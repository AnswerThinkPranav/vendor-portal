package com.ezc.aragenPR.webapp.sap;

/**
 * Which transport a given SAP operation should use. Resolved per operation code via
 * {@link SapIntegrationModeConfig} (property {@code sap.mode.<OPERATION_CODE>}), so any
 * operation can be flipped between the two without a code change - e.g. a client whose SAP
 * landscape only has the inherited custom Z-RFC stays on FM, a client with a vanilla/un-customized
 * SAP (or one that exposes the standard OData service) can be switched to ODATA purely via config.
 */
public enum SapIntegrationMode {
    /** Call via JCo RFC/BAPI (existing {@code RFCReadSAPService} destination). */
    FM,
    /** Call via the standard SAP OData service ({@link SapODataClient}). */
    ODATA
}
