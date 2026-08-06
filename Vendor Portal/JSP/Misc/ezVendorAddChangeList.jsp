<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorAddChangeList.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<Html>
<Head>
<Script>
function funOpenAudit(fileName,refNo,vendorCode)
{	
	document.myForm.refNo.value=refNo;
	document.myForm.vendorCode.value=vendorCode;
	document.myForm.action=fileName;
	document.myForm.submit();

}
</Script>
</Head>
<Body>
<Form name='myForm'>
<input type='hidden' name='refNo' >
<input type='hidden' name='vendorCode' >
<input type='hidden' name='statusFlag' value='<%=statusFlag%>'>
<%	
	String display_header = "To Be Approved Vendor Address Change Requests";
	
	if("A".equals(statusFlag))
		display_header = "Approved Vendor Address Change Requests";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<div style="position:absolute;top:12%;width:100%;left:0%;overflow:auto;height:328px">
		<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<thead>
			<Tr>
				<th align="center" width="20%">Reference No.</th>
				<th align="center" width="20%">Vendor</th>
				<th align="center" width="20%">Vendor Name</th>
				<th align="center" width="15%">
<%
				if("A".equals(statusFlag))
				{
%>
					Approved On
<%
				}else{
%>
					Submitted On
<%
				}
%>
				</th>
				
				
			</tr>
		</thead>
		<tbody>		
	<%
		String refNo	        = "";
		String vendor	        = "";
		String companyName	        = "";
		String savedOn  	        = "";
		       
		for (int i= 0; i<count; i++)
		{
			refNo	= VendorListRetObj.getFieldValueString(i,"EVA_REF_NO");
			vendor	= VendorListRetObj.getFieldValueString(i,"EVA_VENDOR");
			companyName	= VendorListRetObj.getFieldValueString(i,"EVA_COMPANY_NAME");
			savedOn	= VendorListRetObj.getFieldValueString(i,"EVA_SAVED_ON");
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = formatter.parse(savedOn);
			 formatter = new SimpleDateFormat("dd-MM-yyyy");
			 String saveDate = formatter.format(date);
        
			String refNoHyperLink = "<a href=\"JavaScript:funOpenAudit('ezVendorAddrDetails.jsp','"+refNo+"','"+vendor.trim()+"')\">"+refNo+"</a>";
			
		
	%>	
					<Tr>
						<td align="center" width="20%"><%=refNoHyperLink%></td>
						<td align="center" width="20%"><%=vendor%></td>
						<td align="left" width="20%">&nbsp;&nbsp;<%=companyName%></td>
						<td align="center" width="20%"><%=saveDate%></td>
						
						
						
					</Tr>
	
	<%
	
		}
		
		
	%>	
		</Tbody>
		</Table>
	</Form>
	<Div id="MenuSol"></Div> 
	</Body>
</Html>

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>