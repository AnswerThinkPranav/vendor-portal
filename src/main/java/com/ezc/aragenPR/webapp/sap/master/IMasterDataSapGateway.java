package com.ezc.aragenPR.webapp.sap.master;

/**
 * SAP I/O for the generic master-data sync (plants, purchasing groups, GL accounts, networks,
 * service master, etc.) - reserved package shape, mirroring {@code sap.vendor}.
 * <b>Not migrated yet, and not a trivial extraction when it is</b> -
 * {@code service.master.MasterDataService.syncFromSAP(key)} is a single ~300-line method with a
 * large if/else-if dispatcher keyed on a String `key`: most branches call the generic
 * {@code RFC_READ_TABLE} (via {@code RFCReadSAPService.readRFCTable}, not a dedicated FM), and
 * three branches call a dedicated function. Unlike Vendor Registration, the SAP call and the
 * DB-save logic (building/saving {@code EzcMasterData} rows) are interleaved per branch, not
 * cleanly separable without restructuring the whole dispatcher - flagged here rather than forced
 * through under time pressure, since a transcription mistake in this method would silently
 * corrupt master-data sync.
 *
 * <pre>
 * Operation code     | FM today                  | Triggered by key=
 * ---------------------|------------------------------|------------------
 * SERVICE_MASTER_LIST  | BAPI_SERVICE_GET_LIST         | "SERVICECD"
 * NETWORK_LIST         | ZBAPI_NETWORK_GETLIST         | "NETWORK" / "IO"
 * GL_ACCOUNT_LIST      | Z_EZ_GET_GL_ACCOUNT           | "GLACCOUNT" (same FM also called from
 *                       |                                | PRController under PR_GL_ACCOUNT)
 * GENERIC_TABLE_READ   | RFC_READ_TABLE                | every other key (DIVISION, PURGRP,
 *                       |                                | PLANT, ACCASSG, ITEMCATEG, STRGLOC,
 *                       |                                | PURORG, DEPART, SERVICECODE, BATCH,
 *                       |                                | COSTCENTER, MATGRP) - via
 *                       |                                | RFCReadSAPService.readRFCTable,
 *                       |                                | also used by
 *                       |                                | UserDefaultsController.getDefaults()
 * </pre>
 *
 * Migration plan once undertaken: first split {@code syncFromSAP} so each branch's raw SAP call
 * (not the subsequent {@code EzcMasterData} mapping) moves here as an {@code fmXxx} method
 * returning the raw JCo table/rows; keep the key-dispatch and DB-save logic in
 * {@code MasterDataService} itself, calling into this gateway instead of JCo directly.
 */
public interface IMasterDataSapGateway {
    // Signatures intentionally not declared yet - see class javadoc for why this one needs a
    // restructure, not just a move, before a contract can be committed to.
}
