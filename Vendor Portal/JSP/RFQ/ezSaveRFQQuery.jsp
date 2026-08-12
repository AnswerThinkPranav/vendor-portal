<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%//@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%@ page import = "java.io.*"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>
<%!
	private String checkNull(String str){ 
			if("null".equals(str) ||str==null || "".equals(str))
			str="";
			return str.trim();
	}
%>		
<%
		boolean successFlg = true;	
		String query = request.getParameter("query");
		String docID = request.getParameter("docID");
		String docItem  = checkNull(request.getParameter("queryLine"));
		String fromPg= checkNull(request.getParameter("fromPg"));
		String createdBY   = checkNull(request.getParameter("createdBY"));
		String gv_UserType = checkNull((String)session.getValue("UserType"));
		String loggedUser=(String)Session.getUserId();
		String eMailData = "", msgShipMailSubject = "",eMailDataDocs="";
		String userMailid="";
		String bgColor = "bgcolor=\"#FFFFFF\"";
		String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
		String tdBGColor = "style=\"background-color: #EDF1F4;\"";

		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();

		String queryId = "";

		ezc.ezparam.EzcParams mainParams_range = new ezc.ezparam.EzcParams(false);                                                             
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr_range = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzGetNewNumberParams numRangeParam_range = new ezc.misctransactions.params.EzGetNewNumberParams();

		mainParams_range = new ezc.ezparam.EzcParams(false); 
		numRangeParam_range = new ezc.misctransactions.params.EzGetNewNumberParams();
		numRangeParam_range.setNumberFor("MISC_ID");

		try 
		{
			mainParams_range.setLocalStore("Y");
			mainParams_range.setObject(numRangeParam_range);
			Session.prepareParams(mainParams_range);
			Object newNumber = (Object)miscMgr_range.ezGetNewnumber(mainParams_range);
			queryId = newNumber+"";
		}catch(Exception e){} 	

		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("INSERT INTO EZC_PARTNER_QUERIES (EPQ_ID,EPQ_SOLD_TO,EPQ_TYPE,EPQ_QUERY,EPQ_POSTED_BY,EPQ_POSTED_ON,EPQ_STATUS,EPQ_EXT2,EPQ_EXT3) VALUES('"+queryId+"','"+Session.getUserId()+"','RFQ','"+query+"','"+Session.getUserId()+"',now(),'S','"+docID+"','"+docItem+"')");
		miscTable.appendRow(miscTableRow);
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("INSERT INTO EZC_PARTNER_QUERY_CHAT (EPQC_ID,EPQC_REPLY,EPQC_REPLIED_BY,EPQC_REPLIED_ON) VALUES('"+queryId+"','"+query+"','"+Session.getUserId()+"',now())");
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try
		{
		miscMgr.ezSaveMiscTransactions(mainParams);

		}
		catch(Exception e){}
		
		//STATUS update at RFQ HEADER
		
		mainParams = new ezc.ezparam.EzcParams(false); 				
		miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		miscTable = new ezc.misctransactions.params.EzMiscTable();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();		
	
		String qry="";
		//if("V".equals(fromPg) && "3".equals(gv_UserType))
			//qry="UPDATE EZC_RFQ_HEADER SET ERH_STATUS='Q'  WHERE ERH_RFQ_NO='"+docID+"'";
		//if("V".equals(fromPg) && !"3".equals(gv_UserType))
			//qry="UPDATE EZC_RFQ_HEADER SET ERH_STATUS='V'  WHERE ERH_RFQ_NO='"+docID+"'";
		if("".equals(fromPg))
			qry="UPDATE EZC_RFQ_HEADER SET ERH_STATUS='Q'  WHERE ERH_RFQ_NO='"+docID+"'";
		ezc.ezcommon.EzLog4j.log("qry>>2"+qry,"I");
		miscTableRow.setQuery(qry);
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try
		{
			miscMgr.ezSaveMiscTransactions(mainParams);

		}
		catch(Exception e)
		{
			log("Exception in Updating Audit Header>>>>>"+e);
		}
		
		mainParams = new ezc.ezparam.EzcParams(false); 				
		miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		miscTable = new ezc.misctransactions.params.EzMiscTable();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();		
		
		qry="UPDATE EZC_RFQ_DETAILS SET ERD_QUERY='"+queryId+"',ERD_STATUS='Q'  WHERE ERD_RFQ_NO='"+docID+"' AND ERD_LINE_NO='"+docItem+"'" ;
		ezc.ezcommon.EzLog4j.log("qry>>3"+qry,"I");
		miscTableRow.setQuery(qry);
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try
		{
			miscMgr.ezSaveMiscTransactions(mainParams);

		}
		catch(Exception e)
		{
			log("Exception in Updating Audit Header>>>>>"+e);
		}		
	
		eMailData = "Dear Sir/Madam,<Br><Br>Query has been raised  against RFQ : "+docID+" <Br><Br>";
		eMailData += "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th "+thBGColor+" colspan=4>Query </Th><Td "+tdBGColor+">"+query+"</Td></Tr></Table><Br>";		
		if("3".equals(gv_UserType))
		{
			String vendname=getVendorName(Session,loggedUser);
			msgShipMailSubject = " Query has been raised  against RFQ : "+docID+" by Vendor : "+session.getValue("Vendor")+"["+Session.getUserId()+"]";
			eMailData +=  "<Br><Br>Regards,<Br>"+session.getValue("Vendor")+"["+Session.getUserId()+"]<Br>";
			userMailid=getUserMail(Session,createdBY);
		}
		else
		{

			msgShipMailSubject = " Query has been answered  against RFQ: "+docID+" By User : "+loggedUser+"["+loggedUser+"]";
			eMailData +=  "<Br><Br>Regards,<Br>"+loggedUser+"["+loggedUser+"]<Br>";
			userMailid=getUserMail(Session,loggedUser);

		}




		sendMail(Session,"hchowdary@answerthink.com","hchowdary@answerthink.com","",eMailData,msgShipMailSubject);
		if(!"V".equals(fromPg))
			out.print(successFlg);
%>
<%
if("V".equals(fromPg))
{
%>
<Html>
<Head>
<base target="_self">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
 <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
 <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>

<script>
function funClose()
{
	window.parent.closeModal();
	
	
}
</script>
<style>
th
{
	    background-color: #3c8dbc;
	    color:white;
}
button
{
	margin-left:2px;
}
</style>
</head>

<body scroll=no>
<form name="myForm" id="myForm">
	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper" style="margin-left: 0px !important;">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Query Id : <%=docID%>
		</h1>
	</section>

	<!-- Main content -->
	<section class="content">
		<div class="row">
			<div class="col-md-12 col-xs-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<center>
						<div class="alert alert-success">
						<h4><i class="icon fa fa-check"></i> Success</h4>
							Query Details Saved Successfully
						</div>
					</center>
				</div>
			</div>
		</div>
		</br>
		<div class="row no-print" style="text-align:center;">
		<div class="col-xs-12">
				<button type="button" onclick="funClose()" class="btn btn-primary " style="left: 50%;"> OK</button>

		</div>
		</div>
	
	
	</section><!-- /.content -->
	</div><!-- /.content-wrapper --> 

</form>
</Body>
</Html>
<%}%>
