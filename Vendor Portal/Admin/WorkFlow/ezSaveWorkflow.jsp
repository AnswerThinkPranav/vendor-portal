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
	String rowValue =request.getParameter("rowVal");
	String deptSel =request.getParameter("deptSel");
	int retVendItemsCnt3 = 0;
%>

<%
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	for(int l=0;l<Integer.parseInt(rowValue);l++)
	{
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		int val=l+1;
	String levelVal=checkNull(request.getParameter("levelVal_"+val));
	if(levelVal != null && !levelVal.trim().isEmpty())
	{
	miscTableRow.setQuery("DELETE FROM ezc_user_workflow WHERE EZWF_WorkFlowKey='"+deptSel+"' and EZWF_Level='"+levelVal+"'");
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
	}
	}
%>
<%
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	for(int l1=0;l1<Integer.parseInt(rowValue);l1++)
	{
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	int val2=l1+1;
	String levelVal2=checkNull(request.getParameter("levelVal_"+val2));
	String userName=checkNull(request.getParameter("selName_"+val2));
	
	ezc.ezcommon.EzLog4j.log("****==level and user=====**"+levelVal2+""+userName,"I");	
	if(levelVal2 != null && !levelVal2.trim().isEmpty() && userName != null && !userName.trim().isEmpty())
	{
	miscTableRow1.setQuery("INSERT INTO ezc_user_workflow (EZWF_WorkFlowKey, EZWF_Level, EZWF_UserId) VALUES('"+deptSel+"','"+levelVal2+"','"+userName+"')");
	ezc.ezcommon.EzLog4j.log("query>>>>"+miscTableRow1.getQuery(),"I");	
	miscTable1.appendRow(miscTableRow1);
	}
	}
	
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
%>


	<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
  		<Tr align="center">
    			<Td class="displayheader">Work Flow Added</Td>
  		</Tr>
	</Table>



<br>
<center>
<a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none alt="Click here to Back"></a>
</center>