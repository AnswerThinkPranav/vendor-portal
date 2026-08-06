<%
	String user_Ids     = "";
	int valMapRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve	valMapRetObj = null;
	ezc.ezparam.EzcParams mainParams_email = new ezc.ezparam.EzcParams(true);
	ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
	ezc.valuemap.params.EziValueMappingParams valueParams =  new ezc.valuemap.params.EziValueMappingParams();

	valueParams.setMapType(eMailType);
	valueParams.setValue1(eMailValue);

	mainParams_email.setObject(valueParams);	
	Session.prepareParams(mainParams_email);

	try{
		valMapRetObj = (ezc.ezparam.ReturnObjFromRetrieve)valMapMgr.ezGetValueMapping(mainParams_email);
	}catch(Exception e){}
	
	if(valMapRetObj!=null)
		valMapRetObjCnt = valMapRetObj.getRowCount();
		
	for(int e=0;e<valMapRetObjCnt;e++)
	{	
		if(e==0)
			user_Ids = valMapRetObj.getFieldValueString(e,"VALUE2");
		else
			user_Ids += "','"+valMapRetObj.getFieldValueString(e,"VALUE2");
			
		if( valMapRetObj.getFieldValueString(e,"VALUE2").indexOf("@")>=0)
		{
			if(!"".equals(toEMailIds))
			toEMailIds=toEMailIds+","+user_Ids;
			else
			toEMailIds=user_Ids;
		}
	}
	
	
	int user_EMailsRetCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve user_EMailsRet = null;
	
	ezc.ezparam.EzcParams user_MainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.client.EzVendorTransactionsManager user_vendTrnsMgr = new ezc.vendortransactions.client.EzVendorTransactionsManager();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams user_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzVendorParams user_Params = new ezc.vendortransactions.params.EzVendorParams();

	try
	{
		user_KeyParams.setKey("GET_USER_EMAIL");

		user_Params.setUserId(user_Ids);
		
		user_MainParams.setLocalStore("Y");
		user_MainParams.setObject(user_KeyParams);	
		user_MainParams.setObject(user_Params);
		Session.prepareParams(user_MainParams);

		user_EMailsRet=(ezc.ezparam.ReturnObjFromRetrieve)user_vendTrnsMgr.ezGetVendorTransactions(user_MainParams);
	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log(":::ERROR WHILE GETTTING USER EMAIL-CONTACT NUMBERS:::"+e,"E");
	}

	if(user_EMailsRet!=null)
		user_EMailsRetCnt = user_EMailsRet.getRowCount();

	for(int u=0;u<user_EMailsRetCnt;u++)
	{	
		if(u==0)
			toEMailIds = user_EMailsRet.getFieldValueString(u,"EU_EMAIL");
		else
			toEMailIds += ","+user_EMailsRet.getFieldValueString(u,"EU_EMAIL");
			
		//mobileNoVect.addElement(user_EMailsRet.getFieldValueString(u,"EU_CONTACT_NO"));	
	}
	
%>