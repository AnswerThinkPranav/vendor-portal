<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

	String vendorCode = request.getParameter("vendorCode");
	String fromDate = request.getParameter("FromDate");
	String toDate = request.getParameter("ToDate");	
	String userType = (String)session.getValue("UserType");
	
	
	if("3".equals(userType))
	{
		vendorCode	= (String) session.getValue("SOLDTO");	
		if(vendorCode!=null)
			vendorCode = vendorCode.trim();
	}

	String qryString = " WHERE ";
	if(vendorCode!=null && !"".equals(vendorCode) && !"null".equals(vendorCode))
		qryString += "EAF_VENDOR='"+vendorCode+"' AND ";
		
	qryString += " EAF_CREATED_ON BETWEEN TO_DATE('"+fromDate+"','DD/MM/YYYY') AND TO_DATE('"+toDate+" 23:50:00','DD/MM/YYYY HH24:MI:SS')";


	int count=0;
	ezc.ezparam.ReturnObjFromRetrieve auditListRetObj=null;
	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzAuditFindingsParams auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("GET_AUDIT_FINDINGS");
		addMainParams.setLocalStore("Y");
		auditFindingParams.setVendor(qryString);
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		Session.prepareParams(addMainParams);

		auditListRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
		//out.println("auditListRetObj=="+auditListRetObj.toEzcString());
		if(auditListRetObj!=null && auditListRetObj.getRowCount()>0)
		{
		count=auditListRetObj.getRowCount();
		//out.println("count=="+count);
		}

	}
	catch(Exception e)
	{
		out.println(":::EEEE:::"+e);
	}


%>	