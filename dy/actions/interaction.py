import time
import re
import hashlib
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
    _EXCLUDED_TEXTS = {
        "首页", "朋友", "消息", "我", "搜索", "分享", "评论", "关注",
        "复制链接", "分享链接", "不感兴趣", "举报", "保存本地"
    }

    def execute(self):
        visible_description = self._extract_visible_description()
        panel_opened = False
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
                return self._fallback_video_info(visible_description, "分享面板未打开")
            panel_opened = True
            
            # 4. 滑动并复制链接
            bounds = container.info['bounds']
            center_y = (bounds['top'] + bounds['bottom']) / 2
            self.d.swipe(bounds['right'] * 0.8, center_y, bounds['right'] * 0.2, center_y, duration=0.2)
            time.sleep(1)
            
            copy_btn = self.d.xpath(L.COPY_LINK_BTN)
            if copy_btn.wait(timeout=5):
                copy_btn.click()
                time.sleep(1.5)
                
                raw_text = self._read_clipboard()
                parsed = self._parse_share_text(raw_text, visible_description)
                if parsed:
                    return parsed

                return self._fallback_video_info(visible_description, "剪贴板无可解析链接")

            logger.error("未找到复制链接按钮")
            return self._fallback_video_info(visible_description, "未找到复制链接按钮")
        except Exception as e:
            logger.error(f"提取链接出错: {e}")
            return self._fallback_video_info(visible_description, "提取链接异常")
        finally:
            if panel_opened:
                self._close_share_panel()

    def _close_share_panel(self):
        try:
            panel_id = self.config.get('ui_ids', {}).get('share_panel', L.SHARE_PANEL_CONTAINER)
            w, h = self.d.window_size()
            if self.d(resourceId=panel_id).exists or self.d.xpath(L.COPY_LINK_BTN).exists:
                self.d.click(int(w * 0.5), int(h * 0.2))
                time.sleep(0.8)
            if self.d(resourceId=panel_id).exists or self.d.xpath(L.COPY_LINK_BTN).exists:
                self.d.press("back")
                time.sleep(1)
            logger.info("已尝试关闭分享面板")
        except Exception as exc:
            logger.warning(f"关闭分享面板失败: {exc}")

    def _read_clipboard(self):
        try:
            return self.d.clipboard or ""
        except Exception as exc:
            logger.warning(f"读取剪贴板失败，改用页面文案兜底: {exc}")
            return ""

    def _parse_share_text(self, raw_text, visible_description):
        if not raw_text:
            return None

        url_match = re.search(r'https://v\.douyin\.com/[\w-]+/', raw_text)
        if not url_match:
            return None

        url = url_match.group(0)
        full_desc = raw_text[:url_match.start()].strip()
        description = re.sub(r'^[\d.\s]+', '', full_desc) or visible_description

        token_match = re.search(r'(\d{2}/\d{2}\s+[a-zA-Z0-9]{3,}:/\s+[\w@.]+)', raw_text)
        if token_match:
            share_token = token_match.group(1)
        else:
            after_url = raw_text[url_match.end():].strip()
            share_token = after_url or self._stable_token(description or url)

        logger.info(f"成功解析抖音分享链接: {url}")
        return url, share_token, description

    def _fallback_video_info(self, visible_description, reason):
        if not visible_description:
            logger.error(f"{reason}，且当前页面无可用文案，无法生成视频标识")
            return None

        share_token = self._stable_token(visible_description)
        logger.warning(f"{reason}，使用当前页面文案生成兜底视频标识: {share_token}")
        return "", share_token, visible_description

    def _stable_token(self, text):
        digest = hashlib.sha1(str(text).encode("utf-8", errors="ignore")).hexdigest()
        return f"dy_visible_{digest[:16]}"

    def _extract_visible_description(self):
        candidates = []
        try:
            width, height = self.d.window_size()
            for node in self.d.xpath(L.VIDEO_DESC_TEXT_VIEW).all():
                text = str(getattr(node, "text", "") or "").strip()
                if not self._is_description_candidate(text):
                    continue

                bounds = node.info.get("bounds", {})
                top = bounds.get("top", 0)
                bottom = bounds.get("bottom", 0)
                left = bounds.get("left", 0)
                right = bounds.get("right", 0)
                center_y = int((top + bottom) / 2)
                center_x = int((left + right) / 2)

                score = 0
                if center_y >= int(height * 0.45):
                    score += 5
                if center_x <= int(width * 0.8):
                    score += 2
                if "#" in text:
                    score += 2
                score += min(len(text), 80) / 20
                candidates.append((score, text))
        except Exception as exc:
            logger.warning(f"读取当前视频文案失败: {exc}")

        if not candidates:
            return ""

        candidates.sort(key=lambda item: item[0], reverse=True)
        description = candidates[0][1]
        logger.info(f"当前视频可见文案兜底: {description[:60]}")
        return description

    def _is_description_candidate(self, text):
        if not text or text in self._EXCLUDED_TEXTS:
            return False
        if len(text) < 6:
            return False
        if re.fullmatch(r"[\d.万wWkK]+", text):
            return False
        if re.search(r"(评论|分享|点赞|收藏|搜索|首页|朋友|消息)$", text):
            return False
        return True
