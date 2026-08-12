<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
	ezc.ezcommon.EzLog4j.log("::::::::::"+Session.getUserId(),"I");
	out.print(pageContext.getAttribute("AUCTION"+request.getParameter("auctionId"),PageContext.APPLICATION_SCOPE));
%> 