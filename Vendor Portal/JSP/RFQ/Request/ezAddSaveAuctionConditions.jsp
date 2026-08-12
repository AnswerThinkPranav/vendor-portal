<%!
public java.util.ArrayList<String> addConditions(java.util.ArrayList<String> qryList,String auctionId,String itemId,String supId,String taxCode,String taxValue,String taxType,String ext1,String ext2,String ext3,String seq,String negTaxVal,String cur,String exchRate,String condVendor,String ext4,String ext5)
{	
	qryList.add("INSERT INTO EZC_AUCTION_ITEM_CONDITIONS (EAIC_AUCTION_ID, EAIC_ITEM_ID, EAIC_SUPPLIER_ID, EAIC_TAX_CODE, EAIC_TAX_VALUE, EAIC_TAX_TYPE, EAIC_CFORM, EAIC_EXT1, EAIC_EXT2, EAIC_EXT3, EAIC_SEQ_NO, EAIC_NEG_TAX_VALUE, EAIC_CURRENCY, EAIC_EXCH_RATE, EAIC_COND_VEND, EAIC_EXT4, EAIC_EXT5) VALUES ('"+auctionId+"', '"+itemId+"', '"+supId+"', '"+taxCode+"', '"+taxValue+"', '"+taxType+"', '', '"+ext1+"', '"+ext2+"', '"+ext3+"', '"+seq+"', '"+negTaxVal+"', '"+cur+"', '"+exchRate+"', '"+condVendor+"', '"+ext4+"', '"+ext5+"')");
	return qryList; 
}
%>

<%
	queriesList.add("DELETE FROM EZC_AUCTION_ITEM_CONDITIONS WHERE EAIC_AUCTION_ID='"+auctionId+"'");
	queriesList.add("DELETE FROM EZC_AUCTION_RECOMMENDED_ITEMS WHERE EARI_AUCTION_ID='"+auctionId+"'");
	String [] lineItemId=request.getParameterValues("lineItemId");
	String [] lineSupId=request.getParameterValues("lineSupId");
	if(lineSupId != null && lineSupId.length > 0)
	{
		for(int j=0;j<lineSupId.length;j++)
		{
			String rfqItemPos = lineItemId[j]+"_"+lineSupId[j];
			String rfqItemQty = request.getParameter("rfqItemQty"+rfqItemPos);
			if(rfqItemQty != null && !"".equals(rfqItemQty) && !"".equals(rfqItemQty))
			{
				BigDecimal rfqItemQtyConv=new BigDecimal(rfqItemQty);
				if(rfqItemQtyConv.compareTo(BigDecimal.ZERO) > 0)
				{
					queriesList.add("INSERT INTO EZC_AUCTION_RECOMMENDED_ITEMS (EARI_AUCTION_ID, EARI_SUPPLIER_ID, EARI_ITEM_ID, EARI_PO_QTY, EARI_PO_CR_QTY) VALUES ('"+auctionId+"', '"+lineSupId[j]+"', '"+lineItemId[j]+"',"+rfqItemQtyConv+", 0)");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemDISCCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemDISC"+rfqItemPos)),checkNull_Num(request.getParameter("valTypeDISC"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemDISCVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemPKFWCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemPKFW"+rfqItemPos)),checkNull_Num(request.getParameter("valTypePKFW"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemPKFWVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemFRTCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemFRT"+rfqItemPos)),checkNull_Num(request.getParameter("valTypeFRT"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemFRTVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemBFRTCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemBFRT"+rfqItemPos)),checkNull_Num(request.getParameter("valTypeBFRT"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemBFRTVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemINSCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemINS"+rfqItemPos)),checkNull_Num(request.getParameter("valTypeINS"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemINSVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
					queriesList=addConditions(queriesList,auctionId,lineItemId[j],lineSupId[j],checkNull(request.getParameter("itemTAXCode"+rfqItemPos)),checkNull_Num(request.getParameter("itemTAX"+rfqItemPos)),checkNull_Num(request.getParameter("valTypeTAX"+rfqItemPos)),checkNull_Num(request.getParameter("rfqItemQty"+rfqItemPos)),checkNull_Num(request.getParameter("itemPrice"+rfqItemPos)),checkNull_Num(request.getParameter("itemTAXVal"+rfqItemPos)),"1","",checkNull_Num(request.getParameter("rfqItemCurr"+rfqItemPos)),"0","","","");
				}
			}
		}
	}
	
%>