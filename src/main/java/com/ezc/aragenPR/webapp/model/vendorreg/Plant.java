package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_PLANTS table (see db.sql) - only the columns the
 * Invite Vendor plant dropdown actually needs.
 */
@Entity
@Table(name = "ezc_plants")
@Data
public class Plant {

    @Id
    @Column(name = "EP_PLANT", length = 8)
    private String plant;

    @Column(name = "EP_NAME1", length = 35)
    private String name1;
}
