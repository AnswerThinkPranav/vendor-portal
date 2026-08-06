
<%@ page import="java.io.*"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<script>
function fileOpen(nam)
{
	window.open("ezFileDownLoad.jsp?name="+nam);
}
</script>
<Html>
<Body>
<Form>
<%
	String display_header	= "User Guide";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<br><br><br><br><br><br>
<Table  width='25%' border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 align=center>
<Tr>
<Th height='40px'>User Guides</Th>
</Tr>
<%
String userType=(String)session.getValue("UserType");
//out.print("user type"+ut);
if(userType.equals("2"))
{
%>
<Tr>
<Td align="center" style='background-color:#c9e0ff' height='40px'><a href="javascript:fileOpen('Greaves_Buyer_UserGuide.doc')">
		<Font size=3 color='BLUE'><B>Buyer</B></Font></a>
</Td>
</Tr>
<%}%>
<Tr>
<Td align="center" height='40px'><a href="javascript:fileOpen('Greaves_Vendor_UserGuide.doc')"><Font size=3 color='BLUE'><B>Vendor</B></Font></a></Td>
</Tr>
</Table>
</Form>
<Div id="MenuSol"></Div> 
</Body>
</Html>       