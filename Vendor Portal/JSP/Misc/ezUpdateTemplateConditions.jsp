<%@ page contentType="text/plain;charset=UTF-8" %>
<%@ page import="ezc.ezmisc.params.*, ezc.ezparam.*, ezc.ezmisc.client.*, ezc.ezcommon.*, java.util.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page" />
<%
	String template = request.getParameter("template");
	String level = request.getParameter("level");
	String condition = request.getParameter("condition");
	String value = request.getParameter("value");
	

	EzcParams mainParams = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	    
	if(template!=null && !"null".equals(template) && !"".equals(template))
	{
		String query = "UPDATE EZC_WF_PRICING_CONDITIONS SET EWPC_QCF_FLAG='"+ condition +"',EWPC_QCF_RELEASE='"+ value +"' WHERE EWPC_TEMPLATE='"+ template +"' AND EWPC_LEVEL='"+ level +"'";
		miscParams.setQuery(query);
		ezc.ezcommon.EzLog4j.log("updateQuery>>>>>>"+query,"I");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);	
		try 
		{
			ezMiscManager.ezUpdate(mainParams);
			out.print("SUCCESS");
		}
		catch(Exception e)
		{
			e.printStackTrace();
			out.println("ERROR");
			ezc.ezcommon.EzLog4j.log("Error while updating>>>>>>"+e.getMessage(),"E");
		}
    	}
%>