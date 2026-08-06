<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>

<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<HTML>
<head>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<Script>
function validationsCert(type)
{		
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType="+type,'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
/*function validationsTHC()
{		
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=THC",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsDC()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=DC",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsISO()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=ISO",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsTS()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=TS",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsEMS()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=EMS",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsOHSH()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=OHSH",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsDOL()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=DOL",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsAward()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=Award",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsCF()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=CF",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsVA()
{
	window.showModalDialog("../Inbox/ezConfirmCert.jsp?folderType=VA",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}*/

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

<div style="position:absolute;top:20%;left:0%;width:100%;visibility:visible;">
	<Table width="99%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
			<th align="center" width="11%" height='40px'>Tool Holding Certificate</th>			
			<th align="center" width="11%" height='40px'>8 D Certificate</th>
			<th align="center" width="11%" height='40px'>ISO Certificate</th>
			<th align="center" width="11%" height='40px'>TS Certificate</th>
			<th align="center" width="11%" height='40px'>EMS Certificate</th>
			<th align="center" width="11%" height='40px'>OHSH Certificate</th>
			<th align="center" width="11%" height='40px'>DOL Certificate</th>
			<th align="center" width="11%" height='40px'>Award Certificate</th>
			<th align="center" width="11%" height='40px'>C Forms Certificate</th>
			<th align="center" width="11%" height='40px'>Vendor Assessment</th>
		</tr>
		<!--<Tr>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadDC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadISO.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadTS.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadEMS.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadOHSH.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadDOL.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadAward.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadCF.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadVendorAssessment.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
			</Td>
		</Tr>-->
		<Tr >
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=THC','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=DC','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=ISO','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=TS','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=EMS','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=OHSH','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=DOL','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=Award','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=CF','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=VA','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<IMG src="../../Images/down.png" width=100 height=25 border=none>
				</a>	
			</Td>			
		</Tr>
		<Tr>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsCert("THC")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
			</Td>

			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadDC" onClick=validationsCert("DC")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>				
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadISO" onClick=validationsCert("ISO")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadTS" onClick=validationsCert("TS")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadEMS" onClick=validationsCert("EMS")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadOHSH" onClick=validationsCert("OHSH")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadDOL" onClick=validationsCert("DOL")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadAward" onClick=validationsCert("Award")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadCF" onClick=validationsCert("CF")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadCF" onClick=validationsCert("VA")><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>			
			
		</Tr>
		<Tr >
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=THC','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=DC','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=ISO','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=TS','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=EMS','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=OHSH','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=DOL','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=Award','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=CF','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCert.jsp?folderType=VA','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
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