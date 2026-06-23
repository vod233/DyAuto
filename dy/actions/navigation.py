import time
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L

logger = logging.getLogger(__name__)

class EnsureHomeAction(BaseAction):
    """确保抖音已打开并处于可以搜索的状态 (包含处理青少年模式弹窗)"""
    def execute(self):
        for i in range(10):
            if self.d(text=L.HOME_TAB_TEXT).exists or self.d.xpath(L.SEARCH_BTN_DESC).exists:
                logger.info("✅ 抖音首页加载成功")
                time.sleep(3)
                return True
            
            if self.d(text=L.YOUTH_MODE_CLOSE_TEXT).exists:
                self.d(text=L.YOUTH_MODE_CLOSE_TEXT).click()
                logger.info("已跳过青少年模式弹窗")
                
            logger.info(f"等待首页加载中... ({i+1}/10)")
            time.sleep(2)
        return False

class EnterSearchAction(BaseAction):
    """进入搜索框并输入关键词，随后切换到视频页签"""
    def execute(self, keyword):
        logger.info(f"正在搜索关键词: {keyword}")
        
        # 1. 多级兜底点击搜索按钮
        try:
            if self.d.xpath(L.SEARCH_BTN_DESC).click_exists(timeout=5):
                logger.info("通过 XPath 成功点击搜索按钮")
                time.sleep(2)
            else:
                search_btn_id = self.d(resourceId=L.SEARCH_BTN_ID)
                if search_btn_id.exists(timeout=3):
                    search_btn_id.click()
                    logger.info("通过 ID 兜底点击成功")
                    time.sleep(2)
                else:
                    search_desc = self.d(description=L.SEARCH_BTN_DESC_FALLBACK)
                    if search_desc.exists(timeout=2):
                        search_desc.click()
                        logger.info("通过 Description 兜底点击成功")
                        time.sleep(2)
                    else:
                        logger.warning("所有点击方式均告失败，尝试坐标点击兜底")
                        sw, sh = self.d.window_size()
                        self.d.click(sw - 80, 80)
                        time.sleep(2)
        except Exception as e:
            logger.error(f"点击搜索按钮异常: {e}")
            sw, sh = self.d.window_size()
            self.d.click(sw - 80, 80)
            time.sleep(2)

        # 2. 输入搜索内容
        self.d.set_fastinput_ime(True)
        try:
            self.d.clear_text()
        except Exception as e:
            logger.warning(f"clear_text() 发生异常 ({e})，尝试发送删除按键兜底")
            for _ in range(20):  # 模拟多次按下退格键
                self.d.press("del")
        
        self.d.send_keys(keyword)
        self.d.set_fastinput_ime(False)
        time.sleep(1)
        
        confirm_btn = self.d.xpath(L.SEARCH_CONFIRM_BTN)
        if confirm_btn.wait(timeout=5):
            confirm_btn.click()
            time.sleep(5)
        else:
            self.d.send_action("search")
            time.sleep(5)

        # 3. 切换到视频页签
        video_tab = self.d.xpath(L.VIDEO_TAB)
        if video_tab.wait(timeout=5):
            video_tab.click()
            logger.info("成功切换到'视频'页签")
            time.sleep(2)
        else:
            logger.warning("未找到'视频'页签按钮")
        return True

class ApplyFiltersAction(BaseAction):
    """打开并应用搜索结果的筛选条件"""
    def execute(self, sort_mode="latest"):
        sort_text = "最多点赞" if sort_mode == "most_liked" else "最新发布"
        logger.info(f">>> 自动化配对成功：模式[{sort_mode}] -> 点击按钮[{sort_text}] <<<")
        
        filter_btn = self.d.xpath(L.FILTER_PANEL_BTN)
        if filter_btn.exists:
            bounds = filter_btn.info['bounds']
            cx = (bounds['left'] + bounds['right']) / 2
            cy = (bounds['top'] + bounds['bottom']) / 2
            self.d.click(cx, cy)
            time.sleep(1.5)
            
            target_sort = self.d.xpath(f'//*[@text="{sort_text}"]')
            if target_sort.wait(timeout=3):
                target_sort.click()
                logger.info(f"已成功选择排序方式: {sort_text}")
                time.sleep(0.5)
            
            unseen_btn = self.d.xpath(L.FILTER_UNSEEN_BTN)
            if unseen_btn.wait(timeout=3):
                unseen_btn.click()
                logger.info("已点击选择: 还未看过")
                time.sleep(0.5)
            
            # 强制收起面板机制
            time.sleep(1.5)
            self.d.click(cx, cy)
            time.sleep(1.0)
            
            video_tab = self.d.xpath(L.VIDEO_TAB)
            if video_tab.exists:
                video_tab.click()
                logger.info("已点击'视频'页签辅助收起面板")
            
            # 确定性等待面板消失
            start_wait = time.time()
            while time.time() - start_wait < 5:
                if not self.d.xpath(L.FILTER_SORT_PANEL_INDICATOR).exists:
                    break
                time.sleep(0.5)
            
            time.sleep(1.5)
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
                    self.d.xpath(f'//android.widget.TextView[@text="{text}"]').click()
                    return True
            time.sleep(1)
                
        logger.warning("未找到特征文案，尝试点击默认视频位置")
        self.d.click(0.3, 0.4)
        return True

class SwipeNextVideoAction(BaseAction):
    """全屏模式下向下滑动到下一个视频"""
    def execute(self):
        width, height = self.d.window_size()
        self.d.swipe(width // 2, int(height * 0.8), width // 2, int(height * 0.2), duration=0.2)
        time.sleep(1)
        return True

class ResetToSearchAction(BaseAction):
    """返回 5 次以重置到首页状态"""
    def execute(self):
        logger.info("执行 5 次返回以重置到首页状态...")
        for i in range(5):
            self.d.press("back")
            time.sleep(1.2)
        return True