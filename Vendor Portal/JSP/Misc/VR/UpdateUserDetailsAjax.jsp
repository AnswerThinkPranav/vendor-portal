<%@ page language="java" import="org.json.*,ezc.ezparam.*,ezc.misctransactions.client.*,ezc.misctransactions.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="miscMgr" class="ezc.misctransactions.client.EzMiscTransactionsManager" scope="session"/>

<%
response.setContentType("application/json;charset=UTF-8");

String docId = request.getParameter("docId");
String field = request.getParameter("field");
String value = request.getParameter("value");

JSONObject resp = new JSONObject();

// ¦¦¦¦¦ ERROR VALIDATION
if (docId == null || docId.trim().isEmpty() ||
    field == null || field.trim().isEmpty()) {

    resp.put("status","error");
    resp.put("message","Missing docId or field");
    out.print(resp.toString());
    return;
}

docId = docId.trim();
field = field.trim();

try {

    // ¦¦¦¦¦ UPDATE TEXT FIELDS ONLY — NO FILE LOGIC HERE
    String escField = field.replace("'", "''");
    String escValue = (value != null) ? value.replace("'", "''") : "";

    // Check if record exists
    String chkSQL =
        "SELECT COUNT(*) AS CNT FROM EZC_CUSTOMER_FORM_DETAILS " +
        "WHERE ECFD_DOC_ID='" + docId + "' AND ECFD_FIELD='" + escField + "'";

    EzMiscTable t = new EzMiscTable();
    EzMiscTableRow r = new EzMiscTableRow();
    r.setQuery(chkSQL);
    t.appendRow(r);

    EzcParams p = new EzcParams(false);
    p.setLocalStore("N");     // IMPORTANT: read from DB, not local store
    p.setObject(t);
    Session.prepareParams(p);

    ReturnObjFromRetrieve ret =
        (ReturnObjFromRetrieve) miscMgr.ezGetMiscTransactions(p);

    int cnt = 0;
    if (ret != null && ret.getRowCount() > 0) {
        try { cnt = Integer.parseInt(ret.getFieldValueString(0,"CNT")); }
        catch(Exception e) { cnt = 0; }
    }

    String sql;

    if (cnt > 0) {
        sql = "UPDATE EZC_CUSTOMER_FORM_DETAILS SET ECFD_VALUE='" + escValue + "' " +
              "WHERE ECFD_DOC_ID='" + docId + "' AND ECFD_FIELD='" + escField + "'";
    } else {
        sql = "INSERT INTO EZC_CUSTOMER_FORM_DETAILS (ECFD_DOC_ID, ECFD_FIELD, ECFD_VALUE) " +
              "VALUES ('" + docId + "', '" + escField + "', '" + escValue + "')";
    }

    EzMiscTable t2 = new EzMiscTable();
    EzMiscTableRow r2 = new EzMiscTableRow();
    r2.setQuery(sql);
    t2.appendRow(r2);

    EzcParams up = new EzcParams(false);
    up.setLocalStore("N");
    up.setObject(t2);
    Session.prepareParams(up);

    miscMgr.ezSaveMiscTransactions(up);

    resp.put("status", "success");
    resp.put("message", "Field updated");

} catch (Exception e) {

    e.printStackTrace();
    resp.put("status", "error");
    resp.put("message", e.toString());
}

out.print(resp.toString());
%>
