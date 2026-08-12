<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>
<%@include file="../../../Includes/JSPs/Rfq/iViewSchedules.jsp"%>
<%@ page import="ezc.ezutil.*" %>
    
<html>
<head>   
	<script> 
	function goToPlantAddr(plant)
	{
		window.open("../Purorder/ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,width=300,height=300,left=250,top=200");
	}
	function goBack(){
		var portRfqNum=document.myForm.portRfqNum.value;
		document.forms[0].action = "ezViewRFQDetails.jsp?portRfqNum="+portRfqNum;
		document.forms[0].submit();
	}
	</script>
<Script>
var tabHeadWidth=94
var tabHeight="65%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll="no">
<form name="myForm" method="post">
	<input type="hidden" name="EndDate" value="<%=EndDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" value="<%=rfqNumber%>" name="rfqNumber">
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	<input type="hidden" name="portRfqNum" value="<%=request.getParameter("portRfqNum")%>">
	
	<input type="hidden" value="<%=rfqVendor%>" name="rfqVendor">
	<input type="hidden" value="<%=rfqCompCode%>" name="rfqCompCode">
	<input type="hidden" value="<%=rfqPurOrg%>" name="rfqPurOrg">
	<input type="hidden" value="<%=rfqSysKey%>" name="rfqSysKey">
<%
	 ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	 String display_header	= "RFQ > RFQ's To Be Responded > RFQ Details > Delivery Schedules For SAP RFQ No : "+rfqNumber;
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%> 
 	<br><br>

	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>>
     	<th width="8%">Line</th>
      	<th width="14%">Material</th>
      	<th width="39%">Description</th>
      	<th width="6%">UOM</th>
      	<th width="13%">Req. Qty </th>
     	<th width="10%">Req. Date</th>
	<th width="10%">Plant</th>
 	</tr>
	</Thead>  
	<TBody>	
<%
   	for(int i=0;i<Count;i++)
   	{
	       	String date = FormatDate.getStringFromDate((java.util.Date)retObj.getFieldValue(i,"DLVDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String plant = retObj.getFieldValueString(i,"PLANT");
%>
     		<tr>
		<td width="8%"><%=retObj.getFieldValueString(i,"LINENUM")%></td>
		<td width="14%">
<%
		try{
			out.println(Long.parseLong(retObj.getFieldValueString(i,"MATERIAL")));
		}catch(Exception e){
			out.println(retObj.getFieldValueString(i,"MATERIAL"));	
		}
%>  
		</td>
     		<td width="39%"><%=retObj.getFieldValueString(i,"MATDESC")%></td>
		<td width="6%" align="center"><%=retObj.getFieldValueString(i,"UOM")%></td>
     		<td width="13%" align="right"><%=retObj.getFieldValueString(i,"QUANTITY")%></td>
      		<td width="10%" align="center"><%=date%></td> 
      		<td width="10%" align="center">
			<a href="Javascript:void(0)" onClick="goToPlantAddr('<%=plant%>')"  onMouseover="window.status='Click to view the Plant Address. '; return true" onMouseout="window.status=' '; return true">
			<%=plant%></a>&nbsp;</td>
		</tr>
<%
	}
%>
  	</Tbody>
  	</Table>

	<div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
		<center>
			<button type="button" class="btn btn-primary" onclick="goBack()">Back</button>  &nbsp;	
		</center>
		</div>
	<%@ include file="../Misc/AddMessage.jsp" %>
</form>
<Div id="MenuSol"></Div>
</body>
</html>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>