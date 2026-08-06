<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*,java.sql.*,javax.naming.Context,javax.naming.InitialContext" %>   
<%@ page import="ezc.valuemap.params.*,ezc.ezmisc.params.*,java.util.*" %>
<%@ page import="java.util.*"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%!
	public void addKeyRow(String docId,String tabName,String fieldName,HttpServletRequest  req,ezc.misctransactions.params.EzMiscTable miscTable)throws Exception
	{
	
		ezc.ezcommon.EzLog4j.log("fieldName>>>>>if1>>>"+fieldName,"I");
		if(req.getParameter(fieldName)!=null)
		{
			StringBuffer feildVal = new StringBuffer(req.getParameter(fieldName));
			// to get a String result:
			String str2 = checkNull(feildVal.toString()).replaceAll("'","`");
			// to get a StringBuffer result:
			StringBuffer str3 = new StringBuffer(str2);
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery("INSERT INTO EZC_CUSTOMER_FORM_DETAILS(ECFD_DOC_ID,ECFD_FIELD,ECFD_VALUE,ECFD_TAB_NAME) VALUES('"+docId+"','"+checkNull(fieldName).replaceAll("'","`")+"','"+str3+"','"+tabName+"')");
			ezc.ezcommon.EzLog4j.log("fieldName>>>>>if1>>>"+miscTableRow.getQuery(),"I");
			miscTable.appendRow(miscTableRow);
		}  
	}
%> 
<%
	 
	
	String mailText="";
	String ccEmailStr="";
	String mailSub="";
	
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retErrorObj	  =	null;
	
	int contctLineNumberVal=0;
	int topCusLineNumberVal=0;
	int plantSiteLineNumberVal=0;
	int DPASLineNumberVal=0;
	String docId=checkNull(request.getParameter("tempUserId"));
	String vendName=checkNull(request.getParameter("vendName"));
	String actionSts=checkNull(request.getParameter("actionSts"));
	String venType=request.getParameter("venType");
	String userName=checkNull(request.getParameter("userName"));

	String purOrg  		= request.getParameter("purOrg");				//"4500"		
	String compCode 	= request.getParameter("compCode");				//"4500"
	String category 	= request.getParameter("selCategory");				//"VNR"
	String venWFPlant  	= request.getParameter("selPlant");				//"4500"
	String venWFCategory  	= "RM_PM";
	String wfTemplate	= request.getParameter("wfTemplate");				//"0"
	String wfCurStep	= "1"; //request.getParameter("wfCurStep");			
	String venGrp=request.getParameter("venGrp");						
	String tempUserId=request.getParameter("tempUserId");
	String syskey[] = {"999000"};
		
	String role = "TU";
	String userId	= 	request.getParameter("tempUserId");	
	String email	=	request.getParameter("eMail");
	String contactNo =	request.getParameter("contactNo");

	
 	ezc.ezcommon.EzLog4j.log("venGrp>>>first_Approver>>>>>"+venGrp,"I");
	ezc.ezcommon.EzLog4j.log("tempUserId>>>first_Approver>>>>>"+tempUserId,"I");
	ezc.ezcommon.EzLog4j.log("venWFPlant>>>first_Approver>>>>>"+venWFPlant,"I");
	ezc.ezcommon.EzLog4j.log("venWFCategory>>>>first_Approver>>>>"+venWFCategory,"I");
	ezc.ezcommon.EzLog4j.log("wfTemplate>>>>>first_Approver>>>"+wfTemplate,"I");
	ezc.ezcommon.EzLog4j.log("wfCurStep>>>>first_Approver>>>>"+wfCurStep,"I");
	ezc.ezcommon.EzLog4j.log("docId>>>>>first_Approver>>>"+docId,"I");
	ezc.ezcommon.EzLog4j.log("vendName>>>>first_Approver>>>>"+vendName,"I");
	ezc.ezcommon.EzLog4j.log("purOrg>>>>>first_Approver>>>"+purOrg,"I");
	ezc.ezcommon.EzLog4j.log("compCode>>>>first_Approver>>>>"+compCode,"I");
	ezc.ezcommon.EzLog4j.log("category>>>>>first_Approver>>>"+category,"I");
	String rfqAuth = "N";
	String regAuth = "N";
	
	
	
	String template = "";
	ezc.ezparam.ReturnObjFromRetrieve wfTemRet = getWFTemplate(Session,"VNR",venWFPlant,venWFCategory,compCode);
	ezc.ezcommon.EzLog4j.log("wfTemRet>>>>>first_Approver>>>"+wfTemRet.toEzcString(),"I");
	if(wfTemRet != null)
	{
		template=wfTemRet.getFieldValueString(0,"EWKM_TEMPLATE");
	}
	ezc.ezcommon.EzLog4j.log("templateNew>>>>>>>>"+template,"I");
	
	String logonSite = (String)session.getValue("SITE");
	String portalURL = "";
	ResourceBundle sitBundleObj=null;
	try
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		portalURL=sitBundleObj.getString("PORTAL_URL");
	}
	catch(Exception e)
	{ 
	    
	}		
	
	String comments = request.getParameter("comments");
	
	if(comments != null)
		comments = comments.replaceAll("'","`");	
	
	String currentStep="";
	String nextPart="";
	String wfStatus ="";	
	String dispStr = "";
	
	
/*--------------------- Sending to HOD Level Approval  -----------------------------*/

		try
		{
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams); 
			retErrorObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(mainParams);
		}
		catch(Exception e){}			



			if(template != null && !"null".equals(template) && !"".equals(template))
			{
				currentStep = "1";
				ezc.ezcommon.EzLog4j.log("currentStep>>>>>>>>"+currentStep,"I");
				ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,template,Integer.parseInt(currentStep));
				ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>type_4_user>>>"+wfNextPartRet.toEzcString(),"I");
				if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
				{
					currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
					nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
					wfStatus = "SUBMITTED";
					
					ezc.ezcommon.EzLog4j.log("currentStep>>>first_Approver>>>>>"+currentStep,"I");
					ezc.ezcommon.EzLog4j.log("nextPart>>>>first_Approver>>>>"+nextPart,"I");
					ezc.ezcommon.EzLog4j.log("wfStatus>>>>>first_Approver>>>"+wfStatus,"I");
				}		

				java.util.ArrayList<String> queriesList1=new java.util.ArrayList<String>();
				
				if("2".equals(userType))
				{
					queriesList1.add("INSERT INTO EZC_WF_DOC_HISTORY_HEADER(EWDHH_AUTH_KEY,EWDHH_DOC_ID,EWDHH_SYSKEY,EWDHH_TEMPLATE_CODE,EWDHH_WF_STATUS,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_MODIFIED_BY,EWDHH_CURRENT_STEP,EWDHH_NEXT_PARTICIPANT) VALUES('VNR','"+docId+"','"+sysKey+"','"+template+"','"+wfStatus+"',now(),now(),'"+Session.getUserId()+"','"+Session.getUserId()+"',"+currentStep+",'"+nextPart+"')");
					
				}
					
				queriesList1.add("INSERT INTO ezc_customer_form_header (ECFH_DOC_ID, ECFH_SALES_ORG,ECFH_EXT1, ECFH_EXT2,ECFH_STATUS,ECFH_CUST_NAME,ECFH_CREATED_BY,ECFH_CREATED_ON,ECFH_MODIFIED_BY,ECFH_MODIFIED_ON,ECFH_MASTER_TYPE,ECFH_PAN_NO,ECFH_VEN_GRP,ECFH_VEN_TYPE,ECFH_PLANT,ECFH_CATEGORY) VALUES('"+tempUserId+"','"+purOrg+"','"+compCode+"','','NOTINITIATED','"+userName+"','"+Session.getUserId()+"',now(),'"+Session.getUserId()+"',now(),'V','','"+venGrp+"','"+venType+"','"+venWFPlant+"','"+category+"')");				
				queriesList1.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+docId+"','VNR','"+comments+"','"+Session.getUserId()+"',now())");
				ezMiscInsert(Session,queriesList1);
				saveWFDocAudit(Session,docId,"VNR","Vendor details "+wfStatus.toLowerCase()+" by "+Session.getUserId()+"["+v_fullName+"]","U");
				
				ReturnObjFromRetrieve userRet = getWorkFlowMails(Session,wfNextPartRet.getFieldValueString(0,"EWPC_GROUP"),venWFPlant,venWFCategory);
				int userRetCnt = 0;
				if(userRet != null)
				{
					userRetCnt = userRet.getRowCount();
				}
				for(int i=0;i<userRetCnt;i++)
				{
					String linkId=saveLinkControllerData(Session,docId,"VNR",userRet.getFieldValueString(i,"EU_ID"),userRet.getFieldValueString(i,"EU_EMAIL"),mailText);
					sendMails(Session,userRet.getFieldValueString(i,"EU_EMAIL"),ccEmailStr,"",mailText.replace("JBTEID",linkId),mailSub);
				}
				dispStr = "Request details submitted for approval. Doc Id : "+docId+"";
				
				

			}
			else
			{
				dispStr = "No Workflow exists for the selected defaults.";
			}
			
			String soldtoId="0000000000"+tempUserId;
			soldtoId=soldtoId.substring(tempUserId.length(),soldtoId.length());			
			
			String bpnumber	 =	""; 
				
				
			ReturnObjFromRetrieve	valMapRetObj = null;
			mainParams = new EzcParams(true);
			ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
			EziValueMappingParams valueParams =  new EziValueMappingParams();				
			valueParams.setMapType("TEMP_USER_BP_NUM");
			mainParams.setObject(valueParams);	
			Session.prepareParams(mainParams);
				
			
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
					dispMessage = "User Id :"+userId+" created successfully and mail has been sent to :"+email;
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
					portalURL  = "http://"+request.getServerName()+"/JUBL/";
					
					
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