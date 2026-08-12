<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezbasicutil.*" %> 
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	String rfqNumber=request.getParameter("PurchaseOrder");  
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));
	String QtnEndDt = checkNull(request.getParameter("QtnEndDate"));
	String vendCat=request.getParameter("vendCat");
	String rfqPmntTms 	= checkNull(request.getParameter("PaymentTerms"));
	String rfqIncoTms1 	= checkNull(request.getParameter("IncoTerms"));
	String Comments 	= checkNull(request.getParameter("Comments"));
	
	String [] items = request.getParameterValues("ItemNo");
	String [] prices = request.getParameterValues("Price");
	String [] currs = request.getParameterValues("Curr");
	String [] rfqQty = request.getParameterValues("rfqQty");
	
	//DOMESTIC
	
	java.util.Hashtable condDiscHT = new java.util.Hashtable();
	condDiscHT.put("P","ZR00");
	condDiscHT.put("Q","ZR01");
	condDiscHT.put("V","ZR02");
	
	java.util.Hashtable condPKFWHT = new java.util.Hashtable();
	condPKFWHT.put("P","ZPK1");
	condPKFWHT.put("Q","ZPK3");
	condPKFWHT.put("V","ZPK2");
	
	java.util.Hashtable condFRTHT = new java.util.Hashtable();
	
	condFRTHT.put("P","FRA1");
	condFRTHT.put("Q","FRC1");
	condFRTHT.put("V","FRB1");
	

	JCoFunction function = null;
	String systemKey = (String)session.getValue("SYSKEY");
	String logonSite = (String)session.getValue("SITE");
	
	String retMsg = "Quotation Submitted Succesfully in Portal";
	String outputSts = "S";	

	

		
	//portal
	EzcParams ezparams=new EzcParams(true);
	EzShipmentManager shManager=new EzShipmentManager();


	/***********Added to update status to Y if approved in portal***********/
	//if(!"E".equals(outputSts))	
	//{
		ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
		ezc.ezparam.EzcParams updateRFQParams	= new ezc.ezparam.EzcParams(false);
		
		ezc.ezpreprocurement.params.EziRFQHeaderTable updateezirfqheadertable	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
		ezc.ezpreprocurement.params.EziRFQHeaderTableRow updateezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();
		
		ezc.ezpreprocurement.params.EziRFQItemQtyTable      ezirfqqtystable = new ezc.ezpreprocurement.params.EziRFQItemQtyTable();
		ezc.ezpreprocurement.params.EziRFQItemQtyTableRow   ezirfqqtystablerow =  null;		
		
		ezc.ezpreprocurement.params.EzRFQConditionsTable    rfqCondTable = new ezc.ezpreprocurement.params.EzRFQConditionsTable();
		ezc.ezpreprocurement.params.EzRFQConditionsTableRow rfqCondTableRow =  null;
		
		ezc.ezpreprocurement.params.EzRFQQuoteHistoryTable    rfqQuoteHistoryTable = new ezc.ezpreprocurement.params.EzRFQQuoteHistoryTable();
		ezc.ezpreprocurement.params.EzRFQQuoteHistoryTableRow rfqQuoteHistoryTableRow =  null;					

		updateezirfqheadertablerow.setRFQNo(rfqNumber); 
		updateezirfqheadertablerow.setPmntTerms(rfqPmntTms); 
		updateezirfqheadertablerow.setIncoTerms1(rfqIncoTms1); 
		updateezirfqheadertablerow.setStatus("Y"); 
		updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
		updateezirfqheadertable.appendRow(updateezirfqheadertablerow);
		
		//INSERT BUYER FIELDS
		String rfqItem 		= "";
		String rfqLineItem	= "";
		String itemMRP		= "0.00";
		String itemBudget	= "0.00";
		
		
		for (int i=0 ; i < items.length ; i++)
		{
			rfqItem 	= i+"";
			ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
			rfqLineItem	= checkNull(request.getParameter("rfItemNo"+rfqItem));
			
			itemMRP		= checkNull_Num(request.getParameter("itemMRP"+rfqItem));
			itemBudget	= checkNull_Num(request.getParameter("itemBudget"+rfqItem));
			
			ezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();
			
			ezirfqqtystablerow.setProposeStatus("B',ERD_BUDGET_PRICE='"+itemBudget+"',ERD_MRP_PRICE='"+itemMRP);
			ezirfqqtystablerow.setRFQNo(rfqNumber);
			ezirfqqtystablerow.setItmNo(rfqLineItem);
			ezirfqqtystable.appendRow(ezirfqqtystablerow);				
			

			//BFRT
			rfqCondTableRow = new ezc.ezpreprocurement.params.EzRFQConditionsTableRow();
			rfqCondTableRow.setVendor(rfqVendor);
			rfqCondTableRow.setRfqNo(rfqNumber);
			rfqCondTableRow.setRfqLineNo(rfqLineItem);
			rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemBFRTCode"+rfqItem)));
			rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemBFRT"+rfqItem)));
			rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeBFRT"+rfqItem)));
			rfqCondTableRow.setCForm("");
			rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemBFRTVal"+rfqItem)));			
			rfqCondTableRow.setSeqNo("5");
			rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemBFRTVal"+rfqItem)));
			rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
			rfqCondTableRow.setCondVendor(rfqVendor); 
			rfqCondTableRow.setExt4(""); 
			rfqCondTableRow.setExt5(""); 				
			rfqCondTable.appendRow(rfqCondTableRow);
			
			//INS
			rfqCondTableRow = new ezc.ezpreprocurement.params.EzRFQConditionsTableRow();
			rfqCondTableRow.setVendor(rfqVendor);
			rfqCondTableRow.setRfqNo(rfqNumber);
			rfqCondTableRow.setRfqLineNo(rfqLineItem);
			rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemINSCode"+rfqItem)));
			rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemINS"+rfqItem)));
			rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeINS"+rfqItem)));
			rfqCondTableRow.setCForm("");
			rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemINSVal"+rfqItem)));			
			rfqCondTableRow.setSeqNo("6");
			rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemINSVal"+rfqItem)));
			rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
			rfqCondTableRow.setCondVendor(rfqVendor); 
			rfqCondTableRow.setExt4(""); 
			rfqCondTableRow.setExt5(""); 				
			rfqCondTable.appendRow(rfqCondTableRow);
			
			//QUOTE HISTORY
			rfqQuoteHistoryTableRow = new ezc.ezpreprocurement.params.EzRFQQuoteHistoryTableRow();
			rfqQuoteHistoryTableRow.setVendor(rfqVendor);
			rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
			rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
			rfqQuoteHistoryTableRow.setCounter("1");
			rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemBFRTCode"+rfqItem)));		
			rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemBFRT"+rfqItem)));		
			rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeBFRT"+rfqItem)));		
			rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemBFRTVal"+rfqItem)));
			rfqQuoteHistoryTableRow.setCForm("");
			rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt3("");
			rfqQuoteHistoryTableRow.setSeqNo("5");
			rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId()); 
			rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
			rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
			rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
			rfqQuoteHistoryTableRow.setExt4(""); 
			rfqQuoteHistoryTableRow.setExt5(""); 								
			rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
			rfqQuoteHistoryTableRow = new ezc.ezpreprocurement.params.EzRFQQuoteHistoryTableRow();
			rfqQuoteHistoryTableRow.setVendor(rfqVendor);
			rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
			rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
			rfqQuoteHistoryTableRow.setCounter("1");
			rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemINSCode"+rfqItem)));		
			rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemINS"+rfqItem)));		
			rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeINS"+rfqItem)));		
			rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemINSVal"+rfqItem)));
			rfqQuoteHistoryTableRow.setCForm("");
			rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt3("");
			rfqQuoteHistoryTableRow.setSeqNo("6");
			rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId()); 
			rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
			rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
			rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
			rfqQuoteHistoryTableRow.setExt4(""); 
			rfqQuoteHistoryTableRow.setExt5(""); 								
			rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);		
			
			
		}		
	
		updateRFQParams.setObject(updateezirfqheadertable);
		updateRFQParams.setObject(ezirfqqtystable);
		updateRFQParams.setObject(rfqCondTable);
		updateRFQParams.setObject(rfqQuoteHistoryTable);		
		updateRFQParams.setLocalStore("Y");
		Session.prepareParams(updateRFQParams);
		ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details at Buyer=====**","I");
		Manager.ezUpdateRFQ(updateRFQParams);
		ezc.ezcommon.EzLog4j.log("****==After Update RFQ Details at Buyer=====**","I");	
		
	//}	
	
	//DOC COMMENTS

	if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0)
	{
		Comments = Comments.replaceAll("'","`");   
		Comments = Comments.trim();
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+rfqNumber+"','RFQ','"+Comments+"','"+Session.getUserId()+"',now())");
		ezMiscInsert(Session,queriesList);
	}	

	
%>
	<%//@ include file="ezQuoteApprovalMail.jsp"%> 
	<script>
		location.href="../Shipment/ezMessage.jsp?Msg=<%=retMsg%>";
	</script>
