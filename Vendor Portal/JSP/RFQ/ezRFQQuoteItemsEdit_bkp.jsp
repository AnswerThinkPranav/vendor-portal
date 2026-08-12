<%
	if(i%3==0)
	{
%>
		<table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
		<Tr>
		<Td width="33%">
			<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
			<Tr>
				<Th <%=trBGColor%> width="100%" colspan=2><%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL_DESC"))%></Th>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Material</Td>
				<Td width="65%">&nbsp;<%=rfqMatCode%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;UOM </Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_UOM"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Quantity </B></Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Currency </Td>
				<Td width="65%">&nbsp;INR</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Coromandel HSN Code </Td>
				<Td width="65%">&nbsp;
				<input  class=InputBox type="text" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10"></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN Code </Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="vndrHSNCode<%=rfqItemPos%>" value="" size="10" maxlength="10" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemDISCTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>  
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemPKFWTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemCGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemSGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemIGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemUGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFRTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
					&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemTotalValue_bd.toString())%>" size="7" readonly></Td>
			</Tr>

			</table>
		</Td>
<%
		}
		if(i%3==1)
		{
%>
		<Td width="33%">
			<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
			<Tr>
				<Th <%=trBGColor%> width="100%" colspan=2><%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL_DESC"))%></Th>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Material</Td>
				<Td width="65%">&nbsp;<%=rfqMatCode%></Td> 				
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;UOM </Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_UOM"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Quantity </B></Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Currency </Td>
				<Td width="65%">&nbsp;INR</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Coromandel HSN Code </Td>
				<Td width="65%">&nbsp;
				<input  class=InputBox type="text" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10"></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN Code </Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="vndrHSNCode<%=rfqItemPos%>" value="" size="10" maxlength="10" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemDISCTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>  
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemPKFWTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemCGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemSGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemIGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemUGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFRTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
					&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemTotalValue_bd.toString())%>" size="7" readonly></Td>
			</Tr>

			</table>
		</Td>
<%
		}
		if(i%3==2)
		{
%>			
		<Td width="33%">
			<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
			<Tr>
				<Th <%=trBGColor%> width="100%" colspan=2><%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL_DESC"))%></Th>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Material</Td>
				<Td width="65%">&nbsp;<%=rfqMatCode%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;UOM </Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_UOM"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Quantity </B></Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Currency </Td>
				<Td width="65%">&nbsp;INR</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;HSN Code </Td>
				<Td width="65%">&nbsp;
				<input  class=InputBox type="text" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10"></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemDISCTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemPKFWTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemCGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemSGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemIGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemUGSTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFRTTotVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
					&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemTotalValue_bd.toString())%>" size="7" readonly></Td>
			</Tr>

			</table>
		</Td>
<%
	}
	if((i+1)==rfqDetailsRetCnt)
	{
%>
		</Tr>
		</Table>
<%
	}
%>		