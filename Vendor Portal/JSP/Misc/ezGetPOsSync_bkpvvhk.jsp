<%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>

<%
	String site = request.getParameter("site");
	
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	EzcParams ezcContainer = new ezc.ezparam.EzcParams(false);	
	logs.setUserId("TEST_RRK");
	logs.setPassWd("portal");
	logs.setConnGroup(site);
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	String dummySysKey = "999999";
	ReturnObjFromRetrieve retSysKeys = null;
	String allSysKeys = "";

	Hashtable orgSysKeysHT = new Hashtable();

	EzcSysConfigParams sparams = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams = new EzcSysConfigNKParams();
	snkparams.setLanguage("EN");
	sparams.setObject(snkparams);
	Session.prepareParams(sparams);

	try
	{
		retSysKeys = (ReturnObjFromRetrieve) sysManager.getPurchaseAreas(sparams);		
	}catch(Exception e){}

	if(retSysKeys!=null)
	{
		for(int s=0;s<retSysKeys.getRowCount();s++)
		{
			if(s==0)
				allSysKeys = retSysKeys.getFieldValueString(s,"ESKD_SYS_KEY");
			else
				allSysKeys += "','"+retSysKeys.getFieldValueString(s,"ESKD_SYS_KEY");
		}
	}	


	if(!"".equals(allSysKeys))
	{
		ReturnObjFromRetrieve retdef = null;

		EzcSysConfigParams sparams1 = new EzcSysConfigParams();
		EzcSysConfigNKParams snkparams1 = new EzcSysConfigNKParams();
		snkparams1.setLanguage("EN");
		snkparams1.setSystemKey(allSysKeys);
		snkparams1.setSiteNumber(Integer.parseInt(site));
		sparams1.setObject(snkparams1);
		Session.prepareParams(sparams1);
		try
		{
			retdef = (ReturnObjFromRetrieve)sysManager.getCatAreaDefaults(sparams1);
		}catch(Exception e){}	

		if(retdef!=null)
		{
			for(int p=0;p<retdef.getRowCount();p++)
			{
				if("PURORG".equals(retdef.getFieldValueString(p,"EUDD_KEY")))
					orgSysKeysHT.put(retdef.getFieldValueString(p,"ECAD_VALUE"),retdef.getFieldValueString(p,"ECAD_SYS_KEY"));	

			}	
		}
}	
	
	ReturnObjFromRetrieve poRelHdrXML = new ReturnObjFromRetrieve(new String[]{"ORDER","VENDOR_NUMBER","RECORDSTATUS","RECORDSTATUS","ORDERTYPE","PURCH_ORG","PURGRP","PURGRP_NAME","START_DATE","END_DATE","ORDERDATE","COMPCODE","PLANT","CREATED_BY"});
	
	JCoFunction poFunction = null;
	JCoParameterList sapPurOrd = null;
	java.util.Date toDayObj=new java.util.Date();
	java.util.Date toDate=new java.util.Date();
	toDayObj.setDate(toDayObj.getDate()-90);
	java.sql.Date FromDate=new java.sql.Date(toDayObj.getYear(),toDayObj.getMonth(),toDayObj.getDate());
	java.sql.Date FromDate=new java.sql.Date(toDayObj.getYear(),toDayObj.getMonth(),toDayObj.getDate());
	try
	{
		JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
		poFunction = EzSAPHandler.getJCoFunction(destination,"ZEZ_UNRELEASED_POS");
		JCoParameterList sapTabParam= poFunction.getTableParameterList();
		
		sapPurOrd 	 = poFunction.getImportParameterList();
		sapPurOrd.setValue("FROM_DATE",FromDate);
		sapPurOrd.setValue("TO_DATE",toDate);	
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>FROM_DATE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("FROM_DATE"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>TO_DATE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("TO_DATE"),"D");
		
		JCoTable compCodeTab   	= sapTabParam.getTable("COMP_CODE");
		compCodeTab.appendRow();
		compCodeTab.setValue("SIGN","I");
		compCodeTab.setValue("OPTION","EQ");
		compCodeTab.setValue("LOW","5000");
		
		compCodeTab.appendRow();
		compCodeTab.setValue("SIGN","I");
		compCodeTab.setValue("OPTION","EQ");
		compCodeTab.setValue("LOW","1000");
		
		compCodeTab.appendRow();
		compCodeTab.setValue("SIGN","I");
		compCodeTab.setValue("OPTION","EQ");
		compCodeTab.setValue("LOW","4500");		
		
		JCoTable poDocTypeTab   = sapTabParam.getTable("DOC_TYPE");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZH01");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZH02");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZH03");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZH04");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZH05");
		poDocTypeTab.appendRow();
		poDocTypeTab.setValue("SIGN","I");
		poDocTypeTab.setValue("OPTION","EQ");
		poDocTypeTab.setValue("BSART_LOW","ZIMP");
		
		JCoTable relCodeTab   	= sapTabParam.getTable("REL_CODE");
		relCodeTab.appendRow();
		relCodeTab.setValue("SIGN","I");
		relCodeTab.setValue("OPTION","EQ");
		relCodeTab.setValue("LOW","BY");
		
		try{
			poFunction.execute(destination);
		}catch(Exception e){
			ezc.ezcommon.EzLog4j.log("Exception in Executing ZEZ_UNRELEASED_POS>>>"+e,"I");		
		}

		try {
			JCoTable sapPoList = poFunction.getTableParameterList().getTable("UNREL_POS");

			int poCount = sapPoList.getNumRows();
			

			if (poCount>0)
			{
				do{
					//Set All required field Values
					poRelHdrXML.setFieldValue("ORDER", sapPoList.getValue("EBELN"));
					poRelHdrXML.setFieldValue("VENDOR_NUMBER",sapPoList.getValue("LIFNR"));
					poRelHdrXML.setFieldValue("ORDERTYPE", sapPoList.getValue("BSART"));
					poRelHdrXML.setFieldValue("PURGRP",sapPoList.getValue("EKGRP"));

					try{
						poRelHdrXML.setFieldValue("PLANT",sapPoList.getValue("EQ_WERKS"));
					}catch(Exception e){}	
			
					poRelHdrXML.setFieldValue("ORDERDATE", sapPoList.getValue("BEDAT"));
					poRelHdrXML.setFieldValue("COMPCODE", sapPoList.getValue("BUKRS"));
					poRelHdrXML.setFieldValue("PURCH_ORG", sapPoList.getValue("EKORG"));
					poRelHdrXML.setFieldValue("CREATED_BY", sapPoList.getValue("ERNAM"));
					poRelHdrXML.addRow();
				}
				while(sapPoList.nextRow());
			}	

		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDERS TABLE>>>"+e,"I");
		}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDERS>>>"+e,"I");
	}


	int poRelHdrXMLCount=0;

	if(poRelHdrXML!=null)
	    poRelHdrXMLCount=poRelHdrXML.getRowCount();

	if(poRelHdrXMLCount>0)
		{
			
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ArrayList<String> poArrList = new ArrayList<String>();
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
			miscTableRow.setQuery("select EZPA_DOC_NO from EZC_PO_ACKNOWLEDGEMENT WHERE EZPA_PO_DOC_TYPE='P'");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			try
			{
				dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int dtlXMLCnt = 0;
				if(dtlXML != null)
					dtlXMLCnt = dtlXML.getRowCount();
				log("portal po count"+dtlXMLCnt);
				for(int i=0;i<dtlXMLCnt;i++)
				{
					poArrList.add(dtlXML.getFieldValueString(i,"EZPA_DOC_NO"));
				}
	
			}
			catch(Exception e)
			{
				log("Exception in getting Purchase Group List>>>>>"+e);
			}
	
			ArrayList<String> poDocArr = new ArrayList<String>();
			 
			mainParams = new ezc.ezparam.EzcParams(false);
			miscTable = new ezc.misctransactions.params.EzMiscTable();
			miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve masterRetObj	  =	null;
			miscTableRow.setQuery("SELECT DISTINCT MAP_TYPE,VALUE2 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE IN ('PO_DOC_TYPE')");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			try
			{
				masterRetObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int masterRetObjCnt = 0;
				if(masterRetObj != null)
					masterRetObjCnt = masterRetObj.getRowCount();
	
				for(int i=0;i<masterRetObjCnt;i++)
				{
					if("PO_DOC_TYPE".equals(masterRetObj.getFieldValueString(i,"MAP_TYPE")))	
						poDocArr.add(masterRetObj.getFieldValueString(i,"VALUE2"));
					/*
					else if("NR_DIR_ASN".equals(masterRetObj.getFieldValueString(i,"EMKV_MASTER_TYPE")))	
						dirASNGrp.add(masterRetObj.getFieldValueString(i,"EMKV_KEY"));
					*/
	
				}
	
			}
			catch(Exception e)
			{
				log("Exception in getting Purchase Group List>>>>>"+e);
			}
		
			String vendorCodesStr = "";
			int indx = 0;	
			Vector poVendVect = new Vector();
			
					ezc.ezvendorapp.params.EzPOAcknowledgementTable addAckTab=new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
					ezc.ezvendorapp.params.EzPOAcknowledgementTableRow addAckTabRow=null;
					ezc.ezvendorapp.params.EzVendorTimeStampStructure ackTimeStamp=new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
	
					java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					java.util.Date dt = new java.util.Date();
					String createdOn= sdf.format(dt);
	
					for(int i=0;i<poRelHdrXMLCount;i++)
					{
						String tempSapVend	=(poRelHdrXML.getFieldValueString(i,"VENDOR_NUMBER")).trim();
						String tempDocNo  	= poRelHdrXML.getFieldValueString(i,"ORDER");
						String poDocType 	= poRelHdrXML.getFieldValueString(i,"ORDERTYPE");
						tempDocNo = tempDocNo.trim();
						
						if("".equals(tempSapVend) || poArrList.contains(tempDocNo))
							continue;
						
						//if(!poDocArr.contains(poDocType))
							//continue;
	
						String myOrderDate = "";
						boolean addAckflg=false;
						boolean updateAckflg=false;
	
						
	
						String tempRecStat	=(poRelHdrXML.getFieldValueString(i,"RECORDSTATUS"));
						String tempOrdType	=(poRelHdrXML.getFieldValueString(i,"ORDERTYPE"));
						String tempOrdGrp	=(poRelHdrXML.getFieldValueString(i,"PURGRP"));
	
						String plant 		= poRelHdrXML.getFieldValueString(i,"PLANT");
						String purGrpName 	= poRelHdrXML.getFieldValueString(i,"PURGRP_NAME");
						String purOrg 		= poRelHdrXML.getFieldValueString(i,"PURCH_ORG");
						String compCode 	= poRelHdrXML.getFieldValueString(i,"COMPCODE");
						String poSysKey		= "999800";//(String)orgSysKeysHT.get(purOrg);
						String createdBy 	= poRelHdrXML.getFieldValueString(i,"CREATED_BY");
						if(poSysKey==null || "null".equals(poSysKey) || "".equals(poSysKey))
							continue;
						out.print("tempDocNo::"+tempDocNo);
						
						String startDate = "";
						try{
							sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
							dt = (java.util.Date)poRelHdrXML.getFieldValue(i,"START_DATE");
							startDate= sdf.format(dt);
						}catch(Exception e){
							 startDate = "1900-01-01 00:00:00";
						}
						
						String endDate = "";
						try{
							sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
							dt = (java.util.Date)poRelHdrXML.getFieldValue(i,"END_DATE");
							endDate= sdf.format(dt);
						}catch(Exception e){
							 endDate = "1900-01-01 00:00:00";
						}
	
						if(tempOrdGrp!=null)
							tempOrdGrp=(tempOrdGrp.toUpperCase()).trim();
	
	
						sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						dt = (java.util.Date)poRelHdrXML.getFieldValue(i,"ORDERDATE");
						myOrderDate= sdf.format(dt);
	
						if(tempRecStat==null||"null".equals(tempRecStat)) 
							tempRecStat="";
	
						
						addAckTabRow =  new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();
	
						addAckTabRow.setSysKey(poSysKey);
						addAckTabRow.setSoldTo(tempSapVend);
						addAckTabRow.setDocNo(tempDocNo);
						addAckTabRow.setDocDate(myOrderDate);
	
						addAckTabRow.setCreatedOn(createdOn);
						addAckTabRow.setModifiedOn(createdOn);
						addAckTabRow.setCreatedBy(createdBy);
						addAckTabRow.setModifiedOn(createdOn);
						addAckTabRow.setHeaderText("");
						addAckTabRow.setExt1(tempOrdGrp);
						addAckTabRow.setExt2(poDocType);
						addAckTabRow.setExt3(tempRecStat);
	
						addAckTabRow.setPoDocType("P");
						addAckTabRow.setPlant(plant);
						addAckTabRow.setPurGrpName(purGrpName);
						addAckTabRow.setStartDate(startDate);
						addAckTabRow.setEndDate(endDate);
	
						addAckTabRow.setPoAmended("N");
						addAckTabRow.setCompCode(compCode);
						addAckTabRow.setSmsStatus("N");
						addAckTabRow.setPurOrg(purOrg);
						addAckTabRow.setDocStatus("X");
						
						addAckTab.appendRow(addAckTabRow);
						
					}
	
					ezc.ezcommon.EzLog4j.log("TO_BE_INSERTED_POS_COUNT>>>>>>>>"+addAckTab.getRowCount(),"I");  
					if(addAckTab.getRowCount()>0)
					{
						ezcContainer = new ezc.ezparam.EzcParams(true);
						ackTimeStamp.setExt1("");
						ackTimeStamp.setExt2("");
						ackTimeStamp.setAuthKey("POUPDATEDDATE");
						ackTimeStamp.setSysKey(dummySysKey);
						ackTimeStamp.setSoldTo("CFLADM");
						ackTimeStamp.setFlag("Y");
						ezcContainer.setLocalStore("Y");
						ezcContainer.setObject(addAckTab);
						ezcContainer.setObject(ackTimeStamp);
						Session.prepareParams(ezcContainer);
						ReturnObjFromRetrieve retAdd= (ReturnObjFromRetrieve)AppManager.ezAddPOAcknowledgement(ezcContainer);

						//if(retAdd.isError())
							//sendMail = false;
					}	
	

					 
					
				}
				
			
		
		
		try{ 
			ezc.ezcommon.EzLog4j.log("POS_SYNCH_LOGOUT>>>>>>>>","I");
			Session.logOut(); 
		} catch(Exception e) { 
			ezc.ezcommon.EzLog4j.log("POS_SYNCH_LOGOUT ERROR>>>>>>>>"+e,"E");
		} 
	session.invalidate();
	out.print("GET_POS_FROM_SAP_END>>>>>>>>"+poRelHdrXML.toEzcString());	

%>