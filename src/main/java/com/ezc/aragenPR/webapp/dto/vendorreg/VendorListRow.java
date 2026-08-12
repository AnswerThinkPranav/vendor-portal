package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.time.LocalDate;

/** One row in the "New" or "List" vendor registration tables - see ezTempVendList.jsp / ezVNRList.jsp. */
public record VendorListRow(
        String docId,
        String custName,
        String purOrg,
        String createdBy,
        LocalDate createdOn,
        LocalDate modifiedOn,
        String status,
        String sapCode
) {
}
