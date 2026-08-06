<%@ page import ="ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*"%>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, java.io.OutputStreamWriter" %>
<%@ page import="org.json.JSONObject" %>

<%
    // Variables for SuccessFactors API credentials
    String clientId = "your_client_id";
    String clientSecret = "your_client_secret";
    String tokenUrl = "https://api8.successfactors.com/oauth/token";
    String requestBody = "company_id=C0014469929P&client_id=OTI0YzAxNGNiODU3NDQzNjYxNzc3OTgzYWQxZQ&grant_type=urn:ietf:params:oauth:grant-type:saml2-bearer&user_id=admincp&assertion=PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c2FtbDI6QXNzZXJ0aW9uIHhtbG5zOnNhbWwyPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uIiBJRD0iYTMwZTRiYzAtYjljOC00MjRkLWJkZjQtNzQzMzQzNTA2NTlmIiBJc3N1ZUluc3RhbnQ9IjIwMjMtMDYtMTRUMDk6MjU6MzAuNzc1WiIgVmVyc2lvbj0iMi4wIiB4bWxuczp4cz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEiIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiPjxzYW1sMjpJc3N1ZXI+d3d3LnN1Y2Nlc3NmYWN0b3JzLmNvbTwvc2FtbDI6SXNzdWVyPjxkczpTaWduYXR1cmUgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxkczpTaWduZWRJbmZvPjxkczpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PGRzOlNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48ZHM6UmVmZXJlbmNlIFVSST0iI2EzMGU0YmMwLWI5YzgtNDI0ZC1iZGY0LTc0MzM0MzUwNjU5ZiI+PGRzOlRyYW5zZm9ybXM+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIi8+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyI+PGVjOkluY2x1c2l2ZU5hbWVzcGFjZXMgeG1sbnM6ZWM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIgUHJlZml4TGlzdD0ieHMiLz48L2RzOlRyYW5zZm9ybT48L2RzOlRyYW5zZm9ybXM+PGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+PGRzOkRpZ2VzdFZhbHVlPjZtelJCZE82alljd20xT094OTNZKzJ3OVpLQT08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+YVFNeHBoV04yOU5qbFNmTTFSajhOSGxaOU9DeCtZaXJnbHpmRStsRG9uOTZoMFUxMlRFQlhJeFlUK0c1NW5BUzRxM3FFWDFFUUVkTXg0K0xLNUpORFBmTlRXWXRpK2pCSUoxMERqTEZFMkh0MTkwNVdhTHhSTzRDemNtcEVSMUtiazVDeXgzcmJ4R1I1YUNQZG1kQjlKV0JEMUEyeFg2UW81U0ozNk40djhxNmFtR2R2WWtzUE00cm5mT0krVkUwRXJNVVlQbGJpTXpRYUQ4NmhwUnRlZ283YXFic2NIVDNtdDZwN1RxK0Z1aXpVNVJpRStwcDdCTEpEWG9qcFhZbURNN1R1ZVl2Y0RtM2dvYktTU1lqdTg5dW0zYXB3c085OXp1UUhKbllsaTJMb1ExM1o4T3hHVnpXbzB4cVVTSlppVm5kK0dwOTZNUnU5d0NEVytSaWRnPT08L2RzOlNpZ25hdHVyZVZhbHVlPjwvZHM6U2lnbmF0dXJlPjxzYW1sMjpTdWJqZWN0PjxzYW1sMjpOYW1lSUQgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoxLjE6bmFtZWlkLWZvcm1hdDp1bnNwZWNpZmllZCI+YWRtaW5jcDwvc2FtbDI6TmFtZUlEPjxzYW1sMjpTdWJqZWN0Q29uZmlybWF0aW9uIE1ldGhvZD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmNtOmJlYXJlciI+PHNhbWwyOlN1YmplY3RDb25maXJtYXRpb25EYXRhIE5vdE9uT3JBZnRlcj0iMjIxMy0wOC0wMVQyMDowNTozMC43NzVaIiBSZWNpcGllbnQ9Imh0dHBzOi8vYXBpOC5zdWNjZXNzZmFjdG9ycy5jb20vb2F1dGgvdG9rZW4iLz48L3NhbWwyOlN1YmplY3RDb25maXJtYXRpb24+PC9zYW1sMjpTdWJqZWN0PjxzYW1sMjpDb25kaXRpb25zIE5vdEJlZm9yZT0iMjAyMy0wNi0xNFQwOToxNTozMC43NzVaIiBOb3RPbk9yQWZ0ZXI9IjIyMTMtMDgtMDFUMjA6MDU6MzAuNzc1WiI+PHNhbWwyOkF1ZGllbmNlUmVzdHJpY3Rpb24+PHNhbWwyOkF1ZGllbmNlPnd3dy5zdWNjZXNzZmFjdG9ycy5jb208L3NhbWwyOkF1ZGllbmNlPjwvc2FtbDI6QXVkaWVuY2VSZXN0cmljdGlvbj48L3NhbWwyOkNvbmRpdGlvbnM+PHNhbWwyOkF1dGhuU3RhdGVtZW50IEF1dGhuSW5zdGFudD0iMjAyMy0wNi0xNFQwOToyNTozMC43NzVaIiBTZXNzaW9uSW5kZXg9Ijg4ODc4NzU1LTU0Y2QtNGU1Ni1hMmNkLTVkZThlNWY4ZGY2NyI+PHNhbWwyOkF1dGhuQ29udGV4dD48c2FtbDI6QXV0aG5Db250ZXh0Q2xhc3NSZWY+dXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFjOmNsYXNzZXM6UGFzc3dvcmRQcm90ZWN0ZWRUcmFuc3BvcnQ8L3NhbWwyOkF1dGhuQ29udGV4dENsYXNzUmVmPjwvc2FtbDI6QXV0aG5Db250ZXh0Pjwvc2FtbDI6QXV0aG5TdGF0ZW1lbnQ+PHNhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudD48c2FtbDI6QXR0cmlidXRlIE5hbWU9ImFwaV9rZXkiPjxzYW1sMjpBdHRyaWJ1dGVWYWx1ZSB4c2k6dHlwZT0ieHM6c3RyaW5nIj5PVEkwWXpBeE5HTmlPRFUzTkRRek5qWXhOemMzT1RnellXUXhaUTwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PC9zYW1sMjpBdHRyaWJ1dGVTdGF0ZW1lbnQ+PC9zYW1sMjpBc3NlcnRpb24+";

	//SSL
	//String certificatesTrustStorePath = "D:/TyreApp/Certificate/cacerts";
	//System.setProperty("javax.net.ssl.trustStore", certificatesTrustStorePath);
	//System.setProperty("https.protocols", "TLSv1.2");
    try {
        // Create the token request
        URL url = new URL(tokenUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        //connection.setRequestProperty("Host", "api8.successfactors.com");
        connection.setRequestProperty("Content-Length", String.valueOf(requestBody.getBytes().length));
        connection.setDoOutput(true);

        // Set the request body
        OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
        writer.write(requestBody);
        writer.flush();

        // Send the request
        int responseCode = connection.getResponseCode();

        // Process the response
        if (responseCode == HttpURLConnection.HTTP_OK) {
            // Read the response body
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder responsee = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responsee.append(line);
            }
            reader.close();

            // Parse the response JSON
            JSONObject jsonResponse = new JSONObject(responsee.toString());
            String accessToken = jsonResponse.getString("access_token");
            String tokenType = jsonResponse.getString("token_type");
            int expiresIn = jsonResponse.getInt("expires_in");

            // Use the access token for subsequent API calls
            // ...

            // Display the response in the HTML body
%>
<!DOCTYPE html>
<html>
<head>
    <title>API Response Example</title>
</head>
<body>
    <h1>Access Token: <%= accessToken %></h1>
    <h2>Token Type: <%= tokenType %></h2>
    <h2>Expires In: <%= expiresIn %></h2>
</body>
</html>
<%
        } else {
            // Handle the error response
            // ...
        }
    } catch (Exception e) {
        // Handle any exceptions that occur
        e.printStackTrace();
        out.println("exception>>>>>>"+e);
        // ...
    }
%>
