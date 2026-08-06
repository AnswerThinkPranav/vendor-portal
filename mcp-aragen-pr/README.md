# Aragen PR Portal MCP Server

Standalone MCP server (stdio transport) exposing the Aragen PR Portal's material/service
lookups, PR listing, and PR creation/update/SAP-posting flow as MCP tools, so an MCP
client (Claude Desktop, Claude Code) can create and manage Purchase Requisitions.

This talks to the existing Spring Boot app over plain HTTP using a dedicated
`X-MCP-Api-Key` header - see the backend changes in
`src/main/java/com/ezc/aragenPR/webapp/config/security/` (`McpApiKeySecurityConfig`,
`McpApiKeyAuthFilter`, `McpServiceAccountSeeder`) and the additive JSON read API in
`src/main/java/com/ezc/aragenPR/webapp/controller/mcp/McpPrQueryController.java`.

## One-time backend setup

1. Generate a BCrypt hash of a random API key (any BCrypt tool, or run once in a
   Python REPL: `import bcrypt; bcrypt.hashpw(b"<your-key>", bcrypt.gensalt())`).
2. Set `MCP_API_KEY_HASH` to that hash as an environment variable wherever the Java
   app runs. The app auto-provisions a dedicated `mcp-service-account` `Users` row on
   startup (see `McpServiceAccountSeeder`) - no manual seed SQL needed.
3. Point this server's `ARAGEN_BASE_URL` at that deployment, and `ARAGEN_MCP_API_KEY`
   at the *raw* key from step 1 (never the hash).

Start with a dev/QA deployment whose SAP JCo destination targets an SAP **test**
client - the four PR-write tools below post real, largely irreversible transactions.

## Install

```
python -m venv .venv
.venv/Scripts/activate   # .venv/bin/activate on macOS/Linux
pip install -e ".[dev]"
```

## Configure

Copy `.env.example` to `.env` and fill in `ARAGEN_BASE_URL` / `ARAGEN_MCP_API_KEY`.

## Run standalone / inspect

```
python -m aragen_mcp
```

**Always run it as `python -m aragen_mcp` (the package) or via the installed
`aragen-mcp` console script - never `python -m aragen_mcp.server` (the submodule).**
Running the submodule directly as `__main__` causes Python to import
`aragen_mcp.server` a second time under its normal dotted name (since `tools/*.py`
imports it that way too), producing two separate `MCPServer` instances: one that
`main()` actually serves, and a different one that all the `@mcp.tool()` decorators
registered onto. The symptom is a connector that connects fine but reports zero
tools. `python -m aragen_mcp` and the `aragen-mcp` console script both avoid this by
only ever importing `aragen_mcp.server` via its normal dotted path.

Or use the MCP CLI's dev inspector if installed (`mcp dev src/aragen_mcp/server.py`)
to call tools interactively without a full client.

## Register with Claude Desktop / Claude Code

Add to `claude_desktop_config.json` (or the CLI's `.mcp.json`):

```json
{
  "mcpServers": {
    "aragen-pr": {
      "command": "python",
      "args": ["-m", "aragen_mcp"],
      "env": {
        "ARAGEN_BASE_URL": "http://dev-host:8081",
        "ARAGEN_MCP_API_KEY": "<dev-key>"
      }
    }
  }
}
```

## Tools

- **Lookups** (read-only): `list_departments`, `list_storage_locations`,
  `list_material_groups`, `search_materials`, `search_materials_from_cas`,
  `search_materials_from_catalog`, `get_material_details`, `search_wbs_elements`,
  `list_gl_accounts`, `list_project_codes`, `list_cost_centers`, `list_reasons`,
  `list_internal_orders`, `list_networks`, `search_service_codes`, `list_agreements`,
  `check_release_strategy`, `trigger_master_sync`.
- **PR read** (read-only): `list_purchase_requisitions`,
  `list_purchase_requisitions_by_doc_type`, `get_purchase_requisition`.
- **PR write** (destructive, non-idempotent - see docstrings before use):
  `create_material_pr`, `create_service_pr`, `update_material_pr`,
  `update_service_pr`, `send_pr_reminder`.

Typical flow: resolve department/storage location/material group -> search for the
material (or service code) -> resolve exactly one account-assignment lookup based on
the intended `accAsmt` (F->internal order, P/Q->WBS element, N->network, K->cost
center) -> assemble the item -> call `check_release_strategy` and report it to the
user -> confirm the assembled PR with the user -> `create_material_pr` /
`create_service_pr`.

**Never retry a write tool call blindly** - a retried `create_*` call posts a second,
distinct SAP PR, it does not resend/replace the first. On any uncertain outcome
(timeout, network error), use `get_purchase_requisition` / `list_purchase_requisitions`
to check whether the original call actually went through before deciding what to do
next.

## Tests

```
pytest tests/ -v
```
