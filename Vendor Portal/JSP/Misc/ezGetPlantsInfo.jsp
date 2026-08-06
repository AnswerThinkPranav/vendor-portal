
<%	
	
	
	int plantsRetObjCnt = 0;
	
	String whereStr = "";
	if(docPlant!=null && !"null".equals(docPlant) && !"".equals(docPlant))
		whereStr = " WHERE EP_PLANT = '"+docPlant+"'";
	
	java.util.Hashtable plantsHT = new java.util.Hashtable();
	ReturnObjFromRetrieve plantsRetObj 	= null;
 	EzcParams pl_mainParams			= new EzcParams(false);
 	EziMiscParams pl_miscParams 		= new EziMiscParams();
 
 	pl_miscParams.setQuery("SELECT * FROM EZC_PLANTS "+whereStr);
 	pl_mainParams.setObject(pl_miscParams);
 	pl_mainParams.setLocalStore("Y");
 	Session.prepareParams(pl_mainParams);
 	try
 	{
 		plantsRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(pl_mainParams);
 
 	}catch(Exception e){
 		ezc.ezcommon.EzLog4j.log(":::::Exception occured while getting plants::::::"+e,"E");
 	} 	
 	
 	if(plantsRetObj!=null)
 		plantsRetObjCnt = plantsRetObj.getRowCount();	
%>