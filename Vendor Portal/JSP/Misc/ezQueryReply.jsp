<%!
public String convertDateObjToString(java.util.Date inputDate)
	{
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("d MMM yyyy HH:mm:ss");
		String stringObj = "";
		try {
			stringObj = sdf.format(inputDate);

		} catch (Exception e) {
			
		}
		return stringObj;
		
	}
	public String globalNullCheck(String inStr)
	{

		if(inStr==null || "null".equals(inStr)) 
			inStr = "";
		else if(inStr!=null) 
			inStr = inStr.trim();
		else
			inStr = "";

		return inStr;	
	}
%>
	<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String queryId = request.getParameter("queryId");
	String docId = globalNullCheck(request.getParameter("docId"));
	String docItem = globalNullCheck(request.getParameter("docItem"));
	String fromPage= globalNullCheck(request.getParameter("fromPage"));
	String qmDocId = globalNullCheck(request.getParameter("qmDocId"));
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retHead	  =	null; 
	miscTableRow.setQuery("SELECT * FROM EZC_PARTNER_QUERIES WHERE EPQ_ID='"+queryId+"'");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		retHead=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		//out.print(retHead.toEzcString());
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retHeadCnt = 0;
	if(retHead != null)
		retHeadCnt = retHead.getRowCount();
	
	mainParams = new ezc.ezparam.EzcParams(false); 				
	miscTable = new ezc.misctransactions.params.EzMiscTable();
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retItems	  =	null; 
	miscTableRow.setQuery("SELECT * FROM EZC_PARTNER_QUERY_CHAT WHERE EPQC_ID='"+queryId+"' ORDER BY EPQC_REPLIED_ON");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		retItems=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		//out.print(retItems.toEzcString());
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retItemsCnt = 0;
	if(retItems != null)
	retItemsCnt = retItems.getRowCount();
	
	//out.println("retItemsCnt:::"+retItemsCnt+"::::"+retItems.toEzcString());

	
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
	var frompage = '<%=fromPage%>';
	//alert("frompage>>"+frompage);
	if(frompage === 'RFQ')
		document.myForm.action="ezCloseRfqQuery.jsp";
	else
		document.myForm.action="ezCloseQuery.jsp";
		document.myForm.submit();
}
function funSubmit()
{
	var replyMsg= document.myForm.replyMsg.value;
	if(replyMsg == "")
	{
		alert("Please Enter Message");
		return ;
	}
		document.myForm.action="ezSaveReply.jsp";
		document.myForm.submit();
		
	
	
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

<body style="overflow-y: hidden;">
<form name="myForm" id="myForm">
	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper" style="margin-left: 0px !important;">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
<%
		if("RFQ".equals(fromPage)){
%>		
			Query for : <%=docId%> with Line: <%=docItem%>
<%
		}else{
%>
			Query Id  : <%=queryId%>
<%
		}
%>		
			
			<input type="hidden" name="queryId" value="<%=retHead.getFieldValueString(0,"EPQ_ID")%>">
			<input type="hidden" name="qmDocId" value="<%=qmDocId%>">
			<input type="hidden" name="queryType" value="<%=retHead.getFieldValueString(0,"EPQ_EXT1")%>">
			<input type="hidden" name="docId" value="<%=docId%>">
			<input type="hidden" name="docItem" value="<%=docItem%>">
		</h1>
	</section>

	<!-- Main content -->
	<section class="content">
		<div class="row">
			<div class="col-md-12 col-xs-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box box-primary direct-chat direct-chat-primary">
						<div class="box-body">  
		
		<div class="direct-chat-messages" style="height:350px">
<%
	String userId=Session.getUserId();
	for(int i=0;i<retItemsCnt;i++)
	{
		if(userId.equals(retItems.getFieldValueString(i,"EPQC_REPLIED_BY")))
		{
%>
								    <!-- Message. Default to the left -->
								    <div class="direct-chat-msg">
									<div class="direct-chat-info clearfix">
									    <span class="direct-chat-name pull-left"><%=retItems.getFieldValueString(i,"EPQC_REPLIED_BY")%></span>
									    <span class="direct-chat-timestamp pull-right"><%=convertDateObjToString((java.util.Date)retItems.getFieldValue(i,"EPQC_REPLIED_ON"))%></span>
									</div><!-- /.direct-chat-info -->
									<img class="direct-chat-img" src="../../../../EzCommon/Library/img/ceat.GIF" alt="message user image">
									<!-- /.direct-chat-img -->
									<div class="direct-chat-text">
									    <%=retItems.getFieldValueString(i,"EPQC_REPLY")%>
									</div><!-- /.direct-chat-text -->
								    </div><!-- /.direct-chat-msg -->
<%
		}
		else
		{
%>
								    <!-- Message to the right -->
								    <div class="direct-chat-msg right">
									<div class="direct-chat-info clearfix">
									    <span class="direct-chat-name pull-right"><%=retItems.getFieldValueString(i,"EPQC_REPLIED_BY")%></span>
									    <span class="direct-chat-timestamp pull-left"><%=convertDateObjToString((java.util.Date)retItems.getFieldValue(i,"EPQC_REPLIED_ON"))%></span>
									</div><!-- /.direct-chat-info -->
									<img class="direct-chat-img" src="../../../../EzCommon/Library/img/ceat.GIF" alt="message user image">
									<!-- /.direct-chat-img -->
									<div class="direct-chat-text">
									    <%=retItems.getFieldValueString(i,"EPQC_REPLY")%>
									</div><!-- /.direct-chat-text -->
								    </div><!-- /.direct-chat-msg -->
<%
		}
	}
%>
							</div>
						</div>
<%
	if(!"C".equals(retHead.getFieldValueString(0,"EPQ_STATUS")))
	{
%>
						<div class="box-footer">
							<div class="input-group" style="width: 100%;">
							<input type="text" name="replyMsg" placeholder="Type Message ..." class="form-control">
							<span class="input-group-btn">
							<button type="button" onclick="funSubmit()" class="btn btn-primary btn-flat">Send</button>
							</span>
							</div>
						</div>
<%
	}
%>
					</div>
				</div> 
			</div>
		</div>
		</br>
		<div class="row no-print" style="text-align:center;"> 
		<div class="col-xs-12">
<%
	if(Session.getUserId().equals(retHead.getFieldValueString(0,"EPQ_POSTED_BY")) && !"C".equals(retHead.getFieldValueString(0,"EPQ_STATUS")))
	{
%>
				<button type="button" onclick="funClose()" class="btn btn-primary " style="left: 50%;"> Close Query</button>
<%
	}
%>
		</div>
		</div>
	
	
	</section><!-- /.content -->
	</div><!-- /.content-wrapper --> 

</form>
</Body>
</Html>
