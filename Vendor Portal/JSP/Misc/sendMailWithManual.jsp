<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />     
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%@ page import="java.io.*"%>
<%	
	String [] fileItem = new String[]{"VENDOR_MANUAL.pdf"};
	java.util.ArrayList arrlist=null;	
	boolean isSendAttachments=true;
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve userRetObj	  =	null;
	miscTableRow.setQuery("SELECT EU_ID,EU_EMAIL,EU_PASSWORD,EU_FIRST_NAME FROM EZC_USERS WHERE EU_ID IN ('11221')");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		userRetObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception occured in getting User Data","E");
	}
	int userRetObjCnt = 0;
	if(userRetObj != null)
		userRetObjCnt = userRetObj.getRowCount(); 

	if(userRetObjCnt>0)
	{
		ezc.ezcommon.EzCipher ci = new ezc.ezcommon.EzCipher();
		for(int i=0;i<userRetObjCnt;i++)
		{
			arrlist=new java.util.ArrayList();	
			String userPwd = ci.ezDecrypt(userRetObj.getFieldValueString(i,"EU_PASSWORD"));
			String userEmail = userRetObj.getFieldValueString(i,"EU_EMAIL");
			String userName = userRetObj.getFieldValueString(i,"EU_FIRST_NAME");

			String msgText = "";

			msgText += "Dear "+userName+",";
			msgText += "\n Please login to vendor portal using below credentials. Refer attached user manual for your reference. \nUser Id : "+userRetObj.getFieldValueString(i,"EU_ID")+"\nPassword : "+userPwd+"\n Login URL : http://vendor.hindware.com\n\nIn case of any issue in accessing above link. Copy vendor.hindware.com in browser.\n\nRegards,\nSOMANY IMPRESSA GROUP.\n";
			try
			{
			   ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();
			   mailParams.setGroupId("HSIL");
			   mailParams.setTo(userEmail);
			   mailParams.setMsgText(msgText);
			   mailParams.setSubject("SOMANY IMPRESSA GROUP | VENDOR PORTAL LOGIN DETAILS " );
			   mailParams.setSendAttachments(isSendAttachments);
			   if(isSendAttachments)
			   {
				for(int k=0;k<fileItem.length;k++) 
				{
					arrlist.add(inboxPath+"SOP\\"+fileItem[k]);
					ezc.ezcommon.EzLog4j.log("::::::::sending mails manual::::","I");			
				}

				mailParams.setAttachments(arrlist);
			   }
			   mailParams.setIsDelete(false);
			   mailParams.setContentType("text/html; charset=utf-8");
			   mailParams.setAttachDirectory(inboxPath+"SOP");
			   ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
			   boolean value=myMail.ezSend(mailParams,Session);

			}
			catch(Exception e)
			{
			   ezc.ezcommon.EzLog4j.log("Exception while sending cha details:::"+e.getMessage(),"E");
			}
		}
	}
     

%>
