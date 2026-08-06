<%@ page import ="java.util.*" %>
<%@ page import ="java.util.Calendar.*" %>
<%@ page import ="java.text.*" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetConfirmedQtrs.jsp" %>  
<Html>
<Head>
<Script>
function funGo()
{
	document.myForm.action = "ezGetAccountStmnt.jsp";
	document.myForm.submit();
}
function funViewComm(comments)
{
	var url = "ezViewQtrComments.jsp?comments=" + comments;
	window.open(url,"UserWindow","width=500,height=450, left = 0 top = 0 resizable=no, menubar = no locationbar = no scrollbars=yes");
}
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Account Statement Confirmation : <br>Financial Year "+startYear+"--"+endYear;
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<br>
	<Table width=60% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0>
	<Tr>
<%
		if(compCodeArr != null && compCodeArr.length > 1)
		{
			selCompFlg =true;
%>
			<Tr>
			<Th  align="left" width="15%" height=30>Financial Year</Th>
			<Td  align="left" width="20%" height=30>
				<select name="selFinancialYear" style='width:60%'>
<%
				//String selectedFlg = "";
				//if(selCompCode==null || "null".equals(selCompCode) || "".equals(selCompCode) )
					//selCompCode = compCodeArr[0]; 
%>
					<option value="2011FYR2012">2011-2012</option>
					<option value="2012FYR2013">2012-2013</option>
					<option value="2013FYR2014">2013-2014</option>
				</select>			
			</Td>
			<Th  align="left" width="15%" height=30>Company Code</Th>
			<Td  align="left" width="30%" height=30>
				<select name="selCompCode" style='width:60%'>
<%
				String selectedFlg = "";
				if(selCompCode==null || "null".equals(selCompCode) || "".equals(selCompCode) )
					selCompCode = compCodeArr[0]; 
				for(int k=0;k<compCodeArr.length;k++)
				{
					if(compCodeArr[k].equals(selCompCode)) 
						selectedFlg="selected";
%>
						<option value="<%=compCodeArr[k]%>" <%=selectedFlg%> ><%=compCodeDesc.get(compCodeArr[k])%></option>
<%
					selectedFlg="";
				}
%>
				</select>			
			</Td>
			<Td  height=30 width="20%" align=center>
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Go");
			buttonMethod.add("funGo()");
			out.println(getButtonStr(buttonName,buttonMethod));
%>			
			
			</Td>
			</Tr>
<%
	}
	else
	{
%>
		<input type="hidden" name="selCompCode" value="<%=selCompCode%>">
<%
	}
%>
	</Tr>
	</Table>
	<Br><Br><Br>
	<Table width=85% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0>


	

	<Tr>
	                <Th  align="center" height=30 width=10%>Quarter</Th>
	                <Th  align="center" height=30 width=15%>Period</Th>
	                <Th  align="center" height=30 width=15%>Status</Th>
	                <Th  align="center" height=30 width=60%>Vendor Comments/Remarks</Th>
	</Tr> 
	<Tr>
	                
	                
<%
	for(int i=1;i<=noOfQuarters;i++)
	{
			String comments=(String)qtrComments.get(new Integer(i));
			String startDateStr = "";
			String endDateStr = "";
			
			if(comments==null || "null".equals(comments))
				comments = "&nbsp;";
			
			
			startDateStr = (String)startDateHT.get("Q"+i);
			endDateStr = (String)endDateHT.get("Q"+i);
%>
			<Tr>	
				<Td align="center" height=30><b>Q<%=i%></b></Td>
				<TD align="center" height=30><B><%=monIntHt.get(i+"")%></B>&nbsp;&nbsp;&nbsp;&nbsp;</Td>
				<Td align="center" height=30>
<%
			if(confimedQtrs.contains(new Integer(i)))
			{
%>
				<B>Confirmed<B>
<%
			}else{
%>
				<B>Not Yet Confirmed<B> <Br> <a href="ezQtrAcstatement.jsp?quater=<%=i%>&noOfQtrs=<%=noOfQuarters%>&selCompCode=<%=selVendCompCode%>&FromDate=<%=startDateStr%>&ToDate=<%=endDateStr%>&finStartYear=<%=startYear%>" ><B>Click to Confirm</B></a>
<%
			}
%>
			</Td>
			<Td align="left" height=30>&nbsp;<%=comments%></Td>
			</Tr>	
<%
	}
%>
		</Table>
<script>
<%
	if(financialYear==null)
		financialYear = startYear+"FYR"+endYear;
%>	

	document.myForm.selFinancialYear.value = '<%=financialYear%>';
</script>
	
	<Div id="MenuSol"></Div>
	</Form>
	</Body>
	</Html>

