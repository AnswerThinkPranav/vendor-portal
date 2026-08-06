<%@ include file="../Misc/iGetUserName.jsp" %>
<%
	ezc.ezparam.ReturnObjFromRetrieve globalRet = null;
	
	java.util.Hashtable hashNavigateFile = new java.util.Hashtable();
	java.util.Hashtable hashCompCode = new java.util.Hashtable();
	hashNavigateFile.put("QCF","CON_RELEASE");
	hashNavigateFile.put("PO","PO_RELEASE");
	hashNavigateFile.put("CON","PO_RELEASE");


	String offlinex = (String)session.getValue("OFFLINE");
	String border="";
	if(offlinex != null || "Y".equals(offlinex))
		border="0";
	else
		border="1";

	/*
	int qcsRetCnt=0;
	ezc.ezparam.ReturnObjFromRetrieve qcsRet = null;

	ezc.ezpreprocurement.client.EzPreProcurementManager qcfManager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	mainParams.setLocalStore("Y");
	ezc.ezpreprocurement.params.EziQcfCommentParams qcfParams= new ezc.ezpreprocurement.params.EziQcfCommentParams();
	qcfParams.setQcfExt1("$$$");
	qcfParams.setQcfDestUser(Session.getUserId());
	qcfParams.setQcfType("QUERY");
	qcfParams.setQcfQueryMap("0");
	mainParams.setObject(qcfParams);
	Session.prepareParams(mainParams);
	qcsRet = (ezc.ezparam.ReturnObjFromRetrieve)qcfManager.getQcfCommentList(mainParams);


	if(qcsRet!=null || !"null".equals(qcsRet))
	{
		qcsRetCnt = qcsRet.getRowCount();

		String dateSep = (String)session.getValue("DATESEPERATOR");
		

		Vector grtypes = new Vector();
		grtypes.addElement("date");
		EzGlobal.setColTypes(grtypes);
		//EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");
		EzGlobal.setDateFormat("MM/dd/yyyy hh:mm");

		Vector grColNames = new Vector();
		grColNames.addElement("QCF_DATE");
		EzGlobal.setColNames(grColNames);

		globalRet = EzGlobal.getGlobal(qcsRet);

	}*/
	
	String qTypeDB="";
	String qrytype=request.getParameter("qrytype");
	//String docNo=request.getParameter("docNo");
	ezc.ezcommon.EzLog4j.log(":::::docNo:::::::"+docNo,"I");
	if(qrytype==null || "null".equals(qrytype))qrytype="ALL";
	if("ALL".equals(qrytype))qTypeDB="QCF','VNR";
	else qTypeDB=qrytype;
	String status=request.getParameter("status");
	if(status==null || "null".equals(status))status="Pending";
		
	int qcsRetCnt=0;
	int qcsRet3Cnt=0;
	ezc.ezparam.ReturnObjFromRetrieve qcsRet = null;
	
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);  
			
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qry1="";
	String qry2="";
	String qry3="";
	if("Pending".equals(status))
	{
		qry1="select * from ezc_qcf_comments where EQC_QUERY_MAP='0' and EQC_TYPE='QUERY' and EQC_EXT2 in('"+qTypeDB+"') and eqc_dest_user='"+Session.getUserId()+"'";
	}
	else
	{
		qry1="select * from ezc_qcf_comments where EQC_QUERY_MAP='1' and EQC_TYPE='REPLY' and EQC_EXT2 in('"+qTypeDB+"') and eqc_user='"+Session.getUserId()+"'";
	}
	
	ezc.ezcommon.EzLog4j.log("** qry1"+qry1,"I");

	miscTableRow1.setQuery(qry1);
	miscTable1.appendRow(miscTableRow1);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	
	try
	{
		qcsRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}	
	if(qcsRet!=null || !"null".equals(qcsRet))
		qcsRetCnt = qcsRet.getRowCount();
	

%>

