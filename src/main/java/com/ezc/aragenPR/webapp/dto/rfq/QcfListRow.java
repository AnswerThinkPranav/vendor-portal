package com.ezc.aragenPR.webapp.dto.rfq;

/** One row of the QCF List / QCS List grids - see ezListQcfs.jsp / ezQCSList.jsp. */
public record QcfListRow(
        String qcfNo,
        String qcfTitle,
        String plant,
        String createdBy,
        String createdOn,
        String expiryDate,
        long noOfVendorsSent,
        long noOfVendorsReceived,
        String status,
        String statusColor,
        String docValue) {
}
