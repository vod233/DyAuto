import time
import re
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L

logger = logging.getLogger(__name__)

class DoubleClickLikeAction(BaseAction):
    """双击屏幕中心区域点赞"""
    def execute(self):
        w, h = self.d.window_size()
        cx, cy = int(w / 2), int(h / 2)
        self.d.click(cx, cy)
        time.sleep(0.1)
        self.d.click(cx, cy)
        logger.info("已执行双击点赞")
        return True

class FollowAuthorAction(BaseAction):
    """滑动到作者主页并关注，然后返回视频页"""
    def execute(self):
        # 1. 滑动到主页
        w, h = self.d.window_size()
        self.d.swipe(int(w * 0.9), int(h / 2), int(w * 0.1), int(h / 2), duration=0.2)
        time.sleep(3)
        
        # 2. 点击关注
        follow_btn = self.d(text=L.PROFILE_FOLLOW_BTN, clickable=True)
        if follow_btn.exists(timeout=2):
            follow_btn.click()
            logger.info("成功点击关注")
        else:
            logger.info("未找到'关注'按钮，可能已经关注过了")
        time.sleep(1.5)
        
        # 3. 返回视频页
        self._return_to_video_page()
        return True

    def _is_video_page_ready(self):
        comment_nodes = self.d.xpath(L.COMMENT_BTN_DYNAMIC).all()
        share_nodes = self.d.xpath(L.SHARE_BTN_DYNAMIC).all()
        return len(comment_nodes) > 0 and len(share_nodes) > 0

    def _return_to_video_page(self):
        """从作者主页稳定返回视频页"""
        for attempt in range(3):
            if self._is_video_page_ready():
                logger.info("确认已经回到视频页")
                return True
            logger.info(f"尝试返回视频页... ({attempt + 1}/3)")
            self.d.press("back")
            time.sleep(2)
            
        if self._is_video_page_ready():
            logger.info("确认已经回到视频页")
            return True
            
        logger.warning("未能可靠确认已返回视频页，继续尝试后续流程")
        return False

class GetCurrentVideoLinkAction(BaseAction):
    """提取当前视频的链接、share_token 和 文案"""
    def execute(self):
        try:
            share_clicked = False
            logger.info("正在定位分享按钮...")
            
            # 1. 动态 Content-Desc 定位
            if self.d.xpath(L.SHARE_BTN_DYNAMIC).click_exists(timeout=3):
                logger.info("通过动态 Content-Desc 成功点击分享按钮")
                share_clicked = True

            # 2. 兜底：纯数字或"分享"文本定位
            if not share_clicked:
                logger.info("尝试通过屏幕下方 TextView 定位...")
                all_text_nodes = self.d.xpath(L.VIDEO_DESC_TEXT_VIEW).all()
                candidate_nodes = [n for n in all_text_nodes if n.text == "分享" or (n.text and n.text.isdigit())]
                
                if candidate_nodes:
                    candidate_nodes.sort(key=lambda x: x.info['bounds']['bottom'], reverse=True)
                    target_node = candidate_nodes[0]
                    logger.info(f"找到分享按钮标识文字: '{target_node.text}' at bottom")
                    target_node.click()
                    share_clicked = True
                else:
                    logger.warning("未找到符合条件的分享按钮标识文字")

            if not share_clicked:
                logger.error("所有定位方式均未找到分享按钮")
                return None
            
            time.sleep(2)
            
            # 3. 检查分享面板
            panel_id = self.config.get('ui_ids', {}).get('share_panel', L.SHARE_PANEL_CONTAINER)
            container = self.d(resourceId=panel_id)
            if not container.wait(timeout=5):
                logger.error("分享面板未打开")
                return None
            
            # 4. 滑动并复制链接
            bounds = container.info['bounds']
            center_y = (bounds['top'] + bounds['bottom']) / 2
            self.d.swipe(bounds['right'] * 0.8, center_y, bounds['right'] * 0.2, center_y, duration=0.2)
            time.sleep(1)
            
            copy_btn = self.d.xpath(L.COPY_LINK_BTN)
            if copy_btn.wait(timeout=5):
                copy_btn.click()
                time.sleep(1.5)
                
                raw_text = self.d.clipboard
                url_match = re.search(r'https://v\.douyin\.com/[\w-]+/', raw_text)
                
                share_token = None
                description = None
                if url_match:
                    url = url_match.group(0)
                    full_desc = raw_text[:url_match.start()].strip()
                    description = re.sub(r'^[\d.\s]+', '', full_desc)
                    
                    token_match = re.search(r'(\d{2}/\d{2}\s+[a-zA-Z0-9]{3,}:/\s+[\w@.]+)', raw_text)
                    if token_match:
                        share_token = token_match.group(1)
                    else:
                        after_url = raw_text[url_match.end():].strip()
                        if after_url:
                            share_token = after_url
                    
                    self._close_share_panel()
                    return url, share_token, description
            
            self._close_share_panel()
            return None
        except Exception as e:
            logger.error(f"提取链接出错: {e}")
            return None

    def _close_share_panel(self):
        self.d.press("back")
        time.sleep(1)