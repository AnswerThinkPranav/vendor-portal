<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*,java.util.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>

function SupplierCodeofConduct()
{

	window.open("/j2ee/Supplier_CodeofConduct.pdf","newWin","titlebar=yes")
}
</script>
<body  scroll=no>
<form name="myForm">
<%
	String display_header	= "Supplier Code of Conduct";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<center>
	<br><br>
	<table width="40%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
	<th colspan=3 align="left">Click on below link to see the Supplier Code of Conduct </th>
	</tr>
	<%
		//String userType = (String)session.getValue("UserType");
		
		//if(userType.equals("3"))
		//{	
	%>
	<tr>
	<td align="center"><a href="JavaScript:void(0)" onClick="SupplierCodeofConduct()">Supplier Code of Conduct</a>&nbsp;</td>
	</tr>
	<%
	//}
	%>
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