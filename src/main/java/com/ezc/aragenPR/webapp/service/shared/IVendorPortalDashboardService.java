package com.ezc.aragenPR.webapp.service.shared;

/**
 * Dashboard tile counts for the Vendor Portal merge (QCF, RFQ, Vendor Registration).
 * Mirrors the counts computed inline in the legacy Vendor Portal's
 * "Vendor Portal/JSP/Misc/ezWelcomePageCounts.jsp". Every method here is a placeholder
 * for now - the real queries land one at a time later. Controllers/templates must call
 * through this service rather than embedding query logic themselves.
 */
public interface IVendorPortalDashboardService {

    // Buyer-side counts (EU_TYPE=2) - see ezBuyerWelcome.jsp
    int getDomesticRfqToActCount(String buyerUserId);

    int getImportRfqToActCount(String buyerUserId);

    int getQcfPendingApprovalCount(String buyerUserId);

    int getQcfPendingPoCreationCount(String buyerUserId);

    int getDomesticVendorPendingApprovalCount(String buyerUserId);

    int getImportVendorPendingApprovalCount(String buyerUserId);

    // Vendor-side counts (EU_TYPE=3 SAP vendor, EU_TYPE=4 temp vendor) - see
    // ezWelcome_New.jsp / ezWelcomeTempUser.jsp
    int getRfqToQuoteCount(String vendorCode);

    int getRfqToRequoteCount(String vendorCode);
}
