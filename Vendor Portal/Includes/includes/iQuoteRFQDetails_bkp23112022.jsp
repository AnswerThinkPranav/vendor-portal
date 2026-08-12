<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%!
	public static HashMap sortByValues(HashMap map) 
	{ 
		List list = new LinkedList(map.entrySet());
		// Defined Custom Comparator here
		Collections.sort(list, new Comparator() {
		public int compare(Object o1, Object o2) {
		return ((Comparable) ((Map.Entry) (o1)).getValue())
		  .compareTo(((Map.Entry) (o2)).getValue());
		}
		});
		HashMap sortedHashMap = new LinkedHashMap();
		for (Iterator it = list.iterator(); it.hasNext();) {
		     Map.Entry entry = (Map.Entry) it.next();
		     sortedHashMap.put(entry.getKey(), entry.getValue());
		} 

		return sortedHashMap;
	} 
	public ReturnObjFromRetrieve getPRDetails(String site,ArrayList<String> prList)
	{
		ReturnObjFromRetrieve retObjItem= new ReturnObjFromRetrieve(new String[]{"BANFN","BNFPO","QTY"});
		JCoFunction poFunction = null;
		JCoParameterList sapPurOrd = null;
		for(String tempPrNo:prList)
		{
			try
			{
				JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
				poFunction = EzSAPHandler.getJCoFunction(destination,"BAPI_PR_GETDETAIL");		
				sapPurOrd 	 = poFunction.getImportParameterList();
				sapPurOrd.setValue("NUMBER",tempPrNo);
				sapPurOrd.setValue("SERVICES","X");
				try
				{
					poFunction.execute(destination);
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing BAPI_PR_GETDETAIL>>>"+e,"I");		
				}
				try 
				{

					JCoTable prItemTable = poFunction.getTableParameterList().getTable("PRITEM");
					JCoTable prServLinesTable = poFunction.getTableParameterList().getTable("SERVICELINES");

					if(prItemTable != null && prItemTable.getNumRows() > 0)
					{
						do
						{						
							retObjItem.setFieldValue("BANFN",tempPrNo);
							retObjItem.setFieldValue("BNFPO",prItemTable.getValue("PREQ_ITEM"));
							retObjItem.setFieldValue("QTY",prItemTable.getValue("QUANTITY"));
							retObjItem.addRow();

						}
						while(prItemTable.nextRow());
					}
					/*if(prServLinesTable != null && prServLinesTable.getNumRows() > 0)
					{
						do
						{						
							retObjServLines.setFieldValue("BANFN",tempPrNo);
							retObjServLines.setFieldValue("BNFPO",prServLinesTable.getValue("DOC_ITEM"));
							retObjServLines.setFieldValue("UOM",prServLinesTable.getValue("UOM"));
							retObjServLines.setFieldValue("SHORT_TEXT",prServLinesTable.getValue("SHORT_TEXT"));
							retObjServLines.setFieldValue("SRV_LINE",prServLinesTable.getValue("SRV_LINE"));
							retObjServLines.setFieldValue("SERVICE",prServLinesTable.getValue("SERVICE"));
							retObjServLines.addRow();

						}
						while(prServLinesTable.nextRow());
					}*/


				}catch(Exception e){
						ezc.ezcommon.EzLog4j.log("Exception in Executing BAPI_PR_GETDETAIL>>>"+e,"I");		
				}

			}catch(Exception e){
						ezc.ezcommon.EzLog4j.log("Exception in Executing BAPI_PR_GETDETAIL>>>>>>"+e,"I");		
			}
		}
		return retObjItem;
	}      
%>
<%
	String qcfNo=checkNull(request.getParameter("qcfNo"));
	String fromType=checkNull(request.getParameter("type"));
	ezc.ezparam.EzcParams quoteParams = new ezc.ezparam.EzcParams(false);
	String selVendorCode 	= "";
	String fixVend="";
	String puReqTot="";
	String logonSite1 = (String)session.getValue("SITE");
	
	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));	
	
	ezc.misctransactions.client.EzMiscTransactionsManager quoteMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable quoteTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow quoteTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qryRfq="";
	ezc.ezparam.ReturnObjFromRetrieve rfqStatObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve rfqListObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve ItemRet	=  null;
	ezc.ezparam.ReturnObjFromRetrieve CondRet	=  null;
	ezc.ezparam.ReturnObjFromRetrieve CondHisRet	=  null;
	ezc.ezparam.ReturnObjFromRetrieve rfqLinesRet	=  new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"QCFNO","RFQNO","LINENO","MATERIAL","MATDESC","UOM","QTY","BPRICE","LEADDAYS","CURR","VENDOR","MATTYPE","PAYMENTTYPE","LEADTIME","PERCENT","REASON","STATRANK","ITEMTEXT","POTEXT","STATRANKLINENO","MATGRP"});
	ezc.ezparam.ReturnObjFromRetrieve rfqVendLinesRet	=  new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"PRDET","SAPHSNCODE","HSNCODE","SAPGSTCODE","GSTCODE","QCFNO","RFQNO","PRNO","PRITEMNO","LINENO","CURR","VENDOR","PRICE","DISCVAL","DISCTYPE","PKFWVAL","PKFWTYPE","FRTVAL","FRTTYPE","OTHVAL","OTHTYPE","BFRTVAL","BFRTTYPE","INSVAL","INSTYPE","TAXVAL","TAXTYPE","LEADVAL","LEADTYPE","PRICEHIS","DISCHISVAL","DISCHISTYPE","PKFWHISVAL","PKFWHISTYPE","FRTHISVAL","FRTHISTYPE","BFRTHISVAL","BFRTHISTYPE","INSHISVAL","INSHISTYPE","TAXHISVAL","TAXHISTYPE","LEADHISVAL","LEADHISTYPE","PMNT","INCO","LEADDAYS","MATTYPE","PAYMENTTYPE","LEADTIME","PERCENT","POQTY","STATRANK","STATRANKLINENO","PONUM","RECVAL","DOCVAL","ITEMCAT","QUOTEBY"});
	
	int rfqStatLen=0;
	int rfqLen=0;
	int CondRetCnt = 0;
	int itemCnt = 0;
	
	//RFQ STATUS
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
	//ezc.ezcommon.EzLog4j.log("rfqStatObj>>>>"+rfqStatObj.toEzcString(),"I");
	rfqStatLen    = rfqStatObj.getRowCount();
	ArrayList chkVen = new ArrayList();
	for(int i=0;i<rfqStatLen;i++) 
	{
		chkVen.add(rfqStatObj.getFieldValueString(i,"ERH_SOLD_TO"));
	}

	//Lowest Quote for Material
	ezc.ezparam.ReturnObjFromRetrieve ret_LowestMatPrcObj = null;
	ezc.ezparam.EzcParams lp_quoteParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager lp_quoteMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable lp_quoteTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow lp_quoteTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	lp_quoteTableRow.setQuery("SELECT ERD_LINE_NO,ERD_MATERIAL,MIN(ERD_PRICE) MIN_PRICE FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO IN (SELECT ERH_RFQ_NO FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO = '"+qcfNo+"') AND ERD_PRICE != '0.0000' GROUP BY ERD_MATERIAL");
	lp_quoteTable.appendRow(lp_quoteTableRow);
	lp_quoteParams.setLocalStore("Y");
	lp_quoteParams.setObject(lp_quoteTable);
	Session.prepareParams(lp_quoteParams);
	
	try{
		ret_LowestMatPrcObj=(ezc.ezparam.ReturnObjFromRetrieve)lp_quoteMgr.ezGetMiscTransactions(lp_quoteParams);
	}catch(Exception e){}

	Hashtable lowestPrcHT = new Hashtable();
	for(int lp=0;lp<ret_LowestMatPrcObj.getRowCount();lp++)
		lowestPrcHT.put(ret_LowestMatPrcObj.getFieldValueString(lp,"ERD_LINE_NO"),ret_LowestMatPrcObj.getFieldValueString(lp,"MIN_PRICE"));
		
	//NON SAP VENDORS CHECK
	String nonSAPVendExists = "N";
	ezc.ezparam.ReturnObjFromRetrieve retNonSAP = null;
	ArrayList nonSapVenAL = new ArrayList();
	qryRfq="SELECT ERH_SOLD_TO FROM EZC_RFQ_HEADER,EZC_USERS WHERE ERH_COLLETIVE_RFQ_NO='"+qcfNo+"' AND ERH_STATUS='S' AND ERH_SOLD_TO = LPAD(TRIM(EU_ID),10,0) AND EU_TYPE='4'" ;
	ezc.ezcommon.EzLog4j.log("** NonSAP Query"+qryRfq,"I");

	quoteTableRow.setQuery(qryRfq);
	quoteTable.appendRow(quoteTableRow);
	quoteParams.setLocalStore("Y");
	quoteParams.setObject(quoteTable);
	Session.prepareParams(quoteParams);
	
	try
	{
		retNonSAP=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting RFQ List>>>>>"+e);
	}
	if(retNonSAP.getRowCount()>0)
	{
		nonSAPVendExists = "Y";
		for(int nv=0;nv<retNonSAP.getRowCount();nv++)
		{
			nonSapVenAL.add(retNonSAP.getFieldValueString(nv,"ERH_SOLD_TO"));	
		}
	}
	ezc.ezcommon.EzLog4j.log("** nonSapVenAL"+nonSapVenAL,"I");	
	//RFQ List
	if("FromQuote".equals(fromType))
	qryRfq="SELECT ERH_RFQ_NO,ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE  ERH_STATUS IN ('Y','P') AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
	else
	qryRfq="SELECT ERH_RFQ_NO,ERH_SOLD_TO FROM EZC_RFQ_HEADER WHERE ERH_STATUS IN ('Y','S','P','R') AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'" ;
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
	String soldTo1="";
	
	
	if(rfqLen>0)
	{
		  //rfqNo =rfqListObj.getFieldValueString(0,"ERH_RFQ_NO");
		  //soldTo= rfqListObj.getFieldValueString(0,"ERH_SOLD_TO");
	}
	for(int k=0;k<rfqLen;k++)
	{
		rfqNo = rfqListObj.getFieldValueString(k,"ERH_RFQ_NO");
		soldTo1= rfqListObj.getFieldValueString(k,"ERH_SOLD_TO");
		
		//RFQ DETAILS
		//qryRfq="SELECT ERH_PO_FLAG,ERH_RFQ_NO,ERH_SOLD_TO,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_PUR_ORG,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_RFQ_DATE,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_MAT_TYPE ,ERH_LEAD_DAYS ,ERH_PERCENTAGE ,ERH_REASON,ERH_PLANT,ERH_COMP_CODE,ERH_CATEGORY,ERH_REC_VALUE,ERH_FINAL_VALUE,ERD_LINE_NO,ERD_MATERIAL,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PO_QTY,ERD_PO_NO,ERD_LEAD_DAYS,ERD_CURRENCY,ERD_BUDGET_PRICE,ERD_PRICE,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_VEND_HSN_CODE,ERD_SAP_HSN_CODE,ERD_VEND_GST,ERD_SAP_GST,ERD_MAT_GRP,ERD_ITEM_CAT  FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+rfqNo+"'" ;
		qryRfq="SELECT ERH_PO_FLAG,ERH_SAVE_FLG,ERH_RFQ_NO,ERH_SOLD_TO,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_PUR_ORG,ERH_PUR_GRP,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_RFQ_DATE,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_MAT_TYPE ,ERH_LEAD_DAYS ,ERH_PERCENTAGE ,ERH_REASON,ERH_PLANT,ERH_COMP_CODE,ERH_CATEGORY,ERH_REC_VALUE,ERH_FINAL_VALUE,ERD_LINE_NO,ERD_MATERIAL,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PO_QTY,ERD_PO_NO,ERD_LEAD_DAYS,ERD_CURRENCY,ERD_BUDGET_PRICE,ERD_PRICE,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_VEND_HSN_CODE,ERD_SAP_HSN_CODE,ERD_VEND_GST,ERD_SAP_GST,ERD_MAT_GRP,ERD_ITEM_CAT,date_format(ERD_DELIVERY_DATE,'%d.%m.%Y') AS DELIV_DATE ,ERD_ACC_CAT FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+rfqNo+"'" ;

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
		//ezc.ezcommon.EzLog4j.log("dtlXMLNEW>>>>"+dtlXML.toEzcString(),"I");
		int Count = dtlXML.getRowCount();
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

		//rfqLinesRet = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"RFQNO","LINENO","VENDOR","MATERIAL","MATDESC","UOM","QTY","CURR","PRICE","DISCVAL","DISCTYPE","PKFWVAL","PKFWTYPE","FRTVAL","FRTTYPE","GSTVAL","GSTTYPE"});	


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
		String condHisPrice=null; 
		String prNO="",prItemNO="";
		String type="",leadTime="",percent="",reasonSel="";
		

		for(int i=0;i<Count;i++)
		{
			rfqNum= dtlXML.getFieldValueString(i,"ERH_RFQ_NO");
			rfqLineNo= dtlXML.getFieldValueString(i,"ERD_LINE_NO");
			rfqVendor=dtlXML.getFieldValueString(i,"ERH_SOLD_TO");
			prNO=dtlXML.getFieldValueString(i,"ERH_PR_NO");
			prItemNO=dtlXML.getFieldValueString(i,"ERH_PR_ITEM_NO");
			type=dtlXML.getFieldValueString(i,"ERH_MAT_TYPE");
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
			rfqLinesRet.setFieldValue("BPRICE",dtlXML.getFieldValueString(i,"ERD_BUDGET_PRICE"));
			rfqLinesRet.setFieldValue("LEADDAYS",dtlXML.getFieldValueString(i,"ERD_LEAD_DAYS"));
			rfqLinesRet.setFieldValue("CURR",dtlXML.getFieldValueString(i,"ERD_CURRENCY"));
			rfqLinesRet.setFieldValue("PAYMENTTYPE",dtlXML.getFieldValueString(i,"ERH_MAT_TYPE"));
			rfqLinesRet.setFieldValue("MATTYPE",dtlXML.getFieldValueString(i,"ERH_MAT_TYPE"));
			rfqLinesRet.setFieldValue("LEADTIME",dtlXML.getFieldValueString(i,"ERH_LEAD_DAYS"));
			rfqLinesRet.setFieldValue("PERCENT",dtlXML.getFieldValueString(i,"ERH_PERCENTAGE"));
			rfqLinesRet.setFieldValue("REASON",dtlXML.getFieldValueString(i,"ERH_REASON"));
			rfqLinesRet.setFieldValue("VENDOR",rfqVendor);
			rfqLinesRet.setFieldValue("ITEMTEXT",dtlXML.getFieldValueString(i,"ERD_EXT2"));
			rfqLinesRet.setFieldValue("POTEXT",dtlXML.getFieldValueString(i,"ERD_EXT3"));
			rfqLinesRet.setFieldValue("MATGRP",dtlXML.getFieldValueString(i,"ERD_MAT_GRP"));

			rfqVendLinesRet.setFieldValue("QCFNO",qcfNo);
			rfqVendLinesRet.setFieldValue("RFQNO",rfqNum);
			rfqVendLinesRet.setFieldValue("PRNO",prNO);
			rfqVendLinesRet.setFieldValue("PRITEMNO",prItemNO);
			rfqVendLinesRet.setFieldValue("LINENO",rfqLineNo);
			rfqVendLinesRet.setFieldValue("CURR",dtlXML.getFieldValueString(i,"ERD_CURRENCY"));
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
			rfqVendLinesRet.setFieldValue("PAYMENTTYPE",dtlXML.getFieldValueString(i,"ERH_MAT_TYPE"));
			rfqVendLinesRet.setFieldValue("MATTYPE",dtlXML.getFieldValueString(i,"ERH_MAT_TYPE"));
			rfqVendLinesRet.setFieldValue("LEADTIME",dtlXML.getFieldValueString(i,"ERH_LEAD_DAYS"));
			rfqVendLinesRet.setFieldValue("PERCENT",dtlXML.getFieldValueString(i,"ERH_PERCENTAGE"));
			rfqVendLinesRet.setFieldValue("POQTY",dtlXML.getFieldValueString(i,"ERD_PO_QTY"));
			rfqVendLinesRet.setFieldValue("PONUM",dtlXML.getFieldValueString(i,"ERD_PO_NO"));
			rfqVendLinesRet.setFieldValue("RECVAL",dtlXML.getFieldValueString(i,"ERH_REC_VALUE"));
			rfqVendLinesRet.setFieldValue("DOCVAL",dtlXML.getFieldValueString(i,"ERH_FINAL_VALUE"));
			rfqVendLinesRet.setFieldValue("ITEMCAT",dtlXML.getFieldValueString(i,"ERD_ITEM_CAT"));
			rfqVendLinesRet.setFieldValue("QUOTEBY",dtlXML.getFieldValueString(i,"ERH_SAVE_FLG"));
			
			//puReqTot = "000000010000001868$$2001$$25.07.2021$$25.000$$KG$$Dipotassium Hydrogen Phosphate$$0011263741$$00010$$208$$ $$ $$ $$NB$$$$$$$$INR$$NNJOKSM$$Raw material$$10.03.2022";
			//puReqTot=material+"$$"+plant+"$$"+delDate+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itmno+"$$"+valtype+"$$"+itmTx+"$$"+poTx+"$$"+vendFixed+"$$"+docType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy+"$$"+relDate;
			
			puReqTot=dtlXML.getFieldValueString(i,"ERD_MATERIAL")+"$$"+dtlXML.getFieldValueString(i,"ERD_PLANT")+"$$"+dtlXML.getFieldValueString(i,"DELIV_DATE")+"$$"+dtlXML.getFieldValueString(i,"ERD_QUANTITY")+"$$"+dtlXML.getFieldValueString(i,"ERD_UOM")+"$$"+dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC")+"$$"+dtlXML.getFieldValueString(i,"ERH_PR_NO")+"$$"+dtlXML.getFieldValueString(i,"ERH_PR_ITEM_NO")+"$$"+dtlXML.getFieldValueString(i,"ERH_PUR_GRP")+"$$"+dtlXML.getFieldValueString(i,"ERD_EXT2")+"$$"+dtlXML.getFieldValueString(i,"ERD_EXT3")+"$$"+fixVend+"$$"+"NB"+"$$"+dtlXML.getFieldValueString(i,"ERD_ACC_CAT")+"$$"+dtlXML.getFieldValueString(i,"ERD_ITEM_CAT")+"$$"+""+"$$"+dtlXML.getFieldValueString(i,"ERD_CURRENCY")+"$$"+dtlXML.getFieldValueString(i,"ERD_MAT_GRP")+"$$"+dtlXML.getFieldValueString(i,"ERD_CURRENCY")+"$$"+"PNGEI"+"$$"+dtlXML.getFieldValueString(i,"DELIV_DATE");
			
		

			for(int j=0;j<CondCnt;j++)
			{
				condVendor=CondRet.getFieldValueString(j,"ERIC_VENDOR");
				condRfqNo=CondRet.getFieldValueString(j,"ERIC_RFQ_NO");
				condRfqLineNo=CondRet.getFieldValueString(j,"ERIC_LINE_NO");
				condTaxCode=CondRet.getFieldValueString(j,"ERIC_TAX_CODE");
				condTaxValue=CondRet.getFieldValueString(j,"ERIC_TAX_VALUE");
				condTaxType=CondRet.getFieldValueString(j,"ERIC_TAX_TYPE");

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
					}
					if("OTH".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("OTHVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("OTHTYPE",condTaxType);
					}					
					if("BFRT".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("BFRTVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("BFRTTYPE",condTaxType);
					}
					if("INS".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("INSVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("INSTYPE",condTaxType);
					}					
					if("TAX".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("TAXVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("TAXTYPE",condTaxType);
					}
					if("LEAD".equals(condTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("LEADVAL",condTaxValue);
						rfqVendLinesRet.setFieldValue("LEADTYPE","D");
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
					}
					if("BFRT".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("BFRTHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("BFRTHISTYPE",condHisTaxType);
					}
					if("INS".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("INSHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("INSHISTYPE",condHisTaxType);
					}					
					if("TAX".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("TAXHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("TAXHISTYPE",condHisTaxType);
					}	
					if("LEAD".equals(condHisTaxCode))	
					{
						rfqVendLinesRet.setFieldValue("LEADHISVAL",condHisTaxValue);
						rfqVendLinesRet.setFieldValue("LEADHISTYPE","D");
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
		String FRTType  = "";
		String OTHType  = "";
		String BFRTType = "";
		String INSType = "";
		String TAXType = "";
		String condPKFW = "";		
		String condFRT  = "";
		String condOTH = "";
		String condBFRT = "";
		String condINS  = "";
		String condGST  = "";
		
		String discHisType = "";
		String condHisDisc = "";
		String PKFWHisType = "";
		String condHisPKFW = "";
		String FRTHisType  = "";
		String BFRTHisType  = "";
		String INSHisType  = "";
		String TAXHisType  = "";
		String condHisFRT  = "";
		String condHisBFRT = "";
		String condHisINS  = "";
		String condHisGST  = "";		
		String totalAmoutStr="";
		String basicValStr="";
		String basicValHisStr="";
		String totcondGSTStr="";
		String negPriceStr="";
		
		double totcondGST=0.0;
		double totVal = 0.0;
		double totalAmout=0.0;
		double discVal = 0.0;
		double discTotVal = 0.0;
		double basicVal=0.0;
		double basicValHis=0.0;
		double negPrice=0.0;
		double PKFWVal = 0.0;
		double FRTVal = 0.0;
		double OTHVal = 0.0;
		double BFRTVal = 0.0;
		double INSVal = 0.0;
		double GSTVal = 0.0;
		double sPrice = 0.0;
		double grossVal = 0.0;	
		double totRfqVal = 0.0;	
		
		double PKFWRecVal = 0.0;
		double FRTRecVal = 0.0;
		double OTHRecVal = 0.0;
		double BFRTRecVal = 0.0;
		double INSRecVal = 0.0;
		double getRecVal=0.0;
		double sRecPrice = 0.0;
		double GSTRecVal = 0.0;
		double sPriceRec = 0.0;
		
		
		String totRecQtyStr="0";
		String totRecValStr="0";
		String PKFWRecValStr ="0";
		String FRTRecValStr ="0";
		String OTHRecValStr ="0";
		String BFRTRecValStr ="0";
		String INSRecValStr ="0";
		String sRecPriceStr = "0";
		String GSTRecValStr="0";
		
		double totHisVal = 0.0;
		double discHisVal = 0.0;
		double discUOMHisVal = 0.0;
		double discHisTotVal = 0.0;
		
		double PKFWHisVal = 0.0;
		double FRTHisVal = 0.0;
		double BFRTHisVal = 0.0;
		double INSHisVal = 0.0;
		double GSTHisVal = 0.0;
		double sPriceHis = 0.0;
		double grossHisVal = 0.0;			
		double totPOPrice=0.0;
		
		String totValStr="0";
		String discValStr="0";
		String discTotValStr="0";
		String totPOPriceStr="0";
		
		String PKFWValStr="0";
		String FRTValStr="0";
		String OTHValStr="0";
		String BFRTValStr="0";
		String INSValStr="0";
		String GSTValStr="0";
		String sPriceStr = "0";
		String grossValStr = "0";
		
		
		String totHisValStr="0";
		String discHisValStr="0";
		String discUOMHisValStr="0";
		String discHisTotValStr="0";
		String PKFWHisValStr="0";
		String FRTHisValStr="0";
		String BFRTHisValStr="0";
		String INSHisValStr="0";
		String GSTHisValStr="0";
		String sPriceHisStr = "0";
		String grossHisValStr = "0";
		String discHisAllItemTotValStr="0";
		String discAllItemTotValStr="0";
		double discHisAllItemTotVal = 0.0;
		double discAllItemTotVal = 0.0;

		
		
		
		ArrayList rfqLinesList = new ArrayList();
		ArrayList rfqTotalList = new ArrayList();
		Hashtable vendWiseTotqty=new Hashtable();
		Hashtable vendWiseRecQty=new Hashtable();
		Hashtable vendWiseRecVal=new Hashtable();		
		Hashtable vendWiseTotqtyWithoutDis=new Hashtable();
		Hashtable vendWiseTotAmount=new Hashtable();
		Hashtable vendWiseTotBasePriceHT=new Hashtable();
		Hashtable vendWisePKGTypeHT=new Hashtable();
		Hashtable vendWisePKGHT=new Hashtable();
		Hashtable vendWisePKGValueHT=new Hashtable();
		Hashtable vendWiseFRTTypeHT=new Hashtable();
		Hashtable vendWiseFRTHT=new Hashtable();
		Hashtable vendWiseFRTValueHT=new Hashtable();
		Hashtable vendWiseBFRTTypeHT=new Hashtable();
		Hashtable vendWiseBFRTHT=new Hashtable();
		Hashtable vendWiseBFRTValueHT=new Hashtable();
		Hashtable vendWiseINSTypeHT=new Hashtable();
		Hashtable vendWiseINSHT=new Hashtable(); 
		Hashtable vendWiseINSValueHT=new Hashtable();				
		Hashtable vendWiseSUPPPRICEHT=new Hashtable();
		Hashtable vendWiseGSTTypeHT=new Hashtable();
		Hashtable vendWiseGSTHT=new Hashtable();
		Hashtable vendWiseGSTValueHT=new Hashtable();
		Hashtable vendWisePaymentTypeHT=new Hashtable(); 
		Hashtable vendWiseTotGSTHT=new Hashtable(); 
		Hashtable vendWiseGrossValHT=new Hashtable();
		Hashtable vendWiseRfqHT=new Hashtable();
		Hashtable rfqTotHT=new Hashtable();
		
		double totalQuantity=0.0;
		//double totRfqVal= 0.0;
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
					}	
					//out.println("keyStr"+keyStr);
					try
					{
						totVal= (Double.parseDouble(myQty) * basicVal);
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
			         String avgGstStr  = new java.math.BigDecimal(avgGst).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			        
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
				//out.println("PKFWRecVal>>>>"+PKFWRecVal);
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

				PKFWHisValStr  = new java.math.BigDecimal(PKFWHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//out.println("PKFWHisValStr in QCF"+PKFWHisValStr);
			}
			catch(Exception e)
			{ 
				PKFWHisVal = 00.0;  
			}
	
			
			vendWisePKGHT.put(vend,PKFWHisValStr+"#"+PKFWValStr+"#"+PKFWRecValStr);	
			//out.println("vendWisePKGHT>>>>"+vendWisePKGHT);
			vendWisePKGTypeHT.put(vend,PKFWHisType+"#"+PKFWType);
			vendWisePKGValueHT.put(vend,condHisPKFW+"#"+condPKFW);
			//out.println("vendWisePKGValueHT>>>>"+vendWisePKGValueHT);
			
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
			condFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTVAL"));
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
					else
						FRTRecVal = 00.0; 
				}		
				else
				{
					FRTVal = 00.0;
					FRTRecVal = 00.0;
				}	

				FRTValStr  = new java.math.BigDecimal(FRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				FRTRecValStr  = new java.math.BigDecimal(FRTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				FRTVal = 00.0;  
				FRTRecVal = 00.0;
			}
			FRTHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTHISTYPE"));
			condHisFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"FRTHISVAL"));
			String totHisFRTVal =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[0];
			if("".equals(condHisFRT) || "null".equals(condHisFRT) || condHisFRT==null) 
				condHisFRT = "0"; 			
			try
			{
				if("P".equals(FRTHisType))
					FRTHisVal= Double.parseDouble(totHisFRTVal) * Double.parseDouble(condHisFRT)/100;
				else if("Q".equals(FRTHisType))
					FRTHisVal= Double.parseDouble(condHisFRT)* totalQuantity;
				else if("V".equals(FRTHisType))
					FRTHisVal= Double.parseDouble(condHisFRT);
				else
					FRTHisVal = 00.0;

				FRTHisValStr  = new java.math.BigDecimal(FRTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				FRTHisVal = 00.0;  
			}
			vendWiseFRTHT.put(vend,FRTHisValStr+"#"+FRTValStr+"#"+FRTRecValStr);
			vendWiseFRTTypeHT.put(vend,FRTHisType+"#"+FRTType);
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
			BFRTType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BFRTTYPE"));
			condBFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BFRTVAL"));
			String totValBFRT =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[1];
			if("".equals(condBFRT) || "null".equals(condBFRT) || condBFRT==null) 
				condBFRT = "0"; 
			if("".equals(BFRTType) || "null".equals(BFRTType) || BFRTType==null) 
				BFRTType = "NA"; 				
			try
			{
				if("P".equals(BFRTType))
				{
					BFRTVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condBFRT)/100;
					BFRTRecVal= Double.parseDouble((String)vendWiseRecVal.get(vend)) * Double.parseDouble(condBFRT)/100;
				}	
				else if("Q".equals(BFRTType))
				{
					BFRTVal= Double.parseDouble(condBFRT) * totalQuantity;
					BFRTRecVal= Double.parseDouble(condBFRT) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(BFRTType))
				{
					BFRTVal= Double.parseDouble(condBFRT);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						BFRTRecVal= Double.parseDouble(condBFRT);
					else
						BFRTRecVal = 00.0; 
				}		
				else
				{
					BFRTVal = 00.0;
					BFRTRecVal = 00.0;
				}	

				BFRTValStr  = new java.math.BigDecimal(BFRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				BFRTRecValStr  = new java.math.BigDecimal(BFRTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				BFRTVal = 00.0;  
				BFRTRecVal = 00.0;
			}
			BFRTHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BFRTHISTYPE"));
			condHisBFRT  = checkNull(rfqVendLinesRet.getFieldValueString(f,"BFRTHISVAL"));
			String totHisBFRTVal =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[0];
			if("".equals(condHisBFRT) || "null".equals(condHisBFRT) || condHisBFRT==null) 
				condHisBFRT = "0"; 			
			try
			{
				if("P".equals(BFRTHisType))
					BFRTHisVal= Double.parseDouble(totHisBFRTVal) * Double.parseDouble(condHisBFRT)/100;
				else if("Q".equals(BFRTHisType))
					BFRTHisVal= Double.parseDouble(condHisBFRT)* totalQuantity;
				else if("V".equals(BFRTHisType))
					BFRTHisVal= Double.parseDouble(condHisBFRT);
				else
					BFRTHisVal = 00.0;

				BFRTHisValStr  = new java.math.BigDecimal(BFRTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				BFRTHisVal = 00.0;  
			}
			vendWiseBFRTHT.put(vend,BFRTHisValStr+"#"+BFRTValStr+"#"+BFRTRecValStr);
			vendWiseBFRTTypeHT.put(vend,BFRTHisType+"#"+BFRTType);
			vendWiseBFRTValueHT.put(vend,condHisBFRT+"#"+condBFRT);
		}
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			INSType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"INSTYPE"));
			condINS  = checkNull(rfqVendLinesRet.getFieldValueString(f,"INSVAL"));
			String totValINS =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[1];
			if("".equals(condINS) || "null".equals(condINS) || condINS==null) 
				condINS = "0"; 
			if("".equals(INSType) || "null".equals(INSType) || INSType==null) 
				INSType = "NA"; 				
			try
			{
				if("P".equals(INSType))
				{
					INSVal= Double.parseDouble((String)vendWiseTotAmount.get(vend)) * Double.parseDouble(condINS)/100;
					INSRecVal= Double.parseDouble((String)vendWiseRecVal.get(vend)) * Double.parseDouble(condINS)/100;
				}	
				else if("Q".equals(INSType))
				{
					INSVal= Double.parseDouble(condINS) * totalQuantity;
					INSRecVal= Double.parseDouble(condINS) * Double.parseDouble((String)vendWiseRecQty.get(vend));
				}	
				else if("V".equals(INSType))
				{
					INSVal= Double.parseDouble(condINS);
					if(Double.parseDouble((String)vendWiseRecVal.get(vend))>0)					
						INSRecVal= Double.parseDouble(condINS);
					else
						INSRecVal = 00.0; 
				}		
				else
				{
					INSVal = 00.0;
					INSRecVal = 00.0;
				}	

				INSValStr  = new java.math.BigDecimal(INSVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				INSRecValStr  = new java.math.BigDecimal(INSRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				INSVal = 00.0;  
				INSRecVal = 00.0;
			}
			INSHisType  = checkNull(rfqVendLinesRet.getFieldValueString(f,"INSHISTYPE"));
			condHisINS  = checkNull(rfqVendLinesRet.getFieldValueString(f,"INSHISVAL"));
			String totHisINSVal =((String)vendWiseTotqtyWithoutDis.get(vend)).split("#")[0];
			if("".equals(condHisINS) || "null".equals(condHisINS) || condHisINS==null) 
				condHisINS = "0"; 			
			try
			{
				if("P".equals(INSHisType))
					INSHisVal= Double.parseDouble(totHisINSVal) * Double.parseDouble(condHisINS)/100;
				else if("Q".equals(INSHisType))
					INSHisVal= Double.parseDouble(condHisINS)* totalQuantity;
				else if("V".equals(INSHisType))
					INSHisVal= Double.parseDouble(condHisINS);
				else
					INSHisVal = 00.0;

				INSHisValStr  = new java.math.BigDecimal(INSHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				INSHisVal = 00.0;  
			}
			vendWiseINSHT.put(vend,INSHisValStr+"#"+INSValStr+"#"+INSRecValStr);
			vendWiseINSTypeHT.put(vend,INSHisType+"#"+INSType);
			vendWiseINSValueHT.put(vend,condHisINS+"#"+condINS);
		}		
		chkList = new ArrayList();
		for(int f=0;f<rfqVendLinesRetCnt;f++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
			
			String pkgVal=(String)vendWisePKGHT.get(vend);
			String frtVal=(String)vendWiseFRTHT.get(vend);
			String bfrtVal=(String)vendWiseBFRTHT.get(vend);
			String insVal=(String)vendWiseINSHT.get(vend);
			String totValForSP=(String)vendWiseTotAmount.get(vend);
			String totRecValSP=(String)vendWiseRecVal.get(vend);
			double sPricHis=Double.parseDouble(totValForSP)+Double.parseDouble(pkgVal.split("#")[0])+Double.parseDouble(frtVal.split("#")[0])+Double.parseDouble(bfrtVal.split("#")[0])+Double.parseDouble(insVal.split("#")[0]);
			sPriceHisStr  = new java.math.BigDecimal(sPricHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			double sPricH=Double.parseDouble(totValForSP)+Double.parseDouble(pkgVal.split("#")[1])+Double.parseDouble(frtVal.split("#")[1])+Double.parseDouble(bfrtVal.split("#")[1])+Double.parseDouble(insVal.split("#")[1]);
			sPriceStr  = new java.math.BigDecimal(sPricH).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			sRecPrice=Double.parseDouble(totRecValSP)+Double.parseDouble(pkgVal.split("#")[2])+Double.parseDouble(frtVal.split("#")[2])+Double.parseDouble(bfrtVal.split("#")[2])+Double.parseDouble(insVal.split("#")[2]);
			sRecPriceStr  = new java.math.BigDecimal(sRecPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();			
			vendWiseSUPPPRICEHT.put(vend,sPriceHisStr+"#"+sPriceStr+"#"+sRecPriceStr);
		}
		chkList = new ArrayList();
		for(int g=0;g<rfqVendLinesRetCnt;g++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
			TAXType  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXTYPE"));
			condGST  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXVAL"));
			//condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
			sPrice=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]);
			sPriceRec=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[2]);
			if("".equals(condGST) || "null".equals(condGST) || condGST==null) 
				condGST = "0"; 			
			try
			{
				GSTVal= sPrice * Double.parseDouble(condGST)/100;
				GSTValStr  = new java.math.BigDecimal(GSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				ezc.ezcommon.EzLog4j.log("GSTValStr in ADD GST>>>>>>>"+GSTValStr,"I"); 
				GSTRecVal= sPriceRec * Double.parseDouble(condGST)/100;
				GSTRecValStr  = new java.math.BigDecimal(GSTRecVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
				ezc.ezcommon.EzLog4j.log("GSTRecValStr in ADD GST>>>>>>>"+GSTRecValStr,"I"); 				
			}
			catch(Exception e)
			{ 
				GSTVal = 00.0;  
				GSTRecVal = 00.0;
			}
			TAXHisType  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXHISTYPE"));
			condHisGST  = checkNull(rfqVendLinesRet.getFieldValueString(g,"TAXHISVAL"));
			sPriceHis=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0]);
			if("".equals(condHisGST) || "null".equals(condHisGST) || condHisGST==null) 
				condHisGST = "0"; 			
			try
			{
				GSTHisVal= sPriceHis * Double.parseDouble(condHisGST)/100;
				GSTHisValStr  = new java.math.BigDecimal(GSTHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				GSTHisVal = 00.0;  
				GSTHisValStr  ="0";
			}
			vendWiseGSTHT.put(vend,GSTHisValStr+"#"+GSTValStr+"#"+GSTRecValStr);
			vendWiseGSTTypeHT.put(vend,TAXHisType+"#"+TAXType);
			vendWiseGSTValueHT.put(vend,condHisGST+"#"+condGST);
		}
	for(int l=0;l<rfqVendLinesRetCnt;l++)
	{
		if(chkListSht.contains(rfqVendLinesRet.getFieldValueString(l,"RFQNO")))
		continue;
		else
		chkListSht.add(rfqVendLinesRet.getFieldValueString(l,"RFQNO"));

		String vend=rfqVendLinesRet.getFieldValueString(l,"VENDOR");
		String paymentStr=checkNull((String)vendWisePaymentTypeHTSht.get(vend));
		String landCostStr="0",landCostHisStr="0",typeofPayemnt="";
		double landCost=0.0;
		double landCostHis=0.0;
		if(!"".equals(paymentStr))
		{
		String erhType=checkNull(paymentStr.split("#")[0]);
		String erhLeadTime=checkNull(paymentStr.split("#")[1]);
		String erhPercent=checkNull(paymentStr.split("#")[2]);
		String totalBasePrice=((String)vendWiseTotqtyWithDisSht.get(vend)).split("#")[1];
		String totalBaseHisPrice=((String)vendWiseTotqtyWithDisSht.get(vend)).split("#")[0];
		String suppPrice=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1];

		//out.println("erhType"+erhType+"totalBasePrice"+totalBasePrice+"erhLeadTime"+erhLeadTime+"erhPercent"+erhPercent+"vend"+vend);
			if("Credit".equals(erhType))
			{	
				typeofPayemnt="Saving";
				try{
				landCost=Double.parseDouble(suppPrice)*((double)8/100)*(Double.parseDouble(erhLeadTime)/365);
				landCostHis=Double.parseDouble(totalBaseHisPrice)-((Double.parseDouble(totalBaseHisPrice)*(1/8)*(1/365))*Double.parseDouble(erhLeadTime));
				}
				catch(Exception e)
				{ 
					landCost = 00.0;  
					landCostHis = 00.0; 
				}
				
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
		//landCostHisStr=new java.math.BigDecimal(landCostHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		
//		mapTotalCost.put(vend,landCost);
		list.add(landCost);
		TotalCostStrHT.put(vend,landCostStr+"#"+typeofPayemnt);
		}		
		List<Double> gvList=new ArrayList<Double>();

		chkList = new ArrayList();
		for(int v=0;v<rfqVendLinesRetCnt;v++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(v,"RFQNO")))
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(v,"RFQNO"));

			String vend=rfqVendLinesRet.getFieldValueString(v,"VENDOR");
			double grossValieHis=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[0])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[0]);
			double grossValie=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[1]);
			double grossRecValie=Double.parseDouble(((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[2])+Double.parseDouble(((String)vendWiseGSTHT.get(vend)).split("#")[2]);
			String grossValieStr = new java.math.BigDecimal(grossValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			String grossValieHisStr = new java.math.BigDecimal(grossValieHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
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
	rfqLinesRet.sort(new String[]{"STATRANKLINENO"},true);
	rfqVendLinesRet.sort(new String[]{"STATRANKLINENO"},true);
	
	ReturnObjFromRetrieve prDetailsRetObj=ezMiscSelect(Session,"SELECT * FROM EZC_RFQ_PRS WHERE ERP_QCF_NO='"+qcfNo+"'");
	//ezc.ezcommon.EzLog4j.log("prDetailsRetObj>>>>"+prDetailsRetObj.toEzcString(),"I");
	int prDetailsRetObjCnt = 0;
	if(prDetailsRetObj != null)
		prDetailsRetObjCnt = prDetailsRetObj.getRowCount();	
		
	ArrayList<String> prListTemp=new ArrayList<String>();
	for(int l=0;l<prDetailsRetObjCnt;l++)
	{
		prListTemp.add(prDetailsRetObj.getFieldValueString(l,"ERP_PR_NO"));

	}		
	ezc.ezcommon.EzLog4j.log("prListTemp>>>>"+prListTemp,"I");
	
	int prListTempCnt=prListTemp.size();
	
		int retPRDetObjCnt=0;
		ReturnObjFromRetrieve retPRDetObj = getPRDetails(logonSite1,prListTemp);
		if(retPRDetObj != null)
				retPRDetObjCnt=retPRDetObj.getRowCount();
		ezc.ezcommon.EzLog4j.log("retPRDetObjCnt:::::"+retPRDetObjCnt,"I");
	
	boolean isPrQty=false;
	
	if(retPRDetObj != null && retPRDetObjCnt>0)
	{
	
		for(int l=0;l<prDetailsRetObjCnt;l++)
		{
			String prReq = prDetailsRetObj.getFieldValueString(l,"ERP_PR_NO");
			String prReqItem = prDetailsRetObj.getFieldValueString(l,"ERP_PR_ITEM");
			java.math.BigDecimal prItemQty=new java.math.BigDecimal(prDetailsRetObj.getFieldValueString(l,"ERP_PR_QTY"));	
			ezc.ezcommon.EzLog4j.log("prReq:::::"+prReq,"I");
			ezc.ezcommon.EzLog4j.log("prReqItem:::::"+prReqItem,"I");
			ezc.ezcommon.EzLog4j.log("prItemQty:::::"+prItemQty,"I");
			
			for(int w=0;w<retPRDetObjCnt;w++)
			{
				if(prReq.equals(retPRDetObj.getFieldValueString(w,"BANFN")) && prReqItem.equals(retPRDetObj.getFieldValueString(w,"BNFPO")))
				{
					java.math.BigDecimal prItemChkQty=new java.math.BigDecimal(retPRDetObj.getFieldValueString(w,"QTY"));
					ezc.ezcommon.EzLog4j.log("prItemChkQtyNew:::::"+prItemChkQty,"I");
					ezc.ezcommon.EzLog4j.log("prItemQty:::::"+prItemQty,"I");
					if(prItemQty.compareTo(prItemChkQty)!= 0)
					{
						isPrQty=true;
						break;
					}	
				}
				
				
			}
			
		}
	}
	ezc.ezcommon.EzLog4j.log("isPrQty:::::"+isPrQty,"I");
%>	