<%@ page import ="java.util.*,ezc.ezutil.*,java.text.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*" %>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

	String display_header = "RFQ Mass Creation";
	String downloadStatus = request.getParameter("downloadStatus");
	
%>

<html>
<head >
<title>RFQ Mass Creation-- Powered By EzCommerce India</title>
<Script>

function funLoad()
{
	if("Y"!="<%=downloadStatus%>")
	{
		document.myForm.action="ezRQFMassDownload.jsp";
		document.myForm.submit();
	}	
}
function funUpload()
{
	var filePath=document.myForm.path.value;
	if(filePath=="")
	{
		alert("Please select document");
		return false;
	}
	document.myForm.encoding="multipart/form-data";  
	
	document.myForm.action="ezGetVendorList.jsp?path="+document.myForm.path.value;
	document.myForm.submit();	

}
</Script>

</head>
<Body onload="funLoad()" oncontextmenu="return false;">
<form name="myForm" method="post">
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<Div style="position:absolute;width:100%;left:2%;top:20%">
	<Table width=40% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th width ="20%" align= right><nobr>Upload File :</nobr></th>
			<Td width="80%"> <input type="file" name="path" class=inputbox  style="width:100%">
			</Td>
		</Tr> 
	</Table>
	</Div>
	
<Div id="back" align=center style="position:absolute;top:87%;visibility:visible;width:100%">

<span id="EzButtonsSpan" >
<center>

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("GO");
	buttonMethod.add("funUpload()");
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>

</center>
</span>
<span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Th >Your request is being processed... Please wait</Th>
			</Tr>
		</Table>
		</span>
    </Div>	
</form>
<Div id="MenuSol"></Div>
</Body>	
</Html>
	
 