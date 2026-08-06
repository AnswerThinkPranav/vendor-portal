<%--*************************************************************************************

       /* Copyright Notice ===================================================
	* This file contains proprietary information of The Hackett Group Ind Ltd.
	* Copying or reproduction without prior written approval is prohibited.
	* Copyright (c) 2005-2006 =====================================*/
		Author: smaddipati
		Team:   EzcSuite
		Date:   05/12/2005
*****************************************************************************************--%>

<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Lib/InboxBean.jsp"%>


<HTML><HEAD><TITLE>Ranbaxy Partners : Vendors</TITLE>
<META content="text/html; charset=windows-1252" http-equiv=Content-Type>
<META content="MSHTML 5.00.2919.6307" name=GENERATOR>
<SCript>
	function funcheck()
	{
		var check = window.open("ezCloseLogout.jsp","")
		check.close();
	}
</SCript>	
</HEAD>
<frameset rows="66,25,*,23" cols="*" border="0" framespacing="0"  marginheight=0 margintop=0 >
<frame src="ezLoginBanner.jsp" scrolling="NO" name="banner" frameborder="NO" marginwidth="0"  marginheight=0 margintop=0>
<%
  	String userType=(String)session.getValue("UserType");
  	if("3".equals(userType))
  	{
%>
  		<frame src="ezVendorMenu.jsp" scrolling="no" name="menu" frameborder="NO" marginwidth="0"  marginheight=0 margintop=0 noresize>
<%	
	}
  	else
  	{
%>
  		<frame src="ezVendorEnterpriseMenu.jsp" scrolling="no" name="menu" frameborder="NO" marginwidth="0"  marginheight=0 margintop=0 noresize>
<%
  	}
%>
<frame src="ezSBUWelcomeWait.jsp" scrolling="no" name="display" frameborder="NO" marginwidth="0"  marginheight=0 margintop=0>
<frame src="ezFooter.jsp" name="footer" marginwidth="0"  marginheight=0 margintop=0 scrolling="NO" frameborder="NO" noresize>
</frameset>
</HTML>

