<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%
	String type = request.getParameter("type"); 
	ezc.ezcommon.EzLog4j.log("** type at QCS List"+type,"I");	

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	if(type.equalsIgnoreCase("ALL"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED','APPROVED')";
	else if(type.equalsIgnoreCase("Act"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED','REJECTED') AND  B.EWDHH_NEXT_PARTICIPANT IN ('"+gv_WorkGrpForQry+"')";
	else if(type.equalsIgnoreCase("Sub"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('SUBMITTED')";		
	else if(type.equalsIgnoreCase("Apr"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED')";
	else if(type.equalsIgnoreCase("Rej"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('REJECTED')";	
	else if(type.equalsIgnoreCase("POPend"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED') AND (A.ERH_PO_FLAG IS NULL OR A.ERH_PO_FLAG='')";	
	else if(type.equalsIgnoreCase("POCreat"))
		qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED') AND A.ERH_PO_FLAG='X'";	

	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";
		
	
	//qryRFQ="SELECT DISTINCT ERH_PO_FLAG,ERH_COMP_CODE,ERH_COLLETIVE_RFQ_NO,ERH_EXT2,ERH_PLANT,ERH_CAEG,ERH_FINAL_VALUE,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_RFQ_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ERH_COLLETIVE_RFQ_NO=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID AND TRIM(EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PLANT' AND EUDKV_VALUE IN ('"+gv_PlantForQry+"')) AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE A.ERH_PLANT IN ('"+gv_PlantForQry+"') AND A.ERH_CATEGORY IN ('"+gv_CategoriesForQry+"') "+qryStr;	
	
	//qryRFQ="SELECT DISTINCT ERH_PO_FLAG,ERH_COLLETIVE_RFQ_NO,COUNT(ERH_SOLD_TO) TOTVEND,COUNT(ERH_STATUS IN ('S','P','Y')) QTVEND,ERH_EXT2,ERH_PLANT,ERH_FINAL_VALUE,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_RFQ_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ERH_COLLETIVE_RFQ_NO=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID AND TRIM(EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PLANT' AND EUDKV_VALUE IN ('"+gv_PlantForQry+"')) AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE A.ERH_PLANT IN ('"+gv_PlantForQry+"') AND A.ERH_CATEGORY IN ('"+gv_CategoriesForQry+"') "+qryStr+" GROUP BY A.ERH_COLLETIVE_RFQ_NO";	
	qryRFQ="SELECT DISTINCT ERH_PO_FLAG,ERH_COLLETIVE_RFQ_NO,(SELECT COUNT(Z.ERH_SOLD_TO) FROM ezc_rfq_header Z where z.ERH_COLLETIVE_RFQ_NO=A.ERH_COLLETIVE_RFQ_NO ) AS TOTVEND, (SELECT COUNT(Z.ERH_SOLD_TO) FROM ezc_rfq_header Z where z.ERH_COLLETIVE_RFQ_NO=A.ERH_COLLETIVE_RFQ_NO AND ERH_STATUS IN ('S','P','Y')) AS QTVEND,ERH_EXT2,ERH_PLANT,ERH_CATEGORY,ERH_COMP_CODE,ERH_FINAL_VALUE,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART,USER_IDS,ERH_EXT3 FROM  EZC_RFQ_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ERH_COLLETIVE_RFQ_NO=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART,GROUP_CONCAT(EU_ID) AS USER_IDS  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID  AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('"+gv_CategoriesForQry+"')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE  CONCAT(ERH_PLANT,'#',A.ERH_CATEGORY) IN ('"+gv_CategoriesForQry+"') "+qryStr;	
	ezc.ezcommon.EzLog4j.log("** qryRFQ at QCS List"+qryRFQ,"I");	
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
	
	//ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>hdrXML>>>>>>>>>>>>>>>:"+hdrXML.toEzcString(),"D");
	
	String quotNo = "";
	String userIds = "";
	String wf_query = "";
	String wf_Plant = "";
	String wf_Category = "";
	String plantCatComb = "";
	
	//By Lakshman on 20.11.2025
	/*
	ezc.ezparam.ReturnObjFromRetrieve docWiseNextPart	  =	null; 
	for(int i=0;i<Count;i++)   
	{
		rfqParams = new ezc.ezparam.EzcParams(false); 
                rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
                rfqTable = new ezc.misctransactions.params.EzMiscTable();
		rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		
		quotNo = hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
		wf_Plant = hdrXML.getFieldValueString(i,"ERH_PLANT");
		wf_Category = hdrXML.getFieldValueString(i,"ERH_CATEGORY");
		plantCatComb = wf_Plant + "#" + wf_Category;
		userIds = hdrXML.getFieldValueString(i,"USER_IDS");
		
		if(userIds != null && !userIds.trim().equals("")){
			userIds = "'" + userIds.replace(",","','") + "'";
		}else{
			userIds = "''";
		}
		
		wf_query = "SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_VALUE ='"+ plantCatComb +"' AND EUDKV_USER_ID in ("+ userIds +")";
		
		ezc.ezcommon.EzLog4j.log("** wf_query at QCS List"+wf_query,"I");	
		rfqTableRow.setQuery(wf_query);
		rfqTable.appendRow(rfqTableRow);
		rfqParams.setLocalStore("Y");
		rfqParams.setObject(rfqTable);
		Session.prepareParams(rfqParams);
		int ret_Count=0;
		try
		{
			docWiseNextPart=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
			ret_Count = docWiseNextPart.getRowCount();
			ezc.ezcommon.EzLog4j.log("*******ret_Count*****"+ret_Count,"I");
			//ezc.ezcommon.EzLog4j.log("*******retObj docWiseNextPart*****"+docWiseNextPart.toEzcString(),"I");
		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
	}
	*/
	
%>

