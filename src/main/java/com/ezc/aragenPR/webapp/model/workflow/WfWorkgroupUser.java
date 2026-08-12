package com.ezc.aragenPR.webapp.model.workflow;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/** Mirrors the legacy Vendor Portal EZC_WF_WORKGROUP_USERS table (see db.sql) - group membership for workflow routing. */
@Entity
@Table(name = "ezc_wf_workgroup_users")
@IdClass(WfWorkgroupUserId.class)
@Data
public class WfWorkgroupUser {

    @Id
    @Column(name = "EWWU_GROUP", length = 10)
    private String group;

    @Id
    @Column(name = "EWWU_USER", length = 10)
    private String user;

    @Id
    @Column(name = "EWWU_SYSKEY", length = 20)
    private String sysKey;

    @Column(name = "EWWU_SOLD_TO", length = 20)
    private String soldTo;

    @Column(name = "EWWU_EFFECTIVE_FROM")
    private LocalDateTime effectiveFrom;

    @Column(name = "EWWU_EFFECTIVE_TO")
    private LocalDateTime effectiveTo;
}
