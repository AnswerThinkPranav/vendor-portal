<%@ page language="java" import="org.json.*,ezc.ezparam.*,ezc.misctransactions.client.*,ezc.misctransactions.params.*" %>
<%@ page isErrorPage="true" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="miscMgr" class="ezc.misctransactions.client.EzMiscTransactionsManager" scope="session" />

<%
response.setContentType("application/json;charset=UTF-8");
String docId = request.getParameter("docId");
JSONObject resp = new JSONObject();
JSONObject data = new JSONObject();

if (docId == null || docId.trim().isEmpty()) {
    resp.put("status", "error");
    resp.put("message", "Doc ID required");
    out.print(resp.toString());
    return;
}

docId = docId.trim();

try {
    EzMiscTable t = new EzMiscTable();
    EzMiscTableRow r = new EzMiscTableRow();

    String sql = "SELECT ECFD_FIELD, ECFD_VALUE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID = '" + docId + "'";
    r.setQuery(sql);
    t.appendRow(r);

    EzcParams p = new EzcParams(false);
    p.setLocalStore("Y");
    p.setObject(t);
    Session.prepareParams(p);

    ReturnObjFromRetrieve ret = (ReturnObjFromRetrieve) miscMgr.ezGetMiscTransactions(p);

    int rows = (ret != null) ? ret.getRowCount() : 0;
    if (rows > 0) {
        for (int i = 0; i < rows; i++) {
            String field = ret.getFieldValueString(i, "ECFD_FIELD");
            String value = ret.getFieldValueString(i, "ECFD_VALUE");
            if (field == null) continue;
            if (value == null) value = "";
            data.put(field.trim(), value);
        }
        resp.put("status", "success");
        resp.put("data", data);
        resp.put("rowCount", rows);
    } else {
        resp.put("status", "no_data");
        resp.put("data", new JSONObject());
    }
} catch (Exception e) {
    e.printStackTrace();
    JSONObject err = new JSONObject();
    err.put("status","error");
    err.put("message", e.toString());
    java.io.StringWriter sw = new java.io.StringWriter();
    e.printStackTrace(new java.io.PrintWriter(sw));
    err.put("stack", sw.toString());
    out.print(err.toString());
    return;
}

out.print(resp.toString());
%>
