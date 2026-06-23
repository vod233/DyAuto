import subprocess
import sys
import os

try:
    from adbutils import adb_path
    ADB_BIN = adb_path()
except ImportError:
    print("警告: 未检测到 adbutils，将尝试使用系统默认的 adb 命令。")
    ADB_BIN = "adb"

def run_cmd(args):
    """运行系统命令并返回输出"""
    cmd_str = " ".join(args)
    print(f"\n正在执行: {cmd_str}")
    try:
        # 使用列表形式调用，避免 shell=True 带来的路径转义问题
        result = subprocess.run(args, capture_output=True, text=True, encoding='utf-8', errors='ignore')
        if result.stdout.strip():
            print(f"输出: {result.stdout.strip()}")
        if result.stderr.strip():
            print(f"提示: {result.stderr.strip()}")
        return result.returncode == 0
    except Exception as e:
        print(f"执行命令时发生异常: {e}")
        return False

def pair_device():
    print("\n--- 步骤 1：配对设备 ---")
    print("请在手机的「开发者选项 -> 无线调试」中，点击「使用配对码配对设备」。")
    print("此时手机屏幕上会显示一个 IP地址、端口号 以及 6位配对码。")
    
    ip_port = input("\n请输入手机显示的 IP地址和端口 (格式: 192.168.x.x:端口): ").strip()
    if not ip_port:
        return
        
    code = input("请输入 6位配对码: ").strip()
    if not code:
        return
        
    run_cmd([ADB_BIN, "pair", ip_port, code])

def connect_device():
    print("\n--- 步骤 2：连接设备 ---")
    print("配对成功后，请返回手机的「无线调试」主界面。")
    print("在「IP地址和端口」一栏，会显示用于连接的端口（注意：通常与配对时的端口不同！）。")
    
    ip_port = input("\n请输入用于连接的 IP地址和端口 (格式: 192.168.x.x:端口): ").strip()
    if not ip_port:
        return
        
    if run_cmd([ADB_BIN, "connect", ip_port]):
        print("\n✅ 连接命令已发送，您可以运行 python test_connection.py 来验证引擎挂载状态了！")

def show_devices():
    print("\n--- 当前已连接设备列表 ---")
    run_cmd([ADB_BIN, "devices"])

def main():
    while True:
        print("\n" + "="*40)
        print("🚀 Android 11+ 无线调试连接助手")
        print("="*40)
        print("1. 使用配对码配对新设备 (adb pair)")
        print("2. 连接已配对的设备 (adb connect)")
        print("3. 查看当前已连接的设备 (adb devices)")
        print("4. 退出程序")
        print("="*40)
        
        choice = input("请选择操作 (1/2/3/4): ").strip()
        
        if choice == '1':
            pair_device()
        elif choice == '2':
            connect_device()
        elif choice == '3':
            show_devices()
        elif choice == '4':
            print("退出程序。")
            break
        else:
            print("无效的选择，请重新输入。")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n退出程序。")
        sys.exit(0)
