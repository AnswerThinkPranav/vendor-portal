<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>

<%
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();


	miscParams.setQuery("UPDATE EZC_RFQ_HEADER SET ERH_STATUS='C'  WHERE  NOW() >= ERH_VALID_UPTO ");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	try{
	ezMiscManager.ezUpdate(mainParams);
	}
   	catch(Exception e)
      	{
      		ezc.ezcommon.EzLog4j.log(":Exception occured while closing RFQ List from DB:"+e,"I");
      	}
%>      	