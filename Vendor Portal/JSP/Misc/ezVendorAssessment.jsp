<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<html>
<head>
<title>Vendor Assessment Form</title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>
<Script>


function Download()
{
	
	window.open("ezDownload.jsp","Download","resizable=no,left=0,left=0,top=132,height=0,width=0,status=no,toolbar=no,menubar=no,location=no");
	

}
function Upload()
{
	var name= document.myForm.name
	if(name!=null && name.value!="")
		window.open("ezAttachmentFile.jsp?filestring="+name.value,"UserWindow1","width=450,height=400,left=150,top=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no");
	else
	{
		alert("Please enter your name")
		name.focus();
	}
}
</Script>

<body bgcolor="#FFFFF7" scroll=no>
<form name="myForm">
<center>
	
	<Div id='UserDiv' style='position:relative;align:center;top:1%;width:100%;'>
	<Table width="80%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr height=100px>
	<Td width="5" style="background-color:'F3F3F3'" background="../Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'F3F3F3';font-size:14px" valign=middle align=center>
	<Table width="100%" align="center" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
		<tr>
			<td style="background-color:'F3F3F3'" width="80%" colspan=2>Download VendorAssessment Form by clicking on the Download Form button.</td>
		</tr>
		<tr>
			<th style="background-color:'F3F3F3'" width="25%" align="left">Enter Name :</th>
			<td style="background-color:'F3F3F3'" width="75%" align="left"><input type="text" class=InputBox  name="name"></td>
		</tr>
		<tr>
			<td style="background-color:'F3F3F3'" width="80%" colspan=2>Before Uploading the file(s) please enter your name.</td>
		</tr>
	</Table>
	
	<Td width="5" style="background-color:'F3F3F3'" background="../Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
		</Tr>
		<Tr>
			<Td width="5" style="background-color:'F3F3F3'" height="5" background="../Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../Images/Table_Corners/Cb_c3.gif"></Td>
			<Td height="5" style="background-color:'F3F3F3'" background="../Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../Images/Table_Corners/Cb_e4.gif"></Td>
			<Td width="5" style="background-color:'F3F3F3'" height="5" background="../Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../Images/Table_Corners/Cb_c4.gif"></Td>
		</Tr>
		</Table>
	</Div>
</center>
<div id="ButtonDiv" style="position:absolute;left:20%;top:80%;width:100%;visibility:visible">
	
<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();

		buttonName.add("Download Form");
		buttonMethod.add("Download()");
		
		buttonName.add("Upload");
		buttonMethod.add("Upload()");

		buttonName.add("Close");
		buttonMethod.add("window.close()");
		
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	
</div>	
</form>
</body>
</html>	