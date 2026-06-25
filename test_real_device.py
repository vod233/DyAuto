"""
真机测试脚本：验证抖音4大功能链路是否跑通
设备序列号: 10AE3M011A002C4
测试功能:
  1. 点赞 (DoubleClickLikeAction)
  2. 关注+私信 (FollowAuthorAction) - 重点验证粉丝数提取修复
  3. 视频评论 (PostCommentAction)
  4. 评论区楼中楼回复 (OpenCommentSectionAction + ProcessCommentSectionAction)
"""
import sys
import os
import logging
import time

# 添加项目根目录到 sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import uiautomator2 as u2

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s'
)
logger = logging.getLogger("real_device_test")


def load_config():
    """加载用户配置"""
    import yaml
    config_path = os.path.join(os.path.dirname(__file__), 'dy', 'config', 'user_settings.yaml')
    with open(config_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)


def test_follower_count_parsing():
    """单元测试：验证 _parse_follower_text 逻辑"""
    from dy.actions.interaction import FollowAuthorAction

    class Dummy(FollowAuthorAction):
        def __init__(self):
            pass

    dummy = Dummy()
    test_cases = [
        ("7146", 0.7146),          # 独立数字 → 万
        ("1.2万", 1.2),             # 带万后缀
        ("3w", 3.0),                # w 后缀
        ("1234粉丝", 0.1234),       # 合并显示
        ("1.5万粉丝", 1.5),         # 合并显示带万
        ("粉丝5000", 0.5),          # 粉丝在前
        ("", None),                 # 空字符串
        ("未知", None),             # 非数字
    ]
    passed = 0
    failed = 0
    for text, expected in test_cases:
        result = dummy._parse_follower_text(text)
        if expected is None:
            ok = result is None
        else:
            ok = result is not None and abs(result - expected) < 0.001
        status = "PASS" if ok else "FAIL"
        if ok:
            passed += 1
        else:
            failed += 1
        logger.info(f"[{status}] _parse_follower_text('{text}') = {result} (期望 {expected})")
    logger.info(f"单元测试结果: {passed} 通过, {failed} 失败")
    return failed == 0


def connect_device(serial):
    """连接设备"""
    logger.info(f"正在连接设备: {serial}")
    d = u2.connect(serial)
    info = d.info
    logger.info(f"设备已连接: {info.get('productName', 'unknown')} | 屏幕: {d.window_size()}")
    return d


def ensure_douyin_foreground(d):
    """确保抖音在前台"""
    pkg = "com.ss.android.ugc.aweme"
    current = d.app_current()
    if current.get('package') != pkg:
        logger.info("抖音不在前台，启动中...")
        d.app_start(pkg)
        time.sleep(3)
    else:
        logger.info(f"抖音已在前台: {current.get('activity')}")
    return True


def enter_first_video(d):
    """进入一个视频（优先搜索结果，其次首页推荐流）"""
    from dy.actions.locators import TikTokLocators as L
    logger.info("尝试进入第一个视频...")

    # 方式1: 搜索结果页的视频卡片（LinearLayout，非 FrameLayout）
    candidates = d.xpath(
        '//androidx.recyclerview.widget.RecyclerView//android.widget.LinearLayout[@clickable="true"]'
    ).all()
    if not candidates:
        candidates = d.xpath(
            '//android.widget.ListView//android.widget.LinearLayout[@clickable="true"]'
        ).all()
    if candidates:
        # 排除"点赞"按钮（有 content-desc 的），选择真正的视频卡片
        video_cards = [c for c in candidates if not c.info.get('contentDescription', '')]
        if video_cards:
            video_cards[0].click()
            logger.info("已点击搜索结果中的第一个视频卡片")
            time.sleep(3)
            return True

    # 方式2: 从首页推荐流进入（点击屏幕中部的视频）
    logger.info("搜索结果页无可点击视频，切换到首页推荐流...")
    # 先回到首页
    home_tab = d(text="首页")
    if home_tab.exists(timeout=2):
        home_tab.click()
        time.sleep(2)
    else:
        d.press("back")
        time.sleep(2)
        home_tab = d(text="首页")
        if home_tab.exists(timeout=2):
            home_tab.click()
            time.sleep(2)

    # 首页推荐流视频通常通过点击屏幕中部进入沉浸模式
    w, h = d.window_size()
    # 点击屏幕中部偏上（视频内容区域）
    d.click(int(w * 0.5), int(h * 0.45))
    time.sleep(3)

    # 验证是否进入了视频播放页（检查是否有分享/评论按钮）
    share_nodes = d.xpath(L.SHARE_BTN_DYNAMIC).all()
    comment_nodes = d.xpath(L.COMMENT_BTN_DYNAMIC).all()
    if share_nodes or comment_nodes:
        logger.info("已进入视频播放页")
        return True

    logger.warning("未能进入视频播放页")
    return False


def test_follower_extraction_on_device(d, config):
    """真机测试：导航到作者主页并验证粉丝数提取"""
    from dy.actions.interaction import FollowAuthorAction
    from dy.actions.locators import TikTokLocators as L

    logger.info("=" * 60)
    logger.info("测试功能2：粉丝数提取（重点验证修复）")
    logger.info("=" * 60)

    # 1. 滑动到作者主页
    w, h = d.window_size()
    logger.info(f"屏幕尺寸: {w}x{h}")

    sx = int(w * 0.9)
    sy = int(h / 2)
    ex = int(w * 0.1)
    ey = int(h / 2)
    logger.info(f"执行横向滑动进入作者主页: ({sx},{sy}) -> ({ex},{ey})")
    d.swipe(sx, sy, ex, ey, duration=0.4)
    time.sleep(3)

    # 2. dump 当前 UI 中所有 TextView，确认页面结构
    logger.info("--- 当前页面所有 TextView ---")
    text_nodes = d.xpath('//android.widget.TextView').all()
    for i, node in enumerate(text_nodes):
        info = node.info
        text = info.get('text', '') or ''
        bounds = info.get('bounds', {}) or {}
        if text and bounds:
            logger.info(f"  [{i}] text='{text}' bounds={bounds}")

    # 3. 调用修复后的 _extract_follower_count
    action = FollowAuthorAction(d, config=config)
    follower_count = action._extract_follower_count()
    logger.info(f">>> 提取到的粉丝数(万): {follower_count}")

    if follower_count is not None:
        logger.info(">>> [PASS] 粉丝数提取成功!")
        # 4. 验证关注按钮
        follow_btn = d(text=L.PROFILE_FOLLOW_BTN, clickable=True)
        if follow_btn.exists(timeout=2):
            bounds = follow_btn.info.get('bounds', {})
            logger.info(f">>> 找到关注按钮: bounds={bounds} (不点击，仅验证)")
            logger.info(">>> [PASS] 关注按钮定位成功!")
        else:
            logger.info(">>> 未找到关注按钮（可能已关注）")
        result = True
    else:
        logger.error(">>> [FAIL] 粉丝数提取失败!")
        result = False

    # 5. 返回视频页
    logger.info("返回视频页...")
    d.press("back")
    time.sleep(2)
    return result, follower_count


def test_like_action(d, config):
    """测试功能1：点赞"""
    from dy.actions.interaction import DoubleClickLikeAction
    logger.info("=" * 60)
    logger.info("测试功能1：点赞（双击）")
    logger.info("=" * 60)
    try:
        action = DoubleClickLikeAction(d, config=config)
        result = action.execute()
        logger.info(f">>> 点赞执行结果: {result}")
        if result:
            logger.info(">>> [PASS] 点赞功能正常!")
        else:
            logger.error(">>> [FAIL] 点赞功能异常!")
        return result
    except Exception as e:
        logger.error(f">>> [FAIL] 点赞功能异常: {e}")
        return False


def test_follow_action(d, config):
    """测试功能2：关注（不实际发私信，仅验证流程）"""
    from dy.actions.interaction import FollowAuthorAction
    logger.info("=" * 60)
    logger.info("测试功能2：关注+私信链路")
    logger.info("=" * 60)
    try:
        # 关闭私信以避免实际发送
        test_config = dict(config)
        test_interaction = dict(config.get('interaction', {}))
        test_interaction['enable_private_message'] = False
        test_config['interaction'] = test_interaction

        action = FollowAuthorAction(d, config=test_config, private_message_allowed=False)
        result = action.execute()
        logger.info(f">>> 关注执行结果: {result}")
        if isinstance(result, dict):
            follower_count = result.get('follower_count')
            followed = result.get('followed', False)
            logger.info(f"  - 粉丝数: {follower_count}")
            logger.info(f"  - 是否关注: {followed}")
            if follower_count is not None:
                logger.info(">>> [PASS] 关注链路正常（粉丝数提取成功）!")
                return True
            else:
                logger.error(">>> [FAIL] 粉丝数提取失败!")
                return False
        logger.error(f">>> [FAIL] 关注链路异常，返回值: {result}")
        return False
    except Exception as e:
        logger.error(f">>> [FAIL] 关注功能异常: {e}", exc_info=True)
        return False


def test_comment_action(d, config):
    """测试功能3：视频评论（仅验证输入框定位，不实际发送）"""
    from dy.actions.commenting import PostCommentAction, _find_bottom_edit_text
    from dy.actions.locators import TikTokLocators as L
    logger.info("=" * 60)
    logger.info("测试功能3：视频评论输入框定位")
    logger.info("=" * 60)
    try:
        # 先尝试找到评论输入入口
        hints = [L.COMMENT_INPUT_HINT_1, L.COMMENT_INPUT_HINT_2, L.COMMENT_INPUT_HINT_3, L.COMMENT_INPUT_HINT_4]
        found_input = False
        for hint in hints:
            node = d(text=hint)
            if node.exists(timeout=1):
                logger.info(f"找到评论入口: '{hint}'")
                node.click()
                time.sleep(1.5)
                found_input = True
                break

        if not found_input:
            logger.warning("未找到评论输入入口提示文字")
            # 尝试直接查找 EditText
            edit = _find_bottom_edit_text(d, timeout=2)
            if edit:
                found_input = True

        if found_input:
            edit = _find_bottom_edit_text(d, timeout=2)
            if edit:
                bounds = edit.info.get('bounds', {})
                logger.info(f">>> 找到评论输入框: bounds={bounds}")
                logger.info(">>> [PASS] 视频评论输入框定位成功! (不实际发送评论)")
                d.press("back")
                time.sleep(1)
                return True
            else:
                logger.error(">>> [FAIL] 点击入口后未找到输入框!")
                d.press("back")
                return False
        else:
            logger.error(">>> [FAIL] 未找到评论输入入口!")
            return False
    except Exception as e:
        logger.error(f">>> [FAIL] 评论功能异常: {e}")
        return False


def test_comment_section(d, config):
    """测试功能4：评论区打开"""
    from dy.actions.commenting import OpenCommentSectionAction
    logger.info("=" * 60)
    logger.info("测试功能4：打开评论区")
    logger.info("=" * 60)
    try:
        action = OpenCommentSectionAction(d, config=config)
        result = action.execute()
        if result:
            logger.info(">>> [PASS] 评论区打开成功!")
            # 验证评论区是否有评论内容
            from dy.actions.locators import TikTokLocators as L
            text_nodes = d.xpath(L.COMMENT_TEXT_XPATH).all()
            logger.info(f"  评论区可见 TextView 数量: {len(text_nodes)}")
            # 展示前几条评论
            for i, node in enumerate(text_nodes[:5]):
                text = node.info.get('text', '') or ''
                if text and len(text) > 3:
                    logger.info(f"  评论[{i}]: {text[:50]}")
        else:
            logger.error(">>> [FAIL] 评论区打开失败!")
        # 关闭评论区
        d.press("back")
        time.sleep(1)
        return result
    except Exception as e:
        logger.error(f">>> [FAIL] 评论区功能异常: {e}")
        return False


def main():
    serial = "10AE3M011A002C4"
    config = load_config()
    logger.info(f"配置加载完成: enable_like={config['interaction']['enable_like']}, "
                f"enable_author_follow={config['interaction']['enable_author_follow']}")

    # Step 1: 单元测试 _parse_follower_text
    logger.info("\n" + "=" * 60)
    logger.info("Step 1: 单元测试 _parse_follower_text")
    logger.info("=" * 60)
    unit_ok = test_follower_count_parsing()

    # Step 2: 连接设备
    d = connect_device(serial)
    ensure_douyin_foreground(d)

    # Step 3: 进入视频
    logger.info("\n" + "=" * 60)
    logger.info("Step 3: 进入第一个视频")
    logger.info("=" * 60)
    if not enter_first_video(d):
        logger.error("无法进入视频，测试终止")
        return

    results = {}

    # Step 4: 测试点赞
    results['like'] = test_like_action(d, config)
    time.sleep(2)

    # Step 5: 测试粉丝数提取 + 关注
    follower_ok, follower_count = test_follower_extraction_on_device(d, config)
    results['follower_extract'] = follower_ok
    time.sleep(2)

    # Step 6: 测试评论输入框
    results['comment_input'] = test_comment_action(d, config)
    time.sleep(2)

    # Step 7: 测试评论区打开
    results['comment_section'] = test_comment_section(d, config)

    # 汇总
    logger.info("\n" + "=" * 60)
    logger.info("测试结果汇总")
    logger.info("=" * 60)
    logger.info(f"  单元测试 _parse_follower_text: {'PASS' if unit_ok else 'FAIL'}")
    logger.info(f"  功能1 点赞: {'PASS' if results.get('like') else 'FAIL'}")
    logger.info(f"  功能2 粉丝数提取: {'PASS' if results.get('follower_extract') else 'FAIL'} (提取值: {follower_count})")
    logger.info(f"  功能3 评论输入框: {'PASS' if results.get('comment_input') else 'FAIL'}")
    logger.info(f"  功能4 评论区打开: {'PASS' if results.get('comment_section') else 'FAIL'}")
    logger.info("=" * 60)


if __name__ == "__main__":
    main()
