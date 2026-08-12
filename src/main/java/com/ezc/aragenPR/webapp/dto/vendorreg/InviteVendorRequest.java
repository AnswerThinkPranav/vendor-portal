package com.ezc.aragenPR.webapp.dto.vendorreg;

import lombok.Data;

/** Invite Vendor form submission - see Vendor Portal/JSP/Misc/ezTempUserCreation.jsp. */
@Data
public class InviteVendorRequest {

    private String userName;
    private String email;
    private String contactNo;
    private String purOrg;
    private String compCode;
    private String venGrp;
    private String venType;
    private String selPlant;
    private String selCategory;
    private boolean rfqAuth;
    private boolean vendRegAuth;
}
