 <%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
 <%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
 <%@ page import="java.io.BufferedReader, java.io.InputStreamReader,java.io.OutputStreamWriter,java.net.HttpURLConnection,java.net.URLEncoder,java.net.*"%>
 <%@page import="ezc.ezpreprocurement.params.*" %>
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
 
 	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
 	
 	logs.setUserId("SESSIONUSR");
 	logs.setPassWd("portal");
 	logs.setConnGroup("200");
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
 		snkparams1.setSiteNumber(200);
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
 				
 	String dummySysKey = "999999";
 	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
 	
 	EzcParams ezcContainer = new ezc.ezparam.EzcParams(false);
 	EziRFQHeaderParams 	ezirfqheaderparams_RFQ  = new EziRFQHeaderParams();
 	ezc.ezpreprocurement.client.EzPreProcurementManager ezRFQManager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
 
 	ezcContainer = new ezc.ezparam.EzcParams(false);
 	ezc.ezvendorapp.params.EziPurchaseOrderParams timeStampParams= new ezc.ezvendorapp.params.EziPurchaseOrderParams();
 	ezcContainer.setLocalStore("Y");
 	timeStampParams.setDocType("POUPDATEDDATE");
 	timeStampParams.setSysKey(dummySysKey);
 	timeStampParams.setSoldTo("CFLRFQ");
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
 		addtimeStampParams.setSoldTo("CFLRFQ");
 		addtimeStampParams.setExt1("");
 		addtimeStampParams.setExt2("");
 		aParams.setObject(addtimeStampParams);
 		Session.prepareParams(aParams);
 		AppManager.ezAddVendorTimeStamp(aParams);
 	}   
 Calendar cal = Calendar.getInstance();
 cal.add(Calendar.MONTH, -1);
	FromDate              = new java.sql.Date(cal.getTime().getTime());
	java.sql.Date ToDate  = new java.sql.Date(Calendar.getInstance().getTime().getTime());//new java.sql.Date(117,07,10);
 	
 	
 	ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>FromDate>>>>"+FromDate,"I");
 	//ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>ToDate>>>>"+ToDate,"I");
 	
 	ezc.ezcommon.EzLog4j.log("GET_RFQS_FROM_SAP_STARTS>>>>>>>>","I");	
 				
 	ReturnObjFromRetrieve rfqRelHdrXML = new ReturnObjFromRetrieve(new String[]{"ORDER","VENDOR_NUMBER","RECORDSTATUS","RECORDSTATUS","ORDERTYPE","PURCH_ORG","PURGRP","PURGRP_NAME","QUOT_DEAD","COLL_NO","ORDERDATE","COMPCODE","PLANT"});
 
 	JCoFunction poFunction = null;
 	JCoParameterList sapPurOrd = null;
 
 	try
 	{
 		JCoDestination destination = EzSAPHandler.getDestination("200~999");
 		poFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_BAPI_PO_GETITEMS");
 
 		sapPurOrd 	 = poFunction.getImportParameterList();
 		
 		//sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","A");
 		sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","");
 		sapPurOrd.setValue("CO_CODE","CFL");
 
 		if (FromDate != null )
 			sapPurOrd.setValue("DOC_DATE",FromDate);
 			
 		sapPurOrd.setValue("TO_DATE",ToDate);	
 
 		sapPurOrd.setValue("WITH_PO_HEADERS","X");
 		sapPurOrd.setValue("DOC_CATEGORY","A");
 
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
 			ezc.ezcommon.EzLog4j.log("sapPoListsapPoList Z_EZ_BAPI_PO_GETITEMS>>>"+sapPoList,"I");
 			int poCount = sapPoList.getNumRows();
 			ezc.ezcommon.EzLog4j.log("poCountpoCount Z_EZ_BAPI_PO_GETITEMS>>>"+poCount,"I");
 			if (poCount>0)
 			{
 				do{
 					//Set All required field Values
 					rfqRelHdrXML.setFieldValue("ORDER", sapPoList.getValue("PO_NUMBER"));
 					rfqRelHdrXML.setFieldValue("VENDOR_NUMBER",sapPoList.getValue("VENDOR"));
 					rfqRelHdrXML.setFieldValue("RECORDSTATUS",sapPoList.getValue("TELEPHONE"));
 					rfqRelHdrXML.setFieldValue("ORDERTYPE", sapPoList.getValue("DOC_TYPE"));
 					rfqRelHdrXML.setFieldValue("PURGRP",sapPoList.getValue("PUR_GROUP"));
  					rfqRelHdrXML.setFieldValue("COMPCODE", sapPoList.getValue("CO_CODE"));
 					rfqRelHdrXML.setFieldValue("PURCH_ORG", sapPoList.getValue("PURCH_ORG"));
 					
 					try{
 						rfqRelHdrXML.setFieldValue("PLANT",sapPoList.getValue("PLANT"));
 					}catch(Exception e){}	
 
 					rfqRelHdrXML.setFieldValue("PURGRP_NAME",sapPoList.getValue("PUR_GROUP_NAME"));
 					
					rfqRelHdrXML.setFieldValue("ORDERDATE", sapPoList.getValue("DOC_DATE"));
 					rfqRelHdrXML.setFieldValue("QUOT_DEAD",sapPoList.getValue("QUOT_DEAD"));
 					rfqRelHdrXML.setFieldValue("COLL_NO",sapPoList.getValue("COLL_NO"));

 
 					rfqRelHdrXML.addRow();
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
 	
 	
 	int rfqRelHdrXMLCount=0;
 
 	if(rfqRelHdrXML!=null)
 	    rfqRelHdrXMLCount=rfqRelHdrXML.getRowCount();
 
 	ezc.ezcommon.EzLog4j.log("POS_FROM_SAP>>>>>>>>"+rfqRelHdrXMLCount,"I");  
 	ezc.ezcommon.EzLog4j.log("GET_POS_FROM_SAP_END>>>>>>>>"+rfqRelHdrXML.toEzcString(),"I");	
 	
 	
 	if(rfqRelHdrXMLCount>0)
 	{
 		String vendorCodesStr = "";
 		int indx = 0;	
 		Vector poVendVect = new Vector();
 		for(int pv=0;pv<rfqRelHdrXMLCount;pv++)
 		{
 			String poVendor = rfqRelHdrXML.getFieldValueString(pv,"VENDOR_NUMBER");
 			
 			if("".equals(poVendor) || poVendVect.contains(poVendor))
 				continue;
 			
 			if(indx==0)
 				vendorCodesStr = poVendor;
 			else
 				vendorCodesStr += "','"+poVendor;
 			
 			poVendVect.addElement(poVendor);
 			indx++;	
 		}
 
 		java.util.Hashtable vendorsHT = new java.util.Hashtable(); 
 		int vendorsRetObjCnt = 0;
 		ezc.ezparam.ReturnObjFromRetrieve retsoldto = null;
 
 		ezc.ezparam.EzcParams vendorMainParams = new ezc.ezparam.EzcParams(false);
 		ezc.vendortransactions.params.EzVendorTransactionsKeyParams vendorKeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
 		ezc.vendortransactions.params.EzVendorParams  vendorBannerParams= new ezc.vendortransactions.params.EzVendorParams();
 
 		try
 		{
 			vendorKeyParams.setKey("GET_VENDORS");
 			vendorMainParams.setLocalStore("Y");
 
 			vendorBannerParams.setSyskey(allSysKeys);
 			vendorBannerParams.setGroup(" AND EC_ERP_CUST_NO IN ('"+vendorCodesStr+"') AND EC_SYS_KEY = EWWU_SYSKEY");
 
 			vendorMainParams.setObject(vendorKeyParams);	
 			vendorMainParams.setObject(vendorBannerParams);
 			Session.prepareParams(vendorMainParams);
 
 			retsoldto=(ezc.ezparam.ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(vendorMainParams);
 		}
 		catch(Exception e){
 			ezc.ezcommon.EzLog4j.log(":::EEEE:::"+e,"E");
 		}
 	
 		ezc.ezcommon.EzLog4j.log("GET_VENDORS>>>>>>>>"+retsoldto.getRowCount(),"I");
 		
 		
 		String vendorsStr = "";
 
 		if(retsoldto!=null)
 			vendorsRetObjCnt = retsoldto.getRowCount();
 
 		if(vendorsRetObjCnt>0)  
 		{
 			String vendorUserIdStr = "";
 			for(int v=0;v<vendorsRetObjCnt;v++)
 			{
 				String defErpVendor = retsoldto.getFieldValueString(v,"EC_ERP_CUST_NO");
 				String vendUserId = defErpVendor;
 
 				try{
 					vendUserId = Long.parseLong(vendUserId)+"";
 				}catch(Exception e){}
 				
 				if(indx==0)
 					vendorUserIdStr = vendUserId;
 				else
 					vendorUserIdStr += "','"+vendUserId;
 			}
 			
 			ezc.ezparam.ReturnObjFromRetrieve vendorEMailContactRetObj=null;
 			try
 			{
 				ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
 				ezc.vendortransactions.params.EzVendorParams  vendorEmailParams= new ezc.vendortransactions.params.EzVendorParams();
 				ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
 				keyParams.setKey("GET_USER_EMAIL");
 				addMainParams.setLocalStore("Y");
 
 				vendorEmailParams.setUserId(vendorUserIdStr);
 
 
 				addMainParams.setObject(keyParams);	
 				addMainParams.setObject(vendorEmailParams);
 				Session.prepareParams(addMainParams);
 
 				vendorEMailContactRetObj=(ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(addMainParams);
 			}
 			catch(Exception e)
 			{
 				out.println(":::Exception while getting company codes:::"+e);
 			}
 
 			Hashtable userEmailHT = new Hashtable();
 			Hashtable userContactNoHT = new Hashtable();
 
 			if(vendorEMailContactRetObj!=null && vendorEMailContactRetObj.getRowCount()>0)
 			{
 				for(int ec=0;ec<vendorEMailContactRetObj.getRowCount();ec++)
 				{				
 					userEmailHT.put(vendorEMailContactRetObj.getFieldValueString(ec,"EU_ID"),vendorEMailContactRetObj.getFieldValueString(ec,"EU_EMAIL"));
 					userContactNoHT.put(vendorEMailContactRetObj.getFieldValueString(ec,"EU_ID"),vendorEMailContactRetObj.getFieldValueString(ec,"EU_CONTACT_NO"));
 				}	
 			}
 			
 			ezc.ezcommon.EzLog4j.log("userEmailHT>>>>>>>>"+userEmailHT,"I");
 			ezc.ezcommon.EzLog4j.log("userContactNoHT>>>>>>>>"+userContactNoHT,"I");
 			
 			boolean updateTimeStamp = false;
 			/*
 			String rfqdb="";
 			try{
				miscParams.setQuery("SELECT * from EZC_RFQ_HEADER where ERH_SOLD_TO in ('')");

				mainParams.setObject(miscParams);
				mainParams.setLocalStore("Y");
				Session.prepareParams(mainParams);
				ReturnObjFromRetrieve userRFQRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

				if(userRFQRetObj!=null)
				{

				for(int j=0;j<userRFQRetObj.getRowCount();j++)
				{
					 rfqdb = checkNull(userRFQRetObj.getFieldValueString(j,"ERH_EXT1"));
					//out.println("docId:::::::"+rfqdb);

				}
				}
			catch(Exception e){System.out.println(e);}	
				*/
 			for(int vp=0;vp<vendorsRetObjCnt;vp++)
 			{
 				String mobileNo = "",vendEmail="";
 				boolean sendMail = true;
 				
 				String defErpVendor = retsoldto.getFieldValueString(vp,"EC_ERP_CUST_NO");
 				
 				try{
 					vendEmail = (String)userEmailHT.get(Long.parseLong(defErpVendor)+"");
 					mobileNo  = (String)userContactNoHT.get(Long.parseLong(defErpVendor)+"");
 				}catch(Exception e){
 					vendEmail = (String)userEmailHT.get(defErpVendor);
 					mobileNo  = (String)userContactNoHT.get(defErpVendor);
 				} 				
 				
 				ezRFQManager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
 				ezcContainer = new ezc.ezparam.EzcParams(false);
 				ezirfqheaderparams_RFQ  = new EziRFQHeaderParams();
 
				ezirfqheaderparams_RFQ.setSysKey(allSysKeys);
				ezirfqheaderparams_RFQ.setStatus("N','Y");
				ezirfqheaderparams_RFQ.setSoldTo(defErpVendor); 
				ezirfqheaderparams_RFQ.setExt1(""); 

				ezcContainer.setLocalStore("Y");
				ezcContainer.setObject(ezirfqheaderparams_RFQ);
				Session.prepareParams(ezcContainer);	
 				
 				ezc.ezcommon.EzLog4j.log("TO BE QUOTED RFQs CALL START>>","I");
 				ReturnObjFromRetrieve allRFQsInLDB= (ReturnObjFromRetrieve)ezRFQManager.ezGetRFQList(ezcContainer);
 				ezc.ezcommon.EzLog4j.log("GET_VENDOR_ALL_POS>>>>>>>>"+allRFQsInLDB.toEzcString(),"I");	
 
 				java.util.Vector allDocVect=new java.util.Vector();
 				int allRFQsInLDBCount = 0;
 
 				if(allRFQsInLDB!=null)
 				{
 					allRFQsInLDBCount = allRFQsInLDB.getRowCount();
 					for(int i=0;i<allRFQsInLDBCount;i++)
 					{
 						//allDocVect.addElement(allRFQsInLDB.getFieldValueString(i,"RFQ_NO"));
 						allDocVect.addElement(allRFQsInLDB.getFieldValueString(i,"EXT1").trim());
 					}
 				}	
 
 				ezc.ezcommon.EzLog4j.log("GET_VENDOR_ALL_RFQS_VECTOR>>>>>>>>"+allDocVect,"I");
 				
 				
 				ezRFQManager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
				EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
				EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
				EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
				EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	
				
				EzRFQConditionsTable 	condTable 		= new EzRFQConditionsTable();
				
 				ezc.ezvendorapp.params.EzVendorTimeStampStructure ackTimeStamp=new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
 
 				java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
 				java.util.Date dt = new java.util.Date();
 				String createdOn= sdf.format(dt);
				 ezc.valuemap.params.EziValueMappingParams valueParams = null;
 				for(int i=0;i<rfqRelHdrXMLCount;i++)
 				{
 					String tempSapVend	=(rfqRelHdrXML.getFieldValueString(i,"VENDOR_NUMBER")).trim();
 
 					if(!defErpVendor.equals(tempSapVend))
 						continue;
 						
 					
					String portalRFQNumber = "";
					ReturnObjFromRetrieve	valMapRetObj = null;
					ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
					ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
					 valueParams =  new ezc.valuemap.params.EziValueMappingParams();

					valueParams.setMapType("PORTAL_RFQ_NR_RANGE");

					mainParams.setObject(valueParams);	
					Session.prepareParams(mainParams);

					try{
						valMapRetObj = (ReturnObjFromRetrieve)valMapMgr.ezGetValueMapping(mainParams);
					}catch(Exception e){}	

					if(valMapRetObj!=null && valMapRetObj.getRowCount()>0)
					{
						portalRFQNumber = valMapRetObj.getFieldValueString(0,"VALUE1");

						String nextNr = "";

						try{

							nextNr = (Long.parseLong(portalRFQNumber)+1)+"";

							mainParams = new ezc.ezparam.EzcParams(true);
							valueParams =  new ezc.valuemap.params.EziValueMappingParams();

							valueParams.setValue1(nextNr);
							valueParams.setMapType(" MAP_TYPE = 'PORTAL_RFQ_NR_RANGE'");

							mainParams.setObject(valueParams);	
							Session.prepareParams(mainParams);

							valMapMgr.ezUpdateValueMapping(mainParams);	

						}catch(Exception e){}	
					}

					portalRFQNumber = "0000000000"+portalRFQNumber;
					portalRFQNumber = portalRFQNumber.substring(portalRFQNumber.length()-10,portalRFQNumber.length());
	
 
 					String myRFQDate = "";
 					
 					String rfqNo  		= portalRFQNumber;//rfqRelHdrXML.getFieldValueString(i,"ORDER");
 					String colRfqNo		= rfqRelHdrXML.getFieldValueString(i,"COLL_NO");
 					String purOrg  		= rfqRelHdrXML.getFieldValueString(i,"PURCH_ORG");
 					String purGrp  		= rfqRelHdrXML.getFieldValueString(i,"PURGRP");
 					String compCode 	= rfqRelHdrXML.getFieldValueString(i,"COMPCODE");
 					
 					String quoteEndDate = "";
 					try{
 						sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
 						dt = (java.util.Date)rfqRelHdrXML.getFieldValue(i,"QUOT_DEAD");
 						quoteEndDate= sdf.format(dt);
 					}catch(Exception e){
 						 quoteEndDate = "1900-01-01 00:00:00";
 					}
 
  
 					sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
 					dt = (java.util.Date)rfqRelHdrXML.getFieldValue(i,"ORDERDATE");
 					myRFQDate= sdf.format(dt);
 					
 					if(!allDocVect.contains(rfqRelHdrXML.getFieldValueString(i,"ORDER")))
 					{
						ezirfqheadertablerow = new EziRFQHeaderTableRow();
						ezirfqheadertablerow.setRFQNo(rfqNo);
						ezirfqheadertablerow.setCollectiveRFQNo(colRfqNo);
						ezirfqheadertablerow.setSysKey((String)orgSysKeysHT.get(purOrg));
						ezirfqheadertablerow.setSoldTo(tempSapVend);
						ezirfqheadertablerow.setPRNo("");
						ezirfqheadertablerow.setPRItmNo("");
						ezirfqheadertablerow.setStatus("N");
						ezirfqheadertablerow.setRFQDate(myRFQDate);
						ezirfqheadertablerow.setValidUpto(quoteEndDate);
						ezirfqheadertablerow.setCreatedBy("CFLADM");
						ezirfqheadertablerow.setModifiedBy("");
						ezirfqheadertablerow.setCompCode(compCode);
						ezirfqheadertablerow.setPurchaseOrg(purOrg);		
						ezirfqheadertablerow.setPurchaseGrp(purGrp);
						ezirfqheadertablerow.setVendorType("");
						ezirfqheadertablerow.setAgentCode("");
						ezirfqheadertablerow.setReleaseIndicator("");
						ezirfqheadertablerow.setRankStatus("");
						ezirfqheadertablerow.setExt1(rfqRelHdrXML.getFieldValueString(i,"ORDER"));
						ezirfqheadertablerow.setExt2(tempSapVend);
						ezirfqheadertablerow.setExt3("");
						ezirfqheadertablerow.setValType("");
						ezirfqheadertablerow.setPRDetails("");
						ezirfqheadertablerow.setPriceValDate("1900-01-01 00:00:00");
						ezirfqheadertablerow.setQuoteRef("");
						ezirfqheadertablerow.setDelvPeriod("");
						ezirfqheadertablerow.setGuaranteePeriod("");
						ezirfqheadertablerow.setRequestRequote("");
						ezirfqheadertablerow.setPlant("");
					
						ezirfqheadertable.appendRow(ezirfqheadertablerow);	
					}	
						
				}
				
				ezc.ezcommon.EzLog4j.log("TO_BE_INSERTED_RFQS_COUNT>>>>>>>>"+ezirfqheadertable.getRowCount(),"I");  

				if(ezirfqheadertable.getRowCount()>0)
				{
					updateTimeStamp = true;
						EzRFQQuoteHistoryTable 	rfqQuoteHistoryTable 	= new EzRFQQuoteHistoryTable();
						
					ezcContainer = new EzcParams(true);
					ezcContainer.setLocalStore("Y");
					ezcContainer.setObject(ezirfqheadertable);
					ezcContainer.setObject(ezirfqdetailstable);
					ezcContainer.setObject(condTable);
					ezcContainer.setObject(rfqQuoteHistoryTable);
					Session.prepareParams(ezcContainer);
					try
					{
						ezRFQManager.ezAddRFQ(ezcContainer);
					}
					catch(Exception e)
					{
						ezc.ezcommon.EzLog4j.log("Error while inserting RFQs in DB"+e,"I");
						sendMail = false;
					}

				}
 	
 				/**************SMS and MAIL Sending Starts***********************/
 				
 				if(ezirfqheadertable.getRowCount()>0 && sendMail)
 				{
 					String sentStatus="N",smsRFQ="",poAmended="";
 
 					EziRFQHeaderTableRow linesRow = null;
 					for(int p=0;p<ezirfqheadertable.getRowCount();p++)
 					{
 						linesRow = (EziRFQHeaderTableRow)ezirfqheadertable.getRow(p);
 						smsRFQ = linesRow.getRFQNo();
 
 						poAmended = "N";
 						
 						ezc.ezcommon.EzLog4j.log("::MOBILE NO::::"+mobileNo,"I");
 						ezc.ezcommon.EzLog4j.log("SMS_PO>>>>>>>>"+smsRFQ,"I");  
 
 						String smsMesg    = "Below RFQ is created from Coromandel "+smsRFQ+" Please login to the Vendor Portal make the Quotation.";
 %>						
 						<%@ include file="ezSendSMS.jsp"%>
 <%
 						ezc.ezcommon.EzLog4j.log("::EMAIL::::"+vendEmail,"I");
 						
 						if("OK".equals(smsResponse))
 							sentStatus = "Y";
 							
 						ezc.ezcommon.EzLog4j.log("SMS Sent STATUS>>>>>>>"+sentStatus,"I");	
 						
						String toEMailIds = vendEmail;
						String ccEMailIds = "";
 
 						String msgSubject = "Coromandel : Request For Quotation -"+smsRFQ;
 					//	String eMailData = "Dear Sir/Madam, <Br><Br> Below RFQ has created. <Br>"+smsRFQ+" <Br><Br>Please login to the vendor portal for quotation.<Br><Br>Regards,<Br> Coromandel International Limited. <Br><Br><B>Portal Link : <a href=http://172.25.10.73:50000  target=_blank>172.25.10.73:50000</a></B>";
 						String eMailData = "Dear Sir/Madam, <Br><Br> RFQ "+smsRFQ+" has created.<Br><Br>Please login to the vendor portal for quotation.<Br><Br>Regards,<Br> Coromandel International Limited. <Br><Br><B>Portal Link : <a href="+request.getScheme()+"://"+request.getServerName()+"  target=_blank>"+request.getServerName()+"</a></B>";
 
 						ezc.ezcommon.EzLog4j.log("MAIL MSGSUBJECT>>>>>>>"+msgSubject,"I");
 						ezc.ezcommon.EzLog4j.log("MAIL MSGTEXT>>>>>>>"+eMailData,"I");
 
%>
						<%@ include file="ezSendExternalMail.jsp"%>
<%

 					}
 				}
 				/**************SMS and MAIL Sending End***********************/
 			}
 			
 			if(updateTimeStamp)
 			{
				ezc.ezparam.EzcParams ts_Params = new ezc.ezparam.EzcParams(false);
				ezc.ezvendorapp.params.EzVendorTimeStampStructure updatetimeStampParams= new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
				
				updatetimeStampParams.setAuthKey("POUPDATEDDATE");
				updatetimeStampParams.setSysKey(dummySysKey);
				updatetimeStampParams.setSoldTo("CFLRFQ");
				updatetimeStampParams.setExt1("");
				updatetimeStampParams.setExt2("");
				
				ts_Params.setLocalStore("Y");
				ts_Params.setObject(updatetimeStampParams);
				Session.prepareParams(ts_Params);
				AppManager.ezUpdateVendorTimeStamp(ts_Params);
 			}
 			
 		}	
 	}	
 	
 	
 	try{ 
 		ezc.ezcommon.EzLog4j.log("RFQS_SYNCH_LOGOUT>>>>>>>>","I");
 		Session.logOut(); 
 	} catch(Exception e) { 
 		ezc.ezcommon.EzLog4j.log("RFQS_SYNCH_LOGOUT ERROR>>>>>>>>"+e,"E");
 	} 
 	session.invalidate();
%>