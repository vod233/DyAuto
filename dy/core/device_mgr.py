import os
import yaml
import logging
import adbutils
from device_connect_lock import locked_u2_connect

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class DeviceManager:
    def __init__(self, serial=None):
        self.serial = serial
        self.u2_device = None
        self.config_path = os.path.join(
            os.path.dirname(os.path.dirname(__file__)),
            'config',
            'scout_settings.yaml'
        )

    def _get_last_bound_serial(self):
        """读取配置文件中记录的上一次绑定的序列号"""
        if os.path.exists(self.config_path):
            try:
                with open(self.config_path, 'r', encoding='utf-8') as f:
                    config = yaml.safe_load(f)
                    if config and 'device' in config and 'last_bound_serial' in config['device']:
                        return config['device']['last_bound_serial']
            except Exception as e:
                logging.error(f"读取配置文件失败: {e}")
        return None

    def _save_last_bound_serial(self, serial):
        """更新配置文件中的序列号"""
        config = {'device': {'last_bound_serial': serial}}
        if os.path.exists(self.config_path):
            try:
                with open(self.config_path, 'r', encoding='utf-8') as f:
                    existing_config = yaml.safe_load(f) or {}
                    if 'device' not in existing_config:
                        existing_config['device'] = {}
                    existing_config['device']['last_bound_serial'] = serial
                    config = existing_config
            except Exception:
                pass
                
        try:
            os.makedirs(os.path.dirname(self.config_path), exist_ok=True)
            with open(self.config_path, 'w', encoding='utf-8') as f:
                yaml.safe_dump(config, f, allow_unicode=True)
        except Exception as e:
            logging.error(f"保存配置文件失败: {e}")

    def connect(self):
        """连接设备的主逻辑"""
        # 1. ADB 实例校验
        devices = adbutils.adb.device_list()
        if not devices:
            raise RuntimeError("当前没有任何设备通过 ADB 连接到电脑，请先运行 scan_and_connect.py 或检查 USB 连接。")
        
        connected_serials = [d.serial for d in devices]
        logging.info(f"当前 ADB 连接设备列表: {connected_serials}")

        # 2. 序列号匹配分配
        target_serial = None
        
        # 明确传入了 --serial
        if self.serial and self.serial in connected_serials:
            target_serial = self.serial
            logging.info(f"使用传入的序列号: {target_serial}")
        else:
            # 尝试读取配置文件
            last_serial = self._get_last_bound_serial()
            if last_serial and last_serial in connected_serials:
                target_serial = last_serial
                logging.info(f"使用配置文件中上一次绑定的序列号: {target_serial}")
            else:
                # 终极兜底：强行接管 ADB 列表里的第一台设备
                target_serial = connected_serials[0]
                logging.warning(f"未匹配到指定序列号，回退接管第一台设备: {target_serial}")

        self.serial = target_serial
        self._save_last_bound_serial(self.serial)

        # 3. 挂载 UIAutomator2 引擎
        logging.info(f"正在向设备 {self.serial} 挂载 UIAutomator2 引擎...")
        self.u2_device = locked_u2_connect(self.serial)
        logging.info(f"设备 {self.serial} uiautomator2 引擎挂载成功。")
        
        return self.u2_device

    def check_health(self):
        """心跳保活检查"""
        if not self.u2_device:
            logging.error("设备未连接或引擎未挂载，无法检查健康状态。")
            return False
            
        try:
            # 通过获取屏幕状态验证设备通讯通道
            screen_on = self.u2_device.info.get('screenOn')
            logging.info(f"心跳检查 - 设备 {self.serial} 屏幕状态: {'亮起' if screen_on else '熄灭'}")
            return True
        except Exception as e:
            logging.error(f"心跳检查失败，设备 {self.serial} 通讯通道可能已断开: {e}")
            return False

class ScoutControllerHybrid:
    def __init__(self, serial=None):
        self.device_mgr = DeviceManager(serial=serial)
        # 连接成功后，返回的 u2_device 对象被赋给 self.d
        self.d = self.device_mgr.connect()
        
    def check_status(self):
        return self.device_mgr.check_health()
