package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

import lombok.Data;

/** "From PRs" search filters - see Vendor Portal/JSP/RFQ/ezPrePRList.jsp. */
@Data
public class PrSearchCriteria {

    /** R = Released, U = Unreleased. */
    private String status = "R";
    private List<String> purGrp;
    private List<String> plant;
    private List<String> docType;
    private List<String> matGrp;
    private List<String> accCat;
    private List<String> itemCat;
    private String prLow;
    private String prHigh;
    private String matLow;
    private String matHigh;
    /** Y / N / A (All) - amended PR filter. */
    private String amended = "A";
    /** Y / N / A (All) - RFQ-already-created filter. */
    private String rfqStatus = "N";
    private Integer days = 60;
}
