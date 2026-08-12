<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@include file="../../../Includes/Jsps/Request/iAuctionHistoryBySupplier.jsp" %>

<%	
	
	out.println("<?xml version=\"1.0\"?>");
	out.println("<rows>");
	if(supplierCode!=null && !supplierCode.equals("¥"))
	{
	   if(historyCount>0)
 	    {
	
		for(int i=0;i<historyCount;i++)
		{

			out.println("<row id='"+history.getFieldValueString(i,"AUCTION_ID")+"'><cell><![CDATA[<nobr><a href='../Request/ezAuctionHistoryDetails.jsp?auctionId="+history.getFieldValueString(i,"AUCTION_ID")+"&amp;supplierId="+history.getFieldValueString(i,"SUPPLIER_ID")+"&amp;auctionName="+history.getFieldValueString(i,"AUCTION_NAME")+"'>"+history.getFieldValueString(i,"AUCTION_ID")+"</a></nobr>]]></cell><cell>"+history.getFieldValueString(i,"AUCTION_NAME")+"</cell></row>");
		
		} 
		
	     }
	     else
	     {
	     	noDataStatement="There are no auctions to list to view History";
	     }
	}
	else
	{
		noDataStatement	="Please Select Supplier to View History";	
	}
	
   out.println("</rows>");
%>