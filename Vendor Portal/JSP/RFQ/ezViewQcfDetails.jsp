<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<Html>
<Head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
</head>
<%
	String qcfNo=request.getParameter("qcfNo"); 
	String countType=request.getParameter("countType");
	String qryStr = "";
	if(!"V".equalsIgnoreCase(countType)&& !"Q".equalsIgnoreCase(countType))
		qryStr=" AND A.ERH_STATUS in ('"+countType+"')";
	if("Q".equalsIgnoreCase(countType))
		qryStr=" AND A.ERH_STATUS in ('P','Y','S')";		
	
	ezc.ezparam.ReturnObjFromRetrieve qcfRetObj = null;
	int qcfRetObjCnt = 0;
	ezc.ezparam.EzcParams qcfMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager qcfMiscParams = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	qcfTableRow.setQuery("select A.ERH_RFQ_NO,A.ERH_SOLD_TO, B.EU_FIRST_NAME, B.EU_LAST_NAME from EZC_RFQ_HEADER A LEFT JOIN EZC_USERS B ON TRIM(LEADING '0' FROM A.ERH_SOLD_TO)= B.EU_ID where A.ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'"+qryStr);
	qcfTable.appendRow(qcfTableRow);
	qcfMainParams.setLocalStore("Y");
	qcfMainParams.setObject(qcfTable);
	Session.prepareParams(qcfMainParams);
	try{
		qcfRetObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMiscParams.ezGetMiscTransactions(qcfMainParams);
	}
	catch(Exception e){}	

	if(qcfRetObj!=null)
	{
		qcfRetObjCnt = qcfRetObj.getRowCount();
	}	

%>

<body scroll=no>
<form name="myForm">
<input type="hidden" name="qcfNo" value="<%=qcfNo%>">  
<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
           List of RFQ's for Quotation <%=qcfNo%>
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">
        <div class="row">
	
	<div class="box box-primary">
	<div class="box-body">
<%
	if(qcfRetObjCnt>0)
	{
%>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%" style="width: 55%;margin-left: auto;margin-right:auto;">
		<thead>
			<tr>
				<th>RFQ NO.</th>
				<th>Vendor</th>
				<th>Vendor Name</th>
			</tr>
		</thead>
		<tbody>
<%
			String rfqNo="",vendName="",vendNo="";			
			for(int i=0; i<qcfRetObjCnt; i++ )
			{
				
				rfqNo = qcfRetObj.getFieldValueString(i, "ERH_RFQ_NO");
				vendName = checkNull(qcfRetObj.getFieldValueString(i, "EU_FIRST_NAME"))+" "+checkNull(qcfRetObj.getFieldValueString(i, "EU_LAST_NAME"));
				vendNo = qcfRetObj.getFieldValueString(i, "ERH_SOLD_TO");

%>

				<tr>
					<td><%=rfqNo%></td>
					<td><%=Long.parseLong(vendNo)%></td>
					<td><%=vendName%></td>
				</tr>
<%
			}

%>
		</tbody>

		</table>
<%
	}
%>

	
</div>
</div>
</div>
<table width="90%">
<tr><td class="blankcell"><hr></td>
<tr><td class="blankcell">
<div class="col-xs-12" align="center">
		<button type="button" class="btn btn-primary" style="left: 50%;" onclick="funAddVendor('<%=qcfNo%>')" ><i class="fa fa-plus"></i>&nbsp;Add Vendor</button>
		<button type="button" class="btn btn-primary" style="left: 50%;" onclick="funClose()"> Close</button>
</div>
</td>
<tr><td class="blankcell"><hr></td>
</tr></table>

</form>
  </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      

</Body>
</Html>
<script type="text/javascript" class="init">
   $(document).ready( function () {
       $('#example').dataTable( {
   	"dom": 'T<"clear">lfrtip',
   	"lengthMenu": [[5, 10, 20, -1], [5, 10, 20, 'All']],
   	"oTableTools": {
   	
   	    "sSwfPath": "../../../../EzCommon/Library/dataTables/swf/copy_csv_xls_pdf.swf",
   	    "aButtons": [
   	    
   				{
   					"sExtends":    "xls",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as Excel",
   					"sTitle": "report", // Excel file name
   					 "sToolTip": "Save as Excel"
   
   				},
   				{
   					"sExtends":    "pdf",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as PDF",
   					"sTitle": "report",
   					 "sToolTip": "Save as PDF"
   
   				}
   		
   
   			]
   	}
   	
       } );
   } );
   
function funAddVendor(qcfNo)
{
	window.parent.location.href="ezVendorViewList.jsp?qcfPrev="+qcfNo;
	//document.myForm.action="ezVendorViewList.jsp?qcfprev="+qcfNo;
	//document.myForm.submit();
}   
   
function funClose()
{
   window.parent.$('#woModal').modal('hide');	
}
	
   	
</script>
  


