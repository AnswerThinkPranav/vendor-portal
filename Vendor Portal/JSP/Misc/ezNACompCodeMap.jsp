<%
	Hashtable<Integer,String> naCompHt = new Hashtable<Integer,String>();
	ezc.ezparam.EzcParams mainParamsMap = new ezc.ezparam.EzcParams(false);  				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrMap = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableMap = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowMap = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retMap  =	null;	 
	
	//***********************************GETTING NA COMPCODE*****************************************************
	miscTableRowMap.setQuery("SELECT VALUE1 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE='NA_COMP'");
	//miscTableRowMap.setQuery("SELECT MAP_TYPE,VALUE1 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE='4500' AND VALUE1='IM'");	
	miscTableMap.appendRow(miscTableRowMap);
	mainParamsMap.setLocalStore("Y");
	mainParamsMap.setObject(miscTableMap);
	Session.prepareParams(mainParamsMap); 
	try
	{ 
		retMap=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrMap.ezGetMiscTransactions(mainParamsMap);		
		ezc.ezcommon.EzLog4j.log("::::retMap:::"+retMap.toEzcString(),"I");
	}
	catch(Exception e)
	{
		log("Exception in GETTING NA COMPCODE"+e);
	}
	int retMapCnt = 0;
	if(retMap != null)
		retMapCnt = retMap.getRowCount();
	ezc.ezcommon.EzLog4j.log(":::::retMapCnt:::"+retMapCnt,"I");
	for(int t=0;t<retMapCnt;t++){		
		naCompHt.put(t,retMap.getFieldValueString(t,"VALUE1"));
	}
	ezc.ezcommon.EzLog4j.log(":::::naCompHt::::naCompHt:::"+naCompHt.toString(),"I");
	
	/*------------------------------GET VENDOR TYPE---------------------------------*/	
	
	/* mainParamsMap = new ezc.ezparam.EzcParams(false);  				
	 miscMgrMap = new ezc.misctransactions.client.EzMiscTransactionsManager();
	 miscTableMap = new ezc.misctransactions.params.EzMiscTable();
	 miscTableRowMap = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendType  =	null;	*/ 

	//***********************************GETTING NA COMPCODE*****************************************************
	//miscTableRowMap.setQuery("SELECT ECFH_VEN_TYPE,ECFH_EXT1 FROM EZC_CUSTOMER_FORM_HEADER WHERE ECFH_DOC_ID='"+docIdNA+"'");
	//miscTableRowMap.setQuery("SELECT ECFH_VEN_TYPE FROM EZC_CUSTOMER_FORM_HEADER WHERE ECFH_DOC_ID='711871'");	
	/*miscTableMap.appendRow(miscTableRowMap);
	mainParamsMap.setLocalStore("Y");
	mainParamsMap.setObject(miscTableMap);
	Session.prepareParams(mainParamsMap); 
	try
	{ 
		retVendType=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrMap.ezGetMiscTransactions(mainParamsMap);		
		ezc.ezcommon.EzLog4j.log("::::retVendType:::"+retVendType.toEzcString(),"I");
	}
	catch(Exception e)
	{
		log("Exception in GETTING NA COMPCODE"+e);
	}
	int retVendTypeCnt = 0;
	if(retVendType != null)
		retVendTypeCnt = retVendType.getRowCount();
		ezc.ezcommon.EzLog4j.log(":::::retVendTypeCnt::::retVendTypeCnt:::"+retVendTypeCnt,"I");
		String vendTypeNA= retVendType.getFieldValueString(0,"ECFH_VEN_TYPE");
		String compCodeNA= retVendType.getFieldValueString(0,"ECFH_EXT1");
	
	ezc.ezcommon.EzLog4j.log(":::::vendTypeNA::::vendTypeNA:::"+vendTypeNA,"I");
	ezc.ezcommon.EzLog4j.log(":::::compCodeNA::::compCodeNA:::"+compCodeNA,"I");
	*/
	
%>
