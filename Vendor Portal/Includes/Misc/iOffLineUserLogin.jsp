<%@ page import="ezc.ezparam.*"%>
<%
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	String userId = request.getParameter("user");
	String passWord = request.getParameter("password");
	String skey = request.getParameter("skey");
	String soldTo = "";
	
	String catalog_area = "";
	String SysKeyOffline = "";

/*** It's for Agents login ***
	if(userId==null)
	{
		userId   = "";
		passWord = "";
	}
	
*** End ***/	
	String language = "ENGLISH";
	String site="200";

	if(userId != null)
		userId =  userId.toUpperCase();

	logs.setUserId(userId);
	logs.setPassWd(passWord);
        logs.setConnGroup(site);
        
        boolean pwdPassword = false;

	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	
	if(LogonStatus.IsSuccess())	
	{
		
		
		
		ezc.client.EzUserAdminManager UManager = new ezc.client.EzUserAdminManager();
		EzcUserParams uparamsN= new EzcUserParams();
		EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
		ezcUserNKParamsN.setLanguage("EN");
		uparamsN.setUserId(Session.getUserId());
		uparamsN.createContainer();
		uparamsN.setObject(ezcUserNKParamsN);
		Session.prepareParams(uparamsN);
		//User info

		ReturnObjFromRetrieve retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
		boolean needRedirect=true;

		String UserType=retUserData.getFieldValueString(0,"EU_TYPE");
		String redirectfile=null;
		session.putValue("UserType",UserType);		
		
		
		
		
		
		
		
		
		
		
		
		ezc.client.EzcPurchaseUtilManager PurManager = new ezc.client.EzcPurchaseUtilManager(Session);
			
		ReturnObjFromRetrieve retcatarea = (ReturnObjFromRetrieve)PurManager.getUserPurAreas();
		
		for(int i=0;i<retcatarea.getRowCount();i++)
			SysKeyOffline = (String)(retcatarea.getFieldValue(i,"ESKD_SYS_KEY"));
		
		catalog_area = skey;
		ReturnObjFromRetrieve retsoldto = (ReturnObjFromRetrieve)PurManager.getUserVendors(catalog_area);
		//if("".equals(soldTo) || soldTo ==null)  
			soldTo = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO");
		
		PurManager.setPurAreaAndVendor(skey,soldTo);
	}
	else
	{
		pwdPassword = true;
	}
%>