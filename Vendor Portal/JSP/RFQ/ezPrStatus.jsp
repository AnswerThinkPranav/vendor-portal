<%@page import="ezc.ezutil.*,java.util.*"%> 
<%@ page import="java.text.*" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<%
	String prNum = request.getParameter("prNum"); //"0120085623"
	int prDtlRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve prDtlRetObj  =	null;
	String logonSite = (String)session.getValue("SITE");
	
	if(prNum != null && !"null".equals(prNum) && !"".equals(prNum))
	{
		prNum="0000000000"+prNum;
		prNum=prNum.substring(prNum.length()-10,prNum.length());			
		
		//out.println(":::::prNum::::::"+prNum);	
	
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		

		miscTableRow.setQuery("select distinct ERP_QCF_NO,ERP_PR_NO,ERP_PR_ITEM,ERH_CREATED_BY,ERH_CREATED_ON from ezc_rfq_prs,ezc_rfq_header where erp_pr_no='"+prNum+"' and erp_qcf_no=ERH_COLLETIVE_RFQ_NO  group by ERP_QCF_NO,ERP_PR_NO,ERP_PR_ITEM,ERH_CREATED_BY order by ERP_PR_ITEM"); 
		out.println(":::::GETQUERY::::::"+miscTableRow.getQuery());
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try{
			prDtlRetObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

		}catch(Exception e){
			log("Exception in getting RFQ DETAILS>>>>>"+e);
		}
	}	
		
		if(prDtlRetObj != null)
			prDtlRetObjCnt = prDtlRetObj.getRowCount();

		//out.println(":::::prDtlRetObj::::::"+prDtlRetObj.toEzcString());
		
		//SAP STATUS CHECK
		
		ezc.ezparam.ReturnObjFromRetrieve retPRACCObj = null;
		int retPRACCObjCnt=0;

			String sapTab="EBAN";
			String [] outputFeilds =new String[]{"BANFN","BNFPO","WERKS","MATNR","TXZ01","FRGKZ","LOEKZ"};
			String [] queryValues =new String[1];
			queryValues[0]="BANFN EQ '"+prNum+"'";
	
			retPRACCObj = readRFCTable(logonSite,sapTab,outputFeilds,queryValues);
			if(retPRACCObj != null)
				retPRACCObjCnt=retPRACCObj.getRowCount();
				
			/*	
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObjCnt);
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObj.getFieldValueString(0,"BANFN"));
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObj.getFieldValueString(0,"BNFPO"));
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObj.getFieldValueString(0,"FRGKZ"));
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObj.getFieldValueString(0,"WERKS"));
			out.println(":::::retPRACCObjCnt::::::"+retPRACCObj.getFieldValueString(0,"LOEKZ"));
			*/
			
			
%>

<style>
.multiselect-container>li>a>label {
  padding: 4px 20px 3px 20px;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      Purchase Requisition Status
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<body>
<Form name="myForm" method="POST">
<!-- Table row -->
      <div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table class="table table-bordered">
		<Tr>
			<Th>Purchase Requisition</Th>
			<Td>
				<input type="number" class="form-control input-sm"   name="prNum"  value="<%=prNum%>" maxlength="10">
			</Td>
			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
			</Td>		
		</Tr>
	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->
<%
	if(prDtlRetObjCnt>0)
	{
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>		
		<h4>Portal Status</h4>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<tr>
			<th class="text-center">PR No.</th> 
			<th class="text-center">PR item</th> 
			<th class="text-center">QCF No.</th> 
			<th class="text-center">Created By</th> 
			<th class="text-center">Created On</th> 

	       </tr>		
<%		
		for(int i=0;i<prDtlRetObjCnt;i++)
		{
		
%>      
			<tr>
				<Td align="center">&nbsp;<%=prDtlRetObj.getFieldValueString(i,"ERP_PR_NO")%></Td>
				<Td align="center">&nbsp;<%=prDtlRetObj.getFieldValueString(i,"ERP_PR_ITEM")%></Td>
				<Td align="center">&nbsp;<%=prDtlRetObj.getFieldValueString(i,"ERP_QCF_NO")%></Td>
				<Td align="center">&nbsp;<%=prDtlRetObj.getFieldValueString(i,"ERH_CREATED_BY")%></Td>
				<Td align="center">&nbsp;<%=sdf.format((Date)prDtlRetObj.getFieldValue(i,"ERH_CREATED_ON"))%></Td>
			</tr>     	
<%
		}	
%>
	</Table>
<%
	}

	if(retPRACCObjCnt>0)
	{
		
%>		
		<h4>SAP Status</h4>	
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
				<tr>
					<th class="text-center">PR No.</th> 
					<th class="text-center">PR item</th> 
					<th class="text-center">Plant</th>
					<th class="text-center">Material</th>
					<th class="text-center">Description</th>
					<th class="text-center">Release <br>Indicator</th> 
					<th class="text-center">Deletion <br>Indicator</th> 

			        </tr>		
<%		
		for(int i=0;i<retPRACCObjCnt;i++)
		{
			String 	tempStatus  = "Unreleased";
			String  tempInd ="";
			String relStatus =  retPRACCObj.getFieldValueString(i,"FRGKZ");
			String delInd 	 =  retPRACCObj.getFieldValueString(i,"LOEKZ");
			if("R".equals(relStatus)|| "2".equals(relStatus))
				tempStatus  = "Released";
			if("X".equals(delInd))
				tempInd="Deleted";
%>      
				<tr>
					<Td align="center">&nbsp;<%=retPRACCObj.getFieldValueString(i,"BANFN")%></Td>
					<Td align="center">&nbsp;<%=retPRACCObj.getFieldValueString(i,"BNFPO")%></Td>
					<Td align="center">&nbsp;<%=retPRACCObj.getFieldValueString(i,"WERKS")%></Td>
					<Td align="center">&nbsp;<%=retPRACCObj.getFieldValueString(i,"MATNR")%></Td>
					<Td align="center">&nbsp;<%=retPRACCObj.getFieldValueString(i,"TXZ01")%></Td>
					<Td align="center">&nbsp;<%=tempStatus%></Td>
					<Td align="center">&nbsp;<%=tempInd%></Td>
				</tr>     	
     
<%
		}	
%>
	</Table>
<%
	}
%>
			<div class="row">
			<div class="col-xs-12" align="center">
				<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)" ><i class="fa fa-backward"></i>&nbsp;Back</button>
</Form>
</section> 
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog"> 
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>

      
    <!-- REQUIRED JS SCRIPTS -->
    <!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/iCheck/icheck.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/fuse/dist/fuse.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/fuzzycomplete.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js?2"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js?2"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<!--<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>-->
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<!--datatables download -->
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/dataTables.buttons.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.flash.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/jszip.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/vfs_fonts.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.html5.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.print.min.js"></script>	

	<!--end-->
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
      </body>
</html>
  
  <script src="../../../../../EzcLogin/Library/js/bootstrap3-typeahead.min.js"></script>  
  <link rel="stylesheet" href="../../../../../EzcLogin/Library/css/bootstrap_3.3.6.min.css" />
  <script src="../../../../../EzcLogin/Library/js/bootstrap_3.3.5.min.js"></script>
  <script src="../../../../../EzcLogin/Library/js/bootstrap-multiselect.js"></script>
  <link rel="stylesheet" href="../../../../../EzcLogin/Library/css/bootstrap-multiselect.css" />
 

<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY) %>";	 
</Script>
<!--<Script src="../../Library/JavaScript/Rfq/ezPrePRList1.js?ver=4"></Script>-->
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/ezCheckFormFields.js"></SCRIPT>
<script>
$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});
	function ezSubmit()
	{
		var prNum = document.myForm.prNum.value;
		alert(prNum);
		if(prNum=="")
		{
				alert("Please Enter PR Number");
				return false;	
		}		
		document.myForm.action = "ezPrStatus.jsp?prNum="+prNum;
		document.myForm.submit();
	}	




</script>
