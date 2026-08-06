<%@ page import="java.util.*,ezc.ezworkflow.params.*,ezc.ezparam.*"%>
<%@ include file="../Misc/iblockcontrol.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />


<%!
	final String SYSTEM_KEY 		= "ESKD_SYS_KEY";
	final String SYSTEM_KEY_DESC_LANGUAGE 	= "ESKD_LANG";
	final String SYSTEM_KEY_DESCRIPTION 	= "ESKD_SYS_KEY_DESC";
	final String ERP_CUST_NAME 		= "ECA_NAME";
	final String ERP_CUST_NUM 		= "EC_ERP_CUST_NO";
%>

<%
	ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager PasswordManager = new ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager();
	ezc.ezparam.EzcParams mainPwdParams = new ezc.ezparam.EzcParams(false);
	ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams admUtilParams = new  ezc.ezadmin.ezadminutils.params.EziAdminUtilsParams();
	admUtilParams.setUserId("'"+Session.getUserId()+"'");
	mainPwdParams.setObject(admUtilParams);
	Session.prepareParams(mainPwdParams);
	ezc.ezparam.ReturnObjFromRetrieve pwdChgRet =(ezc.ezparam.ReturnObjFromRetrieve)PasswordManager.getPasswordPolicy(mainPwdParams);
	int pwdChgRetCnt = 0;
	if(pwdChgRet!=null) 
		pwdChgRetCnt = pwdChgRet.getRowCount();
	//if(pwdChgRetCnt==0)
		//response.sendRedirect("ezPassword.jsp?Flag=X");

	if(pwdChgRetCnt>0)
	{
		Date curDate = new Date();
		Date chngdDate = (Date)pwdChgRet.getFieldValue(0,"EPM_PWD_CHANGED_ON"); 
		ezc.ezcommon.EzLog4j.log(":curDate::"+curDate.getTime(),"I");
		ezc.ezcommon.EzLog4j.log(":chngdDate::"+chngdDate.getTime(),"I");
		
		ezc.ezcommon.EzLog4j.log("curr:Days::"+curDate.getTime()/(24 * 60 * 60 * 1000),"I");
		ezc.ezcommon.EzLog4j.log("chngdDate:Days::"+chngdDate.getTime()/(24 * 60 * 60 * 1000),"I");
		int Days = (int)((curDate.getTime()/(24 * 60 * 60 * 1000)) - (chngdDate.getTime()/(24 * 60 * 60 * 1000)));  
		ezc.ezcommon.EzLog4j.log(":Days::"+Days,"I");
		
		String numDays = Days+"";
		session.putValue("PWDDAYS",numDays);
		
		//if(Days >= 90)
			//response.sendRedirect("ezPassword.jsp?updtFlag=U");
	}
%>

<%
	String userType = (String)session.getValue("UserType");
	String userRole = (String)session.getValue("USERROLE");
	
	String userGroup	= "";
	String role		= "";
	String catalog_area 	= "";
	String template		= "";
	String purLoc		= "";
	String soldToInStr	= "";
	int retcnt	= 0;	
	int soldtoRows 	= 0;
	
	java.util.Vector loginUsrSoldtos	= new java.util.Vector();
	java.util.Vector catAreas 		= new java.util.Vector(10,5);
	java.util.Hashtable purgrphash		= new java.util.Hashtable();
	java.util.Hashtable ccHash		= new java.util.Hashtable();
	java.util.Hashtable ctHash		= new java.util.Hashtable();
	java.util.Hashtable templatehash	= new java.util.Hashtable();
	java.util.Hashtable purlochash		= new java.util.Hashtable();
	java.util.Hashtable vendorsHT 		= new java.util.Hashtable();	
	java.util.Hashtable vendCityHT 		= new java.util.Hashtable();	
	java.util.Hashtable purOrgHash 		= new java.util.Hashtable();

	//out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>SessionSessionSession		"+(String)Session.getUserId());
	ezc.ezparam.ReturnObjFromRetrieve retsoldto=null;
	ezc.client.EzcPurchaseUtilManager PurManager = new ezc.client.EzcPurchaseUtilManager(Session);
	ReturnObjFromRetrieve retcatarea = null;
	synchronized(this){
		retcatarea=(ReturnObjFromRetrieve)PurManager.getUserPurAreas();
		//out.println("catareaRowscatareaRowscatareaRows	"+retcatarea.toEzcString());
		//ezc.ezcommon.EzLog4j.log("atareaRowscatareaRowscatareaRowsNDS>>"+retcatarea.toEzcString(),"I");
	}	
	int catareaRows = retcatarea.getRowCount(); 
		
	if(catareaRows>0)
	{
		if(!userType.equals("3"))
		{
			String s[]={SYSTEM_KEY};
			boolean b=retcatarea.sort(s,true);
		}
		else
		{
			String s[]={SYSTEM_KEY_DESCRIPTION};
			boolean b=retcatarea.sort(s,true);
		}
	}
	
	ezc.client.EzSystemConfigManager ConfigManager = new ezc.client.EzSystemConfigManager();
	catalog_area = (String)retcatarea.getFieldValue(0,SYSTEM_KEY);

	
	if("3".equals(userType))
		retsoldto = (ReturnObjFromRetrieve)PurManager.getUserVendors(catalog_area);	
	
	if(retsoldto!=null)
		soldtoRows=retsoldto.getRowCount();


	for(int i=0;i<soldtoRows;i++)
	{
		String tempSoldto=(retsoldto.getFieldValueString(i,"EC_ERP_CUST_NO")).trim();
		loginUsrSoldtos.add(tempSoldto);
		if(i==0)
			soldToInStr=tempSoldto;
		else
			soldToInStr+="','"+tempSoldto;
	}	
	
	

	if(soldtoRows > 0)
	{
		for(int v=0;v<soldtoRows;v++)
		{
			if(retsoldto.getFieldValueString(v,"EC_ERP_CUST_NO") != null)
				vendorsHT.put(retsoldto.getFieldValueString(v,"EC_ERP_CUST_NO").trim(),retsoldto.getFieldValue(v,"ECA_NAME"));
			
		}	
		session.putValue("VENDORHT",vendorsHT);
	}

	session.putValue("SOLDTOVECT",loginUsrSoldtos); // Vector for getting all vendors which are synchronized
	session.putValue("SOLDTOS",soldToInStr);	// SoldTos String in the query format with single quotes 
		
	if(soldtoRows>0)
	{
		retsoldto.sort(new String[]{ERP_CUST_NAME},true);
	}
	
	
	
	if(retcatarea!=null)
	{
		String catAreaTemp=null;
		String prgGrpTemp=null;
		String templateTemp=null;
		String ccodeTemp=null;
		String countryTemp=null;
		String purLocTemp=null;
		String purorg=null;
		String userPurAreasStr = "";
		String userWfGroupsStr = "";
		String userPurOrgsStr  = "";
		
		for(int c=0;c<retcatarea.getRowCount();c++)
		{
			if("3".equals(userType))
				catAreaTemp=retcatarea.getFieldValueString(c,"ESKD_SYS_KEY");
			else
				catAreaTemp=retcatarea.getFieldValueString(c,"EBPA_SYS_KEY");
			catAreas.addElement(catAreaTemp); 
			
			if(c==0)
				userPurAreasStr = catAreaTemp;
			else
				userPurAreasStr += "','"+catAreaTemp;
			
			
			
			ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
			ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
			ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
			snkparams1.setLanguage("EN");
			snkparams1.setSystemKey(catAreaTemp);
			snkparams1.setSiteNumber(200);
			sparams1.setObject(snkparams1);
			Session.prepareParams(sparams1);
			ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);
			ezc.ezcommon.EzLog4j.log("retdef>>"+retdef.toEzcString(),"I");
			if(retdef != null)
			{
				int defsCount = 0;
				defsCount = retdef.getRowCount();
				for(int i=0;i<defsCount;i++)
				{
					if("PURGROUP".equals(retdef.getFieldValueString(i,"ECAD_KEY")))
					{
						prgGrpTemp = retdef.getFieldValueString(i,"ECAD_VALUE");
						
						purgrphash.put(catAreaTemp,prgGrpTemp);
						
					}
					else if("PURORG".equals(retdef.getFieldValueString(i,"ECAD_KEY")))
					{
						purorg = retdef.getFieldValueString(i,"ECAD_VALUE");
						if(purorg!=null && !"".equals(purorg))
						{
							purOrgHash.put(catAreaTemp,purorg);		

							if(c==0)
							{
								userWfGroupsStr = purorg+"_"+userRole;
								userPurOrgsStr = purorg;
							}	
							else
							{
								userWfGroupsStr += "','"+purorg+"_"+userRole;
								userPurOrgsStr  += "','"+purorg;
							}	
						}
						
					}
					else if("WFTEMPLATE".equals((retdef.getFieldValueString(i,"ECAD_KEY")).toUpperCase()))
					{
						templateTemp = retdef.getFieldValueString(i,"ECAD_VALUE");
						templatehash.put(catAreaTemp,templateTemp);
					}
					else if("COMPCODE".equals((retdef.getFieldValueString(i,"ECAD_KEY")).toUpperCase()))
					{
						ccodeTemp = retdef.getFieldValueString(i,"ECAD_VALUE");
						ccHash.put(catAreaTemp,ccodeTemp);
					}
					else if("COUNTRY".equals((retdef.getFieldValueString(i,"ECAD_KEY")).toUpperCase()))
					{
						countryTemp = retdef.getFieldValueString(i,"ECAD_VALUE");
						ctHash.put(catAreaTemp,countryTemp);
					}					
				}
			}
			
		}
		//out.println("ISELECT	soldtoRowssoldtoRowssoldtoRowssoldtoRows	"+soldtoRows);
		/***********To speed up the process in login banner**************************/
		session.putValue("CATAREAS",catAreas);
		session.putValue("PURGROUPS",purgrphash);
		session.putValue("TEMPLATES",templatehash);
		session.putValue("PURLOCS",purlochash);
		session.putValue("COMP_CODE",ccHash);
		session.putValue("USER_COUNTRY",ctHash);
		session.putValue("PURORGS",purOrgHash);
		session.putValue("RETCATAREA",retcatarea);
		session.putValue("PURORG",purorg);
		session.putValue("DRL_COMPCODE",ccodeTemp);
		session.putValue("USER_SYSKEYS",userPurAreasStr);
		session.putValue("USER_WF_GROUPS",userWfGroupsStr);
		session.putValue("USER_PUR_ORGS",userPurOrgsStr);
		
		/****************************************************************************/
	}
	
	/*******To get Pricing WorkFlow Level**********/
%>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	ReturnObjFromRetrieve getWFLevel = null;
	String pricingWFlevel = "";
	String currSysKey = (String) session.getValue("SYSKEY");
	String loggedUser = (String)Session.getUserId();

	ezc.ezmisc.client.EzMiscManager ezMiscManager = new ezc.ezmisc.client.EzMiscManager();
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();


	/*****Vendor Reg WorkFlow***********/

	ReturnObjFromRetrieve getVendWFLevel = null;
	String vendWFlevel = "";

	ezc.ezmisc.client.EzMiscManager ezMiscManager1 = new ezc.ezmisc.client.EzMiscManager();
	mainParams = new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT EVRAF_LEVEL,EVRAF_USER_ID FROM EZC_VENDOR_REG_APPROVAL_FLOW WHERE EVRAF_SYSKEY='"+catalog_area+"' AND EVRAF_USER_ID='"+loggedUser+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		ezc.ezcommon.EzLog4j.log("Before>EZC_VENDORAPPROVAL_FLOW ezvendorenterpricemenu.jsp>>","I");
		getVendWFLevel = (ReturnObjFromRetrieve)ezMiscManager1.ezSelect(mainParams);
		ezc.ezcommon.EzLog4j.log("After::>EZC_VENDORAPPROVAL_FLOW ezvendorenterpricemenu.jsp>>","I");
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception occured while getting getVendWFLevel::"+e,"I");
	} 

	if(getVendWFLevel!=null && getVendWFLevel.getRowCount()>0)
	{
		vendWFlevel = getVendWFLevel.getFieldValueString(0,"EVRAF_LEVEL");
		session.putValue("VENDWFLEVEL",vendWFlevel);
	}
	/*****Vendor Reg WorkFlow***********/
	
	
%>
<%@ include file="../Misc/ireleasecontrol.jsp" %>
