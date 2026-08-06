

<%
	//ccEMailIds="radhakrishna.meka@answerthink.com";
	
	ezc.ezcommon.EzLog4j.log("VED SYNC MAIL-toEMailIds>>>>>>>"+toEMailIds,"I");
	ezc.ezcommon.EzLog4j.log("VED SYNC MAIL-ccEMailIds>>>>>>>"+ccEMailIds,"I");
	ezc.ezcommon.EzLog4j.log("VED SYNC MAIL-eMailData>>>>>>>"+eMailData,"I");
	ezc.ezcommon.EzLog4j.log("VED SYNC MAIL-msgSubject>>>>>>>"+msgSubject,"I");
	toEMailIds=toEMailIds.trim();
	ccEMailIds=ccEMailIds.trim();
	ezc.ezmail.EzcMailParams mailParams_external=new ezc.ezmail.EzcMailParams();	
	mailParams_external.setGroupId("JUBL");
	mailParams_external.setTo(toEMailIds);
	mailParams_external.setCC(ccEMailIds); 
	mailParams_external.setBCC("lakshman.epparla@answerthink.com");
	mailParams_external.setMsgText(eMailData+"<Br><b>This is electronically generated mail/document. Hence signature not required.</b><Br>Note: Dont change the subject of the mail");
	mailParams_external.setSubject(msgSubject);
	mailParams_external.setSendAttachments(false);
	mailParams_external.setContentType("text/html");
	ezc.ezmail.EzMail myMail_external=new ezc.ezmail.EzMail();
	boolean value_ssc=myMail_external.ezSend(mailParams_external,Session);

	ezc.ezcommon.EzLog4j.log("MAIL SENDING MAIL>>>>>>>"+value_ssc,"I");
%>
