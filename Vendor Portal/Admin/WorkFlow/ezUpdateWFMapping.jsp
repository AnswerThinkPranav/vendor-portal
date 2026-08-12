  <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
  <%@ page import ="ezc.ezparam.*,java.util.*" %>
  
  <%
  	String mapDept = request.getParameter("mapDept").trim();
  	mapDept = mapDept.replaceAll("'","`");
  	String mapPlant = request.getParameter("mapPlant").trim();
  	mapPlant = mapPlant.replaceAll("'","`");
  	String mapKey = request.getParameter("mapKey").trim();
  	mapKey = mapKey.replaceAll("'","`");
  	String mapVal = request.getParameter("mapVal").trim();
  	mapVal = mapVal.replaceAll("'","`");
  	String actFlag = request.getParameter("actFlag").trim();
          actFlag = actFlag.replaceAll("'","`");
         
       
  
  
  	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
  	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
  	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
  	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
  	
  	String qry = "";
  	  	if("ADD".equals(actFlag))
  		miscTableRow.setQuery("INSERT INTO ezc_wf_defaults_map (EWDM_DEPT,EWDM_PLANT,EWDM_KEY,EWDM_VALUE ) VALUES ('"+mapDept+"', '"+mapPlant+"', '"+mapKey+"','"+mapVal+"')");	
  	if("UPD".equals(actFlag))
  	{
  		qry = "UPDATE ezc_wf_defaults_map SET EWDM_DEPT='"+mapDept+"',EWDM_PLANT='"+mapPlant+"',EWDM_KEY='"+mapKey+"',EWDM_VALUE='"+mapVal+"' WHERE EWDM_DEPT='"+mapDept+"' AND EWDM_PLANT='"+mapPlant+"'AND EWDM_KEY='"+mapKey+"' ";
  		miscTableRow.setQuery(qry);
  	} 
  	if("DEL".equals(actFlag))
  	{
  		qry = "DELETE FROM ezc_wf_defaults_map WHERE EWDM_DEPT='"+mapDept+"' AND EWDM_PLANT='"+mapPlant+"'AND EWDM_KEY='"+mapKey+"' ";
  		miscTableRow.setQuery(qry);
  	}	
  	//out.println(actFlag+"::"+miscTableRow.getQuery());
  	try
  	{
  		miscTable.appendRow(miscTableRow);	
  		mainParams.setLocalStore("Y");
  		mainParams.setObject(miscTable);
  		Session.prepareParams(mainParams);
  		miscMgr.ezSaveMiscTransactions(mainParams);
  	} 
  	catch(Exception e)
  	{
  		out.println("Exception in Updating Audit Header>>>>>"+e);
  	}
  		
  	response.sendRedirect("ezWFMappings.jsp");
  		
%>