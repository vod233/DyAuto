import time
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L

logger = logging.getLogger(__name__)

class EnsureHomeAction(BaseAction):
    """确保抖音已打开并处于可以搜索的状态 (包含处理青少年模式弹窗)"""
    _VIDEO_CONTEXT_MENU_MARKERS = ("不感兴趣", "倍速", "清屏播放", "识别图片", "添加至稍后再看")
    _CLOSABLE_OVERLAY_MARKERS = ("关闭", "分享名片", "发私信", "设置备注", "特别关注", "取消关注")

    def _dismiss_video_context_menu_if_present(self):
        if any(self.d(text=marker).exists(timeout=0.4) for marker in self._VIDEO_CONTEXT_MENU_MARKERS):
            logger.warning("检测到抖音视频长按菜单，执行返回关闭")
            try:
                width, height = self.d.window_size()
                self.human_click(int(width * 0.5), int(height * 0.12), jitter_range=4)
                self.human_sleep('fast')
            except Exception:
                pass
            if any(self.d(text=marker).exists(timeout=0.2) for marker in self._VIDEO_CONTEXT_MENU_MARKERS):
                self.d.press("back")
            self.human_sleep('fast')
            return True
        return False

    def execute(self):
        for i in range(10):
            if self._dismiss_video_context_menu_if_present():
                continue

            if any(self.d(text=marker).exists(timeout=0.2) for marker in self._CLOSABLE_OVERLAY_MARKERS):
                logger.warning("检测到可关闭浮层，执行返回关闭")
                self.d.press("back")
                self.human_sleep('fast')
                continue

            if self.d(text=L.HOME_TAB_TEXT).exists(timeout=0.5) or self.d.xpath(L.SEARCH_BTN_DESC).exists:
                logger.info("✅ 抖音首页加载成功")
                self.human_sleep('normal')
                return True
            
            if self.d(text=L.YOUTH_MODE_CLOSE_TEXT).exists(timeout=0.5):
                self.d(text=L.YOUTH_MODE_CLOSE_TEXT).click()
                logger.info("已跳过青少年模式弹窗")
                
            logger.info(f"等待首页加载中... ({i+1}/10)")
            self.human_sleep('normal')
        return False

class EnterSearchAction(BaseAction):
    """进入搜索框并输入关键词，随后切换到视频页签"""
    def execute(self, keyword):
        logger.info(f"正在搜索关键词: {keyword}")
        
        # 1. 多级兜底点击搜索按钮
        try:
            if self.d.xpath(L.SEARCH_BTN_DESC).click_exists(timeout=5):
                logger.info("通过 XPath 成功点击搜索按钮")
                self.human_sleep('normal')
            else:
                search_btn_id = self.d(resourceId=L.SEARCH_BTN_ID)
                if search_btn_id.exists(timeout=3):
                    search_btn_id.click()
                    logger.info("通过 ID 兜底点击成功")
                    self.human_sleep('normal')
                else:
                    search_desc = self.d(description=L.SEARCH_BTN_DESC_FALLBACK)
                    if search_desc.exists(timeout=2):
                        search_desc.click()
                        logger.info("通过 Description 兜底点击成功")
                        self.human_sleep('normal')
                    else:
                        logger.warning("所有点击方式均告失败，尝试坐标点击兜底")
                        sw, sh = self.d.window_size()
                        self.human_click(sw - 80, 80)
                        self.human_sleep('normal')
        except Exception as e:
            logger.error(f"点击搜索按钮异常: {e}")
            sw, sh = self.d.window_size()
            self.human_click(sw - 80, 80)
            self.human_sleep('normal')

        # 2. 输入搜索内容
        self.d.set_fastinput_ime(True)
        try:
            self.d.clear_text()
        except Exception as e:
            logger.warning(f"clear_text() 发生异常 ({e})，尝试发送删除按键兜底")
            for _ in range(20):
                self.d.press("del")
        
        self.d.send_keys(keyword)
        self.d.set_fastinput_ime(False)
        self.human_sleep('fast')
        
        confirm_btn = self.d.xpath(L.SEARCH_CONFIRM_BTN)
        if confirm_btn.wait(timeout=5):
            confirm_btn.click()
            self.human_sleep('page_load')
        else:
            self.d.send_action("search")
            self.human_sleep('page_load')

        # 3. 切换到视频页签
        video_tab = self.d.xpath(L.VIDEO_TAB)
        if video_tab.wait(timeout=5):
            video_tab.click()
            logger.info("成功切换到'视频'页签")
            self.human_sleep('normal')
            return True
        else:
            logger.warning("未找到'视频'页签按钮")
            return False

class ApplyFiltersAction(BaseAction):
    """打开并应用搜索结果的筛选条件"""
    def execute(self, sort_mode="latest"):
        sort_text = "最多点赞" if sort_mode == "most_liked" else "最新发布"
        logger.info(f">>> 自动化配对成功：模式[{sort_mode}] -> 点击按钮[{sort_text}] <<<")
        
        filter_btn = self.d.xpath(L.FILTER_PANEL_BTN)
        if filter_btn.wait(timeout=4):
            bounds = filter_btn.info['bounds']
            cx = (bounds['left'] + bounds['right']) / 2
            cy = (bounds['top'] + bounds['bottom']) / 2
            self.human_click(int(cx), int(cy))
            self.human_sleep('normal')
            
            target_sort = self.d.xpath(f'//*[@text="{sort_text}"]')
            if target_sort.wait(timeout=3):
                target_sort.click()
                logger.info(f"已成功选择排序方式: {sort_text}")
                self.human_sleep('fast')
            
            unseen_btn = self.d.xpath(L.FILTER_UNSEEN_BTN)
            if unseen_btn.wait(timeout=3):
                unseen_btn.click()
                logger.info("已点击选择: 还未看过")
                self.human_sleep('fast')
            
            # 强制收起面板机制
            self.human_sleep('normal')
            self.human_click(int(cx), int(cy))
            self.human_sleep('normal')
            
            video_tab = self.d.xpath(L.VIDEO_TAB)
            if video_tab.wait(timeout=2):
                video_tab.click()
                logger.info("已点击'视频'页签辅助收起面板")
            
            # 确定性等待面板消失
            start_wait = time.time()
            while time.time() - start_wait < 5:
                if not self.d.xpath(L.FILTER_SORT_PANEL_INDICATOR).exists:
                    break
                self.human_sleep('fast')
            
            self.human_sleep('normal')
            logger.info(f"--- 工作流切换完全执行：{sort_text} ---")
            return True
        else:
            logger.warning("未找到筛选按钮，无法设置排序工作流")
            return False

class EnterFirstVideoAction(BaseAction):
    """进入第一个全屏视频"""
    def execute(self):
        logger.info("正在定位第一个视频...")
        start_wait = time.time()
        while time.time() - start_wait < 8:
            nodes = self.d.xpath(L.VIDEO_DESC_TEXT_VIEW).all()
            for node in nodes:
                text = node.text
                if text and (len(text) > 10 or "#" in text):
                    logger.info(f"识别到视频文案: {text[:20]}...")
                    node.click()
                    self.human_sleep('normal')
                    return True
            self.human_sleep('fast')
                
        logger.warning("未找到特征文案，尝试点击默认视频位置")
        w, h = self.d.window_size()
        self.human_click(int(w * 0.3), int(h * 0.4), jitter_range=15)
        self.human_sleep('normal')
        return len(self.d.xpath(L.SHARE_BTN_DYNAMIC).all()) > 0 or len(self.d.xpath(L.COMMENT_BTN_DYNAMIC).all()) > 0

class SwipeNextVideoAction(BaseAction):
    """全屏模式下向下滑动到下一个视频（贝塞尔曲线人性化滑动）"""
    def execute(self):
        width, height = self.d.window_size()
        # 使用贝塞尔曲线滑动，起止点带随机偏移
        sx = width // 2 + __import__('random').randint(-20, 20)
        sy = int(height * 0.8) + __import__('random').randint(-10, 10)
        ex = width // 2 + __import__('random').randint(-20, 20)
        ey = int(height * 0.2) + __import__('random').randint(-10, 10)
        self.human_swipe_curve(sx, sy, ex, ey)
        self.human_sleep('fast')
        return True

class ResetToSearchAction(BaseAction):
    """返回 5 次以重置到首页状态"""
    def execute(self):
        logger.info("执行 5 次返回以重置到首页状态...")
        for i in range(5):
            self.d.press("back")
            self.human_sleep('fast', custom_range=(0.8, 1.8))
        return True
