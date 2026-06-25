import unittest
from unittest.mock import patch

from dy.anti_detection import HumanGesture


class FakeDevice:
    def __init__(self):
        self.swipes = []
        self.swipe_points_calls = []

    def swipe(self, sx, sy, ex, ey, duration=None):
        self.swipes.append((sx, sy, ex, ey, duration))

    def swipe_points(self, points, duration=None):
        self.swipe_points_calls.append((points, duration))


class DouyinGestureSafetyTests(unittest.TestCase):
    def test_curve_swipe_uses_single_swipe_to_avoid_video_long_press_menu(self):
        device = FakeDevice()

        with patch("dy.anti_detection.random.randint", return_value=0):
            HumanGesture.human_swipe_with_curve(device, 500, 1800, 500, 400, duration=0.2)

        self.assertEqual(1, len(device.swipes))
        self.assertEqual([], device.swipe_points_calls)
        self.assertEqual((500, 1800, 500, 400, 0.2), device.swipes[0])


if __name__ == "__main__":
    unittest.main()
