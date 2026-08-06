<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String statusFlag = request.getParameter("statusFlag");
	String tempType = "";
	
	if("TBA".equals(statusFlag))
		tempType = "SUBMITTED";
	else if("A".equals(statusFlag))
		tempType = "APPROVED";
	
	String vendCode = (String)session.getValue("SOLDTO");
	String userType = (String)session.getValue("UserType");
	String userGroup = (String)session.getValue("USERGROUP");
	
	if(userGroup!=null)
		userGroup = userGroup.trim();
	
	if(vendCode!=null)
		vendCode = vendCode.trim();

	int count=0;
	ezc.ezparam.ReturnObjFromRetrieve VendorListRetObj=null;
	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorAddressParams auditFindingParams= new ezc.vendortransactions.params.EzVendorAddressParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("GET_ADDR_CHANGED_VENDOR_LIST");
		
		
		if("2".equals(userType))
		{
			auditFindingParams.setVendor("EVA_STATUS in ('"+tempType+"')");
			
			if("SUBMITTED".equals(tempType))
				auditFindingParams.setVendor("EVA_STATUS in ('"+tempType+"') AND EVA_NEXT_APPROVER= '"+userGroup+"'");
			
			
		}	
		else
			auditFindingParams.setVendor("EVA_STATUS in ('"+tempType+"') AND EVA_VENDOR in ('"+vendCode+"')");
			
			
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		addMainParams.setLocalStore("Y");
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