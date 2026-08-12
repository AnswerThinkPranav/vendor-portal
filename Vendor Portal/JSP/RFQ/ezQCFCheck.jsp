<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import = "java.io.*"%>
<%
	boolean successFlg = false;
	String qcfNo="";
	String puReqDB = request.getParameter("puReqTotChk");
	ezc.ezcommon.EzLog4j.log("puReqDB>>>"+puReqDB,"I");
	if(!"".equals(puReqDB) && puReqDB!=null) 
	{
		puReqDB = puReqDB.replaceAll("#","¥");
		
	}
	
	String prArr[] = puReqDB.split("__");
	String tempPR="";
	for(int i=0;i<prArr.length;i++)
	{
		if(i==0)
			tempPR = prArr[i];
		else
			tempPR= tempPR+"$"+prArr[i];
		
	}
	ezc.ezcommon.EzLog4j.log("tempPR After>>>"+tempPR,"I");
	int rfqLinesCnt=0;
	String qryRfq="";
	ezc.ezparam.ReturnObjFromRetrieve rfqObj	  =	null;	
	
	//CHECK IF PR EXISTS
	
	ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	qryRfq="SELECT DISTINCT(ERH_COLLETIVE_RFQ_NO) FROM EZC_RFQ_HEADER WHERE ERH_PR_TEXT ='"+tempPR+"'" ; 
	
		

	ezc.ezcommon.EzLog4j.log("** qryRfq in AJAX"+qryRfq,"I");

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
		qcfNo=rfqObj.getFieldValueString(0,"ERH_COLLETIVE_RFQ_NO");
	}	
	
	out.print(qcfNo);
%>
