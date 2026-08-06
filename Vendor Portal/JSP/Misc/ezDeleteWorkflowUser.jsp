<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />

<%
	String userId = request.getParameter("userId");
	String plant = request.getParameter("plant");
	String category = request.getParameter("category");
	String wfValue = plant + "#" + category;
	
	//ezc.ezcommon.EzLog4j.log("userId>>>>>>" + userId,"E");
	//ezc.ezcommon.EzLog4j.log("plant>>>>>>" + plant,"E");
	//ezc.ezcommon.EzLog4j.log("category>>>>>>" + category,"E");
	//ezc.ezcommon.EzLog4j.log("wfValue>>>>>>" + wfValue,"E");

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	String deleteUserInWFQuery = "DELETE FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_USER_ID='"+ userId +"' AND EUDKV_VALUE='"+ wfValue +"'";
	//ezc.ezcommon.EzLog4j.log("deleteUserInWFQuery>>>>>>" + deleteUserInWFQuery,"E");
	miscTableRow.setQuery(deleteUserInWFQuery);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		miscMgr.ezSaveMiscTransactions(mainParams);
		out.print("SUCCESS");
		//ezc.ezcommon.EzLog4j.log("INside delete try:::::::::::::::::;","E");
	}
	catch(Exception e)
	{
		out.print("ERROR");
	}

	
%>