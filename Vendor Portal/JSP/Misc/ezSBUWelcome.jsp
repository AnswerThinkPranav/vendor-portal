<html>
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" /> 
<%@ page import="ezc.ezmisc.params.*" %>
<%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>
<%//@ include file="../../../Includes/JSPs/VendorReg/itoActVenRegDocs.jsp"%> 
<%
	int retListCnt=0;
	String userType    = (String)session.getValue("UserType"); 
	String sysKey 	 = (String) session.getValue("SYSKEY");
	String soldTo 	 = (String) session.getValue("SOLDTO");
	String userRole    = (String)session.getValue("USERROLE");
		 	
	if(soldTo!=null)
		soldTo = soldTo.trim();
%>
<Head>  
	<title>Coromandel Home Page</title> 
	
	<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<style> 
	#inputDiv
	{
	border:2px solid #a1a1a1;
	padding:10px 40px; 
	background:#ffffff;
	width:700px;
	border-radius:300px;
	position:relative;
	margin-left:300px
	}
</style>

</Head>
<Body bgcolor='#C7D7DE' scroll=no> 
<Form name="myForm">
<%
	if(userRole!=null)
		userRole = userRole.trim();
	String display_header="Message Board"; 
	
	if("SO".equals(userRole) || "QA".equals(userRole) ||"FN".equals(userRole))
		display_header=""; 
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

<%
	if("SO".equals(userRole) || "QA".equals(userRole) ||"FN".equals(userRole))
	{
%>
		<div style="position:absolute;top:26%;left:0%;width:100%;"> 
		<Div id='inputDiv' >
		<table width="100%" height="80%" border="0" cellspacing="0" cellpadding="3" align=center valign=center>
		<tr>
		<td style='background-color:#c9e0ff; text-align: center;'>
			<b><a style="color:#29385d;"><Font size = 2>WELCOME TO MTR VENDOR PORTAL</Font></a></b>
		</td>
		</TR>
		</table>
		</div>
		</div>
 <%
 	}
 	else 
 	{
 %>
		<%@ include file="../../../Includes/JSPs/Purorder/iPOSyncFromSAP.jsp"%>  
		<%@ include file="../../../Includes/JSPs/Rfq/iRFQSync.jsp" %>     
		<%@ include file="../../../Includes/JSPs/Misc/iSBUWelcome.jsp" %>
 
 		<div style="position:absolute;top:26%;left:0%;width:100%;"> 
 		<Div id='inputDiv' >
		<table width="100%" height="15%" border="0" cellspacing="0" cellpadding="3" align=center valign=center>
<%
		if("2".equals(userType))
		{
%>
			<tr>
				<td style='text-align: center; background-color:#ffffff;'>
				<b><Font size = 2>Vendor : </Font>&nbsp;&nbsp;[&nbsp;<%=session.getValue("Vendor")%>&nbsp;]</b>  </td>
				 <td style='background-color:#ffffff;'>
				 <table>                                                 
				 <td valign="top" style='background-color:#ffffff;'>
				</td><td style='background-color:#ffffff;'><b><Font color="BLACK" size = 4>&nbsp; </Font></b></td></tr></table>
				</td>
			</tr>
<%
		}
%>
		
		
		<tr>
			<td style='background-color:#c9e0ff; text-align: center;'>
			<b><a style="color:#29385d;" href="../Purorder/ezListAcknowledgedPOs.jsp?type=NotAcknowledged"><Font size = 2>Purchase Orders to be acknowledged</Font></a>&nbsp;&nbsp;[&nbsp;<%=toBeAckPOsCount%>&nbsp;]
			</b></td>
			 <td style='background-color:#c9e0ff'>
			 <table>
			 <tr>
			 <td valign="top" style='background-color:#c9e0ff;'>
			</td><td style='background-color:#c9e0ff'><b><Font color="BLACK" size = "4">&nbsp; </b></td></tr></table>
			</td>
		</tr>

		<tr>  
			<td style='text-align: center; background-color:#ffffff;'>
			<b><a style="color:#29385d;" href="../Purorder/ezGetContractsList.jsp?FROM=MENU&conType=<%=conStatus%>"><Font size = 2>Contracts to be Signed</Font></a>&nbsp;&nbsp;[&nbsp;<%=toBeSignedCONCount%>&nbsp;]</b>  </td>
			 <td style='background-color:#ffffff;'>
			 <table>                                                 
			 <td valign="top" style='background-color:#ffffff;'>
			</td><td style='background-color:#ffffff;'><b><Font color="BLACK" size = 4>&nbsp; </Font></b></td></tr></table>
			</td>
		</tr>

		<tr>
			<td style='background-color:#c9e0ff; text-align: center;'>
			<b><a style="color:#29385d;" href="../RFQ/ezListRFQs.jsp?type=ToQuote"><Font size = 2>RFQs to be processed</Font></a>&nbsp;&nbsp;[&nbsp;<%=toBeQuotedRFQCount%>&nbsp;]</b>
			</td>
			 <td style='background-color:#c9e0ff'>
			 <table>
			 <tr>
			 <td valign="top" style='background-color:#c9e0ff;'>
			 </td><td style='background-color:#c9e0ff;'><b><Font color="BLACK" size = 4>&nbsp; </Font></b></td></tr></table>
			</td>
		</tr>
<%
		if("2".equals(userType))
		{
%>		
		<tr>
			<td style='background-color:#ffffff; text-align: center;'>
			<b><a style="color:#29385d;" href="../VendorReg/ezVendorStatusReport.jsp"><Font size = 2>To Act Vendor Registration Form(s)</Font></a>&nbsp;&nbsp;[&nbsp;<%=retListCnt%>&nbsp;]</b>
			</td>
			 <td style='background-color:#ffffff'>
			 <table>
			 <tr>
			 <td valign="top" style='background-color:#ffffff;'>
			 </td><td style='background-color:#ffffff;'><b><Font color="BLACK" size = 4>&nbsp; </Font></b></td></tr></table>  
			</td>
		</tr> 
<%

	}
	
%>	
		</table>
		</div>
		</div>  
<%
	}
%>   
<%@ include file="../News/ezNews.jsp"%> 
</Form>
<Div id="MenuSol"></Div>
</Body>
</html>