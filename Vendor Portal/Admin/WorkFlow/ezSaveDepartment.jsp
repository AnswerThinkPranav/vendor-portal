<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*" %>   
<%@ page import="java.util.*, java.sql.*"%> 
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>


<%!       
 
	public String checkNull(String str)    
	{  
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str)) 
			retStr = "";
		else
			retStr = str;
			
		return retStr;	
	}
	      
%>

<%
	String deptCode =request.getParameter("deptCode");
	String deptDesc =request.getParameter("deptDesc");
	int retVendItemsCnt3 = 0;
%>

<%
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("DELETE FROM EZC_VALUE_MAPPING WHERE MAP_TYPE='CATEGORY' AND VALUE1='"+deptCode+"'");
	
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
	miscMgr.ezSaveMiscTransactions(mainParams);
	
	}
	catch(Exception e)
	{
	
		ezc.ezcommon.EzLog4j.log("****==exception1=====**"+e,"I");
	}
%>
<%
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow1.setQuery("INSERT INTO EZC_VALUE_MAPPING (MAP_TYPE, VALUE1, VALUE2) VALUES('CATEGORY','"+deptCode+"','"+deptDesc+"')");
	
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	try
	{
	miscMgr1.ezSaveMiscTransactions(mainParams1);
	
	}
	catch (Exception e)
	{
	
		ezc.ezcommon.EzLog4j.log("****==exception2=====**"+e,"I");
	}
	
	ezc.ezparam.EzcParams mainParams3 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr3 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable3 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow3 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems3	  =	null;
	
	miscTableRow3.setQuery("select * from EZC_VALUE_MAPPING WHERE MAP_TYPE='CATEGORY' AND VALUE1='"+deptCode+"' AND VALUE2='"+deptDesc+"'");
	miscTable3.appendRow(miscTableRow3);
	mainParams3.setLocalStore("Y");
	mainParams3.setObject(miscTable3);
	Session.prepareParams(mainParams3); 
	try
	{
		retVendItems3=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr3.ezGetMiscTransactions(mainParams3);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	
	if(retVendItems3 != null)
	retVendItemsCnt3 = retVendItems3.getRowCount(); 

%>

<%
if(retVendItemsCnt3!=0)
{
%>
	<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
  		<Tr align="center">
    			<Td class="displayheader">Department Added</Td>
  		</Tr>
	</Table>
<%
}
else
{
%>

<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
  		<Tr align="center">
    			<Td class="displayheader">Error In Department Adding</Td>
  		</Tr>
	</Table>
<%
}
%>
<br>
<center>
<a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none alt="Click here to Back"></a>
</center>