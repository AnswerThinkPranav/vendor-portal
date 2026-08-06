<jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%
	ezc.ezparam.ReturnObjFromRetrieve auditListRetObj=null;
	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorAddressParams vendorAddressParams= new ezc.vendortransactions.params.EzVendorAddressParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("UPDATE_VEND_ADDR_STATUS");
		addMainParams.setLocalStore("Y");
		vendorAddressParams.setStatus(changeStatus);
		vendorAddressParams.setSubmittedBy(Session.getUserId());
		vendorAddressParams.setNextApprover(nextParticipant);
		vendorAddressParams.setVendor(vendor);
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