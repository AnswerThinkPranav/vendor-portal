<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>       
<%@ include file="../../../Includes/JSPs/Misc/iGetAuditList.jsp" %>
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%> 
<head>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<script>
	function funOpenAudit(fileName,auditNumber,vendor,year,month,buyerComments,vendorComments,dueDate,auditStatus,vendorName)
	{
		document.myForm.auditNumber.value = auditNumber;
		document.myForm.vendor.value = vendor;
		document.myForm.year.value = year;
		document.myForm.month.value = month;
		document.myForm.dueDate.value = dueDate;
		document.myForm.buyerComments.value = buyerComments;
		document.myForm.vendorComments.value = vendorComments;
		document.myForm.auditStatus.value = auditStatus;
		document.myForm.vendorName.value = vendorName;
	
		var url;
		var userType='<%=userType%>';
		if(userType==3)
			fileName='ezVendorAFindingdDetails.jsp';

		document.myForm.action=fileName;
		document.myForm.submit();

	}
</script>	
</head>
<body scroll=no> 
<%
// create hash table
      Hashtable monTable = new Hashtable();

      // put values in table
      monTable.put(1, "January");
      monTable.put(2, "February");
      monTable.put(3, "March");
      monTable.put(4, "April");
      monTable.put(5, "May");
      monTable.put(6, "June");
      monTable.put(7, "July");
      monTable.put(8, "August");
      monTable.put(9, "September");
      monTable.put(10, "October");
      monTable.put(11, "November");
      monTable.put(12, "December ");
%>
<form name="myForm" method="post">
<input type='hidden' name=vendCode value='<%=vendorCode%>'>
<input type='hidden' name=FromDate value='<%=fromDate%>'>
<input type='hidden' name=ToDate value='<%=toDate%>'>
<input type='hidden' name=auditNumber value=''>
<input type='hidden' name=vendor value=''>
<input type='hidden' name=year value=''>
<input type='hidden' name=month value=''>
<input type='hidden' name=dueDate value=''>
<input type='hidden' name=buyerComments value=''>
<input type='hidden' name=vendorComments value=''>
<input type='hidden' name=auditStatus value=''>
<input type='hidden' name=vendorName value=''>





<%	
	String display_header = "List Of Audit Findings";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<div style="position:absolute;top:12%;width:100%;left:0%;overflow:auto;height:328px">
	<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<thead>
		<Tr>
			<th align="center" width="10%">Audit Number</th>
			<th align="center" width="10%">Created On</th>
			<th align="center" width="40%">Vendor</th>
			<th align="center" width="10%">Month</th>
			<th align="center" width="10%">Year</th>
			<th align="center" width="10%">Due Date</th>
			<th align="center" width="10%">Status</th>
			
			
			
		</tr>
	</thead>
	<tbody>		
<%
	String auditNumber 	= "";
	String vendor	        = "";
	String year	        = "";
	String month  	        = "";
	String buyerComments    = "";
	String vendorComments   = "";        
	String createdOn      	= "";
	String dueDate      	= "";
	String auditStatus     	= "";
	
	
	
	for (int i= 0; i<count; i++)
	{
		dueDate      	= "";
		auditNumber	= auditListRetObj.getFieldValueString(i,"EAF_AUDIT_NO");
		createdOn	= auditListRetObj.getFieldValueString(i,"EAF_CREATED_ON");
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date 	= formatter.parse(createdOn);
		formatter = new SimpleDateFormat("dd-MM-yyyy");
		String creatdOn = formatter.format(date);
		
		dueDate	  = auditListRetObj.getFieldValueString(i,"EAF_DUE_DATE");
		if(dueDate!=null && !"null".equals(dueDate))
			dueDate	  = getDislayDateForDateString(auditListRetObj.getFieldValueString(i,"EAF_DUE_DATE"));
		
		vendor	= auditListRetObj.getFieldValueString(i,"EAF_VENDOR");
		year	= auditListRetObj.getFieldValueString(i,"EAF_YEAR");
		month	= auditListRetObj.getFieldValueString(i,"EAF_MONTH");
		month=(String)monTable.get(Integer.parseInt(month));
		buyerComments	= auditListRetObj.getFieldValueString(i,"EAF_BUYER_COMMENTS");
		vendorComments	= auditListRetObj.getFieldValueString(i,"EAF_VENDOR_COMMENTS");
		auditStatus	= auditListRetObj.getFieldValueString(i,"EAF_STATUS");
		String auditNumberhyperLink = "<a href=\"JavaScript:funOpenAudit('ezAFindingdDetails.jsp','"+auditNumber+"','"+vendor+"','"+year+"','"+month+"','"+buyerComments+"','"+vendorComments+"','"+dueDate+"','"+auditStatus+"','"+vendorsHT.get(vendor)+"')\">"+auditNumber+"</a>";
		
		
		
		if("C".equals(auditStatus))
			auditStatus = "Closed";
		else //if("X".equals(auditStatus))
			auditStatus = "Pending";
		
	
%>	
		<Tr>
			<td align="center" width="10%"><%=auditNumberhyperLink%></td>
			<td align="center" width="10%"><%=creatdOn%></td>
			<td align="left"  width="40%">&nbsp;<%=vendorsHT.get(vendor)+" ["+vendor+"]"%></td>	
			<td align="left" width="10%"><%=month%></td>
			<td align="center" width="10%"><%=year%></td>
			<td align="center" width="10%"><%=dueDate%></td>
			<td align="center" width="10%"><%=auditStatus%></td>



		</Tr>
<%
	}
%>	
	</Tbody>
	</Table>

<Div id="ButtonDiv" style="position:absolute;top:90%;width:80%;visibility:visible">	
<Center>
<%	
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Back");
	buttonMethod.add("history.go(-1)");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Center>
</Div>		
	
</Form>
<Div id="MenuSol"></Div> 
</Body>
</Html>