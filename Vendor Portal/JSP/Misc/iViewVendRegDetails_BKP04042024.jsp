<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	String chksel="";
	String chkOthSel="";
	String cntVal=""; 
	String chkYes="";
	String chkNo="";
	String chkSupYes="";
	String chkSupNo="";	
	String chkSiteYes="";
	String chkSiteNo="";
	String chkAckYes="";
	String chkAckNo="";
	String chkTansNo="";
	String chkTansYes="";
	
	String docId=request.getParameter("docId");
	if(docId == null || "null".equals(docId) || "".equals(docId))
		docId=Session.getUserId();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems	  =	null;	 
	
	//***********************************GET ITEM DETAILS*****************************************************
	miscTableRow.setQuery("select * from EZC_CUSTOMER_FORM_DETAILS  WHERE ECFD_DOC_ID='"+docId+"'");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams); 
	try
	{
		retVendItems=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		//out.print(retVendItems.toEzcString());
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retVendItemsCnt = 0;
	if(retVendItems != null)
		retVendItemsCnt = retVendItems.getRowCount();
			
			int rowIndex=0;
			String title="";
			String vendName="";
			String serachTerm="";
			String careOf="";
			String AddressLine1="";
			String District="";
			String PhoneNumber ="";
			String AddressLine2="";
			String PostalCode="";
			String AlternatePhoneNumber="";
			String AddressLine3="";
			String country="";
			String MobileNumber="";
			String AddressLine4="";
			String City="";
			String AlternateMobileNumber ="";
			String AddressLine5="";
			String State ="";
			String fax="";
			String EamilAddress1 ="";
			String EamilAddress2="";
			String webSite="";
			String conMethod="";
			String othConMethod="";
			java.util.Vector  conMethodVec = new java.util.Vector();
			java.util.Vector  supTypeVec   = new java.util.Vector();
			java.util.Vector  vendorTypeVec   = new java.util.Vector();

			//*******************************commercial_Information_details*******************	
			String typeOfOrg="";
			String othCompType="";
			String supType="";
			String othSupType="";
			String vendorType="";
			String Payment_Terms="";
			String PurchaseOrderCurrency="";
			String INCO_Terms ="";
			String INCO_Terms2 ="";
			String paymntTermsText="";
			String PAN_Name="";
			String PAN_Attach="";
			String PAN_Number="";
			String GSTVendorClassification ="";
			String gstType ="";			
			String BUS_Type="";
			String TAN_Number="";
			String GST_Number="";
			String CIN_Number="";
			String IATA_Regisration="";
			String SSI_Regisration="";
			
			//*******************************MSME INFO*******************							
			String MSME_Type ="";
			String busStatus ="";
			String otherBusInfo ="";
			String MSMECertification_Date="";
			String MSME_Udyog_Aadhaar="";
			String e_Invoice ="";
			String vend_Jgl ="";
			String vend_Unit ="";
			String vend_Trans ="";
			String vend_Dtls ="";
			String vend_Site ="";
			String sitePerson ="";
			String siteViDt ="";
			
//*******************************PRODUCTS AND PLANT INFO*******************										
			String Products_Services ="";
			
//*******************************FINANCIAL INFO*******************										
			
			String Annual_TurnoveR="";
			String dealt_with_HSIL ="";
			String itrAttach="";
			String moaAttach="";
			String fsAttach="";
			String saAttach="";
			String kcAttach="";
			String othAttach="";
			String w9Attach="";
			String w8Attach="";
			String INTAttach="";			
			
			
//*******************************BANK INFO*******************
			String Pmnt_Mode="";
			String Accnt_Person ="";
			String Accnt_Email ="";
			String Accnt_Mobile ="";
			String Account_Type ="";
			String RTGSCode ="";
			String Account_Number ="";
			String BankName ="";
			String Branch  ="";
			String BankSwift ="";
			String chequeNo ="";
			String recType ="";
			String reconAccount ="";
			String whTaxType ="";
			String whTaxCode ="";
			String docAck="";
			/*
			String Bank ="";
			
			String BankAddressLine1 ="";
			String BankAddressLine2 ="";
			String BankLocation  ="";*/
			
			
			
	String disDate=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
if(retVendItemsCnt > 0)
{
	rowIndex=retVendItems.getRowId("ECFD_FIELD","title");
	title=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	ezc.ezcommon.EzLog4j.log("fieldName>>>>>title>>>"+title,"I");	
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","vendName");
	vendName=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	ezc.ezcommon.EzLog4j.log("fieldName>>>>>vendName>>>"+vendName,"I");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","searchTerm");
	 serachTerm=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","careOf_Name");
	 careOf=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","addrsLine1");
	 AddressLine1=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","districtName");
	 District=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","phoneNum");
	 PhoneNumber=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","addrsLine2");
	 AddressLine2=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","postalCode");
	 PostalCode=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","altPhoneNum");
	 AlternatePhoneNumber=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	rowIndex=retVendItems.getRowId("ECFD_FIELD","addrsLine3");
	 AddressLine3=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","country");
	 country=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","mobNum");
	 MobileNumber=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","addrsLine4");
	 AddressLine4=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","city");
	 City=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","altMobNum");
	 AlternateMobileNumber=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","addrsLine5");
	 AddressLine5=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","state");
	 State=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","fax");
	 fax=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","email_1");
	 EamilAddress1=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	 rowIndex=retVendItems.getRowId("ECFD_FIELD","email_2");
	 EamilAddress2=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","website");
	 webSite=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","conMethod");
	 conMethod=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 ezc.ezcommon.EzLog4j.log("conMethodCHK>>>>>"+conMethod,"I");
	 if(!"".equals(conMethod) && conMethod != null && !"null".equals(conMethod))
	 {
		String tempConArr[] = conMethod.split("#");		
		for(int gp=0;gp<tempConArr.length;gp++)
			conMethodVec.addElement(tempConArr[gp]);
	 }	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","othConMethod");
	 othConMethod=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	  
	//***************COMMERCIAL INFO*********************

	 rowIndex=retVendItems.getRowId("ECFD_FIELD","othCompType");
	 othCompType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","typeOfOrg");
	 typeOfOrg=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","supType");
	 supType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 if(!"".equals(supType) && supType!= null && !"null".equals(supType))
	 {
		String tempSupArr[] = supType.split("#");		
		for(int gp=0;gp<tempSupArr.length;gp++)
			supTypeVec.addElement(tempSupArr[gp]);
	 }
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","othSupType");
	 othSupType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vendorType");
	 vendorType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 if(!"".equals(vendorType)&& vendorType!= null && !"null".equals(vendorType))
	 {
		String tempVendTypeArr[] = vendorType.split("#");		
		for(int gp=0;gp<tempVendTypeArr.length;gp++)
			vendorTypeVec.addElement(tempVendTypeArr[gp]);
	 }	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","paymntTerms");
	 Payment_Terms=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","purOrdCurr");
	 PurchaseOrderCurrency=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","INCO_Terms");
	 INCO_Terms=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	 rowIndex=retVendItems.getRowId("ECFD_FIELD","INCO_Terms2");
	 INCO_Terms2=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","paymntTermsText");
	 paymntTermsText=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","PAN_Name");
	 PAN_Name=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","PAN_Attach");
	 PAN_Attach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","PAN_Number");
	 PAN_Number=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","gstVendorClas");
	 GSTVendorClassification=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","gstType");
	 gstType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","BUS_Type");
	 BUS_Type=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	 rowIndex=retVendItems.getRowId("ECFD_FIELD","TAN_Number");
	 TAN_Number=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","gst_Number");
	 GST_Number=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","cin_Number");
	 CIN_Number=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","iata_Number");
	 IATA_Regisration=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","ssi_Number");
	 SSI_Regisration=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	//********************MSME DETAILS**********************************************************
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","msme_Type");
	 MSME_Type=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	 rowIndex=retVendItems.getRowId("ECFD_FIELD","msme_CertfctnDate");
	 MSMECertification_Date=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","msme_Udyog_AdhrNo");
	 MSME_Udyog_Aadhaar=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","bus_Status");
	 busStatus=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 ezc.ezcommon.EzLog4j.log("busStatus>>>>>>bus>>"+busStatus,"I");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","e_Invoice");
	 e_Invoice=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vend_Jgl");
	 vend_Jgl=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vend_Unit");
	 ezc.ezcommon.EzLog4j.log(":::vendUnit_ID::::::::"+rowIndex,"D");
	 vend_Unit=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 ezc.ezcommon.EzLog4j.log(":::vendUnit::::::::"+vend_Unit,"D");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vend_Trans");
	 vend_Trans=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vend_Dtls");
	 vend_Dtls=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","vend_Site");
	 vend_Site=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","otherBusInfo");
	 ezc.ezcommon.EzLog4j.log(":::otherBusInfo::::::::"+otherBusInfo,"D");

	 otherBusInfo=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","sitePerson");
	 sitePerson=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","siteViDt");
	 siteViDt=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	 

	//*******************	PLANT PRODUCT DETAILS************************************************** 
	 rowIndex=retVendItems.getRowId("ECFD_FIELD","products_services");
	 Products_Services=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	//********************* FINANCIAL DETAILS**********************************************************
	rowIndex=retVendItems.getRowId("ECFD_FIELD","annual_TurnOver");
	Annual_TurnoveR=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","delt_With_HSIL");
	dealt_with_HSIL=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","itrAttach");
	itrAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","moaAttach");
	moaAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","fsAttach");
	fsAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","saAttach");
	saAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","kcAttach");
	kcAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","othAttach");
	othAttach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","w9Attach");
	w9Attach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	rowIndex=retVendItems.getRowId("ECFD_FIELD","w8Attach");
	w8Attach=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	
	//*********************BANK DETAILS**************************************************************
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","pmntMode");
	Pmnt_Mode=checkNull(retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE"));

	rowIndex=retVendItems.getRowId("ECFD_FIELD","accnt_Per");
	Accnt_Person=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","accnt_Email");
	Accnt_Email=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","accnt_Mobile");
	Accnt_Mobile=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");		
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","rtgs_Code");
	RTGSCode=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bankName");
	BankName=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank_Branch");
	Branch=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	

	rowIndex=retVendItems.getRowId("ECFD_FIELD","accnt_Number");
	Account_Number=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");

	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank_Swift");
	BankSwift=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","chequeNo");
	chequeNo=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","whTaxType");
	whTaxType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","whTaxCode");
	whTaxCode=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","recType");
	recType=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");		
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","reconAccount");
	reconAccount=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");	
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","docAck");
	docAck=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");		

	/*
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","accnt_Type");
	Account_Type=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank");
	Bank=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank_Address_Line1");
	BankAddressLine1=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank_Address_Line2");
	BankAddressLine2=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");
	
	rowIndex=retVendItems.getRowId("ECFD_FIELD","bank_Location");
	BankLocation=retVendItems.getFieldValueString(rowIndex,"ECFD_VALUE");*/


}
		
	
	//***********************************GET CONTACT ITEM DETAILS*****************************************************
	ezc.ezparam.EzcParams mainParams_1 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable_1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow_1 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems_1	  =	null;
	
	miscTableRow_1.setQuery("select * from EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='CONTCT_DET1'");
	miscTable_1.appendRow(miscTableRow_1);
	mainParams_1.setLocalStore("Y");
	mainParams_1.setObject(miscTable_1);
	Session.prepareParams(mainParams_1); 
	try
	{
		retVendItems_1=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams_1);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	
	int retVendItemsCnt1 = 0;
	if(retVendItems_1 != null)
	retVendItemsCnt1 = retVendItems_1.getRowCount();
	
	HashMap<String,String> contactMap = new HashMap<String,String>();
	for(int s=0;s<retVendItemsCnt1;s++)
	{
	 contactMap.put(retVendItems_1.getFieldValueString(s,"ECFD_FIELD"),retVendItems_1.getFieldValueString(s,"ECFD_VALUE"));
	} 
	ezc.ezcommon.EzLog4j.log("****==mapPrasad=====**"+contactMap,"I");
	
	//***********************************GET TOP 5 CUSTOMER ITEM DETAILS*****************************************************
	ezc.ezparam.EzcParams mainParams_2 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable_2 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow_2 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems_2	  =	null;	 
	
	miscTableRow_2.setQuery("select * from EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='CONTCT_DET2'");
	miscTable_2.appendRow(miscTableRow_2);
	mainParams_2.setLocalStore("Y");
	mainParams_2.setObject(miscTable_2);
	Session.prepareParams(mainParams_2); 
	try
	{
		retVendItems_2=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams_2);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}								    
	int retVendItemsCnt2 = 0;
	if(retVendItems_2 != null)
	retVendItemsCnt2 = retVendItems_2.getRowCount();
	HashMap<String,String> topCustMap = new HashMap<String,String>();
	for(int s1=0;s1<retVendItemsCnt2;s1++)
	{
	   topCustMap.put(retVendItems_2.getFieldValueString(s1,"ECFD_FIELD"),retVendItems_2.getFieldValueString(s1,"ECFD_VALUE"));
	} 
	// out.println(topCustMap);
	//***********************************GET PRODUCT AND PLANT ITEM DETAILS*****************************************************
	ezc.ezparam.EzcParams mainParams_3 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_3 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable_3 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow_3 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems_3	  =	null;
	
	miscTableRow_3.setQuery("select * from EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='PRDCT_PLNT_DET1'");
	miscTable_3.appendRow(miscTableRow_3);
	mainParams_3.setLocalStore("Y");
	mainParams_3.setObject(miscTable_3);
	Session.prepareParams(mainParams_3); 
	try
	{
		retVendItems_3=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams_3);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retVendItemsCnt3 = 0;
	if(retVendItems_3 != null)
	retVendItemsCnt3 = retVendItems_3.getRowCount(); 
	HashMap<String,String> prdctPlantMap = new HashMap<String,String>();
	for(int s2=0;s2<retVendItemsCnt3;s2++)
	{
	   prdctPlantMap.put(retVendItems_3.getFieldValueString(s2,"ECFD_FIELD"),retVendItems_3.getFieldValueString(s2,"ECFD_VALUE"));
	} 
	
	//***********************************FINANCIAL ITEM DETAILS*****************************************************
	ezc.ezparam.EzcParams mainParams_4 = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_4 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable_4 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow_4 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendItems_4	  =	null;
	
	miscTableRow_4.setQuery("select * from EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='FINAC_DET1'");
	miscTable_4.appendRow(miscTableRow_4);
	mainParams_4.setLocalStore("Y");
	mainParams_4.setObject(miscTable_4);
	Session.prepareParams(mainParams_4); 
	try
	{
		retVendItems_4=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams_4);
		
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retVendItemsCnt4 = 0;
	if(retVendItems_4 != null)
	retVendItemsCnt4 = retVendItems_4.getRowCount();
	
	 HashMap<String,String> fincMap = new HashMap<String,String>();
	 for(int s3=0;s3<retVendItemsCnt4;s3++)
	 {
	    fincMap.put(retVendItems_4.getFieldValueString(s3,"ECFD_FIELD"),retVendItems_4.getFieldValueString(s3,"ECFD_VALUE"));
	 }
	 
	 String showStr = "";
	 String logonSite = (String)session.getValue("SITE");
	 
	 JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
	 JCoFunction function =null;
	 
	 if(!"".equals(RTGSCode)&& RTGSCode!= null && !"null".equals(RTGSCode) && (!isNABuyer))
	 {
	 
	 	//VERIFY IFSC CODE
	 	function = EzSAPHandler.getJCoFunction(destination,"Z_RFC_VENDOR_CREATE_IFSC_SHLP");

		JCoParameterList sapPreProc = function.getImportParameterList();
		sapPreProc.setValue("I_IFSC",RTGSCode);

		JCoParameterList sapTabParam= function.getTableParameterList();
		JCoTable poItemTable = sapTabParam.getTable("ET_IFSC");

		poItemTable.appendRow();
		
		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in Z_RFC_VENDOR_CREATE_IFSC_SHLP"+qe,"I");
		}
		
		int ifscCnt =0;
		JCoTable sapIfsc = function.getTableParameterList().getTable("ET_IFSC"); 
		ifscCnt 	= 	sapIfsc.getNumRows();
		ezc.ezcommon.EzLog4j.log("ifscCnt:::::::::::::::"+ifscCnt,"I");
		if(ifscCnt>0)
			showStr = "N";
		else
			showStr = "Y";
	}
	
	//WITHHOLDING TAX
	
	int wtCount =0;
	
	function = EzSAPHandler.getJCoFunction(destination,"Z_RFC_VENDOR_WTH_TX_TYPE");
	
	JCoParameterList sapPreProc = function.getImportParameterList();
	sapPreProc.setValue("I_LAND1","IN");
	
	JCoParameterList sapTabParam= function.getTableParameterList();
	JCoTable poItemTable = sapTabParam.getTable("ET_WITHT");
	poItemTable.appendRow();
	
	try
	{
		function.execute(destination);
	}catch(Exception qe){
		ezc.ezcommon.EzLog4j.log("Exception in Z_RFC_VENDOR_WTH_TX_TYPE"+qe,"I");
	}	
	
	JCoTable sapWt= function.getTableParameterList().getTable("ET_WITHT"); 
	wtCount = sapWt.getNumRows();
	ezc.ezcommon.EzLog4j.log("wtCount:::::::::::::::"+wtCount,"I");	

	ArrayList withCDList = new ArrayList();
	try 
	{		
		do
		{
			String withCD = (String)sapWt.getValue("WT_WITHCD");
			ezc.ezcommon.EzLog4j.log("withCD:::::::::::::::"+withCD,"I");	
			if(!withCDList.contains(withCD))
				withCDList.add(withCD);
		}while(sapWt.nextRow());
	}
	catch (Exception e) {}
	ezc.ezcommon.EzLog4j.log("withCDList:::::::::::::::"+withCDList.size(),"I");
%>
		
	