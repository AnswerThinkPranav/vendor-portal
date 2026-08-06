<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<%@ include file="../../../Includes/JSPs/Purorder/iContract.jsp"%>

<%@ page import = "java.util.*"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<html>
<head>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%
	String status = (String)request.getParameter("status");
	String display_header ="";

	if("ToBeApproved".equals(status))
		display_header = "To Be Approved Price Sanction Form";
	if("Approved".equals(status))
		display_header = "Approved Price Sanction Form";
	if("Rejected".equals(status))
		display_header = "Rejected Price Sanction Form";		
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

</head>
<Body>
<Form name="myForm" method="post">
	<div style="position:absolute;top:15%;width:100%;left:0%;overflow:auto;height:328px">
	<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<thead>
		<Tr>
			<th align="center" width="10%">Document Number</th>
			<th align="center" width="10%">Date</th>
			<th align="center" width="15%">Vendor Code</th>     
			<th align="center" width="15%">Part No.</th>
		</Tr>
	</thead>
	<tbody>	
<%
		for(int i=0; i<1; i++)
		{
%>
		<Tr>
			<td align="center"  width="10%"><a href="ezPriceSanctionFormDisplay.jsp?status=<%=status%>">123456</a></td>
			<td align="center" width="10%"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></td>
			<td align="center" width="15%"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></td>
			<td align="center" width="15%"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></td>
		</Tr>
<%
		}
%>
	</tbody>	
	</Table>
</Div>	
<Div id="MenuSol"></Div>
</Form>
</Body>
</Html>