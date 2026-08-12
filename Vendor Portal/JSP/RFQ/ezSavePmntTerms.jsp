<%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*" %>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%
	String pmntTerms = request.getParameter("pmntTerms");
	if(pmntTerms==null || "null".equals(pmntTerms))pmntTerms="";
	
	String RFQNo     = request.getParameter("RFQNo");
	if(RFQNo==null || "null".equals(RFQNo))RFQNo="";
	
	String rfqNoTemp = "0000000000"+RFQNo;
	rfqNoTemp	 = rfqNoTemp.substring(rfqNoTemp.length()-10,rfqNoTemp.length());
	
	pmntTerms = pmntTerms.replaceAll("'","`");


	JCO.Client client	= EzSAPHandler.getSAPConnection("245~999");
	JCO.Function function	= EzSAPHandler.getFunction("RFC_SAVE_TEXT","245~999");
				
	JCO.Table textLines     = function.getTableParameterList().getTable("TEXT_LINES");
	
	textLines.appendRow();
	textLines.setValue("EKKO","TDOBJECT");
	textLines.setValue(rfqNoTemp,"TDNAME");
	textLines.setValue("A07","TDID");
	textLines.setValue(pmntTerms,"TDLINE");
	
	try{
		client.execute(function);
	}catch(Exception e){
		out.println(e);
		e.printStackTrace();
	}finally{
		ezc.ezcommon.EzLog4j.log(":::::::releaseClient:::::","I");

		JCO.releaseClient(client);
		client = null;
		function=null;		
	}
	
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	
	miscParams.setQuery("UPDATE ERH_RFQ_HEAR SET ERH_PAYMENT_TERMS='"+pmntTerms+"' WHERE ERH_RFQ_NO='"+RFQNo+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	
	ezc.ezcommon.EzLog4j.log("miscParams.setQuery>>>"+miscParams.getQuery(),"I");
	
	try
	{
		ezMiscManager.ezUpdate(mainParams);
	}
	catch(Exception e)
	{
	}
	

%>

<html>
<head>
<title>Item Note--Powered By EzCommerce India</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script src="../../Library/JavaScript/ezTrim.js"></Script>
<script>
function funOk()
{
	opener.history.go(0);
	window.close();
}

</script>
</head>

<body oncontextmenu="alert('Function Disabled'); return false;">
<form name="myForm">
<Div style="position:absolute;top:45%;width:100%;visibility:visible">
<Table width=100% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
<tr><th>Payment Terms updated successfully.</th></tr>
</table>
</Div>
<Div id="ButtonDiv" style="position:absolute;top:85%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Ok");
	buttonMethod.add("funOk()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</div>
</body>
</html>