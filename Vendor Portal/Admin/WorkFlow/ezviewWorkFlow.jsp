<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*" %>   
<%@ page import="java.util.*, java.sql.*"%>  
<%
	String dept=request.getParameter("deptSel");
	Hashtable<String,String> workFlowUserMap=new Hashtable<String,String>();
	if(dept!=null)
	{
	ezc.ezparam.EzcParams mainParams4 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr4 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable4 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow4 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems4	  =	null;
	
	miscTableRow4.setQuery("select * from ezc_user_workflow WHERE EZWF_WorkFlowKey='"+dept+"'");
	miscTable4.appendRow(miscTableRow4);
	mainParams4.setLocalStore("Y");
	mainParams4.setObject(miscTable4);
	Session.prepareParams(mainParams4); 
	try
	{
		retVendItems4=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr4.ezGetMiscTransactions(mainParams4);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retVendItemsCnt4=0;
	if(retVendItems4 != null)
	retVendItemsCnt4 = retVendItems4.getRowCount();
	for(int s=0;s<retVendItemsCnt4;s++)
	{
	workFlowUserMap.put(retVendItems4.getFieldValueString(s,"EZWF_Level"),retVendItems4.getFieldValueString(s,"EZWF_UserId"));
	}
	}
%>