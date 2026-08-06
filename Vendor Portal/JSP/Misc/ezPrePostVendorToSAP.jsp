<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>  
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %> 
<%//@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="iViewVendRegDetails.jsp"%>
<%//@ include file="iViewVendRegHeader.jsp"%> 
<%//@ include file="../Misc/ezPurOrgSchemaMap.jsp"%> 
<%//@ include file="ezCountryHT.jsp"%>   
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%

	mainParams = new ezc.ezparam.EzcParams(false); 				
	miscTable = new ezc.misctransactions.params.EzMiscTable();
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendHeader	  =	null;	 
	
	//***********************************GET HEADER DETAILS*****************************************************
	miscTableRow.setQuery("SELECT * from EZC_CUSTOMER_FORM_HEADER  WHERE ECFH_DOC_ID='"+docId+"'");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams); 
	try
	{
		retVendHeader=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
	}
	catch(Exception e)
	{
	}
	
	String compCode=retVendHeader.getFieldValueString(0,"ECFH_EXT1");
	String purOrg=retVendHeader.getFieldValueString(0,"ECFH_SALES_ORG");
	String venGrpVal = retVendHeader.getFieldValueString(0,"ECFH_VEN_GRP"); 
	
	String vendCode = "";
	JCoFunction poFunction = null;  
	JCoFunction commitFunction = null; 
	JCoParameterList sapPurOrd = null;

	destination = EzSAPHandler.getDestination(logonSite+"~999");
	String dispMessage = "";	
	try 
	{
		
		poFunction = EzSAPHandler.getJCoFunction(destination,"Z_RFC_VENDOR_VALIDATE");
		JCoParameterList sapImport = poFunction.getImportParameterList();
		JCoParameterList sapTabParam1= poFunction.getTableParameterList();


		JCoTable vendTable =sapTabParam1.getTable("IM_DATA");
		JCoTable retOut =sapTabParam1.getTable("EX_RETURN");

		vendTable.appendRow();
		vendTable.setValue("CHCK","H"); 
		vendTable.setValue("BUKRS",compCode);
		vendTable.setValue("EKORG",purOrg);
		vendTable.setValue("KTOKK",venGrpVal); 
		vendTable.setValue("NAME1",vendName);
		vendTable.setValue("LAND1",country);
		vendTable.setValue("SORTL",vendName);
		vendTable.setValue("STRAS","EN");
		vendTable.setValue("STREET2",AddressLine1);
		vendTable.setValue("STREET3",AddressLine2);
		vendTable.setValue("ORT01",District);
		vendTable.setValue("PSTLZ",PostalCode);
		vendTable.setValue("REGIO",State);
		vendTable.setValue("SPRAS","");//chk
		vendTable.setValue("TELF1",MobileNumber);
		vendTable.setValue("TELFX",fax);
		vendTable.setValue("LFURL",EamilAddress1);
		vendTable.setValue("J_1ICSTNO","");
		vendTable.setValue("J_1ILSTNO","");
		vendTable.setValue("J_1ISERN",MSME_Udyog_Aadhaar);//MSME TYPE // 1- minor 5- medium 9 - major
		vendTable.setValue("J_1IEXCD","");
		vendTable.setValue("J_1IEXRN","");
		vendTable.setValue("J_1IEXRG","");
		vendTable.setValue("J_1IEXDI","");
		vendTable.setValue("J_1IEXCO","");
		vendTable.setValue("J_1IVTYP","");
		vendTable.setValue("J_1IEXCIVE","");
		vendTable.setValue("J_1ISSIST",MSME_Type);//MSME
		vendTable.setValue("J_1IPANNO",PAN_Number);
		vendTable.setValue("J_1IPANREF",PAN_Number);
		vendTable.setValue("J_1IPANVALDT","");
		vendTable.setValue("STCD3",GST_Number);
		vendTable.setValue("VEN_CLASS",GSTVendorClassification);
		vendTable.setValue("AKONT",reconAccount);//chk
		vendTable.setValue("ZTERM_LFB1",Payment_Terms);
		vendTable.setValue("REPRF","X");
		vendTable.setValue("QLAND","IN");
		vendTable.setValue("WAERS",PurchaseOrderCurrency);
		vendTable.setValue("ZTERM_LFM1",Payment_Terms);
		vendTable.setValue("INCO1",INCO_Terms);
		vendTable.setValue("INCO2",INCO_Terms2);
		//vendTable.setValue("KALSK",schemagroup);//schemagroup
		vendTable.setValue("KALSK","IN");//schemagroup
		vendTable.setValue("WEBRE","X");
		vendTable.setValue("KZAUT","X");

		/*ezc.ezcommon.EzLog4j.log(":::::CHCK::::"+vendTable.getValue("CHCK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BUKRS::::"+vendTable.getValue("BUKRS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::EKORG::::"+vendTable.getValue("EKORG"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KTOKK::::"+vendTable.getValue("KTOKK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::NAME1::::"+vendTable.getValue("NAME1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::LAND1::::"+vendTable.getValue("LAND1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::SORTL::::"+vendTable.getValue("SORTL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STRAS::::"+vendTable.getValue("STRAS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STREET2::::"+vendTable.getValue("STREET2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STREET3::::"+vendTable.getValue("STREET3"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ORT01::::"+vendTable.getValue("ORT01"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PSTLZ::::"+vendTable.getValue("PSTLZ"),"I");
		ezc.ezcommon.EzLog4j.log(":::::REGIO::::"+vendTable.getValue("REGIO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::SPRAS::::"+vendTable.getValue("SPRAS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TELF1::::"+vendTable.getValue("TELF1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TELFX::::"+vendTable.getValue("TELFX"),"I");
		ezc.ezcommon.EzLog4j.log(":::::LFURL::::"+vendTable.getValue("LFURL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ICSTNO::::"+vendTable.getValue("J_1ICSTNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ILSTNO::::"+vendTable.getValue("J_1ILSTNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ISERN::::"+vendTable.getValue("J_1ISERN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCD::::"+vendTable.getValue("J_1IEXCD"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXRN::::"+vendTable.getValue("J_1IEXRN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXRG::::"+vendTable.getValue("J_1IEXRG"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXDI::::"+vendTable.getValue("J_1IEXDI"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCO::::"+vendTable.getValue("J_1IEXCO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IVTYP::::"+vendTable.getValue("J_1IVTYP"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCIVE::::"+vendTable.getValue("J_1IEXCIVE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ISSIST::::"+vendTable.getValue("J_1ISSIST"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IPANNO::::"+vendTable.getValue("J_1IPANNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IPANREF::::"+vendTable.getValue("J_1IPANREF"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IPANVALDT::::"+vendTable.getValue("J_1IPANVALDT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STCD3::::"+vendTable.getValue("STCD3"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VEN_CLASS::::"+vendTable.getValue("VEN_CLASS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::AKONT::::"+vendTable.getValue("AKONT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ZTERM_LFB1::::"+vendTable.getValue("ZTERM_LFB1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::REPRF::::"+vendTable.getValue("REPRF"),"I");
		ezc.ezcommon.EzLog4j.log(":::::QLAND::::"+vendTable.getValue("QLAND"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WAERS::::"+vendTable.getValue("WAERS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ZTERM_LFM1::::"+vendTable.getValue("ZTERM_LFM1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::INCO1::::"+vendTable.getValue("INCO1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::INCO2::::"+vendTable.getValue("INCO2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KALSK::::"+vendTable.getValue("KALSK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WEBRE::::"+vendTable.getValue("WEBRE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KZAUT::::"+vendTable.getValue("KZAUT"),"I"); */
		
		
		vendTable.appendRow();
		vendTable.setValue("BANKS",country);
		vendTable.setValue("BANKL",RTGSCode);
		vendTable.setValue("BANKN",Account_Number);
		vendTable.setValue("KOINH",vendName); //Accnt_Person
		if(whTaxCode != null && !"null".equals(whTaxCode) && !"".equals(whTaxCode) && whTaxType != null && !"null".equals(whTaxType) && !"".equals(whTaxType))
		{
			vendTable.setValue("WITHT",whTaxCode);//chk
			vendTable.setValue("WT_WITHCD",whTaxType);//chk 
			vendTable.setValue("WT_SUBJCT","X");//chk
			vendTable.setValue("QSREC",recType);//chk
		}
		
		/*ezc.ezcommon.EzLog4j.log(":::::BANKS::::"+vendTable.getValue("BANKS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANKL::::"+vendTable.getValue("BANKL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANKN::::"+vendTable.getValue("BANKN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KOINH::::"+vendTable.getValue("KOINH"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WITHT::::"+vendTable.getValue("WITHT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WT_WITHCD::::"+vendTable.getValue("WT_WITHCD"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WT_SUBJCT::::"+vendTable.getValue("WT_SUBJCT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::QSREC::::"+vendTable.getValue("QSREC"),"I");*/
		
		try{
			poFunction.execute(destination);
		}
		catch(Exception e){
		ezc.ezcommon.EzLog4j.log("ERROR WHILE CREATING VENDOR IN SAP POST "+e,"E");
		}	 
		
		//ezc.ezcommon.EzLog4j.log("EX_RETURN22222:::::"+retOut,"I");
		int retCount = retOut.getNumRows();
		//ezc.ezcommon.EzLog4j.log("retCount:::::"+retCount,"I");
		if(retCount>0)
		{
			int i=0;
			do
			{
				String  msgStr       =  retOut.getValue(3)+"";
				i=i+1;
				if(i==1)dispMessage="<div class='alert alert-warning'>";
				dispMessage=dispMessage+"<br>"+i+")"+msgStr;
			}
			while(retOut.nextRow());
		}		
		
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("ERROR WHILE VALIDATIONG VENDOR IN SAP "+e,"E");
	}
	ezc.ezcommon.EzLog4j.log("dispMessage>>>:::::"+dispMessage,"I");
	String rtrnStmt = "";
	if(!"".equals(dispMessage)&& dispMessage!= null && !"null".equals(dispMessage))
		rtrnStmt = "Q";
	else
		rtrnStmt = "A";	
	
	out.println("VND#"+rtrnStmt+"#"+dispMessage);
	
%>
 

