<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezbasicutil.*,java.text.*,java.math.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../Misc/ezDefaultDate.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %> 
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*,java.nio.file.*" %>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>  
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	EzcParams ezparams=new EzcParams(true);
	EzShipmentManager shManager=new EzShipmentManager();
	
	String rfqNumber 	= checkNull(request.getParameter("RfqNo"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));
	String rfqBuyer		= checkNull(request.getParameter("rfqBuyer"));
	String rfqType		= checkNull(request.getParameter("rfqType"));
	String QtnDt 		= checkNull(request.getParameter("QtnDate"));
	String rfqPmntTms 	= checkNull(request.getParameter("PaymentTerms"));
	String rfqIncoTms1 	= checkNull(request.getParameter("IncoTerms"));
	String ldStatus		= checkNull(request.getParameter("ldApp"));
	String ldClause		= checkNull(request.getParameter("ldTxt"));
	String pgStatus		= checkNull(request.getParameter("pgApp"));
	String pgClause 	= checkNull(request.getParameter("pgTxt"));
	String Comments 	= checkNull(request.getParameter("Comments"));
	Comments=Comments.replaceAll("'","`");
	Comments = Comments.trim();
	
	String userType=(String)session.getValue("UserType"); 
	String headCurr=checkNull(request.getParameter("headCurr"));
	ezc.ezcommon.EzLog4j.log("****headCurr=====**"+headCurr,"I");
	
	//GET EXCHANGE RATE
	
		ezc.ezcommon.EzLog4j.log("exchRateNew Enter:::::::::::::::","I");
		String exchRate="0.00";;

		
		String toDtStr="";
		java.util.Date toDelDate = null;
		Calendar cal = Calendar.getInstance();
		Date toDateObj = cal.getTime();
		toDtStr = convertDateObjToString(toDateObj);	
		toDelDate = convertStringToDateObj(toDtStr);
		
		ezc.ezcommon.EzLog4j.log("toDelDate:::::::::::::::"+toDelDate,"I");
		
		JCoFunction function =null;	
		String logonSite = (String)session.getValue("SITE");	
		
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
		function = EzSAPHandler.getJCoFunction(destination,"BAPI_EXCHRATE_GETCURRENTRATES");	
		
		JCoParameterList sapPreProc = function.getImportParameterList();
		JCoParameterList sapTabParam= function.getTableParameterList();	
	
		sapPreProc.setValue("DATE",toDelDate);  //2020-12-10
		sapPreProc.setValue("DATE_TYPE","V");
		sapPreProc.setValue("RATE_TYPE","M");  
		sapPreProc.setValue("SHOW_PROTOCOL","");
		
		ezc.ezcommon.EzLog4j.log("CHK2:::::::::::::::","I");
		
		JCoTable r_fromCurr = sapTabParam.getTable("FROM_CURR_RANGE");	
		r_fromCurr.appendRow();
		r_fromCurr.setValue("SIGN","I");
		r_fromCurr.setValue("OPTION","EQ");
		r_fromCurr.setValue("LOW",headCurr);
		r_fromCurr.setValue("HIGH","");
		
		ezc.ezcommon.EzLog4j.log("CHK3:::::::::::::::","I");
		
		JCoTable r_toCurr = sapTabParam.getTable("TO_CURRNCY_RANGE");
		r_toCurr.appendRow();
		r_toCurr.setValue("SIGN","I");
		r_toCurr.setValue("OPTION","EQ");
		r_toCurr.setValue("LOW","INR");
		r_toCurr.setValue("HIGH","");
		
		ezc.ezcommon.EzLog4j.log("CHK4:::::::::::::::","I");
			
		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in BAPI_EXCHRATE_GETCURRENTRATES FM Exectution:::::::::::::::"+qe,"I");
		}	
	
		int exchCnt =0;
		
		JCoTable exchList = function.getTableParameterList().getTable("EXCH_RATE_LIST");
		exchCnt = exchList.getNumRows();
		
		if(exchCnt>0)
		{
		
			try
			{
				ezc.ezcommon.EzLog4j.log("EXCH_RATE155:::::::::::::::"+exchList.getValue("EXCH_RATE"),"I");
				ezc.ezcommon.EzLog4j.log("FROM_FACTOR55:::::::::::::::"+exchList.getValue("FROM_FACTOR"),"I");
				BigDecimal exRateBD=(java.math.BigDecimal)exchList.getValue("EXCH_RATE");
				BigDecimal fromFactBD=(java.math.BigDecimal)exchList.getValue("FROM_FACTOR");
				ezc.ezcommon.EzLog4j.log("FROM_FACTOR66:::::::::::::::"+exchList.getValue("FROM_FACTOR"),"I");
				BigDecimal calExRate= exRateBD.divide(fromFactBD,2,RoundingMode.FLOOR);
				exchRate = calExRate +"";
				
			}
			catch (Exception e) {
				ezc.ezcommon.EzLog4j.log("Error in exchRateNew44:::::::::::::::"+e,"I");
				exchRate="0.00";
			}
		}
	
	
	
	
	String retMsg 		= "Quotation Posted Successfully in Portal";
	
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;	

	//int j=0;
	Date fromDate1 = new Date();
	fromDate1.setDate(Integer.parseInt(QtnDt.substring(0,2)));
	fromDate1.setMonth(Integer.parseInt(QtnDt.substring(3,5))-1);
	fromDate1.setYear(Integer.parseInt(QtnDt.substring(6,10))-1900);
	
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
	updateezirfqheadertablerow.setIncoTerms1(rfqIncoTms1+"',ERH_LD_STATUS='"+ldStatus+"',ERH_LD_CLAUSE='"+ldClause+"',ERH_PG_STATUS='"+pgStatus+"',ERH_PG_CLAUSE='"+pgClause+"',ERH_SAVE_FLG='"+userType); 
	updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
	//updateezirfqheadertablerow.setExt2(gv_VendCat); 
	updateezirfqheadertablerow.setExt2(""); 
	updateezirfqheadertable.appendRow(updateezirfqheadertablerow);
	
	String rfqItem 		= "";
	String rfqLineItem	= "";
	String rfqItemCat	= "";
	String rfqItemCurr 	= "";
	String itemPrice 	= "";
	String itemMRP	 	= "";
	String leaddays 	= "";
	String sapHSNCode	= "",vendHSNCode="";
	String SAPGST= "",vendGST="",warranty="";

	String rfqPlant="";
	String rfqPr="";
	String rfqPrItem="";
	String rfqMat="";
	String rfqMatDesc="";	
	String rfqItemQty="";
	String rfqUom="";
	String rfqDelDt="";
	String rfqItemVal="";
	
	//RFQ EMAIL

	Hashtable<String,String> plantHT = getPlants(Session); 	 
	
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

	String eMailData="",eMailTerms="",eMailDataComm="";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ref. PR</B></Th>";
	eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
	eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Basic Price</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Total Value</B></Th>";
	eMailData +=  "</Tr>";	
	
	
	for (int i=0 ; i < rfqItemsCnt ; i++)
	{
		rfqItem 	= rfqItems[i];
		rfqLineItem	= checkNull(request.getParameter("rfqLineItem"+rfqItem));
		rfqItemCat	= checkNull(request.getParameter("itemCat"+rfqItem));
		rfqItemCurr 	= checkNull(request.getParameter("rfqItemCurr"+rfqItem));
		ezc.ezcommon.EzLog4j.log("****=rfqItemCurr=====**"+rfqItemCurr,"I");		
		itemPrice 	= checkNull_Num(request.getParameter("itemPrice"+rfqItem));
		itemMRP		= checkNull_Num(request.getParameter("itemMRP"+rfqItem));
		leaddays 	= checkNull(request.getParameter("leaddays"+rfqItem));
		sapHSNCode	= checkNull(request.getParameter("SAPHSNCODE"+rfqItem));
		vendHSNCode	= checkNull(request.getParameter("vendHSNGST"+rfqItem));
		SAPGST		= checkNull(request.getParameter("SAPGST"+rfqItem));
		vendGST		= checkNull(request.getParameter("vendGST"+rfqItem));
		warranty	= checkNull(request.getParameter("warranty"+rfqItem));
		
		
		rfqPlant	= checkNull(request.getParameter("plant"+rfqItem));
		rfqPr		= checkNull(request.getParameter("pr"+rfqItem));
		rfqPrItem 	= checkNull(request.getParameter("prItem"+rfqItem));
		rfqMat		= checkNull(request.getParameter("mat"+rfqItem));
		rfqMatDesc	= checkNull(request.getParameter("matDesc"+rfqItem));	
		rfqItemQty	= checkNull(request.getParameter("rfqItemQty"+rfqItem));
		rfqUom  	= checkNull(request.getParameter("uom"+rfqItem));
		rfqDelDt	= checkNull(request.getParameter("delDate"+rfqItem));
		rfqItemVal	= checkNull(request.getParameter("itemValue"+rfqItem));
		
		
		ezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();
		
		ezirfqqtystablerow.setRemarks(Comments+"', ERD_MRP_PRICE='"+itemMRP+"', ERD_PRICE='"+itemPrice+"', ERD_CURRENCY='"+rfqItemCurr+"',ERD_EXCH_RATE='"+checkNull_Num(exchRate)+"', ERD_LEAD_DAYS='"+leaddays+"',ERD_SAP_HSN_CODE='"+sapHSNCode+"', ERD_VEND_HSN_CODE='"+vendHSNCode+"', ERD_SAP_GST='"+SAPGST+"',ERD_VEND_GST='"+vendGST+"', ERD_WARRANTY='"+warranty);
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

				//qryRfq = "UPDATE EZC_RFQ_SERVICES SET ERS_SRV_PRICE='"+serPrice[r]+"',ERS_SRV_SAC='"+serSAC[r]+"',ERS_SRV_GST='"+serGST[r]+"' WHERE ERS_SRV_RFQ='"+rfqNumber+"' AND ERS_SRV_RFQ_ITEM='"+rfqLineItem+"' AND ERS_SRV_LINE='"+serLines[r]+"'";
				qryRfq = "UPDATE EZC_RFQ_SERVICES SET ERS_SRV_CURR='"+rfqItemCurr+"',ERS_SRV_PRICE='"+serPrice[r]+"' WHERE ERS_SRV_RFQ='"+rfqNumber+"' AND ERS_SRV_RFQ_ITEM='"+rfqLineItem+"' AND ERS_SRV_LINE='"+serLines[r]+"'";
				qcfTableRow.setQuery(qryRfq);
				qcfTable.appendRow(qcfTableRow);
				
				qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				qcfTableRow.setQuery("INSERT INTO EZC_RFQ_SERVICES_HISTORY VALUES('"+rfqNumber+"','"+rfqLineItem+"','"+serLines[r]+"','1','"+serQty[r]+"','"+rfqItemCurr+"','"+serPrice[r]+"','','','','','')");
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
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemDISCVal"+rfqItem)));
		rfqCondTableRow.setSeqNo("1");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemDISC"+rfqItem)));
		rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(exchRate); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 		
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemPKFW"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTableRow.setSeqNo("2");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(exchRate); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);
		
		rfqCondTableRow = new EzRFQConditionsTableRow();
		rfqCondTableRow.setVendor(rfqVendor);
		rfqCondTableRow.setRfqNo(rfqNumber);
		rfqCondTableRow.setRfqLineNo(rfqLineItem);
		rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode"+rfqItem)));
		rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRT"+rfqItem)));
		rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT"+rfqItem)));
		rfqCondTableRow.setCForm("");
		rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemFRTVal"+rfqItem)));			
		rfqCondTableRow.setSeqNo("3");
		rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemFRTVal"+rfqItem)));
		rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqCondTableRow.setExchRate(exchRate); 
		rfqCondTableRow.setCondVendor(rfqVendor); 
		rfqCondTableRow.setExt4(""); 
		rfqCondTableRow.setExt5(""); 				
		rfqCondTable.appendRow(rfqCondTableRow);
		
		if("DOM".equals(rfqType))
		{
		
			rfqCondTableRow = new EzRFQConditionsTableRow();
			rfqCondTableRow.setVendor(rfqVendor);
			rfqCondTableRow.setRfqNo(rfqNumber);
			rfqCondTableRow.setRfqLineNo(rfqLineItem);
			rfqCondTableRow.setTaxCode(checkNull(request.getParameter("itemTAXCode"+rfqItem)));
			rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemTAX"+rfqItem)));
			rfqCondTableRow.setTaxType(checkNull(request.getParameter("valTypeTAX"+rfqItem)));
			rfqCondTableRow.setCForm("");
			rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemTAXVal"+rfqItem)));		
			rfqCondTableRow.setSeqNo("4");
			rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemTAXVal"+rfqItem)));
			rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqCondTableRow.setExchRate(exchRate); 
			rfqCondTableRow.setCondVendor(rfqVendor); 
			rfqCondTableRow.setExt4(""); 
			rfqCondTableRow.setExt5(""); 				
			rfqCondTable.appendRow(rfqCondTableRow);
		}	
		
		//OTHERS
		
		if("IMP".equals(rfqType))
		{
		
			rfqCondTableRow = new EzRFQConditionsTableRow();
			rfqCondTableRow.setVendor(rfqVendor);
			rfqCondTableRow.setRfqNo(rfqNumber);
			rfqCondTableRow.setRfqLineNo(rfqLineItem);
			rfqCondTableRow.setTaxCode("OTH");
			rfqCondTableRow.setTaxValue(checkNull_Num(request.getParameter("itemOTH"+rfqItem)));
			rfqCondTableRow.setTaxType("V");
			rfqCondTableRow.setCForm("");
			rfqCondTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqCondTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqCondTableRow.setExt3(checkNull_Num(request.getParameter("itemOTHVal"+rfqItem)));		
			rfqCondTableRow.setSeqNo("4");
			rfqCondTableRow.setNegTaxVal(checkNull_Num(request.getParameter("itemOTHVal"+rfqItem)));
			rfqCondTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqCondTableRow.setExchRate(exchRate); 
			rfqCondTableRow.setCondVendor(rfqVendor); 
			rfqCondTableRow.setExt4(""); 
			rfqCondTableRow.setExt5(""); 				
			rfqCondTable.appendRow(rfqCondTableRow);
		
		}
		
		
		//QUOTE HISTORY
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemDISCCode"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemDISC"+rfqItem)));
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeDISC"+rfqItem))); 
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemDISCVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("1");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(exchRate); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 						
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemPKFWCode"+rfqItem)));		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemPKFW"+rfqItem)));		
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypePKFW"+rfqItem)));		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemPKFWVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("2");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(exchRate); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		
		rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
		rfqQuoteHistoryTableRow.setVendor(rfqVendor);
		rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
		rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
		rfqQuoteHistoryTableRow.setCounter("1");
		rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemFRTCode"+rfqItem)));		
		rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemFRT"+rfqItem)));		
		rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeFRT"+rfqItem)));		
		rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemFRTVal"+rfqItem)));
		rfqQuoteHistoryTableRow.setCForm("");
		rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
		rfqQuoteHistoryTableRow.setExt3("");
		rfqQuoteHistoryTableRow.setSeqNo("3");
		rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId()); 
		rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
		rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
		rfqQuoteHistoryTableRow.setExchRate(exchRate); 
		rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
		rfqQuoteHistoryTableRow.setExt4(""); 
		rfqQuoteHistoryTableRow.setExt5(""); 								
		rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		

		if("DOM".equals(rfqType))
		{
		
			rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
			rfqQuoteHistoryTableRow.setVendor(rfqVendor);
			rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
			rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
			rfqQuoteHistoryTableRow.setCounter("1");
			rfqQuoteHistoryTableRow.setTaxCode(checkNull(request.getParameter("itemTAXCode"+rfqItem)));	
			rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("vendGST"+rfqItem)));
			rfqQuoteHistoryTableRow.setTaxType(checkNull(request.getParameter("valTypeTAX"+rfqItem)));	
			rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemTAXVal"+rfqItem)));		
			rfqQuoteHistoryTableRow.setCForm("");
			rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt3("");
			rfqQuoteHistoryTableRow.setSeqNo("4");
			rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
			rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
			rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqQuoteHistoryTableRow.setExchRate(exchRate); 
			rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
			rfqQuoteHistoryTableRow.setExt4(""); 
			rfqQuoteHistoryTableRow.setExt5(""); 								
			rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);
		}	
		
		if("IMP".equals(rfqType))
		{		
		
			rfqQuoteHistoryTableRow = new EzRFQQuoteHistoryTableRow();
			rfqQuoteHistoryTableRow.setVendor(rfqVendor);
			rfqQuoteHistoryTableRow.setRfqNo(rfqNumber);
			rfqQuoteHistoryTableRow.setRfqLineNo(rfqLineItem);
			rfqQuoteHistoryTableRow.setCounter("1");
			rfqQuoteHistoryTableRow.setTaxCode("OTH");	
			rfqQuoteHistoryTableRow.setTaxValue(checkNull_Num(request.getParameter("itemOTH"+rfqItem)));
			rfqQuoteHistoryTableRow.setTaxType("V");	
			rfqQuoteHistoryTableRow.setCondTotValue(checkNull_Num(request.getParameter("itemOTHVal"+rfqItem)));		
			rfqQuoteHistoryTableRow.setCForm("");
			rfqQuoteHistoryTableRow.setExt1(checkNull_Num(request.getParameter("rfqItemQty"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt2(checkNull_Num(request.getParameter("itemPrice"+rfqItem)));
			rfqQuoteHistoryTableRow.setExt3("");
			rfqQuoteHistoryTableRow.setSeqNo("4");
			rfqQuoteHistoryTableRow.setEnteredBy((String)Session.getUserId());
			rfqQuoteHistoryTableRow.setQuoteFlag("LATEST");
			rfqQuoteHistoryTableRow.setCurrency(checkNull(request.getParameter("rfqItemCurr"+rfqItem))); 
			rfqQuoteHistoryTableRow.setExchRate(exchRate); 
			rfqQuoteHistoryTableRow.setCondVendor(rfqVendor); 
			rfqQuoteHistoryTableRow.setExt4(""); 
			rfqQuoteHistoryTableRow.setExt5(""); 								
			rfqQuoteHistoryTable.appendRow(rfqQuoteHistoryTableRow);		
		}	
		
		eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqLineItem+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+plantHT.get(rfqPlant)+"</Td>";  
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
		eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
		eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+itemPrice+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDt+"</Td>"; 
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqItemVal+"</Td>";
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
	
	eMailTerms=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Payment Terms</B></Th><td>"+rfqPmntTms+"</td></Tr>";
	eMailTerms += "<Tr><Th width= \"10%\" "+thBGColor+"><B>Inco Terms</B></Th><td>"+rfqIncoTms1+"</td></Tr>";
	eMailTerms +="</Table><Br>";		


	//DOC COMMENTS

	if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0)
	{
		Comments = Comments.replaceAll("'","`");   
		Comments = Comments.trim();
		eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+rfqNumber+"','RFQ','"+Comments+"','"+Session.getUserId()+"',now())");
		ezMiscInsert(Session,queriesList);
	}	
	lineAttachString = request.getParameterValues("fileItem");
	ezc.ezcommon.EzLog4j.log("rfqNumber>>>>>"+rfqNumber,"I");  
	ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I");  
	if(lineAttachString != null)
	{ 
			
		objNo 		= rfqNumber;
		documentType 	= "RFQ"; 
			
			
		ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
		//for(int x=0;x<selectedPRsCnt;x++)
		//{
			String fileItemIndex = "H";
			String fileItem[]	= request.getParameterValues("fileItem"); 
			int fileLength = 0;
			if(fileItem != null)
				fileLength = fileItem.length;
				ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

			if(fileLength > 0)
			{
				String subDirPath = "RFQ"+"\\"+rfqNumber+"\\"+fileItemIndex+"\\";
				String dirPath  = serverUpPath+subDirPath;
				String sessionId = session.getId()+"";
				Path path = Paths.get(dirPath);
				Files.createDirectories(path);
				for(int j=0;j<fileItem.length;j++)
				{
					try
					{
						String fileName = fileItem[j];	
						File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
						File notifDestFile = new File(dirPath+fileName);			
						FileInputStream inStream = new FileInputStream(notifSourceFile);
						FileOutputStream outStream = new FileOutputStream(notifDestFile);
						byte[] buffer = new byte[1024];
						int length;
						//copy the file content in bytes 
						while ((length = inStream.read(buffer)) > 0)
						{
							outStream.write(buffer, 0, length);
						}
						inStream.close();
						outStream.close();
						notifSourceFile.delete();		
						ezc.misctransactions.params.EzMiscTableRow miscTableRow2 = new ezc.misctransactions.params.EzMiscTableRow();
						miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+rfqNumber+"','"+fileItemIndex+"','RFQ','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
						miscTable2.appendRow(miscTableRow2);
					}catch(Exception e)
					{

					}
				}
			}
		//}
		mainParams2.setLocalStore("Y");
		mainParams2.setObject(miscTable2);
		Session.prepareParams(mainParams2);
		try
		{
		miscMgr2.ezSaveMiscTransactions(mainParams2);

		}
		catch(Exception e)
		{
		} 				

%>	
		<%//@ include file="../UploadFiles/ezSaveQuoteAttach.jsp" %>  
			
<%				
						
		}
%>					
			<%@ include file="ezSendPostQuoteMail.jsp" %> 
<%	
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);
%>
