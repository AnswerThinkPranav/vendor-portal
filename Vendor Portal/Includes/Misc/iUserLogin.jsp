<%@ page import="ezc.ezparam.*,ezc.ezbasicutil.*"%>

<%
	String userId 	= request.getParameter("user");
	String passWord = request.getParameter("password");
	String language = request.getParameter("language");
	String site	= request.getParameter("site");

	String soldTo		= "";
	String catalog_area	= "";
	boolean pwdPassword 	= false;

	if(userId==null)	/*** It's for Agents login ***/
	{
		userId   = "";
		passWord = "";
	}
	userId = userId.toUpperCase();


	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	logs.setUserId(userId);
	logs.setPassWd(passWord);
        logs.setConnGroup(site);
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	if(LogonStatus.IsSuccess())	
	{
		ezc.client.EzcPurchaseUtilManager PurManager = new ezc.client.EzcPurchaseUtilManager(Session);
		ReturnObjFromRetrieve retcatarea = (ReturnObjFromRetrieve)PurManager.getUserPurAreas();
		try
		{
			ReturnObjFromRetrieve userInfo = LogonStatus.getUserInfo();
			session.putValue("LAST_LOGIN_TIME",userInfo.getFieldValueString("EU_LAST_LOGIN_TIME"));
			session.putValue("LAST_LOGIN_DATE",userInfo.getFieldValueString("EU_LAST_LOGIN_DATE"));
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		
		if(retcatarea!=null && retcatarea.getRowCount()>0)
		{
			java.util.Vector myCatVect		= new java.util.Vector();
			java.util.Hashtable syskeyTempHash	= new java.util.Hashtable();
			java.util.Hashtable purgrphash	= new java.util.Hashtable();
			String mySys=null;
			for(int u=0;u<retcatarea.getRowCount();u++)
			{
				mySys = retcatarea.getFieldValueString(u,"ESKD_SYS_KEY");
				myCatVect.add(mySys);
				
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
					if("PURGROUP".equals((retTemplate.getFieldValueString(z,"ECAD_KEY")).toUpperCase()))
					{
						purgrphash.put(mySys,retTemplate.getFieldValueString(z,"ECAD_VALUE"));
											
					}
				}
				
							
			}
			
			session.putValue("CATAREAS",myCatVect);
			session.putValue("SYSKEYTEMPLATE",syskeyTempHash);
			session.putValue("PURGROUPS",purgrphash);
		}
		
		catalog_area = (String)(retcatarea.getFieldValue(retcatarea.getRowCount()-1,"ESKD_SYS_KEY"));
		//catalog_area = (String)(retcatarea.getFieldValue(0,"ESKD_SYS_KEY"));
		System.out.println("CHECKITTTTT");
		ReturnObjFromRetrieve retsoldto = (ReturnObjFromRetrieve)PurManager.getUserVendors(catalog_area);
		java.util.Hashtable vendorsHT 		= new java.util.Hashtable();	
		if(retsoldto.getRowCount() > 0)
		{
			for(int v=0;v<retsoldto.getRowCount();v++)
				vendorsHT.put(retsoldto.getFieldValue(v,"EC_ERP_CUST_NO"),retsoldto.getFieldValue(v,"ECA_NAME"));
			session.putValue("VENDORHT",vendorsHT);
		}
		
System.out.println("CHECKITTTTT1111");
		soldTo = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO");
		
		PurManager.setPurAreaAndVendor(catalog_area,soldTo);
		
		session.putValue("userStyle","GREEN");
	}
	else
	{
		pwdPassword = true;
	}
	
%>
<%@ include file="/EzCommerce/EzVendor/Includes/JSPs/Misc/iOffLineAuthenticateUser.jsp"%>