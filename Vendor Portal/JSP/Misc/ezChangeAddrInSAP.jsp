<%@ include file="../../../Includes/JSPs/Labels/iUpdateErpInfo_Labels.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iUpdateErpInfo.jsp"%>
<%
	String stmtIdKey = "GET_VENDOR_EMAIL,"+vendor;
	String msgSubject = "Address Change Request is approved";
	String ccMailIds  = "";
	String msgText = "Your Address Change Request is approved.<Br>";
%>
<%@include file="../Misc/ezSendMail.jsp"%> 
<html>
<head>       
	<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>
<body scroll=no>
<%
	String display_header  = addrUpdateInfo_L;
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<Br>  
<%
	if(!isError)
	{
		response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Vendor Address Change Request approved and updated successfully.");			
	}	
	else
	{
		String noDataStatement = "<Font color='RED' size=2>ERROR : </Font>"+errorMessage;
%>
		<%@ include file="../Misc/ezDisplayNoData.jsp"%>		
<%
	}
%>

<Div id="ButtonDiv" align=center style="position:absolute;top:65%;visibility:visible;width:100%">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Ok");
	buttonMethod.add("navigateBack(\"ezVendorAddChangeList.jsp\")");

	 out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</Div>
<Div id="MenuSol"></Div>
</body>
</html>


