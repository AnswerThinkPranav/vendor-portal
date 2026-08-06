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
	String vendorCode = ((String)session.getValue("SOLDTO")).trim();
	Calendar cal=Calendar.getInstance();
	int yr=cal.get(Calendar.YEAR);
	String year=yr+"";
	String companyName=request.getParameter("companyName");
	String houseNo=request.getParameter("houseNo");
	String address=request.getParameter("address");
	String city=request.getParameter("city");
	String district=request.getParameter("district");
	String state=request.getParameter("vendState");
	String country=request.getParameter("country");
	String pinCode=request.getParameter("pinCode");
	String contact=request.getParameter("contact");
	String email=request.getParameter("email");
	String compcode=request.getParameter("compcode");
	
	String fileName = request.getParameter("attachs");

	if(state==null || "null".equals(state))	state="";
	
	String refNo = "";
		
		
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorAddressParams vendorAddressParams= new ezc.vendortransactions.params.EzVendorAddressParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams vendKeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	
	try
	{
		vendKeyParams.setKey("SAVE_VENDOR_ADDR");
		
		vendorAddressParams.setVendor(vendorCode);
		vendorAddressParams.setYear(year);
		vendorAddressParams.setCompanyName(companyName);
		vendorAddressParams.setAddress1(houseNo);
		vendorAddressParams.setAddress2(address);
		vendorAddressParams.setCity(city);
		vendorAddressParams.setState(state);
		vendorAddressParams.setCountry(country);
		vendorAddressParams.setPin(pinCode);
		vendorAddressParams.setContactNo(contact);
		vendorAddressParams.setEMail(email);
		vendorAddressParams.setStatus("SUBMITTED");
		vendorAddressParams.setSavedBy(Session.getUserId());
		vendorAddressParams.setExt1(district);
		vendorAddressParams.setExt2("");
		vendorAddressParams.setExt3("");
		vendorAddressParams.setCompCode(compcode);
		vendorAddressParams.setNextApprover("PURPERSON");


		mainParams.setLocalStore("Y");
		mainParams.setObject(vendKeyParams);	
		mainParams.setObject(vendorAddressParams);
		Session.prepareParams(mainParams);

		ezAuditFindingManager.ezSaveVendorTransactions(mainParams);
		
		mainParams = new ezc.ezparam.EzcParams(false);
		vendorAddressParams= new ezc.vendortransactions.params.EzVendorAddressParams();
		vendKeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		
		
		vendKeyParams.setKey("GET_VEND_ADDR_CHANGE_REF_NO");
		mainParams.setLocalStore("Y");
		
		vendorAddressParams.setVendor(vendorCode);
		
		mainParams.setObject(vendKeyParams);	
		mainParams.setObject(vendorAddressParams);
		Session.prepareParams(mainParams);
		
		ezc.ezparam.ReturnObjFromRetrieve retRefNoObj = (ezc.ezparam.ReturnObjFromRetrieve)ezAuditFindingManager.ezGetVendorTransactions(mainParams);
		
		if(retRefNoObj!=null && retRefNoObj.getRowCount()>0)
			refNo = retRefNoObj.getFieldValueString(0,"REF_NO");
		
		
	}
	catch(Exception e)
	{
	      out.println(":::EEEE:::"+e);
	}
	
	String currSysKey = "999111";
	String documentNo = refNo+"";
	String uploadKey  = "ADDR_CHG";
	
%>
<%@ include file="../Misc/ezSaveUploadDocs.jsp"%>

<%
	/*String stmtIdKey = "GET_INT_USER_EMAIL";
	String msgSubject = "Address Change Request by Vendor : "+(String)session.getValue("Vendor");

	String ccMailIds  = "";
	String msgText = "Vendor Address Change Request is submitted for your approval.<Br> Reference No. : "+refNo+"<Br>";
	*/
%>
<%//@include file="../Misc/ezSendMail.jsp"%> 
<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	= "Address Change Request by Vendor : "+(String)session.getValue("Vendor");
	String msgText 		= "Vendor Address Change Request is submitted for your approval.<Br> Reference No. : "+refNo+"<Br>";
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

	ezc.ezcommon.EzLog4j.log("ADDRESS CHANGE MAILIDS>>>>>>>"+toEMailIds,"I");
%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>
<%
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Address Change Request is submitted to MTR. <Br> Reference No. : "+refNo);
%>
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>