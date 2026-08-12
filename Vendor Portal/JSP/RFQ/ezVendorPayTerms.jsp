<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%

String vendor=(String)session.getValue("SOLDTO");
String purOrg=(String)Session.getUserPreference("PURORG");

ezc.ezcommon.EzLog4j.log("**end sapMRPControl>>vendor*"+vendor+"purOrg>>>"+purOrg,"I");

String incoStrSAP=null;
String payStrSAP=null;
String incoStr2SAP=null;
try
{
	/*
	String sapMRPControl = "";

	JCoDestination destination 	= EzSAPHandler.getDestination("200~999");
	JCoFunction function 		= EzSAPHandler.getJCoFunction(destination,"RFC_READ_TABLE");
	
	ezc.ezcommon.EzLog4j.log("11111111111111","I");
	
	JCoParameterList paramIn 	= function.getImportParameterList();
	JCoTable messageTable 		= function.getTableParameterList().getTable("PURORDLIST");
	JCoTable fields  		=  function.getTableParameterList().getTable("FIELDS");
	
	ezc.ezcommon.EzLog4j.log("2222222222222","I");
	
	paramIn.setValue("LFM1","QUERY_TABLE");
	paramIn.setValue("#","DELIMITER");

	fields.appendRow();
	fields.setValue("FIELDNAME","ZTERM");
	fields.appendRow();
	fields.setValue("FIELDNAME","INCO1");
	fields.appendRow();
	fields.setValue("FIELDNAME","INCO2");
	
	JCoTable options  =  function.getTableParameterList().getTable("OPTIONS");

	options.appendRow();
	
	options.setValue("LIFNR EQ '"+rfqVendor+"' AND EKORG EQ '"+rfqPurOrg+"'","TEXT");
	ezc.ezcommon.EzLog4j.log("**end options>>vendor*"+options,"I");

	try 
	{
		function.execute(destination);
		
	}catch(Exception e){
		System.out.println("Exception while executing RFC call RFC_READ_TABLE"+e);
	}	

	JCoParameterList  paramOut = function.getExportParameterList();
	JCoTable fieldsOut  =  function.getTableParameterList().getTable("OPTIONS");


	int fieldsOutCount = fieldsOut.getNumRows();
	
	sapMRPControl = (String)fieldsOut.getValue("WA");
	payStrSAP = sapMRPControl.split("#")[0];
	incoStrSAP = sapMRPControl.split("#")[1];
	incoStr2SAP = sapMRPControl.split("#")[2];
	*/
	
}
catch(Exception e)
{
	System.out.println("Exception while getting plant codes from SAP ::::"+e);
}

%>
	
