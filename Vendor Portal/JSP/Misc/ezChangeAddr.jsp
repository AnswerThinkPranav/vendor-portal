<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

String vendCode = ((String)session.getValue("SOLDTO")).trim();
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
	 vendorAddressParams.setVendor(Session.getUserId());
 	vendorAddressParams.setRefNo(refNum);
	

	addMainParams.setObject(keyParams);	
	addMainParams.setObject(vendorAddressParams);
	Session.prepareParams(addMainParams);

	EzAuditFindingManager.ezUpdateVendorTransactions(addMainParams);
	
	

}
catch(Exception e)
{
	out.println(":::EEEE:::"+e);
}


%>	