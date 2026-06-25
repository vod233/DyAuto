import os
import yaml
import logging
import time
import concurrent.futures

from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env"))
from dy.task_runner import TikTokTaskFlow
from dy.logger_config import setup_logger
from dy.multi_device import select_devices_interactively
from social_license import DEFAULT_LICENSE_SERVER_URL, LicenseError, mask_license_key, verify_license

# 初始化日志记录器，这行代码会自动创建 logs 文件夹和日期时间命名的日志文件
setup_logger()

def get_user_input(prompt_text, default_val):
    print(f"\n{prompt_text}")
    default_str = "未设置" if not default_val else " | ".join(default_val)
    print(f"【当前配置】: {default_str}")
    user_in = input("请输入新内容 (多个用逗号分隔，直接回车保留当前配置): ").strip()
    
    if not user_in:
        return default_val
    return [item.strip() for item in user_in.replace('，', ',').split(',') if item.strip()]


def get_text_input(prompt_text, default_val=""):
    print(f"\n{prompt_text}")
    print(f"【当前配置】: {default_val or '未设置'}")
    user_in = input("请输入新内容 (直接回车保留当前配置): ").strip()
    return user_in or default_val

def main():
    print("="*60)
    print("🚀 抖音自动化任务 - 交互式控制台")
    print("="*60)
    
    config_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "dy", "config", "user_settings.yaml"
    )
    api_config_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "dy", "config", "api_settings.yaml"
    )
    
    # 默认基础配置
    config = {
        "search": {"keywords": ["AI获客"], "sort_by": "latest"},
        "ai_reply": {
            "enabled": True,
            "mode": "cloud",
            "cloud_base_url": DEFAULT_LICENSE_SERVER_URL,
            "base_url": "",
            "api_key": "",
            "model": "deepseek-v4-flash",
            "temperature": 0.7,
            "max_tokens": 120,
            "license": {
                "server_url": DEFAULT_LICENSE_SERVER_URL,
                "key": "",
            },
        },
        "crawler": {
            "max_videos_per_keyword": 5,
            "max_daily_videos": 100
        }
    }
    
    # 尝试加载历史配置
    if os.path.exists(config_path):
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                loaded = yaml.safe_load(f)
                if loaded:
                    for k, v in loaded.items():
                        if isinstance(v, dict) and k in config:
                            config[k].update(v)
                        else:
                            config[k] = v
        except Exception as e:
            print(f"加载历史配置失败: {e}")

    if os.path.exists(api_config_path):
        try:
            with open(api_config_path, 'r', encoding='utf-8') as f:
                loaded_api = yaml.safe_load(f) or {}
                if isinstance(loaded_api.get("ai_reply"), dict):
                    config["ai_reply"].update(loaded_api["ai_reply"])
        except Exception as e:
            print(f"加载 AI 授权配置失败: {e}")
            
    # 1. 用户自定义搜索关键词
    config["search"]["keywords"] = get_user_input(
        "1. 您想搜索什么内容？(搜索关键词)", 
        config["search"].get("keywords", [])
    )
    
    # 2. 云端授权配置
    license_cfg = config["ai_reply"].setdefault("license", {})
    current_mask = mask_license_key(license_cfg.get("key", ""))
    print(f"\n2. 请输入客户授权码")
    print(f"【当前配置】: {current_mask or '未设置'}")
    new_license = input("请输入完整授权码 (直接回车保留当前配置): ").strip()
    if new_license:
        license_cfg["key"] = new_license

    license_cfg["server_url"] = get_text_input(
        "3. 授权服务器地址",
        license_cfg.get("server_url", DEFAULT_LICENSE_SERVER_URL)
    )
    config["ai_reply"]["mode"] = "cloud"
    config["ai_reply"]["cloud_base_url"] = license_cfg["server_url"]
    config["ai_reply"]["base_url"] = ""
    config["ai_reply"]["api_key"] = ""
    config["ai_reply"]["model"] = "deepseek-v4-flash"

    try:
        auth_info = verify_license(license_cfg.get("key", ""), license_cfg.get("server_url", DEFAULT_LICENSE_SERVER_URL))
        print(f"✅ 授权验证通过：{auth_info.get('customer_name', '')}，剩余积分 {auth_info.get('balance_credits', 0)}")
    except LicenseError as exc:
        print(f"❌ 授权验证失败：{exc}")
        return
    
    # 保存最新配置
    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    with open(config_path, 'w', encoding='utf-8') as f:
        user_config = {k: v for k, v in config.items() if k != "ai_reply"}
        yaml.safe_dump(user_config, f, allow_unicode=True)
    os.makedirs(os.path.dirname(api_config_path), exist_ok=True)
    with open(api_config_path, 'w', encoding='utf-8') as f:
        yaml.safe_dump({"ai_reply": config["ai_reply"]}, f, allow_unicode=True)
        
    # 5. 选择要执行任务的设备
    selected_devices = select_devices_interactively()
    if not selected_devices:
        print("操作已取消或无设备可用，退出程序。")
        return
        
    print("\n" + "="*60)
    print(f"✅ 配置已更新并保存！")
    print(f"🎯 将对以下 {len(selected_devices)} 台设备并发执行任务: {', '.join(selected_devices)}")
    print("="*60)
    print("等待 3 秒后启动...")
    time.sleep(3)
    
    # 6. 并发启动任务
    def run_on_device(serial):
        logging.info(f"==> 启动设备任务: {serial}")
        try:
            task_flow = TikTokTaskFlow(serial=serial, config_path=config_path)
            task_flow.start()
        except Exception as e:
            logging.error(f"设备 {serial} 执行异常: {e}")
            
    with concurrent.futures.ThreadPoolExecutor(max_workers=len(selected_devices)) as executor:
        futures = {executor.submit(run_on_device, serial): serial for serial in selected_devices}
        for future in concurrent.futures.as_completed(futures):
            serial = futures[future]
            try:
                future.result()
                logging.info(f"<== 设备 {serial} 任务执行完毕")
            except Exception as exc:
                logging.error(f"设备 {serial} 产生未处理异常: {exc}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n用户取消了任务。")
