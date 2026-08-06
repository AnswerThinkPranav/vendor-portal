<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />     
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%@ page import="java.io.*"%>
<%	
	java.util.ArrayList arrlist=null;
	boolean isSendAttachments=true;
	
	String retMsg 	= "Vendor(s) Login Credentials Sent Successfully";
	String header   = "Vendor Credentials";
	String mailSub  = "JUBILANT PORTAL LOGIN CREDENTIALS";
	
	String vendorStr="";
	
	String vendArr[] 	= request.getParameterValues("selVen");
	
	if(vendArr!=null)
	{
		for(int g=0;g<vendArr.length;g++)
		{
			if(g==0)
				vendorStr = vendArr[g];
			else
				vendorStr = vendorStr+"','"+vendArr[g];
		}
	}
	//vendorStr = "100548','100549";
	ezc.ezcommon.EzLog4j.log("vendorStr>>>>"+vendorStr,"I");	
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve userRetObj	  =	null;
	miscTableRow.setQuery("SELECT EU_ID,EU_EMAIL,EU_PASSWORD,EU_FIRST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+vendorStr+"')");
	ezc.ezcommon.EzLog4j.log("** QUERY_LOGINDETAILS>>>>>>>>>>"+miscTableRow.getQuery(),"I");
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
		int cnt=0;
		for(int i=0;i<userRetObjCnt;i++)
		{
			arrlist=new java.util.ArrayList();	
			String userPwd = ci.ezDecrypt(userRetObj.getFieldValueString(i,"EU_PASSWORD"));
			String userEmail = userRetObj.getFieldValueString(i,"EU_EMAIL").trim();
			ezc.ezcommon.EzLog4j.log("::::::::userEmail::::"+userEmail,"I");
			String userName = userRetObj.getFieldValueString(i,"EU_FIRST_NAME");

			String msgText = "";

			msgText += "Dear Business Partner,";
			msgText += "\n\n <br>Please login to JUBILANT VENDOR PORTAL using below credentials.  <br> \n\n\tUser Id : "+userRetObj.getFieldValueString(i,"EU_ID")+"\n\n\tPassword : "+userPwd+"\n\n\t <br>Login URL : http://vendor.jolcorp.info/JUBL/ \n\n";
			msgText += "\n\n Please change the password after first login.";
			
			try
			{
			   ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();
			   mailParams.setGroupId("Ezc");
			   mailParams.setTo(userEmail);
			   //mailParams.setTo("hchowdary@answerthink.com");
			   //mailParams.setBodyHtml(true);
			   mailParams.setMsgText(msgText);
			   mailParams.setSubject(mailSub);
			   mailParams.setSendAttachments(isSendAttachments);
			  /* if(isSendAttachments)
			   {
				for(int k=0;k<fileItem.length;k++)
				{
					arrlist.add(inboxPath+"RFQ\\"+fileItem[k]);
					ezc.ezcommon.EzLog4j.log("::::::::sending mails manual111::::","I");	 		
				}

				mailParams.setAttachments(arrlist);
			   }*/
			   mailParams.setIsDelete(false);
			   mailParams.setContentType("text/html; charset=utf-8");
			   mailParams.setAttachDirectory(inboxPath+"RFQ");
			   ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
			   boolean value=myMail.ezSend(mailParams,Session);
			   cnt++;

			}
			catch(Exception e)
			{
			   ezc.ezcommon.EzLog4j.log("Exception while sending cha details:::"+e.getMessage(),"E");
			}
		}
		ezc.ezcommon.EzLog4j.log("::::::::sending mails manual END::::"+cnt,"I");	 		
	}
	 		
     	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg+"&header="+header);

%>
