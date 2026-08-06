<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="javax.activation.*" %>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ page import="ezc.forums.params.*" %>
<%@ page import="ezc.messaging.params.*" %>
<%@ page import="ezc.trans.messaging.params.*" %>
<%@ page import="ezc.client.*" %>
<%@ page import = "ezc.ezparam.*" %>

<jsp:useBean id="Manager" class="ezc.client.EzMessagingManager" scope="session">
</jsp:useBean>
<jsp:useBean id="ForumsManager" class="ezc.client.EzForumsManager" scope="session">
</jsp:useBean>
<jsp:useBean id="TransManager" class="ezc.client.EzTransactionManager" scope="session">
</jsp:useBean>
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />

<%
	String mailFooterText = "<B>This is electronically generated mail/document. Hence signature not required</B>";
	
	msgText += "<BR><BR><BR>"+mailFooterText;
	
	// if you want to send to External accounts also put "N" 
		
	String sendToExt = "Y";
	String language  = "EN";
	String client 	 = "200";

	EzMsgStructure msgStruc			= null;
	EzPersonalMsgStructure[] msgDetails 	= null;

	// Get Parameters from the Compose Page
	//Fill in the message structure

	msgStruc = new EzMsgStructure();
	msgStruc.setClient(client);
	msgStruc.setPriorityFlag("U");
	msgStruc.setMsgHeader(msgSubject);
	msgStruc.setMsgContent1(msgText);
	msgStruc.setMsgContent2(session.getId());
	msgStruc.setLnkExtInfo("Lnk");

	EzcMessageParams  ezcMessageParams	= new EzcMessageParams();
	EzMessageParams ezMessageParams		= new EzMessageParams();
	ezMessageParams.setEzMsgStructure(msgStruc);
	
	// Set Input Parameter Object in the Container	
	ezcMessageParams.setObject(ezMessageParams);
	Session.prepareParams(ezcMessageParams); // Prepare Parameters for Call

	//Fill in the message details structure

	java.util.StringTokenizer strFullUser = new java.util.StringTokenizer(sendToUser, ",");
	Vector dispIds	 = new Vector(); //Only For displaying Users Ids
	Vector failedIds = new Vector(); //Only to List the Users of failed Ids

	Vector extMailIds = new Vector();
	int numUsers	  = strFullUser.countTokens();
	for(int i=0; i<numUsers; i++)
	{
	
		String useri = strFullUser.nextToken();

		//For temporary purpose
		if("VICE_PRESIDENT".equals(useri.trim()))
			useri = "VPRESIDENT";	
		//Ends Here
		//User info		
		if(useri.trim().length()==0)
			continue;
		if(useri.indexOf("@")!=-1)
		{
			extMailIds.addElement(useri);
			dispIds.addElement(useri);
			continue;
		}
		else
		{
			if(sendToExt.equals("Y"))
			{			
				
				ReturnObjFromRetrieve retUserData=null;

				EzcUserParams uparamsN= new EzcUserParams();
				EzcUserNKParams ezcUserNKParamsN = new EzcUserNKParams();
				ezcUserNKParamsN.setLanguage("EN");
				uparamsN.setUserId(useri);
				uparamsN.createContainer();
				uparamsN.setObject(ezcUserNKParamsN);
				Session.prepareParams(uparamsN);
				try
				{					
					retUserData = (ReturnObjFromRetrieve)UManager.getUserData(uparamsN);
					extMailIds.addElement(retUserData.getFieldValueString("EU_EMAIL"));
				}
				catch(Exception e)
				{
					System.out.println("Failed to Get User MailId.Probably b'coz wrong UserId");
				}
			}
		}

		
		msgDetails	= new EzPersonalMsgStructure[1];
		msgDetails[0]	= new EzPersonalMsgStructure();

		msgDetails[0].setClient(client);
		msgDetails[0].setRecUserId(useri.toUpperCase());
		msgDetails[0].setExpiryDate("99999999");
		msgDetails[0].setExpiryDays(10);
		msgDetails[0].setReminderDate("0");
		msgDetails[0].setFolderId("1000");

		//Setting Parameter to container
		ezMessageParams.setEzPersonalMsgStructure(msgDetails);

		// Send Message Call
		//IBObject.createPersonalMsg(SBObject, servlet, msgStruc, msgDetails);
		try
		{
			
			Manager.createPersonalMsg(ezcMessageParams);
			dispIds.addElement(useri);
		}
		catch(Exception e)
		{  
			failedIds.addElement(useri); 
		}

	}//end for

	//After sending the message go back to inbox


	// Include file to send mail to external Accounts
%>

<%//@ include file="ezGetUserEmail.jsp" %>

<%

	String firstname=(String)session.getValue("FIRST_NAME");
	String middlename=(String)session.getValue("MIDDLE_INITIAL");
	String lastname=(String)session.getValue("LAST_NAME");
	if(firstname==null || "null".equals(firstname.trim())) firstname = "";
	if(middlename==null || "null".equals(middlename.trim())) middlename = "";
	if(lastname==null || "null".equals(lastname.trim())) lastname = "";

	String userName= (firstname.trim())+(middlename.trim())+(lastname.trim());
	
	int extCount=extMailIds.size();
	String to="";
	if(extCount!=0)
	{
		to= (String) (extMailIds.elementAt(0));
		for(int k=1;k<extMailIds.size();k++)
		{
			 to =  to  + "," +  (String) (extMailIds.elementAt(k));
		}
		
	ezc.ezcommon.EzLog4j.log("=========extMailIds==============>"+extMailIds,"I");	
		java.util.ArrayList arrlist=new java.util.ArrayList();
		   ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();	
	   	 //  mailParams.setGroupId("MTR");
	   	   mailParams.setGroupId("CRMDL");
	   	  mailParams.setTo(to);
	   	  // mailParams.setTo("cmulakala@answerthink.com");
	   	   mailParams.setCC("");
	   	   mailParams.setBCC("");
	   	   mailParams.setMsgText(msgText+"<BR><BR>Note: Dont change the subject of the mail\n\n <Br>");
	   	  // mailParams.setSubject(msgSubject+"[" + Session.getUserId() +"]"+userName);
	   	   mailParams.setSubject(msgSubject);
	   	   if("Y".equals(attachflag))
	   	   {
	   	   String destinationPath_attach="";
		   	
		   	try
		   	{
		   		ResourceBundle site_attach= java.util.ResourceBundle.getBundle("Site");
		   		destinationPath_attach=site_attach.getString("SERVERUPLOADPATH");
		   	}
		   	catch(Exception e)
		   	{ 
		   	    ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
			}
	   	  // vendorProfileId="500134";
				
				File srcDir	= new File(destinationPath_attach+vendorProfileId+"\\");

				File[] files = srcDir.listFiles();

				if(files!=null)
				{
					ezc.ezcommon.EzLog4j.log("******files.length*****"+files.length,"I");

					for (int i=0;i<files.length;i++)
					{

						String fileName	 = files[i].getName();


						arrlist.add(destinationPath_attach+vendorProfileId+"\\"+fileName);
					}
				}
			//	mailParams.setIsDelete(true);
			mailParams.setAttachments(arrlist);
	   	  	//mailParams.setAttachDirectory("D:\\usr\\sap\\VMP\\J00\\j2ee\\cluster\\apps\\answerthink.com\\EzCFL\\servlet_jsp\\CFL\\root\\Uploads\\"+vendorProfileId);
    			mailParams.setSendAttachments(true);
	   	   
	   	   }else{
	   	   	mailParams.setSendAttachments(false);
	   	   	mailParams.setContentType("text/html");
	   	   }
	   	  // mailParams.setContentType("html");
	   	   ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
	   	   boolean value=myMail.ezSend(mailParams,Session);
	   	   ezc.ezcommon.EzLog4j.log("=========arrlist==============>"+arrlist,"I");	   	   
	   	   ezc.ezcommon.EzLog4j.log("=========TO Mail Id==============>"+mailParams.getTo(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========CC Mail Id==============>"+mailParams.getCC(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========Subject==============>"+mailParams.getSubject(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=========setMsgText==============>"+mailParams.getMsgText(),"I");
	   	   ezc.ezcommon.EzLog4j.log("=======================>Mail Sent Successfully==============>"+value,"I");
}	   
%>
<Div id="MenuSol"></Div>		








