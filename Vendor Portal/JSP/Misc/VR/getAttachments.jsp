<%@ page language="java" import="org.json.*,ezc.ezparam.*,ezc.misctransactions.client.*,ezc.misctransactions.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="miscMgr" class="ezc.misctransactions.client.EzMiscTransactionsManager" scope="session"/>

<%
response.setContentType("application/json;charset=UTF-8");

String docId = request.getParameter("docId");
String field = request.getParameter("field");   // requested DOC TYPE
JSONObject resp = new JSONObject();
JSONArray arr = new JSONArray();

if (docId == null || docId.trim().isEmpty()) {
    resp.put("status","error");
    resp.put("message","docId missing");
    out.print(resp.toString());
    return;
}

docId = docId.trim().toUpperCase();
if (field != null) field = field.trim().toUpperCase();

try {
    String sql =
        "SELECT EUD_ITEM_NO, EUD_FILE_NAME, EUD_SERVER_FILE_NAME, " +
        "EUD_DOC_TYPE, EUD_UPLOADED_ON " +
        "FROM EZC_UPLOAD_DOCUMENT " +
        "WHERE TRIM(UPPER(EUD_DOC_NO)) = TRIM('" + docId + "') " +
        "AND TRIM(UPPER(EUD_DOC_TYPE)) = TRIM('" + field + "') " +
        "ORDER BY EUD_UPLOADED_ON DESC";

    EzMiscTable t = new EzMiscTable();
    EzMiscTableRow r = new EzMiscTableRow();
    r.setQuery(sql);
    t.appendRow(r);

    EzcParams p = new EzcParams(false);
    p.setLocalStore("Y");
    p.setObject(t);
    Session.prepareParams(p);

    ReturnObjFromRetrieve ret = (ReturnObjFromRetrieve) miscMgr.ezGetMiscTransactions(p);
    int rows = (ret != null) ? ret.getRowCount() : 0;

    for (int i = 0; i < rows; i++) {
        JSONObject o = new JSONObject();
        o.put("itemNo", ret.getFieldValueString(i, "EUD_ITEM_NO"));
        o.put("filename", ret.getFieldValueString(i, "EUD_FILE_NAME"));
        o.put("serverFile", ret.getFieldValueString(i, "EUD_SERVER_FILE_NAME"));
        o.put("docType", ret.getFieldValueString(i, "EUD_DOC_TYPE"));
        o.put("uploadDate", ret.getFieldValueString(i, "EUD_UPLOADED_ON"));
        arr.put(o);
    }

    resp.put("status", "success");
    resp.put("attachments", arr);
    resp.put("rowCount", arr.length());

} catch (Exception e) {
    e.printStackTrace();
    resp.put("status","error");
    resp.put("message", e.getMessage());
}

out.print(resp.toString());
%>
