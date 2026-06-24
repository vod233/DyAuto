import time
import re
import random
import logging

from .main_controller import ScoutTaskRunner
from .actions.navigation import (
    EnterSearchAction, ApplyFiltersAction,
    EnterFirstVideoAction, SwipeNextVideoAction, ResetToSearchAction
)
from .actions.interaction import (
    DoubleClickLikeAction, FollowAuthorAction, GetCurrentVideoLinkAction
)
from .actions.commenting import (
    PostCommentAction, OpenCommentSectionAction, ProcessCommentSectionAction
)
from .ai_reply_agent import DYReplyAgent
from .db_manager import DBManager

logger = logging.getLogger(__name__)

class TikTokTaskFlow:
    """
    具体的业务任务流
    将原子动作串联起来，形成如"搜索 -> 筛选 -> 刷视频 -> 互动"的完整逻辑
    """
    def __init__(self, serial=None, config_path=None):
        self.runner = ScoutTaskRunner(serial=serial, config_path=config_path)
        self.config = self.runner.config
        self.db = DBManager()
        self.reply_agent = DYReplyAgent(self.config)
        
        # 状态记录，用于防重防卡死
        self.last_share_token = None
        self.last_description = None
        self.current_keyword = None
        
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
        logger.info(f"📊 今日已处理视频: {stats['videos']} 个 | 点赞: {stats['likes']} 次 | 评论: {stats['comments']} 次 | 关注: {stats['follows']} 人")
        
        # 检查每日全局上限
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
        
        # 1. 搜索
        self._check_stop()
        if not self.runner.run_action(EnterSearchAction, keyword):
            logger.warning(f"关键词 '{keyword}' 搜索失败，跳过当前关键词")
            self.runner.run_action(ResetToSearchAction)
            return
        
        # 2. 筛选
        self._check_stop()
        sort_mode = self.config.get('search', {}).get('sort_by', 'latest')
        if not self.runner.run_action(ApplyFiltersAction, sort_mode=sort_mode):
            logger.warning("筛选未成功应用，继续使用当前搜索结果")
        
        # 3. 进入第一个视频
        self._check_stop()
        success = self.runner.run_action(EnterFirstVideoAction)
        if not success:
            logger.warning(f"未能进入关键词 '{keyword}' 的视频流，跳过")
            self.runner.run_action(ResetToSearchAction)
            return
            
        self._interruptible_sleep(3)
        
        # 4. 开始循环刷视频
        self._video_loop()
        
        # 5. 当前关键词处理完毕，退回到搜索页，准备下一个
        self.runner.run_action(ResetToSearchAction)

    def _video_loop(self):
        """核心的边刷边互动循环"""
        video_count = 0
        max_videos = self.config.get('crawler', {}).get('max_videos_per_keyword', 10) # 默认刷10个测试
        max_daily_videos = self.config.get('crawler', {}).get('max_daily_videos', 100)
        
        while video_count < max_videos:
            self._check_stop()
            
            # 每次刷视频前检查一次全局今日上限
            stats = self.db.get_daily_stats()
            if stats['videos'] >= max_daily_videos:
                logger.info(f"🛑 今日处理视频总数({stats['videos']})已达到最高上限({max_daily_videos})，即将退出循环！")
                self.stop() # 触发自动结束
                break
                
            video_count += 1
            logger.info(f"\n--- 正在处理第 {video_count}/{max_videos} 个视频 ---")
            
            # A. 提取信息与防重卡死检测
            self._check_stop()
            link_info = self.runner.run_action(GetCurrentVideoLinkAction)
            if link_info:
                url, share_token, description = link_info
                
                # 防重判断：如果连续刷到相同的视频（或已经滑到底了）
                is_duplicate = False
                if share_token and self.last_share_token and share_token == self.last_share_token:
                    logger.warning(f"检测到视频重复 (token一致)，可能已滑到底部")
                    is_duplicate = True
                elif description and self.last_description and description == self.last_description:
                    logger.warning(f"检测到视频重复 (文案一致)，可能已滑到底部")
                    is_duplicate = True
                    
                if is_duplicate:
                    logger.info("结束当前关键词的视频循环")
                    break
                    
                self.last_share_token = share_token
                self.last_description = description
                
                # B. 执行视频级互动
                video_id = share_token if share_token else str(hash(description))
                
                # 提取视频标题用于AI生成评论
                video_title = self._extract_title_from_description(description)
                
                # B.0 记录视频入库，如果已处理过则跳过
                is_new = self.db.record_video(video_id, self.current_keyword, url, note_title=video_title)
                if not is_new:
                    logger.info("⏭️ 视频今日已处理过，跳过互动环节")
                else:
                    logger.info("🎬 开始对新视频执行互动...")
                    logger.info(f"📝 当前视频标题: {video_title}")
                    
                    # B.1 点赞
                    self._check_stop()
                    if self.runner.run_action(DoubleClickLikeAction):
                        self.db.update_interaction(video_id, "like")
                    self._interruptible_sleep(1)
                    
                    # B.2 关注
                    self._check_stop()
                    follow_result = self.runner.run_action(FollowAuthorAction)
                    if isinstance(follow_result, dict):
                        if follow_result.get("followed"):
                            self.db.update_interaction(video_id, "follow")
                        if follow_result.get("private_message_sent"):
                            self.db.update_interaction(video_id, "private_message")
                    elif follow_result:
                        self.db.update_interaction(video_id, "follow")
                    self._interruptible_sleep(1.5)
                    
                    # B.3 发送视频评论（标题驱动 AI 生成）
                    self._check_stop()
                    comment_text = self.reply_agent.generate_reply(
                        title=video_title,
                        keyword=self.current_keyword or ""
                    ) or ""

                    if comment_text:
                        if self.reply_agent.is_enabled():
                            logger.info(f"🤖 AI 生成回复: {comment_text}")
                        self.db.save_ai_reply(
                            video_id,
                            note_title=video_title,
                            ai_reply=comment_text,
                        )
                        if self.runner.run_action(PostCommentAction, comment_text):
                            self.db.update_interaction(video_id, "comment")
                    else:
                        self.db.save_ai_reply(
                            video_id,
                            note_title=video_title,
                            ai_reply="",
                        )
                        logger.info("未生成可发布的回复，跳过评论环节。")
                    
                    # B.4 处理评论区（找潜在客户）
                    self._check_stop()
                    if self.runner.run_action(OpenCommentSectionAction):
                        self._check_stop()
                        self.runner.run_action(
                            ProcessCommentSectionAction,
                            video_title=video_title,
                            keyword=self.current_keyword or "",
                            check_stop_callback=self._check_stop
                        )
                    
            else:
                logger.warning("无法提取当前视频信息，跳过互动环节")
            
            # 打印实时进度
            stats = self.db.get_daily_stats()
            logger.info(f"📊 实时数据 -> 视频:{stats['videos']} | 赞:{stats['likes']} | 评:{stats['comments']} | 关:{stats['follows']}")
            
            # C. 划到下一个视频
            self._check_stop()
            self.runner.run_action(SwipeNextVideoAction)
            
            # 随机停留
            min_stay = self.config.get('crawler', {}).get('min_video_stay', 3)
            max_stay = self.config.get('crawler', {}).get('max_video_stay', 6)
            stay_time = random.uniform(min_stay, max_stay)
            logger.info(f"等待 {stay_time:.1f} 秒后处理下一个视频...")
            self._interruptible_sleep(stay_time)

    def _extract_title_from_description(self, description):
        """从视频描述中提取标题"""
        if not description:
            return self.current_keyword or "当前视频"
        
        lines = []
        for raw_line in str(description).splitlines():
            line = raw_line.strip()
            if not line:
                continue
            line = re.sub(r"http[s]?://\S+", "", line).strip()
            if 6 <= len(line) <= 60:
                lines.append(line)
        
        return lines[0] if lines else (self.current_keyword or "当前视频")
