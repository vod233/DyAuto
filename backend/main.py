import sys
import os
import yaml
import logging
import concurrent.futures
import threading
import time

from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env"), override=True)
from contextlib import asynccontextmanager
from fastapi import FastAPI, BackgroundTasks, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse

# 确保能找到项目根目录下的模块
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.append(PROJECT_ROOT)

from xhs.multi_device import get_connected_devices
from xhs.task_runner import TikTokTaskFlow
from xhs.db_manager import DBManager
from xhs.logger_config import setup_logger, MEMORY_LOGS
from dy.task_runner import TikTokTaskFlow as DouyinTaskFlow
from wireless_connect import run_cmd, ADB_BIN
from usb_connect import detect_usb_devices

from backend.schemas import AppConfig, TaskStartRequest, TaskResponse, DeviceConnectRequest, DevicePairRequest, LicenseVerifyRequest
from social_license import DEFAULT_LICENSE_SERVER_URL, LicenseError, mask_license_key, verify_license

# 初始化全局日志
setup_logger()

# ======================== 全局并发控制 ========================
# 任务状态字典与运行任务字典的线程锁
_task_status_lock = threading.Lock()
_task_status = {}
# 保存正在运行的任务实例引用，以便可以调用 stop()
_running_tasks = {}
_stop_requested = set()
# 全局线程池，限制最大并发设备数
MAX_CONCURRENT_DEVICES = 10
_task_executor = concurrent.futures.ThreadPoolExecutor(
    max_workers=MAX_CONCURRENT_DEVICES,
    thread_name_prefix="device_task"
)

# 为了兼容旧代码，创建 task_status 和 running_tasks 的代理属性
class _LockedDict:
    """线程安全的字典代理"""
    def __init__(self, lock, data):
        self._lock = lock
        self._data = data

    def get(self, key, default=None):
        with self._lock:
            return self._data.get(key, default)

    def __getitem__(self, key):
        with self._lock:
            return self._data[key]

    def __setitem__(self, key, value):
        with self._lock:
            self._data[key] = value

    def __delitem__(self, key):
        with self._lock:
            del self._data[key]

    def __contains__(self, key):
        with self._lock:
            return key in self._data

    def items(self):
        with self._lock:
            return list(self._data.items())

    def values(self):
        with self._lock:
            return list(self._data.values())

    def keys(self):
        with self._lock:
            return list(self._data.keys())

    def pop(self, key, *args):
        with self._lock:
            return self._data.pop(key, *args)

# 为了向后兼容，我们保留原始字典但用函数封装操作
# 实际使用时通过 get_task_status / set_task_status / del_task_status 函数访问
def get_task_status(serial, default=None):
    with _task_status_lock:
        return _task_status.get(serial, default)

def set_task_status(serial, status):
    with _task_status_lock:
        _task_status[serial] = status

def del_task_status(serial):
    with _task_status_lock:
        if serial in _task_status:
            del _task_status[serial]

def get_running_task(serial):
    with _task_status_lock:
        return _running_tasks.get(serial)

def set_running_task(serial, task):
    with _task_status_lock:
        _running_tasks[serial] = task

def del_running_task(serial):
    with _task_status_lock:
        if serial in _running_tasks:
            del _running_tasks[serial]

def get_all_running_tasks():
    with _task_status_lock:
        return list(_running_tasks.items())

def is_task_running(serial):
    with _task_status_lock:
        status = _task_status.get(serial, {}).get("status")
        return status in {"queued", "starting", "running", "paused"}

def set_task_queued(serial, platform):
    set_task_status(serial, {"status": "queued", "error": None, "platform": platform})

def request_task_stop(serial):
    with _task_status_lock:
        _stop_requested.add(serial)

def clear_task_stop_request(serial):
    with _task_status_lock:
        _stop_requested.discard(serial)

def is_task_stop_requested(serial):
    with _task_status_lock:
        return serial in _stop_requested

@asynccontextmanager
async def lifespan(app: FastAPI):
    # 启动时执行
    yield
    # 关闭时执行：优雅地清理所有后台正在运行的设备任务
    logging.info("接收到关闭信号，正在停止所有后台设备任务...")
    for serial, task in get_all_running_tasks():
        try:
            task.stop()
            logging.info(f"已发送停止信号给设备: {serial}")
        except Exception as e:
            logging.error(f"停止设备 {serial} 时出错: {e}")
    # 关闭线程池
    _task_executor.shutdown(wait=True)
    logging.info("线程池已关闭。")

app = FastAPI(title="抖音自动化后端 API", version="1.0.0", lifespan=lifespan)

# 允许跨域请求，方便未来 Streamlit 前端调用
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 小红书配置路径
XHS_USER_CONFIG_PATH = os.path.join(PROJECT_ROOT, "xhs", "config", "user_settings.yaml")
XHS_API_CONFIG_PATH = os.path.join(PROJECT_ROOT, "xhs", "config", "api_settings.yaml")

# 抖音配置路径
DY_USER_CONFIG_PATH = os.path.join(PROJECT_ROOT, "dy", "config", "user_settings.yaml")
DY_API_CONFIG_PATH = os.path.join(PROJECT_ROOT, "dy", "config", "api_settings.yaml")

db_manager = DBManager()


def _load_yaml_file(path):
    if not os.path.exists(path):
        return {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f) or {}
    except Exception as exc:
        logging.warning(f"读取配置文件失败 {path}: {exc}")
        return {}


def _save_yaml_file(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        yaml.safe_dump(data, f, allow_unicode=True, sort_keys=False)


def _normalize_sort_mode(sort_by):
    if sort_by == "most_liked":
        return "comprehensive"
    if sort_by in ("latest", "comprehensive"):
        return sort_by
    return "latest"


# ======================== 小红书配置逻辑 ========================

def _build_xhs_split_config():
    user_data = _load_yaml_file(XHS_USER_CONFIG_PATH)
    api_data = _load_yaml_file(XHS_API_CONFIG_PATH)

    normalized_user_data = {
        key: value for key, value in user_data.items()
        if key != "ai_reply"
    }
    normalized_api_data = {
        key: value for key, value in api_data.items()
        if key not in ("search", "crawler")
    }

    search_data = user_data.get("search") if isinstance(user_data.get("search"), dict) else {}
    crawler_data = user_data.get("crawler") if isinstance(user_data.get("crawler"), dict) else {}
    ai_reply_data = api_data.get("ai_reply") if isinstance(api_data.get("ai_reply"), dict) else {}

    if not search_data and isinstance(api_data.get("search"), dict):
        search_data = api_data["search"]
    if not crawler_data and isinstance(api_data.get("crawler"), dict):
        crawler_data = api_data["crawler"]
    if not ai_reply_data and isinstance(user_data.get("ai_reply"), dict):
        ai_reply_data = user_data["ai_reply"]

    if search_data:
        if "sort_by" in search_data:
            search_data = dict(search_data)
            search_data["sort_by"] = _normalize_sort_mode(search_data.get("sort_by"))
        normalized_user_data["search"] = search_data
    if crawler_data:
        normalized_user_data["crawler"] = crawler_data
    if ai_reply_data:
        normalized_api_data["ai_reply"] = ai_reply_data

    return normalized_user_data, normalized_api_data


def _load_xhs_runtime_config():
    normalized_user_data, normalized_api_data = _build_xhs_split_config()
    current_user_data = _load_yaml_file(XHS_USER_CONFIG_PATH)
    current_api_data = _load_yaml_file(XHS_API_CONFIG_PATH)

    if normalized_user_data != current_user_data:
        _save_yaml_file(XHS_USER_CONFIG_PATH, normalized_user_data)
        logging.info("已将 search/crawler 配置同步到小红书 user_settings.yaml。")
    if normalized_api_data != current_api_data:
        _save_yaml_file(XHS_API_CONFIG_PATH, normalized_api_data)
        logging.info("已将 ai_reply 配置同步到小红书 api_settings.yaml。")

    return {
        "search": normalized_user_data.get("search", {}),
        "crawler": normalized_user_data.get("crawler", {}),
        "ai_reply": normalized_api_data.get("ai_reply", {}),
    }


def _load_xhs_config_for_frontend():
    data = _load_xhs_runtime_config()
    license_data = data.get("ai_reply", {}).get("license", {}) if isinstance(data.get("ai_reply", {}).get("license"), dict) else {}
    license_key = license_data.get("key") or data.get("ai_reply", {}).get("license_key", "")
    return {
        "search_keywords": data.get("search", {}).get("keywords", []),
        "sort_by": _normalize_sort_mode(data.get("search", {}).get("sort_by", "latest")),
        "max_daily_videos": data.get("crawler", {}).get("max_daily_videos", 100),
        "max_videos_per_keyword": data.get("crawler", {}).get("max_videos_per_keyword", 5),
        "ai_enabled": data.get("ai_reply", {}).get("enabled", True),
        "ai_base_url": data.get("ai_reply", {}).get("cloud_base_url", DEFAULT_LICENSE_SERVER_URL),
        "ai_api_key": "",
        "ai_model": data.get("ai_reply", {}).get("model", "deepseek-v4-flash"),
        "ai_temperature": data.get("ai_reply", {}).get("temperature", 0.7),
        "ai_max_tokens": data.get("ai_reply", {}).get("max_tokens", 120),
        "license_key": "",
        "license_key_masked": mask_license_key(license_key),
        "has_license_key": bool(license_key),
        "license_server_url": license_data.get("server_url", DEFAULT_LICENSE_SERVER_URL),
        # 抖音专属字段，小红书页面不需要但前端 AppConfig 要求返回
        "comments": [],
        "target_keywords": [],
        "reply_texts": [],
        "min_video_stay": 3,
        "max_video_stay": 6,
        "max_comment_swipes": 2,
    }


def _save_xhs_config(config: AppConfig):
    previous_api_data = _load_yaml_file(XHS_API_CONFIG_PATH)
    previous_ai = previous_api_data.get("ai_reply", {}) if isinstance(previous_api_data.get("ai_reply"), dict) else {}
    previous_license = previous_ai.get("license", {}) if isinstance(previous_ai.get("license"), dict) else {}
    license_key = (config.license_key or "").strip() or previous_license.get("key", "") or previous_ai.get("license_key", "")
    license_server_url = (config.license_server_url or "").strip() or previous_license.get("server_url", DEFAULT_LICENSE_SERVER_URL)
    user_yaml_data = {
        "search": {
            "keywords": config.search_keywords,
            "sort_by": _normalize_sort_mode(config.sort_by)
        },
        "crawler": {
            "max_daily_videos": config.max_daily_videos,
            "max_videos_per_keyword": config.max_videos_per_keyword,
        },
        "interaction": {
            "comments": config.comments,
            "target_keywords": config.target_keywords,
            "reply_texts": config.reply_texts,
            "max_comment_swipes": config.max_comment_swipes,
        }
    }
    api_yaml_data = {
        "ai_reply": {
            "enabled": config.ai_enabled,
            "mode": "cloud",
            "cloud_base_url": license_server_url,
            "base_url": "",
            "api_key": "",
            "model": config.ai_model,
            "temperature": config.ai_temperature,
            "max_tokens": config.ai_max_tokens,
            "license": {
                "server_url": license_server_url,
                "key": license_key,
            },
        },
    }
    _save_yaml_file(XHS_USER_CONFIG_PATH, user_yaml_data)
    _save_yaml_file(XHS_API_CONFIG_PATH, api_yaml_data)


# ======================== 抖音配置逻辑 ========================

def _load_douyin_runtime_config():
    user_data = _load_yaml_file(DY_USER_CONFIG_PATH)
    api_data = _load_yaml_file(DY_API_CONFIG_PATH)

    normalized_user_data = {
        key: value for key, value in user_data.items()
        if key != "ai_reply"
    }
    normalized_api_data = {
        key: value for key, value in api_data.items()
        if key not in ("search", "crawler")
    }

    search_data = user_data.get("search") if isinstance(user_data.get("search"), dict) else {}
    crawler_data = user_data.get("crawler") if isinstance(user_data.get("crawler"), dict) else {}
    ai_reply_data = api_data.get("ai_reply") if isinstance(api_data.get("ai_reply"), dict) else {}

    if not search_data and isinstance(api_data.get("search"), dict):
        search_data = api_data["search"]
    if not crawler_data and isinstance(api_data.get("crawler"), dict):
        crawler_data = api_data["crawler"]
    if not ai_reply_data and isinstance(user_data.get("ai_reply"), dict):
        ai_reply_data = user_data["ai_reply"]

    if search_data:
        normalized_user_data["search"] = search_data
    if crawler_data:
        normalized_user_data["crawler"] = crawler_data
    if ai_reply_data:
        normalized_api_data["ai_reply"] = ai_reply_data

    return {
        "search": normalized_user_data.get("search", {}),
        "crawler": normalized_user_data.get("crawler", {}),
        "comments": normalized_user_data.get("comments", []),
        "target": normalized_user_data.get("target", {}),
        "interaction": normalized_user_data.get("interaction", {}),
        "ai_reply": normalized_api_data.get("ai_reply", {}),
    }


def _load_douyin_config_for_frontend():
    data = _load_douyin_runtime_config()
    license_data = data.get("ai_reply", {}).get("license", {}) if isinstance(data.get("ai_reply", {}).get("license"), dict) else {}
    license_key = license_data.get("key") or data.get("ai_reply", {}).get("license_key", "")
    return {
        "search_keywords": data.get("search", {}).get("keywords", []),
        "sort_by": data.get("search", {}).get("sort_by", "latest"),
        "max_daily_videos": data.get("crawler", {}).get("max_daily_videos", 100),
        "max_videos_per_keyword": data.get("crawler", {}).get("max_videos_per_keyword", 5),
        "comments": data.get("comments", []),
        "target_keywords": data.get("target", {}).get("keywords", []),
        "reply_texts": data.get("target", {}).get("reply_texts", []),
        "min_video_stay": data.get("crawler", {}).get("min_video_stay", 3),
        "max_video_stay": data.get("crawler", {}).get("max_video_stay", 6),
        "max_comment_swipes": data.get("interaction", {}).get("max_comment_swipes", 2),
        "max_ai_comment_reviews": data.get("interaction", {}).get("max_ai_comment_reviews", 20),
        "intent_keywords": ",".join(data.get("interaction", {}).get("intent_keywords", [])),
        "enable_like": data.get("interaction", {}).get("enable_like", True),
        "enable_author_follow": data.get("interaction", {}).get("enable_author_follow", True),
        "enable_video_comment": data.get("interaction", {}).get("enable_video_comment", True),
        "enable_comment_lead": data.get("interaction", {}).get("enable_comment_lead", True),
        "min_followers_threshold": data.get("interaction", {}).get("min_followers_threshold", 0),
        "enable_private_message": data.get("interaction", {}).get("enable_private_message", True),
        "pm_followers_threshold": data.get("interaction", {}).get("pm_followers_threshold", 1),
        "pm_message_list": data.get("interaction", {}).get("pm_message_list", []),
        "ai_enabled": data.get("ai_reply", {}).get("enabled", True),
        "ai_base_url": data.get("ai_reply", {}).get("cloud_base_url", DEFAULT_LICENSE_SERVER_URL),
        "ai_api_key": "",
        "ai_model": data.get("ai_reply", {}).get("model", "deepseek-v4-flash"),
        "ai_temperature": data.get("ai_reply", {}).get("temperature", 0.7),
        "ai_max_tokens": data.get("ai_reply", {}).get("max_tokens", 120),
        "license_key": "",
        "license_key_masked": mask_license_key(license_key),
        "has_license_key": bool(license_key),
        "license_server_url": license_data.get("server_url", DEFAULT_LICENSE_SERVER_URL),
    }


def _save_douyin_config(config: AppConfig):
    previous_api_data = _load_yaml_file(DY_API_CONFIG_PATH)
    previous_ai = previous_api_data.get("ai_reply", {}) if isinstance(previous_api_data.get("ai_reply"), dict) else {}
    previous_license = previous_ai.get("license", {}) if isinstance(previous_ai.get("license"), dict) else {}
    license_key = (config.license_key or "").strip() or previous_license.get("key", "") or previous_ai.get("license_key", "")
    license_server_url = (config.license_server_url or "").strip() or previous_license.get("server_url", DEFAULT_LICENSE_SERVER_URL)
    # 读取已有用户配置，保留前端未覆盖的段落（如 anti_detection 防风控配置）
    previous_user_data = _load_yaml_file(DY_USER_CONFIG_PATH)
    user_yaml_data = {
        "search": {
            "keywords": config.search_keywords,
            "sort_by": config.sort_by,
        },
        "crawler": {
            "max_daily_videos": config.max_daily_videos,
            "max_videos_per_keyword": config.max_videos_per_keyword,
            "min_video_stay": config.min_video_stay,
            "max_video_stay": config.max_video_stay,
        },
        "comments": config.comments,
        "target": {
            "keywords": config.target_keywords,
            "reply_texts": config.reply_texts,
        },
        "interaction": {
            "max_comment_swipes": config.max_comment_swipes,
            "max_ai_comment_reviews": config.max_ai_comment_reviews,
            "intent_keywords": config.intent_keywords,
            "enable_like": config.enable_like,
            "enable_author_follow": config.enable_author_follow,
            "enable_video_comment": config.enable_video_comment,
            "enable_comment_lead": config.enable_comment_lead,
            "min_followers_threshold": config.min_followers_threshold,
            "enable_private_message": config.enable_private_message,
            "pm_followers_threshold": config.pm_followers_threshold,
            "pm_message_list": config.pm_message_list,
        }
    }
    # 保留前端未直接管理的配置段（防风控参数等），避免被覆盖丢失
    if isinstance(previous_user_data, dict):
        for preserve_key in ("anti_detection",):
            if preserve_key in previous_user_data and preserve_key not in user_yaml_data:
                user_yaml_data[preserve_key] = previous_user_data[preserve_key]
    api_yaml_data = {
        "ai_reply": {
            "enabled": config.ai_enabled,
            "mode": "cloud",
            "cloud_base_url": license_server_url,
            "base_url": "",
            "api_key": "",
            "model": config.ai_model,
            "temperature": config.ai_temperature,
            "max_tokens": config.ai_max_tokens,
            "license": {
                "server_url": license_server_url,
                "key": license_key,
            },
        },
    }
    _save_yaml_file(DY_USER_CONFIG_PATH, user_yaml_data)
    _save_yaml_file(DY_API_CONFIG_PATH, api_yaml_data)


def _get_license_config_for_platform(platform: str) -> dict:
    api_path = DY_API_CONFIG_PATH if platform == "douyin" else XHS_API_CONFIG_PATH
    api_data = _load_yaml_file(api_path)
    ai_reply = api_data.get("ai_reply", {}) if isinstance(api_data.get("ai_reply"), dict) else {}
    license_data = ai_reply.get("license", {}) if isinstance(ai_reply.get("license"), dict) else {}
    return {
        "key": (license_data.get("key") or ai_reply.get("license_key") or "").strip(),
        "server_url": (license_data.get("server_url") or ai_reply.get("cloud_base_url") or DEFAULT_LICENSE_SERVER_URL).strip(),
    }


def _verify_platform_license(platform: str, device_id: str = "") -> dict:
    license_config = _get_license_config_for_platform(platform)
    try:
        return verify_license(
            license_config.get("key", ""),
            license_config.get("server_url", DEFAULT_LICENSE_SERVER_URL),
            device_id=device_id,
        )
    except LicenseError as exc:
        raise HTTPException(status_code=403, detail=str(exc))


def _save_platform_license(platform: str, license_key: str, server_url: str) -> None:
    api_path = DY_API_CONFIG_PATH if platform == "douyin" else XHS_API_CONFIG_PATH
    api_data = _load_yaml_file(api_path)
    ai_reply = api_data.get("ai_reply", {}) if isinstance(api_data.get("ai_reply"), dict) else {}
    license_server_url = (server_url or "").strip() or DEFAULT_LICENSE_SERVER_URL
    api_data["ai_reply"] = {
        **ai_reply,
        "enabled": ai_reply.get("enabled", True),
        "mode": "cloud",
        "cloud_base_url": license_server_url,
        "base_url": "",
        "api_key": "",
        "model": ai_reply.get("model", "deepseek-v4-flash"),
        "temperature": ai_reply.get("temperature", 0.7),
        "max_tokens": ai_reply.get("max_tokens", 120),
        "license": {
            "server_url": license_server_url,
            "key": (license_key or "").strip(),
        },
    }
    _save_yaml_file(api_path, api_data)


# ======================== API 路由 ========================

@app.get("/", summary="根目录重定向")
def root_redirect():
    """将根目录请求重定向到 Swagger API 文档"""
    return RedirectResponse(url="/docs")


# ----------------- 接口: 设备管理 -----------------
@app.get("/api/devices", summary="获取已连接设备列表")
def api_get_devices():
    devices = get_connected_devices()
    return {"success": True, "devices": devices}


@app.post("/api/devices/usb/detect", summary="检测 USB 连接设备")
def api_detect_usb_devices():
    result = detect_usb_devices(verify_u2=True, persist=True)
    logging.info(f"USB 设备检测结果: {result.get('message')}")
    return result


@app.post("/api/devices/pair", summary="无线配对设备")
def api_pair_device(req: DevicePairRequest):
    ip_port = req.ip_port.strip()
    code = req.code.strip()
    if not ip_port or not code:
        return {"success": False, "message": "IP地址端口和配对码不能为空"}

    logging.info(f"尝试配对设备: {ip_port} (验证码: {code})")
    if run_cmd([ADB_BIN, "pair", ip_port, code]):
        return {"success": True, "message": f"成功与设备 {ip_port} 完成配对"}
    else:
        return {"success": False, "message": f"配对 {ip_port} 失败，请检查配对码是否正确或已过期"}


@app.post("/api/devices/connect", summary="无线连接设备")
def api_connect_device(req: DeviceConnectRequest):
    ip_port = req.ip_port.strip()
    if not ip_port:
        return {"success": False, "message": "IP地址和端口不能为空"}

    logging.info(f"尝试连接设备: {ip_port}")
    if run_cmd([ADB_BIN, "connect", ip_port]):
        return {"success": True, "message": f"成功发送连接命令至 {ip_port}"}
    else:
        return {"success": False, "message": f"连接 {ip_port} 失败，请检查手机是否开启无线调试或IP端口是否正确"}


@app.post("/api/devices/disconnect", summary="断开设备连接")
def api_disconnect_device(req: DeviceConnectRequest):
    serial = req.ip_port.strip()
    if not serial:
        return {"success": False, "message": "设备标识不能为空"}

    logging.info(f"尝试断开设备连接: {serial}")
    if run_cmd([ADB_BIN, "disconnect", serial]):
        # 停止该设备上的任务并清理状态
        task = get_running_task(serial)
        if task:
            try:
                task.stop()
            except Exception:
                pass
            del_running_task(serial)
        del_task_status(serial)
        return {"success": True, "message": f"已成功断开设备 {serial} 的连接"}
    else:
        return {"success": False, "message": f"断开设备 {serial} 失败"}


# ----------------- 接口: 配置管理 -----------------
@app.get("/api/config", summary="读取当前配置")
def api_get_config(platform: str = "xhs"):
    """
    读取指定平台的运行配置
    - platform: "xhs" (小红书) 或 "douyin" (抖音)，默认为 "xhs"
    """
    try:
        if platform == "douyin":
            config = _load_douyin_config_for_frontend()
        else:
            config = _load_xhs_config_for_frontend()
        return {"success": True, "config": config}
    except Exception as e:
        return {"success": False, "message": f"读取配置失败: {str(e)}"}


@app.post("/api/config", summary="保存前端配置")
def api_save_config(config: AppConfig, platform: str = "xhs"):
    """
    保存指定平台的运行配置
    - platform: "xhs" (小红书) 或 "douyin" (抖音)，默认为 "xhs"
    """
    try:
        if (config.license_key or "").strip():
            verify_license(
                config.license_key,
                config.license_server_url or DEFAULT_LICENSE_SERVER_URL,
            )

        if platform == "douyin":
            old_data = _load_yaml_file(DY_USER_CONFIG_PATH)
            previous_max_daily = old_data.get("crawler", {}).get("max_daily_videos") if isinstance(old_data.get("crawler"), dict) else None
            _save_douyin_config(config)
        else:
            old_data = _load_xhs_runtime_config()
            previous_max_daily = old_data.get("crawler", {}).get("max_daily_videos")
            _save_xhs_config(config)

        if previous_max_daily is not None and previous_max_daily != config.max_daily_videos:
            if db_manager.reset_daily_progress():
                logging.info("检测到每日处理内容总上限变更，已重置当天统计记录和待处理缓存。")
                return {
                    "success": True,
                    "message": "配置保存成功，今日处理数和待处理缓存已归零"
                }
            logging.warning("每日处理内容总上限已更新，但重置当天统计记录失败。")
            return {
                "success": False,
                "message": "配置已保存，但今日处理数和待处理缓存归零失败"
            }

        return {"success": True, "message": "配置保存成功"}
    except LicenseError as e:
        return {"success": False, "message": f"授权码验证失败: {str(e)}"}
    except Exception as e:
        return {"success": False, "message": f"保存配置失败: {str(e)}"}


@app.post("/api/license/verify", summary="验证客户授权码")
def api_verify_license(req: LicenseVerifyRequest):
    try:
        data = verify_license(
            req.license_key,
            req.license_server_url or DEFAULT_LICENSE_SERVER_URL,
            device_id=req.device_id,
        )
        return {
            "success": True,
            "message": "授权码验证成功",
            "data": {
                "customer_name": data.get("customer_name", ""),
                "status": data.get("status", ""),
                "balance_credits": data.get("balance_credits", 0),
                "token_per_credit": data.get("token_per_credit", 1000),
                "license_key_masked": mask_license_key(req.license_key),
            },
        }
    except LicenseError as exc:
        return {"success": False, "message": str(exc), "data": {}}


@app.post("/api/license/save", summary="验证并保存客户授权码")
def api_save_license(req: LicenseVerifyRequest, platform: str = "xhs"):
    try:
        data = verify_license(
            req.license_key,
            req.license_server_url or DEFAULT_LICENSE_SERVER_URL,
            device_id=req.device_id,
        )
        _save_platform_license(platform, req.license_key, req.license_server_url or DEFAULT_LICENSE_SERVER_URL)
        return {
            "success": True,
            "message": "授权码验证并保存成功",
            "data": {
                "customer_name": data.get("customer_name", ""),
                "status": data.get("status", ""),
                "balance_credits": data.get("balance_credits", 0),
                "token_per_credit": data.get("token_per_credit", 1000),
                "license_key_masked": mask_license_key(req.license_key),
            },
        }
    except LicenseError as exc:
        return {"success": False, "message": str(exc), "data": {}}
    except Exception as exc:
        return {"success": False, "message": f"保存授权码失败: {exc}", "data": {}}


# ----------------- 接口: 任务控制 -----------------
def _get_config_path_for_platform(platform: str) -> str:
    """根据平台返回任务流所需的配置文件路径"""
    if platform == "douyin":
        return DY_USER_CONFIG_PATH
    return XHS_USER_CONFIG_PATH


def run_task_on_device(serial: str, platform: str = "xhs", startup_delay: float = 0):
    """
    后台执行实际任务的函数。
    每个设备在独立线程中运行，线程由 _task_executor 统一调度。
    支持短暂、可解释的启动错峰，避免多台设备同时初始化导致 USB/ADB 争抢。
    """
    set_task_status(serial, {"status": "starting", "error": None, "platform": platform})
    if startup_delay > 0:
        logging.info(f"设备 {serial} 将在 {startup_delay:.1f}s 后启动，避免 ADB 初始化瞬时争抢")
        time.sleep(startup_delay)
    if is_task_stop_requested(serial):
        set_task_status(serial, {"status": "stopped", "error": None, "platform": platform})
        logging.info(f"<== API: 设备 {serial} 在启动前已被取消")
        clear_task_stop_request(serial)
        return
    logging.info(f"==> API: 开始初始化设备 {serial} 的{platform}平台任务")

    config_path = _get_config_path_for_platform(platform)
    try:
        if platform == "douyin":
            task_flow = DouyinTaskFlow(serial=serial, config_path=config_path)
        else:
            task_flow = TikTokTaskFlow(serial=serial, config_path=config_path)

        set_running_task(serial, task_flow)
        if is_task_stop_requested(serial):
            task_flow.stop()
            set_task_status(serial, {"status": "stopped", "error": None, "platform": platform})
            logging.info(f"<== API: 设备 {serial} 初始化后检测到取消请求")
            return
        set_task_status(serial, {"status": "running", "error": None, "platform": platform})
        logging.info(f"==> API: 设备 {serial} 已进入运行状态")
        task_flow.start()

        if task_flow.is_stopped:
            set_task_status(serial, {"status": "stopped", "error": None})
            logging.info(f"<== API: 设备 {serial} 任务被手动停止")
        else:
            set_task_status(serial, {"status": "completed", "error": None})
            logging.info(f"<== API: 设备 {serial} 任务执行完毕")

    except InterruptedError as e:
        set_task_status(serial, {"status": "stopped", "error": str(e)})
        logging.info(f"<== API: 设备 {serial} 任务已中断: {e}")
    except Exception as e:
        set_task_status(serial, {"status": "error", "error": str(e)})
        logging.error(f"API: 设备 {serial} 执行异常: {e}")
    finally:
        clear_task_stop_request(serial)
        del_running_task(serial)


@app.post("/api/tasks/start", summary="启动设备自动化任务")
def api_start_tasks(req: TaskStartRequest):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    try:
        license_info = _verify_platform_license(req.platform, device_id=req.devices[0] if req.devices else "")
        logging.info(
            "授权码验证通过，客户: %s，剩余积分: %s",
            license_info.get("customer_name", ""),
            license_info.get("balance_credits", ""),
        )
    except HTTPException as exc:
        return {"success": False, "message": f"授权校验失败：{exc.detail}"}

    started_devices = []
    skipped_devices = []
    for index, serial in enumerate(req.devices):
        if is_task_running(serial):
            skipped_devices.append(serial)
            continue
        clear_task_stop_request(serial)
        set_task_queued(serial, req.platform)
        # 使用全局线程池调度任务，支持最大 MAX_CONCURRENT_DEVICES 并发
        _task_executor.submit(run_task_on_device, serial, req.platform, min(index * 0.5, 3.0))
        started_devices.append(serial)

    if started_devices:
        message = f"成功提交 {len(started_devices)} 台设备任务（最大并发 {MAX_CONCURRENT_DEVICES} 台）"
        if skipped_devices:
            message += f"，已跳过 {len(skipped_devices)} 台启动中/运行中的设备"
        return {"success": True, "message": message, "data": {"devices": started_devices, "skipped": skipped_devices}}
    else:
        return {"success": False, "message": "设备已在启动中或运行中，无法重复启动"}


@app.post("/api/tasks/stop", summary="结束设备自动化任务")
def api_stop_tasks(req: TaskStartRequest):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    stopped_devices = []
    for serial in req.devices:
        task = get_running_task(serial)
        if task:
            task.stop()
            stopped_devices.append(serial)
            continue
        status = get_task_status(serial, {})
        if status.get("status") in {"queued", "starting"}:
            request_task_stop(serial)
            set_task_status(serial, {"status": "stopped", "error": None, "platform": status.get("platform", req.platform)})
            stopped_devices.append(serial)

    if stopped_devices:
        return {"success": True, "message": f"已向 {len(stopped_devices)} 台设备发送结束指令"}
    else:
        return {"success": False, "message": "所选设备当前没有运行中的任务"}


@app.post("/api/tasks/pause", summary="暂停设备自动化任务")
def api_pause_tasks(req: TaskStartRequest):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    paused_devices = []
    for serial in req.devices:
        task = get_running_task(serial)
        if task:
            task.pause()
            set_task_status(serial, {"status": "paused", "error": None})
            paused_devices.append(serial)

    if paused_devices:
        return {"success": True, "message": f"已暂停 {len(paused_devices)} 台设备"}
    else:
        return {"success": False, "message": "所选设备当前没有运行中的任务"}


@app.post("/api/tasks/resume", summary="继续设备自动化任务")
def api_resume_tasks(req: TaskStartRequest):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    resumed_devices = []
    for serial in req.devices:
        task = get_running_task(serial)
        if task:
            task.resume()
            set_task_status(serial, {"status": "running", "error": None})
            resumed_devices.append(serial)

    if resumed_devices:
        return {"success": True, "message": f"已恢复 {len(resumed_devices)} 台设备"}
    else:
        return {"success": False, "message": "所选设备当前没有可恢复的任务"}


@app.get("/api/tasks/status", summary="查询所有设备的任务运行状态")
def api_get_task_status():
    with _task_status_lock:
        return {"success": True, "status": dict(_task_status)}


@app.get("/api/logs", summary="获取最新系统日志")
def api_get_logs():
    return {"success": True, "logs": list(MEMORY_LOGS)}


# ----------------- 接口: 数据统计 -----------------
@app.get("/api/stats", summary="获取今日数据大屏统计")
def api_get_stats():
    stats = db_manager.get_daily_stats()
    return {"success": True, "data": stats}


@app.get("/api/stats/details", summary="获取今日详细操作记录")
def api_get_stats_details(limit: int = 100):
    records = db_manager.get_daily_records(limit=limit)
    return {"success": True, "data": records}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("backend.main:app", host="0.0.0.0", port=8000, reload=True)
