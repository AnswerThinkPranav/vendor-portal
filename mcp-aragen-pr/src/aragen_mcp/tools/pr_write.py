"""PR write tools - these post real, largely irreversible transactions to SAP.

Every tool here is annotated destructiveHint=True, idempotentHint=False: retrying a
timed-out create_* call creates a SECOND SAP PR, it does not retry/replace the first.
Calling agents should confirm the assembled PR (materials, quantities, prices, total)
with the user before invoking create_material_pr/create_service_pr, and must not
blindly retry on timeout - check list_purchase_requisitions/get_purchase_requisition
first to see whether the original call actually succeeded.
"""

from typing import Any

import httpx
from mcp.server.mcpserver import Context
from mcp.types import ToolAnnotations

from ..errors import AragenApiError
from ..models.pr import PRRequest
from ..models.responses import SapPostResult
from ..server import mcp

_UNKNOWN_OUTCOME_NOTE = (
    "Unknown outcome - do not blindly retry. Check get_purchase_requisition or "
    "list_purchase_requisitions before resubmitting to avoid double-posting to SAP."
)

WRITE_SAP_POST = ToolAnnotations(
    readOnlyHint=False, destructiveHint=True, idempotentHint=False, openWorldHint=False
)
WRITE_SIDE_EFFECT = ToolAnnotations(
    readOnlyHint=False, destructiveHint=False, idempotentHint=False, openWorldHint=False
)


def _client(ctx: Context):
    return ctx.request_context.lifespan_context.client


async def _post_pr(ctx: Context, path: str, pr: PRRequest) -> dict:
    try:
        raw = await _client(ctx).post(path, pr.model_dump(mode="json", exclude_none=True))
    except AragenApiError as exc:
        return {
            "success": False,
            "http_status": exc.status_code,
            "error": exc.raw_body,
            "note": _UNKNOWN_OUTCOME_NOTE,
        }
    except httpx.TransportError as exc:
        return {
            "success": False,
            "error": str(exc),
            "note": _UNKNOWN_OUTCOME_NOTE,
        }

    result = SapPostResult.model_validate(raw) if isinstance(raw, dict) else SapPostResult()
    status_text = (result.status or "").upper()
    return {
        "success": status_text in ("S", "SUCCESS") or bool(result.sapPrNumber),
        "sap_pr_number": result.sapPrNumber,
        "status": result.status,
        "message": result.message,
        "raw": raw,
    }


@mcp.tool(annotations=WRITE_SAP_POST)
async def create_material_pr(pr: PRRequest, ctx: Context) -> dict:
    """Create and post a material Purchase Requisition to SAP (ZBAPI_PR_CREATE).
    Irreversible and non-idempotent - confirm the assembled items with the user first,
    and never retry blindly on timeout. Returns the SAP PR number on success."""
    return await _post_pr(ctx, "prCreate/postPR", pr)


@mcp.tool(annotations=WRITE_SAP_POST)
async def create_service_pr(pr: PRRequest, ctx: Context) -> dict:
    """Create and post a Service Purchase Requisition to SAP (items carry nested
    service lines). Irreversible and non-idempotent - confirm with the user first."""
    return await _post_pr(ctx, "prCreate/postServicePR", pr)


@mcp.tool(annotations=WRITE_SAP_POST)
async def update_material_pr(pr: PRRequest, ctx: Context) -> dict:
    """Update an existing material PR. pr.reqNumber must be set - fetch the current
    item list with get_purchase_requisition first so this call carries the full,
    correct item set (this endpoint replaces, not merges)."""
    if not pr.reqNumber:
        return {"success": False, "error": "reqNumber is required for update_material_pr"}
    return await _post_pr(ctx, "/prCreate/update", pr)


@mcp.tool(annotations=WRITE_SAP_POST)
async def update_service_pr(pr: PRRequest, ctx: Context) -> dict:
    """Update an existing Service PR. pr.reqNumber must be set - fetch the current
    item/service list with get_purchase_requisition first."""
    if not pr.reqNumber:
        return {"success": False, "error": "reqNumber is required for update_service_pr"}
    return await _post_pr(ctx, "/prCreate/updateServicePR", pr)


@mcp.tool(annotations=WRITE_SIDE_EFFECT)
async def send_pr_reminder(pr_id: str, ctx: Context) -> dict:
    """Send a reminder email for a pending PR."""
    try:
        data: Any = await _client(ctx).post(f"/sendReminder/{pr_id}", {})
        return {"success": True, "data": data}
    except AragenApiError as exc:
        return {"success": False, "http_status": exc.status_code, "error": exc.raw_body}
    except httpx.TransportError as exc:
        return {"success": False, "error": str(exc)}
