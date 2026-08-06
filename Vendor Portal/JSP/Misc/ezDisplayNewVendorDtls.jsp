<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*,java.text.*" %>		
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
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
String vendType 		= checkNull(request.getParameter("vendType"));


//out.println("retCountry"+retCountry.toEzcString());
//out.println("retCurrency"+retCurrency.toEzcString());
//out.println("retState"+retState.toEzcString());
String syskey= "";
String template="";
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
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
			
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
	generalParams.setStatus("OPEN");
	generalParams.setVendor(vendor);
	
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
String purpose       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_PURPOSE"));
String searchTerm    =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_SEARCH_TERM"));
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
out.println("<<<<<<<<<"+REGIO);
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
String EKORG       =    checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_PUR_ORG"));
String grBased       =    checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_GR_INV_IND"));
String srvBased       =    checkNull(purchOrgRetObj.getFieldValueString(0,"EVPOD_SRV_INV_IND"));
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
String EVEDCLASSIDESC=EVEDCLASSI;
%>
<%


	Hashtable classHT = new Hashtable();

	classHT.put("01","Registered");
	classHT.put("02","Not Registered");
	classHT.put("03","Compounding Scheme");
	classHT.put("04","PSU/Government Organization");
	
	try{
	EVEDCLASSIDESC=(String)classHT.get(EVEDCLASSI);
	}catch(Exception e){}
	
	
vendor       =	checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_VENDOR"));

String defSoldTo    = "0000000000"+vendor; 	
	try{
	defSoldTo=defSoldTo.substring(vendor.length(),defSoldTo.length());
	}catch(Exception e){defSoldTo    = vendor; }
	
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
		SMTP_ADDR2 =checkNull(emailRetObj.getFieldValueString(0,"EVE_EMAIL"));
		}catch(Exception e){}
			out.println(SMTP_ADDR+"::::SMTP_ADDR"+SMTP_ADDR2);
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
		CERDT =checkNull(companyDataRetObj.getFieldValueString(0,"EVCD_CERTIFICATE_DATE"));
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
th
{
	font-size:small;
 	text-align: left;
 	
}
td
{
	font-size:small;
}
.table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {  
    line-height: inherit;
    width:150px;
}
input
{
	    border: none;
}
</style>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-10.min.js"></script>
</Head>
<script>
function funChange()
{
	var accountGrp = document.myForm.AcctGroup.value;
	if(accountGrp=="")
	{
		alert("Please select Account Group");
		document.myForm.AcctGroup.focus();
		return false;
	}
	else{
	$.ajax({
		url: "ezGetAccountGrpReconMapping.jsp?accountGrp="+accountGrp, 
		type: "POST",    
		dataType:"json",   
		error: function (response) 
		{ 
			var text=response.responseText;
			alert("Error occurred while getting delivery details from SAP");
		},
		success: function (response) 
		{
		
			var selectbox = $('#ReconAcct');
			selectbox.empty();
			var list = '<option value="">---Select Recon Account---</option>';		

			$.each(response, function (key,value)
			{
			           list += "<option value='" +value.reconAAccountCode+ "'>"+value.reconAAccountDesc+" [" +value.reconAAccountCode+ "]</option>";
			});
			selectbox.html(list);
		}
	});

	}
	
}
function funClick(){
var value = $("#accountGrpReconAcct").val();

		var url = "ezGetAccountGrpReconMapping.jsp?"+value;
		$("#accountGrpReconAcct").autocomplete({
			source:url,
			delay:100,
			minLength:1,
			change:function( event, ui )
			{
				var data=$.data(this);//Get plugin data for 'this'
			
				
			},
			select: function( event, ui )
			{			
				//alert("::::ui:::::::"+ui.item.key);
				var key=ui.item.key;
				document.myForm.AcctGroup.value=key.split("-")[0];
				document.myForm.ReconAcct.value=key.split("-")[1];
				
				$( "#accountGrpReconAcct").val(ui.item.accountGrp+" / " + ui.item.reconAAccount);
				return false;
			}
		}).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
		
			return $( "<li></li>" )
				.data( "item.autocomplete", item )
				.append( "<a><strong> "+item.accountGrp+" / " + item.reconAAccount + "</strong></a>" )
				.appendTo( ul );

		};
		}
	$(document).ready(function(){
		$(function() { 		
			$("#agr").autocomplete("list.jsp"); 
		});
	});
	
	
</script>
<Body>
 <form method="post"  name="myForm">
<input type="hidden" name="docId" value="<%=docId%>">
<input type="hidden" name="defSoldTo" value="<%=defSoldTo%>">
<input type="hidden" name="SAPUSER" value="">
<input type="hidden" name="SAPPASSWORD" value="">
<input type="hidden" name="purchOrg" value="<%=checkNull(generalDataRetObj.getFieldValueString(0,"EVGD_ADDR_NR"))%>">
<input type="hidden" name="docSysKey" value="<%=docSysKey%>">
<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h4>
            Vendor Request: <%=docIdStr%></h4>
            <%
		if("MDM".equals(userRole))
		{
		%>

            <br>
            
	                <B><Font size=4 color=BLACK>Account Group</Font></B>
	                  
              &nbsp;&nbsp;&nbsp;&nbsp;
              <select name="AcctGroup" id="AcctGroup" style="width:25%" onchange="funChange()">
			<option value="">---Select Account Group---</option>
			<%
			for(int i=0;i<AcctGroupCnt;i++)
			{
				String DBkey = checkNull(retAcctGroup.getFieldValueString(i,"EMKV_KEY"));
				String DBvalue = checkNull(retAcctGroup.getFieldValueString(i,"EMKV_VALUE"));
			%>
			<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
			<%
			}
			%>
		</select>
		
		&nbsp;&nbsp;&nbsp;&nbsp;
		
			 <B><Font size=4 color=BLACK>Recon Account</Font></B>

	      &nbsp;&nbsp;&nbsp;&nbsp;
	      <select name="ReconAcct" id="ReconAcct" style="width:25%">
			<option value="">---Select Recon Account---</option>
			<%
			for(int i=0;i<ReconAcctCnt;i++)
			{
				String DBkey = checkNull(retReconAcct.getFieldValueString(i,"EMKV_KEY"));
				String DBvalue = checkNull(retReconAcct.getFieldValueString(i,"EMKV_VALUE"));
			%>
			<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
			<%
			}
			%>
	</select>
		
		<br><br>
			 <B><Font size=4 color=BLACK>Payment Mode</Font></B>

	      &nbsp;&nbsp;&nbsp;&nbsp;
	     <select name="PaymentMode" id="PaymentMode" style="width:25%">
				<option value="">---Select Payment Mode---</option>
				<%
				for(int i=0;i<PaymentModeCnt;i++)
				{
					String DBkey = checkNull(retPaymentMode.getFieldValueString(i,"EMKV_KEY"));
					String DBvalue = checkNull(retPaymentMode.getFieldValueString(i,"EMKV_VALUE"));
				%>
					<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
				<%
				}
				%>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
			<B><Font size=4 color=BLACK>Serach Term</Font></B>		
			      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
			<Input  type="text"   name="scTerm" id="scTerm" value="<%=searchTerm%>"  maxlength="15" >	
			<br><br>
			 <B><Font size=4 color=BLACK>Schema Group</Font></B>

	      &nbsp;&nbsp;&nbsp;&nbsp;
	     <select name="schemaGroup" id="schemaGroup" style="width:25%">
				<option value="">---Select Schema Group---</option>
				<%
				for(int i=0;i<SchemaCnt;i++)
				{
					String DBkey = checkNull(retSchema.getFieldValueString(i,"EMKV_KEY"));
					String DBvalue = checkNull(retSchema.getFieldValueString(i,"EMKV_VALUE"));
				%>
					<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
				<%
				}
				%>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;
					
			<br><br>
			
			
					
		<%
		}
		%>
          
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
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B><Font size=2 color=BLACK>PURPOSE</Font></B></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="1" name="purpose" id="purpose"  disabled><%=purpose%></textarea>
	       		       </div>
               </Div>	
		<Div class="box box-info ">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BASIC DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=left>Vendor Code<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  maxlength="10" required>
					</Td>
					<Th align=left>Vendor Name<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  maxlength="35">
					
					</Td>
					
					<!--<Th align=right>Service Based<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>-->
					
				</Tr>				
				<Tr>
					<Th align=right>Company Code<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=BUKRS%>"  maxlength="4">
					</Td>
					<Th align=right>Service Based<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<%
						String srvBasedStr="No";
						if("Y".equals(srvBased))
						{
						srvBasedStr="Yes";
						}
						%>
					<%=srvBasedStr%>
						<Input readonly  type="tehiddenxt" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=srvBased%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right>GR Based<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<%
					String grBasedStr="No";
					if("Y".equals(grBased))
					grBasedStr="Yes";
					
					%>
					<%=grBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="grBased" id="grBased" value="<%=grBased%>"  maxlength="1">

					</Td>
				</Tr>
				<%
				if("MDM".equals(userRole))
				{
				%>
				<!--<Tr>
					<Th align=left>Account group<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<select name="AcctGroup" id="AcctGroup">
						<option value="">---Select Account Group---</option>
						<%
						for(int i=0;i<AcctGroupCnt;i++)
						{
							String DBkey = checkNull(retAcctGroup.getFieldValueString(i,"EMKV_KEY"));
							String DBvalue = checkNull(retAcctGroup.getFieldValueString(i,"EMKV_VALUE"));
						%>
							<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
						<%
						}
						%>
						</select>
					</Td>
					<Th align=right>Recon Account<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<select name="ReconAcct" id="ReconAcct">
							<option value="">---Select Recon Account---</option>
							<%
							for(int i=0;i<ReconAcctCnt;i++)
							{
								String DBkey = checkNull(retReconAcct.getFieldValueString(i,"EMKV_KEY"));
								String DBvalue = checkNull(retReconAcct.getFieldValueString(i,"EMKV_VALUE"));
							%>
								<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
							<%
							}
							%>
						</select>
					</Td>	
					</Tr>
					<Tr>
					<Th align=right>Mode Of Payment<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<select name="PaymentMode" id="PaymentMode">
							<option value="">---Select Payment Mode---</option>
							<%
							for(int i=0;i<PaymentModeCnt;i++)
							{
								String DBkey = checkNull(retPaymentMode.getFieldValueString(i,"EMKV_KEY"));
								String DBvalue = checkNull(retPaymentMode.getFieldValueString(i,"EMKV_VALUE"));
							%>
								<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
							<%
							}
							%>
						</select>

					</Td>
					<Th align=right>Company Code<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<select name="CompanyCode" id="CompanyCode">
							<option value="">---Select Company Code---</option>
							<%
							for(int i=0;i<CompanyCodeCnt;i++)
							{
								String DBkey = checkNull(retCompanyCode.getFieldValueString(i,"EMKV_KEY"));
								String DBvalue = checkNull(retCompanyCode.getFieldValueString(i,"EMKV_VALUE"));
							%>
								<option value="<%=DBkey%>"><%=DBvalue%>[<%=DBkey%>]</option>
							<%
							}
							%>
						</select>
					
					</Td>
				</Tr>-->
					<%
					
					}
					%>
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
					<Th>Title<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<Input readonly  type="text" name="titleSel" style="text-transform: uppercase;"  value="<%=ANRED%>"  maxlength="4">
						<!--<select disabled name="titleSel" id="titleSel">
							<option value="<%=ANRED%>" selected><%=ANRED%></option>
							<option value="mrs.">mrs.</option>
							<option value="m/s">m/s</option>
						</select>					-->

					</Td>
					<Th>Name1<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35">

					</Td>
					<Th>Name2<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr1" id="addr1" value="<%=NAME3%>"  maxlength="10">

					</Td>

					<Th>Addr2<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr2" id="addr2" value="<%=NAME4%>"  maxlength="10">

					</Td>
					<Th>Street<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="street" id="street" value="<%=STRAS%>"  maxlength="60">
											
					</Td>
				</Tr>
				<Tr>
					
					<Th>City<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="city" id="city" value="<%=ORT01%>"  maxlength="35">

					</Td>
					<Th>State<font size="2" color="red"></font></Th>
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
			 <%=statevalue%>--<%=REGIO%>					
					<Input readonly  type="hidden" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
						<!--<select disabled  name="state" id="state">
							<option value="<%=REGIO%>" selected><%=REGIO%></option>
						</select>					-->

					</Td>
					<Th>Country<font size="2" color="red"></font></Th>
					<Td>
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
			<%=value%>--<%=LAND1%>
					<Input readonly  type="hidden" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						<!--<select disabled  name="country" id="country">	
							<option value="<%=LAND1%>" selected><%=LAND1%></option>
						</select>					-->

					</Td>
				</Tr>
				<Tr>
					<Th>District<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="district" id="district" value="<%=ORT02%>"  maxlength="20">
						<!--<select disabled  name="district" id="district">
							<option value="<%=ORT02%>" selected><%=ORT02%></option>
						</select>					-->

					</Td>

					<Th>PinCode<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pin" id="pin" value="<%=PSTLZ%>"  maxlength="10">

					</Td>
					</Tr>
					<Tr>
					<Th>Landline<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="landline" id="landline" value="<%=TELF1%>"  maxlength="16">

					</Td>
					<Th>Mobile<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="mobile" id="mobile" value="<%=TELF2%>"  maxlength="16">

					</Td>
					<Th>Fax<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="fax" id="fax" value="<%=TELFX%>"  maxlength="31">
											
					</Td>
				</Tr>
				 <Tr>
					<Th>EMail<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=SMTP_ADDR%>"  maxlength="241">
					</Td>
					<Th>EMail2<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email2" id="email2" value="<%=SMTP_ADDR2%>"  maxlength="241">
					</Td>					
				</tr>
				<tr>
					<Th>Contact Person 1<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=NAMEV%>"  maxlength="10">
					</Td>
					<Th>Contact Person 2<font size="2" color="red"></font></Th>
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
				<Th>PAN<font size="2" color="red"></font></Th>
				<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=J_1IPANNO%>"  maxlength="40">
				</Td>
			
				<Th>GSTIN</Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="gst" id="gst" value="<%=EVEDGST%>"  maxlength="4">
				</Td>
				<Th>Classification</Th>
				<Td colspan="4">					
					<Input readonly  type="hidden" style="text-transform: uppercase;" name="classification" id="classification" value="<%=EVEDCLASSI%>"  maxlength="2"><%=EVEDCLASSIDESC%>--<%=EVEDCLASSI%>
				</Td>
			</Tr>			
			<Tr>
				<Th>Category</Th>
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
			<%=minInd%>--<%=MINDK%>
				<Input readonly  type="hidden" style="text-transform: uppercase;" name="minIndi" id="minIndi" value="<%=MINDK%>"  maxlength="2">
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
				</Td>
				
				
									
			
				<Th>
					Certification Date<font size="2" color="red"></font>
					</Th>
					<Td colspan="4">
					<Input readonly  type="hidden"   name="cDate" id="cDate" value="<%=CERDT%>"  maxlength="4"><%=CERDT%>
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
			<Th>
				Country<font size="2" color="red"></font>
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
			<%=value%>--<%=BANKS%>
			<Input readonly  type="hidden" style="text-transform: uppercase;" name="bankCountry" id="bankCountry" value="<%=BANKS%>"  maxlength="3">

			</Td>
			<Th>
				Bank Name<font size="2" color="red"></font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=BANKA%>"  maxlength="60">

			</Td>
			<Th>
				Region<font size="2" color="red"></font>
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
			 <%=statevalue%>--<%=PROVZ%>
			<Input readonly  type="hidden" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=PROVZ%>"  maxlength="3">

			</Td>

			</Tr>

			<Tr><Th>
				Street<font size="2" color="red"></font>
			 </Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=STRASBank%>"  maxlength="35">

			</Td>
			<Th>
				City<font size="2" color="red"></font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=ORT01Bank%>"  maxlength="35">

			</Td>
			<Th>
				Branch<font size="2" color="red"></font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=BRNCH%>"  maxlength="40">

			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red"></font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>"  maxlength="11">

			</Td>


			<Th>
				AC Code<font size="2" color="red"></font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=BANKN%>"  maxlength="15">

			</Td>
			<Th>
				Currency<font size="2" color="red"></font>
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
			<%=currvalue%>--<%=WAERS%>				
			<Input readonly  type="hidden" style="text-transform: uppercase;" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>"  maxlength="3">
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

	if(retVenComm.getRowCount()>0)
	{
%>
		<Div>            
			 <Table class="table" style="width:100%">
			<thead>
				<th style="text-align:center;background-color: #f39c12 !important">Name</th>
				<th style="text-align:center;background-color: #f39c12 !important">Comments Date</th>
				<th style="text-align:center;background-color: #f39c12 !important">Comments</th>
				        
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
   
<%
if(!"CLOSED".equals(status) && !"POSTED".equals(status))
{
%>
               <Div class="box box-info ">            
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>COMMENTS</B><font color = red></font></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>
<%
}
%>
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-8 col-md-offset-4" >
	<button type="button" class="btn btn-primary" onclick="history.go(-1)">Back</button> 
	<!--<button type="button" class="btn btn-primary" onclick="funUploads()">View Uploads</button>-->
	<button type="button" class="btn btn-primary" onclick="funEditUploads()">View/Add Uploads</button>
	
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
<input type="hidden" name="docStatus">	
<input type="hidden" name="vendType" id="vendType" value=<%=vendType%> />
<input type="hidden" name="attachFlag" value ="N" >
<input type="hidden" name="attachDocDesc" value ="" >	
<input type="hidden" name="attachFileTime" value ="" >	
<input type="hidden" name="attachDocFiles" value ="" >

 </section><!-- /.content -->
      </Div><!-- /.content-wrapper --> 

	</form>
	</Body>
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

if(document.myForm.AcctGroup.value=="")
	{
		alert("Please select Account Group");
		document.getElementById("AcctGroup").focus();
		return false;
	}
	if(document.myForm.ReconAcct.value=="")
	{
			alert("Please select Recon Account");
			document.getElementById("ReconAcct").focus();
			return false;
	}
	if(document.myForm.PaymentMode.value=="")
	{
			alert("Please select Payment Mode");
			document.getElementById("PaymentMode").focus();
			return false;
	}
	if(document.myForm.scTerm.value=="")
	{
				alert("Please Enter Search Term");
				document.getElementById("scTerm").focus();
				return false;
	}
	if(document.myForm.comments.value=="")
	{
			alert("Please enter comments to post details to SAP");
			document.getElementById("comments").focus();
			return false;
	}
	if(document.myForm.schemaGroup.value=="")
	{
			alert("Please select Schema Group");
			document.getElementById("schemaGroup").focus();
			return false;
	}
	
	$.confirm({
		title: 'Enter SAP Login Credentials',
		content: '<table class="table"><tr><th>User Id:</th><td><input type="text" name="SAPUserId" id="SAPUserId" value="cfhogn05" placeholder="User Id" autocomplete="off" autofocus></td></tr><tr><th>Password:</th><td><input type="password" name="SAPPassword" id="SAPPassword" value="venport@17" autocomplete="new-password" placeholder="Password"></td></tr></table>',
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
					document.myForm.action="ezCreateVendorInSAP.jsp";
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
function funEditUploads()
{
	var Url="../Shipment/ezEditUploads.jsp?docId=<%=docId%>";
	
	$.fancybox.open({
			href : Url,
			type : 'iframe',
			padding : 5,
			width:'50%',
			height:'470px',
			autoSize : false,
			closeBtn : true,
			helpers     : {  
					overlay : {closeClick: false}
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


       

</Html>
 <%@ include file="ezFooter.jsp"%>
  <link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
  <script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>
      
 <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/jQuery-10.min.css" type="text/css" media="screen" />  

