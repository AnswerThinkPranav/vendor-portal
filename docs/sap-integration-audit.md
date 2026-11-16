# SAP integration audit

Generated as part of the SAP test-strategy work. Covers every place this app talks to SAP, as of
the introduction of the generic `genericXxx`/`fmXxx`/`odataXxx` switching layer
(`src/main/java/com/ezc/aragenPR/webapp/sap/`).

## IDoc handling

None. Zero references anywhere in the codebase, including legacy/commented files.

## JCo/RFC/BAPI call sites (24 total)

| Function | Type | OData status | Called from |
|---|---|---|---|
| `BAPI_MATERIAL_GETLIST` | Standard BAPI | Not yet wired to OData | `controller/pr/PRController.java` |
| `BAPI_MATERIAL_GET_DETAIL` | Standard BAPI | Not yet wired to OData | `controller/pr/PRController.java` |
| `BAPI_SERVICE_GET_LIST` | Standard BAPI | Not yet wired to OData | `service/master/MasterDataService.java` |
| `BAPI_ENTRYSHEET_RELEASE` | Standard BAPI | Not yet wired to OData | `service/ses/SESService.java` |
| `RFC_READ_TABLE` | Standard (generic) | Not applicable - generic table read, no OData equivalent targeted | `service/shared/RFCReadSAPService.java` (`readRFCTable`), called from `controller/user/UserDefaultsController.getDefaults()` |
| `ZBAPI_PR_CREATE` | Custom (parameter shape confirmed to match standard `BAPI_REQUISITION_CREATE`: `PRHEADER`/`PRHEADERX`/`PRITEM`/`PRITEMX`/`PRACCOUNT`/`PRACCOUNTX`/`EXTENSIONIN`) | Not yet wired to OData | `controller/pr/PRController.java` |
| `ZBAPI_PR_CHANGE` | Custom (same family as above) | Not yet wired to OData | `controller/pr/PRController.java` |
| `ZEZ_BAPI_PR_GETDETAIL` | Custom (same family as above) | Not yet wired to OData | `controller/pr/PRController.java` |
| `ZEZ_BAPI_RESERVATION_CREATE1` | Custom (name suggests wraps standard `BAPI_RESERVATION_CREATE1` - not parameter-verified) | Not yet wired to OData | `service/reservation/ReservationService.java` |
| `ZEZ_BAPI_RESERVATION_CHANGE` | Custom (same family) | Not yet wired to OData | `service/reservation/ReservationService.java` |
| `ZEZ_BAPI_RESERVATION_GETDETAIL` | Custom (same family) | Not yet wired to OData | `controller/reservation/ReservationController.java` |
| `ZEZ_BAPI_ENTRYSHEET_GETDETAIL` | Custom (name suggests wraps standard `BAPI_ENTRYSHEET_GETDETAIL` - not parameter-verified) | Not yet wired to OData | `service/ses/SESService.java` |
| `Z_RFC_VENDOR_CREATE` | **Genuinely custom** - confirmed flat `IT_FILE` table, not a standard BAPI shape | **Wired** - `odataVendorRegistration()` targets `API_SUPPLIER`, mapping unverified against any real system | `service/vendorreg/VendorSapPostingServiceImpl.java` |
| `Z_RFC_VENDOR_VALIDATE` | Genuinely custom (same family) | **Wired** - `odataVendorValidation()`, same caveat | `service/vendorreg/VendorSapPostingServiceImpl.java` |
| `Z_EZ_GET_PRS` | Genuinely custom - no standard BAPI for arbitrary PR search | Not yet wired to OData | `service/rfq/SapPrFetchServiceImpl.java` |
| `ZEZ_PR_USER_DATA` | Genuinely custom (lookup) | Not yet wired to OData | `controller/pr/PRController.java`, `service/ses/SESService.java` |
| `ZEZ_PR_REL_DTLS` | Genuinely custom (lookup) | Not yet wired to OData | `service/pr/PRReleaseInfoService.java` |
| `ZEZ_ACTIVE_WBS` | Genuinely custom (lookup) | Not yet wired to OData | `controller/pr/PRController.java`, `controller/reservation/ReservationController.java` |
| `Z_EZ_GET_GL_ACCOUNT` | Genuinely custom (lookup) | Not yet wired to OData | `controller/pr/PRController.java`, `service/master/MasterDataService.java` |
| `Z_EZ_GET_PROJ_WBS` | Genuinely custom (lookup) | Not yet wired to OData | `controller/pr/PRController.java` |
| `ZEZ_AGREEMENT_LIST` | Genuinely custom (lookup) | Not yet wired to OData | `controller/pr/PRController.java` |
| `ZBAPI_NETWORK_GETLIST` | Genuinely custom (lookup) | Not yet wired to OData | `service/master/MasterDataService.java` |
| `ZEZ_BAPI_SES_LIST` | Genuinely custom (list) | Not yet wired to OData | `service/ses/SESService.java` |

## OData

Exactly one client exists: `src/main/java/com/ezc/aragenPR/webapp/sap/SapODataClient.java`, built
on `spring-boot-starter-webflux`'s `WebClient`. No other `WebClient`/`RestTemplate`/`Feign`/Olingo
usage exists anywhere in the app. It backs exactly the two VENDOR_CREATE/VENDOR_VALIDATE
operations above today.

## Config externalization

`sap.properties` (JCo connection) and its `sap.odata.*`/`sap.mode.*`/`sap.odata.service.*` keys
(OData + per-operation transport switch) are fully externalized, loaded early via
`spring.config.import=classpath:sap.properties` in `application.properties` (needed so
`@ConditionalOnProperty` beans like `MockSapODataController` see these values in time - see that
property's own comment for why).

**Secret-hygiene finding, separate from the above**: `src/main/java/com/ezc/aragenPR/webapp/
sapconnection/EzSAPHandler.java_bfConnParamsRead` and `EzSAPHandler.java_bf prop file` (dead,
non-compiled legacy backup files, not on the build path) contain real, plaintext-looking SAP
credentials and host IPs committed to source: client `900`/`999`, users `zsap`/`ezcom`, passwords
`copa321`/`123456`, IPs `202.144.51.18`/`152.63.63.6`. Recommend removing these files and
considering whether git history needs scrubbing / credentials rotating.

## Timeouts / retries

None configured anywhere - not in the JCo layer (`RFCReadSAPService` sets only `ashost`/`sysnr`/
`client`/`user`/`passwd`/`lang`; no `jco.client.*` timeout properties), and not in
`SapODataClient`. The only existing safety net is a single `destination.ping()` fail-fast check on
connect in `RFCReadSAPService.getDestination()` - no retry-on-failure anywhere in the app.

## Other findings

`UserDefaultsController.getDefaults()` (`/userDefault/getDefault`) is a live endpoint directly
calling `RFC_READ_TABLE` against `MATNR`/`MAKTX` with a hardcoded test material number and no
visible access restriction - looks like leftover debug code exposed in a production route, worth
a separate look.

## Known gaps in `SapODataClient` against standard SAP-OData behaviors

| Behavior | Status |
|---|---|
| CSRF fetch (`X-CSRF-Token: Fetch`) | Implemented and proven working (verified end-to-end against `MockSapODataController`: real handshake, real 403-without-token rejection) |
| Retry on 403 (expired token) | Not implemented - a fresh token is fetched on every `post()` call rather than cached/reused |
| Session/cookie reuse across calls | Not implemented - each `post()` establishes its own session |
| ETag / If-Match (update/delete) | Gap - no update/delete methods exist yet, only `get`/`post` (create) |
| `$batch` / changeset parsing | Gap - not implemented |
| Server-side paging (`__next`/`@odata.nextLink`) | Gap - `get()` returns the raw first page only |
| SAP error payload parsing (`error.code`, `message.value`, `innererror`) | Gap - failures surface as a raw `WebClientResponseException` |
| Timeouts | Gap - none configured |
| Retries (transient failures) | Gap - none anywhere |
| Auth failures (401/403) / locked-object errors | Gap - not distinguished from any other failure |

## Calls with no realistic free way to be tested

The 19 "genuinely custom" functions in the table above exist only on this client's own SAP
landscape - no public sandbox, trial system, or mocking tool can confirm their real behavior.
Mockito-mocked JCo unit tests (planned, not yet built) can only prove our own field-mapping code
is internally consistent, not that the real RFC call will succeed. Closing this gap fully requires
access to the real client dev/QA system.
