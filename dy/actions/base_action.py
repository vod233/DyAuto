from abc import ABC, abstractmethod
import logging
import random

logger = logging.getLogger(__name__)

class BaseAction(ABC):
    """
    动作基类：所有的具体业务逻辑（如刷视频、点赞、搜索、关注）都应该继承此类。
    实现了业务与设备的解耦，保证扩展性。
    集成防风控引擎，提供人性化操作接口。
    """
    def __init__(self, u2_device, app_manager=None, config=None, **kwargs):
        """
        初始化动作类
        :param u2_device: 已经连接好的 UIAutomator2 设备实例 (d)
        :param app_manager: (可选) 应用生命周期管理器，用于辅助判断 APP 状态
        :param config: (可选) 配置字典
        """
        self.d = u2_device
        self.app = app_manager
        self.config = config or {}
        
        # 将剩余的 kwargs 保存为动作的动态属性，便于如 commenter_keywords 等参数传递
        for k, v in kwargs.items():
            setattr(self, k, v)
        
        # 默认设置全局操作超时时间 (可被子类重写)
        self.d.implicitly_wait(10.0)

        # 初始化防风控引擎
        from ..anti_detection import AntiDetectionEngine
        self.anti = AntiDetectionEngine(config=self.config)

    def human_swipe(self, sx, sy, ex, ey, duration=None):
        """人性化滑动（贝塞尔曲线 + 随机抖动）"""
        self.anti.human_swipe(self.d, sx, sy, ex, ey, duration)

    def human_swipe_curve(self, sx, sy, ex, ey, duration=None):
        """贝塞尔曲线滑动"""
        self.anti.human_swipe_curve(self.d, sx, sy, ex, ey, duration)

    def human_click(self, x, y, jitter_range=8):
        """人性化点击（坐标随机抖动）"""
        self.anti.human_click(self.d, x, y, jitter_range)

    def human_double_click(self, x, y, jitter_range=10):
        """人性化双击"""
        self.anti.human_double_click(self.d, x, y, jitter_range)

    def human_sleep(self, sleep_type='normal', custom_range=None):
        """人性化等待"""
        return self.anti.sleep(sleep_type, custom_range)

    def should_interact(self, action_type):
        """概率决策是否执行互动"""
        return self.anti.should_interact(action_type)

    def can_do(self, action_type):
        """检查每日限额"""
        return self.anti.can_do(action_type)

    @abstractmethod
    def execute(self, *args, **kwargs):
        """
        [抽象方法] 执行具体动作的入口
        子类必须实现此方法，完成真正的业务逻辑流程
        """
        pass

    def check_preconditions(self):
        """
        [钩子方法] 执行前的环境预检
        例如：判断应用是否在前台、判断是否在正确的页面等
        如果预检失败可以抛出异常或返回 False
        """
        if self.app and not self.app.is_foreground():
            logger.warning(f"应用 {self.app.package_name} 不在前台，尝试拉起...")
            self.app.start()
            self.app.wait_for_foreground()
        return True
        
    def perform(self, *args, **kwargs):
        """
        [主入口] 提供给外部调用的标准接口，包含了前置检查和异常捕获机制
        """
        logger.info(f"==> 准备执行动作: [{self.__class__.__name__}]")
        
        try:
            # 1. 前置检查
            if not self.check_preconditions():
                logger.error(f"动作 [{self.__class__.__name__}] 前置检查失败，终止执行。")
                return False
                
            # 2. 执行具体逻辑
            result = self.execute(*args, **kwargs)
            
            logger.info(f"<== 动作执行完成: [{self.__class__.__name__}]")
            return result
            
        except InterruptedError:
            # 允许中断异常向上传递，不要被当做普通执行异常吞掉
            raise
        except Exception as e:
            logger.error(f"执行动作 [{self.__class__.__name__}] 时发生未捕获异常: {e}", exc_info=True)
            # 在这里可以扩展异常后的截图、转储日志等逻辑
            return False
