<%
	
	ezc.ezparam.EzcParams mainParamsMap = new ezc.ezparam.EzcParams(false);  				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrMap = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableMap = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowMap = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retMap  =	null;	 
	
	//***********************************GETTING NA COMPCODE*****************************************************
	//miscTableRowMap.setQuery("SELECT VALUE1 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE='NA_COMP'");
	miscTableRowMap.setQuery("select MAP_TYPE,VALUE1,VALUE2 from ezc_value_mapping where MAP_TYPE='4500' and VALUE1='IM'");
	//miscTableRowMap.setQuery("select MAP_TYPE,VALUE1 from ezc_value_mapping where MAP_TYPE='4500' and VALUE1='IM'");	
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
		log("Exception in Getting Schema Group "+e);
	}
	int retMapCnt = 0;
	if(retMap != null)
		retMapCnt = retMap.getRowCount();
	ezc.ezcommon.EzLog4j.log(":::::schemaGroup:::"+retMapCnt.toEzcSting(),"I");
		
		String schemaGroup = retMap.getFieldValueString(0,"VALUE2"));	
	
	out.println("schemaGroup::::"+schemaGroup);
	
	
%>
