<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%
	String comments		=	request.getParameter("qcfComments");
	String qcfNum 		=	request.getParameter("QcfNumber");
	//String destUser		=	request.getParameter("destUser");
	String qcfType		=	request.getParameter("Type");
	String qcfInitiator	=	request.getParameter("Initiator");
	String DOCTYPE		=	request.getParameter("DOCTYPE");
	String VENDOR		= 	request.getParameter("VENDOR");
	String QRYCOUNT		= 	"";//request.getParameter("QRYCOUNT");
	
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
			
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qry1="";
	ezc.ezparam.ReturnObjFromRetrieve QueryMaxObj	  =	null;
	
	qry1="select cast(max(EQC_COMMENT_NO) as unsigned) as MAXNO from ezc_qcf_comments where EQC_CODE='"+qcfNum+"'" ;
	
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
	
	String fName 	= (String)session.getValue("FIRST_NAME");
	String lName 	= (String)session.getValue("LAST_NAME");
	String name	= fName+" "+lName;
	if(fName==null || lName==null)
	name=Session.getUserId();

	String queryAbout = "";
	if("PO".equals(DOCTYPE))
		queryAbout = "Purchase Order";
	else if("CON".equals(DOCTYPE))
		queryAbout = "Contract";
	else if("SA".equals(DOCTYPE))
		queryAbout = "Schedule Agreement ";
	else if("VNR".equals(DOCTYPE))
		queryAbout = "Vendor Registration";
	else
		queryAbout = "Quotation";
	
	String destusr = "";
	
	String user = Session.getUserId();
	if(comments.indexOf("'")!=-1)
		comments = replaceString(comments,"'","`");	
		
	String commentNo = "";
	commentNo = QRYCOUNT;
	
	java.util.StringTokenizer st = new java.util.StringTokenizer(qcfInitiator,"¥");
	ezc.ezpreprocurement.params.EziQcfCommentTable eziQcfCommentTable = new ezc.ezpreprocurement.params.EziQcfCommentTable();
	ezc.ezpreprocurement.params.EziQcfCommentTableRow eziQcfCommentTablerow 	= null;		
	String sendToUser = "";
	while(st.hasMoreTokens())
	{
		destusr =  (String)st.nextToken();

		eziQcfCommentTablerow = new ezc.ezpreprocurement.params.EziQcfCommentTableRow();
		eziQcfCommentTablerow.setQcfExt1("$$");
		eziQcfCommentTablerow.setQcfExt2(DOCTYPE);
		eziQcfCommentTablerow.setQcfCode(qcfNum);
		eziQcfCommentTablerow.setCommentNo(commentNo);
		eziQcfCommentTablerow.setQcfUser(user);
		eziQcfCommentTablerow.setQcfComments(comments);
		eziQcfCommentTablerow.setQcfDestUser(destusr);
		eziQcfCommentTablerow.setQcfType(qcfType);
		eziQcfCommentTablerow.setQcfQueryMap("0");
		eziQcfCommentTable.appendRow(eziQcfCommentTablerow);

		sendToUser += ","+destusr;
	}	
	
	/*
	ezc.ezpreprocurement.client.EzPreProcurementManager qcfManager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	mainParams.setLocalStore("Y");
	mainParams.setObject(eziQcfCommentTable);
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve addRet = (ReturnObjFromRetrieve)qcfManager.addQcfComment(mainParams);
	*/
	ezc.ezparam.ReturnObjFromRetrieve addRet = null;
	
	mainParams1 = new ezc.ezparam.EzcParams(false); 
			
	miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	qry1="insert into ezc_qcf_comments (EQC_CODE,EQC_COMMENT_NO,EQC_USER,EQC_DATE,EQC_COMMENTS,EQC_EXT1,EQC_EXT2,EQC_EXT3,EQC_DEST_USER,EQC_TYPE,EQC_QUERY_MAP,EQC_ITEM_NO,EQC_REASON_CODE) values('"+qcfNum+"','"+commentNo+"','"+user+"',NOW(),'"+comments+"','','"+DOCTYPE+"','','"+destusr+"','"+qcfType+"','0','','')";
	
	ezc.ezcommon.EzLog4j.log("** qry1"+qry1,"I");

	miscTableRow1.setQuery(qry1);
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	
	try
	{
		addRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezSaveMiscTransactions(mainParams1);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}	
	

	
	String dispMessage = "";
	if(addRet == null)
	{
		dispMessage = "Problem in sending query..Please try again";	
			
	}	
	else
	{
		if(sendToUser.startsWith(","))
			sendToUser = sendToUser.substring(1);

		dispMessage = "Query sent successfully to "+sendToUser;;	
		String v_fnameNew	=	(String)session.getValue("FIRST_NAME");
		//String sendToUser = destusr;
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
		ezc.ezcommon.EzLog4j.log("query raising dstUsrMailId>>>"+dstUsrMailId,"I");		
	
		String mailSub ="Query about "+queryAbout+""+qcfNum+" from "+user;
		String mailText = "Dear Sir/Madam,<Br><Br>The following query has been raised by "+user;
		mailText += "<BR><BR>Query : "+comments+"<Br>";
		mailText += "<BR>Please click on the link given below to send your reply<BR><BR>";
		String link="https://"+request.getServerName()+"/JUBL/ezLogin.jsp";
		mailText += "<a href=\""+link+"\" target=\"_blank\">Click here to give the reply for query.</a>";
		mailText +=  "<br>Regards, \n<br><b>" + v_fnameNew + "(" +Session.getUserId()+").";
		
		sendMails(Session,dstUsrMailId,"","",mailText,mailSub);
		ezc.ezcommon.EzLog4j.log("sendMails>>>"+sendMails(Session,dstUsrMailId,"","",mailText,mailSub),"I");
	}	
%>
<html>
<head>
<Script>
	
	function closeWindow()
	{
		window.opener = window.dialogArguments;
		/*if("Y"=="<%=(String)session.getValue("OFFLINE")%>")
		{
			if("PO"== "<%=DOCTYPE%>")
				parent.document.myForm.action="../Purorder/ezBlockedOfflinePoLineitems.jsp?PurchaseOrder=<%=qcfNum%>&type=Amend&POORCONTRACT=<%=DOCTYPE%>&vendorNo=<%=VENDOR%>";
			else if("SA"== "<%=DOCTYPE%>")
				opener.document.myForm.action="../SchdAgrmts/ezBlockedOfflineSALineitems.jsp?PurchaseOrder=<%=qcfNum%>&type=Amend&POORCONTRACT=<%=DOCTYPE%>&vendorNo=<%=VENDOR%>";	
			else if("CON" == "<%=DOCTYPE%>")
				opener.document.myForm.action="../Rfq/ezGetOfflineAgrmtDetails.jsp?agmtNo=<%=qcfNum%>&viewType=UNREL&POORCONTRACT=CON&RQSTFROM=PORTAL";
			else 
				opener.document.myForm.action="ezOfflineQuotationComparisionForm.jsp?collectiveRFQNo=<%=qcfNum%>";
			parent.document.myForm.submit();
		}
		else
		{
			//opener.document.myForm.submit();
			//opener.location.refresh();
			//opener.history.go(0)
		}*/	
		window.close();
		
	}


</Script>
<Title>Quotation Comparative Statement-- Answerthink</Title>

<%//@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
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

</head>
<body>
<form name="myForm">
<DIV align="center" style="position:absolute;width:100%;top:30%">
<Table align="center" border=0 style="width:50%" borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
	<Tr>
		<Th width="30%"><%=dispMessage%></Th>
	</Tr>
</Table>
</Div>	

<DIV style="position:absolute;width:100%;top:80%">
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</Div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>



