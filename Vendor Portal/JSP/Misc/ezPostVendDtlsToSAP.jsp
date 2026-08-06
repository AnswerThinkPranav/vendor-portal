<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoDestinationManager" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.ext.DestinationDataProvider" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%>    

<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
	public void createDestinationDataFile(String s, Properties properties)
    {
	File file = new File((new StringBuilder()).append(s).append(".jcoDestination").toString());
	try
	{
	    FileOutputStream fileoutputstream = new FileOutputStream(file, false);
	    properties.store(fileoutputstream, "for tests only !");
	    fileoutputstream.close();
	}
	catch(Exception exception)
	{
	    throw new RuntimeException("Unable to create the destination files", exception);
	}
    }
%>
  <%@ include file="ezHeader.jsp"%> 

<%
	String venName = checkNull(request.getParameter("venName"));
	String dispMessage="Problem occured while posting vendor details to SAP.",dispMsgType="E",divWidth="90%";
	boolean errorOccured = false;
	
	String comments  	 = checkNull(request.getParameter("comments"));
	
	comments=comments.replaceAll("'","`");

	String SAPUserId	= checkNull(request.getParameter("SAPUSER")); 	
	String SAPPassword      = checkNull(request.getParameter("SAPPASSWORD")); 
	
	ezc.ezcommon.EzLog4j.log(SAPUserId+":::::::::SAPUserId:::::::::","I");
	ezc.ezcommon.EzLog4j.log(SAPPassword+"::::::::SAPPassword::::::::","I");
	
	String vendorProfileId= checkNull(request.getParameter("docId")); 	
	String docSysKey= checkNull(request.getParameter("docSysKey"));
	String defSoldTo    = checkNull(request.getParameter("defSoldTo")); 	
	String titleSel	    = checkNull(request.getParameter("titleSel")); 		
	String addr1	    = checkNull(request.getParameter("addr1")); 		
	String addr2	    = checkNull(request.getParameter("addr2")); 		
	String street	    = checkNull(request.getParameter("street")); 		
	String city	    = checkNull(request.getParameter("city")); 		
	String district	    = checkNull(request.getParameter("district")); 		
	String pin	    = checkNull(request.getParameter("pin")); 		
	String landline	    = checkNull(request.getParameter("landline")); 		
	String mobile	    = checkNull(request.getParameter("mobile")); 		
	String fax	    = checkNull(request.getParameter("fax")); 		
	String email	    = checkNull(request.getParameter("email")); 
	String email2 	= checkNull(request.getParameter("email2"));
	String contPers1= checkNull(request.getParameter("contPers1"));
	String contPers2= checkNull(request.getParameter("contPers2"));
	
	String vat	    = checkNull(request.getParameter("vat")); 		
	String gst	    = checkNull(request.getParameter("gst"));
	String classi	    = checkNull(request.getParameter("classi"));
	//String classification 	= checkNull(request.getParameter("classification"));
	String cst	    = checkNull(request.getParameter("cst")); 		
	String pan	    = checkNull(request.getParameter("pan")); 		
	String servTax	    = checkNull(request.getParameter("servTax")); 		
	String eccNo	    = checkNull(request.getParameter("eccNo")); 		
	String excRegNo	    = checkNull(request.getParameter("excRegNo")); 		
	String rangeSel	    = checkNull(request.getParameter("rangeSel")); 		
	String exDiv	    = checkNull(request.getParameter("exDiv")); 		
	String commi	    = checkNull(request.getParameter("commi")); 		
	String cDate	    = checkNull(request.getParameter("cDate")); 		
	String minIndi	    = checkNull(request.getParameter("minIndi")); 		//on hold
out.println(contPers1+"::::::"+contPers2+"::::::::::::::::::"+cDate+":::::::::::"+classi);
	String bankCountry[]  = request.getParameterValues("bankCountry");
	String bankKey[]      = request.getParameterValues("bankKey");
	String bankIndex[]    = request.getParameterValues("bankIndex");
      /*String bankName[]     = request.getParameterValues("bankName");
	String bankRegion[]   = request.getParameterValues("bankRegion");
	String bankStreet[]   = request.getParameterValues("bankStreet");
	String bankCity[]	    = request.getParameterValues("bankCity");
	String bankBranch[]   = request.getParameterValues("bankBranch");
	String bankIFSCCode[] = request.getParameterValues("bankIFSCCode");*/
	String bankACCode[]   = request.getParameterValues("bankACCode");
	String pTerms	    = checkNull(request.getParameter("pTerms"));	//on hold
	String paymMethod   = checkNull(request.getParameter("paymMethod"));	//on hold
	String creatDate    = checkNull(request.getParameter("creatDate"));	//on hold
	String houseBank    = checkNull(request.getParameter("houseBank"));	//on hold
	String schemaGroup   = "Z1";//checkNull(request.getParameter("schemaGroup"));	//on hold

	java.util.Hashtable openIBDItemsHT = new java.util.Hashtable();
JCO.Client client1=null;
JCO.Function function = null;
	try
	{
			ReturnObjFromRetrieve retuser_groups	=  null;
			int   user_groupsCnt	=  0;
			ezc.ezparam.EzcParams mainParams_user_groups	= new ezc.ezparam.EzcParams(false);
			EziMiscParams miscParams_user_groups = new EziMiscParams();
			miscParams_user_groups.setQuery("Select * From Ezc_User_Groups Where Eug_Id='999'");
			mainParams_user_groups.setLocalStore("Y");
			mainParams_user_groups.setObject(miscParams_user_groups);
			Session.prepareParams(mainParams_user_groups);
	
			try
			{
				retuser_groups=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_user_groups);
			}
			catch(Exception e)
			{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
			if(retuser_groups!=null)
			user_groupsCnt=retuser_groups.getRowCount();
			
			String eugID 	= retuser_groups.getFieldValueString(0,"EUG_ID");
			String hostIP 	= retuser_groups.getFieldValueString(0,"EUG_R3_HOST");
			String r3Lang 	= retuser_groups.getFieldValueString(0,"EUG_R3_LANG");
			String r3Client = retuser_groups.getFieldValueString(0,"EUG_R3_CLIENT");
			String r3Userid = retuser_groups.getFieldValueString(0,"EUG_R3_USER_ID");
			String r3Passwd = retuser_groups.getFieldValueString(0,"EUG_R3_PASSWD");
			String r3SysNo = retuser_groups.getFieldValueString(0,"EUG_R3_SYS_NO");
		//JCoDestination destination = EzSAPHandler.getDestination("200~999");
		//JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_UPDATE");

		/*Properties connectProperties = new Properties();
		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, "172.26.2.61");
\		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, "00");
		connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, "777");
		connectProperties.setProperty(DestinationDataProvider.JCO_USER, SAPUserId);
		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, SAPPassword);
		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, "EN");
		
        		
		createDestinationDataFile("DESTINATION", connectProperties);
		JCoDestination destination = JCoDestinationManager.getDestination("DESTINATION");
                
		 JCoFunction function = destination.getRepository().getFunction("Z_EZ_GET_VENDOR_UPDATE");*/
        
		//client1 = EzSAPHandler.getSAPConnection("200~999");
		//function = EzSAPHandler.getFunction("Z_EZ_GET_VENDOR_UPDATE","200~999");
		
		
		client1 = JCO.createClient(r3Client, 		// SAP client
					SAPUserId, 	// userid
					SAPPassword, 	// password
					r3Lang, 		
					hostIP,    
					r3SysNo);



			client1.connect();
			JCO.Repository mRepository = new JCO.Repository("REP123", client1);

			function = new JCO.Function((mRepository).getFunctionTemplate("Z_EZ_GET_VENDOR_UPDATE"));
		
		
		JCO.ParameterList impParam = function.getImportParameterList();
		
		JCO.Table vendDataTable  	= function.getTableParameterList().getTable("VENDOR_DATA");	      
		JCO.Table statutaryTable  	= function.getTableParameterList().getTable("STATUTARY_DATA");	      
		JCO.Table contactInfoTable  	= function.getTableParameterList().getTable("CONTACT_INFO");	      
		JCO.Table vendBanksTable  	= function.getTableParameterList().getTable("VENDOR_BANKS");	      
		JCO.Table bankAddressTable  	= function.getTableParameterList().getTable("BANK_ADDRESS");
		JCO.Table vendEmailsTable  	= function.getTableParameterList().getTable("VEND_EMAILS");	      

		ezc.ezcommon.EzLog4j.log(defSoldTo+"::::::::VENDOR::::::::","I");
		
		
		impParam.setValue(defSoldTo,"VENDOR");
		impParam.setValue("CFL","COMPCODE");	
		
		vendDataTable.appendRow();
		if(!"".equals(titleSel))
		vendDataTable.setValue(titleSel,"ANRED");
		if(!"".equals(addr1))
		vendDataTable.setValue(addr1,"NAME3");
		if(!"".equals(addr2))
		vendDataTable.setValue(addr2,"NAME4");
		if(!"".equals(street))
		vendDataTable.setValue(street,"STRAS");
		if(!"".equals(city))
		vendDataTable.setValue(city,"ORT01");
		if(!"".equals(district))
		vendDataTable.setValue(district,"ORT02");
		if(!"".equals(pin))
		vendDataTable.setValue(pin,"PSTLZ");
		if(!"".equals(landline))
		vendDataTable.setValue(landline,"TELF1");
		if(!"".equals(mobile))
		vendDataTable.setValue(mobile,"TELF2");
		if(!"".equals(fax))
		vendDataTable.setValue(fax,"TELFX");
		if(!"".equals(gst))
		vendDataTable.setValue(gst,"STCD3"); 
		//if(!"".equals(vat))
		//vendDataTable.setValue(vat,"STCEG");
		
		ezc.ezcommon.EzLog4j.log(vendDataTable+"::::::::vendDataTable::::::::","I");
					
		
		if(!"".equals(contPers1))
		{
		contactInfoTable.appendRow();
		contactInfoTable.setValue(contPers1,"NAMEV");					
		contactInfoTable.setValue(contPers1,"NAME1");
		if(!"".equals(landline))
		contactInfoTable.setValue(landline,"TELF1");
		}
		if(!"".equals(contPers2))
		{
		contactInfoTable.appendRow();
		contactInfoTable.setValue(contPers2,"NAMEV");					
		contactInfoTable.setValue(contPers2,"NAME1");
		if(!"".equals(landline))
		contactInfoTable.setValue(landline,"TELF1");
		} 
		if("".equals(contPers1) && "".equals(contPers2)&& !"".equals(landline))
		{
			contactInfoTable.appendRow();
			contactInfoTable.setValue(landline,"TELF1");
		}
		
		ezc.ezcommon.EzLog4j.log(contactInfoTable+"::::::::contactInfoTable::::::::","I");
		
		
		vendEmailsTable.appendRow();
		if(!"".equals(email))
		vendEmailsTable.setValue(email,"SMTP_ADDR");
		
		if(!"".equals(email2))
		{
			vendEmailsTable.appendRow();
			vendEmailsTable.setValue(email2,"SMTP_ADDR");				
		}
		ezc.ezcommon.EzLog4j.log(vendEmailsTable+"::::::::vendEmailsTable::::::::","I");
		
		statutaryTable.appendRow();
		//if(!"".equals(cst))
		//statutaryTable.setValue(cst,"J_1ICSTNO");
		if(!"".equals(pan))
		statutaryTable.setValue(pan,"J_1IPANNO");
		if(!"".equals(servTax))
		statutaryTable.setValue(servTax,"J_1ISERN");
		if(!"".equals(eccNo))
		statutaryTable.setValue(eccNo,"J_1IEXCD");
		if(!"".equals(excRegNo))
		statutaryTable.setValue(excRegNo,"J_1IEXRN");
		if(!"".equals(rangeSel))
		statutaryTable.setValue(rangeSel,"J_1IEXRG");
		if(!"".equals(exDiv))
		statutaryTable.setValue(exDiv,"J_1IEXDI");
		if(!"".equals(commi))
		statutaryTable.setValue(commi,"J_1IEXCO");
		if(!"".equals(classi))
		statutaryTable.setValue(Integer.parseInt(classi)+"","VEN_CLASS");
		
		ezc.ezcommon.EzLog4j.log(statutaryTable+"::::::::statutaryTable::::::::","I");
		
		if((bankIndex!=null))
		{
			for(int k=0;k<bankIndex.length;k++)
			{
			ezc.ezcommon.EzLog4j.log(bankKey.length+"::::::::bankKey::::::::"+bankKey[k],"I");
				
				//if ((bankACCode[k]==null)||(bankACCode[k].equals("")))
				//continue;
				String bankName     = checkNull(request.getParameter("bankName"+bankKey[k]+bankACCode[k]));				
				String bankRegion   = checkNull(request.getParameter("bankRegion"+bankKey[k]+bankACCode[k]));				
				String bankStreet   = checkNull(request.getParameter("bankStreet"+bankKey[k]+bankACCode[k]));				
				String bankCity     = checkNull(request.getParameter("bankCity"+bankKey[k]+bankACCode[k]));				
				String bankBranch   = checkNull(request.getParameter("bankBranch"+bankKey[k]+bankACCode[k]));				
				String bankIFSCCode = checkNull(request.getParameter("bankIFSCCode"+bankKey[k]+bankACCode[k]));				
				
				
				
				bankAddressTable.appendRow();
				try{
				if(bankCountry!=null)
				bankAddressTable.setValue(bankCountry[k],"BANKS");
				}catch(Exception e){}
				try{
				if(!"".equals(bankName))
				bankAddressTable.setValue(bankName,"BANKA");
				}catch(Exception e){}
				try{
				if(!"".equals(bankRegion))
				bankAddressTable.setValue(bankRegion,"PROVZ");
				}catch(Exception e){}
				if(!"".equals(bankStreet))
				bankAddressTable.setValue(bankStreet,"STRAS");
				if(!"".equals(bankCity))
				bankAddressTable.setValue(bankCity,"ORT01"); 
			/*	if(bankStreet!=null)
				bankAddressTable.setValue("STRAS",bankStreet);
				if(bankCity!=null)
				bankAddressTable.setValue("ORT01",bankCity);     hold*/ 
				try{
				if(!"".equals(bankBranch))
				bankAddressTable.setValue(bankBranch,"BRNCH");
				}catch(Exception e){}
				try{
				if(!"".equals(bankIFSCCode))
				bankAddressTable.setValue(bankIFSCCode,"SWIFT");
				}catch(Exception e){}
				try{
				if(bankKey!=null)
				bankAddressTable.setValue(bankKey[k],"BANKL");
				}catch(Exception e){}
				try{
				if(bankACCode!=null)
				bankAddressTable.setValue(bankACCode[k],"BNKLZ");
				}catch(Exception e){}
				
				vendBanksTable.appendRow();
				if(bankACCode!=null)
				{
					try{
					vendBanksTable.setValue(bankACCode[k],"BANKN");
					}catch(Exception e){}
					try{
					vendBanksTable.setValue(bankIndex[k],"BKONT");
					}catch(Exception e){}
					try{
						vendBanksTable.setValue(bankCountry[k],"BANKS");
					}catch(Exception e){}
					try{
						vendBanksTable.setValue(bankKey[k],"BANKL");
					}catch(Exception e){}
				}
			}
		}
		
		ezc.ezcommon.EzLog4j.log("::::::bankAddressTable:::::::::"+bankAddressTable,"I");
		ezc.ezcommon.EzLog4j.log("::::::vendBanksTable:::::::::"+vendBanksTable,"I");
		//out.println("<br>"+vendBanksTable);

		try
		{
			//function.execute(destination);
			
			client1.execute(function);
		}
		catch(Exception e)
		{
			 errorOccured = true;
			ezc.ezcommon.EzLog4j.log("::::::Exception while executing Z_EZ_GET_VENDOR_UPDATE::::::"+e,"E");
		}
			
		JCO.Table retTable  = function.getTableParameterList().getTable("RETURN");	      	
		int retCount         = retTable.getNumRows();				
		ezc.ezcommon.EzLog4j.log("::::::retTable:::::::::"+retTable,"I");
		if(retCount > 0)
		{
		int i=0;
			do
			{
				
				String  msgType       =  (String)retTable.getValue("TYPE");
				String  msgStr       =  (String)retTable.getValue("MESSAGE");
				
				if("E".equals(msgType) || "A".equals(msgType))
				{
				i=i+1;
				 errorOccured = true;
				 if(i==1)dispMessage=dispMessage+"<br>";
				dispMessage=dispMessage+"<br><b>"+i+")"+msgStr+"</b>";
				
				}
				
			}						 
			while(retTable.nextRow());			 
		}

	}
	catch(Exception e){
		 errorOccured = true;
		ezc.ezcommon.EzLog4j.log("::::::Exception in Z_EZ_GET_VENDOR_UPDATE::::::"+e,"E");
	}finally
	{
		if (client1!=null)
		{
			JCO.releaseClient(client1);
			client1 = null;
			function=null;

		}
	}
	
	if(!errorOccured)
	{
		dispMessage="Vendor <b>"+Integer.parseInt(defSoldTo)+"</b> changes have been posted successfully to SAP";
		//Request <b>"+vendorProfileId+"</b> has been <b>Posted to SAP</b>
		dispMsgType="S";
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
		EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();

		keyParams.setKey("UpdateRequestStatus");
		keyTableParams.appendRow(keyParams);
		mainParams.setLocalStore("Y");

		generalParams.setDocId(vendorProfileId);
		generalParams.setModifiedBy(Session.getUserId());
		generalParams.setVendor(Integer.parseInt(defSoldTo)+"");
		generalParams.setStatus("CLOSED");
		generalParams.setExt1("");

		mainParams.setObject(keyTableParams);	

		mainParams.setObject(generalParams);
		Session.prepareParams(mainParams);

		try{
		 vendorprofile.ezUpdateDetails(mainParams);
		 	
		}catch(Exception e){out.println(e);}
		String template="";
		EzcSysConfigParams sparams2 = new EzcSysConfigParams();
		EzcSysConfigNKParams snkparams2 = new EzcSysConfigNKParams();
		snkparams2.setLanguage("EN");
		snkparams2.setSystemKey(docSysKey);
		snkparams2.setSiteNumber(200);
		sparams2.setObject(snkparams2);
		Session.prepareParams(sparams2);
		ReturnObjFromRetrieve retTemplate = (ReturnObjFromRetrieve)ConfigManager.getCatAreaDefaults(sparams2);
		int retcnt=retTemplate.getRowCount();
		for(int z=0;z<retcnt;z++)
		{
			if("WFTEMPLATE".equals((retTemplate.getFieldValueString(z,"ECAD_KEY")).toUpperCase()))
			{
				template = retTemplate.getFieldValueString(z,"ECAD_VALUE");
				break;
			}

		}		
		
		ReturnObjFromRetrieve rettempUser=null;
		int rettempUserCnt=0;
		
		mainParams	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();
		miscParams.setQuery("Select * from (SELECT EWW_ROLE_NO ROLE, EWOD_PARTICIPANT OWNERPARTICIPANT, EWOD_PARTICIPANT_TYPE OPTYPE, EWOD_PARENT PARENT,ESKD_SYS_KEY SYSKEY, ECAD_VALUE PURCHGRP, EWOD_LEVEL STEP,EWWU_USER USER_ID FROM EZC_WF_ORGONAGRAM_DETAILS,EZC_WF_ORGONAGRAM,EZC_WF_WORKGROUPS,EZC_WF_WORKGROUP_USERS, EZC_SYSTEM_KEY_DESC, EZC_CAT_AREA_DEFAULTS WHERE EWO_CODE=EWOD_CODE AND EWO_TEMPLATE IN ('"+template+"') AND EWWU_GROUP=EWOD_PARTICIPANT  AND ESKD_SYS_KEY=ECAD_SYS_KEY AND ECAD_KEY='PURGROUP' AND EWWU_SYSKEY=ESKD_SYS_KEY AND EWW_GROUP=EWWU_GROUP AND ESKD_SYS_KEY IN ('"+docSysKey+"')  and EWWU_USER='"+Integer.parseInt(defSoldTo)+"' ORDER BY CAST(EWOD_LEVEL AS UNSIGNED))a");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		try
		{
			rettempUser=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");}
		String userGroupKey="";
		String checkRole = "";
		if(rettempUser!=null)
		{
			rettempUserCnt	= rettempUser.getRowCount();
			userGroupKey=checkNull(rettempUser.getFieldValueString(0,"OWNERPARTICIPANT"));
			checkRole=checkNull(rettempUser.getFieldValueString(0,"ROLE"));
		}
		
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
		miscParams.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_WF_STATUS='POSTEDTOSAP', EWDHH_MODIFIED_BY='"+Session.getUserId()+"', EWDHH_MODIFIED_ON=now(), EWDHH_CURRENT_STEP='1',EWDHH_NEXT_PARTICIPANT='"+userGroupKey+"',EWDHH_PARTICIPANT_TYPE='G',EWDHH_REF1='NO-CHANGE',EWDHH_REF2=CONCAT(EWDHH_REF2,'-->"+Session.getUserId()+"'),EWDHH_NEXT_D_PARTICIPANT='-',EWDHH_D_PARTICIPANT_TYPE='-'   WHERE EWDHH_AUTH_KEY IN ('VENDOR_PROFILE')  AND EWDHH_DOC_ID ='"+vendorProfileId+"' ");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);

		try
		{
			miscManager.ezUpdate(mainParams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}

		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_DOCUMENT_COMMENTS");
		mainParams.setLocalStore("Y");

		documentComments.setDocId(vendorProfileId);
		documentComments.setDocType("VEND_PROFILE");
		documentComments.setComments(comments);
		documentComments.setUserId((String)Session.getUserId());
		documentComments.setExt1("");
		documentComments.setExt2("");
		documentComments.setExt3("");

		mainParams.setObject(keyParams);	
		mainParams.setObject(documentComments);
		Session.prepareParams(mainParams);

		try{
			ezc.ezcommon.EzLog4j.log(":::::Before save documentComments:::::","I");
			vendorprofile.ezSaveDetails(mainParams);
			ezc.ezcommon.EzLog4j.log(":::::After save documentComments:::::","I");
		}catch(Exception e){}
		
		
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFAuditTrailParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_AUDIT_TRAIL");
		mainParams.setLocalStore("Y");

		eziWFAuditTrailParams.setEwhAuditTrailNo("1");
		eziWFAuditTrailParams.setEwhDocId(vendorProfileId);
		eziWFAuditTrailParams.setEwhType("POSTEDTOSAP");
		eziWFAuditTrailParams.setEwhSourceParticipant((String)Session.getUserId());
		eziWFAuditTrailParams.setEwhSourceParticipantType("U");
		eziWFAuditTrailParams.setEwhDestParticipant(Integer.parseInt(defSoldTo)+"");
		eziWFAuditTrailParams.setEwhDestParticipantType("U");
		eziWFAuditTrailParams.setEwhComments("Request "+vendorProfileId+" has been Posted to SAP.");

		mainParams.setObject(keyParams);	
		mainParams.setObject(eziWFAuditTrailParams);
		Session.prepareParams(mainParams);

		try{

			vendorprofile.ezSaveDetails(mainParams);
		}catch(Exception e){}
		
		String sendToUser= (String)Session.getUserId()+","+Integer.parseInt(defSoldTo);

		//String msgSubject = venName+" changed profile posted to SAP";
		String msgSubject = "Vendor Profile change posted to SAP (Request number "+vendorProfileId+")";
		String msgText = "Dear Sir/Madam,<br><br> Vendor profile request "+vendorProfileId+" has been posted to SAP.&nbsp;<br>";
		msgText = msgText+"<BR>";
		msgText += "Regards,<br>"+v_fname+v_mname+v_lname;
		
		
		String inboxPath="";
	 	
		
%>	
	<%//@ include file="../Purorder/ezSendMail.jsp" %>		
<%	
	}
%>
<Html>
<Head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<style>
.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
</style>
<script>
function funOk()
{
	document.myForm.action="../Misc/ezVendorRequests.jsp?Status=OPEN&WFStatus=APPROVED";
	document.myForm.submit();
}
</script>    
</Head>

  <!-- Content Wrapper. Contains page content -->
        <Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Vendor Profile
            </h4>
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	<Body>          
        <form method="post"  name="myForm">
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
	<!--<Div class="row">
		<Div class=" col-md-12 col-sm-12 col-xs-12"> 
			<Div class="box box-info collapsed-box" >
				<Div class="box-body" style="display: block;" styel="height:20%">
				<br>
				<center><b><%=dispMessage%></b><center>
				</Div>
			</Div>
		</Div>
	</Div> -->        		
<div class="row">		
		<Div class="col-xs-12 col-md-6 col-md-offset-6" >
		
			<button type="button" class="btn btn-primary" onclick="funOk()">Ok</button>
		
		</div>
	</div>	
		
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      	
