import adbutils
import logging

logger = logging.getLogger(__name__)

def get_connected_devices():
    """获取当前通过 ADB 连接的所有真实设备序列号列表"""
    try:
        devices = adbutils.adb.device_list()
        valid_devices = []
        for d in devices:
            # 过滤掉局域网 mDNS (ZeroConf) 广播的虚拟设备名
            if "._adb-tls-" not in d.serial and not d.serial.endswith("._tcp"):
                valid_devices.append(d.serial)
        return valid_devices
    except Exception as e:
        logger.error(f"获取设备列表失败: {e}")
        return []

def select_devices_interactively():
    """在控制台让用户交互式选择要操作的设备"""
    devices = get_connected_devices()
    
    if not devices:
        print("\n❌ 未检测到任何连接的设备！")
        print("请先通过 USB 连接手机，或运行 wireless_connect.py / scan_and_connect.py 进行无线连接。")
        return []
        
    print("\n" + "="*40)
    print("📱 已连接的设备列表")
    print("="*40)
    
    for idx, serial in enumerate(devices, 1):
        print(f" [{idx}] {serial}")
        
    print(" [0] 全部设备")
    print("="*40)
    
    while True:
        choice = input("\n请选择要执行任务的设备编号 (多个设备请用逗号分隔，如 '1,3'，输入 '0' 选择全部): ").strip()
        if not choice:
            continue
            
        if choice == '0':
            return devices
            
        selected_serials = []
        try:
            indices = [int(x.strip()) for x in choice.replace('，', ',').split(',')]
            for idx in indices:
                if 1 <= idx <= len(devices):
                    selected_serials.append(devices[idx-1])
                else:
                    print(f"⚠️ 警告: 编号 {idx} 超出范围，将被忽略。")
            
            if selected_serials:
                return list(set(selected_serials))  # 去重返回
            else:
                print("没有选择任何有效的设备，请重新输入。")
        except ValueError:
            print("❌ 输入格式错误，请输入数字编号，多个编号用逗号分隔。")
