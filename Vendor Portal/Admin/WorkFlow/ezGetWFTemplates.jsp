<%@ page language="java" errorPage="../Misc/ezErrorDisplay.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	int retObjWFTempCnt = 0;
	
	ezc.ezparam.ReturnObjFromRetrieve retObjWFTemp = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams wfParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager wfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable wfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow wfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	wfTableRow.setQuery("SELECT EWKM_DOC_TYPE,EWKM_COMP_CODE,EWKM_PLANT,EWKM_CATEGORY,EWKM_TEMPLATE FROM EZC_WF_KEY_MAP");
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
	<Th  width="15%">Comp Code</Th>
	<Th width="15%">Doc Type</Th>
	<Th width="15%">Plant</Th>
	<Th width="15%">Category</Th>
	<Th width="15%">Template</Th>
	<Th width="15%">WorkFlow Users</Th>
	
</Tr>
<%
	for(int i=0;i<retObjWFTempCnt;i++)
	{
		String template = retObjWFTemp.getFieldValueString(i,"EWKM_TEMPLATE");
		String compCode = retObjWFTemp.getFieldValueString(i,"EWKM_COMP_CODE");
		String plant	= retObjWFTemp.getFieldValueString(i,"EWKM_PLANT");
		String category	= retObjWFTemp.getFieldValueString(i,"EWKM_CATEGORY");
		String docType	= retObjWFTemp.getFieldValueString(i,"EWKM_DOC_TYPE");
%>	 
        <tr>
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWKM_COMP_CODE")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWKM_DOC_TYPE")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWKM_PLANT")%></Td>	
		<Td width="15%"><%=retObjWFTemp.getFieldValueString(i,"EWKM_CATEGORY")%></Td>	
		<Td width="15%"><a href="ezGetWFSteps.jsp?template=<%=template%>"><%=template%></a></Td>	
		<Td width="15%"><a href="ezWFUsers.jsp?compCode=<%=compCode%>&category=<%=category%>&plant=<%=plant%>&docType=<%=docType%>">Workflow Users</a></Td>	
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
         </div>
<br>
<Div id="MenuSol"></Div>
</form>

