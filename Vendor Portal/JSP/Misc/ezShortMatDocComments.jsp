<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%
String doc = request.getParameter("doc");
String ind   = request.getParameter("ind"); 
%>

<html>
<head>
<Title>Powered By EzCommerceInc.</Title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script>
function funBack()
{
	var textObj=document.myForm.Comments;
	var lineNo=document.myForm.Index.value;
	if(textObj.value=="")
	{
		alert("Please Enter comments ");
		textObj.focus();
		return false;
	}	
		
	window.opener.document.getElementById('comments'+lineNo).value=textObj.value;
	alert(lineNo)
	window.close();
}

</Script>
	
</head>

<Body leftborder=0 topborder=0 rightborder=0 onLoad='scrollInit()' onresize='scrollInit()' scroll="no">
<form name=myForm method=post>
<input type="text" name="Index" value="<%=ind%>">
<br><br>
<br><br>
	<Div id="theads">
		<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="100%">
		<Tr>
		<Th  colspan="4" align="center">Material Document:<font color="red"><%=doc%></Font></Th>
		</Tr>
		<Tr>
		<Th  align="left">Comments:</Th>
		<Td  align="left">
		<textarea name="Comments" cols="50"></textarea>
		</Td>
		</Tr>
		</Table>
	</Div>	
	<br>
	<br>
	<DIV id="ButtonsDiv" align="center" style="position:relative;width:100%;">
	 <%	
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
	
	
		buttonName.add("OK");
		buttonMethod.add("funBack()");
		out.println(getButtonStr(buttonName,buttonMethod));
	 
	 %>
	 </Div>
                  
</form>
</body>
</html>
