<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%
	String type = request.getParameter("type"); 
	String venType = request.getParameter("venType");	

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	qryRFQ="SELECT ECFH_SAP_CODE,ECFH_DOC_ID,ECFH_CUST_NAME,ECFH_SALES_ORG,ECFH_CREATED_BY,ECFH_EXT1,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_CUSTOMER_FORM_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ECFH_DOC_ID=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID  AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE CONCAT(A.ECFH_PLANT,'#',A.ECFH_CATEGORY) IN ('"+gv_CategoriesForQry+"') AND A.ECFH_VEN_TYPE IN ('"+venType+"')"+qryStr;
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	int Count=0;
	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		Count = hdrXML.getRowCount();
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
%>

