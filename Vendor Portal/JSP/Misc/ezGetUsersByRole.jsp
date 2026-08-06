<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />

<%
	String userId = request.getParameter("userId");

	ezc.ezparam.ReturnObjFromRetrieve retObj = null;

	EzcParams mainParams = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	String userListQuery = "SELECT U.EU_ID, U.EU_FIRST_NAME FROM EZC_USERS U, EZC_USER_DEFAULTS D WHERE U.EU_ID = D.EUD_USER_ID AND D.EUD_KEY ='USERROLE' AND D.EUD_VALUE in (select EUD_VALUE from ezc_user_defaults where EUD_USER_ID='" + userId + "' and EUD_KEY='USERROLE')";

	miscParams.setQuery(userListQuery);
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);

	ReturnObjFromRetrieve roleUserList = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(mainParams);

	if (roleUserList != null && roleUserList.getRowCount() > 0){
		StringBuilder userString = new StringBuilder();
		for (int i = 0; i < roleUserList.getRowCount(); i++){
			String uid = roleUserList.getFieldValueString(i, "EU_ID");
			String name = roleUserList.getFieldValueString(i, "EU_FIRST_NAME");
			userString.append(uid).append(" [").append(name).append("]");
			if (i < roleUserList.getRowCount() - 1){
				userString.append("|");
			}
		}
		out.print(userString.toString());
	}else{
		out.print("ERROR");
	}
%>