<%	
	int plantsRetObjCnt = 0;
	
	java.util.Hashtable plantsHT = new java.util.Hashtable();
	ezc.ezparam.ReturnObjFromRetrieve plantsRetObj 	= null;
	ezc.ezparam.EzcParams pl_mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager pl_miscMgr 	= new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable pl_miscTable 		= new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow pl_miscTableRow 	= new ezc.misctransactions.params.EzMiscTableRow();
 
	pl_miscTableRow.setQuery("SELECT * FROM EZC_PLANTS");
	pl_miscTable.appendRow(pl_miscTableRow);
	pl_mainParams.setLocalStore("Y");
	pl_mainParams.setObject(pl_miscTable);
	Session.prepareParams(pl_mainParams);	

 	try
 	{
 		plantsRetObj = (ReturnObjFromRetrieve)pl_miscMgr.ezGetMiscTransactions(pl_mainParams);
 
 	}catch(Exception e){
 		ezc.ezcommon.EzLog4j.log(":::::Exception occured while getting plants::::::"+e,"E");
 	} 	
 	
 	if(plantsRetObj!=null)
 		plantsRetObjCnt = plantsRetObj.getRowCount();	
 		
 	for(int pl=0;pl<plantsRetObjCnt;pl++)
 		plantsHT.put(plantsRetObj.getFieldValueString(pl,"EP_PLANT"),plantsRetObj.getFieldValueString(pl,"EP_CITY"));
 		
 	//out.println(":::plantsRetObj:::"+plantsHT);	
%>