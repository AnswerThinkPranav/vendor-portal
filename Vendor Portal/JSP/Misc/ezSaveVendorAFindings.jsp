<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%

	String auditNumber=request.getParameter("auditNumber");
	String vendor=request.getParameter("vendor");
	String year=request.getParameter("year");
	String month=request.getParameter("month");
	String buyerComments=request.getParameter("buyerComments");
	String vendorComments=request.getParameter("vendorComments");
	String fileName = request.getParameter("attachs");
	
	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";


	String eMailData = "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th "+thBGColor+">Audit No. : </Th><Td "+tdBGColor+">"+auditNumber+"</Td><Th "+thBGColor+">Year :</Th><Td "+tdBGColor+">"+year+"</Td><Th "+thBGColor+">Month : </Th><Td "+tdBGColor+">"+month+"</Td></Tr></Table><Br>";
	if(buyerComments!=null && !"".equals(buyerComments) && buyerComments.length()>0)
		eMailData +=  "<Br><Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width = \"20%\" "+thBGColor+">Buyer Comments (MTR) </Th><Td width = \"80%\">"+buyerComments+"</Td><Tr></Table>";
	if(vendorComments!=null && !"".equals(vendorComments) && vendorComments.length()>0)
		eMailData +=  "<Br><Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width = \"20%\" "+thBGColor+">Vendor Comments (MTR) </Th><Td width = \"80%\">"+vendorComments+"</Td><Tr></Table>";
	
	ezc.ezcommon.EzLog4j.log("eMailData::::::::::::::"+eMailData,"I");

	
	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzAuditFindingsParams auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("UPDATE_AUDITFINDINGS_STATUS");
		addMainParams.setLocalStore("Y");
		auditFindingParams.setRefNumber(auditNumber);
		auditFindingParams.setStatus("C");
		auditFindingParams.setVendor(vendor);
		auditFindingParams.setVendorComments(vendorComments);
		auditFindingParams.setModifiedBy(Session.getUserId());
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		Session.prepareParams(addMainParams);

		ezAuditFindingManager.ezUpdateVendorTransactions(addMainParams);

	}
	catch(Exception e)
	{
		      out.println(":::EEEE:::"+e);
	}

%>
<%
	String currSysKey = "999111";
	String documentNo = auditNumber+"";
	String uploadKey  = "VAUDIT";
	
%>
<%@ include file="../Misc/ezSaveUploadDocs.jsp"%>
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	=  "Reply to the Audit Finding.  Vendor : "+(String)session.getValue("Vendor");
	String msgText 		=  eMailData;
	String toEMailIds 	= (String)eMailIdHT.get("QA");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";

	ezc.ezcommon.EzLog4j.log("TOAUDITEMAILIDS>>>>>>>"+toEMailIds,"I");

%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Audit Status is updated and intimation is sent to MTR.");
%>