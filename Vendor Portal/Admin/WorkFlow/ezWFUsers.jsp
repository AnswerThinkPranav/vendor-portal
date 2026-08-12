<%@ page language="java" errorPage="../Misc/ezErrorDisplay.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String compCode = request.getParameter("compCode");
	String plant	= request.getParameter("plant");
	String category	= request.getParameter("category");
	String docType	= request.getParameter("docType");

	int retObjWFTempCnt = 0;
	
	ezc.ezparam.ReturnObjFromRetrieve retObjWFTemp = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams wfParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager wfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable wfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow wfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	String query = "SELECT *,(SELECT GROUP_CONCAT(CONCAT(B.EU_FIRST_NAME,'  [ ',B.EU_ID,']')) FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP =EWPC_GROUP  AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE='"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_STR FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"') ORDER BY EWPC_LEVEL";
	wfTableRow.setQuery(query);
	ezc.ezcommon.EzLog4j.log("query:::::::::::::::::::::ezWFUsers::::::::::::::::::"+query,"I");
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
	<Th  width="30%">Company Code</Th><Td width="20%"><%=compCode%></Td>
	<Th  width="30%">Doc Type</Th><Td width="20%"><%=docType%></Td>
</Tr>
<Tr>
	<Th  width="30%">Plant</Th><Td width="20%"><%=plant%></Td>
	<Th  width="30%">Category</Th width="20%"><Td><%=category%></Td>
</Tr>
</table>
<Br>
<table id="tabHead" width="80%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<Tr>
	<Th  width="5%">Level</Th>
	<Th width="45%">User</Th>
	<Th width="15%">Role</Th>
	<Th width="15%">Group</Th>
	<Th width="10%">Condition</Th>
	<Th width="15%">Value</Th>
	
</Tr>
<%
	for(int i=0;i<retObjWFTempCnt;i++)
	{
		String stepUsers = retObjWFTemp.getFieldValueString(i,"USER_STR");
		stepUsers = stepUsers.replaceAll(",","<BR>");
%>	 
        <tr>
		<Td width="5%" align=center>&nbsp;<%=retObjWFTemp.getFieldValueString(i,"EWPC_LEVEL")%></Td>	
		<Td width="45%" align=left>&nbsp;<%=stepUsers%></Td>	
		<Td width="15%" align=center>&nbsp;<%=retObjWFTemp.getFieldValueString(i,"EWPC_ROLE")%></Td>	
		<Td width="15%" align=center>&nbsp;<%=retObjWFTemp.getFieldValueString(i,"EWPC_GROUP")%></Td>	
		<Td width="10%" align=center>&nbsp;<%=retObjWFTemp.getFieldValueString(i,"EWPC_QCF_FLAG")%></Td>	
		<Td width="15%" align=center>&nbsp;<%=retObjWFTemp.getFieldValueString(i,"EWPC_QCF_RELEASE")%></Td>	
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