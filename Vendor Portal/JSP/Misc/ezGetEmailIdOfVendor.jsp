<%@ page import="java.util.*" %>
<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

// To Get Company codes :: start
		ezc.ezparam.ReturnObjFromRetrieve VendorCCRetObj=null;
		String vendCode = ((String)session.getValue("SOLDTO")).trim();
		
		try
		{	String purchaseArea = (String)session.getValue("SYSKEY");
			ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendortransactions.params.EzVendorParams  vendorParams= new ezc.vendortransactions.params.EzVendorParams();
			ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
			keyParams.setKey("GET_VENDOR_EMAIL");
			addMainParams.setLocalStore("Y");
			
			vendorParams.setVendor("VM0004");
			
			
			addMainParams.setObject(keyParams);	
			addMainParams.setObject(vendorParams);
			Session.prepareParams(addMainParams);
		
			VendorCCRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
			//out.println("VendorCCRetObj=="+VendorCCRetObj.toEzcString());EU_EMAIL
			
			
		
		}
		catch(Exception e)
		{
			out.println(":::Exception while getting company codes:::"+e);
		}
		// To Get Company codes :: end
%>		
		