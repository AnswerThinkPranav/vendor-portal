<% 
	String inputTextDisabled="";
	if("EditQuoted".equals(editType))inputTextDisabled="disabled";
		
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
				<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
				<Td valign="middle" align="left" width="15%" colspan=5>
					<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
						<option value=''>--Select Tax Type--</option>
						<option value='SCGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("SCGST"))?"Selected":""%> >SGST & CGST</option>
						<option value='IGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("IGST"))?"Selected":""%> >IGST</option>
						<option value='UGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("UGST"))?"Selected":""%> >UGST</option>
					</Select>
				</Td>
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
				<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
				<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>">					
					<input  class=InputBox type="text" disabled value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10">
					<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')" <%=inputTextDisabled%>>
					<Font color='RED' size=2><B>Incorrect</B></Font>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="" size="10" maxlength="10">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=checkNull(discTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="<%=itemPriceAftrDisc_bd%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="<%=checkNull(totAftrDiscHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>  
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=checkNull(pkfwTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFinalPric_bd.toString())%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
	
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(cgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>				
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(sgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(igstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(ugstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="<%=checkNull(frtGstHT.get(rfqItemPos))%>" <%=taxFieldsSize%>>%
					&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtGstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%>" size="7" readonly></Td>
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
				<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
				<Td valign="middle" align="left" width="15%" colspan=5>
					<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
						<option value=''>--Select Tax Type--</option>
						<option value='SCGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("SCGST"))?"Selected":""%> >SGST & CGST</option>
						<option value='IGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("IGST"))?"Selected":""%> >IGST</option>
						<option value='UGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("UGST"))?"Selected":""%> >UGST</option>
					</Select>
				</Td>
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
				<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
				<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>">					
					<input  class=InputBox type="text" disabled value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10">
					<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')">
					<Font color='RED' size=2><B>Incorrect</B></Font>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="" size="10" maxlength="10">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=checkNull(discTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="<%=itemPriceAftrDisc_bd%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="<%=checkNull(totAftrDiscHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>  
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=checkNull(pkfwTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFinalPric_bd.toString())%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
	
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(cgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>				
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(sgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(igstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(ugstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="<%=checkNull(frtGstHT.get(rfqItemPos))%>" <%=taxFieldsSize%>>%
					&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtGstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%>" size="7" readonly></Td>
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
				<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
				<Td valign="middle" align="left" width="15%" colspan=5>
					<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
						<option value=''>--Select Tax Type--</option>
						<option value='SCGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("SCGST"))?"Selected":""%> >SGST & CGST</option>
						<option value='IGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("IGST"))?"Selected":""%> >IGST</option>
						<option value='UGST' <%=(checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2")).equals("UGST"))?"Selected":""%> >UGST</option>
					</Select>
				</Td>
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
				<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
				<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>">					
					<input  class=InputBox type="text" disabled value="<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>" size="10" maxlength="10">
					<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')">
					<Font color='RED' size=2><B>Incorrect</B></Font>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="" size="10" maxlength="10">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPrice<%=rfqItemPos%>" value="<%=rfqItemPrice%>" size="8" maxlength="8" onBlur="checkNum(this,'<%=rfqItemPos%>')">
					&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemGrossVal_bd.toString())%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemDISCVal<%=rfqItemPos%>" value="<%=checkNull(discHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%		
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="<%=checkNull(discTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="<%=itemPriceAftrDisc_bd%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="<%=checkNull(totAftrDiscHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>  
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
					<input  class=InputBox type="text" <%=inputTextDisabled%> name="itemPKFWVal<%=rfqItemPos%>" value="<%=checkNull(pkfwHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="<%=checkNull(pkfwTotValHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">&nbsp;
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="<%=getDeciFormatVal(itemFinalPric_bd.toString())%>" <%=taxFieldsSize%> readonly>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%>" size="7" readonly>
				</Td>
			</Tr>
	
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
					<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>" value="<%=checkNull(cgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(cgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>				
			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
					<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>" value="<%=checkNull(sgstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(sgstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
					<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>" value="<%=checkNull(igstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(igstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeUGST<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
					<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>" value="<%=checkNull(ugstHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%	
					&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(ugstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="P"> 
					<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
					<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" <%=taxFieldsSize%> onBlur="checkNum(this,'<%=rfqItemPos%>')">	
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">&nbsp;
					<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="V"> 
					<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
					<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="<%=checkNull(frtGstHT.get(rfqItemPos))%>" <%=taxFieldsSize%>>%
					&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="<%=checkNull(frtGstTotValHT.get(rfqItemPos))%>" size="7" readonly>
					<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value</B> </Td>
				<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
				<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%>" size="7" readonly></Td>
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