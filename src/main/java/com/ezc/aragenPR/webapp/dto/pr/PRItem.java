package com.ezc.aragenPR.webapp.dto.pr;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import com.ezc.aragenPR.webapp.dto.pr.PRService;

@Data
public class PRItem {
    private String itemNumber;
    private String division;
    private String department;
    private String matNumber;
    private String shortText;
    private String cas;
    private BigDecimal quantity;
    private String uom;
    private String plant;
    private BigDecimal valPrice;
    private String total;
    private String materialGroup;
    private String deliveryDate;// yyyy-MM-dd
    private String periodInd;
    private String purGrp;
    private String accAsmt;
    private String reqName;
    private String glAcc;
    private String glAccDesc;
    private String projCode;
    private String projCodeDesc;
    private String wbsElement;
    private String internalOrder;
    private String network;
    private String costCenter;
    private String storageLoc;
    private String trackNo;
    private String packSize;
    private String coa;
    private String passThrough;
    private String msds;
    private String status;
    private String reason;
    private String agreement;
    private String catalog;
    private String fixVendor;
    private String aggrItem;
    private String currency;
    private List<PRService> services;


}
