<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="ezc.ezutil.*,ezc.ezmisc.params.*"%>
<%@ page import = "ezc.ezparam.*,ezc.ezadmin.ezadminutils.params.*" %>
<%@ page import="ezc.messaging.params.*" %>
<%@ page import="ezc.trans.messaging.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="Manager" class="ezc.client.EzMessagingManager" scope="session" />
<jsp:useBean id="ezMiscManager1" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<jsp:useBean id="AUM" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session" />


<%
	String 	msgSubject 	= "";
	String 	msgText 	= "";
	String sendToUser = "";

	
	String rfqNO		= request.getParameter("Rfqno");
	String remarks		= request.getParameter("Remarks");
	String rfqVend		= request.getParameter("rfqVend");
	Vector extMailIds= new Vector();
	
	
	
	if(remarks !=null && !"".equals(remarks) && remarks.indexOf("'")!=-1)
	{
		remarks = replaceString(remarks,"'","`");	
	}
	
	Vector vendorCodes 	= new Vector();
	vendorCodes.addElement(rfqVend);
	
%>
	<%//@ include file="../../../Vendor2/JSPs/RFQ/ezGetVenMailIds.jsp" %>
<%  
	String desc=(String)session.getValue("DRL_PURGROUP_DESC");

	msgSubject 	= "Request For Re Quotation  No :"+rfqNO+" From Dr. Reddy`s Labs Ltd";
	msgText 	= "<Br>Dear Vendor,\n\n <Br> <Br>This is a Request For Re Quote No : "+rfqNO+" from Dr. Reddy`s Labs Ltd. \n\n <Br> Select the Purchase Area  \""+desc+"\"  after login into the Portal.\n\n <Br> Please click on the following link to quote the RFQ. \n\n <Br> <a href=\"http://www.vikreta2drl.com\" target=_blank>Click here to Re Quote.</a>.\n\n <Br><Br> Regards, \n\n <Br>Dr. Reddy`s Labs Ltd.\n\n <Br><Br>";

	
	rfqVend = "0000000000"+rfqVend;
	rfqVend = rfqVend.substring((rfqVend.length()-10),rfqVend.length());
	
	
	ReturnObjFromRetrieve updateRet = null;
	ReturnObjFromRetrieve selectRet = null;
		
	ezc.ezparam.EzcParams mainMiscParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("UPDATE  EZC_RFQ_HEADER SET ERH_MODIFIED_BY ='"+Session.getUserId()+"',ERH_MODIFIED_ON=SYSDATE ,ERH_STATUS='N',ERH_REQUOTE='Y',ERH_EXT1='"+remarks+"' WHERE ERH_RFQ_NO ='"+rfqNO+"'");
	mainMiscParams.setLocalStore("Y");
	mainMiscParams.setObject(miscParams);
	Session.prepareParams(mainMiscParams);

	try
	{
		updateRet = (ReturnObjFromRetrieve)ezMiscManager1.ezUpdate(mainMiscParams);
	}
	catch(Exception e){}
	
	
	mainMiscParams=new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();
	
	miscParams.setQuery("SELECT EU_EMAIL FROM EZC_USERS WHERE EU_ID='"+rfqVend+"'");
	mainMiscParams.setLocalStore("Y");
	mainMiscParams.setObject(miscParams);
	Session.prepareParams(mainMiscParams);

	try
	{
		selectRet = (ReturnObjFromRetrieve)ezMiscManager1.ezSelect(mainMiscParams);
	}
	catch(Exception e){}
	
	

	//extMailIds.addElement(venMailIds.get(rfqVend));
	
	if(selectRet!=null && selectRet.getRowCount()>0)
	{
		extMailIds.addElement(selectRet.getFieldValueString(0,"EU_EMAIL"));		
	}

	EziAdminUtilsParams adminUtilsParams = new EziAdminUtilsParams();
	adminUtilsParams.setSyskeys((String)session.getValue("SYSKEY"));
	adminUtilsParams.setPartnerValueBy(rfqVend);

	EzcParams mainParams = new EzcParams(false);
	mainParams.setObject(adminUtilsParams);
	Session.prepareParams(mainParams);

	ReturnObjFromRetrieve partnersRet = (ReturnObjFromRetrieve)AUM.getUsersByPartnerValueAndArea(mainParams);
	sendToUser = partnersRet.getFieldValueString(0,"EU_ID"); 


	String sendToExt="Y";
	String language = "EN";
	String client2 = "200";

	EzMsgStructure msgStruc = null;
	EzPersonalMsgStructure[] msgDetails = null;

	msgStruc = new EzMsgStructure();
	msgStruc.setClient(client2);
	msgStruc.setPriorityFlag("U");
	msgStruc.setMsgHeader(msgSubject);
	msgStruc.setMsgContent1(msgText);
	msgStruc.setMsgContent2("");
	msgStruc.setLnkExtInfo("Lnk");


	EzcMessageParams  ezcMessageParams = new EzcMessageParams();
	EzMessageParams ezMessageParams = new EzMessageParams();
	ezMessageParams.setEzMsgStructure(msgStruc);

	ezcMessageParams.setObject(ezMessageParams);
	Session.prepareParams(ezcMessageParams);

	msgDetails = new EzPersonalMsgStructure[1];
	msgDetails[0] = new EzPersonalMsgStructure();

	msgDetails[0].setClient(client2);
	msgDetails[0].setRecUserId(sendToUser.toUpperCase());
	msgDetails[0].setExpiryDate("99999999");
	msgDetails[0].setExpiryDays(10);
	msgDetails[0].setReminderDate("0");
	msgDetails[0].setFolderId("1000");

	ezMessageParams.setEzPersonalMsgStructure(msgDetails);

	try
	{
		Manager.createPersonalMsg(ezcMessageParams);
	}
	catch(Exception e)
	{  
		ezc.ezcommon.EzLog4j.log("=========Error occured==============>"+sendToUser,"I");
	}
	
	String attachFlag=request.getParameter("attachFlag");
	
	if(attachFlag!= null)attachFlag= attachFlag.trim();
	
	
	String docType="REQUOTE";
	String docVal=rfqNO;
		
	if("Y".equals(attachFlag))
	{
%>
		<%@ include file="../../../Vendor2/JSPs/Attachments/iUploadDocs.jsp"  %> 	
<%
	}


%>
	<%@include file="../../../Vendor2/JSPs/Inbox/ezSendExternalMail.jsp" %>
