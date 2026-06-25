"""
替换 uiautomator2 库中的 APK，推送到手机并安装
"""
import shutil
import hashlib
import os
import adbutils

UIAUTOMATOR2_ASSETS = r"C:\Users\abc\AppData\Local\Programs\Python\Python312\Lib\site-packages\uiautomator2\assets"
ORIGINAL_APK = os.path.join(UIAUTOMATOR2_ASSETS, "app-uiautomator.apk")
BACKUP_APK = os.path.join(UIAUTOMATOR2_ASSETS, "app-uiautomator.apk.bak")
TECH_APK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "app-uiautomator-tech.apk")
PACKAGE_NAME = "com.github.uiautomator"
TEST_PACKAGE = "com.github.uiautomator.test"


def md5(path):
    h = hashlib.md5()
    with open(path, 'rb') as f:
        h.update(f.read())
    return h.hexdigest()


def replace_lib_apk():
    if not os.path.exists(TECH_APK):
        print(f"错误: 找不到科技风APK: {TECH_APK}")
        return False

    if not os.path.exists(BACKUP_APK):
        shutil.copy2(ORIGINAL_APK, BACKUP_APK)
        print(f"已备份原始APK")
    else:
        print(f"备份已存在")

    shutil.copy2(TECH_APK, ORIGINAL_APK)
    print(f"已替换库APK")
    print(f"  新APK大小: {os.path.getsize(ORIGINAL_APK)} bytes")
    print(f"  MD5匹配: {md5(ORIGINAL_APK) == md5(TECH_APK)}")
    return True


def install_to_device(device):
    serial = device.serial
    print(f"\n{'='*50}")
    print(f"设备: {serial}")
    print(f"{'='*50}")

    # 先卸载旧版本（包括 test 包）
    for pkg in [TEST_PACKAGE, PACKAGE_NAME]:
        result = device.shell(["pm", "uninstall", pkg])
        print(f"  卸载 {pkg}: {result.strip()}")

    # 推送 APK 到手机
    remote_path = "/data/local/tmp/app-uiautomator-tech.apk"
    print(f"  推送APK到手机...")
    device.sync.push(TECH_APK, remote_path)
    print(f"  已推送到: {remote_path}")

    # 用 pm install 安装
    print(f"  安装中...")
    result = device.shell(["pm", "install", "-r", "-t", "-d", "--user", "0", remote_path])
    print(f"  安装结果: {result.strip()}")

    # 验证
    result = device.shell(["pm", "list", "packages", PACKAGE_NAME])
    if PACKAGE_NAME in result:
        print(f"  验证: 安装成功!")
        # 获取应用信息
        info = device.shell(["dumpsys", "package", PACKAGE_NAME])
        for line in info.split('\n'):
            if 'versionName' in line or 'applicationLabel' in line:
                print(f"  {line.strip()}")
        return True
    else:
        print(f"  验证: 安装失败!")
        return False


def main():
    print("=" * 60)
    print("科技风APK - 替换库文件并安装到手机")
    print("=" * 60)

    if not replace_lib_apk():
        return

    devices = adbutils.adb.device_list()
    if not devices:
        print("\n没有检测到已连接的设备")
        print("请连接手机并开启USB调试后重新运行")
        return

    print(f"\n检测到 {len(devices)} 台设备:")
    for d in devices:
        print(f"  - {d.serial}")

    success = 0
    for device in devices:
        if install_to_device(device):
            success += 1

    print(f"\n{'='*60}")
    print(f"完成: 成功 {success}/{len(devices)} 台")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
