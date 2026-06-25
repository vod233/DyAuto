import logging
import os
import platform
import uuid
from pathlib import Path
from typing import Any, Optional
from urllib.parse import urlparse

import requests


DEFAULT_LICENSE_SERVER_URL = "https://lcjx.yun/social-ai-credit-api"
REQUEST_TIMEOUT = 20
APP_VERSION = "socialautoagent-desktop"

logger = logging.getLogger(__name__)


class LicenseError(RuntimeError):
    pass


def mask_license_key(value: str) -> str:
    clean = (value or "").strip()
    if not clean:
        return ""
    if len(clean) <= 12:
        return f"{clean[:3]}***{clean[-2:]}"
    return f"{clean[:7]}...{clean[-6:]}"


def normalize_server_url(value: str) -> str:
    clean = (value or DEFAULT_LICENSE_SERVER_URL).strip().rstrip("/")
    if clean.endswith("/api"):
        clean = clean[:-4]
    clean = clean or DEFAULT_LICENSE_SERVER_URL
    parsed = urlparse(clean)
    allow_custom = os.environ.get("SOCIAL_LICENSE_ALLOW_CUSTOM_SERVER", "").strip() == "1"
    if parsed.scheme != "https" and not allow_custom:
        raise LicenseError("授权服务器必须使用 HTTPS")
    if parsed.hostname not in {"lcjx.yun"} and not allow_custom:
        raise LicenseError("授权服务器地址不在允许范围内")
    return clean


def get_machine_id() -> str:
    root = Path(__file__).resolve().parent
    state_dir = root / ".socialautoagent"
    state_dir.mkdir(exist_ok=True)
    machine_file = state_dir / "machine_id"
    try:
        existing = machine_file.read_text(encoding="utf-8").strip()
        if existing:
            return existing
    except Exception:
        pass

    machine_id = f"saam_{uuid.uuid4().hex}"
    try:
        machine_file.write_text(machine_id, encoding="utf-8")
    except Exception as exc:
        logger.warning("写入机器 ID 失败，将使用内存 ID: %s", exc)
    return machine_id


def get_machine_payload(device_id: str = "") -> dict[str, str]:
    hostname = platform.node() or ""
    hostname_hash = ""
    if hostname:
        import hashlib
        hostname_hash = hashlib.sha256(hostname.encode("utf-8")).hexdigest()[:16]
    return {
        "machine_id": get_machine_id(),
        "device_id": device_id or "",
        "hostname_hash": hostname_hash,
        "os_name": f"{platform.system()} {platform.release()}".strip(),
        "app_version": APP_VERSION,
    }


def _parse_error(resp: requests.Response) -> str:
    try:
        data = resp.json()
    except Exception:
        return resp.text[:200] or f"HTTP {resp.status_code}"
    detail = data.get("detail") or data.get("error") or data.get("message") or f"HTTP {resp.status_code}"
    if detail == "invalid license key":
        return "授权码无效，请检查是否复制完整"
    if detail == "license is not active":
        return "授权码已停用，请联系管理员"
    if detail == "insufficient credits":
        return "授权码积分不足，请充值后继续使用"
    return str(detail)


def verify_license(license_key: str, server_url: str = DEFAULT_LICENSE_SERVER_URL, device_id: str = "") -> dict[str, Any]:
    key = (license_key or "").strip()
    if not key:
        raise LicenseError("请先填写授权码")

    url = f"{normalize_server_url(server_url)}/auth/verify"
    try:
        resp = requests.post(
            url,
            json=get_machine_payload(device_id),
            headers={"Authorization": f"Bearer {key}"},
            timeout=REQUEST_TIMEOUT,
        )
    except requests.RequestException as exc:
        raise LicenseError(f"授权服务器连接失败: {exc}") from exc

    if not resp.ok:
        raise LicenseError(_parse_error(resp))

    data = resp.json()
    if not data.get("success"):
        raise LicenseError(data.get("message") or "授权码验证失败")
    return data


class CloudAIClient:
    def __init__(self, ai_config: Optional[dict] = None, platform: str = ""):
        self.ai_config = ai_config or {}
        license_config = self.ai_config.get("license") if isinstance(self.ai_config.get("license"), dict) else {}
        self.license_key = (
            self.ai_config.get("license_key")
            or license_config.get("key")
            or license_config.get("license_key")
            or ""
        ).strip()
        self.server_url = normalize_server_url(
            self.ai_config.get("license_server_url")
            or self.ai_config.get("cloud_base_url")
            or license_config.get("server_url")
            or DEFAULT_LICENSE_SERVER_URL
        )
        self.platform = platform

    def enabled(self) -> bool:
        return bool(self.license_key)

    def post(self, path: str, payload: dict[str, Any]) -> dict[str, Any]:
        if not self.license_key:
            raise LicenseError("未配置授权码，无法调用云端 AI")

        url = f"{self.server_url}/{path.lstrip('/')}"
        body = dict(payload)
        body.setdefault("platform", self.platform)
        body.update({k: v for k, v in get_machine_payload(body.get("device_id", "")).items() if k not in body or not body.get(k)})
        try:
            resp = requests.post(
                url,
                json=body,
                headers={"Authorization": f"Bearer {self.license_key}"},
                timeout=REQUEST_TIMEOUT,
            )
        except requests.RequestException as exc:
            raise LicenseError(f"云端 AI 连接失败: {exc}") from exc

        if not resp.ok:
            raise LicenseError(_parse_error(resp))
        data = resp.json()
        if not data.get("success"):
            raise LicenseError(data.get("message") or "云端 AI 调用失败")
        return data
