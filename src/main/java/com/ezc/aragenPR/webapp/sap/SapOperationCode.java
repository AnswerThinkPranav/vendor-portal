package com.ezc.aragenPR.webapp.sap;

/**
 * One constant per SAP operation this app performs, independent of whichever FM/Z-RFC/OData
 * service actually implements it for a given client. Used as the key into
 * {@code sap.mode.<CODE>} (which transport to use) - see {@link SapIntegrationModeConfig}.
 *
 * Inventoried from every JCo call site in the app (PRController, ReservationService/Controller,
 * SESService, MasterDataService, VendorSapPostingServiceImpl, SapPrFetchServiceImpl). Not every
 * code here has a generic/FM/OData split implemented yet - see each service's own
 * genericXxx/fmXxx/odataXxx methods for what's actually wired today vs. still FM-only.
 */
public final class SapOperationCode {

    // Vendor Registration
    public static final String VENDOR_VALIDATE = "VENDOR_VALIDATE";
    public static final String VENDOR_CREATE = "VENDOR_CREATE";

    // Purchase Requisition
    public static final String PR_CREATE = "PR_CREATE";
    public static final String PR_CHANGE = "PR_CHANGE";
    public static final String PR_GETDETAIL = "PR_GETDETAIL";
    public static final String PR_SEARCH = "PR_SEARCH";
    public static final String PR_USER_DATA = "PR_USER_DATA";
    public static final String PR_REL_DTLS = "PR_REL_DTLS";
    public static final String PR_ACTIVE_WBS = "PR_ACTIVE_WBS";
    public static final String PR_PROJ_WBS = "PR_PROJ_WBS";
    public static final String PR_AGREEMENT_LIST = "PR_AGREEMENT_LIST";
    public static final String PR_GL_ACCOUNT = "PR_GL_ACCOUNT";

    // Reservation
    public static final String RESERVATION_CREATE = "RESERVATION_CREATE";
    public static final String RESERVATION_CHANGE = "RESERVATION_CHANGE";
    public static final String RESERVATION_GETDETAIL = "RESERVATION_GETDETAIL";
    public static final String RESERVATION_ACTIVE_WBS = "RESERVATION_ACTIVE_WBS";

    // Service Entry Sheet
    public static final String SES_LIST = "SES_LIST";
    public static final String SES_GETDETAIL = "SES_GETDETAIL";
    public static final String SES_RELEASE = "SES_RELEASE";

    // Material / Master data
    public static final String MATERIAL_SEARCH = "MATERIAL_SEARCH";
    public static final String MATERIAL_GETDETAIL = "MATERIAL_GETDETAIL";
    public static final String SERVICE_MASTER_LIST = "SERVICE_MASTER_LIST";
    public static final String NETWORK_LIST = "NETWORK_LIST";
    public static final String GL_ACCOUNT_LIST = "GL_ACCOUNT_LIST";
    public static final String GENERIC_TABLE_READ = "GENERIC_TABLE_READ";

    private SapOperationCode() {
    }
}
