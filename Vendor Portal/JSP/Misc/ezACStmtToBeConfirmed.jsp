<%@ include file="../Misc/ezJQueryScript.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iACStmtConfirmation.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ page import ="java.text.*"%>
<%@ page import ="java.util.*"%>
	
<Html>  
<Head>

</Head>
<Body>
<Form name='myForm'>
<input type='hidden' name='vendorID' >
<%	 
	Date now = new Date();
	int month=0,yr=0,yr1=0;
	int mon=0,qtr=0,prevYear=0;
	month=now.getMonth();
	
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
	  
	String display_header = "To Be  Confirmed for "+quarter;
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<Div style="position:absolute;top:10%;width:100%;left:0%;overflow:auto;height:80%">
	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Thead>
	<Tr>
			<th align="center" width="10%">Quarter</th>
			<th align="center" width="10%">Vendor</th> 	
	</Tr>
	</Thead>
	<TBody>		        

<%	
	String vendorCode = "",vendName="";
	for(int i=0;i<vendorsRetObjCnt;i++)    
	 {
		vendorCode	= vendorsRetObj.getFieldValueString(i,"EC_ERP_CUST_NO");   
		vendName	= vendorsRetObj.getFieldValueString(i,"ECA_NAME");   

		if(confirmedVend.contains(vendorCode.trim()))
			continue;
%>
		<Tr>
			<td align="center" width="10%"><%=quarter%>&nbsp;</td>
			<td align="left" width="10%">&nbsp;&nbsp;<%=vendName +" ["+vendorCode+"]"%>&nbsp;</td>
		</Tr>
		
<%
	}
%>

</Tbody>
</Table>
</Div>
<%@ include file="ezBackButton.jsp" %>
</Form>
<Div id="MenuSol"></Div> 
</Body>
</Html>
