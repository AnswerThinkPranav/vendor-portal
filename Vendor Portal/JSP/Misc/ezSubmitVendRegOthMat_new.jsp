<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*" %>   
<%@ page import="java.util.*"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%@ include file="../Misc/ezNACompCodeMap.jsp"%> 
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
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retErrorObj	  =	null;
	
	int contctLineNumberVal=0;
	int topCusLineNumberVal=0;
	int plantSiteLineNumberVal=0;
	int DPASLineNumberVal=0;
	String docId=checkNull(request.getParameter("docId"));
	String vendName=checkNull(request.getParameter("vendName"));
	String actionSts=checkNull(request.getParameter("actionSts"));

	String purOrg  		= request.getParameter("purOrg");
	String compCode 	= request.getParameter("compCode");
	String category 	= request.getParameter("category");
	String venWFPlant  	= request.getParameter("venWFPlant");
	String venWFCategory  	= request.getParameter("venWFCategory");
	
	String wfTemplate	= request.getParameter("wfTemplate");
	String wfCurStep	= request.getParameter("wfCurStep");
	
	ezc.ezcommon.EzLog4j.log("docId>>>>>first_Approver>>>"+docId,"I");
	ezc.ezcommon.EzLog4j.log("vendName>>>>first_Approver>>>>"+vendName,"I");
	ezc.ezcommon.EzLog4j.log("purOrg>>>>>first_Approver>>>"+purOrg,"I");
	ezc.ezcommon.EzLog4j.log("compCode>>>>first_Approver>>>>"+compCode,"I");
	ezc.ezcommon.EzLog4j.log("category>>>>>first_Approver>>>"+category,"I");
	ezc.ezcommon.EzLog4j.log("venWFPlant>>>first_Approver>>>>>"+venWFPlant,"I");
	ezc.ezcommon.EzLog4j.log("venWFCategory>>>>first_Approver>>>>"+venWFCategory,"I");
	ezc.ezcommon.EzLog4j.log("wfTemplate>>>>>first_Approver>>>"+wfTemplate,"I");
	ezc.ezcommon.EzLog4j.log("wfCurStep>>>>first_Approver>>>>"+wfCurStep,"I");
	

	
	String template = "";
	ezc.ezparam.ReturnObjFromRetrieve wfTemRet = getWFTemplate(Session,"VNR",venWFPlant,venWFCategory,compCode);
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
	
	String ccEmailStr = getUserMail(Session,(String)Session.getUserId());
	ezc.ezcommon.EzLog4j.log("ccEmailStr in WF =====**"+ccEmailStr,"I");	
	
	//MAIL
	String mailSub="New Vendor Registration details submitted for your approval - "+docId;
	String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

	String mailText="Dear Sir/Madam,<br> Below Request details submitted for your approval<br>";
	mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
	mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Doc Id</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+docId+"</Td></Tr>";	
	mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Vendor Name</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+vendName+"</Td></Tr>";	
	mailText +=  "</Table><Br>";
	mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	mailText +=  "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";					
	
	if("4".equals(userType))
	{
		if("V".equals(actionSts) && "4".equals(userType) || "U".equals(actionSts) && "4".equals(userType))
		{
			String tabVal1=checkNull(request.getParameter("tabVal1"));
			String tabVal2=checkNull(request.getParameter("tabVal2"));
			String tabVal3=checkNull(request.getParameter("tabVal3"));
			String tabVal4=checkNull(request.getParameter("tabVal4"));
			String tabVal5=checkNull(request.getParameter("tabVal5"));


			String qry="";

			qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='BANK_DET'";
			miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery(qry);
			miscTable.appendRow(miscTableRow);	

			addKeyRow(docId,"BANK_DET","accnt_Per",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Mobile",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Email",request,miscTable);
			addKeyRow(docId,"BANK_DET","rtgs_Code",request,miscTable);
			addKeyRow(docId,"BANK_DET","bankName",request,miscTable);
			addKeyRow(docId,"BANK_DET","bank_Branch",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Number",request,miscTable);
			addKeyRow(docId,"BANK_DET","bank_Swift",request,miscTable);
			addKeyRow(docId,"BANK_DET","chequeNo",request,miscTable);
			
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
				ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = null;
				if(!naCompHt.contains(compCode))
				{
				currentStep = "0";
				ezc.ezcommon.EzLog4j.log("currentStep>>>>>>>>"+currentStep,"I");
				 wfNextPartRet = getNextPart(Session,template,Integer.parseInt(currentStep));
				ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>0_user>>>"+wfNextPartRet.toEzcString(),"I");
				}else{
				currentStep = "2";
				ezc.ezcommon.EzLog4j.log("currentStep>>>>>>>>"+currentStep,"I");
				 wfNextPartRet = getNextPart(Session,template,Integer.parseInt(currentStep));
				ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>2_user>>>"+wfNextPartRet.toEzcString(),"I");
				
				}
				if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
				{
					currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
					nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
					wfStatus = "SUBMITTED";
					
					ezc.ezcommon.EzLog4j.log("currentStep>>>first_Approver>>>>>"+currentStep,"I");
					ezc.ezcommon.EzLog4j.log("nextPart>>>>first_Approver>>>>"+nextPart,"I");
					ezc.ezcommon.EzLog4j.log("wfStatus>>>>>first_Approver>>>"+wfStatus,"I");
				}		

				java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
				if(!naCompHt.contains(compCode))
				{
					if("V".equals(actionSts) && "4".equals(userType))
					{
						queriesList.add("INSERT INTO EZC_WF_DOC_HISTORY_HEADER(EWDHH_AUTH_KEY,EWDHH_DOC_ID,EWDHH_SYSKEY,EWDHH_TEMPLATE_CODE,EWDHH_WF_STATUS,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_MODIFIED_BY,EWDHH_CURRENT_STEP,EWDHH_NEXT_PARTICIPANT) VALUES('VNR','"+docId+"','"+sysKey+"','"+template+"','"+wfStatus+"',now(),now(),'"+Session.getUserId()+"','"+Session.getUserId()+"',"+currentStep+",'"+nextPart+"')");

					}
					else if("U".equals(actionSts) && "4".equals(userType))
					{

						queriesList.add("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='"+wfStatus+"',EWDHH_CURRENT_STEP='"+currentStep+"',EWDHH_NEXT_PARTICIPANT='"+nextPart+"' WHERE EWDHH_DOC_ID='"+docId+"' and EWDHH_AUTH_KEY='VNR'");
										
					}
				}
				else
				{
					queriesList.add("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='"+wfStatus+"',EWDHH_CURRENT_STEP='"+currentStep+"',EWDHH_NEXT_PARTICIPANT='"+nextPart+"' WHERE EWDHH_DOC_ID='"+docId+"' and EWDHH_AUTH_KEY='VNR'");
				}
					
				queriesList.add("UPDATE EZC_CUSTOMER_FORM_HEADER SET ECFH_STATUS='"+wfStatus+"',ECFH_MODIFIED_BY='"+Session.getUserId()+"',ECFH_MODIFIED_ON=now()  WHERE ECFH_DOC_ID='"+docId+"'");				
				queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+docId+"','VNR','"+comments+"','"+Session.getUserId()+"',now())");
				ezMiscInsert(Session,queriesList);
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
		}
	}
	else if("2".equals(userType))
	{
		if("VAR".equals(userRole) && "S".equals(actionSts))
		{
			String qry="";

			qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='BANK_DET' AND ECFD_FIELD in('reconAccount','whTaxType','whTaxCode','recType','docAck')";
			miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery(qry);
			miscTable.appendRow(miscTableRow);
			
			addKeyRow(docId,"BANK_DET","whTaxType",request,miscTable);
			addKeyRow(docId,"BANK_DET","whTaxCode",request,miscTable);			
			addKeyRow(docId,"BANK_DET","recType",request,miscTable);
			addKeyRow(docId,"BANK_DET","reconAccount",request,miscTable);
			addKeyRow(docId,"BANK_DET","docAck",request,miscTable);
			
			try
			{
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams); 
				retErrorObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(mainParams);
			}
			catch(Exception e){}			
			
		}
		
		if("S".equals(actionSts))
		{
			//FILE UPLOAD for VEN
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

			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,Integer.parseInt(wfCurStep));
			ezc.ezcommon.EzLog4j.log("wfNextPartRet>>>>>type_2_user>>>"+wfNextPartRet.toEzcString(),"I");
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
				wfStatus = "SUBMITTED";
				
				ezc.ezcommon.EzLog4j.log("currentStep>>>>>>>>"+currentStep,"I");
				ezc.ezcommon.EzLog4j.log("nextPart>>>>>>>>"+nextPart,"I");
				ezc.ezcommon.EzLog4j.log("wfStatus>>>>>>>>"+wfStatus,"I");
			}
			dispStr = "Request details submitted for approval. Doc Id : "+docId+"";
			
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
		}
		else if("R".equals(actionSts))
		{

			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,0);
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
				wfStatus = "REJECTED";
				
				ezc.ezcommon.EzLog4j.log("currentStep>>>>reject>>>>"+currentStep,"I");
				ezc.ezcommon.EzLog4j.log("nextPart>>>reject>>>>>"+nextPart,"I");
				ezc.ezcommon.EzLog4j.log("wfStatus>>>>reject>>>>"+wfStatus,"I");
			}			
			
			dispStr = "Request details has been Rejected. Doc Id : "+docId+"";
		}		
		else if("A".equals(actionSts))
		{

			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,0);
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
				wfStatus = "APPROVED";
				ezc.ezcommon.EzLog4j.log("currentStep>>>>Approve>>>>"+currentStep,"I");
				ezc.ezcommon.EzLog4j.log("nextPart>>>Approve>>>>>"+nextPart,"I");
				ezc.ezcommon.EzLog4j.log("wfStatus>>>>Approve>>>>"+wfStatus,"I");
			}			
			
			dispStr = "Request details has been approved. Doc Id : "+docId+"";
		}
		else if("B".equals(actionSts))
		{

			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,0);
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep="0";
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
				wfStatus = "RESUBMITTED";
				
				ezc.ezcommon.EzLog4j.log("currentStep>>>>RESUBMITTED>>>>"+currentStep,"I");
				ezc.ezcommon.EzLog4j.log("nextPart>>>RESUBMITTED>>>>>"+nextPart,"I");
				ezc.ezcommon.EzLog4j.log("wfStatus>>>>RESUBMITTED>>>>"+wfStatus,"I");
			}			
			
			dispStr = "Request details has been Sent back to vendor: "+docId+"";
		}		

		
		ezc.misctransactions.client.EzMiscTransactionsManager gv_miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable gv_miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow gv_miscTableRow = null;
		
		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery("UPDATE EZC_CUSTOMER_FORM_HEADER SET ECFH_STATUS='"+wfStatus+"',ECFH_MODIFIED_ON=now(),ECFH_MODIFIED_BY='"+Session.getUserId()+"' WHERE ECFH_DOC_ID='"+docId+"'");
		gv_miscTable.appendRow(gv_miscTableRow);		
		
		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='"+wfStatus+"',EWDHH_CURRENT_STEP='"+currentStep+"',EWDHH_NEXT_PARTICIPANT='"+nextPart+"' WHERE EWDHH_DOC_ID='"+docId+"' and EWDHH_AUTH_KEY='VNR'");
		gv_miscTable.appendRow(gv_miscTableRow);		

		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+docId+"','VNR','"+comments+"','"+Session.getUserId()+"',now())");
		gv_miscTable.appendRow(gv_miscTableRow);

		ezc.ezparam.EzcParams ezcContainer = new ezc.ezparam.EzcParams(false); 
		ezcContainer.setLocalStore("Y");
		ezcContainer.setObject(gv_miscTable);
		Session.prepareParams(ezcContainer);	
		gv_miscMgr.ezSaveMiscTransactions(ezcContainer);
		
		saveWFDocAudit(Session,docId,"VNR","Request details "+wfStatus.toLowerCase()+" by "+Session.getUserId()+"["+v_fullName+"]","U");
				
	}	
		boolean isError = false;

		String display_header = "Confirmation";
%>
	<html> 
	<head>
	<script>
	function checkList()
	{
		location.href="../Misc/ezWelcome_New.jsp";
	}
	</script>
	</head>
	<body scroll=no>
	<form name="myForm" method="post">
	<%@ include file="../Misc/ezSubHeader.jsp"%> 
	<Br><Br><Br>
	<center> 
	
	<div class="alert alert-<%=isError?"error":"success"%>" style="width:30%">
	<h4><i class="icon fa fa-check"></i> <%=isError?"Error":"Success"%></h4>
	<%=dispStr%>
	</div>
	</center>
	<Br><Br><Br>
	<center>
		<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	
	</center>
	<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
 

