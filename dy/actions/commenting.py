import time
import re
import random
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L

logger = logging.getLogger(__name__)

class PostCommentAction(BaseAction):
    """发布一条普通视频评论"""
    def execute(self, comment_text):
        if not comment_text:
            return False
            
        logger.info(f"准备发布视频评论: {comment_text}")
        try:
            edit_text = self.d(className=L.COMMENT_EDIT_TEXT_CLASS)
            if not edit_text.exists:
                hints = [
                    L.COMMENT_INPUT_HINT_1, L.COMMENT_INPUT_HINT_2,
                    L.COMMENT_INPUT_HINT_3, L.COMMENT_INPUT_HINT_4
                ]
                found_input = False
                for hint in hints:
                    node = self.d(text=hint)
                    if node.exists:
                        node.click()
                        time.sleep(1)
                        found_input = True
                        break
                
                if not found_input:
                    logger.warning("未找到视频页底部的评论输入框")
                    return False
                    
            edit_text = self.d(className=L.COMMENT_EDIT_TEXT_CLASS)
            if edit_text.exists:
                edit_text.set_text(comment_text)
                time.sleep(1)
                
                send_btn = self.d.xpath(L.COMMENT_SEND_BTN_XPATH)
                if send_btn.exists:
                    send_btn.click()
                    logger.info("已点击发送按钮")
                    time.sleep(2)
                    return True
                else:
                    self.d.press("enter")
                    logger.info("通过回车键发送评论")
                    time.sleep(2)
                    return True
            else:
                logger.error("输入框依然不存在，无法输入")
                return False
                
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
        # 兼容 kwargs 传入的关键词参数
        potential_customer_keywords = getattr(self, 'potential_customer_keywords', [])
        auto_reply_texts = getattr(self, 'auto_reply_texts', ["你好"])
        
        max_swipes = self.config.get('crawler', {}).get('max_comment_swipes', 3)
        processed_comments = set()
        swipe_count = 0
        
        while swipe_count < max_swipes:
            if hasattr(self, 'check_stop_callback'):
                self.check_stop_callback()
                
            if self._process_current_screen_comments(processed_comments, potential_customer_keywords, auto_reply_texts):
                logger.info("发现目标客户，完成互动，准备退出评论区")
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

    def _process_current_screen_comments(self, processed_comments, potential_customer_keywords, auto_reply_texts):
        logger.info("正在解析当前屏幕可见评论...")
        compose_nodes = self.d(className=L.COMPOSE_TEXT_CLASS)
        
        found_target = False
        if compose_nodes.exists:
            for i in range(len(compose_nodes)):
                text = compose_nodes[i].info.get('text', '')
                if text and text not in processed_comments:
                    processed_comments.add(text)
                    if self._is_potential_customer(text, potential_customer_keywords):
                        logger.info(f"🎯 发现潜在客户意向 (Compose模式): {text}")
                        self._interact_with_potential_customer(auto_reply_texts)
                        found_target = True
                        break
        else:
            content_nodes = self.d(resourceId=L.NATIVE_CONTENT_ID)
            for i in range(len(content_nodes)):
                text = content_nodes[i].info.get('text', '')
                if text and text not in processed_comments:
                    processed_comments.add(text)
                    if self._is_potential_customer(text, potential_customer_keywords):
                        logger.info(f"🎯 发现潜在客户意向 (原生模式): {text}")
                        self._interact_with_potential_customer(auto_reply_texts)
                        found_target = True
                        break
        return found_target

    def _is_potential_customer(self, text, keywords):
        if not keywords:
            return False
        for kw in keywords:
            if kw in text:
                return True
        return False

    def _interact_with_potential_customer(self, auto_reply_texts):
        reply_texts = auto_reply_texts if auto_reply_texts else ["你好"]
        comment_to_send = random.choice(reply_texts)
        self._send_comment_workflow(comment_to_send)
        time.sleep(1.5)

    def _send_comment_workflow(self, text):
        logger.info(f"回复内容: {text}")
        # 具体回复逻辑可后续在 Action 中扩充
        pass

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