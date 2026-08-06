<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	String cKey=request.getParameter("cKey");
	 String logonSite = (String)session.getValue("SITE");
	 JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
	 JCoFunction function =null;
	 
	 
	 	//VERIFY IFSC CODE
	 
			
		function = EzSAPHandler.getJCoFunction(destination,"Z_RFC_VENDOR_WITH_TX_CODE");

		JCoParameterList sapPreProc = function.getImportParameterList();
		sapPreProc.setValue("I_WT_WITHCD",cKey);

		
		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in Z_RFC_VENDOR_CREATE_IFSC_SHLP"+qe,"I");
		}
		
		
		JCoTable withholdingitems = function.getTableParameterList().getTable("ET_WT_WITHCD"); 
	
%>	
		<select class="form-dropdown" name="whTaxCode" value="" class="form-control select2 validate[required]" style="width:200px;margin-left: 3%;" onchange="" >
				<option value="">--Select withhold TaxCode--</option>
<%		
			if(withholdingitems.getNumRows()>0)
			{
	
				do
				{
%>
					<option value=<%=withholdingitems.getValue("WITHT")%>><%=withholdingitems.getValue("WITHT")%>--><%=withholdingitems.getValue("TEXT40")%></option>
<%
				}
				while(withholdingitems.nextRow());
			}
%>
		</select>