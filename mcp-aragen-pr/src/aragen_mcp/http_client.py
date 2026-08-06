import logging

import httpx

from .config import Settings
from .errors import AragenApiError

logger = logging.getLogger("aragen_mcp.http")

_GET_RETRY_ATTEMPTS = 2


class AragenClient:
    """Thin wrapper around the Aragen PR Portal's existing REST endpoints.

    Authenticates via the X-MCP-Api-Key header (see McpApiKeySecurityConfig on the
    Java side) - no cookies, no CSRF token, no session to manage.
    """

    def __init__(self, settings: Settings):
        self._client = httpx.AsyncClient(
            base_url=settings.base_url,
            headers={"X-MCP-Api-Key": settings.api_key},
            timeout=settings.timeout,
        )

    async def aclose(self):
        await self._client.aclose()

    async def get(self, path: str, params: dict | None = None) -> object:
        last_error: Exception | None = None
        for attempt in range(1, _GET_RETRY_ATTEMPTS + 1):
            try:
                logger.debug("GET %s params=%s (attempt %d)", path, params, attempt)
                response = await self._client.get(path, params=_clean(params))
                return self._parse(response)
            except httpx.TransportError as exc:
                last_error = exc
                logger.warning("GET %s transport error on attempt %d: %s", path, attempt, exc)
        raise last_error

    async def post(self, path: str, json_body: dict) -> object:
        # No retry here: a retried write can double-post a PR to SAP.
        logger.debug("POST %s", path)
        response = await self._client.post(path, json=json_body)
        return self._parse(response)

    @staticmethod
    def _parse(response: httpx.Response) -> object:
        if response.status_code >= 400:
            try:
                body = response.json()
            except ValueError:
                body = response.text
            raise AragenApiError(response.status_code, body)
        if not response.content:
            return None
        try:
            return response.json()
        except ValueError:
            return response.text


def _clean(params: dict | None) -> dict | None:
    if params is None:
        return None
    return {k: v for k, v in params.items() if v is not None}
