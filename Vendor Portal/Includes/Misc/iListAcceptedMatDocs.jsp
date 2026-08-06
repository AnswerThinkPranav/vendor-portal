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

	String FrmDat=fromDate.replaceAll("/","");
	String ToDat=toDate.replaceAll("/","");
	String vendCode = (String)session.getValue("SOLDTO");
	String purOrg   = (String)session.getValue("PURORG");
	
	FrmDat = FrmDat.substring(4,8)+FrmDat.substring(2,4)+FrmDat.substring(0,2);
	ToDat = ToDat.substring(4,8)+ToDat.substring(2,4)+ToDat.substring(0,2);
	
	ezc.ezcommon.EzLog4j.log("::::::::::fromDate::::::"+FrmDat,"I");
	ezc.ezcommon.EzLog4j.log(":::::::::::toDate::::::::::"+ToDat,"I"); 
	
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table RejMatDocsTable=null,DateTable=null;
	JCO.Table mvtTypesTable =null;
	
	int RejMatDocsCount=0;
	ezc.ezparam.ReturnObjFromRetrieve retRejMatDocsObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"MATDOCNO","PONUM","POITEMNO","MATCODE","MATDESC","UOM","RECEIVED_QTY","ACCPETED_QTY","SHORTAGE_QTY","REJ_QTY","INSLOT","UD_TYPE","REF_DOC"});
	String logonSite = (String)session.getValue("SITE");
	try
	{
		
		client1 = EzSAPHandler.getSAPConnection(logonSite+"~999");
		function = EzSAPHandler.getFunction("Z_EZ_GET_MATERIAL_DOCUMENTS",logonSite+"~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue(vendCode,"VENDOR");
		DateTable =parameterList.getTable("DATE");	
		
		mvtTypesTable =parameterList.getTable("MOVEMENT_TYPE");	
		
		DateTable.appendRow();
		DateTable.setValue("I","SIGN");	
		DateTable.setValue("BT","OPTION");
		DateTable.setValue(FrmDat,"LOW");
		DateTable.setValue(ToDat,"HIGH");
		//parameterList.setValue(DateTable,"DATE");
		
		
		parameterList.setValue(purOrg,"PUR_ORG");
		
		//parameterList.setValue("MTRF","COMPANY_CODE");
		
		
		mvtTypesTable.appendRow();
		mvtTypesTable.setValue("I","SIGN");	
		mvtTypesTable.setValue("EQ","OPTION");
		mvtTypesTable.setValue("103","LOW");
		
		mvtTypesTable.appendRow();
		mvtTypesTable.setValue("I","SIGN");	
		mvtTypesTable.setValue("EQ","OPTION");
		mvtTypesTable.setValue("105","LOW");
		
		mvtTypesTable.appendRow();
		mvtTypesTable.setValue("I","SIGN");	
		mvtTypesTable.setValue("EQ","OPTION");
		mvtTypesTable.setValue("106","LOW");
		
		mvtTypesTable.appendRow();
		mvtTypesTable.setValue("I","SIGN");	
		mvtTypesTable.setValue("EQ","OPTION");
		mvtTypesTable.setValue("122","LOW");
		//parameterList.setValue(DateTable,"DATE");
		
		
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
	//ezc.ezcommon.EzLog4j.log(".....:::::::::.... "+RejMatDocsTable.toString(),"D");
	//out.println(RejMatDocsTable);
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
			retRejMatDocsObj.setFieldValue("RECEIVED_QTY",(String)RejMatDocsTable.getValue("MENGE_103"));
			retRejMatDocsObj.setFieldValue("ACCPETED_QTY",(String)RejMatDocsTable.getValue("MENGE"));
			retRejMatDocsObj.setFieldValue("SHORTAGE_QTY",(String)RejMatDocsTable.getValue("SHORT_QUAN"));
			retRejMatDocsObj.setFieldValue("INSLOT",(String)RejMatDocsTable.getValue("PRUEFLOS"));
			retRejMatDocsObj.setFieldValue("UD_TYPE",(String)RejMatDocsTable.getValue("UD_CODE"));
			retRejMatDocsObj.setFieldValue("REF_DOC",(String)RejMatDocsTable.getValue("XBLNR"));
			retRejMatDocsObj.setFieldValue("REJ_QTY",(String)RejMatDocsTable.getValue("REJ_QUAN"));
			retRejMatDocsObj.addRow();
		

		}while(RejMatDocsTable.nextRow());					

	}
	
	   int retRejMatDocsObjCnt=0;
	   if(retRejMatDocsObj!=null)retRejMatDocsObjCnt=retRejMatDocsObj.getRowCount();
	   
	
	//ezc.ezcommon.EzLog4j.log(".....:::::retRejMatDocsObj::::.... "+retRejMatDocsObj.toEzcString(),"D");
	
		

%>      