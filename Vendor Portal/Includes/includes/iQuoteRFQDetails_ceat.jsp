<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%!
	public static HashMap sortByValues(HashMap map) { 
	List list = new LinkedList(map.entrySet());
	// Defined Custom Comparator here
	Collections.sort(list, new Comparator() {
	public int compare(Object o1, Object o2) {
		return ((Comparable) ((Map.Entry) (o1)).getValue()).compareTo(((Map.Entry) (o2)).getValue());
	}
	});
	HashMap sortedHashMap = new LinkedHashMap();
	for (Iterator it = list.iterator(); it.hasNext();) {
	     	Map.Entry entry = (Map.Entry) it.next();
	     	sortedHashMap.put(entry.getKey(), entry.getValue());
	} 
		return sortedHashMap;
	} 
%>       
<%
	Hashtable taxesHT =  new Hashtable();
	taxesHT.put("DISC","Discount");
	taxesHT.put("PKFW","Packing & Forwarding");
	taxesHT.put("FRT","Freight"); 
	taxesHT.put("GST","GST");

	Hashtable hashType = new Hashtable();
	hashType.put("P","%");
	hashType.put("Q","(/Qty)");
	hashType.put("V","(Value)");
	hashType.put("","");
	
	//Reason HT
	Hashtable reasonHT=new 	Hashtable();
	reasonHT.put("SS","Single Source");
	reasonHT.put("OEM","OEM");
	reasonHT.put("OAD","OEM-Authorized Dealer");
	reasonHT.put("SOP","SOP");

	//Downpayment HT
	Hashtable dpHT=new Hashtable();
	dpHT.put("N","No Down Payment");
	dpHT.put("M","Mandatory Down Payment");
	dpHT.put("V","Valuntary Down Payment");
	
	//Retention HT
	Hashtable retentionHT=new Hashtable();
	retentionHT.put("N","Not Applicable");
	retentionHT.put("H","Applicable(Header Level)");
	retentionHT.put("I","Applicable(Item Level)");
	retentionHT.put("B","Secured by Bond");	
	
	String qcfNo	=checkNull(request.getParameter("qcfNo"));
	String fromType =checkNull(request.getParameter("type"));
	String selVendorCode = "";
	String exchRate="0.00";
	String curr="";
	String qryRfq="";
	
	ezc.ezparam.EzcParams quoteParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager quoteMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable quoteTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow quoteTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	ezc.ezparam.ReturnObjFromRetrieve rfqStatObj	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve rfqListObj	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve ItemRet	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve CondRet	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve CondHisRet	  =  null;
	ezc.ezparam.ReturnObjFromRetrieve rfqLinesRet	  =  new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"QCFNO","RFQNO","LINENO","MATERIAL","MATDESC","UOM","QTY","LEADDAYS","CURR","VENDOR","PAYMENTTYPE","LEADTIME","PERCENT","REASON","PURORG","PURGRP","RANK","STATRANK","ITEMTEXT","POTEXT","STATRANKLINENO","HEDDAYS","HEDPER","POTYPE","RETTYPE","RETPER","DPCAT","DPPER","DPAMT","DPDUEDT"});
	ezc.ezparam.ReturnObjFromRetrieve rfqVendLinesRet =  new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"PRDET","SAPHSNCODE","HSNCODE","SAPGSTCODE","GSTCODE","QCFNO","RFQNO","PRNO","PRITEMNO","LINENO","CURR","VENDOR","PRICE","DISCVAL","DISCTYPE","PKFWVAL","PKFWTYPE","FRTVAL","FRTTYPE","FRTCURR","TAXVAL","TAXTYPE","TAXCURR","TAXVEND","LEADVAL","LEADTYPE","BCDVAL","BCDTYPE","BCDCURR","BCDVEND","SWCVAL","SWCTYPE","SWCCURR","SWCVEND","CHAVAL","CHATYPE","CHACURR","CHAVEND","CHA1VAL","CHA1TYPE","CHA1CURR","CHA1VEND","IFRTVAL","IFRTTYPE","IFRTCURR","IFRTVEND","OTHVAL","OTHTYPE","OTHCURR","OTHVEND","DUTYVAL","DUTYTYPE","DUTYCURR","PRICEHIS","DISCHISVAL","DISCHISTYPE","PKFWHISVAL","PKFWHISTYPE","FRTHISVAL","FRTHISTYPE","FRTHISCURR","TAXHISVAL","TAXHISTYPE","TAXHISCURR","TAXHISVEND","LEADHISVAL","LEADHISTYPE","BCDHISVAL","BCDHISTYPE","BCDHISCURR","BCDHISVEND","SWCHISVAL","SWCHISTYPE","SWCHISCURR","SWCHISVEND","CHAHISVAL","CHAHISTYPE","CHAHISCURR","CHAHISVEND","CHA1HISVAL","CHA1HISTYPE","CHA1HISCURR","CHA1HISVEND","IFRTHISVAL","IFRTHISTYPE","IFRTHISCURR","IFRTHISVEND","OTHHISVAL","OTHHISTYPE","OTHHISCURR","OTHHISVEND","DUTYHISVAL","DUTYHISTYPE","DUTYHISCURR","PMNT","INCO","INCOLOC","INCOVER","LEADDAYS","PAYMENTTYPE","LEADTIME","PERCENT","POQTY","EXCHRATE","STATRANK","STATRANKLINENO"});
	
	int rfqStatLen=0;
	int rfqLen=0;
	int CondRetCnt = 0;
	int itemCnt = 0;
	ezc.ezcommon.EzLog4j.log("** fromType>>>"+fromType,"I");
	
	//RFQ STATUS AND FOR CHECKED VENDORS
	if("FromQuote".equals(fromType))
		qryRfq="SELECT ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE  ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
	else
		qryRfq="SELECT ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE ERH_STATUS='S' AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
	
		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

	quoteTableRow.setQuery(qryRfq);
	quoteTable.appendRow(quoteTableRow);
	quoteParams.setLocalStore("Y");
	quoteParams.setObject(quoteTable);
	Session.prepareParams(quoteParams);
	
	try
	{
		rfqStatObj=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting RFQ List>>>>>"+e);
	}	
	ezc.ezcommon.EzLog4j.log("rfqStatObj>>>>"+rfqStatObj.toEzcString(),"I");
	rfqStatLen    	 = rfqStatObj.getRowCount();
	ArrayList chkVen = new ArrayList();
	for(int i=0;i<rfqStatLen;i++) 
	{
		chkVen.add(rfqStatObj.getFieldValueString(i,"ERH_SOLD_TO"));
	}
	
	//RFQ List
	if("FromQuote".equals(fromType))
	qryRfq="SELECT ERH_RFQ_NO,ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE  ERH_STATUS IN ('Y','P','V') AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
	else
	qryRfq="SELECT ERH_RFQ_NO,ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE ERH_STATUS IN ('Y','S') AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
	ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

	quoteTableRow.setQuery(qryRfq);
	quoteTable.appendRow(quoteTableRow);
	quoteParams.setLocalStore("Y");
	quoteParams.setObject(quoteTable);
	Session.prepareParams(quoteParams);
	
	try
	{
		rfqListObj=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting RFQ List>>>>>"+e);
	}	
	
	ezc.ezcommon.EzLog4j.log("rfqListObj>>>>"+rfqListObj.toEzcString(),"I");
	
	rfqLen    = rfqListObj.getRowCount();
	String rfqNo="";
	String soldTo="";
	
	
	if(rfqLen>0)
	{
		  //rfqNo =rfqListObj.getFieldValueString(0,"ERH_RFQ_NO");
		  //soldTo= rfqListObj.getFieldValueString(0,"ERH_SOLD_TO");
	}
	for(int k=0;k<rfqLen;k++)
	{
		rfqNo = rfqListObj.getFieldValueString(k,"ERH_RFQ_NO");
		soldTo= rfqListObj.getFieldValueString(k,"ERH_SOLD_TO");
		//RFQ DETAILS
		qryRfq="SELECT ERH_RFQ_NO,ERH_SOLD_TO,ERH_MODIFIED_ON,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_RFQ_DATE,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_INCO_TERMS2,ERH_INCO_TERMS3,ERH_type ,ERH_LEAD_DAYS ,ERH_PERCENTAGE ,ERH_HED_DAYS,ERH_HED_PER,ERH_PO_TYPE,ERH_RET_TYPE,ERH_RET_PER,ERH_DP_CAT,ERH_DP_PER,ERH_DP_AMT,ERH_DUE_DATE,ERH_REASON,ERH_PUR_ORG,ERH_PUR_GRP,ERH_RANK,ERD_LINE_NO,ERD_MATERIAL,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PO_QTY,ERD_LEAD_DAYS,ERD_CURRENCY,ERD_EXCH_RATE,ERD_PRICE,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_VEND_HSN_CODE,ERD_SAP_HSN_CODE,ERD_VEND_GST,ERD_SAP_GST  FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+rfqNo+"'" ;

		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

		quoteTableRow.setQuery(qryRfq);
		quoteTable.appendRow(quoteTableRow);
		quoteParams.setLocalStore("Y");
		quoteParams.setObject(quoteTable);
		Session.prepareParams(quoteParams);  

		try
		{
			dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		ezc.ezcommon.EzLog4j.log("dtlXML>>>>"+dtlXML.toEzcString(),"I");
		int Count = dtlXML.getRowCount();
		curr=dtlXML.getFieldValueString(0,"ERD_CURRENCY").trim();   //gv_VendCurr.trim();
		exchRate=dtlXML.getFieldValueString(0,"ERD_EXCH_RATE").trim();   //gv_VendCurr.trim();
		//out.println("exchRate>>>"+exchRate);
		//*******************GETTING ITEMS************
		qryRfq="SELECT * FROM EZC_RFQ_DETAILS WHERE erd_rfq_no='"+rfqNo+"'" ;
		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

		quoteTableRow.setQuery(qryRfq);
		quoteTable.appendRow(quoteTableRow);
		quoteParams.setLocalStore("Y");
		quoteParams.setObject(quoteTable);
		Session.prepareParams(quoteParams);


		try
		{
			ItemRet=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting conditions>>>>>"+e);
		}	
				//ezc.ezcommon.EzLog4j.log("CondRet>>>>"+CondRet.toEzcString(),"I");
		 itemCnt = ItemRet.getRowCount();

		//GETTING RFQ CONDITIONS

		qryRfq="SELECT * FROM EZC_RFQ_ITEM_CONDITIONS WHERE ERIC_RFQ_NO='"+rfqNo+"'" ;
		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

		quoteTableRow.setQuery(qryRfq);
		quoteTable.appendRow(quoteTableRow);
		quoteParams.setLocalStore("Y");
		quoteParams.setObject(quoteTable);
		Session.prepareParams(quoteParams);

		try
		{
			CondRet=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting conditions>>>>>"+e);
		}	
		//ezc.ezcommon.EzLog4j.log("CondRet>>>>"+CondRet.toEzcString(),"I");
		int CondCnt = CondRet.getRowCount();
		
		//GETTING RFQ HISTORY

		qryRfq="SELECT * FROM EZC_RFQ_QUOTE_HISTORY WHERE ERQH_RFQ_NO='"+rfqNo+"'"+"AND ERQH_COUNTER='1'";
		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

		quoteTableRow.setQuery(qryRfq);
		quoteTable.appendRow(quoteTableRow);
		quoteParams.setLocalStore("Y");
		quoteParams.setObject(quoteTable);
		Session.prepareParams(quoteParams);

		try
		{
			CondHisRet=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting conditions history>>>>>"+e);
		}	
		ezc.ezcommon.EzLog4j.log("CondHisRet>>>>"+CondHisRet.toEzcString(),"I");
		int CondHisRetCnt = CondHisRet.getRowCount();
		ezc.ezcommon.EzLog4j.log("CondHisRetCnt>>>>"+CondHisRetCnt,"I");

		String rfqNum=null;
		String rfqLineNo=null;
		String rfqVendor=null;
		String condVendor=null;
		String condRfqNo=null;
		String condRfqLineNo=null;
		String condTaxCode=null;
		String condTaxValue=null;
		String condTaxType=null;
		String condHisVendor=null;
		String condHisRfqNo=null;
		String condHisRfqLineNo=null;
		String condHisTaxCode=null;
		String condHisTaxValue=null;
		String condHisTaxType=null;
		String condCurr=null;
		String condVend=null;		
		String condHisPrice=null; 
		String condHisCurr=null; 		
		String condHisVend=null; 		
		String prNO="",prItemNO="";
		String type="",leadTime="",percent="",reasonSel="";

		for(int i=0;i<Count;i++)
		{
			rfqNum= dtlXML.getFieldValueString(i,"ERH_RFQ_NO");
			rfqLineNo= dtlXML.getFieldValueString(i,"ERD_LINE_NO");
			rfqVendor=dtlXML.getFieldValueString(i,"ERH_SOLD_TO");
			prNO=dtlXML.getFieldValueString(i,"ERH_PR_NO");
			prItemNO=dtlXML.getFieldValueString(i,"ERH_PR_ITEM_NO");
			type=dtlXML.getFieldValueString(i,"ERH_type");
			leadTime=dtlXML.getFieldValueString(i,"ERH_LEAD_DAYS");
			percent=dtlXML.getFieldValueString(i,"ERH_PERCENTAGE");
			reasonSel=dtlXML.getFieldValueString(i,"ERH_REASON");
			//out.println("prNO"+prNO);
			if("RFQ".equals(prNO))prNO="NA";
			if("RFQ".equals(prItemNO))prItemNO="Material RFQ";

			rfqLinesRet.setFieldValue("QCFNO",qcfNo);
			rfqLinesRet.setFieldValue("RFQNO",rfqNum);
			rfqLinesRet.setFieldValue("LINENO",rfqLineNo);
			rfqLinesRet.setFieldValue("MATERIAL",dtlXML.getFieldValueString(i,"ERD_MATERIAL"));
			rfqLinesRet.setFieldValue("MATDESC",dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC"));
			rfqLinesRet.setFieldValue("UOM",dtlXML.getFieldValueString(i,"ERD_UOM"));
			rfqLinesRet.setFieldValue("QTY",dtlXML.getFieldValueString(i,"ERD_QUANTITY"));
			rfqLinesRet.setFieldValue("LEADDAYS",dtlXML.getFieldValueString(i,"ERD_LEAD_DAYS"));
			rfqLinesRet.setFieldValue("CURR",dtlXML.getFieldValueString(i,"ERD_CURRENCY"));
			rfqLinesRet.setFieldValue("PAYMENTTYPE",dtlXML.getFieldValueString(i,"ERH_type"));
			rfqLinesRet.setFieldValue("LEADTIME",dtlXML.getFieldValueString(i,"ERH_LEAD_DAYS"));
			rfqLinesRet.setFieldValue("PERCENT",dtlXML.getFieldValueString(i,"ERH_PERCENTAGE"));
			rfqLinesRet.setFieldValue("HEDDAYS",dtlXML.getFieldValueString(i,"ERH_HED_DAYS"));
			rfqLinesRet.setFieldValue("HEDPER",dtlXML.getFieldValueString(i,"ERH_HED_PER"));			
			rfqLinesRet.setFieldValue("POTYPE",dtlXML.getFieldValueString(i,"ERH_PO_TYPE"));			
			rfqLinesRet.setFieldValue("RETTYPE",dtlXML.getFieldValueString(i,"ERH_RET_TYPE"));			
			rfqLinesRet.setFieldValue("RETPER",dtlXML.getFieldValueString(i,"ERH_RET_PER"));			
			rfqLinesRet.setFieldValue("DPCAT",dtlXML.getFieldValueString(i,"ERH_DP_CAT"));			
			rfqLinesRet.setFieldValue("DPPER",dtlXML.getFieldValueString(i,"ERH_DP_PER"));			
			rfqLinesRet.setFieldValue("DPAMT",dtlXML.getFieldValueString(i,"ERH_DP_AMT"));			
			rfqLinesRet.setFieldValue("DPDUEDT",dtlXML.getFieldValueString(i,"ERH_DUE_DATE"));			
			rfqLinesRet.setFieldValue("REASON",dtlXML.getFieldValueString(i,"ERH_REASON"));
			rfqLinesRet.setFieldValue("PURORG",dtlXML.getFieldValueString(i,"ERH_PUR_ORG"));
			rfqLinesRet.setFieldValue("PURGRP",dtlXML.getFieldValueString(i,"ERH_PUR_GRP"));
			rfqLinesRet.setFieldValue("RANK",dtlXML.getFieldValueString(i,"ERH_RANK"));
			rfqLinesRet.setFieldValue("VENDOR",rfqVendor);
			rfqLinesRet.setFieldValue("ITEMTEXT",dtlXML.getFieldValueString(i,"ERD_EXT2"));
			rfqLinesRet.setFieldValue("POTEXT",dtlXML.getFieldValueString(i,"ERD_EXT3"));
			

			rfqVendLinesRet.setFieldValue("QCFNO",qcfNo);
			rfqVendLinesRet.setFieldValue("RFQNO",rfqNum);
			rfqVendLinesRet.setFieldValue("PRNO",prNO);
			rfqVendLinesRet.setFieldValue("PRITEMNO",prItemNO);
			rfqVendLinesRet.setFieldValue("LINENO",rfqLineNo);
			rfqVendLinesRet.setFieldValue("CURR",dtlXML.getFieldValueString(i,"ERD_CURRENCY"));
			rfqVendLinesRet.setFieldValue("EXCHRATE",dtlXML.getFieldValueString(i,"ERD_EXCH_RATE"));
			rfqVendLinesRet.setFieldValue("VENDOR",rfqVendor);
			rfqVendLinesRet.setFieldValue("PRICE",dtlXML.getFieldValueString(i,"ERD_PRICE"));
			rfqVendLinesRet.setFieldValue("LEADDAYS",dtlXML.getFieldValueString(i,"ERD_LEAD_DAYS"));
			rfqVendLinesRet.setFieldValue("PRDET",dtlXML.getFieldValueString(i,"ERD_EXT1"));
			rfqVendLinesRet.setFieldValue("HSNCODE",dtlXML.getFieldValueString(i,"ERD_VEND_HSN_CODE"));
			rfqVendLinesRet.setFieldValue("SAPHSNCODE",dtlXML.getFieldValueString(i,"ERD_SAP_HSN_CODE"));
			rfqVendLinesRet.setFieldValue("SAPGSTCODE",dtlXML.getFieldValueString(i,"ERD_SAP_GST"));
			rfqVendLinesRet.setFieldValue("GSTCODE",dtlXML.getFieldValueString(i,"ERD_VEND_GST"));
			rfqVendLinesRet.setFieldValue("PMNT",dtlXML.getFieldValueString(i,"ERH_PAYMENT_TERMS"));
			rfqVendLinesRet.setFieldValue("INCO",dtlXML.getFieldValueString(i,"ERH_INCO_TERMS1"));
			rfqVendLinesRet.setFieldValue("INCOLOC",dtlXML.getFieldValueString(i,"ERH_INCO_TERMS2"));
			rfqVendLinesRet.setFieldValue("INCOVER",dtlXML.getFieldValueString(i,"ERH_INCO_TERMS3"));
			rfqVendLinesRet.setFieldValue("PAYMENTTYPE",dtlXML.getFieldValueString(i,"ERH_type"));
			rfqVendLinesRet.setFieldValue("LEADTIME",dtlXML.getFieldValueString(i,"ERH_LEAD_DAYS"));
			rfqVendLinesRet.setFieldValue("PERCENT",dtlXML.getFieldValueString(i,"ERH_PERCENTAGE"));
			rfqVendLinesRet.setFieldValue("POQTY",dtlXML.getFieldValueString(i,"ERD_PO_QTY"));


			for(int j=0;j<CondCnt;j++)
			{
				condVendor=CondRet.getFieldValueString(j,"ERIC_VENDOR");
				condRfqNo=CondRet.getFieldValueString(j,"ERIC_RFQ_NO");
				condRfqLineNo=CondRet.getFieldValueString(j,"ERIC_LINE_NO");
				condTaxCode=CondRet.getFieldValueString(j,"ERIC_TAX_CODE");
				condTaxValue=CondRet.getFieldValueString(j,"ERIC_TAX_VALUE");
				condTaxType=CondRet.getFieldValueString(j,"ERIC_TAX_TYPE");
				condCurr=CondRet.getFieldValueString(j,"ERIC_CURRENCY");
				condVend=CondRet.getFieldValueString(j,"ERIC_COND_VEND");				

				if((condVendor.equals(rfqVendor)) && (condRfqNo.equals(rfqNum)) && (condRfqLineNo.equals(rfqLineNo)))
				{
					if("DISC".equals(condTaxCode))
					{
						rfqVendLinesRet.setFieldValue("DISCVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("DISCTYPE",condTaxType);
					}	
					if("PKFW".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("PKFWVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("PKFWTYPE",condTaxType); 
					}
					if("FRT".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("FRTVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("FRTTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("FRTCURR",condCurr);						
					}
					if("TAX".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("TAXVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("TAXTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("TAXCURR",condCurr);
						rfqVendLinesRet.setFieldValue("TAXVEND",condVend);						
					}
					if("LEAD".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("LEADVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("LEADTYPE","D");
					}
					if("BCD".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("BCDVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("BCDTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("BCDCURR",condCurr);
						rfqVendLinesRet.setFieldValue("BCDVEND",condVend);
					}
					if("SWC".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("SWCVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("SWCTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("SWCCURR",condCurr);
						rfqVendLinesRet.setFieldValue("SWCVEND",condVend);
					}				
					if("CHA".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("CHAVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("CHATYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("CHACURR",condCurr);
						rfqVendLinesRet.setFieldValue("CHAVEND",condVend);
					}
					if("CH1".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("CHA1VAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("CHA1TYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("CHA1CURR",condCurr);
						rfqVendLinesRet.setFieldValue("CHA1VEND",condVend);
					}					
					if("IFRT".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("IFRTVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("IFRTTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("IFRTCURR",condCurr);
						rfqVendLinesRet.setFieldValue("IFRTVEND",condVend);
					}
					if("OTH".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("OTHVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("OTHTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("OTHCURR",condCurr);
						rfqVendLinesRet.setFieldValue("OTHVEND",condVend);
					}					
					if("DUTY".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("DUTYVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("DUTYTYPE",condTaxType);
						rfqVendLinesRet.setFieldValue("DUTYCURR",condCurr);
					}									
				}
			}
			for(int m=0;m<CondHisRetCnt;m++)
			{
				condHisVendor=CondHisRet.getFieldValueString(m,"ERQH_VENDOR");
				condHisRfqNo=CondHisRet.getFieldValueString(m,"ERQH_RFQ_NO");
				condHisRfqLineNo=CondHisRet.getFieldValueString(m,"ERQH_LINE_NO");
				condHisTaxCode=CondHisRet.getFieldValueString(m,"ERQH_COND_CODE");
				condHisTaxValue=CondHisRet.getFieldValueString(m,"ERQH_COND_VALUE");
				condHisTaxType=CondHisRet.getFieldValueString(m,"ERQH_COND_TYPE");
				condHisPrice=CondHisRet.getFieldValueString(m,"ERQH_EXT2");
				condHisCurr=CondHisRet.getFieldValueString(m,"EQRH_CURRENCY");
				condHisVend=CondHisRet.getFieldValueString(m,"EQRH_COND_VEND");				
			

				if((condHisVendor.equals(rfqVendor)) && (condHisRfqNo.equals(rfqNum)) && (condHisRfqLineNo.equals(rfqLineNo)))
				{
					
					if("DISC".equals(condHisTaxCode))
					{
						rfqVendLinesRet.setFieldValue("DISCHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("DISCHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("PRICEHIS",condHisPrice);
					}	
					if("PKFW".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("PKFWHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("PKFWHISTYPE",condHisTaxType); 
					}
					if("FRT".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("FRTHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("FRTHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("FRTHISCURR",condHisCurr);
					}
					if("TAX".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("TAXHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("TAXHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("TAXHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("TAXHISVEND",condHisVend);						
					}	
					if("LEAD".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("LEADHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("LEADHISTYPE","D");
					}	
					if("BCD".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("BCDHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("BCDHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("BCDHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("BCDHISVEND",condHisVend);
						ezc.ezcommon.EzLog4j.log("BCDHISVAL>>>>>>>"+condHisTaxValue,"I");
						ezc.ezcommon.EzLog4j.log("BCDHISTYPE>>>>>>>"+condHisTaxType,"I");
					}
					if("SWC".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("SWCHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("SWCHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("SWCHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("SWCHISVEND",condHisVend);
					}				
					if("CHA".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("CHAHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("CHAHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("CHAHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("CHAHISVEND",condHisVend);
					}
					if("CH1".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("CHA1HISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("CHA1HISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("CHA1HISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("CHA1HISVEND",condHisVend);
					}					
					if("IFRT".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("IFRTHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("IFRTHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("IFRTHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("IFRTHISVEND",condHisVend);
					}
					if("OTH".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("OTHHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("OTHHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("OTHHISCURR",condHisCurr);
						rfqVendLinesRet.setFieldValue("OTHHISVEND",condHisVend);
					}					
					if("DUTY".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("DUTYHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("DUTYHISTYPE",condHisTaxType);
						rfqVendLinesRet.setFieldValue("DUTYHISCURR",condHisCurr);
					}					
				}
			}			
			rfqVendLinesRet.addRow();
			rfqLinesRet.addRow();
		}
	}
	

	int rfqLinesRetCnt= rfqLinesRet.getRowCount();
	int rfqVendLinesRetCnt= rfqVendLinesRet.getRowCount();
	ezc.ezcommon.EzLog4j.log("rfqLinesRetCnt>>>>>>>"+rfqLinesRetCnt,"I");
	ezc.ezcommon.EzLog4j.log("rfqVendLinesRetCnt>>>>>>>"+rfqVendLinesRetCnt,"I");
	ezc.ezcommon.EzLog4j.log("rfqLinesRet11>>>>>>>"+rfqLinesRet.toEzcString(),"I");
	ezc.ezcommon.EzLog4j.log("rfqVendLinesRet>>>>>>>"+rfqVendLinesRet.toEzcString(),"I");
	Map<String, Integer> map   = new HashMap<String, Integer>(); 
	for(int r=0;r<rfqLinesRetCnt;r++)
	{
		String key=rfqLinesRet.getFieldValueString(r,"MATERIAL")+"#"+rfqLinesRet.getFieldValueString(r,"VENDOR")+"#"+rfqLinesRet.getFieldValueString(r,"RFQNO");
		String price=rfqVendLinesRet.getFieldValueString(r,"PRICE");
		double d = Double.parseDouble(price);
		int priceInt = (int) d;
		
		map.put(key,priceInt);
	
	}

	/*String minKey = "";//Collections.min(map.keySet()); 
	String maxKey = "";//Collections.max(map.keySet()); 
	out.println("Minimum Key of Map is: " + minKey); 
	out.println("Value corresponding to " + "minimum Key of Map is: "  + map.get(minKey)); 
	out.println("Maximum Key of Map is: " + maxKey); 
	out.println("Value corresponding to " + "maximum Key of Map is: "  + map.get(maxKey));

	Hashtable<String,Integer> minPriceHT=new Hashtable<String,Integer>();
	minPriceHT.put(minKey,map.get(minKey)); */
	ezc.ezcommon.EzLog4j.log("map>>>>>>>"+map,"I");
	ArrayList rfqLinesListSht = new ArrayList();
	Hashtable vendWiseTotqtyWithDisSht=new Hashtable();
	Hashtable vendWisePaymentTypeHTSht=new Hashtable();
	Hashtable vendRankHT=new Hashtable();
	double totValSht=0.0;
	String totValShtStr="0";
	double totHisValSht=0.0;
	String totHisValShtStr="0";
	int vendCnt=0;
	ArrayList chkListSht = new ArrayList();
	ArrayList chkList = new ArrayList();
	for(int vn=0;vn<rfqLinesRetCnt;vn++)
	{
		String vend=rfqLinesRet.getFieldValueString(vn,"VENDOR");
		if(chkListSht.contains(vend))
		continue;
		else
		chkListSht.add(vend);
		vendCnt++;
		String vendRank="L"+(vendCnt+"");
		vendRankHT.put(vendRank,vendRank);
	
	}
	for(int z=0;z<rfqLinesRetCnt;z++)
	{
		String vend=rfqLinesRet.getFieldValueString(z,"VENDOR");
		String qcfH = rfqLinesRet.getFieldValueString(z,"QCFNO");
		String lineH = rfqLinesRet.getFieldValueString(z,"LINENO");
		String payMentType=checkNull(rfqLinesRet.getFieldValueString(z,"PAYMENTTYPE"));
		String leadDays=checkNull(rfqLinesRet.getFieldValueString(z,"LEADTIME"));
		String percent=checkNull(rfqLinesRet.getFieldValueString(z,"PERCENT"));
		if("".equals(percent))percent="NA";
			vendWisePaymentTypeHTSht.put(vend,payMentType+"#"+leadDays+"#"+percent);
		if(rfqLinesListSht.contains(rfqLinesRet.getFieldValueString(z,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(z,"LINENO")))
			continue;
		else
			rfqLinesListSht.add(rfqLinesRet.getFieldValueString(z,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(z,"LINENO"));
		String myQty = rfqLinesRet.getFieldValueString(z,"QTY");
		
		
		try
		{
			myQty = (Double.parseDouble(myQty))+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){}
		for(int j=0;j<rfqVendLinesRetCnt;j++)
		{	
			String vendorLoop=rfqLinesRet.getFieldValueString(j,"VENDOR");	
			if(qcfH.equals(rfqVendLinesRet.getFieldValueString(j,"QCFNO")) && lineH.equals(rfqVendLinesRet.getFieldValueString(j,"LINENO")))
			{
				String quotCurr = rfqVendLinesRet.getFieldValueString(j,"CURR");
				ezc.ezcommon.EzLog4j.log("quotCurr>>>>>>>"+quotCurr,"I");
				if("".equals(quotCurr) || "null".equals(quotCurr) || quotCurr==null) quotCurr = "INR";	
				String quotPrice = rfqVendLinesRet.getFieldValueString(j,"PRICE");
				if("".equals(quotPrice) || "null".equals(quotPrice) || quotPrice==null) quotPrice = "0";
				try
				{
					quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){}
				String condDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCVAL"));
				if("".equals(condDisc) || "null".equals(condDisc) || condDisc==null) condDisc = "0";
				String discType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCTYPE"));
				double discVal=0.0;
				try
				{
					if("P".equals(discType))
						discVal= Double.parseDouble(quotPrice) * Double.parseDouble(condDisc)/100;
					else if("Q".equals(discType))
						discVal= Double.parseDouble(condDisc) * Double.parseDouble(myQty);
					else if("V".equals(discType))
						discVal= Double.parseDouble(condDisc);			

					
				}
				catch(Exception e)
				{
					discVal = 00.0;
				}
				

				try
				{
					totValSht= (Double.parseDouble(myQty) * (Double.parseDouble(quotPrice)-discVal));
					if(totValSht<0)totValSht=0.0;
					totValShtStr  = new java.math.BigDecimal(totValSht).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e)
				{
					totValSht = 00.0;
				}

				String quotHisPrice = rfqVendLinesRet.getFieldValueString(j,"PRICEHIS");   
				if("".equals(quotHisPrice) || "null".equals(quotHisPrice) || quotHisPrice==null) quotHisPrice = "0";
				try
				{
					quotHisPrice  = new java.math.BigDecimal(quotHisPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}						
				catch(Exception e){}
				try
				{
					totHisValSht= (Double.parseDouble(myQty) * Double.parseDouble(quotHisPrice));
					if(totHisValSht<0)totHisValSht=0.0;
					totHisValShtStr  = new java.math.BigDecimal(totHisValSht).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e)
				{
					totHisValSht = 00.0;
				}
				
				if(vendWiseTotqtyWithDisSht.containsKey(vendorLoop))
				{
					String getValHis=((String)vendWiseTotqtyWithDisSht.get(vendorLoop)).split("#")[0];
					String getVal=((String)vendWiseTotqtyWithDisSht.get(vendorLoop)).split("#")[1];
					double getDb=totValSht+Double.parseDouble(getVal);
					if(getDb<0)getDb=0.0;
					double getHisDb=totHisValSht+Double.parseDouble(getValHis);
					if(getHisDb<0)getHisDb=0.0;
					getVal= new java.math.BigDecimal(getDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					getValHis= new java.math.BigDecimal(getHisDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					vendWiseTotqtyWithDisSht.put(vendorLoop,getValHis+"#"+getVal);
				}
				else
				{
					vendWiseTotqtyWithDisSht.put(vendorLoop,totHisValShtStr+"#"+totValShtStr);
				}
			}	
		}
	}
	//out.println("vendRankHT"+vendRankHT);
	HashMap<String, Double> mapTotalCost   = new HashMap<String, Double>(); 
	Hashtable<String, String> TotalCostStrHT   = new Hashtable<String, String>(); 
	HashMap<String, Double> minMatHT   = new HashMap<String, Double>(); 
	Hashtable<String, String> TotalHedCostStrHT   = new Hashtable<String, String>(); 
	List<Double> list = new ArrayList<Double>(); 
	
	chkListSht = new ArrayList();
	ArrayList rfqLinesListIN = new ArrayList();
	for(int q=0;q<rfqLinesRetCnt;q++)
	{
		String qcfH = rfqLinesRet.getFieldValueString(q,"QCFNO");
		String lineH = rfqLinesRet.getFieldValueString(q,"LINENO");
		String vend=rfqLinesRet.getFieldValueString(q,"VENDOR");
		List<Double> matlist = new ArrayList<Double>(); 
		String material="";
		try{
		material=(Long.parseLong(rfqLinesRet.getFieldValueString(q,"MATERIAL")))+"";
		}catch(Exception e){
		material=rfqLinesRet.getFieldValueString(q,"MATERIAL");
		}
		
		if(rfqLinesListIN.contains(rfqLinesRet.getFieldValueString(q,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(q,"LINENO")))
			continue;
		else
			rfqLinesListIN.add(rfqLinesRet.getFieldValueString(q,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(q,"LINENO"));
		String myQty = rfqLinesRet.getFieldValueString(q,"QTY");
		for(int j=0;j<rfqVendLinesRetCnt;j++)
		{
				
			String vendorLoop=rfqLinesRet.getFieldValueString(j,"VENDOR");	 
			double totVal=0.0;
			if(qcfH.equals(rfqVendLinesRet.getFieldValueString(j,"QCFNO")) && lineH.equals(rfqVendLinesRet.getFieldValueString(j,"LINENO")))
			{
				String quotCurr = rfqVendLinesRet.getFieldValueString(j,"CURR");
				if("".equals(quotCurr) || "null".equals(quotCurr) || quotCurr==null) quotCurr = "INR";
				
				String quotPrice = rfqVendLinesRet.getFieldValueString(j,"PRICE");
				if("".equals(quotPrice) || "null".equals(quotPrice) || quotPrice==null) quotPrice = "0";
				
				try
				{
					quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){}

				try
				{
					totVal= (Double.parseDouble(myQty) * Double.parseDouble(quotPrice));
					
				}
				catch(Exception e)
				{
					totVal = 00.0;
				}

				
				

				String discType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCTYPE"));
				String condDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCVAL"));
				if("".equals(condDisc) || "null".equals(condDisc) || condDisc==null) condDisc = "0";
				double discVal=0.0;
				double discTotVal=0.0;
				try
				{
					if("P".equals(discType))
						discVal= Double.parseDouble(quotPrice) * Double.parseDouble(condDisc)/100;
					else if("Q".equals(discType))
						discVal= Double.parseDouble(condDisc) * Double.parseDouble(myQty);
					else if("V".equals(discType))
						discVal= Double.parseDouble(condDisc);			

					
				}
				catch(Exception e)
				{
					discVal = 00.0;
				}
				try
				{
					discTotVal= Double.parseDouble(quotPrice)-discVal;
					
				}
				catch(Exception e)
				{ 
					discTotVal = 00.0;  
				}				
				try
				{
					totVal= (Double.parseDouble(myQty) * discTotVal);
					
				}
				catch(Exception e)
				{
					totVal = 00.0;
				}
				//out.println(totVal+"j");
				matlist.add(totVal);
			}
			
		}
		Double minMatList = Collections.min(matlist);
		//out.println(minMatList+"minMatList"+matlist);
		minMatHT.put(material,minMatList);
	}
	//out.println(minMatHT+"minMatHT");
	
//*************************************************************

		String discType = "";
		String condDisc = "";
		String PKFWType = "";
		String condPKFW = "";
		String FRTType  = "";
		String condFRT  = "";
		String BCDType  = "";
		String condBCD  = "";
		String SWCType  = "";
		String condSWC  = "";		
		String CHAType  = "";
		String condCHA  = "";
		String CHA1Type  = "";
		String condCHA1  = "";
		String OTHType  = "";
		String condOTH  = "";
		String condOTHVend = "";
		String IFRTType = "";		
		String condIFRT = "";				
		String condGST  = "";
		String DUTYType = "";
		String condDUTY = "";
		
		String discHisType = "";
		String condHisDisc = "";
		String PKFWHisType = "";
		String condHisPKFW = "";
		String FRTHisType  = "";
		String condHisFRT  = "";
		String BCDHisType  = "";		
		String condHisBCD  = "";
		String SWCHisType  = "";		
		String condHisSWC  = "";
		String CHAHisType  = "";		
		String CHA1HisType  = "";		
		String condHisCHA  = "";		
		String condHisCHA1  = "";		
		String IFRTHisType  = "";		
		String condHisIFRT  = "";
		String OTHHisType  = "";		
		String condHisOTH  = "";		
		String condHisOTHVend = "";		
		String condHisGST  = "";
		String DUTYHisType  = "";		
		String condHisDUTY  = "";
		
		String totalAmoutStr="";
		String basicValStr="";
		String basicValHisStr="";
		String totcondGSTStr="";
		
		double totcondGST=0.0;
		double totVal = 0.0;
		double totalAmout=0.0;
		double discVal = 0.0;
		double discTotVal = 0.0;
		double basicVal=0.0;
		double basicValHis=0.0;
		double PKFWVal = 0.0;
		double FRTVal = 0.0;
		double BCDVal = 0.0;
		double SWCVal = 0.0;
		double CHAVal = 0.0;
		double CHA1Val = 0.0;
		double IFRTVal = 0.0;
		double OTHVal = 0.0;
		double GSTVal = 0.0;
		double DUTYVal = 0.0;
		double sPrice = 0.0;
		double sPriceInr = 0.0;
		double grossVal = 0.0;	
		
		
		double PKFWRecVal = 0.0;
		double FRTRecVal = 0.0;
		double getRecVal=0.0;
		double sRecPrice = 0.0;
		double sRecPriceInr = 0.0;
		double BCDRecVal = 0.0;
		double SWCRecVal = 0.0;
		double CHARecVal = 0.0;
		double CHA1RecVal = 0.0;
		double IFRTRecVal = 0.0;
		double OTHRecVal = 0.0;
		double sPriceRecInr = 0.0;
		double GSTRecVal = 0.0;
		double DUTYRecVal = 0.0;
		String totRecQtyStr="0";
		String totRecValStr="0";
		String PKFWRecValStr ="0";
		String FRTRecValStr ="0";
		String sRecPriceStr = "0";
		String sRecPriceInrStr = "0";
		String BCDRecValStr="0";
		String SWCRecValStr="0";
		String CHARecValStr="0";
		String CHA1RecValStr="0";
		String IFRTRecValStr="0";
		String OTHRecValStr="0";
		String GSTRecValStr="0";
		String DUTYRecValStr ="0";
		
		
		
		double totHisVal = 0.0;
		double discHisVal = 0.0;
		double discUOMHisVal = 0.0;
		double discHisTotVal = 0.0;
		
		double PKFWHisVal = 0.0;
		double FRTHisVal = 0.0;
		double BCDHisVal = 0.0;
		double SWCHisVal = 0.0;
		double CHAHisVal = 0.0;
		double CHA1HisVal = 0.0;
		double IFRTHisVal = 0.0;
		double OTHHisVal = 0.0;
		double GSTHisVal = 0.0;
		double sPriceHis = 0.0;
		double sPriceHisInr = 0.0;
		double DUTYHisVal = 0.0;
		double grossHisVal = 0.0;			
		double totPOPrice=0.0;
		
		String totValStr="0";
		String discValStr="0";
		String discTotValStr="0";
		String totPOPriceStr="0";
		
		String PKFWValStr="0";
		String FRTValStr="0";
		String BCDValStr="0";
		String SWCValStr="0";
		String CHAValStr="0";
		String CHA1ValStr="0";
		String OTHValStr="0";
		String IFRTValStr="0";
		String GSTValStr="0";
		String DUTYValStr="0";
		String sPriceStr = "0";
		String sPriceHisInrStr = "0";
		String sPriceInrStr = "0";
		String grossValStr = "0";
		
		
		String totHisValStr="0";
		String discHisValStr="0";
		String discUOMHisValStr="0";
		String discHisTotValStr="0";
		String PKFWHisValStr="0";
		String FRTHisValStr="0";
		String BCDHisValStr="0";
		String SWCHisValStr="0";
		String CHAHisValStr="0";
		String CHA1HisValStr="0";
		String IFRTHisValStr="0";
		String OTHHisValStr="0";
		String GSTHisValStr="0";
		String sPriceHisStr = "0";
		String DUTYHisValStr = "0";
		String grossHisValStr = "0";
		String discHisAllItemTotValStr="0";
		String discAllItemTotValStr="0";
		double discHisAllItemTotVal = 0.0;
		double discAllItemTotVal = 0.0;

		
		
		
		ArrayList rfqLinesList = new ArrayList();
		Hashtable vendWiseCurrency=new Hashtable();
		Hashtable vendWiseExchange=new Hashtable();
		Hashtable vendWiseTotqty=new Hashtable();
		Hashtable vendWiseRecQty=new Hashtable();
		Hashtable vendWiseRecVal=new Hashtable();
		Hashtable vendWiseTotqtyWithoutDis=new Hashtable();
		Hashtable vendWiseTotAmount=new Hashtable();
		Hashtable vendWiseTotBasePriceHT=new Hashtable();
		Hashtable vendWisePKGValueHT=new Hashtable();
		Hashtable vendWisePKGHT=new Hashtable();
		Hashtable vendWiseFRTHT=new Hashtable();
		Hashtable vendWiseFRTValueHT=new Hashtable();
		Hashtable vendWiseBCDHT=new Hashtable();
		Hashtable vendWiseBCDValueHT=new Hashtable();
		Hashtable vendWiseSWCHT=new Hashtable();
		Hashtable vendWiseSWCValueHT=new Hashtable();
		Hashtable vendWiseCHAHT=new Hashtable();
		Hashtable vendWiseCHAValueHT=new Hashtable();
		Hashtable vendWiseCHA1HT=new Hashtable();
		Hashtable vendWiseCHA1ValueHT=new Hashtable();		
		Hashtable vendWiseIFRTHT=new Hashtable();
		Hashtable vendWiseIFRTValueHT=new Hashtable();				
		Hashtable vendWiseOTHHT=new Hashtable();
		Hashtable vendWiseOTHValueHT=new Hashtable();						
		Hashtable vendWiseOTHReasonHT=new Hashtable();						
		Hashtable vendWiseSUPPPRICEHT=new Hashtable();
		Hashtable vendWiseSUPPPRICEINRHT=new Hashtable();
		Hashtable vendWiseGSTHT=new Hashtable();
		Hashtable vendWiseGSTValueHT=new Hashtable();
		Hashtable vendWiseDUTYHT=new Hashtable();
		Hashtable vendWisePaymentTypeHT=new Hashtable(); 
		Hashtable vendWiseTotGSTHT=new Hashtable(); 
		Hashtable vendWiseGrossValHT=new Hashtable(); 
		Hashtable vendWiseTotValHT=new Hashtable(); 
		double totalQuantity=0.0;
		double totRecQty=0.0;
		for(int b=0;b<rfqLinesRetCnt;b++)
		{
			String qcfH = rfqLinesRet.getFieldValueString(b,"QCFNO");
			String lineH = rfqLinesRet.getFieldValueString(b,"LINENO");
			String vend=rfqLinesRet.getFieldValueString(b,"VENDOR");
			
 
			if(rfqLinesList.contains(rfqLinesRet.getFieldValueString(b,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(b,"LINENO")))
				continue;
			else
				rfqLinesList.add(rfqLinesRet.getFieldValueString(b,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(b,"LINENO"));

			String myQty = rfqLinesRet.getFieldValueString(b,"QTY");
			try
			{
				myQty = (Double.parseDouble(myQty))+"";
				myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e){}
			totalQuantity=totalQuantity+Double.parseDouble(myQty); 
			
			
				for(int j=0;j<rfqVendLinesRetCnt;j++)
				{

					String vendorLoop=rfqLinesRet.getFieldValueString(j,"VENDOR");	 

					if(qcfH.equals(rfqVendLinesRet.getFieldValueString(j,"QCFNO")) && lineH.equals(rfqVendLinesRet.getFieldValueString(j,"LINENO")))
					{
						String material="";
						try{
						material=(Long.parseLong(rfqLinesRet.getFieldValueString(b,"MATERIAL")))+"";
						}catch(Exception e){
						material=rfqLinesRet.getFieldValueString(b,"MATERIAL");
					}
					String quotCurr = rfqVendLinesRet.getFieldValueString(j,"CURR");
					if("".equals(quotCurr) || "null".equals(quotCurr) || quotCurr==null) quotCurr = "INR";
					ezc.ezcommon.EzLog4j.log("vendorLoop for Currency>>>>>>>"+vendorLoop,"I");		
					ezc.ezcommon.EzLog4j.log("quotCurr>>>>>>>"+quotCurr,"I");		
					if(!(vendWiseCurrency.containsKey(vendorLoop)))
						vendWiseCurrency.put(vendorLoop,quotCurr);
					String vendExch = rfqVendLinesRet.getFieldValueString(j,"EXCHRATE"); 
					ezc.ezcommon.EzLog4j.log("vendExch>>>>>>>"+vendExch,"I");
					if(!(vendWiseExchange.containsKey(vendorLoop)))
						vendWiseExchange.put(vendorLoop,vendExch);						
					String HSNCode=	rfqVendLinesRet.getFieldValueString(j,"HSNCODE");	
					String quotPrice = rfqVendLinesRet.getFieldValueString(j,"PRICE");
										
					if("".equals(quotPrice) || "null".equals(quotPrice) || quotPrice==null) quotPrice = "0";
					try
					{
						quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e){}

					try
					{
						totVal= (Double.parseDouble(myQty) * Double.parseDouble(quotPrice));
						totVal = totVal * Double.parseDouble(exchRate);
						if(totVal<0)totVal=0.0;
						
						totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						totVal = 00.0;
					}

					String quotHisPrice = rfqVendLinesRet.getFieldValueString(j,"PRICEHIS");   
					if("".equals(quotHisPrice) || "null".equals(quotHisPrice) || quotHisPrice==null) quotHisPrice = "0";
					try
					{
						quotHisPrice  = new java.math.BigDecimal(quotHisPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}						
					catch(Exception e){}
					try
					{
						totHisVal= (Double.parseDouble(myQty) * Double.parseDouble(quotHisPrice));
						totHisVal = totHisVal * Double.parseDouble(exchRate);
						
						if(totHisVal<0)totHisVal=0.0;
						totHisValStr  = new java.math.BigDecimal(totHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						totHisVal = 00.0;
					}

					if(vendWiseTotqtyWithoutDis.containsKey(vendorLoop))
					{
						String getValHis=((String)vendWiseTotqtyWithoutDis.get(vendorLoop)).split("#")[0];
						String getVal=((String)vendWiseTotqtyWithoutDis.get(vendorLoop)).split("#")[1];
						double getDb=totVal+Double.parseDouble(getVal);
						if(getDb<0)getDb=0.0;
						double getHisDb=totHisVal+Double.parseDouble(getValHis);
						if(getHisDb<0)getHisDb=0.0;
						getVal= new java.math.BigDecimal(getDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						getValHis= new java.math.BigDecimal(getHisDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseTotqtyWithoutDis.put(vendorLoop,getValHis+"#"+getVal);
					}
					else
					{
					vendWiseTotqtyWithoutDis.put(vendorLoop,totHisValStr+"#"+totValStr);
					}
					if(vendWiseTotBasePriceHT.containsKey(vendorLoop))
					{
						String getquotPrice=((String)vendWiseTotBasePriceHT.get(vendorLoop)).split("#")[1];
						String getquotHisPrice=((String)vendWiseTotBasePriceHT.get(vendorLoop)).split("#")[0];
						double getquotPriceDb=Double.parseDouble(quotPrice)+Double.parseDouble(getquotPrice);
						if(getquotPriceDb<0)getquotPriceDb=0.0;
						double getquotHisPriceDb=Double.parseDouble(quotHisPrice)+Double.parseDouble(getquotHisPrice);
						if(getquotHisPriceDb<0)getquotHisPriceDb=0.0;
						getquotPrice= new java.math.BigDecimal(getquotPriceDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						getquotHisPrice= new java.math.BigDecimal(getquotHisPriceDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseTotBasePriceHT.put(vendorLoop,getquotHisPrice+"#"+getquotPrice);
					}
					else  
					{
					vendWiseTotBasePriceHT.put(vendorLoop,quotHisPrice+"#"+quotPrice);
					}
					String styleCl="";  
					String keyStr=rfqLinesRet.getFieldValueString(b,"MATERIAL")+"#"+rfqVendLinesRet.getFieldValueString(j,"VENDOR")+"#"+rfqVendLinesRet.getFieldValueString(j,"RFQNO");

					discType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCTYPE")); 
					condDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCVAL"));
					condGST	 =checkNull(rfqVendLinesRet.getFieldValueString(j,"TAXVAL"));
					if("".equals(condDisc) || "null".equals(condDisc) || condDisc==null) condDisc = "0";
					if("".equals(condGST) || "null".equals(condGST) || condGST==null) condGST = "0";

					try
					{
						if("P".equals(discType))
							discVal= Double.parseDouble(quotPrice) * Double.parseDouble(condDisc)/100;
						else if("Q".equals(discType))
							discVal= Double.parseDouble(condDisc) * Double.parseDouble(myQty);
						else if("V".equals(discType))
							discVal= Double.parseDouble(condDisc);			

						discValStr  = new java.math.BigDecimal(discVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						discVal = 00.0;
					}
					try
					{
						discTotVal= Double.parseDouble(quotPrice)-discVal;
						//out.println("quotPrice"+quotPrice+"discVal"+discVal);
						basicVal=Double.parseDouble(quotPrice)-discVal;
						basicValStr  = new java.math.BigDecimal(basicVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						discTotValStr  = new java.math.BigDecimal(discTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						
					}
					catch(Exception e)
					{ 
						discTotVal = 00.0;  
					}				
					discHisType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCHISTYPE"));
					condHisDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCHISVAL"));
					if("".equals(condHisDisc) || "null".equals(condHisDisc) || condHisDisc==null) condHisDisc = "0";
					try
					{
						if("P".equals(discHisType))
							discHisVal= totHisVal * Double.parseDouble(condHisDisc)/100;
						else if("Q".equals(discHisType))
							discHisVal= Double.parseDouble(condHisDisc) * Double.parseDouble(myQty);
						else if("V".equals(discHisType))
							discHisVal= Double.parseDouble(condHisDisc);			

						discHisValStr  = new java.math.BigDecimal(discHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						discHisVal = 00.0;
					}				
					try
					{
						discHisTotVal= totHisVal-discHisVal;
						basicValHis=Double.parseDouble(quotHisPrice)-discHisVal;
						basicValHisStr  = new java.math.BigDecimal(basicValHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						discHisTotValStr  = new java.math.BigDecimal(discHisTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{ 
						discHisTotVal = 00.0;  
					}
					if(vendWiseTotqty.containsKey(vendorLoop))
					{
						String valFromHT=(String)vendWiseTotqty.get(vendorLoop);
						discHisAllItemTotVal=Double.parseDouble(valFromHT.split("#")[0])+discHisTotVal;
						if(discHisAllItemTotVal<0)discHisAllItemTotVal=0.0;
						discAllItemTotVal=Double.parseDouble(valFromHT.split("#")[1])+discTotVal;
						if(discAllItemTotVal<0)discAllItemTotVal=0.0;
						discHisAllItemTotValStr=new java.math.BigDecimal(discHisAllItemTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						discAllItemTotValStr=new java.math.BigDecimal(discAllItemTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseTotqty.put(vendorLoop,discHisAllItemTotValStr+"#"+discAllItemTotValStr);
					}
					else
					{
						vendWiseTotqty.put(vendorLoop,discHisTotValStr+"#"+discTotValStr);
					}						//out.println("keyStr"+keyStr);
					try
					{
						totVal= (Double.parseDouble(myQty) * basicVal);
						//totVal= totVal * Double.parseDouble(exchRate);
						
						if(totVal<0)totVal=0.0;
						totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						totVal = 00.0;
					}
					if(vendWiseTotAmount.containsKey(vendorLoop))
					{
						String valFromHT=(String)vendWiseTotAmount.get(vendorLoop);
						totalAmout=Double.parseDouble(valFromHT)+totVal;
						if(totalAmout<0)totalAmout=0.0;
						totalAmoutStr  = new java.math.BigDecimal(totalAmout).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseTotAmount.put(vendorLoop,totalAmoutStr);
					}
					else
					{
						vendWiseTotAmount.put(vendorLoop,totValStr);
					}
					if(vendWiseTotGSTHT.containsKey(vendorLoop))
					{
						String valFromHT=(String)vendWiseTotGSTHT.get(vendorLoop);
						totcondGST=Double.parseDouble(valFromHT)+Double.parseDouble(condGST); 
						if(totcondGST<0)totcondGST=0.0;
						totcondGSTStr= new java.math.BigDecimal(totcondGST).setScale(0,java.math.BigDecimal.ROUND_HALF_UP).toString();

						vendWiseTotGSTHT.put(vendorLoop,totcondGSTStr);
					}
					else
					{
					vendWiseTotGSTHT.put(vendorLoop,condGST);
					}
					String recQty = "0";
					try
					{
						 recQty = rfqVendLinesRet.getFieldValueString(j,"POQTY"); 
						 if("".equals(recQty) || "null".equals(recQty) || recQty==null) recQty = "0";
					}	
					catch(Exception e)
					{
						recQty = "0";
					}
					try
					{
						totRecQtyStr  = new java.math.BigDecimal(recQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						ezc.ezcommon.EzLog4j.log("recQty Loop >>>>>>>"+j,"I");
						ezc.ezcommon.EzLog4j.log("recQty vendorLoop >>>>>>>"+vendorLoop,"I");
						ezc.ezcommon.EzLog4j.log("recQty>>>>>>>"+recQty,"I");
						getRecVal= (Double.parseDouble(recQty) * basicVal) ;
						totRecValStr = new java.math.BigDecimal(getRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					}
					catch(Exception e)
					{
						totRecQtyStr ="0";
						totRecValStr ="0";
					}
					
					if(vendWiseRecQty.containsKey(vendorLoop))
					{
						String getRecQty=((String)vendWiseRecQty.get(vendorLoop));
						ezc.ezcommon.EzLog4j.log("quotPrice>>>>>>>"+quotPrice,"I");
						ezc.ezcommon.EzLog4j.log("discVal>>>>>>>"+discVal,"I");
						ezc.ezcommon.EzLog4j.log("basicVal>>>>>>>"+basicVal,"I");
						
						
						String totRecVal= ((String)vendWiseRecVal.get(vendorLoop));
						ezc.ezcommon.EzLog4j.log("totRecVal>>>>>>>"+totRecVal,"I");	
						
						double getDb=Double.parseDouble(recQty)+Double.parseDouble(getRecQty);
						if(getDb<0)getDb=0.0;
						totRecQtyStr= new java.math.BigDecimal(getDb).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseRecQty.put(vendorLoop,totRecQtyStr);
						
						getRecVal= (Double.parseDouble(recQty) * basicVal)+Double.parseDouble(totRecVal) ;
						ezc.ezcommon.EzLog4j.log("getRecVal>>>>>>>"+getRecVal,"I");	
						totRecValStr= new java.math.BigDecimal(getRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						vendWiseRecVal.put(vendorLoop,totRecValStr);
					}
					else
					{
						vendWiseRecQty.put(vendorLoop,totRecQtyStr);
						vendWiseRecVal.put(vendorLoop,totRecValStr);
					}										
					
					}
				}
	
		}
		
	 
    	  	Set keys = vendWiseTotGSTHT.entrySet();
		Iterator itr = keys.iterator();
		while(itr.hasNext()) {
			Map.Entry me2 = (Map.Entry)itr.next();
			String vend =(String)me2.getKey();
			String gstVal=(String)me2.getValue();
			Double d= new Double(itemCnt);
			Double avgGst=Double.parseDouble(gstVal)/d;
			String avgGstStr  = new java.math.BigDecimal(avgGst).setScale(0,java.math.BigDecimal.ROUND_HALF_UP).toString();
			vendWiseTotGSTHT.put(vend,avgGstStr);
      		}
		//out.println("vendWiseTotGSTHT"+vendWiseTotGSTHT);
		
		//out.println("vendWiseTotAmount"+vendWiseTotAmount);
		chkList = new ArrayList();
		for(int c=0;c<rfqVendLinesRetCnt;c++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(c,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(c,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(c,"VENDOR");
			//out.println("vend in QCF"+vend);

			PKFWType = checkNull(rfqVendLinesRet.getFieldValueString(c,"PKFWTYPE"));
			//out.println("PKFWType>>>"+PKFWType);
			condPKFW = checkNull(rfqVendLinesRet.getFieldValueString(c,"PKFWVAL"));
			//out.println("condPKFW>>>>"+condPKFW);
			if("".equals(condPKFW) || "null".equals(condPKFW) || condPKFW==null) 
			condPKFW = "0"; 
			try
			{
				if("P".equals(PKFWType))
				{
					PKFWVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condPKFW)/100;
					PKFWRecVal= Double.parseDouble((String)vendWiseRecVal.get(vend)) * Double.parseDouble(condPKFW)/100;
				}	
				else if("Q".equals(PKFWType))
				{
					PKFWVal= Double.parseDouble(condPKFW) * totalQuantity;
					PKFWRecVal= Double.parseDouble(condPKFW) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(PKFWType))
				{
					PKFWVal= Double.parseDouble(condPKFW);	
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						PKFWRecVal= Double.parseDouble(condPKFW);
					else
						PKFWRecVal = 00.0; 
				}	
				else
				{
					PKFWVal = 00.0; 
					PKFWRecVal = 00.0; 
				}	
				//PKFWVal	= PKFWVal * Double.parseDouble(exchRate);				

				PKFWValStr  = new java.math.BigDecimal(PKFWVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				PKFWRecValStr  = new java.math.BigDecimal(PKFWRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//out.println("PKFWValStr in QCF"+PKFWValStr);
			}
			catch(Exception e)
			{ 
				PKFWVal = 00.0;
				PKFWRecVal = 00.0;
			}
			PKFWHisType = checkNull(rfqVendLinesRet.getFieldValueString(c,"PKFWHISTYPE"));
			condHisPKFW = checkNull(rfqVendLinesRet.getFieldValueString(c,"PKFWHISVAL"));
			if("".equals(condHisPKFW) || "null".equals(condHisPKFW) || condHisPKFW==null) 
				condHisPKFW = "0"; 
			try
			{
				if("P".equals(PKFWHisType))
					PKFWHisVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condHisPKFW)/100;
				else if("Q".equals(PKFWHisType))
					PKFWHisVal= Double.parseDouble(condHisPKFW) * totalQuantity;
				else if("V".equals(PKFWHisType))
					PKFWHisVal= Double.parseDouble(condHisPKFW);
				else
					PKFWHisVal = 00.0;					

				//PKFWHisVal = PKFWHisVal * Double.parseDouble(exchRate);
				PKFWHisValStr  = new java.math.BigDecimal(PKFWHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//out.println("PKFWHisValStr in QCF"+PKFWHisValStr);
			}
			catch(Exception e)
			{ 
				PKFWHisVal = 00.0;  
			}

			vendWisePKGHT.put(vend,PKFWHisValStr+"#"+PKFWValStr+"#"+PKFWRecValStr);	
			vendWisePKGValueHT.put(vend,condHisPKFW+"#"+condPKFW);
		}
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			FRTType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTTYPE"));
			out.println("FRTType>>>"+FRTType);
			condFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTVAL"));
			out.println("condFRT>>>"+condFRT);
			String totValFRT =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[1];
			if("".equals(condFRT) || "null".equals(condFRT) || condFRT==null) 
				condFRT = "0"; 			
			try
			{
				if("P".equals(FRTType))
				{
					FRTVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condFRT)/100;
					FRTRecVal= Double.parseDouble((String)vendWiseRecVal.get(vend)) * Double.parseDouble(condFRT)/100;
				}	
				else if("Q".equals(FRTType))
				{
					FRTVal= Double.parseDouble(condFRT) * totalQuantity;
					FRTRecVal= Double.parseDouble(condFRT) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(FRTType))
				{
					FRTVal= Double.parseDouble(condFRT);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						FRTRecVal= Double.parseDouble(condFRT);
						
				}	
				else
				{
					FRTVal = 00.0;
					FRTRecVal = 00.0; 
				}	
					
				//out.println("FRTVal>>>"+FRTVal);
				//FRTVal	= FRTVal * Double.parseDouble(exchRate);
				FRTValStr  = new java.math.BigDecimal(FRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				FRTRecValStr  = new java.math.BigDecimal(FRTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//out.println("FRTValStr>>>"+FRTValStr);
			}
			catch(Exception e)
			{ 
				FRTVal = 00.0;  
				FRTRecVal = 00.0;
			}
			FRTHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTHISTYPE"));
			out.println("FRTHISTYPE>>>"+FRTHisType);
			condHisFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTHISVAL"));
			String totHisFRTVal =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[0];
			if("".equals(condHisFRT) || "null".equals(condHisFRT) || condHisFRT==null) 
				condHisFRT = "0"; 			
			try
			{
				if("P".equals(FRTHisType))
					FRTHisVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condHisFRT)/100;
				else if("Q".equals(FRTHisType))
					FRTHisVal= Double.parseDouble(condHisFRT)* totalQuantity;
				else if("V".equals(FRTHisType))
					FRTHisVal= Double.parseDouble(condHisFRT);
				else
					FRTHisVal = 00.0;
					
				//FRTHisVal	= FRTHisVal * Double.parseDouble(exchRate);
				FRTHisValStr  = new java.math.BigDecimal(FRTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				FRTHisVal = 00.0;  
			}
			vendWiseFRTHT.put(vend,FRTHisValStr+"#"+FRTValStr+"#"+FRTRecValStr);
			vendWiseFRTValueHT.put(vend,condHisFRT+"#"+condFRT);
		}
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			String frtVal=(String)vendWiseFRTHT.get(vend);
			String pkgVal=(String)vendWisePKGHT.get(vend);
			String totValForSP=(String)vendWiseTotAmount.get(vend);
			String totRecValSP=(String)vendWiseRecVal.get(vend);
			sPriceHis=Double.parseDouble(totValForSP)+Double.parseDouble(pkgVal.split("#")[0])+Double.parseDouble(frtVal.split("#")[0]);
			sPriceHisStr  = new java.math.BigDecimal(sPriceHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			sPrice=Double.parseDouble(totValForSP)+Double.parseDouble(pkgVal.split("#")[1])+Double.parseDouble(frtVal.split("#")[1]);
			sPriceStr  = new java.math.BigDecimal(sPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			sRecPrice=Double.parseDouble(totRecValSP)+Double.parseDouble(pkgVal.split("#")[2])+Double.parseDouble(frtVal.split("#")[2]);
			sRecPriceStr  = new java.math.BigDecimal(sRecPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
			vendWiseSUPPPRICEHT.put(vend,sPriceHisStr+"#"+sPriceStr+"#"+sRecPriceStr);
			exchRate = (String)vendWiseExchange.get(vend);
			ezc.ezcommon.EzLog4j.log("exchRateNew>>>>>>>"+exchRate,"I");	
			
			sPriceHisInr=(Double.parseDouble(totValForSP) * Double.parseDouble(exchRate))+(Double.parseDouble(pkgVal.split("#")[0])* Double.parseDouble(exchRate))+(Double.parseDouble(frtVal.split("#")[0])* Double.parseDouble(exchRate));
			sPriceHisInrStr  = new java.math.BigDecimal(sPriceHisInr).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			sPriceInr=(Double.parseDouble(totValForSP) * Double.parseDouble(exchRate))+(Double.parseDouble(pkgVal.split("#")[1])* Double.parseDouble(exchRate))+(Double.parseDouble(frtVal.split("#")[1])* Double.parseDouble(exchRate));
			sPriceInrStr  = new java.math.BigDecimal(sPriceInr).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			sRecPriceInr=(Double.parseDouble(totRecValSP) * Double.parseDouble(exchRate))+(Double.parseDouble(pkgVal.split("#")[2])* Double.parseDouble(exchRate))+(Double.parseDouble(frtVal.split("#")[2])* Double.parseDouble(exchRate));
			sRecPriceInrStr  = new java.math.BigDecimal(sRecPriceInr).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();			
			vendWiseSUPPPRICEINRHT.put(vend,sPriceHisInrStr+"#"+sPriceInrStr+"#"+sRecPriceInrStr);
		}
		//BCD
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			BCDType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BCDTYPE"));
			condBCD  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BCDVAL"));
			String totValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[1];
			String totRecValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2];
			if("".equals(condBCD) || "null".equals(condBCD) || condBCD==null) 
				condBCD = "0"; 			
			try
			{
				if("P".equals(BCDType))
				{
					BCDVal= Double.parseDouble(totValSUP) * Double.parseDouble(condBCD)/100;
					BCDRecVal= Double.parseDouble(totRecValSUP) * Double.parseDouble(condBCD)/100;
				}	
				else if("Q".equals(BCDType))
				{
					BCDVal= Double.parseDouble(condBCD) * totalQuantity;
					BCDRecVal= Double.parseDouble(condBCD) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(BCDType))
				{
					BCDVal= Double.parseDouble(condBCD);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						BCDRecVal= Double.parseDouble(condBCD);
				}		
				else
				{
					BCDVal = 00.0;
					BCDRecVal = 00.0;
				}	
				
				BCDValStr  = new java.math.BigDecimal(BCDVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				BCDRecValStr  = new java.math.BigDecimal(BCDRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				out.println("BCDValNEW11>>>>"+BCDVal);
			}
			catch(Exception e)
			{ 
				BCDVal = 00.0;  
				BCDRecVal = 00.0;
			}
			BCDHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BCDHISTYPE"));
			condHisBCD  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BCDHISVAL"));
			String totHisValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[0];
			ezc.ezcommon.EzLog4j.log("totHisValSUP>>>>>>>"+totHisValSUP,"I");
			if("".equals(condHisBCD) || "null".equals(condHisBCD) || condHisBCD==null) 
				condHisBCD = "0"; 			
			try
			{
				if("P".equals(BCDHisType))
					BCDHisVal= Double.parseDouble(totHisValSUP) * Double.parseDouble(condHisBCD)/100;
				else if("Q".equals(BCDHisType))
					BCDHisVal= Double.parseDouble(condHisBCD)* totalQuantity;
				else if("V".equals(BCDHisType))
					BCDHisVal= Double.parseDouble(condHisBCD);
				else
					BCDHisVal = 00.0;
				
				BCDHisValStr  = new java.math.BigDecimal(BCDHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				BCDHisVal = 00.0;  
			}
			ezc.ezcommon.EzLog4j.log("BCDHisType>>>>>>>"+BCDHisType,"I");
			ezc.ezcommon.EzLog4j.log("BCDHisVal>>>>>>>"+BCDHisVal,"I");			
			vendWiseBCDHT.put(vend,BCDHisValStr+"#"+BCDValStr+"#"+BCDRecValStr);
			vendWiseBCDValueHT.put(vend,condHisBCD+"#"+condBCD);
		}
		//SWC
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			SWCType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"SWCTYPE"));
			condSWC  = checkNull(rfqVendLinesRet.getFieldValueString(f,"SWCVAL"));
			String totBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[1];
			String totBCDRecVal =((String)vendWiseBCDHT.get(vend)).split("#")[2];
			if("".equals(condSWC) || "null".equals(condSWC) || condSWC==null) 
				condSWC = "0"; 			
			try
			{
				if("P".equals(SWCType))
				{
					SWCVal= Double.parseDouble(totBCDVal) * Double.parseDouble(condSWC)/100;
					SWCRecVal= Double.parseDouble(totBCDRecVal) * Double.parseDouble(condSWC)/100;
				}	
				else if("Q".equals(SWCType))
				{
					SWCVal= Double.parseDouble(condSWC) * totalQuantity;
					SWCRecVal= Double.parseDouble(condSWC) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(SWCType))
				{
					SWCVal= Double.parseDouble(condSWC);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						SWCRecVal= Double.parseDouble(condSWC);	
				}		
				else
				{
					SWCVal = 00.0;
					SWCRecVal = 00.0;
				}	

				SWCValStr  = new java.math.BigDecimal(SWCVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				SWCRecValStr  = new java.math.BigDecimal(SWCRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				SWCVal = 00.0;  
			}
			SWCHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"SWCHISTYPE"));
			condHisSWC  = checkNull(rfqVendLinesRet.getFieldValueString(f,"SWCHISVAL"));
			String totHisBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[0];
			if("".equals(condHisSWC) || "null".equals(condHisSWC) || condHisSWC==null) 
				condHisSWC = "0"; 			
			try
			{
				if("P".equals(SWCHisType))
					SWCHisVal= Double.parseDouble(totHisBCDVal) * Double.parseDouble(condHisSWC)/100;
				else if("Q".equals(SWCHisType))
					SWCHisVal= Double.parseDouble(condHisSWC)* totalQuantity;
				else if("V".equals(SWCHisType))
					SWCHisVal= Double.parseDouble(condHisSWC);
				else
					SWCHisVal = 00.0;

				SWCHisValStr  = new java.math.BigDecimal(SWCHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				FRTHisVal = 00.0;  
			}
			vendWiseSWCHT.put(vend,SWCHisValStr+"#"+SWCValStr+"#"+SWCRecValStr);
			vendWiseSWCValueHT.put(vend,condHisSWC+"#"+condSWC);
		}
		//CHA
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			CHAType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHATYPE"));
			condCHA  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHAVAL"));
			String totValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];
			String totRecValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2];
			if("".equals(condCHA) || "null".equals(condCHA) || condCHA==null) 
				condCHA = "0"; 			
			try
			{
				if("P".equals(CHAType))
				{
					CHAVal= Double.parseDouble(totValSUP) * Double.parseDouble(condCHA)/100;
					CHARecVal= Double.parseDouble(totRecValSUP) * Double.parseDouble(condCHA)/100;
				}	
				else if("Q".equals(CHAType))
				{
					CHAVal= Double.parseDouble(condCHA) * totalQuantity;
					CHARecVal= Double.parseDouble(condCHA) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(CHAType))
				{
					CHAVal= Double.parseDouble(condCHA);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						CHARecVal= Double.parseDouble(condCHA);					
				}	
				else
				{
					CHAVal = 00.0;
					CHARecVal = 00.0;
				}	

				CHAValStr  = new java.math.BigDecimal(CHAVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				CHARecValStr  = new java.math.BigDecimal(CHARecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				CHAVal = 00.0; 
				CHARecVal = 00.0;
			}
			CHAHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHAHISTYPE"));
			condHisCHA = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHAHISVAL"));
			String totHisValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0];
			if("".equals(condHisCHA) || "null".equals(condHisCHA) || condHisCHA==null) 
				condHisCHA = "0"; 			
			try
			{
				if("P".equals(CHAHisType))
					CHAHisVal= Double.parseDouble(totHisValSUP) * Double.parseDouble(condHisCHA)/100;
				else if("Q".equals(CHAHisType))
					CHAHisVal= Double.parseDouble(condHisCHA)* totalQuantity;
				else if("V".equals(CHAHisType))
					CHAHisVal= Double.parseDouble(condHisCHA);
				else
					CHAHisVal = 00.0;
				ezc.ezcommon.EzLog4j.log("CHAHisType>>>>>>>"+CHAHisType,"I");
				ezc.ezcommon.EzLog4j.log("CHAHisVal>>>>>>>"+CHAHisVal,"I");
				CHAHisValStr  = new java.math.BigDecimal(CHAHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				CHAHisVal = 00.0;  
			}
			vendWiseCHAHT.put(vend,CHAHisValStr+"#"+CHAValStr+"#"+CHARecValStr);
			vendWiseCHAValueHT.put(vend,condHisCHA+"#"+condCHA);
		}	
		//CHA1
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			CHA1Type  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHA1TYPE"));
			condCHA1  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHA1VAL"));
			String totValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];
			String totRecValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2];
			if("".equals(condCHA1) || "null".equals(condCHA1) || condCHA1==null) 
				condCHA1 = "0"; 			
			try
			{
				if("P".equals(CHA1Type))
				{
					CHA1Val= Double.parseDouble(totValSUP) * Double.parseDouble(condCHA1)/100;
					CHA1RecVal= Double.parseDouble(totRecValSUP) * Double.parseDouble(condCHA1)/100;
				}	
				else if("Q".equals(CHA1Type))
				{
					CHA1Val= Double.parseDouble(condCHA1) * totalQuantity;
					CHA1RecVal= Double.parseDouble(condCHA1) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(CHA1Type))
				{
					CHA1Val= Double.parseDouble(condCHA1);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						CHA1RecVal= Double.parseDouble(condCHA1);						
				}	
				else
				{
					CHA1Val = 00.0;
					CHA1RecVal = 00.0;
				}	

				CHA1ValStr  = new java.math.BigDecimal(CHA1Val).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				CHA1RecValStr  = new java.math.BigDecimal(CHA1RecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				CHA1Val = 00.0; 
				CHA1RecVal = 00.0;
			}
			CHA1HisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHA1HISTYPE"));
			condHisCHA1 = checkNull(rfqVendLinesRet.getFieldValueString(f,"CHA1HISVAL"));
			String totHisValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0];
			if("".equals(condHisCHA1) || "null".equals(condHisCHA1) || condHisCHA1==null) 
				condHisCHA1 = "0"; 			
			try
			{
				if("P".equals(CHA1HisType))
					CHA1HisVal= Double.parseDouble(totHisValSUP) * Double.parseDouble(condHisCHA1)/100;
				else if("Q".equals(CHA1HisType))
					CHA1HisVal= Double.parseDouble(condHisCHA1)* totalQuantity;
				else if("V".equals(CHA1HisType))
					CHA1HisVal= Double.parseDouble(condHisCHA1);
				else
					CHA1HisVal = 00.0;
				ezc.ezcommon.EzLog4j.log("CHA1HisType>>>>>>>"+CHAHisType,"I");
				ezc.ezcommon.EzLog4j.log("CHAHisVal>>>>>>>"+CHAHisVal,"I");
				CHA1HisValStr  = new java.math.BigDecimal(CHA1HisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				CHA1HisVal = 00.0;  
			}
			vendWiseCHA1HT.put(vend,CHA1HisValStr+"#"+CHA1ValStr+"#"+CHA1RecValStr);
			vendWiseCHA1ValueHT.put(vend,condHisCHA1+"#"+condCHA1);
		}			
		//IFRT
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			IFRTType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"IFRTTYPE"));
			condIFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"IFRTVAL"));
			String totValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];
			String totRecValSUP =((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2];
			if("".equals(condIFRT) || "null".equals(condIFRT) || condIFRT==null) 
				condIFRT = "0"; 			
			try
			{
				if("P".equals(IFRTType))
				{
					IFRTVal= Double.parseDouble(totValSUP) * Double.parseDouble(condIFRT)/100;
					IFRTRecVal= Double.parseDouble(totRecValSUP) * Double.parseDouble(condIFRT)/100;
				}	
				else if("Q".equals(IFRTType))
				{
					IFRTVal= Double.parseDouble(condIFRT) * totalQuantity;
					IFRTRecVal= Double.parseDouble(condIFRT) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(IFRTType))
				{
					IFRTVal= Double.parseDouble(condIFRT);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						IFRTRecVal= Double.parseDouble(condIFRT);							
				}	
				else
				{
					IFRTVal = 00.0;
					IFRTRecVal = 00.0;
				}	

				IFRTValStr  = new java.math.BigDecimal(IFRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				IFRTRecValStr  = new java.math.BigDecimal(IFRTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				IFRTVal = 00.0;  
				IFRTRecVal = 00.0;
			}
			IFRTHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"IFRTHISTYPE"));
			condHisIFRT = checkNull(rfqVendLinesRet.getFieldValueString(f,"IFRTHISVAL"));
			String totHisValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0];
			if("".equals(condHisIFRT) || "null".equals(condHisIFRT) || condHisIFRT==null) 
				condHisIFRT = "0"; 			
			try
			{
				if("P".equals(IFRTHisType))
					IFRTHisVal= Double.parseDouble(totHisValSUP) * Double.parseDouble(condHisIFRT)/100;
				else if("Q".equals(IFRTHisType))
					IFRTHisVal= Double.parseDouble(condHisIFRT)* totalQuantity;
				else if("V".equals(IFRTHisType))
					IFRTHisVal= Double.parseDouble(condHisIFRT);
				else
					IFRTHisVal = 00.0;
				IFRTHisValStr  = new java.math.BigDecimal(IFRTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				IFRTHisVal = 00.0;  
			}
			vendWiseIFRTHT.put(vend,IFRTHisValStr+"#"+IFRTValStr+"#"+IFRTRecValStr);
			vendWiseIFRTValueHT.put(vend,condHisIFRT+"#"+condIFRT);
		}
		//OTHER CHARGES
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			OTHType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHTYPE"));
			condOTH  = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHVAL"));
			condOTHVend  = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHVEND"));
			String totValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];
			if("".equals(condOTH) || "null".equals(condOTH) || condOTH==null) 
				condOTH = "0"; 			
			try
			{
				if("V".equals(OTHType))
				{
					OTHVal= Double.parseDouble(condOTH) * Double.parseDouble(exchRate);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)
						OTHRecVal= Double.parseDouble(condOTH)* Double.parseDouble(exchRate);
				}	
				else
				{
					OTHVal = 00.0;
					OTHRecVal = 00.0;
				}	
					
				
				OTHValStr  = new java.math.BigDecimal(OTHVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				OTHRecValStr  = new java.math.BigDecimal(OTHRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				OTHVal = 00.0;  
				OTHRecVal = 00.0; 
			}
			OTHHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHHISTYPE"));
			condHisOTH = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHHISVAL"));
			condHisOTHVend = checkNull(rfqVendLinesRet.getFieldValueString(f,"OTHHISVEND"));
			String totHisValSUP =((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0];
			if("".equals(condHisOTH) || "null".equals(condHisOTH) || condHisOTH==null) 
				condHisOTH = "0"; 			
			try
			{
				if("V".equals(OTHHisType))
					OTHHisVal= Double.parseDouble(condHisOTH);
				else
					OTHHisVal = 00.0;
				ezc.ezcommon.EzLog4j.log("OTHHisType>>>>>>>"+OTHHisType,"I");
				ezc.ezcommon.EzLog4j.log("OTHHisVal>>>>>>>"+OTHHisVal,"I");
				OTHHisVal	= OTHHisVal * Double.parseDouble(exchRate);
				OTHHisValStr  = new java.math.BigDecimal(OTHHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				OTHHisVal = 00.0; 
				OTHHisValStr = "0";
			}
			vendWiseOTHHT.put(vend,OTHHisValStr+"#"+OTHValStr+"#"+OTHRecValStr);
			vendWiseOTHValueHT.put(vend,condHisOTH+"#"+condOTH);
			vendWiseOTHReasonHT.put(vend,condOTHVend+"#"+condHisOTHVend); 
		}		
		
		//ADD IGST
		chkList = new ArrayList();
		for(int g=0;g<rfqVendLinesRetCnt;g++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
			
			condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
			sPriceInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[1]);
			String totBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[1];
			String totSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[1];
			ezc.ezcommon.EzLog4j.log("sPriceInr in ADD GST>>>>>>>"+sPriceInr,"I");
			ezc.ezcommon.EzLog4j.log("totBCDVal in ADD GST>>>>>>>"+totBCDVal,"I");
			ezc.ezcommon.EzLog4j.log("totSWCVal in ADD GST>>>>>>>"+totSWCVal,"I"); 
			sPriceRecInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2]);
			String totBCDRecVal =((String)vendWiseBCDHT.get(vend)).split("#")[2];
			String totSWCRecVal =((String)vendWiseSWCHT.get(vend)).split("#")[2];
			ezc.ezcommon.EzLog4j.log("sPriceRecInr in ADD GST>>>>>>>"+sPriceRecInr,"I");
			ezc.ezcommon.EzLog4j.log("totBCDRecVal in ADD GST>>>>>>>"+totBCDRecVal,"I");
			ezc.ezcommon.EzLog4j.log("totSWCRecVal in ADD GST>>>>>>>"+totSWCRecVal,"I");			
			
			if("".equals(condGST) || "null".equals(condGST) || condGST==null) 
				condGST = "0"; 			
			try
			{
				GSTVal= ((sPriceInr + Double.parseDouble(totBCDVal)+Double.parseDouble(totSWCVal))* Double.parseDouble(condGST)/100);
				GSTValStr  = new java.math.BigDecimal(GSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				ezc.ezcommon.EzLog4j.log("GSTValStr in ADD GST>>>>>>>"+GSTValStr,"I"); 
				GSTRecVal= ((sPriceRecInr + Double.parseDouble(totBCDRecVal)+Double.parseDouble(totSWCRecVal))* Double.parseDouble(condGST)/100);
				GSTRecValStr  = new java.math.BigDecimal(GSTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
				ezc.ezcommon.EzLog4j.log("GSTRecValStr in ADD GST>>>>>>>"+GSTRecValStr,"I"); 
			}
			catch(Exception e)
			{ 
				GSTVal = 00.0; 
				GSTRecVal = 00.0; 
			}	
			condHisGST  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXHISVAL"));
			sPriceHisInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[0]);
			String totHisBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[0];
			String totHisSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[0];
			if("".equals(condHisGST) || "null".equals(condHisGST) || condHisGST==null) 
				condHisGST = "0"; 			
			try
			{
				GSTHisVal= ((sPriceHisInr + Double.parseDouble(totHisBCDVal)+Double.parseDouble(totHisSWCVal))* Double.parseDouble(condHisGST)/100);
				GSTHisValStr  = new java.math.BigDecimal(GSTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				GSTHisVal = 00.0;  
				GSTHisValStr  ="0";
			}
			ezc.ezcommon.EzLog4j.log("vend in ADD GST>>>>>>>"+vend,"I"); 
			vendWiseGSTHT.put(vend,GSTHisValStr+"#"+GSTValStr+"#"+GSTRecValStr);
			vendWiseGSTValueHT.put(vend,condHisGST+"#"+condGST);
			ezc.ezcommon.EzLog4j.log("vendWiseGSTHT>>>>>>>"+vendWiseGSTHT,"I"); 
		}
		//DUTY
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			DUTYType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"DUTYTYPE"));
			String totBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[1];
			String totSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[1];	
			String totBCDRecVal =((String)vendWiseBCDHT.get(vend)).split("#")[2];
			String totSWCRecVal =((String)vendWiseSWCHT.get(vend)).split("#")[2];			
			try
			{
			if("E".equals(DUTYType))
			{
				DUTYVal=  Double.parseDouble(totBCDVal)+Double.parseDouble(totSWCVal);
				DUTYRecVal=  Double.parseDouble(totBCDRecVal)+Double.parseDouble(totSWCRecVal);
				
			}	
			else if("D".equals(FRTType))
			{
				DUTYVal= Double.parseDouble("0");
				DUTYRecVal= Double.parseDouble("0");
			}	

				DUTYValStr  = new java.math.BigDecimal(DUTYVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
				DUTYRecValStr  = new java.math.BigDecimal(DUTYRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
			}
			catch(Exception e){ 
				DUTYVal = 0.0;
				DUTYRecVal = 0.0;
			}
			DUTYHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"IFRTHISTYPE"));
			String totHisBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[0];
			String totHisSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[0];		
			try
			{
			if("E".equals(DUTYHisType))
				DUTYHisVal=  Double.parseDouble(totHisBCDVal)+Double.parseDouble(totHisSWCVal);
			else if("D".equals(FRTType))
				DUTYHisVal= Double.parseDouble("0");

				DUTYHisValStr  = new java.math.BigDecimal(DUTYVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
			}
			catch(Exception e){ 
				DUTYHisVal = 0.0;  
			}			
			
			vendWiseDUTYHT.put(vend,DUTYHisValStr+"#"+DUTYValStr+"#"+DUTYRecValStr);
			
		}			
		
		//LESS GST
		chkList = new ArrayList();
		for(int g=0;g<rfqVendLinesRetCnt;g++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
			
			condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
			sPriceInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[1]);
			String totBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[1];
			String totSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[1];
			sPriceRecInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2]);
			String totBCDRecVal =((String)vendWiseBCDHT.get(vend)).split("#")[2];
			String totSWCRecVal =((String)vendWiseSWCHT.get(vend)).split("#")[2];			
			if("".equals(condGST) || "null".equals(condGST) || condGST==null) 
				condGST = "0"; 			
			try
			{
				GSTVal= ((sPriceInr + Double.parseDouble(totBCDVal)+Double.parseDouble(totSWCVal))* Double.parseDouble(condGST)/100);
				GSTValStr  = new java.math.BigDecimal(GSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				GSTRecVal= ((sPriceRecInr + Double.parseDouble(totBCDRecVal)+Double.parseDouble(totSWCRecVal))* Double.parseDouble(condGST)/100);
				GSTRecValStr  = new java.math.BigDecimal(GSTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
				ezc.ezcommon.EzLog4j.log("GSTRecValStr in ADD GST>>>>>>>"+GSTRecValStr,"I"); 				
			}
			catch(Exception e)
			{ 
				GSTVal = 00.0;
				GSTRecVal = 00.0; 
			}	
			condHisGST  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXHISVAL"));
			sPriceHisInr=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[0]);
			String totHisBCDVal =((String)vendWiseBCDHT.get(vend)).split("#")[0];
			String totHisSWCVal =((String)vendWiseSWCHT.get(vend)).split("#")[0];
			if("".equals(condHisGST) || "null".equals(condHisGST) || condHisGST==null) 
				condHisGST = "0"; 			
			try
			{
				GSTHisVal= ((sPriceHisInr + Double.parseDouble(totHisBCDVal)+Double.parseDouble(totHisSWCVal))* Double.parseDouble(condHisGST)/100);
				GSTHisValStr  = new java.math.BigDecimal(GSTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				GSTHisVal = 00.0;  
			}
			vendWiseGSTHT.put(vend,GSTHisValStr+"#"+GSTValStr+"#"+GSTRecValStr);
			vendWiseGSTValueHT.put(vend,condHisGST+"#"+condGST);
		}	
		//LANDED COST
		for(int l=0;l<rfqVendLinesRetCnt;l++)
		{
			if(chkListSht.contains(rfqVendLinesRet.getFieldValueString(l,"RFQNO")))
			continue;
			else
			chkListSht.add(rfqVendLinesRet.getFieldValueString(l,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(l,"VENDOR");
			String paymentStr=checkNull((String)vendWisePaymentTypeHTSht.get(vend));
			String landCostStr="0",landCostHisStr="0",typeofPayemnt="",hedgeCostStr="",landHedgeCostStr="";
			double landCost=0.0;
			double landCostHis=0.0;
			double hedgeCost=0.0;
			double landHedgeCost=0.0;
			
			
			String quotCurr = rfqVendLinesRet.getFieldValueString(l,"CURR");
				if("".equals(quotCurr) || "null".equals(quotCurr) || quotCurr==null) quotCurr = "INR";			
			
			String hedgeDays = rfqLinesRet.getFieldValueString(l,"HEDDAYS");
			out.println("hedgeDays>>>"+hedgeDays);
			String hedgePer = rfqLinesRet.getFieldValueString(l,"HEDPER");
			out.println("hedgePer>>>"+hedgePer);
			/*if("USD".equals(quotCurr))
				hedgePer ="4.5";
			else
				hedgePer ="6.5"; */
				
			if(!"".equals(paymentStr))
			{
			String erhType=checkNull(paymentStr.split("#")[0]);
			String erhLeadTime=checkNull(paymentStr.split("#")[1]);
			String erhPercent=checkNull(paymentStr.split("#")[2]);
			String totalBasePrice=((String)vendWiseTotqtyWithDisSht.get(vend)).split("#")[1];
			String totalBaseHisPrice=((String)vendWiseTotqtyWithDisSht.get(vend)).split("#")[0];
			String suppPrice=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];

			//out.println("erhType"+erhType+"totalBasePrice"+totalBasePrice+"erhLeadTime"+erhLeadTime+"erhPercent"+erhPercent+"vend"+vend);
			ezc.ezcommon.EzLog4j.log("suppPriceIMP>>>>>>>"+suppPrice,"I");
				if("Credit".equals(erhType))
				{	
					/*typeofPayemnt="Saving";
					try{
					landCost=Double.parseDouble(suppPrice)*((double)8/100)*(Double.parseDouble(erhLeadTime)/365);
					landCostHis=Double.parseDouble(totalBaseHisPrice)-((Double.parseDouble(totalBaseHisPrice)*(1/8)*(1/365))*Double.parseDouble(erhLeadTime));
					}
					catch(Exception e)
					{ 
						landCost = 00.0;  
						landCostHis = 00.0; 
					}*/
					typeofPayemnt="";
					try{
					landCost=Double.parseDouble(suppPrice)- Double.parseDouble(suppPrice)*((double)8/100)*(Double.parseDouble(erhLeadTime)/365);
					landCostHis=Double.parseDouble(totalBaseHisPrice)- Double.parseDouble(totalBaseHisPrice)-((Double.parseDouble(totalBaseHisPrice)*(1/8)*(1/365))*Double.parseDouble(erhLeadTime));
					}
					catch(Exception e)
					{ 
						landCost = 00.0;  
						landCostHis = 00.0; 
					}
					try{
					hedgeCost=Double.parseDouble(suppPrice)*(Double.parseDouble(hedgePer)/Double.parseDouble("100"))*(Double.parseDouble("1")/Double.parseDouble("365"))*Double.parseDouble(hedgeDays);
					
					}
					catch(Exception e)
					{ 
						hedgeCost = 00.0;  
						 
					}					
					//landed Cost with Hedge Cost
					landHedgeCost= landCost+hedgeCost;

				}

				if("Advance".equals(erhType))
				{
					typeofPayemnt="Loss of Pay";
					try{
					landCost=(Double.parseDouble(suppPrice)*(Double.parseDouble(erhPercent)/100)*((double)8/100)*(Double.parseDouble(erhLeadTime)/365));
					//out.println("landCost"+landCost);
					landCostHis=Double.parseDouble(totalBaseHisPrice)+((Double.parseDouble(totalBaseHisPrice)*(Double.parseDouble(erhPercent)/100)*(8/100)*(1/365))*Double.parseDouble(erhLeadTime));

					
					}
					catch(Exception e)
					{ 
						landCost = 00.0;  
						landCostHis = 00.0; 
					}

				}
				//out.println("landCost"+landCost);
			}
			landCostStr=new java.math.BigDecimal(landCost).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			hedgeCostStr=new java.math.BigDecimal(hedgeCost).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			landHedgeCostStr=new java.math.BigDecimal(landHedgeCost).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			//out.println("hedgeCostStr>>>"+hedgeCostStr);
			out.println("landHedgeCostStr>>>"+landHedgeCostStr);
			//landCostHisStr=new java.math.BigDecimal(landCostHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();

			//mapTotalCost.put(vend,landCost);
			list.add(landCost);
			TotalCostStrHT.put(vend,landCostStr+"#"+typeofPayemnt);
			TotalHedCostStrHT.put(vend,landHedgeCostStr+"#"+hedgeCostStr);
		}
		//Total Cost
		chkList = new ArrayList();
		for(int v=0;v<rfqVendLinesRetCnt;v++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(v,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(v,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(v,"VENDOR");
			double grossValieHis=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[0]);
			double grossValie=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseBCDHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseSWCHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseCHAHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseCHA1HT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseIFRTHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseOTHHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[1]);
			double grossRecValie=Double.parseDouble(((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseBCDHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseSWCHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseCHAHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseCHA1HT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseIFRTHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseOTHHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[2]);
			String grossValieStr = new java.math.BigDecimal(grossValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			String grossRecValieStr = new java.math.BigDecimal(grossRecValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			String grossValieHisStr = new java.math.BigDecimal(grossValieHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			ezc.ezcommon.EzLog4j.log("grossValieStr>>>>>>>"+grossValieStr,"I");
			ezc.ezcommon.EzLog4j.log("grossRecValieStr>>>>>>>"+grossRecValieStr,"I");
			vendWiseTotValHT.put(vend,grossValieStr+"#"+grossRecValieStr);
			ezc.ezcommon.EzLog4j.log("vendWiseTotValHT>>>>>>>"+vendWiseTotValHT,"I");
			
			
		}
		// Landed Cost
		List<Double> gvList=new ArrayList<Double>();

		chkList = new ArrayList();
		for(int v=0;v<rfqVendLinesRetCnt;v++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(v,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(v,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(v,"VENDOR");
			//double grossValieHis=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[0]);
			double grossValie=Double.parseDouble(((String)vendWiseTotValHT.get(vend)).split("#")[0])-Double.parseDouble(((String)vendWiseDUTYHT.get(vend)).split("#")[1])-Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[1]);
			String grossValieStr = new java.math.BigDecimal(grossValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			//String grossValieHisStr = new java.math.BigDecimal(grossValieHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			double grossRecValie=Double.parseDouble(((String)vendWiseTotValHT.get(vend)).split("#")[1])-Double.parseDouble(((String)vendWiseDUTYHT.get(vend)).split("#")[2])-Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[2]);
			String grossRecValieStr = new java.math.BigDecimal(grossRecValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();			
			vendWiseGrossValHT.put(vend,grossValieStr+"#"+grossRecValieStr);
			mapTotalCost.put(vend,grossValie);
			gvList.add(grossValie);
		}		
	//********************************
	Hashtable rankWiseHT=new Hashtable();
	int rankCnt=0;
	Map<String, Double> mapSht = sortByValues(mapTotalCost); 
	     // out.println("After Sorting:");
	      Set set2 = mapSht.entrySet();
	      Iterator iterator2 = set2.iterator();
	      while(iterator2.hasNext()) {
	           Map.Entry me2 = (Map.Entry)iterator2.next();
	          // out.print(me2.getKey() + ": ");
	          // out.println(me2.getValue());
	           rankCnt++;
	           String rank="L"+(rankCnt+"");
	           rankWiseHT.put(me2.getKey(),rank);
      }
      //out.println("rankWiseHT"+rankWiseHT);

	Enumeration rankVend = rankWiseHT.keys();
	while(rankVend.hasMoreElements()) 
	{
		String key = (String) rankVend.nextElement();
		key="0000000000"+key;
		key=key.substring(key.length()-10,key.length());
		String val=(String)rankWiseHT.get(key);
		//out.println("val"+val+"key"+key);	
		Vector rankVendVT    =	rfqLinesRet.where(new String[]{"VENDOR"},new String[]{key});
		Vector rfqVendLinesRetVT    =	rfqVendLinesRet.where(new String[]{"VENDOR"},new String[]{key});
		int rankVendVTCnt = 0;
		if(rankVendVT!=null)rankVendVTCnt = rankVendVT.size();
		for(int h=0;h<rankVendVTCnt;h++)
		{
			int index1 = -1;
			try{
			index1 = Integer.parseInt(rankVendVT.get(h)+"");	}
			catch(Exception e){}		
			if(index1>=0)
			{
				String line=rfqLinesRet.getFieldValueString(index1,"LINENO");
				rfqLinesRet.setFieldValueAt("STATRANK",val,index1);
				rfqLinesRet.setFieldValueAt("STATRANKLINENO",val+line,index1);
			}	
		}
		int rfqVendLinesRetVTCnt = 0;
		if(rfqVendLinesRetVT!=null)rfqVendLinesRetVTCnt = rfqVendLinesRetVT.size();
		
		for(int h=0;h<rfqVendLinesRetVTCnt;h++)
		{	
			int index1 = -1;
			try{
			index1 = Integer.parseInt(rfqVendLinesRetVT.get(h)+"");	}
			catch(Exception e){}		
			if(index1>=0)
			{
				String line=rfqVendLinesRet.getFieldValueString(index1,"LINENO");
				rfqVendLinesRet.setFieldValueAt("STATRANK",val,index1);
				rfqVendLinesRet.setFieldValueAt("STATRANKLINENO",val+line,index1);
			}	
		}
	//out.println("rankVendVTCnt"+rankVendVTCnt);	
	} 
	ezc.ezcommon.EzLog4j.log("vendWiseCurrency>>>>>>>"+vendWiseCurrency,"I");									
	rfqLinesRet.sort(new String[]{"STATRANKLINENO"},true);
	rfqVendLinesRet.sort(new String[]{"STATRANKLINENO"},true);
%>	