<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%

	int auditNo=0;
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT MAX(EAF_AUDIT_NO) AS MAXAUDITNUM FROM EZC_AUDIT_FINDINGS");
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve retPurOrg = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	//out.println("retPurOrg=="+retPurOrg.toEzcString());
	if(retPurOrg!=null && retPurOrg.getRowCount()>0)
	{
	
	auditNo=Integer.parseInt(retPurOrg.getFieldValueString(0,"MAXAUDITNUM")+"");
	//out.println("auditNo=="+auditNo);
	
	}
	
	
%>	