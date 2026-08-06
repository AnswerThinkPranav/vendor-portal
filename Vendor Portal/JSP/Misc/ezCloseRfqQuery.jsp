<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%//@ include file="ezUserDefaults.jsp" %>           
<%
	
	String queryId = request.getParameter("queryId");
	String docId = request.getParameter("docId");
	String docItem = request.getParameter("docItem");
	
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow(); 
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 	 

	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("UPDATE EZC_PARTNER_QUERIES SET EPQ_CLOSED_ON=now(),EPQ_CLOSED_BY='"+Session.getUserId()+"',EPQ_STATUS='C' WHERE EPQ_ID='"+queryId+"'");
	miscTable.appendRow(miscTableRow);
	
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("UPDATE EZC_RFQ_DETAILS SET ERD_STATUS='C'  WHERE ERD_RFQ_NO='"+docId+"' AND ERD_LINE_NO='"+docItem+"'");
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
	//TO CLOSE RFQ HEADER
	ezc.ezparam.ReturnObjFromRetrieve rfqObj	  =	null;	
	int rfqLinesCnt=0;
	
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow(); 
	ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false); 
	
	miscTableRow1.setQuery("SELECT * FROM EZC_RFQ_DETAILS WHERE ERD_STATUS='Q' AND ERD_RFQ_NO='"+docId+"'");
	miscTable1.appendRow(miscTableRow1);	
	
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscTable1);
	Session.prepareParams(mainParams1);
	try
	{
		rfqObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);

	}
	catch(Exception e)
	{
		
	}
	if(rfqObj!=null)
		rfqLinesCnt=rfqObj.getRowCount();
		
	if(rfqLinesCnt == 0)
	{
	
		miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow1.setQuery("UPDATE EZC_RFQ_HEADER SET ERH_STATUS='N' WHERE ERH_RFQ_NO='"+docId+"'");
		miscTable1.appendRow(miscTableRow1);	

		mainParams1.setLocalStore("Y");
		mainParams1.setObject(miscTable1);
		Session.prepareParams(mainParams1);
		try
		{
			miscMgr1.ezSaveMiscTransactions(mainParams1);

		}
		catch(Exception e)
		{

		}
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
							Query Details Closed Successfully
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
