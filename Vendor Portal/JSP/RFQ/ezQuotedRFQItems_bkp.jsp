<%
/*******This file is included in pages RFQ\ezRequote.jsp and RFQ\ezNonSAPRfqQuote.jsp and RFQ\ezViewQuoteDetails.jsp************/
%>
<%!
	public String getDeciFormatVal(String valStr) 
	{
		String retStr = "";
		//java.text.DecimalFormat deciFormat = new java.text.DecimalFormat(".##"); 
		
		try{
			//retStr = deciFormat.format(Double.parseDouble(valStr))+"";
			
			retStr = String.format("%.2f", Double.parseDouble(valStr))+"";
			
		}catch(Exception e){}	

		return retStr;	
	}
%>	
<%
	String inpBoxColor = "style='background-color:grey;color:white;text-align:right'";
	String currSymbol = "&#8377;";
	String taxFieldsSize = " size='5' maxlength='5' ";

	BigDecimal itemPrice_bd 	= new BigDecimal("0");
	BigDecimal itemQty_bd 		= new BigDecimal("0");
	BigDecimal itemGrossVal_bd 	= new BigDecimal("0"); 

	BigDecimal itemPriceTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemDISCTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemCGSTTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemSGSTTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemIGSTTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemUGSTTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemPKFWTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemFRTTotVal_bd 	= new BigDecimal("0");
	BigDecimal itemTotalValue_bd 	= new BigDecimal("0");

	BigDecimal percent_bd 	= new BigDecimal("100");

	for(int i=0;i<rfqDetailsRetCnt;i++)
	{		
		String rfqItemPos 	= rfqDetailsRet.getFieldValueString(i,"ERD_LINE_NO");
		dateObj			 = (java.util.Date)rfqDetailsRet.getFieldValue(i,"ERD_DELIVERY_DATE");
		String rfqItemDlvDate 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String rfqItemPrice	= new BigDecimal(rfqDetailsRet.getFieldValueString(i,"ERD_PRICE")).setScale(2, BigDecimal.ROUND_UP).toString();
		String rfqItemQty	= rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY");
		String currency		= rfqDetailsRet.getFieldValueString(i,"CURRENCY");
		
		if("".equals(currency) || "null".equals(currency) || currency==null)
      			currency = "INR";
		
		if("Y".equals(rfqReQuote))
			rfqItemPrice	= new BigDecimal(rfqDetailsRet.getFieldValueString(i,"ERD_NEG_PRICE")).setScale(2, BigDecimal.ROUND_UP).toString();

		String rfqMatCode = rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL");

		try{
			rfqMatCode = Long.parseLong(rfqMatCode)+"";
      		}catch(Exception e){}

		itemTotalValue_bd 	= new BigDecimal("0");
		itemQty_bd 		= new BigDecimal(rfqItemQty);
		itemPrice_bd 		= new BigDecimal(rfqItemPrice);
		itemGrossVal_bd 	= itemQty_bd.multiply(itemPrice_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemGrossVal_bd);

		itemDISCTotVal_bd 	= new BigDecimal(checkNull(discHT.get(rfqItemPos)));
		itemCGSTTotVal_bd 	= new BigDecimal(checkNull(cgstHT.get(rfqItemPos)));
		itemSGSTTotVal_bd 	= new BigDecimal(checkNull(sgstHT.get(rfqItemPos)));
		itemIGSTTotVal_bd 	= new BigDecimal(checkNull(igstHT.get(rfqItemPos)));
		itemUGSTTotVal_bd 	= new BigDecimal(checkNull(ugstHT.get(rfqItemPos)));
		itemPKFWTotVal_bd 	= new BigDecimal(checkNull(pkfwHT.get(rfqItemPos)));
		itemFRTTotVal_bd 	= new BigDecimal(checkNull(frtHT.get(rfqItemPos)));


		itemDISCTotVal_bd 	= itemDISCTotVal_bd.multiply(itemGrossVal_bd);
		itemDISCTotVal_bd 	= itemDISCTotVal_bd.divide(percent_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.subtract(itemDISCTotVal_bd);

		itemCGSTTotVal_bd 	= itemCGSTTotVal_bd.multiply(itemGrossVal_bd);
		itemCGSTTotVal_bd 	= itemCGSTTotVal_bd.divide(percent_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemCGSTTotVal_bd);

		itemSGSTTotVal_bd 	= itemSGSTTotVal_bd.multiply(itemGrossVal_bd);
		itemSGSTTotVal_bd 	= itemSGSTTotVal_bd.divide(percent_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemSGSTTotVal_bd);

		itemIGSTTotVal_bd 	= itemIGSTTotVal_bd.multiply(itemGrossVal_bd);
		itemIGSTTotVal_bd 	= itemIGSTTotVal_bd.divide(percent_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemIGSTTotVal_bd);

		itemUGSTTotVal_bd 	= itemUGSTTotVal_bd.multiply(itemGrossVal_bd);
		itemUGSTTotVal_bd 	= itemUGSTTotVal_bd.divide(percent_bd);

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemUGSTTotVal_bd);

		itemPKFWTotVal_bd 	= itemPKFWTotVal_bd.multiply(itemGrossVal_bd);
		itemPKFWTotVal_bd 	= itemPKFWTotVal_bd.divide(percent_bd);
 
		itemTotalValue_bd 	= itemTotalValue_bd.add(itemPKFWTotVal_bd);

		itemFRTTotVal_bd 	= itemFRTTotVal_bd.multiply(itemGrossVal_bd);
		itemFRTTotVal_bd 	= itemFRTTotVal_bd.divide(percent_bd); 

		itemTotalValue_bd 	= itemTotalValue_bd.add(itemFRTTotVal_bd);        

%>
		<input type='hidden' name='rfqItem' value='<%=rfqItemPos%>'>	
		<input type='hidden' name='rfqMatCode<%=rfqItemPos%>' value='<%=rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL")%>'>
		<input type='hidden' name='rfqMatDesc<%=rfqItemPos%>' value='<%=rfqDetailsRet.getFieldValueString(i,"ERD_MATERIAL_DESC")%>'>
		<input type='hidden' name='rfqItemUOM<%=rfqItemPos%>' value='<%=rfqDetailsRet.getFieldValueString(i,"ERD_UOM")%>'>
		<input type='hidden' name='rfqItemQty<%=rfqItemPos%>' value='<%=rfqDetailsRet.getFieldValueString(i,"ERD_QUANTITY")%>'>
		<input type='hidden' name='rfqItemCurr<%=rfqItemPos%>' value='<%=currency%>'>
		<input type='hidden' name='rfqItemDlvDate<%=rfqItemPos%>' value='<%=rfqItemDlvDate%>'>
		
<%
		if("EDIT".equals(pageType))
		{	
%>
			<%@ include file="ezRFQQuoteItemsEdit.jsp" %>		
<%
		}
		if("DISPLAY".equals(pageType))
		{
%>
			<%@ include file="ezRFQQuoteItemsDisplay.jsp" %>	
<%
		}
	}
%>