<%@ include file="../../../Includes/JSPs/Labels/iUpdateErpInfo_Labels.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iUpdateErpInfo.jsp"%>
<%
	String stmtIdKey = "GET_VENDOR_EMAIL";
	String msgSubject = "Address Change Request is approved by MTR";
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
	String vdr=request.getParameter("vendor");
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<Br>  
<%
	if(!isError)
	{
		if(payToCustNum==null)
		{
%>
			<div align="center">
			<TABLE width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
			<tr> 
				<th colspan='2'><%=payToAddr_L%></th>
			</tr>
			<tr> 
				<Th>Company Name</Th>
				<td><%=companyName%>&nbsp;</td>
			</tr>
			<tr> 	
				<Th>Address</Th>
				<td><%=payAddr1%>&nbsp;</td>
			</tr>
<%
			if (payAddr2!=null && payAddr2.trim().length()>0) 
			{
%>
				<tr>
					<Th>Address2</Th>
					<td><%=payAddr2%>&nbsp;</td>
				</tr>
<%
			}
%>

			<tr> 
				<Th>City</Th>
				<td><%=payCity%>&nbsp;</td>
			</tr>
			<tr> 
				<Th>Zip</Th>
				<td><%=payZip%>&nbsp; </td>
			</tr>
			<tr> 
				<Th>Country</Th>
				<td><%=payCountry%>&nbsp;</td>
			</tr>
			<tr> 
				<Th>Telephone</Th>
				<td><%=telephone1%>&nbsp;</td>
			</tr>
			</table>
			</div>
			<%//@ include file="../Purorder/ezSendMail.jsp" %>			
<%
		} 
		else 
		{
			String noDataStatement = noPayToAddr_L;
%>
			<%@ include file="../Misc/ezDisplayNoData.jsp"%>		
<%
		}
	}	
	else
	{
		String noDataStatement = errorMessage;
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


