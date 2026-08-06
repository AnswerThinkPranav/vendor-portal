"""PR read tools.

These call a small additive JSON API (/api/mcp/prs*) added specifically for MCP use -
PRController's own prCreate/list, prCreate/list/filter, and prCreate/edit only ever
render the prCreation/prList HTML view and cannot serve a non-browser client. See
McpPrQueryController.java. /pending/last15days (SAP status re-sync + fixed fiscal-year
range) is intentionally not wrapped here - deferred, not silently mis-mapped.
"""

from mcp.server.mcpserver import Context
from mcp.types import ToolAnnotations

from ..errors import AragenApiError
from ..server import mcp

READ_ONLY = ToolAnnotations(readOnlyHint=True, destructiveHint=False, idempotentHint=True, openWorldHint=False)


def _client(ctx: Context):
    return ctx.request_context.lifespan_context.client


@mcp.tool(annotations=READ_ONLY)
async def list_purchase_requisitions(
    ctx: Context,
    status: str | None = None,
    from_date: str | None = None,
    to_date: str | None = None,
    created_by: str | None = None,
) -> dict:
    """List PR headers filtered by status (UNRELEASED/PENDING/RELEASED), date range
    (yyyy-MM-dd), and optionally the SAP user id that created them. Omit created_by to
    list across all users."""
    try:
        data = await _client(ctx).get(
            "/api/mcp/prs",
            {"status": status, "fromDate": from_date, "toDate": to_date, "createdBy": created_by},
        )
        return {"success": True, "data": data}
    except AragenApiError as exc:
        return {"success": False, "warning": str(exc), "data": []}


@mcp.tool(annotations=READ_ONLY)
async def list_purchase_requisitions_by_doc_type(
    ctx: Context,
    doc_type: str,
    from_date: str | None = None,
    to_date: str | None = None,
    created_by: str | None = None,
) -> dict:
    """List PR headers filtered by document type and date range (yyyy-MM-dd)."""
    try:
        data = await _client(ctx).get(
            "/api/mcp/prs/by-doc-type",
            {"docType": doc_type, "fromDate": from_date, "toDate": to_date, "createdBy": created_by},
        )
        return {"success": True, "data": data}
    except AragenApiError as exc:
        return {"success": False, "warning": str(exc), "data": []}


@mcp.tool(annotations=READ_ONLY)
async def get_purchase_requisition(req_number: str, ctx: Context) -> dict:
    """Fetch one PR header with its items/services by SAP requisition number.
    Use this to pull the current item list before update_material_pr/update_service_pr."""
    try:
        data = await _client(ctx).get(f"/api/mcp/prs/{req_number}", {})
        return {"success": True, "data": data}
    except AragenApiError as exc:
        if exc.status_code == 404:
            return {"success": False, "warning": f"No PR found for reqNumber {req_number}", "data": None}
        return {"success": False, "warning": str(exc), "data": None}
