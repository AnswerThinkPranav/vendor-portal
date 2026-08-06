<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
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
	String display_header = "Save  Audit Findings";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

<%
	Hashtable monthNamesHT = new Hashtable();
	monthNamesHT.put("1","January");
	monthNamesHT.put("02","February");
	monthNamesHT.put("03","March");
	monthNamesHT.put("04","April");
	monthNamesHT.put("05","May");
	monthNamesHT.put("05","June");
	monthNamesHT.put("07","July");
	monthNamesHT.put("08","August");
	monthNamesHT.put("09","September");
	monthNamesHT.put("10","October");
	monthNamesHT.put("11","November");
	monthNamesHT.put("12","December");


	String dueDate = request.getParameter("dueDate");
	String vendor=request.getParameter("Vndr").split("#")[0];
	String year=request.getParameter("year");
	String month=request.getParameter("month");
	String auditFindingRem=request.getParameter("auditFindingRem");
	String fileName = request.getParameter("attachs");//"gc.txt";
	//String auditNo = "";
	
	try{
		Date date = new Date();
		String createdDate= new SimpleDateFormat("dd/MM/yyyy").format(date);
	}
	catch(Exception e)
	{
	      out.println(":::EEEE:::"+e);
	}
	try
	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzAuditFindingsParams auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("SAVE_AUDIT_FINDINGS");
		addMainParams.setLocalStore("Y");
		auditFindingParams.setVendor(vendor);
		auditFindingParams.setYear(year);
		auditFindingParams.setMonth(month);
		auditFindingParams.setBuyerComments(auditFindingRem);
		auditFindingParams.setCreatedBy(Session.getUserId());
		auditFindingParams.setModifiedBy(Session.getUserId());
		auditFindingParams.setExt1("");
		auditFindingParams.setExt2("");
		auditFindingParams.setExt3("");
		auditFindingParams.setDueDate(dueDate);
		auditFindingParams.setStatus("X");
		
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		Session.prepareParams(addMainParams);

		ezAuditFindingManager.ezSaveVendorTransactions(addMainParams);
		
		
		/*auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
		keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		
		keyParams.setKey("GET_AUDIT_FINDINGS");
		addMainParams.setLocalStore("Y");
		auditFindingParams.setVendor(" WHERE EAF_VENDOR = '"+vendor+"' AND EAF_YEAR = '"+year+"' AND EAF_YEAR = '"+month+"'");
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		Session.prepareParams(addMainParams);
		
		ezc.ezparam.ReturnObjFromRetrieve retAudFindObj = (ezc.ezparam.ReturnObjFromRetrieve)ezAuditFindingManager.ezGetVendorTransactions(addMainParams);
		
		if(retAudFindObj!=null && retAudFindObj.getRowCount()>0)
			auditNo = retAudFindObj.getFieldValueString(0,"EAF_AUDIT_NO");
		*/	
		
		
	}
	catch(Exception e)
	{
	      out.println(":::EEEE:::"+e);
	}	
%>
<%@ include file="../../../Includes/JSPs/Misc/iGetMaxAuditNo.jsp" %>
<%
	String currSysKey = "999111";
	String documentNo = auditNo+"";
	String uploadKey  = "BAUDIT";
	
%>
<%@ include file="../Misc/ezSaveUploadDocs.jsp"%>
<%
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";


	String eMailData = "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th "+thBGColor+">Audit No. : </Th><Td "+tdBGColor+">"+auditNo+"</Td><Th "+thBGColor+">Month :</Th><Td "+tdBGColor+">"+monthNamesHT.get(month)+"</Td><Th "+thBGColor+"> Year : </Th><Td "+tdBGColor+">"+year+"</Td></Tr></Table><Br>";
	if(auditFindingRem!=null && !"".equals(auditFindingRem) && auditFindingRem.length()>0)
		eMailData +=  "<Br><Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width = \"20%\" "+thBGColor+">Comments (MTR) </Th><Td width = \"80%\">"+auditFindingRem+"</Td><Tr></Table>";

	ezc.ezcommon.EzLog4j.log("eMailData::::::::::::::"+eMailData,"I");

	String stmtIdKey = "GET_VENDOR_EMAIL,"+vendor;
	String msgSubject = "Auding Findings for the Month : "+monthNamesHT.get(month)+" [ "+year+" ] From MTR Foods";

	String ccMailIds  = "";
	String msgText = eMailData;
%>
<%@include file="../Misc/ezSendMail.jsp"%> 
<%
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg= Audit Findings are saved successfully. Reference Number : "+auditNo);
%>
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>