import logging
import os
import re
from typing import Optional

from dotenv import load_dotenv
from social_license import CloudAIClient, LicenseError

load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env"), override=True)

logger = logging.getLogger(__name__)
LANGCHAIN_IMPORT_ERROR = None

try:
    from langchain_core.messages import HumanMessage, SystemMessage
    from langchain_openai import ChatOpenAI
except ImportError:  # pragma: no cover - optional dependency
    LANGCHAIN_IMPORT_ERROR = "缺少 `langchain-openai` 或其依赖，请在当前虚拟环境执行 `pip install langchain-openai openai`。"
    HumanMessage = None
    SystemMessage = None
    ChatOpenAI = None


class XHSReplyAgent:
    """根据标题生成合规的小红书评论回复。"""

    _BANNED_PATTERNS = [
        re.compile(r"(微信|vx|v信|威信|加我|联系我|私信我|私聊我|主页|进群)", re.IGNORECASE),
        re.compile(r"(http[s]?://|www\.|xhslink\.com)", re.IGNORECASE),
        re.compile(r"(QQ|qq|电话|手机号|微信号|二维码)"),
        re.compile(r"\d{7,}"),
        re.compile(r"(最便宜|保证|包过|稳赚|返利|代购|招代理|兼职|刷单)"),
        re.compile(r"(政治|色情|赌博|毒品|辱骂|仇恨|暴力)"),
    ]

    def __init__(self, config: Optional[dict] = None):
        self.config = config or {}
        self.ai_config = self.config.get("ai_reply", {})
        self.cloud_ai = CloudAIClient(self.ai_config, platform="xhs")

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

    def _call_model(self, title: str, keyword: str, strict_retry: bool = False) -> Optional[str]:
        if self.cloud_ai.enabled():
            try:
                data = self.cloud_ai.post("/ai/generate-video-comment", {
                    "keyword": keyword,
                    "title": title,
                })
                return data.get("reply")
            except LicenseError as exc:
                logger.error(f"云端 AI 生成小红书评论失败: {exc}")
                return None

        if self.ai_config.get("mode", "cloud") != "local":
            logger.warning("未配置授权码，无法调用云端 AI 生成小红书评论。")
            return None

        base_url = (
            os.environ.get("DEEPSEEK_BASE_URL")
            or os.environ.get("DASHSCOPE_BASE_URL")
            or (self.ai_config.get("base_url") or "").strip()
        )
        api_key = (
            os.environ.get("DEEPSEEK_API_KEY")
            or os.environ.get("DASHSCOPE_API_KEY")
            or (self.ai_config.get("api_key") or "").strip()
        )
        model = (
            os.environ.get("DEEPSEEK_MODEL")
            or os.environ.get("DASHSCOPE_MODEL")
            or (self.ai_config.get("model") or "").strip()
        )

        if not base_url or not api_key or not model:
            logger.warning("AI 回复配置不完整，需要填写 Base URL、API Key 和 Model。")
            return None

        if not all([ChatOpenAI, SystemMessage, HumanMessage]):
            logger.error(f"LangChain 依赖不可用，无法调用 AI 回复接口。{LANGCHAIN_IMPORT_ERROR or ''}")
            return None

        return self._call_langchain(title, keyword, base_url, api_key, model, strict_retry)

    def _call_langchain(self, title: str, keyword: str, base_url: str, api_key: str, model: str, strict_retry: bool) -> Optional[str]:
        try:
            llm = ChatOpenAI(
                base_url=self._normalize_openai_base_url(base_url),
                api_key=api_key,
                model=model,
                temperature=float(self.ai_config.get("temperature", 0.7)),
                max_tokens=int(self.ai_config.get("max_tokens", 120)),
                timeout=int(self.ai_config.get("timeout", 60)),
            )
            messages = [
                SystemMessage(content=self._system_prompt(strict_retry)),
                HumanMessage(content=self._human_prompt(title, keyword)),
            ]
            response = llm.invoke(messages)
            return self._extract_response_text(response)
        except Exception as exc:
            logger.error(f"LangChain 调用 AI 回复失败: {exc}")
            return None

    def _system_prompt(self, strict_retry: bool) -> str:
        retry_line = "如果第一次结果像营销话术，请改写得更像普通用户自然留言。" if strict_retry else ""
        return (
            "你是小红书评论区互动助手。"
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
        return f"标题：{title}\n搜索关键词：{keyword_text}\n请生成一条合规、自然、适合发布在小红书评论区的回复。"

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
        return ""

    def _normalize_text(self, text: Optional[str]) -> str:
        if not text:
            return ""
        return re.sub(r"\s+", " ", str(text)).strip()
