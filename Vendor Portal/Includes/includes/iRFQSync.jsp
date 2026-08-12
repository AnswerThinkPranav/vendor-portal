<%@ page import ="ezc.ezparam.*" %>
<%@ include file="../../Lib/PurchaseBean.jsp"%>
<%@ page import="ezc.client.*,ezc.ezutil.FormatDate" %>

<%

	String myPurGrp	  = (String)Session.getUserPreference("PURGROUP");
	String status 	  = request.getParameter("type"); 
	
	if("ToQuote".equals(status)) status = "N";		
	else if("Quoted".equals(status)) status = "Y";
	else if("All".equals(status)) status = "Y','N";
	
	
	String defErpVendor= "";
	
	if("2".equals(userType))
		defErpVendor = (String)session.getValue("SOLDTO");
	else if("3".equals(userType))
		defErpVendor = (String)Session.getUserId();
		
	if(myPurGrp!=null)
		myPurGrp=(myPurGrp.toUpperCase()).trim();
		
	if(defErpVendor!=null)
	{
		defErpVendor = defErpVendor.trim();
		
		try{
			Long.parseLong(defErpVendor);
			
			defErpVendor = "0000000000"+defErpVendor;
			defErpVendor = defErpVendor.substring(defErpVendor.length()-10,defErpVendor.length());
			
		}catch(Exception e){}
	}	
		
   
   	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
   	ReturnObjFromRetrieve hdrXML = null;
   	int Count = 0;
		
	EzcParams 		ezcparams		= new ezc.ezparam.EzcParams(false);
	EziRFQHeaderParams 	ezirfqheaderparams    	= new EziRFQHeaderParams();
	EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
	EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
	EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
	EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	
	
   	ezirfqheaderparams.setStatus("N");
   	ezirfqheaderparams.setSoldTo(defErpVendor); 
   	ezirfqheaderparams.setExt1(""); 
   	
   	ezcparams.setLocalStore("Y");
	ezcparams.setObject(ezirfqheaderparams);
	Session.prepareParams(ezcparams);
	ezc.ezcommon.EzLog4j.log("Get RFQ LIST","I");
      	try
      	{
      		hdrXML = (ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);
      	}
      	catch(Exception e)
      	{
      		ezc.ezcommon.EzLog4j.log(":Exception occured while getting RFQ List from DB:"+e,"I");
      	}
      	
      	if(hdrXML!=null && hdrXML.getRowCount()>0)
      		Count = hdrXML.getRowCount();  	
%>