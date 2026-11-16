package com.ezc.aragenPR.webapp.sap.ses;

import java.util.Map;

/**
 * SAP I/O for Service Entry Sheets. {@code SES_RELEASE} is migrated from
 * {@code service.ses.SESService.releaseSES}/{@code getRelCode} - those now call this gateway.
 * {@code SES_LIST}/{@code SES_GETDETAIL} are not migrated yet (see package javadoc on
 * {@link com.ezc.aragenPR.webapp.sap.SapOperationCode}).
 */
public interface ISesSapGateway {

    /**
     * BAPI_ENTRYSHEET_RELEASE (FM mode - already standard, no Z-wrapper). Internally resolves
     * the release code via ZEZ_PR_USER_DATA (same FM shared with SapOperationCode.PR_USER_DATA)
     * for the current authenticated user, exactly as the original method did.
     */
    Map<String, Object> releaseServiceEntrySheet(String sesNumber);
}
