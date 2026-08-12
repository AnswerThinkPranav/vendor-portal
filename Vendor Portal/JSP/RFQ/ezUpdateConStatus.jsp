<%@ page import="java.util.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%@ page import = "ezc.ezutil.FormatDate,ezc.ezparam.*"%>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
	String agmtNo = request.getParameter("agmtNo");
	String qcsCommentNo = request.getParameter("qcsCommentNo");
	String comments = request.getParameter("reasons");
	String conAckStatus = "";//request.getParameter("conAckStatus");
	String conDocUpload = request.getParameter("conDocUpload");
	String vendor	    = request.getParameter("vendor");
	
	String conType		= request.getParameter("conType");	
	String conStartDate	= request.getParameter("conStartDate");
	String conEndDate	= request.getParameter("conEndDate");


	String conItemCode[]	= request.getParameterValues("conItemCode");
	String conItemDesc[]	= request.getParameterValues("conItemDesc");
	String conItemQty[]	= request.getParameterValues("conItemQty");
	String conItemPrice[]	= request.getParameterValues("conItemPrice");
	String conItemValue[]	= request.getParameterValues("conItemValue");



	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";


	String eMailData = "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th "+thBGColor+">Contract No. : </Th><Td "+tdBGColor+">"+agmtNo+"</Td><Th "+thBGColor+">Type :</Th><Td "+tdBGColor+">"+conType+"</Td><Th "+thBGColor+">Start Date : </Th><Td "+tdBGColor+">"+conStartDate+"</Td><Th "+thBGColor+">End Date :</Th><Td "+tdBGColor+">"+conEndDate+"</Td><Tr></Table><Br>";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Material</B></Th><Th width= \"20%\" "+thBGColor+"><B>Description</B></Th><Th width= \"10%\" "+thBGColor+"><B>Qty</B></Th><Th width= \"10%\" "+thBGColor+"><B>Price</B></Th><Tr>";

	for(int i=0;i<conItemCode.length;i++)
	{
		eMailData +=  "<Tr "+bgColor+"><Td width= \"6%\" "+tdBGColor+" align='center'>"+conItemCode[i]+"</Td><Td width= \"10%\" "+tdBGColor+"  align='left'>"+conItemDesc[i]+"</Td><Td width= \"20%\" "+tdBGColor+"  align='right'>"+conItemQty[i]+"</Td><Td width= \"7%\" "+tdBGColor+"  align='right'>"+conItemPrice[i]+"</Td></Tr>";
	}
	eMailData +=  "</Table>";

	if(comments!=null && !"".equals(comments) && comments.length()>0)
		eMailData +=  "<Br><Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width = \"20%\" "+thBGColor+">Comments  </Th><Td width = \"80%\">"+comments+"</Td><Tr></Table>";
	
	ezc.ezcommon.EzLog4j.log("eMailData::::::::::::::"+eMailData,"I");

	
	String userType =(String)session.getValue("UserType");	
	
	if("2".equals(userType))
		conAckStatus = "B";
	if("3".equals(userType))
		conAckStatus = "V";	
	
	ezc.ezparam.EzcParams poMainParams = new ezc.ezparam.EzcParams(true);
	poMainParams.setLocalStore("Y");	    

	ezc.ezvendorapp.params.EzPOAcknowledgementTable poTable =  new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
	ezc.ezvendorapp.params.EzPOAcknowledgementTableRow poTableRow = null;
	String podate = request.getParameter("OrderDate");	

	java.util.Date d = new java.util.Date();	
	FormatDate formatDate = new FormatDate();
	String date1=formatDate.getStringFromDate(d,"/",FormatDate.DDMMYYYY);


	poTableRow =  new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();
	poTableRow.setDocNo(agmtNo);
	poTableRow.setDocStatus(conAckStatus);
	poTableRow.setModifiedOn(date1);
	poTable.appendRow(poTableRow);	

	poMainParams.setObject(poTable);	
	Session.prepareParams(poMainParams);
	AppManager.ezUpdatePOAcknowledgement(poMainParams);
	
	

	ezc.ezpreprocurement.client.EzPreProcurementManager qcfManager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	mainParams.setLocalStore("Y");
	ezc.ezpreprocurement.params.EziQcfCommentParams qcfParams= new ezc.ezpreprocurement.params.EziQcfCommentParams();
	qcfParams.setQcfCode(agmtNo);
	qcfParams.setCommentNo(qcsCommentNo);
	qcfParams.setQcfUser(Session.getUserId());
	qcfParams.setQcfComments(comments);
	qcfParams.setQcfType("COMMENTS");
	qcfParams.setQcfDestUser(Session.getUserId());
	qcfParams.setQcfExt1("$$");
	mainParams.setObject(qcfParams);
	Session.prepareParams(mainParams);
	qcfManager.addQcfComment(mainParams);
	
	String currSysKey = "999111";
	String documentNo = agmtNo;
	String uploadKey  = conAckStatus+"CONTRACT";
	String fileName   = conDocUpload;
%>
<%@ include file="../Misc/ezSaveUploadDocs.jsp"%>
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String stmtIdKey = "";
	
	if("2".equals(userType))
		 stmtIdKey = "GET_VENDOR_EMAIL,"+vendor;
	else if("3".equals(userType))
		 stmtIdKey = "GET_INT_USER_EMAIL";
		 
	String msgSubject = "";
	
	if("2".equals(userType))
		msgSubject = "Contract : "+agmtNo+" is Signed by MTR and sent to you";
	else if("3".equals(userType))	
		msgSubject = "Contract : "+agmtNo+" is Signed by Vendor : "+(String)session.getValue("Vendor");

	String ccMailIds  = "";
	String msgText = eMailData;
	
	
	
	String toEMailIds 	= (String)eMailIdHT.get("PP");
	
	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";

	if("".equals(toEMailIds))
	{
		if(eMailIdHT.get("FPM")!=null)
			toEMailIds = (String)eMailIdHT.get("FPM");
	}
	else
	{
		if(eMailIdHT.get("FPM")!=null)
			toEMailIds += ","+(String)eMailIdHT.get("FPM");
	}				

	if("".equals(toEMailIds))
	{
		if(eMailIdHT.get("HOPM")!=null)
			toEMailIds = (String)eMailIdHT.get("HOPM");
	}
	else
	{
		if(eMailIdHT.get("HOPM")!=null)
			toEMailIds += ","+(String)eMailIdHT.get("HOPM");
	}	
	
	ezc.ezcommon.EzLog4j.log("CONTRCT SIGNED DOCUMENT UPLOAD BY VENDOR MAILIDS>>>>>>>"+toEMailIds,"I");
	
	
	
	if("2".equals(userType))
	{
%>
		<%@ include file="../Misc/ezSendMail.jsp"%>
<%
	}
	else if("3".equals(userType))	
	{
%>
		<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	}
%>

<%
	if("2".equals(userType))
		response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Contract status is updated and can be viewd by Vendor to upload his/her signed document.");
	else if("3".equals(userType))	
		response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Your signed document is sent to MTR.");
%>