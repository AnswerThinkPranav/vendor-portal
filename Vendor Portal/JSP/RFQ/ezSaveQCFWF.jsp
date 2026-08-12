<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<%//@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%>  
<%//@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%//@ include file="../Misc/ezHeader.jsp"%> 
<%

	
	String auctionId 	= qcfNo;     //qcfNo
	
	String logonSite = (String)session.getValue("SITE");
	String portalURL = "";
	ResourceBundle sitBundleObj=null;
	try
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		portalURL=sitBundleObj.getString("PORTAL_URL");
	}
	catch(Exception e)
	{ 
	    
	}	
	if(comments != null)
		comments = comments.replaceAll("'","`");
	String template = "";
	ezc.ezparam.ReturnObjFromRetrieve wfTemRet = getWFTemplate(Session,"QCF",plant,category,compCode);
	out.print("wfTemRet:::"+wfTemRet.toEzcString());
	if(wfTemRet != null)
	{
		template=wfTemRet.getFieldValueString(0,"EWKM_TEMPLATE");
	}
	
	//MAIL
	String mailSub="QCF SUBMITTED FOR APPROVAL - "+auctionId;
	//String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
	String offlineLink = "https://vendor.jolcorp.info/JUBL/ezLogin.jsp";
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

	String mailText="Dear Sir/Madam,<br> Below QCF details submitted for your approval<br>";
	mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>QCF NO</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+auctionId+"</Td></Tr>";	
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Documemnt Value</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+docVal+"</Td></Tr>";	
	mailText +=  "</Table><Br>";
	mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	mailText +=  "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
	
	//WF
	if(template != null && !"null".equals(template) && !"".equals(template))
	{
		int curStep = 1;
		ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,template,curStep);
		String wfStatus = "SUBMITTED";
		String nextPart = "";
		String ccEmailStr = getUserMail(Session,(String)Session.getUserId());
		ezc.ezcommon.EzLog4j.log("ccEmailStr in WF =====**"+ccEmailStr,"I");
		
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add("INSERT INTO EZC_WF_DOC_HISTORY_HEADER(EWDHH_AUTH_KEY,EWDHH_DOC_ID,EWDHH_SYSKEY,EWDHH_TEMPLATE_CODE,EWDHH_WF_STATUS,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_MODIFIED_BY,EWDHH_CURRENT_STEP,EWDHH_NEXT_PARTICIPANT) VALUES('QCF','"+auctionId+"','"+sysKey+"','"+template+"','"+wfStatus+"',now(),now(),'"+Session.getUserId()+"','"+Session.getUserId()+"',"+wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL")+",'"+wfNextPartRet.getFieldValueString(0,"EWPC_GROUP")+"')");
		queriesList.add("UPDATE EZC_RFQ_HEADER SET ERH_WF_STATUS='SUBMITTED',ERH_FINAL_VALUE='"+docVal+"' WHERE ERH_COLLETIVE_RFQ_NO='"+auctionId+"'");
		queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+auctionId+"','QCF','"+comments+"','"+Session.getUserId()+"',now())");
		ezMiscInsert(Session,queriesList);
		saveWFDocAudit(Session,auctionId,"QCF","QCF details submitted by "+Session.getUserId()+"["+v_fullName+"]","U");
		
		ReturnObjFromRetrieve userRet = getWorkFlowMails(Session,wfNextPartRet.getFieldValueString(0,"EWPC_GROUP"),plant,category);
		int userRetCnt = 0;
		if(userRet != null)
		{
			userRetCnt = userRet.getRowCount();
		}
		for(int i=0;i<userRetCnt;i++)
		{
			String linkId=saveLinkControllerData(Session,auctionId,"QCF",userRet.getFieldValueString(i,"EU_ID"),userRet.getFieldValueString(i,"EU_EMAIL"),mailText);
			sendMails(Session,userRet.getFieldValueString(i,"EU_EMAIL"),ccEmailStr,"",mailText.replace("JBTEID",linkId),mailSub);
			
		}
		
		noDataStatement = "QCF details : <strong>"+auctionId+"</strong>  sent for approval";
	}
	else
	{
		noDataStatement = "No Workflow exists for the selected defaults.";
	}
%>



