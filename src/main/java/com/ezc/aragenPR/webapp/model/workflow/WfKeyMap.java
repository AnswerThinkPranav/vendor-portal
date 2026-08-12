package com.ezc.aragenPR.webapp.model.workflow;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_WF_KEY_MAP table (see db.sql) - maps
 * (docType, compCode, plant, category) to the workflow template that governs approval
 * routing for documents raised against that combination. See Vendor Portal/Admin/WorkFlow/
 * ezWFUsers.jsp and JSP/Misc/ezWFCommonMethods.jsp#getWFTemplate.
 */
@Entity
@Table(name = "ezc_wf_key_map")
@IdClass(WfKeyMapId.class)
@Data
public class WfKeyMap {

    @Id
    @Column(name = "EWKM_DOC_TYPE", length = 4)
    private String docType;

    @Id
    @Column(name = "EWKM_COMP_CODE", length = 5)
    private String compCode;

    @Id
    @Column(name = "EWKM_PLANT", length = 5)
    private String plant;

    @Id
    @Column(name = "EWKM_CATEGORY", length = 10)
    private String category;

    @Column(name = "EWKM_TEMPLATE")
    private Integer template;
}
