<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import="java.util.*" %>
<%
	String finYear   	= request.getParameter("finYear");
	String startDateStr	= (2000+Integer.parseInt(finYear.substring(3,5)))+"-04-01";
	String endDateStr	= (2000+Integer.parseInt(finYear.substring(6,8)))+"-03-31";

	String plant   		= request.getParameterValues("plant");
	String material   	= request.getParameterValues("material");
	String description   	= request.getParameterValues("description");
	String basicPrice   	= request.getParameterValues("basicPrice");
	String landedPrice   	= request.getParameterValues("landedPrice");
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = null;

	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("INSERT INTO EZC_MAT_BUDGET_PRICE(EMBP_FIN_YEAR,EMBP_PLANT,EMBP_MATERIAL,EMBP_DESCRIPTION,EMBP_BASIC_PRICE,EMBP_LANDED_PRICE,EMBP_FY_START_DATE,EMBP_FY_END_DATE,EMBP_EXT1,EMBP_EXT2) VALUES('"+finYear+"','"+plant+"','"+material+"','"+description+"','"+basicPrice+"','"+landedPrice+"',CONVERT('"+startDateStr+" 01:00',datetime),CONVERT('"+endDateStr+" 23:00',datetime),'','')");		
	miscTable.appendRow(miscTableRow);

	try
	{
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		miscMgr.ezSaveMiscTransactions(mainParams);
	}catch(Exception e){
		out.println("Exception in Updating Audit Header>>>>>"+e);
	}
	
	response.sendRedirect("ezListFYMatBudgetPrice.jsp");
%>