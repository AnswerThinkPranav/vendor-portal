<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
	String rfqNo= request.getParameter("rfqNo");
	String closeDate= request.getParameter("closeDate");

	ezc.ezcommon.EzLog4j.log(rfqNo+"::rfqNo:::closeDate:::::"+closeDate,"I");

	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 	
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("UPDATE EZC_RFQ_HEADER SET ERH_VALID_UPTO=STR_TO_DATE('"+closeDate+"','%d/%m/%Y')  WHERE ERH_RFQ_NO='"+rfqNo+"'");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		miscMgr.ezSaveMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::::Error Occured While u[pdating rfq close date:::::"+e,"I");
	}	
	

%>