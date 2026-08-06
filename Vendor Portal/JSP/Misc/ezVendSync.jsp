<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve,ezc.ezparam.*,ezc.ezworkflow.params.*" %>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="BussPartnerManager" class="ezc.client.CEzBussPartnerManager" scope="session"/>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*,ezc.ezparam.*,javax.naming.*,javax.sql.*" %>

<html>
<head>
	<Title>Quick Add Vendor</Title>
</head>
<script>
	function goBack(){
		document.myForm.action = "ezPreVendSync.jsp";
		document.myForm.submit();
	}
</script>
<body>
<style>
.select2-container--default .select2-selection--multiple {
    height: 40px;
    width: 220px;
    border-radius: 0px;
} 
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Confirm Vendor Sync
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->

<form name='myForm'>

<%
	String dispMsg 		= "";

	String vendCode 	= request.getParameter("vendCode");
	String vendName 	= request.getParameter("vendName");
	String vendEmail	= request.getParameter("vendEmail");
	String syskey[] 	= new String[]{request.getParameter("sysKey")}; 
	String cmpncode[] 	= new String[]{request.getParameter("cmpncode")}; 

	String payTo 	= vendCode;
	String userName = vendName;
	String userId 	= vendCode;
	String email 	= vendEmail;

	String usrRoles[]	= {"RFQ_LIST#RFQ List"};//{"PO_LIST","ASN_LIST","RFQ_LIST","ACC_STATEMENT","VEND_CHNG_SUBMIT","ADD_ASN","UPLOAD_ASN_INV","UPLOAD_FRT_INV","UPLOAD_LOAD_INV","UPLOD_UNLOAD_IN","UPLOAD_STRG_INV","UPLOAD_PO_INV","TO_BE_DLV_LIST","INV_PEND_GR_LIST"};//request.getParameterValues("usrRoles");
	
	try{
		Long.parseLong(payTo);
		payTo = "0000000000"+payTo;
		payTo = payTo.substring(payTo.length()-10,payTo.length());
	}catch(Exception e){}
	
	String mobile = request.getParameter("mobile");
	String cmpnCode=cmpncode[0];
	
	for(int c=1;c<cmpncode.length;c++)
	{
		cmpnCode += "¥"+cmpncode[c];
	}
	//out.println("cmpnCode::::"+cmpnCode);
	if(payTo!=null && !"null".equals(payTo))
	{
		payTo = payTo.trim();
		payTo = payTo.toUpperCase();
		try{
			payTo = Long.parseLong(payTo)+"";
			payTo="0000000000"+payTo;
			payTo=payTo.substring((payTo.length()-10),payTo.length());
		}
		catch(Exception e){
			payTo = payTo;
		}
	}	
	
	String ConnGroup = (String)session.getValue("ConnGroup");
	Connection con=null;

	Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	con=DriverManager.getConnection("jdbc:mysql://localhost:3306/jublqa?user=root&password=jubldev");
	
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.ezworkflow.params.EziWorkGroupUsersTable addTable= new ezc.ezworkflow.params.EziWorkGroupUsersTable();
	ezc.ezworkflow.params.EziWorkGroupUsersTableRow addParams = null;

	Hashtable bpSysAuth=new Hashtable();
	Hashtable bpIndAuth=new Hashtable();
	Hashtable userSysAuth=new Hashtable();
	Hashtable userIndAuth=new Hashtable();

	bpSysAuth.put("VENDOR_SYS_DEP","Vendor System Dependent Role");
	bpIndAuth.put("VENDOR_SYS_IND","Vemdpr System Independant Role");

	userSysAuth.put("VENDOR_SYS_DEP","Vendor System Dependent Role");
	userIndAuth.put("VENDOR_SYS_IND","Vemdpr System Independant Role");
	
	String usrRoleNr = "", usrRoleDesc = "";
	
	if(usrRoles!=null && usrRoles.length>0)
	{
		for(int r=0;r<usrRoles.length;r++)
		{
			usrRoleNr 	= usrRoles[r].split("#")[0];
			usrRoleDesc 	= usrRoles[r].split("#")[1];
			
			bpSysAuth.put(usrRoleNr,usrRoleDesc);
			userSysAuth.put(usrRoleNr,usrRoleDesc);
		}	
	}

	ezc.ezbasicutil.EzMassVendSynch mySynch= new ezc.ezbasicutil.EzMassVendSynch("999","0");
	mySynch.setSession(Session);
	mySynch.setConnection(con);

	mySynch.ERPSOLDTO=payTo;
	mySynch.company = userName;
	mySynch.SYSKEY=syskey[0];
	mySynch.contactNo = mobile;
	boolean error=false;

	String mySyskey = syskey[0];
	for(int i=1;i<syskey.length;i++)
	{
		mySyskey += "#####"+syskey[i];
	}
	mySynch.ezAreas=mySyskey;
   	String bpnumber=mySynch.addBP();
   	
   	ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>bpnumber>>>>>>>>>>>>>>>>>>>>>>>> "+bpnumber,"I");
   	
	if(bpnumber!=null && !"null".equals(bpnumber))
	{
		mySynch.addBPSysAuth(bpnumber,bpSysAuth);
		mySynch.addBPSysInAuth(bpnumber,bpIndAuth);

		for(int i=0;i<syskey.length;i++)
		{
			mySynch.SYSKEY=syskey[i];
			
			ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>getVendorsFromErp()>>>>>>>>>>>>>>>>>>>>>>>> "+mySynch.getVendorsFromErp(),"I");
			
			if(! mySynch.getVendorsFromErp())
			{
				ezc.ezparam.EzcParams myEzcParams = new ezc.ezparam.EzcParams(false);
				ezc.ezparam.EzcBussPartnerNKParams bussPartnerNKParams = new ezc.ezparam.EzcBussPartnerNKParams();
				bussPartnerNKParams.setPartnerNumber("'"+bpnumber+"'");
				myEzcParams.setObject(bussPartnerNKParams);
				Session.prepareParams(myEzcParams);
				ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Before11111 Delete Buss Partner","I");
				BussPartnerManager.deleteBussPartners(myEzcParams);
				ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> After22222 Delete Buss Partner","I");
				
				dispMsg = "Error while getting vendor details from SAP";
				error=true;
				break;
			}
			try{
			     Long.parseLong(mySynch.ERPSOLDTO);
			     mySynch.ERPSOLDTO="00000000000000".substring(0,10-mySynch.ERPSOLDTO.length())+mySynch.ERPSOLDTO;
			}
			catch(Exception er){
			
			}
			
			if(! mySynch.ezAddPayTo(bpnumber))
			{
				ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ezAddPayTo After Delete Buss Partner","I");
				dispMsg = "Error creating business partner in portal";
				error=true;
				break;
			}
			if(! mySynch.getBPCustomers(bpnumber))
			{	
				ezc.ezcommon.EzLog4j.log(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getBPCustomers After Delete Buss Partner","I");

				dispMsg = "Error while getting vendor details from SAP";
				error=true;
				break;
			}
			if(! mySynch.ezAddFunctions(bpnumber))
			{
				dispMsg = "Problem While adding functions.";
				error=true;
				break;
			}
			
			
			
			addParams= new ezc.ezworkflow.params.EziWorkGroupUsersTableRow();
			addParams.setEffectiveFrom("01/01/2000");	
			addParams.setEffectiveTo("01/01/2999");	
			addParams.setGroupId("VENDOR");
			addParams.setUserId(userId.toUpperCase());
			addParams.setSyskey(syskey[i]);
			addParams.setSoldTo(payTo);
			addTable.appendRow(addParams);
			
		}
		if(!error)
		{
			mySynch.UserId = userId.toUpperCase();
			mySynch.email  = email;
			mySynch.setPassword();
			mySynch.addUser(bpnumber);
			mySynch.addUserSysAuth(userSysAuth);
			mySynch.addUserSysInAuth(userIndAuth);
			
			addMainParams.setObject(addTable);
			Session.prepareParams(addMainParams);
			EzWorkFlowManager.addWorkGroupUsers(addMainParams);
			
			try{
				Statement statement = con.createStatement();
				statement.executeUpdate("insert into ezc_user_defaults values('"+userId.toUpperCase()+"','NOT','','PURGROUP','ALL','D','Y')");
				
				statement.executeUpdate("insert into ezc_user_defaults values('"+userId.toUpperCase()+"','NOT','','COMPCODE','"+cmpnCode+"','D','Y')");								
								
				ezc.ezcommon.EzCipher ci = new ezc.ezcommon.EzCipher();
				String passWdToBeUpd = ci.ezEncrypt("portal");
				
				statement.executeUpdate("UPDATE  EZC_USERS SET EU_PASSWORD = '"+passWdToBeUpd+"' WHERE EU_ID ='"+userId.toUpperCase()+"'");
				
			}catch(Exception e){
				out.println("Exception while inserting data in user defaults in jsp ezQuickAddVendor...."+e);
			}
			String toEMailIds = email;
			String ccEMailIds = request.getParameter("ccEMailIds");
			String msgSubject = "Somany Impressa Vendor Portal Login Details";
			String eMailData = "Dear Sir/Madam, <Br><Br>Please find below your login details of Somany Impressa Vendor Portal <Br> User Id : "+userId+" <Br> Password : portal <Br><Br>Regards,<Br> Somany Impressa International Limited. <Br><Br><B>Portal Link : <a href="+request.getScheme()+"://"+request.getServerName()+"  target=_blank>"+request.getServerName()+"</a></B>";

%>
			<%//@ include file="../../../../../EzVendor/Vendor2/JSPs/Misc/ezSendExternalMail.jsp"%>
			<%//@ include file="ezSendVendorMail.jsp"%>
<%			
		}
	}
%>
<Br><Br><Br><Br>
<Table width="90%" border="1" align="center" bordercolorlight=#000000 bordercolordark=#ffffff cellspacing=0 cellpadding=2>
	<Tr>

		<Td align=center><%=payTo%></Td>
		<Td><%=userName%></Td>
		<Td><%=userId.toUpperCase()%></Td>
		<Td><%=mySynch.getPassword()%></Td>			
		<Td><%=email%></Td>
<%
		if(! error) 
		{
%>
			<Td><Font color='GREEN'>SUCCESS</Font></Td>	
<%
		}else{
%>
			<Td><Font color='RED'>FAILED : <%=dispMsg%></Td>	
<%
		}
%>
	</Tr>
</Table>	
<br>
	<Center>
		<button type="button" class="btn btn-primary pull-right" onclick="goBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Go Back</button>
	</Center>
</form>
</html>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezFooter.jsp"%>