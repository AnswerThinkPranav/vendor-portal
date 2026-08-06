<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorStmtConfirmedList.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<Html>
<Head>
<Script>
function funOpenAudit(fileName,vendor)
{	dor
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
	String display_header = "List Of Vendor Statement Confirmed List ";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<div style="position:absolute;top:12%;width:100%;left:0%;overflow:auto;height:328px">
		<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<thead>
			<Tr>
				<th align="center" width="20%">Vendor</th>
				<th align="center" width="20%">Quarter</th>
				<th align="center" width="15%">Year</th>
				<th align="center" width="15%">Comments</th>
				
				
			</tr>
		</thead>
		<tbody>		
	<%
		
		String vendor	        = "";
		String quarter	        = "";
		String year  	        = "";
		String comments  	        = "";
		       
		for (int i= 0; i<count; i++)
		{
			vendor	= VendorListRetObj.getFieldValueString(i,"EVBC_VENDOR");
			quarter	= VendorListRetObj.getFieldValueString(i,"EVBC_CONF_QUARTER");
			year	= VendorListRetObj.getFieldValueString(i,"EVBC_CONF_YEAR");
			comments	= VendorListRetObj.getFieldValueString(i,"EVBC_VEND_COMMENTS");
			
        
			
			
		
	%>	
					<Tr>
						<td align="center" width="20%"><%=vendor%></td>
						<td align="center" width="20%"><%=quarter%></td>
						<td align="center" width="20%"><%=year%></td>
						<td align="center" width="20%"><%=comments%></td>
						
						
						
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