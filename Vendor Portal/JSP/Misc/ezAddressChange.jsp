<jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Html>
<Head>
<Script>
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Change Vendor Address";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
<%

String vendorCode = ((String)session.getValue("SOLDTO")).trim();
String refNum 	= request.getParameter("refNum");
String companyName 	= request.getParameter("companyName");
String address1 	= request.getParameter("address1");
String address2 	= request.getParameter("address2");
String city 	= request.getParameter("city");
String state 	= request.getParameter("state");
String pinCode 	= request.getParameter("pinCode");
String country 	= request.getParameter("country");
String contact 	= request.getParameter("contact");
String email 	= request.getParameter("email");
String compcode=request.getParameter("compcode");

//out.println("contact=="+contact);




int count=0;
ezc.ezparam.ReturnObjFromRetrieve auditListRetObj=null;
try

{
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorAddressParams vendorAddressParams= new ezc.vendortransactions.params.EzVendorAddressParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyParams.setKey("UPDATE_VENDOR_ADDR");
	addMainParams.setLocalStore("Y");
	vendorAddressParams.setCompanyName(companyName);
	vendorAddressParams.setAddress1(address1);
	vendorAddressParams.setAddress2(address2);
	vendorAddressParams.setCity(city);
	vendorAddressParams.setState(state);
	vendorAddressParams.setCountry(country);
	vendorAddressParams.setPin(pinCode);
	vendorAddressParams.setContactNo(contact);
	vendorAddressParams.setEMail(email);
	vendorAddressParams.setStatus("SUBMITTED");
	 vendorAddressParams.setSavedBy(Session.getUserId());
	 vendorAddressParams.setExt1("");
	 vendorAddressParams.setExt2("");
	 vendorAddressParams.setExt3("");
	 vendorAddressParams.setCompCode(compcode);
	 vendorAddressParams.setVendor(vendorCode);
 	vendorAddressParams.setRefNo(refNum);
	

	addMainParams.setObject(keyParams);	
	addMainParams.setObject(vendorAddressParams);
	Session.prepareParams(addMainParams);

	ezAuditFindingManager.ezUpdateVendorTransactions(addMainParams);
	
	

}
catch(Exception e)
{
	out.println(":::EEEE:::"+e);
}
%>
<%
	/*String stmtIdKey = "GET_INT_USER_EMAIL";
	String msgSubject = "Address Change Request by Vendor : "+(String)session.getValue("Vendor");

	String ccMailIds  = "";
	String msgText = "Vendor Address Change Request is submitted for your approval.";
	*/
%>
<%//@include file="../Misc/ezSendMail.jsp"%> 

<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	= "Address Change Request by Vendor : "+(String)session.getValue("Vendor");
	String msgText 		= "Vendor Address Change Request is submitted for your approval.";
	String toEMailIds 	= (String)eMailIdHT.get("PH");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";

	ezc.ezcommon.EzLog4j.log("ADDRESS CHANGE MAILIDS>>>>>>>"+toEMailIds,"I");

%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>

	response.sendRedirect("../Shipment/ezMessage.jsp?Msg=Address Change Request is submitted successfully to MTR.");
%>
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>