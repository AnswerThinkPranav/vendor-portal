<%@ page import ="ezc.ezparam.*" %>
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="PoManager1" class="ezc.client.EzPurchaseManager" scope="page"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%
	String fromDate1=request.getParameter("FromDate");
	String toDate1=request.getParameter("ToDate");
	String status=request.getParameter("statusSel");
	String qryVend="";
	String qryStr = "";
		int toActVendCnt=0; 
		ezc.ezparam.EzcParams vendParams = new ezc.ezparam.EzcParams(false); 
 		ReturnObjFromRetrieve hdrVendXML = null;
 
 		ezc.misctransactions.client.EzMiscTransactionsManager vendMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
 		ezc.misctransactions.params.EzMiscTable vendTable = new ezc.misctransactions.params.EzMiscTable();
 		ezc.misctransactions.params.EzMiscTableRow vendTableRow = new ezc.misctransactions.params.EzMiscTableRow();
 		out.print("fromDate:::"+fromDate);
	
	if(fromDate!=null && !"null".equals(fromDate) && !"".equals(fromDate))
		qryStr += "AND A.ECFH_CREATED_ON BETWEEN str_to_date('"+fromDate+"','%d/%m/%Y') AND  str_to_date('"+toDate+"','%d/%m/%Y') order by ECFH_MODIFIED_ON desc";
	
	if(status!=null && !"null".equals(status) && !"".equals(status))
	{
		if("TOBEPOSTED".equals(status.trim()))
		{
			qryStr += "AND A.ECFH_STATUS='APPROVED'";
		}
		else
		{
			qryStr += "AND A.ECFH_STATUS='"+status+"'";
		}
	}
	/*
	if(status != null && "TOBEPOSTED".equals(status.trim()))
	{
		qryVend="select *  from ezc_customer_form_header A WHERE ECFH_DOC_ID IS NOT NULL "+qryStr;	
 	}
	else if(status != null && "SUBMITTED".equals(status.trim()))
 	{
 		qryVend="select * from ezc_customer_form_header a,ezc_user_workflow b where a.ECFH_WF_KEY=b.EZWF_WorkFlowKey and a.ECFH_LEVEL=b.EZWF_Level and EZWF_UserId='"+Session.getUserId()+"'";
 		
 	}
 	else
 	{
 		qryVend="select *  from ezc_customer_form_header A,ezc_user_workflow B WHERE  a.ecfh_wf_key=b.EZWF_WorkFlowKey and b.EZWF_UserId='"+Session.getUserId()+"' "+qryStr;
 	} */		
 	qryVend="select *  from ezc_customer_form_header A WHERE ECFH_DOC_ID IS NOT NULL "+qryStr;	
 		ezc.ezcommon.EzLog4j.log("** qryVend"+qryVend,"I");	
 		vendTableRow.setQuery(qryVend);
 		vendTable.appendRow(vendTableRow);
 		vendParams.setLocalStore("Y");
 		vendParams.setObject(vendTable);
 		Session.prepareParams(vendParams);
 
 		try
 		{
 			hdrVendXML=(ezc.ezparam.ReturnObjFromRetrieve)vendMgr.ezGetMiscTransactions(vendParams);
 
 		}
 		catch(Exception e)
 		{
 			out.println("Exception in getting Purchase Group List>>>>>"+e);
 		}
 		//ezc.ezcommon.EzLog4j.log("hdrVendXML>>>>"+hdrVendXML.toEzcString(),"I");
 		if(hdrVendXML!=null && hdrVendXML.getRowCount()>0)
 		toActVendCnt = hdrVendXML.getRowCount(); 
 		ezc.ezcommon.EzLog4j.log("toActVendCnt"+toActVendCnt,"I");
 	
 %>