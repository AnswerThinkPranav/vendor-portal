package com.ezc.aragenPR.webapp.model.vendorreg;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_CUSTOMER_FORM_DETAILS table (see db.sql) - a
 * generic key/value extension of {@link CustomerFormHeader} for fields that don't have a
 * dedicated header column (email, contact number, RFQ/registration authorization flags
 * at invite time). The legacy table has no primary key at all; {@code id} is a new,
 * purely additive surrogate key so JPA has something to key rows on.
 */
@Entity
@Table(name = "ezc_customer_form_details")
@Data
public class CustomerFormDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ECFD_DOC_ID", length = 10)
    private String docId;

    @Column(name = "ECFD_FIELD", length = 20)
    private String field;

    @Column(name = "ECFD_VALUE", length = 100)
    private String value;

    @Column(name = "ECFD_TAB_NAME", length = 20)
    private String tabName;

    @Column(name = "ECFD_EXT1", length = 10)
    private String ext1;

    @Column(name = "ECFD_EXT2", length = 10)
    private String ext2;

    public CustomerFormDetail() {
    }

    public CustomerFormDetail(String docId, String field, String value, String tabName) {
        this.docId = docId;
        this.field = field;
        this.value = value;
        this.tabName = tabName;
    }
}
