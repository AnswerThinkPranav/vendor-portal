package com.ezc.aragenPR.webapp.service.shared;

import org.springframework.stereotype.Service;

@Service
public class VendorPortalDashboardServiceImpl implements IVendorPortalDashboardService {

    // TODO: back each of these with a real repository query - see
    // "Vendor Portal/JSP/Misc/ezWelcomePageCounts.jsp" for the legacy SQL each one replaces.
    // Stubbed at 0 until wired up piece by piece.

    @Override
    public int getDomesticRfqToActCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getImportRfqToActCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getQcfPendingApprovalCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getQcfPendingPoCreationCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getDomesticVendorPendingApprovalCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getImportVendorPendingApprovalCount(String buyerUserId) {
        return 0;
    }

    @Override
    public int getRfqToQuoteCount(String vendorCode) {
        return 0;
    }

    @Override
    public int getRfqToRequoteCount(String vendorCode) {
        return 0;
    }
}
