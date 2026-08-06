<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*,java.text.*" %>		
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<%@ include file="iVendorDetails.jsp" %>
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>

<%
//out.println("retCountry"+retCountry.toEzcString());
//out.println("retCurrency"+retCurrency.toEzcString());
//out.println("retState"+retState.toEzcString());

	String usersList = "";
	String userName	= "";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;

	ReturnObjFromRetrieve retVenComm	=  null;
	int retVenCommCnt = 0;

	String docId 	= "";
	String vendor 	= (String)Session.getUserId();
	
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
		EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
		
		keyParams.setKey("GetGeneralData");
		keyTableParams.appendRow(keyParams);
		mainParams.setLocalStore("Y");
	
		generalParams.setStatus("OPEN");
		
String selVendorTemp="0000000000"+(String)Session.getUserId();
		selVendorTemp=selVendorTemp.substring(((String)Session.getUserId()).length(),selVendorTemp.length());
	generalParams.setVendor((String)Session.getUserId()+"','"+selVendorTemp);
	
		//generalParams.setVendor(Integer.parseInt(vendor)+"");
		
		mainParams.setObject(keyTableParams);	
		
		mainParams.setObject(generalParams);
		Session.prepareParams(mainParams);
		
		ReturnObjFromRetrieve vendorDtlsObj =null;
		int vendorDtlsObjCnt=0;
		try{
		 vendorDtlsObj=(ReturnObjFromRetrieve)vendorprofile.ezGetDetails(mainParams);
		 vendorDtlsObj=((ReturnObjFromRetrieve)vendorDtlsObj.getObject("GetGeneralData"));
		if(vendorDtlsObj!=null)
		{
		docId = checkNull(vendorDtlsObj.getFieldValueString(0,"EVGD_DOC_ID"));
	 	}
		
	}catch(Exception e){out.println(e);}
	
	ReturnObjFromRetrieve generalDataRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve purchOrgRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve companyDataRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve exciseDataRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve bankDtlsRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve partnersRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve emailRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve telphoneRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve faxRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve contactPersonRetObj =new ReturnObjFromRetrieve();
	ReturnObjFromRetrieve bankMasterRetObj =new ReturnObjFromRetrieve();
	
	if(!"".equals(docId))
	{
	 mainParams = new ezc.ezparam.EzcParams(true);
	generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	keyTableParams = new EziVendorKeyParamsTable();
	
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
	//generalParams.setVendor(Integer.parseInt(vendor)+"");
selVendorTemp="0000000000"+(String)Session.getUserId();
		selVendorTemp=selVendorTemp.substring(((String)Session.getUserId()).length(),selVendorTemp.length());
	generalParams.setVendor((String)Session.getUserId()+"','"+selVendorTemp);
		
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
	}
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
	
	/*mainParams				= new ezc.ezparam.EzcParams(false);
	miscParams		= new EziMiscParams(); 

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
		venComments = retVenComm.getFieldValueString(0,"EDC_COMMENTS");*/
	//out.println("venComments::"+venComments);
	ReturnObjFromRetrieve retWFCode	=  null;
	int    WFCnt	=  0;
	ezc.ezparam.EzcParams mainParams7	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams7		= new EziMiscParams();
	miscParams7.setQuery("select * from ezc_wf_doc_history_header where EWDHH_DOC_ID='"+docId+"'");
	mainParams7.setLocalStore("Y");
	mainParams7.setObject(miscParams7);
	Session.prepareParams(mainParams7);
	try
	{		
		retWFCode=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams7);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retWFCode!=null)
	WFCnt=retWFCode.getRowCount();	
	String WFStep = retWFCode.getFieldValueString(0,"EWDHH_CURRENT_STEP");
	//out.println("venCoWFStepmments::"+WFStep);
	
%>
<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import ="java.util.*" %>

<%
String docIdStr="";
String purchOrg =checkNull(vendorDtlsObj.getFieldValueString(0,"EVGD_ADDR_NR"));
if(!"".equals(purchOrg))docIdStr=purchOrg+docId;
String LIFNR       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_VENDOR"));
String NAME1       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME1"));
String NAME2       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME2"));
String NAME3       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME3"));
String NAME4       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_NAME4"));
String DLGRP       =	"";
String ANRED       =	"";
String ORT01       =	"";
String ORT01Bank       =	"";
String ORT02       =	"";
String REGIO       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_STATE"));
String PSTLZ       =	"";
String STRAS       =	"";
String STRASBank       =	"";
String LAND1       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_COUNTRY"));
String BANKN       =	"";
String BANKS       = 	"";
String BANKL       = 	"";
String BANKA       = 	"";
String PROVZ       = 	"";
String BRNCH       = 	"";
String SMTP_ADDR   =    "";  
String SMTP_ADDR2   =    "";  
String TELF1	   =	"";  

String ZTERM	   =	""; 
String ZTERMComp   =    "";
String ZWELS       =    "";
String BUKRS       =    "CFL";
String	CERDT	   =    "";
String	HBKID	   =    "";
String	KALSK	   =    "";
String  WAERS      = 	"";
String  LEBRE      = 	checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_SRV_INV_IND"));
String  WEBRE      =  	checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_GR_INV_IND"));
String EKORG       =    checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_PUR_ORG"));
String TELFX       = 	"";
String TELF2       = 	"";
String NAMEV       = 	 checkNull(contactPersonRetObj.getFieldValueString(0,"EVCP_CONTACT_PERSSON"));
String NAME1ConInfo       =    checkNull(contactPersonRetObj.getFieldValueString(1,"EVCP_CONTACT_PERSSON"));
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
String EVEDGST		= 	checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_GST"));
String EVEDCLASSI	=	checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CLASSIFICATION"));
String EVEDCERTIDATE	=	checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CERTIFICATE_DATE"));

 

%>
<%
	String defSoldTo    = "0000000000"+vendor; 	
	
	defSoldTo=defSoldTo.substring(vendor.length(),defSoldTo.length());

		try{
		ANRED =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_TITLE"));
		}catch(Exception e){}
		
		try{
		STRAS =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_STREET"));
		}catch(Exception e){}
	
		try{
		ORT01 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_CITY"));
		}catch(Exception e){}
				
		try{
		ORT02 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_DISTRICT"));
		}catch(Exception e){}
					
		try{
		PSTLZ =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_PIN"));
		}catch(Exception e){}
		
		try{
		TELF1 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_LANDLINE"));
		}catch(Exception e){}
	
		try{
		TELF2 =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_MOBILE"));
		}catch(Exception e){}
			
		try{
		TELFX =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_FAX"));
		}catch(Exception e){}
		
		try{
		SMTP_ADDR =checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_EMAIL"));
		}catch(Exception e){}
		
		try{
		SMTP_ADDR2 =checkNull(generalDataRetObj.getFieldValueString(1,"EVGD_EMAIL"));
		}catch(Exception e){}
			
		try{
		STCEG =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_VAT"));
		}catch(Exception e){}
	
		try{
		J_1ICSTNO =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_CST"));
		}catch(Exception e){}
			
		try{
		J_1IPANNO =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_PAN_NO"));
		}catch(Exception e){}
		
		try{
		J_1ISERN =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_SRV_TAX"));
		}catch(Exception e){}
		
		try{
		J_1IEXCD =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_ECC_NO"));
		}catch(Exception e){}
			
		try{
		J_1IEXRN =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_REG_NO"));
		}catch(Exception e){}
	
		try{
		J_1IEXRG =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_RANGE"));
		}catch(Exception e){}
		
		try{
		J_1IEXDI =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EXC_DIV"));
		}catch(Exception e){}
			
		try{
		J_1IEXCO =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_EX_COMM"));
		}catch(Exception e){}
	
		try{
		MINDK =checkNull(exciseDataRetObj.getFieldValueString(0,"EVED_MINORITY_IND"));
		}catch(Exception e){}
		
		try{
		BANKS =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_COUNTRY_KEY"));
		}catch(Exception e){}
		
		try{
		BANKA =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_BANK_NAME"));
		}catch(Exception e){}
		
		try{
		PROVZ =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_REGION"));
		}catch(Exception e){}
			
		try{
		STRASBank =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_STREET"));
		}catch(Exception e){}
		
		try{
		ORT01Bank =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_CITY"));
		}catch(Exception e){}
		
		try{
		BRNCH =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_BRANCH"));
		}catch(Exception e){}
				
		try{
		BANKL =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_IFSC_CODE"));
		}catch(Exception e){}
		
		try{
		BANKN =checkNull(bankMasterRetObj.getFieldValueString(0,"EBM_AC_CODE"));
		}catch(Exception e){}
		
		try{
		ZTERMComp =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_TERMS"));
		}catch(Exception e){}
			
		try{
		ZWELS =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_PAY_METHOD"));
		}catch(Exception e){}
		
		try{
		CERDT =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_CREATION_DATE"));
		}catch(Exception e){}
		
		try{
		HBKID =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_HOUSE_BANK"));
		}catch(Exception e){}
		
		try{
		KALSK =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_SCHEMA_GROUP"));
		}catch(Exception e){}
		
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
input
{
	    border: none;
}
th
{
	    line-height: inherit;
	    padding-top: 12px;
}
td
{
	    line-height: inherit;	    
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
            Self Service > View 'Profile Change' Request > Vendor Request: <%=docIdStr%>
          </h4>
        </section>

        <!-- Main content -->  
        <section class="content">  
        <%
        if(!"".equals(docId))
{
%>
<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info ">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BASIC DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=right style="line-height: inherit;">Vendor Code</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  maxlength="10" required>
					</Td>
					
					<Th align=right style="line-height: inherit;">Vendor Name</Th>
					<Td colspan="4">
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  maxlength="35"><%=NAME1+NAME2%>
					
					</Td>
					<!--<Th align=right style="line-height: inherit;">Service Based</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>-->
					
				</Tr>				
				<Tr>
					<Th align=right style="line-height: inherit;">Company Code</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=BUKRS%>"  maxlength="4">
					</Td>
					<Th align=right style="line-height: inherit;">Service Based</Th>
					<Td colspan="4">
					<%
						String srvBasedStr="No";
						if("Y".equals(LEBRE))
						{
						srvBasedStr="Yes";
						}
					%><%=srvBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right style="line-height: inherit;">GR Based</Th>
					<Td colspan="4">
					<%
						String grBasedStr="No";
						if("Y".equals(WEBRE))
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

		<Div class="box box-info ">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>CONTACT DETAILS</Font></B></button>                
			</Div>
			
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th align=right  style="padding-top: 10px;line-height: inherit;">Title</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;"  value="<%=ANRED%>"  maxlength="4">
						<!--<select disabled name="titleSel" id="titleSel">
							<option value="<%=ANRED%>" selected><%=ANRED%></option>
							<option value="mrs.">mrs.</option>
							<option value="m/s">m/s</option>
						</select>					-->

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Name1</Th>
					<Td colspan="4">
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35"><%=NAME1%>

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Name2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
				</Tr>
				
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;" >Addr1 / H.No</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr1" id="addr1" value="<%=NAME3%>"  maxlength="10">

					</Td>

					<Th align=right style="padding-top: 10px;line-height: inherit;">Addr2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr2" id="addr2" value="<%=NAME4%>"  maxlength="10">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Street</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="street" id="street" value="<%=STRAS%>"  maxlength="60">
											
					</Td>
				</Tr>
				<Tr>
					
					<Th align=right style="padding-top: 10px;line-height: inherit;">City</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="city" id="city" value="<%=ORT01%>"  maxlength="35">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">State</Th>
					<Td colspan="4">
					<%
						statevalue ="";
						for (int j=0;j<StateCnt;j++)
						 {
							statekey = retState.getFieldValueString(j,"EMKV_VALUE");

							if(statekey.equals(REGIO))
							{
							statevalue = retState.getFieldValueString(j,"EMKV_VALUE1");
							break;
							}
						 }
					%>
			 <%=statevalue%>--
					<Input readonly  type="text" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
						<!--<select disabled  name="state" id="state">
							<option value="<%=REGIO%>" selected><%=REGIO%></option>
						</select>					-->

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Country</Th>
					<Td colspan="4">
				<%
					value="";
					for (int k=0;k<CountryCnt;k++) 
					{
							 key = checkNull(retCountry.getFieldValueString(k,"EMKV_KEY"));
							if(key.equals(LAND1))
							{
							 value = checkNull(retCountry.getFieldValueString(k,"EMKV_VALUE"));
							break;
							}
					}
				%>
				<%=value%>--
					<Input readonly  type="text" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						<!--<select disabled  name="country" id="country">	
							<option value="<%=LAND1%>" selected><%=LAND1%></option>
						</select>					-->

					</Td>
				</Tr>
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">District</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="district" id="district" value="<%=ORT02%>"  maxlength="20">
						<!--<select disabled  name="district" id="district">
							<option value="<%=ORT02%>" selected><%=ORT02%></option>
						</select>					-->

					</Td>

					<Th align=right style="padding-top: 10px;line-height: inherit;">PinCode</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pin" id="pin" value="<%=PSTLZ%>"  maxlength="10">

					</Td>
					</Tr>
					<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Landline</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="landline" id="landline" value="<%=TELF1%>"  maxlength="16">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Mobile</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="mobile" id="mobile" value="<%=TELF2%>"  maxlength="16">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Fax</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="fax" id="fax" value="<%=TELFX%>"  maxlength="31">
											
					</Td>
				</Tr>
				 <Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">EMail</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=SMTP_ADDR%>"  maxlength="241">
					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">EMail 2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=SMTP_ADDR2%>"  maxlength="241">
					</Td>
				</Tr>
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Contact Person 1</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=NAMEV%>"  maxlength="10">
					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Contact Person 2</Th>
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

		<Div class="box box-info ">
		<Div class="box-header ">
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>STATUTORY</Font></B></button>                
		</Div>
		<Div class="box-body" style="display: block;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody>
			<Tr>				
				<Th align=right  style="padding-top: 10px;line-height: inherit;">PAN<font size="2" color="red">*</font></Th>
				<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=J_1IPANNO%>"  maxlength="40">
				</Td>	
				<Th align=right style="padding-top: 10px;line-height: inherit;">GSTIN</Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="gst" id="gst" value="<%=EVEDGST%>"  maxlength="4">
				</Td>

				<Th align=right style="padding-top: 10px;line-height: inherit;">Classification</Th>
				<Td colspan="4">
					<Input type = 'hidden' name="classification" id="classification" value=""  maxlength="2">
					<Input readonly  type="text" style="text-transform: uppercase;" name="classification" id="classification" value="<%=EVEDCLASSI%>"  maxlength="2">
				</Td>
				
			</Tr>			
			<Tr>
				<Th align=right style="padding-top: 10px;line-height: inherit;">Category</Th>
				<Td colspan="4">
				<%	java.util.Hashtable minIndHT = new java.util.Hashtable();
																						  
					 for (int i=0;i<MinIndCnt;i++) 
					{

						 MinIndkey = checkNull(retMinInd.getFieldValueString(i,"EMKV_KEY"));
						 MinIndvalue = checkNull(retMinInd.getFieldValueString(i,"EMKV_VALUE"));
							minIndHT.put(MinIndkey,MinIndvalue);
							//out.println("<<<"+key+"<<<<<<"+minIndHT.get(MinIndkey));
					}

						String minInd =checkNull((String)minIndHT.get(MINDK));
						minInd = minInd.trim();
						//out.println(minInd+"<<<"+key+"<<<<<<"+minIndHT.get(LAND1));
				%>
			<%=minInd%>--
				<Input readonly  type="text" style="text-transform: uppercase;" name="minIndi" id="minIndi" value="<%=MINDK%>"  maxlength="2">
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
				</Td>
			
				<Th align=right style="padding-top: 10px;line-height: inherit;">
					Certification Date
				 </Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="creatDate" id="creatDate" value="<%=EVEDCERTIDATE%>" >
				
				</Td>
		</Tr>			
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>


<%
if(bankDtlsRetObj!=null)
{
	String BKREF= "";
	for(int i=0;i<bankDtlsRetObj.getRowCount();i++)
	{
	


		String keyStr = checkNull(bankDtlsRetObj.getFieldValueString(i,"EVBD_KEY"));
		BANKN = checkNull(bankDtlsRetObj.getFieldValueString(i,"EVBD_ACCOUNT_NUM"));

		int index = bankMasterRetObj.getRowId("EBM_KEY",keyStr);

		if(index>=0)
		{
			BANKL = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_KEY"));
			BANKS = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_COUNTRY_KEY"));
			BANKA = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_BANK_NAME"));
			PROVZ = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_REGION"));
			STRASBank = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_STREET"));
			ORT01Bank = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_CITY"));
			BRNCH = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_BRANCH"));
			BKREF = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_IFSC_CODE"));
			WAERS = checkNull(bankMasterRetObj.getFieldValueString(index,"EBM_CURRENCY"));

		}
		
		
%>
			<Div class="box box-info ">    
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK</Font></B></button>                
			</Div>	  
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Country
			</Th>
			<Td colspan="4">
<%
			value="";
		 	for (int k=0;k<CountryCnt;k++) 
			{
					 key = checkNull(retCountry.getFieldValueString(k,"EMKV_KEY"));
					if(key.equals(BANKS))
					{
					 value = checkNull(retCountry.getFieldValueString(k,"EMKV_VALUE"));
					break;
					}
			}
%>
			<%=value%>--
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCountry" id="bankCountry" value="<%=BANKS%>"  maxlength="3">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Bank Name
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=BANKA%>"  maxlength="60">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Region
			</Th>
			<Td colspan="4">
<%
				statevalue ="";
				for (int j=0;j<StateCnt;j++)
				 {
					statekey = retState.getFieldValueString(j,"EMKV_VALUE");

					if(statekey.equals(PROVZ))
					{
					statevalue = retState.getFieldValueString(j,"EMKV_VALUE1");
					break;
					}
				 }
%>
			 <%=statevalue%>--
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=PROVZ%>"  maxlength="3">

			</Td>

			</Tr>

			<Tr><Th align=right style="padding-top: 10px;line-height: inherit;">
				Street
			 </Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=STRASBank%>"  maxlength="35">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				City
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=ORT01Bank%>"  maxlength="35">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Branch
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=BRNCH%>"  maxlength="40">

			</Td>
			</Tr>
			<Tr>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				IFSC Code
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>"  maxlength="11">

			</Td>


			<Th align=right style="padding-top: 10px;line-height: inherit;">
				AC Code
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=BANKN%>"  maxlength="15">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Currency
			</Th>
			<Td colspan="4">
<%
			currvalue="";
			 for (int m=0;m<CurrCnt;m++) 
			{
				 currkey = retCurrency.getFieldValueString(m,"EMKV_KEY");
				 
				 if(currkey.equals(WAERS))
				 {
				 currvalue = retCurrency.getFieldValueString(m,"EMKV_VALUE");
				 break;
				 }
					
			}
%>
			<%=currvalue%>--				
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
<%
	}
}
%>


<%
	if(retVenComm.getRowCount()>0)
	{
%>
		<Div >            
	
		<Table class="table" style="width:100%">
		<thead>
			<th style="text-align:center;background-color: #59584c!important;color:white">Name</th>
			<th style="text-align:center;background-color: #59584c!important;color:white">Comments Date</th>
			<th style="text-align:center;background-color: #59584c!important;color:white">Comments</th>
	        
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
               <Div class="box box-info ">            
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>Comments</B><font color = red>*</font></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-8 col-md-offset-5" style="padding-right:3px;">
	<button type="button" class="btn btn-primary" onclick="funUploads()">View Uploads</button>
	<%
	//if("OPEN".equals(status))
	//{
	%>
	<button type="button" class="btn btn-primary" onclick="funDeleteRequest()">Delete Request</button>
	<%
	//}
	%>
</Div>	
	<%
	}else{
	%>
	<Div class="row">
		<Div class=" col-md-12 col-sm-12 col-xs-12"> 
			<Div class="box box-info>
			<Div class="box-body">
			There is no open request
			</Div>
			</Div>
		</Div>
	</Div>
	<%
	}
	%>
<script>
function funDeleteRequest()
{
	var wfStep = '<%=WFStep%>';
	if((wfStep)<3)
	{
		var flag= confirm("Are you sure to delete the request");
		if(flag)
		{
			document.myForm.action="ezDeleteRequest.jsp";
			document.myForm.submit();
		}
	}
	else
	{
		alert("Request in flow, cannot be deleted");
		return;
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
		margin : 200,
		width:'60%',
		height:300,
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
      
