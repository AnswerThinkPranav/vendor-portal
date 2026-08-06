<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ include file="ezUserDefaults.jsp" %>           
<%
	
	String queryId = request.getParameter("queryId");
	String replyMsg = request.getParameter("replyMsg"); 
	String queryType = request.getParameter("queryType");
	String qmDocId = globalNullCheck(request.getParameter("qmDocId"));	
	String status="S";
	if("2".equals(gv_UserType))
		status = "A";
	if("3".equals(gv_UserType) && "LOG".equals(queryType)) 
		status = "A";		
		
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 	 

	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("UPDATE EZC_PARTNER_QUERIES SET EPQ_REPLIED_ON=now(),EPQ_REPLIED_BY='"+Session.getUserId()+"',EPQ_STATUS='"+status+"' WHERE EPQ_ID='"+queryId+"'");
	miscTable.appendRow(miscTableRow);
	if("C".equals(status)||"A".equals(status)){
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery(" UPDATE EZC_QA_MANUAL_ACK_VENDORS SET EQMAV_STATUS = 'N' WHERE EQMAV_QUERY_ID = '"+queryId+"'");
		miscTable.appendRow(miscTableRow);
	}else if("S".equals(status)){
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery(" UPDATE EZC_QA_MANUAL_ACK_VENDORS SET EQMAV_STATUS = 'S' WHERE EQMAV_QUERY_ID = '"+queryId+"'");
		miscTable.appendRow(miscTableRow);	
	}
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("INSERT INTO EZC_PARTNER_QUERY_CHAT (EPQC_ID,EPQC_REPLY,EPQC_REPLIED_BY,EPQC_REPLIED_ON) VALUES('"+queryId+"','"+replyMsg+"','"+Session.getUserId()+"',now())");
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
		
	}
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
	var qmDocId = '<%=qmDocId%>';
	if(qmDocId!="")
		top.location.replace("ezListQMDocDetails.jsp?qmDocId="+qmDocId+"&status=ALL");
	else
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
			Query Id : <%=queryId%>
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
