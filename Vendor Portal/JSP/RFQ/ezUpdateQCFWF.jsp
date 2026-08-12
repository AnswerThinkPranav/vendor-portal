<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezutil.FormatDate.*" %>
<%@ page import="ezc.ezmisc.params.*" %>
<%@ page import ="ezc.ezparam.*,java.util.*,java.text.*,java.nio.file.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../Misc/ezWFCommonMethods.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<html> 
<head>
<%@ include file="../Misc/ezHeader.jsp"%> 
<script>
	function checkList()
	{
		location.href="../Misc/ezBuyerWelcome.jsp";
	}
</script>
</head>

<%
	boolean isError = false; 
	if("Y".equals(session.getValue("QCF_WF_UPDATE")))
	{ 
		response.sendRedirect("../../../Vendor2/Library/Globals/ezValidVendorUserError.jsp");
	}
	session.putValue("QCF_WF_UPDATE","Y");
	
	
	String rfqBuyer  	= request.getParameter("rfqBuyer");
	String plant  		= request.getParameter("plant");
	String compCode 	= request.getParameter("compCode");
	String category 	= request.getParameter("category");
	String auctionId 	= request.getParameter("qcfNo");
	String docVal		= request.getParameter("docVal");
	String submitType	= request.getParameter("submitType");
	String wfTemplate	= request.getParameter("wfTemplate");
	String wfCurStep	= request.getParameter("wfCurStep");
	String wfNextPart	= request.getParameter("wfNextPart");
	
	String comments		= request.getParameter("comments");
	if(comments != null)
		comments = comments.replaceAll("'","`");
	String currentStep="";
	String nextPart="";
	String dispText="";
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
	if(!isError) 
	{	
		if("SUBMITTED".equals(submitType))
		{
			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,Integer.parseInt(wfCurStep));
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
			}
			dispText ="QCF : <strong>"+auctionId+"</strong> has been submitted for approval.";
		}
		else if("REJECTED".equals(submitType))
		{
			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,0);
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
			}
			dispText ="QCF : <strong>"+auctionId+"</strong> has been rejected.";
		}
		else if("APPROVED".equals(submitType))
		{
			//currentStep = wfCurStep;
			//nextPart = wfNextPart;
			ezc.ezparam.ReturnObjFromRetrieve wfNextPartRet = getNextPart(Session,wfTemplate,0);
			if(wfNextPartRet != null && wfNextPartRet.getRowCount()>0)
			{
				currentStep=wfNextPartRet.getFieldValueString(0,"EWPC_LEVEL");
				nextPart=wfNextPartRet.getFieldValueString(0,"EWPC_GROUP");
			}			
			dispText ="QCF : <strong>"+auctionId+"</strong> has been approved.";
		}
		ezc.misctransactions.client.EzMiscTransactionsManager gv_miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable gv_miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow gv_miscTableRow = null;

		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='"+submitType+"',EWDHH_CURRENT_STEP='"+currentStep+"',EWDHH_NEXT_PARTICIPANT='"+nextPart+"' WHERE EWDHH_DOC_ID='"+auctionId+"' and EWDHH_AUTH_KEY='QCF'");
		gv_miscTable.appendRow(gv_miscTableRow);
		
		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+auctionId+"','QCF','"+comments+"','"+Session.getUserId()+"',now())");
		gv_miscTable.appendRow(gv_miscTableRow);	

		ezc.ezparam.EzcParams ezcContainer = new ezc.ezparam.EzcParams(false); 
		ezcContainer.setLocalStore("Y");
		ezcContainer.setObject(gv_miscTable);
		Session.prepareParams(ezcContainer);	
		gv_miscMgr.ezSaveMiscTransactions(ezcContainer);
		saveWFDocAudit(Session,auctionId,"QCF","QCF details "+submitType.toLowerCase()+" by "+Session.getUserId()+"["+v_fullName+"]","U");
		
		//FILE UPLOAD for QCS
		String objNo="";
		String documentType="";
		String[] lineAttachString=null;	

		lineAttachString = request.getParameterValues("fileItem");
		//ezc.ezcommon.EzLog4j.log("auctionId>>>>>"+auctionId,"I");  
		//ezc.ezcommon.EzLog4j.log("lineAttachString in updateQCF WF>>>>>"+lineAttachString,"I"); 

		if(lineAttachString != null)
		{ 
			objNo 		= auctionId;
			documentType 	= "QCF"; 

				ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
				//for(int x=0;x<selectedPRsCnt;x++)
				//{
					String fileItemIndex = "H";
					String fileItem[]	= request.getParameterValues("fileItem"); 
					int fileLength = 0;
					if(fileItem != null)
						fileLength = fileItem.length;
						ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

					if(fileLength > 0)
					{
						String subDirPath = "QCF"+"\\"+auctionId+"\\"+fileItemIndex+"\\";
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
								File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
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
								miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+auctionId+"','"+fileItemIndex+"','QCF','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
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
		
		int retApprCnt=0;
		ReturnObjFromRetrieve retAppr= ezMiscSelect(Session,"SELECT ERH_SOLD_TO,EU_FIRST_NAME,ERH_RFQ_NO FROM EZC_RFQ_HEADER,EZC_USERS WHERE ERH_COLLETIVE_RFQ_NO='"+auctionId+"' AND ERH_STATUS='S' AND ERH_SOLD_TO=LPAD(TRIM(EU_ID),10,0)");		
		if(retAppr != null)
			retApprCnt= retAppr.getRowCount(); 
		//MAIL
		if("SUBMITTED".equals(submitType) || "REJECTED".equals(submitType) || "APPROVED".equals(submitType))
		{
			String prCreatedBy = request.getParameter("prCreatedBy");
			if(prCreatedBy==null || "null".equals(prCreatedBy))prCreatedBy="";
			String mailSub="",mailText="";
			if("SUBMITTED".equals(submitType))
			{
				mailText +=  "Dear Sir/Madam,<br> Below QCF details submitted for your approval<br><br>";
				mailSub="QCF DETAILS SUBMITTED FOR APPROVAL - "+auctionId;
			}
			else if("REJECTED".equals(submitType))
			{
				mailText +=  "Dear Sir/Madam,<br> Below QCF details rejected due to reason:<b>"+comments+"</b><br><br>";
				mailSub="QCF DETAILS REJECTED - "+auctionId;
			}			
			else if("APPROVED".equals(submitType))
			{
				mailText +=  "Dear Sir/Madam,<br>Below QCF details are approved.<br><br>";
				mailSub="QCF DETAILS APPROVED - "+auctionId;
			}
			//String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
			String offlineLink = "https://vendor.jolcorp.info/JUBL/ezLogin.jsp";
			String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
			String bgColor = "bgcolor=\"#FFFFFF\"";
			String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
			String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

			
			mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
			mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>QCF:</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+auctionId+"</Td></Tr>";	
			mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Documemnt Value</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+docVal+"</Td></Tr>";
			if(!"".equals(prCreatedBy))mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>PR Creator</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+prCreatedBy+"</Td></Tr>";
			mailText +=  "</Table><Br>";
			
			if(retApprCnt>0)
			{
				mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
				mailText +=  "<Tr align=left "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Approved Vendor(s)</B></Th></Tr>";	
				mailText +=  "</Table><Br>";
				
				
				
				for(int i=0;i<retApprCnt;i++)
				{
					mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
					mailText +=  "<Tr><Th width= \"50%\" "+thBGColor+"><B>Vendor</B></Th><Td width= \"50%\" "+tdBGColor+" colspan='7'>"+retAppr.getFieldValueString(i,"EU_FIRST_NAME")+"["+retAppr.getFieldValueString(i,"ERH_SOLD_TO")+"]"+"</Td></Tr>";
					mailText +=  "<Tr><Th width= \"50%\" "+thBGColor+"><B>RFQ</B></Th><Td width= \"50%\" "+tdBGColor+" colspan='7'>"+retAppr.getFieldValueString(i,"ERH_RFQ_NO")+"</Td></Tr>";
					
					mailText +=  "<Tr><Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
					mailText +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
					mailText +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
					mailText +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
					mailText +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
					mailText +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
					mailText +=  "<Th width= \"5%\" "+thBGColor+"><B>Basic Price</B></Th>";
					mailText +=  "<Th width= \"10%\" "+thBGColor+"><B>Total Value</B></Th>";
					mailText +=  "</Tr>";					
					
					ReturnObjFromRetrieve retApprDtl= ezMiscSelect(Session,"SELECT * FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO="+retAppr.getFieldValueString(i,"ERH_RFQ_NO"));		
					ezc.ezcommon.EzLog4j.log("**fretApprDtl>>"+retApprDtl.toEzcString(),"I");
					
					for (int j=0 ; j < retApprDtl.getRowCount(); j++)
					{
						String chkStr=retApprDtl.getFieldValueString(j,"ERD_RFQ_NO")+retApprDtl.getFieldValueString(j,"ERD_LINE_NO");
						
						String rfqItemQty	= checkNull(request.getParameter("itemQty"+chkStr));
						String rfqItemPrice	= checkNull(request.getParameter("itemPrice"+chkStr));
						String rfqItemVal	= checkNull(request.getParameter("itemValue"+chkStr));
						
						mailText +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+retApprDtl.getFieldValueString(j,"ERD_LINE_NO")+"</Td>";
						mailText +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+retApprDtl.getFieldValueString(j,"ERD_PLANT")+"</Td>";  
						mailText +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+retApprDtl.getFieldValueString(j,"ERD_MATERIAL")+"</Td>";
						mailText +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+retApprDtl.getFieldValueString(j,"ERD_MATERIAL_DESC")+"</Td>";
						mailText +=  "<Td width= \"5%\"  "+tdBGColor+"  align='center'>"+retApprDtl.getFieldValueString(j,"ERD_UOM")+"</Td>";
						mailText +=  "<Td width= \"5%\"  "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
						mailText +=  "<Td width= \"5%\"  "+tdBGColor+"  align='center'>"+rfqItemPrice+"</Td>";
						mailText +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqItemVal+"</Td>";
						mailText +=  "</Tr>";						
					}
					
					mailText +=  "</Table><Br>";
				}
				
				
			}	
			
			
			mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
			mailText +=  "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
			//ezc.ezcommon.EzLog4j.log("mailText=="+mailText,"I");
			ReturnObjFromRetrieve userRet = getWorkFlowMails(Session,nextPart,plant,category);
			int userRetCnt = 0;
			if(userRet != null)
			{
				userRetCnt = userRet.getRowCount();
			}
			//ezc.ezcommon.EzLog4j.log("userRetCnt>>>>"+userRetCnt,"I");
			
			for(int i=0;i<userRetCnt;i++)
			{
				if(("APPROVED".equals(submitType) && !userRet.getFieldValueString(i,"EU_ID").equals(rfqBuyer)) || ("REJECTED".equals(submitType) && !userRet.getFieldValueString(i,"EU_ID").equals(rfqBuyer))) 
					continue;
					
				
				String linkId=saveLinkControllerData(Session,auctionId,"QCF",userRet.getFieldValueString(i,"EU_ID"),userRet.getFieldValueString(i,"EU_EMAIL"),mailText);
				sendMails(Session,userRet.getFieldValueString(i,"EU_EMAIL"),"","",mailText.replace("JBTEID",linkId),mailSub);
			}
		}
		
	}
		
	String display_header = "Confirmation"; 
%>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<center> 

	<div class="alert alert-<%=(isError || "REJECTED".equals(submitType))?"error":"success"%>" style="width:30%">
	<h4><i class="icon fa fa-check"></i> <%=isError?"Error":"Success"%></h4>
	<%=isError?"Error while submitting":dispText%>
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
 

