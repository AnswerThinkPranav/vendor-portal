<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*, java.net.*" %>
<%@ page import ="ezc.ezparam.*,java.util.*, java.net.*" %>
<%
	boolean sapGatewayConnCheck =true;
	//String sapGatewayCheckVendor=(String)Session.getUserId();
	
	try
	{
		String logonSite = (String)session.getValue("SITE");
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");200~999");
		JCoFunction sapGatewayFunction 		 = EzSAPHandler.getJCoFunction(sapGatewaydestination,"RFC_READ_TABLE");
		JCoParameterList sapGatewayImportParams 	= sapGatewayFunction.getImportParameterList();
		
		
		
		sapGatewayImportParams.setValue("QUERY_TABLE","LFA1");
		sapGatewayImportParams.setValue("DELIMITER","#");	 


		JCoTable sapGatewayOptionsTable 	 	= sapGatewayFunction.getTableParameterList().getTable("OPTIONS");
		JCoTable sapGatewayFieldsTable 	 	= sapGatewayFunction.getTableParameterList().getTable("FIELDS");
		
		sapGatewayFieldsTable.appendRow();
   		sapGatewayFieldsTable.setValue("FIELDNAME","LIFNR"); 
		 
		sapGatewayOptionsTable.appendRow();
		sapGatewayOptionsTable.setValue("TEXT","LIFNR IN ( '"+(String)Session.getUserId()+"' )");
		out.println(sapGatewayOptionsTable); 
		sapGatewayFunction.execute(sapGatewaydestination);
		
			
	}catch(Exception e){
		 ezc.ezcommon.EzLog4j.log("Exception occured::::SAP Gateway connection failed:::::"+e,"E");	
		sapGatewayConnCheck=false;
	}
%>
		