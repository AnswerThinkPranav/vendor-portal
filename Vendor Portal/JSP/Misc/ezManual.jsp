<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*,java.util.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
function VendorManual()
{

	window.open("/j2ee/DRL_Vendor_UserGuide.doc","newWin","titlebar=yes")
}
function BuyerManual()
{

	window.open("/j2ee/DRL_Buyer_UserGuide.doc","newWin","titlebar=yes")
}
</script>
<body  scroll=no>
<form name="myForm">
<%
	String display_header	= "Download Manual";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<center>
	<table width="40%">
	<tr><td><b></b></td>
	<tr><td class="blankcell"><br></td>
	<tr><td class="blankcell">Download the file by clicking on it.</td>
	</tr></table>
	<table width="40%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
	<th colspan=3 align="left">Download Manual</th>
	</tr>
	<%
		String userType = (String)session.getValue("UserType");
		if(userType.equals("2"))
		{	
	%>
	<tr>
	<td align="center"><a href="JavaScript:void(0)" onClick="BuyerManual()">Buyer Manual</a>&nbsp;</td>
	</tr>
	<%
	}
	%>
	<tr>
		<td align="center"><a href="JavaScript:void(0)" onClick="VendorManual()">Vendor Manual</a>&nbsp;</td>
	</tr>
	</table>
	</center>
<Div align='center' style='position:absolute;top:88%'>
		<Table align="center" width="100%" >
			<Tr align="center">
				<Td class=blankcell>
	<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Back");
		buttonMethod.add("history.go(-1)");
		
		out.println(getButtonStr(buttonName,buttonMethod));
	%>			
				</Td>
			</Tr>
		</Table>
</Div>	
</form>
<Div id="MenuSol"></Div>
</body>
</html>	