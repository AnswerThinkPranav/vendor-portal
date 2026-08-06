<%@ page import="java.util.*,java.text.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>  
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/DateFunctions.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>  
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>          
  
<%    
	int dateRange = 500;//90   
	String fromDate		= request.getParameter("FromDate");
	String toDate		= request.getParameter("ToDate");  
	ReturnObjFromRetrieve vendorsRetObj = null;
	int vendorsRetObjCnt=0; 
	ReturnObjFromRetrieve tempVendorsRetObj = null;
	int tempVendorsRetObjCnt=0;
	String display_header="";
	String clickString="onclick='ezSubmit()'";
%>
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%>
<%@ include file="iListVendReg.jsp"%>  
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<html>
<head>    
<script>
function ezSubmit()
{
	document.myForm.action = "ezListVendReg.jsp?menuItem=vendReg";
	document.myForm.submit();
}               
</script>
</head>

<body onLoad="getDefaultsFromTo()">
<style>
.pane {
  background: #fff;
}
.pane-hScroll {
  overflow: auto;
  width: 100%;
   
} 
</style> 
<form name="myForm" method="POST">  
<input type='hidden' name='menuItem' value='<%=request.getParameter("menuItem")%>'>
<input type="hidden" name="fromDate" value="<%=fromDate%>">
<input type="hidden" name="toDate" value="<%=toDate%>">


<%@ include file="../Misc/ezSubHeader.jsp"%>
<%
	if("2".equals(userType))  
	{
%>
		<%@ include file="../Misc/ezSelectDate.jsp"%>  
<% 
	}
%>
	
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>
  
	<div class="box" style="padding: 13px;">
	<div class="pane pane--table1">
	<div class="pane-hScroll">
	<table id="example" class="table table-striped table-bordered  nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>> 
			<th align="center" width="20%">Doc Number</th>
			<th align="center" width="20%">Created On</th>
			<th align="center" width="20%">Created By</th>
			<th align="center" width="20%">Status</th>
			<th align="center" width="20%">Pur Org.</th>
		</tr>
	</thead>
	<tbody>
<%
	for(int i=0;i<toActVendCnt;i++)
	{
%>
		<tr>
		<td align="center">
		<a style='text-decoration:underline' href="ezVendReg.jsp?docId=<%=hdrVendXML.getFieldValueString(i,"ECFH_DOC_ID")%>"><%=hdrVendXML.getFieldValueString(i,"ECFH_DOC_ID")%></a>
		</td>
		<td align="center">
		<%=hdrVendXML.getFieldValueString(i,"ECFH_CREATED_ON")%>
		</td>
		<td align="center">
		<%=hdrVendXML.getFieldValueString(i,"ECFH_CREATED_BY")%>
		</td>
		<td align="center">
		<%=hdrVendXML.getFieldValueString(i,"ECFH_STATUS")%>
		</td>
		<td align="center">
		<%=hdrVendXML.getFieldValueString(i,"ECFH_SALES_ORG")%>
		</td>
		</tr>
<%
		
		
	}
%>
		
		</tbody>
</Table>
</div> 
</div> 
</div> 
<div class="spacer">
</div> 
</div>	
</form>

<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
  <script>
  $(document).ready(function() {
  		
         $("#FromDate").datepicker({ 
                	dateFormat: 'dd/mm/yy', 
                	changeMonth: true,
            	changeYear: true
         });
          $("#ToDate").datepicker({ 
                       	dateFormat: 'dd/mm/yy', 
                       	changeMonth: true,
            		changeYear: true
       });
       });
  
       </script>