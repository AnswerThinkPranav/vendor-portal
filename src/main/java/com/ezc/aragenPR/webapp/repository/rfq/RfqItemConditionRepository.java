package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.model.rfq.RfqItemCondition;
import com.ezc.aragenPR.webapp.model.rfq.RfqItemConditionId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RfqItemConditionRepository extends JpaRepository<RfqItemCondition, RfqItemConditionId> {

    List<RfqItemCondition> findByRfqNoAndVendor(String rfqNo, String vendor);
}
