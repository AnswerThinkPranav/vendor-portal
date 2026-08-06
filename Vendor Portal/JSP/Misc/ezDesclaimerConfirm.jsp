<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/InboxBean.jsp"%>

<%@ page import = "ezc.ezparam.*,ezc.ezshipment.client.*,java.util.*" %>
<%@ page import="ezc.ezcommon.arms.params.*" %>
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope="session"></jsp:useBean>
<%@ include file="../../../Includes/JSPs/Misc/iAddWebStats.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%
	if(session.isNew()) 
	{
		response.sendRedirect("../../Htmls/EzCookieHelp.htm");
	}
	
	String userId 		= Session.getUserId();
	
	String redirectfile 	= "";
	if(userId != null)
	{
		EzcUserParams uparamsN= new EzcUserParams();
		EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
		ezcUserNKParamsN.setLanguage("EN");
		uparamsN.setUserId(userId);
		uparamsN.createContainer();
		uparamsN.setObject(ezcUserNKParamsN);
		Session.prepareParams(uparamsN);
		ReturnObjFromRetrieve retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
		//out.println(retUserData.toEzcString());
		int retUserDataCount = 0;
		if(retUserData != null)
		{
			retUserDataCount = retUserData.getRowCount();
			//ezc.ezcommon.EzLog4j.log("::::::::retUserData:::::::::::"+retUserData.toEzcString(),"I");
		}
		
		if(retUserDataCount > 0)
		{
			String userStyle = "";
			String userRole  = "";
			String userGroup = "";
			String role 	 = "";
			String lang1     = "ENGLISH";
			String userDefPurGroup="";
			String userPlants = "";
			
			String UserType  = retUserData.getFieldValueString(0,"EU_TYPE");
			String firstName = retUserData.getFieldValueString(0,"EU_FIRST_NAME");
			String middleName= retUserData.getFieldValueString(0,"EU_MIDDLE_INITIAL");
			String lastName  = retUserData.getFieldValueString(0,"EU_LAST_NAME");
			String emailId  = retUserData.getFieldValueString(0,"EU_EMAIL");
			String laLoginTime  = retUserData.getFieldValueString(0,"EU_LAST_LOGIN_TIME");
			String laLoginDate  = retUserData.getFieldValueString(0,"EU_LAST_LOGIN_DATE");

			if(Session.getUserPreference("STYLE")	!= null)
				userStyle = (String)Session.getUserPreference("STYLE");

			if(Session.getUserPreference("USERROLE")!= null)
				userRole  = (String)Session.getUserPreference("USERROLE");
			
			if(Session.getUserPreference("PURGROUP")!= null)
				userDefPurGroup  = (String)Session.getUserPreference("PURGROUP");
				
			if(Session.getUserPreference("PLANT")!= null)
				userPlants  = (String)Session.getUserPreference("PLANT");				
				
			
			
			if(userDefPurGroup!=null)
			userDefPurGroup=userDefPurGroup.trim();
			
			userDefPurGroup=userDefPurGroup.toUpperCase();
			
			
			ReturnObjFromRetrieve retUsrRoles = null;
			String pf[] = {"AG","VN"};
			EzcUserParams uparamsUA = new EzcUserParams();
			EzcUserNKParams ezcUserNKParamsUA = new EzcUserNKParams();
			ezcUserNKParamsUA.setLanguage("EN");
			ezcUserNKParamsUA.setPartnerFunctions(pf);
			uparamsUA.setUserId(userId);
			uparamsUA.setBussPartner(retUserData.getFieldValueString(0,"EU_BUSINESS_PARTNER").trim());
			uparamsUA.setObject(ezcUserNKParamsUA);
			Session.prepareParams(uparamsUA);
			retUsrRoles = (ReturnObjFromRetrieve) UserManager.getUserAllowedAuthorizations(uparamsUA);

			String userRolesStr = "";
			int retUsrRolesCnt=0;
			if(retUsrRoles!=null)
				retUsrRolesCnt = retUsrRoles.getRowCount();

			for(int r=0;r<retUsrRolesCnt;r++)
			{
				if("Y".equals(retUsrRoles.getFieldValueString(r,"ISCHECKED")))
				{
					if(r==0)
						userRolesStr = retUsrRoles.getFieldValueString(r,"EBPA_AUTH_KEY");
					else
						userRolesStr += "','"+retUsrRoles.getFieldValueString(r,"EBPA_AUTH_KEY");
				}	
			}

			/*ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezworkflow.params.EziWorkGroupsParams params= new ezc.ezworkflow.params.EziWorkGroupsParams();
			params.setUserId(Session.getUserId());
			mainParams.setObject(params);
			Session.prepareParams(mainParams);
			ezc.ezparam.ReturnObjFromRetrieve retWorkGroupsList = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWorkGroupsList(mainParams);


			if(retWorkGroupsList != null)
			{
				int workGroupCount = retWorkGroupsList.getRowCount();
				if(workGroupCount > 0)
				{
					userGroup = retWorkGroupsList.getFieldValueString(0,"GROUP_ID");
					role 	  = retWorkGroupsList.getFieldValueString(0,"ROLE");
				}
			}*/
			
			java.util.Vector wgVector = new java.util.Vector();
			java.util.Hashtable wgHashTable = new java.util.Hashtable();
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezworkflow.params.EziWorkGroupsParams params= new ezc.ezworkflow.params.EziWorkGroupsParams();
			params.setUserId(Session.getUserId());
			mainParams.setObject(params);
			Session.prepareParams(mainParams);
			ezc.ezparam.ReturnObjFromRetrieve retWorkGroupsList = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWorkGroupsList(mainParams);
			ezc.ezcommon.EzLog4j.log(":retWorkGroupsList::"+retWorkGroupsList.toEzcString(),"I");
			if(retWorkGroupsList != null)
			{
				int workGroupCount = retWorkGroupsList.getRowCount();
				if(workGroupCount > 0)
				{
					userGroup = retWorkGroupsList.getFieldValueString(0,"GROUP_ID");
					ezc.ezcommon.EzLog4j.log(":userGroup::"+userGroup,"I");
					role 	  = retWorkGroupsList.getFieldValueString(0,"ROLE");
				}
				for(int i=0;i<workGroupCount;i++)
				{	ezc.ezcommon.EzLog4j.log(":wgVector::"+wgVector.toString(),"I");
					if(!wgVector.contains(retWorkGroupsList.getFieldValueString(i,"GROUP_ID")))
					{
						wgVector.addElement(retWorkGroupsList.getFieldValueString(i,"GROUP_ID"));
					}
					wgHashTable.put(retWorkGroupsList.getFieldValueString(i,"SYSKEY"),retWorkGroupsList.getFieldValueString(i,"GROUP_ID"));
				}
			}

			session.putValue("WGSVECTOR",wgVector);
			session.putValue("WGHASHTABLE",wgHashTable);		
			
			//ezc.ezcommon.EzLog4j.log(":WGSVECTORWGSVECTORWGSVECTORWGSVECTOR::"+wgVector,"I");
			//ezc.ezcommon.EzLog4j.log(":WGHASHTABLEWGHASHTABLEWGHASHTABLEWGHASHTABLE::"+wgHashTable,"I");

		/*********************Getting Configured Authorizations for the user*******************/
			ezc.ezparam.EzcParams myConfigParams = new ezc.ezparam.EzcParams(true);
			Session.prepareParams(myConfigParams);
			try
			{
				java.util.Vector authVect=new java.util.Vector();
				ezc.ezcommon.arms.client.EzcUserRolesManager ezcUserRolesManager = new ezc.ezcommon.arms.client.EzcUserRolesManager();
				EzcParams roleParams=new EzcParams(false);
				EziRoleAuthParams roleAuthParams = new EziRoleAuthParams();
				roleAuthParams.setRoleNo(userRolesStr);
				roleAuthParams.setSysKey("0");
				roleParams.setObject(roleAuthParams);
				Session.prepareParams(roleParams);
				ezc.ezparam.ReturnObjFromRetrieve roleAuthRetObj = (ezc.ezparam.ReturnObjFromRetrieve)ezcUserRolesManager.ezRoleAuthList(roleParams);
				if(roleAuthRetObj != null)
				{
					int roleAuthRetCount = roleAuthRetObj.getRowCount();
					for(int i=0;i<roleAuthRetCount;i++)
					{
						authVect.add(roleAuthRetObj.getFieldValueString(i,"AUTH_KEY"));
					}
					session.putValue("USERAUTHS",authVect);
				}
				
				ezc.ezcommon.EzLog4j.log(":authVectauthVectauthVectauthVectauthVectauthVectauthVectauthVect::"+authVect,"I");
			}
			catch(Exception e){}
			
			
			
			/**************************************************************************************/			

			session.putValue("UserType",UserType);
			session.putValue("FIRST_NAME",firstName);
			session.putValue("MIDDLE_INITIAL",middleName);
			session.putValue("LAST_NAME",lastName);
			session.putValue("EMAIL_ID",emailId);
			session.putValue("LAST_LOGIN_TIME",laLoginTime);
			session.putValue("LAST_LOGIN_DATE",laLoginDate);
			session.putValue("userStyle",userStyle);
			session.putValue("USERROLE",userRole);
			session.putValue("USERDEFPURGRP",userDefPurGroup);
			//session.putValue("PLANT",userPlants);
			session.putValue("USERGROUP",userGroup);
			session.putValue("ROLE",role);
			session.putValue("LOCALE",new java.util.Locale("en","US"));
			session.putValue("CURRENCY","$");
			session.putValue("CPOSITION",new Boolean("true"));
			session.putValue("SREQUIRED",new Boolean("false"));
			session.putValue("DATEFORMAT",String.valueOf(ezc.ezutil.FormatDate.DDMMYYYY));
			session.putValue("DATESEPERATOR","/");
			session.putValue("TITLE","Welcome to EzCommerce Suite");
			session.putValue("POP_UP","N");
			
			session.putValue("PRICE_VEND_USER",userId);
			
			Vector plants=new Vector();
			Vector categories=new Vector();
			Vector purOrgVec=new Vector();
			
			
			ReturnObjFromRetrieve	retUserDef = ezMiscSelect(Session,"SELECT * FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_USER_ID='"+Session.getUserId()+"'");
			int retUserDefCnt = 0;
			if(retUserDef!=null)
				retUserDefCnt = retUserDef.getRowCount();

			if(retUserDefCnt>0)
			{
				for(int r=0;r<retUserDefCnt;r++)
				{
					if("PLANT".equals(retUserDef.getFieldValueString(r,"EUDKV_KEY")))
						plants.add(retUserDef.getFieldValueString(r,"EUDKV_VALUE"));
					else if("CATEGORY".equals(retUserDef.getFieldValueString(r,"EUDKV_KEY")))
						categories.add(retUserDef.getFieldValueString(r,"EUDKV_VALUE"));
					else if("PURORG".equals(retUserDef.getFieldValueString(r,"EUDKV_KEY")))
						purOrgVec.add(retUserDef.getFieldValueString(r,"EUDKV_VALUE"));						
				}
			}
			session.putValue("PLANT",plants);
			session.putValue("CATEGORIES",categories);
			session.putValue("PURORGDEF",purOrgVec);
			//out.print(purOrgVec);
			ezc.ezmisc.client.EzMiscManager miscMgr1 = new ezc.ezmisc.client.EzMiscManager();
			ReturnObjFromRetrieve	retObj1 = null;
			int retObjCnt1 = 0;

			ezc.ezparam.EzcParams mainParams_2 = new ezc.ezparam.EzcParams(true);
			ezc.ezmisc.params.EziMiscParams miscParams1 = new ezc.ezmisc.params.EziMiscParams();
			miscParams1.setQuery("SELECT * FROM EZC_WEB_STATS WHERE EWS_USER_ID = '"+Session.getUserId()+"'  ORDER BY EWS_LOGGED_IN DESC");
			mainParams_2.setObject(miscParams1);	
			Session.prepareParams(mainParams_2);
			try
			{
				retObj1 = (ReturnObjFromRetrieve)miscMgr1.ezSelect(mainParams_2);
			}catch(Exception e){}

			if(retObj1!=null)
				retObjCnt1 = retObj1.getRowCount();
			
			if(retObjCnt1>0)
			{
				/*for(int p=0;p<retObjCnt1;p++)
				{
					 if(p == retObjCnt1 -1){
					           session.putValue("LAST_LOGIN_TIMEE",retObj1.getFieldValue(p,"EWS_LOGGED_IN"));
					           out.println("::::::::retObjCnt1:::::::::::"+retObj1.getFieldValue(p,"EWS_LOGGED_IN"));
        					}								
				}*/
				
				if(retObjCnt1>=2)
					 session.putValue("LAST_LOGIN_TIMEE",retObj1.getFieldValue(1,"EWS_LOGGED_IN"));
				else if(retObjCnt1==1)	
					session.putValue("LAST_LOGIN_TIMEE",retObj1.getFieldValue(0,"EWS_LOGGED_IN"));
							
			}
			ezc.ezmisc.client.EzMiscManager miscMgr2 = new ezc.ezmisc.client.EzMiscManager();
			ReturnObjFromRetrieve	retObj3 = null;
			int retObjCnt3 = 0;

			ezc.ezparam.EzcParams mainParams_4 = new ezc.ezparam.EzcParams(true);
			ezc.ezmisc.params.EziMiscParams miscParams4 = new ezc.ezmisc.params.EziMiscParams();
			//miscParams4.setQuery("SELECT * FROM EZC_WEB_STATS WHERE EWS_USER_ID = '"+Session.getUserId()+"' and  DATE_FORMAT(EWS_LOGGED_IN, '%Y-%m-%d') =CURDATE() ORDER BY EWS_LOGGED_IN DESC");
			miscParams4.setQuery("SELECT * FROM EZC_WEB_STATS");
			mainParams_4.setObject(miscParams4);	
			Session.prepareParams(mainParams_4);
			try
			{
				retObj3 = (ReturnObjFromRetrieve)miscMgr2.ezSelect(mainParams_4);
			}catch(Exception e){}

			if(retObj3!=null)
				retObjCnt3 = retObj3.getRowCount();

			if(retObjCnt3>0)
			{									
			   session.putValue("LOGIN_COUNT",retObj3.getRowCount());			   
			}
			
			if("4".equals(UserType))
			{
				ezc.ezmisc.client.EzMiscManager miscMgr = new ezc.ezmisc.client.EzMiscManager();
				ReturnObjFromRetrieve	retObj = null;
				int retObjCnt = 0;

				ezc.ezparam.EzcParams mainParams_1 = new ezc.ezparam.EzcParams(true);
				ezc.ezmisc.params.EziMiscParams miscParams = new ezc.ezmisc.params.EziMiscParams();
				miscParams.setQuery("SELECT EUD_KEY,EUD_VALUE FROM EZC_USER_DEFAULTS WHERE EUD_USER_ID = '"+Session.getUserId()+"'");
				mainParams_1.setObject(miscParams);	
				Session.prepareParams(mainParams_1);
				try
				{
					retObj = (ReturnObjFromRetrieve)miscMgr.ezSelect(mainParams_1);
				}catch(Exception e){}
				
				if(retObj!=null)
					retObjCnt = retObj.getRowCount();
					
				if(retObjCnt>0)
				{
					for(int r=0;r<retObjCnt;r++)
					{
						if("ALLOW_RFQ".equals(retObj.getFieldValueString(r,"EUD_KEY")) && "Y".equals(retObj.getFieldValueString(r,"EUD_VALUE")))
							session.putValue("ALLOW_RFQ","Y");
						if("ALLOW_REG".equals(retObj.getFieldValueString(r,"EUD_KEY")) && "Y".equals(retObj.getFieldValueString(r,"EUD_VALUE")))
							session.putValue("ALLOW_REG","Y");	
						if("PP_WF_GRP".equals(retObj.getFieldValueString(r,"EUD_KEY")))
							session.putValue("PP_WF_GRP",retObj.getFieldValueString(r,"EUD_VALUE"));
						if("SOLDTOPARTY".equals(retObj.getFieldValueString(r,"EUD_KEY")))
							session.putValue("SOLDTO",retObj.getFieldValueString(r,"EUD_VALUE"));							
					}
				
				}
			}
			ezc.ezmisc.client.EzMiscManager miscMgr3 = new ezc.ezmisc.client.EzMiscManager();
			ReturnObjFromRetrieve	retObj2 = null;
			int retObjCnt2 = 0;

			ezc.ezparam.EzcParams mainParams_3 = new ezc.ezparam.EzcParams(true);
			ezc.ezmisc.params.EziMiscParams miscParams = new ezc.ezmisc.params.EziMiscParams();
			miscParams.setQuery("select EUD_VALUE from  EZC_USER_DEFAULTS WHERE EUD_USER_ID = '"+Session.getUserId()+"' and EUD_KEY='COMPCODE'");
			mainParams_3.setObject(miscParams);	
			Session.prepareParams(mainParams_3);
			try
			{
				retObj2 = (ReturnObjFromRetrieve)miscMgr3.ezSelect(mainParams_3);
			}catch(Exception e){}

			if(retObj2!=null)
				retObjCnt2 = retObj2.getRowCount();

			if(retObjCnt2>0)
			{
				for(int p=0;p<retObjCnt2;p++)
				{					
						session.putValue("CCode",retObj2.getFieldValueString(p,"EUD_VALUE"));		
				}
									
			}
			
			if("2".equals(UserType))
			{
				ezc.ezparam.ReturnObjFromRetrieve	sh_appr_ValMapRetObj = null;
				ezc.ezparam.EzcParams sh_appr_mParams = new ezc.ezparam.EzcParams(true);
				ezc.valuemap.client.EzValueMapManager sh_appr_ValMapMgr = new ezc.valuemap.client.EzValueMapManager();
				ezc.valuemap.params.EziValueMappingParams sh_appr_valueParams =  new ezc.valuemap.params.EziValueMappingParams();

				sh_appr_valueParams.setMapType("SHIPMENT_APPR");
				sh_appr_valueParams.setValue2(Session.getUserId());

				sh_appr_mParams.setObject(sh_appr_valueParams);	
				Session.prepareParams(sh_appr_mParams);

				try{
					sh_appr_ValMapRetObj = (ezc.ezparam.ReturnObjFromRetrieve)sh_appr_ValMapMgr.ezGetValueMapping(sh_appr_mParams);
				}catch(Exception e){}

				if(sh_appr_ValMapRetObj!=null && sh_appr_ValMapRetObj.getRowCount()>0)
					session.putValue("SHIPMENT_APPR","Y");
			}

			if (UserType.equals("3"))
			{
				redirectfile = "ezDisclaimer.jsp";
			}
			else if (UserType.equals("2"))
			{
				redirectfile = "ezSelectSoldTo.jsp";
			}
			else if (UserType.equals("4"))
			{
				redirectfile = "ezWelcomeTempUser.jsp";
			}
			else
			{
				redirectfile = "ezLoginError.jsp";
			}
		}
		else
			redirectfile = "ezLoginError.jsp";
	}		
	else
		redirectfile = "ezLoginError.jsp";
	ezc.ezcommon.EzLog4j.log(":redirectfile::"+redirectfile,"I");
	
	response.sendRedirect(redirectfile);
%>
<Div id="MenuSol"></Div>
