"""
抖音功能链路真机测试脚本
逐步测试每个功能的 Action 执行情况，定位失败点
"""
import sys
import os
import time
import logging
import yaml

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

# 加载配置
config_path = 'dy/config/user_settings.yaml'
with open(config_path, 'r', encoding='utf-8') as f:
    config = yaml.safe_load(f)

# 强制开启所有功能用于测试
config['interaction']['enable_like'] = True
config['interaction']['enable_author_follow'] = True
config['interaction']['enable_video_comment'] = True
config['interaction']['enable_comment_lead'] = True
config['interaction']['enable_private_message'] = True
# 降低限额以便测试
config.setdefault('anti_detection', {}).setdefault('daily_limits', {})
config['anti_detection']['daily_limits']['daily_like_limit'] = 999
config['anti_detection']['daily_limits']['daily_comment_limit'] = 999
config['anti_detection']['daily_limits']['daily_follow_limit'] = 999
config['anti_detection']['daily_limits']['daily_message_limit'] = 999

# 禁用夜间模式
config['anti_detection']['night_mode'] = {'enabled': False}

from dy.main_controller import ScoutTaskRunner
from dy.actions.navigation import (
    EnsureHomeAction, EnterSearchAction, ApplyFiltersAction,
    EnterFirstVideoAction, SwipeNextVideoAction
)
from dy.actions.interaction import (
    DoubleClickLikeAction, FollowAuthorAction, GetCurrentVideoLinkAction
)
from dy.actions.commenting import (
    PostCommentAction, OpenCommentSectionAction, ProcessCommentSectionAction
)

def test_step(name, func):
    """执行一个测试步骤并记录结果"""
    print(f"\n{'='*60}")
    print(f"  测试: {name}")
    print(f"{'='*60}")
    try:
        result = func()
        print(f"  [结果] {name}: {'成功' if result else '失败'}")
        return result
    except Exception as e:
        print(f"  [异常] {name}: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("\n" + "=" * 60)
    print("  抖音功能链路真机测试")
    print("=" * 60)

    # 1. 连接设备
    print("\n>>> 步骤 1: 连接设备")
    try:
        runner = ScoutTaskRunner(serial='10AE3M011A002C4', config_path=config_path)
        runner.config = config  # 覆盖配置
        print(f"  设备连接成功: {runner.device.info}")
    except Exception as e:
        print(f"  设备连接失败: {e}")
        return

    # 2. 拉起抖音
    print("\n>>> 步骤 2: 拉起抖音并确保首页")
    try:
        runner.launch_app()
        print("  抖音已启动并处于首页")
    except Exception as e:
        print(f"  启动抖音失败: {e}")
        return

    # 3. 测试搜索
    print("\n>>> 步骤 3: 测试搜索功能")
    search_ok = test_step("EnterSearchAction", lambda: runner.run_action(EnterSearchAction, "创业"))
    if not search_ok:
        print("  搜索失败，尝试重试...")
        time.sleep(2)
        search_ok = test_step("EnterSearchAction 重试", lambda: runner.run_action(EnterSearchAction, "创业"))
    
    # 4. 测试筛选
    print("\n>>> 步骤 4: 测试筛选功能")
    filter_ok = test_step("ApplyFiltersAction", lambda: runner.run_action(ApplyFiltersAction, sort_mode="latest"))

    # 5. 进入第一个视频
    print("\n>>> 步骤 5: 进入第一个视频")
    enter_ok = test_step("EnterFirstVideoAction", lambda: runner.run_action(EnterFirstVideoAction))
    if enter_ok:
        print("  等待视频加载...")
        time.sleep(3)

    # 6. 测试提取视频信息
    print("\n>>> 步骤 6: 测试提取视频链接/文案")
    link_info = test_step("GetCurrentVideoLinkAction", lambda: runner.run_action(GetCurrentVideoLinkAction))
    if link_info:
        url, share_token, description = link_info
        print(f"  URL: {url[:50] if url else 'None'}...")
        print(f"  Token: {share_token}")
        print(f"  描述: {description[:50] if description else 'None'}...")

    # 7. 测试点赞
    print("\n>>> 步骤 7: 测试双击点赞")
    like_ok = test_step("DoubleClickLikeAction", lambda: runner.run_action(DoubleClickLikeAction))

    # 8. 测试进作者主页
    print("\n>>> 步骤 8: 测试进作者主页/关注")
    follow_ok = test_step("FollowAuthorAction", lambda: runner.run_action(FollowAuthorAction, private_message_allowed=False))

    # 9. 测试发布评论
    print("\n>>> 步骤 9: 测试发布视频评论")
    test_comment = "这个内容很有价值，学到了"
    comment_ok = test_step("PostCommentAction", lambda: runner.run_action(PostCommentAction, test_comment))

    # 10. 测试打开评论区
    print("\n>>> 步骤 10: 测试打开评论区")
    comment_section_ok = test_step("OpenCommentSectionAction", lambda: runner.run_action(OpenCommentSectionAction))

    # 11. 测试评论区截流
    if comment_section_ok:
        print("\n>>> 步骤 11: 测试评论区AI截流")
        lead_ok = test_step("ProcessCommentSectionAction", lambda: runner.run_action(
            ProcessCommentSectionAction,
            video_title="测试视频",
            keyword="创业",
            check_stop_callback=lambda: None
        ))
    
    # 汇总
    print("\n" + "=" * 60)
    print("  测试汇总")
    print("=" * 60)
    results = {
        "搜索": search_ok,
        "筛选": filter_ok,
        "进入视频": enter_ok,
        "提取信息": link_info is not None,
        "点赞": like_ok,
        "关注/主页": follow_ok,
        "评论": comment_ok,
        "打开评论区": comment_section_ok,
    }
    for name, ok in results.items():
        print(f"  {'[PASS]' if ok else '[FAIL]'} {name}")

    # 关闭评论区
    try:
        runner.device.press("back")
        time.sleep(1)
        runner.device.press("back")
        time.sleep(1)
    except:
        pass

    print("\n  测试完成！")
    runner.shutdown()

if __name__ == "__main__":
    main()
