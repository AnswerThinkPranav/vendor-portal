<html>
<head>
<title>Enter Shipments --Powered By EzCommerce Inc</title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
function funClose()
{
	var index=document.myForm.index.value;
	if(!isNaN(parent.opener.document.myForm.attachment.length))
	{
		parent.opener.document.myForm.attachment[index].value =document.myForm.n1.value;
		//alert(parent.opener.document.myForm.attachment[index].value)
		parent.opener.document.myForm.serverfile[index].value =document.myForm.n2.value;
		parent.opener.document.getElementById("attachfile"+index).style.display='none';
		parent.opener.document.getElementById("remove"+index).style.display='';



	}
	else
	{
		parent.opener.document.myForm.attachment.value =document.myForm.n1.value;
		parent.opener.document.myForm.serverfile.value =document.myForm.n2.value;
		parent.opener.document.getElementById("attachfile"+index).style.display='none';
		parent.opener.document.getElementById("remove"+index).style.display='';

	}

	parent.window.close();
}
</script>
</head>
<form name=myForm>
<body>
<%
	String filename=request.getParameter("filename");
	String path=request.getParameter("path");
	String index=request.getParameter("index");
	
%>
<br>
<TABLE width="90%" align=left>
<tr><td class="blankcell"><b>Files Attached.</b></Td></Tr>
<tr><td class="blankcell"><hr></Td></Tr>
<tr><td class="blankcell">The following file have been attached: </Td></Tr>
<tr><td class="blankcell"><%=filename%></Td></Tr>
<tr><td class="blankcell"><hr></Td></Tr>
<tr><td class="blankcell">Click on the 'Done' button.</Td></Tr>
<tr><td class="blankcell"><input type="button" name="Done" value="Done" onclick="funClose()"></Td></Tr>
<tr><td class="blankcell"><hr></Td></Tr>
</table>
<input type="hidden" name="n1" value="<%=filename%>" >
<input type="hidden" name="n2" value="<%=path%>" >
<input type="hidden" name="index" value='<%=session.getValue("INDEX")%>' >
</form>
</body>
</html>