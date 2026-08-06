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
	if(type.equalsIgnoreCase("ALL"))
		qryStr+="AND ECFH_STATUS IN ('INITIATED','RESUBMITTED')";
	else if(type.equalsIgnoreCase("Reg"))
		qryStr+="AND ECFH_STATUS IN ('INITIATED')";
	else if(type.equalsIgnoreCase("Res"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('RESUBMITTED')";		
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND ECFH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i') ";			
		
	qryRFQ="SELECT ECFH_DOC_ID,ECFH_CUST_NAME,ECFH_SALES_ORG,ECFH_EXT1,ECFH_CREATED_BY,ECFH_CREATED_ON,ECFH_MODIFIED_ON,ECFH_STATUS FROM  EZC_CUSTOMER_FORM_HEADER WHERE ECFH_CREATED_BY IN('"+Session.getUserId()+"')  AND ECFH_VEN_TYPE IN ('"+venType+"')" +qryStr +"ORDER BY ECFH_DOC_ID DESC" ;
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

