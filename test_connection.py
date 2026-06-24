import logging
import sys
from dy.core.device_mgr import ScoutControllerHybrid

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def test_device_connection():
    print("="*50)
    print("🚀 开始测试抖音自动化引擎连接逻辑...")
    print("="*50)
    
    try:
        # 1. 实例化混合控制器，这将触发 DeviceManager 的 connect 逻辑
        print("[步骤 1] 正在初始化控制器并挂载 UIAutomator2 引擎...")
        controller = ScoutControllerHybrid()
        
        # 2. 检查健康状态
        print("\n[步骤 2] 正在检查设备通讯通道健康状态...")
        is_healthy = controller.check_status()
        
        if is_healthy:
            print("✅ 心跳检查成功！通讯通道畅通。")
            
            # 3. 尝试调用 u2_device 的 API 获取手机基本信息
            print("\n[步骤 3] 正在获取手机物理信息...")
            device_info = controller.d.info
            print(f"📱 手机品牌: {controller.d.device_info.get('brand')}")
            print(f"📱 手机型号: {controller.d.device_info.get('model')}")
            print(f"📐 屏幕分辨率: {device_info.get('displayWidth')} x {device_info.get('displayHeight')}")
            
            print("\n🎉 测试圆满成功！您的手机控制逻辑已经可以正常工作了！")
        else:
            print("❌ 心跳检查失败，请检查手机状态。")
            
    except Exception as e:
        print(f"\n❌ 测试过程中发生错误: {e}")
        print("请确保您已经先运行了 scan_and_connect.py，或者手机已经通过 USB/ADB 连接到了电脑。")

if __name__ == "__main__":
    test_device_connection()