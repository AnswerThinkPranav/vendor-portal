<%@ page import ="ezc.ezparam.*"%>
<%@ page import = "ezc.ezcsm.EzUser" %>
<%@ page import = "ezc.ezcommon.EzUserDBLight" %>
<%@ include file="../../../Includes/Lib/PurchaseBean.jsp"%>

<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope = "page"></jsp:useBean>
<jsp:useBean id="PasswordManager" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session"></jsp:useBean>
<%@ include file="../Misc/iblockcontrol.jsp" %>
<% 
	
	String noDataStatement = urPwdSucc_L;
	String pwdMatchedFlag = "";
	
	boolean passwordCheck 	= false;
	boolean passCheck	= true;
	
	String updtFlag = request.getParameter("updtFlag");
	String flag 	= request.getParameter("Flag");
	
	String oldPswd 	= request.getParameter("oldPswd");
	String mypwd 	= request.getParameter("oldpasswd");
	String newpwd	= request.getParameter("password1");
	
	String newpwdenc=null;
	if(oldPswd==null||"null".equals(oldPswd)) 
		oldPswd	="";
	
	ezc.ezcommon.EzLog4j.log(":oldPswd:"+oldPswd,"I");
	ezc.ezcommon.EzLog4j.log(":mypwd:"+mypwd,"I");
	ezc.ezcommon.EzLog4j.log(":newpwd:"+newpwd,"I");
	

	EzcUserNKParams usernkparams = new EzcUserNKParams();
	EzcUserParams newParams = new EzcUserParams();
	usernkparams.setLanguage("EN");
	newParams.setUserId(Session.getUserId());
	newParams.createContainer();
	newParams.setObject(usernkparams);
	Session.prepareParams(newParams);
	usernkparams.setPassword(mypwd);


	ezc.ezparam.EzcParams mainPwdParams = new ezc.ezparam.EzcParams(false);
	ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams admUtilParams = new  ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams();



	ezc.ezcommon.EzCipher myCipher = new ezc.ezcommon.EzCipher();
	newpwdenc=myCipher.ezEncrypt(newpwd);
	java.util.StringTokenizer st=new java.util.StringTokenizer(oldPswd,"¥");
	int tokenCount=0;
	if(st!=null)
	{
		tokenCount=st.countTokens();
		int count=0;	
		String tempPswd="";
		while(st.hasMoreTokens())
		{
			if(newpwdenc.equals(((String)st.nextToken()).trim()))
			{
				passCheck=false;
			}
		}
		if(passCheck && !"".equals(oldPswd))
		{
			oldPswd += "¥"+newpwdenc;
		}
		else if(passCheck)
		{
			oldPswd=newpwdenc;
		}

	}



ezc.ezcommon.EzLog4j.log(":passCheck:"+passCheck,"I");

if(passCheck)
{
	if ((!(mypwd == null))) 
	{
		boolean ret = UserManager.validateUserPassword(newParams);	
		ezc.ezcommon.EzLog4j.log(":ret:"+ret,"I");
		if (ret) 
		{
			usernkparams.setPassword(newpwd);
			UserManager.changeUserPassword(newParams);
			
			ezc.ezcommon.EzLog4j.log(":updtFlag:"+updtFlag,"I");
			if("U".equals(updtFlag) || flag==null)
			{
				System.out.println("++++++++++In Update Method+++++++++++++++");
				admUtilParams.setUserId("'"+Session.getUserId()+"'");
				admUtilParams.setPassword(oldPswd);
				mainPwdParams.setObject(admUtilParams);
				Session.prepareParams(mainPwdParams);
				PasswordManager.updatePasswordPolicy(mainPwdParams);
			}

		}	
	}
	ezc.ezcommon.EzLog4j.log(":flag:"+flag,"I");
	if (flag!=null)
	{
		if("3".equals((String)session.getValue("UserType")))
		{
			ezc.ezshipment.client.EzShipmentManager shipManager= new ezc.ezshipment.client.EzShipmentManager();
			newParams = new EzcUserParams();
			EzcUserParams uparams= new EzcUserParams();
			uparams.setUserId(Session.getUserId());
			newParams.setObject(uparams);
			Session.prepareParams(newParams);
			shipManager.ezPutDisclaimerStamp(newParams);
		}	

ezc.ezcommon.EzLog4j.log(":Session.getUserId():"+Session.getUserId(),"I");
		
		mainPwdParams = new ezc.ezparam.EzcParams(false);
		admUtilParams = new  ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams();
		
		admUtilParams.setUserId("'"+Session.getUserId()+"'");
		admUtilParams.setPassword(oldPswd);
		mainPwdParams.setObject(admUtilParams);
		Session.prepareParams(mainPwdParams);
		ezc.ezcommon.EzLog4j.log(":B4 pwdPolicy::","I");
		PasswordManager.addPasswordPolicy(mainPwdParams);
		ezc.ezcommon.EzLog4j.log(":After pwdPolicy::","I");
		
		if("Y".equals((String)session.getValue("OFFLINE")))
		{
			//response.sendRedirect("ezSelectSoldTo.jsp");
			passwordCheck = true;	
		}	
		else
			passwordCheck = false;	
			//response.sendRedirect("ezSelectSoldTo.jsp");
	}
}	
else
{
	noDataStatement = "Your password matches recently changed passwords.Please change the password again.";
	pwdMatchedFlag = "Y";
}
	
	
%>

<%@ include file="../Misc/ireleasecontrol.jsp" %>