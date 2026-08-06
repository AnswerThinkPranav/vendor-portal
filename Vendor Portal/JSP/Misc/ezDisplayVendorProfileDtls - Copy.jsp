<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>		
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>

<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>

<%
	String docId 	= request.getParameter("selDocId");
	String status 	= request.getParameter("status");
	String vendor 	= request.getParameter("selVendor");
	
	ReturnObjFromRetrieve generalDataRetObj =null;
	ReturnObjFromRetrieve purchOrgRetObj =null;
	ReturnObjFromRetrieve companyDataRetObj =null;
	ReturnObjFromRetrieve exciseDataRetObj =null;
	ReturnObjFromRetrieve bankDtlsRetObj =null;
	ReturnObjFromRetrieve partnersRetObj =null;
	ReturnObjFromRetrieve emailRetObj =null;
	ReturnObjFromRetrieve telphoneRetObj =null;
	ReturnObjFromRetrieve faxRetObj =null;
	ReturnObjFromRetrieve contactPersonRetObj =null;
	ReturnObjFromRetrieve bankMasterRetObj =null;
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
	
	keyParams.setKey("GetGeneralData");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetPurOrgData");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetCompanyData");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetExciseData");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetBankDetails");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorPartners");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorEmail");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorTelephone");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorFax");
	keyTableParams.appendRow(keyParams);
	 /*keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorContactPerson");
	keyTableParams.appendRow(keyParams);*/
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetBankMaster");
	keyTableParams.appendRow(keyParams);
	
	mainParams.setLocalStore("Y");
	//out.println("docId:::"+docId+"::vendor::"+vendor);
	generalParams.setDocId(docId);
	generalParams.setVendor(vendor);
	generalParams.setStatus("OPEN");
	
	mainParams.setObject(keyTableParams);	
	
	mainParams.setObject(generalParams);
	Session.prepareParams(mainParams);
	
	
	try{
		
	ReturnObjFromRetrieve finalRetObj = (ReturnObjFromRetrieve)vendorprofile.ezGetDetails(mainParams);

		generalDataRetObj 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetGeneralData");
		//out.println("generalDataRetObj"+generalDataRetObj.toEzcString());
		purchOrgRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetPurOrgData");
		//out.println("purchOrgRetObj"+purchOrgRetObj.toEzcString());
		companyDataRetObj 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetCompanyData");
		//out.println("companyDataRetObj"+companyDataRetObj.toEzcString());
		exciseDataRetObj 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetExciseData");
		//out.println("exciseDataRetObj"+exciseDataRetObj.toEzcString());
		bankDtlsRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetBankDetails");
		//out.println("bankDtlsRetObj"+bankDtlsRetObj.toEzcString());
		partnersRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetVendorPartners");
		//out.println("partnersRetObj"+partnersRetObj.toEzcString());
		emailRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetVendorEmail");
		//out.println("emailRetObj"+emailRetObj.toEzcString());
		telphoneRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetVendorTelephone");
		//out.println("telphoneRetObj"+telphoneRetObj.toEzcString());
		faxRetObj 		= (ReturnObjFromRetrieve)finalRetObj.getObject("GetVendorFax");
		//out.println("faxRetObj"+faxRetObj.toEzcString());
		contactPersonRetObj 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetVendorContactPerson");
		 //out.println("contactPersonRetObj"+contactPersonRetObj.toEzcString());
		bankMasterRetObj 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetBankMaster");
		//out.println("bankMasterRetObj"+bankMasterRetObj.toEzcString());
	}catch(Exception e){out.println(e);}
	
	String venComments="";
	ReturnObjFromRetrieve retVenComm	=  null;
	int retVenCommCnt = 0;

	mainParams				= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams		= new EziMiscParams(); 

	miscParams.setQuery("SELECT * from EZC_DOCUMENT_COMMENTS where EDC_DOC_ID='"+docId+"' And EDC_USER_ID='"+vendor+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams); 
	try
	{		
		retVenComm = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Vendor Comments:::"+e,"E");
	}
	if(retVenComm!=null)
		venComments = retVenComm.getFieldValueString(0,"EDC_COMMENTS");
	//out.println("venComments::"+venComments);
	
%>
<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import ="java.util.*" %>

<%
String LIFNR       =	"";
String NAME1       =	"";
String NAME2       =	"";
String NAME3       =	"";
String NAME4       =	"";
String DLGRP       =	"";
String ANRED       =	"";
String ORT01       =	"";
String ORT02       =	"";
String REGIO       =	"";
String PSTLZ       =	"";
String STRAS       =	"";
String LAND1       =	"";
String BANKN       =	"";
String BANKS       = 	"";
String BANKL       = 	"";
String BANKA       = 	"";
String PROVZ       = 	"";
String BRNCH       = 	"";
String SMTP_ADDR   =    "";  
String TELF1	   =	"";  

String ZTERM	   =	""; 
String ZTERMComp   =    "";
String ZWELS       =    "";
String BUKRS       =    "";
Date	CERDT	   =    new Date();
String	HBKID	   =    "";
String	KALSK	   =    "";
String  WAERS      = 	"";
String  LEBRE      = 	"";
String EKORG       =    "";
String TELFX       = 	"";
String TELF2       = 	"";
String NAMEV       = 	"";
String NAME1ConInfo       =    "";
String STCEG       = 	"";
String MINDK       = 	"";

String J_1ISERN    	= 	"";
String J_1IEXRG  	= 	"";			   
String J_1ICSTNO 	=	"";
String J_1IEXCD 	=	"";
String J_1IEXDI		=	"";
String J_1IPANNO	=	"";
String J_1IEXRN 	=	"";
String J_1IEXCO 	=	"";

 

%>
<%
	String defSoldTo    = "0000000000"+vendor; 	
	
	defSoldTo=defSoldTo.substring(vendor.length(),defSoldTo.length());
ezc.ezcommon.EzLog4j.log(vendor+":::vendor:::defSoldTo:::::"+defSoldTo,"I");
	java.util.Hashtable openIBDItemsHT = new java.util.Hashtable();

	try
	{
		JCoDestination destination = EzSAPHandler.getDestination("200~999");
		//out.println(":::::destination:::::::"+destination);
		JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_DETAILS");
		//out.println(":::::function:::::::"+function);
JCoParameterList impParam = function.getImportParameterList();


			impParam.setValue("VENDOR",defSoldTo);
			impParam.setValue("COMPCODE","CFL");
			
			
     

			try
			{
				function.execute(destination);
				//System.out.println("function executed::::::");
			}
			catch(Exception e)
			{
				System.out.println("Exception::::::"+e);
			}
			
			
			JCoParameterList expParam = function.getExportParameterList();
			
			JCoStructure expTable = expParam.getStructure("GEN_DATA");
			//int expCoun         = expTable.getNumRows();
			
				
					//String MANDT0       =  (String)expTable.getValue("MANDT");
					 LIFNR       =  (String)expTable.getValue("LIFNR");
					 //out.println("LIFNR::"+LIFNR);
					 NAME1       =  (String)expTable.getValue("NAME1");
					 NAME2       =  (String)expTable.getValue("NAME2");
					 NAME3       =  (String)expTable.getValue("NAME3");
					 NAME4       =  (String)expTable.getValue("NAME4");
					 DLGRP       =  (String)expTable.getValue("DLGRP");
					 ANRED       =  (String)expTable.getValue("ANRED");
					 ORT01       =  (String)expTable.getValue("ORT01");
					 ORT02       =  (String)expTable.getValue("ORT02");
					 REGIO       =  (String)expTable.getValue("REGIO");
					 PSTLZ       =  (String)expTable.getValue("PSTLZ");
					 STRAS       =  (String)expTable.getValue("STRAS");
					 LAND1       =  (String)expTable.getValue("LAND1");
					 STCEG       =  (String)expTable.getValue("STCEG");
					 TELFX       =  (String)expTable.getValue("TELFX");
					 TELF2       =  (String)expTable.getValue("TELF2");
							
					String ADRNR       =  (String)expTable.getValue("ADRNR");
					String WERKS       =  (String)expTable.getValue("WERKS");

			JCoStructure compTable = expParam.getStructure("COMP_DATA");

				CERDT	   	   =  (Date)compTable.getValue("CERDT");
				ZTERMComp   	   =  (String)compTable.getValue("ZTERM");
				HBKID	   	   =  (String)compTable.getValue("HBKID");
				ZWELS              =  (String)compTable.getValue("ZWELS");
				BUKRS              =  (String)compTable.getValue("BUKRS");
				MINDK	   	   =  (String)compTable.getValue("MINDK");
			JCoTable retTable  = function.getTableParameterList().getTable("PURORG_DATA");	      
			JCoTable retTable1 = function.getTableParameterList().getTable("STATUTARY_DATA");
			JCoTable retTable2 = function.getTableParameterList().getTable("CONTACT_INFO");
			JCoTable retTable3 = function.getTableParameterList().getTable("VENDOR_BANKS");
			JCoTable retTable4 = function.getTableParameterList().getTable("BANK_ADDRESS");
			JCoTable retTable5 = function.getTableParameterList().getTable("VEND_EMAILS");
			
			int retCoun         = retTable.getNumRows();
			int retCoun1         = retTable1.getNumRows();
			int retCoun2         = retTable2.getNumRows();
			int retCoun3         = retTable3.getNumRows();
			int retCoun4         = retTable4.getNumRows();
			int retCoun5         = retTable5.getNumRows();
			
			//System.out.println("retTable=="+retTable+"==retCoun=="+retCoun);

			if(retCoun > 0)
						{
							do
							{
								 ZTERM       =  (String)retTable.getValue("ZTERM");
								 KALSK       =  (String)retTable.getValue("KALSK");
								 WAERS       =  (String)retTable.getValue("WAERS");
								 LEBRE       =  (String)retTable.getValue("LEBRE");
								 EKORG       =  (String)retTable.getValue("EKORG");
									 
							}						 
							while(retTable.nextRow());			 
						}
			
						if(retCoun1 > 0)
						{
							do
							{
								// STCEG       	=  (String)retTable1.getValue("STCEG");
								 J_1ISERN       =  (String)retTable1.getValue("J_1ISERN");
								 J_1IEXRG       =  (String)retTable1.getValue("J_1IEXRG");					
								
								 J_1ICSTNO      =  (String)retTable1.getValue("J_1ICSTNO");
								 J_1IEXCD       =  (String)retTable1.getValue("J_1IEXCD");
								 J_1IEXDI       =  (String)retTable1.getValue("J_1IEXDI");
								 J_1IPANNO      =  (String)retTable1.getValue("J_1IPANNO");
								 J_1IEXRN       =  (String)retTable1.getValue("J_1IEXRN");
								 J_1IEXCO       =  (String)retTable1.getValue("J_1IEXCO");
								
								
								//out.println("::MANDT1::"+MANDT+"::::"+LIFNR+"::::"+EKORG+"::::"+ERDAT+"::::"+ERNAM+"::::"+WAERS+"::::"+MINBW+"::::"+ZTERM+"::::"+INCO1+"::::"+INCO2);	 
													 
													 
								//openIBDItemsHT.put(itemNo,itemOpenQty);	 
							}						 
							while(retTable.nextRow());			 
						}			
					if(retCoun2 > 0)
						{
							do
							{
								NAMEV       =  (String)retTable2.getValue("NAMEV");					
								NAME1ConInfo       =  (String)retTable2.getValue("NAME1");
								 TELF1       =  (String)retTable2.getValue("TELF1");
							}						 
							while(retTable2.nextRow());			 
						}
					if(retCoun3 > 0)
						{
							do
							{				
								 BANKN       =  (String)retTable3.getValue("BANKN");
							}						 
							while(retTable3.nextRow());			 
						}			
					
					if(retCoun4 > 0)
						{
							do
							{
								 BANKS       =  (String)retTable4.getValue("BANKS");
								 BANKL       =  (String)retTable4.getValue("BANKL");					
								 BANKA       =  (String)retTable4.getValue("BANKA");
								 PROVZ       =  (String)retTable4.getValue("PROVZ");
								 BRNCH       =  (String)retTable4.getValue("BRNCH");
									 
							}						 
							while(retTable4.nextRow());			 
						}	
					if(retCoun5 > 0)
						{
							do
							{
								 SMTP_ADDR        =  (String)retTable5.getValue("SMTP_ADDR");
							}						 
							while(retTable5.nextRow());			 
						}			
							
	}
	catch(Exception e){
		out.println(":::::Exception:::::::"+e);
	}
	
	
	String title = "";
	boolean titleChanged=false;
	String titleStyle="";
	try{
	title =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_TITLE"));
	}catch(Exception e){}

	if(!title.equals(ANRED.trim())){
	titleChanged=true;
	titleStyle="style='background-color:#F0E68C'";
	}
	
	String name3 = "";
	boolean name3Changed=false;
	String name3Style="";
	try{
	name3 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME3"));
	}catch(Exception e){}
	
	if(!name3.equals(NAME3.trim())){
		name3Changed=true;
		name3Style="style='background-color:#F0E68C'";
	}

	String name4 = "";
	boolean name4Changed=false;
	String name4Style="";
	try{
	name4 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME4"));
	}catch(Exception e){}
		
	if(!name4.equals(NAME4.trim()))
	{
		name4Changed=true;
		name4Style="style='background-color:#F0E68C'";
	}
	
	String street = "";
	boolean streetChanged=false;
	String streetStyle="";
	try{
	street =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_STREET"));
	}catch(Exception e){}

	if(!street.equals(STRAS.trim()))
	{
		streetChanged=true;
		streetStyle="style='background-color:#F0E68C'";
	}
	
	String city = "";
	boolean cityChanged=false;
	String cityStyle="";
	try{
	city =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_CITY"));
	}catch(Exception e){}
	
	if(!city.equals(ORT01.trim()))
	{
		cityChanged=true;
		cityStyle="style='background-color:#F0E68C'";
	}
	
	String district = "";
	boolean districtChanged=false;
	String districtStyle="";
	try{
	district =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_DISTRICT"));
	}catch(Exception e){}
		
	if(!district.equals(ORT02.trim()))
	{
		districtChanged=true;
		districtStyle="style='background-color:#F0E68C'";
	}
	
	String pin = "";
	boolean pinChanged=false;
	String pinStyle="";
	try{
	pin =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_PIN"));
	}catch(Exception e){}

	if(!pin.equals(PSTLZ.trim())){
	pinChanged=true;
	pinStyle="style='background-color:#F0E68C'";
	}
	
	String landline = "";
	boolean landlineChanged=false;
	String landlineStyle="";
	try{
	landline =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_LANDLINE"));
	}catch(Exception e){}

	if(!landline.equals(TELF1.trim())){
	landlineChanged=true;
	landlineStyle="style='background-color:#F0E68C'";
	}
	
	String mobile = "";
	boolean mobileChanged=false;
	String mobileStyle="";
	try{
	mobile =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_MOBILE"));
	}catch(Exception e){}

	if(!mobile.equals(TELF2.trim())){
	mobileChanged=true;
	mobileStyle="style='background-color:#F0E68C'";
	}
	
	String fax = "";
	boolean faxChanged=false;
	String faxStyle="";
	try{
	fax =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_FAX"));
	}catch(Exception e){}

	if(!fax.equals(TELFX.trim())){
	faxChanged=true;
	faxStyle="style='background-color:#F0E68C'";
	}
	
	String email = "";
	boolean emailChanged=false;
	String emailStyle="";
	try{
	email =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_EMAIL"));
	}catch(Exception e){}

	if(!email.equals(SMTP_ADDR.trim())){
	emailChanged=true;
	emailStyle="style='background-color:#F0E68C'";
	}
	
	String vat = "";
	boolean vatChanged=false;
	String vatStyle="";
	try{
	vat =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_VAT"));
	}catch(Exception e){}

	if(!vat.equals(STCEG.trim())){
	vatChanged=true;
	vatStyle="style='background-color:#F0E68C'";
	}
	
	String cst = "";
	boolean cstChanged=false;
	String cstStyle="";
	try{
	cst =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CST"));
	}catch(Exception e){}

	if(!cst.equals(J_1ICSTNO.trim())){
	cstChanged=true;
	cstStyle="style='background-color:#F0E68C'";
	}
	
	String pan = "";
	boolean panChanged=false;
	String panStyle="";
	try{
	pan =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_PAN_NO"));
	}catch(Exception e){}

	if(!pan.equals(J_1IPANNO.trim())){
	panChanged=true;
	panStyle="style='background-color:#F0E68C'";
	}
	
	String servTax = "";
	boolean servTaxChanged=false;
	String servTaxStyle="";
	try{
	servTax =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_SRV_TAX"));
	}catch(Exception e){}

	if(!servTax.equals(J_1ISERN.trim())){
	servTaxChanged=true;
	servTaxStyle="style='background-color:#F0E68C'";
	}
	
	String eccNo = "";
	boolean eccNoChanged=false;
	String eccNoStyle="";
	try{
	eccNo =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_ECC_NO"));
	}catch(Exception e){}

	if(!eccNo.equals(J_1IEXCD.trim())){
	eccNoChanged=true;
	eccNoStyle="style='background-color:#F0E68C'";
	}
	
	String excRegNo = "";
	boolean excRegNoChanged=false;
	String excRegNoStyle="";
	try{
	excRegNo =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_REG_NO"));
	}catch(Exception e){}

	if(!excRegNo.equals(J_1IEXRN.trim())){
	excRegNoChanged=true;
	excRegNoStyle="style='background-color:#F0E68C'";
	}
	
	String rangeSel = "";
	boolean rangeSelChanged=false;
	String rangeSelStyle="";
	try{
	rangeSel =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_RANGE"));
	}catch(Exception e){}

	if(!rangeSel.equals(J_1IEXRG.trim())){
	rangeSelChanged=true;
	rangeSelStyle="style='background-color:#F0E68C'";
	}
	
	String exDiv = "";
	boolean exDivChanged=false;
	String exDivStyle="";
	try{
	exDiv =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_DIV"));
	}catch(Exception e){}

	if(!exDiv.equals(J_1IEXDI.trim())){
	exDivChanged=true;
	exDivStyle="style='background-color:#F0E68C'";
	}
	
	String commi = "";
	boolean commiChanged=false;
	String commiStyle="";
	try{
	commi =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_COMM"));
	}catch(Exception e){}

	if(!commi.equals(J_1IEXCO.trim())){
	commiChanged=true;
	commiStyle="style='background-color:#F0E68C'";
	}
	
	String minIndi = "";
	boolean minIndiChanged=false;
	String minIndiStyle="";
	try{
	minIndi =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_MINORITY_IND"));
	}catch(Exception e){}

	if(!minIndi.equals(MINDK.trim())){
	minIndiChanged=true;
	minIndiStyle="style='background-color:#F0E68C'";
	}
	
	
	String bankCountry = "";
	boolean bankCountryChanged=false;
	String bankCountryStyle="";
	try{
	bankCountry =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_COUNTRY_KEY"));
	}catch(Exception e){}

	if(!bankCountry.equals(BANKS.trim())){
	bankCountryChanged=true;
	bankCountryStyle="style='background-color:#F0E68C'";
	}
	
	String bankName = "";
	boolean bankNameChanged=false;
	String bankNameStyle="";
	try{
	bankName =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_BANK_NAME"));
	}catch(Exception e){}
	if(!bankName.equals(BANKA.trim())){
	bankNameChanged=true;
	bankNameStyle="style='background-color:#F0E68C'";
	}
	
	String bankRegion = "";
	boolean bankRegionChanged=false;
	String bankRegionStyle="";
	try{
	bankRegion =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_REGION"));
	}catch(Exception e){}
	if(!bankRegion.equals(PROVZ.trim())){
	bankRegionChanged=true;
	bankRegionStyle="style='background-color:#F0E68C'";
	}
	
	String bankStreet = "";
	boolean bankStreetChanged=false;
	String bankStreetStyle="";
	try{
	bankStreet =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_STREET"));
	}catch(Exception e){}
	if(!bankStreet.equals(STRAS.trim())){
	bankStreetChanged=true;
	bankStreetStyle="style='background-color:#F0E68C'";
	}
	
	String bankCity = "";
	boolean bankCityChanged=false;
	String bankCityStyle="";
	try{
	bankCity =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_CITY"));
	}catch(Exception e){}
	if(!bankCity.equals(ORT01.trim())){
	bankCityChanged=true;
	bankCityStyle="style='background-color:#F0E68C'";
	}
	
	String bankBranch = "";
	boolean bankBranchChanged=false;
	String bankBranchStyle="";
	try{
	bankBranch =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_BRANCH"));
	}catch(Exception e){}
	if(!bankBranch.equals(BRNCH.trim())){
	bankBranchChanged=true;
	bankBranchStyle="style='background-color:#F0E68C'";
	}
	
	String bankIFSCCode = "";
	boolean bankIFSCCodeChanged=false;
	String bankIFSCCodeStyle="";
	try{
	bankIFSCCode =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_IFSC_CODE"));
	}catch(Exception e){}
	if(!bankIFSCCode.equals(BANKL.trim())){
	bankIFSCCodeChanged=true;
	bankIFSCCodeStyle="style='background-color:#F0E68C'";
	}
	
	String bankACCode = "";
	boolean bankACCodeChanged=false;
	String bankACCodeStyle="";
	try{
	bankACCode =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_AC_CODE"));
	}catch(Exception e){}
	if(!bankACCode.equals(BANKN.trim())){
	bankACCodeChanged=true;
	bankACCodeStyle="style='background-color:#F0E68C'";
	}
	
	String pTerms = "";
	boolean pTermsChanged=false;
	String pTermsStyle="";
	try{
	pTerms =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_TERMS"));
	}catch(Exception e){}
	if(!pTerms.equals(ZTERMComp.trim())){
	pTermsChanged=true;
	pTermsStyle="style='background-color:#F0E68C'";
	}

	String paymMethod = "";
	boolean paymMethodChanged=false;
	String paymMethodStyle="";
	try{
	paymMethod =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_METHOD"));
	}catch(Exception e){}
	if(!paymMethod.equals(ZWELS.trim())){
	paymMethodChanged=true;
	paymMethodStyle="style='background-color:#F0E68C'";
	}

	String creatDate = "";
	boolean creatDateChanged=false;
	String creatDateStyle="";
	try{
	creatDate =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_CREATION_DATE"));
	}catch(Exception e){}
	if(!creatDate.equals(CERDT)){
	creatDateChanged=true;
	creatDateStyle="style='background-color:#F0E68C'";
	}

	String houseBank = "";
	boolean houseBankChanged=false;
	String houseBankStyle="";
	try{
	houseBank =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_HOUSE_BANK"));
	}catch(Exception e){}
	if(!houseBank.equals(HBKID.trim())){
	houseBankChanged=true;
	houseBankStyle="style='background-color:#F0E68C'";
	}

	String schemaGroup = "";
	boolean schemaGroupChanged=false;
	String schemaGroupStyle="";
	try{
	schemaGroup =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_SCHEMA_GROUP"));
	}catch(Exception e){}
	if(!schemaGroup.equals(KALSK.trim())){
	schemaGroupChanged=true;
	schemaGroupStyle="style='background-color:#F0E68C'";
	}
	
							
%>

  <%@ include file="ezHeader.jsp"%> 

<Html>
<Head>
<style>
.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
input
{
	    border: none;
}
</style>

</Head>
<Body>
 <form method="post"  name="myForm">
<input type="hidden" name="defSoldTo" value="<%=defSoldTo%>">
<input type="hidden" name="docId" value="<%=docId%>">
<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h4>
            Vendor Request: <%=docId%>
          </h4>
        </section>

        <!-- Main content -->  
        <section class="content">  
        

<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BASIC DETAILS</B></h5>
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: none;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=left>Vendor Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  maxlength="10" required>
					</Td>
					<Th align=right>Company Code<font size="2" color="red">*</font></Th>
					<Td colspan="4" ><%=BUKRS%></Td>
					<!--<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>-->
					<Th>ServAgntProcGrp<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="procGrp" id="procGrp" value="<%=DLGRP%>"  maxlength="3">																				
					</Td>
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  maxlength="35">

					</Td>
					<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right>GR Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="grBased" id="grBased" value="Value"  maxlength="1">

					</Td>
				</Tr>
							
				</TBody>               
				</Table>
				</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>

		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
			<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>CONTACT DETAILS</B></h5>
			<Div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>                
			</Div>
			</Div>
			<Div class="box-body" style="display: none;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>Title<font size="2" color="red">*</font>
					<br>
					<%
						if(titleChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%>						
					</Th>
					<Td colspan="4" <%=titleStyle%>>
					<%=ANRED%>
					<br>
						<%
							if(titleChanged)
							{
						%>
							<input type="hidden" name="titleSel" value="<%=title%>"><%=title%>
						<%
							}
						%>
					</Td>
					<Th>Name1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35">

					</Td>
					<Th>Name2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No<font size="2" color="red">*</font>
					<br>
					<%
						if(name3Changed)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=name3Style%>>
						<%=NAME3%>
					<br>
						<%
							if(name3Changed)
							{
						%>
							<input type="hidden" name="addr1" value="<%=name3%>"><%=name3%>
						<%
							}
						%>
					</Td>

					<Th>Addr2<font size="2" color="red">*</font>
					<br>
					<%
						if(name4Changed)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=name4Style%>>
						<%=NAME4%>
						<br>
						<%
							if(name4Changed)
							{
						%>
							<input type="hidden" name="addr2" value="<%=name4%>"><%=name4%>
						<%
							}
						%>
					</Td>
					<Th>Street<font size="2" color="red">*</font>
					<br>
					<%
						if(streetChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=streetStyle%>>
						<%=STRAS%>
						<br>
						<%
							if(streetChanged)
							{
						%>
							<input type="hidden" name="street" value="<%=street%>"><%=street%>
						<%
							}
						%>					
					</Td>
				</Tr>
				<Tr>
					
					<Th>City<font size="2" color="red">*</font>
					<br>
					<%
						if(cityChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=cityStyle%>>
						<%=ORT01%>
						<br>
						<%
							if(cityChanged)
							{
						%>
							<input type="hidden" name="city" value="<%=city%>"><%=city%>
						<%
							}
						%>
					</Td>
					<Th>State<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
						<!--<select disabled  name="state" id="state">
							<option value="<%=REGIO%>" selected><%=REGIO%></option>
						</select>					-->

					</Td>
					<Th>Country<font size="2" color="red">*</font></Th>
					<Td>
					<Input readonly  type="text" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						<!--<select disabled  name="country" id="country">	
							<option value="<%=LAND1%>" selected><%=LAND1%></option>
						</select>					-->

					</Td>
				</Tr>
				<Tr>
					<Th>District<font size="2" color="red">*</font>
					<br>
					<%
						if(districtChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=districtStyle%>>
					<%=ORT02%>
						<br>
						<%
							if(districtChanged)
							{
						%>
							<input type="hidden" name="district" value="<%=district%>"><%=district%>
						<%
							}
						%>
					</Td>

					<Th>Pin<font size="2" color="red">*</font>
					<br>
					<%
						if(pinChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=pinStyle%>>
					<%=PSTLZ%>
						<br>
						<%
							if(pinChanged)
							{
						%>
							<input type="hidden" name="pin" value="<%=pin%>"><%=pin%>
						<%
							}
						%>

					</Td>
					</Tr>
					<Tr>
					<Th>Landline<font size="2" color="red">*</font>
					<br>
					<%
						if(landlineChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=landlineStyle%>>
					<%=TELF1%>
					<br>
					<%
						if(landlineChanged)
						{
					%>
						<input type="hidden" name="landline" value="<%=landline%>"><%=landline%>
					<%
						}
					%>

					</Td>
					<Th>Mobile<font size="2" color="red">*</font>
					<br>
					<%
						if(mobileChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=mobileStyle%>>
					<%=TELF2%>
					<br>
					<%
						if(mobileChanged)
						{
					%>
						<input type="hidden" name="mobile" value="<%=mobile%>"><%=mobile%>
					<%
						}
					%>
					</Td>
					<Th>Fax<font size="2" color="red">*</font>
					<br>
					<%
						if(faxChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=faxStyle%>>
					<%=TELFX%>
					<br>
					<%
						if(faxChanged)
						{
					%>
						<input type="hidden" name="fax" value="<%=fax%>"><%=fax%>
					<%
						}
					%>
											
					</Td>
				</Tr>
				 <Tr>
					<Th>EMail<font size="2" color="red">*</font>
					<br>
					<%
						if(emailChanged)
						{
					%>
						<b>Changed Value:</b>
					<%
						}
					%></Th>
					<Td colspan="4" <%=emailStyle%>>
					<%=SMTP_ADDR%>
					<br>
					<%
						if(emailChanged)
						{
					%>
						<input type="hidden" name="email" value="<%=email%>"><%=email%>
					<%
						}
					%>
					</Td>
					<Th>Contact Person 1<font size="1.5" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=NAMEV%>"  maxlength="10">
					</Td>
					<Th>Contact Person 2<font size="1.5" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers2" id="contPers2" value="<%=NAME1ConInfo%>"  maxlength="10">
					</Td>
				</Tr>
				
			</TBody>               
			</Table>
			</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>            

		<Div class="box box-info collapsed-box">
		<Div class="box-header ">
		<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>STATUTORY</B></h5>
		<Div class="box-tools pull-right">
		<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
		</button>                
		</Div>
		</Div>
		<Div class="box-body" style="display: none;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody>
			<Tr>
				<Th>VAT<font size="2" color="red">*</font>
				<br>
				<%
					if(vatChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=vatStyle%>>
				<%=STCEG%>
				<br>
				<%
					if(vatChanged)
					{
				%>
					<input type="hidden" name="vat" value="<%=vat%>"><%=vat%>
				<%
					}
				%>
				</Td>
				<Th>CST<font size="2" color="red">*</font>
				<br>
				<%
					if(cstChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=cstStyle%>>
				<%=J_1ICSTNO%>
				<br>
				<%
					if(cstChanged)
					{
				%>
					<input type="hidden" name="cst" value="<%=cst%>"><%=cst%>
				<%
					}
				%>
				</Td>
				
				<Th>PAN<font size="2" color="red">*</font>
				<br>
				<%
					if(panChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=panStyle%>>
				<%=J_1IPANNO%>
				<br>
				<%
					if(panChanged)
					{
				%>
					<input type="hidden" name="pan" value="<%=pan%>"><%=pan%>
				<%
					}
				%>
				</Td>
			</Tr>

			<Tr>
				<Th>Service Tax<font size="2" color="red">*</font>
				<br>
				<%
					if(servTaxChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=servTaxStyle%>>
				<%=J_1ISERN%>
				<br>
				<%
					if(servTaxChanged)
					{
				%>
					<input type="hidden" name="servTax" value="<%=servTax%>"><%=servTax%>
				<%
					}
				%>
				</Td>
				
				<Th>Ecc No<font size="2" color="red">*</font><br>
				<%
					if(eccNoChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=eccNoStyle%>>
				<%=J_1IEXCD%>
				<br>
				<%
					if(eccNoChanged)
					{
				%>
					<input type="hidden" name="eccNo" value="<%=eccNo%>"><%=eccNo%>
				<%
					}
				%>
				</Td>
					
				<Th>Exc. Reg No<font size="2" color="red">*</font><br>
				<%
					if(excRegNoChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=excRegNoStyle%>>
				<%=J_1IEXRN%>
				<br>
				<%
					if(excRegNoChanged)
					{
				%>
					<input type="hidden" name="excRegNo" value="<%=excRegNo%>"><%=excRegNo%>
				<%
					}
				%>
				</Td>
					
					
			</Tr>
			<Tr>	
				<Th>Ex. Range<font size="2" color="red">*</font><br>
				<%
					if(rangeSelChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=rangeSelStyle%>>
				<%=J_1IEXRG%>
				<br>
				<%
					if(rangeSelChanged)
					{
				%>
					<input type="hidden" name="rangeSel" value="<%=rangeSel%>"><%=rangeSel%>
				<%
					}
				%>
				</Td>
					<!--<select disabled  name="rangeSel" id="rangeSel">
						<option value="<%=J_1IEXRG%>" selected><%=J_1IEXRG%></option>
					</select>					-->
					
				<Th>Ex Division<font size="2" color="red">*</font><br>
				<%
					if(exDivChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=exDivStyle%>>
				<%=J_1IEXDI%>
				<br>
				<%
					if(exDivChanged)
					{
				%>
					<input type="hidden" name="exDiv" value="<%=exDiv%>"><%=exDiv%>
				<%
					}
				%>
				</Td>
				
				<Th>CommI<font size="2" color="red">*</font><br>
				<%
					if(commiChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=commiStyle%>>
				<%=J_1IEXCO%>
				<br>
				<%
					if(commiChanged)
					{
				%>
					<input type="hidden" name="commi" value="<%=commi%>"><%=commi%>
				<%
					}
				%>
				</Td>
			</Tr>
			<Tr>
				<Th>Minority Indi<font size="2" color="red">*</font><br>
				<%
					if(minIndiChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=minIndiStyle%>>
				<%=MINDK%>
				<br>
				<%
					if(minIndiChanged)
					{
				%>
					<input type="hidden" name="minIndi" value="<%=minIndi%>"><%=minIndi%>
				<%
					}
				%>
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
				</Td>
			</Tr>
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>



			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
						    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BANK</B></h5>
						    <Div class="box-tools pull-right">
								    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
								    </button>                   
				      </Div>
				       </Div>
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			<br>
			<%
				if(bankCountryChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankCountryStyle%>>
			<%=BANKS%>
			<br>
			<%
				if(bankCountryChanged)
				{
			%>
				<input type="hidden" name="bankCountry" value="<%=bankCountry%>"><%=bankCountry%>
			<%
				}
			%>
			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			<br>
			<%
				if(bankNameChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankNameStyle%>>
			<%=BANKA%>
			<br>
			<%
				if(bankNameChanged)
				{
			%>
				<input type="hidden" name="bankName" value="<%=bankName%>"><%=bankName%>
			<%
				}
			%>
			</Td>
			<Th>
				Region<font size="2" color="red">*</font>
			<br>
			<%
				if(bankRegionChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankRegionStyle%>>
			<%=PROVZ%>
			<br>
			<%
				if(bankRegionChanged)
				{
			%>
				<input type="hidden" name="bankRegion" value="<%=bankRegion%>"><%=bankRegion%>
			<%
				}
			%>

			</Td>

			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			<br>
			<%
				if(bankStreetChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankStreetStyle%>>
			<%=STRAS%>
			<br>
			<%
				if(bankStreetChanged)
				{
			%>
				<input type="hidden" name="bankStreet" value="<%=bankStreet%>"><%=bankStreet%>
			<%
				}
			%>

			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			<br>
			<%
				if(bankCityChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankCityStyle%>>
			<%=ORT01%>
			<br>
			<%
				if(bankCityChanged)
				{
			%>
				<input type="hidden" name="bankCity" value="<%=bankCity%>"><%=bankCity%>
			<%
				}
			%>

			</Td>
			<Th>
				Branch<font size="2" color="red">*</font>
			<br>
			<%
				if(bankBranchChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankBranchStyle%>>
			<%=BRNCH%>
			<br>
			<%
				if(bankBranchChanged)
				{
			%>
				<input type="hidden" name="bankBranch" value="<%=bankBranch%>"><%=bankBranch%>
			<%
				}
			%>

			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			<br>
			<%
				if(bankIFSCCodeChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankIFSCCodeStyle%>>
			<%=BANKL%>
			<br>
			<%
				if(bankIFSCCodeChanged)
				{
			%>
				<input type="hidden" name="bankIFSCCode" value="<%=bankIFSCCode%>"><%=bankIFSCCode%>
			<%
				}
			%>

			</Td>


			<Th>
				AC Code<font size="2" color="red">*</font>
			<br>
			<%
				if(bankACCodeChanged)
				{
			%>
				<b>Changed Value:</b>
			<%
				}
			%></Th>
			<Td colspan="4" <%=bankACCodeStyle%>>
			<%=BANKN%>
			<br>
			<%
				if(bankACCodeChanged)
				{
			%>
				<input type="hidden" name="bankACCode" value="<%=bankACCode%>"><%=bankACCode%>
			<%
				}
			%>

			</Td>
			<Th>
				Currency<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">	
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>"  maxlength="3">
			<!--<select disabled  name="bankCurrency" id="bankCurrency">			
				<option value="<%=WAERS%>" selected><%=WAERS%></option>		
			</select>	-->				


			</Td>

			 </Tr>
			 </TBody>


			</Table>
				      </Div>
				      <!-- /.table-responsive -->
				    </Div>         		

						    </Div>
						    <!-- /.box-header -->

			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
						    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>PAYMENT DETAILS</B></h5>
						    <Div class="box-tools pull-right">
								    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
								    </button>                   
				      </Div>
				       </Div>
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody>

			
			<Tr>
				<Th>
					P Terms<font size="2" color="red">*</font>
				<br>
				<%
					if(pTermsChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=pTermsStyle%>>
				<%=ZTERMComp%>
				<br>
				<%
					if(pTermsChanged)
					{
				%>
					<input type="hidden" name="pTerms" value="<%=pTerms%>"><%=pTerms%>
				<%
					}
				%>
				<!--<select disabled  name="pTerms" id="pTerms">

					<option value="<%=ZTERMComp%>" selected><%=ZTERMComp%></option>

				</select>-->					


				</Td>	

				<Th>
					Payment Method<font size="2" color="red">*</font>
				<br>
				<%
					if(paymMethodChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=paymMethodStyle%>>
				<%=ZWELS%>
				<br>
				<%
					if(paymMethodChanged)
					{
				%>
					<input type="hidden" name="paymMethod" value="<%=paymMethod%>"><%=paymMethod%>
				<%
					}
				%>

				</Td>
				<Th>
					Creation Date<font size="2" color="red">*</font>
				 <br>
				<%
					if(creatDateChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=creatDateStyle%>>
				<%=CERDT%>
				<br>
				<%
					if(creatDateChanged)
					{
				%>
					<input type="hidden" name="creatDate" value="<%=creatDate%>"><%=creatDate%>
				<%
					}
				%>

				</Td>


			 </Tr>
			<Tr>
				<Th>
					House Bank<font size="2" color="red">*</font>
				<br>
				<%
					if(houseBankChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=houseBankStyle%>>
				<%=HBKID%>
				<br>
				<%
					if(houseBankChanged)
					{
				%>
					<input type="hidden" name="houseBank" value="<%=houseBank%>"><%=houseBank%>
				<%
					}
				%>
				</Td>

				<Th>
					Schema Group<font size="2" color="red">*</font>
				<br>
				<%
					if(schemaGroupChanged)
					{
				%>
					<b>Changed Value:</b>
				<%
					}
				%></Th>
				<Td colspan="4" <%=schemaGroupStyle%>>
				<%=KALSK%>
				<br>
				<%
					if(schemaGroupChanged)
					{
				%>
					<input type="hidden" name="schemaGroup" value="<%=schemaGroup%>"><%=schemaGroup%>
				<%
					}
				%>
				<!--<select disabled name="schemaGroup" id="schemaGroup">

					<option value="<%=KALSK%>" selected=""><%=KALSK%></option>

				</select>					-->


				</Td>					

			</Tr>
			
			</TBody>
			</Table>
		</Div>
		<!-- /.table-responsive -->
	</Div>         		
</Div>
		<Div class="box box-info collapsed-box">            
			<Div class="box-header">
				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>Vendor Comments</B></h5>
		       </Div>
	        
			<div class="form-group">
				  <textarea readonly class="form-control" rows="5"  value="<%=venComments%>"><%=checkNull(venComments)%></textarea>
		       </div>
               </Div>
               <Div class="box box-info collapsed-box">            
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>Comments</B><font color = red>*</font></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-8 col-md-offset-4" style="padding-right:3px;">
	<button type="button" class="btn btn-primary" onclick="funUploads()">View Uploads</button>
	<%
	if("OPEN".equals(status))
	{
	%>
	<button type="button" class="btn btn-primary" onclick="funPostToSAP()">Post To SAP</button>
	<%
	}
	%>
</Div>	
	
<script>
function funDeleteRequest()
{
	var flag= confirm("Are you sure to delete the request");
	if(flag)
	{
		document.myForm.action="ezDeleteRequest.jsp";
		document.myForm.submit();
	}
}
function funPostToSAP()
{
	document.myForm.action="ezPostVendDtlsToSAP.jsp";
	document.myForm.submit();
}
function funUploads()
{
	var Url="ezViewUploads.jsp?docId=<%=docId%>";
	

	$.fancybox.open({
		href : Url,
		type : 'iframe',
		padding : 5,
		width:'80%',
		height:400,
		autoSize : false,
		closeBtn : false,
		helpers     : { 
				overlay : {closeClick: false}
				 }		
	});
}
</script>


        </section><!-- /.content -->
      </Div><!-- /.content-wrapper --> 

	</form>
	</Body>

</Html>
  <%@ include file="ezFooter.jsp"%>
  <link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
  <script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>
      
