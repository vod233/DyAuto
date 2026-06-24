import time
import re
import random
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L
from ..ai_reply_agent import DYReplyAgent

logger = logging.getLogger(__name__)


def _bounds_bottom(node):
    return node.info.get("bounds", {}).get("bottom", 0)


def _click_node_center(d, node):
    bounds = node.info.get("bounds", {}) or {}
    if not bounds:
        node.click()
        return
    x = int((bounds.get("left", 0) + bounds.get("right", 0)) / 2)
    y = int((bounds.get("top", 0) + bounds.get("bottom", 0)) / 2)
    d.click(x, y)


def _is_visible_enabled(node):
    info = node.info
    return info.get("visible", True) and info.get("enabled", True)


def _find_bottom_edit_text(d, timeout=3):
    """Find the visible, enabled edit box closest to the bottom of the screen."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        edit_nodes = d.xpath(L.COMMENT_EDIT_TEXT_XPATH).all()
        candidates = [node for node in edit_nodes if _is_visible_enabled(node)]
        if candidates:
            return sorted(candidates, key=_bounds_bottom)[-1]
        time.sleep(0.3)
    return None


def _find_clickable_send_button(d):
    send_nodes = d.xpath(L.COMMENT_SEND_BTN_XPATH).all()
    candidates = [
        node for node in send_nodes
        if node.info.get("clickable", False) and node.info.get("visible", True) and node.info.get("enabled", True)
    ]
    if candidates:
        return sorted(candidates, key=_bounds_bottom)[-1]

    for resource_id in L.COMMENT_SEND_BTN_IDS:
        btn = d(resourceId=resource_id)
        if btn.exists(timeout=0.5):
            info = btn.info
            if info.get("clickable", False) and info.get("visible", True) and info.get("enabled", True):
                return btn

    return None


def _message_visible(d, text, timeout=2):
    if not text:
        return False
    deadline = time.time() + timeout
    while time.time() < deadline:
        nodes = d.xpath(L.COMMENT_TEXT_XPATH).all()
        bottom_nodes = sorted(nodes, key=_bounds_bottom)[-8:]
        for node in bottom_nodes:
            node_text = str(node.info.get("text", "") or "")
            if text in node_text:
                return True
        time.sleep(0.3)
    return False


def _set_text_to_input(d, edit_text, text):
    edit_text.click()
    time.sleep(0.2)
    resource_id = edit_text.info.get("resourceId") or edit_text.info.get("resourceName")
    if resource_id:
        try:
            input_selector = d(resourceId=resource_id)
            if input_selector.exists(timeout=0.5):
                input_selector.set_text(text)
                return True
        except Exception as e:
            logger.info(f"resource-id 输入失败，改用 fastinput: {e}")

    try:
        d.set_fastinput_ime(True)
        try:
            d.clear_text()
        except Exception:
            for _ in range(30):
                d.press("del")
        d.send_keys(text)
        return True
    finally:
        try:
            d.set_fastinput_ime(False)
        except Exception:
            pass


def _input_still_contains(d, text):
    edit_text = _find_bottom_edit_text(d, timeout=0.8)
    if not edit_text:
        return False
    current_text = str(edit_text.info.get("text", "") or "").strip()
    return bool(current_text and text in current_text)


def _send_text_from_focused_input(d, text, log_label):
    edit_text = _find_bottom_edit_text(d, timeout=3)
    if not edit_text:
        logger.warning(f"{log_label}: 未找到可用输入框")
        return False

    if not _set_text_to_input(d, edit_text, text):
        return False
    time.sleep(0.8)

    for attempt in range(3):
        send_btn = _find_clickable_send_button(d)
        if send_btn:
            _click_node_center(d, send_btn)
            logger.info(f"{log_label}: 已点击发送按钮")
            time.sleep(1.5)
            if _message_visible(d, text) or not _input_still_contains(d, text):
                return True
            logger.info(f"{log_label}: 点击发送后文本仍在输入框，继续重试")
        logger.info(f"{log_label}: 发送按钮未就绪，重试 {attempt + 1}/3")
        time.sleep(0.8)

    logger.info(f"{log_label}: 尝试回车键发送")
    d.press("enter")
    time.sleep(1.5)
    return _message_visible(d, text) or not _input_still_contains(d, text)


class PostCommentAction(BaseAction):
    """发布一条普通视频评论"""
    def execute(self, comment_text):
        if not comment_text:
            return False
            
        logger.info(f"准备发布视频评论: {comment_text}")
        try:
            edit_text = _find_bottom_edit_text(self.d, timeout=1)
            if not edit_text:
                hints = [
                    L.COMMENT_INPUT_HINT_1, L.COMMENT_INPUT_HINT_2,
                    L.COMMENT_INPUT_HINT_3, L.COMMENT_INPUT_HINT_4
                ]
                found_input = False
                for hint in hints:
                    node = self.d(text=hint)
                    if node.exists(timeout=1):
                        node.click()
                        time.sleep(1)
                        found_input = True
                        break
                
                if not found_input:
                    logger.warning("未找到视频页底部的评论输入框")
                    return False

            return _send_text_from_focused_input(self.d, comment_text, "视频评论")
                
        except Exception as e:
            logger.error(f"评论流程出现异常: {e}")
            return False

class OpenCommentSectionAction(BaseAction):
    """打开评论区（根据规律寻找主评论区按钮）"""
    def execute(self):
        logger.info("正在通过 content-desc 规律寻找主评论区按钮...")
        all_nodes = self.d.xpath(L.COMMENT_BTN_DYNAMIC).all()
        
        candidates = []
        for node in all_nodes:
            desc = node.info.get('contentDescription', '') or node.info.get('content-desc', '')
            if desc and re.match(r'^评论(评论|[\d万wWkK.]+.*)，按钮$', desc):
                candidates.append(node)
        
        if len(candidates) < 2:
            logger.warning(f"未找到足够的评论按钮候选目标 (找到 {len(candidates)} 个)。尝试兜底定位...")
            fallback_btn = self.d.xpath(L.COMMENT_BTN_FALLBACK)
            if fallback_btn.wait(timeout=2):
                fallback_btn.click()
                time.sleep(2)
                return True
            else:
                w, h = self.d.window_size()
                logger.warning("兜底定位失败，尝试点击评论按钮常见区域坐标")
                self.d.click(int(w * 0.92), int(h * 0.63))
                time.sleep(2)
                return True
            
        candidates.sort(key=lambda x: x.info['bounds']['top'])
        target_node = candidates[1]
        target_desc = target_node.info.get('contentDescription', '') or target_node.info.get('content-desc', '')
        
        if "评论评论" in target_desc:
            logger.info("当前视频可能为 0 评论")
        else:
            logger.info(f"成功锁定评论区入口，当前评论数标识: {target_desc}")
            
        target_node.click()
        time.sleep(2.5)
        return True

class ProcessCommentSectionAction(BaseAction):
    """处理评论区内容逻辑 (滑动并解析评论)"""
    def execute(self):
        logger.info("开始处理评论区内容...")
        ai_agent = DYReplyAgent(self.config)
        video_title = getattr(self, 'video_title', "")
        keyword = getattr(self, 'keyword', "")
        
        interaction_config = self.config.get('interaction', {})
        max_swipes = int(interaction_config.get('max_comment_swipes', 2))
        max_reviews = int(interaction_config.get('max_ai_comment_reviews', 20))
        custom_keywords = interaction_config.get('intent_keywords', [])
        processed_comments = set()
        swipe_count = 0
        reviewed_count = 0
        
        while swipe_count < max_swipes and reviewed_count < max_reviews:
            if hasattr(self, 'check_stop_callback'):
                self.check_stop_callback()
                
            found_target, reviewed_now = self._process_current_screen_comments(
                processed_comments,
                ai_agent,
                video_title,
                keyword,
                max_reviews - reviewed_count,
                custom_keywords,
            )
            reviewed_count += reviewed_now
            logger.info(f"AI 已识别评论 {reviewed_count}/{max_reviews} 条")

            if found_target:
                logger.info("发现目标客户，完成互动，准备退出评论区")
                break

            if reviewed_count >= max_reviews:
                logger.info("已达到 AI 评论识别上限，停止继续扫描评论区")
                break
                
            if self.d.xpath(L.COMMENT_NO_MORE_TEXT).exists:
                logger.info("已滑到底部，没有更多评论")
                break
                
            if not self._swipe_up_comments():
                logger.warning("滑动评论区失败")
                break
                
            swipe_count += 1
            time.sleep(random.uniform(1.0, 2.0))
            
        logger.info("评论区处理完毕，关闭面板")
        self._close_comment_section()
        return True

    def _process_current_screen_comments(self, processed_comments, ai_agent, video_title, keyword, remaining_reviews, custom_keywords=None):
        logger.info("正在解析当前屏幕可见评论...")
        text_nodes = self.d.xpath(L.COMMENT_TEXT_XPATH).all()
        custom_keywords = custom_keywords or []
        
        found_target = False
        reviewed_count = 0
        for node in text_nodes:
            text = node.info.get('text', '')
            if text and text not in processed_comments:
                processed_comments.add(text)
                if not self._is_reviewable_comment(text):
                    continue
                reviewed_count += 1
                if ai_agent.is_intent_comment(text, video_title=video_title, keyword=keyword, custom_keywords=custom_keywords):
                    logger.info(f"🎯 AI 识别到意向评论: {text}")
                    found_target = self._interact_with_potential_customer(node, text, ai_agent, video_title, keyword)
                    break
                if reviewed_count >= remaining_reviews:
                    break
        return found_target, reviewed_count

    def _is_reviewable_comment(self, text):
        if not text:
            return False
        clean = str(text).strip()
        if len(clean) < 4:
            return False
        ignored = {"作者", "置顶", "回复", "展开", "查看更多回复", "赞", "分享"}
        return clean not in ignored

    def _interact_with_potential_customer(self, comment_node, comment_text, ai_agent, video_title, keyword):
        comment_to_send = ai_agent.generate_lead_reply(
            comment_text,
            video_title=video_title,
            keyword=keyword,
        )
        if not comment_to_send:
            logger.warning("未能生成楼中楼回复，跳过本条意向评论")
            return False
        sent = self._send_comment_workflow(comment_node, comment_to_send)
        time.sleep(1.5)
        return sent

    def _send_comment_workflow(self, comment_node, text):
        logger.info(f"回复内容: {text}")
        try:
            comment_node.click()
            time.sleep(1)
        except Exception as exc:
            logger.warning(f"点击评论节点失败，尝试继续寻找回复输入框: {exc}")

        if not self._focus_reply_input():
            logger.warning("未找到楼中楼回复输入框")
            return False

        return _send_text_from_focused_input(self.d, text, "楼中楼回复")

    def _focus_reply_input(self):
        hints = [
            "回复", "回复评论", "善语结善缘", "发条评论",
            L.COMMENT_INPUT_HINT_1, L.COMMENT_INPUT_HINT_2,
            L.COMMENT_INPUT_HINT_3, L.COMMENT_INPUT_HINT_4
        ]
        for hint in hints:
            node = self.d(text=hint)
            if node.exists(timeout=1):
                node.click()
                time.sleep(0.8)
                return True

        if self.d.xpath(L.COMMENT_EDIT_TEXT_XPATH).wait(timeout=1):
            return True

        return False

    def _swipe_up_comments(self):
        try:
            container = self.d(resourceId=L.COMMENT_LIST_CONTAINER)
            if container.exists:
                bounds = container.info['bounds']
                self.d.swipe(
                    (bounds['left'] + bounds['right']) // 2,
                    int(bounds['bottom'] * 0.8),
                    (bounds['left'] + bounds['right']) // 2,
                    int(bounds['top'] + (bounds['bottom'] - bounds['top']) * 0.2),
                    duration=0.3
                )
                return True
            else:
                w, h = self.d.window_size()
                self.d.swipe(w // 2, int(h * 0.7), w // 2, int(h * 0.3), duration=0.3)
                return True
        except Exception as e:
            logger.error(f"滑动异常: {e}")
            return False

    def _close_comment_section(self):
        self.d.press("back")
        time.sleep(1)
