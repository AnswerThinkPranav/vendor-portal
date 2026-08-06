<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<html> 
<head>
<%@ include file="../Misc/ezHeader.jsp"%> 
<script>
	function checkList()
	{
		location.href="../Misc/ezBuyerWelcome.jsp";
	}
</script>
</head>
<%

	String rfqAuth = "N";
	String regAuth = "N"; 
	
	String tempUserId=request.getParameter("userId");
	
	if("Y".equals(request.getParameter("RFQ")))
		rfqAuth = "Y";
	ezc.ezcommon.EzLog4j.log("rfqAuth in update>>>>"+rfqAuth,"I");

	if("Y".equals(request.getParameter("VENREG")))	
		regAuth = "Y";
	ezc.ezcommon.EzLog4j.log("regAuth in update>>>>"+regAuth,"I");	
			
	ezc.misctransactions.client.EzMiscTransactionsManager gv_miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable gv_miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow gv_miscTableRow = null;

	gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	gv_miscTableRow.setQuery("UPDATE EZC_USER_DEFAULTS SET EUD_VALUE='"+rfqAuth+"' WHERE EUD_USER_ID='"+tempUserId+"' AND EUD_KEY='ALLOW_RFQ'");
	gv_miscTable.appendRow(gv_miscTableRow);

	gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	gv_miscTableRow.setQuery("UPDATE EZC_USER_DEFAULTS SET EUD_VALUE='"+regAuth+"' WHERE EUD_USER_ID='"+tempUserId+"' AND EUD_KEY='ALLOW_REG'");
	gv_miscTable.appendRow(gv_miscTableRow);	

	ezc.ezparam.EzcParams ezcContainer = new ezc.ezparam.EzcParams(false); 
	ezcContainer.setLocalStore("Y");
	ezcContainer.setObject(gv_miscTable);
	Session.prepareParams(ezcContainer);
	try
	{
		gv_miscMgr.ezSaveMiscTransactions(ezcContainer);	
	}
	catch(Exception e)
	{
		out.println("Exception in SAP Vendor update>>>>>"+e);
	}		
	
	String display_header = "Confirmation"; 
	
%>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<center> 

	<div class="alert alert-success" style="width:30%">
	<h4><i class="icon fa fa-check"></i>Success</h4>
	Vendor details updated successfully
	</div>
</center>
<Br><Br><Br>

<center>
	<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	
</center>
<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 



