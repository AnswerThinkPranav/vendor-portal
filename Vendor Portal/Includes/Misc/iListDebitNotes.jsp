<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,ezc.ezsap.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<%!
    	private String checkNull(String str)
    	{
    		if("null".equals(str) ||str==null || str=="" || "".equals(str))
    		str="NA";
    		return str;
    	}
%>    	
<%
	java.text.DateFormat formatter = new java.text.SimpleDateFormat("dd/MM/yyyy");
	java.util.Date fdate = formatter.parse(fromDate);
	java.util.Date tdate = formatter.parse(toDate);
	
	//String compCode		= checkNull((String)Session.getUserPreference("COMPCODE"));
	String vendor 			= checkNull((String)Session.getUserId());
	String soldTo			= checkNull((String)Session.getUserPreference("ERPSOLDTO"));
	
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table RejTableOut=null,DateTable=null;
	int RejTableOutCount=0;
	ezc.ezparam.ReturnObjFromRetrieve retRejDebitNotesObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"DOCNO","DOCYEAR","DOCDATE","POSTINGDATE","GROSSAMT","ACCDOCNO"});
			
	try
	{
		client1 = EzSAPHandler.getSAPConnection("200~999");
		function = EzSAPHandler.getFunction("Z_EZ_GET_DEBIT_NOTES","200~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue(fdate,"FROM_DATE");
		parameterList.setValue(tdate,"TO_DATE");
		if("3".equals(userType))
		{
			ezc.ezcommon.EzLog4j.log("vendor>>>>>>>>"+userType,"I");
			parameterList.setValue(vendor,"VENDOR");
		}
		else if(!"3".equals(userType))
		{
			ezc.ezcommon.EzLog4j.log("int user>>>>>>>>"+userType,"I");
			ezc.ezcommon.EzLog4j.log("int user>>>>>soldTo>>>"+soldTo,"I");
			parameterList.setValue(soldTo,"VENDOR");
		}
		//parameterList.setValue(compCode,"COMPANY_CODE");
		
		
		try
 		{
    		 	client1.execute(function);
		}
		catch(Exception e)
		{
		 	ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_DEBIT_NOTES  exec"+e,"I");
 		}
 		
 		RejTableOut= function.getTableParameterList().getTable("DEBIT_NOTES");
		if(RejTableOut!=null)
		RejTableOutCount	= RejTableOut.getNumRows();	
		
		ezc.ezcommon.EzLog4j.log("RejTableOut>>>>>>>>"+RejTableOut,"I");
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_DEBIT_NOTES"+e,"I");
 	}
 	finally
	{
		if (client1!=null)
		{
			ezc.ezcommon.EzLog4j.log("R E L E A S I N G   C L I E N T .... ","D");
			JCO.releaseClient(client1);
			client1 = null;
			function=null;
		}
	}
	if(RejTableOutCount>0)
	{
		do
		{	  
			  retRejDebitNotesObj.setFieldValue("DOCNO",(String)RejTableOut.getValue("DOC_NO"));
			  retRejDebitNotesObj.setFieldValue("DOCYEAR",(String)RejTableOut.getValue("DOC_YEAR"));
			  retRejDebitNotesObj.setFieldValue("DOCDATE",getDateForDateObj((java.util.Date)RejTableOut.getValue("DOC_DATE")));
			  retRejDebitNotesObj.setFieldValue("POSTINGDATE",getDateForDateObj((java.util.Date)RejTableOut.getValue("POSTING_DATE")));					
			  retRejDebitNotesObj.setFieldValue("GROSSAMT",(String)RejTableOut.getValue("GROSS_AMT"));
			  retRejDebitNotesObj.setFieldValue("ACCDOCNO",(String)RejTableOut.getValue("ACC_DOC_NO"));
			  retRejDebitNotesObj.addRow();
		}while(RejTableOut.nextRow());					
	}
	
	int retRejDebitNotesObjCnt=0;
	if(retRejDebitNotesObj!=null)retRejDebitNotesObjCnt=retRejDebitNotesObj.getRowCount();
	ezc.ezcommon.EzLog4j.log("::Before retRejDebitNotesObj::::"+retRejDebitNotesObj.toEzcString(),"I");
	/***********For Getting status of Debit Note***********************/
	ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	int retVendTransCnt=0;
	ezc.vendortransactions.params.EzDebitCreditNotesParams ezDebitCreditParams = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyDebitParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyDebitParams.setKey("GET_DEBIT_CREDIT_NOTES");
	mainParams.setLocalStore("Y");
	if("3".equals(userType))
	{
		ezDebitCreditParams.setVendor(vendor);
	}
	else
	{
		ezDebitCreditParams.setVendor(soldTo);
	}


	mainParams.setObject(keyDebitParams);
	mainParams.setObject(ezDebitCreditParams);
	Session.prepareParams(mainParams);

	try{
		ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
		retVendTransObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams);

		ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::"+retVendTransObj.toEzcString(),"I");

	}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}

	java.util.Hashtable creditStat =new java.util.Hashtable();
	if(retVendTransObj!=null)
	{
		  for(int i=0;i<retVendTransObj.getRowCount();i++)
		   {

			creditStat.put(retVendTransObj.getFieldValueString(i,"EDCN_DEBIT_NOTE"),retVendTransObj.getFieldValueString(i,"EDCN_CREDIT_NOTE"));
		   }
	}
	ezc.ezcommon.EzLog4j.log("::::::creditStat::::"+creditStat,"I");
	ezc.ezcommon.EzLog4j.log("::::::creditStat::::"+creditStat.size(),"I");
	
	/***********For Getting status of Debit Note***********************/
%>  