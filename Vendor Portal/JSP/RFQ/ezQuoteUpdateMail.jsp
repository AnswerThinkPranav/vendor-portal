<%
	String eMailData1 = "", msgQuoteMailSub = "",toEmailStr = "",ccEmailStr = "";
	//toEmailStr = getVendorMail(Session,rfqVendor);
	
	toEmailStr = getUserMail(Session,rfqBuyer);
	ccEmailStr = getVendorMail(Session,Session.getUserId()); 
	
	ezc.ezcommon.EzLog4j.log("toEmailStr in RFQ ReQuote from Vendor>>>"+toEmailStr,"I"); 
	ezc.ezcommon.EzLog4j.log("ccEmailStr in RFQ ReQuote from Vendor>>>"+ccEmailStr,"I");	
	
	String lv_VendName = getVendorName(Session,rfqVendor);

	eMailData1 = "Dear Sir/Madam,<Br><Br>This is a Requoted RFQ request submitted for your approval from M/S."+lv_VendName+"["+Session.getUserId()+"].<Br>"; 
	eMailData1 +=  "Please approve the RFQ:"+rfqNumber+" against the below details.<BR><BR>";
	eMailData1 += eMailData;
	eMailData1 += eMailDataComm;
	eMailData1 +="<Br><Br>Regards,<Br>"+lv_VendName+"["+Session.getUserId()+"]<Br><Br>"; 
	
	
	ezc.ezcommon.EzLog4j.log("eMailData1 in ReQuote by Vendor>>>"+eMailData1,"I");		
	
	
	
	msgQuoteMailSub = "Request for Re-Quotation Approval:" + rfqNumber +"-["+Session.getUserId()+"]" ;  
	
	ezc.ezcommon.EzLog4j.log("msgQuoteMailSub>>>"+msgQuoteMailSub,"I");

	sendMail(Session,toEmailStr,ccEmailStr,"hchowdary@answerthink.com",eMailData1,msgQuoteMailSub); 	
%>

