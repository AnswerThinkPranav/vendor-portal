<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ page import ="ezc.ezparam.*,java.util.*" %>
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<%@ page import ="ezc.ezparam.*,java.util.*"%>
<%
	String finYear 	= request.getParameter("finYear").trim();
	String material = request.getParameter("material").trim();
	String plant 	= request.getParameter("plant").trim();
	String actFlag 	= request.getParameter("actFlag").trim();
	String month 	= request.getParameter("month").trim();
	String success	= "Y";
		
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		
	String qry = "";
	
	if("ADD".equals(actFlag))
	{
		//miscTableRow.setQuery("INSERT INTO EZC_VALUE_MAPPING(MAP_TYPE,VALUE1,VALUE2) VALUES('"+mapType+"','"+bidTxt+"','"+bidTxt+"')");
		//miscTable.appendRow(miscTableRow);
	}
	if("DEL".equals(actFlag))
	{
		qry = "DELETE FROM EZC_MAT_BUDGET_PRICE WHERE EMBP_FIN_YEAR='"+finYear+"' AND EMBP_MONTH = '"+month+"' AND EMBP_PLANT='"+plant+"' AND EMBP_MATERIAL='"+material+"' ";
		
		miscTableRow.setQuery(qry);
		miscTable.appendRow(miscTableRow);	
	}
	if("UPD".equals(actFlag))
	{
		ezc.ezcommon.EzLog4j.log("finYear:::"+finYear,"I");
		ezc.ezcommon.EzLog4j.log("material:::"+material,"I");
		ezc.ezcommon.EzLog4j.log("plant:::"+plant,"I");
		
		String basicPrice 	= request.getParameter("basePrice").trim();
		String landPrice 	= request.getParameter("landPrice").trim();
		
		ezc.ezcommon.EzLog4j.log("basicPrice:::"+basicPrice,"I");
		ezc.ezcommon.EzLog4j.log("landPrice:::"+landPrice,"I");

		qry = "UPDATE EZC_MAT_BUDGET_PRICE SET EMBP_BASIC_PRICE='"+basicPrice+"', EMBP_LANDED_PRICE='"+landPrice+"' WHERE EMBP_FIN_YEAR='"+finYear+"' AND EMBP_MONTH = '"+month+"' AND EMBP_PLANT='"+plant+"' AND EMBP_MATERIAL='"+material+"' ";
		
		miscTableRow.setQuery(qry);
		miscTable.appendRow(miscTableRow);
	}
	
	try
	{
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		miscMgr.ezSaveMiscTransactions(mainParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Exception in Updating Material Budget >>>>>"+e,"E");
		success	= "N";
	}
	
	out.println(success);
%>