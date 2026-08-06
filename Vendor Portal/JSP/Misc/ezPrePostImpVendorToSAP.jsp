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
	ezc.ezcommon.EzLog4j.log("Entering ezPrePostImpVendorToSAP","E");

	String schemaGrp="IM";
	String withHoldTaxCountry="";
	
	String vendType="IM";
	String compCode="5000";
	
	
	
	
	if("4500".equals(compCode)&& "IN".equals(vendType))
		schemaGrp="I1";
	if("4500".equals(compCode)&& "IM".equals(vendType))
		schemaGrp="I2";
	if("9000".equals(compCode)&& "IN".equals(vendType))
		schemaGrp="J1";	 
		
	if("7300".equals(compCode)|| "4101".equals(compCode)|| "9000".equals(compCode))
		withHoldTaxCountry="US";
	if("7501".equals(compCode)|| "4500".equals(compCode))
		withHoldTaxCountry="CA";	

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
	
	// String compCode=retVendHeader.getFieldValueString(0,"ECFH_EXT1");
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
		vendTable.setValue("J_1ISERN","");
		vendTable.setValue("J_1IEXCD","");
		vendTable.setValue("J_1IEXRN","");
		vendTable.setValue("J_1IEXRG","");
		vendTable.setValue("J_1IEXDI","");
		vendTable.setValue("J_1IEXCO","");
		vendTable.setValue("J_1IVTYP","");
		vendTable.setValue("J_1IEXCIVE","");
		vendTable.setValue("J_1ISSIST","");//MSME
		vendTable.setValue("J_1IPANNO","");
		vendTable.setValue("J_1IPANREF","");
		vendTable.setValue("J_1IPANVALDT","");
		vendTable.setValue("STCD3","");
		vendTable.setValue("VEN_CLASS","");
		vendTable.setValue("AKONT",reconAccount);//chk
		vendTable.setValue("QLAND",withHoldTaxCountry);
		vendTable.setValue("ZTERM_LFB1",Payment_Terms);
		vendTable.setValue("REPRF","X");
		
		vendTable.setValue("WAERS",PurchaseOrderCurrency);
		vendTable.setValue("ZTERM_LFM1",Payment_Terms);
		vendTable.setValue("INCO1",INCO_Terms);
		vendTable.setValue("INCO2",INCO_Terms2);
		vendTable.setValue("KALSK",schemaGrp);//schemagroup
		vendTable.setValue("WEBRE","X");
		vendTable.setValue("KZAUT","X");

		vendTable.appendRow();
		
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
