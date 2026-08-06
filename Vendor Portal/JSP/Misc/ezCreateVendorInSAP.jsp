<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*,java.text.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoDestinationManager" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.ext.DestinationDataProvider" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%>    
  <%@ include file="ezHeader.jsp"%> 
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>	
<%
//out.println("<<<"+key+"<<<"+value+"<<<"+value);
%>

<%  
	String comments  	 = checkNull(request.getParameter("comments"));
	
	comments=comments.replaceAll("'","`");

	String SAPUserId	= checkNull(request.getParameter("SAPUSER")); 	
	String SAPPassword      = checkNull(request.getParameter("SAPPASSWORD")); 
	
	ezc.ezcommon.EzLog4j.log(SAPUserId+":::::::::SAPUserId:::::::::","I");
	ezc.ezcommon.EzLog4j.log(SAPPassword+"::::::::SAPPassword::::::::","I");
	
	
	Hashtable stateHT= new Hashtable();
	String usrId	=	"xyz";
	String selected="";
	String titleSelArr[] = {"Mr.","M/S.","Ms.", "Company", "Mr. and Mrs." };
	
	String vendorProfileId= checkNull(request.getParameter("docId")); 	
	String defSoldTo    = checkNull(request.getParameter("defSoldTo")); 	
	String vendCode = "";//checkNull(request.getParameter("vendCode"));
	String compCode = checkNull(request.getParameter("compCode"));
	String serBased = checkNull(request.getParameter("serBased"));
	String venName  = checkNull(request.getParameter("venName"));
	String corLoc   = checkNull(request.getParameter("corLoc"));
	String grBased  = checkNull(request.getParameter("grBased"));
	String purchOrg  = checkNull(request.getParameter("purchOrg"));
	String cDateStr  = checkNull(request.getParameter("cDate"));
	
	String titleSel = checkNull(request.getParameter("titleSel"));
	String name1    = checkNull(request.getParameter("name1"));
	String name2 	= checkNull(request.getParameter("name2"));
	String addr1 	= checkNull(request.getParameter("addr1"));
	String addr2 	= checkNull(request.getParameter("addr2"));
	String street	= checkNull(request.getParameter("street"));
	String city 	= checkNull(request.getParameter("city"));
	String state 	= checkNull(request.getParameter("state"));
	String country	= checkNull(request.getParameter("country"));
	String district = checkNull(request.getParameter("district"));
	String pin 	= checkNull(request.getParameter("pin"));
	String landline = checkNull(request.getParameter("landline"));
	String mobile	= checkNull(request.getParameter("mobile"));
	String fax 	= checkNull(request.getParameter("fax"));
	String email 	= checkNull(request.getParameter("email"));
	String email2 	= checkNull(request.getParameter("email2"));
	String contPers1= checkNull(request.getParameter("contPers1"));
	String contPers2= checkNull(request.getParameter("contPers2"));
	String vat   	= checkNull(request.getParameter("vat"));
	String cst   	= checkNull(request.getParameter("cst"));
	String pan   	= checkNull(request.getParameter("pan"));
	String servTax  = checkNull(request.getParameter("servTax"));
	String eccNo   	= checkNull(request.getParameter("eccNo"));
	String excRegNo = checkNull(request.getParameter("excRegNo"));
	String rangeSel = checkNull(request.getParameter("rangeSel"));
	String exDiv   	= checkNull(request.getParameter("exDiv"));
	String commi   	= checkNull(request.getParameter("commi"));
	String minIndi 	= checkNull(request.getParameter("minIndi"));
	String gst 	= checkNull(request.getParameter("gst"));
	String classification 	= checkNull(request.getParameter("classification"));
	
	String bankCountry[] = request.getParameterValues("bankCountry");
	String bankIndex[] = request.getParameterValues("bankIndex");
	String bankName[]    = request.getParameterValues("bankName");
	String bankRegion[]  = request.getParameterValues("bankRegion");
	String bankStreet[]  = request.getParameterValues("bankStreet");
	String bankCity[]    = request.getParameterValues("bankCity");
	String bankBranch[]  = request.getParameterValues("bankBranch");
	String bankIFSCCode[]= request.getParameterValues("bankIFSCCode");
	String bankACCode[]  = request.getParameterValues("bankACCode");
	String bankCurrency[]= request.getParameterValues("bankCurrency");
	String bankKey[]= request.getParameterValues("bankKey");
	
	String pTerms 	   = checkNull(request.getParameter("pTerms"));
	String paymMethod  = checkNull(request.getParameter("paymMethod"));
	String creatDate   = checkNull(request.getParameter("creatDate"));
	String houseBank   = checkNull(request.getParameter("houseBank"));
	String schemaGroup = checkNull(request.getParameter("schemaGroup"));
	String reconAcct = checkNull(request.getParameter("ReconAcct"));
	String paymentMode = checkNull(request.getParameter("PaymentMode"));
	String AcctGroup = checkNull(request.getParameter("AcctGroup"));
	String CompanyCode = "CFL";//checkNull(request.getParameter("CompanyCode"));
	String scTerm = checkNull(request.getParameter("scTerm"));
	
	
	
	JCO.Client client1=null;
JCO.Function function = null;
boolean errorOccured=false;

String dispMessage="Problem occured while posting vendor details to SAP.",dispMsgType="E",divWidth="90%";

try
	{
		ReturnObjFromRetrieve retuser_groups	=  null;
		int   user_groupsCnt	=  0;
		ezc.ezparam.EzcParams mainParams_user_groups	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams_user_groups = new EziMiscParams();
		miscParams_user_groups.setQuery("Select * From Ezc_User_Groups Where Eug_Id='999'");
		mainParams_user_groups.setLocalStore("Y");
		mainParams_user_groups.setObject(miscParams_user_groups);
		Session.prepareParams(mainParams_user_groups);

		try
		{
			retuser_groups=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_user_groups);
		}
		catch(Exception e)
		{
		ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}
		if(retuser_groups!=null)
		user_groupsCnt=retuser_groups.getRowCount();
		
		String eugID 	= retuser_groups.getFieldValueString(0,"EUG_ID");
		String hostIP 	= retuser_groups.getFieldValueString(0,"EUG_R3_HOST");
		String r3Lang 	= retuser_groups.getFieldValueString(0,"EUG_R3_LANG");
		String r3Client = retuser_groups.getFieldValueString(0,"EUG_R3_CLIENT");
		String r3Userid = retuser_groups.getFieldValueString(0,"EUG_R3_USER_ID");
		String r3Passwd = retuser_groups.getFieldValueString(0,"EUG_R3_PASSWD");
		String r3SysNo = retuser_groups.getFieldValueString(0,"EUG_R3_SYS_NO");
		//String lang = retuser_groups.getFieldValueString(0,"EUG_R3_LANG");
		//out.println(eugID+"::::::::"+hostIP+"::::::::"+r3Lang+"::::::::"+r3Client+"::::::::"+r3Userid+"::::::::"+r3Passwd+"::::::::");
        
		//client1 = EzSAPHandler.getSAPConnection("200~999");
		//function = EzSAPHandler.getFunction("Z_EZ_GET_VENDOR_CREATE","200~999");
		
	client1 = JCO.createClient(r3Client, 		// SAP client
			SAPUserId, 	// userid
			SAPPassword, 	// password
			r3Lang, 		
			hostIP,    
			r3SysNo); 	



			client1.connect();
			JCO.Repository mRepository = new JCO.Repository("REP123", client1);

			function = new JCO.Function((mRepository).getFunctionTemplate("Z_EZ_GET_VENDOR_CREATE"));
			
		JCO.ParameterList impParam = function.getImportParameterList();
		
		JCO.Table vendDataTable  	= function.getTableParameterList().getTable("VENDOR_DATA");	      
		JCO.Table statutaryTable  	= function.getTableParameterList().getTable("STATUTARY_DATA");	      
		JCO.Table contactInfoTable  	= function.getTableParameterList().getTable("CONTACT_INFO");	      
		JCO.Table vendBanksTable  	= function.getTableParameterList().getTable("VENDOR_BANKS");	      
		JCO.Table bankAddressTable  	= function.getTableParameterList().getTable("BANK_ADDRESS");
		JCO.Table vendEmailsTable  	= function.getTableParameterList().getTable("VEND_EMAILS");	
		JCO.Table reconAccountTable  	= function.getTableParameterList().getTable("RECON_ACCT");
		JCO.Table minorityTable  	= function.getTableParameterList().getTable("CURR_MINORITY");
		
		impParam.setValue(CompanyCode,"COMP_DATA");
		impParam.setValue(purchOrg,"PUR_ORG");
		impParam.setValue(AcctGroup,"ACCOUNT_GROUP");
		
		ezc.ezcommon.EzLog4j.log(":::::::CompanyCode::::::"+CompanyCode,"I");
		ezc.ezcommon.EzLog4j.log(":::::::purchOrg::::::"+purchOrg,"I");
		ezc.ezcommon.EzLog4j.log(":::::::AcctGroup::::::"+AcctGroup,"I");
		
		minorityTable.appendRow();
		if(bankCurrency!=null)
		minorityTable.setValue(bankCurrency[0],"WAERS");
		minorityTable.setValue(schemaGroup,"KALSK");
		minorityTable.setValue(purchOrg,"EKORG");
		minorityTable.setValue(grBased,"WEBRE");
		minorityTable.setValue(serBased,"LEBRE");
		
		ezc.ezcommon.EzLog4j.log(":::::::minorityTable::::::"+minorityTable,"I");
		
		Date cDate = new Date();
		try{
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		cDate = formatter.parse(cDateStr);
		}catch(Exception e){cDate = new Date();}
				
		reconAccountTable.appendRow();
		reconAccountTable.setValue(compCode,"BUKRS");
		reconAccountTable.setValue(reconAcct,"AKONT");
		reconAccountTable.setValue(paymentMode,"ZWELS");
		reconAccountTable.setValue(minIndi,"MINDK");
		reconAccountTable.setValue(cDate,"CERDT");
		
		ezc.ezcommon.EzLog4j.log(cDate+":::::::reconAccountTable::::::"+reconAccountTable,"I");		
		
		vendDataTable.appendRow();
		vendDataTable.setValue("EN","SPRAS");
		vendDataTable.setValue(name1,"NAME1");
		vendDataTable.setValue(name2,"NAME2");
		vendDataTable.setValue(addr1 ,"NAME3");
		vendDataTable.setValue(addr2 ,"NAME4");
		vendDataTable.setValue(titleSel ,"ANRED");
		vendDataTable.setValue(city ,"ORT01");
		vendDataTable.setValue(district,"ORT02");
		vendDataTable.setValue(state,"REGIO");
		//vendDataTable.setValue("PSTL2","PSTL2");
		vendDataTable.setValue(street,"STRAS");
		vendDataTable.setValue(country,"LAND1");
		//vendDataTable.setValue(vat,"STCEG");
		vendDataTable.setValue(fax,"TELFX");
		//vendDataTable.setValue(mobile,"TELF1");
		vendDataTable.setValue(landline,"TELF1");
		vendDataTable.setValue(mobile,"TELF2");
		vendDataTable.setValue(pin,"PSTLZ");
		vendDataTable.setValue(gst,"STCD3"); 
		//vendDataTable.setValue("ADRNR","ADRNR");
		//vendDataTable.setValue("WERKS","WERKS");
		vendDataTable.setValue(scTerm,"SORTL");
		
		ezc.ezcommon.EzLog4j.log(":::::::vendDataTable::::::"+vendDataTable,"I");		
		
		statutaryTable.appendRow();
		//statutaryTable.setValue(cst,"J_1ICSTNO");
		statutaryTable.setValue(pan,"J_1IPANNO");
		statutaryTable.setValue(servTax,"J_1ISERN");
		statutaryTable.setValue(eccNo,"J_1IEXCD");
		statutaryTable.setValue(excRegNo,"J_1IEXRN");
		statutaryTable.setValue(rangeSel,"J_1IEXRG");
		statutaryTable.setValue(exDiv,"J_1IEXDI");
		statutaryTable.setValue(commi,"J_1IEXCO");
		if(!classification.equals(""))
		statutaryTable.setValue(Integer.parseInt(classification)+"","VEN_CLASS");
		
		ezc.ezcommon.EzLog4j.log(classification+"::::classification:::statutaryTable::::::"+statutaryTable,"I");		
		
		contactInfoTable.appendRow();
		contactInfoTable.setValue(contPers1,"NAMEV");					
		contactInfoTable.setValue(contPers1,"NAME1");
		
		if(!"".equals(contPers2))
		{
		contactInfoTable.appendRow();
		contactInfoTable.setValue(contPers2,"NAMEV");					
		contactInfoTable.setValue(contPers2,"NAME1");
		}
		//contactInfoTable.setValue(contPers1,"TELF1");
		
		ezc.ezcommon.EzLog4j.log(":::::::contactInfoTable::::::"+contactInfoTable,"I");		
		
		if((bankACCode!=null))
		{
			for(int k=0;k<bankACCode.length;k++)
			{
				
				bankAddressTable.appendRow();
				try{
				if(bankCountry!=null)
				bankAddressTable.setValue(bankCountry[k],"BANKS");
				}catch(Exception e){}
				try{
				if(bankName!=null)
				bankAddressTable.setValue(bankName[k],"BANKA");
				}catch(Exception e){}
				try{
				if(bankRegion!=null)
				bankAddressTable.setValue(bankRegion[k],"PROVZ");
				}catch(Exception e){}
				if(bankStreet!=null)
				bankAddressTable.setValue(bankStreet[k],"STRAS");
				if(bankCity!=null)
				bankAddressTable.setValue(bankCity[k],"ORT01");     
				try{
				if(bankBranch!=null)
				bankAddressTable.setValue(bankBranch[k],"BRNCH");
				}catch(Exception e){}
				try{
				if(defSoldTo!=null)
				bankAddressTable.setValue((defSoldTo)+(k+1),"BANKL");
				}catch(Exception e){}
				
				try{
				if(bankIFSCCode!=null)
				bankAddressTable.setValue(bankIFSCCode[k],"SWIFT");
				}catch(Exception e){}
				
				try{
				if(bankACCode!=null)
				bankAddressTable.setValue(bankACCode[k],"BNKLZ");
				}catch(Exception e){}

				vendBanksTable.appendRow();
				if(bankACCode!=null)
				{
					try{
					vendBanksTable.setValue(bankACCode[k],"BANKN");
					}catch(Exception e){}
					try{
					vendBanksTable.setValue((k+1)+"","BKONT");
					vendBanksTable.setValue(bankCountry[k],"BANKS");
					vendBanksTable.setValue((defSoldTo)+(k+1),"BANKL");
					}catch(Exception e){}
				}
			}
			ezc.ezcommon.EzLog4j.log(":::::::bankAddressTable::::::"+bankAddressTable,"I");		
			ezc.ezcommon.EzLog4j.log(":::::::vendBanksTable::::::"+vendBanksTable,"I");		
		}
		
		vendEmailsTable.appendRow();
		if(!"".equals(email))
		vendEmailsTable.setValue(email,"SMTP_ADDR");
		
		if(!"".equals(email2))
		{
			vendEmailsTable.appendRow();
			vendEmailsTable.setValue(email2,"SMTP_ADDR");				
		}
		ezc.ezcommon.EzLog4j.log(":::::::vendEmailsTable::::::"+vendEmailsTable,"I");
		try
		{
			//function.execute(destination);

			client1.execute(function);
		}
		catch(Exception e)
		{
			 errorOccured = true;
			ezc.ezcommon.EzLog4j.log("::::::Exception while executing Z_EZ_GET_VENDOR_CREATE::::::"+e,"E");
		}
		
		
		com.sap.mw.jco.JCO.ParameterList expParam = function.getExportParameterList();
		vendCode=checkNull((String)expParam.getValue("VENCODE"));
		ezc.ezcommon.EzLog4j.log("::::::new vendor created with number :::::::::"+vendCode,"I");
		JCoTable retTable  = function.getTableParameterList().getTable("RETURN");	      	
		int retCount         = retTable.getNumRows();				
		ezc.ezcommon.EzLog4j.log("::::::retTable:::::::::"+retTable,"I");
		if(retCount > 0)
		{
			int i=0;
			do
			{
				
				String  msgType       =  (String)retTable.getValue("TYPE");
				String  msgStr       =  (String)retTable.getValue("MESSAGE");
				
				if("E".equals(msgType))
				{
				i=i+1;
				 errorOccured = true;
				 if(i==1)dispMessage=dispMessage+"<br>";
				dispMessage=dispMessage+"<br><b>"+i+")"+msgStr+"</b>";
				
				}
				
			}						 
			while(retTable.nextRow());			 
		}
		
		
		

ezc.ezcommon.EzLog4j.log("::::::vendCode::::::"+vendCode,"I");
}
catch(Exception e){
		 errorOccured = true;
		ezc.ezcommon.EzLog4j.log("::::::Exception in Z_EZ_GET_VENDOR_CREATE::::::"+e,"E");
	}finally
	{
		if (client1!=null)
		{
			JCO.releaseClient(client1);
			client1 = null;
			function=null;

		}
	}
	
	try{
	String vendCode1 = Integer.parseInt(vendCode)+"";
	}catch(Exception e){vendCode="";}

	if(!"".equals(vendCode))
	{
		ezc.ezcommon.EzLog4j.log("::::::vendCode after try block::::::"+vendCode,"I");
		dispMessage="Request <b>"+vendorProfileId+"</b> has been Posted to SAP with new vendor code <b>"+vendCode+" </b>";
		dispMsgType="S";
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
		EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();

		keyParams.setKey("UpdateRequestStatus");
		keyTableParams.appendRow(keyParams);
		mainParams.setLocalStore("Y");

		generalParams.setDocId(vendorProfileId);
		generalParams.setModifiedBy(Session.getUserId());
		generalParams.setVendor(Integer.parseInt(defSoldTo)+"");
		generalParams.setStatus("CLOSED");
		generalParams.setExt1(",EVGD_ACC_GRP='"+AcctGroup+"',EVGD_SEARCH_TERM='"+scTerm+"',EVGD_RECON_ACCOUNT='"+reconAcct+"',EVGD_PAYMENT_METHOD='"+paymentMode+"',EVGD_SAP_VENDOR='"+vendCode+"'");
		

		mainParams.setObject(keyTableParams);	

		mainParams.setObject(generalParams);
		Session.prepareParams(mainParams);

		try{
		 vendorprofile.ezUpdateDetails(mainParams);
		 	
		}catch(Exception e){out.println(e);}
		
		
		mainParams	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();
		miscParams.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_WF_STATUS='POSTEDTOSAP', EWDHH_MODIFIED_BY='"+Session.getUserId()+"', EWDHH_MODIFIED_ON=now(), EWDHH_CURRENT_STEP='1',EWDHH_NEXT_PARTICIPANT='',EWDHH_PARTICIPANT_TYPE='G',EWDHH_REF1='NO-CHANGE',EWDHH_REF2=CONCAT(EWDHH_REF2,'-->"+Session.getUserId()+"'),EWDHH_NEXT_D_PARTICIPANT='-',EWDHH_D_PARTICIPANT_TYPE='-'   WHERE EWDHH_AUTH_KEY IN ('VENDOR_PROFILE')  AND EWDHH_DOC_ID ='"+vendorProfileId+"' ");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);

		try
		{
			miscManager.ezUpdate(mainParams);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
		}
		
		
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_DOCUMENT_COMMENTS");
		mainParams.setLocalStore("Y");

		documentComments.setDocId(vendorProfileId);
		documentComments.setDocType("VEND_PROFILE");
		documentComments.setComments(comments);
		documentComments.setUserId((String)Session.getUserId());
		documentComments.setExt1("");
		documentComments.setExt2("");
		documentComments.setExt3("");

		mainParams.setObject(keyParams);	
		mainParams.setObject(documentComments);
		Session.prepareParams(mainParams);

		try{
			ezc.ezcommon.EzLog4j.log(":::::Before save documentComments:::::","I");
			vendorprofile.ezSaveDetails(mainParams);
			ezc.ezcommon.EzLog4j.log(":::::After save documentComments:::::","I");
		}catch(Exception e){}
		
		
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFAuditTrailParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_AUDIT_TRAIL");
		mainParams.setLocalStore("Y");

		eziWFAuditTrailParams.setEwhAuditTrailNo("1");
		eziWFAuditTrailParams.setEwhDocId(vendorProfileId);
		eziWFAuditTrailParams.setEwhType("POSTEDTOSAP");
		eziWFAuditTrailParams.setEwhSourceParticipant((String)Session.getUserId());
		eziWFAuditTrailParams.setEwhSourceParticipantType("U");
		eziWFAuditTrailParams.setEwhDestParticipant(Integer.parseInt(defSoldTo)+"");
		eziWFAuditTrailParams.setEwhDestParticipantType("U");
		eziWFAuditTrailParams.setEwhComments("Request "+vendorProfileId+" has been Posted to SAP.");

		mainParams.setObject(keyParams);	
		mainParams.setObject(eziWFAuditTrailParams);
		Session.prepareParams(mainParams);

		try{

			vendorprofile.ezSaveDetails(mainParams);
		}catch(Exception e){}
		
		String sendToUser= (String)Session.getUserId()+","+Integer.parseInt(defSoldTo);

		//String msgSubject = venName+" new profile posted to SAP";
		String msgSubject = "New Vendor Profile posted to SAP (Request number "+vendorProfileId+")";
		String msgText = "Dear Sir/Madam,<br><br>Vendor profile request "+vendorProfileId+" has been posted to SAP with SAP vendor code "+vendCode+".&nbsp;<br>";
		msgText = msgText+"<BR>";
		msgText += "Regards,<br>"+v_fname+v_mname+v_lname;
		
		
		String inboxPath="";
	 	
		
%>	
	<%@ include file="../Purorder/ezSendMail.jsp" %>		
<%	
	}
%>
<Html>
<Head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
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
</style>
  
</Head>

  <!-- Content Wrapper. Contains page content -->
        <Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Vendor Profile
            </h4>
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	<Body>          
        <form method="post"  name="myForm">
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      	