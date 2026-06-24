import time
import re
import hashlib
import random
import logging
from .base_action import BaseAction
from .locators import TikTokLocators as L

logger = logging.getLogger(__name__)


def _node_bounds(node):
    return node.info.get('bounds', {}) or {}


def _bounds_bottom(node):
    return _node_bounds(node).get('bottom', 0)


def _bounds_center(bounds):
    return (
        int((bounds.get('left', 0) + bounds.get('right', 0)) / 2),
        int((bounds.get('top', 0) + bounds.get('bottom', 0)) / 2),
    )


def _is_visible_enabled(node):
    info = node.info
    return info.get('visible', True) and info.get('enabled', True)


def _set_text_to_input(d, input_node, text):
    input_node.click()
    time.sleep(0.2)
    resource_id = input_node.info.get('resourceId') or input_node.info.get('resourceName')
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
    """滑动到作者主页并关注，然后返回视频页（支持粉丝数过滤和私信功能）"""
    
    _FOLLOWER_PATTERNS = [
        re.compile(r'(\d+(?:\.\d+)?)\s*[万wW]?\s*粉丝'),
        re.compile(r'粉丝\s*(\d+(?:\.\d+)?)\s*[万wW]?'),
        re.compile(r'(\d+(?:\.\d+)?)\s*[万wW]'),
    ]
    
    def execute(self):
        # 1. 滑动到主页
        w, h = self.d.window_size()
        self.d.swipe(int(w * 0.9), int(h / 2), int(w * 0.1), int(h / 2), duration=0.2)
        time.sleep(3)
        
        # 2. 获取作者粉丝数量
        follower_count = self._extract_follower_count()
        logger.info(f"作者粉丝数: {follower_count if follower_count else '未知'}")
        
        # 3. 根据阈值判断是否关注
        min_followers = self._get_min_followers_threshold()
        should_follow = True
        followed = False
        if min_followers > 0 and follower_count is not None:
            if follower_count < min_followers:
                logger.info(f"作者粉丝数({follower_count})低于关注阈值({min_followers})，跳过关注")
                should_follow = False
        
        # 4. 执行关注
        if should_follow:
            follow_btn = self.d(text=L.PROFILE_FOLLOW_BTN, clickable=True)
            if follow_btn.exists(timeout=2):
                follow_btn.click()
                logger.info("成功点击关注")
                followed = True
                time.sleep(1.5)
            else:
                logger.info("未找到'关注'按钮，可能已经关注过了")
        
        # 5. 判断是否发送私信（仅当成功关注且粉丝数大于私信阈值时）
        private_message_sent = False
        if should_follow:
            private_message_sent = self._try_send_private_message(follower_count)
        
        # 6. 返回视频页
        self._return_to_video_page()
        return {
            "should_follow": should_follow,
            "followed": followed,
            "private_message_sent": private_message_sent,
            "follower_count": follower_count,
        }
    
    def _get_min_followers_threshold(self):
        """获取配置的最小粉丝数阈值（单位：万）"""
        return float(self.config.get('interaction', {}).get('min_followers_threshold', 0))
    
    def _try_send_private_message(self, follower_count):
        """尝试发送私信（仅当粉丝数大于私信阈值时）"""
        # 检查私信功能是否启用
        if not self.config.get('interaction', {}).get('enable_private_message', False):
            return False
        
        # 检查粉丝数是否达到私信阈值
        pm_threshold = float(self.config.get('interaction', {}).get('pm_followers_threshold', 10))
        if follower_count is None or follower_count <= pm_threshold:
            logger.info(f"作者粉丝数({follower_count})未达到私信阈值({pm_threshold})，跳过私信")
            return False
        
        # 获取私信话术列表
        message_list = self.config.get('interaction', {}).get('pm_message_list', [])
        if not message_list:
            logger.warning("私信话术词库为空，无法发送私信")
            return False
        
        # 随机选择一条话术
        message = random.choice(message_list)
        logger.info(f"准备发送私信: {message}")
        
        # 执行私信发送
        try:
            return self._send_private_message(message)
        except Exception as e:
            logger.error(f"发送私信失败: {e}")
            return False
    
    def _send_private_message(self, message):
        """执行发送私信操作"""
        w, h = self.d.window_size()
        
        # 1. 查找私信按钮（消息/私信图标）
        message_btn = None
        
        # 方式1: 通过 content-desc 查找私信按钮（使用定位器配置）
        message_nodes = self.d.xpath(L.PM_BTN_DESC).all()
        if message_nodes:
            message_btn = message_nodes[0]
            logger.info("通过 content-desc 找到私信按钮")
        
        # 方式2: 通过文本查找私信按钮（使用定位器配置）
        if not message_btn:
            message_text_nodes = self.d.xpath(f'//*[@text="{L.PM_BTN_TEXT}"]').all()
            if message_text_nodes:
                # 优先选择可点击的私信按钮
                clickable_btns = [btn for btn in message_text_nodes if btn.info.get('clickable', False)]
                message_btn = clickable_btns[0] if clickable_btns else message_text_nodes[0]
                logger.info("通过文本找到私信按钮")
        
        # 方式3: 通过常见位置坐标点击（作者主页私信按钮通常在头像附近）
        if not message_btn:
            logger.info("未找到私信按钮，尝试常见位置")
            # 尝试点击头像下方区域（作者主页常见位置）
            self.d.click(int(w * 0.5), int(h * 0.35))
            time.sleep(2)
            
            # 再次查找私信输入框
            input_nodes = self.d.xpath(f'//{L.PM_EDIT_TEXT_CLASS}').all()
            if input_nodes:
                message_btn = input_nodes[0]
                logger.info("找到输入框")
        
        if message_btn:
            try:
                message_btn.click()
                time.sleep(2)
            except Exception:
                logger.warning("点击私信按钮失败，尝试直接查找输入框")
        
        # 2. 查找输入框并输入消息
        input_edit = self._find_private_message_input(timeout=4)
        
        if input_edit:
            if not _set_text_to_input(self.d, input_edit, message):
                logger.warning("私信输入失败，无法发送私信")
                return False
            time.sleep(1.5)

            if self._send_private_message_from_input(input_edit, message):
                logger.info("私信发送成功并已验证")
                return True

            logger.warning("私信发送失败：文本仍停留在输入框，未继续重试以避免堆积草稿")
            return False
        else:
            logger.warning("未找到私信输入框，无法发送私信")
            return False

    def _find_private_message_input(self, timeout=3):
        """查找聊天页底部可编辑输入框。"""
        deadline = time.time() + timeout
        while time.time() < deadline:
            input_nodes = self.d.xpath(f'//{L.PM_EDIT_TEXT_CLASS}').all()
            candidates = [node for node in input_nodes if _is_visible_enabled(node)]
            if candidates:
                return sorted(candidates, key=_bounds_bottom)[-1]
            time.sleep(0.3)
        return None

    def _find_private_message_send_button(self, input_edit=None):
        """查找私信页发送按钮，兼容文字、resource-id 和图标按钮。"""
        for resource_id in L.PM_SEND_BTN_IDS:
            btn = self.d(resourceId=resource_id)
            if btn.exists(timeout=0.3) and _is_visible_enabled(btn):
                logger.info(f"通过 resource-id 找到私信发送按钮: {resource_id}")
                return btn

        send_xpaths = (
            L.PM_SEND_BTN_XPATH,
        )
        for xpath in send_xpaths:
            nodes = self.d.xpath(xpath).all()
            candidates = [node for node in nodes if _is_visible_enabled(node)]
            if candidates:
                logger.info("通过文本/content-desc 找到私信发送按钮")
                return sorted(candidates, key=_bounds_bottom)[-1]

        if not input_edit:
            return None

        input_bounds = _node_bounds(input_edit)
        if not input_bounds:
            return None

        input_center_y = int((input_bounds.get('top', 0) + input_bounds.get('bottom', 0)) / 2)
        right_of_input = input_bounds.get('right', 0)
        width, _ = self.d.window_size()
        clickable_nodes = self.d.xpath(L.PM_CLICKABLE_XPATH).all()
        nearby = []
        for node in clickable_nodes:
            if not _is_visible_enabled(node):
                continue
            bounds = _node_bounds(node)
            if not bounds:
                continue
            overlaps_input_row = bounds.get('top', 0) <= input_center_y <= bounds.get('bottom', 0)
            is_on_right = bounds.get('left', 0) >= max(right_of_input - 12, int(width * 0.55))
            if overlaps_input_row and is_on_right:
                nearby.append(node)

        if nearby:
            logger.info("通过输入框右侧可点击节点找到私信发送按钮")
            return sorted(nearby, key=lambda n: _node_bounds(n).get('left', 0))[-1]

        return None

    def _click_node(self, node):
        bounds = _node_bounds(node)
        if bounds:
            x, y = _bounds_center(bounds)
            self.d.click(x, y)
            return True

        try:
            node.click()
            return True
        except Exception:
            return False

    def _input_contains_message(self, message):
        input_edit = self._find_private_message_input(timeout=0.8)
        if not input_edit:
            return False
        current_text = str(input_edit.info.get('text', '') or '').strip()
        return bool(current_text and message in current_text)

    def _click_send_text_center(self):
        send_nodes = self.d.xpath(L.PM_SEND_BTN_XPATH).all()
        candidates = [node for node in send_nodes if _is_visible_enabled(node)]
        if not candidates:
            return False

        node = sorted(candidates, key=_bounds_bottom)[-1]
        bounds = _node_bounds(node)
        if not bounds:
            return False
        x, y = _bounds_center(bounds)
        logger.info(f"通过发送文字中心坐标点击私信发送按钮: ({x}, {y})")
        self.d.click(x, y)
        return True

    def _click_bottom_right_send_area(self):
        width, height = self.d.window_size()
        click_points = (
            (int(width * 0.92), int(height * 0.91)),
            (int(width * 0.92), int(height * 0.86)),
            (int(width * 0.96), int(height * 0.91)),
        )
        for x, y in click_points:
            logger.info(f"尝试点击私信页面右下发送区域: ({x}, {y})")
            self.d.click(x, y)
            time.sleep(0.8)
            return True
        return False

    def _wait_until_private_message_sent(self, message, timeout=2.5):
        deadline = time.time() + timeout
        cleared_at = None
        while time.time() < deadline:
            if self._has_private_message_failure():
                return False
            if self._input_contains_message(message):
                cleared_at = None
                time.sleep(0.3)
                continue
            if self._verify_message_sent(message):
                return True
            if cleared_at is None:
                cleared_at = time.time()
            elif time.time() - cleared_at >= 1.2:
                return not self._has_private_message_failure()
            time.sleep(0.3)
        return False

    def _refind_input_or_original(self, input_edit):
        fresh = self._find_private_message_input(timeout=0.8)
        return fresh or input_edit

    def _click_send_button_by_nearby_node(self, input_edit):
        send_btn = self._find_private_message_send_button(input_edit)
        if not send_btn:
            return False
        return self._click_node(send_btn)

    def _click_send_area_next_to_input(self, input_edit):
        """图标按钮无法被 UIAutomator 识别时，点击输入框同行最右侧区域。"""
        bounds = _node_bounds(input_edit)
        if not bounds:
            return False
        width, _ = self.d.window_size()
        y = int((bounds.get('top', 0) + bounds.get('bottom', 0)) / 2)
        x = min(int(width * 0.94), max(bounds.get('right', 0) + 36, int(width * 0.88)))
        logger.info(f"尝试点击输入框右侧发送区域: ({x}, {y})")
        self.d.click(x, y)
        return True

    def _click_private_send_button(self, input_edit):
        send_btn = self._find_private_message_send_button(input_edit)
        if not send_btn:
            return False
        return self._click_node(send_btn)

    def _send_ime_action(self):
        try:
            self.d.send_action("send")
        except Exception:
            self.d.send_action("done")
        return True

    def _send_private_message_from_input(self, input_edit, message):
        """从已输入文本的私信输入框执行发送，并验证输入框被清空。"""
        send_attempts = [
            ("send_button_center", lambda: self._click_send_button_by_nearby_node(self._refind_input_or_original(input_edit))),
            ("send_text_center", self._click_send_text_center),
            ("input_row_coordinate", lambda: self._click_send_area_next_to_input(self._refind_input_or_original(input_edit))),
            ("bottom_right_coordinate", self._click_bottom_right_send_area),
            ("ime_send_action", self._send_ime_action),
            ("enter_key", lambda: self.d.press("enter") or True),
        ]

        for name, action in send_attempts:
            try:
                logger.info(f"尝试私信发送方式: {name}")
                if action() is False:
                    continue
                if self._wait_until_private_message_sent(message):
                    logger.info(f"私信发送方式成功: {name}")
                    return True
                if self._has_private_message_failure():
                    logger.warning("检测到抖音私信发送失败提示，停止继续重试")
                    return False
            except Exception as e:
                logger.warning(f"私信发送方式失败 ({name}): {e}")

        return False

    def _verify_private_message_sent(self, message):
        """确认消息已发送；先查消息气泡，再用输入框状态兜底。"""
        if self._has_private_message_failure():
            return False
        if self._verify_message_sent(message):
            return True

        input_edit = self._find_private_message_input(timeout=1.2)
        if input_edit:
            current_text = str(input_edit.info.get('text', '') or '').strip()
            if current_text and message in current_text:
                logger.info("私信输入框仍包含待发送文本，判定未发送")
                return False
            time.sleep(1.0)
            if self._has_private_message_failure():
                return False
            logger.info("未匹配到消息气泡，但输入框文本已清空，按已发送处理")
            return True

        return False

    def _has_private_message_failure(self):
        """识别抖音私信发送失败、隐私限制、风控提示。"""
        try:
            for node in self.d.xpath(L.PM_MESSAGE_TEXT_XPATH).all():
                text = str(node.info.get('text', '') or node.info.get('contentDescription', '') or '')
                if any(marker in text for marker in L.PM_SEND_FAILURE_TEXTS):
                    logger.warning(f"检测到私信失败提示: {text}")
                    return True
            return False
        except Exception as e:
            logger.warning(f"检查私信失败提示时出错: {e}")
            return False
    
    def _verify_message_sent(self, message):
        """验证消息是否成功发送（检查消息气泡是否出现）"""
        try:
            if self._has_private_message_failure():
                return False
            
            message_bubbles = self.d.xpath(L.PM_MESSAGE_TEXT_XPATH).all()
            if message_bubbles:
                # 优先检查底部的消息（刚发送的消息通常在底部）
                bottom_bubbles = sorted(
                    message_bubbles,
                    key=lambda x: x.info.get('bounds', {}).get('bottom', 0)
                )[-3:]  # 取最后3条消息检查
                for bubble in bottom_bubbles:
                    text = str(bubble.info.get('text', '') or '')
                    if any(marker in text for marker in L.PM_SEND_FAILURE_TEXTS):
                        return False
                    if text and message in text:
                        return True
            
            logger.debug("未找到已发送的消息气泡")
            return False
        except Exception as e:
            logger.warning(f"验证消息发送失败: {e}")
            return False
    
    def _extract_follower_count(self):
        """从作者主页提取粉丝数量（单位：万）"""
        try:
            # 方式1: 查找包含"粉丝"字样的节点
            follower_nodes = self.d.xpath('//*[contains(@text, "粉丝")]').all()
            for node in follower_nodes:
                text = str(node.info.get('text', '')).strip()
                if text:
                    count = self._parse_follower_text(text)
                    if count:
                        return count
            
            # 方式2: 遍历所有 TextView 查找粉丝数
            all_text_nodes = self.d.xpath('//android.widget.TextView').all()
            for node in all_text_nodes:
                text = str(node.info.get('text', '')).strip()
                if text and ('粉丝' in text or ('万' in text and len(text) <= 8)):
                    count = self._parse_follower_text(text)
                    if count:
                        return count
            
            return None
        except Exception as e:
            logger.warning(f"提取粉丝数量失败: {e}")
            return None
    
    def _parse_follower_text(self, text):
        """解析粉丝数字符串（支持"123万"、"123.4万"、"123456"等格式）"""
        if not text:
            return None
        
        for pattern in self._FOLLOWER_PATTERNS:
            match = pattern.search(text)
            if match:
                try:
                    num_str = match.group(1)
                    value = float(num_str)
                    # 如果文本中包含"万"，已经是万为单位；否则转换为万
                    if '万' in text or 'W' in text or 'w' in text:
                        return value
                    else:
                        # 小于6位的数字可能是直接显示的万数，大于等于6位是具体粉丝数
                        if len(num_str) >= 6:
                            return value / 10000
                        else:
                            return value
                except ValueError:
                    continue
        
        return None

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
