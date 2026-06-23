import os
import time
import logging
import datetime
import cv2
import numpy as np
import adbutils
from .base_action import BaseAction
from .locators import XHSLocators as L
from ..db_manager import DBManager

logger = logging.getLogger(__name__)


def _capture_screen_with_adb(serial):
    """使用最基础的 adb screencap 获取当前屏幕，并解码成 OpenCV 图像。"""
    png_bytes = adbutils.adb.device(serial=serial).shell(["screencap", "-p"], encoding=None)
    if not png_bytes:
        raise RuntimeError("ADB 截图返回空数据")

    image_array = np.frombuffer(png_bytes, dtype=np.uint8)
    image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)
    if image is None:
        raise RuntimeError("ADB 截图解码失败")
    return image


def _save_debug_screenshot(image, prefix):
    """将当前截图保存到 logs 目录，便于排查匹配失败时的真实页面。"""
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    logs_dir = os.path.join(project_root, "logs")
    os.makedirs(logs_dir, exist_ok=True)
    filename = f"{prefix}_{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.png"
    output_path = os.path.join(logs_dir, filename)
    cv2.imwrite(output_path, image)
    return output_path


def _build_template_foreground_mask(template_gray):
    """从模板中提取爱心轮廓区域，便于后续只对图标本身做颜色判断。"""
    bg_samples = np.array(
        [
            template_gray[0, 0],
            template_gray[0, -1],
            template_gray[-1, 0],
            template_gray[-1, -1],
        ],
        dtype=np.uint8,
    )
    bg_level = int(np.median(bg_samples))
    mask = np.abs(template_gray.astype(np.int16) - bg_level) > 18

    if int(mask.sum()) < 12:
        mask = cv2.Canny(template_gray, 40, 120) > 0

    return mask


def _is_match_in_feed_region(image, center_x, center_y):
    """只限制顶部误匹配，不限制底部内容区域。"""
    height, width = image.shape[:2]
    min_y = int(height * 0.14)
    min_x = int(width * 0.08)
    max_x = int(width * 0.92)
    return min_x <= center_x <= max_x and center_y >= min_y


def _build_note_click_point(image, match):
    """点击识别到的白色爱心同一高度左侧，优先命中图文卡片主体区域。"""
    height, width = image.shape[:2]
    x, y = match["result"]
    box_w, box_h = match["box_size"]

    click_x = x - max(85, int(box_w * 3.8))
    click_y = y

    safe_margin_x = max(20, box_w)
    safe_margin_y = max(30, box_h)
    click_x = min(max(safe_margin_x, click_x), width - safe_margin_x)
    click_y = min(max(safe_margin_y, click_y), height - safe_margin_y)
    return int(click_x), int(click_y)


def _build_click_bounds(click_x, click_y, radius=3):
    return {
        "left": int(click_x - radius),
        "top": int(click_y - radius),
        "right": int(click_x + radius),
        "bottom": int(click_y + radius),
    }


def _swipe_right_to_exit_note(device):
    """点击左上角返回按钮，退出当前的图文/视频详情页。带有轻量防误退保护。"""
    # 轻量防误退：如果屏幕上存在“首页”、“发现”或搜索栏特征，说明已经在外部，直接跳过
    if device.xpath('//*[@text="首页" or @text="发现"]').exists or device.xpath('//*[@content-desc="搜索"]').exists:
        logger.info("当前画面疑似已在列表页或首页，跳过退出详情页操作。")
        return

    logger.info("点击左上角返回，尝试退出内容详情页...")
    width, height = device.window_size()
    click_x = int(width * 0.06)
    click_y = int(height * 0.06)
    device.click(click_x, click_y)


def _is_xhs_note_detail_page(device):
    """通过详情页底部互动区特征，判断当前是否还停留在笔记详情页。"""
    # TODO: 暂时注释掉基于底部按钮的详情页判断逻辑
    # has_comment_btn = device.xpath(L.XHS_COMMENT_BTN_DESC).exists
    # has_share_btn = device.xpath(L.XHS_SHARE_BTN_DESC).exists
    # return bool(has_comment_btn or has_share_btn)
    return True


def _wait_for_xhs_note_detail_page(device, timeout=3.0, interval=0.3):
    """点击后等待详情页加载成功，避免误把无效点击当作进入成功。"""
    # TODO: 暂时注释掉等待详情页加载逻辑
    # start_time = time.time()
    # while time.time() - start_time < timeout:
    #     if _is_xhs_note_detail_page(device):
    #         return True
    #     time.sleep(interval)
    # return _is_xhs_note_detail_page(device)
    time.sleep(1.5) # 兜底等待一下页面跳转
    return True


def _open_top_note(device, screenshot, white_matches, scene_name):
    """只取屏幕指定半边最上方的一个白色爱心点击，不再保留候选列表。"""
    if not white_matches:
        return False
        
    # 取按 Y 坐标排序后的第一个（最上方的）白心
    match = white_matches[0]
    x, y = match["result"]
    click_x, click_y = _build_note_click_point(screenshot, match)

    logger.info(
        f"{scene_name}，已选中最上方的白心 (分数: {match['confidence']:.3f})，"
        f"爱心坐标: ({x}, {y})，即将点击坐标: ({click_x}, {click_y})"
    )
    device.click(click_x, click_y)

    if _wait_for_xhs_note_detail_page(device):
        logger.info("已点击白心，假设进入图文详情页。")
        time.sleep(1)
        return True

    return False





def _click_search_result_tab(device, tab_xpath, tab_name, attempts=2):
    """点击搜索结果页顶部页签，优先走坐标点击以提高稳定性。"""
    tab_node = device.xpath(tab_xpath)
    if not tab_node.wait(timeout=5):
        logger.warning(f"未找到'{tab_name}'页签按钮，可能是搜索无结果或者UI变更")
        return False

    _log_search_result_tabs_state(device, "点击前")

    for attempt in range(attempts):
        try:
            bounds = tab_node.info.get("bounds", {})
            left = int(bounds.get("left", 0))
            right = int(bounds.get("right", 0))
            top = int(bounds.get("top", 0))
            bottom = int(bounds.get("bottom", 0))
            if right > left and bottom > top:
                click_x = int((left + right) / 2)
                click_y = int((top + bottom) / 2)
                device.click(click_x, click_y)
            else:
                tab_node.click()
            logger.info(f"已执行第 {attempt + 1} 次'{tab_name}'页签点击")
            time.sleep(1.2)
            _log_search_result_tabs_state(device, f"第 {attempt + 1} 次点击后")
        except Exception as exc:
            logger.warning(f"点击'{tab_name}'页签失败，第 {attempt + 1} 次重试: {exc}")

    return True


def _get_search_result_tab_state(device, tab_xpath, tab_name):
    """读取搜索结果页签当前状态，用于日志排查是否真的切换成功。"""
    tab_node = device.xpath(tab_xpath)
    if not tab_node.exists:
        return {"name": tab_name, "exists": False}

    try:
        info = tab_node.info or {}
    except Exception as exc:
        return {"name": tab_name, "exists": True, "error": str(exc)}

    return {
        "name": tab_name,
        "exists": True,
        "text": info.get("text"),
        "selected": info.get("selected"),
        "checked": info.get("checked"),
        "focused": info.get("focused"),
        "enabled": info.get("enabled"),
        "bounds": info.get("bounds"),
    }


def _log_search_result_tabs_state(device, stage):
    latest_state = _get_search_result_tab_state(device, L.TAB_LATEST, "最新")
    comprehensive_state = _get_search_result_tab_state(device, L.TAB_COMPREHENSIVE, "综合")
    logger.info(
        f"搜索结果页签状态[{stage}] latest={latest_state} comprehensive={comprehensive_state}"
    )


def _find_template_matches_in_image(image, template_path, threshold=0.45, scales=None, region=None):
    """对单张截图做多尺度模板匹配，可指定 region ('left'或'right') 限制搜索区域，返回按从上到下排序后的候选点。"""
    if not os.path.exists(template_path):
        raise FileNotFoundError(template_path)

    if scales is None:
        scales = (0.45, 0.52, 0.60, 0.68, 0.76, 0.85, 0.92, 1.0, 1.08, 1.16, 1.24)

    screenshot_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    img_h, img_w = screenshot_gray.shape[:2]
    template = cv2.imread(template_path, cv2.IMREAD_GRAYSCALE)
    if template is None:
        raise RuntimeError(f"模板图片加载失败: {template_path}")
    template_mask = _build_template_foreground_mask(template)

    matches = []
    best_match = {
        "confidence": 0.0,
        "result": None,
        "box_size": None,
        "scale": None,
    }
    for scale in scales:
        template_w = max(12, int(template.shape[1] * scale))
        template_h = max(12, int(template.shape[0] * scale))
        if template_w >= img_w or template_h >= img_h:
            continue

        interpolation = cv2.INTER_AREA if scale < 1.0 else cv2.INTER_LINEAR
        scaled_template = cv2.resize(template, (template_w, template_h), interpolation=interpolation)
        scaled_mask = cv2.resize(
            template_mask.astype(np.uint8),
            (template_w, template_h),
            interpolation=cv2.INTER_NEAREST,
        ) > 0
        
        # 根据 region 裁剪搜索区域，提高效率和准确度
        search_roi = screenshot_gray
        offset_x = 0
        if region == 'left':
            search_roi = screenshot_gray[:, :img_w // 2]
        elif region == 'right':
            search_roi = screenshot_gray[:, img_w // 2:]
            offset_x = img_w // 2

        if template_w >= search_roi.shape[1] or template_h >= search_roi.shape[0]:
            continue

        result = cv2.matchTemplate(search_roi, scaled_template, cv2.TM_CCOEFF_NORMED)
        _, max_val, _, max_loc = cv2.minMaxLoc(result)
        
        global_max_loc_x = max_loc[0] + offset_x
        if max_val > best_match["confidence"]:
            best_match = {
                "confidence": float(max_val),
                "result": (int(global_max_loc_x + template_w / 2), int(max_loc[1] + template_h / 2)),
                "box_size": (template_w, template_h),
                "scale": scale,
            }
            
        ys, xs = np.where(result >= threshold)

        for x, y in zip(xs, ys):
            global_x = x + offset_x
            center_x = int(global_x + template_w / 2)
            center_y = int(y + template_h / 2)
            score = float(result[y, x])

            duplicated = False
            for existed in matches:
                existed_x, existed_y = existed["result"]
                distance_limit_x = max(template_w, existed["box_size"][0]) // 2
                distance_limit_y = max(template_h, existed["box_size"][1]) // 2
                if abs(center_x - existed_x) < distance_limit_x and abs(center_y - existed_y) < distance_limit_y:
                    duplicated = True
                    if score > existed["confidence"]:
                        existed["result"] = (center_x, center_y)
                        existed["confidence"] = score
                        existed["box_size"] = (template_w, template_h)
                        existed["template_mask"] = scaled_mask
                    break

            if not duplicated:
                matches.append(
                    {
                        "result": (center_x, center_y),
                        "confidence": score,
                        "box_size": (template_w, template_h),
                        "template_mask": scaled_mask,
                    }
                )

    matches.sort(key=lambda m: (m["result"][1], m["result"][0]))
    return matches, best_match


def _classify_heart_color(image, center_x, center_y, box_w, box_h, template_mask=None):
    """结合模板轮廓区域与 HSV 统计，更稳地区分红心和白心。"""
    height, width = image.shape[:2]

    half_w = max(8, box_w // 2)
    half_h = max(8, box_h // 2)

    left = max(0, center_x - half_w)
    right = min(width, center_x + half_w + 1)
    top = max(0, center_y - half_h)
    bottom = min(height, center_y + half_h + 1)

    roi = image[top:bottom, left:right]
    if roi.size == 0:
        return "unknown", {}

    roi_h, roi_w = roi.shape[:2]
    if roi_h < 4 or roi_w < 4:
        return "unknown", {}

    # 优先使用模板轮廓区域统计颜色，避免被图文背景干扰。
    yy, xx = np.ogrid[:roi_h, :roi_w]
    cx = roi_w / 2.0
    cy = roi_h / 2.0
    rx = max(1.0, roi_w * 0.42)
    ry = max(1.0, roi_h * 0.42)
    center_mask = ((xx - cx) ** 2 / rx ** 2 + (yy - cy) ** 2 / ry ** 2) <= 1

    icon_mask = None
    if template_mask is not None and template_mask.size:
        if template_mask.shape != (roi_h, roi_w):
            resized_mask = cv2.resize(
                template_mask.astype(np.uint8),
                (roi_w, roi_h),
                interpolation=cv2.INTER_NEAREST,
            ) > 0
        else:
            resized_mask = template_mask
        icon_mask = resized_mask

    if icon_mask is None or int(icon_mask.sum()) < 8:
        icon_mask = center_mask

    hsv = cv2.cvtColor(roi, cv2.COLOR_BGR2HSV)
    h = hsv[:, :, 0]
    s = hsv[:, :, 1]
    v = hsv[:, :, 2]

    # 红色：Hue 在红色两端，饱和度较高，亮度不能太低
    red_mask = (
        ((h <= 12) | (h >= 168))
        & (s > 85)
        & (v > 90)
    )

    # 白色/浅灰心形描边在模板轮廓上通常表现为低饱和度、较高亮度。
    white_mask = (
        (s < 75)
        & (v > 115)
    )

    valid_mask = icon_mask & (v > 55)

    valid_count = int(valid_mask.sum())
    if valid_count < 10:
        return "unknown", {
            "valid_count": valid_count,
        }

    red_count = int((red_mask & valid_mask).sum())
    white_count = int((white_mask & valid_mask).sum())

    red_ratio = red_count / valid_count
    white_ratio = white_count / valid_count

    # 主导颜色判断
    if red_ratio > 0.18 and red_ratio > white_ratio * 1.25:
        label = "red"
    elif white_ratio > 0.32 and red_ratio < 0.16:
        label = "white"
    else:
        label = "unknown"

    return label, {
        "red_ratio": float(red_ratio),
        "white_ratio": float(white_ratio),
        "red_count": red_count,
        "white_count": white_count,
        "valid_count": valid_count,
        "roi_shape": roi.shape[:2],
    }


def _scan_and_return_matches(device, template_path, threshold=0.45, region=None):
    """截取当前屏幕，调用多尺度模板匹配，并按颜色过滤分类（只找白心），返回匹配结果列表。"""
    screenshot = _capture_screen_with_adb(device.serial)
    if screenshot is None:
        raise RuntimeError("ADB 截图失败")

    candidate_matches, best_match = _find_template_matches_in_image(
        screenshot, template_path, threshold=threshold, region=region
    )

    white_matches = []
    red_matches = []
    unknown_matches = []

    for match in candidate_matches:
        cx, cy = match["result"]
        bw, bh = match["box_size"]
        
        if not _is_match_in_feed_region(screenshot, cx, cy):
            continue

        mask = match.get("template_mask")
        color_class, stats = _classify_heart_color(screenshot, cx, cy, bw, bh, template_mask=mask)
        match["color_class"] = color_class
        match["color_stats"] = stats

        if color_class == "white":
            white_matches.append(match)
        elif color_class == "red":
            red_matches.append(match)
        else:
            unknown_matches.append(match)

    if candidate_matches:
        logger.info(
            f"当前屏幕[{region or '全屏'}]扫描到 {len(candidate_matches)} 个候选爱心："
            f"白心 {len(white_matches)} 个，未知 {len(unknown_matches)} 个，红心 {len(red_matches)} 个。"
        )

    return screenshot, white_matches, red_matches, unknown_matches, best_match

class EnsureHomeAction(BaseAction):
    """确保小红书已打开并处于可以搜索的状态 (包含处理青少年模式/隐私弹窗)"""
    def execute(self):
        for i in range(10):
            # 检查是否有小红书隐私同意按钮等弹窗
            if self.d(text="同意").exists:
                self.d(text="同意").click()
                logger.info("已点击同意隐私政策")
                time.sleep(1)

            if self.d(text=L.HOME_TAB_TEXT).exists or self.d.xpath(L.SEARCH_BTN_DESC).exists:
                logger.info("✅ 小红书首页加载成功")
                time.sleep(3)
                return True
            
            if self.d(text=L.YOUTH_MODE_CLOSE_TEXT).exists:
                self.d(text=L.YOUTH_MODE_CLOSE_TEXT).click()
                logger.info("已跳过青少年模式弹窗")
                
            logger.info(f"等待首页加载中... ({i+1}/10)")
            time.sleep(2)
        return False

class EnterSearchAction(BaseAction):
    """进入搜索框并输入关键词，随后点击搜索按钮确认，并按配置切换页签"""
    def execute(self, keyword, sort_mode="latest"):
        logger.info(f"正在搜索关键词: {keyword}，目标排序页签: {sort_mode}")
        
        # 1. 点击首页搜索按钮 (右上角放大镜)
        try:
            if self.d.xpath(L.SEARCH_BTN_DESC).click_exists(timeout=5):
                logger.info("通过 XPath 成功点击搜索按钮")
                time.sleep(2)
            else:
                search_desc = self.d(description=L.SEARCH_BTN_DESC_FALLBACK)
                if search_desc.exists(timeout=2):
                    search_desc.click()
                    logger.info("通过 Description 兜底点击成功")
                    time.sleep(2)
                else:
                    logger.warning("所有点击方式均告失败，尝试坐标点击右上角兜底")
                    sw, sh = self.d.window_size()
                    self.d.click(sw - 80, 100) # 小红书搜索大致在右上角
                    time.sleep(2)
        except Exception as e:
            logger.error(f"点击搜索按钮异常: {e}")
            sw, sh = self.d.window_size()
            self.d.click(sw - 80, 100)
            time.sleep(2)

        # 2. 在搜索框输入搜索内容
        self.d.set_fastinput_ime(True)
        try:
            self.d.clear_text()
        except Exception as e:
            logger.warning(f"clear_text() 发生异常 ({e})，尝试发送删除按键兜底")
            for _ in range(20):
                self.d.press("del")
        
        self.d.send_keys(keyword)
        self.d.set_fastinput_ime(False)
        time.sleep(1)
        
        # 点击确认搜索
        confirm_btn = self.d.xpath(L.SEARCH_CONFIRM_BTN)
        if confirm_btn.wait(timeout=5):
            confirm_btn.click()
            logger.info("点击了页面上的搜索按钮")
            time.sleep(5)
        else:
            self.d.send_action("search")
            logger.info("使用了键盘回车的搜索操作")
            time.sleep(5)

        # 3. 搜索出结果后，按配置切换到目标页签
        target_name = "最新" if sort_mode == "latest" else "综合"
        target_xpath = L.TAB_LATEST if sort_mode == "latest" else L.TAB_COMPREHENSIVE
        if _click_search_result_tab(self.d, target_xpath, target_name):
            logger.info(f"已尝试切换到'{target_name}'页签")
            time.sleep(2)
        return True

class ApplyFiltersAction(BaseAction):
    """打开并应用搜索结果的筛选条件"""
    def execute(self, sort_mode="latest"):
        sort_text = "综合" if sort_mode == "comprehensive" else "最新发布"
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
    """到达搜索结果页后，寻找屏幕左半边第一个白色爱心点击进入"""
    def execute(self):
        logger.info("正在扫描当前搜索结果页并寻找左半边第一个爱心...")
        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        tpl_white_heart_path = os.path.join(base_dir, "assets", "tpl_white_heart.png")

        if not os.path.exists(tpl_white_heart_path):
            logger.error(f"未找到白色爱心模板图片: {tpl_white_heart_path}，请先截图并保存。")
            return False

        start_wait = time.time()
        while time.time() - start_wait < 5:
            try:
                current_app = self.d.app_current()
                current_package = current_app.get("package", "")
                if current_package != "com.xingin.xhs":
                    logger.warning(f"当前前台应用不是小红书，而是: {current_package or 'unknown'}，跳过爱心扫描。")
                    return False

                # 初始进入，只扫左边
                screenshot, white_matches, red_matches, unknown_matches, best_match = _scan_and_return_matches(
                    self.d,
                    tpl_white_heart_path,
                    threshold=0.45,
                    region='left'
                )
                
                if white_matches:
                    logger.info(f"在左半边找到 {len(white_matches)} 个白色爱心，准备直接点击最上方的一个。")
                    if _open_top_note(self.d, screenshot, white_matches, "进入左半边第一个内容"):
                        return True
            except Exception as e:
                logger.warning(f"通过 ADB+OpenCV 查找白色爱心时发生异常: {e}")

            time.sleep(1)

        try:
            screenshot = _capture_screen_with_adb(self.d.serial)
            debug_path = _save_debug_screenshot(screenshot, "debug_first_white_heart_not_found")
            logger.warning(f"当前屏幕未扫描到任何白色爱心内容，已保存调试截图: {debug_path}")
        except Exception as save_error:
            logger.warning(f"当前屏幕未扫描到任何白色爱心内容，且保存调试截图失败: {save_error}")

        return False

class NextXHSNoteAction(BaseAction):
    """在一个内容处理完成后，寻找下一个具有白色爱心的内容点击进入"""
    def execute(self, current_count=1, force_scroll=False):
        logger.info(f"准备退回上级页面并切换下一个笔记 (当前已处理完第 {current_count} 个)...")

        # 1. 退出当前内容，返回瀑布流页面
        _swipe_right_to_exit_note(self.d)
        time.sleep(2)

        if force_scroll:
            logger.info("因内容连续重复，强制向下翻一页瀑布流。")
            self._scroll_feed_down()

        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        tpl_white_heart_path = os.path.join(base_dir, "assets", "tpl_white_heart.png")

        if not os.path.exists(tpl_white_heart_path):
            logger.error(f"未找到白色爱心模板图片: {tpl_white_heart_path}，请先截图并保存。")
            return False

        # current_count=1 时处理的是搜索后进入的左边第一个，所以此时 current_count=1
        # current_count 是从 task_runner 传进来的，它代表“刚才处理完的是第几个”
        # 所以接下来我们要寻找的是 第 current_count + 1 个
        next_target_index = current_count + 1
        
        # 奇数找左边，偶数找右边
        # 1 (左) -> 刚才处理完, 现在要找 2 (右)
        # 2 (右) -> 刚才处理完, 现在要找 3 (左，需翻页)
        if next_target_index % 2 == 0:
            target_region = 'right'
            logger.info("准备在当前屏幕寻找【右半边】的爱心候选。")
        else:
            target_region = 'left'
            logger.info("上一行的左右两边已处理完毕，先向下翻页，再寻找新一屏【左半边】的爱心候选。")
            self._scroll_feed_down()

        # 2. 在指定半边寻找下一个内容
        max_scroll_attempts = 10
        for scroll_attempt in range(max_scroll_attempts):
            logger.info(f"正在扫描当前屏幕[{target_region}]寻找下一个笔记 (第 {scroll_attempt + 1} 次扫描)...")

            try:
                current_app = self.d.app_current()
                current_package = current_app.get("package", "")
                if current_package != "com.xingin.xhs":
                    logger.warning(f"当前前台应用不是小红书，而是: {current_package or 'unknown'}，终止翻页扫描。")
                    return False

                screenshot, white_matches, red_matches, unknown_matches, best_match = _scan_and_return_matches(
                    self.d,
                    tpl_white_heart_path,
                    threshold=0.45,
                    region=target_region
                )
                
                if white_matches:
                    logger.info(f"在{target_region}半边找到 {len(white_matches)} 个白色爱心，准备直接点击最上方的一个。")
                    if _open_top_note(self.d, screenshot, white_matches, f"进入{target_region}半边下一个内容"):
                        return True
            except Exception as e:
                logger.warning(f"通过 ADB+OpenCV 查找白色爱心时发生异常: {e}")

            # 如果当前半边没找到白色爱心，意味着这一半没有（比如广告、已点赞），向上滑动寻找更多
            logger.info(f"当前屏幕[{target_region}]未发现白色爱心，向下翻页...")
            self._scroll_feed_down()

        try:
            screenshot = _capture_screen_with_adb(self.d.serial)
            debug_path = _save_debug_screenshot(screenshot, "debug_next_white_heart_not_found")
            logger.warning(f"达到最大滑动次数，未找到新的未处理内容。已保存调试截图: {debug_path}")
        except Exception as save_error:
            logger.warning(f"达到最大滑动次数，未找到新的未处理内容，且保存调试截图失败: {save_error}")
        return False

    def _scroll_feed_down(self):
        w, h = self.d.window_size()
        self.d.swipe(w // 2, int(h * 0.7), w // 2, int(h * 0.3), duration=0.2)
        time.sleep(2)

class SwipeNextVideoAction(BaseAction):
    """全屏模式下向下滑动到下一个视频"""
    def execute(self):
        width, height = self.d.window_size()
        self.d.swipe(width // 2, int(height * 0.8), width // 2, int(height * 0.2), duration=0.2)
        time.sleep(1)
        return True
