# Vendor Portal → aragen-pr-portal merge: handoff notes

## What this project is

`aragen-pr-portal` is an existing Spring Boot Purchase Requisition app (session-based
Spring Security login, MySQL via Hibernate, Thymeleaf UI, AdminLTE-style sidebar).
There is a separate, older JSP-based "Vendor Portal" application (an "EzCommerce Suite"
product instance for Jubilant Pharmova) with its own MySQL schema and its own vendor
registration / RFQ / QCF / auction / PO features. The two are being merged into one
Spring Boot app, starting with a unified login/user model and working outward feature
by feature. **Vendor registration is the next feature to build.**

The full legacy JSP source is checked into this repo under `Vendor Portal/` (folders
`JSP/Misc/` and `Includes/Misc/`) purely as a reference for porting logic — it is not
executed by the Spring Boot app.

## Decisions already locked in (do not re-litigate without asking the user)

1. **No OTP/MFA for now.** Plain username + password login only, via the app's existing
   Spring Security `formLogin()` machinery. The legacy portal's MFA/OTP JSPs
   (`ezCreateOTP.jsp`, `ezVerifyMfa.jsp`, `ezApplicationAreas_MFA.jsp`) were never even
   found in this checkout — only an older, pre-MFA flow exists in `Vendor Portal/`.
2. **Legacy passwords are not migrated.** `EZC_USERS.EU_PASSWORD` in the legacy schema is
   a *reversibly encrypted* value (custom `EzCipher` cipher, code unavailable in this
   checkout) — not a hash. Migrated users get `MUST_CHANGE_PASSWORD=true` and must go
   through the existing forgot-password flow (or have an admin set a fresh BCrypt
   password) rather than porting the old value.
3. **Local dev DB name is `portal`** (not `aragen`). `src/main/resources/persistence.properties`
   already points here.
4. **`Users`' primary key is now the natural legacy key `EU_ID`** (a `String`), not a
   surrogate numeric ID — because literally everything in the legacy schema
   (`ezc_user_auth`, `ezc_user_defaults`, `ezc_roles_by_user`, etc.) and the app's own
   `CustomAuthenticationProvider`/`CustomUserServiceImpl` already key off the string
   user ID, not a number.

## What has been built so far

### 1. Merged `Users` / `UserDefaults` JPA model
- **`src/main/java/com/ezc/aragenPR/webapp/model/user/Users.java`** — `@Table(name="EZC_USERS")`.
  `@Id` is `String userId` mapped to column `EU_ID`. Full legacy column set is now mapped:
  `EU_FIRST_NAME`, `EU_MIDDLE_INITIAL`, `EU_LAST_NAME`, `EU_EMAIL`, `EU_PASSWORD`,
  `IS_ENABLED`, `MUST_CHANGE_PASSWORD` (new, Aragen-only), `EU_TYPE` (→ `userType`),
  `EUG_ID` (→ `userGroupId`), `EU_BUSINESS_PARTNER` (→ `vendorCode`),
  `EU_IS_BUILT_IN_USER`, `EU_CURRENT_NUMBER`, `EU_CONTACT_NO`, `EU_LAST_LOGIN_TIME/DATE`.
- **`model/user/UserType.java`** (new enum, not JPA-mapped) — `BUYER(2)`, `VENDOR_SAP(3)`,
  `VENDOR_TEMP(4)`, matching the legacy `EU_TYPE` codes (2 = internal/buyer, 3 = vendor
  with a real SAP vendor code, 4 = vendor with a temporary/pre-onboarding code). Has a
  `fromCode(Integer)` helper.
- **`model/user/UserDefaults.java` / `UserDefaultsKey.java`** — `@Table(name="EZC_USER_DEFAULTS")`,
  composite key `(userId: String, key: String)`, plus `EUD_SYS_KEY`, `EUD_CUST_NO`,
  `EUD_DEFAULT_FLAG`, `EUD_IS_USERA_KEY` columns added to match the legacy table shape.
  It's a generic key→value store per user (legacy keys seen: `COMPCODE`, `SOLDTOPARTY`,
  `USERROLE`, `PLANT`, `PURGROUP`, `ALLOW_RFQ`, `ALLOW_REG`, `PP_WF_GRP`, etc.).
- Every call site that assumed a numeric `Users` ID was updated for the `String` type
  change: `UserRepository`, `UserDefRepository`, `WorkGroupUsersRepository` (5 JPQL
  queries), `IUserService`/`UserServiceImpl`, `UserSecurityService`/`ISecurityUserService`
  (this also fixed a latent `!=` reference-comparison bug in password-reset-token
  validation that the type change would otherwise have silently broken), `UserDto`,
  `UserForm`, `UserController`, `McpServiceAccountSeeder`.

### 2. Login / authentication
- **No new login mechanism** — reused the existing Spring Security session-based
  form login (`config/SecurityConfiguration.java`, `security/CustomAuthenticationProvider.java`,
  `security/CustomUserServiceImpl.java`).
- `CustomUserServiceImpl.getAuthorities()` now also derives a coarse authority from
  `EU_TYPE`, additively alongside the existing `Roles`/`UserPrivilege` authorities:
  `ROLE_BUYER` (type 2), `ROLE_VEND_SAP` (type 3), `ROLE_VEND_TEMP` (type 4).
- **Gotcha to know about:** this app has no `GrantedAuthorityDefaults` bean, so Spring
  Security's default `"ROLE_"` prefix is active. `hasRole('ROLE_BUYER')` would actually
  look for the authority `"ROLE_ROLE_BUYER"` (double-prefixed) and silently never match.
  Always use **`hasAuthority('ROLE_BUYER')`** / `hasAuthority('ROLE_VEND_SAP')` /
  `hasAuthority('ROLE_VEND_TEMP')` — not `hasRole(...)` — for these three, in both
  Thymeleaf `sec:authorize` and any `@PreAuthorize`.
- `ezc_user_auth` (fine-grained per-screen legacy authorizations) is deliberately **not**
  modeled as Spring `GrantedAuthority`s — it's a different axis (transaction-level auth,
  not coarse role-based access). Left as plain data for a later phase.

### 3. Post-login session context
- **`security/PostLoginSessionSetupService.java`** (new) — called from
  `CustomLoginAuthenticationSuccessHandler` right after login succeeds. Reads the user's
  `EZC_USER_DEFAULTS` rows (already eagerly loaded on `Users.userDefaults`) and builds a
  `UserSessionContext` (userType, businessPartner, compCode, and — only for
  `VENDOR_TEMP` — allowRfq/allowReg/ppWfGrp/soldTo), stored under session attribute
  `PostLoginSessionSetupService.SESSION_ATTRIBUTE` (`"userSessionContext"`). Also stamps
  `EU_LAST_LOGIN_TIME`/`EU_LAST_LOGIN_DATE`. This replaces the legacy
  `ezDesclaimerConfirm.jsp`'s dozens of individual `session.setAttribute(...)` calls with
  one structured object.
- Every login logs `[LOGIN-DEBUG]` lines (console + `./logs/app.log`) showing every raw
  `EZC_USER_DEFAULTS` key/value for that user and the final `UserSessionContext` — useful
  for verifying what data actually exists for a given test user.
- **Known gap:** does not yet read `EZC_USER_DEF_KEY_VALUES` (the `PLANT`/`CATEGORY`
  rows) — that table has no JPA entity yet.

### 4. Sidebar navigation
- **`src/main/resources/templates/fragments/main-sidebar.html`** — added 3 new
  role-gated menu sections mirroring the legacy `Vendor Portal/JSP/Misc/ezHeader.jsp`:
  - **Vendor Registration** (`hasAuthority('ROLE_BUYER')` only — vendors don't register
    other vendors): Invite Vendor, New, List → `/vendorReg/invite`, `/vendorReg/new`,
    `/vendorReg/list`
  - **RFQ** (buyer + both vendor roles, create-actions buyer-only): Create From PR,
    Create From Material, RFQ List → `/rfq/createFromPr`, `/rfq/createFromMaterial`,
    `/rfq/list`
  - **QCF** (buyer + both vendor roles, split by side): QCF List (shared), Submit QCF
    (vendor-only), To Act / PR-PO Report (buyer-only) → `/qcf/list`, `/qcf/submit`,
    `/qcf/toAct`, `/qcf/prPoReport`
  - Also fixed the pre-existing "Purchase Requisition" section, which was invisible to
    every buyer (including test users) because it required a `ROLE_REQ_CR` role that was
    never actually assigned to anyone — it now also accepts `hasAuthority('ROLE_BUYER')`.
  - **None of `/vendorReg/*`, `/rfq/*`, `/qcf/*` have controllers or templates yet** —
    the links exist and will 404 until built. This is deliberate scaffolding.

### 5. Dashboards
- **`controller/shared/DashboardController.java`** — `/dashboard/*` now branches by role:
  - `ROLE_VEND_SAP` → `dashboard/vendorDashboard.html` (new)
  - `ROLE_VEND_TEMP` → `dashboard/tempVendorDashboard.html` (new; tiles conditionally
    shown based on `allowRfq`/`allowReg` from `UserSessionContext`, mirroring the legacy
    `ezWelcomeTempUser.jsp`)
  - everyone else (buyer) → `dashboard/index.html` (existing PR/SES tiles, extended with
    new QCF/RFQ/Vendor-Registration tile rows, mirroring `ezBuyerWelcome.jsp`)
- **`service/shared/IVendorPortalDashboardService.java` / `VendorPortalDashboardServiceImpl.java`**
  (new) — every count method is currently a **stub returning 0**:
  `getDomesticRfqToActCount`, `getImportRfqToActCount`, `getQcfPendingApprovalCount`,
  `getQcfPendingPoCreationCount`, `getDomesticVendorPendingApprovalCount`,
  `getImportVendorPendingApprovalCount`, `getRfqToQuoteCount`, `getRfqToRequoteCount`.
  The real queries these should run are documented inline and can be found in
  `Vendor Portal/JSP/Misc/ezWelcomePageCounts.jsp` (the legacy SQL each one replaces).
  Controllers/templates must call through this service, never embed query logic
  directly — that convention should continue.

### 6. Database
- `src/main/resources/persistence.properties` points at local MySQL db **`portal`**.
  `hibernate.hbm2ddl.auto=update` (additive-only; renames/retypes need manual SQL).
- Test users that exist right now in `portal.ezc_users`:
  - `testbuyer` / password unknown to us (pre-existing) — `EU_TYPE=2` (buyer)
  - `testvend` / password unknown to us (pre-existing) — `EU_TYPE=4` (temp vendor)
  - `VSHARMA2` / **`Test@1234`** — `EU_TYPE=2` (buyer), a real legacy user record
    migrated from pasted data, including matching `ezc_user_defaults`,
    `ezc_user_def_key_values`, and `ezc_user_auth` rows
  - `mcpservice` — not a real login; service account for the MCP API-key auth chain only

### 7. Unrelated-but-present: MCP integration
- `mcp-aragen-pr/` (Python) and `config/security/` (`McpApiKeyAuthFilter`,
  `McpApiKeySecurityConfig`, `McpServiceAccountSeeder`) implement a separate,
  stateless, API-key-based auth chain (`X-MCP-Api-Key` header) so an AI agent can create
  PRs via a small REST API (`controller/mcp/McpPrQueryController.java`). This is
  independent of the Vendor Portal merge — don't confuse the two when exploring `security/`.

## What is explicitly NOT done yet (this is where vendor registration picks up)

- **No `/vendorReg/*` controllers, services, or templates exist at all** — only the
  sidebar links pointing at them (currently 404).
- **No Vendor/VendorRegistration entity or repository in Spring Boot yet.** The legacy
  vendor master data is fragmented across several tables (see `db.sql`):
  - `ezc_vend_gen_data` — the live/current vendor master record, keyed by `EVGD_VENDOR`,
    has `EVGD_BLOCK_FLAG` (vendor blocked/disabled)
  - `ezc_vend_general_data` — a doc-workflow-versioned snapshot per registration
    submission, keyed by `(EVGD_DOC_ID, EVGD_VENDOR)`; **this is the table that holds the
    temp-vendor-code-vs-SAP-vendor-code duality** (`EVGD_VENDOR` = temp code,
    `EVGD_SAP_VENDOR` = final SAP code once approved) — i.e. what distinguishes
    `EU_TYPE=4` from `EU_TYPE=3`
  - Satellite detail tables: `ezc_vend_bank_details`, `ezc_vend_company_data`,
    `ezc_vend_contact_person`, `ezc_vend_excise_data` (GST/PAN/VAT), `ezc_vend_partners`,
    `ezc_vend_pur_org_data`, `ezc_vend_telephones`
  - Workflow/status tables: `ezc_vendor_confirmation`, `ezc_vendor_creation_workflow`,
    `ezc_vendor_reg_details` (the actual self-registration form submission),
    `ezc_vendor_questionnaire` (supplier qualification/compliance questionnaire),
    `ezc_customer_form_header` (referenced heavily in `ezWelcomePageCounts.jsp` as
    `ECFH_*` — appears to be the live registration-request header the dashboard counts
    query against; **the relationship between this and `ezc_vendor_reg_details` /
    `ezc_vend_general_data` was not fully traced this session and needs investigation**)
- **The legacy vendor registration JSPs themselves were only referenced by filename, not
  read/traced this session.** Relevant ones to start with, all in
  `Vendor Portal/JSP/Misc/`:
  - `ezTempUserCreation.jsp` / `ezTempNAUserCreation.jsp` — "Invite Vendor" flow (buyer
    invites a new vendor, creating a temp-code user)
  - `ezVNRList.jsp` — the vendor-registration list/queue (used for both "New" and "List"
    sidebar links, with `type=`/`venType=` query params selecting the view)
  - `ezVendReg.jsp` / `ezImpVendReg.jsp` / `ezNAVendReg.jsp` — the actual multi-step
    registration form (domestic/import/NA variants — `naCompHt`/`compCode` decide which
    one a vendor is routed to, see `ezWelcomeTempUser.jsp`)
  - `ezWelcomeTempUser.jsp` — shows registration status derived from `ECFH_STATUS`:
    `INITIATED`/`RESUBMITTED` → "complete registration", `SUBMITTED` → "under approval",
    `REJECTED` → "rejected", else → "approved"
- **OTP/MFA and full usertype-based landing-page redirect** (legacy redirects buyer /
  SAP-vendor / temp-vendor to entirely different URLs; here everyone hits `/dashboard/*`
  and the controller branches server-side instead) remain explicitly deferred per
  earlier decisions.

## Suggested next steps for vendor registration

1. Read the legacy JSPs listed above (`ezTempUserCreation.jsp`, `ezVNRList.jsp`,
   `ezVendReg.jsp`/variants) to understand the actual multi-step form fields and the
   approval workflow (who approves, what statuses exist, how `ezc_wf_doc_history_header`
   drives the workflow-state machine used elsewhere in this codebase too — see how
   `WorkGroupUsersRepository`/`Work_Groups` in the Java side already model a similar
   approval-hierarchy concept for PRs, which might be reusable).
2. Clarify with the user how much of the legacy multi-table vendor model to port
   1:1 vs. simplify — it's genuinely fragmented (see table list above).
3. Design a `Vendor`/`VendorRegistration` JPA entity (or small set of entities) and wire
   real controllers/templates for `/vendorReg/invite`, `/vendorReg/new`, `/vendorReg/list`.
4. Once that's real, wire `IVendorPortalDashboardService.getDomesticVendorPendingApprovalCount`
   / `getImportVendorPendingApprovalCount` to real queries against it.
5. Follow the same pattern already established for RFQ/QCF placeholders when those come next.

## Key files to orient from

| Purpose | Path |
|---|---|
| User entity | `src/main/java/com/ezc/aragenPR/webapp/model/user/Users.java` |
| User defaults (EAV) | `src/main/java/com/ezc/aragenPR/webapp/model/user/UserDefaults.java` |
| Usertype enum | `src/main/java/com/ezc/aragenPR/webapp/model/user/UserType.java` |
| Login authorities | `src/main/java/com/ezc/aragenPR/webapp/security/CustomUserServiceImpl.java` |
| Post-login session setup | `src/main/java/com/ezc/aragenPR/webapp/security/PostLoginSessionSetupService.java` |
| Session context shape | `src/main/java/com/ezc/aragenPR/webapp/security/UserSessionContext.java` |
| Security config | `src/main/java/com/ezc/aragenPR/webapp/config/SecurityConfiguration.java` |
| Dashboard routing | `src/main/java/com/ezc/aragenPR/webapp/controller/shared/DashboardController.java` |
| Dashboard count stubs | `src/main/java/com/ezc/aragenPR/webapp/service/shared/IVendorPortalDashboardService.java` |
| Sidebar | `src/main/resources/templates/fragments/main-sidebar.html` |
| Buyer dashboard | `src/main/resources/templates/dashboard/index.html` |
| Vendor dashboard | `src/main/resources/templates/dashboard/vendorDashboard.html` |
| Temp vendor dashboard | `src/main/resources/templates/dashboard/tempVendorDashboard.html` |
| DB connection config | `src/main/resources/persistence.properties` |
| Legacy schema reference | `db.sql` (schema-only dump, no data, of the `jublprd` legacy DB) |
| Legacy JSP source (reference only) | `Vendor Portal/JSP/Misc/`, `Vendor Portal/Includes/Misc/` |
| Legacy login flow (partial) | `Vendor Portal/JSP/Misc/ezApplicationAreas.jsp`, `ezDesclaimerConfirm.jsp`, `ezSelectSoldTo.jsp`, `ezBuyerWelcome.jsp`, `ezWelcome_New.jsp`, `ezWelcomeTempUser.jsp` |
| Legacy dashboard counts (SQL reference) | `Vendor Portal/JSP/Misc/ezWelcomePageCounts.jsp` |

## Repo / environment notes

- Local dev DB: MySQL, database `portal`, `root`/`root` (see `persistence.properties`).
- App runs on port `8081` (`server.port` in `application.properties`). Start via
  `run-dev.ps1` (sets `JAVA_HOME` then `mvnw.cmd spring-boot:run`).
- Remote: `https://github.com/AnswerThinkPranav/vendor-portal.git`, branch `main`. All of
  the above is committed and pushed as of commit `881c428`.
- Three legacy JSPs (`ezOTPGeneration.jsp`, `ezPasswordGeneration.jsp`, `ezPlantSync.jsp`)
  contain a hardcoded third-party SMS gateway credential — flagged to the user, kept
  as-is by their decision, now in git history. Worth knowing if this repo's visibility
  or audience ever changes.
