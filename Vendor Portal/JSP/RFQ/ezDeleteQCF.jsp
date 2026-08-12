<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import = "ezc.ezparam.*,ezc.ezutil.FormatDate.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ page import="ezc.ezmisc.params.*" %>

<%
	String docType=request.getParameter("docType");
	String docNo=request.getParameter("docNo");
	String fromPage=request.getParameter("fromPage");
	String rfqNo = "";
	int rfqCount=0;
	if("QCF".equals(docType))
	{
		ReturnObjFromRetrieve rfqRetObj = ezMiscSelect(Session,"SELECT GROUP_CONCAT(ERH_RFQ_NO) AS RFQ_NO,count(ERH_RFQ_NO) AS RFQ_COUNT FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO='"+docNo+"' AND (ERH_PO_FLAG IS NULL OR ERH_PO_FLAG='')");
		if(rfqRetObj != null)
		{
			rfqNo = rfqRetObj.getFieldValueString(0,"RFQ_NO");
			rfqNo = rfqNo.replaceAll(",","','");
		}
	}
	else if("RFQ".equals(docType))
	{
		rfqNo = docNo;
	}
	//out.print("rfqNo::"+rfqNo);
	
	ArrayList<String> queries=new ArrayList<String>();
	
	if("QCF".equals(docType) && "WF".equals(fromPage))
	{
		queries.add("DELETE FROM EZC_WF_AUDIT_TRAIL WHERE EWAT_DOC_ID IN ('"+docNo+"')");
		queries.add("DELETE FROM EZC_WF_DOC_HISTORY_HEADER WHERE EWDHH_DOC_ID IN ('"+docNo+"')");
	}
	
	queries.add("DELETE FROM EZC_RFQ_SERVICES WHERE ERS_SRV_RFQ IN ('"+rfqNo+"')");
	queries.add("DELETE FROM EZC_RFQ_QUOTE_HISTORY WHERE ERQH_RFQ_NO IN ('"+rfqNo+"')");
	queries.add("DELETE FROM EZC_RFQ_ITEM_CONDITIONS WHERE ERIC_RFQ_NO IN ('"+rfqNo+"')");
	queries.add("DELETE FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO IN ('"+rfqNo+"')");
	queries.add("DELETE FROM EZC_RFQ_HEADER WHERE ERH_RFQ_NO IN ('"+rfqNo+"')");
	if("QCF".equals(docType))
		queries.add("DELETE FROM EZC_RFQ_PRS WHERE ERP_QCF_NO IN ('"+docNo+"')");
	queries.add("DELETE FROM EZC_UPLOAD_DOCUMENT WHERE EUD_DOC_TYPE='RFQ' AND EUD_DOC_NO IN ('"+rfqNo+"')");
	queries.add("DELETE FROM EZC_DOCUMENT_COMMENTS WHERE EDC_DOC_TYPE='RFQ' AND EDC_DOC_ID IN ('"+rfqNo+"')");
	ezMiscInsert(Session,queries);
	
	ezc.ezcommon.EzLog4j.log("** queries"+queries,"I");
	
	String display_header = "Confirmation"; 
%>
<html> 
<head>
<%@ include file="../Misc/ezHeader.jsp"%> 
<script>
	function checkList()
	{
		location.href="../Misc/ezWelcome_New.jsp";
	}
</script>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<center> 

	<div class="alert alert-success" style="width:50%">
	<h4><i class="icon fa fa-check"></i> Success</h4>
	<%=("QCF".equals(docType))?"QCF - ":"RFQ - "%> <strong> <%=docNo%> </strong>has been deleted successfully.
	</div>
</center>
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	
</center>
<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
 

