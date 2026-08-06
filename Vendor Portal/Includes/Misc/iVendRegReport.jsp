<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%
	String type = request.getParameter("type"); 
	String venType = request.getParameter("venType");
	
	
	java.util.Hashtable<String,String> regEmailHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regPmntHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regIncoHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regPanHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regGstHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regVenTypeHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regSupTypeHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regMsmeTypeHT = new java.util.Hashtable<String,String>();
	java.util.Hashtable<String,String> regAcctHT = new java.util.Hashtable<String,String>();
	
	ezc.ezparam.ReturnObjFromRetrieve retVendDtl=ezMiscSelect(Session,"select * from ezc_customer_form_details where ecfd_field in ('accnt_Email','paymntTerms','INCO_Terms','PAN_Number','gst_Number','vendorType','supType','msme_Type','accnt_Number') and  ECFD_DOC_ID in (select ECFH_DOC_ID from EZC_CUSTOMER_FORM_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ECFH_DOC_ID=B.EWDHH_DOC_ID and A.ecfh_status='POSTED'  and A.ECFH_VEN_TYPE='IN' and A.ecfh_modified_on  BETWEEN STR_TO_DATE('01/04/2021 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('03/11/2022 23:59','%d/%m/%Y %H:%i'))");
	ezc.ezcommon.EzLog4j.log("retVendDtl>>>"+retVendDtl.getRowCount(),"I");
	
	int retVendDtlCnt = 0;
	if(retVendDtl != null)
	{
		retVendDtlCnt = retVendDtl.getRowCount();
	}
	for(int i=0;i<retVendDtlCnt;i++)
	{
		if("accnt_Email".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regEmailHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}
		if("paymntTerms".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regPmntHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}	
		if("INCO_Terms".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regIncoHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}
		if("PAN_Number".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regPanHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}		
		if("gst_Number".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regGstHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}
		if("vendorType".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regVenTypeHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE").split("#")[0]);
		}
		if("supType".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regSupTypeHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE").split("#")[0]);
		}
		if("msme_Type".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regMsmeTypeHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}
		if("accnt_Number".equals(retVendDtl.getFieldValueString(i,"ECFD_FIELD")))
		{
			regAcctHT.put(retVendDtl.getFieldValueString(i,"ECFD_DOC_ID"),retVendDtl.getFieldValueString(i,"ECFD_VALUE"));
		}		
	}	
	
	ezc.ezcommon.EzLog4j.log("regGstHT>>>"+regGstHT,"I");

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	if(type.equalsIgnoreCase("ALL"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED','APPROVED','RESUBMITTED')";
	else if(type.equalsIgnoreCase("Act"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED') AND  B.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')";
	else if(type.equalsIgnoreCase("Sub"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED')";		
	else if(type.equalsIgnoreCase("Apr"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED')";
	else if(type.equalsIgnoreCase("Rej"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('REJECTED')";
	else if(type.equalsIgnoreCase("Ven"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('RESUBMITTED')";		
	else if(type.equalsIgnoreCase("Pnd"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED') AND (A.ECFH_SAP_CODE IS NULL OR A.ECFH_SAP_CODE='')";	
	else if(type.equalsIgnoreCase("Pst"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED') AND A.ECFH_SAP_CODE!=''";

	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	//qryRFQ="SELECT ECFH_SAP_CODE,ECFH_DOC_ID,ECFH_SALES_ORG,ECFH_CREATED_BY,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_CUSTOMER_FORM_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ECFH_DOC_ID=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID AND TRIM(EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PURORG' AND EUDKV_VALUE IN ('"+gv_PurorgsForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE A.ECFH_SALES_ORG IN ('"+gv_PurorgsForQry+"')"+qryStr;
	qryRFQ="SELECT ECFH_SAP_CODE,ECFH_DOC_ID,ECFH_CUST_NAME,ECFH_SALES_ORG,ECFH_CREATED_BY,ECFH_EXT1,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_CUSTOMER_FORM_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ECFH_DOC_ID=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID  AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE CONCAT(A.ECFH_PLANT,'#',A.ECFH_CATEGORY) IN ('"+gv_CategoriesForQry+"') AND A.ECFH_VEN_TYPE IN ('"+venType+"')"+qryStr;
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	int Count=0;
	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		Count = hdrXML.getRowCount();
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
%>

