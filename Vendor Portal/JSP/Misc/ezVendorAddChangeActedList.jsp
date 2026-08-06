<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorAddChangeActedList.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<Html>
<Head>
<Script>
function funOpenAudit(fileName,vendor)
{	
	document.myForm.vendorID.value=vendor;
	document.myForm.action=fileName;
	document.myForm.submit();  

}
</Script>
</Head> 
<Body>
<Form name='myForm'>
<input type='hidden' name='vendorID' >
<%	
	String display_header = "List Of Updated  Vendor Address Change Requests";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<div style="position:absolute;top:12%;width:100%;left:0%;overflow:auto;height:328px">
		<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<thead>
			<Tr>
				<th align="center" width="20%">Vendor</th>
				<th align="center" width="20%">Vendor Name</th>
				<th align="center" width="15%">Submitted On</th>
				
				
			</tr>
		</thead>
		<tbody>		
	<%
		
		String vendor	        = "";
		String companyName	        = "";
		String savedOn  	        = "";
		       
		for (int i= 0; i<count; i++)
		{
			vendor	= VendorListRetObj.getFieldValueString(i,"EVA_VENDOR");
			companyName	= VendorListRetObj.getFieldValueString(i,"EVA_COMPANY_NAME");
			savedOn	= VendorListRetObj.getFieldValueString(i,"EVA_SAVED_ON");
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = formatter.parse(savedOn);
			 formatter = new SimpleDateFormat("dd-MM-yyyy");
			 String saveDate = formatter.format(date);
        
			String vendorhyperLink = "<a href=\"JavaScript:funOpenAudit('ezVendorAddrDetails.jsp','"+vendor+"')\">"+vendor+"</a>";
			
		
	%>	
					<Tr>
						<td align="center" width="20%"><%=vendor%></td>
						<td align="center" width="20%"><%=companyName%></td>
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