 <%
 	/*******This file is included in pages RFQ\ezPostQuote.jsp and RFQ\ezNonSAPRfqQuote.jsp************/
 %>
 
<table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="99%">
<Tr>
	<Th align="right" width="15%" <%=trBGColor%>>Portal Ref. No&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">&nbsp;<input type="hidden" name="RfqNo" value="<%=request.getParameter("portRfqNum")%>"><%=request.getParameter("portRfqNum")%></Td>
	<Th align="right" width="15%"  <%=trBGColor%>>RFQ Date&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">&nbsp;&nbsp;<%=rfqDate%></Td>
	<Th align="right" width="15%"  <%=trBGColor%>>Quotation Date&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">&nbsp;
<%
		String qtndate = FormatDate.getStringFromDate(new Date(),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
%>
		<%=qtndate%>
		<input type="hidden" name="quotationDate" value="<%=qtndate%>">
	</Td>
</Tr>
<Tr>
	<Th align="right" width="15%" <%=trBGColor%>>SAP RFQ No&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">&nbsp;<input type="hidden" name="SAPRfqNo" value="<%=SAPRFQNo%>"><%=SAPRFQNo%></Td>
	<Th align="right" width="15%"  <%=trBGColor%>>Qtn. Ref. No *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">
			&nbsp;<input type="text" class=InputBox  name="quoteRefNo" maxlength="15" size="15" value="">
	</Td>

	<Th align="right" width="15%" <%=trBGColor%>>Price Valid Upto *&nbsp;&nbsp;</Th>
	<Td width="15%">
	<div class="input-group">&nbsp;
		<input type="text" class=InputBox  style="width: 120px;" id="priceValidUpto" name="priceValidUpto"  value="" size=12 readonly onfocus=this.blur()>
		<!--<%=getDateImage("priceValidUpto")%>-->
		<label for="priceValidUpto" style="padding: 0px;" class="input-group-addon btn"><span> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'><span></label>&nbsp;&nbsp;  				
	</div>	
	</Td>
</tr>
<tr>
	<Th align="right" width="15%"  <%=trBGColor%>>Inco Terms *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%">&nbsp;
		<Select name="rfqIncoTerms1"  style="width:91%">
		<option value="">--Select Inco Terms--</option>
	<%
			while(incoIterator.hasNext())
			{
				incoObj = incoIterator.next();
				String incoStr = incoObj.toString();
				if(incoStr.equals(incoterm))
				{
	%>
					<Option value=<%=incoStr%> selected><%=incoStr%>--><%=incoTM.get(incoStr) %></Option>
	<%
				}
				else
				{
	%>
					<Option value=<%=incoStr%> ><%=incoStr%>--><%=incoTM.get(incoStr) %></Option>
	<%
				}
			}
	%>
		</Select>
	</Td>
	


	<Th align="right" width="15%" <%=trBGColor%>>Inco Terms2 *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%"  colspan=3>
		&nbsp;&nbsp;<input type="text" class=InputBox  name="rfqIncoTerms2" maxlength="100" size="73" value="">
	</Td>
</Tr>

<Tr>
	<Th align="right" width="15%" <%=trBGColor%> >Payment terms *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%"  colspan=5>
		&nbsp;<!--<input type="text" class=InputBox  name="rfqPayTerms"  maxlength="100" size="125" value="">-->
		<select  name="rfqPayTerms" id="rfqPayTerms">
		<option value="" ><--------Select Payment Terms-------></option>
			<option value="WITHIN 10 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE">WITHIN 10 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE</option>
			<option value="WITHIN 20 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE">WITHIN 20 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE</option>			
			<option value="WITHIN 30 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE">WITHIN 30 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE</option>
			<option value="WITHIN 45 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE">WITHIN 45 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE</option>
			<option value="WITHIN 60 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE">WITHIN 60 DAYS FROM THE DATE OF RECEIPT OF MATERIAL/ SERVICE & ACCEPTANCE</option>
			<option value="Others">Others</option>
		</select>
	</Td>

</Tr>


<Tr>

	<Th align="right" width="15%"  <%=trBGColor%>>Delivery Period *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%" colspan=5>
		&nbsp;<input type="text" class=InputBox  name="rfqDelvPeriod"  maxlength="100" size="125" value="">
	</Td>
</Tr>
<Tr>
	<Th align="right" width="15%"  <%=trBGColor%>>Guarantee Period *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%" colspan=5>
		&nbsp;<input type="text" class=InputBox  name="rfqGrtyPeriod"  maxlength="100" size="125" value="">
	</Td>
</Tr>
<!--<Tr>
	<Th align="right" width="15%"  <%=trBGColor%>>Applicable Tax *&nbsp;&nbsp;</Th>
	<Td valign="middle" align="left" width="15%" colspan=5>
		<Select name='applTax' onChange="enableTaxes()">
			<option value=''>--Select Tax Type--</option>
			<option value='SCGST'>SGST & CGST</option>
			<option value='IGST'>IGST</option>
			<option value='UGST'>UGST</option>
		</Select>
	</Td>
</Tr>-->

</table>