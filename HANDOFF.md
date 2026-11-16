# Aragen PR Portal — Session Handoff

Written at the end of a long multi-session build to hand off to whoever continues this work
(possibly on a different machine). Read this before touching code — it explains what exists,
why, and what's genuinely unfinished vs. deliberately deferred.

## What this is

A Spring Boot 3 / Thymeleaf procurement portal, migrating a legacy JSP "Vendor Portal" app
(`Vendor Portal/` folder — legacy reference, not part of the Spring app) to a modern stack.
MySQL via Hibernate (`hibernate.hbm2ddl.auto=update`, no migration tooling yet), Spring Security
form login, SAP integration via JCo (RFC/BAPI) with a brand-new generic OData layer.

### Running it locally
- `$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"` then `.\mvnw.cmd spring-boot:run` (PowerShell
  — **the Bash tool is broken in this environment**, `EPERM uv_spawn bash.exe`; use PowerShell for
  everything shell-related).
- Runs on port 8081. MySQL schema `portal`, user/pass `root`/`root` (see
  `src/main/resources/persistence.properties`).
- Test users (password `Test@1234` for all): `VSHARMA2` (PP buyer), `ADWIVEDI` (VAR), `AEERICH`
  (SITEFI), `AKSHARMA` (BUHEAD), `AMOHNOT` (FIHEAD), `AMITJ` (CEO) — these form a 6-level workflow
  approval chain (template 1005). Vendor users: `100007`/`100012`/`100020`.
- devtools auto-restarts on any `src/main`/`src/main/resources` change — if the app seems stuck,
  check for stale/duplicate `java.exe` processes and restart cleanly via `Start-Process -FilePath
  ".\mvnw.cmd" -ArgumentList "spring-boot:run"` with `JAVA_HOME` set.

### A file was deliberately excluded from git
`users.sql` (repo root) — a raw DB export containing **real vendor company names, real contact
emails/phone numbers, and a password-hash-looking value repeated on every row**. Added to
`.gitignore`. If you need it, it's still on disk locally — just never commit it. If this file
ever did get committed somewhere, that history needs scrubbing.

## Major areas of work, by topic

### 1. UI redesign (sidebar, login, dashboard) — done
Login page and sidebar were redesigned around a deep-slate-charcoal theme (`#1f2937`/`#3b4a5e`/
`#2d3f55` family) with an animated background (blobs/grid/particle-network canvas), replacing the
old bright-blue Aragen branding. The site-wide `--blue-color`/`--blue-color-light` CSS variables
in `layout.html` were repointed to the same charcoal family, so every "vr-" styled page (RFQ, QCF,
Vendor Registration, PR, SES, Reservation) picked up the new theme automatically — plus ~93
hardcoded literal blue hex values were bulk-replaced across 31 template files. Dashboard stat
tiles got entrance animations, a count-up-on-load script, and icon badges. All of this is in
`layout.html`, `login.html`, `fragments/main-sidebar.html`.

### 2. RFQ → QCF → Approval Workflow → Create PO — done, tested end-to-end
Full procurement flow: buyer creates an RFQ against selected vendors from a PR line → vendor
submits a quote with packaging/freight/GST conditions → buyer accepts/rejects/requotes → QCF
(quotation comparison) where buyer splits recommended qty across vendors → submits into the
generic approval workflow (same engine Vendor Registration uses) → each approver forwards/
rejects/sends back, with audit trail + query mechanism → final approval unlocks "Create PO"
(creates a real local `PurchaseOrder`/`PurchaseOrderItem` record — **no SAP posting**, by design,
mirroring how Vendor Registration's SAP posting was kept separate).

Key files: `service/rfq/{RfqServiceImpl,QcfServiceImpl,PoServiceImpl}.java`,
`service/workflow/WorkflowEngineServiceImpl.java` (generic engine, shared with Vendor
Registration), `templates/qcf/compare.html`.

**Value-threshold workflow routing**: `ezc_wf_pricing_conditions` is a *sequential ladder* (level
1→2→3→4→5→6, exactly one row per level; LE/GE thresholds on later levels determine where the
climb **stops**, not which row to pick at a given level) — see
`WorkflowEngineServiceImpl.resolveFinalLevel`. This was redesigned once already after an initial
wrong assumption (branching candidates at one level) — don't revert to that model.

### 3. Multi-tenancy architecture — **planned only, not implemented**
The user wants this app to serve multiple client companies from one domain/login, each with
isolated data. Full design exists but **zero code was written** for this — it's a future epic.
Key decisions made (not yet acted on):
- **Schema-per-tenant** (not shared-schema + tenant_id column) — chosen because the current
  codebase has several under-scoped native-SQL queries, and schema isolation makes that risk
  moot by construction.
- A global `tenant_user_directory` table resolves username→tenant at login, so the login page
  itself needs zero changes (no company picker).
- `AbstractRoutingDataSource` + Hibernate's native multi-tenancy (`CurrentTenantIdentifierResolver`)
  so existing repository code needs almost no changes.
- Flyway should be introduced (currently zero migration tooling — pure `hbm2ddl.auto=update`).
- Scale target: 2-10 tenants initially, one MySQL server, small per-tenant connection pools.

If you pick this up: there is no code to build on yet, only this design. Treat the current
`portal` schema as tenant #1 when you start.

### 4. MCP (Model Context Protocol) tool layer — **planned only, not implemented**
Goal: let Claude drive Vendor Registration (invite → conversational fill-out → buyer review table
→ Excel export → submit to workflow → status checks) and RFQ/QCF buyer actions (view/approve/
reject/requote quotes, compare, submit, status, create PO — **not** vendor quote submission,
which stays website-only) via MCP tools.

**Important finding**: real, partial MCP infrastructure already exists and should be extended,
not replaced — `config/security/{McpApiKeySecurityConfig,McpApiKeyAuthFilter,
McpApiKeyProperties,McpServiceAccountSeeder}.java` (an `X-MCP-Api-Key` header auth bridge, a
seeded `mcpservice` service account) and `controller/mcp/McpPrQueryController.java` (one working
example, `/api/mcp/prs/...`). This was clearly built in anticipation of a **standalone external
MCP server process** calling back into this Spring app over HTTP. No actual MCP protocol
server/transport exists yet — that would be a new Maven module (confirmed decision: in this same
repo, not a separate project) using the official MCP Java SDK, stdio transport.
Trust model decision: MCP tool calls carry an explicit `actingUserId` parameter, trusted as-is
once the API-key gate passes (no per-human MCP auth yet — flagged as a v1 simplification, fine
for internal use, would need hardening if ever vendor-facing).

Every buyer-facing method on `IRfqService`/`IQcfService`/`IPoService`/`IVendorRegistrationService`
already takes `Users`/a userId as an explicit parameter (confirmed via audit — none read
`SecurityContextHolder`), so MCP tools can call these services directly without faking an HTTP
session.

### 5. Generic SAP integration layer — **partially implemented, in progress**

This is the most recent and most substantial unfinished work. Full architecture doc:
**`docs/sap-integration-audit.md`** — read that first for the complete 24-function inventory and
free-testing-options analysis.

**The core idea**: every SAP operation gets a `genericXxx()` entry point that checks
`SapIntegrationModeConfig.effectiveMode(operationCode)` and dispatches to either `fmXxx()` (the
original JCo/RFC call, moved verbatim, unchanged behavior) or `odataXxx()` (a new OData call via
`SapODataClient`). Default is `ODATA` everywhere, but `effectiveMode()` automatically falls back
to `FM` (with a log warning) whenever `sap.odata.service.<CODE>` isn't configured yet — so
defaulting to OData can never silently break an operation nobody has verified. **Never guess a
service/entity name** — leave `sap.odata.service.*` empty until confirmed via the SAP Business
Accelerator Hub (for BAPI-shaped operations) or the client's own Gateway catalog (for the 19
genuinely-custom Z-functions) — a web search during this session confirmed there's no reliable
public 1:1 BAPI→OData mapping to lean on.

**Package structure** (the user explicitly asked for this — one subpackage per business
operation, isolated from business logic, for easier debugging):
```
com.ezc.aragenPR.webapp.sap/
├── SapIntegrationMode.java          shared: FM/ODATA enum
├── SapIntegrationModeConfig.java    shared: per-operation mode + service-name resolution
├── SapOperationCode.java            shared: named constant per SAP operation (javadoc = full inventory)
├── SapODataClient.java              shared: generic CSRF-aware OData V2/V4 client (WebClient-based)
├── MockSapODataController.java      shared: fake-SAP test double, gated by sap.odata.mock.enabled
├── SapODataSelfTestController.java  shared: GET /mock-sap/self-test — proves SapODataClient works end-to-end
├── vendor/   → IVendorSapGateway + VendorSapGateway     ✅ FULLY migrated (VENDOR_CREATE/VALIDATE)
├── material/ → IMaterialSapGateway + MaterialSapGateway ✅ FULLY migrated (MATERIAL_SEARCH/GETDETAIL)
├── ses/      → ISesSapGateway + SesSapGateway           ✅ FULLY migrated (SES_RELEASE)
├── pr/       → IPrSapGateway + PrSapGateway             🟡 PARTIALLY migrated (PR_GETDETAIL only,
│                                                            both the regular-PR and Service-PR variants —
│                                                            PR_CREATE/PR_CHANGE and the other 7 PR
│                                                            operation codes are still inline in
│                                                            PRController)
├── po/       → IPoSapGateway                            ⬜ reserved placeholder — PO creation doesn't
│                                                            post to SAP at all yet (local-only by design)
├── reservation/ → IReservationSapGateway                 ⬜ structured interface only, not migrated
└── master/   → IMasterDataSapGateway                     ⬜ structured interface only — NOT a simple
                                                             move: MasterDataService.syncFromSAP(key) is
                                                             one ~300-line method with a string-key
                                                             dispatcher where SAP calls and DB-save logic
                                                             are interleaved per branch; needs a real
                                                             restructure, not just relocation
```

**Why PRController isn't done**: it's 2,700+ lines with 10 of the 24 total SAP functions, each
deeply embedded in large request-handling methods (some mutate a `header` object that's read
again later in the same method, some have early `return "errorPage"` on failure that must be
preserved exactly). Each extraction so far has required reading the *entire* surrounding method
before touching it — rushing this risks silently breaking a live PR create/edit flow. **PR_CREATE
and PR_CHANGE (write operations, both ×2 variants for regular vs. Service PR) are next and are
higher-stakes than anything done so far** — read fully before extracting, same discipline as what
came before.

**Confirmed evidence, useful when you resume this**:
- `ZBAPI_PR_CREATE`'s parameters (`PRHEADER`/`PRHEADERX`/`PRITEM`/`PRITEMX`/`PRACCOUNT`/
  `PRACCOUNTX`/`EXTENSIONIN`) exactly match standard `BAPI_REQUISITION_CREATE` — strong (not
  proven) evidence it's a thin wrapper.
- `Z_RFC_VENDOR_CREATE` uses a flat `IT_FILE` table with type-flagged rows — confirmed genuinely
  custom, NOT a BAPI wrapper. Its OData mapping in `VendorSapGateway.buildSupplierODataPayload`
  targets the standard `API_SUPPLIER` service but is **unverified against any real system** —
  don't trust it in production without checking against real `$metadata` first.
- `BAPI_MATERIAL_GETLIST`/`GET_DETAIL`, `BAPI_SERVICE_GET_LIST`, `BAPI_ENTRYSHEET_RELEASE`,
  `RFC_READ_TABLE` are already genuinely standard — called directly, no Z-wrapper at all.

**Testing provision — use this before touching a real SAP system**:
```properties
sap.odata.mock.enabled=true
sap.odata.base-url=http://localhost:8081/mock-sap
sap.mode.VENDOR_CREATE=ODATA
```
then hit `GET /mock-sap/self-test` (proves the real `SapODataClient` CSRF-handshake-then-POST
flow works end-to-end against `MockSapODataController`, a fake Gateway that enforces the real
`X-CSRF-Token: Fetch` dance and rejects writes without a valid token — verified working, pass:
true, in this session). Flip `sap.mode.*` back to `FM` (or `sap.odata.mock.enabled=false`) when
done. **These are currently set back to safe defaults (mock off, FM pinned for vendor ops)** —
don't assume they're left in test mode.

**Known gaps in `SapODataClient`** (see `docs/sap-integration-audit.md` for the full table): no
ETag/If-Match, no `$batch`, no server-side paging, no structured SAP error-payload parsing, no
timeouts, no retries. None of the JCo layer has timeouts/retries either — only a single
`destination.ping()` fail-fast on connect.

**Secret-hygiene finding, unrelated to the above, still open**: `src/main/java/com/ezc/aragenPR/
webapp/sapconnection/EzSAPHandler.java_bfConnParamsRead` and `EzSAPHandler.java_bf prop file`
(dead, non-compiled legacy backup files) contain real plaintext-looking SAP credentials/IPs
(client `900`/`999`, users `zsap`/`ezcom`, passwords `copa321`/`123456`, IPs
`202.144.51.18`/`152.63.63.6`). Not yet removed. Also orphaned `jco2.*` properties in
`application.properties` that nothing reads (dead config from before `sap.properties` existed).

## Immediate next steps, in priority order
1. **If continuing the SAP migration**: `PR_CREATE`/`PR_CHANGE` next (both PR and Service-PR
   variants — 4 call sites total), same read-fully-first discipline. Then the remaining PR lookup
   functions, reservation (3 functions), and the `MasterDataService` restructure.
2. **Verify, don't assume**: run `./mvnw -q -o compile` after every change, then do a live
   devtools-restart check (`Invoke-WebRequest http://localhost:8081/login` should return 200)
   before considering any extraction done — this caught real bugs during this session (a
   `MvcRequestMatcher` gotcha in `SecurityConfiguration` where a new permitAll rule silently
   didn't match because no real Spring MVC handler was registered for that path yet at
   conditional-bean-evaluation time — fixed with `AntPathRequestMatcher` instead of the
   String-pattern overload; and a `@ConditionalOnProperty` vs. `@PropertySource` load-order race,
   fixed via `spring.config.import=classpath:sap.properties` in `application.properties`).
3. **Clean up the dead legacy credential files** (`EzSAPHandler.java_bf*`) and orphaned `jco2.*`
   properties flagged above.
4. **Multi-tenancy and MCP** remain fully unimplemented designs — don't start either without
   re-reading this doc's summaries above first, since both involved real back-and-forth with the
   user on architecture choices that shouldn't be re-litigated from scratch.
