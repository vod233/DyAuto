import argparse
import os
import subprocess
from dataclasses import dataclass, asdict

import yaml

from device_connect_lock import locked_u2_connect

try:
    from adbutils import adb_path

    ADB_BIN = adb_path()
except ImportError:
    ADB_BIN = "adb"


PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
SCOUT_CONFIG_PATHS = [
    os.path.join(PROJECT_ROOT, "xhs", "config", "scout_settings.yaml"),
    os.path.join(PROJECT_ROOT, "dy", "config", "scout_settings.yaml"),
]


@dataclass
class UsbDevice:
    serial: str
    status: str
    detail: str = ""
    model: str = ""
    product: str = ""
    transport_id: str = ""
    u2_ready: bool = False
    message: str = ""


def run_adb(args, timeout=15):
    try:
        result = subprocess.run(
            [ADB_BIN, *args],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="ignore",
            timeout=timeout,
        )
        return result.returncode, result.stdout.strip(), result.stderr.strip()
    except FileNotFoundError:
        return 1, "", f"未找到 ADB: {ADB_BIN}"
    except subprocess.TimeoutExpired:
        return 1, "", "ADB 命令执行超时，请重插 USB 线或重启 ADB。"


def parse_devices_output(output):
    devices = []
    for raw_line in output.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("List of devices attached"):
            continue

        parts = line.split()
        if len(parts) < 2:
            continue

        serial, status = parts[0], parts[1]
        detail_items = {}
        for item in parts[2:]:
            if ":" in item:
                key, value = item.split(":", 1)
                detail_items[key] = value

        devices.append(
            UsbDevice(
                serial=serial,
                status=status,
                detail=" ".join(parts[2:]),
                model=detail_items.get("model", ""),
                product=detail_items.get("product", ""),
                transport_id=detail_items.get("transport_id", ""),
            )
        )
    return devices


def is_usb_serial(serial):
    return (
        ":" not in serial
        and not serial.startswith("emulator-")
        and "._adb-tls-" not in serial
        and not serial.endswith("._tcp")
    )


def save_last_bound_serial(serial):
    for path in SCOUT_CONFIG_PATHS:
        config = {}
        if os.path.exists(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    config = yaml.safe_load(f) or {}
            except Exception:
                config = {}

        config.setdefault("device", {})
        config["device"]["last_bound_serial"] = serial

        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            yaml.safe_dump(config, f, allow_unicode=True, sort_keys=False)


def verify_uiautomator2(serial):
    try:
        device = locked_u2_connect(serial)
        info = device.info
        return True, f"UIAutomator2 已就绪，屏幕 {info.get('displayWidth')}x{info.get('displayHeight')}"
    except Exception as exc:
        return False, f"ADB 已连接，但 UIAutomator2 检查失败: {exc}"


def detect_usb_devices(verify_u2=True, persist=True):
    start_code, _, start_error = run_adb(["start-server"])
    if start_code != 0:
        return {
            "success": False,
            "message": f"ADB 启动失败: {start_error}",
            "adb": ADB_BIN,
            "devices": [],
            "ready_devices": [],
            "needs_action": [],
            "stderr": start_error,
        }

    list_code, stdout, stderr = run_adb(["devices", "-l"])
    if list_code != 0:
        return {
            "success": False,
            "message": f"读取 USB 设备失败: {stderr or stdout}",
            "adb": ADB_BIN,
            "devices": [],
            "ready_devices": [],
            "needs_action": [],
            "stderr": stderr,
        }

    devices = parse_devices_output(stdout)
    usb_devices = [device for device in devices if is_usb_serial(device.serial)]

    for device in usb_devices:
        if device.status == "device":
            if verify_u2:
                device.u2_ready, device.message = verify_uiautomator2(device.serial)
            else:
                device.u2_ready = True
                device.message = "ADB 设备在线"

            if device.u2_ready and persist:
                save_last_bound_serial(device.serial)
        elif device.status == "unauthorized":
            device.message = "手机未授权，请解锁手机并点击“允许 USB 调试”。"
        elif device.status == "offline":
            device.message = "设备离线，请重插 USB 线，或关闭再开启 USB 调试。"
        else:
            device.message = f"设备状态异常: {device.status}"

    ready_devices = [device.serial for device in usb_devices if device.status == "device" and device.u2_ready]
    needs_action = [device.serial for device in usb_devices if device.status != "device" or not device.u2_ready]

    if ready_devices:
        message = f"检测到 {len(ready_devices)} 台可用 USB 设备。"
        success = True
    elif usb_devices:
        message = "检测到 USB 设备，但还不能控制。请按提示处理授权或离线状态。"
        success = False
    else:
        message = "未检测到 USB 设备。请检查数据线、USB 调试、手机授权和驱动。"
        success = False

    return {
        "success": success,
        "message": message,
        "adb": ADB_BIN,
        "devices": [asdict(device) for device in usb_devices],
        "ready_devices": ready_devices,
        "needs_action": needs_action,
        "stderr": stderr,
    }


def main():
    parser = argparse.ArgumentParser(description="检测 USB ADB 设备并保存最近绑定设备。")
    parser.add_argument("--no-u2-check", action="store_true", help="只检测 ADB，不检查 UIAutomator2。")
    parser.add_argument("--no-save", action="store_true", help="不写入 scout_settings.yaml。")
    args = parser.parse_args()

    result = detect_usb_devices(verify_u2=not args.no_u2_check, persist=not args.no_save)
    print(result["message"])
    for device in result["devices"]:
        model = f" model={device['model']}" if device["model"] else ""
        print(f"- {device['serial']} [{device['status']}]{model}: {device['message']}")

    if not result["devices"]:
        print("处理建议: 使用支持数据传输的 USB 线，开启开发者选项和 USB 调试，并在手机弹窗中允许调试。")


if __name__ == "__main__":
    main()
