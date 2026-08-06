<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iPassword_Labels.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iSavePassword.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%
	String display_header = "Change Password";
	String fromMenu = request.getParameter("fromMenu");
	
	String fileName = "";
	
	String frame = "";
	ezc.ezcommon.EzLog4j.log("::flag::"+flag,"I");
	/*if(flag == null || "".equals(flag) || "null".equals(flag))
	{
		fileName = "ezSBUWelcome.jsp";//commented
		frame = "FRAME";
	}	
	else*/	
	//{
		fileName = "ezSelectSoldTo.jsp";
		frame = "TOP";
	//}	
	
%>
		
<html>
<head>
<Script>
function gotoHome(file,frame)
{
	//alert("file:"+file)
	var pwdMatchedFlag = '<%=pwdMatchedFlag%>'
	
	if(pwdMatchedFlag=='Y') 
	{ 
		document.location.href = "ezPassword.jsp?fromMenu=<%=fromMenu%>";
	}
	else
	{
		top.document.location.href=file;
	}
}
</Script>
</head>
<%
	String dispMessage="Your Password Changed Successfully.",dispMsgType="S",divWidth="90%";
%>
<body scroll=no>
	<%@ include file="../Misc/ezSubHeader.jsp"%> 	
	<Br>
	<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
<script>
	gotoHome('<%=fileName%>','<%=frame%>');
</script>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>