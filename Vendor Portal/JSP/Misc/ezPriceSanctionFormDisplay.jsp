<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<%@ include file="../../../Includes/JSPs/Purorder/iContract.jsp"%>
<% 
	String purOrg   = ((String)Session.getUserPreference("PURORG"));
	String status = (String)request.getParameter("status");
	//String vendorCode = (String)session.getValue("SOLDTO");
	String vendorName = (String)session.getValue("Vendor");
	String display_header ="";
	
	if("toBeApp".equals(status))
		display_header = "To Be Approved Price Sanction Form";
	if("App".equals(status))
		display_header = "Approved Price Sanction Form";
	if("Rej".equals(status))
		display_header = "Rejected Price Sanction Form";		
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Html>
<Body>
<form name = "myForm" method="post">
<div style="position:absolute;top:12%;left:0%;width:100%;">
	<Table width="80%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		
		<Tr>
			<Th width="20%">Supplier Code : </Th>
			<Td width="30%"><%=purchctrhdr.getFieldValueString(0,"CURRENCY")%></Td>
			<Th width="20%">Plant : </Th>
			<Td width="30%"><%=purchctrhdr.getFieldValueString(0,"CURRENCY")%></Td>
		</Tr>
		<Tr>
			<Th width="20%">Supplier Name : </Th>
			<Td width="30%"><%=purchctrhdr.getFieldValueString(0,"CURRENCY")%></Td>
			<Th width="20%">Purchase Org. : </Th>
			<Td width="30%"><%=purchctrhdr.getFieldValueString(0,"CURRENCY")%></Td>
		</Tr>
	</Table>
	<br>
	<Table width="99%" id="lineItems" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>		
		<Tr>
			<Th align="left" >&nbsp;</Th>
			<Th align="left" >&nbsp;</Th>
			<Th align="left" >&nbsp;</Th>
			<Th align="center"  rowspan=2>Existing Price</Th>
			<Th align="center"  colspan=3>Requested</Th>
			<Th align="center"  colspan=3>Negotiated/Recommended</Th>
			<Th align="left" >Incr/Decr W.E.F</Th>
		</Tr>
		<Tr>
			<Th align="left" >S. No</Th>
			<Th align="left" >Part No.</Th>
			<Th align="left" >Description</Th>
			<Th align="left" >Price(Rs.)</Th>
			<Th align="left" >INCR(Rs.)</Th>
			<Th align="left" >%</Th>
			<Th align="left" >Price(Rs.)</Th>
			<Th align="left" >INCR(Rs.)</Th>
			<Th align="left" >%</Th>
			<Th align="left" >&nbsp;</Th>
		</Tr>	
		<Tr>
			<Th>Location</Th>
			<Td colspan=2>&nbsp;</Td>
			<Th>Vendor Info Record</Th>
			<Th>Manual</Th>
			<Th>&nbsp;</Th>
			<Th>&nbsp;</Th>
			<Th>Manual</Th>
			<Th>&nbsp;</Th>
			<Th>&nbsp;</Th>
			<Th>Reduction</Th>
		</Tr>	
	
<%
		for(int i=0;i<purchctrhdr.getRowCount();i++)
		{

		
%>

		<Tr>
			<Td width="4%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="12%" align="left"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
			<Td width="8%" align="center"><%=purchctrhdr.getFieldValueString(i,"CURRENCY")%></Td>
		</Tr>
<%
		}
%>

	</Table>
	<br><br>
	<Table width="99%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<!--<Tr>
			<Th width="15%">Requested Date</Th>
			<Td width="20%">&nbsp;</Td>	
			<Th width="20%">Negotiated Effective Date</Th>
			<Td width="20%">&nbsp;</Td>
		</Tr>	-->
		<Tr>
			<Th colspan=2>Reasons for Price Change</Th>
			<!--<Th colspan=2>Change in Price due to</Th>-->
		</Tr>
		<Tr>
			<Td colspan=2><%=purchctrhdr.getFieldValueString(0,"CURRENCY")%></Td>
			<!--<Td colspan=2><textarea rows=6 cols=50></textarea></Td>-->
		</Tr>
		<!--<Tr>
			<Th align="left">Proposed By<br><br><br>Buyer</Th>
			<Th >Pricing Committee<br><br><br>RS&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;KRK&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;SVS</Th>
			<Th colspan=2>Approved By<br><br><br>JS&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;SK</Th>
		</Tr>-->
	</Table>
	<br>
	<Center>	
<%	
		buttonName.add("Back");	
		buttonMethod.add("history.back(-1)");  
		buttonName.add("Approve");	
		buttonMethod.add("");  
		buttonName.add("Reject");	
		buttonMethod.add("");  		
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	<Center>
<Div>
</from>
<Div id="MenuSol"></Div>
</Body>
</Html>