import logging
import os
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from dataclasses import dataclass

from mcp.server.mcpserver import MCPServer

from .config import load_settings
from .http_client import AragenClient

logging.basicConfig(level=logging.INFO)


@dataclass
class AppContext:
    client: AragenClient


@asynccontextmanager
async def app_lifespan(_server: MCPServer) -> AsyncIterator[AppContext]:
    settings = load_settings()
    client = AragenClient(settings)
    try:
        yield AppContext(client=client)
    finally:
        await client.aclose()


mcp = MCPServer("aragen-pr", lifespan=app_lifespan)


def run_http() -> None:
    """Serve over streamable-http for use with a public tunnel (e.g. ngrok) and a
    Claude.ai custom connector.

    Claude.ai's "Add custom connector" dialog does not always offer a Request
    headers field (it's a beta Anthropic is still rolling out), so a header-based
    credential can't be relied on as the default protection. Instead the mandatory
    credential is a long random secret baked into the URL PATH itself
    (MCP_HTTP_PATH_TOKEN) - the same "capability URL" pattern webhook URLs use.
    Whoever holds the exact URL can reach the server; without it, requests to the
    well-known /mcp path 404 rather than reaching the tool-call layer.

    If MCP_HTTP_API_KEY is also set, an additional x-api-key header check is
    layered on top - useful once header-auth is available on your account, but
    optional so this still works today without it.
    """
    import uvicorn
    from mcp.server.transport_security import TransportSecuritySettings

    from .http_auth import ApiKeyAuthMiddleware

    path_token = os.environ.get("MCP_HTTP_PATH_TOKEN")
    if not path_token:
        raise RuntimeError(
            "MCP_HTTP_PATH_TOKEN is not set - refusing to start an unauthenticated public "
            "transport at the predictable path /mcp. Generate one, e.g.: "
            "python -c \"import secrets; print(secrets.token_urlsafe(32))\""
        )

    host = os.environ.get("MCP_HTTP_HOST", "127.0.0.1")
    port = int(os.environ.get("MCP_HTTP_PORT", "8000"))
    streamable_http_path = f"/mcp/{path_token}"

    # The MCP SDK rejects requests whose Host/Origin header isn't on an explicit
    # allowlist (DNS-rebinding protection) - a public tunnel's hostname must be
    # added here or every request gets 421 Misdirected Request.
    extra_hosts = [h.strip() for h in os.environ.get("MCP_HTTP_ALLOWED_HOSTS", "").split(",") if h.strip()]
    extra_origins = [o.strip() for o in os.environ.get("MCP_HTTP_ALLOWED_ORIGINS", "").split(",") if o.strip()]
    transport_security = TransportSecuritySettings(
        allowed_hosts=["127.0.0.1", f"127.0.0.1:{port}", "localhost", f"localhost:{port}", *extra_hosts],
        allowed_origins=[f"http://127.0.0.1:{port}", f"http://localhost:{port}", *extra_origins],
    )

    app = mcp.streamable_http_app(
        streamable_http_path=streamable_http_path, host=host, transport_security=transport_security
    )

    header_name = os.environ.get("MCP_HTTP_AUTH_HEADER", "x-api-key")
    expected_key = os.environ.get("MCP_HTTP_API_KEY")
    if expected_key:
        app = ApiKeyAuthMiddleware(app, header_name, expected_key)

    logging.getLogger("aragen_mcp").info(
        "Streamable-http endpoint mounted at %s (path token is the credential - keep it secret)",
        streamable_http_path,
    )

    config = uvicorn.Config(app, host=host, port=port, log_level="info")
    uvicorn.Server(config).run()


def main() -> None:
    from . import tools  # noqa: F401  (import registers @mcp.tool() decorators)

    transport = os.environ.get("MCP_TRANSPORT", "stdio")
    if transport == "stdio":
        mcp.run()
    elif transport in ("http", "streamable-http"):
        run_http()
    else:
        raise RuntimeError(f"Unknown MCP_TRANSPORT: {transport!r}")


if __name__ == "__main__":
    main()
