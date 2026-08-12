package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.util.List;

import lombok.Data;

/** Tab 2 (CONSTN_DET) - see ezVendReg.jsp "Commercial Information" tab. */
@Data
public class ConstitutionDetailsRequest {

    private String typeOfOrg;
    private String othCompType;
    private List<String> supType;
    private String othSupType;
    private List<String> vendorType;
    private String purOrdCurr;
    /** "Place of Delivery" - free text despite the INCO_Terms-like name (matches legacy). */
    private String incoTerms2;
    private String incoTerms;
    private String panAttach;
    private String panName;
    private String panNumber;
    private String gstVendorClas;
    private String gstType;
    private String gstNumber;
}
