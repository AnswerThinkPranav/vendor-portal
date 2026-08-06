<html>
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script>
function ezHref(event)
{
	
	document.location.href = event
	
}
function funConditions()
{
	var protocol = document.location.protocol;
	var printWD = protocol+"//<%=request.getServerName()%>/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/Misc/Vendor NEFT request.doc";
	//http://<%=request.getServerName()%>/j2ee/EzCommerce/EzSales/Sales2/JSPs/Misc/Service.doc
	document.myForm.action=printWD;
	document.myForm.submit();	
}
</script>
</head>
<body>
<form  method="post" name="myForm" target="_parent">
<%
	String display_header="Download NEFT Request Form";
%>
	<%@ include file="ezDisplayHeader.jsp"%>
<Div style='position:absolute;background-color:#FFFFFF;top:40%;width:80%;height="9%";align:center;left:12%' align=center>
	<Table width="60%" height="100%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>

		<Tr>
			<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
			<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
			<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
		</Tr>
		<Tr>
			<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
			<Td align='center'>

				<a href="javascript:funConditions()" ><font size='2' color = 'Blue' align=center>Download the ' Vendor NEFT request.doc'</font></a>

			</Td>
			<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
		</Tr>

		 <Tr>
			<Td width ="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
			<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
			<Td width ="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
		</Tr>		
	</Table>	
</Div>

<Div id="ButtonDiv" style="position:absolute;top:70%;width:100%">
	
	<center>
	<%

			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Back");
			buttonMethod.add("ezHref(\"../Misc/ezSBUWelcome.jsp\")");


			out.println(getButtonStr(buttonName,buttonMethod));
	%>
	</center>
</Div>	
	
<Div id="MenuSol"></Div>
</form>
</body>
</html>
