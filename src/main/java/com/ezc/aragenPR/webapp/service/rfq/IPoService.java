package com.ezc.aragenPR.webapp.service.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.dto.rfq.PoSummary;
import com.ezc.aragenPR.webapp.model.user.Users;

/** Local-only Purchase Order creation from an approved QCF - see ezViewDOMQCF.jsp's Create PO button. */
public interface IPoService {

    /**
     * Creates one PO per vendor that was recommended (RfqDetail.poQty > 0 on at least one line)
     * in this QCF - only allowed once the QCF's workflow has reached APPROVED. Idempotent: if POs
     * already exist for this QCF, returns them instead of creating duplicates.
     */
    List<PoSummary> createPurchaseOrders(String qcfNo, Users buyer);

    List<PoSummary> getPurchaseOrders(String qcfNo);
}
