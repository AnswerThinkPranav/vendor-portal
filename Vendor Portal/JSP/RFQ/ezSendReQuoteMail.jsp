<%
	String eMailData1 = "", msgQCFMailSubject = "",toEmailStr = "",ccEmailStr = "";
	String contNO=getUserContact(Session,(String)Session.getUserId());
	
	String vendCode = rfqVendor;
	try
	{
		vendCode = Long.parseLong(rfqVendor)+"";
	}
	catch(Exception e)
	{
		vendCode = rfqVendor;
	}
	
	
	ResourceBundle site=null;
	site= ResourceBundle.getBundle("Site");
	//String link = site.getString("PORTAL_URL");	
	String link = "https://vendor.jolcorp.info/JUBL/ezLogin.jsp";
	
	toEmailStr = getVendorMail(Session,rfqVendor);
	ccEmailStr = getUserMail(Session,Session.getUserId());
	
	
	ezc.ezcommon.EzLog4j.log("toEmailStr in RFQ ReQuote from Buyer>>>"+toEmailStr,"I"); 
	ezc.ezcommon.EzLog4j.log("ccEmailStr in RFQ ReQuote from Buyer>>>"+ccEmailStr,"I");	
	
	msgQCFMailSubject = "Quotation requested for Requote against RFQ No :"+rfqNum+" from Jubilant Ltd";

	eMailData1 = "Dear Sir/Madam,<Br><Br>This is a Request submitted for Requote the RFQ from Jubilant Ltd.<Br>";
	eMailData1 += "For M/S."+getVendorName(Session,rfqVendor)+"["+vendCode+"]"+","+"Please Requote the RFQ:"+rfqNum+".Pls refer below mentioned enquiry details."+"<Br><Br>"; 
	eMailData1 += eMailData;
	eMailData1 += eMailDataComm;
	eMailData1 += "<BR><BR>"+"Quotations received via Email or any other media will not be considered for this RFQ<Br>";
	eMailData1 += "<b><a href ="+link	+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	eMailData1 += "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
	eMailData1 += "<br><b>*</b>This is electronically generated mail/document.Hence signature is not required.<br>";								
	
	
	
	ezc.ezcommon.EzLog4j.log("eMailDataQCF in REQUOTE from BUYER>>>"+eMailData1,"I");	
	
	ezc.ezcommon.EzLog4j.log("msgQCFMailSubject>>>"+msgQCFMailSubject,"I");
	ezc.ezcommon.EzLog4j.log("eMailData1>>>"+eMailData1,"I");

	sendMail(Session,toEmailStr,ccEmailStr,"",eMailData1,msgQCFMailSubject); 	
%>	