package com.ezc.aragenPR.webapp.service.shared;

import com.ezc.aragenPR.webapp.repository.vendorreg.CustomerFormHeaderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VendorPortalDashboardServiceImpl implements IVendorPortalDashboardService {

    // TODO: back the RFQ/QCF counts with a real repository query - see
    // "Vendor Portal/JSP/Misc/ezWelcomePageCounts.jsp" for the legacy SQL each one replaces.
    // Stubbed at 0 until wired up piece by piece. The Vendor Registration counts below are wired.

    @Autowired
    private CustomerFormHeaderRepository customerFormHeaderRepository;

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

    /**
     * Domestic Vendor(s) Pending For Approval tile - see ezBuyerWelcome.jsp / ezWelcomePageCounts.jsp's
     * TOBEAPPVNRS query. Counts registrations currently sitting at a workflow step this buyer can
     * act on (CustomerFormHeaderRepository.countToAct), not every pending registration in the
     * system - matches "To Act" semantics used by the deep-linked /vendorReg/list?type=Act view.
     */
    @Override
    public int getDomesticVendorPendingApprovalCount(String buyerUserId) {
        return (int) customerFormHeaderRepository.countToAct(buyerUserId, "IN");
    }

    @Override
    public int getImportVendorPendingApprovalCount(String buyerUserId) {
        return (int) customerFormHeaderRepository.countToAct(buyerUserId, "IM");
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
