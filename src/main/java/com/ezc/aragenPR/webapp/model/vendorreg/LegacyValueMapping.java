package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Reads the legacy Vendor Portal EZC_VALUE_MAPPING columns (MAP_TYPE/VALUE1/VALUE2 - see
 * db.sql), used for the Invite Vendor Category dropdown (MAP_TYPE='CATEGORY') and the
 * TEMP_USER_NR_RANGE sequence counter that assigns temp vendor ids.
 *
 * <p>This is a <b>separate entity from {@code model.master.EzValueMapping}</b>, which maps
 * the same physical table but to Aragen's own EVM_MAP_KEY/EVM_VALUE1/EVM_VALUE2 columns.
 * Both column sets already coexist side by side in the live {@code ezc_value_mapping}
 * table (confirmed in the `portal` database) - Hibernate added Aragen's columns
 * additively next to the legacy ones already there. Two JPA entities mapping the same
 * table with different columns/keys is intentional here, not a mistake - do not merge
 * them, and do not change {@code EzValueMapping} to read these columns.
 */
@Entity
@Table(name = "ezc_value_mapping")
@IdClass(LegacyValueMappingId.class)
@Data
public class LegacyValueMapping {

    @Id
    @Column(name = "MAP_TYPE", length = 20)
    private String mapType;

    @Id
    @Column(name = "VALUE1", length = 50)
    private String value1;

    @Id
    @Column(name = "VALUE2", length = 500)
    private String value2;
}
