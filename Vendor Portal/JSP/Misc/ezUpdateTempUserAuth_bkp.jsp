<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>	

 <%	
	String tempVendCode = request.getParameter("tempVendCode");
	String venRegAuth = request.getParameter("venRegAuth");
	String rfqAuth = request.getParameter("rfqAuth");
	
	out.println(":::::tempVendCode::::::::"+tempVendCode);
	out.println(":::::venRegAuth::::::::"+venRegAuth);
	out.println(":::::rfqAuth::::::::"+rfqAuth);
	
	String rfqAuthStr = "UPDATE EZC_USER_DEFAULTS SET EUD_VALUE = '"+rfqAuth+"' where EUD_KEY = 'ALLOW_RFQ' AND EUD_USER_ID = '"+tempVendCode+"'";
	String regAuthStr = "UPDATE EZC_USER_DEFAULTS SET EUD_VALUE = '"+venRegAuth+"' where EUD_KEY = 'ALLOW_REG' AND EUD_USER_ID = '"+tempVendCode+"'";
	
 	
     	ReturnObjFromRetrieve retQuery	=  null;
     	int    QueryCnt	=  0;
     	
     	 ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
     	 EziMiscParams miscParams		= new EziMiscParams();
        	       	
     		miscParams.setQuery("update EZC_VEND_GENERAL_DATA set EVGD_STATUS='CLOSED' , EVGD_VENDOR='"+tempUserId+"' WHERE EVGD_DOC_ID='"+docId+"'");
        	       	
     	mainParams.setLocalStore("Y");
     	mainParams.setObject(miscParams);
     	Session.prepareParams(mainParams);
     	try
     	{		
     		ezMiscManager.ezUpdate(mainParams);
     	}
     	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
     	if(retQuery!=null)
     		QueryCnt=retQuery.getRowCount(); 
     		//out.println(miscParams.getQuery()+"::::::::"+QueryCnt);
     	mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();
	miscParams.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_WF_STATUS='CLOSED', EWDHH_MODIFIED_BY='"+Session.getUserId()+"', EWDHH_MODIFIED_ON=now() WHERE EWDHH_DOC_ID ='"+docId+"' ");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);

	try
	{
		ezMiscManager.ezUpdate(mainParams);
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
	}	
     		
	ReturnObjFromRetrieve retSyskey	=  null;
	int    SyskeyCnt	=  0;
	mainParams	= new EzcParams(false);
	 miscParams		= new EziMiscParams();
	miscParams.setQuery("select ECAD_SYS_KEY from ezc_cat_area_defaults where ECAD_VALUE='"+loc+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
		retSyskey=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retSyskey!=null)
		SyskeyCnt=retSyskey.getRowCount();
		String syskeyv = retSyskey.getFieldValueString(0,"ECAD_SYS_KEY");
		out.println("syskeyv:::::::"+syskeyv);
		String soldtoId="0000000000"+tempUserId;
		soldtoId=soldtoId.substring(tempUserId.length(),soldtoId.length());		

	ReturnObjFromRetrieve retWF	=  null;
	int    WFCnt	=  0;
	 mainParams	= new EzcParams(false);
	miscParams		= new EziMiscParams();
	miscParams.setQuery("INSERT INTO EZC_WF_WORKGROUP_USERS (EWWU_GROUP, EWWU_USER,EWWU_SYSKEY,EWWU_SOLD_TO,EWWU_EFFECTIVE_FROM, EWWU_EFFECTIVE_TO)  VALUES ('VENDOR','"+tempUserId+"','"+syskeyv+"','"+soldtoId+"',STR_TO_DATE('01/01/2000','%d/%m/%Y'),STR_TO_DATE('01/01/2999','%d/%m/%Y'))");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
		ezMiscManager.ezAdd(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retWF!=null)
		WFCnt=retWF.getRowCount();
	//response.sendRedirect("ezAddTempUser.jsp?userId="+userId+"&userName="+userName+"&eMail="+eMail+"&contactNo="+contactNo);
%>
<%
	String syskey[] = {"999000"};
	String role = "TU";
	String userId	= 	request.getParameter("userId");
	String userName	=	request.getParameter("userName");
	String email	=	request.getParameter("eMail");
	String contactNo =	request.getParameter("contactNo");
	String bpnumber	 =	""; 
	
	
	ReturnObjFromRetrieve	valMapRetObj = null;
	 mainParams = new EzcParams(true);
	ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
	EziValueMappingParams valueParams =  new EziValueMappingParams();

	valueParams.setMapType("TEMP_USER_BP_NUM");

	mainParams.setObject(valueParams);	
	Session.prepareParams(mainParams);

	try{
		valMapRetObj = (ReturnObjFromRetrieve)valMapMgr.ezGetValueMapping(mainParams);
	}catch(Exception e){}	

	if(valMapRetObj!=null && valMapRetObj.getRowCount()>0)
		bpnumber = valMapRetObj.getFieldValueString(0,"VALUE1");
	
	
	String catnum="0";
	Connection 	con=null;
	Class.forName("com.mysql.jdbc.Driver");
	java.util.ResourceBundle mySite= java.util.ResourceBundle.getBundle("Site");
	con=DriverManager.getConnection("jdbc:mysql://localhost:3306/cflvenddev?user=cflvenddev&password=cflvenddev");
	
	Hashtable userSysAuth=new Hashtable();
	Hashtable userIndAuth=new Hashtable();
	Hashtable userIndDefaults=new Hashtable();

	userIndAuth.put("VENDOR_SYS_IND","Vendor System Independent");
	userSysAuth.put("VENDOR_SYS_DEP","Vendor System Dependent");
	
	userSysAuth.put("TEMP_USER","Temp User Role");
	

	userIndDefaults.put("CURRENCY","INR");
	userIndDefaults.put("LANGUAGE","EN");
	userIndDefaults.put("STYLE","");
	userIndDefaults.put("USERROLE",role);
	
	ezc.ezbasicutil.EzMassInternalCustSynch mySynch= new ezc.ezbasicutil.EzMassInternalCustSynch("999",catnum);
	mySynch.setSession(Session);
	mySynch.setConnection(con);

	mySynch.SYSKEY=syskey[0];
	mySynch.company = userName;
	mySynch.email = email;
	mySynch.contactNo = contactNo;
	boolean error=false;

	String mySyskey = syskey[0];
	for(int i=1;i<syskey.length;i++)
	{
		mySyskey += "#####"+syskey[i];
	}
	mySynch.ezAreas=mySyskey;
	
	if(bpnumber!=null && !"null".equals(bpnumber))
	{
		for(int i=0;i<syskey.length;i++)
		{
			mySynch.SYSKEY=syskey[i];
	    	}
	    	if(!error)
		{
			mySynch.UserId = userId.toUpperCase();
			mySynch.setPassword();
			mySynch.addOtherUser(bpnumber,"O");
			mySynch.addUserSysAuth(userSysAuth);
			mySynch.addUserSysInAuth(userIndAuth);
			mySynch.addUserDefaults(userIndDefaults);
			
			String rfqAuth = "";
			String regAuth = "";
			String wfGrp = "";
			
			try{
				Statement statement = con.createStatement();
				
				if("Y".equals(request.getParameter("RFQ")))
					rfqAuth = "Y";
				statement.executeUpdate("INSERT INTO EZC_USER_DEFAULTS VALUES('"+userId.toUpperCase()+"','NOT','','ALLOW_RFQ','"+rfqAuth+"','D','Y')");
				
				if("Y".equals(request.getParameter("VENREG")))	
					regAuth = "Y";
				statement.executeUpdate("INSERT INTO EZC_USER_DEFAULTS VALUES('"+userId.toUpperCase()+"','NOT','','ALLOW_REG','"+regAuth+"','D','Y')");								
				
				if("Y".equals(request.getParameter("VENREG")))	
					wfGrp = userGroup;
				
				statement.executeUpdate("INSERT INTO EZC_USER_DEFAULTS VALUES('"+userId.toUpperCase()+"','NOT','','PP_WF_GRP','"+wfGrp+"','D','Y')");								
					
					
			}catch(Exception e){
				out.println("Exception while inserting data in user defaults in jsp Temp User...."+e);
			}
			
			
	     	}
	}
	
	String msgSubject = "Temporary Login Details for Coromandel Vendor Portal";

	String ccMailIds  = "";

	String msgText 		=  "";//eMailData;
	String toEMailIds 	=  email;
	String ccEMailIds	= "";
	String eMailData	= "";
	
	ezc.ezcommon.EzLog4j.log("Temporary Login Details for Coromandel Vendor Porral -- toEMailIds>>>>>>>"+toEMailIds,"I");
	
	String dispMsgType = "";
	String dispMessage = "";
	String divWidth = "50%";
		
	if(!error)
	{
		dispMessage = "User Id :"+userId+" created successfully and mail has been sent to :"+email;
		dispMsgType = "S";	
		eMailData  = "Below are your temporary login credentials for Vendor Portal<Br>";
		eMailData  += "<Br>User Id :"+userId;
		eMailData  += "<Br>Password :"+mySynch.getPassword();
		eMailData  += "<Br>URL : http://"+request.getServerName()+":"+request.getServerPort()+" <Br>";
		eMailData  += "<Br>";
		eMailData  += "<Br>Regards ";
		eMailData  += "<Br>Coromandel ";
		
		String smsMesg    = "Below are your temporary login credentials for Vendor Portal";
		smsMesg  += "<Br>User Id :"+userId;
		smsMesg  += "<Br>Password :"+mySynch.getPassword();
		
		String mobileNo = contactNo;
		
%>
		<%@ include file="../Misc/ezSendExternalMail.jsp"%> 
		<%@ include file="ezSendSMS.jsp"%>
<%
	}	
	else if(error)
	{
		dispMessage = "Problem while creating User Id :"+userId;
		dispMsgType = "E";	
	}	

	String display_header ="Temporary User Creation";	

%>
<%@ include file="ezHeader.jsp"%> 
<!DOCTYPE html>
<html>
<head>

</head>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
	<%@ include file="../Misc/ezStatusMsgDisplay.jsp"%> 
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="funOk()">Ok</button>  &nbsp;	
</center>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 