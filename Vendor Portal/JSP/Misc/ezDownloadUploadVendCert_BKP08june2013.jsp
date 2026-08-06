<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>

<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%
	site=null;
	String certPath = "";
	try
	{
		site = ResourceBundle.getBundle("Site");
		certPath = site.getString("CERTIFICATEPATH");
	}
	catch(Exception e)
	{}

	String soldTo=(String)session.getAttribute("SOLDTO");
	
	String filePathTHC = certPath+"THC\\";
	String filePath = certPath+"DC\\";
%>
<HTML>
<head>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<Script>
function validationsTHC()
	{		
		window.showModalDialog("../Inbox/ezConfirmTHC.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
				
		/*window.open('../Inbox/ezConfirmTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');
		var confirmTHC = confirm("Kindly check if the certificate is already uploaded to avoid the duplication");
		if(confirmTHC==true)
		{
			alert("Please do not change the name of document while uploading");
			window.open('../Inbox/ezAttachFileTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');
		}
		else
		{
			return false;
		}*/
	}
function validationsDC()
	{
		window.showModalDialog("../Inbox/ezConfirmDC.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
		//window.open('../Inbox/ezConfirmDC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');
	}	
</Script>
</head>
<BODY scroll="no">
<Form name="myForm"  method="POST">
<div style="position:absolute;top:0%;left:0%;width:75%;">
	<table align=left border="0" cellpadding="0"  cellspacing="0"  width="400px">
		<tr>
			<td height="35" align=left width="400px" style="filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=1,StartColorStr='#f34700',EndColorStr='#ffffff');"><font size="3" color="black"><b>Certificates</b></font></td> 
		</tr>
	</table>
</div>
<div style="position:absolute;top:16%;left:0%;width:100%;">
	<Table width="40%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
			<th align="center" width="12%" height='40px'>	Tool Holding Certificate	</th>			
			<th align="center" width="12%" height='40px'>8 D Certificate</th>
		</tr>
		<Tr>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadDC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
		</Tr>
		<Tr>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsTHC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
			</Td>

			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadDC" onClick=validationsDC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>				
		</Tr>
		<Tr >
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedDC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
		</Tr>
	</Table>
</Div>
<Div id="MenuSol"></Div>
</Form>
</body>
</html>