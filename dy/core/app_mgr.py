import logging

logger = logging.getLogger(__name__)

class AppManager:
    """
    应用级生命周期管理器
    负责 APP 的启动、关闭、状态检测等通用操作，不涉及具体业务逻辑
    """
    def __init__(self, u2_device, package_name):
        self.d = u2_device
        self.package_name = package_name

    def start(self):
        """启动目标应用"""
        logger.info(f"正在启动应用: {self.package_name}")
        try:
            self.d.app_start(self.package_name)
        except Exception as e:
            logger.warning(f"普通方式启动应用失败，尝试 monkey 启动: {e}")
            self.d.app_start(self.package_name, use_monkey=True)

        if not self.wait_for_foreground(timeout=8):
            logger.warning("普通启动后应用未进入前台，尝试 monkey 启动兜底")
            self.d.app_start(self.package_name, use_monkey=True)

    def stop(self):
        """停止目标应用"""
        logger.info(f"正在停止应用: {self.package_name}")
        self.d.app_stop(self.package_name)

    def is_running(self):
        """检测应用是否在运行"""
        return self.package_name in self.d.app_list_running()

    def is_foreground(self):
        """检测应用是否处于前台活动状态"""
        current_app = self.d.app_current()
        return current_app.get('package') == self.package_name

    def clear_data(self):
        """清除应用数据 (重置状态)"""
        logger.warning(f"正在清除应用数据: {self.package_name}")
        self.d.app_clear(self.package_name)

class TikTokManager(AppManager):
    """
    抖音专用的应用管理器
    抖音的包名为 com.ss.android.ugc.aweme
    可以在这里扩展一些仅限于应用状态管理的抖音特有逻辑
    """
    def __init__(self, u2_device):
        # 默认抖音包名
        super().__init__(u2_device, package_name="com.ss.android.ugc.aweme")
        
    def wait_for_foreground(self, timeout=10):
        """等待应用进入前台"""
        logger.info(f"等待抖音进入前台，超时时间: {timeout}秒")
        return self.d.app_wait(self.package_name, front=True, timeout=timeout)
