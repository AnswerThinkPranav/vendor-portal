<%@ page import ="ezc.ezparam.*"%>
<%@ page import = "ezc.ezcsm.EzUser" %>
<%@ page import = "ezc.ezcommon.EzUserDBLight" %>
<%@ include file="../../../Includes/Lib/PurchaseBean.jsp"%>

<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope = "page"></jsp:useBean>
<jsp:useBean id="PasswordManager" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session"></jsp:useBean>

<%

	ezc.ezparam.EzcParams mainPwdParams = new ezc.ezparam.EzcParams(false);
	ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams admUtilParams = new  ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams();

	admUtilParams.setUserId("'"+Session.getUserId()+"'");
	admUtilParams.setPassword("test");
	mainPwdParams.setObject(admUtilParams);
	Session.prepareParams(mainPwdParams);
	ezc.ezcommon.EzLog4j.log(":New pwdPolicy::","I");
	//PasswordManager.addPasswordPolicy(mainPwdParams);
	ezc.ezcommon.EzLog4j.log(":After New pwdPolicy::","I");
	
	String s = "03-10-2013";
	java.util.Date d= new java.util.Date(s);
	out.println("Date:"+d);
%>