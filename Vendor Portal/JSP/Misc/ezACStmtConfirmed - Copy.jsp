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
 <%	
 	tempFinancialYear = "2013-2014";
 	String display_header = "Confirmed for "+tempFinancialYear;
 %>
 	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
 	<Div style="position:absolute;top:10%;width:100%;left:0%;overflow:auto;height:80%">
 	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
 	<Thead>
	<Tr>
		<th align="center" width="15%">Year</th>
		<th align="center" width="10%">Quarter</th>
		<th align="center" width="30%">Vendor</th>
		<th align="center" width="45%">Comments</th>
	</tr> 	
 	<TBody>		        
 
 <%	
 	String vendor	        = "";
	String finQrt	        = "";
	String year  	        = "";
	String comments  	= "";
	for(int i=0;i<confirmedVendRetObjCnt;i++)    
	{
		vendor	= confirmedVendRetObj.getFieldValueString(i,"EVBC_VENDOR");
		finQrt	= confirmedVendRetObj.getFieldValueString(i,"EVBC_CONF_QUARTER");
		year	= confirmedVendRetObj.getFieldValueString(i,"EVBC_CONF_YEAR");
		comments= confirmedVendRetObj.getFieldValueString(i,"EVBC_VEND_COMMENTS");
 %>
 		<Tr>
			<td align="center" width="15%"><%=tempFinancialYear%></td>
			<td align="center" width="10%"><B>Q<%=finQrt%></B></td>
 			<td align="left" width="30%">&nbsp;&nbsp;<%=vendorsHT.get(vendor.trim())+" ["+vendor+"]"%></td>
			<td align="left" width="45%">&nbsp;&nbsp;<%=comments%></td>
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
