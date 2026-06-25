import logging
import yaml
import os
from .core.device_mgr import ScoutControllerHybrid
from .core.app_mgr import TikTokManager

# 导入所有具体的 Action
from .actions.navigation import (
    EnsureHomeAction, EnterSearchAction, ApplyFiltersAction,
    EnterFirstVideoAction, SwipeNextVideoAction, ResetToSearchAction
)
from .actions.interaction import (
    DoubleClickLikeAction, FollowAuthorAction, GetCurrentVideoLinkAction
)
from .actions.commenting import (
    PostCommentAction, OpenCommentSectionAction, ProcessCommentSectionAction
)

logger = logging.getLogger(__name__)


def _load_yaml_file(path):
    if not path or not os.path.exists(path):
        return {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f) or {}
    except Exception as exc:
        logger.warning(f"读取配置文件失败 {path}: {exc}")
        return {}

class ScoutTaskRunner:
    """
    核心调度中心（任务执行器）
    负责串联起「设备连接」、「APP 生命周期管理」以及「具体动作执行」三部分
    作为整个业务的主入口使用
    """
    def __init__(self, serial=None, config_path=None):
        logger.info("初始化任务调度中心...")
        
        # 0. 读取配置
        primary_config = _load_yaml_file(config_path)
        config_dir = os.path.dirname(config_path) if config_path else os.path.join(
            os.path.dirname(__file__), "config"
        )
        user_config = _load_yaml_file(os.path.join(config_dir, "user_settings.yaml"))
        api_config = _load_yaml_file(os.path.join(config_dir, "api_settings.yaml"))

        self.config = dict(primary_config)

        search_config = user_config.get("search") or primary_config.get("search") or api_config.get("search")
        crawler_config = user_config.get("crawler") or primary_config.get("crawler") or api_config.get("crawler")
        ai_reply_config = api_config.get("ai_reply") or primary_config.get("ai_reply") or user_config.get("ai_reply")

        if search_config:
            self.config["search"] = search_config
        if crawler_config:
            self.config["crawler"] = crawler_config
        if ai_reply_config:
            self.config["ai_reply"] = ai_reply_config

        # 1. 设备连接层
        self.controller = ScoutControllerHybrid(serial=serial)
        self.device = self.controller.d
        
        # 2. 应用管理层
        self.app_mgr = TikTokManager(self.device)
        
        # 检查设备健康度
        if not self.controller.check_status():
            raise RuntimeError("设备通讯通道异常，无法初始化调度中心。请检查连接状态。")
            
        logger.info("设备通讯正常，引擎挂载完毕。")

    def run_action(self, action_class, *args, **kwargs):
        """
        动作执行引擎
        接收一个继承自 BaseAction 的类，实例化并执行。
        实现了业务的解耦和高扩展性。
        """
        logger.info(f"调度器开始装载动作: {action_class.__name__}")
        
        # 依赖注入：将设备实例、APP管理器和配置传入动作类中
        action_instance = action_class(
            u2_device=self.device,
            app_manager=self.app_mgr,
            config=self.config,
            **kwargs
        )
        
        # 调用 BaseAction 封装的标准 perform 方法
        return action_instance.perform(*args)

    def launch_app(self):
        """主控层封装的 APP 拉起逻辑"""
        logger.info("调度中心正在拉起抖音 APP...")
        self.app_mgr.start()
        # 等待其完全启动
        if not self.app_mgr.wait_for_foreground():
            current_app = self.device.app_current()
            raise RuntimeError(f"抖音未进入前台，当前前台应用: {current_app}")
        
        # 确保回到首页并处理可能弹出的青少年模式等弹窗
        if not self.run_action(EnsureHomeAction):
            raise RuntimeError("抖音首页未就绪，无法继续执行任务")
        logger.info("抖音启动完成，准备就绪。")

    def shutdown(self):
        """任务结束后的清理逻辑"""
        logger.info("任务执行完毕，清理资源...")
        # 可以选择停止 APP 或是保留当前界面，取决于业务需求
        # self.app_mgr.stop()
        logger.info("资源清理完毕，安全退出。")

