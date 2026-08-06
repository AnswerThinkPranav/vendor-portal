<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/iGetUserName.jsp" %>
<%
	String wfDocNo = "";
	boolean sendReply = false;
	String docType = request.getParameter("docType");
	String collSys = request.getParameter("syskey");
	if("QCF".equals(docType))
	{
		if(request.getParameter("qcf_code") != null)
		{
			wfDocNo = request.getParameter("qcf_code");
			ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
			ezc.ezparam.EzcParams ezcparams	= new ezc.ezparam.EzcParams(false);
			ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams = new ezc.ezpreprocurement.params.EziRFQHeaderParams();
			ezirfqheaderparams.setCollectiveRFQNo(wfDocNo);
			ezirfqheaderparams.setExt1("QCS");
			ezcparams.setObject(ezirfqheaderparams);
			ezcparams.setLocalStore("Y");
			Session.prepareParams(ezcparams);
			ezc.ezparam.ReturnObjFromRetrieve myRet = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);		
			int rfqCount = 0;
			if(myRet != null)
			{
				rfqCount = 	myRet.getRowCount();
				for(int i=0;i<rfqCount;i++)
				{
					if("C".equals(myRet.getFieldValueString(i,"STATUS").trim()))
						sendReply = false;
					else	
						sendReply = true;
				}		
			}
			
			String nextParticipant	= null;
			String nextParType="";
			String initiator="";
			String myUID="";
			String delUser="";
			String wfStatus = "";
			
			ezc.ezworkflow.client.EzWorkFlowManager ezWorkFlowManager = new ezc.ezworkflow.client.EzWorkFlowManager();
			ezc.ezparam.EzcParams wfMainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezworkflow.params.EziWFDocHistoryParams wfParams= new ezc.ezworkflow.params.EziWFDocHistoryParams();
			wfParams.setAuthKey("QCF_RELEASE");
			wfParams.setSysKey(collSys);
			wfParams.setDocId(wfDocNo);
			wfParams.setSoldTo("0");
			wfMainParams.setObject(wfParams);
			Session.prepareParams(wfMainParams);
			ezc.ezparam.ReturnObjFromRetrieve wfDetailsRet=(ezc.ezparam.ReturnObjFromRetrieve)ezWorkFlowManager.getWFDocDetails(wfMainParams);	
			int wfDetailCount = 0;
			
			if(wfDetailsRet!= null)
			{
				wfDetailCount = wfDetailsRet.getRowCount();
				if(wfDetailCount > 0)
				{
					initiator 	= wfDetailsRet.getFieldValueString(0,"INITIATOR");
					nextParticipant	= wfDetailsRet.getFieldValueString(wfDetailsRet.getRowCount()-1,"NEXTPARTICIPANT");
					nextParType	= wfDetailsRet.getFieldValueString(wfDetailsRet.getRowCount()-1,"PARTICIPANTTYPE");
					wfStatus 	= wfDetailsRet.getFieldValueString(wfDetailsRet.getRowCount()-1,"STATUS");
					myUID=getUserName(Session,nextParticipant,nextParType+"¥ID",collSys);
					delUser = wfDetailsRet.getFieldValueString(wfDetailsRet.getRowCount()-1,"NEXTDPARTICIPANT");
					if("APPROVED".equals(wfStatus) || "RELEASED".equals(wfStatus))
						sendReply = false;
					else 
						sendReply = true;					
					if(myUID!=null && !(myUID.trim()).equalsIgnoreCase((request.getParameter("qcf_user")).trim()))
					{
						if((delUser!=null && !(delUser.trim()).equalsIgnoreCase((request.getParameter("qcf_user")).trim())))
							sendReply = false;
						else
							sendReply = true;
					}	
					else 
						sendReply = true;
				}
							
				
			}
		}
	}
	else
	{
		sendReply = true;
	}
%>