<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<Html>
<Head>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Save  Audit Findings";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

<%
	String auditVendor=request.getParameter("auditVendor");
	String auditNumber=request.getParameter("auditNumber");
	String closingRemarks=request.getParameter("closingRemarks");
	String extensionDate=request.getParameter("extensionDate");
	String selAction =request.getParameter("selAction");
	
	try
	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzAuditFindingsParams auditFindingParams= new ezc.vendortransactions.params.EzAuditFindingsParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		
		auditFindingParams.setVendor(auditVendor);
		auditFindingParams.setRefNumber(auditNumber);
		auditFindingParams.setModifiedBy(Session.getUserId());
		
		
		if("EXTEND".equals(selAction))
		{
			auditFindingParams.setDueDate(extensionDate);
			keyParams.setKey("UPDATE_AUDITFINDINGS_DUE_DATE");
		}	
		else if("CLOSE".equals(selAction))
		{
			auditFindingParams.setStatus("C");
			auditFindingParams.setVendorComments(closingRemarks+" -- Closing Remarks By MTR QA");
			keyParams.setKey("UPDATE_AUDITFINDINGS_STATUS");
		}	
		
		out.println(":::getKey:::"+keyParams.getKey());
		
		addMainParams.setLocalStore("Y");
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(auditFindingParams);
		Session.prepareParams(addMainParams);

		ezAuditFindingManager.ezUpdateVendorTransactions(addMainParams);
		
	}
	catch(Exception e)
	{
	      out.println(":::EEEE:::"+e);
	}	
%>
<script>
	window.opener.location.href="ezListAudit.jsp?FromDate=<%=request.getParameter("FromDate")%>&ToDate=<%=request.getParameter("ToDate")%>&vendCode=<%=request.getParameter("listSelVendor")%>";
	self.close(); 
</script>
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>