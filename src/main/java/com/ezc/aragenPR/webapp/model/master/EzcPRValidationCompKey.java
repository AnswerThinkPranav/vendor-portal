package com.ezc.aragenPR.webapp.model.master;

import java.io.Serializable;
import java.util.Objects;

public class EzcPRValidationCompKey implements Serializable {

    private String companyCode;
    private String docType;
    private String accountAssignment;
    private String fieldName;

    public EzcPRValidationCompKey() {
    }

    public EzcPRValidationCompKey(String companyCode, String docType,
                                  String accountAssignment, String fieldName) {
        this.companyCode = companyCode;
        this.docType = docType;
        this.accountAssignment = accountAssignment;
        this.fieldName = fieldName;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof EzcPRValidationCompKey)) return false;
        EzcPRValidationCompKey that = (EzcPRValidationCompKey) o;
        return Objects.equals(companyCode, that.companyCode) &&
                Objects.equals(docType, that.docType) &&
                Objects.equals(accountAssignment, that.accountAssignment) &&
                Objects.equals(fieldName, that.fieldName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(companyCode, docType, accountAssignment, fieldName);
    }
}