package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.model.rfq.RfqPr;
import com.ezc.aragenPR.webapp.model.rfq.RfqPrId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RfqPrRepository extends JpaRepository<RfqPr, RfqPrId> {

    /** Used to flag "RFQ already created" against a PR in the search results - see ezListPR.jsp. */
    List<RfqPr> findByPrNoIn(List<String> prNos);
}
