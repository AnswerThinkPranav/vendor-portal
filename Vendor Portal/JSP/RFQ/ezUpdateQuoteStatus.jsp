<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import ="ezc.vendorprofile.params.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezparam.*" %>
<%@ include file="../Misc/ezHeader.jsp"%> 
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>

<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull1(String str)
	 {
		if("null".equals(str) ||str==null)
		str="NA";
		return str;
 	}
%>

<%
String comments  	 = checkNull(request.getParameter("comments"));
comments=comments.replaceAll("'","`");
	String rfqNumber 	= checkNull(request.getParameter("rfqNumber"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor"));

	boolean statusSuccess = false;
	String dispMessage="Problem occured in submitting quotation details",dispMsgType="E",divWidth="90%";
	
	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	EzRFQQuoteHistoryTable 	rfqQuoteHistoryTable 	= new EzRFQQuoteHistoryTable();
	
	EziRFQHeaderTableRow 	rfqHeaderRow 	= null;
	EziRFQDetailsTableRow 	rfqDetailsRow 	= null;	
	EzRFQConditionsTableRow rfqCondTableRow = null;
	EzRFQQuoteHistoryTableRow rfqQuoteHistoryTableRow = null;
	
	rfqHeaderRow = new EziRFQHeaderTableRow();

	rfqHeaderRow.setRFQNo(rfqNumber);
	rfqHeaderRow.setSoldTo(rfqVendor);
	rfqHeaderRow.setStatus("N");
	rfqHeaderRow.setRequestRequote("Y");

	rfqHeaderTable.appendRow(rfqHeaderRow);
		
	ezparams.setLocalStore("Y");
	ezparams.setObject(rfqHeaderTable);
	ezparams.setObject(rfqDetailsTable);
	ezparams.setObject(rfqCondTable);
	ezparams.setObject(rfqQuoteHistoryTable);
	Session.prepareParams(ezparams);
	
	ezc.ezcommon.EzLog4j.log("::::::rfqQuoteHistoryTable::::::::::::"+ezparams.getObject("ezc.ezpreprocurement.params.EzRFQConditionsTable"),"I");
	try
	{
		ReturnObjFromRetrieve statusRet = (ReturnObjFromRetrieve)rfqManager.ezUpdateRFQ(ezparams);
		
		if(!statusRet.isError())
		{
			statusSuccess = true;
			dispMessage="Requote Request sent Successfully.";
			dispMsgType="S";
		}	
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Error while update requote status in DB"+e,"I");
	}
	
	
	if(statusSuccess)
	{
ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_DOCUMENT_COMMENTS");
		mainParams.setLocalStore("Y");

		documentComments.setDocId(rfqNumber);
		documentComments.setDocType("RFQ");
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
	
	String toEMailIds 	= "";
		ReturnObjFromRetrieve retUserData=null;

		EzcUserParams uparamsN= new EzcUserParams();
		EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
		ezcUserNKParamsN.setLanguage("EN");
		uparamsN.setUserId(Integer.parseInt(rfqVendor)+"");
		uparamsN.createContainer();
		uparamsN.setObject(ezcUserNKParamsN);
		Session.prepareParams(uparamsN);
		try
		{					
			retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
			
			toEMailIds=checkNull(retUserData.getFieldValueString("EU_EMAIL"));
		}
		catch(Exception e)
		{
			System.out.println("Failed to Get User MailId.Probably b'coz wrong UserId");
		}
		
		String docNumber = rfqNumber;

		String msgSubject 	= "Coromandel : Requotation Request for RFQ "+rfqNumber;
		String msgText 		= "Dear Sir/Madam, <br><br> RFQ "+rfqNumber+" has been resent for your Quotation. <Br> <br>";
		msgText += "Regards,<br>"+v_fname+v_mname+v_lname;
		//String toEMailIds 	= (String)eMailIdHT.get("PP");
		
		String eMailData	= "",ccEMailIds="";

		if(toEMailIds==null || "null".equals(toEMailIds))
			toEMailIds = "";

		ezc.ezcommon.EzLog4j.log("RE-QUOTATION -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");
%>
		<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	}
	
	String display_header = "Quotation Submission Status";
%>

<html>
<head>

<script>
	function funOK()
	{
		location.href="../Misc/ezWelcome_New.jsp";
	}
</script>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="funOK()">Ok</button>  &nbsp;	
</center>

<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
 
