<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<%//@ page language="java" errorPage="ezErrorDisplay.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iContactInfo_Labels.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ include file="ezGetUserAuthDefaults.jsp"%>  
<%@ include file="ezHeader.jsp"%>
<html>
<head>
	<title>Contact Info</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	
<script>
function funDownloadManual()
{
	//alert("hello");
	document.sbuForm.action = "ezDownloadUsrManual.jsp";
	document.sbuForm.submit();
}
</script>
</head>

<body scroll=no>
<form name="sbuForm">
<%
	String display_header = "Contact Information";
	
%>	
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<div style="position:absolute;top:30%;width:100%;">	
<br>		
	<TABLE align=center style="BORDER-RIGHT: #4374a6 1px solid; BORDER-TOP: #4374a6 1px solid; BORDER-LEFT: #4374a6 1px solid; BORDER-BOTTOM: #4374a6 1px solid" cellSpacing=0 cellPadding=0 width="100%"  height=60% border=0>
		<TR>
			<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
				<img src="../../../../EzCommon/Images/Body/contact_us.jpg" >
			</TD>
			<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
				<TABLE width="100%" align=left cellPadding=0 cellSpacing=0 >
				<tr>
					<TD style="BACKGROUND-COLOR:#FFFFFF">
					</TD>
					<TD style="BACKGROUND-COLOR: #FFFFFF" valign=bottom align=left>
					<br><br><br>
						<!--<Font color=#663300 size=2><B>Any site related queries kindly contact any of the following persons</B></Font> <Br><Br>-->
						<Font color=#663300 size=2><B>Any queries kindly contact  us by using below mail id and telephone number</B></Font> <Br><Br>
						<TABLE  border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
							<tr>
								<th width=25% height='35px'>Name</td>
								<th width=25% height='35px'>EMail Id</td>
								<th width=25% height='35px'>Phone</td>
							</tr>

							<tr>
								<td width=25% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>Helpdesk&nbsp;1&nbsp;</Font></td>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>aphelpdesk@coromandel.murugappa.com&nbsp;&nbsp;</td>
								<td width=20% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>1800 425 5696 &nbsp;&nbsp;</td>
							</tr>
							<!--<tr>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>Helpdesk&nbsp;2&nbsp;</B></Font></td>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>XXX.helpdesk@coromandel.murugappa.com&nbsp;&nbsp;</td>
								<td width=20% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>+91-9999999999&nbsp;&nbsp;</td>
							</tr>-->
							<tr>
								<td width=25% align="Center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>Helpdesk&nbsp2&nbsp;</Font></td>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>aphelpdesksupport1@coromandel.murugappa.com&nbsp;&nbsp;</td>
								<td width=20% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2>1800 425 5696&nbsp;&nbsp;</td>
							</tr>

						</TABLE>
						<br>
						<!--<TABLE align=left  cellPadding=0 cellSpacing=0 >
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left"><font color=green>Visit Us at:</Font></td></tr>
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left"><a href="http://www.coromandel.com" target="new">XXX.helpdesk@coromandel.murugappa.com</a></td></tr>
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left"><a href="http://www.coromandel.com" target="new">aphelpdesksupport1@coromandel.murugappa.com</a></td></tr>
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left">&nbsp;</td></tr>
						</Table>-->
						<TABLE align=left  cellPadding=0 cellSpacing=0 >
						<tr><td style="BACKGROUND-COLOR: #FFFFFF;text-decoration:underline;padding-bottom: .5em" align="Left"><Font color=green><B>SSC Address:</B></Font></td></tr>
						<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Shared Services Center, <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Coromandel International Limited,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ground Floor, Administrative Block,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sriharipuram, Malkapuram Post<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Visakhapatnam, A.P. - 530011</td></tr>
						<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left">&nbsp;</td></tr>
						</Table>
									
					</TD>
				</tr>
							
				
			</td>	
			<!--<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
				&nbsp;
			</TD>-->
			
		</TR>
		</table>
		<TABLE align=left  cellPadding=0 cellSpacing=0 >
			<tr>
				<td style="BACKGROUND-COLOR: #FFFFFF;text-decoration:underline;padding-bottom: .5em" align="Left"><Font color=green><B>Download vendor portal user manual based on user.</B></Font></td>
			</tr>

			<tr>
				<td style="text-decoration:underline">1.&nbsp;<a href="ezDownloadUsrManual.jsp" target="_self">Distribution vendors</a></td>
			</tr>
			<tr>
				<td style="text-decoration:underline">2.&nbsp;<a href="ezDownloadUsrManual.jsp" target="_self">Loading/ unloading vendors</a></td>
			</tr>
			<tr>
				<td style="text-decoration:underline">3.&nbsp;<a href="ezDownloadUsrManual.jsp" target="_self">Other vendors</a></td>
			</tr>
			<tr>
				<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
								&nbsp;
			</TD>
			</tr>
			<tr>
							<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
											&nbsp;
						</TD>
			</tr>
												
		</Table>
		
		
</TABLE><Br> 
<!--<center>
	<button type="button" class="btn btn-primary" data-toggle="tooltip" data-placement="bottom" title="Click Here to Download User Manual" onclick="funDownloadManual()">All Vendors</button>  &nbsp;
	<button type="button" class="btn btn-primary" data-toggle="tooltip" data-placement="bottom" title="Click Here to Download User Manual" onclick="funDownloadManual()">Distribution Vendors</button>  &nbsp;
	<button type="button" class="btn btn-primary" data-toggle="tooltip" data-placement="bottom" title="Click Here to Download User Manual" onclick="funDownloadManual()">Loading/Unloading Vendors</button>  &nbsp;
</cenetr>-->

</div>
<input type="hidden" name="userType" value="<%=v_UserType%>"/>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>