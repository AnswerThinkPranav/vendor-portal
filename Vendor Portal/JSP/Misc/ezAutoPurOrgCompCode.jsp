<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean> 
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>  
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>

<%
	String plant 		= request.getParameter("plant");
	ezc.ezcommon.EzLog4j.log("plant in EnterEndDate::::::::"+plant,"I");
	String valueDesc="";

	//AutoPurOrgCompCode
	//TO Fetch Purchase Org  and Company Code  based on Plant
	
	String logonSite = (String)session.getValue("SITE");
	String [] outputFeilds = null;
	String [] queryValues = null;

	queryValues =new String[]{"WERKS EQ '"+plant+"'"}; 
	outputFeilds =new String[]{"EKORG"};

	ReturnObjFromRetrieve retPOrg = readRFCTable(logonSite,"T024W",outputFeilds,queryValues);
	String selPOrg = retPOrg.getFieldValueString(0,"EKORG");
	ezc.ezcommon.EzLog4j.log("::selPOrg:::"+selPOrg,"I");	
	/*if("1001".equals(plant))
		selPOrg="1011";*/

	queryValues =new String[]{"BWKEY EQ '"+plant+"'"}; 		
	outputFeilds =new String[]{"BUKRS"};

	ReturnObjFromRetrieve retCC = readRFCTable(logonSite,"T001K",outputFeilds,queryValues);
	String selCC = retCC.getFieldValueString(0,"BUKRS");
	ezc.ezcommon.EzLog4j.log("::selCC:::"+selCC,"I");

	//selPOrg ="4101";
	//selCC ="4101";
	
	ReturnObjFromRetrieve retQuery	=  null;
	int    QueryCnt	=  0;
	ezc.ezparam.EzcParams  mainParams = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();	
	miscParams.setQuery("SELECT EMKV_KEY,EMKV_VALUE from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE IN('PUR_ORG') AND EMKV_KEY='"+selPOrg+"'");
	ezc.ezcommon.EzLog4j.log("retQuery:::"+miscParams.getQuery(),"I");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
	retQuery=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retQuery!=null)
	QueryCnt=retQuery.getRowCount(); 

	valueDesc = retQuery.getFieldValueString(0,"EMKV_VALUE");
	ezc.ezcommon.EzLog4j.log("valueDesc>>>PurOrgSchGrp>>>"+valueDesc,"I");	
	out.println(selPOrg+"##"+selCC+"##"+valueDesc);	
%>
