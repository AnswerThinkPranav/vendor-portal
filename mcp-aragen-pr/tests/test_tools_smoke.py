"""Exercises the tool functions directly (bypassing the MCP protocol/session layer,
which is already verified separately via mcp.list_tools()) against a mocked Aragen
backend, to check argument mapping, pydantic validation, and response shaping."""

from types import SimpleNamespace

import httpx
import pytest
import respx

from aragen_mcp.config import Settings
from aragen_mcp.http_client import AragenClient
from aragen_mcp.tools import lookups, pr_write


def _ctx_with_client(client: AragenClient):
    return SimpleNamespace(request_context=SimpleNamespace(lifespan_context=SimpleNamespace(client=client)))


@pytest.mark.asyncio
async def test_search_materials_success():
    client = AragenClient(Settings(base_url="http://test-host", api_key="secret-key", timeout=5))
    try:
        with respx.mock(base_url="http://test-host") as respx_mock:
            respx_mock.get("/getMaterials", params={"plant": "1000", "query": "acid", "searchType": "desc"}).mock(
                return_value=httpx.Response(200, json=[{"matNumber": "MAT001", "shortText": "Acetic Acid"}])
            )

            result = await lookups.search_materials("1000", "acid", "desc", _ctx_with_client(client))

            sent_headers = respx_mock.calls.last.request.headers
            assert sent_headers["X-MCP-Api-Key"] == "secret-key"
            assert result["success"] is True
            assert result["data"][0]["matNumber"] == "MAT001"
    finally:
        await client.aclose()


@pytest.mark.asyncio
async def test_search_materials_backend_error_returns_warning_not_exception():
    client = AragenClient(Settings(base_url="http://test-host", api_key="secret-key", timeout=5))
    try:
        with respx.mock(base_url="http://test-host") as respx_mock:
            respx_mock.get("/getMaterials").mock(return_value=httpx.Response(500, json={"error": "boom"}))

            result = await lookups.search_materials("1000", "acid", "desc", _ctx_with_client(client))

            assert result["success"] is False
            assert result["data"] == []
    finally:
        await client.aclose()


def _valid_pr_payload():
    return {
        "docType": "ZNB",
        "plant": "1000",
        "purGrp": "P01",
        "division": "D1",
        "department": "DEPT1",
        "accAsmt": "K",
        "items": [
            {
                "matNumber": "MAT001",
                "shortText": "Acetic Acid",
                "quantity": "5",
                "uom": "EA",
                "plant": "1000",
                "valPrice": "10.50",
                "deliveryDate": "2026-09-01",
                "accAsmt": "K",
                "costCenter": "CC100",
            }
        ],
    }


@pytest.mark.asyncio
async def test_create_material_pr_success():
    from aragen_mcp.models.pr import PRRequest

    client = AragenClient(Settings(base_url="http://test-host", api_key="secret-key", timeout=5))
    try:
        with respx.mock(base_url="http://test-host") as respx_mock:
            respx_mock.post("/prCreate/postPR").mock(
                return_value=httpx.Response(
                    200, json={"status": "S", "sapPrNumber": "4500001234", "message": "OK"}
                )
            )

            pr = PRRequest.model_validate(_valid_pr_payload())
            result = await pr_write.create_material_pr(pr, _ctx_with_client(client))

            sent_body = respx_mock.calls.last.request.content
            assert result["success"] is True
            assert result["sap_pr_number"] == "4500001234"
            assert b"MAT001" in sent_body
            assert b"2026-09-01" in sent_body
    finally:
        await client.aclose()


@pytest.mark.asyncio
async def test_create_material_pr_network_error_reports_unknown_outcome_and_does_not_retry():
    client = AragenClient(Settings(base_url="http://test-host", api_key="secret-key", timeout=5))
    try:
        with respx.mock(base_url="http://test-host") as respx_mock:
            route = respx_mock.post("/prCreate/postPR").mock(side_effect=httpx.ConnectTimeout("timed out"))

            from aragen_mcp.models.pr import PRRequest

            pr = PRRequest.model_validate(_valid_pr_payload())
            result = await pr_write.create_material_pr(pr, _ctx_with_client(client))

            assert route.call_count == 1
            assert result["success"] is False
            assert "do not blindly retry" in result["note"]
    finally:
        await client.aclose()


def test_pr_item_rejects_missing_account_assignment_field():
    from pydantic import ValidationError

    from aragen_mcp.models.pr import PRItem

    payload = _valid_pr_payload()["items"][0]
    del payload["costCenter"]

    with pytest.raises(ValidationError):
        PRItem.model_validate(payload)
