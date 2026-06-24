from pydantic import BaseModel
from typing import List

class AppConfig(BaseModel):
    """前端传来的配置表单模型"""
    search_keywords: List[str]
    sort_by: str = "latest"
    max_videos_per_keyword: int = 5
    max_daily_videos: int = 100
    # 小红书专属
    ai_enabled: bool = True
    ai_base_url: str = "https://api.deepseek.com/v1"
    ai_api_key: str = ""
    ai_model: str = "deepseek-v4-flash"
    ai_temperature: float = 0.7
    ai_max_tokens: int = 120
    # 抖音专属
    comments: List[str] = []
    target_keywords: List[str] = []
    reply_texts: List[str] = []
    min_video_stay: int = 3
    max_video_stay: int = 6
    max_comment_swipes: int = 2
    max_ai_comment_reviews: int = 20
    intent_keywords: List[str] = []
    min_followers_threshold: float = 0
    enable_private_message: bool = True
    pm_followers_threshold: float = 1
    pm_message_list: List[str] = []

class DeviceConnectRequest(BaseModel):
    """连接新设备请求"""
    ip_port: str

class DevicePairRequest(BaseModel):
    """配对新设备请求"""
    ip_port: str
    code: str

class TaskStartRequest(BaseModel):
    """启动任务时的请求参数"""
    devices: List[str]  # 用户勾选的要执行任务的设备序列号列表
    platform: str = "xhs"  # 目标平台: "xhs" 或 "douyin"

class TaskResponse(BaseModel):
    """通用的响应格式"""
    success: bool
    message: str
    data: dict = {}
