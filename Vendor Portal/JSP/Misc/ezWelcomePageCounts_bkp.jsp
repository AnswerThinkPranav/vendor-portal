 <% 
 	int shipmentsCnt 	= 0;
 	int toBeAckPOsCount = 0;
	int toBeQuotedRFQsCnt = 0;
 	
 	int openVendChngsCnt    = 0;
 	
 	ReturnObjFromRetrieve retObj = null;
 	String qryStr = "";
 		
	if("3".equals(userType) || "VENDOR".equals(portaType))
		qryStr = " AND EZSH_SOLD_TO ='"+soldTo+"' ";
	qryStr	= qryStr+" AND EZSH_STATUS IN ('Y')";
 	
 	ezc.ezparam.EzcParams v_MainParams = new ezc.ezparam.EzcParams(true);
 	
 	if("Y".equals(shipmentAppr) || "3".equals(userType))
 	{
		ezc.vendortransactions.client.EzVendorTransactionsManager v_transactions = new ezc.vendortransactions.client.EzVendorTransactionsManager();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		ezc.ezshipment.params.EziShipmentInfoParams v_InParams = new ezc.ezshipment.params.EziShipmentInfoParams();

		v_KeyParams.setKey("GET_SHIPMENTS");

		v_InParams.setSysKey(userSyskeysStr);
		v_InParams.setEXT1(qryStr);

		v_MainParams.setLocalStore("Y");
		v_MainParams.setObject(v_KeyParams);
		v_MainParams.setObject(v_InParams);
		Session.prepareParams(v_MainParams);

		try{
			retObj = (ReturnObjFromRetrieve)v_transactions.ezGetVendorTransactions(v_MainParams);
		}catch(Exception e){}
 	}
 	
 	if(retObj!=null)
 		shipmentsCnt=retObj.getRowCount();
 	
	//out.println("userRole:::::::"+userRole);
	
	
	String wfCheckName 	= 	"'"+Session.getUserId()+"','"+userWfGroupsStr+"','"+userRole+"'";	
	v_MainParams = new ezc.ezparam.EzcParams(false);
	ezc.ezworkflow.client.EzWorkFlowManager wfManager = new ezc.ezworkflow.client.EzWorkFlowManager();
	ezc.ezworkflow.params.EziWFDocHistoryParams wfparams= new ezc.ezworkflow.params.EziWFDocHistoryParams();

	wfparams.setAuthKey("'VENDOR_PROFILE'");
	
	if("MDM".equals(userRole))
	wfparams.setStatus("'APPROVED'");
	else{
	wfparams.setStatus("'SUBMITTED'");
	wfparams.setParticipant(wfCheckName);
	}
	v_MainParams.setObject(wfparams);
	Session.prepareParams(v_MainParams);
	
	try{
		retObj = (ezc.ezparam.ReturnObjFromRetrieve)wfManager.getWFDocList(v_MainParams);
	}catch(Exception e){}
	String docStrMain="";
	if(retObj!=null)
	{
		openVendChngsCnt = retObj.getRowCount();
		for(int i=0;i<openVendChngsCnt;i++)
		{
		if("".equals(docStrMain))
		docStrMain=checkNull(retObj.getFieldValueString(i,"EWDHH_DOC_ID"));
		else
		docStrMain=docStrMain+"','"+checkNull(retObj.getFieldValueString(i,"EWDHH_DOC_ID"));
		}
	}
		
	v_MainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams1= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams1 = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	ezc.vendorprofile.params.EziVendorKeyParamsTable keyTableParams1 = new ezc.vendorprofile.params.EziVendorKeyParamsTable();
	
	ezc.vendorprofile.client.EzVendorProfileManager vendorprofileMainPage= new ezc.vendorprofile.client.EzVendorProfileManager();
		
	keyParams1.setKey("GetGeneralData");
	keyTableParams1.appendRow(keyParams1);
	v_MainParams.setLocalStore("Y");

	generalParams1.setStatus("OPEN') AND EVGD_VEND_TYPE NOT IN('NOSAP");
	generalParams1.setDocId(docStrMain);

	v_MainParams.setObject(keyTableParams1);	
	
	v_MainParams.setObject(generalParams1);
	Session.prepareParams(v_MainParams);
	
	retObj =null;
	openVendChngsCnt=0;
	try{
	 retObj=(ReturnObjFromRetrieve)vendorprofileMainPage.ezGetDetails(v_MainParams);
	 retObj=((ReturnObjFromRetrieve)retObj.getObject("GetGeneralData"));
	 if(retObj!=null)
	 {
	 openVendChngsCnt=retObj.getRowCount();
	}
	}catch(Exception e){}
			
	//out.println("openVendChngsCnt:::::::"+openVendChngsCnt);	
	
	
	if("3".equals(userType) || "4".equals(userType))
	{
		ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
		v_MainParams = new ezc.ezparam.EzcParams(false);

		ReturnObjFromRetrieve hdrXML = null;

		EziRFQHeaderParams 	ezirfqheaderparams    	= new EziRFQHeaderParams();
		EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
		EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
		EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
		EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	

		ezirfqheaderparams.setStatus("N");
		ezirfqheaderparams.setSoldTo(soldTo); 
		ezirfqheaderparams.setExt1(""); 

		v_MainParams.setLocalStore("Y");
		v_MainParams.setObject(ezirfqheaderparams);
		Session.prepareParams(v_MainParams);
		try
		{
			hdrXML = (ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(v_MainParams);

		if(hdrXML!=null && hdrXML.getRowCount()>0)
			toBeQuotedRFQsCnt = hdrXML.getRowCount(); 
		}
		catch(Exception e){
			ezc.ezcommon.EzLog4j.log(":Exception occured while getting RFQ List from DB:"+e,"I");
		} 

		ezc.ezparam.EzcParams mainCountParams = new ezc.ezparam.EzcParams(true);
		mainCountParams.setLocalStore("Y");	    
		ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();

		iParams.setDocStatus("X");
		iParams.setSysKey(userSyskeysStr);
		iParams.setSoldTo(soldTo);	

		mainCountParams.setObject(iParams);	
		Session.prepareParams(mainCountParams);

		try
		{
			ezc.ezparam.ReturnObjFromRetrieve toBeAckPOsRet = (ezc.ezparam.ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(mainCountParams);

			if(toBeAckPOsRet != null)
				toBeAckPOsCount=toBeAckPOsRet.getRowCount();
		}		
		catch(Exception e){}
	}	
 %>