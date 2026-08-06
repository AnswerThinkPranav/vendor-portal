<%@ page language="java" isErrorPage="true"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezcommon.EzJSPExceptionHandler" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 

<% 
	ezc.ezcommon.EzLog4j.log(":::::::::::ERROR PAGE CALLED::234576:::::::::","I");
%>
<html>
<head>
<script> 
	function logOut()
	{
		top.location.href="../../../Vendor2/JSPs/Misc/ezLogout.jsp" ;
		
	}	
</script> 
<title>EzCommerce ... The Next Generation eBusiness solutions</title>
<%
	String display_header  = "ERROR"; 
%>	

<%@ include file="../Misc/ezSubHeader.jsp"%>       
<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
	
	String errorMessage = "";
	if(session.isNew())
	{
		session.invalidate();
		errorMessage = "It is very long time since you submit your last request.";
	}
	else
	{
		Exception e = (Exception)request.getAttribute("javax.servlet.jsp.jspException");
		EzJSPExceptionHandler exHandler1 = new EzJSPExceptionHandler();
		Object ss1=exHandler1.handleException(e);

		if ( e.getClass() == ezc.ezutil.EzJspException.class )
		{
			ezc.ezparam.ReturnObjFromRetrieve retEx = (ezc.ezparam.ReturnObjFromRetrieve)((ezc.ezutil.EzJspException)e).getReturnObject();
			if(retEx != null)
			{
				String[] errMessages = retEx.getErrorMessages();
				
				int errCount = errMessages.length;
				for (int i=0;i<errCount;i++)
				{
			 		String eMsg = errMessages[i];
					int index=eMsg.indexOf("Ezc");
					if(eMsg.indexOf("No Connection Manager Available ") != -1)
					{
						errorMessage = "Services are temporarily unavailable....Please try after sometime.<BR>Inconvenience is regretted";
					}
					else if(eMsg.indexOf("getInvoiceDetails") != -1)
					{
						errorMessage = "Sorry! Details for this invoice are not available.";
					}
					else if(eMsg.indexOf("Not Authorized") != -1)
					{
						errorMessage = "Sorry! You are not authorized to view this data.";
					}
					else
					{
						errorMessage = "Server is busy.<br>Please try after sometime.";
					}
					break;
				}
			}
		}
		else
		{

			errorMessage = "Server is busy.<br>Please try  again.";
		}			
	}
%>
</head>
<body scroll=no>
	<Br><Br><Br>
	<Table border="0" align="center" valign=middle width="100%" cellpadding=10 cellspacing=10 class=welcomecell>
	<Tr <%=trBGColor%>> 
		<Td style="background-color:'F3F3F3'" valign=middle align=center>
			<font size="4">
				System Error.<BR> Please try again but if the error message reappears then contact us.
			</font>
			<br><br>
				<font size="2">
					Please click <a href="Javascript:logOut()">here</a> to login again.
				</font>	
		</Td>
	</Tr>
	</Table>
			
<Div id="MenuSol"></Div>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>