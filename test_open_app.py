import logging
import time
from xhs.main_controller import ScoutTaskRunner

# 配置日志输出格式，方便在控制台查看执行过程
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def test_open_tiktok():
    print("="*50)
    print("🚀 开始测试：通过调度中心打开抖音 APP")
    print("="*50)
    
    runner = None
    try:
        # 1. 实例化主控调度中心
        # 这一步会自动连接设备，并初始化 AppManager
        print("\n[步骤 1] 正在初始化调度中心并连接设备...")
        runner = ScoutTaskRunner()
        
        # 2. 调用拉起 APP 的逻辑
        print("\n[步骤 2] 准备拉起抖音 APP...")
        runner.launch_app()
        
        # 3. 验证状态
        print("\n[步骤 3] 验证 APP 前台状态...")
        is_front = runner.app_mgr.is_foreground()
        if is_front:
            print("✅ 验证成功：抖音当前已处于手机前台运行！")
            
            # 保持前台几秒钟让您能看清手机屏幕
            print("⏳ 保持画面 5 秒钟...")
            time.sleep(5)
            
            print("\n🎉 测试圆满成功！")
        else:
            print("❌ 验证失败：抖音未能成功切换到前台，请检查包名或手机状态。")

    except Exception as e:
        print(f"\n❌ 测试过程中发生错误: {e}")
        print("提示：请确保您的手机已经通过 wireless_connect.py 成功连接。")
    finally:
        # 4. 安全退出清理
        if runner:
            print("\n[步骤 4] 执行退出清理...")
            runner.shutdown()

if __name__ == "__main__":
    test_open_tiktok()
