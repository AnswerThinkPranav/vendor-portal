<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	ReturnObjFromRetrieve retList = null;
	int retListCnt = 0;
	String	vendor		=(String)session.getValue("SOLDTO");	// "1314B0156";

	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT EMVM_MAPPED_VENDOR FROM EZC_MULTI_VENDOR_MAPPING WHERE EMVM_VENDOR='"+vendor.trim()+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);

	try
	{
		retList = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		if(retList!=null)
			retListCnt = retList.getRowCount();
	}
	catch(Exception e){}
	
	if(retListCnt>0)
	{
		String multiVendor = retList.getFieldValueString(0,"EMVM_MAPPED_VENDOR");
		
		if(multiVendor!=null && !"null".equals(multiVendor) && !"".equals(multiVendor))
		{
			multiVendor = multiVendor.trim();	
			session.setAttribute("MULTI_VENDOR",multiVendor);
		}
	}
%>
