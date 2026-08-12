<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
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
%>

<%
	String rfqNumber 	= checkNull(request.getParameter("rfqNumber"));
	String rfqDate 		= checkNull(request.getParameter("rfqDate"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));
	String rfqSysKey 	= checkNull(request.getParameter("rfqSysKey"));
	String quoteRefNo 	= checkNull(request.getParameter("quoteRefNo"));
	String quotationDate 	= checkNull(request.getParameter("quotationDate"));
	String priceValidUpto 	= checkNull(request.getParameter("priceValidUpto"));
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
	String dispMessage="Problem occured in submitting quotation details",dispMsgType="E",divWidth="90%";
	
	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	
	EziRFQHeaderTableRow 	rfqHeaderRow 	= null;
	EziRFQDetailsTableRow 	rfqDetailsRow 	= null;	
	EzRFQConditionsTableRow rfqCondTableRow = null;
	
	
	rfqHeaderRow = new EziRFQHeaderTableRow();

	rfqHeaderRow.setRFQNo(rfqNumber);
	rfqHeaderRow.setSysKey(rfqSysKey);
	rfqHeaderRow.setSoldTo(rfqVendor);
	rfqHeaderRow.setStatus("Y");
	rfqHeaderRow.setModifiedBy(Session.getUserId());			
	rfqHeaderRow.setPriceValDate(priceValidUpto);
	rfqHeaderRow.setQuoteRef(quoteRefNo);
	rfqHeaderRow.setQuoteDate(quotationDate);
	rfqHeaderRow.setQuoteRef(quoteRefNo);
	rfqHeaderRow.setDelvPeriod(rfqDelvPeriod);
	rfqHeaderRow.setGuaranteePeriod(rfqGrtyPeriod);
	rfqHeaderRow.setPmntTerms(rfqPayTerms);
	rfqHeaderRow.setIncoTerms1(rfqIncoTerms1);
	rfqHeaderRow.setIncoTerms2(rfqIncoTerms2);
	rfqHeaderRow.setTaxType(applTax);

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
		hsnCode		= checkNull(request.getParameter("hsnCode"+rfqItem));
		vendHsnCode	= checkNull(request.getParameter("vndrHSNCode"+rfqItem));
	
		rfqDetailsRow = new EziRFQDetailsTableRow();
		
		rfqDetailsRow.setRFQNo(rfqNumber);
		rfqDetailsRow.setLineNo(rfqItem);
		rfqDetailsRow.setCounter("1");
		rfqDetailsRow.setMaterial(rfqMatCode);
		rfqDetailsRow.setMaterialDesc(rfqMatDesc);
		rfqDetailsRow.setUOM(rfqItemUOM);
		rfqDetailsRow.setDeliveryDate(rfqItemDlvDate);
		rfqDetailsRow.setQuantity(rfqItemQty);
		rfqDetailsRow.setPrice(itemPrice);
		rfqDetailsRow.setCurr(rfqItemCurr);		
		rfqDetailsRow.setPlant("");
		rfqDetailsRow.setRemarks("");
		rfqDetailsRow.setExt1("");
		rfqDetailsRow.setExt2("");
		rfqDetailsRow.setExt3("");
		rfqDetailsRow.setExchRate("0");	
		rfqDetailsRow.setNegPrice(itemPrice);
		rfqDetailsRow.setQuoteStatus("");
		rfqDetailsRow.setMatHSNCode(hsnCode);
		rfqDetailsRow.setVendMatHSNCode(vendHsnCode);
		
		rfqDetailsTable.appendRow(rfqDetailsRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemDISCTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrDISC"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("1");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemPKFWTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemFinalTotVal"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("2");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);		
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemCGSTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemCGSTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeCGST"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemCGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrCGST"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("3");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemCGSTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemSGSTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemSGSTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeSGST"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemSGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrSGST"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("4");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemSGSTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemIGSTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemIGSTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeIGST"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemIGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrIGST"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("5");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemIGSTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemUGSTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemUGSTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeUGST"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemUGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrUGST"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("6");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemUGSTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemFRTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemFRTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrFRT"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("7");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemFRTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTGSTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull(request.getParameter("itemFRTGSTVal"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeFRTGST"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull(request.getParameter("itemFRTGSTTotVal"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull(request.getParameter("itemTotValAftrFRTGST"+rfqItem)));
		rfqCondTableRow.setExt3("");
		rfqCondTableRow.setSeqNo("8");
		rfqCondTableRow.setNegTaxVal(checkNull(request.getParameter("itemFRTGSTVal"+rfqItem)));
		rfqCondTable.appendRow(rfqCondTableRow);
		
	}
	
	ezparams.setLocalStore("Y");
	ezparams.setObject(rfqHeaderTable);
	ezparams.setObject(rfqDetailsTable);
	ezparams.setObject(rfqCondTable);
	Session.prepareParams(ezparams);
	
	try
	{
		ReturnObjFromRetrieve statusRet = (ReturnObjFromRetrieve)rfqManager.ezSaveQuote(ezparams);
		
		if(!statusRet.isError())
		{
			statusSuccess = true;
			dispMessage="Quotation Submitted  Successfully.";
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
%>
<%@ include file="ezSaveUploadDocs.jsp"%> 
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
	ezc.ezcommon.EzLog4j.log("QUOTATION -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");
%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	}
	String display_header = "Quotation Submission Status";
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
 
