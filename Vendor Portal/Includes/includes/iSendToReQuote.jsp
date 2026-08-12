<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="ezc.ezutil.*,ezc.ezmisc.params.*"%>
<%@ page import = "ezc.ezparam.*,ezc.ezadmin.ezadminutils.params.*" %>
<%@ page import="ezc.messaging.params.*" %>
<%@ page import="ezc.trans.messaging.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />


<%
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	//String 	msgSubject 	= "";
	//String 	msgText 	= "";
	String sendToUser = "";
	boolean statusReQuote = true;

	
	String rfqNO		= request.getParameter("PurchaseOrder");
	String remarks		= request.getParameter("Remarks");
	String rfqVend		= request.getParameter("rfqVend");
	String modifiedBy 	= (String)Session.getUserId();
	
	if(remarks !=null && !"".equals(remarks) && remarks.indexOf("'")!=-1)
	{
		remarks = replaceString(remarks,"'","`");	
	}
	
	
	ReturnObjFromRetrieve updateRet = null;
	
	ezc.ezpreprocurement.params.EziRFQHeaderTable  	ezirfqheadertable	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow ezirfqheadertablerow 	= new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();
	
	ezirfqheadertablerow.setStatus("N"); 
	ezirfqheadertablerow.setRequoteStatus("Y");
	ezirfqheadertablerow.setRFQNo(rfqNO);
	ezirfqheadertablerow.setModifiedBy(modifiedBy); 
	ezirfqheadertable.appendRow(ezirfqheadertablerow);
	
	EzcParams ezcparams = new EzcParams(true);
	ezcparams.setLocalStore("Y");
	ezcparams.setObject(ezirfqheadertable);
	Session.prepareParams(ezcparams);
	
	
	try
	{
		ezc.ezcommon.EzLog4j.log("::Before updateRFQ::","I");
		ezrfqmanager.ezUpdateRFQ(ezcparams);
		ezc.ezcommon.EzLog4j.log("::After updateRFQ::","I");
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log(":Exception while updating rfq header:"+e,"I");
		statusReQuote = false;
	}
	
	

%>
