<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezparam.*;" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 

<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<%
out.println(userSyskeysStr+":::::::::::::::userSyskeysStr");
	ReturnObjFromRetrieve retUsers  = null;
	int retUsersCnt = 0;
	
	EzcUserParams uparams= new EzcUserParams();
	Session.prepareParams(uparams);	
	EzcUserNKParams ezcUserNKParams = new EzcUserNKParams();
	ezcUserNKParams.setLanguage("EN");
//	ezcUserNKParams.setSys_Key("999000') AND EU_CHANGED_BY IN ('"+Session.getUserId());
	ezcUserNKParams.setSys_Key(userSyskeysStr+"','999000') AND EU_TYPE IN('4");
	uparams.createContainer();
	uparams.setObject(ezcUserNKParams);
	retUsers =	(ReturnObjFromRetrieve)UserManager.getUsersForSalesArea(uparams);
	
	if(retUsers!=null)
		retUsersCnt = retUsers.getRowCount();
		
	//out.println(":::retUsers:::"+retUsers.toEzcString());
	ReturnObjFromRetrieve retSAPUsers  = null;
	int retSAPUsersCnt = 0;
	
	uparams= new EzcUserParams();
	Session.prepareParams(uparams);	
	ezcUserNKParams = new EzcUserNKParams();
	ezcUserNKParams.setLanguage("EN");
//	ezcUserNKParams.setSys_Key("999000') AND EU_CHANGED_BY IN ('"+Session.getUserId());
	ezcUserNKParams.setSys_Key(userSyskeysStr+"') AND EU_TYPE IN('3");
	uparams.createContainer();
	uparams.setObject(ezcUserNKParams);
	retSAPUsers =	(ReturnObjFromRetrieve)UserManager.getUsersForSalesArea(uparams);
	
	if(retSAPUsers!=null)
		retSAPUsersCnt = retSAPUsers.getRowCount();
			
%>		



<html>
<head>
<script>
	function ezSubmit()
	{
		if(document.myForm.inputRfqNumber.value=='')
		{
			alert("Please enter SAP RFQ number");
			document.myForm.inputRfqNumber.focus();
			return;
		}
		
		var tempUserIdObj = document.myForm.tempUserId;
		var tempUserIdObjLen = tempUserIdObj.length;
		var checkedCnt = 0;
		
		if(isNaN(tempUserIdObjLen))
		{
			if(tempUserIdObj.checked)
				checkedCnt++;
		}else{
			for(var i=0;i<tempUserIdObjLen;i++)
			{
				if(tempUserIdObj[i].checked)
					checkedCnt++;
			}
		}
		
		if(checkedCnt==0)
		{
			alert("Please select vendor(s)");
			return;
		}
		
		document.myForm.action = 'ezSendRFQtoTempUsers.jsp';
		document.myForm.submit();
	}
</Script>
</head> 
<style>
.nav-pills>li>a {
    
    border-top: 3px solid #c73030fa;
    color: #333;
}
.nav>li>a:focus{
background-color: #59584C;
 color: #ffffff;
}
</style>

<body scroll=no>
<form name="myForm" method="post">
<input type='hidden' name='ShipId' value=''>
<input type='hidden' name='docId' value=''>
<input type='hidden' name='ponum' value=''>
<input type='hidden' name='orderBase' value='po'>

<%	
	String display_header	= "Temporary/SAP Users > Send RFQ"; 
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%>
	<br>
	<Table width="40%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr align="center" valign="middle">
		<Th <%=trBGColor%> width= "60%" align="right"> Reference SAP RFQ No.*</th>
		<Td width= "40%" align="left">&nbsp;&nbsp;<input type="text" class=InputBox  name="inputRfqNumber" value="" size="10" maxlength="10">
		&nbsp;&nbsp;<button type="button" onclick="ezSubmit()">Send</button>  
		</Td>		
	</Tr>
	</Table>
	<center><font color=red size=2><B>Enter SAP RFQ Number, select vendor(s) and then click on Send button</B></Font></center>
	
	<div id="tabs">
	  <ul class="nav nav-pills" style="padding-left: 5px;padding-bottom: 5px;">
	    <li style="font-size:small;background-color: #f7f7f7"><a href="#tabs-1"><b>Temporary Users</b></a></li>
	    <li style="font-size:small;background-color: #f7f7f7"><a href="#tabs-2"><b>SAP Users</b></a></li>
	  </ul>
	  <div class="container" style="width: auto;padding-left: 25px;padding-right: 25px;">
        <div id="tabs-1">  
        <div class="row">
	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>>
		<th width="5%">&nbsp;</th>
		<th width="10%">User Id</th>
		<th width="10%">Name</th>
		<th width="10%">EMail</th>
		<th width="10%">Contact No.</th>
		<!--<th width="10%">Valid From</th>
		<th width="10%">Valid To</th>
		<th width="10%">Status</th>-->
	</tr>
	</thead>
	<tbody>		
<%
	String color = "";
	String modeTpt = "";

	for(int i=0;i< retUsersCnt;i++)
	{

		color = "";
		//if(i%2==0) {color = "style='background-color:#c9e0ff'";}
%>
		<tr>
			<td width="5%" align="center" <%=color%>> <input name='tempUserId' type='checkbox' value='<%=retUsers.getFieldValueString(i,"EU_ID")+"_NONSAP"%>'> </td>	
			<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_ID")%> </td>	
			<td width="10%" align="left" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_FIRST_NAME")%> </td>	
			<td width="10%" align="left" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_EMAIL")%> </td>	
			<td width="10%" align="center" <%=color%>> <%=checkNull(retUsers.getFieldValueString(i,"EU_CONTACT_NO"))%> </td>
			<!--<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_CREATED_DATE")%> </td>
			<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_VALID_TO_DATE")%> </td>
			<td width="10%" align="center" <%=color%>> &nbsp; </td>-->
		</tr>
<%
	}
%>
	</tbody>	
	</table>
	</div>
	</div>
	<div id="tabs-2">  
        <div class="row">
	<table id="example1" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>>
		<th width="5%">&nbsp;</th>
		<th width="10%">User Id</th>
		<th width="10%">Name</th>
		<th width="10%">EMail</th>
		<th width="10%">Contact No.</th>
		<!--<th width="10%">Valid From</th>
		<th width="10%">Valid To</th>
		<th width="10%">Status</th>-->
	</tr>
	</thead>
	<tbody>		
<%
	ArrayList userAL = new ArrayList();
	color = "";
	modeTpt = "";

	for(int i=0;i< retSAPUsersCnt;i++)
	{

		color = "";
		//if(i%2==0) {color = "style='background-color:#c9e0ff'";}
		
		if(userAL.contains(retSAPUsers.getFieldValueString(i,"EU_ID")))continue;
		userAL.add(retSAPUsers.getFieldValueString(i,"EU_ID"));
%>
		<tr>
			<td width="5%" align="center" <%=color%>> <input name='tempUserId' type='checkbox' value='<%=retSAPUsers.getFieldValueString(i,"EU_ID")+"_SAP"%>'> </td>	
			<td width="10%" align="center" <%=color%>> <%=retSAPUsers.getFieldValueString(i,"EU_ID")%> </td>	
			<td width="10%" align="left" <%=color%>> <%=retSAPUsers.getFieldValueString(i,"EU_FIRST_NAME")%> </td>	
			<td width="10%" align="left" <%=color%>> <%=retSAPUsers.getFieldValueString(i,"EU_EMAIL")%> </td>	
			<td width="10%" align="center" <%=color%>> <%=checkNull(retSAPUsers.getFieldValueString(i,"EU_CONTACT_NO"))%> </td>
			<!--<td width="10%" align="center" <%=color%>> <%=retSAPUsers.getFieldValueString(i,"EU_CREATED_DATE")%> </td>
			<td width="10%" align="center" <%=color%>> <%=retSAPUsers.getFieldValueString(i,"EU_VALID_TO_DATE")%> </td>
			<td width="10%" align="center" <%=color%>> &nbsp; </td>-->
		</tr>
<%
	}
%>
	</tbody>	
	</table>
	</div>
	</div>	
	</div>
	</div>
	<!--<center>
		<button type="button" class="btn btn-primary" onclick="ezSubmit()">Send</button>  &nbsp;
	</center>	-->
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<script>
$(document).ready(function() {
	$("#tabs").tabs( {
		"show": function(event, ui) {
			var oTable = $('div.dataTables_scrollBody>table.display', ui.panel).dataTable();
			if ( oTable.length > 0 ) {
				oTable.fnAdjustColumnSizing();
			}
		}
	} );
	
	$('table.display').dataTable( {
		"sScrollY": "200px",
		"bScrollCollapse": true,
		"bPaginate": false,
		"bJQueryUI": true,
		"aoColumnDefs": [
			{ "sWidth": "10%", "aTargets": [ -1 ] }
		]
	} );
} );
</script>
<%@ include file="../Misc/ezDataTableScript.jsp"%>