<%@ page import="java.util.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%@ page import = "ezc.ezutil.FormatDate,ezc.ezparam.*"%>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
	String docNo = request.getParameter("docNo");
	String documentName = request.getParameter("n1");
	
	String currSysKey = "999111";
	String documentNo = docNo;
	String uploadKey  = "CAPA";
	String fileName   = documentName;
%>
<%@ include file="../Misc/ezSaveUploadDocs.jsp"%>
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	= "CAPA Document is Uploaded by :"+(String)session.getValue("Vendor");
	String msgText 		=  "Dear Sir,<Br><Br>CAPA Document is Uploaded for the Rejected Document : "+docNo;
	String toEMailIds 	= (String)eMailIdHT.get("QA");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";


	ezc.ezcommon.EzLog4j.log("CAPA DOCUMENT UPLOAD -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");

%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	response.sendRedirect("ezMessage.jsp?Msg=Document Saved Successfully.");
%>