<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,ezc.ezsap.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>

<%!
    	private String checkNull(String str)
    	{
    		if("null".equals(str) ||str==null || str=="" || "".equals(str))
    		str="NA";
    		return str;
    	}
%>    	
<%
String venAccNo="VT707";//request.getParameter("bankAccNo");
String compCode="MTRF";//request.getParameter("bankAccNo");
String purOrg="MTRF";//request.getParameter("bankAccNo");
String venAccgrp="LIEF";//request.getParameter("bankAccNo");
String title="MR";//request.getParameter("bankAccNo");
String venname="BETGERI";//request.getParameter("bankAccNo");
String sortField="0201";//request.getParameter("bankAccNo");
String houseNum="CHILLIMERCHANTS";//request.getParameter("bankAccNo");
String FrmDat=fromDate.replaceAll("/","");
String ToDat=toDate.replaceAll("/","");

ezc.ezcommon.EzLog4j.log("::::::::::fromDate::::::"+FrmDat,"I");
ezc.ezcommon.EzLog4j.log(":::::::::::toDate::::::::::"+ToDat,"I");
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table RejMatDocsTable=null,DateTable=null;
	int RejMatDocsCount=0;
	ezc.ezparam.ReturnObjFromRetrieve retRejMatDocsObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"MATDOCNO","PONUM","POITEMNO","MATCODE","MATDESC","UOM","QTY","INSLOT"});
			
	try
	{
		client1 = EzSAPHandler.getSAPConnection("200~999");
		function = EzSAPHandler.getFunction("Z_EZ_SHORTAGE_ACKNOWLEDGE","200~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue("VM0004","VENDOR");
		DateTable =parameterList.getTable("DATE");		
		DateTable.appendRow();
		DateTable.setValue("I","SIGN");	
		DateTable.setValue("BT","OPTION");
		DateTable.setValue(FrmDat,"LOW");
		DateTable.setValue(ToDat,"HIGH");
		parameterList.setValue(DateTable,"DATE");
		parameterList.setValue("MTRF","PUR_ORG");
		parameterList.setValue("MTRF","COMPANY_CODE");
		parameterList.setValue("122","MOVEMENT_TYPE");
		try
 		{
  		 	client1.execute(function);
		}
		catch(Exception e)
		{
		 	ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_SHORTAGE_ACKNOWLEDGE  exec"+e,"I");
 		}
 		
 			 RejMatDocsTable= function.getTableParameterList().getTable("IT_DISPLAY");
 	 		
			if(RejMatDocsTable!=null)
			RejMatDocsCount	= RejMatDocsTable.getNumRows();			
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_SHORTAGE_ACKNOWLEDGE"+e,"I");
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
	ezc.ezcommon.EzLog4j.log(".....:::::::::.... "+RejMatDocsTable.toString(),"D");
	
	if(RejMatDocsCount>0)
	{
		do
		{	  
			  retRejMatDocsObj.setFieldValue("MATDOCNO",(String)RejMatDocsTable.getValue("MBLNR"));
			  retRejMatDocsObj.setFieldValue("PONUM",(String)RejMatDocsTable.getValue("EBELN"));					
			  retRejMatDocsObj.setFieldValue("POITEMNO",(String)RejMatDocsTable.getValue("EBELP"));
			  retRejMatDocsObj.setFieldValue("MATCODE",(String)RejMatDocsTable.getValue("MAT_CODE"));
			  retRejMatDocsObj.setFieldValue("MATDESC",(String)RejMatDocsTable.getValue("MAKTX"));
			  retRejMatDocsObj.setFieldValue("UOM",(String)RejMatDocsTable.getValue("MEINS"));
			  retRejMatDocsObj.setFieldValue("QTY",(String)RejMatDocsTable.getValue("MENGE"));
			  retRejMatDocsObj.setFieldValue("INSLOT",(String)RejMatDocsTable.getValue("PRUEFLOS"));
			  retRejMatDocsObj.addRow();
		

		}while(RejMatDocsTable.nextRow());					

	}
	
	   int retRejMatDocsObjCnt=0;
	   if(retRejMatDocsObj!=null)retRejMatDocsObjCnt=retRejMatDocsObj.getRowCount();
	   
	
	ezc.ezcommon.EzLog4j.log(".....:::::retRejMatDocsObj::::.... "+retRejMatDocsObj.toEzcString(),"D");
	
		

%>  