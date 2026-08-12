package com.ezc.aragenPR.webapp.model.workflow;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_WF_PRICING_CONDITIONS table (see db.sql) - the
 * ordered levels of a workflow template. Despite the "pricing"/"QCF" naming (this engine
 * originated for QCF value-threshold routing), it's the same generic level/role/group
 * table used for VNR (vendor registration) and other document types - see
 * ezWFCommonMethods.jsp#getNextPart.
 */
@Entity
@Table(name = "ezc_wf_pricing_conditions")
@IdClass(WfPricingConditionId.class)
@Data
public class WfPricingCondition {

    @Id
    @Column(name = "EWPC_TEMPLATE")
    private Integer template;

    @Id
    @Column(name = "EWPC_LEVEL")
    private Integer level;

    @Id
    @Column(name = "EWPC_ROLE", length = 20)
    private String role;

    @Id
    @Column(name = "EWPC_GROUP", length = 20)
    private String group;

    /** Condition operator (e.g. LE/GE) - only meaningful for value-gated (QCF/PR) templates; VNR levels always apply. */
    @Column(name = "EWPC_QCF_FLAG", length = 5)
    private String conditionFlag;

    @Column(name = "EWPC_QCF_RELEASE")
    private Long conditionValue;
}
