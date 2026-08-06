<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
 <%

	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();	
	logs.setUserId("440590");
	logs.setPassWd("myindia");
	logs.setConnGroup("200");
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
%>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
	 


<%!
public String checkNull(String value)
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	
	return value;
} 
%>
<%
String userId = (String)Session.getUserId();
EziMiscParams miscParams = new EziMiscParams();   

String dispMessage="Problem occured while submitting the request",dispMsgType="E",divWidth="90%";

String vendCode = checkNull(request.getParameter("vendCode"));
String compCode = checkNull(request.getParameter("compCode"));
String serBased = checkNull(request.getParameter("serBased"));
//String venName  = request.getParameter("venName");
//String corLoc   = request.getParameter("corLoc");
String grBased  = checkNull(request.getParameter("grBased"));
String procGrp  = checkNull(request.getParameter("procGrp"));

String comments  	 = checkNull(request.getParameter("comments"));
//out.println(comments+"::::::::"+vendCode+"<>"+compCode+"<>"+serBased+"<>"+grBased+"<>"+procGrp);
comments=comments.replaceAll("'","`");

String titleSel  	 = checkNull(request.getParameter("titleSel"));
String vendType  	 = checkNull(request.getParameter("vendType"));
String name1  	 	 = checkNull(request.getParameter("name1"));
String name2  	 	 = checkNull(request.getParameter("name2"));
String addr1  	  	 = checkNull(request.getParameter("addr1"));
String addr2  	 	 = checkNull(request.getParameter("addr2"));
String street 	 	 = checkNull(request.getParameter("street"));
String city  	 	 = checkNull(request.getParameter("city"));
String state  	 	 = checkNull(request.getParameter("state"));
String country  	 = checkNull(request.getParameter("country"));
String district  	 = checkNull(request.getParameter("district"));
String pin  	 	 = checkNull(request.getParameter("pin"));
String landline  	 = checkNull(request.getParameter("landline"));
String mobile  	 	 = checkNull(request.getParameter("mobile"));
String fax  	 	 = checkNull(request.getParameter("fax"));
String email  	 	 = checkNull(request.getParameter("email"));
String email2  	 	 = checkNull(request.getParameter("email2"));
String contPers1  	 = checkNull(request.getParameter("contPers1"));
String contPers2  	 = checkNull(request.getParameter("contPers2"));
String SystemKey = checkNull(request.getParameter("SystemKey"));
//out.println(SystemKey+"::::::::"+titleSel+name1+name2+addr1+addr2+""+street+city+state+country+district+pin+landline+mobile+fax+email+email2+contPers1+contPers2);

String vat   	= checkNull(request.getParameter("vat"));
String cst   	= checkNull(request.getParameter("cst"));
String pan   	= checkNull(request.getParameter("pan"));
String servTax  = checkNull(request.getParameter("servTax"));
String eccNo   	= checkNull(request.getParameter("eccNo"));
String excRegNo = checkNull(request.getParameter("excRegNo"));
String rangeSel = checkNull(request.getParameter("rangeSel"));
String exDiv   	= checkNull(request.getParameter("exDiv"));
String commi  	= checkNull(request.getParameter("commi"));
String minIndi  = checkNull(request.getParameter("minIndi"));
String gst  	= checkNull(request.getParameter("gst"));
String classification  	= checkNull(request.getParameter("classification"));
//out.println("::::::::"+vat+"<>"+cst+"<>"+pan+"<>"+servTax+"<>"+eccNo+"<>"+excRegNo+"<>"+rangeSel+"<>"+exDiv+"<>"+commi+"<>"+minIndi+"<>"+gst+"<>"+classification);

/*String bankCountry[]  	= request.getParameterValues("bankCountry");
String bankName[]  	= request.getParameterValues("bankName");
String bankRegion[]   	= request.getParameterValues("bankRegion");
String bankStreet[]   	= request.getParameterValues("bankStreet");
String bankCity[]     	= request.getParameterValues("bankCity");
String bankBranch[] 	= request.getParameterValues("bankBranch");
String bankIFSCCode[] 	= request.getParameterValues("bankIFSCCode");
String bankACCode[] 	= request.getParameterValues("bankACCode");
String bankCurrency[] 	= request.getParameterValues("bankCurrency");
String bankKey[] 	= request.getParameterValues("bankKey");
String isDelete 	= "N";

out.println("::::::::"+Arrays.toString(bankKey)+"<>"+Arrays.toString(bankCurrency)+"<>"+Arrays.toString(bankACCode)+"<>"+Arrays.toString(bankIFSCCode)+"<>"+Arrays.toString(bankRegion)+"<>"+Arrays.toString(bankBranch)+"<>"+Arrays.toString(bankStreet)+"<>"+Arrays.toString(bankCity)+"<>"+Arrays.toString(bankBranch)+"<>"+Arrays.toString(bankCountry)+"<>"+Arrays.toString(bankName)+"<>"+Arrays.toString(bankACCode));
*/
String pTerms 	   = checkNull(request.getParameter("pTerms"));
String paymMethod  = checkNull(request.getParameter("paymMethod"));
String creatDate   = checkNull(request.getParameter("creatDate"));
String houseBank   = checkNull(request.getParameter("houseBank"));
String schemaGroup = checkNull(request.getParameter("schemaGroup"));
String cerificateDate = checkNull(request.getParameter("cDate"));
ezc.ezcommon.EzLog4j.log(":::::SystemKey:::::"+SystemKey,"I");
String template="";

	EzcSysConfigParams sparams2 = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams2 = new EzcSysConfigNKParams();
	snkparams2.setLanguage("EN");
	snkparams2.setSystemKey(SystemKey);
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

	ezc.ezcommon.EzLog4j.log(":::::template::::::"+template,"I");


	ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
	ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
	ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	snkparams1.setSystemKey(SystemKey);
	snkparams1.setSiteNumber(200);
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);
	String myPurOrg="";
	
	if(retdef!=null){
		for(int d=0;d<retdef.getRowCount();d++){
			if("PURORG".equals(retdef.getFieldValueString(d,"ECAD_KEY"))){
				myPurOrg=retdef.getFieldValueString(d,"ECAD_VALUE");
				break;
			}
		}
			
	}


	String userGroupKey ="";//checkNull((String)session.getValue("USERGROUP"));
	String checkRole    ="";//checkNull((String)session.getValue("USERROLE"));

	ReturnObjFromRetrieve rettempUser	=  null;
	int    rettempUserCnt	=  0;

	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams				= new EziMiscParams();
	miscParams.setQuery("Select * from (SELECT EWW_ROLE_NO ROLE, EWOD_PARTICIPANT OWNERPARTICIPANT, EWOD_PARTICIPANT_TYPE OPTYPE, EWOD_PARENT PARENT,ESKD_SYS_KEY SYSKEY, ECAD_VALUE PURCHGRP, EWOD_LEVEL STEP,EWWU_USER USER_ID FROM EZC_WF_ORGONAGRAM_DETAILS,EZC_WF_ORGONAGRAM,EZC_WF_WORKGROUPS,EZC_WF_WORKGROUP_USERS, EZC_SYSTEM_KEY_DESC, EZC_CAT_AREA_DEFAULTS WHERE EWO_CODE=EWOD_CODE AND EWO_TEMPLATE IN ('"+template+"') AND EWWU_GROUP=EWOD_PARTICIPANT  AND ESKD_SYS_KEY=ECAD_SYS_KEY AND ECAD_KEY='PURGROUP' AND EWWU_SYSKEY=ESKD_SYS_KEY AND EWW_GROUP=EWWU_GROUP AND ESKD_SYS_KEY IN ('"+SystemKey+"')   ORDER BY CAST(EWOD_LEVEL AS UNSIGNED))a");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		rettempUser=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");}
	if(rettempUser!=null)
	{
		rettempUserCnt	= rettempUser.getRowCount();
	}
	
	if("".equals(userGroupKey))userGroupKey=rettempUser.getFieldValueString(0,"OWNERPARTICIPANT").trim();//"VENDOR"
	if("".equals(checkRole))checkRole=rettempUser.getFieldValueString(0,"ROLE").trim();//"VENDOR_SYS_DEP"

	ezc.ezcommon.EzLog4j.log(checkRole+"::::::::checkRole:::::::userGroupKey::::"+userGroupKey,"I");
	
	
	ReturnObjFromRetrieve vendorProfileRetObj =null;
	String vendorProfileId="";
	
	mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorExciseDataParams  exciseDataParams = new EziVendorExciseDataParams();
					
	EziVendorPurOrgTable purOrgTable = new EziVendorPurOrgTable();
	EziVendorPurOrgTableRow purOrgTableRow = new EziVendorPurOrgTableRow();

	EziVendorBankMasterTable bankMasterTable = new EziVendorBankMasterTable();
	EziVendorBankMasterTableRow bankMasterTableRow = new EziVendorBankMasterTableRow();
	
	EziVendorBankDetailsTable bankDetailsTable = new EziVendorBankDetailsTable();
	EziVendorBankDetailsTableRow bankDetailsTableRow = new EziVendorBankDetailsTableRow();

	EziVendorPartnersTable vendorPartnersTable = new EziVendorPartnersTable();
	EziVendorPartnersTableRow vendorPartnersTableRow = new EziVendorPartnersTableRow();

	EziVendorEmailTable vendorEmailTable = new EziVendorEmailTable();
	EziVendorEmailTableRow vendorEmailTableRow = new EziVendorEmailTableRow();

	EziVendorTelephoneTable vendorTelephoneTable = new EziVendorTelephoneTable();
	EziVendorTelephoneTableRow vendorTelephoneTableRow = new EziVendorTelephoneTableRow();

	EziVendorFaxTable vendorFaxTable = new EziVendorFaxTable();
	EziVendorFaxTableRow vendorFaxTableRow = new EziVendorFaxTableRow();
	
	EziVendorContactPersonTable vendorContactPersonTable = new EziVendorContactPersonTable();
	EziVendorContactPersonTableRow vendorContactPersonTableRow = new EziVendorContactPersonTableRow();

	keyParams.setKey("ADD_VENDOR_PROFILE");
	mainParams.setLocalStore("Y");

	//vendCode=Integer.parseInt(vendCode)+"";
	generalParams.setVendor(vendCode);
	generalParams.setAccGrp(procGrp);
	generalParams.setTitle(titleSel);
	generalParams.setVendType(vendType);
	generalParams.setStatus("OPEN");
	generalParams.setName1(name1);
	generalParams.setName2(name2);
	generalParams.setName3(addr1);
	generalParams.setName4(addr2);
	generalParams.setStreet(street);
	generalParams.setHouseNum("");
	generalParams.setCity(city);
	generalParams.setDistrict(district);
	generalParams.setState(state);
	generalParams.setCountry("IN");
	generalParams.setPin(pin);
	generalParams.setLandline(landline);
	generalParams.setFax(fax);
	generalParams.setMobile(mobile);
	generalParams.setEmail(email);
	generalParams.setAddrNr(myPurOrg);
	generalParams.setModifiedBy(vendCode);
	generalParams.setSearchTerm("");
	generalParams.setPurpose("");
	generalParams.setPaymentMethod("");
	generalParams.setReconAccount("");
	//generalParams.setCertificationDate(cerificateDate);
	

	purOrgTableRow.setVendor(vendCode);
	purOrgTableRow.setPurOrg(myPurOrg);
	purOrgTableRow.setGrInvInd(grBased);
	purOrgTableRow.setSrvInvInd(serBased);
	purOrgTableRow.setCurrency("INR");
	purOrgTable.appendRow(purOrgTableRow);
	
	generalParams.setCompCode(compCode);
	generalParams.setMinorityInd(minIndi);
	generalParams.setPayTerms(pTerms);
	generalParams.setHouseBank(houseBank);
	generalParams.setCreationDate(" ");
	generalParams.setPayMethod(paymMethod);
	generalParams.setSchemaGroup(schemaGroup);
	
	exciseDataParams.setVendor(vendCode);
	exciseDataParams.setSrvTax(servTax);
	exciseDataParams.setExcRegNo(excRegNo);
	exciseDataParams.setExcDiv(exDiv);
	exciseDataParams.setVat(vat);
	exciseDataParams.setCst(cst);
	exciseDataParams.setGst(gst);
	exciseDataParams.setClassification(classification);
	exciseDataParams.setEccNo(eccNo);
	exciseDataParams.setExRange(rangeSel);
	exciseDataParams.setExComm(commi);
	exciseDataParams.setPanNo(pan);
	exciseDataParams.setVendType("test");
	exciseDataParams.setMinorityInd(minIndi);
	
	/*if((bankCountry!=null) && (bankACCode!=null))
	{
		for(int k=0;k<bankCountry.length;k++)
		{
	if ((bankACCode[k]==null)||(bankACCode[k].equals("")))
			continue;

			 bankDetailsTableRow = new EziVendorBankDetailsTableRow();
			 bankDetailsTableRow.setVendor(vendCode);
			 bankDetailsTableRow.setAccountNum(bankACCode[k]);
			 bankDetailsTableRow.setAccountName(bankName[k]);
			 bankDetailsTableRow.setCountry(bankCountry[k]);
			 bankDetailsTableRow.setKey(bankKey[k]);
			 bankDetailsTableRow.setValidFrom("18/05/2017");
			 bankDetailsTableRow.setValidTo("20/05/2017");	
			 bankDetailsTableRow.setIsDelete(isDelete);
			 bankDetailsTable.appendRow(bankDetailsTableRow);
		}
	}
	*/
	vendorPartnersTableRow.setVendor(vendCode);
	vendorPartnersTableRow.setPurOrg("1001");
	vendorPartnersTableRow.setPlant("1100");
	vendorPartnersTableRow.setPartnerFun("VN");
	vendorPartnersTableRow.setPartnerNum("1321");
	vendorPartnersTable.appendRow(vendorPartnersTableRow);

	vendorEmailTableRow.setVendor(vendCode);
	vendorEmailTableRow.setAddrNr("123");
	vendorEmailTableRow.setEmail(email);
	vendorEmailTable.appendRow(vendorEmailTableRow);

	vendorTelephoneTableRow.setVendor(vendCode);
	vendorTelephoneTableRow.setAddrNr("123");
	vendorTelephoneTableRow.setTelPhone(landline);
	vendorTelephoneTableRow.setTelPhoneExt("040");
	vendorTelephoneTableRow.setCountry(country);
	vendorTelephoneTable.appendRow(vendorTelephoneTableRow);
					
	vendorFaxTableRow.setVendor(vendCode);
	vendorFaxTableRow.setAddrNr("123");
	vendorFaxTableRow.setFax(fax);
	vendorFaxTableRow.setFaxExt("456");
	vendorFaxTableRow.setCountry(country);
	vendorFaxTable.appendRow(vendorFaxTableRow);
	
	if(!"".equals(contPers1))
	{
	vendorContactPersonTableRow = new EziVendorContactPersonTableRow();
	vendorContactPersonTableRow.setVendor(vendCode);
	vendorContactPersonTableRow.setContactPerson(contPers1);
	vendorContactPersonTableRow.setExt1("");
	vendorContactPersonTable.appendRow(vendorContactPersonTableRow);
	}
	if(!"".equals(contPers2) && !contPers1.equals(contPers2))
	{
	vendorContactPersonTableRow = new EziVendorContactPersonTableRow();
	vendorContactPersonTableRow.setVendor(vendCode);
	vendorContactPersonTableRow.setContactPerson(contPers2);
	vendorContactPersonTableRow.setExt1("");
	vendorContactPersonTable.appendRow(vendorContactPersonTableRow);
	}
	/*
	if((bankCountry!=null) && (bankACCode!=null))
	{
		for(int k=0;k<bankCountry.length;k++)
		{if ((bankACCode[k]==null)||(bankACCode[k].equals("")))
			continue;
			 bankMasterTableRow = new EziVendorBankMasterTableRow();
			bankMasterTableRow.setVendor(vendCode);
			bankMasterTableRow.setCountryKey(bankCountry[k]);
			bankMasterTableRow.setKey(bankKey[k]);
			bankMasterTableRow.setStreet(bankStreet[k]);
			bankMasterTableRow.setIfscCode(bankIFSCCode[k]);
			bankMasterTableRow.setBankName(bankName[k]);
			bankMasterTableRow.setCity(bankCity[k]);
			bankMasterTableRow.setAcCode(bankACCode[k]);
			bankMasterTableRow.setRegion(bankRegion[k]);
			bankMasterTableRow.setBranch(bankBranch[k]);
			bankMasterTableRow.setCurrency(bankCurrency[k]);
			bankMasterTableRow.setIsDelete(isDelete);
			bankMasterTable.appendRow(bankMasterTableRow);         
		}
	}
	*/
		
	mainParams.setObject(keyParams);	
	mainParams.setObject(vendorFaxTable);
	mainParams.setObject(vendorTelephoneTable);
	mainParams.setObject(vendorEmailTable);
	mainParams.setObject(vendorPartnersTable);
	mainParams.setObject(bankMasterTable);
	mainParams.setObject(vendorContactPersonTable);
	mainParams.setObject(bankDetailsTable);
	mainParams.setObject(exciseDataParams);
	mainParams.setObject(purOrgTable);
	mainParams.setObject(generalParams);
	Session.prepareParams(mainParams);
	
	try{
		 ReturnObjFromRetrieve vendorDtlsObj=(ReturnObjFromRetrieve)vendorprofile.ezSaveDetails(mainParams);
		 vendorDtlsObj=((ReturnObjFromRetrieve)vendorDtlsObj.getObject("GetGeneralData"));
	 	if(vendorDtlsObj!=null)
	 	{
	 	vendorProfileId = checkNull(vendorDtlsObj.getFieldValueString(0,"EVGD_DOC_ID"));
	 	}
	 }catch(Exception e){System.out.println(e);}
ezc.ezcommon.EzLog4j.log(":::::vendorProfileId::::::::"+vendorProfileId,"I");
try
{
	if(!"".equals(vendorProfileId))
	{
		//dispMessage="Request "+vendorProfileId+" has been submitted to the admin user";
		dispMessage="Your request has been submitted succesfully to coromandel.<br> Request No: "+myPurOrg+vendorProfileId+" Helpdesk Number: +91-9999999999";
		dispMsgType="S";
		String attachflag 	= checkNull(request.getParameter("attachFlag"));
		if("".equals(attachflag))attachflag="N";
		ezc.ezcommon.EzLog4j.log("::::::attachflag qry:::::::::::"+attachflag,"I");

		if("Y".equals(attachflag))
		{
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			mainParams=new ezc.ezparam.EzcParams(false); 
			
			
			String attachDocDesc = request.getParameter("attachDocDesc");
			String attachDocFiles = request.getParameter("attachDocFiles");
			String attachFileTime = request.getParameter("attachFileTime");
			String attachType = request.getParameter("attachType");
			String tempAttachFile="";

			ezc.ezcommon.EzLog4j.log("::::::attachDocDesc qry:::::::::::"+attachDocDesc,"I");
			ezc.ezcommon.EzLog4j.log("::::::attachDocFiles qry:::::::::::"+attachDocFiles,"I");

			Hashtable docDescFiles = new Hashtable();
			Hashtable docTypeFiles = new Hashtable();
  
			if(attachDocFiles.indexOf("¥")>0)
			{
				String[] attachDocFilesArr = attachDocFiles.split("¥");
				String[] attachDocDescArr = attachDocDesc.split("¥");
				String[] attachFileTimeArr = attachFileTime.split("¥");
				String[] attachTypeArr = attachType.split("¥");

				if(attachDocFilesArr!=null)
				{
					for(int i=0;i<attachDocFilesArr.length;i++)
					{		
						int lastindex = attachDocFilesArr[i].lastIndexOf("\\");

						try{
						if(lastindex>=0)
							tempAttachFile = attachDocFilesArr[i].substring(lastindex+1,attachDocFilesArr[i].length());
						else
						tempAttachFile=attachDocFilesArr[i];
						
						}catch(Exception e){tempAttachFile=attachDocFilesArr[i];ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");}
						ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");

						docDescFiles.put(attachFileTimeArr[i]+"_"+tempAttachFile,attachDocDescArr[i]);
						docTypeFiles.put(attachFileTimeArr[i]+"_"+tempAttachFile,attachTypeArr[i]);
					}
				}
			}else
			{
				int lastindex = attachDocFiles.lastIndexOf("\\");
					ezc.ezcommon.EzLog4j.log("::::::lastindex2:::::::::::"+lastindex,"I");

				try{
				if(lastindex>=0)
					tempAttachFile = attachDocFiles.substring(lastindex+1,attachDocFiles.length());
				else
					tempAttachFile=attachDocFiles;
				}catch(Exception e){tempAttachFile=attachDocFiles;ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");}
						ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");

				docDescFiles.put(attachFileTime+"_"+tempAttachFile,attachDocDesc);
				docTypeFiles.put(attachFileTime+"_"+tempAttachFile,attachType);
			}

			ezc.ezcommon.EzLog4j.log("::::::docDescFiles qry:::::::::::"+docDescFiles,"I");

			String srcPath="",destinationPath="";

			try
			{
				ResourceBundle site1= ResourceBundle.getBundle("Site");
				srcPath=site1.getString("UPLOADTEMPDIR");
				destinationPath=site1.getString("SERVERUPLOADPATH");
			}
			catch(Exception e)
			{ 
			    ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
			}

			ezc.ezcommon.EzLog4j.log("::::::srcPath qry:::::::::::"+srcPath,"I"); 
			File srcDir	= new File(srcPath+session.getId());
  
			File[] files = null;

			if(srcDir.exists())
			files = srcDir.listFiles();

			FileChannel in = null;
			FileChannel outSt = null;

			if(files!=null)
			{
				ezc.ezcommon.EzLog4j.log("******files.length*****"+files.length,"I");

				for (int i=0;i<files.length;i++)
				{

					String fileName	 = files[i].getName();

					ezc.ezcommon.EzLog4j.log("******fileName*****"+fileName,"I");

					try
					{
						in = new FileInputStream(files[i]).getChannel();
						File destFolder	= null;

//						destFolder	= new File("D:\\EZC\\EzCom\\Upload\\"+vendorProfileId);
						destFolder	= new File(destinationPath+vendorProfileId);


						if (!destFolder.exists())
						destFolder.mkdirs();

						String serFileName=vendorProfileId+"\\\\"+fileName;

						String attachmentDesc = (String)docDescFiles.get(fileName);
						String attachmentType= (String)docTypeFiles.get(fileName);

						if(attachmentDesc==null || "null".equals(attachmentDesc))attachmentDesc="";
						if(attachmentType==null || "null".equals(attachmentType))attachmentType="";

						if(!"".equals(attachmentDesc))
						{
							File outFile 	= new File(destFolder, fileName);
							outSt 		= new FileOutputStream(outFile).getChannel();
							in.transferTo(0, in.size(), outSt);

							attachmentDesc = attachmentDesc.replaceAll("'","`");
							attachmentDesc = attachmentDesc.replaceAll("\"","``");

							ezc.ezcommon.EzLog4j.log("******serFileName*****"+serFileName,"I");
							String qry="INSERT INTO EZC_UPLOAD_FILES (EUF_DOC_ID,EUF_ATTACHED_BY,EUF_ATTACHED_DATE,EUF_FILE_DESCRTIPTION,EUF_CLIENT_FILE_NAME,EUF_SERVER_FILE_NAME,EUF_EXT1,EUF_EXT2,EUF_EXT3) VALUES('"+vendorProfileId+"','"+Session.getUserId()+"',NOW(),'"+attachmentDesc+"','"+fileName+"','"+serFileName+"','"+attachmentType+"','','')" ;
							ezc.ezcommon.EzLog4j.log("******EZC_UPLOAD_FILES qry*****"+qry,"I");

							miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
							miscTableRow.setQuery(qry);
							miscTable.appendRow(miscTableRow);
						}
						files[i].delete();
					}
					catch (Exception e)
					{
						ezc.ezcommon.EzLog4j.log(" : :Error occured while moving files ::::"+e,"E");
					}
					finally
					{
						if (in != null)
						in.close();
						if (outSt != null)
						outSt.close();

					}


				}	
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);

				ezc.ezparam.ReturnObjFromRetrieve retObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(mainParams);
				try{
					for (File file : files)
					{
					file.delete();
					}

				}catch(Exception e){ezc.ezcommon.EzLog4j.log("::::::Batch query execution failed in ezSaveCRNDetails::::::"+e,"E");}
			}
		}		
		session.removeValue("ATTACHEDFILES");
		
		mainParams = new ezc.ezparam.EzcParams(false);
		 ezc.ezworkflow.params.EziWFParams eziWfparams 	= new ezc.ezworkflow.params.EziWFParams();
		 ezc.ezworkflow.params.EziWFDocHistoryParams eziWfDocHis = new ezc.ezworkflow.params.EziWFDocHistoryParams();
		 eziWfparams.setRole(checkRole);
		 eziWfDocHis.setStatus("SUBMITTED");
		 eziWfDocHis.setSysKey(SystemKey);
		 eziWfDocHis.setTemplateCode(template);
		 eziWfDocHis.setModifiedBy(userId);
		 eziWfDocHis.setCreatedBy(userId);
		 eziWfDocHis.setAction("100066");
		 eziWfDocHis.setParticipant(userGroupKey);
		 eziWfparams.setParticipant(userGroupKey);
		eziWfDocHis.setDocId(vendorProfileId);
		eziWfDocHis.setAuthKey("VENDOR_ENQUIRY");
		eziWfDocHis.setSoldTo(userId);

		mainParams.setObject(eziWfparams);
		mainParams.setObject(eziWfDocHis);
		Session.prepareParams(mainParams);
		
		try{
		ezc.ezparam.ReturnObjFromRetrieve retPoWorkFlow = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.updateWFDoc(mainParams);	
		}catch(Exception e){}
		
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
		eziWFAuditTrailParams.setEwhType("SUBMITTED");
		eziWFAuditTrailParams.setEwhSourceParticipant((String)Session.getUserId());
		eziWFAuditTrailParams.setEwhSourceParticipantType("U");
		eziWFAuditTrailParams.setEwhDestParticipant("PURPERSON");
		eziWFAuditTrailParams.setEwhDestParticipantType("U");
		eziWFAuditTrailParams.setEwhComments("Request "+vendorProfileId+" has been submitted from "+(String)Session.getUserId()+" to PURPERSON");

		mainParams.setObject(keyParams);	
		mainParams.setObject(eziWFAuditTrailParams);
		Session.prepareParams(mainParams);

		try{
			
			//vendorprofile.ezSaveDetails(mainParams);
		}catch(Exception e){}

		
		String sendToUser= (String)Session.getUserId()+",PURPERSON";

		String msgSubject = "Vendor profile has been submitted";
		String msgText = "Dear Sir/Madam<br> Vendor profile request "+myPurOrg+vendorProfileId+" has been submitted.&nbsp;<br>";
		msgText = msgText+"<BR>";
		//msgText += "<br>Regards,<br>"+v_fname+v_mname+v_lname;
		
		
		String inboxPath="";
	 	
		
%>	
	<%//@ include file="../Misc/ezSendMailVendProfile.jsp" %>		
<%	
	}
}catch(Exception e){ezc.ezcommon.EzLog4j.log("::::::Exception in ezSave::::::"+e,"E");}
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
	<!--<Div class="row">
		<Div class=" col-md-12 col-sm-12 col-xs-12"> 
			<Div class="box box-info collapsed-box" >
				<Div class="box-body" style="display: block;" styel="height:20%">
				<br>
				<center><b><%=dispMessage%></b><center>
				</Div>
			</Div>
		</Div>
	</Div>   -->
	
	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      
<%	
	String autoLogout = request.getParameter("AUTOLOGOUT");
	if(autoLogout == null)
		autoLogout = "";
	try{ Session.logOut(); } catch(Exception e) { System.out.println("Exception while logout"); } 
%>