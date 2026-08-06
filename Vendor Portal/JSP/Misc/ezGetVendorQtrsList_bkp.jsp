<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorStmtConfirmedList.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
<Html>
<Head>
<Script>
function funPopup(comm)
{

	window.open("../Misc/ezViewComments.jsp?comm="+comm,"UserWindow1","width=650,height=270,left=150,top=250,resizable=yes,scrollbars=no,toolbar=no,menubar=no");
}
</Script>
</Head>
<Body>
<Form name='myForm'>
<input type='hidden' name='vendorID' >
<%	
	
	Date now = new Date();
	int month=0,yr=0,yr1=0;
	int mon=0,qtr=0,prevYear=0;
	month=now.getMonth();
	//out.println("month=="+month);
	if(month>=3)
	{

	yr=now.getYear()+1900;
	yr1=now.getYear()+1901;

	}
	else
	{

	yr=now.getYear()+1899;
	yr1=now.getYear()+1900;

	}
	SimpleDateFormat simpleDateformat = new SimpleDateFormat("MM"); // two digit numerical represenation
	
	mon=Integer.parseInt(simpleDateformat.format(now));
	//out.println("mon=="+mon);
	if(mon==1)

		mon=10;
	else if(mon==2)
		mon=11;
	else if(mon==3)
		mon=12;
	else
		mon=mon-3;
	qtr=mon/3;
	
	String display_header = "List Of Vendor Statement Confirmed List: <br>Financial Year "+yr+"--"+yr1;
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
						<td align="center" width="20%"><B>Q<%=quarter%></B></td>
						<td align="center" width="20%"><%=year%></td>
						<td align="center" width="20%">
						<a href="javascript:funPopup('<%=comments%>')">Click</a>
						<input type="hidden" name="genText" value="<%=comments%>">
						</td>
						
						
						
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