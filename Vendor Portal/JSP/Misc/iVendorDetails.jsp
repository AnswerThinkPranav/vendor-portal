<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
String key ="";
String value =""; 

String currkey ="";
String currvalue =""; 

String pkey ="";
String pvalue =""; 

String schemakey ="";
String schemavalue =""; 

String statekey ="";
String statevalue =""; 

String MinIndkey ="";
String MinIndvalue =""; 

String GSTStateCode ="";
String stateCode ="";

%>
<%		
	ReturnObjFromRetrieve retCountry	=  null;
	int    CountryCnt	=  0;
	ezc.ezparam.EzcParams mainParams_c	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_c		= new EziMiscParams();
	miscParams_c.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='COUNTRY'");
	mainParams_c.setLocalStore("Y");
	mainParams_c.setObject(miscParams_c);
	Session.prepareParams(mainParams_c);
	try
	{		
		retCountry=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_c);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retCountry!=null)
		CountryCnt=retCountry.getRowCount();



		
		
		

	ReturnObjFromRetrieve retCurrency	=  null;
	int    CurrCnt	=  0;
	ezc.ezparam.EzcParams mainParams1	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams1		= new EziMiscParams();
	miscParams1.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='CURRENCY'");
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscParams1);
	Session.prepareParams(mainParams1);
	try
	{		
		retCurrency=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams1);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retCurrency!=null)
		CurrCnt=retCurrency.getRowCount();
		
		
		
	ReturnObjFromRetrieve retPay	=  null;
	int    PayCnt	=  0;
	ezc.ezparam.EzcParams mainParams2	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams2		= new EziMiscParams();
	miscParams2.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PAY_TERMS'");
	mainParams2.setLocalStore("Y");
	mainParams2.setObject(miscParams2);
	Session.prepareParams(mainParams2);
	try
	{		
		retPay=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams2);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retPay!=null)
		PayCnt=retPay.getRowCount();	
		
		
		
	ReturnObjFromRetrieve retSchema	=  null;
	int    SchemaCnt	=  0;
	ezc.ezparam.EzcParams mainParams3	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams3		= new EziMiscParams();
	miscParams3.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='SCHEMA_GROUP'");
	mainParams3.setLocalStore("Y");
	mainParams3.setObject(miscParams3);
	Session.prepareParams(mainParams3);
	try
	{		
		retSchema=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams3);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retSchema!=null)
		SchemaCnt=retSchema.getRowCount();	
		
		
		
	ReturnObjFromRetrieve retState	=  null;
	int    StateCnt	=  0;
	ezc.ezparam.EzcParams mainParams4	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams4		= new EziMiscParams();
	miscParams4.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='STATES'");
	mainParams4.setLocalStore("Y");
	mainParams4.setObject(miscParams4);
	Session.prepareParams(mainParams4);
	try
	{		
		retState=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams4);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retState!=null)
		StateCnt=retState.getRowCount();
		
	ReturnObjFromRetrieve retMinInd	=  null;
	int    MinIndCnt	=  0;
	ezc.ezparam.EzcParams mainParams5	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams5		= new EziMiscParams();
	miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='MIN_IND'");
	mainParams5.setLocalStore("Y");
	mainParams5.setObject(miscParams5);
	Session.prepareParams(mainParams5);
	try
	{		
		retMinInd=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retMinInd!=null)
		MinIndCnt=retMinInd.getRowCount();	
		
		
	ReturnObjFromRetrieve retAcctGroup	=  null;
	int    AcctGroupCnt	=  0;
	mainParams5	= new ezc.ezparam.EzcParams(false);
	miscParams5		= new EziMiscParams();
	miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='ACCTGROUP'");
	mainParams5.setLocalStore("Y");
	mainParams5.setObject(miscParams5);
	Session.prepareParams(mainParams5);
	try
	{		
		retAcctGroup=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retAcctGroup!=null)
		AcctGroupCnt=retAcctGroup.getRowCount();
		
	ReturnObjFromRetrieve retCompanyCode	=  null;
	int    CompanyCodeCnt	=  0;
	mainParams5	= new ezc.ezparam.EzcParams(false);
	miscParams5		= new EziMiscParams();
	miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='COMPANYCODE'");
	mainParams5.setLocalStore("Y");
	mainParams5.setObject(miscParams5);
	Session.prepareParams(mainParams5);
	try
	{		
		retCompanyCode=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retCompanyCode!=null)
		CompanyCodeCnt=retAcctGroup.getRowCount();
		
	ReturnObjFromRetrieve retReconAcct	=  null;
	int    ReconAcctCnt	=  0;
	mainParams5	= new ezc.ezparam.EzcParams(false);
	miscParams5		= new EziMiscParams();
	miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='RECONACCT'");
	mainParams5.setLocalStore("Y");
	mainParams5.setObject(miscParams5);
	Session.prepareParams(mainParams5);
	try
	{		
		retReconAcct=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retReconAcct!=null)
		ReconAcctCnt=retReconAcct.getRowCount();
		
	ReturnObjFromRetrieve retPaymentMode	=  null;
	int    PaymentModeCnt	=  0;
	mainParams5	= new ezc.ezparam.EzcParams(false);
	miscParams5		= new EziMiscParams();
	miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PAYMENTMODE'");
	mainParams5.setLocalStore("Y");
	mainParams5.setObject(miscParams5);
	Session.prepareParams(mainParams5);
	try
	{		
		retPaymentMode=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retPaymentMode!=null)
		PaymentModeCnt=retPaymentMode.getRowCount();	
		
	ReturnObjFromRetrieve retStateCode	=  null;
	int    StateCodeCnt	=  0;
	ezc.ezparam.EzcParams mainParams6	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams6		= new EziMiscParams();
	miscParams6.setQuery("SELECT * FROM EZC_MASTER_STATE_CODES");
	mainParams6.setLocalStore("Y");
	mainParams6.setObject(miscParams6);
	Session.prepareParams(mainParams6);
	try
	{		
		retStateCode=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams6);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retStateCode!=null)
		StateCodeCnt=retStateCode.getRowCount();
		
	//PAYMENT TERM
	
	ReturnObjFromRetrieve pmntObj	=  null;
	int    pmntTmCnt	=  0;
	ezc.ezparam.EzcParams mainParams7	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams7		= new EziMiscParams();
	miscParams7.setQuery("SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PMNT_TERM'") ;
	mainParams7.setLocalStore("Y");
	mainParams7.setObject(miscParams7);
	Session.prepareParams(mainParams7);
	try
	{		
		pmntObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams7);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Payment Terms:::::"+e,"I");}
	if(pmntObj!=null)
		pmntTmCnt=pmntObj.getRowCount();
		
	//INCO TERM
	
	ReturnObjFromRetrieve incoObj	=  null;
	int    incoTmCnt	=  0;
	ezc.ezparam.EzcParams mainParams8= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams8		= new EziMiscParams();
	miscParams8.setQuery("SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='INCO_TERM'") ;
	mainParams8.setLocalStore("Y");
	mainParams8.setObject(miscParams8);
	Session.prepareParams(mainParams8);
	try
	{		
		incoObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams8);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Inco Terms:::::"+e,"I");}
	if(incoObj!=null)
		incoTmCnt=incoObj.getRowCount();		
		
		
%>