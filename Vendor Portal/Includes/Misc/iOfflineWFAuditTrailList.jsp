<%@ page import ="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="ConfigMgr" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%!
	private String calculateTime(java.util.Date fromDate, java.util.Date toDate)
	{
		int day 	= fromDate.getDate();
		int month 	= fromDate.getMonth();
		int year 	= fromDate.getYear();
		int hours 	= fromDate.getHours();
		int mins 	= fromDate.getMinutes();
		int scnds 	= fromDate.getSeconds();
		java.util.Date fromDateObj = new java.util.Date(year,month,day,hours,mins,scnds);
		long fromTime = fromDateObj.getTime();
		day 	= toDate.getDate();
		month 	= toDate.getMonth();
		year 	= toDate.getYear();
		hours 	= toDate.getHours();
		mins 	= toDate.getMinutes();
		scnds 	= toDate.getSeconds();
		java.util.Date toDateObj = new java.util.Date(year,month,day,hours,mins,scnds);
		long toTime = toDateObj.getTime();
		return millisecondsToString(toTime-fromTime);
	}
	private String millisecondsToString(long time)
	{
		String returnTime = ""; 
		int milliseconds = (int)(time % 1000);
		int seconds = (int)((time/1000) % 60);
		int minutes = (int)((time/60000) % 60);
		int hours = (int)((time/3600000) % 24);
		int days = (int)((time/3600000)/24);
		hours += days*24;	    
		String millisecondsStr = (milliseconds<10 ? "00" : (milliseconds<100 ? "0" : ""))+milliseconds;
		String secondsStr = (seconds<10 ? "0" : "")+seconds;
		String minutesStr = (minutes<10 ? "0" : "")+minutes;
		String hoursStr = (hours<10 ? "0" : "")+hours;
		try{
			int hoursInt = Integer.parseInt(hoursStr);
			int dysTkn = hoursInt / 24;
			int hrsTkn = hoursInt % 24;
			hoursStr = (hrsTkn<10 ? "0" : "")+hrsTkn;
			if(dysTkn == 0)
				returnTime = hoursStr+" Hrs "+minutesStr+" Mins";
			else
				returnTime = dysTkn+"Days "+hoursStr+" Hrs";
		}catch(Exception ex){returnTime = hoursStr+" Hrs "+minutesStr+" Mins";}	
		return returnTime;
	}	
%>
<%
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();	
	String scrollInit = "";
	String loginType = (String)session.getValue("OFFLINE");
	String rqstMenu = request.getParameter("rqstMenu");
	String checkStatus = "'SUBMITTED','REJECTED','Blocked'";
	String template = (String)session.getValue("TEMPLATE");
	
	if(!"QCF_COMMENTS".equals(rqstMenu))
		checkStatus += ",'APPROVED','RELEASED','CLOSED'";
	else	
		checkStatus += ") AND EWDHH_CURRENT_STEP <= (SELECT EWTS_STEP FROM EZC_WF_TEMPLATE_STEPS WHERE EWTS_CODE='"+template+"' AND EWTS_STEP_DESC='GM'";
	
	if(loginType != null && "Y".equals(loginType))
		scrollInit="10";
	else
		scrollInit="10";	
	
	
	String sysKey 	= (String)session.getValue("SYSKEY");
	String docId = "";
	int myRetCnt = 0;
	java.util.Hashtable auditHash = new  java.util.Hashtable();
	auditHash.put("QCF_RELEASE","QCF");
	auditHash.put("PO_RELEASE","PO");
	auditHash.put("CON_RELEASE","CONTRACT");
	
	java.util.Hashtable auditHashDesc = new  java.util.Hashtable();
	auditHashDesc.put("QCF_RELEASE","QCF No");
	auditHashDesc.put("PO_RELEASE","PO No");
	auditHashDesc.put("CON_RELEASE","Contract No");
	
	String auditTypeDesc = "Workflow No";
	
	java.util.Enumeration enum = auditHash.keys();
	String keyValue = "";
	String keyId	= "";
	String selected = "";
	ezc.ezparam.ReturnObjFromRetrieve myRet = null;
	ezc.ezparam.ReturnObjFromRetrieve retGetWFAuditTrailNos = null;
	String auditType = request.getParameter("wf_trail_type");
	int retCount = 0;
	if(auditType != null && !"-".equals(auditType))
	{
		auditTypeDesc = (String)auditHashDesc.get(auditType);
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		ezc.ezworkflow.params.EziWFDocHistoryParams params= new ezc.ezworkflow.params.EziWFDocHistoryParams();
		params.setAuthKey("'"+auditType+"'");
		params.setSysKey("'"+sysKey+"'");
		params.setTemplateCode(template);
		params.setStatus(checkStatus);
		mainParams.setObject(params);
		Session.prepareParams(mainParams);
		myRet=(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams);
		myRetCnt = myRet.getRowCount();
		myRet.sort(new String[]{"DOCID"},false);
			
		
		ezc.ezpreprocurement.client.EzPreProcurementManager wfAuditTrailManager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
		ezc.ezparam.EzcParams myParams	= new ezc.ezparam.EzcParams(true);
		ezc.ezpreprocurement.params.EziWFAuditTrailParams wfAuditTrailParams = new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
		if(request.getParameter("wf_trail_list")!=null && !"null".equals(request.getParameter("wf_trail_list")))
		{
			docId = request.getParameter("wf_trail_list");
			myParams.setLocalStore("Y");
			wfAuditTrailParams.setEwhExt1("$$");
			wfAuditTrailParams.setEwhType("QCF_CLOSED");
			wfAuditTrailParams.setEwhDocId(docId);
			myParams.setObject(wfAuditTrailParams);
			Session.prepareParams(myParams);
			try
			{
				retGetWFAuditTrailNos = (ezc.ezparam.ReturnObjFromRetrieve)wfAuditTrailManager.ezGetWFAuditTrailNo(myParams);
			}
			catch(Exception e)
			{
				System.out.println("Exception Occured while getting Upload docs:"+e);	
			}
			if(retGetWFAuditTrailNos!= null)
			{
				retCount = retGetWFAuditTrailNos.getRowCount();
				int auditNo = 0;
				String timeDiff = "";
				retGetWFAuditTrailNos.addColumn("TIME_DIFF");
				for(int i=retCount-1;i>=0;i--)
				{
					auditNo = Integer.parseInt(retGetWFAuditTrailNos.getFieldValueString(i,"EWAT_AUDIT_NO"));
					if(i < retCount-1)
					{
						timeDiff = calculateTime((java.util.Date)retGetWFAuditTrailNos.getFieldValue(i+1,"EWAT_DATE"),(java.util.Date)retGetWFAuditTrailNos.getFieldValue(i,"EWAT_DATE"));
					}	
					else
					{
						timeDiff = "-";
					}	
					retGetWFAuditTrailNos.setFieldValueAt("TIME_DIFF",timeDiff,i);	
				}
				
				retGetWFAuditTrailNos.addColumn("AUDIT_TIME");
				for(int i=0;i<retCount;i++)
				{
					retGetWFAuditTrailNos.setFieldValueAt("AUDIT_TIME",(retGetWFAuditTrailNos.getFieldValueString(i,"EWAT_DATE")).substring(11,19),i);
					retGetWFAuditTrailNos.addRow();
				}
				
			}
		}	
	}	
%>
