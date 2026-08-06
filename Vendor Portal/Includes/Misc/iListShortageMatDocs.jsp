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
	
	String compCode		= checkNull((String)Session.getUserPreference("COMPCODE"));
	String purOrg 		= checkNull((String)Session.getUserPreference("PURORG"));
	String purGrp		= checkNull((String)Session.getUserPreference("PURGROUP")); 
	String vendor 		= (String)session.getValue("SOLDTO");	
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table RejMatDocsTable=null,DateTable=null;
	int RejMatDocsCount=0;
	ezc.ezparam.ReturnObjFromRetrieve retRejMatDocsObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"MATDOCNO","PONUM","POITEMNO","MATCODE","MATDESC","UOM","QTY","APPDATE","POSTDATE","REF_DOC"});
			
	try
	{
		client1 = EzSAPHandler.getSAPConnection("200~999");
		function = EzSAPHandler.getFunction("Z_EZ_GET_SHORTAGE_DOCS","200~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue(fdate,"GATEENTRY_FROM");
		parameterList.setValue(tdate,"GATEENTRY_TO"); 
		parameterList.setValue(vendor,"VENDOR");//VS0301 
		parameterList.setValue(purOrg,"PUR_ORG"); 
		//parameterList.setValue(compCode,"COMPANY_CODE");//commented as data is not coming
		//parameterList.setValue(purGrp,"PUR_GRP");//commented as data is not coming
		
		try
 		{
  		 	ezc.ezcommon.EzLog4j.log("client1.execute(function)>>>purOrg>>>>>"+purOrg+"compCode>>"+compCode+"purGrp>>"+purGrp,"I");
  		 	client1.execute(function);
		}
		catch(Exception e)
		{
		 	ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_SHORTAGE_DOCS  exec"+e,"I");
 		}
 		
 		RejMatDocsTable= function.getTableParameterList().getTable("GR_LIST");
		if(RejMatDocsTable!=null)
		RejMatDocsCount	= RejMatDocsTable.getNumRows();	
		
		ezc.ezcommon.EzLog4j.log("RejMatDocsTable>>>>>>>>"+RejMatDocsTable,"I");
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_SHORTAGE_DOCS"+e,"I");
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
	if(RejMatDocsCount>0)
	{
		do
		{	  
			  retRejMatDocsObj.setFieldValue("REF_DOC",(String)RejMatDocsTable.getValue("VENDINV"));
			  retRejMatDocsObj.setFieldValue("MATDOCNO",(String)RejMatDocsTable.getValue("MBLNR"));
			  retRejMatDocsObj.setFieldValue("PONUM",(String)RejMatDocsTable.getValue("EBELN"));					
			  retRejMatDocsObj.setFieldValue("POITEMNO",(String)RejMatDocsTable.getValue("ZEILE"));
			  retRejMatDocsObj.setFieldValue("MATCODE",(String)RejMatDocsTable.getValue("MATNR"));
			  retRejMatDocsObj.setFieldValue("MATDESC",(String)RejMatDocsTable.getValue("MAKTX"));
			  retRejMatDocsObj.setFieldValue("UOM",(String)RejMatDocsTable.getValue("UOM"));
			  retRejMatDocsObj.setFieldValue("QTY",(String)RejMatDocsTable.getValue("SHORT_QUAN"));
			   //retRejMatDocsObj.setFieldValue("POSTDATE",RejMatDocsTable.getValue("BUDAT"));//PostingDate
			  retRejMatDocsObj.setFieldValue("POSTDATE",formatDate.getStringFromDate((java.util.Date)RejMatDocsTable.getValue("BUDAT"),"/",FormatDate.DDMMYYYY));//PostingDate
			  //retRejMatDocsObj.setFieldValue("APPDATE",(String)RejMatDocsTable.getValue("ERDAT"));//ApproveDate
			  retRejMatDocsObj.setFieldValue("APPDATE",formatDate.getStringFromDate((java.util.Date)RejMatDocsTable.getValue("ERDAT"),"/",FormatDate.DDMMYYYY));//ApproveDate
			  retRejMatDocsObj.addRow();
		}while(RejMatDocsTable.nextRow());	 				
	}
	
	   int retRejMatDocsObjCnt=0;
	   if(retRejMatDocsObj!=null)retRejMatDocsObjCnt=retRejMatDocsObj.getRowCount();
	 /***********For Getting status of Material Document***********************/
		ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		int retVendTransCnt=0;
		ezc.vendortransactions.params.EzDebitCreditNotesParams ezShortAckParams = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyShortParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyShortParams.setKey("GET_SHORTAGES_ACK_INFO");
		mainParams.setLocalStore("Y");
	
		ezShortAckParams.setVendor(checkNull((String)Session.getUserId()));
		
			
		mainParams.setObject(keyShortParams);
		mainParams.setObject(ezShortAckParams);
		Session.prepareParams(mainParams);
		
		try{
			ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
			retVendTransObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams);
			
			ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::","I");
			
		}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}
	
		String matPoItem="";
		java.util.Hashtable ackStat =new java.util.Hashtable();
		if(retVendTransObj!=null)
		{
			  for(int i=0;i<retVendTransObj.getRowCount();i++)
			   {
				matPoItem=retVendTransObj.getFieldValueString(i,"ESA_MAT_DOC")+"$$"+retVendTransObj.getFieldValueString(i,"ESA_PO_ITEM_NO");	
				ackStat.put(matPoItem,retVendTransObj.getFieldValueString(i,"ESA_EXT1"));
			   }
	 	 }
	
	/***********For Getting status of Material Document***********************/
%>  