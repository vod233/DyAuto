import os
import shutil
import adbutils

UIAUTOMATOR2_ASSETS = r"C:\Users\abc\AppData\Local\Programs\Python\Python312\Lib\site-packages\uiautomator2\assets"
ORIGINAL_APK = os.path.join(UIAUTOMATOR2_ASSETS, "app-uiautomator.apk")
BACKUP_APK = os.path.join(UIAUTOMATOR2_ASSETS, "app-uiautomator.apk.bak")
TECH_APK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "app-uiautomator-tech.apk")
PACKAGE_NAME = "com.github.uiautomator"


def backup_and_replace():
    if not os.path.exists(TECH_APK):
        print(f"错误: 找不到科技风APK文件: {TECH_APK}")
        return False

    if not os.path.exists(BACKUP_APK):
        shutil.copy2(ORIGINAL_APK, BACKUP_APK)
        print(f"已备份原始APK到: {BACKUP_APK}")
    else:
        print(f"备份已存在: {BACKUP_APK}")

    shutil.copy2(TECH_APK, ORIGINAL_APK)
    print(f"已替换uiautomator2库中的APK")
    print(f"  原始大小: {os.path.getsize(BACKUP_APK)} bytes")
    print(f"  新大小: {os.path.getsize(ORIGINAL_APK)} bytes")
    return True


def install_to_device(device):
    print(f"\n正在安装到设备: {device.serial}")
    try:
        output = device.shell(["pm", "list", "packages", PACKAGE_NAME])
        if PACKAGE_NAME in output:
            print(f"  卸载旧版本...")
            device.uninstall(PACKAGE_NAME)

        print(f"  安装新版本...")
        device.install(TECH_APK, nolaunch=True)
        print(f"  安装成功!")

        output = device.shell(["pm", "list", "packages", PACKAGE_NAME])
        if PACKAGE_NAME in output:
            print(f"  验证: 包已存在")
            return True
        else:
            print(f"  验证失败: 包不存在")
            return False
    except Exception as e:
        print(f"  安装失败: {e}")
        return False


def main():
    print("=" * 60)
    print("科技风APK安装工具")
    print("=" * 60)

    if not backup_and_replace():
        return

    devices = adbutils.adb.device_list()
    if not devices:
        print("\n错误: 没有检测到已连接的设备")
        print("请先通过USB连接手机，并开启USB调试模式")
        return

    print(f"\n检测到 {len(devices)} 台设备:")
    for d in devices:
        print(f"  - {d.serial}")

    success_count = 0
    for device in devices:
        if install_to_device(device):
            success_count += 1

    print("\n" + "=" * 60)
    print(f"安装完成: 成功 {success_count}/{len(devices)} 台")
    print("=" * 60)


if __name__ == "__main__":
    main()
