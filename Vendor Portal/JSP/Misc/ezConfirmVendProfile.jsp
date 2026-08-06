<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>

<%
	String flag = request.getParameter("flag");
	String vendorId	= (String)Session.getUserId();
	String qry="INSERT INTO EZC_VENDOR_CONFIRMATION (EVC_VENDOR,EVC_IS_CONFIRMED,EVC_CONFIRMED_ON,EVC_EXT1,EVC_EXT2,EVC_EXT3) VALUES('"+vendorId+"','"+flag+"',NOW(),'','','')" ;

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	EziMiscParams miscParams = new EziMiscParams();
	miscParams.setQuery(qry);
	mainParams.setObject(miscParams);	
	Session.prepareParams(mainParams);

	try{
	miscManager.ezAdd(mainParams);
}catch(Exception e){}
%>

