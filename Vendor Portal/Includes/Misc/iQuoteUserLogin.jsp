<%@ page import="ezc.ezparam.*,ezc.ezbasicutil.*"%>

<%
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	String userId = request.getParameter("user");
	String passWord = request.getParameter("password");
	
	String soldTo = "";
	
	String catalog_area = "";

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
	String catAreaStr="";
	int RetrfqCount = 0;	
	if(LogonStatus.IsSuccess())	
	{
		ezc.client.EzcPurchaseUtilManager PurManager = new ezc.client.EzcPurchaseUtilManager(Session);
			
		ReturnObjFromRetrieve retcatarea = (ReturnObjFromRetrieve)PurManager.getUserPurAreas();
		try{
			ReturnObjFromRetrieve userInfo = LogonStatus.getUserInfo();
			
			session.putValue("LAST_LOGIN_TIME",userInfo.getFieldValueString("EU_LAST_LOGIN_TIME"));
			session.putValue("LAST_LOGIN_DATE",userInfo.getFieldValueString("EU_LAST_LOGIN_DATE"));
			
		}catch(Exception e){System.out.println(e.getMessage());}
		
		
		
		ezc.client.EzUserAdminManager UManager = new ezc.client.EzUserAdminManager();
		EzcUserParams uparamsN= new EzcUserParams();
		EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
		ezcUserNKParamsN.setLanguage("EN");
		uparamsN.setUserId(Session.getUserId());
		uparamsN.createContainer();
		uparamsN.setObject(ezcUserNKParamsN);
		Session.prepareParams(uparamsN);
		ReturnObjFromRetrieve retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
		String UserType=retUserData.getFieldValueString(0,"EU_TYPE");
		session.putValue("UserType",UserType);	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		java.util.Vector myCatVect=new java.util.Vector();
		if(retcatarea!=null&&retcatarea.getRowCount()>0)
		{
			
			java.util.Hashtable syskeyTempHash=new java.util.Hashtable();
			String mySys=null;
			for(int u=0;u<retcatarea.getRowCount();u++)
			{
				
				
				mySys = retcatarea.getFieldValueString(u,"ESKD_SYS_KEY");
				myCatVect.add(mySys);
				
				if("".equals(catAreaStr))
					catAreaStr=mySys;
				else
					catAreaStr +="','"+mySys;
				
				
				
				EzcSysConfigParams sparams2 = new EzcSysConfigParams();
				EzcSysConfigNKParams snkparams2 = new EzcSysConfigNKParams();
				snkparams2.setLanguage("EN");
				snkparams2.setSystemKey(mySys);
				snkparams2.setSiteNumber(200);
				sparams2.setObject(snkparams2);
				Session.prepareParams(sparams2);
				ReturnObjFromRetrieve retTemplate = (ReturnObjFromRetrieve)ConfigMgr.getCatAreaDefaults(sparams2);
				int retcnt=retTemplate.getRowCount();
				for(int z=0;z<retcnt;z++)
				{
					if("WFTEMPLATE".equals((retTemplate.getFieldValueString(z,"ECAD_KEY")).toUpperCase()) )
					{
						if(!syskeyTempHash.containsKey(mySys))
						{
							syskeyTempHash.put(mySys,retTemplate.getFieldValueString(z,"ECAD_VALUE"));
						}
					}
				}
				
							
			}
			
			session.putValue("CATAREAS",myCatVect);
			session.putValue("SYSKEYTEMPLATE",syskeyTempHash);
			
		}
		
		ReturnObjFromRetrieve retsoldto =null;
		for(int i=0;i<myCatVect.size();i++)	
		{
			catalog_area = (String)myCatVect.get(i);
			retsoldto= (ReturnObjFromRetrieve)PurManager.getUserVendors(catalog_area);
			if(retsoldto.getRowCount()>0){
				soldTo = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO");
				break;
			}
		}
			
		PurManager.setPurAreaAndVendor(catalog_area,soldTo);
		
				
		
		ezc.ezparam.ReturnObjFromRetrieve myRetrfq = null;
		String statusString ="N') AND ERH_EXT3 LIKE ('Y') AND ERH_RFQ_NO='6000118057'  AND ERH_SYS_KEY=EC_SYS_KEY AND EC_SYS_KEY IN ('"+catAreaStr;

		ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
		ezc.ezparam.EzcParams ezcparamsrfq				     	= new ezc.ezparam.EzcParams(false);
		ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
		ezirfqheaderparams.setStatus(statusString);
		ezirfqheaderparams.setSoldTo(soldTo);
		ezcparamsrfq.setObject(ezirfqheaderparams);
		ezcparamsrfq.setLocalStore("Y");
		Session.prepareParams(ezcparamsrfq);
		myRetrfq = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparamsrfq);
		if(myRetrfq!=null)
			RetrfqCount=myRetrfq.getRowCount();
		if(RetrfqCount>0){
			catalog_area=myRetrfq.getFieldValueString("SYS_KEY");
			PurManager.setPurAreaAndVendor(catalog_area,soldTo);
		}
			
		
	}
	else
	{
		pwdPassword = true;
	}
%>
<%@ include file="/EzCommerce/EzVendor/Includes/JSPs/Misc/iOffLineAuthenticateUser.jsp"%>