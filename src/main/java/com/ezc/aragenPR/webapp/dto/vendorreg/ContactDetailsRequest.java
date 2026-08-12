package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.util.List;

import lombok.Data;

/** Tab 1 (CONTCT_DET / CONTCT_DET1) - see ezVendReg.jsp "Vendor Information" tab. */
@Data
public class ContactDetailsRequest {

    private String title;
    private String vendName;
    private String searchTerm;
    private String addrsLine1;
    private String addrsLine2;
    private String addrsLine3;
    private String addrsLine4;
    private String addrsLine5;
    private String postalCode;
    private String districtName;
    private String city;
    private String state;
    private String country;
    private String phoneNum;
    private String altPhoneNum;
    private String mobNum;
    private String altMobNum;
    private String fax;
    private String email1;
    private String email2;
    private String website;
    private List<String> conMethod;
    private String othConMethod;
    private List<ContactPerson> contacts;

    @Data
    public static class ContactPerson {
        private String title;
        private String name;
        private String designation;
        private String phone;
        private String email;
    }
}
