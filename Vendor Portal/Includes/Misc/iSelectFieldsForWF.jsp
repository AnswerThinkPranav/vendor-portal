<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>

<%
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qryStr1="";
	ezc.ezparam.ReturnObjFromRetrieve matlCatObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve purGrpObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve docTypeObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve mrpCtrlObj 	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve itemCatObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve accCatObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve proStatObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve reqDeptObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve purOrgObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve ccObj	  	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve pmntObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve incoObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve userDocObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve retObjWFTemp1	  =	null;
	
	java.util.Hashtable matHash = new java.util.Hashtable();
	java.util.Hashtable pmntHash = new java.util.Hashtable();
	java.util.Hashtable incoHash = new java.util.Hashtable();
	java.util.Hashtable pGrpHash = new java.util.Hashtable();
	java.util.Hashtable plantHT = new java.util.Hashtable();
	
	java.util.Vector  gv_DocVect 	= new java.util.Vector();
	String gv_DocType="";
	
	
	//MATERIAL GROUP LIST
		
	qryStr1="SELECT distinct(EWKM_CATEGORY) from EZC_WF_KEY_MAP" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1 wf"+qryStr1,"I");

	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	
	try
	{
		matlCatObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}	
	//WF LIST
	//MATERIAL GROUP LIST
			
		qryStr1="SELECT EWKM_DOC_TYPE,EWKM_COMP_CODE,EWKM_PLANT,EWKM_CATEGORY,EWKM_TEMPLATE FROM EZC_WF_KEY_MAP" ;
		ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");
	
		miscTableRow.setQuery(qryStr1);
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		
		try
		{
			retObjWFTemp1=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			
		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}	
	
	//PURCHASE GROUP LIST
		
	qryStr1="SELECT * FROM EZC_VALUE_MAPPING WHERE MAP_TYPE='PUR_GRP'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");

	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	
	try
	{
		purGrpObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
	//DOC TYPE LIST
		
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='DOC_TYPE'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");

	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	
	try
	{
		docTypeObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}	
	
	//MRP CONTROLLERS LIST
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='MRP_CTRL'" ;	
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");
	
	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		mrpCtrlObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting MRP Controller List>>>>>"+e);
	}	
	
	//ITEM CATEGORY
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='ITEM_CAT'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		itemCatObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}	
	
	//ACCOUNT ASSIGNMENT CATEGORIES
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='ACCT_ASN_CAT'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		accCatObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}
	//PROCESSING STATUS
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PRO_STATUS'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		proStatObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}
	
	//REQUISITIONER DEPT
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='REQ_DEPT'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		reqDeptObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}
	
	//PURCHASE ORG
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PUR_ORG'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		purOrgObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}
	
	//COMPANY CODE
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='COMP_CODE'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		ccObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}	
	
	//PAYMENT TERMS
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='PMNT_TERM'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		pmntObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}
	//INCO TERMS
	
	qryStr1="SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='INCO_TERM'" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		incoObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}	
	
	//PLANT
	
	qryStr1="SELECT EP_PLANT,EP_NAME1 FROM EZC_PLANTS" ;
	ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");


	miscTableRow.setQuery(qryStr1);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		plantObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Item Category List>>>>>"+e);
	}	
	
	ezc.ezcommon.EzLog4j.log("matlCatObj>>>>"+matlCatObj.toEzcString(),"I");
	//ezc.ezcommon.EzLog4j.log("purGrpObj>>>>"+purGrpObj.toEzcString(),"I");	
	//ezc.ezcommon.EzLog4j.log("mrpCtrlObj>>>>"+mrpCtrlObj.toEzcString(),"I");
	//ezc.ezcommon.EzLog4j.log("itemCatObject>>>>"+itemCatObj.toEzcString(),"I");
	//ezc.ezcommon.EzLog4j.log("accCatObj>>>>"+accCatObj.toEzcString(),"I");
	
	ezc.ezcommon.EzLog4j.log("matlCatObj>>>>"+matlCatObj.getRowCount(),"I");
	ezc.ezcommon.EzLog4j.log("matlCatObj>>>>"+purGrpObj.getRowCount(),"I");
	
	
	for(int j=0;j<matlCatObj.getRowCount();j++)
	{
		matHash.put(matlCatObj.getFieldValueString(j,"EWKM_CATEGORY").trim(),matlCatObj.getFieldValueString(j,"EWKM_CATEGORY"));
	}
	
	for(int j=0;j<pmntObj.getRowCount();j++)
	{
		pmntHash.put(pmntObj.getFieldValueString(j,"EMKV_KEY").trim(),pmntObj.getFieldValueString(j,"EMKV_VALUE"));
	}
	for(int j=0;j<incoObj.getRowCount();j++)
	{
		incoHash.put(incoObj.getFieldValueString(j,"EMKV_KEY").trim(),incoObj.getFieldValueString(j,"EMKV_VALUE"));
	}
	for(int j=0;j<purGrpObj.getRowCount();j++)
	{
		pGrpHash.put(purGrpObj.getFieldValueString(j,"VALUE1").trim(),purGrpObj.getFieldValueString(j,"VALUE2"));
	}
	for(int j=0;j<plantObj.getRowCount();j++)
	{
		plantHT.put(plantObj.getFieldValueString(j,"EP_PLANT").trim(),plantObj.getFieldValueString(j,"EP_NAME1"));
	}
	
	//out.println("plantHT"+plantHT);
	
	//DOC TYPE
	
	
	
		qryStr1="SELECT * from EZC_USER_DEFAULTS WHERE EUD_KEY='DOCTYPE' AND EUD_USER_ID='"+Session.getUserId()+"'" ;
		ezc.ezcommon.EzLog4j.log("** qryStr1"+qryStr1,"I");
		miscTableRow.setQuery(qryStr1);
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);	
		try
		{
			userDocObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Item Category List>>>>>"+e);
		}
		
		gv_DocType= userDocObj.getFieldValueString(0,"EUD_VALUE");
		ezc.ezcommon.EzLog4j.log("** gv_DocType"+gv_DocType,"I");
		
		
		if(!"".equals(userType))
		{
			
			String tempPlantArr[] = gv_DocType.split("#");		
			for(int gp=0;gp<tempPlantArr.length;gp++)
				gv_DocVect.addElement(tempPlantArr[gp]);
		}		
				
%>
     