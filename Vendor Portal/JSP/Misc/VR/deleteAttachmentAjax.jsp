<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>

<%@ page import="java.io.*" %>
<%@ page import="ezc.misctransactions.client.EzMiscTransactionsManager" %>
<%@ page import="ezc.misctransactions.params.EzMiscTable" %>
<%@ page import="ezc.misctransactions.params.EzMiscTableRow" %>

<%
    boolean successFlg = true;

    String upDocId = request.getParameter("upDocId");
    String upDocType = request.getParameter("upDocType");
    String upItemNo = request.getParameter("upItemNo");
    String fileName = request.getParameter("fileName");

    String pathName = "200/" + upDocType + "/" + upDocId + "/" + upItemNo + "/" + fileName;
    String fileReqName = uploadFilePathDir + "/" + pathName;


    try {
        File f = new File(fileReqName);
        if (f.exists()) {
            f.delete();
        }
    } catch (Exception e) {
        successFlg = false;
    }

    if (successFlg) {
        EzcParams mainParams = new EzcParams(false);
        EzMiscTransactionsManager miscMgr = new EzMiscTransactionsManager();
        EzMiscTable miscTable = new EzMiscTable();
        EzMiscTableRow miscTableRow = new EzMiscTableRow();

        miscTableRow.setQuery(
            "DELETE FROM EZC_UPLOAD_DOCUMENT WHERE " +
            "EUD_DOC_NO='" + upDocId + "' AND " +
            "EUD_ITEM_NO='" + upItemNo + "' AND " +
            "EUD_DOC_TYPE='" + upDocType + "' AND " +
            "EUD_FILE_NAME='" + fileName + "'"
        );

        miscTable.appendRow(miscTableRow);

        mainParams.setLocalStore("Y");
        mainParams.setObject(miscTable);
        Session.prepareParams(mainParams);

        try { miscMgr.ezSaveMiscTransactions(mainParams); } catch(Exception e){}
    }

    out.print(successFlg ? "true" : "false");
%>
