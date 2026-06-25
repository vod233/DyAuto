import unittest
from unittest.mock import patch

from dy.actions.commenting import (
    OpenCommentSectionAction,
    PostCommentAction,
    ProcessCommentSectionAction,
)
from dy.actions.interaction import (
    DoubleClickLikeAction,
    FollowAuthorAction,
    GetCurrentVideoLinkAction,
)
from dy.actions.navigation import SwipeNextVideoAction
from dy.task_runner import TikTokTaskFlow


class FakeRunner:
    def __init__(self):
        self.device = object()
        self.calls = []
        self.state = "video_page"

    def run_action(self, action_class, *args, **kwargs):
        self.calls.append((action_class, args, kwargs))
        if action_class is GetCurrentVideoLinkAction:
            return ("https://v.douyin.com/test/", "share-token", "这是一个用于测试的视频标题")
        if action_class is FollowAuthorAction:
            return {"followed": True, "private_message_sent": kwargs.get("private_message_allowed", False)}
        if action_class is OpenCommentSectionAction:
            self.state = "comment_panel"
            return True
        if action_class is ProcessCommentSectionAction:
            self.state = "video_page"
            return True
        return True


class FakeDB:
    def __init__(self):
        self.interactions = []

    def get_daily_stats(self):
        return {"videos": 0, "likes": 0, "comments": 0, "follows": 0, "private_messages": 0}

    def record_video(self, *args, **kwargs):
        return True

    def update_interaction(self, video_id, action_type):
        self.interactions.append(action_type)
        return True

    def save_ai_reply(self, *args, **kwargs):
        return True


class FakeAnti:
    def __init__(self, private_message_allowed=True):
        self.private_message_allowed = private_message_allowed

    def can_do(self, action_type):
        if action_type == "private_message":
            return self.private_message_allowed
        return True

    def should_interact(self, action_type):
        if action_type == "long_watch":
            return False
        raise AssertionError(f"interactive action should not use probability gate: {action_type}")


class FakeReplyAgent:
    def generate_reply(self, **kwargs):
        return "测试评论"

    def is_enabled(self):
        return True


def build_flow(interaction_config, private_message_allowed=True):
    flow = TikTokTaskFlow.__new__(TikTokTaskFlow)
    flow.runner = FakeRunner()
    flow.config = {
        "crawler": {
            "max_videos_per_keyword": 1,
            "max_daily_videos": 100,
            "min_video_stay": 0,
            "max_video_stay": 0,
        },
        "interaction": interaction_config,
    }
    flow.db = FakeDB()
    flow.reply_agent = FakeReplyAgent()
    flow.anti = FakeAnti(private_message_allowed=private_message_allowed)
    flow.last_share_token = None
    flow.last_description = None
    flow.current_keyword = "测试关键词"
    flow.is_stopped = False
    flow.is_paused = False
    flow._interruptible_sleep = lambda seconds: None
    flow._recover_to_video_page = lambda reason, max_back=5: True
    flow._detect_page_state = lambda: flow.runner.state
    flow._dismiss_video_context_menu_if_present = lambda: False
    return flow


class DouyinInteractionSwitchTests(unittest.TestCase):
    def run_flow(self, flow):
        with patch("dy.task_runner.BehaviorRandomizer.maybe_fast_scroll", return_value=False), \
             patch("dy.task_runner.BehaviorRandomizer.maybe_rewind", return_value=False), \
             patch("dy.task_runner.BehaviorRandomizer.maybe_browse_home_feed", return_value=False), \
             patch("dy.task_runner.BehaviorRandomizer.maybe_pause_and_think", return_value=False):
            flow._video_loop()

    def test_enabled_switches_load_each_selected_action_without_probability_gate(self):
        flow = build_flow({
            "enable_like": True,
            "enable_author_follow": True,
            "enable_private_message": True,
            "enable_video_comment": True,
            "enable_comment_lead": True,
        })

        self.run_flow(flow)

        called_actions = [call[0] for call in flow.runner.calls]
        self.assertIn(DoubleClickLikeAction, called_actions)
        self.assertIn(FollowAuthorAction, called_actions)
        self.assertIn(PostCommentAction, called_actions)
        self.assertIn(OpenCommentSectionAction, called_actions)
        self.assertIn(ProcessCommentSectionAction, called_actions)
        self.assertIn(SwipeNextVideoAction, called_actions)
        self.assertIn("private_message", flow.db.interactions)

    def test_disabled_switches_skip_unselected_actions(self):
        flow = build_flow({
            "enable_like": False,
            "enable_author_follow": False,
            "enable_private_message": True,
            "enable_video_comment": False,
            "enable_comment_lead": False,
        })

        self.run_flow(flow)

        called_actions = [call[0] for call in flow.runner.calls]
        self.assertNotIn(DoubleClickLikeAction, called_actions)
        self.assertNotIn(FollowAuthorAction, called_actions)
        self.assertNotIn(PostCommentAction, called_actions)
        self.assertNotIn(OpenCommentSectionAction, called_actions)
        self.assertNotIn(ProcessCommentSectionAction, called_actions)

    def test_private_message_limit_is_passed_into_author_action(self):
        flow = build_flow({
            "enable_like": False,
            "enable_author_follow": True,
            "enable_private_message": True,
            "enable_video_comment": False,
            "enable_comment_lead": False,
        }, private_message_allowed=False)

        self.run_flow(flow)

        follow_calls = [call for call in flow.runner.calls if call[0] is FollowAuthorAction]
        self.assertEqual(1, len(follow_calls))
        self.assertFalse(follow_calls[0][2]["private_message_allowed"])
        self.assertNotIn("private_message", flow.db.interactions)


if __name__ == "__main__":
    unittest.main()
