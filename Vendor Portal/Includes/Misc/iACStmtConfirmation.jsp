<%@ page import="java.util.*" %>
<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String financialYear =	request.getParameter("financialYear");
	String selQuarter    =	request.getParameter("quarter");
	
	String tempFinancialYear = financialYear;
	if(tempFinancialYear!=null)
		tempFinancialYear = tempFinancialYear.replaceAll("FYR","'-'");
	
	String startYear = "",endYear="";
	
	if(financialYear!=null)
	{
		startYear = financialYear.split("FYR")[0];
		endYear = financialYear.split("FYR")[1];	
	}	
	
	String quarter = "",qStartDt = "",qEndDate="";
	if(selQuarter!=null)
	{
		quarter  = selQuarter.split("DLM")[0];
		
		if(!"Q4".equals(quarter))
		{
			qStartDt = selQuarter.split("DLM")[1]+"/"+startYear;
			qEndDate = selQuarter.split("DLM")[2]+"/"+startYear;
		}
		else
		{
			qStartDt = selQuarter.split("DLM")[1]+"/"+endYear;
			qEndDate = selQuarter.split("DLM")[2]+"/"+endYear;
		}
	}	
	
	String sysKey = (String) session.getValue("SYSKEY");
	
	Hashtable vendorsHT = new Hashtable(); 
	Vector confirmedVend = new Vector(); 

	int confirmedVendRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve confirmedVendRetObj=null;
	
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorBalConfirmParams vendBalConfirmParams= new ezc.vendortransactions.params.EzVendorBalConfirmParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	
	try
	{
		keyParams.setKey("GET_VEND_BAL_CONFIRM_ALL_LIST");
		addMainParams.setLocalStore("Y");

		//vendBalConfirmParams.setQryString(" EVBC_CONF_QUARTER = '"+quarter+"' AND EVBC_CONF_YEAR IN ('"+financialYear+"') AND EVBC_COMPANY_CODE = '"+selCompCode+"'");
		//vendBalConfirmParams.setQryString(" EVBC_CONF_QUARTER = '"+quarter+"' AND EVBC_CONF_YEAR IN ('2013') AND EVBC_COMPANY_CODE = 'MTRF'");
		vendBalConfirmParams.setQryString(" EVBC_QRTR_START_DATE >= TO_DATE('"+qStartDt+"','DD/MM/YYYY') AND EVBC_QRTR_END_DATE <= TO_DATE('"+qEndDate+"','DD/MM/YYYY')");
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(vendBalConfirmParams);
		Session.prepareParams(addMainParams);

		confirmedVendRetObj = (ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
		if(confirmedVendRetObj!=null && confirmedVendRetObj.getRowCount()>0)
		{
			confirmedVendRetObjCnt = confirmedVendRetObj.getRowCount();
			
			for(int v=0;v<confirmedVendRetObjCnt;v++)
				confirmedVend.addElement(confirmedVendRetObj.getFieldValueString(v,"EVBC_VENDOR").trim());
			
		}	
	}
	catch(Exception e){
		out.println(":::EEEE:::"+e);
	}
	
	ezc.ezparam.ReturnObjFromRetrieve vendorsRetObj = null;
	int vendorsRetObjCnt = 0;
	addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();
	keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();

	try
	{
		keyParams.setKey("GET_VENDORS");
		addMainParams.setLocalStore("Y");

		vendParams.setSyskey(sysKey);
		vendParams.setGroup("");
		
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(vendParams);
		Session.prepareParams(addMainParams);

		vendorsRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
		
		if(vendorsRetObj!=null && vendorsRetObj.getRowCount()>0)
		{
			vendorsRetObjCnt = vendorsRetObj.getRowCount();
			
			for(int v=0;v<vendorsRetObjCnt;v++)
				vendorsHT.put(vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO").trim(), vendorsRetObj.getFieldValueString(v,"ECA_NAME"));
			
		}	
	}
	catch(Exception e){
		out.println(":::EEEE:::"+e);
	}

	//out.println(confirmedVend);
	//out.println(vendorsHT);
%>	