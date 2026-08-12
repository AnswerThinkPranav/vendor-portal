package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_CUSTOMER_FORM_HEADER table (see db.sql) - one row
 * per vendor registration/invite request. ECFH_DOC_ID is the temp vendor id assigned at
 * invite time (see VendorRegistrationServiceImpl.generateNextTempVendorId).
 */
@Entity
@Table(name = "ezc_customer_form_header")
@Data
public class CustomerFormHeader {

    @Id
    @Column(name = "ECFH_DOC_ID", length = 10)
    private String docId;

    @Column(name = "ECFH_SALES_ORG", length = 5)
    private String salesOrg;

    @Column(name = "ECFH_CUST_NAME", length = 50)
    private String custName;

    @Column(name = "ECFH_CREATED_BY", length = 10)
    private String createdBy;

    @Column(name = "ECFH_CREATED_ON")
    private LocalDate createdOn;

    @Column(name = "ECFH_MODIFIED_BY", length = 10)
    private String modifiedBy;

    @Column(name = "ECFH_MODIFIED_ON")
    private LocalDate modifiedOn;

    @Column(name = "ECFH_SAP_CODE", length = 10)
    private String sapCode;

    /** INITIATED / SUBMITTED / RESUBMITTED / REJECTED / APPROVED (see ezWelcomeTempUser.jsp). */
    @Column(name = "ECFH_STATUS", length = 15)
    private String status;

    /** Company code lives here, not in a dedicated column - matches the legacy save (ezAddTempUser.jsp). */
    @Column(name = "ECFH_EXT1", length = 100)
    private String ext1;

    @Column(name = "ECFH_EXT2", length = 40)
    private String ext2;

    @Column(name = "ECFH_EXT3", length = 10)
    private String ext3;

    @Column(name = "ECFH_NEXT_PARTICIPANT", length = 100)
    private String nextParticipant;

    /** Constant "V" for vendor requests - matches legacy. */
    @Column(name = "ECFH_MASTER_TYPE", length = 1)
    private String masterType;

    @Column(name = "ECFH_PAN_NO", length = 15)
    private String panNo;

    @Column(name = "ECFH_VEN_GRP", length = 10)
    private String venGrp;

    /** IN = Domestic, IM = International. */
    @Column(name = "ECFH_VEN_TYPE", length = 3)
    private String venType;

    @Column(name = "ECFH_PLANT", length = 5)
    private String plant;

    @Column(name = "ECFH_CATEGORY", length = 10)
    private String category;
}
