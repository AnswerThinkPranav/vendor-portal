<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="ezHeader.jsp"%> 
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>

<%
	//String displayMsg="Problem occured while deleting the request.";
	String dispMessage="Problem occured while submitting the request",dispMsgType="S",divWidth="90%";
	boolean errorOccured = false;
	
	String vendorProfileId= checkNull(request.getParameter("docId")); 	
	String defSoldTo    = checkNull(request.getParameter("defSoldTo")); 	
	
	
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
		EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();

		keyParams.setKey("UpdateRequestStatus");
		keyTableParams.appendRow(keyParams);
		mainParams.setLocalStore("Y");

		generalParams.setDocId(vendorProfileId);
		generalParams.setModifiedBy(Session.getUserId());
		//generalParams.setVendor(Integer.parseInt(defSoldTo)+"");
		generalParams.setVendor(Session.getUserId());
		generalParams.setStatus("DELETED");
		generalParams.setExt1("");

		mainParams.setObject(keyTableParams);	

		mainParams.setObject(generalParams);
		Session.prepareParams(mainParams);

		try{
		 vendorprofile.ezUpdateDetails(mainParams);
		 dispMessage="Request "+vendorProfileId+" has been deleted";
		}catch(Exception e){errorOccured=true;}
		
		
		if(!errorOccured)
		{
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziDocumentCommentsParams documentComments= new ezc.vendorprofile.params.EziDocumentCommentsParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_DOCUMENT_COMMENTS");
		mainParams.setLocalStore("Y");

		documentComments.setDocId(vendorProfileId);
		documentComments.setDocType("VEND_PROFILE");
		documentComments.setComments("");
		documentComments.setUserId((String)Session.getUserId());
		documentComments.setExt1("");
		documentComments.setExt2("");
		documentComments.setExt3("");

		mainParams.setObject(keyParams);	
		mainParams.setObject(documentComments);
		Session.prepareParams(mainParams);

		try{
			ezc.ezcommon.EzLog4j.log(":::::Before save documentComments:::::","I");
			vendorprofile.ezSaveDetails(mainParams);
			ezc.ezcommon.EzLog4j.log(":::::After save documentComments:::::","I");
		}catch(Exception e){}
		
		
		mainParams = new ezc.ezparam.EzcParams(true);
		ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFAuditTrailParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
		keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();

		keyParams.setKey("ADD_AUDIT_TRAIL");
		mainParams.setLocalStore("Y");

		eziWFAuditTrailParams.setEwhAuditTrailNo("1");
		eziWFAuditTrailParams.setEwhDocId(vendorProfileId);
		eziWFAuditTrailParams.setEwhType("POSTEDTOSAP");
		eziWFAuditTrailParams.setEwhSourceParticipant((String)Session.getUserId());
		eziWFAuditTrailParams.setEwhSourceParticipantType("U");
		//eziWFAuditTrailParams.setEwhDestParticipant(Integer.parseInt(defSoldTo)+"");
		eziWFAuditTrailParams.setEwhDestParticipant("PURPERSON");
		eziWFAuditTrailParams.setEwhDestParticipantType("U");
		eziWFAuditTrailParams.setEwhComments("Request "+vendorProfileId+" has been Deleted");

		mainParams.setObject(keyParams);	
		mainParams.setObject(eziWFAuditTrailParams);
		Session.prepareParams(mainParams);

		try{

			vendorprofile.ezSaveDetails(mainParams);
		}catch(Exception e){}
		
		//String sendToUser= (String)Session.getUserId()+","+Integer.parseInt(defSoldTo);
		String sendToUser= (String)Session.getUserId()+",PURPERSON";

		String msgSubject = "Vendor profile request has been deleted";
		String msgText = "Dear Sir/Madam,<br><br> Vendor profile request "+vendorProfileId+" has been deleted.&nbsp;<br>";
		msgText = msgText+"<BR>";
		msgText += "Regards,<br>"+v_fname+v_mname+v_lname;
		
		
		String inboxPath="";
	 	
		
%>	
	<%@ include file="../Purorder/ezSendMail.jsp" %>		
<%	
	}
%>
<Html>
<Head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<style>
.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
</style>
  
</Head>

  
  <!-- Content Wrapper. Contains page content -->
        <Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Vendor Profile
            </h4>
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	<Body>          
        <form method="post"  name="myForm">
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
	         		
	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>
</Html>      

