 <%@ page import = "ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO,ezc.ezparam.*" %>
 <%
	String systemKey = (String)session.getValue("SYSKEY");
	ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
	ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
	ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	snkparams1.setSystemKey(systemKey);
	snkparams1.setSiteNumber(200);
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);
	
	String purorg="";
	if(retdef != null)
	{
		int defsCount = retdef.getRowCount();
		for(int i=0;i<defsCount;i++)
		{
			if("PURORG".equals(retdef.getFieldValueString(i,"ECAD_KEY")))
			{
				purorg = retdef.getFieldValueString(i,"ECAD_VALUE");
				purorg=purorg.trim();

			}
		}
	}

	//String purorg=(String)session.getValue("PURORG");
	
	rfqVend=rfqVend.trim();
 	java.util.Vector vendorCurr=new java.util.Vector();
 	
 		com.sap.mw.jco.JCO.Function function = null;
 		com.sap.mw.jco.JCO.Client client = null;
		
		try
 		{
 			String currency = "";
 			String purOrg    = (String)session.getValue("SYSKEY");
 			String site = (String)session.getValue("DRL_SITE");
 			String connStr 		= "200~999";
 			if(systemKey!=null)
 				connStr = site+"~"+systemKey.substring(0,3);
 
 			function = EzSAPHandler.getFunction("RFC_READ_TABLE",connStr);
 			client = EzSAPHandler.getSAPConnection(connStr);
 
 			JCO.ParameterList paramIn    = function.getImportParameterList();
 			JCO.ParameterList paramTable = function.getTableParameterList();
 
 			JCO.Table fields  = paramTable.getTable("FIELDS");
 
 			paramIn.setValue("LFM1","QUERY_TABLE");
 			paramIn.setValue(",","DELIMITER");
 
 			fields.appendRow();
 			fields.setValue("LIFNR","FIELDNAME");//vendorcode
			fields.appendRow();
 			fields.setValue("WAERS","FIELDNAME");//currencycode
 						
			JCO.Table options  = paramTable.getTable("OPTIONS");

			options.appendRow();
			options.setValue("LIFNR = '"+rfqVend+"' AND EKORG = '"+purorg+"'","TEXT");
			
			//out.println(options.getValue("TEXT"));
 
 			try
 			{
 				client.execute(function);
 			}catch(Exception e){
 				ezc.ezcommon.EzLog4j.log("Exception while executing RFC call RFC_READ_TABLE"+e,"I");
 			}	
 
 			JCO.ParameterList  paramOut = function.getExportParameterList();
 			JCO.Table 	  fieldsOut = function.getTableParameterList().getTable("DATA");
 			 			
 			int fieldsOutCount = fieldsOut.getNumRows();
 
 			if(fieldsOutCount>0)
 			{
 				do
 				{
 					currency = (String)fieldsOut.getValue("WA"); 					
					vendorCurr.addElement(currency.split(",")[1]);
					
 				}
 				while(fieldsOut.nextRow());
 			}
 			
 		}
 		catch(Exception e)
 		{
 			ezc.ezcommon.EzLog4j.log("Exception while getting plant codes from SAP ::::"+e,"I");
 		}
 		finally
 		{
 			if (client!=null)
 			{
 				ezc.ezcommon.EzLog4j.log("R E L E A S I N G   C L I E N T .... ","I");
 				JCO.releaseClient(client);
 				client = null;
 				function=null;
 			}
 		}
 	 

 %>
 
 
 