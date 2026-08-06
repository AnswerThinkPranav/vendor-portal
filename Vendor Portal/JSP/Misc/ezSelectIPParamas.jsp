<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %>
<%@ page import ="java.util.*" %>
<%@ page import ="java.util.Calendar.*" %>
<%@ page import ="java.text.*" %>
<Html>
<%
String flag=request.getParameter("Flag");
int mon=0,year=0,qtr=0,prevYear=0;
	Date now = new Date();

SimpleDateFormat simpleDateformat = new SimpleDateFormat("MM"); // two digit numerical represenation

	mon=Integer.parseInt(simpleDateformat.format(now));
	if(mon==1)
		mon=10;
	else if(mon==2)
		mon=11;
	else if(mon==3)
		mon=12;
	else
		mon=mon-3;
	qtr=mon/3;
	//out.println("qtr=="+qtr);	
	
%>
<Head>
<Script>
function funGO()
{
	var flag='<%=flag%>';
	var url;
	
	if(document.myForm.quarter.value=='')
	{
		alert('Please Select Quarter');
		document.myForm.quarter.focus();
		return;
	}
	if(flag=='C')
	{
		url="ezACStmtConfirmed.jsp";
	}
	else
	{
		url="ezACStmtToBeConfirmed.jsp";
	}
	document.myForm.action = url;
	document.myForm.submit();
}		
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "A/C Statement Confirmation";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<Br><br>
	
<Table width=40% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0>

		<TR>
		<Th  align="left" width="10%" height=30>Financial Year </Th>
		<Td height=30>
			<select name='financialYear' style="width:100%" >
				<option value="2013FYR2014">2013--2014</option>
			</Select>
		</Td>
		</TR>

		<TR> 
		<Th  align="left" width="30%" height=30>Quarter</Th>
		<Td height=30>
		<Select name='quarter' style="width:100%" >
			<option value="">-Select Quarter--- </option>
			<option value="Q1DLM01/04DLM30/06">Q1</option>
			<option value="Q2DLM01/07DLM30/09">Q2</option>
			<option value="Q3DLM01/10DLM31/12">Q3</option>
			<option value="Q4DLM01/01DLM31/03">Q4</option>
		</Select>
		</Td>
		</TR>
	</Table>
<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("GO");
	buttonMethod.add("funGO()");
	out.println(getButtonStr(buttonName,buttonMethod));

%>	

	</Div>	

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>