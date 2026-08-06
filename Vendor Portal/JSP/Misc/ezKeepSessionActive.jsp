<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
	out.print(":::"+Session.getUserId());
%> 