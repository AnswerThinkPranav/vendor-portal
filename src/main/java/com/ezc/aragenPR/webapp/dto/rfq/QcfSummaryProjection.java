package com.ezc.aragenPR.webapp.dto.rfq;

import java.time.LocalDateTime;

/** Native-query projection backing the QCF list (grouped by ERH_COLLETIVE_RFQ_NO) - see RfqHeaderRepository. */
public interface QcfSummaryProjection {
    String getQcfNo();
    String getQcfTitle();
    String getPlant();
    String getCreatedBy();
    LocalDateTime getRfqDate();
    LocalDateTime getValidUpto();
    Long getNoOfVendors();
    Long getForBuyerApproval();
}
