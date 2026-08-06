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
	ezc.ezparam.ReturnObjFromRetrieve retWebStats	  =	null; 
	
	if(type.equalsIgnoreCase("ALL"))
		qryStr+=" AND EU_TYPE IN ('2','3','4')";
	if(type.equalsIgnoreCase("INU"))
		qryStr+=" AND EU_TYPE IN ('2')";		
	if(type.equalsIgnoreCase("EXT"))
		qryStr+=" AND EU_TYPE IN ('3','4')";				
	

	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND EWS_LOGGED_IN BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i') ORDER BY EWS_LOGGED_IN DESC";			
		
	qryRFQ="SELECT EWS_USER_ID, EU_FIRST_NAME ,EU_MIDDLE_INITIAL ,EU_LAST_NAME ,EWS_SYSKEY, EWS_IP ,EWS_LOGGED_IN ,EWS_LOGGED_OUT FROM EZC_USERS A, EZC_WEB_STATS B WHERE A.EU_ID=B.EWS_USER_ID" +qryStr;
	
	
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	int Count=0;
	try
	{
		retWebStats=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	if(retWebStats!=null)
	{
		Count = retWebStats.getRowCount();
		retWebStats.sort(new String[]{"EWS_LOGGED_IN"},true);
	}
	//ezc.ezcommon.EzLog4j.log("retWebStats>>"+retWebStats.toEzcString(),"I");	
	
%>

