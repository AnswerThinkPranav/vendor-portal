<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iUserLoginDetails.jsp" %>
<html>
<head>
<title>Self Audit Feature</Title>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	var tabHeadWidth=90
	var tabHeight="70%"
	function closeWindow()
	{
		window.close();
	}
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()">
<form name=myForm>
<%
	String display_header = "Self Audit Feature";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

<Div align=center style='position:absolute;top:5%;margin-left: auto;margin-right: auto;margin-top: 5em;padding: 15px;border: 1px solid #cccccc;width: 60%;left:20%;background: #F1F3F5;height:40%'>
	<Table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=3 cellSpacing=0  width="80%">
	<Tr>
		<Th width=60% align="left"><B>No. of Successful Logins</B></Td><Td width=40%><%=succesfullLogins%></Th>
	</Tr>		
	<Tr>
		<Th width=60% align="left"><B>No. of unsuccessful Logins</B></Td><Td width=40%><%=unSuccesfullLogins%></Th>
	</Tr>	

	<Tr>
		<Th width=60% align="left"><B>Last Login</B></Td><Td width=40%><%=lastLoginDate%></Th>
	</Tr>
	<Tr>
		<Th width=60% align="left"><B>Parallel Logins</B></Td><Td width=40%><%=parallelLogins%></Th>
	</Tr>
	</Table>
<Br><Br><Br>
<%
	if("Y".equals(fromMenu))
	{
            buttonName.add("Back");  
            buttonMethod.add("history.go(-1)");
           // out.println(getButtonStr(buttonName,buttonMethod));
	}
	else
	{

            buttonName.add("Close");  
            buttonMethod.add("window.close()");
	}
              out.println(getButtonStr(buttonName,buttonMethod));

%>
</Div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>
