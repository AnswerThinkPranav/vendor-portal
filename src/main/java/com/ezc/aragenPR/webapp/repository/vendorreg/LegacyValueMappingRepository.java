package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.vendorreg.LegacyValueMapping;
import com.ezc.aragenPR.webapp.model.vendorreg.LegacyValueMappingId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LegacyValueMappingRepository extends JpaRepository<LegacyValueMapping, LegacyValueMappingId> {

    List<LegacyValueMapping> findByMapTypeAndValue1InOrderByValue2Asc(String mapType, List<String> value1s);

    List<LegacyValueMapping> findByMapTypeOrderByValue2Asc(String mapType);

    /**
     * Locks the TEMP_USER_NR_RANGE counter row for the duration of the caller's
     * transaction so concurrent invites can't be assigned the same temp vendor id -
     * the legacy JSP read-then-update was not atomic, this fixes that.
     */
    @Query(value = "SELECT VALUE1 FROM ezc_value_mapping WHERE MAP_TYPE = 'TEMP_USER_NR_RANGE' LIMIT 1 FOR UPDATE",
            nativeQuery = true)
    Optional<String> lockTempUserNrRangeValue1();

    /** Unlocked read for display-only purposes - see IVendorRegistrationService.peekNextTempVendorId. */
    @Query(value = "SELECT VALUE1 FROM ezc_value_mapping WHERE MAP_TYPE = 'TEMP_USER_NR_RANGE' LIMIT 1",
            nativeQuery = true)
    Optional<String> peekTempUserNrRangeValue1();

    @Modifying
    @Query(value = "UPDATE ezc_value_mapping SET VALUE1 = :nextValue WHERE MAP_TYPE = 'TEMP_USER_NR_RANGE'",
            nativeQuery = true)
    void updateTempUserNrRangeValue1(@Param("nextValue") String nextValue);

    /**
     * ezc_value_mapping also carries Aragen's own EVM_MAP_KEY/EVM_VALUE1/EVM_VALUE2
     * columns (NOT NULL, no default - see EzValueMapping), coexisting with the legacy
     * MAP_TYPE/VALUE1/VALUE2 columns this repository reads/writes. Both sets must be
     * supplied on INSERT or MySQL rejects the row; empty string is fine since those
     * columns are irrelevant to a TEMP_USER_NR_RANGE row.
     */
    @Modifying
    @Query(value = "INSERT INTO ezc_value_mapping (MAP_TYPE, VALUE1, VALUE2, EVM_MAP_KEY, EVM_VALUE1, EVM_VALUE2) "
            + "VALUES ('TEMP_USER_NR_RANGE', :value1, '', '', '', '')",
            nativeQuery = true)
    void seedTempUserNrRange(@Param("value1") String value1);
}
