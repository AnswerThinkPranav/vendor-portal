<%@ page import="ezc.vendortransactions.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendortransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session"></jsp:useBean>
  <%//@ include file="ezHeader.jsp"%> 


<%!
public String checkNull(String value)
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	return value;
} 
%> 
<%
EziMiscParams miscParams = new EziMiscParams();   
 try
      	{
      		soldTo = Integer.parseInt(soldTo)+"";
     	}catch(Exception e){}
String QueryType = checkNull(request.getParameter("category"));
String Query = checkNull(request.getParameter("comment"));
System.out.println(soldTo+"<>"+QueryType+"<>"+Query);
Query=Query.replaceAll("'","`");

ReturnObjFromRetrieve vendorProfileRetObj =null;
ezc.ezparam.EzcParams qr_mainParams = new ezc.ezparam.EzcParams(true);
ezc.vendortransactions.params.EzVendorTransactionsKeyParams generalParams= new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
ezc.vendortransactions.params.EzPartnerQueriesParams inParams = new ezc.vendortransactions.params.EzPartnerQueriesParams();

	generalParams.setKey("SAVE_PARTNER_QUERIES");

	inParams.setQueryType(QueryType);
	inParams.setQuery(Query);
	inParams.setPostedBy(soldTo);
	inParams.setReply("");
	inParams.setRepliedBy("");
	inParams.setStatus("");
	inParams.setAttachements("");
	inParams.setExt1("");
	inParams.setExt2("");
	inParams.setExt3("");
	
	
	qr_mainParams.setLocalStore("Y");
	qr_mainParams.setObject(generalParams);
	qr_mainParams.setObject(inParams);
	Session.prepareParams(qr_mainParams);
	
	
	try{
		vendortransactions.ezSaveVendorTransactions(qr_mainParams);
	}catch(Exception e){
		out.println(e);
	}
	String toEMailIds = "";
	String ccEMailIds = "";
	
	String msgSubject = "Query Posted By Vendor "+(String)session.getValue("Vendor");
	String eMailData  = "Category : "+QueryType;
	eMailData  += "<Br> Query  : "+Query;
	eMailData  += "<Br><Br> Regards,<Br> "+(String)session.getValue("Vendor")+"<Br>";
	
	String eMailType = "SERVICE_CENTER";
	String eMailValue = "EMAIL"; 
	
%>
	<%@ include file="../Misc/ezGetIntUserEMail.jsp" %>
<%
	ezc.ezcommon.EzLog4j.log("QUERY -- TO-MAILIDS>>>>>>>"+toEMailIds,"I");
%>
	<%@ include file="../Misc/ezSendExternalMail.jsp" %>

<%	
	response.sendRedirect("ezVendorQuery.jsp");  
%>	