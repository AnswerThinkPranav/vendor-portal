<jsp:useBean id="Manager1" class="ezc.client.EzMessagingManager" scope="session" />
<jsp:useBean id="ForumsManager" class="ezc.client.EzForumsManager" scope="session" />
<jsp:useBean id="TransManager" class="ezc.client.EzTransactionManager" scope="session" />
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<jsp:useBean id="AUM" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session" />

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="javax.activation.*" %>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ page import="ezc.forums.params.*" %>
<%@ page import="ezc.messaging.params.*" %>
<%@ page import="ezc.trans.messaging.params.*" %>
<%@ page import="ezc.client.*" %>
<%@ page import="ezc.ezparam.*" %>
<%@ page import="ezc.ezparam.*,ezc.ezadmin.ezadminutils.params.*" %>

<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<%
	String 	msgSubject 	= "";
	String 	msgText 	= "";
	String email="";
	String desc=(String)session.getValue("DRL_PURGROUP_DESC");
	String rfqVendor=request.getParameter("rfqVendor");
	String rfqV;
	
	
	ReturnObjFromRetrieve retObj = null;
	ReturnObjFromRetrieve retList = null;
	Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	
	 // out.println(">>>>>>>>"+rfqNo);
	
	miscParams.setQuery("SELECT EU_EMAIL FROM EZC_USERS WHERE TRIM(EU_ID) = (SELECT ERH_CREATED_BY FROM EZC_RFQ_HEADER WHERE ERH_RFQ_NO='"+rfqNo+"')");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	
	try
	{
		retList = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}
	catch(Exception e)
	{
	}
	
	if(retList!=null)
		email = retList.getFieldValueString(0,"EU_EMAIL");
	
	 // out.println(">>>>>>>>>>>>>"+email);
	 
	 
	 
	 if(vendorsHT.get(rfqVendor)==null)
	  	
	  	rfqV="";
	  else
	  	rfqV=(String)vendorsHT.get(rfqVendor);
	  	
	 ezc.ezcommon.EzLog4j.log("=========vendor==============>"+rfqV,"I"); 
	 
	msgSubject 	= "RFQ No : "+rfqNo+" has been quoted by "+rfqV;
	
	msgText 	= "<Br>Dear User,\n\n <Br> <Br> RFQ No : "+rfqNo+" has been quoted by "+rfqV +"\n\n <Br> Select the Purchase Area  \""+desc+"\"  after login into the Portal.\n\n <Br> Please click on the following link to View Quotation. \n\n <Br> <a href=\"http://e-bizv.greavesinet.com\" target=_blank>Click here to View quotation.</a>.\n\n <Br><Br> Regards, \n\n <Br> "+rfqV+"\n\n <Br><Br>";
	
	ezc.ezcommon.EzLog4j.log("=========msgSubject==============>"+msgSubject,"I");

%>
		
<%@ include file="../Inbox/ezPostExternalMail.jsp" %>






