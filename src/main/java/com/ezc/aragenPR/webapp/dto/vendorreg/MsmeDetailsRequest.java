package com.ezc.aragenPR.webapp.dto.vendorreg;

import lombok.Data;

/** Tab 3 (MSME_DET) - see ezVendReg.jsp "Financial Information" tab. */
@Data
public class MsmeDetailsRequest {

    private String msmeType;
    private String msmeUdyogAdhrNo;
    private String paymntTerms;
    private String busStatus;
    private String eInvoice;
    private String vendJgl;
    private String vendUnit;
    private String vendTrans;
    private String vendDtls;
    private String vendSite;
    private String sitePerson;
    private String siteViDt;
}
