package com.ezc.aragenPR.webapp.dto.vendorreg;

import lombok.Data;

/** Tab 5 (BANK_DET) - see ezVendReg.jsp "Bank Details" tab. */
@Data
public class BankDetailsRequest {

    private String accntPer;
    private String accntEmail;
    private String accntMobile;
    private String rtgsCode;
    private String bankName;
    private String bankBranch;
    private String accntNumber;
    private String bankSwift;
    private String chequeNo;
}
