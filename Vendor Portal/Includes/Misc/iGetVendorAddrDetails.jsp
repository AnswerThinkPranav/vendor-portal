<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
String refNo = request.getParameter("refNo");
String vendorCode = request.getParameter("vendorCode");

//out.println("vendCode=="+ vendCode);

int count=0;
ezc.ezparam.ReturnObjFromRetrieve VendorListRetObj=null;
try

{
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorAddressParams auditFindingParams= new ezc.vendortransactions.params.EzVendorAddressParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyParams.setKey("GET_VENDOR_ADDR");
	addMainParams.setLocalStore("Y");
	auditFindingParams.setVendor(vendorCode+"') AND EVA_REF_NO IN ('"+refNo);
	addMainParams.setObject(keyParams);	
	addMainParams.setObject(auditFindingParams);
	Session.prepareParams(addMainParams);

	VendorListRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
	//out.println("VendorListRetObj=="+VendorListRetObj.toEzcString());
	if(VendorListRetObj!=null && VendorListRetObj.getRowCount()>0)
	{
	count=VendorListRetObj.getRowCount();
	//out.println("count=="+count);
	}

}
catch(Exception e)
{
	out.println(":::EEEE:::"+e);
}


%>	