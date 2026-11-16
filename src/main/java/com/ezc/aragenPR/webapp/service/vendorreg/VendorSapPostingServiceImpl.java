package com.ezc.aragenPR.webapp.service.vendorreg;

import java.time.LocalDate;

import com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields;
import com.ezc.aragenPR.webapp.dto.vendorreg.SapValidationResult;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;
import com.ezc.aragenPR.webapp.repository.vendorreg.CustomerFormHeaderRepository;
import com.ezc.aragenPR.webapp.sap.vendor.IVendorSapGateway;
import com.ezc.aragenPR.webapp.service.workflow.IWorkflowEngineService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Business flow for posting an approved vendor registration into SAP - docId lookups, the
 * unanswered-query guard, and the dual-write (header status + workflow transition) that happens
 * once SAP accepts the vendor. The actual SAP call (FM or OData, switchable) lives entirely in
 * {@link IVendorSapGateway} (package {@code com.ezc.aragenPR.webapp.sap.vendor}) - this class
 * never touches JCo or OData directly, so a SAP-side problem is always isolated to that package.
 */
@Slf4j
@Service
public class VendorSapPostingServiceImpl implements IVendorSapPostingService {

    private static final String WF_DOC_TYPE = "VNR";

    @Autowired
    private IVendorRegistrationService vendorRegistrationService;

    @Autowired
    private CustomerFormHeaderRepository customerFormHeaderRepository;

    @Autowired
    private IWorkflowEngineService workflowEngineService;

    @Autowired
    private IVendorSapGateway vendorSapGateway;

    @Override
    public SapValidationResult validateVendor(String docId) {
        CustomerFormHeader header = requireHeader(docId);
        VendorRegistrationDetails details = vendorRegistrationService.getVendorRegistrationDetails(docId);
        FinanceReviewFields finance = vendorRegistrationService.getFinanceFields(docId);
        return vendorSapGateway.validateVendor(docId, header, details, finance);
    }

    @Override
    @Transactional
    public String postVendor(String docId, String actorUserId, String comments) {
        if (vendorRegistrationService.hasUnansweredQuery(docId)) {
            throw new IllegalStateException("Query has not been replied to this Vendor Registration. You cannot submit/approve Vendor Registration now.");
        }

        CustomerFormHeader header = requireHeader(docId);
        VendorRegistrationDetails details = vendorRegistrationService.getVendorRegistrationDetails(docId);
        FinanceReviewFields finance = vendorRegistrationService.getFinanceFields(docId);

        String vendorCode = vendorSapGateway.createVendor(docId, header, details, finance);

        if (vendorCode == null || vendorCode.isBlank()) {
            throw new IllegalStateException("SAP did not return a vendor code for " + docId);
        }

        header.setSapCode(vendorCode);
        header.setStatus("POSTED");
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(LocalDate.now());
        header.setNextParticipant("");
        customerFormHeaderRepository.save(header);

        workflowEngineService.markApproved(WF_DOC_TYPE, docId, actorUserId, comments);

        return vendorCode;
    }

    private CustomerFormHeader requireHeader(String docId) {
        return customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));
    }
}
