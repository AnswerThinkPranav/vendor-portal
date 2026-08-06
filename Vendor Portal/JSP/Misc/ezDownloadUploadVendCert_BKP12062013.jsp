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
function validationsTHC()
{		
	window.showModalDialog("../Inbox/ezConfirmTHC.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsDC()
{
	window.showModalDialog("../Inbox/ezConfirmDC.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsISO()
{
	window.showModalDialog("../Inbox/ezConfirmISO.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsTS()
{
	window.showModalDialog("../Inbox/ezConfirmTS.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsEMS()
{
	window.showModalDialog("../Inbox/ezConfirmEMS.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsOHSH()
{
	window.showModalDialog("../Inbox/ezConfirmOHSH.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsDOL()
{
	window.showModalDialog("../Inbox/ezConfirmDOL.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsAward()
{
	window.showModalDialog("../Inbox/ezConfirmAward.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function validationsCF()
{
	window.showModalDialog("../Inbox/ezConfirmCF.jsp",'','unadorned:yes;resizable:1;dialogHeight:60px;dialogwidth:600px;scroll:no;status=no');
}
function funChange(valCert)
{
	var divVisibility = "DIV"+valCert.value;

	for(i=1;i<=9;i++)
	{
		var divVisibility = "DIV"+i;
		
		if(i==valCert.value)
		{
			document.getElementById(divVisibility).style.visibility ="visible";
			document.getElementById("DefaultDIV").style.visibility ="hidden";
			continue;
		}
		else
		{
			document.getElementById(divVisibility).style.visibility ="hidden";
		}
	}
	if(valCert.value=='')
	{
		document.getElementById("DefaultDIV").style.visibility ="visible";
	}
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

<div style="position:absolute;top:15%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
			<th align="center" width="8%" height='40px'>Certificate Type</th>			
			<td align="center" width="10%" height='40px'>
				<select name="selCert" onChange="funChange(this)" style="width:80%">
					<option value="" >---->  Select Certificate  <-----   </option> 
					<option value="1">Tool Holding Certificate</option>
					<option value="2">8 D Certificate</option>
					<option value="3">ISO   Certificate</option>
					<option value="4">TS    Certificate</option>
					<option value="5">EMS   Certificate</option>
					<option value="6">OHSH  Certificate</option>
					<option value="7">DOL   Certificate</option>
					<option value="8">Award Certificate</option>
					<option value="9">C Forms Certificate</option> 
				</select> 
			</td>
		</tr>
	</Table>
</Div>
<Div id="DefaultDIV" style="position:absolute;left:20%;top:40%;width:60%;visibility:hidden;">
<Table align=center width="100%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>	
	<tr>
		<th align="center" width="12%" height='40px' colspan=2>Please select a Certificate type</th>			
	</tr>
</Table>
</Div>
<Div id="DIV1" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	Tool Holding Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadTHC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsTHC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedTHC.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV2" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	8 D Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadDC.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsDC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedDC.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV3" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	ISO Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadISO.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsISO()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedISO.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV4" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	TS Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadTS.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsTS()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedTS.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV5" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	EMS Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadEMS.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsEMS()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedEMS.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV6" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	OHSH Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadOHSH.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsOHSH()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedOHSH.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV7" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	DOL Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadDOL.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsDOL()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedDOL.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV8" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	Award Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadAward.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsAward()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedAward.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<Div id="DIV9" style="position:absolute;top:40%;left:0%;width:100%;visibility:hidden;">
	<Table width="50%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<tr>
		<th align="center" width="11%" height='40px'>	C Forms Certificate	</th>
	<tr>
	</tr>		
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezFileDownloadCF.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=yes');"  onMouseout="window.status=' '; return true"><IMG src="../../Images/down.png" width=100 height=25 border=none></a>
		</Td>
	<tr>
	</tr>	
		<Td align="center" style='background-color:#c9e0ff'  height='40px'>
			<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsCF()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
		</Td>
	</tr>	
	<tr>
		<Td align="center"  height='40px'>
			<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCF.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
				<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
			</a>	
		</Td>
	</tr>
	</Table>
</Div>
<div style="position:absolute;top:20%;left:0%;width:100%;visibility:visible;">
	<Table width="95%" align=center   borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
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
		</tr>
		<Tr>
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
		</Tr>
		<Tr>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadTHC" onClick=validationsTHC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a> 
			</Td>

			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadDC" onClick=validationsDC()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>				
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadISO" onClick=validationsISO()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadTS" onClick=validationsTS()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadEMS" onClick=validationsEMS()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadOHSH" onClick=validationsOHSH()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadDOL" onClick=validationsDOL()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadAward" onClick=validationsAward()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			<Td align="center" style='background-color:#c9e0ff'  height='40px'>
				<a href="Javascript:void(0)" name="uploadCF" onClick=validationsCF()><IMG src="../../Images/upload.png" width=100 height=25 border=none></a>
			</Td>
			
		</Tr>
		<Tr >
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedTHC.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates</B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedDC.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedISO.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedTS.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedEMS.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedOHSH.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedDOL.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedAward.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
					<font size=2 color='#FF3300'><B>List of Uploaded Certificates </B></font>
				</a>	
			</Td>
			<Td align="center"  height='40px'>
				<a href="Javascript:void(0)" onClick="window.open('../Inbox/ezListUploadedCF.jsp','popuppage','left=510,top=180,width=600,height=400,statusbar=yes');"  onMouseout="window.status=' '; return true">
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