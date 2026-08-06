<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%
	int toBeAckPOsCount = 0;
	int toBeQuotedRFQCount = 0;
	int toBeMadeGRCount = 0;
	
	
	String conStatus = "";
	
	String buyerGroup = "";
	
	if(myPurGrp!=null)
		myPurGrp=(myPurGrp.toUpperCase()).trim();
	

	ezc.ezparam.EzcParams mainCountParams = new ezc.ezparam.EzcParams(true);
	mainCountParams.setLocalStore("Y");	    
	iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();

	iParams.setDocStatus("X");
	//iParams.setSysKey(sysKey+"') AND EZPA_PO_DOC_TYPE IN ('P");
	iParams.setSysKey(sysKey);
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

	mainCountParams = new ezc.ezparam.EzcParams(true);
	iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	
		
	mainCountParams = new ezc.ezparam.EzcParams(true);
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	
	ezirfqheaderparams.setStatus("N') AND ERH_SYS_KEY = EC_SYS_KEY AND ERH_SYS_KEY = ('"+sysKey);
	
	ezirfqheaderparams.setSoldTo(soldTo);
	
	ezirfqheaderparams.setExt1("");
	ezirfqheaderparams.setExt3("Y");
	ezirfqheaderparams.setSysKey(sysKey);


	mainCountParams.setObject(ezirfqheaderparams);
	mainCountParams.setLocalStore("Y");
	Session.prepareParams(mainCountParams);
	
	try
	{
		ezc.ezparam.ReturnObjFromRetrieve toBeQuotedRFQRet = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(mainCountParams);
	
		if(toBeQuotedRFQRet != null)
			toBeQuotedRFQCount = toBeQuotedRFQRet.getRowCount();
	}		
	catch(Exception e){}	
%>