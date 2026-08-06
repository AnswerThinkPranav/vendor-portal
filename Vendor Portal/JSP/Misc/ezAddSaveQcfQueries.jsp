<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iWFMethods.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iCheckQuery.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iCheckTimes.jsp" %>
<%@ page import ="ezc.ezparam.*,java.util.*,java.text.*,java.nio.file.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>

<html> 
<head>
<Title>Reply.....</Title>
<script language="Javascript1.2">
	am = "This function is disabled!";
	bV  = parseInt(navigator.appVersion)
	bNS = navigator.appName=="Netscape"
	bIE = navigator.appName=="Microsoft Internet Explorer"
	function nrc(e) 
	{
	   if (bNS && e.which > 1)
	   {
	      alert(am)
	      return false
	   } 
	   else if (bIE && (event.button >1)) 
	   {
	     alert(am)
	     return false;
	   }
	}
	document.onmousedown = nrc;
	if (document.layers) window.captureEvents(Event.MOUSEDOWN);
	if (bNS && bV<5) window.onmousedown = nrc;
</script>
<Script>
	
	function closeWindow()
	{
		parent.document.myForm.submit();
		window.close();
	}

</Script>
</head>
<%
	String user		= Session.getUserId();
	String qcfcomment 	= request.getParameter("qcfComments");
	String chk1 		= request.getParameter("chk1");
	String qcfcode		= request.getParameter("qcf_code");
	String comment_nm	= request.getParameter("qcf_comment_no");
	String destusr		= request.getParameter("qcf_dest_user");
	String eqcusr		= request.getParameter("qcf_user");
	String qryDate		= request.getParameter("qryDate");
	String qcfType		= "REPLY";
	String docType		= request.getParameter("docType");
	
	ezc.ezcommon.EzLog4j.log("** qcfType"+qcfType,"I");
	ezc.ezcommon.EzLog4j.log("** destusr"+destusr,"I");
	ezc.ezcommon.EzLog4j.log("** qcfcomment"+qcfcomment,"I");
	ezc.ezcommon.EzLog4j.log("** user"+user,"I");
	ezc.ezcommon.EzLog4j.log("** qcfcode"+qcfcode,"I");
	ezc.ezcommon.EzLog4j.log("** qryDate"+qryDate,"I");

	
	String participant 	= "";
	String participant_type = "";
	String role 		= "";
	String syskey		= "";
	String template		= "";
	String QRYCOUNT		= "";

	if(qcfcomment.indexOf("'") != -1)
		qcfcomment = replaceString(qcfcomment,"'","`");	
		
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
			
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qry1="";
	ezc.ezparam.ReturnObjFromRetrieve QueryMaxObj	  =	null;
	
	qry1="select cast(max(EQC_COMMENT_NO) as unsigned) as MAXNO from ezc_qcf_comments where EQC_CODE='"+qcfcode+"'" ;
	
	ezc.ezcommon.EzLog4j.log("** qry1"+qry1,"I");

	miscTableRow1.setQuery(qry1);
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	
	try
	{
		QueryMaxObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
	if(QueryMaxObj!=null)
	{
		if("null".equals(QueryMaxObj.getFieldValueString(0,"MAXNO")))QRYCOUNT="1";
		else QRYCOUNT = (Integer.parseInt(QueryMaxObj.getFieldValueString(0,"MAXNO"))+1)+"";
	}
	
	String commentNo = "";
	commentNo = QRYCOUNT;	
	
	
	java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
	queriesList.add("insert into ezc_qcf_comments (EQC_CODE,EQC_COMMENT_NO,EQC_USER,EQC_DATE,EQC_COMMENTS,EQC_EXT1,EQC_EXT2,EQC_EXT3,EQC_DEST_USER,EQC_TYPE,EQC_QUERY_MAP,EQC_ITEM_NO,EQC_REASON_CODE) values('"+qcfcode+"','"+commentNo+"','"+user+"',NOW(),'"+qcfcomment+"','','"+docType+"','','"+destusr+"','"+qcfType+"','1','','')");
	queriesList.add("update ezc_qcf_comments set EQC_QUERY_MAP= '-1' where EQC_CODE='"+qcfcode+"' and  EQC_TYPE='QUERY' and EQC_DATE='"+qryDate+"'");
	ezMiscInsert(Session,queriesList);	
		



	/*** Attachment Block ***/
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;	

	lineAttachString = request.getParameterValues("fileItem");
	//ezc.ezcommon.EzLog4j.log("qcfcode>>>>>"+qcfcode,"I");  
	//ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I"); 

	if(lineAttachString != null)
	{ 
		objNo 		= qcfcode;
		documentType 	= docType; 

			ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
			
			String fileItemIndex = "H";
			String fileItem[]	= request.getParameterValues("fileItem"); 
			int fileLength = 0;
			if(fileItem != null)
				fileLength = fileItem.length;
			ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

			if(fileLength > 0)
			{
				String subDirPath = docType+"\\"+qcfcode+"\\"+fileItemIndex+"\\";
				String dirPath  = serverUpPath+subDirPath;
				String sessionId = session.getId()+"";
				Path path = Paths.get(dirPath);
				Files.createDirectories(path);
				for(int j=0;j<fileItem.length;j++)
				{
					try
					{
						String fileName = fileItem[j];	
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
						miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_EXT1,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+qcfcode+"','"+fileItemIndex+"','"+docType+"','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"','QRY',NOW(),'"+(String)Session.getUserId()+"')");
						miscTable2.appendRow(miscTableRow2);
					}catch(Exception e)
					{

					}
				}
			}
			
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
	

	String v_fnameNew	=	(String)session.getValue("FIRST_NAME");
	String sendToUser = destusr;
	String dstUsrMailId="";
	mainParams1 = new ezc.ezparam.EzcParams(false);
	miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve QueryMailObj	  =	null;
	miscTableRow1.setQuery("select * from ezc_users where EU_ID='"+sendToUser+"'");
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);

	try
	{
		QueryMailObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);
	}
	catch(Exception e)
	{
		out.println("Exception in getting Mail Id of Dest User>>>>>"+e);
	}
	if(QueryMailObj!=null)dstUsrMailId=QueryMailObj.getFieldValueString(0,"EU_EMAIL");
	ezc.ezcommon.EzLog4j.log("dstUsrMailId>>>"+dstUsrMailId,"I");
	
	String tmpDType="";
	if("VNR".equals(docType))tmpDType="Vendor Registration";
	else tmpDType="QCF";
	String mailSub ="Reply for your query on "+tmpDType+" "+qcfcode+" was submitted";
	String mailText = "Dear Sir/Madam,<BR>"+mailSub+" by "+user+"<Br><BR>";
	mailText += "<B>Reply Given : </B>"+qcfcomment+"<Br><Br>";
	
	String appLink = "https://"+request.getServerName()+"/JUBL/ezLogin.jsp";
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

	mailText +=  "<b><a href ="+appLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	mailText +=  "<br>Regards, \n<br><b>" + v_fnameNew + "(" +Session.getUserId()+").";
			
	sendMails(Session,dstUsrMailId,"","",mailText,mailSub);
	ezc.ezcommon.EzLog4j.log("sendMails>>>"+sendMails(Session,dstUsrMailId,"","",mailText,mailSub),"I");
	
%>

<body>
<form name="myForm">
<DIV align="center" style="position:absolute;width:100%;top:30%">
<Table align="center" border=0 style="width:80%" borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
	<Tr>
		<Th><BR>&nbsp;Reply posted Successfully<BR>&nbsp;</Th>
	</Tr>
</Table>
</Div>	
<DIV style="position:absolute;width:100%;top:80%">
<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="closeWindow()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</Div>
<Div id="MenuSol">
</Div>
</form>
</body>
</html>



