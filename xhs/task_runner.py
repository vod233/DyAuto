import time
import re
import logging

from .main_controller import ScoutTaskRunner
from .actions.navigation import (
    EnterSearchAction, EnterFirstVideoAction, NextXHSNoteAction
)
from .actions.interaction import (
    GetXHSNoteLinkAction, GetXHSNoteTitleAction, XHSFollowAuthorAction,
    XHSLikeAction, XHSCollectAction, XHSCommentAction
)
from .ai_reply_agent import XHSReplyAgent
from .db_manager import DBManager

logger = logging.getLogger(__name__)

class TikTokTaskFlow:
    """
    具体的业务任务流
    将原子动作串联起来，形成如“搜索 -> 筛选 -> 刷视频 -> 互动”的完整逻辑
    """
    def __init__(self, serial=None, config_path=None):
        self.runner = ScoutTaskRunner(serial=serial, config_path=config_path)
        self.config = self.runner.config
        self.db = DBManager()
        self.reply_agent = XHSReplyAgent(self.config)
        
        # 状态记录，用于防重防卡死
        self.last_share_token = None
        self.last_description = None
        self.current_keyword = None
        self.consecutive_duplicate_note_count = 0
        
        # 停止标识
        self.is_stopped = False
        self.is_paused = False

    def stop(self):
        """通知任务流结束执行"""
        self.is_stopped = True
        logger.info("收到结束指令，准备退出任务流...")

    def pause(self):
        """通知任务流暂停"""
        self.is_paused = True
        logger.info("收到暂停指令，任务挂起...")

    def resume(self):
        """通知任务流继续"""
        self.is_paused = False
        logger.info("收到继续指令，任务恢复执行...")

    def _interruptible_sleep(self, seconds):
        """可被暂停和停止打断的休眠"""
        slept = 0
        while slept < seconds:
            self._check_stop()
            time.sleep(0.5)
            slept += 0.5
            
    def _check_stop(self):
        """检查是否收到了结束或暂停指令"""
        # 如果处于暂停状态，就在这里循环等待，直到取消暂停或直接结束
        while self.is_paused:
            if self.is_stopped:
                break
            time.sleep(1)
            
        if self.is_stopped:
            logger.info("检测到结束指令，中断当前执行！")
            raise InterruptedError("用户手动结束了任务")

    def start(self):
        """开始执行完整的采集与互动任务"""
        logger.info("=== 任务流开始 ===")
        
        # 打印当前已有的统计数据
        stats = self.db.get_daily_stats()
        logger.info(f"📊 今日已处理视频: {stats['videos']} 个 | 点赞: {stats['likes']} 次 | AI回复: {stats['comments']} 次 | 关注: {stats['follows']} 人")

        max_daily_videos = self.config.get('crawler', {}).get('max_daily_videos', 100)
        if stats['videos'] >= max_daily_videos:
            logger.info(f"🛑 今日处理视频总数({stats['videos']})已达到设置的最高上限({max_daily_videos})，任务终止！")
            return
            
        self._check_stop()
        # 1. 确保抖音处于可用状态
        self.runner.launch_app()
        
        # 2. 读取关键词列表
        keywords = self.config.get('search', {}).get('keywords', [])
        if not keywords:
            # 兼容旧配置格式
            old_keyword = self.config.get('search', {}).get('keyword')
            if old_keyword:
                keywords = [old_keyword]
                
        if not keywords:
            logger.error("未在配置中找到 search.keywords，任务无法执行")
            return
            
        try:
            for keyword in keywords:
                self._check_stop()
                logger.info(f"\n>>> 开始处理关键词: {keyword} <<<")
                self._process_single_keyword(keyword)
                
            logger.info("所有关键词任务处理完毕！")
        except KeyboardInterrupt:
            logger.warning("用户手动停止了任务")
        except Exception as e:
            logger.error(f"任务流执行异常: {e}")
        finally:
            self.runner.shutdown()

    def _process_single_keyword(self, keyword):
        """处理单个关键词的完整流程"""
        # 重置防重状态
        self.last_share_token = None
        self.last_description = None
        self.current_keyword = keyword
        self.consecutive_duplicate_note_count = 0
        
        # 1. 搜索
        self._check_stop()
        sort_mode = self.runner.config.get("search", {}).get("sort_by", "latest")
        self.runner.run_action(EnterSearchAction, keyword, sort_mode)
        
        # 2. 筛选
        self._check_stop()
        logger.info(f"小红书搜索流：已在搜索步骤中切换至目标页签[{sort_mode}]，跳过抽屉筛选。")
        
        # 3. 进入第一个内容
        self._check_stop()
        success = self.runner.run_action(EnterFirstVideoAction)
        if not success:
            logger.warning(f"未能进入关键词 '{keyword}' 的内容流，跳过")
            return
        self._interruptible_sleep(3)
        
        # 4. 开始循环处理
        self._video_loop()
        
        logger.info(f"结束当前关键词 '{keyword}' 的处理。")

    def _video_loop(self):
        """核心的互动循环"""
        video_count = 0
        max_videos = self.config.get('crawler', {}).get('max_videos_per_keyword', 10)
        max_daily_videos = self.config.get('crawler', {}).get('max_daily_videos', 100)
        
        while True:
            self._check_stop()

            stats = self.db.get_daily_stats()
            if stats['videos'] >= max_daily_videos:
                logger.info(f"🛑 今日处理视频总数({stats['videos']})已达到最高上限({max_daily_videos})，结束当前任务循环。")
                break
            
            video_count += 1
            logger.info(f"\n--- 正在处理第 {video_count} 个内容 ---")
            
            # 统一按图文路由处理，不再区分视频和图文
            self._check_stop()
            logger.info(">>> 进入内容处理 <<<")
            handle_result = self._handle_image_content(video_count, max_videos)
            is_duplicate = handle_result.get("duplicate", False)

            # 打印实时进度
            stats = self.db.get_daily_stats()
            logger.info(f"📊 实时数据 -> 内容:{stats['videos']} | 赞:{stats['likes']} | AI回复:{stats['comments']} | 关:{stats['follows']}")

            if stats['videos'] >= max_daily_videos:
                logger.info(f"🛑 今日处理视频总数({stats['videos']})已达到最高上限({max_daily_videos})，不再继续进入下一个内容。")
                break

            # 寻找下一个内容，包含退回和 Airtest 翻页逻辑
            self._check_stop()
            
            # 如果是重复内容且连续2次，通知 NextXHSNoteAction 强制向下翻页
            force_scroll = False
            if is_duplicate and self.consecutive_duplicate_note_count >= 2:
                force_scroll = True
                logger.warning("内容已连续重复 2 次，准备退出当前页面后强制向下翻页。")
                self.consecutive_duplicate_note_count = 0

            success = self.runner.run_action(NextXHSNoteAction, current_count=video_count, force_scroll=force_scroll)
            if not success:
                logger.info("当前屏幕已无新内容或遇到错误，结束当前关键词的内容循环。")
                break

    def _handle_image_content(self, current_count, max_count):
        """统一处理所有内容，当前全部按图文路由执行。"""
        logger.info("处理内容...")
        return self._handle_xhs_content(content_type_name="图文")

    def _extract_title_from_share_text(self, share_text):
        if not share_text:
            return ""

        lines = []
        for raw_line in str(share_text).splitlines():
            line = raw_line.strip()
            if not line:
                continue
            if "xhslink.com" in line.lower():
                continue
            if "打开小红书" in line or "复制本条信息" in line:
                continue
            line = re.sub(r"http[s]?://\S+", "", line).strip()
            if 6 <= len(line) <= 40:
                lines.append(line)

        return lines[0] if lines else ""

    def _resolve_note_title(self, share_text):
        self._check_stop()
        title = self.runner.run_action(GetXHSNoteTitleAction)
        if title:
            return title

        fallback_title = self._extract_title_from_share_text(share_text)
        if fallback_title:
            logger.info(f"使用分享文案兜底作为标题: {fallback_title}")
            return fallback_title

        fallback_title = self.current_keyword or "当前内容"
        logger.warning(f"未能提取到标题，使用兜底标题: {fallback_title}")
        return fallback_title

    def _handle_xhs_content(self, content_type_name):
        """统一处理小红书内容页，视频和图文共用分享提链与底部互动逻辑。"""
        link_info = self.runner.run_action(GetXHSNoteLinkAction)
        if not link_info:
            logger.warning(f"未能成功提取当前{content_type_name}链接信息，跳过此内容")
            return {"success": True, "duplicate": False}

        url, share_token, description = link_info
        content_id = share_token if share_token else str(hash(description))

        if self.last_share_token and content_id == self.last_share_token:
            self.consecutive_duplicate_note_count += 1
            logger.warning(
                f"检测到{content_type_name}连续重复 (token一致)，当前连续重复 {self.consecutive_duplicate_note_count} 次。"
            )
            return {"success": True, "duplicate": True}

        self.consecutive_duplicate_note_count = 0
        self.last_share_token = content_id
        self.last_description = description
        note_title = self._resolve_note_title(description)

        self.db.record_video(content_id, self.current_keyword, url, note_title=note_title)
        logger.info(f"已将{content_type_name}链接存入数据库供前端展示。")
        logger.info(f"🎬 开始对{content_type_name}执行互动...")
        logger.info(f"📝 当前{content_type_name}标题: {note_title}")

        self._check_stop()
        follow_success = self.runner.run_action(XHSFollowAuthorAction)
        if not follow_success:
            logger.info(f"当前{content_type_name}判定为已关注内容，已直接回退到结果列表页并跳过后续互动。")
            return {"success": True, "duplicate": False}

        self._check_stop()
        self.runner.run_action(XHSLikeAction)

        self._check_stop()
        self.runner.run_action(XHSCollectAction)

        self._check_stop()
        comment_text = self.reply_agent.generate_reply(
            title=note_title,
            keyword=self.current_keyword or ""
        ) or ""
        if comment_text:
            logger.info(f"🤖 AI 生成回复: {comment_text}")
            self.db.save_ai_reply(
                content_id,
                note_title=note_title,
                ai_reply=comment_text,
            )
            if self.runner.run_action(XHSCommentAction, comment_text=comment_text):
                self.db.update_interaction(content_id, "comment")
        else:
            self.db.save_ai_reply(
                content_id,
                note_title=note_title,
                ai_reply="",
            )
            logger.info("未生成可发布的回复，跳过评论环节。")

        self.db.update_interaction(content_id, "like")
        self.db.update_interaction(content_id, "follow")

        return {"success": True, "duplicate": False}

    def _force_scroll_feed_down(self):
        """强制将瀑布流向下翻一页，跳出连续重复的内容区域。"""
        w, h = self.runner.device.window_size()
        self.runner.device.swipe(int(w * 0.5), int(h * 0.90), int(w * 0.5), int(h * 0.16), duration=0.3)
