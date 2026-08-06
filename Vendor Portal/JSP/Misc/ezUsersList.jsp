<%@page import="ezc.ezutil.*,java.util.*"%> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<%//@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>  
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>

<%
	String Status = request.getParameter("Status"); 
	String display_header = "",purGrpFromBack="",selected="";  
	
	if("R".equals(Status))
		display_header = "Selection Criteria for Released PRs"; 
	else
		display_header = "Selection Criteria for Unreleased PRs"; 
		
	String updateStr="I";	
	
%>
<style>
  .multiselect-container>li>a>label {
  padding: 4px 20px 3px 20px;
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      Vendor Credentials
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<Form name="myForm" method="POST">
<Input type="hidden" name="Status" value="<%=Status%>">  
<!-- Table row -->
<%

	
	ezc.ezparam.ReturnObjFromRetrieve vendGenDataObj=null;
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrVend = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableVend = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowVend = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.EzcParams mainParamsVend = new ezc.ezparam.EzcParams(false);	
	
	miscTableRowVend.setQuery("select EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_PASSWORD,EU_DELETION_FLAG,EU_CONTACT_NO from ezc_users where EU_DELETION_FLAG='N' ");
	ezc.ezcommon.EzLog4j.log("** QUERY>>"+miscTableRowVend.getQuery(),"I");
	miscTableVend.appendRow(miscTableRowVend);
	mainParamsVend.setLocalStore("Y");
	mainParamsVend.setObject(miscTableVend);
	Session.prepareParams(mainParamsVend);

	try
	{
		vendGenDataObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrVend.ezGetMiscTransactions(mainParamsVend);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Vendor List>>>>>"+e);
	}
	int vendCnt = 0;
	if(vendGenDataObj!=null)
		vendCnt=vendGenDataObj.getRowCount();
		
	/*vendGenDataObj.sort(new String[]{"EU_FIRST_NAME"},true);
	ezc.ezcommon.EzLog4j.log("** vendCnt in upload>>"+vendCnt,"I");
	ezc.ezcommon.EzLog4j.log("** vendGenDataObj >>"+vendGenDataObj,"I");*/

%>


   	    
		<table class="table table-bordered">


	<Tr>
		<Th align="left" colspan="3">Vendor &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</Th>
		<Td colspan="2">
			<select name="selVen" id="selVen" multiple class="form-control" style="width:150% !important"> 
						
<%
				for(int j=0;j<vendCnt;j++)
				{
					selected="";

					out.println("<option value='"+vendGenDataObj.getFieldValueString(j,"EU_ID").trim()+"'"+selected+">"+vendGenDataObj.getFieldValueString(j,"EU_ID").trim()+"->"+vendGenDataObj.getFieldValueString(j,"EU_FIRST_NAME")+"</option>");
				}
%>
			</select>
		</Td>
	</Tr> 

	</Table>


	<div class="row no-print">
		<div class="col-xs-12">
			<button type="button" class="btn btn-primary pull-right" onclick="sendCredentials()" style="margin-right: 5px;">Continue</button>	
			
		</div>
	</div>

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

      <!-- Main Footer -->
      <footer class="main-footer no-print">
        <!-- To the right -->
        
        <!-- Default to the left -->
        <strong>Copyright &copy; <%=((new java.util.Date()).getYear()+1900)%> <a href="http://www.thehackettgroup.com/">The Hackett Group</a>.</strong> All rights reserved.
      </footer>

     
      <div class="control-sidebar-bg"></div>
    </div><!-- ./wrapper -->
	<div class="modal fade" id="pleaseWaitDialog">
		 <div class="modal-dialog" style="padding-top: 15%;">
   		<div class="modal-content" style="background: transparent;">
		<div class="modal-body">
		    <img src="../img/squares.gif" style="margin-left:55%;"/>
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
         
<script>

 jQuery.extend( jQuery.fn.dataTableExt.oSort, {
	"date-uk-pre": function ( a ) {
		if (a == null || a == "") {
			return 0;
		}
		var ukDatea = a.split('/');
		return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
	},

	"date-uk-asc": function ( a, b ) {
		return ((a < b) ? -1 : ((a > b) ? 1 : 0));
	},

	"date-uk-desc": function ( a, b ) {
		return ((a < b) ? 1 : ((a > b) ? -1 : 0));
	}
} );

	$(function () {
		$('.select2').select2()
	 });
	function callFun(clickedOn)
	{
		if(clickedOn=='H')
		{
			top.display.location.href = "../Misc/ezSBUWelcomeWait.jsp";
		}	
		else if(clickedOn=='L')
		{
			top.location.href='../Misc/ezLogout.jsp'
		} 
	}
	// slight update to account for browsers not supporting e.which
	function disableF5(e) { if ((e.which || e.keyCode) == 116) e.preventDefault(); };
	
	/* OR jQuery >= 1.7 */
	$(document).on("keydown", disableF5);
	
	var url = window.location;
        // for sidebar menu entirely but not cover treeview
        $('ul.sidebar-menu a').filter(function() {
             return this.href == url;
        }).parent().addClass('active');

        // for treeview
        $('ul.treeview-menu a').filter(function() {
             return this.href == url;
        }).parentsUntil(".sidebar-menu > .treeview-menu").addClass('active');
	
	
	
	</script>	
  </body>
</html>
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>  
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY) %>";	 
</Script>
<!--<Script src="../../Library/JavaScript/Rfq/ezPrePRList1.js?ver=4"></Script>-->
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script src="../../Library/JavaScript/multiselect.js"></Script>
 <link rel="stylesheet" href="../../Library/Styles/multiselect.css" />
<SCRIPT src="../../Library/JavaScript/ezCheckFormFields.js"></SCRIPT>
<script>

	 $('#selVen').multiselect({
	     nonSelectedText: 'Select',
	     enableFiltering: true,
	     maxHeight: 250, 
	     enableCaseInsensitiveFiltering: true,
	     buttonWidth:'385px',
	     includeSelectAllOption:true
	 });
	

</script>
<script>
function funGetValue()
{
var opts = getSelectedOptions( this.elements['purGrp[]'] );
    
    alert( 'The number of options selected is: ' + opts.length ); //  number of selected options
    
    
}

window.closeModal = function(){
    $('#woModal').modal('hide');
};

$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			getPRs();
		}
	});

function compareDates(date1,date2)
{


	compDate1 = new Date(date1);
	compDate2 = new Date(date2);

	if(compDate1 > compDate2)
	{
		return true;
	}
	else
	{
		return false;
	}
}


function sendCredentials()
{

	var selVen = document.myForm.selVen.value;

	if(selVen =="")
	{
		alert("Please Enter atleast one Vendor");
		return false;
	}

	document.myForm.action = "ezSendLoginDetails.jsp"; 
	document.myForm.submit();
			
}

function closeIframe()
{
	   $('#woModal').modal('toggle');
}
<%//@include file="../Misc/ezFooter.jsp"%>
</script>
