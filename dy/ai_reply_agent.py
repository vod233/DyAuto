import logging
import os
import re
import threading
from typing import Optional

from dotenv import load_dotenv
from social_license import CloudAIClient, LicenseError

load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env"), override=True)

logger = logging.getLogger(__name__)
LANGCHAIN_IMPORT_ERROR = None

# API 并发限流信号量，最多同时 2000 个 DeepSeek API 调用（使用 deepseek-v4-flash 模型）
_ai_api_semaphore = threading.Semaphore(2000)

try:
    from langchain_core.messages import HumanMessage, SystemMessage
    from langchain_openai import ChatOpenAI
except ImportError:
    LANGCHAIN_IMPORT_ERROR = "缺少 `langchain-openai` 或其依赖，请在当前虚拟环境执行 `pip install langchain-openai openai`。"
    HumanMessage = None
    SystemMessage = None
    ChatOpenAI = None


class DYReplyAgent:
    """根据标题生成合规的抖音评论回复。"""

    _BANNED_PATTERNS = [
        re.compile(r"(微信|vx|v信|威信|加我|联系我|私信我|私聊我|主页|进群)", re.IGNORECASE),
        re.compile(r"(http[s]?://|www\.|douyin\.com|v\.douyin\.com)", re.IGNORECASE),
        re.compile(r"(QQ|qq|电话|手机号|微信号|二维码)"),
        re.compile(r"\d{7,}"),
        re.compile(r"(最便宜|保证|包过|稳赚|返利|代购|招代理|兼职|刷单)"),
        re.compile(r"(政治|色情|赌博|毒品|辱骂|仇恨|暴力)"),
    ]

    def __init__(self, config: Optional[dict] = None):
        self.config = config or {}
        self.ai_config = self.config.get("ai_reply", {})
        self.cloud_ai = CloudAIClient(self.ai_config, platform="douyin")

    def is_enabled(self) -> bool:
        return bool(self.ai_config.get("enabled", True))

    def generate_reply(self, title: str, keyword: str = "") -> Optional[str]:
        clean_title = self._normalize_text(title)
        if not clean_title:
            logger.warning("标题为空，跳过 AI 回复生成。")
            return None

        if not self.is_enabled():
            logger.info("AI 自动回复已关闭，跳过评论环节。")
            return None

        for attempt in range(2):
            candidate = self._call_model(clean_title, keyword, strict_retry=attempt > 0)
            candidate = self._sanitize_reply(candidate)
            if self._is_valid_reply(candidate):
                return candidate

            if candidate:
                logger.warning("AI 生成内容格式不符合要求，准备重试: %s", candidate)

        fallback = self._build_safe_fallback(clean_title)
        if self._is_valid_reply(fallback):
            logger.info(f"AI 回复降级为本地安全模板: {fallback}")
            return fallback

        logger.warning("未能生成可用回复，跳过评论环节。")
        return None

    def is_intent_comment(self, comment_text: str, video_title: str = "", keyword: str = "", custom_keywords: list = None) -> bool:
        clean_comment = self._normalize_text(comment_text)
        if not clean_comment or len(clean_comment) < 3:
            return False

        custom_keywords = custom_keywords or []
        
        if not self.is_enabled():
            return self._local_intent_guess(clean_comment, custom_keywords)

        result = self._call_intent_model(clean_comment, video_title, keyword, custom_keywords)
        if result is None:
            return self._local_intent_guess(clean_comment, custom_keywords)

        if result:
            return True
        
        return self._check_custom_keywords(clean_comment, custom_keywords)

    def generate_lead_reply(self, comment_text: str, video_title: str = "", keyword: str = "") -> Optional[str]:
        clean_comment = self._normalize_text(comment_text)
        if not clean_comment:
            return None

        if not self.is_enabled():
            return self._build_lead_fallback(clean_comment)

        for attempt in range(2):
            candidate = self._call_lead_reply_model(clean_comment, video_title, keyword, strict_retry=attempt > 0)
            candidate = self._sanitize_lead_reply(candidate)
            if self._is_valid_lead_reply(candidate):
                return candidate

        fallback = self._build_lead_fallback(clean_comment)
        if self._is_valid_lead_reply(fallback):
            return fallback

        return None

    def _call_model(self, title: str, keyword: str, strict_retry: bool = False) -> Optional[str]:
        if self.cloud_ai.enabled():
            try:
                data = self.cloud_ai.post("/ai/generate-video-comment", {
                    "keyword": keyword,
                    "title": title,
                })
                return data.get("reply")
            except LicenseError as exc:
                logger.error(f"云端 AI 生成视频评论失败: {exc}")
                return None

        if self.ai_config.get("mode", "cloud") != "local":
            logger.warning("未配置授权码，无法调用云端 AI 生成视频评论。")
            return None

        base_url = os.environ.get("DEEPSEEK_BASE_URL") or (self.ai_config.get("base_url") or "").strip()
        api_key = os.environ.get("DEEPSEEK_API_KEY") or (self.ai_config.get("api_key") or "").strip()
        model = os.environ.get("DEEPSEEK_MODEL") or (self.ai_config.get("model") or "").strip()

        if not base_url or not api_key or not model:
            logger.warning("AI 回复配置不完整，需要填写 Base URL、API Key 和 Model。")
            return None

        if not all([ChatOpenAI, SystemMessage, HumanMessage]):
            logger.error(f"LangChain 依赖不可用，无法调用 AI 回复接口。{LANGCHAIN_IMPORT_ERROR or ''}")
            return None

        return self._call_langchain(title, keyword, base_url, api_key, model, strict_retry)

    def _get_model_config(self):
        if self.ai_config.get("mode", "cloud") != "local":
            logger.warning("未配置授权码，无法调用云端 AI。")
            return None

        base_url = os.environ.get("DEEPSEEK_BASE_URL") or (self.ai_config.get("base_url") or "").strip()
        api_key = os.environ.get("DEEPSEEK_API_KEY") or (self.ai_config.get("api_key") or "").strip()
        model = os.environ.get("DEEPSEEK_MODEL") or (self.ai_config.get("model") or "").strip()
        if not base_url or not api_key or not model:
            logger.warning("AI 配置不完整，需要填写 Base URL、API Key 和 Model。")
            return None
        if not all([ChatOpenAI, SystemMessage, HumanMessage]):
            logger.error(f"LangChain 依赖不可用，无法调用 AI 接口。{LANGCHAIN_IMPORT_ERROR or ''}")
            return None
        return base_url, api_key, model

    def _create_llm(self, base_url: str, api_key: str, model: str, temperature: Optional[float] = None, max_tokens: Optional[int] = None):
        return ChatOpenAI(
            base_url=self._normalize_openai_base_url(base_url),
            api_key=api_key,
            model=model,
            temperature=float(self.ai_config.get("temperature", 0.7) if temperature is None else temperature),
            max_tokens=int(self.ai_config.get("max_tokens", 120) if max_tokens is None else max_tokens),
            timeout=int(self.ai_config.get("timeout", 60)),
        )

    def _call_langchain(self, title: str, keyword: str, base_url: str, api_key: str, model: str, strict_retry: bool) -> Optional[str]:
        # 使用信号量限制并发，避免 API 速率限制
        with _ai_api_semaphore:
            try:
                llm = self._create_llm(base_url, api_key, model)
                messages = [
                    SystemMessage(content=self._system_prompt(strict_retry)),
                    HumanMessage(content=self._human_prompt(title, keyword)),
                ]
                response = llm.invoke(messages)
                return self._extract_response_text(response)
            except Exception as exc:
                logger.error(f"LangChain 调用 AI 回复失败: {exc}")
                return None

    def _call_intent_model(self, comment_text: str, video_title: str, keyword: str, custom_keywords: Optional[list] = None) -> Optional[bool]:
        if self.cloud_ai.enabled():
            try:
                data = self.cloud_ai.post("/ai/check-intent-comment", {
                    "keyword": keyword,
                    "title": video_title,
                    "comment_text": comment_text,
                    "custom_keywords": custom_keywords or [],
                })
                return bool(data.get("intent"))
            except LicenseError as exc:
                logger.error(f"云端 AI 判断评论意向失败: {exc}")
                return None

        model_config = self._get_model_config()
        if not model_config:
            return None

        base_url, api_key, model = model_config
        # 使用信号量限制并发，避免 API 速率限制
        with _ai_api_semaphore:
            try:
                llm = self._create_llm(base_url, api_key, model, temperature=0.1, max_tokens=8)
                messages = [
                    SystemMessage(content=(
                        "你是抖音评论区线索筛选器。"
                        "判断评论是否表达了明确需求、咨询意愿、购买/体验兴趣、想了解更多、求推荐、求教程、求链接、求价格、求方案。"
                        "只输出 YES 或 NO。"
                        "普通夸赞、调侃、无意义表情、单纯路过、泛泛赞同都输出 NO。"
                    )),
                    HumanMessage(content=(
                        f"视频标题：{video_title or '未提供'}\n"
                        f"搜索关键词：{keyword or '未提供'}\n"
                        f"评论：{comment_text}\n"
                        "这条评论是否有潜在客户意愿？"
                    )),
                ]
                response = llm.invoke(messages)
                text = (self._extract_response_text(response) or "").strip().upper()
                if text.startswith("YES"):
                    return True
                if text.startswith("NO"):
                    return False
                return None
            except Exception as exc:
                logger.error(f"AI 判断评论意向失败: {exc}")
                return None

    def _call_lead_reply_model(self, comment_text: str, video_title: str, keyword: str, strict_retry: bool = False) -> Optional[str]:
        if self.cloud_ai.enabled():
            try:
                data = self.cloud_ai.post("/ai/generate-lead-reply", {
                    "keyword": keyword,
                    "title": video_title,
                    "comment_text": comment_text,
                })
                return data.get("reply")
            except LicenseError as exc:
                logger.error(f"云端 AI 生成截流回复失败: {exc}")
                return None

        model_config = self._get_model_config()
        if not model_config:
            return None

        base_url, api_key, model = model_config
        retry_line = "上一条结果太像营销，请改成更克制、更像真人顺手回复。" if strict_retry else ""
        # 使用信号量限制并发，避免 API 速率限制
        with _ai_api_semaphore:
            try:
                llm = self._create_llm(base_url, api_key, model, max_tokens=80)
                messages = [
                    SystemMessage(content=(
                        "你是抖音评论区楼中楼回复助手。"
                        "根据用户评论生成一条自然、简短的中文回复，引导对方去看我的主页资料。"
                        "规则：1. 只输出回复正文；2. 10 到 32 个汉字；"
                        "3. 可以提到主页，但不得出现微信、私信、电话、二维码、链接、价格承诺、夸大宣传；"
                        "4. 不要使用 emoji、标签、连续感叹号；5. 语气像真人，不要强推。"
                        f"{retry_line}"
                    )),
                HumanMessage(content=(
                        f"视频标题：{video_title or '未提供'}\n"
                        f"搜索关键词：{keyword or '未提供'}\n"
                        f"用户评论：{comment_text}\n"
                        "请生成一条适合楼中楼回复的引导话术。"
                    )),
                ]
                response = llm.invoke(messages)
                return self._extract_response_text(response)
            except Exception as exc:
                logger.error(f"AI 生成截流回复失败: {exc}")
                return None

    def _system_prompt(self, strict_retry: bool) -> str:
        retry_line = "如果第一次结果像营销话术，请改写得更像普通用户自然留言。" if strict_retry else ""
        return (
            "你是抖音评论区互动助手。"
            "请根据内容标题生成 1 条中文评论，像普通用户自然留言。"
            "必须遵守以下规则："
            "1. 只输出评论正文，不要解释；"
            "2. 语气真诚、简短、自然，长度控制在 10 到 28 个汉字；"
            "3. 不得包含联系方式、引流、私信、主页、加好友、链接、二维码、价格承诺、夸大宣传；"
            "4. 不得包含色情、暴力、政治、辱骂、违法违规内容；"
            "5. 不要使用 emoji、标签、英文口号、连续感叹号；"
            "6. 优先评价内容价值、观点、经验或氛围，避免销售感。"
            f"{retry_line}"
        )

    def _human_prompt(self, title: str, keyword: str) -> str:
        keyword_text = keyword or "未提供"
        return f"标题：{title}\n搜索关键词：{keyword_text}\n请生成一条合规、自然、适合发布在抖音评论区的回复。"

    def _normalize_openai_base_url(self, base_url: str) -> str:
        clean_base = base_url.rstrip("/")
        if clean_base.endswith("/chat/completions"):
            clean_base = clean_base[: -len("/chat/completions")]
        return clean_base

    def _extract_response_text(self, response) -> Optional[str]:
        if response is None:
            return None

        content = getattr(response, "content", response)
        if isinstance(content, str):
            return content.strip()

        if isinstance(content, list):
            parts = []
            for item in content:
                if isinstance(item, str):
                    parts.append(item)
                    continue
                if isinstance(item, dict):
                    text = item.get("text")
                    if text:
                        parts.append(str(text))
            merged = "".join(parts).strip()
            return merged or None

        return str(content).strip() or None

    def _sanitize_reply(self, text: Optional[str]) -> Optional[str]:
        if not text:
            return None

        cleaned = self._normalize_text(text)
        cleaned = re.sub(r"^评论[:：]\s*", "", cleaned)
        cleaned = cleaned.strip("\"' ")
        cleaned = re.sub(r"[#@]", "", cleaned)
        cleaned = re.sub(r"[!！]{2,}", "！", cleaned)
        cleaned = re.sub(r"[?？]{2,}", "？", cleaned)
        cleaned = cleaned.replace("“", "").replace("”", "")
        return cleaned[:38].strip()

    def _is_valid_reply(self, text: Optional[str]) -> bool:
        if not text:
            return False

        if len(text) < 6 or len(text) > 38:
            return False

        if "\n" in text or "\r" in text:
            return False

        for pattern in self._BANNED_PATTERNS:
            if pattern.search(text):
                return False

        if text.count("！") > 1 or text.count("？") > 1:
            return False

        return True

    def _sanitize_lead_reply(self, text: Optional[str]) -> Optional[str]:
        if not text:
            return None
        cleaned = self._normalize_text(text)
        cleaned = re.sub(r"^回复[:：]\s*", "", cleaned)
        cleaned = cleaned.strip("\"' ")
        cleaned = re.sub(r"[#@]", "", cleaned)
        cleaned = re.sub(r"[!！]{2,}", "！", cleaned)
        cleaned = re.sub(r"[?？]{2,}", "？", cleaned)
        return cleaned[:40].strip()

    def _is_valid_lead_reply(self, text: Optional[str]) -> bool:
        if not text:
            return False
        if len(text) < 6 or len(text) > 40:
            return False
        if "\n" in text or "\r" in text:
            return False
        banned_patterns = [
            re.compile(r"(微信|vx|v信|威信|加我|联系我|私信|私聊|进群)", re.IGNORECASE),
            re.compile(r"(http[s]?://|www\.|douyin\.com|v\.douyin\.com)", re.IGNORECASE),
            re.compile(r"(QQ|qq|电话|手机号|微信号|二维码)"),
            re.compile(r"\d{7,}"),
            re.compile(r"(保证|包过|稳赚|返利|刷单)"),
        ]
        return not any(pattern.search(text) for pattern in banned_patterns)

    def _local_intent_guess(self, text: str, custom_keywords: list = None) -> bool:
        custom_keywords = custom_keywords or []
        
        default_pattern = r"(怎么买|哪里|求|想要|了解|价格|多少|推荐|教程|方法|链接|资料|怎么做|靠谱吗|有用吗)"
        if re.search(default_pattern, text):
            return True
        
        return self._check_custom_keywords(text, custom_keywords)
    
    def _check_custom_keywords(self, text: str, custom_keywords: list) -> bool:
        if not custom_keywords:
            return False
        
        # 先清洗再去重，避免 " 关键词" 和 "关键词" 被当成两条。
        unique_keywords = list(dict.fromkeys(k.strip() for k in custom_keywords if str(k).strip()))
        
        for keyword in unique_keywords:
            if keyword in text:
                logger.info(f"🔍 命中自定义意向关键词: '{keyword}'")
                return True
        
        return False

    def _build_lead_fallback(self, comment_text: str) -> str:
        if re.search(r"(哪里|怎么买|价格|多少|链接)", comment_text):
            return "我主页有整理，可以先看下"
        if re.search(r"(教程|方法|怎么做|资料)", comment_text):
            return "主页放了相关整理，可以参考"
        return "这个我主页有说，可以看看"

    def _build_safe_fallback(self, title: str) -> str:
        if re.search(r"(教程|攻略|干货|方法|步骤|技巧|避坑)", title):
            return "这个思路很实用，先收藏慢慢看"
        if re.search(r"(测评|评测|对比|开箱)", title):
            return "对比得很清楚，确实有参考价值"
        if re.search(r"(穿搭|妆容|护肤|发型)", title):
            return "这条内容很有参考性，思路挺清晰"
        if re.search(r"(旅行|探店|民宿|拍照|城市)", title):
            return "这条分享很有氛围感，信息也挺实用"
        if re.search(r"(健身|减脂|跑步|饮食|运动)", title):
            return "内容很清晰，照着做会更容易坚持"
        return "内容讲得挺清楚，确实有参考价值"

    def _normalize_text(self, text: Optional[str]) -> str:
        if not text:
            return ""
        return re.sub(r"\s+", " ", str(text)).strip()
