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
				<Td width="65%">&nbsp;<%=checkNull(rfqMatCode)%></Td>
			</Tr>
			<Tr>
					<Td width="35%">Applicable Tax</Td>
					<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2"))%></Td>
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
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_VEND_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B> </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(rfqItemPrice)%></Td>
					<Td  width=50%  align=right>&nbsp;<%=getDeciFormatVal(itemGrossVal_bd.toString())%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">
					<Table border=0  width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(discHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(discTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=itemPriceAftrDisc_bd%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrDiscHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(pkfwHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(pkfwTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=getDeciFormatVal(itemFinalPric_bd.toString())%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%></Td></Tr></Table>					
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(cgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(cgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(sgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(sgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(igstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(igstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(ugstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(ugstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">	
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtGstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtGstTotValHT.get(rfqItemPos))%></Td></Tr></Table>	
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
				<Td width="30%"2>
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;&nbsp;</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>	
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
				<Td width="65%">&nbsp;<%=checkNull(rfqMatCode)%></Td>
			</Tr>
			<Tr>
				<Td width="35%">Applicable Tax</Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2"))%></Td>
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
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_VEND_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B> </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(rfqItemPrice)%></Td>
					<Td  width=50%  align=right>&nbsp;<%=getDeciFormatVal(itemGrossVal_bd.toString())%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">
					<Table border=0  width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(discHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(discTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=itemPriceAftrDisc_bd%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrDiscHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(pkfwHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(pkfwTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=getDeciFormatVal(itemFinalPric_bd.toString())%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%></Td></Tr></Table>					
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(cgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(cgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(sgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(sgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(igstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(igstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(ugstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(ugstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">	
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtGstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtGstTotValHT.get(rfqItemPos))%></Td></Tr></Table>	
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
				<Td width="30%"2>
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;&nbsp;</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>	
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
				<Td width="65%">&nbsp;<%=checkNull(rfqMatCode)%></Td>
			</Tr>
			<Tr>
					<Td width="35%">Applicable Tax</Td>
					<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_EXT2"))%></Td>
			</Tr>			
			<Tr>
				<Td width="35%">&nbsp;UOM </Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_UOM"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Quantity </Td>
				<Td width="65%">&nbsp;<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY"))%></Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Currency </Td>
				<Td width="65%">&nbsp;INR</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
				<Td width="65%">&nbsp;
					<%=checkNull(rfqDetailsRet.getFieldValueString(i,"ERD_VEND_HSN_CODE"))%>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;<B>Price per Unit </B> </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(rfqItemPrice)%></Td>
					<Td  width=50%  align=right>&nbsp;<%=getDeciFormatVal(itemGrossVal_bd.toString())%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Discount </Td>
				<Td width="65%">
					<Table border=0  width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(discHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(discTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>     
				<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=itemPriceAftrDisc_bd%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrDiscHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Packing & Fowarding </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(pkfwHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(pkfwTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>  
				<Td width="35%">&nbsp;<B>Total Price</B></Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=getDeciFormatVal(itemFinalPric_bd.toString())%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrPkfwHT.get(rfqItemPos))%></Td></Tr></Table>					
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Central GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(cgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(cgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;State GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(sgstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(sgstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Integrated GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(igstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(igstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>

			<Tr>
				<Td width="35%">&nbsp;Union Trty GST </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(ugstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50% align=right>&nbsp;<%=checkNull(ugstTotValHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
				<Td width="65%">	
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>
			</Tr>
			<Tr>
				<Td width="35%">&nbsp;GST on Freight </Td>
				<Td width="65%">
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;<%=checkNull(frtGstHT.get(rfqItemPos))%>&nbsp;%</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(frtGstTotValHT.get(rfqItemPos))%></Td></Tr></Table>	
				</Td>
			</Tr> 
			<Tr>
				<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
				<Td width="30%"2>
					<Table border=0 width=20%><Tr><Td width=50%>&nbsp;&nbsp;</Td>
					<Td  width=50%  align=right>&nbsp;<%=checkNull(totAftrFrtGstHT.get(rfqItemPos))%></Td></Tr></Table>
				</Td>	
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