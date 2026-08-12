<%
	String qcfText= "",msgQCFMailSubject = "",toEmailStr = "",ccEmailStr = "";
	//String contNO=getUserContact(Session,(String)Session.getUserId());
	String compName="";
	
	vendfrmsap = dispSoldTo;
	

	String link = site.getString("PORTAL_URL");
	
	ResourceBundle sitBundleObj=null;
	try
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		//link=sitBundleObj.getString("PORTAL_URL");
		link = "https://vendor.jolcorp.info/JUBL/ezLogin.jsp";
	}
	catch(Exception e)
	{ 
	    
	}	
	
	/*String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	
	
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"50%\" "+thBGColor+"><B>RFQ No.</B></Th><Th width= \"50%\" "+thBGColor+"><B>Vendor</B></Th></Tr>";
	eMailData +=  "<Tr "+bgColor+"><Td width= \"50%\" "+tdBGColor+" align='center'>"+rfq+"</Td><Td width= \"50%\" "+tdBGColor+"  align='center'>"+vendfrmsap+"</Td></Tr>";	
	eMailData +=  "</Table><Br><Br>";*/
	ezc.ezcommon.EzLog4j.log("vendfrmsap>>>"+vendfrmsap,"I");
	toEmailStr = getVendorMail(Session,vendfrmsap);
	ccEmailStr = getUserMail(Session,(String)Session.getUserId());
	ezc.ezcommon.EzLog4j.log("toEmailStr in RFQ Create>>>"+toEmailStr,"I"); 
	ezc.ezcommon.EzLog4j.log("ccEmailStr in RFQ Create>>>"+ccEmailStr,"I");  
	
	String lv_VendName = (String) gv_VendorsHT.get(vendor[i]);
	msgQCFMailSubject = "Request For Quotation From Jubilant Ltd:"+rfq;
	qcfText = "Dear Sir/Madam,<Br><Br>This is a Request For Quotation from Jubilant Ltd.";
	qcfText += " to quote the RFQ:"+rfq+" for Vendor "+vendfrmsap+"("+lv_VendName+").<Br><Br>";
	qcfText += eMailData;
	qcfText += eMailDataComm;
	qcfText += "<Br>Please ensure to send the Quotation through Vendor Portal only , Login details already assigned to you .<br>";
	qcfText += "<Br><b>*Quotations received via Email or any other media will not be considered for this RFQ</b><br>";
	qcfText	+= "<b><a href ="+link+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	qcfText	+= "<Br>This is system generated email after receipt of RFQ/Enquiry to the vendor , <B>Please DO NOT reply on this email ID as it is only for outgoing emails, & reply to this email is system prohibited.</B><br>";
	qcfText += "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
	qcfText += "<br><b>*</b>This is electronically generated mail/document.Hence signature is not required.<br>";							
	//qcfText	+= "<br><b>*</b>This is system generated email after receipt of RFQ/Enquiry to the vendor , Please DO NOT reply on this email ID as it is only for outgoing emails, & reply to this email is system prohibited .";
	
	
	ezc.ezcommon.EzLog4j.log("eMailDataQCF>>>"+eMailData,"I");	
	
	ezc.ezcommon.EzLog4j.log("msgQCFMailSubject>>>"+msgQCFMailSubject,"I");

	boolean sendMailReq=sendMail(Session,toEmailStr,ccEmailStr,"",qcfText,msgQCFMailSubject);
	
	ezc.ezcommon.EzLog4j.log("sendMailReq>>>"+sendMailReq,"I");	
	

%>	