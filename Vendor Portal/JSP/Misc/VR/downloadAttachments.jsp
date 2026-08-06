<%@ page language="java"
    import="java.io.*,java.sql.*,javax.naming.*,javax.sql.*"
%>
<%
    // Get parameters
    String docId   = request.getParameter("docId");
    String docType = request.getParameter("docType");

    // Validation - return error HTML if parameters missing
    if (docId == null || docId.trim().isEmpty() || docType == null || docType.trim().isEmpty()) {
        response.setContentType("text/html");
%>
<!DOCTYPE html>
<html>
<head><title>Download Error</title></head>
<body>
    <h3>Invalid download request</h3>
    <p>Missing required parameters:</p>
    <ul>
        <li>docId: <%= docId %></li>
        <li>docType: <%= docType %></li>
    </ul>
    <p><a href="javascript:history.back()">Go Back</a></p>
</body>
</html>
<%
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    InputStream in = null;
    OutputStream outStream = null;

    try {
        // Get database connection
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/EzDB");
        con = ds.getConnection();

        // Query for file information
        String sql = "SELECT EUD_FILE_NAME, EUD_SERVER_FILE_NAME " +
                     "FROM EZC_UPLOAD_DOCUMENT " +
                     "WHERE EUD_DOC_NO = ? AND EUD_DOC_TYPE = ?";

        ps = con.prepareStatement(sql);
        ps.setString(1, docId);
        ps.setString(2, docType);
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.setContentType("text/html");
%>
<!DOCTYPE html>
<html>
<head><title>File Not Found</title></head>
<body>
    <h3>File not found in database</h3>
    <p>No record found for:</p>
    <ul>
        <li>docId: <%= docId %></li>
        <li>docType: <%= docType %></li>
    </ul>
    <p><a href="javascript:history.back()">Go Back</a></p>
</body>
</html>
<%
            return;
        }

        String originalFileName = rs.getString("EUD_FILE_NAME");
        String serverFilePath   = rs.getString("EUD_SERVER_FILE_NAME");

        File file = new File(serverFilePath);

        if (!file.exists()) {
            response.setContentType("text/html");
%>
<!DOCTYPE html>
<html>
<head><title>File Missing</title></head>
<body>
    <h3>File missing on server</h3>
    <p>File path: <%= serverFilePath %></p>
    <p>The file exists in database but not on disk.</p>
    <p><a href="javascript:history.back()">Go Back</a></p>
</body>
</html>
<%
            return;
        }

        // Clear the output buffer and set download headers
        out.clear();
        out = pageContext.pushBody();

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + originalFileName + "\"");
        response.setContentLengthLong(file.length());

        // Stream the file
        in = new BufferedInputStream(new FileInputStream(file));
        outStream = response.getOutputStream();

        byte[] buffer = new byte[8192];
        int bytesRead;

        while ((bytesRead = in.read(buffer)) != -1) {
            outStream.write(buffer, 0, bytesRead);
        }

        outStream.flush();

    } catch (Exception e) {
        response.setContentType("text/html");
%>
<!DOCTYPE html>
<html>
<head><title>Download Error</title></head>
<body>
    <h3>Error downloading file</h3>
    <p>Error: <%= e.getMessage() %></p>
    <pre><% e.printStackTrace(new PrintWriter(out)); %></pre>
    <p><a href="javascript:history.back()">Go Back</a></p>
</body>
</html>
<%
    } finally {

        try { if (in != null) in.close(); } catch(Exception e){}
        try { if (outStream != null) outStream.close(); } catch(Exception e){}
        try { if (rs != null) rs.close(); } catch(Exception e){}
        try { if (ps != null) ps.close(); } catch(Exception e){}
        try { if (con != null) con.close(); } catch(Exception e){}
    }
%>

