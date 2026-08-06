<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%	
	String display_header = "Audit Details";
	
	String auditNumber 	= request.getParameter("auditNumber");
	String vendor	        = request.getParameter("vendor");
	String year	        = request.getParameter("year");
	String month  	        = request.getParameter("month");
	String buyerComments    = request.getParameter("buyerComments");
	String vendorComments   = request.getParameter("vendorComments");
	String dueDate     	= request.getParameter("dueDate");
	String vendorName	= request.getParameter("vendorName");
	
	String listSelVendor	= request.getParameter("vendCode");
	String fromDate		= request.getParameter("FromDate");
	String toDate		= request.getParameter("ToDate");
%>
<Html>
<Head>
<Script>
function funSelAction(selAction)
{
	window.open("ezAuditPopUp.jsp?auditNumber=<%=auditNumber%>&auditVendor=<%=vendor%>&dueDate=<%=dueDate%>&listSelVendor=<%=listSelVendor%>&FromDate=<%=fromDate%>&ToDate=<%=toDate%>&selAction="+selAction,"UserWindow2","width=500,height=220,left=150,top=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no");
}



</Script>
</Head>
<Body>
<Center>
<Form name='myForm'>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<div>
		<table class="data-table" id="example" width='75%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<Tr>
			<th align="left" width="40%">Audit Number</th>
			<td align="left" width="20%"><%=auditNumber%></td>
			<th align="left" width="20%">Vendor</th>
			<td align="left" width="20%"><%=vendorName%></td>
		</Tr>	
		 <Tr>
			<th align="left" width="15%">Year</th>	
			<td align="left" width="20%"><%=year%></td>
			<th align="left" width="15%">Month</th>    
			<td align="left" width="20%"><%=month%></td>
		</tr>
		 <Tr>
			<th align="left" width="15%">Due Date</th>
			<td align="left" width="20%" colspan='3'><%=dueDate%></td>
		</tr>
		<Tr>
			<th align="left" width="15%">Remarks(MTR)</th>  
			<td align="left" width="20%" colspan='3'><%=buyerComments%></td>
		</Tr>
<%
		if(vendorComments!=null && !"null".equals(vendorComments))
		{
%>

			<Tr>
				<th align="left" width="15%">Vendor  Remarks</th>  
				<td align="left" width="20%" colspan='3'><%=vendorComments%></td>
			</Tr>
<%
		}
%>		
		</table>
		<center>
	<Div align='center' style='position:absolute;rigth:88%'>
	
	<br><br><br><bR>

</center>
<div>
<%
	String conStatus ="";
	String uploadKey = "";
	String docsKeyStr="'999111VAUDIT"+auditNumber+"','999111VAUDIT"+auditNumber+"','999111BAUDIT"+auditNumber+"','999111BAUDIT"+auditNumber+"'";
%>
<bR><br><Br>
<%@ include file="../Misc/ezGetUploadedDocs.jsp"%>
<%
	buttonName.add("Back");
	buttonMethod.add("history.go(-1)");
	if(docsListCnt>0)
	{
		buttonName.add("View Documents");
		buttonMethod.add("openViewUploadWindow()");
		
	}
	if(!"C".equals(request.getParameter("auditStatus")))
	{
		buttonName.add("Extend Date");
		buttonMethod.add("funSelAction(\"EXTEND\")");

		buttonName.add("Close");
		buttonMethod.add("funSelAction(\"CLOSE\")");
	}	
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>	

<Div id="MenuSol"></Div> 
</Center>
</Form>
</Body>
</Html>