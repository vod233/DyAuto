import sys
import os
import yaml
import logging
import concurrent.futures

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

from backend.schemas import AppConfig, TaskStartRequest, TaskResponse, DeviceConnectRequest, DevicePairRequest

# 初始化全局日志
setup_logger()

# 全局任务状态追踪 { serial: {"status": "running" | "error" | "completed" | "stopped", "error": str} }
task_status = {}
# 保存正在运行的任务实例引用，以便可以调用 stop()
running_tasks = {}

@asynccontextmanager
async def lifespan(app: FastAPI):
    # 启动时执行
    yield
    # 关闭时执行：优雅地清理所有后台正在运行的设备任务
    logging.info("接收到关闭信号，正在停止所有后台设备任务...")
    for serial, task in list(running_tasks.items()):
        try:
            task.stop()
            logging.info(f"已发送停止信号给设备: {serial}")
        except Exception as e:
            logging.error(f"停止设备 {serial} 时出错: {e}")

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
    return {
        "search_keywords": data.get("search", {}).get("keywords", []),
        "sort_by": _normalize_sort_mode(data.get("search", {}).get("sort_by", "latest")),
        "max_daily_videos": data.get("crawler", {}).get("max_daily_videos", 100),
        "max_videos_per_keyword": data.get("crawler", {}).get("max_videos_per_keyword", 5),
        "ai_enabled": data.get("ai_reply", {}).get("enabled", True),
        "ai_base_url": data.get("ai_reply", {}).get("base_url", "https://api.deepseek.com/v1"),
        "ai_api_key": data.get("ai_reply", {}).get("api_key", ""),
        "ai_model": data.get("ai_reply", {}).get("model", "deepseek-v4-flash"),
        "ai_temperature": data.get("ai_reply", {}).get("temperature", 0.7),
        "ai_max_tokens": data.get("ai_reply", {}).get("max_tokens", 120),
        # 抖音专属字段，小红书页面不需要但前端 AppConfig 要求返回
        "comments": [],
        "target_keywords": [],
        "reply_texts": [],
        "min_video_stay": 3,
        "max_video_stay": 6,
        "max_comment_swipes": 2,
    }


def _save_xhs_config(config: AppConfig):
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
            "base_url": config.ai_base_url,
            "api_key": config.ai_api_key,
            "model": config.ai_model,
            "temperature": config.ai_temperature,
            "max_tokens": config.ai_max_tokens,
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
        "min_followers_threshold": data.get("interaction", {}).get("min_followers_threshold", 0),
        "enable_private_message": data.get("interaction", {}).get("enable_private_message", True),
        "pm_followers_threshold": data.get("interaction", {}).get("pm_followers_threshold", 1),
        "pm_message_list": data.get("interaction", {}).get("pm_message_list", []),
        "ai_enabled": data.get("ai_reply", {}).get("enabled", True),
        "ai_base_url": data.get("ai_reply", {}).get("base_url", "https://api.deepseek.com/v1"),
        "ai_api_key": data.get("ai_reply", {}).get("api_key", ""),
        "ai_model": data.get("ai_reply", {}).get("model", "deepseek-v4-flash"),
        "ai_temperature": data.get("ai_reply", {}).get("temperature", 0.7),
        "ai_max_tokens": data.get("ai_reply", {}).get("max_tokens", 120),
    }


def _save_douyin_config(config: AppConfig):
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
            "min_followers_threshold": config.min_followers_threshold,
            "enable_private_message": config.enable_private_message,
            "pm_followers_threshold": config.pm_followers_threshold,
            "pm_message_list": config.pm_message_list,
        }
    }
    api_yaml_data = {
        "ai_reply": {
            "enabled": config.ai_enabled,
            "base_url": config.ai_base_url,
            "api_key": config.ai_api_key,
            "model": config.ai_model,
            "temperature": config.ai_temperature,
            "max_tokens": config.ai_max_tokens,
        },
    }
    _save_yaml_file(DY_USER_CONFIG_PATH, user_yaml_data)
    _save_yaml_file(DY_API_CONFIG_PATH, api_yaml_data)


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
        if serial in running_tasks:
            try:
                running_tasks[serial].stop()
                del running_tasks[serial]
            except Exception:
                pass
        if serial in task_status:
            del task_status[serial]
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
    except Exception as e:
        return {"success": False, "message": f"保存配置失败: {str(e)}"}


# ----------------- 接口: 任务控制 -----------------
def _get_config_path_for_platform(platform: str) -> str:
    """根据平台返回任务流所需的配置文件路径"""
    if platform == "douyin":
        return DY_USER_CONFIG_PATH
    return XHS_USER_CONFIG_PATH


def run_task_on_device(serial: str, platform: str = "xhs"):
    """后台执行实际任务的函数"""
    task_status[serial] = {"status": "running", "error": None}
    logging.info(f"==> API: 开始在设备 {serial} 上执行{platform}平台任务")

    config_path = _get_config_path_for_platform(platform)
    try:
        if platform == "douyin":
            task_flow = DouyinTaskFlow(serial=serial, config_path=config_path)
        else:
            task_flow = TikTokTaskFlow(serial=serial, config_path=config_path)

        running_tasks[serial] = task_flow
        task_flow.start()

        if task_flow.is_stopped:
            task_status[serial]["status"] = "stopped"
            logging.info(f"<== API: 设备 {serial} 任务被手动停止")
        else:
            task_status[serial]["status"] = "completed"
            logging.info(f"<== API: 设备 {serial} 任务执行完毕")

    except InterruptedError as e:
        task_status[serial] = {"status": "stopped", "error": str(e)}
        logging.info(f"<== API: 设备 {serial} 任务已中断: {e}")
    except Exception as e:
        task_status[serial] = {"status": "error", "error": str(e)}
        logging.error(f"API: 设备 {serial} 执行异常: {e}")
    finally:
        if serial in running_tasks:
            del running_tasks[serial]


@app.post("/api/tasks/start", summary="启动设备自动化任务")
def api_start_tasks(req: TaskStartRequest, background_tasks: BackgroundTasks):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    started_devices = []
    for serial in req.devices:
        if task_status.get(serial, {}).get("status") == "running":
            continue
        background_tasks.add_task(run_task_on_device, serial, req.platform)
        started_devices.append(serial)

    if started_devices:
        return {"success": True, "message": f"成功启动 {len(started_devices)} 台设备任务", "data": {"devices": started_devices}}
    else:
        return {"success": False, "message": "设备已在运行任务中，无法重复启动"}


@app.post("/api/tasks/stop", summary="结束设备自动化任务")
def api_stop_tasks(req: TaskStartRequest):
    if not req.devices:
        return {"success": False, "message": "未选择任何设备"}

    stopped_devices = []
    for serial in req.devices:
        if serial in running_tasks:
            running_tasks[serial].stop()
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
        if serial in running_tasks:
            running_tasks[serial].pause()
            task_status[serial]["status"] = "paused"
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
        if serial in running_tasks:
            running_tasks[serial].resume()
            task_status[serial]["status"] = "running"
            resumed_devices.append(serial)

    if resumed_devices:
        return {"success": True, "message": f"已恢复 {len(resumed_devices)} 台设备"}
    else:
        return {"success": False, "message": "所选设备当前没有可恢复的任务"}


@app.get("/api/tasks/status", summary="查询所有设备的任务运行状态")
def api_get_task_status():
    return {"success": True, "status": task_status}


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
