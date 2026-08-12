<%@ page import ="ezc.ezparam.*" %>
<%@ include file="../../Lib/PurchaseBean.jsp"%>
<%@ page import="ezc.client.*,ezc.ezutil.FormatDate" %>

<%!

	Date convertStringToDate(String dateStr)
	{
		Date conDateObj = null;
		if(dateStr != null && dateStr.length() > 9)
		{
		    ezc.ezcommon.EzLog4j.log("dateStr::" + dateStr, "I");
		    int dd = Integer.parseInt(dateStr.substring(0, 2));
		    int mm = Integer.parseInt(dateStr.substring(3, 5));
		    int yy = Integer.parseInt(dateStr.substring(6, 10));
		    GregorianCalendar g = new GregorianCalendar(yy, mm - 1, dd);
		    conDateObj = g.getTime();
		    ezc.ezcommon.EzLog4j.log("conDateObj::" + conDateObj, "I");
		}
		return conDateObj;
	}
%>

<%

	String myPurGrp	  = (String)Session.getUserPreference("PURGROUP");
	String userType   = (String)session.getValue("UserType");
	String sysKey 	  = (String) session.getValue("SYSKEY");
	
	String defErpVendor= "";
	
	if("2".equals(userType))
		defErpVendor = (String)session.getValue("SOLDTO");
	else if("3".equals(userType))
		defErpVendor = (String)Session.getUserId();
		
	if(myPurGrp!=null)
		myPurGrp=(myPurGrp.toUpperCase()).trim();
		
	if(defErpVendor!=null)
		defErpVendor = defErpVendor.trim();
		
	String fromDate = "01.01.2010";
	String type = request.getParameter("type");
	EzPurchaseManager PoManager=new EzPurchaseManager();

	EzPurchHdrXML hdrXML =null;
	EzPSIInputParameters iparams = new EzPSIInputParameters();
	ezc.ezparam.EzcPurchaseParams newParams = new ezc.ezparam.EzcPurchaseParams();
	ezc.ezpurchase.params.EziPurchaseInputParams testParams = new ezc.ezpurchase.params.EziPurchaseInputParams();
		
	iparams.setVendorNumber(defErpVendor);

	if(myPurGrp!=null && !"null".equals(myPurGrp) && !"".equals(myPurGrp.trim()))
		testParams.setPurGroup(myPurGrp);
	//if(myPurOrg!=null&& !"null".equals(myPurOrg) && !"".equals(myPurOrg.trim()))
		//testParams.setPurOrg(myPurOrg);
	java.sql.Date FromDate = null;
	ezc.ezcommon.EzLog4j.log(":FromDate::"+FromDate,"I");
	int dateArray[] = FormatDate.getMMDDYYYY("01/01/2010", true);
	ezc.ezcommon.EzLog4j.log(":dateArray::"+dateArray,"I");
	dateArray[0] = dateArray[0] - 1;
	FromDate = new java.sql.Date(dateArray[2] - 1900, dateArray[0], dateArray[1]);
	
	
	if(fromDate != null)
	{
		testParams.setFromDate(FromDate);
	}
	
	testParams.setDocType("AN");
	testParams.setSelectionFlag("A");
	newParams.createContainer();
	newParams.setObject(iparams);
	newParams.setObject(testParams);
	Session.prepareParams(newParams);

	if(type.equalsIgnoreCase("ToQuote"))
	{
		try
		{
			ezc.ezcommon.EzLog4j.log("before ezGetNewPurchaseOrderList","I");
			hdrXML = (EzPurchHdrXML)PoManager.ezGetNewPurchaseOrderList(newParams);
			ezc.ezcommon.EzLog4j.log("after ezGetNewPurchaseOrderList"+hdrXML.toEzcString(),"I");
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Ezception occured while getting ezGetNewPurchaseOrderList RFQs"+e,"I");
		}
	}
	else{
		try
		{
			hdrXML = (EzPurchHdrXML)PoManager.ezGetAllPurchaseOrderList(newParams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Ezception occured while getting ezGetAllPurchaseOrderList RFQs"+e,"I");
		}
	}

	String[] sortKey = {"ORDER"};
	if(hdrXML!=null)
		hdrXML.sort( sortKey, false );//false for descending

	int Count = 0;
	if(hdrXML!=null && hdrXML.getRowCount()>0 )
		Count = hdrXML.getRowCount();
	
   
   	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
   	ReturnObjFromRetrieve rfqListRetObj = null;
   	int rfqListDBRetObjCount = 0;
		
	EzcParams 		ezcparams		= new ezc.ezparam.EzcParams(false);
	EziRFQHeaderParams 	ezirfqheaderparams    	= new EziRFQHeaderParams();
	EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
	EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
	EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
	EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	
   	
   	ezirfqheaderparams.setSysKey(sysKey);
   	ezirfqheaderparams.setStatus("N','Y");
   	ezirfqheaderparams.setSoldTo(defErpVendor); 
   	ezirfqheaderparams.setExt1(""); 
   	
   	ezcparams.setLocalStore("Y");
	ezcparams.setObject(ezirfqheaderparams);
	Session.prepareParams(ezcparams);
	ezc.ezcommon.EzLog4j.log("Get RFQ LIST","I");
      	try
      	{
      		rfqListRetObj = (ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);
      		ezc.ezcommon.EzLog4j.log("After Get RFQ LIST"+rfqListRetObj.toEzcString(),"I");
      	}
      	catch(Exception e)
      	{
      		ezc.ezcommon.EzLog4j.log(":Exception occured while getting RFQ List from DB:"+e,"I");
      	}
      	
      	if(rfqListRetObj!=null && rfqListRetObj.getRowCount()>0)
      		rfqListDBRetObjCount = rfqListRetObj.getRowCount();
      		
      	java.util.Vector rfqDBVect=new java.util.Vector();
	
	ezc.ezcommon.EzLog4j.log("beofrefor loop"+rfqListRetObj.toEzcString(),"I");
	for(int i=0;i<rfqListDBRetObjCount;i++)	
      		rfqDBVect.addElement(rfqListRetObj.getFieldValueString(i,"RFQ_NO"));
  	
  	for(int i=0;i<Count;i++)
	{
		
		ezirfqheaderparams    	= new EziRFQHeaderParams();

		String rfqNo  = hdrXML.getFieldValueString(i,"ORDER") ;
		String purGrp = hdrXML.getFieldValueString(i,"PURGRP") ;
		
		boolean docContains = false;
		boolean insertRfq   = false;
		
		docContains = rfqDBVect.contains(rfqNo);  
		java.util.Date ordDate = (java.util.Date)hdrXML.getFieldValue(i,"ORDERDATE");
		String OrderDt = FormatDate.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String rfqcloseDate	= formatDate.getStringFromDate((java.util.Date)hdrXML.getFieldValue(i,"CONFIRMDELIVERYDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		
		ezirfqheadertablerow = new EziRFQHeaderTableRow();
		ezirfqheadertablerow.setRFQNo(rfqNo);
		ezirfqheadertablerow.setCollectiveRFQNo(rfqNo);
		ezirfqheadertablerow.setSysKey(sysKey);
		ezirfqheadertablerow.setSoldTo(defErpVendor);
		ezirfqheadertablerow.setPRNo("");
		ezirfqheadertablerow.setPRItmNo("");
		ezirfqheadertablerow.setStatus("N");
		ezirfqheadertablerow.setRFQDate(OrderDt);
		ezirfqheadertablerow.setValidUpto(rfqcloseDate);
		ezirfqheadertablerow.setCreatedBy("SAP");
		ezirfqheadertablerow.setModifiedBy("");
		ezirfqheadertablerow.setPurchaseOrg("");		
		ezirfqheadertablerow.setPurchaseGrp(purGrp);
		ezirfqheadertablerow.setVendorType("");
		ezirfqheadertablerow.setAgentCode("");
		ezirfqheadertablerow.setReleaseIndicator("");
		ezirfqheadertablerow.setRankStatus("");
		ezirfqheadertablerow.setExt1("");
		ezirfqheadertablerow.setExt2("");
		ezirfqheadertablerow.setExt3("");
		ezirfqheadertablerow.setValType("");
		ezirfqheadertablerow.setPRDetails("");
		ezirfqheadertablerow.setRFQTitle("");
		
	
		if(!docContains)
			insertRfq=true;
		if(insertRfq)
			ezirfqheadertable.appendRow(ezirfqheadertablerow);
			
		/*ezirfqdetailstablerow = new EziRFQDetailsTableRow();
		ezirfqdetailstablerow.setRFQNo(rfqNo);
		ezirfqdetailstablerow.setLineNo("1");
		ezirfqdetailstablerow.setCounter("1");
		ezirfqdetailstablerow.setMaterial("ttest");
		ezirfqdetailstablerow.setMaterialDesc("test");
		ezirfqdetailstablerow.setUOM("kg");
		ezirfqdetailstablerow.setDeliveryDate("01/01/2013");
		ezirfqdetailstablerow.setQuantity("1");
		ezirfqdetailstablerow.setPrice("1");
		ezirfqdetailstablerow.setQuantity("1");
		ezirfqdetailstablerow.setPlant("1");
		ezirfqdetailstablerow.setRemarks("1");
		ezirfqdetailstablerow.setExt1("");
		ezirfqdetailstablerow.setExt2("");
		ezirfqdetailstablerow.setExt3("");
		ezirfqdetailstablerow.setCurr("");
		ezirfqdetailstablerow.setExchRate("1");		
		ezirfqdetailstable.appendRow(ezirfqdetailstablerow);*/	
		
	}
	
	if(ezirfqheadertable.getRowCount()>0)
	{
		ezcparams = new EzcParams(true);
		ezcparams.setLocalStore("Y");
		ezcparams.setObject(ezirfqheadertable);
		ezcparams.setObject(ezirfqdetailstable);
		Session.prepareParams(ezcparams);
		try
		{
			ezrfqmanager.ezAddRFQ(ezcparams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Error while inserting RFQs in DB"+e,"I");
		}

	}
  	
%>

