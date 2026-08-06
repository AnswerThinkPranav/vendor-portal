 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<%
	String nextParticipant = "";
	String userRole = (String)session.getValue("USERROLE");

	if(userRole!=null)
		userRole = userRole.trim();
	
	if("PP".equals(userRole))
		nextParticipant = "PURHEAD";
	else if("PH".equals(userRole))
		nextParticipant = "VP";	


	String changeStatus = "SUBMITTED";
%>
<%@ include file="ezUpdateVenAddrStatus.jsp"%>	
<%
	String display_header  = "Address Change Request";
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>