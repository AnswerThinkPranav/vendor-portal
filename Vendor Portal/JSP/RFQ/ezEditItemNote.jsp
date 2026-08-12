<%
String index = request.getParameter("index");
String ItemNote[]=request.getParameterValues("itemNotePOP");
//String ItemNote=request.getParameter("ItemNote");
String reqNo=request.getParameter("reqNo");
String itemNo=request.getParameter("itemNo");
int indx;
try
{
	indx= Integer.parseInt(index);
}	
catch(Exception e){indx=0;}

/*if(ItemNote==null || "null".equals(ItemNote))ItemNote="";
ItemNote=ItemNote.trim();*/

if(reqNo==null || "null".equals(reqNo))reqNo="";
if(itemNo==null || "null".equals(itemNo))itemNo="";

//out.println("index::::"+index+"ItemNote::::"+ItemNote[0]+"reqNo::::"+ItemNote[1]+"itemNo::::"+ItemNote[2]);

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
	var index ='<%=index%>'
	var len = opener.window.document.myForm.material.length
	var itemNote = document.myForm.comments.value;
	itemNote=(itemNote.replace(/^\W+/,'')).replace(/\W+$/,'');
	itemNote = funTrim(itemNote);
	if(isNaN(len))
	{
		opener.window.document.myForm.ItemNote.value=itemNote;
		window.close()
	}	
	else{
		opener.window.document.myForm.ItemNote[index].value=itemNote;
		window.close()
	}	
		
	
}
function funLoad()
{
	document.myForm.comments.focus();
}
</script>
</head>

<body onload="funLoad()">
<form name="myForm">
<%
	String display_header = "Item Note";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<br><br>
<table align="center"  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<tr>
<tr>
<Th>PR No:</Th><Td><%=reqNo%></Td>

<Th>Item No:</Th><Td><%=itemNo%></Td>
</tr>
</tr>
<tr>
<Th >Item Note:</Th>
<td align="center" colspan=3>
<Textarea  rows="10" cols="40"  name="comments" value="<%=ItemNote%>[indx]"><%=ItemNote[indx]%>
</Textarea>
</td></tr>
</Table>

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
