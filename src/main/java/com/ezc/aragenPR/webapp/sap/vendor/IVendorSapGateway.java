package com.ezc.aragenPR.webapp.sap.vendor;

import com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields;
import com.ezc.aragenPR.webapp.dto.vendorreg.SapValidationResult;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;

/**
 * Everything that actually talks to SAP for vendor creation/validation lives behind this
 * interface, isolated under {@code com.ezc.aragenPR.webapp.sap.vendor} - away from the business
 * flow (docId lookups, workflow transitions, status updates), which stays in
 * {@code service.vendorreg.VendorSapPostingServiceImpl}. Keeping the two apart means a SAP-side
 * problem (wrong field, wrong FM, a connection issue) is always isolated to this package, never
 * mixed into the business logic you'd otherwise have to re-read to rule it out.
 */
public interface IVendorSapGateway {

    /** Z_RFC_VENDOR_VALIDATE (FM mode) or the configured OData service (ODATA mode). */
    SapValidationResult validateVendor(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance);

    /**
     * Z_RFC_VENDOR_CREATE (FM mode) or the configured OData service (ODATA mode). Returns the
     * SAP-assigned vendor code, or null/blank if SAP didn't return one (caller decides how to
     * treat that).
     */
    String createVendor(String docId, CustomerFormHeader header, VendorRegistrationDetails details,
            FinanceReviewFields finance);
}
