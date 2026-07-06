package com.ezc.aragenPR.webapp.model.master;

import jakarta.persistence.*;

@Entity
@Table(name = "EZC_PR_VALIDATION_MASTER")
@IdClass(EzcPRValidationCompKey.class)
public class EzcPRValidationMaster {

    @Id
    @Column(name = "EPV_COMPANY_CODE", length = 4)
    private String companyCode;

    @Id
    @Column(name = "EPV_DOC_TYPE", length = 5)
    private String docType;

    @Id
    @Column(name = "EPV_ACC_ASSIGNMENT", length = 2)
    private String accountAssignment;

    @Id
    @Column(name = "EPV_FIELD_NAME", length = 50)
    private String fieldName;

    @Column(name = "EPV_DISPLAY_NAME", length = 50)
    private String displayName;

    @Column(name = "EPV_MANDATORY", length = 1)
    private String mandatory;

    @Column(name = "EPV_VISIBLE", length = 1)
    private String visible;

    @Column(name = "EPV_EDITABLE", length = 1)
    private String editable;

    @Column(name = "EPV_FIELD_TYPE", length = 15)
    private String fieldType;

    @Column(name = "EPV_FIELD_LENGTH", length = 10)
    private Integer fieldLength;

    @Column(name = "EPV_DEFAULT_VALUE", length = 10)
    private String defaultValue;

    @Column(name = "EPV_VALIDATION_MSG", length = 50)
    private String validationMessage;

    @Column(name = "EPV_ACTIVE", length = 1)
    private String active;

    public EzcPRValidationMaster() {
    }

    public String getCompanyCode() {
        return companyCode;
    }

    public void setCompanyCode(String companyCode) {
        this.companyCode = companyCode;
    }

    public String getDocType() {
        return docType;
    }

    public void setDocType(String docType) {
        this.docType = docType;
    }

    public String getAccountAssignment() {
        return accountAssignment;
    }

    public void setAccountAssignment(String accountAssignment) {
        this.accountAssignment = accountAssignment;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getMandatory() {
        return mandatory;
    }

    public void setMandatory(String mandatory) {
        this.mandatory = mandatory;
    }

    public String getVisible() {
        return visible;
    }

    public void setVisible(String visible) {
        this.visible = visible;
    }

    public String getEditable() {
        return editable;
    }

    public void setEditable(String editable) {
        this.editable = editable;
    }

    public String getFieldType() {
        return fieldType;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public Integer getFieldLength() {
        return fieldLength;
    }

    public void setFieldLength(Integer fieldLength) {
        this.fieldLength = fieldLength;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getValidationMessage() {
        return validationMessage;
    }

    public void setValidationMessage(String validationMessage) {
        this.validationMessage = validationMessage;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }
}