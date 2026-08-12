<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<Html>
<Head>
<title>Remarks-- Powered By The Hackett Group</title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script src="../../Library/JavaScript/ezTrim.js"></script>
<script>
function funRemarks()
{
	var reasons = document.myForm.reasons.value;
	if(textCounter(document.myForm.reasons))
	{
		window.returnValue=funTrim(reasons);
		window.close();
	}	
}
function funCancel()
{
	window.returnValue="Canceld~~"
	window.close()
}
function textCounter(field) 
{
	if (field.value.length > 2000) 
	{
		alert("Comments Limit Exceeded : You can enter only 2000 characters in the Comments field");
		field.focus();
		return false;
	}	
	return true;
}
function setDefault()
{
	window.opener = window.dialogArguments
	if(opener.document.myForm.qcfComments != null)
		document.myForm.reasons.value = opener.document.myForm.qcfComments.value
	if(opener.document.myForm.reasons != null)
		document.myForm.reasons.value = opener.document.myForm.reasons.value
		
}
</script>
</Head>
</Head>
<body scroll=no onload='setDefault()'>
<form name="myForm">
<br><center>
<table  border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 width=100%>
	<tr><th align=left> Enter Commets here and press Ok ...</th></tr>
	<tr><td align="center" class='blankcell'>
	<Textarea rows="16" style="width:100%" class=txarea name="reasons"></Textarea>
	</td></tr>
</table></Center>
<br>


<Div id="image" align="center" style='Position:Absolute;visibility:visible;WIDTH:100%;Top:90%'>
	
			
<%
			buttonName = new ArrayList();
			buttonMethod = new ArrayList();

			buttonName.add("Ok");
			buttonMethod.add("funRemarks()");
			
			buttonName.add("Cancel");
			buttonMethod.add("funCancel()");

			out.println(getButtonStr(buttonName,buttonMethod));
%>
			
</Div>



</form>
<Div id="MenuSol"></Div>
</body>
</Html>

