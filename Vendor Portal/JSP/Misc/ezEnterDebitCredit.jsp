<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>


<%!
    	private String checkNull(String str)
    	{
    		if("null".equals(str) ||str==null || str=="" || "".equals(str))
    		str="NA";
    		return str;
    	}
%>  
<%
String doc 		= checkNull(request.getParameter("doc"));
String ind      	= checkNull(request.getParameter("ind"));
String postDate		= checkNull(request.getParameter("postDate"));
String grossAmt		= checkNull(request.getParameter("grossAmt")); 
String docDate		= checkNull(request.getParameter("docDate"));

String userType  = (String)session.getValue("UserType");
%>
<%@ include file="../../../Includes/Jsps/Misc/iEnterDebitNotes.jsp"%>   
<%@ include file="../../../Includes/Jsps/Misc/iDebitNotesComments.jsp"%>
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
function checkNum()
{
	var creditN=document.myForm.creditN;
	if(isNaN(creditN.value))
	{
	   alert("Credit Note should be numeric"); 
	   creditN.value="";
	   creditN.focus();
	   return false;
	}
}
function funSave()
{
	var creditN=document.myForm.creditN;
	var creditVal=creditN.value;
	var textObj=document.myForm.Comments;
	var text=textObj.value;
	text=Trim(text);
	if(creditVal=="")
	{
		alert("Enter Credit Note ");
		creditN.focus();
		return false;
	}
	if(text=="")
	{
		alert("Enter Comments ");
		textObj.focus();
		return false;
	}	
	if(text.length>499)
	{
		alert("Comments length exceeded 500 characters!! ");
		textObj.focus();
		return false;
	}
		
		document.myForm.action="ezSaveDebitCreditNotes.jsp?docDate=<%=docDate%>&creditNote="+creditVal+"&postDate=<%=postDate%>&doc=<%=doc%>&comments="+text+"&ind=<%=ind%>";
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
		<Th>Debit Note</Th>
		<Th>Gross Amount</Th>
		<th>Credit Note</th>
		</Tr>
		<tr>
		<td align="center"><%=doc%></td>
		<td align="center"><%=grossAmt%></td>
<%
	ezc.ezcommon.EzLog4j.log("creditno>>>>>>>>"+creditno,"I");
	creditno=checkNull(creditno); 
	if(!"NA".equals(creditno) && creditno!="NA")  
	{
	ezc.ezcommon.EzLog4j.log("creditno>>>>>>>>"+creditno,"I");
%>
	<td align="center"><input class="tx" type="text" name="creditN" value="<%=creditno%>" readonly></td>
<%
	}else 
	{
%>	
		<td align="center"><input type="text" onChange="checkNum()" name="creditN" value=""></td>
<%
}%>
		</tr>
		</Table>
		
	</Div>	
	<Div id="theads">
		<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="100%">
		<Tr>
			<Th  align="left">Comments:</Th>
			<Td  align="left">
<%
	if("NA".equals(creditno) || creditno=="NA")
	{
%>	
			
		<textarea name="Comments" cols="72" rows="5"></textarea>
<%
	}
	else
	{
%>	
		<input type="text"  class="tx" name="Comments" value="<%=comments%>" readonly>  
<%
	}
%>	
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
	

		if("NA".equals(creditno) || creditno=="NA")
		{

		buttonName.add("Save");
		buttonMethod.add("funSave()");

		}
		buttonName.add("Close");
		buttonMethod.add("window.close()");
		
		out.println(getButtonStr(buttonName,buttonMethod));
	 
	 %>
	 </Div>

</form>
</body>
</html>

