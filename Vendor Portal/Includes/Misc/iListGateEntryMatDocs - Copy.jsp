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
	String vendCode 	= (String)session.getValue("SOLDTO");
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table gateEntryDocsTable=null,DateTable=null;
	int gateEntryDocsTableCount=0;
	ezc.ezparam.ReturnObjFromRetrieve gateEntryDocsRetObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"MATDOCNO","PONUM","POITEMNO","MATCODE","MATDESC","UOM","QTY","APPDATE","POSTDATE","REF_DOC","TRUCK_NO"});
			
	try
	{
		ezc.ezcommon.EzLog4j.log("<<<<<<<<<<<<<<<<<Z_EZ_GATE_ENTRY_DETAILS>>>>>>>>","I");
	
		client1 = EzSAPHandler.getSAPConnection("200~999");
		function = EzSAPHandler.getFunction("Z_EZ_GATE_ENTRY_DETAILS","200~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue(fdate,"GATEENTRY_FROM");
		parameterList.setValue(tdate,"GATEENTRY_TO"); 
		parameterList.setValue(vendCode,"VENDOR");//VS0301  vendCode
		parameterList.setValue(purOrg,"PUR_ORG"); 
		//parameterList.setValue(compCode,"COMPANY_CODE");//commented as data is not coming
		//parameterList.setValue(purGrp,"PUR_GRP");//commented as data is not coming
		
		ezc.ezcommon.EzLog4j.log("GATEENTRY_FROM>>>>>>>>"+parameterList.getValue("GATEENTRY_FROM"),"I");
		ezc.ezcommon.EzLog4j.log("GATEENTRY_TO>>>>>>>>"+parameterList.getValue("GATEENTRY_TO"),"I");
		ezc.ezcommon.EzLog4j.log("VENDOR>>>>>>>>"+parameterList.getValue("VENDOR"),"I");
		ezc.ezcommon.EzLog4j.log("PUR_ORG>>>>>>>>"+parameterList.getValue("PUR_ORG"),"I");
		
		try
 		{
  		 	ezc.ezcommon.EzLog4j.log("client1.execute(function)>>>purOrg>>>>>"+purOrg+"compCode>>"+compCode+"purGrp>>"+purGrp,"I");
  		 	client1.execute(function);
		}
		catch(Exception e)
		{
		 	ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_SHORTAGE_DOCS  exec"+e,"I");
 		}
 		
 		gateEntryDocsTable= function.getTableParameterList().getTable("GR_LIST");
		if(gateEntryDocsTable!=null)
		gateEntryDocsTableCount	= gateEntryDocsTable.getNumRows();	
		
		//ezc.ezcommon.EzLog4j.log("gateEntryDocsTable>>>>>>>>"+gateEntryDocsTable,"I");
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
	if(gateEntryDocsTableCount>0)
	{
		do
		{	  
			  gateEntryDocsRetObj.setFieldValue("REF_DOC",(String)gateEntryDocsTable.getValue("VENDINV"));
			  gateEntryDocsRetObj.setFieldValue("MATDOCNO",(String)gateEntryDocsTable.getValue("MBLNR"));
			  gateEntryDocsRetObj.setFieldValue("PONUM",(String)gateEntryDocsTable.getValue("EBELN"));					
			  gateEntryDocsRetObj.setFieldValue("POITEMNO",(String)gateEntryDocsTable.getValue("ZEILE"));
			  gateEntryDocsRetObj.setFieldValue("MATCODE",(String)gateEntryDocsTable.getValue("MATNR"));
			  gateEntryDocsRetObj.setFieldValue("MATDESC",(String)gateEntryDocsTable.getValue("MAKTX"));
			  gateEntryDocsRetObj.setFieldValue("UOM",(String)gateEntryDocsTable.getValue("UOM"));
			  gateEntryDocsRetObj.setFieldValue("QTY",(String)gateEntryDocsTable.getValue("MENGE"));
			   //gateEntryDocsRetObj.setFieldValue("POSTDATE",gateEntryDocsTable.getValue("BUDAT"));//PostingDate
			  gateEntryDocsRetObj.setFieldValue("POSTDATE",formatDate.getStringFromDate((java.util.Date)gateEntryDocsTable.getValue("BUDAT"),"/",FormatDate.DDMMYYYY));//PostingDate
			  //gateEntryDocsRetObj.setFieldValue("APPDATE",(String)gateEntryDocsTable.getValue("ERDAT"));//ApproveDate
			  gateEntryDocsRetObj.setFieldValue("APPDATE",formatDate.getStringFromDate((java.util.Date)gateEntryDocsTable.getValue("ERDAT"),"/",FormatDate.DDMMYYYY));//ApproveDate
			   gateEntryDocsRetObj.setFieldValue("TRUCK_NO",(String)gateEntryDocsTable.getValue("XBLNR"));
			  gateEntryDocsRetObj.addRow();
		}while(gateEntryDocsTable.nextRow());	 				
	}
	
	   int gateEntryDocsRetObjCnt=0;
	   if(gateEntryDocsRetObj!=null)gateEntryDocsRetObjCnt=gateEntryDocsRetObj.getRowCount();
%>  