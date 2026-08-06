<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String password=(String)session.getValue("DRL_PASSWORD");	
	if(password==null || "null".equals(password)) password="";
	
	ezc.ezshipment.client.EzShipmentManager shipManager= new ezc.ezshipment.client.EzShipmentManager();
	ezc.ezparam.EzcParams ezcparams= new ezc.ezparam.EzcParams(true);
	ezc.ezparam.EzcUserParams uparams= new ezc.ezparam.EzcUserParams();
	uparams.setUserId(Session.getUserId());
	ezcparams.setObject(uparams);
	Session.prepareParams(ezcparams);
	ReturnObjFromRetrieve retObj=(ReturnObjFromRetrieve)shipManager.ezGetDisclaimerStamp(ezcparams);
	out.println(retObj.toEzcString());
	ezc.ezcommon.EzLog4j.log(":retObj:ezGetDisclaimerStamp:"+retObj.toEzcString(),"I");
	if (retObj.getRowCount()>0 && !"portal".equalsIgnoreCase(password))
	{
		shipManager.ezPutDisclaimerStamp(ezcparams);
		response.sendRedirect("ezSelectSoldTo.jsp");		
	}
	else
	{
		//response.sendRedirect("ezPassword.jsp?Flag=X");
		response.sendRedirect("ezPreWelPwdChng.jsp?Flag=X");
	}
%>
