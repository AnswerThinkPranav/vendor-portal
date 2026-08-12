package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_MASTER_KEY_VALUES table (see db.sql) - flat
 * master lists keyed by EMKV_MASTER_TYPE (e.g. PUR_ORG, COMP_CODE, VEN_GRP), used to
 * source the Invite Vendor form's dropdowns exactly as ezTempUserCreation.jsp does.
 */
@Entity
@Table(name = "ezc_master_key_values")
@IdClass(MasterKeyValueId.class)
@Data
public class MasterKeyValue {

    @Id
    @Column(name = "EMKV_MASTER_TYPE", length = 20)
    private String masterType;

    @Id
    @Column(name = "EMKV_KEY", length = 10)
    private String key;

    @Id
    @Column(name = "EMKV_VALUE", length = 100)
    private String value;

    @Column(name = "EMKV_VALUE1", length = 100)
    private String value1;

    @Column(name = "EMKV_VALUE2", length = 100)
    private String value2;

    @Column(name = "EMKV_VALUE3", length = 100)
    private String value3;
}
