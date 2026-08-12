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
	/*
	EzPurchDtlXML dtlXML = null;
	EzPSIInputParameters iparams = new EzPSIInputParameters();
	iparams.setOrderNumber(poNum);
	ezc.ezparam.EzcPurchaseParams newParams = new ezc.ezparam.EzcPurchaseParams();
	ezc.ezpurchase.params.EziPurOrderDetailsParams testparams = new ezc.ezpurchase.params.EziPurOrderDetailsParams();
	newParams.createContainer();
	newParams.setObject(iparams);
	newParams.setObject(testparams);
	Session.prepareParams(newParams);

	dtlXML =  (EzPurchDtlXML)PoManager.ezPurchaseOrderStatus(newParams);
	java.util.Date ordDate = (java.util.Date)dtlXML.getFieldValue(0,"ORDERDATE");
	String OrderDt = FormatDate.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
	int Count = dtlXML.getRowCount();

	ReturnObjFromRetrieve retHead = (ReturnObjFromRetrieve)dtlXML.getObject("HEADER");
	
	
	
	String QuotNo="";
	if ( retHead.getRowCount() > 0)
		QuotNo= retHead.getFieldValueString(0,"QUOTATION");
	//ezc.ezcommon.EzLog4j.log("retHead>>>>"+retHead.toEzcString(),"I");	

	ReturnObjFromRetrieve retHeadText = (ReturnObjFromRetrieve)dtlXML.getObject("HEADERTEXT");


	Hashtable htexts=new Hashtable();
	if(retHeadText!=null)
	{
		for (int i=0; i < retHeadText.getRowCount() ; i++)
		{
			htexts.put(retHeadText.getFieldValueString(i,"PONO"),retHeadText.getFieldValueString(i,"TEXTLINE"));
		}
	}
	
	
	//ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** dtlXML"+dtlXML.toEzcString(),"I");
	//ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** retHead"+retHead.toEzcString(),"I");
	//ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** retHeadText"+retHeadText.toEzcString(),"I");*/
	
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
			
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qry1="";
	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
	
	//RFQ DETAILS
	//qry1="SELECT ERH_RFQ_NO,ERH_SOLD_TO,ERH_STATUS,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_PR_NO,ERH_LD_CLAUSE,ERH_EXT2,ERD_LINE_NO,ERD_MATERIAL,ERD_DELIVERY_DATE,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PRICE,ERD_CURRENCY,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_WARRANTY,ERD_MAT_GRP  FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+poNum+"'" ;
	//qry1="SELECT ERH_RFQ_NO,ERH_SOLD_TO,ERH_STATUS,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_PR_NO,ERH_LD_CLAUSE,ERH_EXT2,ERH_PUR_ORG,ERH_COMP_CODE,ERD_LINE_NO,ERD_MATERIAL,ERD_DELIVERY_DATE,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PRICE,ERD_CURRENCY,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_WARRANTY,ERD_MAT_GRP  FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+poNum+"'" ;
	qry1="SELECT ERH_RFQ_NO,ERH_SOLD_TO,ERH_STATUS,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_PR_NO,ERH_LD_CLAUSE,ERH_EXT2,ERH_PUR_ORG,ERH_COMP_CODE,ERD_LINE_NO,ERD_MATERIAL,ERD_DELIVERY_DATE,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PRICE,ERD_CURRENCY,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_WARRANTY,ERD_MAT_GRP,ERD_ORDER_UNIT FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO='"+poNum+"'" ;
	
	ezc.ezcommon.EzLog4j.log("** qry1"+qry1,"I");

	miscTableRow1.setQuery(qry1);
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	
	try
	{
		dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	//ezc.ezcommon.EzLog4j.log("dtlXML>>>>"+dtlXML.toEzcString(),"I");
	int Count = dtlXML.getRowCount();
	
	String QuotNo="";
	if ( Count > 0)
		QuotNo= dtlXML.getFieldValueString(0,"ERD_PRICE");
		
	java.util.Date ordDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_RFQ_DATE");
	java.util.Date chgDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_MODIFIED_ON");
	String rfqVendor = dtlXML.getFieldValueString(0,"ERH_SOLD_TO");
	String rfqBuyer = dtlXML.getFieldValueString(0,"ERH_CREATED_BY");
	String chkStatus = dtlXML.getFieldValueString(0,"ERH_STATUS");
	String compCode = dtlXML.getFieldValueString(0,"ERH_COMP_CODE");
	String purOrg = dtlXML.getFieldValueString(0,"ERH_PUR_ORG");
	
	ezc.ezcommon.EzLog4j.log("chgDate>>>>"+chgDate,"I");	
	ezc.ezcommon.EzLog4j.log("chkStatus>>>>"+chkStatus,"I");
	ezc.ezcommon.EzLog4j.log("compCode>>>>"+compCode,"I");
	ezc.ezcommon.EzLog4j.log("purOrg>>>>"+purOrg,"I");
		
	ezc.ezparam.ReturnObjFromRetrieve docCommentsRet	=  null;
	int docCommentsRetCnt = 0;
	
	//Getting Document Comments
	
	qry1="SELECT * FROM EZC_DOCUMENT_COMMENTS WHERE EDC_DOC_ID='"+poNum+"'" ;
	ezc.ezcommon.EzLog4j.log("** qry1"+qry1,"I");

	miscTableRow1.setQuery(qry1);
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	
	try
	{
		docCommentsRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
	if(docCommentsRet!=null)
	{
		docCommentsRetCnt = docCommentsRet.getRowCount();
		docCommentsRet.sort(new String[]{"EDC_DATE"},true);
	}	
	//ezc.ezcommon.EzLog4j.log("docCommentsRet>>"+docCommentsRet.toEzcString(),"I");
	
	
%>
