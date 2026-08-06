<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file = "../../../Includes/Jsps/Labels/iLogout_Labels.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iUpdateWebStats.jsp"%>
<%
	String offline = (String)session.getValue("OFFLINE");
	
	String sname  = request.getServerName();
	//out.println("sname :"+sname);
	String reqUrl = "http://"+sname+"/j2ee/ezLogin.jsp";
	//out.println("reqUrl :"+reqUrl);
	
	try
	{
		Session.logOut(); 
	}
	catch(Exception e)
	{
		System.out.println("Exception while logout"); 
	}
%>
<html>
<head>
<meta http-equiv="refresh" content="2;url='<%=reqUrl%>'">
<title><%=logoutEzcom_L%></title>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
	function winConfirm()
	{
		window.close();
	}
</script>
</head>
<% 
	try{
		session.invalidate();
	}catch(Exception e){}	
	
%>


<body onload="winConfirm()">

<br>
<br>
<table width="75%" border="0" align="center">
    <tr align="center">
    	<td class="blankcell"><font size="4"><%=uSuccessOut_L%> ................</font>
    	<br><br>
      	<font size="2"><%=urBrowserNo_L%>
       	<b><a href='<%=reqUrl%>' ><%=here_L%></a></b>
      	<%=goLogin_L%></font> </td>
    </tr>
</table>
<Div id="MenuSol">
</Div>	
</body>
</html>