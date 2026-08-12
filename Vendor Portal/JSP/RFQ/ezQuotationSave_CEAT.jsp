<%@ page import ="ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %> 
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>   
<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
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
	EzcParams ezparams=new EzcParams(true);
	EzShipmentManager shManager=new EzShipmentManager();
	
	String rfqNumber 	= checkNull(request.getParameter("RfqNo"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));
	String rfqBuyer		= checkNull(request.getParameter("rfqBuyer"));
	String QtnDt 		= checkNull(request.getParameter("QtnDate"));
	String rfqPmntTms 	= checkNull(request.getParameter("PaymentTerms"));
	String rfqIncoTms1 	= checkNull(request.getParameter("IncoTerms"));
	String rfqIncoTms2 	= checkNull(request.getParameter("IncoTermsLoc"));
	String Comments 	= checkNull(request.getParameter("Comments"));
	Comments=Comments.replaceAll("'","`");
	Comments = Comments.trim();
	
	String retMsg 		= "Quotation Posted Successfully in Portal";
	
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;	

	int j=0;
	Date fromDate = new Date();
	fromDate.setDate(Integer.parseInt(QtnDt.substring(0,2)));
	fromDate.setMonth(Integer.parseInt(QtnDt.substring(3,5))-1);
	fromDate.setYear(Integer.parseInt(QtnDt.substring(6,10))-1900);
	
	String rfqItems[]	= request.getParameterValues("rfqItem");	
	int rfqItemsCnt = 0;
	
	if(rfqItems!=null)
		rfqItemsCnt = rfqItems.length;	
	ezc.ezcommon.EzLog4j.log("****=rfqItems.length=====**"+rfqItems.length,"I");		
	
	
	/***********Added to update status to Y if quoted***********/
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
	updateezirfqheadertablerow.setStatus("P"); 
	updateezirfqheadertablerow.setPmntTerms(rfqPmntTms); 
	updateezirfqheadertablerow.setIncoTerms1(rfqIncoTms1);
	updateezirfqheadertablerow.setIncoTerms2(rfqIncoTms2);
	updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
	//updateezirfqheadertablerow.setExt2(gv_VendCat); 
	updateezirfqheadertablerow.setExt2(""); 
	updateezirfqheadertable.appendRow(updateezirfqheadertablerow);
	
	
	
	String rfqItem 		= "";
	String rfqLineItem	= "";
	String rfqItemCat	= "";
	String rfqItemCurr 	= "";
	String itemPrice 	= "";
	String leaddays 	= "";
	String sapHSNCode	= "",vendHSNCode="";
	String SAPGST= "",vendGST="";

	String rfqPlant="";
	String rfqPr="";
	String rfqPrItem="";
	String rfqMat="";
	String rfqMatDesc="";	
	String rfqItemQty="";
	String rfqUom="";
	String rfqDelDt="";
	
	//RFQ EMAIL

	Hashtable<String,String> plantHT = getPlants(Session); 	 
	
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

	String eMailData="",eMailDataComm="";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ceat PR Reference</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
	eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
	eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
	eMailData +=  "</Tr>";	
	
	
	for (int i=0 ; i < rfqItemsCnt ; i++)
	{
		rfqItem 	= rfqItems[i];
		rfqLineItem	= checkNull(request.getParameter("rfqLineItem"+rfqItem));
		rfqItemCat	= checkNull(request.getParameter("itemCat"+rfqItem));
		rfqItemCurr 	= checkNull(request.getParameter("rfqItemCurr"+rfqItem));
		ezc.ezcommon.EzLog4j.log("rfqItemCurr Loop"+i,"I"); 
		ezc.ezcommon.EzLog4j.log("rfqItemCurr"+rfqItemCurr,"I"); 
		itemPrice 	= checkNull(request.getParameter("itemPrice"+rfqItem));
		leaddays 	= checkNull(request.getParameter("leaddays"+rfqItem));
		sapHSNCode	= checkNull(request.getParameter("SAPHSNCODE"+rfqItem));
		vendHSNCode	= checkNull(request.getParameter("vendHSNGST"+rfqItem));
		SAPGST	= checkNull(request.getParameter("SAPGST"+rfqItem));
		vendGST	= checkNull(request.getParameter("vendGST"+rfqItem));
		
		
		rfqPlant	= checkNull(request.getParameter("plant"+rfqItem));
		rfqPr		= checkNull(request.getParameter("pr"+rfqItem));
		rfqPrItem 	= checkNull(request.getParameter("prItem"+rfqItem));
		rfqMat		= checkNull(request.getParameter("mat"+rfqItem));
		rfqMatDesc	= checkNull(request.getParameter("matDesc"+rfqItem));	
		rfqItemQty	= checkNull(request.getParameter("rfqItemQty"+rfqItem));
		rfqUom  	= checkNull(request.getParameter("uom"+rfqItem));
		rfqDelDt	= checkNull(request.getParameter("delDate"+rfqItem));
		
		
		ezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();
		
		ezirfqqtystablerow.setRemarks(Comments+"', ERD_PRICE='"+itemPrice+"',ERD_CURRENCY='"+rfqItemCurr+"',ERD_LEAD_DAYS='"+leaddays+"',ERD_SAP_HSN_CODE='"+sapHSNCode+"', ERD_VEND_HSN_CODE='"+vendHSNCode+"', ERD_SAP_GST='"+SAPGST+"',ERD_VEND_GST='"+vendGST);
		ezirfqqtystablerow.setRFQNo(rfqNumber);
		ezirfqqtystablerow.setItmNo(rfqLineItem);
		ezirfqqtystable.appendRow(ezirfqqtystablerow);	
		
		
		if("D".equals(rfqItemCat))
		{
			String qryRfq = "";
			String serLines[] = request.getParameter("serLine"+rfqLineItem).split("##");
			String serSAC[]   = request.getParameter("serSAC"+rfqLineItem).split("##");
			String serGST[]   = request.getParameter("serGST"+rfqLineItem).split("##");
			String serPrice[] = request.getParameter("serPrice"+rfqLineItem).split("##");
			String serQty[]   = request.getParameter("serQty"+rfqLineItem).split("##");
			
			int serLinesCnt = 0;
			
			if(serLines!=null)
				serLinesCnt = serLines.length;	
			ezc.ezcommon.EzLog4j.log("****=serLinesCnt**"+serLines.length,"I");

			for(int r=0;r<serLinesCnt;r++)
			{			
			
				ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
				ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();

				qryRfq = "UPDATE EZC_RFQ_SERVICES SET ERS_SRV_CURR='"+rfqItemCurr+"',ERS_SRV_PRICE='"+serPrice[r]+"',ERS_SRV_SAC='"+serSAC[r]+"',ERS_SRV_GST='"+serGST[r]+"' WHERE ERS_SRV_RFQ='"+rfqNumber+"' AND ERS_SRV_RFQ_ITEM='"+rfqLineItem+"' AND ERS_SRV_LINE='"+serLines[r]+"'";
				qcfTableRow.setQuery(qryRfq);
				qcfTable.appendRow(qcfTableRow);
				
				qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				qcfTableRow.setQuery("INSERT INTO EZC_RFQ_SERVICES_HISTORY VALUES('"+rfqNumber+"','"+rfqLineItem+"','"+serLines[r]+"','1','"+serQty[r]+"','"+rfqItemCurr+"','"+serPrice[r]+"','"+serSAC[r]+"','"+serGST[r]+"','','','')");
				qcfTable.appendRow(qcfTableRow);				
				
				qcfParams.setLocalStore("Y");
				qcfParams.setObject(qcfTable);
				Session.prepareParams(qcfParams);

				try
				{
					qcfMgr.ezSaveMiscTransactions(qcfParams);

				}
				catch(Exception e)
				{
					out.println("Exception in Service Insertion>>>>>"+e);
				}
			}	
		}
		
		
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemDISC"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC")));//moved to header level
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTableRow.setSeqNo("1");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemDISC"+rfqItem)));
		rfqCondTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 		
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode")));//moved to header level
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemPKFW")));//moved to header level
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW")));//moved to header level
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemPKFWVal")));//moved to header level
		rfqCondTableRow.setSeqNo("2");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemPKFWVal")));
		rfqCondTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode")));//moved to header level
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRT")));//moved to header level
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT")));//moved to header level
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemFRTVal")));	//moved to header level		
		rfqCondTableRow.setSeqNo("3");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemFRTVal")));
		rfqCondTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemTAXCode")));//moved to header level
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("vendGST"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeTAX")));//moved to header level
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemTAXVal")));//moved to header level		
		rfqCondTableRow.setSeqNo("4");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemTAXVal")));
		rfqCondTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode("LEAD");//moved to header level
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("leaddays"+rfqItem)));
		rfqCondTableRow.setTaxType("");//moved to header level
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1("");
		rfqCondTableRow.setExt2("");
		rfqCondTableRow.setExt3("");//moved to header level		
		rfqCondTableRow.setSeqNo("5");
		rfqCondTableRow.setNegTaxVal("");
		rfqCondTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);		
		
		
		
		
		//QUOTE HISTORY
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemDISC"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC"))); //moved to header level
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemDISCVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("1");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 						
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode")));//moved to header level		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemPKFW")));//moved to header level		
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW")));//moved to header level		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("2");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode")));//moved to header level		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRT")));//moved to header level		
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT")));//moved to header level		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemFRTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("3");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId()); 
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		

		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemTAXCode")));//moved to header level		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("vendGST"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeTAX")));//moved to header level		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemTAXVal")));//moved to header level		
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("4");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode("LEAD");//moved to header level		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("leaddays"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType("");//moved to header level		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("leaddays"+rfqItem)));//moved to header level		
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1("");
		rfqQuoteHistoryTableRow.setExt2("");
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("5");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull_Num(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(checkNull_Num("0.00")); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);		
		
		
		
		eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+plantHT.get(rfqPlant)+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+rfqLineItem+"</Td>";  
		eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
		eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDt+"</Td>"; 
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+QtnDt+"</Td>";
		eMailData +=  "</Tr>";
	}
	eMailData +=  "</Table><Br>";
	updateRFQParams.setLocalStore("Y"); 
	updateRFQParams.setObject(updateezirfqheadertable); 
	updateRFQParams.setObject(ezirfqqtystable);
	updateRFQParams.setObject(rfqCondTable);
	updateRFQParams.setObject(rfqQuoteHistoryTable);		
	Session.prepareParams(updateRFQParams);
	ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I"); 
	Manager.ezUpdateRFQ(updateRFQParams); 
	ezc.ezcommon.EzLog4j.log("****==After Update RFQ Details=====**","I");

	//DOC COMMENTS
	if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0) 
	{
		saveDocComments(Session,rfqNumber,"RFQ",Comments); 
		eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
	}
		lineAttachString = request.getParameterValues("fileItem");
		ezc.ezcommon.EzLog4j.log("rfqNumber>>>>>"+rfqNumber,"I");  
		ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I");  
		if(lineAttachString != null)
		{ 
			objNo 		= rfqNumber;
			documentType 	= "RFQ"; 
%>	
			<%@ include file="../UploadFiles/ezSaveQuoteAttach.jsp" %>  	
<%				
						
		}
%>					
			<%@ include file="ezSendPostQuoteMail.jsp" %> 
<%	
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);
%>
