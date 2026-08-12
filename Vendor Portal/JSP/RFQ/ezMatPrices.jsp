<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*,java.text.SimpleDateFormat,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>  
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/morris/morris.css">

<html>
<head>
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>

</head> 
<body scroll=no>
<form name="myForm" id="myForm" method="post">

<%	
	String display_header	= "Material Prices"; 
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%>		
		<br>
		<div class="box" style="padding: 13px;">
      <div class="row">
<div class="col-xs-12 table-responsive">
<table  class="table table-bordered">
<tr>
	<Th align="left">MATERIAL</Th>
		<Td align="center">
			<input type="text" name="matNum" value="">
			<button type="button" class="btn btn-primary pull-right" onclick="ezDisplay()" style="margin-right: 5px;">GO</button>
		</Td>
</tr>


</table>
<div class="box box-info">
	 <div class="box-header with-border">
	 <h3 class="box-title">Line Chart</h3>
	 <div class="box-tools pull-right">
	 <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
	 </button>
	 <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
	 </div>
	 </div>
	 <div class="box-body chart-responsive">
	 <div class="chart" id="line-chart" style="height: 300px;"></div>
</div>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	

		</div>
</form>
<%
	String matNum = request.getParameter("000000050000000212");
	Hashtable <String,String> dochHash = new Hashtable <String,String>();
	
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null;
	
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	rfqTableRow.setQuery("select A.EWDHH_DOC_ID,A.EWDHH_WF_STATUS,B.ERH_STATUS,DATE_FORMAT(B.ERH_RFQ_DATE,'%Y-%m') AS RFQDAT,C.ERD_MATERIAL,C.ERD_PRICE from ezc_wf_doc_history_header as A join ezc_rfq_header as B on A.EWDHH_DOC_ID=B.ERH_COLLETIVE_RFQ_NO inner join ezc_rfq_details as C on b.ERH_RFQ_NO=C.ERD_RFQ_NO WHERE EWDHH_WF_STATUS='APPROVED' and ERD_MATERIAL='000000050000000212'");
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	int hdrXMLCnt = 0;

	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		ezc.ezcommon.EzLog4j.log("MATERIAL>>>>>"+matNum,"I");
	}

	catch(Exception e)
	{
		out.println("Exception in displaying material prices>>>>>"+e);
	}
		

	if(hdrXML!=null)
	{
		 hdrXMLCnt = hdrXML.getRowCount();
	}
	for(int i=0; i<hdrXMLCnt; i++)
	{
		dochHash.put(hdrXML.getFieldValueString(i,"ERD_MATERIAL"),hdrXML.getFieldValueString(i,"ERD_PRICE"));
		if(dochHash.containsKey("000000050000000212"))
		continue;
	}
	
%>



<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

<script>
function ezDisplay() {
	if(matNum=="")
	{
		alert("Please enter material number");
	}
	else
	{
		
		document.myForm.action="ezMatPrices.jsp";
		document.myForm.submit();
	}
}
</script>

<script src="../../../../EzCommon/Library/plugins/morris/morris.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/raphael/raphael.min.js"></script>
<script>
	$(function () {
		"use strict";
		var line = new Morris.Line({
		element: 'line-chart',
		resize: true,
		data: [
		
			<%
				for(int i=0;i<hdrXMLCnt;i++)
				{
			%>
				{y: '<%=hdrXML.getFieldValueString(i,"RFQDAT")%>', item1: <%=hdrXML.getFieldValueString(i,"ERD_PRICE")%>},
			<%
				}
			%>
			],
			xkey: 'y',
			ykeys: ['item1'],
			labels: ['Item 1'],
			lineColors: ['#3c8dbc'],
			hideHover: 'auto'

	});
	});

</script>
</body>
</html>
