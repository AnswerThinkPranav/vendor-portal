<%@ page language="java" errorPage="../Misc/ezErrorDisplay.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String templateCode = request.getParameter("template");
	int retObjWFTempCnt = 0;
	
	ezc.ezparam.ReturnObjFromRetrieve retObjWFTemp = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams wfParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager wfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable wfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow wfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	wfTableRow.setQuery("SELECT EWPC_TEMPLATE,EWPC_LEVEL,EWPC_ROLE,EWPC_GROUP,EWPC_QCF_FLAG,EWPC_QCF_RELEASE FROM EZC_WF_PRICING_CONDITIONS where EWPC_TEMPLATE='"+templateCode+"' order by EWPC_LEVEL");
	wfTable.appendRow(wfTableRow);
	wfParams.setLocalStore("Y");
	wfParams.setObject(wfTable);
	Session.prepareParams(wfParams); 

	try{
		retObjWFTemp=(ezc.ezparam.ReturnObjFromRetrieve)wfMgr.ezGetMiscTransactions(wfParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Exception in getting EZC_WF_KEY_MAP:::::::","E");
	}
	
	if(retObjWFTemp!=null && retObjWFTemp.getRowCount()>0)
		retObjWFTempCnt = retObjWFTemp.getRowCount(); 
		
	//out.println(":::retObjWFTemp:::"+retObjWFTemp.toEzcString());	
%>
<HTML>
<head>
<script>

</script>
</head>
<form name="myForm">

<br><br>
<DIV id="theads">
<table id="tabHead" width="50%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<Tr>
	<Th  width="15%">Level</Th>
	<Th width="15%">Role</Th>
	<Th width="15%">Group</Th>
	<Th width="15%">Condition</Th>
	<Th width="15%">Value</Th>
	
</Tr>
<%
	for(int i=0;i<retObjWFTempCnt;i++)
	{
%>	 
        <tr>
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWPC_LEVEL")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWPC_ROLE")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWPC_GROUP")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWPC_QCF_FLAG")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWPC_QCF_RELEASE")%></Td>	
	</tr>
<%
 
 	}
%> 	
        </tABLE>
        </div>
        <div id="ButtonDiv" align="center" style="position:absolute;top:90%;width:100%">
		 <!-- <input type="image" src = "../../Images/Buttons/<%= ButtonDir%>/add.gif"  name="Submit" value="Add..." onClick="funAdd()">
		  <input type="image" src = "../../Images/Buttons/<%= ButtonDir%>/delete.gif"  name="Submit" value="Add..." onClick="funDelete()">
		  <a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none></a>-->
		  <a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none></a>
         </div>
<br>
<Div id="MenuSol"></Div>
</form>