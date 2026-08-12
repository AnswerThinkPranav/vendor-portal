<%
String PmntTerms = request.getParameter("pmntTerms");
String RFQNo     = request.getParameter("PurchaseOrder");

if(PmntTerms==null || "null".equals(PmntTerms))PmntTerms="";
if(RFQNo==null || "null".equals(RFQNo))RFQNo="";

%>

<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>

<html>
<head>
<title>Item Note--Powered By EzCommerce India</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script src="../../Library/JavaScript/ezTrim.js"></Script>
<script>
function funOk()
{
	var pmntTerms = document.myForm.pmntTerms.value;
	pmntTerms=(pmntTerms.replace(/^\W+/,'')).replace(/\W+$/,'');
	pmntTerms = funTrim(pmntTerms);

	if(pmntTerms=="")
	{
		alert("Please enter payment terms.");
		return;
	}else{
		opener.window.document.myForm.pmntTerms.value=pmntTerms
		document.myForm.action="ezSavePmntTerms.jsp";
		document.myForm.submit();
	}	
	
}

function funText(field,maxlimit) 
{
	var keyASCII = window.event.keyCode; 
	var keyValue = String.fromCharCode(keyASCII); 
	
	
	if (field.value.length > maxlimit) 
	{
		alert("Text too long. Must be 50 characters or less");
		window.event.keyCode=0; 
		return;
		//field.value = field.value.substring(0, maxlimit);
	}
	/*
	else if (!(keyASCII >= '97' && keyASCII <= '122') && !(keyASCII >= '65' && keyASCII <= '90') && !(keyValue >= '0' && keyValue <= '9')) 
	{ 
		window.event.keyCode=0; 
		alert("Enter only alphabets and numbers.No special characters allowed"); 
		return;
	} */
}


</script>
</head>

<body >
<form name="myForm">
<%
	String display_header = "Item Note";
%>
<%//@ include file="../Misc/ezDisplayHeader.jsp"%>
<br><br><br>
<table align="center"  width="90%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<tr>
<Th >Payment Terms (Max Length: 50)</Th>

<td align="center" >
<Textarea  rows="8" cols="25" name="pmntTerms" value="<%=PmntTerms%>" onKeyPress="funText(this.form.pmntTerms,48);">
<%=PmntTerms%>
</Textarea>
</td></tr>
</Table>
<input type="hidden" name="RFQNo" value="<%=RFQNo%>">
<Div id="ButtonDiv" style="position:absolute;top:85%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Ok");
	buttonMethod.add("funOk()");
	
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</div>
</body>
</html>
