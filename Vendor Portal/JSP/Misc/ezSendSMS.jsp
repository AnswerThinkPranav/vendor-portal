<%@ page import="java.io.BufferedReader, java.io.InputStreamReader,java.io.OutputStreamWriter,java.net.HttpURLConnection,java.net.URLEncoder,java.net.*"%>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%

	String smsResponse = "";
	
	String smsSendURL = "";
	String sendSMS	  = "N";
/*
	ReturnObjFromRetrieve retObj123 = null;
	int retObjCnt = 0;

	ezc.ezmisc.client.EzMiscManager v_EzMiscManager = new ezc.ezmisc.client.EzMiscManager();
	ezc.ezparam.EzcParams sms_MainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams sms_MiscParams = new EziMiscParams();

	sms_MiscParams.setQuery("SELECT VALUE1,VALUE2 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE = 'SMS'");
	sms_MainParams.setLocalStore("Y");
	sms_MainParams.setObject(sms_MiscParams);
	Session.prepareParams(sms_MainParams);
	try
	{
		retObj123 = (ReturnObjFromRetrieve)v_EzMiscManager.ezSelect(sms_MainParams);
	}catch(Exception e){} 
	
	if(retObj123!=null)
		retObjCnt = retObj123.getRowCount();
	
	String sms_url="",sms_user_id="",sms_pwd="",sms_mtype="",sms_dr="";
	for(int m=0;m<retObjCnt;m++)
	{
		if("URL".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sms_url = retObj123.getFieldValueString(m,"VALUE2");
		if("USER_ID".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sms_user_id = "User="+retObj123.getFieldValueString(m,"VALUE2");
		if("PASSWORD".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sms_pwd = "&passwd="+retObj123.getFieldValueString(m,"VALUE2");
		if("MTYPE".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sms_mtype ="&mtype="+retObj123.getFieldValueString(m,"VALUE2");	
		if("DR".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sms_dr ="&DR="+retObj123.getFieldValueString(m,"VALUE2");		
		if("SEND_SMS".equals(retObj123.getFieldValueString(m,"VALUE1")))
			sendSMS = retObj123.getFieldValueString(m,"VALUE2");
	}

	smsSendURL = sms_url+sms_user_id+sms_pwd+sms_mtype+sms_dr;

	if("Y".equals(sendSMS))
	{
		try
		{
			smsSendURL += "&mobilenumber="+mobileNo+"&message="+URLEncoder.encode(smsMesg,"UTF-8");
			ezc.ezcommon.EzLog4j.log("::::::::SMS URL::::::::::"+smsSendURL,"I");
			ezc.ezcommon.EzLog4j.log("::SENDING SMS STARTS::::","I");
			URL url = new URL(smsSendURL);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			smsResponse = conn.getResponseMessage();
			ezc.ezcommon.EzLog4j.log("::::::::SMS RESPONSE::::::::::"+smsResponse,"I");
			conn.disconnect();
		}
		catch(Exception e){
			e.printStackTrace();
			ezc.ezcommon.EzLog4j.log("::::::::SMS ERROR::::::::::"+e,"E");
		}
	}	
	*/
%>	