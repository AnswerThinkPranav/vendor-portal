<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%
	String auditNumber 	= request.getParameter("auditNumber");
	String auditVendor 	= request.getParameter("auditVendor");
	String selAction 	= request.getParameter("selAction");
	String dueDate 		= request.getParameter("dueDate");
%>
<Html>
<Head>
<Script>
function funUpdate()
{	
<%
	if("EXTEND".equals(selAction))
	{
%>	
		if(document.myForm.extensionDate.value=='')
		{
			alert('Please  Enter the Date');
			return;
		}
<%
	}
	else if("CLOSE".equals(selAction))
	{
%>
		if(document.myForm.closingRemarks.value=='')
		{
			alert('Please  Enter  Comments/Remarks');
			document.myForm.closingRemarks.focus();
			return;
		}
<%
	}
%>
	document.myForm.action = "ezUpdateAuditStatus.jsp";
	document.myForm.submit();
		
}
</Script>
</Head>
<Body  onLoad="scrollInit();" onResize="scrollInit()" scroll="no" >
<Form name='myForm' method="POST">
<input type=hidden name='listSelVendor' value='<%=request.getParameter("listSelVendor")%>'>
<input type=hidden name='FromDate' 	value='<%=request.getParameter("FromDate")%>'>
<input type=hidden name='ToDate' 	value='<%=request.getParameter("ToDate")%>'>
<input type=hidden name='selAction' 	value='<%=request.getParameter("selAction")%>'>
<input type=hidden name='auditNumber' 	value='<%=request.getParameter("auditNumber")%>'>
<input type=hidden name='auditVendor' 	value='<%=request.getParameter("auditVendor")%>'>

 
<%
		String purGrpTemp  = "";	
		String purGrpDesc  = "";
		String display_header	= "";
	
%>
		<%@ include file="../Misc/ezDisplayHeader.jsp" %>

		<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="50%">
<%
	if("EXTEND".equals(selAction))
	{
%>		
		<Tr>
		<th align=left width=40%>Due Date</td>
			<td>
				<input type="text" class=InputBox  value="<%=dueDate%>" id="extensionDate"  name="extensionDate"  size=12 readonly>
				<%=getDateImage("extensionDate")%>
			</td>
		</Tr>	
<%
	}
	else if("CLOSE".equals(selAction))
	{
%>			
		<Tr>
			<Th   width='40%' align=left>Remarks</Th>
			<td><textarea name='closingRemarks' rows='4' cols='50' align='center' ></Textarea></td>
		</Tr>
<%
	}
%>
		</Table>
		<br>
			
			
<Div id="ButtonDiv" style="position:absolute;top:70%;width:80%;visibility:visible">	
<Center>
<%	
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Update");
	buttonMethod.add("funUpdate()");
	
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Center>
</Div>	

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>