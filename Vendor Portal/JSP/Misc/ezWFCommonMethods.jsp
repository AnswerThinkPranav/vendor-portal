<%!
	public ezc.ezparam.ReturnObjFromRetrieve getWFHirearchy(ezc.session.EzSession Session,String docType,String plant,String category,String compCode)
	{
		return ezMiscSelect(Session,"SELECT *,(SELECT GROUP_CONCAT(CONCAT(B.EU_ID,'[',B.EU_FIRST_NAME,']')) FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP =EWPC_GROUP AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE='"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_STR FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"') ORDER BY EWPC_LEVEL");
	}
	public ezc.ezparam.ReturnObjFromRetrieve getVNRWFHirearchy(ezc.session.EzSession Session,String docType,String plant,String category,String compCode)
	{
		return ezMiscSelect(Session,"SELECT *,(SELECT GROUP_CONCAT(CONCAT(B.EU_ID,'[',B.EU_FIRST_NAME,']')) FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP =EWPC_GROUP AND TRIM(A.EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PLANT' AND EUDKV_VALUE='"+plant+"') AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES) GROUP BY A.EWWU_GROUP) AS USER_STR FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"') ORDER BY EWPC_LEVEL");
	}	
	public ezc.ezparam.ReturnObjFromRetrieve getWFTemplate(ezc.session.EzSession Session,String docType,String plant,String category,String compCode)
	{
		return ezMiscSelect(Session,"SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"'");
	}
	public ezc.ezparam.ReturnObjFromRetrieve getNextPart(ezc.session.EzSession Session,String template,int curStep)
	{
		curStep=curStep+1;
		return ezMiscSelect(Session,"SELECT * FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_LEVEL="+curStep+" AND EWPC_TEMPLATE='"+template+"'");
	}
	public ezc.ezparam.ReturnObjFromRetrieve getWFDetails(ezc.session.EzSession Session,String template,int curStep,String nextPart)
	{
		ezc.ezcommon.EzLog4j.log("session>>>>>>"+Session,"I");
		ezc.ezcommon.EzLog4j.log("template>>>>>>"+template,"I");
		ezc.ezcommon.EzLog4j.log("curStep>>>>>>"+curStep,"I");
		ezc.ezcommon.EzLog4j.log("nextPart>>>>>>"+nextPart,"I");
		
		return ezMiscSelect(Session,"SELECT * FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_GROUP='"+nextPart+"' AND EWPC_LEVEL="+curStep+" AND EWPC_TEMPLATE='"+template+"'");
	}
	public void saveWFDocAudit(ezc.session.EzSession Session,String docNo,String docType,String comments,String srcType)
	{
		ezc.ezparam.EzcParams historyMainParams = new ezc.ezparam.EzcParams(false);
		ezc.ezpreprocurement.client.EzPreProcurementManager Manager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
		historyMainParams.setLocalStore("Y");
		ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFHistoryParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
		eziWFHistoryParams.setEwhDocId(docNo);
		historyMainParams.setObject(eziWFHistoryParams);
		Session.prepareParams(historyMainParams);
		ezc.ezparam.ReturnObjFromRetrieve wfMyRet = (ezc.ezparam.ReturnObjFromRetrieve)Manager.ezGetWFAuditTrailNo(historyMainParams);
		ezc.ezcommon.EzLog4j.log("audit_trail>>>>>>>::::::::::123","I"); 
		String historyNo = "";
		if(wfMyRet != null)
		{
			historyNo = wfMyRet.getFieldValueString(0,"AUDIT_NO");
			if(historyNo == "null")
				historyNo = "1";
		}
		else
			historyNo = "1";
		ezc.ezcommon.EzLog4j.log("audit_trail>>>>>>>"+historyNo,"I"); 
		eziWFHistoryParams.setEwhAuditTrailNo(historyNo);
		eziWFHistoryParams.setEwhDocId(docNo);
		eziWFHistoryParams.setEwhType(docType);
		eziWFHistoryParams.setEwhSourceParticipant((String)Session.getUserId());
		eziWFHistoryParams.setEwhSourceParticipantType(srcType);
		eziWFHistoryParams.setEwhDestParticipant("");
		eziWFHistoryParams.setEwhDestParticipantType("");
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();	
		String strDate = fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.DDMMYYYY);
		eziWFHistoryParams.setEwhComments(comments);
		historyMainParams.setObject(eziWFHistoryParams);
		Session.prepareParams(historyMainParams);
		Manager.ezAddWFAuditTrail(historyMainParams);
	}	
	/*
	public void saveWorkflowHeader(String authKey,String docId,String sysKey,String template,String wfStatus,String curStep,String nextPart)
	{
		String qry="insert into ezc_wf_doc_history_header(EWDHH_AUTH_KEY,EWDHH_DOC_ID,EWDHH_SYSKEY,EWDHH_TEMPLATE_CODE,EWDHH_WF_STATUS,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_MODIFIED_BY,EWDHH_CURRENT_STEP,EWDHH_NEXT_PARTICIPANT) VALUES('"+authKey+"','"+docId+"','"+sysKey+"','"+template+"','"+wfStatus+"',now(),now(),'"+Session.getUserId()+"','"+Session.getUserId()+"',"+curStep+",'"+nextPart+"')";
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add(qry);
		ezMiscInsert(Session,queriesList);
	}
	*/
	public boolean sendMails(ezc.session.EzSession Session,String toMail,String ccMail,String bccMail,String msgText,String msgSubject) throws Exception
	{
		ezc.ezcommon.EzLog4j.log("msgText::::::::"+msgText,"I"); 
		ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();	
		mailParams.setGroupId("JUBL");
		mailParams.setTo(toMail);
		mailParams.setCC(ccMail);
		mailParams.setBCC(bccMail);
		mailParams.setMsgText(msgText);
		mailParams.setSubject(msgSubject);
		mailParams.setSendAttachments(false);
		mailParams.setContentType("text/html");
		ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
		return myMail.ezSend(mailParams,Session);
		//return true;
	}
	public ezc.ezparam.ReturnObjFromRetrieve getWorkFlowMails(ezc.session.EzSession Session,String workGrp,String plant,String category)
	{
		ezc.ezparam.ReturnObjFromRetrieve userRet = null; 
		try
		{
			userRet= ezMiscSelect(Session,"SELECT DISTINCT EU_ID,EU_FIRST_NAME,EU_EMAIL FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP ='"+workGrp+"'  AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE='"+plant+"#"+category+"')");
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("exception in :::getWorkFlowMails>>>>>>>"+e,"E"); 
		}
		return userRet;
	}
	public String getNumberRange(ezc.session.EzSession Session,String rangeType)
	{
		String queryId = "";
		ezc.ezparam.EzcParams mainParams_range = new ezc.ezparam.EzcParams(false);                                                             
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_range = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzGetNewNumberParams numRangeParam_range = new ezc.misctransactions.params.EzGetNewNumberParams();

		mainParams_range = new ezc.ezparam.EzcParams(false); 
		numRangeParam_range = new ezc.misctransactions.params.EzGetNewNumberParams();
		numRangeParam_range.setNumberFor(rangeType);

		try
		{
			mainParams_range.setLocalStore("Y");
			mainParams_range.setObject(numRangeParam_range);
			Session.prepareParams(mainParams_range);
			Object newNumber = (Object)miscMgr_range.ezGetNewnumber(mainParams_range);
			queryId = newNumber+"";
			
		}catch(Exception e){}
		return queryId;
	}
	public String saveLinkControllerData(ezc.session.EzSession Session,String docId,String docType,String userId,String email,String mailText)
	{
		String queryId = getNumberRange(Session,"LINKID");
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add("INSERT INTO EZC_LINK_CONTROLLER(ELC_ID,ELC_DOC_ID,ELC_DOC_TYPE,ELC_USER,ELC_EMAIL,ELC_MAIL_TEXT,ELC_CREATED_ON,ELC_STATUS) VALUES("+queryId+",'"+docId+"','"+docType+"','"+userId+"','"+email+"','"+mailText+"',now(),'S')");
		ezMiscInsert(Session,queriesList);
		return queryId;
	}
	public String getWFCategory(ezc.session.EzSession Session,String purGrp,String plant,String prDocType,String prMatType)
	{
		ezc.ezparam.ReturnObjFromRetrieve retPurGrpData=ezMiscSelect(Session,"SELECT EWDM_DEPT FROM EZC_WF_DEFAULTS_MAP WHERE EWDM_PLANT='"+plant+"' AND EWDM_KEY='PURGRP' AND EWDM_VALUE='"+purGrp+"'");
		String prCategory = "";
		if(retPurGrpData != null && retPurGrpData.getRowCount() > 0)
		{
			try
			{
				prCategory=retPurGrpData.getFieldValueString(0,"EWDM_DEPT");
				if(prCategory != null && !"null".equals(prCategory) && !"".equals(prCategory))
					return prCategory;

			}catch(Exception e){}
		}

		if("4410".equals(plant) && "ZFIN".equals(prMatType))
			prCategory = "FGS";
		else if("ZH07".equals(prDocType))
			prCategory = "EXT_MFG";			
		else if	("ZH08".equals(prDocType))
			prCategory = "LOG";
		else if(("ZRAW".equals(prMatType)|| "ZSFP".equals(prMatType)|| "ZPPM".equals(prMatType)|| "ZTPM".equals(prMatType)  || "ZSPM".equals(prMatType)) && ("NB".equals(prDocType)||"ZH01".equals(prDocType)))
			prCategory = "RM_PM";
		else if("1000".equals(plant) && "141".equals(purGrp))
			prCategory = "IT_JPL";
		else if("1000".equals(plant) && "123".equals(purGrp))
			prCategory = "Admin_JPL";
		else if("1000".equals(plant) && "139".equals(purGrp))
			prCategory = "HR_JPL";	
		else if("1000".equals(plant) && "135".equals(purGrp))
			prCategory = "PROJ_JPL";	
		else 
			prCategory = "ENG_SER";
		return prCategory;
	}
	
	
%>
