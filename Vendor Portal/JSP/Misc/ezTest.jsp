<%@ page import="java.sql.*,ezc.ezparam.*,javax.naming.*,javax.sql.*" %>
<%
	Connection dbConnection = null;
	Context ctx = null;

	
	DataSource ds = null;

	try {
		ctx = new InitialContext();
		//ds = 	(DataSource)ctx.lookup("java:comp/env/EzCOMDEVAlias");
		ds = 	(DataSource)ctx.lookup("java:openejb/Resource/EzCOMDEVAlias");
		if(ds!=null)
			dbConnection =  ds.getConnection();
			
		out.print(dbConnection);
	} catch (Exception e) {
		out.print(e);
	}
%>