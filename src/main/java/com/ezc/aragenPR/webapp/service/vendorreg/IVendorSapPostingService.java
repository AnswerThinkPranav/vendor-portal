package com.ezc.aragenPR.webapp.service.vendorreg;

import com.ezc.aragenPR.webapp.dto.vendorreg.SapValidationResult;

/**
 * Posts an approved vendor registration into SAP as a real vendor master record - see
 * Vendor Portal/JSP/Misc/ezPrePostVendorToSAP.jsp (validate) and ezPostVendorToSAP.jsp
 * (create). No mock fallback: both calls fail loudly (throw) when SAP is unreachable,
 * unlike the RFQ PR-fetch flow's mock-on-failure pattern - a vendor master record is
 * consequential enough that a silent substitute would be worse than an explicit error.
 */
public interface IVendorSapPostingService {

    /** Z_RFC_VENDOR_VALIDATE (CHCK='H') - validates without creating; returns any SAP warnings/errors. */
    SapValidationResult validateVendor(String docId);

    /**
     * Z_RFC_VENDOR_CREATE - creates the vendor master in SAP. On success, stores the
     * returned SAP vendor code on the registration, flips it to POSTED, and closes the
     * approval workflow (APPROVED). Returns the assigned SAP vendor code.
     */
    String postVendor(String docId, String actorUserId, String comments);
}
