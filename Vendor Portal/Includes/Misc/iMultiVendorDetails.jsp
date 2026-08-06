<%
	String multiVendPurOrg   = ((String)Session.getUserPreference("PURORG"));
	String multiVendor = "";
	
	if(session.getAttribute("MULTI_VENDOR")!=null && "3".equals((String)session.getValue("UserType")))
		multiVendor = (String)session.getAttribute("MULTI_VENDOR");
		
	//if("1372B0249 ".equals((String)session.getValue("SOLDTO")))
	//	multiVendor = "1314B0156";
		
	String userPrefPlant = (String)Session.getUserPreference("PLANT");	
	//out.println(":userPrefPlant::"+userPrefPlant);
	java.util.Vector userPrefPlantVect = new java.util.Vector();
	
	if(userPrefPlant!=null)
	{
		String userPrefPlantArr[] = userPrefPlant.split(",");
		
		for(int i=0;i<userPrefPlantArr.length;i++)
			userPrefPlantVect.addElement(userPrefPlantArr[i].trim());		
	}
	
	int userPrefPlantVectCnt = userPrefPlantVect.size();
%>