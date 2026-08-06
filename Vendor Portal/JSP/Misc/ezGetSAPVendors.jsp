<%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>
<%@ include file="../Misc/ezGetCompCode.jsp"%> 

<%
	String site = "300";
	String compCode = "";
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>site11>>>>>>>>>>>>>>>:"+site,"D");
	
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
	EzcParams ezcContainer = new ezc.ezparam.EzcParams(false);	
	logs.setUserId("TEST_RRK");
	logs.setPassWd("portal");
	logs.setConnGroup(site);
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	ReturnObjFromRetrieve retSysKeys = null;
	String allSysKeys = "";
	int checkcount = 0;
	Hashtable orgSysKeysHT = new Hashtable();
	Hashtable<String,String> naCompHt1 = new Hashtable<String,String>();
	
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
	
	ReturnObjFromRetrieve sapvendHdrXML = new ReturnObjFromRetrieve(new String[]{"VENDOR_CODE","VENDOR_COMP_CODE","VENDOR_NAME","VENDOR_NAME2","VENDOR_EMAIL","VENDOR_MOBILE","VENDOR_COUNTRY","VENDOR_ADDRESS","VENDOR_CITY","VENDOR_POSTALCODE"});
	
	JCoFunction vendFunction = null;
	JCoParameterList sapPurOrd = null;
	java.util.Date toDayObj=new java.util.Date();
	java.util.Date toDate=new java.util.Date();
	toDayObj.setDate(toDayObj.getDate()-90);
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>getYear>>>>>>>>>>>>>>>:"+toDayObj.getYear(),"D");
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>getMonth in PO SYNC1>>>>>>>>>>>>>>>:"+toDayObj.getMonth(),"D");
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>getDate in PO SYNC>>>>>>>>>>>>>>>:"+toDayObj.getDate(),"D");
	java.sql.Date FromDate=new java.sql.Date(toDayObj.getYear(),toDayObj.getMonth(),toDayObj.getDate());
	
	FromDate=new java.sql.Date(124,0,01); // 01/10/2022 --> DD/MM/YYYY 
	//toDate=new java.sql.Date(123,4,26);
	
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>FROM_DATE>>>>>>>>>>>>>>>:"+FromDate,"I");
	ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>TO_DATE>>>>>>>>>>>>>>>:"+toDate,"I");
	
	/*String dateStr = "01/01/2024";
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
	LocalDate dateObj = LocalDate.parse(dateStr, formatter);*/
	
	try
	{
		JCoDestination destination = EzSAPHandler.getDestination("300~999");
		vendFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_VENDOR_SYNC");
		JCoParameterList sapTabParam= vendFunction.getTableParameterList();
		
		ezc.ezcommon.EzLog4j.log(hdrXMLCnt+">>>>>>>>>>>>hdrXML>>>>>>>>>>>>>>>:"+hdrXML.toEzcString(),"I");
		for(int i=0; i<hdrXMLCnt; i++)
		{
			compCode = hdrXML.getFieldValueString(i,"VALUE1");
			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>naCompHt1>>>>>>>>>>>>>>>:"+naCompHt1,"I");
			if(!naCompHt1.containsKey(compCode))
			{
				sapPurOrd 	 = vendFunction.getImportParameterList();
				sapPurOrd.setValue("FROM_DATE",FromDate);
				sapPurOrd.setValue("TO_DATE",toDate);
				sapPurOrd.setValue("COMP_CODE",compCode);	
				ezc.ezcommon.EzLog4j.log("FM:Z_EZ_VENDOR_SYNC>>>>>>>>>:","D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>FROM_DATE in PO SYNC22>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("FROM_DATE"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>TO_DATE in PO SYNC22>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("TO_DATE"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>COMP_CODE in PO SYNC22>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("COMP_CODE"),"D");

			try{
				vendFunction.execute(destination);
				ezc.ezcommon.EzLog4j.log("EXECUTED IN TRY>>>"+111,"I");		
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_VENDOR_SYNC_NA >>>"+e,"I");		
			}

			try {
				JCoTable sapvendList = vendFunction.getTableParameterList().getTable("T_VENDOR_DATA");

				int poCount = sapvendList.getNumRows();

				ezc.ezcommon.EzLog4j.log("poCount>>>"+poCount,"I");		
				if (poCount>0)
				{
					do{
						//Set All required field Values
						sapvendHdrXML.setFieldValue("VENDOR_CODE", sapvendList.getValue("VENDOR_CODE"));
						sapvendHdrXML.setFieldValue("VENDOR_COMP_CODE", sapvendList.getValue("COMP_CODE"));
						sapvendHdrXML.setFieldValue("VENDOR_NAME",sapvendList.getValue("NAME1"));
						sapvendHdrXML.setFieldValue("VENDOR_NAME2",sapvendList.getValue("NAME2"));
						sapvendHdrXML.setFieldValue("VENDOR_EMAIL", sapvendList.getValue("EMAIL"));
						sapvendHdrXML.setFieldValue("VENDOR_MOBILE", sapvendList.getValue("MOBILE"));
						sapvendHdrXML.setFieldValue("VENDOR_COUNTRY", sapvendList.getValue("COUNTRY"));
						sapvendHdrXML.setFieldValue("VENDOR_ADDRESS", sapvendList.getValue("ADDR1"));
						sapvendHdrXML.setFieldValue("VENDOR_CITY", sapvendList.getValue("CITY"));
						sapvendHdrXML.setFieldValue("VENDOR_POSTALCODE", sapvendList.getValue("POSTAL_CODE"));

						sapvendHdrXML.addRow();
					}
					while(sapvendList.nextRow());


				}	
				out.println(sapvendHdrXML.getRowCount()+"    sapvendHdrXML==="+sapvendHdrXML.toEzcString());

			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exception in Calling  Z_EZ_VENDOR_SYNC11>>>>>>>"+e,"I");
			}

		int sapVendCount = 0;
		sapVendCount = sapvendHdrXML.getRowCount();

		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();	
		ezc.ezcommon.EzLog4j.log("sapVendCount>>>"+sapVendCount,"I");	


		for(int j=0;j<sapVendCount;j++)
		{
			checkcount++;
			String sapVendCode	= sapvendHdrXML.getFieldValueString(j,"VENDOR_CODE");
			String sapVendCompCode	= sapvendHdrXML.getFieldValueString(j,"VENDOR_COMP_CODE");
			String vendName  	= sapvendHdrXML.getFieldValueString(j,"VENDOR_NAME");
			String vendName2  	= sapvendHdrXML.getFieldValueString(j,"VENDOR_NAME2");
			String vendEmail 	= sapvendHdrXML.getFieldValueString(j,"VENDOR_EMAIL");
			String vendMobile	= sapvendHdrXML.getFieldValueString(j,"VENDOR_MOBILE");
			String vendCountry	= sapvendHdrXML.getFieldValueString(j,"VENDOR_COUNTRY");
			String vendAddr		= sapvendHdrXML.getFieldValueString(j,"VENDOR_ADDRESS");
			String vendCity		= sapvendHdrXML.getFieldValueString(j,"VENDOR_CITY");
			String vendPostalCode	= sapvendHdrXML.getFieldValueString(j,"VENDOR_POSTALCODE");
			
			String sapVendQry = "";



			//sapVendQry = "INSERT INTO EZC_VEND_GEN_DATA(EVGD_VENDOR,EVGD_CREATED_ON,EVGD_DEL_FLAG,EVGD_BLOCK_FLAG,EVGD_INDR_KEY,EVGD_TITLE,EVGD_NAME,EVGD_NAME1,EVGD_NAME2,EVGD_NAME3,EVGD_NAME4,EVGD_ADDR1,EVGD_ADDR2,EVGD_ADDR3,EVGD_ADDR4,EVGD_CITY,EVGD_DISTRICT,EVGD_POSTAL_CODE,EVGD_REGION,EVGD_COUNTRY,EVGD_ACC_GROUP,EVGD_TELEPHONE1,EVGD_TELEPHONE2,EVGD_MOBILE,EVGD_FAX,EVGD_EMAIL,EVCD_GST_NO,EVCD_PAN_NO,EVCD_CURRENCY,EVGD_VEN_CLASS,EVGD_TAX_JUTIS,EVGD_CUSTOMER_NO,EVGD_EXT1,EVGD_EXT2,EVGD_EXT3) VALUES ('"+sapVendCode+"',NOW(),'','','','','"+vendName+"','','"+vendName2+"','','','','','','','','','','','"+vendCountry+"','','','','"+vendMobile+"','','"+vendEmail+"','','','','','','','','','"+sapVendCompCode+"')";
			sapVendQry = "INSERT INTO EZC_VEND_GEN_DATA(EVGD_VENDOR,EVGD_CREATED_ON,EVGD_DEL_FLAG,EVGD_BLOCK_FLAG,EVGD_INDR_KEY,EVGD_TITLE,EVGD_NAME,EVGD_NAME1,EVGD_NAME2,EVGD_NAME3,EVGD_NAME4,EVGD_ADDR1,EVGD_ADDR2,EVGD_ADDR3,EVGD_ADDR4,EVGD_CITY,EVGD_DISTRICT,EVGD_POSTAL_CODE,EVGD_REGION,EVGD_COUNTRY,EVGD_ACC_GROUP,EVGD_TELEPHONE1,EVGD_TELEPHONE2,EVGD_MOBILE,EVGD_FAX,EVGD_EMAIL,EVCD_GST_NO,EVCD_PAN_NO,EVCD_CURRENCY,EVGD_VEN_CLASS,EVGD_TAX_JUTIS,EVGD_CUSTOMER_NO,EVGD_EXT1,EVGD_EXT2,EVGD_EXT3) VALUES ('"+sapVendCode+"',NOW(),'','','','','"+vendName+"','','"+vendName2+"','','','"+vendAddr+"','','','','"+vendCity+"','','"+vendPostalCode+"','','"+vendCountry+"','','','','"+vendMobile+"','','"+vendEmail+"','','','','','','','','','"+sapVendCompCode+"')";
			miscTableRow.setQuery(sapVendQry);
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams); 

				ezc.ezcommon.EzLog4j.log(">>>SAP_VEND_CODE>>>>:"+sapVendCode,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_NAME>>>>>>:"+vendName,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_EMAIL>>>>:"+vendEmail,"D");
				ezc.ezcommon.EzLog4j.log(">>>SAP_COMP_CODE>>>>:"+sapVendCompCode,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_NAME2>>>>>>:"+vendName2,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_MOBILE>>>>:"+vendMobile,"D");
				ezc.ezcommon.EzLog4j.log(">>>SAP_VEND_ADDR>>>>:"+vendAddr,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_VEND_CITY>>>>>>:"+vendCity,"D");
				ezc.ezcommon.EzLog4j.log(">>>>SAP_VEND_POSTALCODE>>>>:"+vendPostalCode,"D");
				

			try
			{
				ezc.ezcommon.EzLog4j.log("INto Save=========","I");
				miscMgr.ezSaveMiscTransactions(mainParams);
				ezc.ezcommon.EzLog4j.log("INto Save11=========","I");

			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log(":::::Exception occured while inserting vendor into EZC_VEND_GEN_DATA::::::"+e,"E");
			} 
		}
		}
		naCompHt1.put(compCode,compCode);
	}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception in Calling  Z_EZ_VENDOR_SYNC22>>>>>>>"+e,"I");
	}

	ezc.ezcommon.EzLog4j.log("checkcount========="+checkcount,"I");
%>
	