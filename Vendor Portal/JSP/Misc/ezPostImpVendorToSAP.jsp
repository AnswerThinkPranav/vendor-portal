<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="iViewVendRegDetails.jsp"%>
<%@ include file="iViewVendRegHeader.jsp"%> 
<%@ include file="ezCountryHT.jsp"%>   
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%

	String schemaGrp="IM";
	String withHoldTaxCountry="";
	
	if("4500".equals(compCode)&& "IN".equals(vendType))
		schemaGrp="I1";
	if("4500".equals(compCode)&& "IM".equals(vendType))
		schemaGrp="I2";
	if("9000".equals(compCode)&& "IN".equals(vendType))
		schemaGrp="J1";	 
		
	if("7300".equals(compCode)|| "4101".equals(compCode)|| "9000".equals(compCode))
		withHoldTaxCountry="US";
	if("7501".equals(compCode)|| "4500".equals(compCode))
		withHoldTaxCountry="CA";

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

	if("Y".equals(session.getValue("VEND_CREATE")))
	{
		response.sendRedirect("../../../Vendor2/Library/Globals/ezValidVendorUserError.jsp");
	}
	session.putValue("VEND_CREATE","Y");
	
	
	String vendCode = "";
	JCoFunction poFunction = null;  
	JCoFunction commitFunction = null; 
	JCoParameterList sapPurOrd = null;
	
	String comments = request.getParameter("comments");
	
	if(comments != null)
		comments = comments.replaceAll("'","`");	
		
	
	//String logonSite = (String)session.getValue("SITE");
	destination = EzSAPHandler.getDestination(logonSite+"~999");
	String dispStr = "";	
	try 
	{
		
		poFunction = EzSAPHandler.getJCoFunction(destination,"Z_RFC_VENDOR_CREATE");//Z_VENDOR_MASTER_UPDATE
		JCoParameterList sapImport = poFunction.getImportParameterList();
		JCoParameterList sapTabParam1= poFunction.getTableParameterList();


		JCoTable vendTable =sapTabParam1.getTable("IT_FILE");

		vendTable.appendRow();
		vendTable.setValue("CHCK","H"); 
		vendTable.setValue("BUKRS",compCode);
		vendTable.setValue("EKORG",purOrg);
		vendTable.setValue("KTOKK",venGrpVal);
		vendTable.setValue("NAME1",vendName);
		vendTable.setValue("LAND1",country);
		vendTable.setValue("SORTL",vendName);
		vendTable.setValue("STRAS","EN");
		vendTable.setValue("STREET2",AddressLine1);
		vendTable.setValue("STREET3",AddressLine2);
		vendTable.setValue("ORT01",District);
		vendTable.setValue("PSTLZ",PostalCode);
		vendTable.setValue("REGIO",State);
		vendTable.setValue("SPRAS","");//chk
		vendTable.setValue("TELF1",MobileNumber);
		vendTable.setValue("TELFX",fax);
		vendTable.setValue("LFURL",EamilAddress1);
		vendTable.setValue("J_1ICSTNO","");
		vendTable.setValue("J_1ILSTNO","");
		vendTable.setValue("J_1ISERN","");
		vendTable.setValue("J_1IEXCD","");
		vendTable.setValue("J_1IEXRN","");
		vendTable.setValue("J_1IEXRG","");
		vendTable.setValue("J_1IEXDI","");
		vendTable.setValue("J_1IEXCO","");
		vendTable.setValue("J_1IVTYP","");
		vendTable.setValue("J_1IEXCIVE","");
		vendTable.setValue("J_1ISSIST","");//MSME
		vendTable.setValue("J_1IPANNO","");
		vendTable.setValue("J_1IPANREF","");
		vendTable.setValue("J_1IPANVALDT","");
		vendTable.setValue("STCD3","");
		vendTable.setValue("VEN_CLASS","");
		vendTable.setValue("AKONT",reconAccount);//chk
		vendTable.setValue("QLAND",withHoldTaxCountry);
		vendTable.setValue("ZTERM_LFB1",Payment_Terms);
		vendTable.setValue("REPRF","X");
		
		vendTable.setValue("WAERS",PurchaseOrderCurrency);
		vendTable.setValue("ZTERM_LFM1",Payment_Terms);
		vendTable.setValue("INCO1",INCO_Terms);
		vendTable.setValue("INCO2",INCO_Terms2);
		vendTable.setValue("KALSK",schemaGrp);//schemagroup
		vendTable.setValue("WEBRE","X");
		vendTable.setValue("KZAUT","X");

		ezc.ezcommon.EzLog4j.log(":::::CHCK::::"+vendTable.getValue("CHCK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BUKRS::::"+vendTable.getValue("BUKRS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::EKORG::::"+vendTable.getValue("EKORG"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KTOKK::::"+vendTable.getValue("KTOKK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::NAME1::::"+vendTable.getValue("NAME1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::LAND1::::"+vendTable.getValue("LAND1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::SORTL::::"+vendTable.getValue("SORTL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STRAS::::"+vendTable.getValue("STRAS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STREET2::::"+vendTable.getValue("STREET2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::STREET3::::"+vendTable.getValue("STREET3"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ORT01::::"+vendTable.getValue("ORT01"),"I");
		ezc.ezcommon.EzLog4j.log(":::::PSTLZ::::"+vendTable.getValue("PSTLZ"),"I");
		ezc.ezcommon.EzLog4j.log(":::::REGIO::::"+vendTable.getValue("REGIO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::SPRAS::::"+vendTable.getValue("SPRAS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TELF1::::"+vendTable.getValue("TELF1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::TELFX::::"+vendTable.getValue("TELFX"),"I");
		ezc.ezcommon.EzLog4j.log(":::::LFURL::::"+vendTable.getValue("LFURL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ICSTNO::::"+vendTable.getValue("J_1ICSTNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ILSTNO::::"+vendTable.getValue("J_1ILSTNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ISERN::::"+vendTable.getValue("J_1ISERN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCD::::"+vendTable.getValue("J_1IEXCD"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXRN::::"+vendTable.getValue("J_1IEXRN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXRG::::"+vendTable.getValue("J_1IEXRG"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXDI::::"+vendTable.getValue("J_1IEXDI"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCO::::"+vendTable.getValue("J_1IEXCO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IVTYP::::"+vendTable.getValue("J_1IVTYP"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IEXCIVE::::"+vendTable.getValue("J_1IEXCIVE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1ISSIST::::"+vendTable.getValue("J_1ISSIST"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IPANNO::::"+vendTable.getValue("J_1IPANNO"),"I");
		ezc.ezcommon.EzLog4j.log(":::::J_1IPANREF::::"+vendTable.getValue("J_1IPANREF"),"I");
		
		ezc.ezcommon.EzLog4j.log(":::::STCD3::::"+vendTable.getValue("STCD3"),"I");
		ezc.ezcommon.EzLog4j.log(":::::VEN_CLASS::::"+vendTable.getValue("VEN_CLASS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::AKONT::::"+vendTable.getValue("AKONT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ZTERM_LFB1::::"+vendTable.getValue("ZTERM_LFB1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::REPRF::::"+vendTable.getValue("REPRF"),"I");
		ezc.ezcommon.EzLog4j.log(":::::QLAND11::::"+vendTable.getValue("QLAND"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WAERS::::"+vendTable.getValue("WAERS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::ZTERM_LFM1::::"+vendTable.getValue("ZTERM_LFM1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::INCO1::::"+vendTable.getValue("INCO1"),"I");
		ezc.ezcommon.EzLog4j.log(":::::INCO2::::"+vendTable.getValue("INCO2"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KALSK::::"+vendTable.getValue("KALSK"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WEBRE::::"+vendTable.getValue("WEBRE"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KZAUT::::"+vendTable.getValue("KZAUT"),"I");
		
		
		vendTable.appendRow();
		/*
		vendTable.setValue("BANKS",country);
		vendTable.setValue("BANKL",RTGSCode);
		vendTable.setValue("BANKN",Account_Number);
		vendTable.setValue("KOINH",Accnt_Person);
		if(whTaxCode != null && !"null".equals(whTaxCode) && !"".equals(whTaxCode) && whTaxType != null && !"null".equals(whTaxType) && !"".equals(whTaxType))
		{
			vendTable.setValue("QLAND","");
			vendTable.setValue("WITHT",whTaxCode);//chk
			vendTable.setValue("WT_WITHCD",whTaxType);//chk 
			vendTable.setValue("WT_SUBJCT","X");//chk
			vendTable.setValue("QSREC",recType);//chk
		}*/
		
		ezc.ezcommon.EzLog4j.log(":::::BANKS::::"+vendTable.getValue("BANKS"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANKL::::"+vendTable.getValue("BANKL"),"I");
		ezc.ezcommon.EzLog4j.log(":::::BANKN::::"+vendTable.getValue("BANKN"),"I");
		ezc.ezcommon.EzLog4j.log(":::::KOINH::::"+vendTable.getValue("KOINH"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WITHT::::"+vendTable.getValue("WITHT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WT_WITHCD::::"+vendTable.getValue("WT_WITHCD"),"I");
		ezc.ezcommon.EzLog4j.log(":::::WT_SUBJCT::::"+vendTable.getValue("WT_SUBJCT"),"I");
		ezc.ezcommon.EzLog4j.log(":::::QSREC::::"+vendTable.getValue("QSREC"),"I");
		
		try{
			poFunction.execute(destination);
		}
		catch(Exception e){
		ezc.ezcommon.EzLog4j.log("ERROR WHILE CREATING VENDOR IN SAP POST "+e,"E");
		}	 
		JCoParameterList expParam   = poFunction.getExportParameterList();
		JCoTable retOut = expParam.getTable("E_MSG");
		ezc.ezcommon.EzLog4j.log("E_MSG:::::"+retOut,"I");
		//String vendCode = (String)expParam.getValue("E_VENDOR");
		vendCode = (String)expParam.getValue("E_VENDOR");
		ezc.ezcommon.EzLog4j.log("E_VENDOR:::::"+vendCode,"I");
		dispStr = (String)expParam.getValue("E_LOG");
		ezc.ezcommon.EzLog4j.log("E_LOG:::::"+dispStr,"I");
		
	
		int retCount = retOut.getNumRows();
		ezc.ezcommon.EzLog4j.log("retCount:::::"+retCount,"I");
		if(retCount>0)
		{
			do
			{
				dispStr += retOut.getValue(0)+"";
			}
			while(retOut.nextRow());
		}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("ERROR WHILE CREATING VENDOR IN SAP "+e,"E");
	}


	
	boolean isError = false;	
	
	
	if(vendCode != null && !"null".equals(vendCode) && !"".equals(vendCode))
	{
	
	
		mainParams = new ezc.ezparam.EzcParams(false); 				
		miscTable = new ezc.misctransactions.params.EzMiscTable();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("UPDATE EZC_CUSTOMER_FORM_HEADER SET ECFH_SAP_CODE='"+vendCode+"',ECFH_STATUS='POSTED',ECFH_MODIFIED_BY='"+Session.getUserId()+"',ECFH_MODIFIED_ON=now()  WHERE ECFH_DOC_ID='"+docId+"'");
		miscTable.appendRow(miscTableRow);
		
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("UPDATE EZC_WF_DOC_HISTORY_HEADER SET EWDHH_MODIFIED_BY='"+Session.getUserId()+"',EWDHH_MODIFIED_ON=now(),EWDHH_WF_STATUS='APPROVED',EWDHH_CURRENT_STEP='0',EWDHH_NEXT_PARTICIPANT='' WHERE EWDHH_DOC_ID='"+docId+"' and EWDHH_AUTH_KEY='VNR'");
		miscTable.appendRow(miscTableRow);
		
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+docId+"','VNR','"+comments+"','"+Session.getUserId()+"',now())");
		miscTable.appendRow(miscTableRow);		
		
		
		
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams); 
		miscMgr.ezSaveMiscTransactions(mainParams);
		
		saveWFDocAudit(Session,docId,"VNR","Request details "+wfStatus.toLowerCase()+" by "+Session.getUserId()+"["+v_fullName+"]","U");
		
		ezc.ezcommon.EzLog4j.log("venWFCategory>>>"+venWFCategory,"I");
		ezc.ezcommon.EzLog4j.log("venWFPlant>>>"+venWFPlant,"I");
		
		if("RM_PM".equals(venWFCategory))
		{
		//MAIL
		String mailSub="Unblock the Vendor Code: "+vendCode+" has been created in SAP.";
		String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
		String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
		String bgColor = "bgcolor=\"#FFFFFF\"";
		String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
		String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

		String mailText="Dear Sir/Madam,<br> Below Vendor has been created in SAP.<br>";
		mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
		mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Vendor Code</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+vendCode+"</Td></Tr>";	
		//mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Vendor Name</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+vendName+"</Td></Tr>";	
		mailText +=  "</Table><Br>";
		//mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
		//mailText +=  "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
		mailText  += "<Br>Regards ";
		mailText  += "<Br>Jubilant Generics ";
		
		sendMails(Session,QAHM.get(venWFPlant),"hchowdary@answerthink.com","",mailText,mailSub);
		}	
	}
	else
	{
		isError = true;
	}

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
 

