<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	
	String vendCode = (String)session.getValue("SOLDTO");

	int count=0;
	ezc.ezparam.ReturnObjFromRetrieve VendorListRetObj=null;
	try
	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorAddressParams auditFindingParams= new ezc.vendortransactions.params.EzVendorAddressParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("GET_ADDR_CHANGED_VENDOR_LIST");
		
		auditFindingParams.setVendor("EVA_STATUS in ('SUBMITTED') AND EVA_VENDOR in ('"+vendCode+"')");
			
			
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		addMainParams.setLocalStore("Y");
		Session.prepareParams(addMainParams);

		VendorListRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
		if(VendorListRetObj!=null && VendorListRetObj.getRowCount()>0)
			count=VendorListRetObj.getRowCount();

	}
	catch(Exception e)
	{
		out.println(":::EEEE:::"+e);
	}
%>	