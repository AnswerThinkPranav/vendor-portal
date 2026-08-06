
<%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader,java.io.OutputStreamWriter,java.net.HttpURLConnection,java.net.URLEncoder,java.net.*"%>
<%@ page import="ezc.ezpurcontract.csb.*,ezc.ezvendorapp.params.*" %>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="PoManager" class="ezc.client.EzPurContractManager" scope="page"></jsp:useBean>
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %> 
<jsp:useBean id="AppManager1" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="vendorTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />


<%@ page import ="java.net.*,java.net.*" %>

<%//@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>
<jsp:useBean id="miscManager1" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>

<%
ezc.ezcommon.EzLog4j.log(":::WEB STATS CALL START:::::","I");
ReturnObjFromRetrieve vendWebStatRet=null;
int vendWebStatRetCnt=0;

String weStatQry="SELECT * FROM EZC_WEB_STATS WHERE EWS_USER_ID='"+Session.getUserId()+"'";
ezc.ezparam.EzcParams webStatMainParams = new ezc.ezparam.EzcParams(true);
EziMiscParams webStatMiscParams = new EziMiscParams();
webStatMiscParams.setQuery(weStatQry);
webStatMainParams.setObject(webStatMiscParams);	
Session.prepareParams(webStatMainParams);
ezc.ezcommon.EzLog4j.log(":::WEB STATS CALL QUERY:::::"+webStatMiscParams.getQuery(),"I");
try
{
	vendWebStatRet = (ReturnObjFromRetrieve)miscManager1.ezSelect(webStatMainParams);
}
catch(Exception e){}
if(vendWebStatRet!=null)
{
	vendWebStatRetCnt=vendWebStatRet.getRowCount();
}
ezc.ezcommon.EzLog4j.log("::vendWebStatRetCntvendWebStatRetCnt:::::"+vendWebStatRetCnt,"I");
if(vendWebStatRetCnt==1)
{
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
		ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	
		ezcContainer = new ezc.ezparam.EzcParams(false);
		ezc.ezvendorapp.params.EziPurchaseOrderParams timeStampParams= new ezc.ezvendorapp.params.EziPurchaseOrderParams();
		ezcContainer.setLocalStore("Y");
		timeStampParams.setDocType("POUPDATEDDATE");
		timeStampParams.setSysKey(dummySysKey);
		timeStampParams.setSoldTo("CFLADM");
		ezcContainer.setObject(timeStampParams);
		Session.prepareParams(ezcContainer);
		ezc.ezparam.ReturnObjFromRetrieve retDate=(ezc.ezparam.ReturnObjFromRetrieve)AppManager1.ezGetVendorTimeStamp(ezcContainer);
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
			AppManager1.ezAddVendorTimeStamp(aParams);
		}   
		 Calendar cal = Calendar.getInstance();
		 cal.add(Calendar.MONTH, -6);
		
		FromDate              = new java.sql.Date(cal.getTime().getTime());
		java.sql.Date ToDate  = new java.sql.Date(Calendar.getInstance().getTime().getTime());
	
		//FromDate              = new java.sql.Date(117,07,12);
		//java.sql.Date ToDate  = new java.sql.Date(117,07,16);
		
		
		ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>FromDate>>>>"+FromDate,"I");
		//ezc.ezcommon.EzLog4j.log("CFLADM TIME STAMP>>>>ToDate>>>>"+ToDate,"I");
		
		ezc.ezcommon.EzLog4j.log("GET_POS_FROM_SAP_STARTS>>>>>>>>","I");	
					
		ReturnObjFromRetrieve poRelHdrXML = new ReturnObjFromRetrieve(new String[]{"ORDER","VENDOR_NUMBER","RECORDSTATUS","RECORDSTATUS","ORDERTYPE","PURCH_ORG","PURGRP","PURGRP_NAME","START_DATE","END_DATE","ORDERDATE","COMPCODE","PLANT"});
	
		JCoFunction poFunction = null;
		JCoParameterList sapPurOrd = null;
	
		try
		{
			String logonSite = (String)session.getValue("SITE");
			JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
			poFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_BAPI_PO_GETITEMS");
	
			sapPurOrd 	 = poFunction.getImportParameterList();
			
			//sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","A");
			sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","");
			sapPurOrd.setValue("CO_CODE","CFL");
	
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
				
				ezc.ezcommon.EzLog4j.log("sapPoListsapPoListsapPoList::::::::>>>"+sapPoList,"I");
	
				int poCount = sapPoList.getNumRows();
				ezc.ezcommon.EzLog4j.log("sapPoListsapPoListsapPoListCount::::::::>>>"+poCount,"I");
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
	
						poRelHdrXML.setFieldValue("PURGRP_NAME",sapPoList.getValue("PUR_GROUP_NAME"));
						poRelHdrXML.setFieldValue("START_DATE",sapPoList.getValue("VPER_START"));
						poRelHdrXML.setFieldValue("END_DATE",sapPoList.getValue("VPER_END"));
						poRelHdrXML.setFieldValue("ORDERDATE", sapPoList.getValue("DOC_DATE"));
						poRelHdrXML.setFieldValue("COMPCODE", sapPoList.getValue("CO_CODE"));
						poRelHdrXML.setFieldValue("PURCH_ORG", sapPoList.getValue("PURCH_ORG"));
	
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
			String vendorCodesStr = "";
			int indx = 0;	
			Vector poVendVect = new Vector();
			for(int pv=0;pv<poRelHdrXMLCount;pv++)
			{
				String poVendor = poRelHdrXML.getFieldValueString(pv,"VENDOR_NUMBER");
				
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
					ezc.ezparam.EzcParams addMainParams1 = new ezc.ezparam.EzcParams(false);
					ezc.vendortransactions.params.EzVendorParams  vendorEmailParams= new ezc.vendortransactions.params.EzVendorParams();
					ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
					keyParams.setKey("GET_USER_EMAIL");
					addMainParams1.setLocalStore("Y");
	
					vendorEmailParams.setUserId(vendorUserIdStr);
	
	
					addMainParams1.setObject(keyParams);	
					addMainParams1.setObject(vendorEmailParams);
					Session.prepareParams(addMainParams1);
	
					vendorEMailContactRetObj=(ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(addMainParams1);
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
					
					
					ezcContainer = new ezc.ezparam.EzcParams(false);
					iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	
					iParams.setSoldTo(defErpVendor);
					iParams.setSysKey(allSysKeys);
	
					ezcContainer.setLocalStore("Y");
					ezcContainer.setObject(iParams);
					Session.prepareParams(ezcContainer);
					ezc.ezcommon.EzLog4j.log("TO BE ACK POS CALL START>>","I");
					ReturnObjFromRetrieve allPOsInLDB= (ReturnObjFromRetrieve)AppManager1.ezGetPOAcknowledgement(ezcContainer);
	
					ezc.ezcommon.EzLog4j.log("GET_VENDOR_ALL_POS>>>>>>>>"+allPOsInLDB.getRowCount(),"I");	
	
					java.util.Vector allDocVect=new java.util.Vector();
					int allPOsInLDBCount = 0;
	
					if(allPOsInLDB!=null)
					{
						allPOsInLDBCount = allPOsInLDB.getRowCount();
						for(int i=0;i<allPOsInLDBCount;i++)	
							allDocVect.addElement(allPOsInLDB.getFieldValueString(i,"DOCNO"));
					}	
	
					ezc.ezcommon.EzLog4j.log("GET_VENDOR_ALL_POS_VECTOR>>>>>>>>"+allDocVect,"I");
					
					ezc.ezvendorapp.params.EzPOAcknowledgementTable addAckTab=new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
					ezc.ezvendorapp.params.EzPOAcknowledgementTableRow addAckTabRow=null;
					ezc.ezvendorapp.params.EzVendorTimeStampStructure ackTimeStamp=new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
	
					java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					java.util.Date dt111 = new java.util.Date();
					String createdOn= sdf.format(dt111);
	
					for(int i=0;i<poRelHdrXMLCount;i++)
					{
						String tempSapVend	=(poRelHdrXML.getFieldValueString(i,"VENDOR_NUMBER")).trim();
	
						if(!defErpVendor.equals(tempSapVend))
							continue;
	
						String myOrderDate = "";
						boolean addAckflg=false;
						boolean updateAckflg=false;
	
						boolean docContains	=false;
						String tempDocNo  	= poRelHdrXML.getFieldValueString(i,"ORDER");
	
						String tempRecStat	=(poRelHdrXML.getFieldValueString(i,"RECORDSTATUS"));
						String tempOrdType	=(poRelHdrXML.getFieldValueString(i,"ORDERTYPE"));
						String tempOrdGrp	=(poRelHdrXML.getFieldValueString(i,"PURGRP"));
	
						String plant 		= poRelHdrXML.getFieldValueString(i,"PLANT");
						String poDocType 	= poRelHdrXML.getFieldValueString(i,"ORDERTYPE");
						String purGrpName 	= poRelHdrXML.getFieldValueString(i,"PURGRP_NAME");
						String purOrg 		= poRelHdrXML.getFieldValueString(i,"PURCH_ORG");
						String poSysKey		= (String)orgSysKeysHT.get(purOrg);
						
						if(poSysKey==null || "null".equals(poSysKey) || "".equals(poSysKey))
							continue;
						
						
						String startDate = "";
						try{
							sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
							dt111 = (java.util.Date)poRelHdrXML.getFieldValue(i,"START_DATE");
							startDate= sdf.format(dt111);
						}catch(Exception e){
							 startDate = "1900-01-01 00:00:00";
						}
						
						String endDate = "";
						try{
							sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
							dt111 = (java.util.Date)poRelHdrXML.getFieldValue(i,"END_DATE");
							endDate= sdf.format(dt111);
						}catch(Exception e){
							 endDate = "1900-01-01 00:00:00";
						}
	
						if(tempOrdGrp!=null)
							tempOrdGrp=(tempOrdGrp.toUpperCase()).trim();
	
	
						sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						dt111 = (java.util.Date)poRelHdrXML.getFieldValue(i,"ORDERDATE");
						myOrderDate= sdf.format(dt111);
	
						if(tempRecStat==null||"null".equals(tempRecStat)) 
							tempRecStat="";
	
						docContains=allDocVect.contains(tempDocNo);   
						addAckTabRow =  new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();
	
						addAckTabRow.setSysKey(poSysKey);
						addAckTabRow.setSoldTo(tempSapVend);
						addAckTabRow.setDocNo(tempDocNo);
						addAckTabRow.setDocDate(myOrderDate);
	
						addAckTabRow.setCreatedOn(createdOn);
						addAckTabRow.setModifiedOn(createdOn);
						addAckTabRow.setCreatedBy("CFLADM");
						addAckTabRow.setModifiedOn(createdOn);
						addAckTabRow.setHeaderText("");
						addAckTabRow.setExt1(tempOrdGrp);
						addAckTabRow.setExt2("");
						addAckTabRow.setExt3(tempRecStat);
	
						addAckTabRow.setPoDocType("P");
						addAckTabRow.setPlant(plant);
						addAckTabRow.setPurGrpName(purGrpName);
						addAckTabRow.setStartDate(startDate);
						addAckTabRow.setEndDate(endDate);
	
						addAckTabRow.setPoAmended("N");
						addAckTabRow.setCompCode("CFL");
						addAckTabRow.setSmsStatus("N");
	
						addAckTabRow.setDocStatus("X");
						if(!docContains && !"RN".equals(poDocType))
							addAckflg=true;
	
						if(addAckflg)
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
						ReturnObjFromRetrieve retAdd= (ReturnObjFromRetrieve)AppManager1.ezAddPOAcknowledgement(ezcContainer);
						
						if(retAdd.isError())
							sendMail = false;
					}
					 
					
					/**************SMS and MAIL Sending Starts***********************/
					
					if(addAckTab.getRowCount()>0 && sendMail)
					{
						String sentStatus="N",smsPO="",poAmended="";
	
						EzPOAcknowledgementTableRow linesRow = null;
						for(int p=0;p<addAckTab.getRowCount();p++)
						{
							linesRow = (EzPOAcknowledgementTableRow)addAckTab.getRow(p);
							smsPO = linesRow.getDocNo();
	
						 	poAmended = "N";
							
							ezc.ezcommon.EzLog4j.log("::MOBILE NO::::"+mobileNo,"I");
							ezc.ezcommon.EzLog4j.log("SMS_PO>>>>>>>>"+smsPO,"I");  
	
							String smsMesg    = "Below PO is released from Coromandel "+smsPO+" Please login to the Vendor Portal and acknowledge the PO.";
	%>						
							<%@ include file="ezSendSMS.jsp"%>
	<%
							ezc.ezcommon.EzLog4j.log("::EMAIL::::"+vendEmail,"I");
							
							if("OK".equals(smsResponse))
								sentStatus = "Y";
								
							String toEMailIds = vendEmail;
							String ccEMailIds = "";							
	
							String msgSubject = "Coromandel : PO-"+smsPO+ " has released";
							String eMailData = "Dear Sir/Madam, <Br><Br>Below PO is released. <Br>"+smsPO+" <Br><Br>Please login to the vendor portal to acknowledge the PO.<Br><Br>Regards,<Br> Coromandel International Limited. <Br><Br><B>Portal Link : <a href="+request.getScheme()+"://"+request.getServerName()+"  target=_blank>"+request.getServerName()+"</a></B>";
	
							if("Y".equals(poAmended))
							{
								msgSubject = "Coromandel : PO-"+smsPO+ " is amended and sent for your re-acknowledgement";
								eMailData = "Below PO is amended and sent for your re-acknowledgement. <Br>"+smsPO+" <Br><Br>Please login to the vendor portal to re-acknowledgement the PO.<Br><Br>Regards,<Br> Coromandel International Limited. ";
							}
	
							ezc.ezcommon.EzLog4j.log("MAIL MSGSUBJECT>>>>>>>"+msgSubject,"I");
							ezc.ezcommon.EzLog4j.log("MAIL MSGTEXT>>>>>>>"+eMailData,"I");
	
	
							ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
	%>
							<%@ include file="ezSendExternalMail.jsp"%>
	<%
	
							if("Y".equals(sentStatus))
							{	
								int retVendTransCnt=0;
								ezc.ezparam.EzcParams smsMainParams = new ezc.ezparam.EzcParams(false);
								ezc.vendortransactions.params.EzVendorParams vendorParams = new ezc.vendortransactions.params.EzVendorParams();
								ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyDebitParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
								keyDebitParams.setKey("UPDATE_PO_SMS_STATUS");
								smsMainParams.setLocalStore("Y");
	
								vendorParams.setStatus("Y");
								vendorParams.setDocNo(smsPO);
	
								smsMainParams.setObject(keyDebitParams);
								smsMainParams.setObject(vendorParams);
								Session.prepareParams(smsMainParams);
	
								try{
									ezc.ezcommon.EzLog4j.log("::Before UPDATE_PO_SMS_STATUS::::","I");
									venTranManager.ezUpdateVendorTransactions(smsMainParams);
									ezc.ezcommon.EzLog4j.log("::After UPDATE_PO_SMS_STATUS::::","I");
	
								}catch(Exception e){ezc.ezcommon.EzLog4j.log("::UPDATE_PO_SMS_STATUS::::"+e,"I");}
	
							}
						}
					}
					/**************SMS and MAIL Sending End***********************/
				}
			}	
		}	
	
}
%>