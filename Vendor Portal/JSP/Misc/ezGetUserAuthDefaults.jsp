<%
	ezc.ezcommon.EzLog4j.log("Test.......>>::::::LE::00","I");
	String userSyskeysStr = "";
	if(session.getValue("USER_SYSKEYS") !=null)
		userSyskeysStr = (String)session.getValue("USER_SYSKEYS");
	
	String userWfGroupsStr = "";
	if(session.getValue("USER_WF_GROUPS") !=null)
		userWfGroupsStr = (String)session.getValue("USER_WF_GROUPS");
		
	String userPurOrgsStr = "";
	if(session.getValue("USER_PUR_ORGS") !=null)
		userPurOrgsStr = (String)session.getValue("USER_PUR_ORGS");
		
	String userType    = (String)session.getValue("UserType"); 
	String sysKey 	   = (String) session.getValue("SYSKEY");   
	String userRole    = (String)session.getValue("USERROLE"); 
	String soldTo      = (String)session.getValue("SOLDTO");
	String userGroup   = (String)session.getValue("USERGROUP");
	String portaType   = (String)session.getValue("PORTAL_TYPE"); //Buyer / Vendor View
	String shipmentAppr   = (String)session.getValue("SHIPMENT_APPR"); //Buyer / Vendor View
	String CompCodee   = (String)session.getValue("CCode");
	String purGrpSess    = (String)session.getValue("USERDEFPURGRP"); 
	//out.print("CompCodee:::"+session.getValue("CCode"));
	//out.print("soldTo:::"+(String)session.getValue("SOLDTO"));
	String gv_UserPlant 	="";
	
	String userPurGrpStr = "";
	
	if(purGrpSess != null)
		userPurGrpStr = purGrpSess.replaceAll(",","','");
	
	String gv_CategoriesForQry  = "";
	java.util.Vector  gv_CategoryVect 	= (java.util.Vector)session.getValue("CATEGORIES");
	java.util.Vector  gv_CategoryVectAll 	= new java.util.Vector();
	ezc.ezcommon.EzLog4j.log("Test.......>>::::::LE::11"+gv_CategoryVect,"I");
	

	for(Object tempCatVal:gv_CategoryVect)
	{
		String tempCatObjStr = (tempCatVal+"").split("#")[1];
		if(!gv_CategoryVectAll.contains(tempCatObjStr))
			gv_CategoryVectAll.add(tempCatObjStr);
		
		if("".equals(gv_CategoriesForQry))
		{
			gv_CategoriesForQry += tempCatVal+"";
		}
		else
		{
			gv_CategoriesForQry += "','"+tempCatVal+"";
		}
	}
	ezc.ezcommon.EzLog4j.log("Test.......>>::::::LE::22","I");
	
	String gv_PlantForQry  = "";
	java.util.Vector  gv_PlantVect 		= (java.util.Vector)session.getValue("PLANT");
		
	for(Object tempPlantVal:gv_PlantVect)
	{
		if("".equals(gv_PlantForQry))
		{
			gv_PlantForQry += tempPlantVal+"";
		}
		else
		{
			gv_PlantForQry += "','"+tempPlantVal+"";
		}
	}
	ezc.ezcommon.EzLog4j.log("Test.......>>::::::LE::33","I");
	
	java.util.Vector workGrpVect    = (java.util.Vector)session.getValue("WGSVECTOR"); 
	String gv_WorkGrpForQry  = "";
	for(Object tempWGVal:workGrpVect)
		{
			if("".equals(gv_WorkGrpForQry))
			{
				gv_WorkGrpForQry += tempWGVal+"";
			}
			else
			{
				gv_WorkGrpForQry += "','"+tempWGVal+"";
			}
	}
	String gv_PurorgsForQry  = "";
	java.util.Vector  gv_PurorgsVect 	= (java.util.Vector)session.getValue("PURORGDEF");
	//out.print("a:::"+session.getValue("PURORGDEF"));
	for(Object tempPorgVal:gv_PurorgsVect)
	{
		if("".equals(gv_PurorgsForQry))
		{
			gv_PurorgsForQry += tempPorgVal+"";
		}
		else
		{
			gv_PurorgsForQry += "','"+tempPorgVal+"";
		}
	}
	ezc.ezcommon.EzLog4j.log("Test.......>>::::::LE::44","I");
	/*
	if(!"".equals(gv_UserPlant))
	{
		gv_PlantForQry = gv_UserPlant.replaceAll("#","','");	
		String tempPlantArr[] = gv_UserPlant.split("#");		
		for(int gp=0;gp<tempPlantArr.length;gp++)
			gv_PlantVect.addElement(tempPlantArr[gp]);
	}*/		
	
	ezc.ezcommon.EzLog4j.log("::::::::gv_CategoryVectAll>>:::::"+gv_CategoryVectAll,"I");
	/*
	out.print("gv_CategoryVectAll:::"+gv_CategoryVectAll);	
	out.print("userWfGroupsStr:::"+gv_CategoriesForQry);
	out.print("gv_WorkGrpForQry:::"+gv_WorkGrpForQry);
	
	
	out.println("::::::::purGrp:::::"+purGrp);
	out.println("::::::::userType:::::"+userType);
	out.println("::::::::sysKey:::::"+sysKey);
	out.println("::::::::userRole:::::"+userRole);
	out.println("::::::::soldTo:::::"+soldTo);
	out.println("::::::::userGroup:::::"+userGroup);
	out.println("::::::::portaType:::::"+portaType);
	out.println("::::::::gv_UserPlant:::::"+gv_UserPlant);
	out.println("::::::::userSyskeysStr:::::"+userSyskeysStr);
	
	
	out.println("::::::::ALLOW_RFQ:::::"+session.getValue("ALLOW_RFQ"));
	out.println("::::::::ALLOW_REG:::::"+session.getValue("ALLOW_REG"));*/
	
	ezc.ezcommon.EzLog4j.log("gv_WorkGrpForQry:::::"+gv_WorkGrpForQry,"I");
	ezc.ezcommon.EzLog4j.log("gv_UserPlant:::::"+gv_UserPlant,"I");
	java.util.Hashtable  ctHash 	= (java.util.Hashtable)session.getValue("USER_COUNTRY");
	
	ezc.ezcommon.EzLog4j.log("::::::::ctHash>>:::::"+ctHash,"I");
	
	boolean isNABuyer=false;
	if(ctHash!= null){
		if(ctHash.contains("US"))	
			isNABuyer=true;
	}
	//out.println("::::::::isNABuyer:::::"+isNABuyer);
	ezc.ezcommon.EzLog4j.log("isNABuyer:::::"+isNABuyer,"I");
	
	
%>