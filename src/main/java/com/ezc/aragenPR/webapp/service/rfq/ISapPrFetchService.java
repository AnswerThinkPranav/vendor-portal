package com.ezc.aragenPR.webapp.service.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.dto.rfq.PrLineItem;
import com.ezc.aragenPR.webapp.dto.rfq.PrSearchCriteria;

public interface ISapPrFetchService {

    /**
     * Fetches matching Purchase Requisition lines live from SAP (Z_EZ_GET_PRS via JCo -
     * see Vendor Portal/Includes/includes/iListPR.jsp for the legacy call this mirrors).
     * If SAP is unreachable (e.g. no live connection in this environment - see
     * sap.properties), falls back to a single example PR line so the rest of the
     * RFQ-creation flow can be built/tested end-to-end without SAP access. The real
     * call path is fully implemented and will be used automatically once deployed
     * somewhere with real SAP connectivity.
     */
    List<PrLineItem> fetchPurchaseRequisitions(PrSearchCriteria criteria, String buyerUserId);
}
