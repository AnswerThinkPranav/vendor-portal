<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session"></jsp:useBean>

<%
	
	int myRetCount=0;
	
	String sysKey = (String) session.getValue("SYSKEY");
	String soldTo = (String) session.getValue("SOLDTO");
	String userType =(String)session.getValue("UserType");	
	
		
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	mainParams.setLocalStore("Y");	    
	ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	iParams.setSysKey(sysKey);
	if("2".equals(userType)){
		iParams.setDocStatus("X");
		iParams.setSoldTo(soldTo);
	}else{
		iParams.setDocStatus("K','M','N");
		iParams.setSoldTo(soldTo);
	}	

	mainParams.setObject(iParams);	
	Session.prepareParams(mainParams);
	ezc.ezparam.ReturnObjFromRetrieve ret= (ezc.ezparam.ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(mainParams);
	
	if(ret != null)
	{
		myRetCount=ret.getRowCount();
		if(myRetCount > 0)
		{
			ret.sort(new String[]{"DOCDATE"},false);
		}
	}	
		
	myRetCount=ret.getRowCount();	
	
	
	out.println("::::::myRetCount:::::::"+ret.toEzcString());
	
	
%>
