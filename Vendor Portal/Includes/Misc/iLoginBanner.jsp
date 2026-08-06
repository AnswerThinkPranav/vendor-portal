<%@ page import ="ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*"%>
<jsp:useBean id="vendorTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	String name 		= "";
	String fname	=	(String)session.getValue("FIRST_NAME");
	String mname	=	(String)session.getValue("MIDDLE_INITIAL");
	String lname	=	(String)session.getValue("LAST_NAME");
	
	if(fname==null||"null".equals(fname))fname="";
	if(mname==null||"null".equals(mname))mname="";
	if(lname==null||"null".equals(lname))lname="";
	
	String userPurGroups = (String)session.getValue("USERDEFPURGRP");
	
	String userType = (String)session.getValue("UserType");
	
	String fullName = "";
	if("3".equals(userType))
		fullName = (String)session.getValue("Vendor");
	else
		fullName = fname+" "+lname;
	
	String callPreWelcomePage = "N";
	if(request.getParameter("callPreWelcomePage") != null)
		callPreWelcomePage = request.getParameter("callPreWelcomePage");

	String init = ""; 
	if(request.getParameter("INIT") != null)
		init = request.getParameter("INIT");
		
	/*---FOR PAGE REFRESH CHECKING REF AT iPurMgrWelcome.jsp---*/
	if("FIRST".equals(init))
		session.putValue("INITVAL",init);
	/*--------------------------END--------------------------*/
		
	
	String changePurArea = "N";
	if(request.getParameter("changePurArea") != null)
		changePurArea = request.getParameter("changePurArea");

	String purchaseArea = request.getParameter("CatalogArea");
	String vendorCode   = request.getParameter("VENDOR_CODE");
	String vendorName   = request.getParameter("VENDOR_NAME");
	String compCode	    =	"";

	if(vendorCode == null)
		vendorCode = (String)session.getValue("SOLDTO");
	if(vendorName == null)
		vendorName = (String)session.getValue("Vendor");
	
	if(purchaseArea == null)
		purchaseArea = (String)session.getValue("SYSKEY");
		
	ezc.ezcommon.EzLog4j.log(vendorCode+":::::"+vendorName+":::::::"+callPreWelcomePage+"<<<<<<<<<<CHECKOOOOOOOOOOO","I");	

	
	int catareaRows = 0;
	ezc.client.EzcPurchaseUtilManager PurManager 	= new ezc.client.EzcPurchaseUtilManager(Session);
	ReturnObjFromRetrieve retUserPurAreas 		= (ReturnObjFromRetrieve)session.getValue("RETCATAREA");//PurManager.getUserPurAreas();
	if(retUserPurAreas != null)
	{
		catareaRows = retUserPurAreas.getRowCount();
		if(catareaRows > 0)
		{
			retUserPurAreas.sort(new String[]{"ESKD_SYS_KEY_DESC"},true);
		}	
	}
	
	java.util.Hashtable  purGroupsHash = new java.util.Hashtable();
	java.util.Hashtable templatehash   = new java.util.Hashtable();
	java.util.Hashtable ccHash		= new java.util.Hashtable();
	java.util.Vector catAreas 	   = new java.util.Vector();	
	
	String vendUserType = (String)session.getValue("UserType");
	String vendUserSoldTo = (String)session.getValue("SOLDTO");

	java.util.Hashtable vendorsHT = new java.util.Hashtable(); 
	int vendorsRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve retsoldto = null;

	ezc.ezparam.EzcParams vendorMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams vendorKeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzVendorParams  vendorBannerParams= new ezc.vendortransactions.params.EzVendorParams();

	try
	{
		vendorKeyParams.setKey("GET_VENDORS");
		vendorMainParams.setLocalStore("Y");

		if("2".equals(vendUserType))
			vendorBannerParams.setSyskey(purchaseArea);
		else
			vendorBannerParams.setSyskey(purchaseArea+"') AND LTRIM(RTRIM(EC_ERP_CUST_NO)) = ('"+vendUserSoldTo.trim());

		vendorBannerParams.setGroup(" AND EC_SYS_KEY = EWWU_SYSKEY");

		vendorMainParams.setObject(vendorKeyParams);	
		vendorMainParams.setObject(vendorBannerParams);
		Session.prepareParams(vendorMainParams);

		retsoldto=(ezc.ezparam.ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(vendorMainParams);
	}
	catch(Exception e){
		out.println(":::EEEE:::"+e);
	}

	if("Y".equals(callPreWelcomePage) || "S".equals(callPreWelcomePage))
	{
		int soldtoRows = retsoldto.getRowCount();
		if(soldtoRows>0 && "Y".equals(callPreWelcomePage))
		{
		
			retsoldto.sort(new String[]{"ECA_NAME"},true);
			
			vendorCode	= retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO");
			vendorName	= retsoldto.getFieldValueString(0,"ECA_NAME");
		}
		PurManager.setPurAreaAndVendor(purchaseArea,vendorCode); 
		session.putValue("SYSKEY", purchaseArea);
		session.putValue("Catalog",purchaseArea);
		session.putValue("SOLDTO",vendorCode);	
		session.putValue("Vendor",vendorName);
		// To Get Company codes :: start
		ezc.ezparam.ReturnObjFromRetrieve VendorCCRetObj=null;
		try
		{
			ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendortransactions.params.EzVendorParams  vendorParams= new ezc.vendortransactions.params.EzVendorParams();
			ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
			keyParams.setKey("GET_VEND_COMP_CODES");
			addMainParams.setLocalStore("Y");
			
			vendorParams.setVendor(vendorCode);
			addMainParams.setObject(keyParams);	
			addMainParams.setObject(vendorParams);
			Session.prepareParams(addMainParams);
		
			VendorCCRetObj=(ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(addMainParams);
			//out.println("VendorCCRetObj=="+VendorCCRetObj.toEzcString());
			if(VendorCCRetObj!=null && VendorCCRetObj.getRowCount()>0)
			{
				compCode =  VendorCCRetObj.getFieldValueString(0,"EUD_VALUE");
				compCode = compCode.trim();
			}
		
		}
		catch(Exception e)
		{
			out.println(":::Exception while getting company codes:::"+e);
		}
		// To Get Company codes :: end
		session.putValue("COMPCODE",compCode);	
	}	
%>