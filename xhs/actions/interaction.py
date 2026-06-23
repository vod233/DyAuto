import time
import re
import logging
from .base_action import BaseAction
from .locators import XHSLocators as L

logger = logging.getLogger(__name__)


class GetXHSNoteTitleAction(BaseAction):
    """提取小红书图文或视频详情页标题。"""

    _EXCLUDED_TEXTS = {
        "关注", "收藏", "评论", "分享", "搜索", "发送", "发布", "首页", "我知道了"
    }

    def _clean_text(self, text):
        if not text:
            return ""
        return re.sub(r"\s+", " ", str(text)).strip()

    def _is_title_candidate(self, text):
        if not text or len(text) < 6:
            return False
        if text in self._EXCLUDED_TEXTS:
            return False
        if re.search(r"(关注|评论|收藏|发送|分享|搜索)", text):
            return False
        return True

    def _score_node(self, node, text):
        width, height = self.d.window_size()
        bounds = node.info.get("bounds", {})
        left = bounds.get("left", 0)
        right = bounds.get("right", 0)
        top = bounds.get("top", 0)
        bottom = bounds.get("bottom", 0)
        center_x = int((left + right) / 2)
        center_y = int((top + bottom) / 2)

        score = 0
        if int(height * 0.12) <= center_y <= int(height * 0.62):
            score += 5
        if int(width * 0.1) <= center_x <= int(width * 0.9):
            score += 2
        if 8 <= len(text) <= 40:
            score += 3
        score += min(len(text), 30) / 10
        return score

    def execute(self):
        candidates = []

        try:
            title_node = self.d(resourceId=L.NOTE_TITLE_ID)
            if title_node.exists(timeout=1):
                title_text = self._clean_text(title_node.get_text())
                if self._is_title_candidate(title_text):
                    logger.info(f"通过 resource-id 提取到标题: {title_text}")
                    return title_text
        except Exception:
            logger.debug("通过 resource-id 提取标题失败，继续尝试 XPath 兜底。")

        try:
            for node in self.d.xpath(L.NOTE_TITLE_XPATH).all():
                text = self._clean_text(getattr(node, "text", ""))
                if not self._is_title_candidate(text):
                    continue
                candidates.append((self._score_node(node, text), text))
        except Exception as exc:
            logger.warning(f"通过 XPath 提取标题失败: {exc}")

        if not candidates:
            logger.warning("未在详情页识别到标题文本。")
            return None

        candidates.sort(key=lambda item: item[0], reverse=True)
        best_title = candidates[0][1]
        logger.info(f"通过 XPath 兜底提取到标题: {best_title}")
        return best_title

class GetXHSNoteLinkAction(BaseAction):
    """提取小红书当前图文或视频的链接"""
    def _collect_visible_texts(self, limit=12):
        texts = []
        try:
            for node in self.d.xpath('//*[@text]').all():
                text = str(getattr(node, "text", "") or "").strip()
                if not text or text in texts:
                    continue
                texts.append(text)
                if len(texts) >= limit:
                    break
        except Exception as exc:
            logger.warning(f"读取当前页面可见文本失败: {exc}")
        return texts

    def _dismiss_share_panel(self):
        try:
            # 盲点上半屏安全收起分享面板，防止 press("back") 误退详情页
            w, h = self.d.window_size()
            self.d.click(int(w * 0.5), int(h * 0.2))
            logger.info("已尝试收起分享面板")
            time.sleep(1)
        except Exception as exc:
            logger.warning(f"收起分享面板失败: {exc}")

    def _click_copy_link_button(self):
        for label in L.XHS_COPY_LINK_CANDIDATES:
            try:
                btn = self.d(text=label)
                if btn.exists(timeout=1):
                    btn.click()
                    logger.info(f"通过文本按钮点击成功: {label}")
                    return True
            except Exception as exc:
                logger.warning(f"点击复制按钮[{label}]失败: {exc}")

        try:
            copy_nodes = self.d.xpath(L.XHS_COPY_LINK_XPATH).all()
            for index, node in enumerate(copy_nodes, start=1):
                try:
                    node.click()
                    logger.info(f"通过 XPath 候选点击复制按钮成功，第 {index} 个候选")
                    return True
                except Exception as exc:
                    logger.warning(f"点击第 {index} 个复制按钮候选失败: {exc}")
        except Exception as exc:
            logger.warning(f"通过 XPath 搜索复制按钮失败: {exc}")

        return False

    def execute(self):
        try:
            logger.info("正在定位小红书分享按钮...")
            # 1. 点击右上角分享/转发按钮
            if self.d.xpath(L.XHS_SHARE_BTN_DESC).click_exists(timeout=3):
                logger.info("成功点击分享按钮")
            else:
                logger.warning("未找到分享按钮，尝试右上角盲点兜底")
                sw, sh = self.d.window_size()
                self.d.click(sw - 80, 100) # 右上角
            
            time.sleep(2)
            
            # 2. 点击复制链接
            copied = False
            for attempt in range(3):
                if self._click_copy_link_button():
                    copied = True
                    logger.info("点击复制链接成功")
                    time.sleep(1.5)
                    break
                logger.warning(f"第 {attempt + 1} 次未找到复制链接按钮，继续等待分享面板稳定")
                time.sleep(1)

            if not copied:
                visible_texts = self._collect_visible_texts()
                logger.error(f"未找到复制链接按钮，当前可见文本: {visible_texts}")
                self._dismiss_share_panel()
                return None
            
            # 3. 提取剪贴板内容
            raw_text = self.d.clipboard
            # 小红书分享链接格式通常是 http://xhslink.com/a/xxxx 或者 http://xhslink.com/xxxx
            # 原有的 [\w]+ 匹配不到斜杠 '/'，会导致所有的链接都被截断为 http://xhslink.com/a 从而被判定为同一个！
            url_match = re.search(r'http[s]?://xhslink\.com/[a-zA-Z0-9/]+', raw_text)
            
            share_token = None
            description = raw_text
            url = ""
            if url_match:
                url = url_match.group(0).rstrip('/')
                # 使用 URL 的最后一段作为唯一标识
                share_token = url.split('/')[-1]
            else:
                # 如果没有匹配到链接，为了防重，可以使用全文本的哈希值作为标识
                share_token = str(hash(raw_text))
                
            return url, share_token, description
        except Exception as e:
            logger.error(f"获取小红书链接出错: {e}")
            self._dismiss_share_panel()
            return None

class XHSFollowAuthorAction(BaseAction):
    """小红书详情页点击关注"""
    def execute(self):
        follow_btn = self.d(text=L.XHS_FOLLOW_BTN_TEXT)
        if follow_btn.exists(timeout=2):
            follow_btn.click()
            logger.info("成功点击关注")
            time.sleep(1)
            return True
        else:
            logger.info("检测到已关注内容：未找到'关注'按钮")
            # TODO: 暂时注释掉因找不到关注按钮而提前触发的回退逻辑
            # w, h = self.d.window_size()
            # swipe_y = int(h * 0.78)
            # self.d.swipe(int(w * 0.08), swipe_y, int(w * 0.78), swipe_y, duration=0.2)
            # time.sleep(2)
            return False

class XHSLikeAction(BaseAction):
    """小红书详情页点击点赞"""
    def _get_node_center(self, node):
        bounds = node.info.get('bounds', {})
        left = bounds.get('left', 0)
        right = bounds.get('right', 0)
        top = bounds.get('top', 0)
        bottom = bounds.get('bottom', 0)
        return int((left + right) / 2), int((top + bottom) / 2)

    def _pick_best_bottom_node(self, nodes):
        width, height = self.d.window_size()
        candidates = []
        for node in nodes:
            try:
                center_x, center_y = self._get_node_center(node)
            except Exception:
                continue
            if center_y < int(height * 0.55):
                continue
            if center_x < int(width * 0.05) or center_x > int(width * 0.95):
                continue
            candidates.append((center_y, center_x, node))

        if not candidates:
            return None

        candidates.sort(key=lambda item: (item[0], -item[1]), reverse=True)
        return candidates[0][2]

    def _try_click_like_by_collect_anchor(self):
        width, height = self.d.window_size()
        collect_node = self._pick_best_bottom_node(self.d.xpath(L.XHS_COLLECT_BTN_DESC).all())

        if not collect_node:
            return False

        like_x = int(width * 0.51)
        like_y = int(height * 0.95)
        self.d.click(like_x, like_y)
        logger.info("未直接定位到点赞按钮，已点击页面底部偏上的固定兜底点赞位置")
        return True

    def execute(self):
        clicked = self._try_click_like_by_collect_anchor()

        if not clicked:
            logger.info("未找到'收藏'按钮，点赞固定兜底逻辑无法执行")
        time.sleep(1)
        return clicked

class XHSCollectAction(BaseAction):
    """小红书详情页点击收藏"""
    def execute(self):
        if self.d.xpath(L.XHS_COLLECT_BTN_DESC).click_exists(timeout=2):
            logger.info("成功点击收藏")
        else:
            logger.info("未找到'收藏'按钮，可能已收藏或定位失效")
        time.sleep(1)
        return True

class XHSCommentAction(BaseAction):
    """小红书评论"""
    def _focus_comment_input_safely(self, input_box):
        """点击输入框左侧安全区域，避免误触右侧图片/附件按钮。"""
        try:
            bounds = input_box.info.get("bounds", {})
            left = int(bounds.get("left", 0))
            right = int(bounds.get("right", 0))
            top = int(bounds.get("top", 0))
            bottom = int(bounds.get("bottom", 0))
            if right > left and bottom > top:
                width = right - left
                click_x = left + max(24, int(width * 0.18))
                click_y = int((top + bottom) / 2)
                self.d.click(click_x, click_y)
                logger.info(f"已点击评论输入框左侧安全区域: ({click_x}, {click_y})")
                return True
        except Exception as exc:
            logger.warning(f"安全聚焦评论输入框失败: {exc}")

        return False

    def execute(self, comment_text):
        if not comment_text:
            return False
            
        logger.info("尝试点击评论按钮...")
        if self.d.xpath(L.XHS_COMMENT_BTN_DESC).click_exists(timeout=2):
            time.sleep(1.5)
            # 找到输入框并输入
            input_box = self.d(className=L.XHS_COMMENT_INPUT_CLASS)
            if input_box.exists(timeout=2):
                typed = False
                try:
                    input_box.set_text(comment_text)
                    typed = True
                    logger.info("已直接向评论输入框写入内容")
                except Exception as exc:
                    logger.warning(f"直接写入评论输入框失败，尝试安全聚焦后重试: {exc}")

                if not typed:
                    if self._focus_comment_input_safely(input_box):
                        time.sleep(0.5)
                    input_box.set_text(comment_text)
                    logger.info("已在安全聚焦后向评论输入框写入内容")
                time.sleep(1)
                
                # 点击发送
                send_btn = self.d(text=L.XHS_COMMENT_SEND_BTN_TEXT)
                if send_btn.exists(timeout=2):
                    send_btn.click()
                    logger.info(f"发送评论成功: {comment_text}")
                    time.sleep(2)
                else:
                    self.d.press("enter")
                    logger.info("使用回车键发送评论")
                    time.sleep(2)
            else:
                logger.warning("未找到评论输入框")
                
            # 收起评论面板/键盘，避免使用 press("back") 导致误退详情页
            # 盲点屏幕上半部分可以安全收起面板而不会触发页面回退
            w, h = self.d.window_size()
            self.d.click(int(w * 0.5), int(h * 0.2))
            time.sleep(1)
        else:
            logger.warning("未找到评论按钮")
        return True
