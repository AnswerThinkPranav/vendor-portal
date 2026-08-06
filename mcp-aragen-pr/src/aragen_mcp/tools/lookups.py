"""Read-only master-data lookup tools, one per GET endpoint on PRController.

All tools here are safe to call speculatively while assembling a PR - none of them
mutate SAP or the portal's own data (trigger_master_sync refreshes a local master-data
cache and is the one exception, flagged accordingly).
"""

from mcp.server.mcpserver import Context
from mcp.types import ToolAnnotations

from ..errors import AragenApiError
from ..server import mcp

READ_ONLY = ToolAnnotations(readOnlyHint=True, destructiveHint=False, idempotentHint=True, openWorldHint=False)


def _client(ctx: Context):
    return ctx.request_context.lifespan_context.client


async def _get_or_warn(ctx: Context, path: str, params: dict) -> dict:
    try:
        data = await _client(ctx).get(path, params)
        return {"success": True, "data": data}
    except AragenApiError as exc:
        return {"success": False, "warning": str(exc), "data": []}


@mcp.tool(annotations=READ_ONLY)
async def list_departments(division: str, plant: str, ctx: Context) -> dict:
    """List department codes for a division/plant, for use as PRItem.department."""
    return await _get_or_warn(ctx, "/getDepartments", {"division": division, "plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def list_storage_locations(plant: str, ctx: Context) -> dict:
    """List storage locations for a plant, for use as PRItem.storageLoc."""
    return await _get_or_warn(ctx, "/getStorageLocations", {"plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def list_material_groups(plant: str, ctx: Context) -> dict:
    """List material groups for a plant, for use as PRItem.materialGroup."""
    return await _get_or_warn(ctx, "/getMaterialGroup", {"plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def search_materials(plant: str, query: str, search_type: str, ctx: Context) -> dict:
    """Search materials by code/description on a plant. Returns candidates with matNumber
    to use as PRItem.matNumber - call get_material_details next to fill UOM/price/group."""
    return await _get_or_warn(ctx, "/getMaterials", {"plant": plant, "query": query, "searchType": search_type})


@mcp.tool(annotations=READ_ONLY)
async def search_materials_from_cas(cas_number: str, ctx: Context) -> dict:
    """Search materials by CAS number."""
    return await _get_or_warn(ctx, "/getMaterialsFromCas", {"casNumber": cas_number})


@mcp.tool(annotations=READ_ONLY)
async def search_materials_from_catalog(catalog_number: str, ctx: Context) -> dict:
    """Search materials by catalog number (ZANB document type)."""
    return await _get_or_warn(ctx, "/getMaterialsFromCatalog", {"catalogNumber": catalog_number})


@mcp.tool(annotations=READ_ONLY)
async def get_material_details(plant: str, material_code: str, ctx: Context) -> dict:
    """Fetch UOM, material group, price, and CAS/catalog details for a chosen material."""
    return await _get_or_warn(ctx, "/getMaterialDetails", {"plant": plant, "materialCode": material_code})


@mcp.tool(annotations=READ_ONLY)
async def search_wbs_elements(plant: str, ctx: Context, query: str | None = None) -> dict:
    """Search WBS elements for a plant. Use when accAsmt is P or Q, to fill PRItem.wbsElement."""
    return await _get_or_warn(ctx, "/getWBSElements", {"plant": plant, "query": query})


@mcp.tool(annotations=READ_ONLY)
async def list_gl_accounts(plant: str, ctx: Context) -> dict:
    """List GL accounts for a plant, for use as PRItem.glAcc."""
    return await _get_or_warn(ctx, "/getGLAcct", {"plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def list_project_codes(plant: str, ctx: Context) -> dict:
    """List project/WBS codes for a plant, for use as PRItem.projCode."""
    return await _get_or_warn(ctx, "/getProjCode", {"plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def list_cost_centers(ctx: Context) -> dict:
    """List cost centers. Use when accAsmt is K, to fill PRItem.costCenter."""
    return await _get_or_warn(ctx, "/getCostCenter", {})


@mcp.tool(annotations=READ_ONLY)
async def list_reasons(ctx: Context) -> dict:
    """List reason codes, used for ZCSP document type PRItem.reason."""
    return await _get_or_warn(ctx, "/getReason", {})


@mcp.tool(annotations=READ_ONLY)
async def list_internal_orders(ctx: Context) -> dict:
    """List internal orders. Use when accAsmt is F, to fill PRItem.internalOrder."""
    return await _get_or_warn(ctx, "/getInternalOrders", {})


@mcp.tool(annotations=READ_ONLY)
async def list_networks(plant: str, ctx: Context) -> dict:
    """List networks for a plant. Use when accAsmt is N, to fill PRItem.network."""
    return await _get_or_warn(ctx, "/getNetwork", {"plant": plant})


@mcp.tool(annotations=READ_ONLY)
async def search_service_codes(plant: str, mat_group: str, ctx: Context) -> dict:
    """Search service codes for a plant/material group, for Service PR line items (PRService.servNo)."""
    return await _get_or_warn(ctx, "/getServiceCode", {"plant": plant, "matGroup": mat_group})


@mcp.tool(annotations=READ_ONLY)
async def list_agreements(plant: str, material_code: str, ctx: Context) -> dict:
    """List purchasing agreements/vendors for a plant+material (ZOSO document type),
    for PRItem.agreement/aggrItem/fixVendor."""
    return await _get_or_warn(ctx, "/getAggrements", {"plant": plant, "materialCode": material_code})


@mcp.tool(annotations=READ_ONLY)
async def check_release_strategy(plant: str, pur_grp: str, division: str, department: str, ctx: Context) -> dict:
    """Check whether SAP has a release (approval) strategy maintained for this
    plant/purchasing-group/division/department combination. Advisory only - it does
    not block posting, but call it before create_material_pr/create_service_pr and
    report the result to the user so they know the PR's approval routing is set up."""
    return await _get_or_warn(
        ctx,
        "/checkReleaseStrategy",
        {"plant": plant, "purGrp": pur_grp, "division": division, "department": department},
    )


@mcp.tool(
    annotations=ToolAnnotations(readOnlyHint=False, destructiveHint=False, idempotentHint=True, openWorldHint=False)
)
async def trigger_master_sync(key: str, ctx: Context) -> dict:
    """Trigger a refresh of SAP-backed master data cached by the portal.
    key must be 'SERVICECD' or 'NETWORK'."""
    if key not in ("SERVICECD", "NETWORK"):
        return {"success": False, "warning": "key must be 'SERVICECD' or 'NETWORK'"}
    return await _get_or_warn(ctx, f"/master/sync/{key}", {})
