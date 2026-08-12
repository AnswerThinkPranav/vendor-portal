<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%!  
	public String checkNull(String value)   
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<%
	String type = request.getParameter("type"); 

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	if(type.equalsIgnoreCase("ALL"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED','APPROVED')";
	else if(type.equalsIgnoreCase("Act"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED') AND  B.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')";
	else if(type.equalsIgnoreCase("Apr"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED')";
	else if(type.equalsIgnoreCase("Rej"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('REJECTED')";	

	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	//qryRFQ="SELECT * FROM EZC_AUCTION_HEADER A,EZC_WF_DOC_HISTORY_HEADER B WHERE A.EAH_AUCTION_ID=B.EWDHH_DOC_ID AND A.EAH_PLANT IN ('"+gv_PlantForQry+"') AND A.EAH_CATEGORY IN ('"+gv_CategoriesForQry+"') "+qryStr;
	qryRFQ="SELECT  FROM EZC_AUCTION_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.EAH_AUCTION_ID=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID AND TRIM(EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PLANT' AND EUDKV_VALUE IN ('"+gv_PlantForQry+"')) AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE A.EAH_PLANT IN ('"+gv_PlantForQry+"') AND A.EAH_CATEGORY IN ('"+gv_CategoriesForQry+"') "+qryStr;

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

