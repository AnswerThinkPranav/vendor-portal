package com.ezc.aragenPR.webapp.dto.vendorreg;

import lombok.Data;

/** Full pre-fill payload for the vendor registration form (GET /vendorReg/register?docId=...). */
@Data
public class VendorRegistrationDetails {

    private String docId;
    private String custName;
    private String status;
    private ContactDetailsRequest contact = new ContactDetailsRequest();
    private ConstitutionDetailsRequest constitution = new ConstitutionDetailsRequest();
    private MsmeDetailsRequest msme = new MsmeDetailsRequest();
    private DocumentDetailsRequest documents = new DocumentDetailsRequest();
    private BankDetailsRequest bank = new BankDetailsRequest();
}
