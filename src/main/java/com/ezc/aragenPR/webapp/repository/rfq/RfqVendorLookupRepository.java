package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import com.ezc.aragenPR.webapp.model.user.Users;

/**
 * Vendor lookups for the RFQ "Select Vendor" step - see ezListIRL.jsp ("SAP Vendors"
 * tab, EU_TYPE=3) and ezNonSAPVendors.jsp ("Non SAP Vendors" tab, EU_TYPE=4 with
 * ALLOW_RFQ='Y'). Kept as read-only native queries here rather than composed from
 * UserRepository since these are the exact multi-table filters the legacy JSPs use,
 * not general-purpose user lookups.
 */
public interface RfqVendorLookupRepository extends Repository<Users, String> {

    /**
     * Search-as-you-type, capped at 50 rows - the live vendor master can hold thousands
     * of SAP vendors (7000+ observed), so listing them all in one response/DOM is not
     * viable; the caller must narrow with {@code q} (matched against id or name).
     */
    @Query(value = "SELECT * FROM ezc_users WHERE EU_TYPE = '3' AND EU_ID <> 'EZCADMIN' "
            + "AND (:q IS NULL OR :q = '' OR EU_ID LIKE CONCAT('%',:q,'%') OR EU_FIRST_NAME LIKE CONCAT('%',:q,'%')) "
            + "ORDER BY EU_FIRST_NAME LIMIT 50", nativeQuery = true)
    List<Users> findSapVendors(@Param("q") String q);

    @Query(value = "SELECT * FROM ezc_users u WHERE u.EU_TYPE = '4' "
            + "AND u.EU_ID IN (SELECT EUD_USER_ID FROM ezc_user_defaults WHERE EUD_KEY = 'ALLOW_RFQ' AND EUD_VALUE = 'Y') "
            + "AND (:q IS NULL OR :q = '' OR u.EU_ID LIKE CONCAT('%',:q,'%') OR u.EU_FIRST_NAME LIKE CONCAT('%',:q,'%')) "
            + "ORDER BY u.EU_FIRST_NAME LIMIT 50", nativeQuery = true)
    List<Users> findNonSapVendors(@Param("q") String q);

    // --- Paginated/searchable variants for the DataTables-backed "Select Vendor" grid.
    // Spring Data derives LIMIT/OFFSET from the Pageable for native queries when a
    // countQuery is also supplied - avoids binding LIMIT/OFFSET as query params directly,
    // which some MySQL driver/prepared-statement combinations reject. ---

    @Query(value = "SELECT * FROM ezc_users WHERE EU_TYPE = '3' AND EU_ID <> 'EZCADMIN' "
            + "AND (:q = '' OR EU_ID LIKE CONCAT('%',:q,'%') OR EU_FIRST_NAME LIKE CONCAT('%',:q,'%') OR EU_EMAIL LIKE CONCAT('%',:q,'%'))",
            countQuery = "SELECT COUNT(*) FROM ezc_users WHERE EU_TYPE = '3' AND EU_ID <> 'EZCADMIN' "
            + "AND (:q = '' OR EU_ID LIKE CONCAT('%',:q,'%') OR EU_FIRST_NAME LIKE CONCAT('%',:q,'%') OR EU_EMAIL LIKE CONCAT('%',:q,'%'))",
            nativeQuery = true)
    Page<Users> findSapVendorsPage(@Param("q") String q, Pageable pageable);

    @Query(value = "SELECT * FROM ezc_users u WHERE u.EU_TYPE = '4' "
            + "AND u.EU_ID IN (SELECT EUD_USER_ID FROM ezc_user_defaults WHERE EUD_KEY = 'ALLOW_RFQ' AND EUD_VALUE = 'Y') "
            + "AND (:q = '' OR u.EU_ID LIKE CONCAT('%',:q,'%') OR u.EU_FIRST_NAME LIKE CONCAT('%',:q,'%') OR u.EU_EMAIL LIKE CONCAT('%',:q,'%'))",
            countQuery = "SELECT COUNT(*) FROM ezc_users u WHERE u.EU_TYPE = '4' "
            + "AND u.EU_ID IN (SELECT EUD_USER_ID FROM ezc_user_defaults WHERE EUD_KEY = 'ALLOW_RFQ' AND EUD_VALUE = 'Y') "
            + "AND (:q = '' OR u.EU_ID LIKE CONCAT('%',:q,'%') OR u.EU_FIRST_NAME LIKE CONCAT('%',:q,'%') OR u.EU_EMAIL LIKE CONCAT('%',:q,'%'))",
            nativeQuery = true)
    Page<Users> findNonSapVendorsPage(@Param("q") String q, Pageable pageable);
}
