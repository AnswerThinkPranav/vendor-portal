<%
	String eMailData1 = "", msgQuoteMailSub = "",toEmailStr = "",ccEmailStr = "";
	
	String dispSoldTo="";
				
	try{
			dispSoldTo = Long.parseLong(rfqVendor)+""; 
	}catch(Exception e)
	{
			dispSoldTo= rfqVendor;	
	}  				
	String lv_VendName = getVendorName(Session,rfqVendor);
	
	toEmailStr = getUserMail(Session,rfqBuyer); 
	ccEmailStr = getVendorMail(Session,dispSoldTo);  
	
	ezc.ezcommon.EzLog4j.log("toEmailStr in RFQ Quote from Vendor>>>"+toEmailStr,"I"); 
	ezc.ezcommon.EzLog4j.log("ccEmailStr in RFQ Quote from Vendor>>>"+ccEmailStr,"I");
	ezc.ezcommon.EzLog4j.log("lv_VendName>>>"+lv_VendName,"I");

	eMailData1 = "Dear Sir/Madam,<Br><Br>This is a Quotation submitted for your approval from M/S."+lv_VendName+"["+dispSoldTo+"]<Br>"; 
	eMailData1 +=  "Please approve the RFQ:"+rfqNumber+" against the below details.<BR><BR>";
	eMailData1 += eMailData;
	eMailData1 += eMailTerms;
	eMailData1 += eMailDataComm;
	eMailData1 +="<Br><Br>Regards,<Br>"+lv_VendName+"["+dispSoldTo+"]<Br><Br>";
	
	ezc.ezcommon.EzLog4j.log("rfqVendor>>>"+rfqVendor,"I");	
	ezc.ezcommon.EzLog4j.log("eMailData1 in Quote>>>"+eMailData1,"I");	
	
	msgQuoteMailSub = "Request For Quotation Approval:" + rfqNumber +"-["+dispSoldTo+"]" ; 
	
	ezc.ezcommon.EzLog4j.log("msgQuoteMailSub>>>"+msgQuoteMailSub,"I");

	sendMail(Session,toEmailStr,ccEmailStr,"",eMailData1,msgQuoteMailSub);  	
%>

