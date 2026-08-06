<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />

<%
	String tCode 	= (String)session.getValue("TEMPLATE");
	String userGroup= (String)session.getValue("USERGROUP");
	String userRole = (String)session.getValue("USERROLE");
	String sysKey 	= (String)session.getValue("SYSKEY");
	String  wfRole  = (String)session.getValue("ROLE");
	String userId	= (String)Session.getUserId();
	int stepCount 	= 0;
	ezc.ezparam.ReturnObjFromRetrieve retRoles = getWFHierarchy(Session,sysKey,tCode);
	if(retRoles != null)
	{
		stepCount = retRoles.getRowCount();
	}
%>	
