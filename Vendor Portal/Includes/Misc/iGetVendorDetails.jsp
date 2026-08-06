<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%
	ezc.ezparam.ReturnObjFromRetrieve listRet=null;	
	try
	
	{
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzAuditFindingsParams auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyParams.setKey("GET_VENDOR_ADDR");
	addMainParams.setLocalStore("Y");
	auditFindingParams.setVendor("VC0101");
	
	addMainParams.setObject(keyParams);	
	addMainParams.setObject(auditFindingParams);
	Session.prepareParams(addMainParams);
	
	listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
	out.println("listRet=="+listRet);
	
	}
	catch(Exception e)
	{
		      out.println(":::EEEE:::"+e);
	}
	
%>	