<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorStmtToBeConfirmedList.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<%

	Hashtable yearHt=new Hashtable();
	yearHt.put("1","April--June");
	yearHt.put("2","July--Sept");
	yearHt.put("3","Oct--Dec");
	yearHt.put("4","Jan--March");
%>	
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
	String display_header = "List Of Vendor Statement To Be Confirmed";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<div style="position:absolute;top:12%;width:100%;left:0%;overflow:auto;height:328px">
		<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<thead>
			<Tr>
				<th align="center" width="20%">Vendor</th>
				<th align="center" width="20%">Quarter</th>
				
				
				
				
			</tr>
		</thead>
		<tbody>		
	<%
		
		String vendor	        = "";
		String quarter	        = "";
		String year  	        = "";
		
		       
		for (int i= 1; i<=4; i++)
		{
			vendor	= VendorListRetObj.getFieldValueString(i-1,"EVBC_VENDOR");
			quarter	= VendorListRetObj.getFieldValueString(i-1,"EVBC_CONF_QUARTER");
			year	= VendorListRetObj.getFieldValueString(i-1,"EVBC_CONF_YEAR");
			
			
			if(confimedQtrs.contains(i))
			{       
				
				continue;
			}	  
          
			
			
		
	%>	
					<Tr>
						<td align="center" width="20%"><%=vendCode%></td>
						<td align="center" width="20%"><%=i%></td>
						
						
						
						
						
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