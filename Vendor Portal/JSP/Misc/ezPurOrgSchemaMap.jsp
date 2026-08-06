<%
	
	ezc.ezparam.EzcParams mainParamsMap = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrMap = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableMap = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowMap = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retMap  =	null;	 
	
	//***********************************GET MAPPING SCHEMA*****************************************************
	miscTableRowMap.setQuery("select MAP_TYPE,VALUE1,VALUE2 from ezc_value_mapping where MAP_TYPE='"+compCode+"' and VALUE1='"+vendType+"'");
	//miscTableRowMap.setQuery("select MAP_TYPE,VALUE1,VALUE2 from ezc_value_mapping where MAP_TYPE='4500' and VALUE1='IN'");
	ezc.ezcommon.EzLog4j.log(":::::ezPurOrgSchemaMap.jsp::::"+miscTableRowMap.getQuery(),"I");
	miscTableMap.appendRow(miscTableRowMap);
	mainParamsMap.setLocalStore("Y");
	mainParamsMap.setObject(miscTableMap);
	Session.prepareParams(mainParamsMap); 
	try
	{
		retMap=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrMap.ezGetMiscTransactions(mainParamsMap);
		//out.print(retMap.toEzcString());
		ezc.ezcommon.EzLog4j.log(":::::ezPurOrgSchemaMap.jsp::::retMap:::"+retMap.toEzcString(),"I");
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retMapCnt = 0;
	if(retMap != null)
		retMapCnt = retMap.getRowCount();
	String schemagroup=retMap.getFieldValueString(0,"VALUE2");
	String vend=retMap.getFieldValueString(0,"VALUE1");
	
	ezc.ezcommon.EzLog4j.log(":::::ezPurOrgSchemaMap.jsp::::schemagroup:::"+schemagroup,"I");
%>