import os
from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class Settings:
    base_url: str
    api_key: str
    timeout: float


def load_settings() -> Settings:
    base_url = os.environ.get("ARAGEN_BASE_URL")
    api_key = os.environ.get("ARAGEN_MCP_API_KEY")

    if not base_url:
        raise RuntimeError("ARAGEN_BASE_URL is not set")
    if not api_key:
        raise RuntimeError("ARAGEN_MCP_API_KEY is not set")

    timeout = float(os.environ.get("ARAGEN_HTTP_TIMEOUT", "30"))

    return Settings(base_url=base_url.rstrip("/"), api_key=api_key, timeout=timeout)
