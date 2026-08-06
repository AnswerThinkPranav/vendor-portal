<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />

<%
    String userId = request.getParameter("userId");
    String priceCond = request.getParameter("priceCond");
    String price = request.getParameter("price");
    String step = request.getParameter("step");
    String plant = request.getParameter("plant");
    String category = request.getParameter("category");

    ezc.ezparam.ReturnObjFromRetrieve retObj = null;

    EzcParams mainParams = new EzcParams(false);
    EziMiscParams miscParams = new EziMiscParams();

    String userListQuery = "UPDATE EZC_";

    miscParams.setQuery(userListQuery);
    mainParams.setObject(miscParams);
    mainParams.setLocalStore("Y");
    Session.prepareParams(mainParams);

    ReturnObjFromRetrieve roleUserList = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(mainParams);

    if (roleUserList != null && roleUserList.getRowCount() > 0) {
        StringBuilder userString = new StringBuilder();
        for (int i = 0; i < roleUserList.getRowCount(); i++) {
            String uid = roleUserList.getFieldValueString(i, "EU_ID");
            String name = roleUserList.getFieldValueString(i, "EU_FIRST_NAME");
            userString.append(uid).append(" [").append(name).append("]");
            if (i < roleUserList.getRowCount() - 1) {
                userString.append("|");
            }
        }
        out.print(userString.toString());
    } else {
        out.print("ERROR");
    }
%>