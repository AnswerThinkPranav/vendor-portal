<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<%//@ page language="java" errorPage="ezErrorDisplay.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iContactInfo_Labels.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<html>
<head>
	<title>Contact Info</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>

<body scroll=no>
<form name="sbuForm">
<%
	String display_header = "Contact Information";
	
%>	
<div style="position:absolute;top:0%;left:0%;width:75%;">  
<%@ include file="ezDisplayHeader.jsp"%>
</div>
<div style="position:absolute;top:9%;left:0%;width:100%;">	
<br>		
	<TABLE align=center style="BORDER-RIGHT: #4374a6 1px solid; BORDER-TOP: #4374a6 1px solid; BORDER-LEFT: #4374a6 1px solid; BORDER-BOTTOM: #4374a6 1px solid" cellSpacing=0 cellPadding=0 width="80%"  height=60% border=0>
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
						<Font color=#663300 size=2><B>Any site related queries kindly contact any of the following persons</B></Font> <Br><Br>
						<TABLE  border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
							<tr>
								<th width=25% height='35px'>Name</td>
								<th width=25% height='35px'>EMail Id</td>
								<th width=25% height='35px'>Phone</td>
							</tr>

							<tr>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>&nbsp;</B></Font></td>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>&nbsp;&nbsp;</td>
								<td width=20% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#660033 size=2><B>&nbsp;&nbsp;</td>
							</tr>
							<tr>
								<td width=25% align="left" style='background-color:#c9e0ff' height='35px'><Font color=#006666 size=2><B>&nbsp; </td>
								<td width=25% align="left" style='background-color:#c9e0ff' height='35px'><Font color=#006666 size=2><B>&nbsp;&nbsp;</td>
								<td width=20% align="center" style='background-color:#c9e0ff' height='35px'><Font color=#006666 size=2><B>&nbsp;&nbsp;</td>
							</tr>

							<tr>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#FF0033 size=2><B>&nbsp; </td>
								<td width=25% align="left" style=style='background-color:#c9e0ff' height='35px'><Font color=#FF0033 size=2><B>&nbsp;&nbsp;</td>
								<td width=20% align="center" style=style='background-color:#c9e0ff' height='35px'><Font color=#FF0033 size=2><B>&nbsp;&nbsp;</td>
							</tr>
						</TABLE>
						<br><br><br><br>
						<TABLE align=left  cellPadding=0 cellSpacing=0 >
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left"><font color=green>Visit Us at:</Font></td></tr>
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left"><a href="http://www.mtrfoods.com" target="new">www.mtrfoods.com</a></td></tr>
							<tr><td style="BACKGROUND-COLOR: #FFFFFF" align="Left">&nbsp;</td></tr>
						</Table>
									
					</TD>
				</tr>
							
				</table>
			</td>	
			<TD style="BACKGROUND-COLOR: #FFFFFF"  align=left >
				&nbsp;
			</TD>
		</TR>
</TABLE>
</div>
<Div id="MenuSol">
</Div>

</form>

</body>
</html>