package com.ezc.aragenPR.webapp.repository.workflow;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.workflow.WfPricingCondition;
import com.ezc.aragenPR.webapp.model.workflow.WfPricingConditionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WfPricingConditionRepository extends JpaRepository<WfPricingCondition, WfPricingConditionId> {

    List<WfPricingCondition> findByTemplateAndLevel(Integer template, Integer level);

    List<WfPricingCondition> findByTemplateOrderByLevelAsc(Integer template);

    @Query("SELECT MAX(w.level) FROM WfPricingCondition w WHERE w.template = :template")
    Optional<Integer> findMaxLevel(@Param("template") Integer template);
}
