package com.ezc.aragenPR.webapp.dto.vendorreg;

import lombok.Data;

/** Tab 4 (DOC_DET) - see ezVendReg.jsp "Attachments" tab. Each field holds an uploaded filename. */
@Data
public class DocumentDetailsRequest {

    private String itrAttach;
    private String moaAttach;
    private String fsAttach;
    private String saAttach;
    private String kcAttach;
    private String othAttach;
}
