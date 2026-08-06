<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 

<%	
	ReturnObjFromRetrieve retObj = null;
	int retObjCnt = 0;
	ezc.ezmisc.client.EzMiscManager ezMiscManager = new ezc.ezmisc.client.EzMiscManager();
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT DISTINCT EC_ERP_CUST_NO,ECA_NAME FROM EZC_CUSTOMER,EZC_CUSTOMER_ADDR WHERE EC_NO = ECA_NO AND EC_SYS_KEY IN ('"+userSyskeysStr+"') AND EC_PARTNER_FUNCTION ='VN'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}catch(Exception e){} 
	
	if(retObj!=null)
		retObjCnt = retObj.getRowCount();
%>

<html>
<head>    
<script>

function gotoVendView(vendCode,vendName)
{
	document.myForm.vendFromBuyerView.value = vendCode;
	document.myForm.vendNameFromBuyerView.value = vendName;
	
	document.myForm.action = "ezWelcome_New.jsp";
	document.myForm.submit();
}

</script>

</head>

<body>
<form name="myForm" method="POST">
<input type='hidden' name='vendFromBuyerView' value=''>
<input type='hidden' name='vendNameFromBuyerView' value=''>

<%
	String display_header	= "List of Vendors"; 
%>

<%@ include file="../Misc/ezSubHeader.jsp"%> 
	 
<Br>
	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>> 
		<th align="center" width="10%">Vendor Code</th>
		<th align="center" width="10%">Vendor Name</th>
	</tr>
	</Thead>
	<TBody>		
<%
	String color = "";
	for(int i=0;i<retObjCnt;i++) 
	{ 			  
		color = "";
		if(i%2==0) {color = altRowColor;}
%>
		<Tr>
			<td align="center" width="10%" <%=color%>><a style='text-decoration:underline' href="javascript:gotoVendView('<%=retObj.getFieldValueString(i,"EC_ERP_CUST_NO")%>','<%=retObj.getFieldValueString(i,"ECA_NAME")%>')"><%=retObj.getFieldValueString(i,"EC_ERP_CUST_NO")%></a></td>
			<td align="left" width="10%" <%=color%>>&nbsp;<%=retObj.getFieldValueString(i,"ECA_NAME")%></td>
		</Tr>

<%
	}
%>
</Tbody>
	</Table>
<div class="spacer"></div> 
</div>	
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>