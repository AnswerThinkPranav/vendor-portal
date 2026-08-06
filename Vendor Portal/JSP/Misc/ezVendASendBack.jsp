<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*" %>
<%@ page import="java.util.*"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>

<%
	String docId = request.getParameter("docId");
	ezc.ezcommon.EzLog4j.log(":::ezVendASendBack.jsp:::docId:::::"+docId,"D");
 	ezc.ezcommon.EzLog4j.log(":::ezVendASendBack.jsp:::Send back:::::","D");

	java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
	queriesList.add("UPDATE EZC_USERS SET EU_PASSWORD='h?q}B)j)6~p@K@y;',EU_DELETION_FLAG='N' WHERE EU_ID='"+docId.toUpperCase()+"'");										
	queriesList.add("UPDATE EZC_CUSTOMER_FORM_HEADER SET ECFH_STATUS='',ECFH_MODIFIED_BY='"+Session.getUserId()+"',ECFH_MODIFIED_ON=now()  WHERE ECFH_DOC_ID='"+docId+"'");
	queriesList.add("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='SENDBACK',EWDHH_CURRENT_STEP='1',EWDHH_NEXT_PARTICIPANT='BY' WHERE EWDHH_DOC_ID='"+docId+"' and EWDHH_AUTH_KEY='VNR'");
	ezMiscInsert(Session,queriesList);
	
%>