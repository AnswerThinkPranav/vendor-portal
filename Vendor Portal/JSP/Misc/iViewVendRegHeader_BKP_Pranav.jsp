<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%
ezc.ezcommon.EzLog4j.log("START JSP execution", "I");

boolean vendSubmit = false; ezc.ezcommon.EzLog4j.log("vendSubmit initialized", "I");
boolean vendReSubmit = false; ezc.ezcommon.EzLog4j.log("vendReSubmit initialized", "I");
boolean docSubmit = false; ezc.ezcommon.EzLog4j.log("docSubmit initialized", "I");
boolean docApprove = false; ezc.ezcommon.EzLog4j.log("docApprove initialized", "I");
boolean docPost = false; ezc.ezcommon.EzLog4j.log("docPost initialized", "I");
boolean isEditable = false; ezc.ezcommon.EzLog4j.log("isEditable initialized", "I");
boolean isPPEditable = false; ezc.ezcommon.EzLog4j.log("isPPEditable initialized", "I");

ezc.ezcommon.EzLog4j.log("docId="+docId, "I");

mainParams = new ezc.ezparam.EzcParams(false);
ezc.ezcommon.EzLog4j.log("mainParams created", "I");

miscTable = new ezc.misctransactions.params.EzMiscTable();
miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
ezc.ezcommon.EzLog4j.log("miscTable + row created", "I");

ezc.ezparam.ReturnObjFromRetrieve retVendHeader = null;
ezc.ezcommon.EzLog4j.log("retVendHeader initialized null", "I");

String headerQuery = "SELECT * from EZC_CUSTOMER_FORM_HEADER  WHERE ECFH_DOC_ID='"+docId+"'";
ezc.ezcommon.EzLog4j.log("Header Query: "+headerQuery, "I");

miscTableRow.setQuery(headerQuery);
miscTable.appendRow(miscTableRow);
mainParams.setLocalStore("Y");
mainParams.setObject(miscTable);

ezc.ezcommon.EzLog4j.log("Calling Session.prepareParams", "I");
Session.prepareParams(mainParams);

try {
    ezc.ezcommon.EzLog4j.log("Calling miscMgr.ezGetMiscTransactions", "I");
    retVendHeader=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
    ezc.ezcommon.EzLog4j.log("retVendHeader returned: "+retVendHeader, "I");
    if(retVendHeader != null)
        ezc.ezcommon.EzLog4j.log("retVendHeader rowCount="+retVendHeader.getRowCount(), "I");
}
catch(Exception e) {
    ezc.ezcommon.EzLog4j.log("Exception in header fetch: "+e, "E");
}

ezc.ezcommon.EzLog4j.log("Reading header fields", "I");

String compCode=retVendHeader.getFieldValueString(0,"ECFH_EXT1"); ezc.ezcommon.EzLog4j.log("compCode="+compCode, "I");
String plant=retVendHeader.getFieldValueString(0,"ECFH_PLANT"); ezc.ezcommon.EzLog4j.log("plant="+plant, "I");
String purOrg=retVendHeader.getFieldValueString(0,"ECFH_SALES_ORG"); ezc.ezcommon.EzLog4j.log("purOrg="+purOrg, "I");
String dept=retVendHeader.getFieldValueString(0,"ECFH_EXT2"); ezc.ezcommon.EzLog4j.log("dept="+dept, "I");
String docSts=retVendHeader.getFieldValueString(0,"ECFH_STATUS"); ezc.ezcommon.EzLog4j.log("docSts="+docSts, "I");
String wfKey=retVendHeader.getFieldValueString(0,"ECFH_WF_KEY"); ezc.ezcommon.EzLog4j.log("wfKey="+wfKey, "I");
String curLevel=""; ezc.ezcommon.EzLog4j.log("curLevel initialized empty", "I");
String hdrName = retVendHeader.getFieldValueString(0,"ECFH_CUST_NAME"); ezc.ezcommon.EzLog4j.log("hdrName="+hdrName, "I");
String hdrPan = retVendHeader.getFieldValueString(0,"ECFH_PAN_NO"); ezc.ezcommon.EzLog4j.log("hdrPan="+hdrPan, "I");
String venGrpVal = retVendHeader.getFieldValueString(0,"ECFH_VEN_GRP"); ezc.ezcommon.EzLog4j.log("venGrpVal="+venGrpVal, "I");
String venWFPlant=retVendHeader.getFieldValueString(0,"ECFH_PLANT"); ezc.ezcommon.EzLog4j.log("venWFPlant="+venWFPlant, "I");
String venWFCategory=retVendHeader.getFieldValueString(0,"ECFH_CATEGORY"); ezc.ezcommon.EzLog4j.log("venWFCategory="+venWFCategory, "I");
String vendType=retVendHeader.getFieldValueString(0,"ECFH_VEN_TYPE"); ezc.ezcommon.EzLog4j.log("vendType="+vendType, "I");
String accntPerName = retVendHeader.getFieldValueString(0,"ECFH_CUST_NAME"); ezc.ezcommon.EzLog4j.log("accntPerName="+accntPerName, "I");

int maxLevel = 0; ezc.ezcommon.EzLog4j.log("maxLevel initialized 0", "I");

if(wfKey != null && !"null".equals(wfKey) && !"".equals(wfKey)) {
    ezc.ezcommon.EzLog4j.log("Entering WF block", "I");

    mainParams = new ezc.ezparam.EzcParams(false);
    miscTable = new ezc.misctransactions.params.EzMiscTable();
    miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();

    ezc.ezparam.ReturnObjFromRetrieve retWFDet = null;

    String wfQuery = "SELECT * from EZC_USER_WORKFLOW  WHERE EZWF_WORKFLOWKEY='"+wfKey+"'";
    ezc.ezcommon.EzLog4j.log("WF Query="+wfQuery, "I");

    miscTableRow.setQuery(wfQuery);
    miscTable.appendRow(miscTableRow);
    mainParams.setLocalStore("Y");
    mainParams.setObject(miscTable);

    Session.prepareParams(mainParams);

    try {
        ezc.ezcommon.EzLog4j.log("Fetching WF data", "I");
        retWFDet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
        ezc.ezcommon.EzLog4j.log("retWFDet="+retWFDet, "I");
    }
    catch(Exception e) {
        ezc.ezcommon.EzLog4j.log("Exception in WF fetch="+e, "E");
    }

    if(retWFDet != null) {
        int retWFDetCnt = retWFDet.getRowCount();
        ezc.ezcommon.EzLog4j.log("WF rowCount="+retWFDetCnt, "I");

        for(int i=0;i<retWFDetCnt;i++) {
            ezc.ezcommon.EzLog4j.log("Loop i="+i, "I");

            String levelStr = retWFDet.getFieldValueString(i,"EZWF_LEVEL");
            ezc.ezcommon.EzLog4j.log("levelStr="+levelStr, "I");

            if(Integer.parseInt(levelStr) > maxLevel)
                maxLevel=Integer.parseInt(levelStr);

            if(curLevel.equals(levelStr) && Session.getUserId().equals(retWFDet.getFieldValueString(i,"EZWF_USERID"))) {
                docSubmit = true;
                ezc.ezcommon.EzLog4j.log("docSubmit set TRUE", "I");
            }
        }
    }

    if(curLevel.equals(maxLevel+"") && docSubmit) {
        docApprove = true;
        ezc.ezcommon.EzLog4j.log("docApprove set TRUE", "I");
    }
}

ezc.ezcommon.EzLog4j.log("v_UserType="+v_UserType+" docSts="+docSts, "I");

if("4".equals(v_UserType) && "INITIATED".equals(docSts)) {
    vendSubmit = true;
    ezc.ezcommon.EzLog4j.log("vendSubmit TRUE", "I");
}

if("4".equals(v_UserType) && "RESUBMITTED".equals(docSts)) {
    vendReSubmit = true;
    ezc.ezcommon.EzLog4j.log("vendReSubmit TRUE", "I");
}

if("MDCELL".equals(Session.getUserId()) && "APPROVED".equals(docSts)) {
    docPost = true;
    ezc.ezcommon.EzLog4j.log("docPost TRUE", "I");
}

if(vendSubmit || vendReSubmit) {
    isEditable = true;
    ezc.ezcommon.EzLog4j.log("isEditable TRUE", "I");
}

ezc.ezcommon.EzLog4j.log("userRole="+userRole, "I");

if("PP".equals(userRole) || "BY".equals(userRole)) {
    isPPEditable = true;
    ezc.ezcommon.EzLog4j.log("isPPEditable TRUE", "I");
}

session.putValue("QCF_WF_UPDATE","");
ezc.ezcommon.EzLog4j.log("Session QCF_WF_UPDATE set", "I");

String wfStatus="",wfTemplate="",wfNextPart="";
int wfCurStep=0;
boolean showApprove=false;
boolean showSubmit=false;
boolean showReject=false;
boolean showCreate=false;

ReturnObjFromRetrieve retWFDocDetails= ezMiscSelect(Session,"SELECT * FROM EZC_WF_DOC_HISTORY_HEADER WHERE EWDHH_DOC_ID='"+docId+"'");
ezc.ezcommon.EzLog4j.log("retWFDocDetails="+retWFDocDetails, "I");

if(retWFDocDetails != null && retWFDocDetails.getRowCount() > 0) {

    wfStatus=retWFDocDetails.getFieldValueString(0,"EWDHH_WF_STATUS");
    wfCurStep = Integer.parseInt(retWFDocDetails.getFieldValueString(0,"EWDHH_CURRENT_STEP"));
    wfTemplate = retWFDocDetails.getFieldValueString(0,"EWDHH_TEMPLATE_CODE");
    wfNextPart = retWFDocDetails.getFieldValueString(0,"EWDHH_NEXT_PARTICIPANT");

    ezc.ezcommon.EzLog4j.log("wfStatus="+wfStatus+" wfCurStep="+wfCurStep+" wfTemplate="+wfTemplate+" wfNextPart="+wfNextPart, "I");

}
else {
    ezc.ezcommon.EzLog4j.log("No WF history found ? showCreate TRUE", "I");
}

ezc.ezcommon.EzLog4j.log("END JSP execution", "I");
%>