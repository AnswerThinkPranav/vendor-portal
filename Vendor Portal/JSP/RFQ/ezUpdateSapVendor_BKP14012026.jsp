<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%

	String qcfNo = request.getParameter("qcfNo");
	String rfqNo = request.getParameter("rfqNo");
	String vendor = request.getParameter("vendor");	
	String sapVend =request.getParameter("sapVend");
	
	//out.println("qcfNo>>"+qcfNo);
	//out.println("rfqNo>>"+rfqNo);
	//out.println("vendor>>"+vendor);
	//out.println("sapVend>>"+sapVend);
	
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
			
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qryRfq = "UPDATE EZC_RFQ_HEADER SET ERH_SOLD_TO='"+sapVend+"' WHERE ERH_RFQ_NO='"+rfqNo+"' AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"' AND ERH_SOLD_TO='"+vendor+"'";
	ezc.ezcommon.EzLog4j.log("****=qryRfq in update Vendor**"+qryRfq,"I");
	miscTableRow1.setQuery(qryRfq);
	
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);

	try
	{
		miscMgr1.ezSaveMiscTransactions(mainParams1);

	}
	catch(Exception e)
	{
		out.println("Exception in SAP Vendor update>>>>>"+e);
	}
	
	
%>
<body>
<form name="myForm">
<DIV align="center" style="position:absolute;width:100%;top:30%">
<Table align="center" border=0 style="width:80%" borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
	<Tr>
		<Th><BR>&nbsp;Vendor updated Successfully<BR>&nbsp;</Th>
	</Tr>
</Table>
</Div>	
<DIV style="position:absolute;width:100%;top:80%">
<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="closeWindow()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</Div>
<Div id="MenuSol">
</Div>
</form>
</body>
</html>
<Script>
	
	function closeWindow()
	{
		parent.document.myForm.submit();
		window.close();
	}

</Script>



