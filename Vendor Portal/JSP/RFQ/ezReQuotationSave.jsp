<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="ezc.vendorprofile.params.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>

<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull1(String str)
	 {
		if("null".equals(str) ||str==null)
		str="NA";
		return str;
 	}
	private String checkNull_Num(String str)
	 {
		if("null".equals(str) ||str==null || "".equals(str))
			str="0";
		
		return str;
 	} 	
%>

<%
String comments  	 = checkNull(request.getParameter("comments"));
comments=comments.replaceAll("'","`");
	String saveRequestFrom  = checkNull(request.getParameter("saveRequestFrom"));
	String rfqNumber 	= checkNull(request.getParameter("rfqNumber"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));
	String rfqSysKey 	= checkNull(request.getParameter("rfqSysKey"));
	String quoteHistoryMaxCount = checkNull_Num(request.getParameter("quoteHistoryMaxCount"));
	
	try{
	quoteHistoryMaxCount=(Integer.parseInt(quoteHistoryMaxCount)+1)+"";
	}catch(Exception e){}
	
	String tempDispMsg      = "ReQuotation";
	
	
	String quoteRefNo 	= checkNull(request.getParameter("quoteRefNo"));
	String priceValidUpto 	= checkNull(request.getParameter("priceValidUpto"));
	String quotationDate 	= checkNull(request.getParameter("quotationDate"));
	String rfqPayTerms	= checkNull(request.getParameter("rfqPayTerms"));
	String rfqIncoTerms1	= checkNull(request.getParameter("rfqIncoTerms1"));
	String rfqIncoTerms2	= checkNull(request.getParameter("rfqIncoTerms2"));
	String rfqDelvPeriod	= checkNull(request.getParameter("rfqDelvPeriod"));
	String rfqGrtyPeriod	= checkNull(request.getParameter("rfqGrtyPeriod"));	
	String applTax		= checkNull(request.getParameter("applTax"));
	
	String rfqItems[]	= request.getParameterValues("rfqItem");	
	int rfqItemsCnt = 0;
	
	if(rfqItems!=null)
		rfqItemsCnt = rfqItems.length;
	
	boolean statusSuccess = false;
	String dispMessage="Problem occured in submitting requotation details",dispMsgType="E",divWidth="90%";
	
	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	EzRFQQuoteHistoryTable 	rfqQuoteHistoryTable 	= new EzRFQQuoteHistoryTable();
	
	EziRFQHeaderTableRow 	rfqHeaderRow 	= null;
	EziRFQDetailsTableRow 	rfqDetailsRow 	= null;	
	EzRFQConditionsTableRow rfqCondTableRow = null;
	EzRFQQuoteHistoryTableRow rfqQuoteHistoryTableRow = null;
	
	rfqHeaderRow = new EziRFQHeaderTableRow();

	rfqHeaderRow.setRFQNo(rfqNumber);
	rfqHeaderRow.setSoldTo(rfqVendor);
	rfqHeaderRow.setStatus("Y");
	rfqHeaderRow.setModifiedBy(Session.getUserId());	
	
	if("NON_SAP_VENDOR".equals(saveRequestFrom))
	{
		rfqHeaderRow.setQuoteRef(quoteRefNo);
		rfqHeaderRow.setQuoteDate(quotationDate);
		rfqHeaderRow.setPriceValDate(priceValidUpto);
		rfqHeaderRow.setDelvPeriod(rfqDelvPeriod);
		rfqHeaderRow.setGuaranteePeriod(rfqGrtyPeriod);
		rfqHeaderRow.setPmntTerms(rfqPayTerms);
		rfqHeaderRow.setIncoTerms1(rfqIncoTerms1);
		rfqHeaderRow.setIncoTerms2(rfqIncoTerms2);
		rfqHeaderRow.setTaxType(applTax);
		
		tempDispMsg      = "Quotation";
		
		dispMessage="Problem occured in submitting "+tempDispMsg+" details";
	}	
	

	rfqHeaderTable.appendRow(rfqHeaderRow);
	
	String rfqItem 		= "";
	String rfqMatCode 	= "";
	String rfqMatDesc 	= "";
	String rfqItemUOM 	= "";
	String rfqItemQty 	= "";
	String rfqItemCurr 	= "";
	String itemPrice 	= "";
	String rfqItemDlvDate 	= "";
	String hsnCode		= "";
	String vendHsnCode	= "";
	applTax="";

	for(int h=0;h<rfqItemsCnt;h++)
	{
		rfqItem 	= rfqItems[h];
		
		rfqMatCode 	= checkNull(request.getParameter("rfqMatCode"+rfqItem));
		rfqMatDesc 	= checkNull(request.getParameter("rfqMatDesc"+rfqItem));
		rfqItemUOM 	= checkNull(request.getParameter("rfqItemUOM"+rfqItem));
		rfqItemQty 	= checkNull(request.getParameter("rfqItemQty"+rfqItem));
		rfqItemCurr 	= checkNull(request.getParameter("rfqItemCurr"+rfqItem));
		itemPrice 	= checkNull(request.getParameter("itemPrice"+rfqItem));
		rfqItemDlvDate 	= checkNull(request.getParameter("rfqItemDlvDate"+rfqItem));
		hsnCode 	= checkNull(request.getParameter("hsnCode"+rfqItem));
		vendHsnCode	= checkNull(request.getParameter("vndrHSNCode"+rfqItem));
		applTax		= checkNull(request.getParameter("applTax"+rfqItem));
	
		rfqDetailsRow = new EziRFQDetailsTableRow();
		
		rfqDetailsRow.setRFQNo(rfqNumber);
		rfqDetailsRow.setLineNo(rfqItem);
		rfqDetailsRow.setCounter("1");
		
		if("NON_SAP_VENDOR".equals(saveRequestFrom))
		{
			rfqDetailsRow.setPrice(itemPrice);
			rfqDetailsRow.setVendMatHSNCode(vendHsnCode);
		}	
			
		rfqDetailsRow.setNegPrice(itemPrice);
		rfqDetailsRow.setMatHSNCode(hsnCode);
		rfqDetailsRow.setExt2(applTax);
		rfqDetailsTable.appendRow(rfqDetailsRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("1");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemDISCTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrDISC"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("2");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemPKFWTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemFinalTotVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("3");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemCGSTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemCGSTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemCGSTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemCGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrCGST"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("4");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemSGSTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemSGSTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemSGSTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemSGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrSGST"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("5");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemIGSTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemIGSTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemIGSTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemIGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrIGST"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("6");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemUGSTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemUGSTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemUGSTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemUGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrUGST"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("7");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemFRTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemFRTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemFRTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrFRT"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setSeqNo("8");
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTGSTCode"+rfqItem)));
		//if("NON_SAP_VENDOR".equals(saveRequestFrom))
			rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemFRTGSTVal"+rfqItem)));
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemFRTGSTVal"+rfqItem)));
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemFRTGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrFRTGST"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemDISCVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemDISCTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrDISC"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("1");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);


		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemPKFWTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemFinalTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("2");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);		

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemCGSTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemCGSTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeCGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemCGSTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrCGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("3");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemSGSTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemSGSTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeSGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemSGSTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrSGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("4");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);


		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemIGSTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemIGSTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeIGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemIGSTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrIGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("5");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemUGSTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemUGSTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeUGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemUGSTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrUGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("6");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemFRTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrFRT"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("7");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);

		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqItem);
		rfqQuoteHistoryTableRow.setCounter(quoteHistoryMaxCount);
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemFRTGSTCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRTGSTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeFRTGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemFRTGSTTotVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("itemTotValAftrFRTGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(applTax);
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("8");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");		
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);		

	
	}
	
	ezparams.setLocalStore("Y");
	ezparams.setObject(rfqHeaderTable);
	ezparams.setObject(rfqDetailsTable);
	ezparams.setObject(rfqCondTable);
	ezparams.setObject(rfqQuoteHistoryTable);
	Session.prepareParams(ezparams);
	
	try
	{
		ReturnObjFromRetrieve statusRet = (ReturnObjFromRetrieve)rfqManager.ezUpdateRFQ(ezparams);
		
		if(!statusRet.isError())
		{
			statusSuccess = true;
			dispMessage= tempDispMsg+" Submitted  Successfully.";
			dispMsgType="S";
		}	
			
		
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Error while saving Quotation in DB"+e,"I");
	}
	
	
	if(statusSuccess)
	{
		String docNumber = rfqNumber;
		
ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_DOCUMENT_COMMENTS");
		mainParams.setLocalStore("Y");

		documentComments.setDocId(rfqNumber);
		documentComments.setDocType("RFQ");
		documentComments.setComments(comments);
		documentComments.setUserId((String)Session.getUserId());
		documentComments.setExt1("");
		documentComments.setExt2("");
		documentComments.setExt3("");

		mainParams.setObject(keyParams);	
		mainParams.setObject(documentComments);
		Session.prepareParams(mainParams);

		try{
			ezc.ezcommon.EzLog4j.log(":::::Before save documentComments:::::","I");
			vendorprofile.ezSaveDetails(mainParams);
			ezc.ezcommon.EzLog4j.log(":::::After save documentComments:::::","I");
		}catch(Exception e){}
		
%>
		<%@ include file="ezSaveUploadDocs.jsp"%> 
		if(!"2".equals(userType))
<%
		String msgSubject 	= "Quotation for RFQ "+rfqNumber+" posted by Vendor : "+(String)session.getValue("Vendor");
		String eMailData	= "Quotation is posted for the below RFQ. <Br>"+rfqNumber;
		String toEMailIds 	= "";
		String ccEMailIds 	= "";

		java.util.Vector mobileNoVect = new java.util.Vector();
		
		java.util.Hashtable  purOrgsHash = null;
		String eMailType = "PURORG_USER";
		String eMailValue = "";
		if(session.getValue("PURORGS")!=null)
		{
			purOrgsHash = (Hashtable) session.getValue("PURORGS");
			eMailValue = (String)purOrgsHash.get(rfqSysKey);
		}	
%>
		<%@ include file="../Misc/ezGetIntUserEMail.jsp" %>
<%
		ezc.ezcommon.EzLog4j.log("RE-QUOTATION -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");
%>
		<%@ include file="../Misc/ezSendExternalMail.jsp" %>

<%
	}
	
	String display_header = tempDispMsg+" Submission Status";
%>

<html>
<head>
<%@ include file="../Misc/ezHeader.jsp"%> 
<script>
	function funOK()
	{
		location.href="../Misc/ezWelcome_New.jsp";
	}
</script>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="funOK()">Ok</button>  &nbsp;	
</center>

<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
 
