package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Native-query projection backing the QCS list (QCFs already submitted into the approval workflow) - see WfDocHistoryHeaderRepository. */
public interface QcsSummaryProjection {
    String getQcfNo();
    String getWfStatus();
    LocalDateTime getModifiedOn();
    String getBuyer();
    String getQcfTitle();
    String getPlant();
    BigDecimal getDocValue();
    Long getNoOfVendors();
    Long getForBuyerApproval();
}
