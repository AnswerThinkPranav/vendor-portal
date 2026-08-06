<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="ezc.ezparam.*" %>
<%@ page import="ezc.misctransactions.params.*" %>
<%@ page import="ezc.misctransactions.client.*" %>

<%@ page contentType="application/json;charset=UTF-8" %>

<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../../../EzVendor/Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>

<%
    JSONObject resp = new JSONObject();

    try {

        if (!ServletFileUpload.isMultipartContent(request)) {
            resp.put("status","error");
            resp.put("message","Invalid multipart request");
            out.print(resp.toString());
            return;
        }

        String docId = "";
        String docType = "";
        String fileName = "";
        String reuseItemNo = "";
        FileItem filePart = null;

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        List<FileItem> items = upload.parseRequest(request);
        ezc.ezcommon.EzLog4j.log("In upload Attachments>>>>>>>>>>>>>>>>","I"); 

        // ---------- READ FORM FIELDS ----------
        for (FileItem item : items) {

            if (item.isFormField()) {

                String fieldName = item.getFieldName();

                if ("docId".equals(fieldName)) {
                    docId = item.getString().trim().toUpperCase();
                }
                else if ("docType".equals(fieldName)) {
                    docType = item.getString().trim().toUpperCase();
                }
                else if ("reuseItemNo".equals(fieldName)) {
                    reuseItemNo = item.getString().trim();
                }

            } else {

                fileName = new File(item.getName()).getName();
                filePart = item;
            }
        }

        if (docId.equals("") || docType.equals("") || fileName.equals("")) {
            resp.put("status","error");
            resp.put("message","Missing parameters");
            out.print(resp.toString());
            return;
        }

        // ---------- DETERMINE ITEM NO ----------
        String itemNo = "";

        if (reuseItemNo != null && reuseItemNo.length() > 0) {

            itemNo = reuseItemNo;

        } else {

            EzMiscTable seqTable = new EzMiscTable();
            EzMiscTableRow seqRow = new EzMiscTableRow();

            seqRow.setQuery(
                "SELECT NVL(MAX(EUD_ITEM_NO), 0) + 1 AS NEXT_NO " +
                "FROM EZC_UPLOAD_DOCUMENT " +
                "WHERE EUD_DOC_NO='" + docId + "' AND EUD_DOC_TYPE='" + docType + "'"
            );

            seqTable.appendRow(seqRow);

            EzcParams seqParams = new EzcParams(false);
            seqParams.setLocalStore("Y");
            seqParams.setObject(seqTable);
            Session.prepareParams(seqParams);

            ReturnObjFromRetrieve seqRet =
                (ReturnObjFromRetrieve) new EzMiscTransactionsManager().ezGetMiscTransactions(seqParams);

            itemNo = seqRet.getFieldValueString(0,"NEXT_NO");
        }

        // ---------- SAVE FILE TO CORRECT PATH ----------
        String folderPath = serverUpPath + "/" + docType + "/" + docId + "/" + itemNo;
        ezc.ezcommon.EzLog4j.log("folderPath>>>>>>>>>>>>>>>>"+folderPath,"I"); 

        File folder = new File(folderPath);
        if (!folder.exists()) folder.mkdirs();

        File savedFile = new File(folder, fileName);
        filePart.write(savedFile);

        // ---------- INSERT DB RECORD ----------
        String serverPath =  docType + "/" + docId + "/" + itemNo + "/" + fileName;
        

        EzMiscTable insTable = new EzMiscTable();
        EzMiscTableRow insRow = new EzMiscTableRow();

        insRow.setQuery(
            "INSERT INTO EZC_UPLOAD_DOCUMENT " +
            "(EUD_DOC_NO, EUD_ITEM_NO, EUD_DOC_TYPE, EUD_FILE_NAME, EUD_SERVER_FILE_NAME, " +
            "EUD_EXT1, EUD_EXT2, EUD_EXT3, EUD_EXT4, EUD_EXT5, EUD_UPLOADED_ON, EUD_UPLOADED_BY) " +
            "VALUES ('" + docId + "', '" + itemNo + "', '" + docType + "', '" + fileName + "', '" +
            serverPath + "', NULL, NULL, NULL, NULL, NULL, CURDATE(), '" + Session.getUserId() + "')"
        );

        insTable.appendRow(insRow);

        EzcParams insParams = new EzcParams(false);
        insParams.setLocalStore("Y");
        insParams.setObject(insTable);
        Session.prepareParams(insParams);

        new EzMiscTransactionsManager().ezSaveMiscTransactions(insParams);

        // ---------- RESPONSE ----------
        resp.put("status","success");
        resp.put("file", fileName);
        resp.put("itemNo", itemNo);

    } catch(Exception e) {
        resp.put("status","error");
        resp.put("message", e.toString());
        e.printStackTrace();
    }

    out.print(resp.toString());
%>
