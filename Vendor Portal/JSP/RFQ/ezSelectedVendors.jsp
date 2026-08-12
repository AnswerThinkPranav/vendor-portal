<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />

<%
	String values[]=request.getParameterValues("chk1");
	
	int Count=0;
	
	if(values!=null)
		Count=values.length;
%>
<html>
<head>
<Script>
	var tabHeadWidth=75
	var tabHeight="35%"
</Script>
<script>

</script>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body topmargin=0 rightmargin=0 leftmargin=0  scroll=no >
<form name="myForm" method="post">
<%
	String display_header = "Selected Vendors List";
%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
if(Count>0)
{
%>
	<br>
	<Div id="theads" >
	<Table id="tabHead" width="75%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
		<th align="center" width="25%">Vendor</th>
		<th align="center" width="75%">Name</th>
		</tr>
	</Table>
	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:75%;height:60%;left:12%">
	<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<%
	for(int i=0;i<Count;i++)
	{
		String splitValues[] = values[i].split("#");
		String vendorNo=splitValues[0].trim();
		String vendorName=splitValues[1].trim();
%>
		<tr>
			<td align="left" width="25%"><%=vendorNo%>&nbsp;</td>
        		<td align="left" width="75%"><%=vendorName%>&nbsp;</td>
		</tr>
		
<%
	}
%>	
	</table>
	</div>
	<div id="buttons" style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
<%		
		
   		buttonName = new java.util.ArrayList();
    		buttonMethod = new java.util.ArrayList();
    		
		buttonName.add("Close");
		buttonMethod.add("window.close()");
		out.println(getButtonStr(buttonName,buttonMethod));	

    
%> 		
	</div>
<%		
} 

else
{
%>	
	<br><br><br><br><br><br><br>
	<Table width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th>No Selected Vendors exist</th>
		</Tr>
	</Table>
	<div id="buttons" style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
    
%>
	</div>	
		
<%
}
%>	
</form>
<Div id="MenuSol"></Div>
</body>
</html>	