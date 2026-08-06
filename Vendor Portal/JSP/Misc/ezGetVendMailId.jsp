<%
	EzcParams mainParams = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	
	int count=0;
	String contactNum="";	
	String userName="";
	
	String userID=request.getParameter("userID");
	

	ReturnObjFromRetrieve retObj = null;

	if(userID!=null && !"null".equals(userID) && !"".equals(userID))
	{
		userID = userID.trim();
		miscParams.setQuery("SELECT * FROM EZC_USERS WHERE EU_ID='"+userID+"'  AND EU_TYPE='3'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);	
		try
		{
			retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		}
		catch(Exception e){}
	}
	
	if(retObj!=null)
		count=retObj.getRowCount();
	
	if(count>0){
		contactNum=retObj.getFieldValueString(0,"EU_EMAIL");
		contactNum=contactNum.trim();	
		userName = retObj.getFieldValueString("EU_FIRST_NAME");
	}	
%>