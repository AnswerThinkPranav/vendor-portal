<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*" %>

<%
String rfqNo 	= request.getParameter("PurchaseOrder");
String itemNo	= request.getParameter("ItemNo");

if(rfqNo==null || "null".equals(rfqNo))rfqNo="";
if(itemNo==null || "null".equals(itemNo))itemNo="";

rfqNo=rfqNo.trim();
itemNo=itemNo.trim();

String ItemNote ="";


if(!"".equals(itemNo) && !"".equals(rfqNo))
{
	JCO.Client client	= EzSAPHandler.getSAPConnection("245~999");
	JCO.Function function	= EzSAPHandler.getFunction("RFC_READ_TEXT","245~999");
	JCO.Table textLines     = function.getTableParameterList().getTable("TEXT_LINES");

	String rfqNoTemp = "0000000000"+rfqNo;
	rfqNoTemp	 = rfqNoTemp.substring(rfqNoTemp.length()-10,rfqNoTemp.length());
	String ItemNoteTemp = "00000"+itemNo;
	ItemNoteTemp	 = ItemNoteTemp.substring(ItemNoteTemp.length()-5,ItemNoteTemp.length());
			
	textLines.appendRow();
	textLines.setValue("EKPO","TDOBJECT");
	textLines.setValue((rfqNoTemp+ItemNoteTemp),"TDNAME");
	textLines.setValue("A4","TDID");
	textLines.setValue("EN","TDSPRAS");
	try{
		client.execute(function);
		JCO.Table ret = function.getTableParameterList().getTable("TEXT_LINES");
		int retCount = 0 ;
		if(ret!=null)
		 retCount = ret.getNumRows();
		if(retCount>0)
		{
			do
			{
				if(ret.getValue("TDLINE")!=null)
				ItemNote += (String)ret.getValue("TDLINE");
			}
			while(ret.nextRow());
		}
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("=======RFC_READ_TEXT ERROR========>"+e,"I");
		e.printStackTrace();
	}finally{
		ezc.ezcommon.EzLog4j.log(":::::::releaseClient:::::","I");

		JCO.releaseClient(client);
		client = null;
		function=null;
	}
	
	
	
	
	
}

ItemNote=ItemNote.trim();

%>



<html>
<head>
<title>Item Note--Powered By EzCommerce India</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>  
<script>

</script>
</head>

<body >
<form name="myForm">
<%
	String display_header = "Item Note";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
if(!"".equals(ItemNote))
{
%>
<Div style="position:absolute;align:center;top:15%;width:100%;visibility:visible">
<table align="center" width=""100% border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<tr>
<Th width="25%">RFQ No:</Th>
<Td width="25%"><%=rfqNo%></Td>
<Th width="25%">Item No:</Th>
<Td width="25%"><%=itemNo%></Td>
</tr>
<tr>
<Th colspan=4>Item Note</Th>
</tr>
<tr>
<td align="left" colspan=4><%=ItemNote%></td>
</tr>
</Table>
</div>
<%
}else{
%>
<Div style="position:absolute;top:45%;width:100%;visibility:visible">
<Table width=80% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
<tr><th>Item note does not exist for item: <%=itemNo%></th></tr>
</table>
</Div>
<%
}
%>
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
