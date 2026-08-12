<%
	ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();	
	mailParams.setGroupId("MTR");
	mailParams.setTo(toEMailIds);
	mailParams.setCC("");
	mailParams.setBCC("");
	mailParams.setMsgText(msgText);
	mailParams.setSubject("MTR : "+msgSubject);
	mailParams.setSendAttachments(false);
	mailParams.setContentType("text/html");
	ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
	boolean value=myMail.ezSend(mailParams,Session);

	ezc.ezcommon.EzLog4j.log("MAIL SENDING QUOTATION MAIL>>>>>>>"+value,"I");
%>
