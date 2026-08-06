<%@ page import ="ezc.ezparam.*"%>
<%@ page import = "ezc.ezparam.EzCustomerAddrStructure"%>
<jsp:useBean id="VendManager" class="ezc.ezvendor.client.EzVendorManager" scope = "page"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%

	EzCustomerAddrStructure in = new EzCustomerAddrStructure();
	ezc.ezparam.EzcVendorParams vendorParams = new ezc.ezparam.EzcVendorParams();
	EzVendorParams ezVendorParams = new EzVendorParams();
	ReturnObjFromRetrieve updateReturn = null;
	
	String errorMessage = "";
	boolean isError = false;
	
	String refNum 		= request.getParameter("refNum");
	String vendor		= request.getParameter("vendor");
	String companyCode 	= request.getParameter("companyCode");
	
	String houseNo 		= request.getParameter("houseNo");
	String address 		= request.getParameter("address");
	String city 		= request.getParameter("city");
	String district 	= request.getParameter("district");
	String postalCode 	= request.getParameter("postalCode");
	String telephone1 	= request.getParameter("telephone1");
	String email 		= request.getParameter("email");
	
	if(houseNo!=null)
		houseNo = houseNo.trim();
	if(address!=null)
		address = address.trim();	
	if(postalCode!=null)
		postalCode = postalCode.trim();	
	if(city!=null)
		city = city.trim();	
	if(district!=null)
		district = district.trim();	
	if(telephone1!=null)
		telephone1 = telephone1.trim();	
	if(email!=null)
		email = email.trim();		
		
		
	in.setAddr1(houseNo);
	in.setAddr2(address);
	in.setPostalCode(postalCode);
	in.setDistrict(district);
	in.setCity(city);
	in.setTel1(telephone1);
	in.setEmail(email);
	
	ezVendorParams.setVendor(vendor);
	ezVendorParams.setCompCode(companyCode);
	vendorParams.setObject(ezVendorParams);
	vendorParams.setObject(in);
	Session.prepareParams(vendorParams);
	ezc.ezcommon.EzLog4j.log("before update","I");
		
	try{
		updateReturn = (ReturnObjFromRetrieve)VendManager.updateErpVendor(vendorParams);
	}catch(Exception e)
	{
		out.print(":::"+e);
	}
	ezc.ezcommon.EzLog4j.log("afterupdate","I");
	if(updateReturn != null)
	{
		if("E".equals(updateReturn.getFieldValueString(0,"MSGTYP")))
		{
			isError = true;
			errorMessage = updateReturn.getFieldValueString(0,"MESSAGE");
		}
		else
		{
		
			String nextParticipant = "";
			String changeStatus = "APPROVED";
%>
			<%@ include file="ezUpdateVenAddrStatus.jsp"%>	
<%
		}
	}				
%>


