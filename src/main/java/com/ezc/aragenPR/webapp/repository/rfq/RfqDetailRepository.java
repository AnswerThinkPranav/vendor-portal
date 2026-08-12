package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.model.rfq.RfqDetail;
import com.ezc.aragenPR.webapp.model.rfq.RfqDetailId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RfqDetailRepository extends JpaRepository<RfqDetail, RfqDetailId> {

    List<RfqDetail> findByRfqNo(String rfqNo);
}
