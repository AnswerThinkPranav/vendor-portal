<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%	
	String smsSendURL = "";
	String sendSMS	  = "N";
	ReturnObjFromRetrieve retObj = null;
	int retObjCnt = 0;
	ezc.ezmisc.client.EzMiscManager ezMiscManager = new ezc.ezmisc.client.EzMiscManager();
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT VALUE1,VALUE2 FROM EZC_VALUE_MAPPING WHERE MAP_TYPE = 'SMS'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}catch(Exception e){} 
	
	if(retObj!=null)
		retObjCnt = retObj.getRowCount();
		
	for(int m=0;m<retObjCnt;m++)
	{
		if("URL".equals(retObj.getFieldValueString(m,"VALUE1")))
			smsSendURL = retObj.getFieldValueString(m,"VALUE2");
		if("USER_ID".equals(retObj.getFieldValueString(m,"VALUE1")))
			smsSendURL = "&User="+retObj.getFieldValueString(m,"VALUE2");
		if("PASSWORD".equals(retObj.getFieldValueString(m,"VALUE1")))
			smsSendURL = "&passwd="+retObj.getFieldValueString(m,"VALUE2");
		if("MTYPE".equals(retObj.getFieldValueString(m,"VALUE1")))
			smsSendURL ="&mtype="+retObj.getFieldValueString(m,"VALUE2");	
		if("DR".equals(retObj.getFieldValueString(m,"VALUE1")))
			smsSendURL ="&DR="+retObj.getFieldValueString(m,"VALUE2");		
		if("SEND_SMS".equals(retObj.getFieldValueString(m,"VALUE1")))
			sendSMS = retObj.getFieldValueString(m,"VALUE2");			
	}
%>