package com.ezc.aragenPR.webapp.dto.rfq;

/** One row in the "Select Vendor" step - see ezListIRL.jsp / ezNonSAPVendors.jsp. type is S (SAP) or N (non-SAP). */
public record VendorOption(String id, String name, String email, String contactNo, String type) {
}
