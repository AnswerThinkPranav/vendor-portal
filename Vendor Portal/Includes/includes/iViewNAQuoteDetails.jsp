<%@ page import ="ezc.ezparam.*" %>
<%@ page import = "java.util.*"%>
<jsp:useBean id="PoManager" class="ezc.client.EzPurchaseManager" scope="page"></jsp:useBean> 

<%

	String UserType=(String)session.getValue("UserType"); 
	

	String poNum = request.getParameter("PurchaseOrder");
	String expStat = request.getParameter("expStat");	
	String CDate = request.getParameter("EndDate");
		
	int mm=Integer.parseInt(CDate.substring(3,5));

	int dd=Integer.parseInt(CDate.substring(0,2));
	int yy=Integer.parseInt(CDate.substring(6,10));
	GregorianCalendar gc=new GregorianCalendar(yy,mm-1,dd,23,59,59);	//year-month-day-hour-min-sec
	Date closingDate=gc.getTime();

	Date today = new Date();
	
	ezc.ezparam.EzcParams newParams = new ezc.ezparam.EzcParams(false); 
			
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscRfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscRfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
	
	//RFQ DETAILS
	qryStr="SELECT ERH_RFQ_NO,ERH_COLLETIVE_RFQ_NO,ERH_SOLD_TO,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_PUR_ORG,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_MAT_TYPE,ERH_LEAD_DAYS,ERH_PERCENTAGE,ERD_LINE_NO,ERD_MATERIAL,ERD_MATERIAL_DESC,ERD_LEAD_DAYS,ERD_UOM,ERD_QUANTITY,ERD_CURRENCY,ERD_BUDGET_PRICE,ERD_MRP_PRICE,ERD_PRICE,ERD_REMARKS,ERD_PLANT,ERD_EXT2,ERD_EXT3,ERD_VEND_HSN_CODE,ERD_SAP_HSN_CODE,ERD_VEND_GST,ERD_SAP_GST,ERD_DELIVERY_DATE,ERD_WARRANTY,ERD_EXT1,ERD_MAT_GRP,ERH_EXT2,ERD_ACC_CAT,ERD_ITEM_CAT,ERH_LD_CLAUSE,ERH_LD_STATUS,ERH_LD_CLAUSE,ERH_PG_STATUS,ERH_PG_CLAUSE FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+poNum+"'" ;
	
	ezc.ezcommon.EzLog4j.log("** qryStr"+qryStr,"I");

	miscRfqTableRow.setQuery(qryStr);
	miscRfqTable.appendRow(miscRfqTableRow);
	newParams.setLocalStore("Y");
	newParams.setObject(miscRfqTable);
	Session.prepareParams(newParams);
	
	try
	{
		dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(newParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	ezc.ezcommon.EzLog4j.log("dtlXML>>>>"+dtlXML.toEzcString(),"I");
	int Count = dtlXML.getRowCount();
	
	String QuotNo="",curr="";
	if ( Count > 0)
	{
		QuotNo= dtlXML.getFieldValueString(0,"ERD_PRICE");
		curr= dtlXML.getFieldValueString(0,"ERD_CURRENCY");
	}
		
	java.util.Date ordDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_RFQ_DATE");
	java.util.Date chgDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_MODIFIED_ON");
	String rfqVendor = dtlXML.getFieldValueString(0,"ERH_SOLD_TO");
	String rfqBuyer = dtlXML.getFieldValueString(0,"ERH_CREATED_BY");
	ezc.ezcommon.EzLog4j.log("** rfqVendor"+rfqVendor,"I");
	String vendCat = dtlXML.getFieldValueString(0,"ERH_EXT2");
	ezc.ezcommon.EzLog4j.log("** vendCat"+vendCat,"I");
	
	/*
	if("0000600011".equals(rfqVendor))
		vendCat="IMP";
	String vendCat= gv_VendCat;	*/
	
	ezc.ezcommon.EzLog4j.log("chgDate>>>>"+chgDate,"I");
	
	ezc.ezparam.ReturnObjFromRetrieve CondRet	=  null;
	int CondRetCnt = 0;
	
	//Getting RFQ Conditions
	
	qryStr="SELECT * FROM EZC_RFQ_ITEM_CONDITIONS WHERE ERIC_RFQ_NO='"+poNum+"'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr"+qryStr,"I");

	miscRfqTableRow.setQuery(qryStr);
	miscRfqTable.appendRow(miscRfqTableRow);
	newParams.setLocalStore("Y");
	newParams.setObject(miscRfqTable);
	Session.prepareParams(newParams);
	
	try
	{
		CondRet=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(newParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting conditions>>>>>"+e);
	}	
	ezc.ezcommon.EzLog4j.log("CondRet>>>>"+CondRet.toEzcString(),"I");
	int CondCnt = CondRet.getRowCount();
	
	ezc.ezparam.ReturnObjFromRetrieve rfqLinesRet = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"RFQNO","ITEMLEADDAYS","LINENO","MATERIAL","MATDESC","UOM","QTY","CURR","BUDGET","MRP","PRICE","DISCVAL","DISCTYPE","PKFWVAL","PKFWTYPE","FRTVAL","FRTTYPE","OTHVAL","OTHTYPE","FOBVAL","FOBTYPE","BFRTVAL","BFRTTYPE","INSVAL","INSTYPE","GSTVAL","GSTTYPE","BCDVAL","BCDTYPE","SWCVAL","SWCTYPE","CLRVAL","CLRTYPE","CHAVAL","CHATYPE","IFRTVAL","IFRTTYPE","DUTYVAL","DUTYTYPE","VENDHSN","SAPHSN","VENDGST","SAPGST","ITEMTEXT","POTEXT","PLANT","DELDATE","REFPR","PRITEM","TYPE","QCF","REMARKS","WARRANTY","LDSTATUS","PGSTATUS","LDCLAUSE","PGCLAUSE","DISCCODE","FRTCODE"});	
	
	String rfqNum=null;
	String rfqLineNo=null;
	String refPrStr=null;
	String prNo="";
	String prItem="";
	String condRfqNo=null;
	String condRfqLineNo=null;
	String condTaxCode=null;
	String condTaxValue=null;
	String condTaxType=null;
	String condTaxDesc=null;
	
	
	for(int i=0;i<Count;i++)
	{
		rfqNum= dtlXML.getFieldValueString(i,"ERH_RFQ_NO");
		rfqLineNo= dtlXML.getFieldValueString(i,"ERD_LINE_NO");
		
	      	refPrStr= dtlXML.getFieldValueString(i,"ERD_EXT1");
	      	
	      	prNo=refPrStr;
	      	prItem=refPrStr;
	      	
	      	
		
	      	/*if(!"".equals(refPrStr))
	      	{
	      		 prNo=refPrStr.split("¥")[0];
	      		 prItem=refPrStr.split("¥")[1];
	      	}*/	      			
		
		rfqLinesRet.setFieldValue("RFQNO",rfqNum);
		rfqLinesRet.setFieldValue("LINENO",rfqLineNo);
		rfqLinesRet.setFieldValue("MATERIAL",dtlXML.getFieldValueString(i,"ERD_MATERIAL"));
		rfqLinesRet.setFieldValue("MATDESC",dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC"));
		rfqLinesRet.setFieldValue("UOM",dtlXML.getFieldValueString(i,"ERD_UOM"));
		rfqLinesRet.setFieldValue("QTY",dtlXML.getFieldValueString(i,"ERD_QUANTITY"));
		rfqLinesRet.setFieldValue("CURR",dtlXML.getFieldValueString(i,"ERD_CURRENCY"));
		rfqLinesRet.setFieldValue("BUDGET",dtlXML.getFieldValueString(i,"ERD_BUDGET_PRICE"));
		rfqLinesRet.setFieldValue("MRP",dtlXML.getFieldValueString(i,"ERD_MRP_PRICE"));
		rfqLinesRet.setFieldValue("PRICE",dtlXML.getFieldValueString(i,"ERD_PRICE"));
		rfqLinesRet.setFieldValue("ITEMLEADDAYS",dtlXML.getFieldValueString(i,"ERD_LEAD_DAYS"));
		rfqLinesRet.setFieldValue("VENDHSN",dtlXML.getFieldValueString(i,"ERD_VEND_HSN_CODE"));
		rfqLinesRet.setFieldValue("SAPHSN",dtlXML.getFieldValueString(i,"ERD_SAP_HSN_CODE"));
		rfqLinesRet.setFieldValue("VENDGST",dtlXML.getFieldValueString(i,"ERD_VEND_GST"));
		rfqLinesRet.setFieldValue("SAPGST",dtlXML.getFieldValueString(i,"ERD_SAP_GST"));
		rfqLinesRet.setFieldValue("ITEMTEXT",dtlXML.getFieldValueString(i,"ERD_EXT2"));
		rfqLinesRet.setFieldValue("POTEXT",dtlXML.getFieldValueString(i,"ERD_EXT3"));
		rfqLinesRet.setFieldValue("PLANT",dtlXML.getFieldValueString(i,"ERD_PLANT"));
		rfqLinesRet.setFieldValue("DELDATE",(java.util.Date)dtlXML.getFieldValue(i,"ERD_DELIVERY_DATE"));
		rfqLinesRet.setFieldValue("WARRANTY",dtlXML.getFieldValueString(i,"ERD_WARRANTY"));
		rfqLinesRet.setFieldValue("REMARKS",dtlXML.getFieldValueString(i,"ERD_REMARKS"));
		rfqLinesRet.setFieldValue("REFPR",prNo);
		rfqLinesRet.setFieldValue("PRITEM",prItem);
		rfqLinesRet.setFieldValue("TYPE",dtlXML.getFieldValueString(i,"ERH_EXT2"));
		rfqLinesRet.setFieldValue("QCF",dtlXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO"));
		rfqLinesRet.setFieldValue("LDSTATUS",dtlXML.getFieldValueString(i,"ERH_LD_STATUS"));
		rfqLinesRet.setFieldValue("LDCLAUSE",dtlXML.getFieldValueString(i,"ERH_LD_CLAUSE"));
		rfqLinesRet.setFieldValue("PGSTATUS",dtlXML.getFieldValueString(i,"ERH_PG_STATUS"));
		rfqLinesRet.setFieldValue("PGCLAUSE",dtlXML.getFieldValueString(i,"ERH_PG_CLAUSE"));
		
		for(int j=0;j<CondCnt;j++)
		{
			condRfqNo=CondRet.getFieldValueString(j,"ERIC_RFQ_NO");
			condRfqLineNo=CondRet.getFieldValueString(j,"ERIC_LINE_NO");
			condTaxCode=CondRet.getFieldValueString(j,"ERIC_TAX_CODE");
			condTaxValue=CondRet.getFieldValueString(j,"ERIC_TAX_VALUE");
			condTaxType=CondRet.getFieldValueString(j,"ERIC_TAX_TYPE");
			condTaxDesc=CondRet.getFieldValueString(j,"ERIC_EXT4");
			ezc.ezcommon.EzLog4j.log("condTaxDesc>>>>"+condTaxDesc,"I");
			
			if((condRfqNo.equals(rfqNum)) && (condRfqLineNo.equals(rfqLineNo)))
			{
				if("DISC".equals(condTaxCode))
				{
					rfqLinesRet.setFieldValue("DISCVAL",condTaxValue);
					rfqLinesRet.setFieldValue("DISCTYPE",condTaxType);
					rfqLinesRet.setFieldValue("DISCCODE",condTaxDesc);
				}	
				if("PKFW".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("PKFWVAL",condTaxValue);
					rfqLinesRet.setFieldValue("PKFWTYPE",condTaxType); 
				}
				if("FRT".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("FRTVAL",condTaxValue);
					rfqLinesRet.setFieldValue("FRTTYPE",condTaxType);
					rfqLinesRet.setFieldValue("FRTCODE",condTaxDesc);
				}
				if("OTH".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("OTHVAL",condTaxValue);
					rfqLinesRet.setFieldValue("OTHTYPE",condTaxType);
				}
				if("FOB".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("FOBVAL",condTaxValue);
					rfqLinesRet.setFieldValue("FOBTYPE",condTaxType);
				}				
				if("BFRT".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("BFRTVAL",condTaxValue);
					rfqLinesRet.setFieldValue("BFRTTYPE",condTaxType);
				}
				if("INS".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("INSVAL",condTaxValue);
					rfqLinesRet.setFieldValue("INSTYPE",condTaxType);
				}				
				if("TAX".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("GSTVAL",condTaxValue);
					rfqLinesRet.setFieldValue("GSTTYPE",condTaxType);
				}
				if("BCD".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("BCDVAL",condTaxValue);
					rfqLinesRet.setFieldValue("BCDTYPE",condTaxType);
				}
				if("SWC".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("SWCVAL",condTaxValue);
					rfqLinesRet.setFieldValue("SWCTYPE",condTaxType);
				}
				if("CLR".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("CLRVAL",condTaxValue);
					rfqLinesRet.setFieldValue("CLRTYPE",condTaxType);
				}				
				if("CHA".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("CHAVAL",condTaxValue);
					rfqLinesRet.setFieldValue("CHATYPE",condTaxType);
				}				
				if("IFRT".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("IFRTVAL",condTaxValue);
					rfqLinesRet.setFieldValue("IFRTTYPE",condTaxType);
				}
				if("DUTY".equals(condTaxCode))	
				{
					rfqLinesRet.setFieldValue("DUTYVAL",condTaxValue);
					rfqLinesRet.setFieldValue("DUTYTYPE",condTaxType);
				}								
			
			}
		}	
		rfqLinesRet.addRow();
	}
	
	ezc.ezcommon.EzLog4j.log("rfqLinesRet>>>>>>>"+rfqLinesRet.toEzcString(),"I");
	int  rfqLinesRetCnt= rfqLinesRet.getRowCount();
	
	
	
	ezc.ezparam.ReturnObjFromRetrieve docCommentsRet	=  null;
	int docCommentsRetCnt = 0;	
	
	//Getting Document Comments
	
	qryStr="SELECT * FROM EZC_DOCUMENT_COMMENTS WHERE EDC_DOC_ID='"+poNum+"'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr"+qryStr,"I");

	miscRfqTableRow.setQuery(qryStr);
	miscRfqTable.appendRow(miscRfqTableRow);
	newParams.setLocalStore("Y");
	newParams.setObject(miscRfqTable);
	Session.prepareParams(newParams);
	
	try
	{
		docCommentsRet=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(newParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting comments>>>>>"+e);
	}
	
	if(docCommentsRet!=null)
	{
		docCommentsRetCnt = docCommentsRet.getRowCount();
		docCommentsRet.sort(new String[]{"EDC_DATE"},true);
	}	
	ezc.ezcommon.EzLog4j.log("docCommentsRet>>"+docCommentsRet.toEzcString(),"I");	
%>
