<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<% 
 	int shipmentsCnt 	= 0;
 	int toBeAckPOsCount = 0;
	int toBeQuotedRFQsCnt = 0;
	int toBeReQuotedRFQsCnt = 0;
	int toBeActPrdPO = 0;
	int toActRFQsCnt = 0;
	int toActImpRFQsCnt = 0;
	int toActVendCnt=0;
 	String vendRegSts="";
 	String createdBy="";
 	String vendType="";
 	String purOrg="";
 	String compCode="";
 	String plant="";
 	int openVendChngsCnt    = 0;
 	int toAckVendAuctions = 0;
 	int currentVendAuctions = 0;
 	int toBeApprAuctions = 0;
 	int toBeApprPOs = 0;
 	int toBeApprQCFs = 0;
 	int toBeActQrys = 0;
 	int toBePOCreate = 0;
 	int toBeApprVNRs = 0;
 	int toBeSAPVNRs = 0;
 	int toBeApprImpVNRs = 0;
 	int toBeSAPImpVNRs = 0; 
 	
 	ezc.ezcommon.EzLog4j.log("** userType"+userType,"I");
 	ezc.ezcommon.EzLog4j.log("** soldTo"+soldTo,"I");
 	
 	ReturnObjFromRetrieve retObj = null;
 	String qryStr = "";
 		
	if("3".equals(userType) || "4".equals(userType))
		qryStr = " AND EZSH_SOLD_TO ='"+soldTo+"' ";
	qryStr	= qryStr+" AND EZSH_STATUS IN ('Y')";
 	
 	ezc.ezparam.EzcParams v_MainParams = new ezc.ezparam.EzcParams(true);

	
	if("3".equals(userType) || "4".equals(userType))
	{
		//TO QUOTE RFQ COUNT
		ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		ReturnObjFromRetrieve hdrXML = null;

		ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

		String qryRFQ="";
		qryRFQ="SELECT * FROM EZC_RFQ_HEADER WHERE ERH_SOLD_TO='"+soldTo+"' AND ERH_STATUS='N' AND ERH_VALID_UPTO >=NOW()";
		ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
		rfqTableRow.setQuery(qryRFQ);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams); 

		try
		{
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		ezc.ezcommon.EzLog4j.log("hdrXML>>>>"+hdrXML.toEzcString(),"I");
		if(hdrXML!=null && hdrXML.getRowCount()>0)
			toBeQuotedRFQsCnt = hdrXML.getRowCount(); 
			ezc.ezcommon.EzLog4j.log("toBeQuotedRFQsCnt"+toBeQuotedRFQsCnt,"I");
			
		//REQUOTE RFQ	
			
		qryRFQ="SELECT * FROM EZC_RFQ_HEADER WHERE ERH_SOLD_TO='"+soldTo+"' AND ERH_STATUS='R' AND ERH_VALID_UPTO >=NOW()";
		ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
		rfqTableRow.setQuery(qryRFQ);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		ezc.ezcommon.EzLog4j.log("hdrXML>>>>"+hdrXML.toEzcString(),"I");
		if(hdrXML!=null && hdrXML.getRowCount()>0)
			toBeReQuotedRFQsCnt = hdrXML.getRowCount(); 
			ezc.ezcommon.EzLog4j.log("toBeReQuotedRFQsCnt"+toBeReQuotedRFQsCnt,"I");
	
		if("4".equals(userType))
		{
			ezc.ezparam.EzcParams venMainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.params.EzMiscTable miscVendTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscVendTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve retVendItems	  =	null;	 

			venMainParams = new ezc.ezparam.EzcParams(false); 				
			miscVendTable = new ezc.misctransactions.params.EzMiscTable();
			miscVendTableRow = new ezc.misctransactions.params.EzMiscTableRow(); 
			ezc.ezparam.ReturnObjFromRetrieve retVendHeader	  =	null;	 

			//***********************************GET ITEM DETAILS*****************************************************
			miscVendTableRow.setQuery("SELECT ECFH_CREATED_BY,ECFH_STATUS,ECFH_VEN_TYPE,ECFH_EXT1,ECFH_SALES_ORG,ECFH_PLANT from EZC_CUSTOMER_FORM_HEADER  WHERE ECFH_DOC_ID='"+Session.getUserId()+"'");
			miscVendTable.appendRow(miscVendTableRow);
			venMainParams.setLocalStore("Y");
			venMainParams.setObject(miscVendTable);
			Session.prepareParams(venMainParams); 
			try
			{
			retVendHeader=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(venMainParams);
			if(retVendHeader != null)
				createdBy = retVendHeader.getFieldValueString(0,"ECFH_CREATED_BY");
				vendRegSts = retVendHeader.getFieldValueString(0,"ECFH_STATUS");
				vendType = retVendHeader.getFieldValueString(0,"ECFH_VEN_TYPE");
				purOrg = retVendHeader.getFieldValueString(0,"ECFH_SALES_ORG");
				compCode = retVendHeader.getFieldValueString(0,"ECFH_EXT1");
				plant = retVendHeader.getFieldValueString(0,"ECFH_PLANT");
				ezc.ezcommon.EzLog4j.log("** plant2004>>>>>"+plant,"I");
			}
			catch(Exception e)
			{
			}
		}
		
		
		
		//PO ACKNOWLEDGEMENT COUNT
		ezc.ezparam.EzcParams mainCountParams = new ezc.ezparam.EzcParams(true);
		mainCountParams.setLocalStore("Y");	    
		ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();

		iParams.setDocStatus("X");
		iParams.setSysKey(userSyskeysStr);
		iParams.setSoldTo(soldTo);	

		mainCountParams.setObject(iParams);	
		Session.prepareParams(mainCountParams);

		try
		{
			ezc.ezparam.ReturnObjFromRetrieve toBeAckPOsRet = (ezc.ezparam.ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(mainCountParams);

			if(toBeAckPOsRet != null)
				toBeAckPOsCount=toBeAckPOsRet.getRowCount();
		}		
		catch(Exception e){}
		
		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String qryPRDPO="SELECT COUNT(EPPH_DOC_NO) AS PRDPOCOUNT FROM EZC_PO_PRODPLAN_HEADER WHERE EPPH_DOC_STATUS='N' AND EPPH_SOLD_TO='"+soldTo+"'";
		ezc.ezcommon.EzLog4j.log("** qryPRDPO"+qryPRDPO,"I");	
		rfqTableRow.setQuery(qryPRDPO);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		ezc.ezcommon.EzLog4j.log("hdrXML>>>>"+hdrXML.toEzcString(),"I");
		if(hdrXML!=null && hdrXML.getRowCount()>0)
		{
			try
			{
				toBeActPrdPO = Integer.parseInt(hdrXML.getFieldValueString(0,"PRDPOCOUNT")); 
			}
			catch(Exception e){}
		}
			ezc.ezcommon.EzLog4j.log("toBeActPrdPO"+toBeActPrdPO,"I");
		
		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String vendPendCountQry="select (SELECT  count(EAH_AUCTION_ID) FROM EZC_AUCTION_HEADER,EZC_AUCTION_SUPPLIER WHERE EAH_AUCTION_ID = EAS_AUCTION_ID AND now() BETWEEN EAH_START_DATE AND EAH_END_DATE  AND EAS_SUPPLIER_CODE = '"+soldTo+"' AND EAH_AUCTION_STATUS IN ('E') AND EAS_ACKNOWLEDGE_STATUS IN ('A')) AS CURRENT_AUCTIONS,(SELECT  count(EAH_AUCTION_ID) FROM EZC_AUCTION_HEADER,EZC_AUCTION_SUPPLIER WHERE EAH_AUCTION_ID = EAS_AUCTION_ID AND EAS_SUPPLIER_CODE = '"+soldTo+"' AND EAH_AUCTION_STATUS IN ('E') AND EAS_ACKNOWLEDGE_STATUS IN ('N')) AS TO_ACK_AUCTIONS from dual";
		
		rfqTableRow.setQuery(vendPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toAckVendAuctions  = Integer.parseInt(hdrXML.getFieldValueString(0,"TO_ACK_AUCTIONS")); 
			currentVendAuctions  = Integer.parseInt(hdrXML.getFieldValueString(0,"CURRENT_AUCTIONS")); 

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
	}
	if("2".equals(userType))
	{
		ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		ReturnObjFromRetrieve hdrXML = null;

		ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

		String qryRFQ="";

		qryRFQ="SELECT * FROM EZC_RFQ_HEADER WHERE ERH_CREATED_BY='"+Session.getUserId()+"' AND ERH_STATUS='P' AND ERH_EXT2='DOM' AND ERH_VALID_UPTO >=NOW()";
		ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
		rfqTableRow.setQuery(qryRFQ);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Domestic RFQ List>>>>>"+e);
		}
		ezc.ezcommon.EzLog4j.log("hdrXML>>>>"+hdrXML.toEzcString(),"I");
		if(hdrXML!=null && hdrXML.getRowCount()>0)
			toActRFQsCnt = hdrXML.getRowCount(); 
			ezc.ezcommon.EzLog4j.log("toActRFQsCnt"+toActRFQsCnt,"I");
			
		//IMPORT RFQ
		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		qryRFQ="SELECT * FROM EZC_RFQ_HEADER WHERE ERH_CREATED_BY='"+Session.getUserId()+"' AND ERH_STATUS='P' AND ERH_EXT2='IMP' AND ERH_VALID_UPTO >=NOW()";
		
		rfqTableRow.setQuery(qryRFQ);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			
		}
		catch(Exception e)
		{
			out.println("Exception in getting Import RFQ List>>>>>"+e);
		}				
		
		if(hdrXML!=null && hdrXML.getRowCount()>0)
			toActImpRFQsCnt = hdrXML.getRowCount(); 
			ezc.ezcommon.EzLog4j.log("toActImpRFQsCnt"+toActImpRFQsCnt,"I");		
		
		
		//AUCTION

		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String vendPendCountQry="select (select count(a.EAH_AUCTION_ID) AS TOBEAPPAUCTION from ezc_auction_header a,ezc_wf_doc_history_header b where a.EAH_AUCTION_ID=b.EWDHH_DOC_ID  and concat(a.EAH_PLANT,'#',a.EAH_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('SUBMITTED','REJECTED') and b.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')) AS TOBEAPPAUCTION from dual";
		
		rfqTableRow.setQuery(vendPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeApprAuctions  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEAPPAUCTION")); 
			

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
		//POS
		
		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String vendPOCountQry="select (select count(a.EZPA_DOC_NO) AS TOBEAPPPOS from ezc_po_acknowledgement a,ezc_wf_doc_history_header b where a.EZPA_DOC_NO=b.EWDHH_DOC_ID  and concat(a.EZPA_PLANT,'#',a.EZPA_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('SUBMITTED','REJECTED') and b.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')) AS TOBEAPPPOS from dual";

		rfqTableRow.setQuery(vendPOCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeApprPOs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEAPPPOS")); 


		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
		
		
		//QCF

		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String qcfPendCountQry="select(select COUNT(DISTINCT(A.ERH_COLLETIVE_RFQ_NO)) AS TOBEAPPQCF from ezc_Rfq_header a,ezc_wf_doc_history_header b where a.ERH_COLLETIVE_RFQ_NO=b.EWDHH_DOC_ID and CONCAT(a.ERH_PLANT,'#',a.ERH_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('SUBMITTED','REJECTED') and b.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')) AS TOBEAPPQCF,(select COUNT(DISTINCT(A.ERH_COLLETIVE_RFQ_NO)) AS TOBEAPPQCF from ezc_Rfq_header a,ezc_wf_doc_history_header b where a.ERH_COLLETIVE_RFQ_NO=b.EWDHH_DOC_ID and CONCAT(a.ERH_PLANT,'#',a.ERH_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('APPROVED') and (A.ERH_PO_FLAG IS NULL OR A.ERH_PO_FLAG='' )) AS TOBEPOCR from dual";
		
		rfqTableRow.setQuery(qcfPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeApprQCFs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEAPPQCF")); 
			toBePOCreate  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEPOCR")); 

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
		// DOMESTIC VNR

		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		qcfPendCountQry="select(select COUNT(DISTINCT(A.ECFH_DOC_ID)) AS TOBEAPPVNRS from ezc_customer_form_header a,ezc_wf_doc_history_header b where a.ECFH_DOC_ID=b.EWDHH_DOC_ID and CONCAT(a.ECFH_PLANT,'#',a.ECFH_CATEGORY) in ('"+gv_CategoriesForQry+"') and ECFH_VEN_TYPE in ('IN') and b.EWDHH_WF_STATUS in ('SUBMITTED','REJECTED') and b.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')) AS TOBEAPPVNRS,(select COUNT(DISTINCT(A.ECFH_DOC_ID)) AS TOBEAPPVNRS from ezc_customer_form_header a,ezc_wf_doc_history_header b where a.ECFH_DOC_ID=b.EWDHH_DOC_ID and CONCAT(a.ECFH_PLANT,'#',a.ECFH_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('APPROVED')) AS TOBESAPVNRS from dual";

		
		rfqTableRow.setQuery(qcfPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeApprVNRs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEAPPVNRS")); 
			toBeSAPVNRs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBESAPVNRS")); 

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		// IMPORT VNR

		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		qcfPendCountQry="select(select COUNT(DISTINCT(A.ECFH_DOC_ID)) AS TOBEAPPVNRS from ezc_customer_form_header a,ezc_wf_doc_history_header b where a.ECFH_DOC_ID=b.EWDHH_DOC_ID and CONCAT(a.ECFH_PLANT,'#',a.ECFH_CATEGORY) in ('"+gv_CategoriesForQry+"') and ECFH_VEN_TYPE in ('IM') and b.EWDHH_WF_STATUS in ('SUBMITTED','REJECTED') and b.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')) AS TOBEAPPVNRS,(select COUNT(DISTINCT(A.ECFH_DOC_ID)) AS TOBEAPPVNRS from ezc_customer_form_header a,ezc_wf_doc_history_header b where a.ECFH_DOC_ID=b.EWDHH_DOC_ID and CONCAT(a.ECFH_PLANT,'#',a.ECFH_CATEGORY) in ('"+gv_CategoriesForQry+"') and b.EWDHH_WF_STATUS in ('APPROVED')) AS TOBESAPVNRS from dual";

		
		rfqTableRow.setQuery(qcfPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeApprImpVNRs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEAPPVNRS")); 
			toBeSAPImpVNRs  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBESAPVNRS")); 

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}		
		
		//QCF QUERY

		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		qcfPendCountQry="select COUNT(*) AS TOBEACTQRY from ezc_qcf_comments where EQC_TYPE='QUERY' and EQC_DEST_USER='"+Session.getUserId()+"' and EQC_QUERY_MAP='0'";
		
		rfqTableRow.setQuery(qcfPendCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			toBeActQrys  = Integer.parseInt(hdrXML.getFieldValueString(0,"TOBEACTQRY")); 
			

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
		//LIVE AUCTIONS
		
		rfqParams = new ezc.ezparam.EzcParams(false); 
		rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		String liveAuctCountQry="SELECT  COUNT(EAH_AUCTION_ID) AS LIVE_AUCT_COUNT FROM EZC_AUCTION_HEADER WHERE now() BETWEEN EAH_START_DATE AND EAH_END_DATE  AND EAH_AUCTION_STATUS IN ('E')AND  CONCAT(EAH_PLANT,'#',EAH_CATEGORY) IN ('"+gv_CategoriesForQry+"') ORDER BY EAH_AUCTION_ID DESC";

		rfqTableRow.setQuery(liveAuctCountQry);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);

		try
		{	
			hdrXML = null;
			hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			currentVendAuctions  = Integer.parseInt(hdrXML.getFieldValueString(0,"LIVE_AUCT_COUNT")); 


		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		
		
		
		
	}	
 %>
 