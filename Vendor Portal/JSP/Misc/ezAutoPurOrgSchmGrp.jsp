<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>  
<%!       

	public String checkNull(String str) 
	{ 
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str)) 
			retStr = "";
		else
			retStr = str;
			  
		return retStr;	  
	}
	
%>

<%
	String purOrg 		= request.getParameter("purOrg");
	ezc.ezcommon.EzLog4j.log("purOrg:::inAuto:::::"+purOrg,"I");
	String value1="";
	String value2="";
		
	if(purOrg!=null)
	{
	ezc.ezparam.ReturnObjFromRetrieve retObj = null;
	int retObjCnt = 0; 
	ezc.ezparam.EzcParams lv_VenMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager lv_VendMiscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable lv_VendTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow lv_VenTableRow = new ezc.misctransactions.params.EzMiscTableRow(); 	
		lv_VenTableRow.setQuery("select * FROM ezc_value_mapping WHERE MAP_TYPE='"+purOrg+"'");	
	lv_VendTable.appendRow(lv_VenTableRow);
	lv_VenMainParams.setLocalStore("Y"); 
	lv_VenMainParams.setObject(lv_VendTable);
	Session.prepareParams(lv_VenMainParams);
	try{ 
		retObj=(ezc.ezparam.ReturnObjFromRetrieve)lv_VendMiscMgr.ezGetMiscTransactions(lv_VenMainParams);
		
	}
	catch(Exception e){}	
		value1 = retObj.getFieldValueString(0,"VALUE1");
		value2 = retObj.getFieldValueString(0,"VALUE2");
		ezc.ezcommon.EzLog4j.log("value1>>value2>>PurOrgSchGrp>>>"+value1+"-"+value2,"I");	
	}
	out.println(value1+"$$"+value2);
%>
