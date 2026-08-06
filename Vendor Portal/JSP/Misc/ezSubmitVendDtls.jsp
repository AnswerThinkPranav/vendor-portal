<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*,com.sap.mw.jco.*" %>
<%@ page import = "ezc.ezparam.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>

<%@ include file="ezGetUserAuthDefaults.jsp"%> 

 
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>
  <%@ include file="ezHeader.jsp"%> 

<%
	String srcPath="",destinationPath="";

	try
	{
	ResourceBundle site1= ResourceBundle.getBundle("Site");
	srcPath=site1.getString("UPLOADTEMPDIR");
	destinationPath=site1.getString("SERVERUPLOADPATH");
	
	}
	catch(Exception e) 
	{ 
	ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
	}
	String vendType  	 = checkNull(request.getParameter("vendType"));
		String userGroupKey="";
		String checkRole = "";
		ezc.ezparam.ReturnObjFromRetrieve retPoWorkFlow = null;
	//String displayMsg="Problem occured while posting vendor details to SAP.";
	String vendorName = checkNull(request.getParameter("venName"));
	String dispMessage="Problem occured while submitting the request",dispMsgType="E",divWidth="90%";
	boolean errorOccured = false;
	String SystemKey= checkNull(request.getParameter("docSysKey"));
	String userId = (String)Session.getUserId();
	String vendorProfileId= checkNull(request.getParameter("docId")); 	
	String comments  	 = checkNull(request.getParameter("comments"));
	String defSoldTo    = checkNull(request.getParameter("defSoldTo")); 
	if("".equals(defSoldTo))defSoldTo="0";
	String docStatus    = checkNull(request.getParameter("docStatus")); 
	String template="";
	
	comments=comments.replaceAll("'","`");


		EzcSysConfigParams sparams2 = new EzcSysConfigParams();
		EzcSysConfigNKParams snkparams2 = new EzcSysConfigNKParams();
		snkparams2.setLanguage("EN");
		snkparams2.setSystemKey(SystemKey);
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

	ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
	ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
	ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	snkparams1.setSystemKey(SystemKey);
	snkparams1.setSiteNumber(200);
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);
	String myPurOrg="";
	
	if(retdef!=null){
		for(int d=0;d<retdef.getRowCount();d++){
			if("PURORG".equals(retdef.getFieldValueString(d,"ECAD_KEY"))){
				myPurOrg=retdef.getFieldValueString(d,"ECAD_VALUE");
				break;
			}
		}
			
	}
		ezc.ezcommon.EzLog4j.log(":::::template::::::"+template,"I");
		ReturnObjFromRetrieve rettempUser	=  null;
		int    rettempUserCnt	=  0;
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams				= new EziMiscParams();
		if(docStatus.equals("REJECTED"))
		{
			mainParams	= new ezc.ezparam.EzcParams(false);
			miscParams				= new EziMiscParams();
			miscParams.setQuery("Select * from (SELECT EWW_ROLE_NO ROLE, EWOD_PARTICIPANT OWNERPARTICIPANT, EWOD_PARTICIPANT_TYPE OPTYPE, EWOD_PARENT PARENT,ESKD_SYS_KEY SYSKEY, ECAD_VALUE PURCHGRP, EWOD_LEVEL STEP,EWWU_USER USER_ID FROM EZC_WF_ORGONAGRAM_DETAILS,EZC_WF_ORGONAGRAM,EZC_WF_WORKGROUPS,EZC_WF_WORKGROUP_USERS, EZC_SYSTEM_KEY_DESC, EZC_CAT_AREA_DEFAULTS WHERE EWO_CODE=EWOD_CODE AND EWO_TEMPLATE IN ('"+template+"') AND EWWU_GROUP=EWOD_PARTICIPANT  AND ESKD_SYS_KEY=ECAD_SYS_KEY AND ECAD_KEY='PURGROUP' AND EWWU_SYSKEY=ESKD_SYS_KEY AND EWW_GROUP=EWWU_GROUP AND ESKD_SYS_KEY IN ('"+SystemKey+"')  and EWWU_USER='"+Integer.parseInt(defSoldTo)+"' ORDER BY CAST(EWOD_LEVEL AS UNSIGNED))a");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);
			try
			{
				rettempUser=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
			}
			catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");}
			if(rettempUser!=null)
			{
				rettempUserCnt	= rettempUser.getRowCount();
				userGroupKey=checkNull(rettempUser.getFieldValueString(0,"OWNERPARTICIPANT"));
				checkRole=checkNull(rettempUser.getFieldValueString(0,"ROLE"));
			}

			if("".equals(userGroupKey))userGroupKey=Integer.parseInt(defSoldTo)+"";
			//if("".equals(checkRole))	


		
			mainParams = new ezc.ezparam.EzcParams(true);
			ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
			ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
			EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();

			keyParams.setKey("UpdateRequestStatus");
			keyTableParams.appendRow(keyParams);
			mainParams.setLocalStore("Y");

			generalParams.setDocId(vendorProfileId);
			generalParams.setExt1("");
			generalParams.setModifiedBy(Session.getUserId());
			generalParams.setVendor(Integer.parseInt(defSoldTo)+"");
			generalParams.setStatus("REJECTED");

			mainParams.setObject(keyTableParams);	

			mainParams.setObject(generalParams);
			Session.prepareParams(mainParams);

			try{
			 vendorprofile.ezUpdateDetails(mainParams);

			}catch(Exception e){System.out.println(e);}

		
		}
		else{
			ezc.ezcommon.EzLog4j.log("In the method getWFHierarchy() Starta ---> "+(String)Session.getUserId(),"I");
			mainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezworkflow.params.EziOrganogramLevelsParams params= new ezc.ezworkflow.params.EziOrganogramLevelsParams();
			params.setTemplate(template);
			params.setSysKey(SystemKey);
			mainParams.setObject(params);
			Session.prepareParams(mainParams);
			ezc.ezparam.ReturnObjFromRetrieve listTemplateRet=(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getOrganogramLevelsDetails(mainParams);
			ezc.ezcommon.EzLog4j.log("In the method getWFHierarchy() end ---> "+(String)Session.getUserId(),"I");



			if(listTemplateRet != null)
			{
				for(int i=0;i<listTemplateRet.getRowCount();i++)
				{
					String orgUser = checkNull(listTemplateRet.getFieldValueString(i,"USER_ID")); 

					if(userId.equals(orgUser))
					{
					userGroupKey = checkNull(listTemplateRet.getFieldValueString(i,"OWNERPARTICIPANT"));
					checkRole    = checkNull(listTemplateRet.getFieldValueString(i,"ROLE"));
					}
				}
					
			}
		}
		
		
		ezc.ezcommon.EzLog4j.log(docStatus+":::::docStatus:::::"+checkRole+"::::::::checkRole:::::::userGroupKey::::"+userGroupKey,"I");
		mainParams = new ezc.ezparam.EzcParams(false);
		 ezc.ezworkflow.params.EziWFParams eziWfparams 	= new ezc.ezworkflow.params.EziWFParams();
		 ezc.ezworkflow.params.EziWFDocHistoryParams eziWfDocHis = new ezc.ezworkflow.params.EziWFDocHistoryParams();
		 
		 eziWfDocHis.setStatus(docStatus);
		 eziWfDocHis.setSysKey(SystemKey);
		 eziWfDocHis.setTemplateCode(template);
		 eziWfDocHis.setModifiedBy(userId);
		 
		 if(docStatus.equals("REJECTED"))
		 {
		 	eziWfDocHis.setAction("100068");
			eziWfDocHis.setNextParticipantStep("1");
			eziWfDocHis.setNextParticipantRole(checkRole);	
			eziWfDocHis.setNextParticipant(userGroupKey);
			eziWfDocHis.setNextParticipantType("G");
		 }
		 else if(docStatus.equals("APPROVED"))
		 {
		 	eziWfDocHis.setAction("100067");
		 	eziWfDocHis.setNextParticipantStep("1");
			eziWfDocHis.setNextParticipantRole(checkRole);	
			eziWfDocHis.setNextParticipant(userGroupKey);
			eziWfDocHis.setNextParticipantType("G");
		 }
		 else if(docStatus.equals("SUBMITTED"))
		 {
		 	eziWfDocHis.setAction("100066");
}			 	
		 	eziWfparams.setRole(checkRole);
		 	eziWfDocHis.setParticipant(userGroupKey);
			eziWfparams.setParticipant(userGroupKey);
		 
		 
		eziWfDocHis.setDocId(vendorProfileId);
		eziWfDocHis.setAuthKey("VENDOR_PROFILE");

		mainParams.setObject(eziWfparams);
		mainParams.setObject(eziWfDocHis);
		Session.prepareParams(mainParams);

		try{
		//retPoWorkFlow = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.updateWFDoc(mainParams);	
		}catch(Exception e){errorOccured=true;}
	ezc.ezcommon.EzLog4j.log(":::::errorOccured in ezSubmitVendDtls:::::"+errorOccured,"I");
	String attachflag 	= checkNull(request.getParameter("attachFlag"));
			if("".equals(attachflag))attachflag="N";
			ezc.ezcommon.EzLog4j.log("::::::attachflag qry:::::::::::"+attachflag,"I");
			try
			{
			if("Y".equals(attachflag))
			{
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				mainParams=new ezc.ezparam.EzcParams(false); 
	
				String attachDocDesc = checkNull(request.getParameter("attachDocDesc"));
				String attachDocFiles = checkNull(request.getParameter("attachDocFiles"));
				String attachFileTime = checkNull(request.getParameter("attachFileTime"));
				String tempAttachFile="";
	
				ezc.ezcommon.EzLog4j.log("::::::attachDocDesc qry:::::::::::"+attachDocDesc,"I");
				ezc.ezcommon.EzLog4j.log("::::::attachDocFiles qry:::::::::::"+attachDocFiles,"I");
	
				Hashtable docDescFiles = new Hashtable();
	  
				if(attachDocFiles.indexOf("¥")>0)
				{
					String[] attachDocFilesArr = attachDocFiles.split("¥");
					String[] attachDocDescArr = attachDocDesc.split("¥");
					String[] attachFileTimeArr = attachFileTime.split("¥");
					
	
					if(attachDocFilesArr!=null)
					{
						for(int i=0;i<attachDocFilesArr.length;i++)
						{		
							int lastindex = attachDocFilesArr[i].lastIndexOf("\\");
	
							try{
							if(lastindex>=0)
								tempAttachFile = attachDocFilesArr[i].substring(lastindex+1,attachDocFilesArr[i].length());
							else
							tempAttachFile=attachDocFilesArr[i];
							
							}catch(Exception e){tempAttachFile=attachDocFilesArr[i];ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");}
							ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");
	
							try{
							if("NA".equals(attachFileTimeArr[i]))
							docDescFiles.put(tempAttachFile,attachDocDescArr[i]);
							else
							docDescFiles.put(attachFileTimeArr[i]+"_"+tempAttachFile,attachDocDescArr[i]);
							}catch(Exception e){}
						}
					}
				}else
				{
					int lastindex = attachDocFiles.lastIndexOf("\\");
						ezc.ezcommon.EzLog4j.log("::::::lastindex2:::::::::::"+lastindex,"I");
	
					try{
					if(lastindex>=0)
						tempAttachFile = attachDocFiles.substring(lastindex+1,attachDocFiles.length());
					else
						tempAttachFile=attachDocFiles;
					}catch(Exception e){tempAttachFile=attachDocFiles;ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");}
							ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");
					
					if("NA".equals(attachFileTime))
					docDescFiles.put(tempAttachFile,attachDocDesc);
					else
					docDescFiles.put(attachFileTime+"_"+tempAttachFile,attachDocDesc);
					
				}
	
				ezc.ezcommon.EzLog4j.log("::::::docDescFiles qry:::::::::::"+docDescFiles,"I");
	
	
				ezc.ezcommon.EzLog4j.log("::::::srcPath qry:::::::::::"+srcPath,"I"); 
				File srcDir	= new File(srcPath+session.getId());
	  
				File[] files = null;
	
				if(srcDir.exists())
				files = srcDir.listFiles();
	
				FileChannel in = null;
				FileChannel outSt = null;
	
				if(files!=null)
				{
				//uploadedFileCnt=files.length;
					ezc.ezcommon.EzLog4j.log("******files.length*****"+files.length,"I");
	
					for (int i=0;i<files.length;i++)
					{
	
						String fileName	 = files[i].getName();
	
						ezc.ezcommon.EzLog4j.log("******fileName*****"+fileName,"I");
	
						try
						{
							in = new FileInputStream(files[i]).getChannel();
							File destFolder	= null;
	
							destFolder	= new File(destinationPath+vendorProfileId);
	
							if (!destFolder.exists())
							destFolder.mkdirs();
	
							String serFileName=vendorProfileId+"\\\\"+fileName;
	
							String attachmentDesc = (String)docDescFiles.get(fileName);
				
							if(attachmentDesc==null || "null".equals(attachmentDesc))attachmentDesc="";	
							
							
							ezc.ezcommon.EzLog4j.log("******attachmentDesc*****"+attachmentDesc,"I");
							if(!"".equals(attachmentDesc))
							{
								//uploadedFileCnt=uploadedFileCnt+1;
								File outFile 	= new File(destFolder, fileName);
								outSt 		= new FileOutputStream(outFile).getChannel();
								in.transferTo(0, in.size(), outSt);
	
								attachmentDesc = attachmentDesc.replaceAll("'","`");
								attachmentDesc = attachmentDesc.replaceAll("\"","``");
	
								ezc.ezcommon.EzLog4j.log("******serFileName*****"+serFileName,"I");
								String qry="INSERT INTO EZC_UPLOAD_FILES (EUF_DOC_ID,EUF_ATTACHED_BY,EUF_ATTACHED_DATE,EUF_FILE_DESCRTIPTION,EUF_CLIENT_FILE_NAME,EUF_SERVER_FILE_NAME,EUF_EXT1,EUF_EXT2,EUF_EXT3) VALUES('"+vendorProfileId+"','"+Session.getUserId()+"',NOW(),'"+attachmentDesc+"','"+fileName+"','"+serFileName+"','','','')" ;
								ezc.ezcommon.EzLog4j.log("******EZC_UPLOAD_FILES qry*****"+qry,"I");
								
								miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
								miscTableRow.setQuery(qry);
								miscTable.appendRow(miscTableRow);
								
								/*mainParams = new ezc.ezparam.EzcParams(true);
								miscParams = new EziMiscParams();
								miscParams.setQuery(qry);
								mainParams.setObject(miscParams);	
								Session.prepareParams(mainParams);
	
								try{
								miscManager.ezAdd(mainParams);
								}catch(Exception e){}*/
							}
							files[i].delete();
						}
						catch (Exception e)
						{
							ezc.ezcommon.EzLog4j.log(" : :Error occured while moving files ::::"+e,"E");
						}
						finally
						{
							if (in != null)
							in.close();
							if (outSt != null)
							outSt.close();
	
						}
	
	 
					} 
					mainParams.setLocalStore("Y");
					mainParams.setObject(miscTable); 
					Session.prepareParams(mainParams);
	
					ezc.ezparam.ReturnObjFromRetrieve retObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(mainParams);
	
					try{
						for (File file : files)
						{
						file.delete();
						}  
	
					}catch(Exception e){ezc.ezcommon.EzLog4j.log("::::::Batch query execution failed in ezSaveCRNDetails::::::"+e,"E");}
				}
			}		
			session.removeValue("ATTACHEDFILES");
			}catch(Exception e){ezc.ezcommon.EzLog4j.log("::::::Exception occured while uploading files::::::"+e,"E");}
	ReturnObjFromRetrieve	retDocIn = null;
	ReturnObjFromRetrieve	retDocAuditSel = null;
	ReturnObjFromRetrieve	retDocInAudit = null;
	ReturnObjFromRetrieve	retDocUp = null;
	ReturnObjFromRetrieve	retDocKey = null;
	ReturnObjFromRetrieve	retnextParticipant = null;
	String docKey	= "";
	String actionCode="100067";
	if(docStatus.equals("REJECTED"))actionCode="100068";
	
	String nextStep	= "1";
	String nextParticipant =userGroupKey;
	
	if(docStatus.equals("REJECTED") || docStatus.equals("APPROVED")|| docStatus.equals("SUBMITTED"))
	{
		if(docStatus.equals("SUBMITTED"))
		{
			mainParams	= new ezc.ezparam.EzcParams(false);
			miscParams = new EziMiscParams();
			miscParams.setQuery("SELECT  *  from EZC_WF_ORGONAGRAM_DETAILS WHERE EWOD_PARTICIPANT IN ( SELECT EWOD_PARENT FROM EZC_WF_ORGONAGRAM,EZC_WF_ORGONAGRAM_DETAILS WHERE EWO_TEMPLATE="+template+" AND EWOD_PARTICIPANT='"+userGroupKey+"' AND EWO_CODE=EWOD_CODE) AND EWOD_CODE IN  (SELECT EWO_CODE FROM EZC_WF_ORGONAGRAM ,EZC_WF_ORGONAGRAM_DETAILS WHERE EWO_TEMPLATE='"+template+"' AND EWOD_PARTICIPANT='"+userGroupKey+"' AND EWO_CODE=EWOD_CODE)");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);
			try
			{
				retnextParticipant=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
			if(retnextParticipant!=null && retnextParticipant.getRowCount()>0)
			{
				nextStep	= retnextParticipant.getFieldValueString(0,"EWOD_LEVEL");
				nextParticipant = retnextParticipant.getFieldValueString(0,"EWOD_PARTICIPANT");
			}
		}
		
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
		miscParams.setQuery("select * from EZC_WF_DOC_HISTORY_HEADER where EWDHH_DOC_ID='"+vendorProfileId+"'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);

		try
		{
			retDocKey =(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}
		if(retDocKey!=null && retDocKey.getRowCount()>0)
		{
			docKey = retDocKey.getFieldValueString(0,"EWDHH_DOC_ID");
		}
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
		miscParams.setQuery("INSERT INTO EZC_WF_DOC_HISTORY_DETAILS(EWDHD_KEY, EWDHD_WF_STATUS, EWDHD_WF_ACTION, EWDHD_ACTION_ON, EWDHD_ACTION_BY, EWDHD_THIS_STEP, EWDHD_COMMENTS) VALUES('"+docKey+"','"+docStatus+"',"+actionCode+",now(),'"+Session.getUserId()+"','"+nextStep+"','null')");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		
		try
		{
			miscManager.ezAdd(mainParams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
		miscParams.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_WF_STATUS='"+docStatus+"', EWDHH_MODIFIED_BY='"+Session.getUserId()+"', EWDHH_MODIFIED_ON=now(), EWDHH_CURRENT_STEP='"+nextStep+"',EWDHH_NEXT_PARTICIPANT='"+nextParticipant+"',EWDHH_PARTICIPANT_TYPE='G',EWDHH_REF1='NO-CHANGE',EWDHH_REF2=CONCAT(EWDHH_REF2,'-->"+Session.getUserId()+"'),EWDHH_NEXT_D_PARTICIPANT='-',EWDHH_D_PARTICIPANT_TYPE='-'   WHERE EWDHH_AUTH_KEY IN ('VENDOR_PROFILE') AND EWDHH_SYSKEY IN ('"+SystemKey+"') AND EWDHH_DOC_ID ='"+vendorProfileId+"' ");
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
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
		miscParams.setQuery("SELECT MAX(CAST(EWAT_AUDIT_NO AS UNSIGNED))+1 AUDIT_NO FROM EZC_WF_AUDIT_TRAIL WHERE EWAT_DOC_ID = '"+vendorProfileId+"'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);

		try
		{
			retDocAuditSel =(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
			
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}
		if(retDocAuditSel!=null && retDocAuditSel.getRowCount()>0)
		{
		//' rejected by "+Session.getUserId()+"' 
			String audiNo =retDocAuditSel.getFieldValueString(0,"AUDIT_NO");
			mainParams	= new ezc.ezparam.EzcParams(false);
			miscParams = new EziMiscParams();
			miscParams.setQuery("INSERT INTO EZC_WF_AUDIT_TRAIL(EWAT_AUDIT_NO, EWAT_DOC_ID, EWAT_TYPE, EWAT_SOURCE_PARTICIPANT, EWAT_SOURCE_PARTICIPANT_TYPE, EWAT_DEST_PARTICIPANT, EWAT_DEST_PARTICIPANT_TYPE,EWAT_COMMENTS,EWAT_DATE) VALUES('"+audiNo+"','"+vendorProfileId+"','"+actionCode+"','"+Session.getUserId()+"','U','"+nextParticipant+"','G','Purchase Head  and sent back to Shared Service Center ',now())");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);
			try
			{
				miscManager.ezAdd(mainParams);
			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
		}
		
		
	}
	
	String nxtParticipantName ="";
	ReturnObjFromRetrieve retUserNames = null;
	mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();
	miscParams.setQuery("select * from EZC_USERS where EU_ID in( select distinct EWWU_USER from EZC_WF_WORKGROUP_USERS where EWWU_GROUP='"+nextParticipant+"')");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	
	try
	{					
		retUserNames = (ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
	}
	if(retUserNames!=null && retUserNames.getRowCount()>0)
	{
		for(int i=0;i<retUserNames.getRowCount();i++)
		{
			if("".equals(nxtParticipantName))nxtParticipantName = checkNull(retUserNames.getFieldValueString(i,"EU_FIRST_NAME"));
			else nxtParticipantName=nxtParticipantName+","+checkNull(retUserNames.getFieldValueString(i,"EU_FIRST_NAME"));
		}
	}
	
	if(!errorOccured)
	{
	
		if(docStatus.equals("APPROVED")) dispMessage = "Request <b>"+myPurOrg+vendorProfileId+"</b> has been Approved";
		else if(docStatus.equals("REJECTED")) dispMessage = "Request <b>"+myPurOrg+vendorProfileId+"</b> has been Rejected";
		else dispMessage="Request <b>"+myPurOrg+vendorProfileId+"</b> has been submited to <b>"+nxtParticipantName+"</b>";
		//out.println("nxtParticipantNamenxtParticipantName"+nxtParticipantName);
		//out.println("nextParticipantnextParticipant"+nextParticipant);
		dispMsgType="S";
		
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

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
		
		
		String sendToUser= (String)Session.getUserId()+","+Integer.parseInt(defSoldTo);
		
		String msgSubject ="";
		String msgText = "",msgNextPartText="";
		
		if(docStatus.equals("APPROVED")) 
		{
		
			ReturnObjFromRetrieve mdmUsersObj = null;
			mainParams	= new ezc.ezparam.EzcParams(false);
			miscParams = new EziMiscParams();
			miscParams.setQuery("SELECT * FROM EZC_USER_DEFAULTS WHERE EUD_KEY='USERROLE' AND EUD_VALUE='MDM'");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);

			try
			{					
				mdmUsersObj = (ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);

			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
			if(mdmUsersObj!=null && mdmUsersObj.getRowCount()>0)
			{
				for(int l=0;l<mdmUsersObj.getRowCount();l++)
				{
					if("".equals(sendToUser))sendToUser = checkNull(mdmUsersObj.getFieldValueString(l,"EUD_USER_ID"));
					else sendToUser=sendToUser+","+checkNull(mdmUsersObj.getFieldValueString(l,"EUD_USER_ID"));
				}
			}		
			//sendToUser="MDMUSER";
			//msgSubject = vendorName+" change profile Approved";
			msgSubject = "Vendor profile Change Request approved (Request number "+vendorProfileId+")";
			if(vendType.equals("NEW"))
			//msgSubject = vendorName+" new profile Approved";
			msgSubject = "Vendor profile Creation Request approved (Request number "+vendorProfileId+")";
			msgText ="Dear Sir/Madam,<br><br> Vendor profile request "+vendorProfileId+" has been Approved and please post details to SAP.&nbsp;<br>";
		}
		else if(docStatus.equals("REJECTED"))
		{
			sendToUser=Integer.parseInt(defSoldTo)+"";
			//msgSubject =vendorName+" change profile Rejected";
			msgSubject = "Vendor profile Change Request Rejected (Request number "+vendorProfileId+")";		
			if(vendType.equals("NEW"))
			//msgSubject =vendorName+" new profile Rejected";
			msgSubject = "Vendor profile Creation Request Rejected (Request number "+vendorProfileId+")";
			msgText ="Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been Rejected.&nbsp;<br>";
		}
		else 
		{
			
			ReturnObjFromRetrieve wfUsersObj = null;
			mainParams	= new ezc.ezparam.EzcParams(false);
			miscParams = new EziMiscParams();
			miscParams.setQuery("SELECT * FROM EZC_WF_WORKGROUP_USERS WHERE EWWU_GROUP='"+nextParticipant+"'");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);

			try
			{					
				wfUsersObj = (ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);

			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
			if(wfUsersObj!=null && wfUsersObj.getRowCount()>0)
			{
				for(int l=0;l<wfUsersObj.getRowCount();l++)
				{
					if("".equals(sendToUser))sendToUser = checkNull(wfUsersObj.getFieldValueString(l,"EWWU_USER"));
					else sendToUser=sendToUser+","+checkNull(wfUsersObj.getFieldValueString(l,"EWWU_USER"));
				}
			}

			
			
			//msgSubject =vendorName+" change profile Submitted";
			msgSubject ="Vendor Profile Change request submitted (Request number "+vendorProfileId+")";
			if(vendType.equals("NEW"))
			//msgSubject =vendorName+" new profile Submitted";
			msgSubject ="Vendor Profile Creation request submitted (Request number "+vendorProfileId+")";
			msgNextPartText="Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been submitted for your approval.<br>";
			msgText="Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been submitted for your approval.<br>";
			//msgText ="Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been Submitted to "+nxtParticipantName+".&nbsp;<br>";
		}
		String url ="http://"+request.getServerName()+":"+request.getServerPort();
		//String msgSubject = "Vendor profile request has been Submitted";
		//String msgText = "Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been Submitted.&nbsp;<br>";
		if(docStatus.equals("SUBMITTED"))
		{
		//msgNextPartText = msgNextPartText+"<BR><br>Please Click on the below link to access the portal.";
		//msgNextPartText = msgNextPartText+"<BR>"+url;
		}
		
		msgText += "<br><br>Regards,<br>"+v_fname+v_mname+v_lname;
		msgNextPartText += "<br><br>Regards,<br>"+v_fname+v_mname+v_lname;
		
		
		String inboxPath="";
	 	
		
%>	
	<%@ include file="../Purorder/ezSendMail.jsp" %>	
<%	
	/*if(docStatus.equals("SUBMITTED"))
	{
		sendToUser= nextParticipant;
		msgText=msgNextPartText;
		
		ReturnObjFromRetrieve retUserData=null;

		EzcUserParams uparamsN= new EzcUserParams();
		EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
		ezcUserNKParamsN.setLanguage("EN");
		uparamsN.setUserId(sendToUser);
		uparamsN.createContainer();
		uparamsN.setObject(ezcUserNKParamsN);
		Session.prepareParams(uparamsN);
		try
		{					
		retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
		to=retUserData.getFieldValueString("EU_EMAIL");
		}
		catch(Exception e)
		{
		System.out.println("Failed to Get User MailId.Probably b'coz wrong UserId");
		}		
		ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();	
	   	   mailParams.setGroupId("CRMDL");
	   	 
	   //	 mailParams.setTo("cmulakala@answerthink.com");
	   	 mailParams.setTo(to);
	   	   mailParams.setCC("");
	   	   mailParams.setBCC("");
	   	   mailParams.setMsgText(msgText+"<BR><BR>Note: Dont change the subject of the mail\n\n <Br>");
	   	   mailParams.setSubject(msgSubject);
	   	   mailParams.setSendAttachments(false);
	   	   mailParams.setContentType("text/html");
	   	   ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
	   	   boolean value=myMail.ezSend(mailParams,Session);
	   	   
	   	   ezc.ezcommon.EzLog4j.log("=========TO Mail Id==============>"+mailParams.getTo(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========CC Mail Id==============>"+mailParams.getCC(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========Subject==============>"+mailParams.getSubject(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========setMsgText==============>"+mailParams.getMsgText(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=======================>Mail Sent Successfully==============>"+value,"I");	
	
		}*/
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
	</Div>        --> 		
	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      	