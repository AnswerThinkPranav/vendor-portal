<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%
String doc 		= request.getParameter("doc");
String ind      	= request.getParameter("ind");
String poNum		= request.getParameter("poNum");
String poItemNum	= request.getParameter("poItemNum");
String postDate		= request.getParameter("postDate");


%>
<Html>
<Head>
<Title>Powered By EzCommerceInc.</Title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>

<script language="JavaScript">

function LTrim(str)
	{
		var whitespace = new String(" \t\n\r ");
		var s = new String(str);
		if (whitespace.indexOf(s.charAt(0)) != -1) {
		    var j=0, i = s.length;
		    while (j < i && whitespace.indexOf(s.charAt(j)) != -1)
			j++;
		    s = s.substring(j, i);
		}
		return s;
	}
	function RTrim(str)
	{
		var whitespace = new String(" \t\n\r ");
		var s = new String(str);
		if (whitespace.indexOf(s.charAt(s.length-1)) != -1) {
		    var i = s.length - 1;       // Get length of string
		    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
			i--;
		    s = s.substring(0, i+1);
		}
		return s;
	}
	function Trim(str)
	{
		return RTrim(LTrim(str));
	}

function funAcknowledge()
{
	var textObj=document.myForm.Comments;
	var text=textObj.value;
	text=Trim(text);
	if(text=="")
	{
		alert("Please Enter comments ");
		textObj.focus();
		return false;
	}	
	if(text.length>499)
	{
		alert("Comments length exceeded 500 characters!! ");
		textObj.focus();
		return false;
	}
		//var url = "ezSaveShortAckDoc.jsp?postDate=<%=postDate%>&doc=<%=doc%>&poNum=<%=poNum%>&comments="+text+"&ind=<%=ind%>&poItemNum=<%=poItemNum%>";
		//var myWind=window.open(url,"UserWindow","width=500,height=400, left =left top =top resizable=no, menubar = no locationbar = no scrollbars=yes");
		document.myForm.action="ezSaveShortAckDoc.jsp?postDate=<%=postDate%>&doc=<%=doc%>&poNum=<%=poNum%>&comments="+text+"&ind=<%=ind%>&poItemNum=<%=poItemNum%>";
		document.myForm.submit();
		
}

  
</Script>
	
</head>

<Body leftborder=0 topborder=0 rightborder=0 onLoad='scrollInit()' onContextMenu="return false" onresize='scrollInit()' scroll="no">
<form name=myForm method=post>
<input type="hidden" id="status1" value="">
<br><br>


	<Div id="theads">
		<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="100%">
		<Tr>
		<Th  colspan="2" align="left">Material Document:<font color="red"><%=doc%></Font>&nbsp;&nbsp;&nbsp;Item No:<font color="red"><%=poItemNum%></Font></Th>
		</Tr>
		<Tr>
		<Th  align="left">Comments:</Th>
		<Td  align="left">
		<textarea name="Comments" cols="72" rows="5"></textarea>
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
	
	
		buttonName.add("Acknowledge");
		buttonMethod.add("funAcknowledge()");
		out.println(getButtonStr(buttonName,buttonMethod));
	 
	 %>
	 </Div>

</form>
</body>
</html>

