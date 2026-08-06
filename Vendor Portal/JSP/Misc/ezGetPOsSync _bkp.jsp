<%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader,java.io.OutputStreamWriter,java.net.HttpURLConnection,java.net.URLEncoder,java.net.*"%>
<%@ page import="ezc.ezpurcontract.csb.*,ezc.ezvendorapp.params.*" %>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="PoManager" class="ezc.client.EzPurContractManager" scope="page"></jsp:useBean>
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %> 
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="vendorTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />

<%@ page import ="java.net.*,java.net.*" %>

<%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>
<%
	String site = request.getParameter("site");
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	
	logs.setUserId("SESSIONUSR");
	logs.setPassWd("portal");
	logs.setConnGroup(site);
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	
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
	out.print(orgSysKeysHT);			
	String dummySysKey = "999999";
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	
	EzcParams ezcContainer = new ezc.ezparam.EzcParams(false);
	ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();

	ezcContainer = new ezc.ezparam.EzcParams(false);
	ezc.ezvendorapp.params.EziPurchaseOrderParams timeStampParams= new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	ezcContainer.setLocalStore("Y");
	timeStampParams.setDocType("POUPDATEDDATE");
	timeStampParams.setSysKey(dummySysKey);
	timeStampParams.setSoldTo("CFLADM");
	ezcContainer.setObject(timeStampParams);
	Session.prepareParams(ezcContainer);
	ezc.ezparam.ReturnObjFromRetrieve retDate=(ezc.ezparam.ReturnObjFromRetrieve)AppManager.ezGetVendorTimeStamp(ezcContainer);
	java.util.Date toDayObj=new java.util.Date();
	toDayObj.setDate(toDayObj.getDate()-1);
	java.sql.Date FromDate=new java.sql.Date(toDayObj.getYear(),toDayObj.getMonth(),toDayObj.getDate());
	
	formatDate = new ezc.ezutil.FormatDate();
	if(retDate!=null && retDate.getRowCount()>0)
	{
		String lastLoginDate 	= formatDate.getStringFromDate((java.util.Date)retDate.getFieldValue(0,"DOCDATE"),"/",FormatDate.MMDDYYYY);
		int dateArray[]      	= formatDate.getMMDDYYYY(lastLoginDate,true);
		FromDate              = new java.sql.Date(dateArray[2]-1900,dateArray[0]-1,dateArray[1]);
	}
	else
	{
		ezc.ezparam.EzcParams aParams = new ezc.ezparam.EzcParams(false);
		ezc.ezvendorapp.params.EzVendorTimeStampStructure addtimeStampParams= new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
		aParams.setLocalStore("Y");
		addtimeStampParams.setAuthKey("POUPDATEDDATE");
		addtimeStampParams.setSysKey(dummySysKey);
		addtimeStampParams.setSoldTo("CFLADM");
		addtimeStampParams.setExt1("");
		addtimeStampParams.setExt2("");
		aParams.setObject(addtimeStampParams);
		Session.prepareParams(aParams);
		AppManager.ezAddVendorTimeStamp(aParams);
	}   
	 Calendar cal = Calendar.getInstance();
	 cal.add(Calendar.MONTH, -1);
	FromDate              = new java.sql.Date(cal.getTime().getTime());
	java.sql.Date ToDate  = new java.sql.Date(Calendar.getInstance().getTime().getTime());

	//FromDate              = new java.sql.Date(117,03,12);
	//java.sql.Date ToDate  = new java.sql.Date(117,12,16);
	
	
	ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>FromDate>>>>"+FromDate,"I");
	ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>ToDate>>>>"+ToDate,"I");
	
	ezc.ezcommon.EzLog4j.log("GET_POS_FROM_SAP_STARTS>>>>>>>>","I");	
				
	ReturnObjFromRetrieve poRelHdrXML = new ReturnObjFromRetrieve(new String[]{"ORDER","VENDOR_NUMBER","RECORDSTATUS","RECORDSTATUS","ORDERTYPE","PURCH_ORG","PURGRP","PURGRP_NAME","START_DATE","END_DATE","ORDERDATE","COMPCODE","PLANT","CREATED_BY"});

	JCoFunction poFunction = null;
	JCoParameterList sapPurOrd = null;

	try
	{
		JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
		poFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_BAPI_PO_GETITEMS");

		sapPurOrd 	 = poFunction.getImportParameterList();
		
		//sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","A");
		//sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","");
		sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","A");
		//sapPurOrd.setValue("CO_CODE","1000");

		if (FromDate != null )
			sapPurOrd.setValue("DOC_DATE",FromDate);
			
		sapPurOrd.setValue("TO_DATE",ToDate);	

		sapPurOrd.setValue("WITH_PO_HEADERS","X");
		sapPurOrd.setValue("DOC_CATEGORY","F");

		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>ITEMS_OPEN_FOR_RECEIPT>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("ITEMS_OPEN_FOR_RECEIPT"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PURCH_ORG>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("PURCH_ORG"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>CO_CODE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("CO_CODE"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>DOC_DATE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("DOC_DATE"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>TO_DATE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("TO_DATE"),"D");
		ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>DOC_CATEGORY>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("DOC_CATEGORY"),"D");


		try{
			poFunction.execute(destination);
		}catch(Exception e){
			ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
		}

		try {
			JCoTable sapPoList = poFunction.getTableParameterList().getTable("PO_HEADERS");

			int poCount = sapPoList.getNumRows();
			//ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>sapPoList>>>>>>>>>>>>>>>:"+sapPoList,"I");
			//ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>poCount>>>>>>>>>>>>>>>:"+poCount,"I");
			
			if (poCount>0)
			{
				do{
					//Set All required field Values
					poRelHdrXML.setFieldValue("ORDER", sapPoList.getValue("PO_NUMBER"));
					poRelHdrXML.setFieldValue("VENDOR_NUMBER",sapPoList.getValue("VENDOR"));
					poRelHdrXML.setFieldValue("RECORDSTATUS",sapPoList.getValue("TELEPHONE"));
					poRelHdrXML.setFieldValue("ORDERTYPE", sapPoList.getValue("DOC_TYPE"));
					poRelHdrXML.setFieldValue("PURGRP",sapPoList.getValue("PUR_GROUP"));

					try{
						poRelHdrXML.setFieldValue("PLANT",sapPoList.getValue("PLANT"));
					}catch(Exception e){}	
					try{
						poRelHdrXML.setFieldValue("PURGRP_NAME",sapPoList.getValue("PUR_GROUP_NAME"));
					}catch(Exception e){}	

					
					poRelHdrXML.setFieldValue("START_DATE",sapPoList.getValue("VPER_START"));
					poRelHdrXML.setFieldValue("END_DATE",sapPoList.getValue("VPER_END"));
					poRelHdrXML.setFieldValue("ORDERDATE", sapPoList.getValue("DOC_DATE"));
					poRelHdrXML.setFieldValue("COMPCODE", sapPoList.getValue("CO_CODE"));
					poRelHdrXML.setFieldValue("PURCH_ORG", sapPoList.getValue("PURCH_ORG"));
					poRelHdrXML.setFieldValue("CREATED_BY", sapPoList.getValue("CREATED_BY"));
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

	ezc.ezcommon.EzLog4j.log("POS_FROM_SAP>>>>>>>>"+poRelHdrXMLCount,"I");  
	ezc.ezcommon.EzLog4j.log("GET_POS_FROM_SAP_END>>>>>>>>"+poRelHdrXML.toEzcString(),"I");	
	
	
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
			
					if(!poDocArr.contains(poDocType))
						continue;

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
					String poSysKey		= (String)orgSysKeysHT.get(purOrg);
					String createdBy 	= poRelHdrXML.getFieldValueString(i,"CREATEDBY");
					
					if(poSysKey==null || "null".equals(poSysKey) || "".equals(poSysKey))
						continue;
					
					
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
%>