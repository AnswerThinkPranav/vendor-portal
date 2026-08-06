<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<Html>
<Head>
<Script>
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Save  Address";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

<%
	String vendorCode= (String)session.getValue("SOLDTO");
	
	if(vendorCode!=null)
		vendorCode = vendorCode.trim();

	String quarter=request.getParameter("quater");
	String companyCode=request.getParameter("companyCode");
	String comments=request.getParameter("comments");
	String year=request.getParameter("startYear");
	
	String startDate=request.getParameter("startDate");
	String endDate=request.getParameter("endDate");

	try
	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorBalConfirmParams vendBalConfirmParams= new ezc.vendortransactions.params.EzVendorBalConfirmParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("SAVE_VEND_BAL_CONFIRM");
		addMainParams.setLocalStore("Y");

		vendBalConfirmParams.setVendor(vendorCode);
		vendBalConfirmParams.setConfQuarter(quarter);
		vendBalConfirmParams.setYear(year);
		vendBalConfirmParams.setCompCode(companyCode);
		vendBalConfirmParams.setConfirmedBy(Session.getUserId());
		vendBalConfirmParams.setComments(comments);
		vendBalConfirmParams.setQrtrStartDate(startDate);
		vendBalConfirmParams.setQrtrEndDate(endDate);
		vendBalConfirmParams.setExt1("");
		vendBalConfirmParams.setExt2("");
		vendBalConfirmParams.setExt3("");


		addMainParams.setObject(keyParams);	
		addMainParams.setObject(vendBalConfirmParams);
		Session.prepareParams(addMainParams);

		ezAuditFindingManager.ezSaveVendorTransactions(addMainParams);

	}
	catch(Exception e)
	{
	      out.println(":::EEEE:::"+e);
	}
	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";


	String eMailData = "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th "+thBGColor+">Year : </Th><Td "+tdBGColor+">"+year+"</Td><Th "+thBGColor+">Quarter :</Th><Td "+tdBGColor+">"+quarter+"</Td><Th "+thBGColor+">Company Code : </Th><Td "+tdBGColor+">"+companyCode+"</Td></Tr></Table><Br>";
	if(comments!=null && !"".equals(comments) && comments.length()>0)
		eMailData +=  "<Br><Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width = \"20%\" "+thBGColor+">Vendor Comments </Th><Td width = \"80%\">"+comments+"</Td><Tr></Table>";
		
	ezc.ezcommon.EzLog4j.log("eMailData::::::::::::::"+eMailData,"I");
	

	/*String stmtIdKey = "GET_INT_USER_EMAIL";
	String msgSubject = "Confirmation of A/C Statement for Q"+quarter+" ["+year+" ] by Vendor : "+(String)session.getValue("Vendor");
	String ccMailIds  = "";
	String msgText = eMailData;
	*/
%>
<%//@include file="../Misc/ezSendMail.jsp"%> 
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	=  "Confirmation of A/C Statement for Q"+quarter+" ["+year+" ] by Vendor : "+(String)session.getValue("Vendor");
	String msgText 		=  eMailData;
	String toEMailIds 	= (String)eMailIdHT.get("FN");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";


	ezc.ezcommon.EzLog4j.log("A/C Statement Confirmation -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");

%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Account Statement  confirmation is sent to MTR successfully.");
%>
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>