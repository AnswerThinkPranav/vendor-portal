<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*,java.text.*" %>		
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>


<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>

<%
ReturnObjFromRetrieve bankListRetObj = new ReturnObjFromRetrieve(new String[]{"VENDOR","COUNTRY","KEY","ACCOUNT_CODE"});
ReturnObjFromRetrieve bankAddrRetObj = new ReturnObjFromRetrieve(new String[]{"KEY","COUNTRY","DATE","BANK_NAME","REGION","STREET","CITY","BRANCH","IFSC","CURRENCY"});
String syskey= "";
String template="";


	Hashtable classHT = new Hashtable();

	classHT.put("01","Registered");
	classHT.put("02","Not Registered");
	classHT.put("03","Compounding Scheme");
	classHT.put("04","PSU/Government Organization");

	
String STRASBank ="";
String  ORT01Bank="",BKREF="";
	String usersList = "";
	String userName	= "";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;
	
	ReturnObjFromRetrieve retVenComm	=  null;
	int retVenCommCnt = 0;
	
	String docId 	= checkNull(request.getParameter("selDocId"));
	String docIdStr 	= checkNull(request.getParameter("selDocIdStr"));
	String status 	= checkNull(request.getParameter("status"));
	String vendor 	= checkNull(request.getParameter("selVendor"));
	String docSysKey 	= checkNull(request.getParameter("docSysKey"));
	String docCurStep 	= checkNull(request.getParameter("docCurStep"));
	
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
	
	
	
	EzcSysConfigParams sparams2 = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams2 = new EzcSysConfigNKParams();
	snkparams2.setLanguage("EN");
	snkparams2.setSystemKey(docSysKey);
	snkparams2.setSiteNumber(200);
	sparams2.setObject(snkparams2);
	Session.prepareParams(sparams2);
	ReturnObjFromRetrieve retTemplate = (ReturnObjFromRetrieve)ConfigManager.getCatAreaDefaults(sparams2);
	int retcnt=retTemplate.getRowCount();
	for(int z=0;z<retcnt;z++)
	{
		if("WFTEMPLATE".equals((retTemplate.getFieldValueString(z,"ECAD_KEY")).toUpperCase()))
		{
			template = retTemplate.getFieldValueString(z,"ECAD_VALUE");
			break;
		}

	}

	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
	
	//keyTableParams.appendRow(keyParams);
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
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetVendorContactPerson");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetBankMaster");
	keyTableParams.appendRow(keyParams);
	 keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyParams.setKey("GetDocComments");
	keyTableParams.appendRow(keyParams);
	
	mainParams.setLocalStore("Y");
	//out.println("docId:::"+docId+"::vendor::"+vendor);
	generalParams.setDocId(docId);
	generalParams.setVendor(vendor);
	if("REJECTED".equals(status))
	generalParams.setStatus("REJECTED");
	else
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
		retVenComm 	= (ReturnObjFromRetrieve)finalRetObj.getObject("GetDocComments");
		//out.println("retVenComm"+retVenComm.toEzcString());
	}catch(Exception e){out.println(e);}
	if(retVenComm!=null)
	{
	retVenCommCnt = retVenComm.getRowCount();
			retVenComm.sort(new String[]{"EDC_DATE"},true);
		}
	for(int i=0;i<retVenCommCnt;i++)
	{
		String uid	= checkNull(retVenComm.getFieldValueString(i,"EDC_USER_ID"));
		try{
		uid=Integer.parseInt(uid)+"";
		}catch(Exception e){uid= retVenComm.getFieldValueString(i,"EDC_USER_ID");}
		if(!userIdAL.contains(uid))
			userIdAL.add(uid);
	}
	for(int i=0;i<userIdAL.size();i++)
	{
		if("".equals(usersList))
			usersList=(String)userIdAL.get(i);
		else
			usersList=usersList+"','"+(String)userIdAL.get(i);
		
	}
	mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();


	miscParams.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_LAST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+usersList+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	UserNamesRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	try
	{
	if(UserNamesRetObj!=null)
	userNameCount = UserNamesRetObj.getRowCount();
	}catch(Exception e){System.out.println(e);}
	
	ReturnObjFromRetrieve retLastStep=null;
	int retLastStepCnt=0;
	
	mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();
	
	
	miscParams.setQuery("select max(EWTS_STEP) STEP from ezc_wf_template_steps where EWTS_CODE='"+template+"'");
	
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	retLastStep = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	try
	{
	if(retLastStep!=null)
	retLastStepCnt = retLastStep.getRowCount();
	}catch(Exception e){System.out.println(e);}
	
	String docMaxstep= checkNull(retLastStep.getFieldValueString(0,"STEP").trim());
	ezc.ezcommon.EzLog4j.log("docMaxstep:::::"+docMaxstep,"I");
	ezc.ezcommon.EzLog4j.log("docCurStep::::"+docCurStep,"I");
	
	
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
String BANKS       = 	"",SWIFT="";
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
String CERDTStr="";
String	HBKID	   =    "";
String	KALSK	   =    "";
String  WAERS      = 	"";
String  LEBRE      = 	"";
String  WEBRE      = 	"";
String EKORG       =    "";
String TELFX       = 	"";
String TELF2       = 	"";
String NAMEV       = 	"";
String NAME1ConInfo       =    "";
String STCEG       = 	"";
String MINDK       = 	"",GSTIN="";

String J_1ISERN    	= 	"",CLASSIF="",CLASSIF_DESC="",DB_CLASSIF_DESC="";
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
					 TELF2       =  (String)expTable.getValue("TELF1");
					 GSTIN	    =  (String)expTable.getValue("STCD3"); 
							
					String ADRNR       =  (String)expTable.getValue("ADRNR");
					String WERKS       =  (String)expTable.getValue("WERKS");

			JCoStructure compTable = expParam.getStructure("COMP_DATA");

				CERDT	   	   =  (Date)compTable.getValue("CERDT");
				if(CERDT==null)CERDTStr="";
				else{
				SimpleDateFormat formatter = null;//new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = CERDT;//formatter.parse(modifiedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy");
				CERDTStr = formatter.format(date);
				}
								
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
								 WEBRE       =  (String)retTable.getValue("WEBRE");
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
								try
								{
									CLASSIF       =  (String)retTable1.getValue("VEN_CLASS");
									CLASSIF_DESC  =  (String)classHT.get(CLASSIF);
								}catch(Exception e){}
								
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
								 
								bankListRetObj.setFieldValue("VENDOR",(String)retTable3.getValue("LIFNR"));
								bankListRetObj.setFieldValue("COUNTRY",(String)retTable3.getValue("BANKS"));
								bankListRetObj.setFieldValue("KEY",(String)retTable3.getValue("BANKL"));
								bankListRetObj.setFieldValue("ACCOUNT_CODE",BANKN);
								bankListRetObj.addRow();
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
								 STRASBank       =  (String)retTable4.getValue("STRAS");
								 ORT01Bank       =  (String)retTable4.getValue("ORT01");
								 SWIFT = (String)retTable4.getValue("SWIFT");
								// out.println(SWIFT+":::::::SWIFT:::::::::");
								 bankAddrRetObj.setFieldValue("KEY",BANKL);
								bankAddrRetObj.setFieldValue("COUNTRY",BANKS);
								bankAddrRetObj.setFieldValue("DATE","");
								bankAddrRetObj.setFieldValue("BANK_NAME",BANKA);
								bankAddrRetObj.setFieldValue("REGION",PROVZ);
								bankAddrRetObj.setFieldValue("STREET",STRASBank);
								bankAddrRetObj.setFieldValue("CITY",ORT01Bank);
								bankAddrRetObj.setFieldValue("BRANCH",BRNCH);
								bankAddrRetObj.setFieldValue("IFSC",(String)retTable4.getValue("SWIFT"));
								bankAddrRetObj.setFieldValue("CURRENCY",WAERS);
								bankAddrRetObj.addRow();
									 
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
out.println(title+"::::::::::::"+ANRED+"::::::::");
	if(!title.equals(ANRED.trim())){
	titleChanged=true;
	titleStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String name3 = "";
	boolean name3Changed=false;
	String name3Style="";
	try{
	name3 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME3"));
	}catch(Exception e){}
	
	if(!name3.equals(NAME3.trim())){
		name3Changed=true;
		name3Style="style='background-color:#F0E68C;width: 70px;'";
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
		name4Style="style='background-color:#F0E68C;width: 70px;'";
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
		streetStyle="style='background-color:#F0E68C;width: 70px;'";
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
		cityStyle="style='background-color:#F0E68C;width: 70px;'";
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
		districtStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String pin = "";
	boolean pinChanged=false;
	String pinStyle="";
	try{
	pin =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_PIN"));
	}catch(Exception e){}
out.println(pin+":::::::::::::"+PSTLZ);
	if(!pin.equals(PSTLZ.trim())){
	pinChanged=true;
	pinStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String landline = "";
	boolean landlineChanged=false;
	String landlineStyle="";
	try{
	landline =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_LANDLINE"));
	}catch(Exception e){}

	if(!landline.equals(TELF2.trim())){
	landlineChanged=true;
	landlineStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String mobile = "";
	boolean mobileChanged=false;
	String mobileStyle="";
	try{
	mobile =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_MOBILE"));
	}catch(Exception e){}

	if(!mobile.equals(TELF1.trim())){
	mobileChanged=true;
	mobileStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String fax = "";
	boolean faxChanged=false;
	String faxStyle="";
	try{
	fax =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_FAX"));
	}catch(Exception e){}

	if(!fax.equals(TELFX.trim())){
	faxChanged=true;
	faxStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String email = "";
	boolean emailChanged=false;
	String emailStyle="";
	try{
	email =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_EMAIL"));
	}catch(Exception e){}

	if(!email.equals(SMTP_ADDR.trim())){
	emailChanged=true;
	emailStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	//out.println(companyDataRetObj.toEzcString());
String certificateDate = "";
	boolean certificateDateChanged=false;
	String certificateDateStyle="";
	try{
	certificateDate =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_CERTIFICATE_DATE"));
	}catch(Exception e){}
//out.println(certificateDate+"::::::::certificateDate");
	if(!certificateDate.equals(CERDTStr.trim())){
	certificateDateChanged=true;
	certificateDateStyle="style='background-color:#F0E68C;width: 70px;'";
	}
		
	String email2 = "";
		boolean email2Changed=false;
		String email2Style="";
		try{
		email2 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_EMAIL"));
		}catch(Exception e){}
	
		if(!email2.equals(SMTP_ADDR.trim())){
		email2Changed=true;
		email2Style="style='background-color:#F0E68C;width: 70px;'";
	}
String contPers1 = "";
		boolean cont1Changed=false;
		String cont1Style="";
		try{
		contPers1 =checkNull(contactPersonRetObj.getFieldValueString(0,"EVCP_CONTACT_PERSSON"));
		}catch(Exception e){}
	//out.println(contPers1+":::::::::::::::::");
		if(!contPers1.equals(NAMEV.trim())){
		cont1Changed=true;
		cont1Style="style='background-color:#F0E68C;width: 70px;'";
	}
String contPers2 = "";
		boolean cont2Changed=false;
		String cont2Style="";
		try{
		contPers2 =checkNull(contactPersonRetObj.getFieldValueString(1,"EVCP_CONTACT_PERSSON"));
		
		}catch(Exception e){contPers2 =checkNull(contactPersonRetObj.getFieldValueString(0,"EVCP_CONTACT_PERSSON"));}
	
		if(!contPers2.equals(NAME1ConInfo.trim())){
		cont2Changed=true;
		cont2Style="style='background-color:#F0E68C;width: 70px;'";
	}	
	
	String vat = "";
	boolean vatChanged=false;
	String vatStyle="";
	try{
	vat =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_VAT"));
	}catch(Exception e){}
	
	//VAT and CST values are commented for GST

	/*if(!vat.equals(STCEG.trim())){
	vatChanged=true;
	vatStyle="style='background-color:#F0E68C;width: 70px;'";
	}*/
	
	String cst = "";
	boolean cstChanged=false;
	String cstStyle="";
	try{
	cst =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CST"));
	}catch(Exception e){}

	/*if(!cst.equals(J_1ICSTNO.trim())){
	cstChanged=true;
	cstStyle="style='background-color:#F0E68C;width: 70px;'";
	}*/
	
	String pan = "";
	boolean panChanged=false;
	String panStyle="";
	try{
	pan =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_PAN_NO"));
	}catch(Exception e){}

	if(!pan.equals(J_1IPANNO.trim())){
	panChanged=true;
	panStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String servTax = "";
	boolean servTaxChanged=false;
	String servTaxStyle="";
	try{
	servTax =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_SRV_TAX"));
	}catch(Exception e){}

	if(!servTax.equals(J_1ISERN.trim())){
	servTaxChanged=true;
	servTaxStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String eccNo = "";
	boolean eccNoChanged=false;
	String eccNoStyle="";
	try{
	eccNo =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_ECC_NO"));
	}catch(Exception e){}

	if(!eccNo.equals(J_1IEXCD.trim())){
	eccNoChanged=true;
	eccNoStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String excRegNo = "";
	boolean excRegNoChanged=false;
	String excRegNoStyle="";
	try{
	excRegNo =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_REG_NO"));
	}catch(Exception e){}

	if(!excRegNo.equals(J_1IEXRN.trim())){
	excRegNoChanged=true;
	excRegNoStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String rangeSel = "";
	boolean rangeSelChanged=false;
	String rangeSelStyle="";
	try{
	rangeSel =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_RANGE"));
	}catch(Exception e){}

	if(!rangeSel.equals(J_1IEXRG.trim())){
	rangeSelChanged=true;
	rangeSelStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String exDiv = "";
	boolean exDivChanged=false;
	String exDivStyle="";
	try{
	exDiv =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_DIV"));
	}catch(Exception e){}

	if(!exDiv.equals(J_1IEXDI.trim())){
	exDivChanged=true;
	exDivStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	String commi = "";
	boolean commiChanged=false;
	String commiStyle="";
	try{
	commi =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_COMM"));
	}catch(Exception e){}

	if(!commi.equals(J_1IEXCO.trim())){
	commiChanged=true;
	commiStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	
	ReturnObjFromRetrieve retMinInd	=  null;
	int    MinIndCnt	=  0;
	String minIndi = "";
	boolean minIndiChanged=false;
	String minIndiStyle="";
	try{
	minIndi =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_MINORITY_IND"));
	}catch(Exception e){}

	if(!minIndi.equals(MINDK.trim())){
	minIndiChanged=true;
	minIndiStyle="style='background-color:#F0E68C;width: 70px;'";
	

		ezc.ezparam.EzcParams mainParams5	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams5		= new EziMiscParams();
		miscParams5.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='MIN_IND' and EMKV_KEY IN('"+minIndi+"','"+MINDK+"')");
		mainParams5.setLocalStore("Y");
		mainParams5.setObject(miscParams5);
		Session.prepareParams(mainParams5);
		try
		{		
			retMinInd=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
		if(retMinInd!=null)
		MinIndCnt=retMinInd.getRowCount();	
	}

	String gst = "";
	boolean gstChanged=false;
	String gstStyle="";
	try{
	gst =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_GST"));
	}catch(Exception e){}

	if(!gst.equals(GSTIN.trim())){
	gstChanged=true;
	gstStyle="style='background-color:#F0E68C;width: 70px;'";
	}	
	
	String classi = "";
	boolean classiChanged=false;
	String classiStyle="";
	try{
	classi =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CLASSIFICATION"));
	}catch(Exception e){}

	if(!classi.equals(CLASSIF.trim())){
	classiChanged=true;
	classiStyle="style='background-color:#F0E68C;width: 70px;'";
	}	
	
	
	
	String pTerms = "";
	boolean pTermsChanged=false;
	String pTermsStyle="";
	try{
	pTerms =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_TERMS"));
	}catch(Exception e){}
	if(!pTerms.equals(ZTERMComp.trim())){
	pTermsChanged=true;
	pTermsStyle="style='background-color:#F0E68C;width: 70px;'";
	}

	String paymMethod = "";
	boolean paymMethodChanged=false;
	String paymMethodStyle="";
	try{
	paymMethod =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_METHOD"));
	}catch(Exception e){}
	if(!paymMethod.equals(ZWELS.trim())){
	paymMethodChanged=true;
	paymMethodStyle="style='background-color:#F0E68C;width: 70px;'";
	}


	String houseBank = "";
	boolean houseBankChanged=false;
	String houseBankStyle="";
	try{
	houseBank =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_HOUSE_BANK"));
	}catch(Exception e){}
	if(!houseBank.equals(HBKID.trim())){
	houseBankChanged=true;
	houseBankStyle="style='background-color:#F0E68C;width: 70px;'";
	}

	String schemaGroup = "";
	boolean schemaGroupChanged=false;
	String schemaGroupStyle="";
	try{
	schemaGroup =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_SCHEMA_GROUP"));
	}catch(Exception e){}
	if(!schemaGroup.equals(KALSK.trim())){
	schemaGroupChanged=true;
	schemaGroupStyle="style='background-color:#F0E68C;width: 70px;'";
	}
	

			
							
%>
 <%@ include file="ezGetUserAuthDefaults.jsp"%>    
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
th
{
	    text-align: left;
	    font-size: small;
}
td
{
	    text-align: left;
	    font-size: small;
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
<input type="hidden" name="SAPUSER" value="">
<input type="hidden" name="SAPPASSWORD" value="">
<input type="hidden" name="docSysKey" value="<%=docSysKey%>">
<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h4>
            Vendor Request: <%=docIdStr%>
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
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=left>Vendor Code</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  maxlength="10" required>
					</Td>
					<Th align=right>Company Code</Th>
					<Td colspan="4" ><%=BUKRS%></Td>
					<!--<Th align=right>Service Based</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>-->
					<!--<Th>ServAgntProcGrp</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="procGrp" id="procGrp" value="<%=DLGRP%>"  maxlength="3">																				
					</Td>-->
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  maxlength="35">
						<input type="hidden" name="venName" value="<%=NAME1+NAME2%>">

					</Td>
					<Th align=right>Service Based</Th>
					<Td colspan="4">
					<%
					String srvBasedStr="No";
					if("X".equals(LEBRE))
					{
					srvBasedStr="Yes";
					}
					%>
					<%=srvBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right>GR Based</Th>
					<Td colspan="4">
					<%
					String grBasedStr="No";
					if("X".equals(WEBRE))
					{
					grBasedStr="Yes";
					}
					%>
					<%=grBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="grBased" id="grBased" value="<%=WEBRE%>"  maxlength="1">

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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>                
			</Div>
			</Div>
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
			<Table class="table table-bordered">
			<TBody>
				<Tr>
					<Th colspan="4">
					</th>			

					<Th colspan="4">
					Existing Value
					</th>			

					<Th colspan="4">
					Changed Value
					</th>
				</tr>
			<%
				if(titleChanged)
				{
			%>
				<Tr>
					<Th colspan="4">Title
					<br>									
					</Th>
					<Td colspan="4" >
					<%=ANRED%>
					</td>
					<Td colspan="4"; >					
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
				</tr>					
			<%
				}
			%>
				<!--<tr>
					<Th colspan="4">Name1</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35">

					</Td>
					<Td colspan="4">
											
					</Td>
				</tr>
				<tr>
					<Th colspan="4">Name2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
					<Td colspan="4">
											
					</Td>
				</Tr>-->
			<%
				if(name3Changed)
				{
			%>
				<Tr>
					<Th colspan="4">Addr1 / H.No
					<br>							
					</Th>
					<Td colspan="4" >
						<%=NAME3%>				
					</td>
					<Td colspan="4">						
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
				</tr>
			<%
				}
			%>
			<%
				if(name4Changed)
				{
			%>
				<tr>
					<Th colspan="4">Addr2
					<br>						
					</Th>
					<Td colspan="4" >
						<%=NAME4%>				
					</td>
					<Td colspan="4" >
						
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
				</tr>
			<%
				}
			%>
			<%
				if(streetChanged)
				{
			%>
				<tr>
					<Th colspan="4">Street
					<br>						
					</Th>
					<Td colspan="4" >
						<%=STRAS%>				
					</td>
					<Td colspan="4" >						
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
			<%
				}
			%>
			<%
				if(cityChanged)
				{
			%>
				<Tr>					
					<Th colspan="4">City
					<br>				
					</Th>
					<Td colspan="4" >
						<%=ORT01%>				
					</td>
					<Td colspan="4">						
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
				</tr>
			<%
				}
			%>
			<!--	<tr>
					<Th colspan="4">State</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
											

					</Td>
					<Td colspan="4">
											
					</Td>
				</tr>
				<tr>
					<Th colspan="4">Country</Th>
					<Td>
					<Input readonly  type="text" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						

					</Td>
					<Td colspan="4">
											
					</Td>
				</Tr>  -->
			<%
				if(districtChanged)
				{
			%>
				<Tr>
					<Th colspan="4">District
					<br>					
					</Th>
					<Td colspan="4" >
					<%=ORT02%>					
					</td>
					<Td colspan="4" >					
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
				</tr>
			<%
				}
			%>
			<%
				if(pinChanged)
				{
			%>
				<tr>
					<Th colspan="4">Pin
					<br>						
					</Th>
					<Td colspan="4" >
					<%=PSTLZ%>					
					</td>
					<Td colspan="4">					
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
			<%
				}
			%>
			<%
				if(landlineChanged)
				{
			%>
					<Tr>
					<Th colspan="4">Landline
					<br>						
					</Th>
					<Td colspan="4" >
					<%=TELF2%>					
					</td>
					<Td colspan="4" >					
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
				</tr>
			<%
				}
			%>
			<%
				if(mobileChanged)
				{
			%>
				<tr>
					<Th colspan="4">Mobile
					<br>						
					</Th>
					<Td colspan="4" >
					<%=TELF1%>					
					</td>
					<Td colspan="4" >					
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
				</tr>
			<%
				}
			%>
			<%
				if(faxChanged)
				{
			%>
				<tr>
					<Th colspan="4">Fax
					<br>						
					</Th>
					<Td colspan="4" >
					<%=TELFX%>					
					</td>
					<Td colspan="4" >					
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
			<%
				}
			%>	
			<%
				if(emailChanged)
				{
			%>
				 <Tr>
					<Th colspan="4">EMail
					<br>					
					</Th>
					<Td colspan="4" >
					<%=SMTP_ADDR%>					
					</td>
					<Td colspan="4" >					
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
				</tr>
			<%
				}
			%>
			<%
				if(email2Changed)
				{
			%>
				<Tr>
					<Th colspan="4">EMail 2
					<br>					
					</Th>
					<Td colspan="4" >
						<%=email2%>
					</td>
					<Td colspan="4" >					
					<br>
					<%
						if(email2Changed)
						{
					%>
						<input type="hidden" name="email2" value="<%=email2%>"><%=email2%>
					<%
						}
					%>
					</Td>
				</tr>	
			<%
				}
			%>
			<%
				if(cont1Changed)
				{
			%>
				<tr>
					<Th colspan="4">Contact Person 1</Th>
					<Td colspan="4"  >
						<%=NAMEV%>
					</Td>
					<Td colspan="4">
											
					<br>
					<%
						if(cont1Changed)
						{
					%>
						<input type="hidden" name="contPers1" value="<%=contPers1%>"><%=contPers1%>
					<%
						}
					%>					
					</Td>
				</tr>
			<%
				}
			%>
			<%
				if(cont2Changed)
				{
			%>
				<tr>
					<Th colspan="4">Contact Person 2</Th>
					<Td colspan="4" >
						<%=NAME1ConInfo%>
					</Td>
					<Td colspan="4">
										
					<br>
					<%
						if(cont2Changed)
						{
					%>
						<input type="hidden" name="contPers2" value="<%=contPers2%>"><%=contPers2%>
					<%
						}
					%>						
					</Td>
				</Tr>
			<%
				}
			%>
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
		<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
		</button>                
		</Div>
		</Div>
		<Div class="box-body" style="display: block;">
		<Div class="table-responsive">
		<Table class="table table-bordered">
		<TBody>
			<Tr>
				<Th colspan="4">
				</th>			
			
				<Th colspan="4">
				Existing Value
				</th>			
			
				<Th colspan="4">
				Changed Value
				</th>
			</tr>
		<%
			if(vatChanged)
			{
		%>			
			<Tr>
				<Th colspan="4">VAT
				<br>
				
					
				</Th>
				<Td colspan="4">
					<%=STCEG%>				
				</td>
				<Td colspan="4" >
				
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
			</Tr>
		<%
			}
		%>
		<%
			if(cstChanged)
			{
		%>
			<Tr>
				<Th colspan="4">CST
				<br>
				
					
				</Th>
				<Td colspan="4">
					<%=J_1ICSTNO%>				
				</td>
				<Td colspan="4" >
				
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
			</Tr>
		<%
			}
		%>
		<%
			if(panChanged)
			{
		%>
			<Tr>	
				<Th colspan="4">PAN
				<br>
				
					
				</Th>
				<Td colspan="4">
					<%=J_1IPANNO%>				
				</td>
				<Td colspan="4" >
				
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
		<%
			}
		%>
		<%
			if(servTaxChanged)
			{
		%>		
			<Tr>
				<Th colspan="4">Service Tax
				<br>
				
					
				</Th>
				<Td colspan="4">
					<%=J_1ISERN%>				
				</td>
				<Td colspan="4" >
				
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
			</Tr>
		<%
			}
		%>
		<%
			if(eccNoChanged)
			{
		%>
			<Tr>	
				<Th colspan="4">Ecc No<br>
				
					
				</Th>
				<Td colspan="4">
					<%=J_1IEXCD%>				
				</td>
				<Td colspan="4" >
				
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
			</Tr>
		<%
			}
		%>
		<%
			if(excRegNoChanged)
			{
		%>
			<Tr>		
				<Th colspan="4">Exc. Reg No<br>					
				</Th>
				<Td colspan="4">
					<%=J_1IEXRN%>				
				</td>
				<Td colspan="4" >
				
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
		<%
			}
		%>
		<%
			if(rangeSelChanged)
			{
		%>
			<Tr>	
				<Th colspan="4">Ex. Range<br>		
				</Th>
				<Td colspan="4">
					<%=J_1IEXRG%>				
				</td>
				<Td colspan="4" >				
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
			</Tr>
		<%
			}
		%>
		<%
			if(exDivChanged)
			{
		%>
			<Tr>		
				<Th colspan="4">Ex Division<br>
				</Th>
				<Td colspan="4">
				<%=J_1IEXDI%>					
				</td>
				<Td colspan="4" >				
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
			</Tr>
		<%
			}
		%>
		<%
			if(commiChanged)
			{
		%>
			<Tr>	
				<Th colspan="4">CommI<br>					
				</Th>
				<Td colspan="4">
					<%=J_1IEXCO%>					
				</td>
				<Td colspan="4" >
				
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
		<%
			}
		%>	
		<%
			if(minIndiChanged)
			{
		%>
			<Tr>
				<Th colspan="4">Minority Indi<br>				
				</Th>
				<Td colspan="4">
				<%
				int mindkIndex = -1;
				if(MinIndCnt>0)
				{
				mindkIndex = retMinInd.getRowId("EMKV_KEY",MINDK);
				
				if(mindkIndex>=0)
				MINDK=checkNull(retMinInd.getFieldValueString(mindkIndex,"EMKV_VALUE"));
				}
				%>
					<%=MINDK%>				
				</td>
				<Td colspan="4" >
				
				<br>
				<%
					if(minIndiChanged)
					{
					String minIndiDesc=minIndi;
					mindkIndex=-1;
					if(MinIndCnt>0)
					{
					mindkIndex = retMinInd.getRowId("EMKV_KEY",minIndi);

					if(mindkIndex>=0)
					minIndiDesc=checkNull(retMinInd.getFieldValueString(mindkIndex,"EMKV_VALUE"));
					}
				%>
					<input type="hidden" name="minIndi" value="<%=minIndi%>"><%=minIndiDesc%>
				<%
					}
				%>
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
				</Td>
			</Tr>
				
		<%
			}
		%>
		<%
			if(gstChanged)
			{
		%>
			<Tr>
				<Th colspan="4">GSTIN<br>				
				</Th>
				<Td colspan="4">	<%=GSTIN%>							
					</td>
				<Td colspan="4" >				
				<br>
				<%
					if(gstChanged)
					{
				%>
					<input type="hidden" name="gst" value="<%=gst%>"><%=gst%>
				<%
					}
				%>					
				</Td>
			</Tr>
		<%
			}
		%>
		<%
			if(classiChanged)
			{
		%>
			<Tr>
				<Th colspan="4">Classification<br>				
				</Th>
				<Td colspan="4"><%=CLASSIF_DESC%>									
				</td>
				<Td colspan="4" >				
				<br>
				<%
					if(classiChanged)
					{
					DB_CLASSIF_DESC  =  (String)classHT.get(classi);
				%>
					<input type="hidden" name="classi" value="<%=classi%>"><%=DB_CLASSIF_DESC%>
				<%
					}
				%>
					
				</Td>
			</Tr>			
		<%
			}
		%>
<%
			if(certificateDateChanged)
			{
		%>
			<Tr>
				<Th colspan="4">Certificate Date<br>				
				</Th>
				<Td colspan="4"><%=CERDTStr%>								
				</td>
				<Td colspan="4" >				
				<br>
				<%
					if(certificateDateChanged)
					{
				%>
					<%=certificateDate%><input type="hidden" name="cDate" value="<%=certificateDate%>">
				<%
					}
				%>
					
				</Td>
			</Tr>			
		<%
			}
		%>		
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>



<%
//out.println(bankAddrRetObj.toEzcString());
	if(bankDtlsRetObj!=null)
	{
		for(int k=0;k<bankDtlsRetObj.getRowCount();k++)
		{
			String keyStr = "";//checkNull(bankDtlsRetObj.getFieldValueString(k,"EVBD_KEY"));
			BANKN = checkNull(bankDtlsRetObj.getFieldValueString(k,"EVBD_ACCOUNT_NUM"));
			String bankSerialNo = checkNull(bankDtlsRetObj.getFieldValueString(k,"EVBD_SERIAL_NO"));
			
			int index = bankMasterRetObj.getRowId("ebm_ac_code",BANKN);
			
			BANKL 		="";
			BANKS 		="";
			BANKA 		="";
			PROVZ 		="";
			STRASBank 	="";
			ORT01Bank 	="";
			BRNCH 		="";
			BKREF 		="";
			WAERS 		="";
			if(index>=0)
			{
				BANKL 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_KEY"));
				BANKS 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_COUNTRY_KEY"));
				BANKA 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_BANK_NAME"));
				PROVZ 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_REGION"));
				STRASBank 	= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_STREET"));
				ORT01Bank 	= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_CITY"));
				BRNCH 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_BRANCH"));
				BKREF 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_IFSC_CODE"));
				WAERS 		= checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_CURRENCY"));
			}
			//out.println(BANKA+":::::::bank name::::::::"+index+"::::::account:::::::"+BANKN);
String bankCountry = "";
boolean bankCountryChanged=false;
String bankCountryStyle="";

String bankName = "";
boolean bankNameChanged=false;
String bankNameStyle="";

String bankRegion = "";
boolean bankRegionChanged=false;
String bankRegionStyle="";

String bankStreet = "";
boolean bankStreetChanged=false;
String bankStreetStyle="";

String bankCity = "";
boolean bankCityChanged=false;
String bankCityStyle="";
				
String bankBranch = "";
boolean bankBranchChanged=false;
String bankBranchStyle="";

String bankIFSCCode = "";
boolean bankIFSCCodeChanged=false;
String bankIFSCCodeStyle="";

String bankACCode = "";
boolean bankACCodeChanged=false;
String bankACCodeStyle="";

			if(bankListRetObj!=null)
			{			
				int bankIndex=-1;
				bankIndex=bankListRetObj.getRowId("ACCOUNT_CODE",BANKN);
				//out.println(BANKL+":::::::::"+BANKN+"::::::::bankIndex::::::::"+bankIndex);
				try{
				bankCountry =checkNull(bankListRetObj.getFieldValueString(bankIndex,"COUNTRY"));
				}catch(Exception e){}
			
				if(!bankCountry.equals(BANKS.trim())){
				bankCountryChanged=true;
				bankCountryStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankACCode =checkNull(bankListRetObj.getFieldValueString(bankIndex,"ACCOUNT_CODE"));
				}catch(Exception e){}
				if(!bankACCode.equals(BANKN.trim())){
				bankACCodeChanged=true;
				bankACCodeStyle="style='background-color:#F0E68C'";
				}
				bankIndex=bankAddrRetObj.getRowId("KEY",BANKL);
				try{
				bankName =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"BANK_NAME"));
				}catch(Exception e){}
				if(!bankName.equals(BANKA.trim())){
				bankNameChanged=true;
				bankNameStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankRegion =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"REGION"));
				}catch(Exception e){}
				if(!bankRegion.equals(PROVZ.trim())){
				bankRegionChanged=true;
				bankRegionStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankStreet =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"STREET"));
				}catch(Exception e){}
				if(!bankStreet.equals(STRASBank.trim())){
				bankStreetChanged=true;
				bankStreetStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankCity =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"CITY"));
				}catch(Exception e){}
				if(!bankCity.equals(ORT01Bank.trim())){
				bankCityChanged=true;
				bankCityStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankBranch =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"BRANCH"));
				}catch(Exception e){}
				if(!bankBranch.equals(BRNCH.trim())){
				bankBranchChanged=true;
				bankBranchStyle="style='background-color:#F0E68C'";
				}
				
				try{
				bankIFSCCode =checkNull(bankAddrRetObj.getFieldValueString(bankIndex,"IFSC"));
				}catch(Exception e){}
				if(!bankIFSCCode.equals(BKREF.trim())){
				bankIFSCCodeChanged=true;
				bankIFSCCodeStyle="style='background-color:#F0E68C'";
				}
				
				
			}
if(bankIFSCCodeChanged|| bankBranchChanged|| bankACCodeChanged|| bankNameChanged||bankCountryChanged ||bankRegionChanged|| bankStreetChanged ||bankCityChanged)
{
%>
	<input type="hidden" name="bankACCode" value="<%=BANKN%>">
	<input type="hidden" name="bankIndex" value="<%=bankSerialNo%>">
<%	
}
%>

			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
						    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BANK(<%=BANKN%>)</B></h5>
						    <Div class="box-tools pull-right">
								    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
								    </button>                   
				      </Div>
				       </Div>
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table table-bordered">



			<TBody>
			<Tr>
				<Th colspan="4">
				</th>			
			
				<Th colspan="4">
				Existing Value
				</th>			
			
				<Th colspan="4">
				Changed Value
				</th>
			</tr>			
		<%
			if(bankCountryChanged)
			{
		%>
			<Tr>
			<Th colspan="4">
				Country
			<br>				
			</Th>
			<Td colspan="4">
				<%=bankCountry%>				
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankCountryChanged)
				{
			%>
				<input type="hidden" name="bankCountry" value="<%=BANKS%>"><%=BANKS%>
			<%
				}
			%>
			</Td>
		</Tr>
		<%
			}
		%>
		<%
			if(bankNameChanged)
			{
		%>
		<Tr>	
			<Th colspan="4">
				Bank Name
			<br>				
			</Th>
			<Td colspan="4">
				<%=bankName%>				
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankNameChanged)
				{
			%>
				<input type="hidden" name="bankName" value="<%=BANKA%>"><%=BANKA%>
			<%
				}
			%>
			</Td>
		</Tr>
		<%
			}
		%>
		<%
			if(bankRegionChanged)
			{
		%>
		<Tr>	
			<Th colspan="4">
				Region
			<br>				
			</Th>
			<Td colspan="4">
				<%=bankRegion%>				
			</td>
			<Td colspan="4">			
			<br>
			<%
				if(bankRegionChanged)
				{
			%>
				<input type="hidden" name="bankRegion" value="<%=PROVZ%>"><%=PROVZ%>
			<%
				}
			%>
			</Td>
			</Tr>
		<%
			}
		%>
			
		<%
			if(bankStreetChanged)
			{
		%>
			<Tr>
			<Th colspan="4">
				Street
			<br>			
			</Th>
			<Td colspan="4">
				<%=bankStreet%>				
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankStreetChanged)
				{
			%>
				<input type="hidden" name="bankStreet" value="<%=STRASBank%>"><%=STRASBank%>
			<%
				}
			%>
			</Td>
		</Tr>
		<%
			}
		%>
		<%
			if(bankCityChanged)
			{
		%>
		<Tr>	
			<Th colspan="4">
				City
			<br>				
			</Th>
			<Td colspan="4">
				<%=bankCity%>				
			</td>
			<Td colspan="4">			
			<br>
			<%
				if(bankCityChanged)
				{
			%>
				<input type="hidden" name="bankCity" value="<%=ORT01Bank%>"><%=ORT01Bank%>
			<%
				}
			%>
			</Td>
		</Tr>
		<%
			}
		%>
		<%
			if(bankBranchChanged)
			{
		%>
		<Tr>	
			
			<Th colspan="4">
				Branch
			<br>		
			</Th>
			<Td colspan="4">
				<%=bankBranch%>					
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankBranchChanged)
				{
			%>
				<input type="hidden" name="bankBranch" value="<%=BRNCH%>"><%=BRNCH%>
			<%
				}
			%>
			</Td>
			</Tr>
		<%
			}
		%>
		<%
			if(bankIFSCCodeChanged)
			{
		%>
			<Tr>
			<Th colspan="4">
				IFSC Code
			<br>
			</Th>
			<Td colspan="4">
				<%=bankIFSCCode%>				
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankIFSCCodeChanged)
				{
			%>
				<input type="hidden" name="bankIFSCCode" value="<%=SWIFT%>"><%=SWIFT%>
			<%
				}
			%>
			</Td>
		</Tr>
		<%
			}
		%>
		
		<%
			if(bankACCodeChanged)
			{
		%>
		<Tr>
			<Th colspan="4">
				AC Code
			<br>					
			</Th>
			<Td colspan="4">
				<%=bankACCode%>					
			</td>
			<Td colspan="4" >			
			<br>
			<%
				if(bankACCodeChanged)
				{
			%>
				<%=BANKN%>
			<%
				}
			%>

			</Td>
		</Tr>
		<%
			}
		%>
		<!--<Tr>	
			<Th colspan="4">
				Currency
			</Th>
			<Td colspan="4">
								<%=WAERS%>
			</td>
			<Td colspan="4">	
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>"  maxlength="3">
						


			</Td>

			 </Tr>-->
			 </TBody>


			</Table>
				      </Div>
				      <!-- /.table-responsive -->
				    </Div>         		

						    </Div>
						    <!-- /.box-header -->

			
<%
	}
	}
	if(retVenComm.getRowCount()>0)
	{
%>
		<Div>            
			 <Table class="table" style="width:100%">
			<thead>
				<th style="text-align:center;font-size: medium;text-align: left;background-color: #f39c12 !important">Name</th>
				<th style="text-align:center;font-size: medium;text-align: left;background-color: #f39c12 !important">Comments Date</th>
				<th style="text-align:center;font-size: medium;text-align: left;background-color: #f39c12 !important">Comments</th>
				        
			</thead>
			
	        	<tbody>
<%
			//out.println("countcountcount"+retVenComm.getRowCount());
			for(int s=0;s<retVenComm.getRowCount();s++)
			{
				String userid = checkNull(retVenComm.getFieldValueString(s,"EDC_USER_ID"));
				String commentedOn = checkNull(retVenComm.getFieldValueString(s,"EDC_DATE"));
				String comments = checkNull(retVenComm.getFieldValueString(s,"EDC_COMMENTS"));

				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = formatter.parse(commentedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				String commentedOnDate = formatter.format(date);
				try
				{
				userid=Integer.parseInt(userid)+"";
				}
				catch(Exception e){userid = retVenComm.getFieldValueString(s,"EDC_USER_ID");}
%>
				
				<tr>
<%
					int index=-1;
					if(UserNamesRetObj!=null)
					{

						index=UserNamesRetObj.getRowId("EU_ID",userid);
						userName=checkNull(UserNamesRetObj.getFieldValueString(index,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(index,"EU_LAST_NAME"));

					}
%>
						
						<td align="center"><%=userName%></td>
						<td align="center"><%=commentedOnDate%></td>
						<td align="center"><%=comments%></td>
				</tr>

<%
			}
%>
			
			</tbody>
  			</table>

               </Div>
<%
	}
%>
               <Div class="box box-info collapsed-box">            
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>COMMENTS</B></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-8 col-md-offset-4" >
	<button type="button" class="btn btn-primary" onclick="funUploads()">View Uploads</button>
	<%
	if("OPEN".equals(status))
	{
		if("MDM".equals(userRole))
		{
	%>
		<button type="button" class="btn btn-primary" onclick="funPostToSAP()">Post To SAP</button>
	<%
		}else{
	%>
		
<%			if(docMaxstep.equals(docCurStep))
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('APPROVED')">Approve</button>
				<button type="button" class="btn btn-primary" onclick="funSubmit('REJECTED')">Reject</button>
<%
			}
			else
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('SUBMITTED')">Submit</button>
				<button type="button" class="btn btn-primary" onclick="funSubmit('REJECTED')">Reject</button>
	<%
			}
		}
	}
	%>
	 <button type="button" class="btn btn-primary" onclick="history.go(-1)">Back</button>  
</Div>	
<input type="hidden" name="docStatus">
	
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
function funSubmit(flag)
{
	if(document.myForm.comments.value=="")
	{
		alert("Please enter comments");
		document.getElementById("comments").focus();
		return false;
	}
	document.myForm.docStatus.value=flag;
	
	var flagStr="Submit";
	if(flag=="REJECTED")flagStr="Reject";
	if(flag=="APPROVED")flagStr="Approve";
	$.confirm({
		    title: 'Confirm!',
		    content: 'Are you sure to '+flagStr+' the request?',
		    buttons: {
		        YES:{
		        btnClass: 'btn-success',
		        action:function () {
			      document.myForm.action="ezSubmitVendDtls.jsp";
			      document.myForm.submit();
		        }
		        },
		        NO: {
		           btnClass: 'btn-danger',
			   action:function () {
			 //  funAction("NO");
			   //    $.alert('caNCEL!');
		       	   }
		        }
		        
		    }
		});	
	
}
function funPostToSAP()
{
	if(document.myForm.comments.value=="")
	{
		alert("Please enter comments to post details to SAP");
		document.getElementById("comments").focus();
		return false;
	}
	$.confirm({
		title: 'Enter SAP Login Credentials',
		content: '<table class="table"><tr><th>User Id:</th><td><input type="text" name="SAPUserId" id="SAPUserId"  placeholder="User Id" autocomplete="off" autofocus></td></tr><tr><th>Password:</th><td><input type="password" name="SAPPassword" id="SAPPassword"  autocomplete="new-password" placeholder="Password"></td></tr></table>',
		buttons: {
			DONE:{
				btnClass: 'btn-success',
		
				action:function () {
					var SAPUserId=document.getElementById("SAPUserId").value;
					var SAPPassword=document.getElementById("SAPPassword").value;
								
					if(SAPUserId=="")
					{
						alert("Please enter user Id to post details to SAP");
						document.getElementById("SAPUserId").focus();
						return false;
					}
					if(SAPPassword=="")
					{
						alert("Please enter password to post details to SAP");
						document.getElementById("SAPPassword").focus();
						return false;
					}
					document.myForm.SAPUSER.value=SAPUserId;
					document.myForm.SAPPASSWORD.value=SAPPassword;
					document.myForm.action="ezPostVendDtlsToSAP.jsp";
					document.myForm.submit();
				}
			},
			CANCEL: {
			   btnClass: 'btn-danger',
			   action:function () {

			   }
			}
		}
	});
	
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
      
 <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
