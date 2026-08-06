<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="javax.sql.DataSource,javax.naming.InitialContext,javax.naming.Context" %> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ page import="java.util.*"%>
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="iViewVendRegDetails.jsp"%>
<%@ include file="iViewVendRegHeader.jsp"%> 
<%@ include file="ezCountryHT.jsp"%>   
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	String vendorCode = "";
	JCoFunction poFunction = null;  
	JCoFunction commitFunction = null; 
	JCoParameterList sapPurOrd = null;
		
	ReturnObjFromRetrieve outRet= new ReturnObjFromRetrieve(new String[]{"INVPARKNO","YEAR","","MSGV2","MSGV3","MSGV4","MSGTYP","MSGV1","MSGID","MSGSPRA","FLDNAME","DYNAME","MSGNR","MESSAGE"});		
	String logonSite = (String)session.getValue("SITE");
	JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
		
	try 
	{
		
		poFunction = EzSAPHandler.getJCoFunction(destination,"ZVEN_UPD_RFC");//Z_VENDOR_MASTER_UPDATE
		JCoParameterList sapImport = poFunction.getImportParameterList();
		JCoParameterList sapTabParam= poFunction.getTableParameterList();

		JCoStructure vendStruct=sapImport.getStructure("IM_VENDOR_DATA");


		vendStruct.setValue("ACTION","3"); 
		vendStruct.setValue("COMPANY_CODE",compCode);
		vendStruct.setValue("PURCHASE_ORGANISATION",purOrg);
		vendStruct.setValue("VENDOR_GROUP","Z003");
		//vendStruct.setValue("VENDOR","");		
		vendStruct.setValue("DEPARTMENT","CPD- FIN");//dept
		ezc.ezcommon.EzLog4j.log(":::::ACTION::::"+vendStruct.getValue("ACTION"),"I");
		ezc.ezcommon.EzLog4j.log(":::::COMPANY_CODE::::"+vendStruct.getValue("COMPANY_CODE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PURCHASE_ORGANISATION::::"+vendStruct.getValue("PURCHASE_ORGANISATION"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VENDOR_GROUP::::"+vendStruct.getValue("VENDOR_GROUP"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VENDOR::::"+vendStruct.getValue("VENDOR"),"I");
		ezc.ezcommon.EzLog4j.log(":::::DEPARTMENT::::"+vendStruct.getValue("DEPARTMENT"),"I");
		
		
		
		vendStruct.setValue("TITLE",title);
		vendStruct.setValue("VENDOR_NAME",vendName);
		vendStruct.setValue("VENDOR_NAME_1",VendorName2);
		ezc.ezcommon.EzLog4j.log(":::::TITLE::::"+vendStruct.getValue("TITLE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VENDOR_NAME::::"+vendStruct.getValue("VENDOR_NAME"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VENDOR_NAME_1::::"+vendStruct.getValue("VENDOR_NAME_1"),"I");
		
		
		vendStruct.setValue("C_O_NAME",careOf);
		vendStruct.setValue("ADDRESS_STREET",AddressLine1);
		vendStruct.setValue("ADDRESS_STREET_2",AddressLine2);
		vendStruct.setValue("ADDRESS_STREET_3",AddressLine3);
		
		ezc.ezcommon.EzLog4j.log(":::::C_O_NAME::::"+vendStruct.getValue("C_O_NAME"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ADDRESS_STREET::::"+vendStruct.getValue("ADDRESS_STREET"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ADDRESS_STREET_2::::"+vendStruct.getValue("ADDRESS_STREET_2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ADDRESS_STREET_3::::"+vendStruct.getValue("ADDRESS_STREET_3"),"I");
		
		vendStruct.setValue("ADDRESS_STREET_4",AddressLine4);
		vendStruct.setValue("ADDRESS_STREET_5",AddressLine5);
		vendStruct.setValue("DISTRICT",District);
		vendStruct.setValue("CITY",City);
		vendStruct.setValue("POSTALCODE",PostalCode);
		vendStruct.setValue("STATE_CODE",State);
		vendStruct.setValue("COUNTRY",country);
		
		ezc.ezcommon.EzLog4j.log(":::::ADDRESS_STREET_4::::"+vendStruct.getValue("ADDRESS_STREET_4"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ADDRESS_STREET_5::::"+vendStruct.getValue("ADDRESS_STREET_5"),"I");
		ezc.ezcommon.EzLog4j.log(":::::DISTRICT::::"+vendStruct.getValue("DISTRICT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::CITY::::"+vendStruct.getValue("CITY"),"I");
		ezc.ezcommon.EzLog4j.log(":::::POSTALCODE::::"+vendStruct.getValue("POSTALCODE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STATE_CODE::::"+vendStruct.getValue("STATE_CODE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::COUNTRY::::"+vendStruct.getValue("COUNTRY"),"I");
		
	
		
		
		
		vendStruct.setValue("TELEPHONE_1",PhoneNumber);
		vendStruct.setValue("TELEPHONE_2",AlternatePhoneNumber);
		vendStruct.setValue("MOBILE_1",MobileNumber);
		vendStruct.setValue("MOBILE_2",AlternateMobileNumber);
		vendStruct.setValue("FAX_NUMBER",fax);
		//vendStruct.setValue("EMAIL_ID1",EamilAddress1);
		//vendStruct.setValue("EMAIL_ID2",EamilAddress2);
		
		ezc.ezcommon.EzLog4j.log(":::::TELEPHONE_1::::"+vendStruct.getValue("TELEPHONE_1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TELEPHONE_2::::"+vendStruct.getValue("TELEPHONE_2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::MOBILE_1::::"+vendStruct.getValue("MOBILE_1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::MOBILE_2::::"+vendStruct.getValue("MOBILE_2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::FAX_NUMBER::::"+vendStruct.getValue("FAX_NUMBER"),"I");
		ezc.ezcommon.EzLog4j.log(":::::EMAIL_ID1::::"+vendStruct.getValue("EMAIL_ID1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::EMAIL_ID2::::"+vendStruct.getValue("EMAIL_ID2"),"I");
		
		
		vendStruct.setValue("TYPE_OF_INDUSTRY",Constitution);
		vendStruct.setValue("TYPE_OF_BUSINESS","OTHERS");
		ezc.ezcommon.EzLog4j.log(":::::TYPE_OF_INDUSTRY::::"+vendStruct.getValue("TYPE_OF_INDUSTRY"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TYPE_OF_BUSINESS::::"+vendStruct.getValue("TYPE_OF_BUSINESS"),"I");
		
		
		vendStruct.setValue("VENDOR_TYPE",Vendor_Type);
		vendStruct.setValue("PAYMENT_TERMS",Payment_Terms);
		vendStruct.setValue("VENDOR_INCO_TERMS",INCO_Terms);
		ezc.ezcommon.EzLog4j.log(":::::VENDOR_TYPE::::"+vendStruct.getValue("VENDOR_TYPE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PAYMENT_TERMS::::"+vendStruct.getValue("PAYMENT_TERMS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VENDOR_INCO_TERMS::::"+vendStruct.getValue("VENDOR_INCO_TERMS"),"I");
		
		
		vendStruct.setValue("INCO_TERMS_DESCRIPTION",incoHT.get(INCO_Terms));
		vendStruct.setValue("SCHEMA_GROUP_VENDOR","LC");
		vendStruct.setValue("RECON_ACCOUNT","160004");
		vendStruct.setValue("PURCHASE_ORDER_CURRENCY","INR");		
		vendStruct.setValue("NAME_OF_REPRESENTATIVE","NAA");
		vendStruct.setValue("PHONE_NO","9290305587");
		
		ezc.ezcommon.EzLog4j.log(":::::INCO_TERMS_DESCRIPTION::::"+vendStruct.getValue("INCO_TERMS_DESCRIPTION"),"I");
		ezc.ezcommon.EzLog4j.log(":::::SCHEMA_GROUP_VENDOR::::"+vendStruct.getValue("SCHEMA_GROUP_VENDOR"),"I");
		ezc.ezcommon.EzLog4j.log(":::::RECON_ACCOUNT::::"+vendStruct.getValue("RECON_ACCOUNT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PURCHASE_ORDER_CURRENCY::::"+vendStruct.getValue("PURCHASE_ORDER_CURRENCY"),"I");
		ezc.ezcommon.EzLog4j.log(":::::NAME_OF_REPRESENTATIVE::::"+vendStruct.getValue("NAME_OF_REPRESENTATIVE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PHONE_NO::::"+vendStruct.getValue("PHONE_NO"),"I");
		
		
		
		vendStruct.setValue("MSME",MSME_Type);
		vendStruct.setValue("MSME_CODE",MSME_Udyog_Aadhaar);
		vendStruct.setValue("CERTIFICATION_DATE",new Date());
		vendStruct.setValue("PAN",PAN_Number);
		vendStruct.setValue("GST_VENDOR_CLASSIFICATION",GSTVendorClassification);
		vendStruct.setValue("GST_REGISTRATION_NO",GST_Number);
		vendStruct.setValue("IATA_REGN",IATA_Regisration);
		vendStruct.setValue("OTHER_REGN",SSI_Regisration);
		
		ezc.ezcommon.EzLog4j.log(":::::MSME::::"+vendStruct.getValue("MSME"),"I");
		ezc.ezcommon.EzLog4j.log(":::::MSME_CODE::::"+vendStruct.getValue("MSME_CODE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::CERTIFICATION_DATE::::"+vendStruct.getValue("CERTIFICATION_DATE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PAN::::"+vendStruct.getValue("PAN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::GST_VENDOR_CLASSIFICATION::::"+vendStruct.getValue("GST_VENDOR_CLASSIFICATION"),"I");
		ezc.ezcommon.EzLog4j.log(":::::GST_REGISTRATION_NO::::"+vendStruct.getValue("GST_REGISTRATION_NO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::IATA_REGN::::"+vendStruct.getValue("IATA_REGN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::OTHER_REGN::::"+vendStruct.getValue("OTHER_REGN"),"I");
		
		
		
		vendStruct.setValue("BENEFICIARY_ACCOUNT_NO",Account_Number);
		vendStruct.setValue("RTGS_CODE",RTGSCode);
		vendStruct.setValue("BANK_NAME",BankName);
		vendStruct.setValue("BANK_ADDRESS_LINE1",BankAddressLine1);
		vendStruct.setValue("BANK_ADDRESS_LINE2",BankAddressLine2);
		vendStruct.setValue("BANK_ADDRESS_LINE3","");
		vendStruct.setValue("BANK_ADDRESS_LINE4","");
		vendStruct.setValue("BANK_CENTRE_LOCATION",BankLocation);
		
		
		ezc.ezcommon.EzLog4j.log(":::::BENEFICIARY_ACCOUNT_NO::::"+vendStruct.getValue("BENEFICIARY_ACCOUNT_NO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::RTGS_CODE::::"+vendStruct.getValue("RTGS_CODE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_NAME::::"+vendStruct.getValue("BANK_NAME"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_ADDRESS_LINE1::::"+vendStruct.getValue("BANK_ADDRESS_LINE1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_ADDRESS_LINE2::::"+vendStruct.getValue("BANK_ADDRESS_LINE2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_ADDRESS_LINE3::::"+vendStruct.getValue("BANK_ADDRESS_LINE3"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_ADDRESS_LINE4::::"+vendStruct.getValue("BANK_ADDRESS_LINE4"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANK_CENTRE_LOCATION::::"+vendStruct.getValue("BANK_CENTRE_LOCATION"),"I");
		
		try{
			//JCoContext.begin(destination);
			poFunction.execute(destination);
			//JCoContext.end(destination);
		}
		catch(Exception e){
		ezc.ezcommon.EzLog4j.log("ERROR WHILE CREATING VENDOR IN SAP POST "+e,"E");
		}	 

		JCoTable retOut = poFunction.getExportParameterList().getTable("RETURN");
	
	
		ezc.ezcommon.EzLog4j.log("poFunction:::::"+poFunction,"I");
		ezc.ezcommon.EzLog4j.log("poFunction.getExportParameterList():::::"+poFunction.getExportParameterList().getTable("EX_VENDORS_OF_GIVEN_PAN"),"I");
		ezc.ezcommon.EzLog4j.log("retOut:::::"+retOut,"I");
		
		
	
		int retCount = retOut.getNumRows();
		ezc.ezcommon.EzLog4j.log("retCount:::::"+retCount,"I");
		String vendCode="";
		if(retCount>0)
		{
			do
			{
				outRet.setFieldValue("MSGTYP", retOut.getValue("TYPE"));
				outRet.setFieldValue("MSGV1",retOut.getValue("MESSAGE_V1"));		
				outRet.setFieldValue("MSGID",retOut.getValue("ID"));
				outRet.setFieldValue("MSGNR",retOut.getValue("NUMBER"));
				outRet.setFieldValue("MESSAGE",retOut.getValue("MESSAGE"));
				outRet.addRow();
			}
			while(retOut.nextRow());
		}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("ERROR WHILE CREATING VENDOR IN SAP "+e,"E");
	}

	//out.println(""+outRet.toEzcString());
	int retObjCount=0;
	String dispStr = "";
	boolean isError = false;	
	if(outRet!=null){
		retObjCount=outRet.getRowCount();
	
	for(int i=0;i<retObjCount;i++)
	{
		if("E".equals(outRet.getFieldValueString(i,"MSGTYP")))
		{
			dispStr += outRet.getFieldValueString(i,"MESSAGE");
			isError = true;
		}
		else if("S".equals(outRet.getFieldValueString(i,"MSGTYP")))
		{
			dispStr += outRet.getFieldValueString(i,"MESSAGE");
			vendorCode = outRet.getFieldValueString(i,"MSGV1");
			isError = false;
			break;
		}
	}
			
	}
	if(isError)
	{
	
		dispStr = "Error While Creating Vendor : "+dispStr;
	}
	
	if(vendorCode != null && !"null".equals(vendorCode) && !"".equals(vendorCode))
	{
		mainParams = new ezc.ezparam.EzcParams(false); 				
		miscTable = new ezc.misctransactions.params.EzMiscTable();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("UPDATE EZC_CUSTOMER_FORM_HEADER SET ECFH_SAP_CODE='"+vendorCode+"',ECFH_STATUS='POSTED',ECFH_MODIFIED_BY='"+Session.getUserId()+"',ECFH_MODIFIED_ON=now()  WHERE ECFH_DOC_ID='"+docId+"'");
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams); 
		miscMgr.ezSaveMiscTransactions(mainParams);
		
	}

String display_header = "Confirmation";
%>
<html> 
<head>

<script>
	function checkList()
	{
		location.href="../Misc/ezWelcome_New.jsp";
	}
</script>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<center> 

	<div class="alert alert-<%=isError?"error":"success"%>" style="width:30%">
	<h4><i class="icon fa fa-check"></i> <%=isError?"Error":"Success"%></h4>
	<%=dispStr%>
	</div>
</center>
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	
</center>


<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
 

