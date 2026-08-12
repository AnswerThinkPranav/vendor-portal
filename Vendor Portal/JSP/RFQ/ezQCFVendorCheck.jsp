<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import = "java.io.*"%>
<%
	boolean successFlg = false;
	String qcfNo = request.getParameter("qcfNo");
	ezc.ezcommon.EzLog4j.log("qcfNo>>>"+qcfNo,"I");
	
	String vendStr = request.getParameter("chkVend");
	ezc.ezcommon.EzLog4j.log("vendStr>>>"+vendStr,"I");

	int rfqLinesCnt=0;
	String qryRfq="";
	ezc.ezparam.ReturnObjFromRetrieve rfqObj	  =	null;	
	
	//CHECK IF PR EXISTS
	
	ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	qryRfq="SELECT DISTINCT(ERH_SOLD_TO) FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO ='"+qcfNo+"' AND ERH_SOLD_TO IN('"+vendStr+"')" ; 
	
	ezc.ezcommon.EzLog4j.log("** ezQCFVendorCheck in AJAX"+qryRfq,"I");

	qcfTableRow.setQuery(qryRfq);
	qcfTable.appendRow(qcfTableRow);
	qcfParams.setLocalStore("Y");
	qcfParams.setObject(qcfTable);
	Session.prepareParams(qcfParams);

	try
	{
		rfqObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMgr.ezGetMiscTransactions(qcfParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting PR List>>>>>"+e);
	}	
	ezc.ezcommon.EzLog4j.log("rfqObj iin PR LIST>>>>"+rfqObj.toEzcString(),"I");	
	
	if(rfqObj!=null)
		rfqLinesCnt=rfqObj.getRowCount();
		
	if(rfqLinesCnt>0)
	{
		successFlg = true;
		
	}	
	
	out.print(successFlg);
%>
