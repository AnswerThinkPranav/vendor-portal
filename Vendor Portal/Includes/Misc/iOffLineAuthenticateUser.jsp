<jsp:useBean id="PasswordManager" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session" />
<%
	
	if(LogonStatus.IsSuccess()) 
	{
		ezc.ezparam.EzcParams mainPwdParams = new ezc.ezparam.EzcParams(false);
		ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams admUtilParams = new  ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams();
		admUtilParams.setUserId("'"+Session.getUserId()+"'");
		mainPwdParams.setObject(admUtilParams);
		Session.prepareParams(mainPwdParams);
		ezc.ezparam.ReturnObjFromRetrieve pwdChgRet =(ezc.ezparam.ReturnObjFromRetrieve)PasswordManager.getPasswordPolicy(mainPwdParams);
		
		int pwdChgRetCnt = 0;
		if(pwdChgRet!=null) 
			pwdChgRetCnt = pwdChgRet.getRowCount();
		if(pwdChgRetCnt==0)
		{
			//response.sendRedirect("/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/Misc/ezPassword.jsp?Flag=X");
		}

		if(pwdChgRetCnt>0)
		{
			Date curDate = new Date();
			Date chngdDate = (Date)pwdChgRet.getFieldValue(0,"EPM_PWD_CHANGED_ON"); 
			long Days = ((curDate.getTime()/(24 * 60 * 60 * 1000)) - (chngdDate.getTime()/(24 * 60 * 60 * 1000)));  
			if(Days >= 30)
			{
				//response.sendRedirect("/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/Misc/ezPassword.jsp?updtFlag=U");
			}
		}	
	}	
	
	boolean mainLogin = true;
	if(!(LogonStatus.IsSuccess()))      //If not authorized
	{
		logs.setUserGroup("0");						/**************************************************************/
		logs.setUserId("EZCADMIN");					/*Login with dummy  admin user for session to store web status*/
		logs.setPassWd("myindia");					/*Need to create one dummy admin user for this*****************/
		logs.setConnGroup(site);
		LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
		
		mainLogin = false;
	}
	int result = 0;
	String count  = "";
	String SYSKEY = "";
	int rowCount = 0;
	
	
	
	/**************To get user web status from last five logins***********************************/
/*
	ezc.ezwebstats.client.EzWebStatsManager webstatMgr=new ezc.ezwebstats.client.EzWebStatsManager();
	ezc.ezparam.EzcParams ezcparam=new ezc.ezparam.EzcParams(false);
	ezc.ezwebstats.params.EziWebStatsParams webParams=new ezc.ezwebstats.params.EziWebStatsParams();
	webParams.setSysKey("USERWEBSTATS");
	webParams.setUserId(userId);
	ezcparam.setObject(webParams);
	Session.prepareParams(ezcparam);
	ReturnObjFromRetrieve userWeb=(ReturnObjFromRetrieve)webstatMgr.getWebStatsList(ezcparam);
	
	*/
	/*********If the User last login time exceeds 60 days lock the user**************************/
	/*********If the user failed to login atleast five times lock the user***********************/
	/*if(userWeb.getRowCount() > 0)
	{
		String skey=userWeb.getFieldValueString(0,"SYSKEY");
		java.util.Date curDate = new java.util.Date();
		java.util.Date lgOutDt = (java.util.Date)userWeb.getFieldValue(0,"LOGGED_OUT");
		long Days = ((curDate.getTime()/(24 * 60 * 60 * 1000)) - (lgOutDt.getTime()/(24 * 60 * 60 * 1000))); 
		int userWebCount =0;
		if(userWeb!=null) userWebCount = userWeb.getRowCount();
		for(int i=0;i<userWebCount;i++)
		{
			SYSKEY = userWeb.getFieldValueString(i,"SYSKEY");
			if(i < 5)
			{
				if("LOGINFAIL".equals(SYSKEY.toUpperCase())) 
				{
					rowCount = rowCount+1;
				}
				else
				{
					rowCount = 0;
					break;
				}
			}		
		}
		
		System.out.println("Sending MailSending MailSending MailSending MailSending Mail:"+skey);
		if("LOCKED".equals(skey))
		{
			
				try
				{
					System.out.println("Sending Mail");
					ezc.ezparam.EzcParams eParams=new ezc.ezparam.EzcParams(false);
					ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();
					mailParams.setSubject("User ID Locked");
					mailParams.setTo("ssurisetti@answerthink.com");
					mailParams.setCC("vi.singh@ranbaxy.com");
					mailParams.setMsgText("UserID "+userId+" Locked on "+request.getServerName()+" as the user entered wrong password more than 5 times.Please take necessary action");
					mailParams.setGroupId("Ezc");
					mailParams.setIsFailOver(true);
					ezc.ezmail.EzMail mail=new ezc.ezmail.EzMail();
					boolean mailSendFlag=mail.ezSend(mailParams,Session);				   
					System.out.println("Mail Sent");
				}
				catch(Exception e)
				{
				   System.out.println("the exception is :"+e.getMessage());
				}			
				
			response.sendRedirect("/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/Misc/ezOfflineLoginLock.jsp");
			
		}
		else if(Days >= 60 || rowCount >= 4 || (!mainLogin))
		{
			ezc.ezparam.EzcParams ezcparam1=new ezc.ezparam.EzcParams(false);
			ezc.ezwebstats.params.EziWebStatsParams webParams1=new ezc.ezwebstats.params.EziWebStatsParams();
			webParams1.setUserId(userId);
			if(rowCount >= 4 || Days >= 60)
				webParams1.setSysKey("LOCKED");
			else
				webParams1.setSysKey("LOGINFAIL");	
			webParams1.setIP(request.getRemoteAddr());
			webParams1.setSoldTo("0");
			ezcparam1.setObject(webParams1);
			Session.prepareParams(ezcparam1);
			webstatMgr.addWebStats(ezcparam1);

			if(mainLogin)
			{
				
				response.sendRedirect("/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/Misc/ezOfflineLoginLock.jsp");
			}	
		}
				
	}*/
	
	

%>