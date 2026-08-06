 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*,ezc.ezparam.*,javax.naming.Context,javax.naming.InitialContext" %>
<%@ page import="ezc.ezcommon.*,java.io.*,java.nio.file.*" %> 
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.valuemap.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>

 <%	
 
 	//String Update=request.getParameter("Update");
 	String loc=request.getParameter("loc");
 	String panNo=request.getParameter("panNo");
 	String venGrp=request.getParameter("venGrp");
 	String venType=request.getParameter("venType");
 	String docId=request.getParameter("tempUserId");
 	String tempUserId=request.getParameter("tempUserId");
 	String dept=checkNull(request.getParameter("dept"));
 	String reason=checkNull(request.getParameter("reason"));
 	
 	String selPlant=request.getParameter("selPlant");
 	String selCategory=request.getParameter("selCategory"); 		
	String purOrg  		= request.getParameter("purOrg");				//"4500"		
	String compCode 	= request.getParameter("compCode");				//"4500"
	String category 	= request.getParameter("selCategory");				//"VNR"
	String venWFPlant  	= request.getParameter("selPlant");				//"4500"
	String venWFCategory  	= "RM_PM";
	String wfTemplate	= request.getParameter("wfTemplate");				//"0"
	String wfCurStep	= "1"; //request.getParameter("wfCurStep");
 	String logonSite = (String)session.getValue("SITE");
 	
 	
 	//Logging Values
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::loc:::::"+loc,"D");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::panNo:::::"+panNo,"D");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::venGrp:::::"+venGrp,"D");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::venType:::::"+venType,"D");
	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::docId:::::"+docId,"D");
	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::tempUserId:::::"+tempUserId,"D");
	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::compCode:::::"+compCode,"D");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::purOrg:::::"+purOrg,"D");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::selPlant:::::"+selPlant,"D");
	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::selCategory:::::"+selCategory,"I");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::wfCurStep:::::"+wfCurStep,"I");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::wfTemplate:::::"+wfTemplate,"I");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::venWFCategory:::::"+venWFCategory,"I");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::venWFPlant:::::"+venWFPlant,"I");
 	ezc.ezcommon.EzLog4j.log(":::AddTempUser.jsp:::reason:::::"+reason,"I");
 	
 	String template = "";
 	
 	//*****************************FILE UPLOAD for VEN****************************//
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;	

	lineAttachString = request.getParameterValues("fileItemTemp");
	ezc.ezcommon.EzLog4j.log("docId>>>>>"+docId,"I");  
	ezc.ezcommon.EzLog4j.log("lineAttachString in update VNR WF>>>>>"+lineAttachString,"I"); 

	if(lineAttachString != null)
	{ 
		objNo 		=  docId;
		documentType 	= "VNRH"; 

			ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
			//for(int x=0;x<selectedPRsCnt;x++)
			//{
				String fileItemIndex = "H";
				String fileItem[]	= request.getParameterValues("fileItemTemp"); 
				int fileLength = 0;
				if(fileItem != null)
					fileLength = fileItem.length;
					ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

				if(fileLength > 0)
				{
					String subDirPath = "VNRH"+"\\"+docId+"\\"+fileItemIndex+"\\";
					String dirPath  = serverUpPath+subDirPath;
					String sessionId = session.getId()+"";
					Path path = Paths.get(dirPath);
					Files.createDirectories(path);
					for(int j=0;j<fileItem.length;j++)
					{
						try
						{
							String fileName = fileItem[j];	
							ezc.ezcommon.EzLog4j.log("**filename in WF11>>"+fileName,"I");
							File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileName);
							File notifDestFile = new File(dirPath+fileName);			
							FileInputStream inStream = new FileInputStream(notifSourceFile);
							FileOutputStream outStream = new FileOutputStream(notifDestFile);
							byte[] buffer = new byte[1024];
							int length;
							//copy the file content in bytes 
							while ((length = inStream.read(buffer)) > 0)
							{
								outStream.write(buffer, 0, length);
							}
							inStream.close();
							outStream.close();
							notifSourceFile.delete();		
							ezc.misctransactions.params.EzMiscTableRow miscTableRow2 = new ezc.misctransactions.params.EzMiscTableRow();
							miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+docId+"','"+fileItemIndex+"','VNRH','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
							ezc.ezcommon.EzLog4j.log("**filename in WF>>"+miscTableRow2.getQuery(),"I");
							miscTable2.appendRow(miscTableRow2);
						}catch(Exception e)
						{
							ezc.ezcommon.EzLog4j.log("**filename Exception in WF>>"+e,"I");
						}
					}
				}
			//}
			mainParams2.setLocalStore("Y");
			mainParams2.setObject(miscTable2);
			Session.prepareParams(mainParams2);
			try
			{
			miscMgr2.ezSaveMiscTransactions(mainParams2);

			}
			catch(Exception e)
			{
			}
		}

		ezc.ezparam.ReturnObjFromRetrieve wfTemRet = getWFTemplate(Session,"VNR",venWFPlant,venWFCategory,compCode);		
		if(wfTemRet != null)
		{
			template=wfTemRet.getFieldValueString(0,"EWKM_TEMPLATE");
		}
	ezc.ezcommon.EzLog4j.log("templateNew>>>>>>>>"+template,"I");
	
	/*--------------------------Send Document To Approver---------------------------------*/
	String currentStep="";
	String nextPart ="";
	String wfStatus ="";
	String comments ="";
	String firstName  =(String)session.getValue("FIRST_NAME");
	String mailText="";
	String dispStr ="";
	java.util.ArrayList<String> queriesList1=new java.util.ArrayList<String>();
	if(template != null && !"null".equals(template) && !"".equals(template))
	{
		currentStep = "1";
		ezc.ezcommon.EzLog4j.log("currentStep>>>>>>>>"+currentStep,"I");
		ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,template,Integer.parseInt(currentStep));
		ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>type_2_user>>>"+wfNextPartRet.toEzcString(),"I");
		ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>type_2_user>>>"+wfNextPartRet.getFieldValueString(0,"EWPC_GROUP"),"I");
		ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>type_2_user>>>"+wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL"),"I");
		
		if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
		{
			currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
			nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
			wfStatus = "SUBMITTED";

			ezc.ezcommon.EzLog4j.log("currentStep>>>first_Approver>>>>>"+currentStep,"I");
			ezc.ezcommon.EzLog4j.log("nextPart>>>>first_Approver>>>>"+nextPart,"I");
			ezc.ezcommon.EzLog4j.log("wfStatus>>>>>first_Approver>>>"+wfStatus,"I");
		}		

		

		if("2".equals(userType))
		{
			ezc.ezcommon.EzLog4j.log("EZC_WF_DOC_HISTORY_HEADER>>>>","I");
			queriesList1.add("INSERT INTO EZC_WF_DOC_HISTORY_HEADER(EWDHH_AUTH_KEY,EWDHH_DOC_ID,EWDHH_SYSKEY,EWDHH_TEMPLATE_CODE,EWDHH_WF_STATUS,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_MODIFIED_BY,EWDHH_CURRENT_STEP,EWDHH_NEXT_PARTICIPANT) VALUES('VNR','"+docId+"','"+sysKey+"','"+template+"','"+wfStatus+"',now(),now(),'"+Session.getUserId()+"','"+Session.getUserId()+"',"+currentStep+",'"+nextPart+"')");

		}	
		queriesList1.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+docId+"','VNR','"+comments+"','"+Session.getUserId()+"',now())");
		ezMiscInsert(Session,queriesList1);
		saveWFDocAudit(Session,docId,"VNR","Vendor details "+wfStatus.toLowerCase()+" by "+Session.getUserId()+"["+firstName+"]","U");

		ReturnObjFromRetrieve userRet = getWorkFlowMails(Session,wfNextPartRet.getFieldValueString(0,"EWPC_GROUP"),venWFPlant,venWFCategory);
		int userRetCnt = 0;
		if(userRet != null)
		{
			userRetCnt = userRet.getRowCount();
		}
		for(int i=0;i<userRetCnt;i++)
		{
			//String linkId=saveLinkControllerData(Session,docId,"VNR",userRet.getFieldValueString(i,"EU_ID"),userRet.getFieldValueString(i,"EU_EMAIL"),mailText);
			//sendMails(Session,userRet.getFieldValueString(i,"EU_EMAIL"),ccEmailStr,"",mailText.replace("JBTEID",linkId),mailSub);
		}
		dispStr = "Request details submitted for approval. Doc Id : "+docId+"";



	}
	else
	{
		dispStr = "No Workflow exists for the selected defaults.";
	}

	
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
     		//ezMiscManager.ezUpdate(mainParams);
     	}
     	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
     	if(retQuery!=null)
     		QueryCnt=retQuery.getRowCount(); 
     		
     	mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams = new EziMiscParams();
	miscParams.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_WF_STATUS='CLOSED', EWDHH_MODIFIED_BY='"+Session.getUserId()+"', EWDHH_MODIFIED_ON=now() WHERE EWDHH_DOC_ID ='"+docId+"' ");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);

	try
	{
		//ezMiscManager.ezUpdate(mainParams);
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
	}	
     		
	ReturnObjFromRetrieve retSyskey	=  null;
	int    SyskeyCnt	=  0;
	
	mainParams	= new EzcParams(false);
	miscParams	= new EziMiscParams();
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
	
   ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 				
   ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
   ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
   ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
   miscTableRow1.setQuery("INSERT INTO ezc_customer_form_header (ECFH_DOC_ID, ECFH_SALES_ORG,ECFH_EXT1, ECFH_EXT2,ECFH_STATUS,ECFH_CUST_NAME,ECFH_CREATED_BY,ECFH_CREATED_ON,ECFH_MODIFIED_BY,ECFH_MODIFIED_ON,ECFH_MASTER_TYPE,ECFH_PAN_NO,ECFH_VEN_GRP,ECFH_VEN_TYPE,ECFH_PLANT,ECFH_CATEGORY,ECFH_REASON) VALUES('"+tempUserId+"','"+purOrg+"','"+compCode+"','"+dept+"','NOTINITIATED','"+userName+"','"+Session.getUserId()+"',now(),'"+Session.getUserId()+"',now(),'V','"+panNo+"','"+venGrp+"','"+venType+"','"+selPlant+"','"+selCategory+"','"+reason+"')");
   miscTable1.appendRow(miscTableRow1);
    try
    {
    mainParams1.setLocalStore("Y");
    mainParams1.setObject(miscTable1);
    Session.prepareParams(mainParams1);
    miscMgr1.ezSaveMiscTransactions(mainParams1);
    }
    catch(Exception e)
    {
     ezc.ezcommon.EzLog4j.log("::::Error in inserting the tempuser In headerTable"+e,"I");
    }
    
%>
<%
	
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
	Connection 	con1=null;
	Class.forName("com.mysql.jdbc.Driver");
	java.util.ResourceBundle mySite= java.util.ResourceBundle.getBundle("Site");
	
	javax.sql.DataSource ds = null;
	Context ctx = null;
	ctx = new InitialContext();
	String jdbcLookUp = mySite.getString("DBLOOKUP_200");
	ds = 	(javax.sql.DataSource)ctx.lookup(jdbcLookUp);
	con =  ds.getConnection();
	
	//con=DriverManager.getConnection("jdbc:mysql://localhost:3306/jubldev?user=root&password=jubldev");
	
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
			
			String rfqAuth = "N";
			String regAuth = "N";
			String wfGrp = "";
			
			
			try{
				
				if("Y".equals(request.getParameter("RFQ")))
					rfqAuth = "Y";
					ezc.ezcommon.EzLog4j.log("rfqAuth22>>>>"+rfqAuth,"I");
				
				if("Y".equals(request.getParameter("VENREG")))	
					regAuth = "Y";
					ezc.ezcommon.EzLog4j.log("regAuth33>>>>"+regAuth,"I");			
				
				java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
				queriesList.add("INSERT INTO EZC_USER_DEFAULTS (EUD_USER_ID, EUD_SYS_KEY, EUD_KEY, EUD_VALUE, EUD_DEFAULT_FLAG, EUD_IS_USERA_KEY) VALUES('"+userId.toUpperCase()+"','NOT','ALLOW_RFQ','"+rfqAuth+"','D','Y')");
				queriesList.add("INSERT INTO EZC_USER_DEFAULTS (EUD_USER_ID, EUD_SYS_KEY, EUD_KEY, EUD_VALUE, EUD_DEFAULT_FLAG, EUD_IS_USERA_KEY) VALUES('"+userId.toUpperCase()+"','NOT','ALLOW_REG','"+regAuth+"','D','Y')");										
				queriesList.add("INSERT INTO EZC_USER_DEFAULTS (EUD_USER_ID, EUD_SYS_KEY, EUD_KEY, EUD_VALUE, EUD_DEFAULT_FLAG, EUD_IS_USERA_KEY) VALUES('"+userId.toUpperCase()+"','999800','SOLDTOPARTY','"+soldtoId+"','N','')");										
				queriesList.add("UPDATE EZC_USERS SET EU_PASSWORD='h?q}B)j)6~p@K@y;',EU_DELETION_FLAG='B' WHERE EU_ID='"+userId.toUpperCase()+"'");										
				ezMiscInsert(Session,queriesList);
				
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception while inserting data in user defaults in jsp Temp User22	....>>>>"+e,"I");
			}
			
			
	     	}
	}
	
	String msgSubject = "Temporary Login Details for Jubilant Generics Vendor Portal";

	String ccMailIds  = "";

	String msgText 		=  "";//eMailData;
	String toEMailIds 	=  email;
	String ccEMailIds	= "";
	String eMailData	= "";
	
	ezc.ezcommon.EzLog4j.log("Temporary Login Details for Jubilant Generics Vendor Porral -- toEMailIds>>>>>>>"+toEMailIds,"I");
	
	String dispMsgType = "";
	String dispMessage = "";
	String divWidth = "50%";
	ezc.ezcommon.EzCipher cipher=new ezc.ezcommon.EzCipher();
	eMailData += "Dear Sir/Madam,<br>";
	if(!error)
	{
		//dispMessage = "User Id :"+userId+" created successfully and mail has been sent to :"+email;
		//dispMessage = "Document has been Successfully Created,As per Work Flow Next Participant is :"+nextPart;
		dispMessage = "Document has been Successfully Created, Next Participant is :"+nextPart;
		dispMsgType = "S";	
		if("Y".equals(request.getParameter("RFQ")))
		{
			eMailData  = "Below are your temporary login credentials to repond for RFQ<Br>";
		}
		else if("Y".equals(request.getParameter("VENREG")))
		{
			//eMailData  += "Below are your temporary login credentials to register with Jubilant Generics<Br>";
			eMailData  += "Please click on below link to register with Jubilant Generics<Br>";
		}
		else
		{
			eMailData  = "Below are your temporary login credentials for Vendor Portal<Br>";
		}
		eMailData  += "<Br><Br>User Id :"+userId;
		eMailData  += "<Br><Br>Password :"+mySynch.getPassword();
		String portalURL  = "http://"+request.getServerName()+"/JUBL/";
		
		
		try
		{
			//final String decPwd=java.net.URLEncoder.encode(cipher.ezEncrypt(mySynch.getPassword()+""),"UTF-8");
			final String decPwd=java.net.URLEncoder.encode(cipher.ezEncrypt(mySynch.getPassword()+""),"UTF-8");
			eMailData  += "<Br><Br><a href='"+portalURL+"/ezProcessVendorOffline.jsp?id1="+userId+"&id2="+decPwd+"&id3="+logonSite+"'>Click here to register</a><Br><Br>";
		}
		catch(Exception e){
			out.print(e);
		}
		eMailData  += "<Br>Regards ";
		eMailData  += "<Br>Jubilant Generics ";
		
		String smsMesg    = "";
		if("Y".equals(request.getParameter("RFQ"))) 
		{
			smsMesg  = "Below are your temporary login credentials to repond for RFQ<Br>";
		}
		else if("Y".equals(request.getParameter("VENREG")))
		{
			smsMesg  = "Below are your temporary login credentials to register with Jubilant Generics<Br>";
		}
		else
		{
			smsMesg  = "Below are your temporary login credentials for Vendor Portal<Br>";
		}
		//String smsMesg    = "Below are your temporary login credentials for Vendor Portal. ";
		smsMesg  += "User Id :"+userId;
		smsMesg  += " ";
		smsMesg  += "Password :"+mySynch.getPassword();
		
		String mobileNo = contactNo;
		
%>
		<%@ include file="../Misc/ezSendExternalMail.jsp"%> 
		<%//@ include file="ezSendSMS.jsp"%>
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
<script>
function funOk()
{ window.location = "ezBuyerWelcome.jsp";
	//var url = "ezBuyerWelcome.jsp";
   	//window.location(url);
}
</script>
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
