package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.model.rfq.RfqQuoteHistory;
import com.ezc.aragenPR.webapp.model.rfq.RfqQuoteHistoryId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RfqQuoteHistoryRepository extends JpaRepository<RfqQuoteHistory, RfqQuoteHistoryId> {

    List<RfqQuoteHistory> findByRfqNoAndVendor(String rfqNo, String vendor);
}
