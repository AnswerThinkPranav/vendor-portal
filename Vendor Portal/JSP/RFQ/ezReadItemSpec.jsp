<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*" %>

<%
String itemSpec	= request.getParameter("ItemSpec");
String itemNo	= request.getParameter("ItemNo");
String fromPage	= request.getParameter("fromPage");
String noteType	= request.getParameter("noteType");
String disabled  = "disabled";

if(itemSpec==null || "null".equals(itemSpec.trim()))itemSpec="";
if(itemNo==null || "null".equals(itemNo.trim()))itemNo="";
if(fromPage==null || "null".equals(fromPage.trim()))fromPage="";
if(noteType==null || "null".equals(noteType.trim()))noteType="B";

if("ExcelQuote".equals(fromPage))disabled="";
%>
<html>
<head>
<title>Item Note--Powered By EzCommerce India</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>  


</head>
<body >
<form name="myForm">
<%
	
	String display_header = "Buyer Item Note for item: "+itemNo;
	
	if("V".equals(noteType))display_header = "Vendor Item Note for item: "+itemNo;
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

<Div style="position:absolute;align:center;top:15%;width:100%;visibility:visible">

<%
if(!"".equals(itemSpec))
{
%>
<textarea name="Item Specs" disabled rows=4 style="width:100%;overflow:auto" maxlength="200"><%=itemSpec%></textarea>
<%
}else{
%>
<table align="center" width=""100% border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<tr>
<th>Item note does not exist for item: <%=itemNo%></th>
</tr>
</Table>
<%
}
%>
</div>

<Div id="ButtonDiv" style="position:absolute;top:85%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</div>
</body>
</html>
