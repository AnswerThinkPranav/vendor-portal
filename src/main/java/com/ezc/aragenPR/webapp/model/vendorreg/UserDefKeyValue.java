package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_USER_DEF_KEY_VALUES table (see db.sql) - holds a
 * buyer's allowed PLANT codes and PLANT#CATEGORY combinations (EUDKV_KEY='PLANT' /
 * 'CATEGORY'), used to scope the Invite Vendor Plant/Category dropdowns to what the
 * logged-in buyer is actually authorized for (matches ezGetUserAuthDefaults.jsp's
 * gv_PlantVect / gv_CategoryVectAll). No JPA entity existed for this table before -
 * see VENDOR-PORTAL-MERGE-HANDOFF.md.
 */
@Entity
@Table(name = "ezc_user_def_key_values")
@IdClass(UserDefKeyValueId.class)
@Data
public class UserDefKeyValue {

    @Id
    @Column(name = "EUDKV_USER_ID", length = 20)
    private String userId;

    @Id
    @Column(name = "EUDKV_SYS_KEY", length = 6)
    private String sysKey;

    @Id
    @Column(name = "EUDKV_KEY", length = 10)
    private String key;

    @Id
    @Column(name = "EUDKV_VALUE", length = 20)
    private String value;

    @Column(name = "EUDKV_EXT1", length = 15)
    private String ext1;

    @Column(name = "EUDKV_EXT2", length = 15)
    private String ext2;
}
