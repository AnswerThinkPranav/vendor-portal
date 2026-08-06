<%@ page import ="ezc.ezparam.*"%>
<%@ page import = "ezc.ezparam.EzCustomerAddrStructure"%>
<%@ include file="../../../Includes/Lib/Address.jsp"%>
<jsp:useBean id="VendManager" class="ezc.ezvendor.client.EzVendorManager" scope = "page">
</jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session">
</jsp:useBean>
<%

	EzCustomerAddrStructure in = new EzCustomerAddrStructure();
	ezc.ezparam.EzcVendorParams vendorParams = new ezc.ezparam.EzcVendorParams();
	EzVendorParams ezVendorParams = new EzVendorParams();
	ReturnObjFromRetrieve updateReturn = null;
	
	String telephone1="",email="",telephone2="",remark="";
	String payToCustNum = request.getParameter("defPayToCustNum");

	ezVendorParams.setLanguage("EN");
	
	String errorMessage = "";
	boolean isError = false;
		
	telephone1 	= request.getParameter("telephone1");
	telephone2 	= request.getParameter("telephone2");
	email 		= request.getParameter("email");
	remark 		= request.getParameter("contactPerson");
	
	if(telephone1==null || "null".equals(telephone1))telephone1="";
	if(telephone2==null || "null".equals(telephone2))telephone2="";
	if(email==null 	    || "null".equals(email))	 email="";
	if(remark==null     || "null".equals(remark))	 remark="";

	in.setPhone(telephone1.trim());
	in.setTel2(telephone2.trim());
	in.setEmail(email.trim());
	in.setRemark(remark.trim());
	
	//out.println("telephone1::"+telephone1);
	//out.println("email::"+email);

	ezVendorParams.setVendor(payToCustNum);
	vendorParams.setObject(ezVendorParams);
	vendorParams.setObject(in);
	Session.prepareParams(vendorParams);
	ezc.ezcommon.EzLog4j.log("before update","I");
	updateReturn = (ReturnObjFromRetrieve)VendManager.updateErpVendor(vendorParams);
	ezc.ezcommon.EzLog4j.log("afterupdate","I");

	if(updateReturn != null)
	{
		if("E".equals(updateReturn.getFieldValueString(0,"MSGTYP")))
		{
			isError = true;
			errorMessage = updateReturn.getFieldValueString(0,"MESSAGE");
		}
	}
	
	//out.println("updateReturn:::"+updateReturn.toEzcString());
			
%>


