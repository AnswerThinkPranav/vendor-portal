<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezcommon.*,java.util.*,java.util.*,ezc.ezparam.*,ezc.ezshipment.params.*,java.text.*" %>


<%
	ezc.vendortransactions.client.EzVendorTransactionsManager EzAuditFindingManager = new ezc.vendortransactions.client.EzVendorTransactionsManager();
	
	
	ReturnObjFromRetrieve retMailIdsList = null;
	int retMailIdsListCnt = 0;

	String userGroup= (String)session.getValue("USERGROUP");
	String vendCode	= (String)session.getValue("SOLDTO");
	//String userId	= Session.getUserId();
	String sysKey 	= (String)session.getValue("SYSKEY");
	String toMailIds= "";
	
	String fn=((String)session.getValue("FIRST_NAME"));
	if(fn==null || "null".equals(fn))
		fn = "";
	String mn=((String)session.getValue("MIDDLE_INITIAL"));
	if(mn==null || "null".equals(mn))
		mn = "";
	String ln=((String)session.getValue("LAST_NAME"));
	if(ln==null || "null".equals(ln))
		ln = "";
		
	String userId	= (fn.trim())+(mn.trim())+(ln.trim());
	String signatureMsg = "Regards,<BR>"+userId;
	
	if("2".equals((String)session.getValue("UserType")))
		signatureMsg += ",<BR>MTR Foods";
	
	//out.println("::::GET_VENDOR_EMAIL:::::::"+stmtIdKey.indexOf("GET_VENDOR_EMAIL"));

	if(stmtIdKey.indexOf("GET_VENDOR_EMAIL")>=0)
	{
		vendCode = stmtIdKey.split(",")[1];
		stmtIdKey = stmtIdKey.split(",")[0];
	}	

	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorParams vendorMailParams = new ezc.vendortransactions.params.EzVendorParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey(stmtIdKey);
		addMainParams.setLocalStore("Y");

		vendorMailParams.setVendor(vendCode);
		vendorMailParams.setUserId(Session.getUserId());
		vendorMailParams.setGroup(userGroup);
		vendorMailParams.setSyskey(sysKey);

		addMainParams.setObject(keyParams);	
		addMainParams.setObject(vendorMailParams);
		Session.prepareParams(addMainParams);

		try
		{
			retMailIdsList = (ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
			ezc.ezcommon.EzLog4j.log("::retMailIdsList::"+retMailIdsList.toEzcString(),"I");
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception occured while getting mail ids:"+e,"I");
		}
		if(retMailIdsList!=null && retMailIdsList.getRowCount()>0)
		{
			retMailIdsListCnt = retMailIdsList.getRowCount();
		}


	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::Exception occured::"+e,"I");
	}
	
	for(int k=0;k<retMailIdsListCnt;k++)
	{
		 String mailId = retMailIdsList.getFieldValueString(k,"EU_EMAIL");
		 toMailIds =  toMailIds  + "," + mailId ;
	}
	//toMailIds="jakondi@answerthik.com";
	ezc.ezcommon.EzLog4j.log("::toMailIds::"+toMailIds,"I");
	ezc.ezmail.EzcMailParams mailParams = new ezc.ezmail.EzcMailParams();	
	mailParams.setGroupId("MTR");
	mailParams.setTo(toMailIds);
	mailParams.setCC(ccMailIds);
	mailParams.setBCC("");
	mailParams.setMsgText("Note: Dont change the subject of the mail\n\n <Br><Br><br>"+msgText+"<Br>"+signatureMsg+"\n\n <Br><Br> This is electronically generated mail/document. Hence signature not required");
	mailParams.setSubject("MTR : "+msgSubject);
	mailParams.setSendAttachments(false);
	mailParams.setContentType("text/html");
	ezc.ezmail.EzMail myMail = new ezc.ezmail.EzMail();
	boolean value = myMail.ezSend(mailParams,Session);
	
%>