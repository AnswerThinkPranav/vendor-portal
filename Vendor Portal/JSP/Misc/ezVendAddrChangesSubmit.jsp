 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<%
	String refNum = request.getParameter("refNum");
	String vendor = request.getParameter("vendor");
	String vendorName = request.getParameter("companyName");

	String nextParticipant = "";
	String uRole = (String)session.getValue("USERROLE");

	if(uRole!=null)
		uRole = uRole.trim();
	
	if("PP".equals(uRole))
		nextParticipant = "PURHEAD";
	else if("PH".equals(uRole))
		nextParticipant = "VP";	


	String changeStatus = "SUBMITTED";
%>
<%@ include file="../../../Includes/JSPs/Misc/ezUpdateVenAddrStatus.jsp"%>	
<%
	/*String stmtIdKey = "GET_INT_USER_EMAIL";
	String msgSubject = "Address Change Request is submitted for your approval by "+(String)session.getValue("FIRST_NAME");

	String ccMailIds  = "";
	String msgText = "Dear Sir/Madam, <Br><Br>Vendor Address Change Request is submitted for your approval.<Br> Reference No. : "+refNum+"<Br> Vendor Name : "+vendorName+"<Br>";
	*/
%>
<%//@include file="../Misc/ezSendMail.jsp"%> 	
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	= "Vendor Address Change Request is submitted for your approval";
	String msgText 		= "Dear Sir/Madam, <Br><Br>Vendor Address Change Request is submitted for your approval.<Br> Reference No. : "+refNum+"<Br> Vendor Name : "+vendorName+"<Br>";
	String toEMailIds 	= (String)eMailIdHT.get("PH");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";

	ezc.ezcommon.EzLog4j.log("ADDRESS CHANGE APPROVAL MAILIDS>>>>>>>"+toEMailIds,"I");
%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>	
<%	
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Address Change Request is submitted to Purchase Head.");
%> 
	
	