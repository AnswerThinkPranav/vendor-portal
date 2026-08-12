<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import = "ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezpreprocurement.client.EzPreProcurementManager" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String collRfq = request.getParameter("QcfNumber");
	EzPreProcurementManager manager = new EzPreProcurementManager();
	EzcParams mainParams = new EzcParams(false);
	mainParams.setLocalStore("Y");
	EziRFQHeaderParams params = new EziRFQHeaderParams();
	params.setExt1("RFQ");
	params.setCollectiveRFQNo(collRfq);
	params.setStatus("Y','R");
	mainParams.setObject(params);
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve ret = (ReturnObjFromRetrieve)manager.ezGetRFQList(mainParams);	
	int rowCount = ret.getRowCount();
%>
<html>
<head>
<Script>
var tabHeadWidth=70
var tabHeight="60%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/Misc/ezHideButtons.js"></script>
<title>List of RFqs</title>
<Script>
	function funBack()
	{
	
		document.myForm.action="ezListQCS.jsp?status=CR";
		document.myForm.submit();
	}
	function reQuote()
	{
		var flag=false
		var len = document.myForm.chk1.length
		if(isNaN(len))
		{
			if(document.myForm.chk1.checked)
				flag = true
		}
		else
		{
			for(var k=0;k<len;k++)
			{
				if(document.myForm.chk1[k].checked)
					flag = true
			}
		}
		if(flag)
		{
			hideButton();
			document.myForm.action="ezCounterOffer.jsp";
			document.myForm.submit();
		}
		else
		{
			alert("Please select atleast one RFQ for Re-Quote")
		}
	}
</Script>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>
<body  onLoad="scrollInit()" onResize="scrollInit()" scroll=no>
<form name="myForm" method="post">
<%
	String display_header = "List of RFQs";
%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
	if(rowCount==0)
	{
%>
		<br><br><br><br><br>
		<TABLE width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0 >
		<Tr>
			<Th>No RFQs Quoted to List</th>
		</Tr>
		</Table>
		<br>
		<Center>
    <%
		buttonName.add("Back");
		buttonMethod.add("history.go(-1)");
		out.println(getButtonStr(buttonName,buttonMethod));
    %>
</Center>
<%
	}
	else
	{
%>	
	<br><br>	
	<DIV id="theads">
	<Table id="tabHead" width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0 >
	<Tr align="center" valign="middle">
		<Th width="10%">&nbsp;</Th>
		<Th width="45%">RFQ No</Th>
	 	<Th width="45%">Vendor</Th>
	 </Tr>
	</Table>
	</DIV>
	
	<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:70%;height:60%;left:2%">
	<TABLE id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0 >
<%
	for(int i=0;i<rowCount;i++)
	{
%>
		<Tr>
			<Td width="10%"><Input type=checkbox name=chk1 value="<%=ret.getFieldValueString(i,"RFQ_NO")%>¥<%=ret.getFieldValueString(i,"SOLD_TO")%>¥<%=collRfq%>"></Td>
			<Td width="45%"><%=ret.getFieldValueString(i,"RFQ_NO")%></Td>
			<Td width="45%"><%=ret.getFieldValueString(i,"SOLD_TO_NAME")%></Td>
		</Tr>
<%
	}
%>
	</Table>
	</Div>
	
	
	
	
	
	<Div id="image" align="center" style='Position:Absolute;visibility:visible;Left:10%;WIDTH:80%;height:70%;Top:85%'>
		<Table align="center">
			<tr align="center">
				<td class=blankcell align="center">
				<span id="EzButtonsSpan" >
	<%
				buttonName = new ArrayList();
				buttonMethod = new ArrayList();
	
				buttonName.add("Back");
				buttonMethod.add("funBack()");
				
				buttonName.add("Requote");
				buttonMethod.add("reQuote()");
	
				out.println(getButtonStr(buttonName,buttonMethod));
	%>
				</span>
				<span id="EzButtonsMsgSpan" style="display:none">
				<Table align=center>
				<Tr>
					<Td >Your request is being processed... Please wait</Td>
				</Tr>
				</Table>
				</span>
			</Td>
			</Tr>
		</Table>
	</Div>
	
	

		

<%
	}

%>
</form>
<Div id="MenuSol"></Div>
</body>
</html>
