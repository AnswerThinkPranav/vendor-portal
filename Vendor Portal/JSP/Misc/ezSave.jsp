<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>


<%!
public String checkNull(String value)
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	return value;
}
%>
<%
EziMiscParams miscParams = new EziMiscParams();

String displayMsg="Problem occured while submitting the request";

String vendCode = request.getParameter("vendCode");
String compCode = request.getParameter("compCode");
String serBased = request.getParameter("serBased");
//String venName  = request.getParameter("venName");
//String corLoc   = request.getParameter("corLoc");
String grBased  = request.getParameter("grBased");
String procGrp  = request.getParameter("procGrp");

String comments  	 = checkNull(request.getParameter("comments"));

comments=comments.replaceAll("'","`");

String titleSel  	 = request.getParameter("titleSel");
String name1  	 	 = request.getParameter("name1");
String name2  	 	 = request.getParameter("name2");
String addr1  	  	 = request.getParameter("addr1");
String addr2  	 	 = request.getParameter("addr2");
String street 	 	 = request.getParameter("street");
String city  	 	 = request.getParameter("city");
String state  	 	 = request.getParameter("state");
String country  	 = request.getParameter("country");
String district  	 = request.getParameter("district");
String pin  	 	 = request.getParameter("pin");
String landline  	 = request.getParameter("landline");
String mobile  	 	 = request.getParameter("mobile");
String fax  	 	 = request.getParameter("fax");
String email  	 	 = request.getParameter("email");
String contPers1  	 = request.getParameter("contPers1");
String contPers2  	 = request.getParameter("contPers2");

String vat   	= request.getParameter("vat");
String cst   	= request.getParameter("cst");
String pan   	= request.getParameter("pan");
String servTax  = request.getParameter("servTax");
String eccNo   	= request.getParameter("eccNo");
String excRegNo = request.getParameter("excRegNo");
String rangeSel = request.getParameter("rangeSel");
String exDiv   	= request.getParameter("exDiv");
String commi  	= request.getParameter("commi");
String minIndi  = request.getParameter("minIndi");

String bankCountry  	= request.getParameter("bankCountry");
String bankName  	= request.getParameter("bankName");
String bankRegion   	= request.getParameter("bankRegion");
String bankStreet   	= request.getParameter("bankStreet");
String bankCity     	= request.getParameter("bankCity");
String bankBranch 	= request.getParameter("bankBranch");
//out.println("bankBranch"+bankBranch);
String bankIFSCCode 	= request.getParameter("bankIFSCCode");
String bankACCode 	= request.getParameter("bankACCode");
String bankCurrency 	= request.getParameter("bankCurrency");

String pTerms 	   = request.getParameter("pTerms");
String paymMethod  = request.getParameter("paymMethod");
String creatDate   = request.getParameter("creatDate");
String houseBank   = request.getParameter("houseBank");
String schemaGroup = request.getParameter("schemaGroup");

	ReturnObjFromRetrieve vendorProfileRetObj =null;
	String vendorProfileId="";
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
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

vendCode=Integer.parseInt(vendCode)+"";
	generalParams.setVendor(vendCode);
	generalParams.setAccGrp(procGrp);
	generalParams.setTitle(titleSel);
	generalParams.setVendType("1234");
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
	generalParams.setCountry(country);
	generalParams.setPin(pin);
	generalParams.setLandline(landline);
	generalParams.setFax(fax);
	generalParams.setMobile(mobile);
	generalParams.setEmail(email);
	generalParams.setAddrNr("123");
	generalParams.setModifiedBy(vendCode);
	

	purOrgTableRow.setVendor(vendCode);
	purOrgTableRow.setPurOrg("FENN");
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
	exciseDataParams.setEccNo(eccNo);
	exciseDataParams.setExRange(rangeSel);
	exciseDataParams.setExComm(commi);
	exciseDataParams.setPanNo(pan);
	exciseDataParams.setVendType("test");
	exciseDataParams.setMinorityInd(minIndi);
	
	 bankDetailsTableRow.setVendor(vendCode);
	 bankDetailsTableRow.setAccountNum(bankACCode);
	 bankDetailsTableRow.setAccountName(bankName);
	 bankDetailsTableRow.setCountry(bankCountry);
	 bankDetailsTableRow.setKey("test");
	 bankDetailsTableRow.setValidFrom("18/05/2017");
	 bankDetailsTableRow.setValidTo("20/05/2017");	
	 bankDetailsTable.appendRow(bankDetailsTableRow);

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
	
	vendorContactPersonTableRow.setDocId(vendCode);
	vendorContactPersonTableRow.setVendor(vendCode);
	vendorContactPersonTableRow.setContactPerson(contPers1);
	vendorContactPersonTable.appendRow(vendorContactPersonTableRow);
	
	bankMasterTableRow.setVendor(vendCode);
	bankMasterTableRow.setCountryKey(bankCountry);
	bankMasterTableRow.setKey("test");
	bankMasterTableRow.setStreet(bankStreet);
	bankMasterTableRow.setIfscCode(bankIFSCCode);
	bankMasterTableRow.setBankName(bankName);
	bankMasterTableRow.setCity(bankCity);
	bankMasterTableRow.setAcCode(bankACCode);
	bankMasterTableRow.setRegion(bankRegion);
	bankMasterTableRow.setBranch(bankBranch);
	bankMasterTableRow.setCurrency(bankCurrency);
	bankMasterTable.appendRow(bankMasterTableRow);         

	
		
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
		 vendorProfileRetObj=(ReturnObjFromRetrieve)vendorprofile.ezSaveDetails(mainParams);
ezc.ezcommon.EzLog4j.log(vendorProfileRetObj.getRowCount()+":::::vendorProfileId::::::::"+vendorProfileId,"I");
		 if(vendorProfileRetObj!=null && vendorProfileRetObj.getRowCount()>0)
		 {		 	
		 	vendorProfileRetObj 	= (ReturnObjFromRetrieve)vendorProfileRetObj.getObject("GetGeneralData");
		 	vendorProfileId=  checkNull(vendorProfileRetObj.getFieldValueString(0,"EVGD_DOC_ID"));
		 }
	}catch(Exception e){System.out.println(e);}
ezc.ezcommon.EzLog4j.log(vendorProfileRetObj.toEzcString()+":::::vendorProfileId::::::::"+vendorProfileId,"I");
try
{
	if(!"".equals(vendorProfileId))
	{
		displayMsg="Request "+vendorProfileId+" has been submitted to the admin user";
		String attachflag 	= checkNull(request.getParameter("attachFlag"));
		if("".equals(attachflag))attachflag="N";
		ezc.ezcommon.EzLog4j.log("::::::attachflag qry:::::::::::"+attachflag,"I");

		if("Y".equals(attachflag))
		{
			String attachDocDesc = request.getParameter("attachDocDesc");
			String attachDocFiles = request.getParameter("attachDocFiles");
			String attachFileTime = request.getParameter("attachFileTime");
			String tempAttachFile="";

			ezc.ezcommon.EzLog4j.log("::::::attachDocDesc qry:::::::::::"+attachDocDesc,"I");
			ezc.ezcommon.EzLog4j.log("::::::attachDocFiles qry:::::::::::"+attachDocFiles,"I");

			Hashtable docDescFiles = new Hashtable();

			if(attachDocFiles.indexOf("¥")>0)
			{
				String[] attachDocFilesArr = attachDocFiles.split("¥");
				String[] attachDocDescArr = attachDocDesc.split("¥");
				String[] attachFileTimeArr = attachFileTime.split("¥");

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
			}

			ezc.ezcommon.EzLog4j.log("::::::docDescFiles qry:::::::::::"+docDescFiles,"I");

			String srcPath="";

			try
			{
				ResourceBundle site1= ResourceBundle.getBundle("Site");
				srcPath=site1.getString("UPLOADTEMPDIR");
			}
			catch(Exception e)
			{ 
			    System.out.println("Got Exception while getting Upload Temp Dir "+e);	
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

						destFolder	= new File("D:\\EZC\\EzCom\\Upload\\"+vendorProfileId);

						if (!destFolder.exists())
						destFolder.mkdirs();

						String serFileName=vendorProfileId+"\\\\"+fileName;

						String attachmentDesc = (String)docDescFiles.get(fileName);

						if(attachmentDesc==null || "null".equals(attachmentDesc))attachmentDesc="";

						if(!"".equals(attachmentDesc))
						{
							File outFile 	= new File(destFolder, fileName);
							outSt 		= new FileOutputStream(outFile).getChannel();
							in.transferTo(0, in.size(), outSt);

							attachmentDesc = attachmentDesc.replaceAll("'","`");
							attachmentDesc = attachmentDesc.replaceAll("\"","``");

							ezc.ezcommon.EzLog4j.log("******serFileName*****"+serFileName,"I");
							String qry="INSERT INTO EZC_UPLOAD_FILES (EUF_DOC_ID,EUF_ATTACHED_BY,EUF_ATTACHED_DATE,EUF_FILE_DESCRTIPTION,EUF_CLIENT_FILE_NAME,EUF_SERVER_FILE_NAME,EUF_EXT1,EUF_EXT2,EUF_EXT3) VALUES('"+vendorProfileId+"','"+Session.getUserId()+"',NOW(),'"+attachmentDesc+"','"+fileName+"','"+serFileName+"','','','')" ;
							ezc.ezcommon.EzLog4j.log("******EZC_UPLOAD_FILES qry*****"+qry,"I");

							mainParams = new ezc.ezparam.EzcParams(true);
							miscParams = new EziMiscParams();
							miscParams.setQuery(qry);
							mainParams.setObject(miscParams);	
							Session.prepareParams(mainParams);

							try{
							miscManager.ezAdd(mainParams);
							}catch(Exception e){}
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

				try{
					for (File file : files)
					{
					file.delete();
					}

				}catch(Exception e){ezc.ezcommon.EzLog4j.log("::::::Batch query execution failed in ezSaveCRNDetails::::::"+e,"E");}
			}
		}		
		session.removeValue("ATTACHEDFILES");
		
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
			
			vendorprofile.ezSaveDetails(mainParams);
		}catch(Exception e){}

		
		String sendToUser= (String)Session.getUserId()+",PURPERSON";

		String msgSubject = "Vendor profile has been submitted";
		String msgText = "Dear Sir/Madam<br> Vendor profile request "+vendorProfileId+" has been submitted.&nbsp;<br>";
		msgText = msgText+"<BR>";
		msgText += "<br>Regards,<br>"+Session.getUserId();
		
		
		String inboxPath="";
	 	
		
%>	
	<%@ include file="../Purorder/ezSendMail.jsp" %>		
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

  <%@ include file="ezHeader.jsp"%> 
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

	<Div class="row">
		<Div class=" col-md-12 col-sm-12 col-xs-12"> 
			<Div class="box box-info collapsed-box" >
				<Div class="box-body" style="display: block;" styel="height:20%">
				<br>
				<center><b><%=displayMsg%></b><center>
				</Div>
			</Div>
		</Div>
	</Div>         		
	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      