<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import ="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%@ page import = "java.util.*"%>
<%


	String qryDocNo  = request.getParameter("qcfNo");
	String qryCheckUserId = (String)Session.getUserId();

	
	ReturnObjFromRetrieve qcsRet = null;
	
	int retCount=0,noRplyCount = 0,rplyCount = 0;
	String tempString = "";
	String rtrnStmt = "";
	
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();	
	
	miscTableRow1.setQuery("SELECT EQC_COMMENT_NO,SUM(CAST(EQC_QUERY_MAP AS SIGNED)) QUERY_STATUS FROM EZC_QCF_COMMENTS WHERE EQC_CODE='"+qryDocNo+"' AND EQC_TYPE='QUERY' AND EQC_USER='"+qryCheckUserId+"'  GROUP BY EQC_COMMENT_NO ORDER BY CAST(EQC_COMMENT_NO AS SIGNED)");
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
	
	
	
	if(qcsRet != null)
	{
		retCount = qcsRet.getRowCount();
		if(retCount > 0)
		{
			rtrnStmt = "Q";
			for(int i=0;i<retCount;i++)
			{
				if("0".equals(qcsRet.getFieldValueString(i,"QUERY_STATUS")))
				{
					noRplyCount++;
				}
			}

			if(noRplyCount > 0)
			{
				rtrnStmt = "Q";
			}
			else if(noRplyCount == 0)
			{
				tempString = qcsRet.getFieldValueString(retCount-1,"QUERY_STATUS");
				/*
				if("0".equals(tempString))
					rtrnStmt = "Q";
				if("-1".equals(tempString))
					rtrnStmt = "R";
				*/
				try
				{
					int tempVar = Integer.parseInt(tempString);

					if(tempVar >= 0)
						rtrnStmt = "Q";
					else
						rtrnStmt = "R";
				}
				catch(Exception ex){rtrnStmt = "Q";}		
			}
		}
		else
		{
			rtrnStmt = "N";
		}


	}
	
	out.println("QRY#"+rtrnStmt+"#");

%>
	

