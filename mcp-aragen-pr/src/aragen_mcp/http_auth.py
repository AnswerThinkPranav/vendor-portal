import hmac
import json


class ApiKeyAuthMiddleware:
    """Raw ASGI middleware gating every HTTP request behind a fixed header value.

    Sits in front of the MCP Starlette app so unauthenticated requests never reach
    the MCP session/tool-call layer at all - required because a streamable-http
    transport exposed via a public tunnel has no other protection, and the tools
    behind it (create_material_pr etc.) post real SAP transactions.
    """

    def __init__(self, app, header_name: str, expected_key: str):
        self.app = app
        self.header_name = header_name.lower().encode()
        self.expected_key = expected_key

    async def __call__(self, scope, receive, send):
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return

        headers = dict(scope.get("headers") or [])
        presented = headers.get(self.header_name, b"").decode()

        if not presented or not hmac.compare_digest(presented, self.expected_key):
            body = json.dumps({"error": "unauthorized"}).encode()
            await send(
                {
                    "type": "http.response.start",
                    "status": 401,
                    "headers": [(b"content-type", b"application/json")],
                }
            )
            await send({"type": "http.response.body", "body": body})
            return

        await self.app(scope, receive, send)
