<%@ include file="../Misc/ezVendHeader.jsp"%>     
<%@page import="ezc.ezutil.*,java.util.*"%>  
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>  
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

	int vendCnt=0;
	/*ReturnObjFromRetrieve vendGenDataObj=null;
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrVend = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableVend = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowVend = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.EzcParams mainParamsVend = new ezc.ezparam.EzcParams(false);*/
	
	ReturnObjFromRetrieve vendGenDataObj=null;
	miscMgrVend = new ezc.misctransactions.client.EzMiscTransactionsManager();
	miscTableVend = new ezc.misctransactions.params.EzMiscTable();
	miscTableRowVend = new ezc.misctransactions.params.EzMiscTableRow();
	mainParamsVend = new ezc.ezparam.EzcParams(false);	
	
	miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE')");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('3505041','3502853','3501787','3501802','3501840','3502038','3501925','3505258','3502100','3503955','3503773','3501982','3502122','2100006','3502143','2100654','3502334','1600099','3502033','2100303','3501820','3502115','3501857','3504673','3501749','3502071','3503749','3503035','3502525','3505493','3503102','3503088','3502068','3502067','3501898','3502527','3502744','3501908','3505898','3501814','3502486','3503013','3504248','3501880','3500043','3505052','3501915','3501816','3500622','3500509'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('2100122','1600629','3502025','3502407','1700042','3505841','3501849','3505843','1700072','3501316','3501912','2100933','3503937','3505361','3505794','3505765','2100124','3504020','3503470','2100736','3500207','3502310','3505754','3501878','1600151','3504455','3502594','3502091','3505753','2100216','3501885','3500866','1800215','3500780','3501962','3502996','3501384','3503386','3500808','3505733','3500261','3503498','3503929','2100683','3502007','3501955','3502049','3502198','3503566','3504783'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('3501613','1700073','3502508','2100196','3502320','3502239','3501919','3502364','3505609','3502040','3501817','3501874','3503512','3501941','3503515','2100064','3502315','3501869','3501825','3502175','3502362','3501808','3501823','3503701','3502581','3502195','3505154','3502518','3502344','3502167','3501881','3502135','2100121','1700103','3501886','3502207','2100901','1800206','3501868','3502280','1700109','2100650','1700031','3502812','1700015','3504108','3501569','3501851','3502079','3501126'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('3505045','3503580','3502943','3501775','1700651','3502206','3502172','2100050','1700171','1700083','3502339','1700425','3200207','2100035','3502531','3502304','2101357','2101062','1700166','3502541','3502699','3500075','3500298','1700025','2101052','3502372','3501853','2101464','3505227','3505276','3502112','3500230','3501854','3500084','3503593','3503743','1700034','3502292','3500097','3502542','3502999','3502119','2100693','3501893','3500451','3501827','3502003','3502403','2100025','3502573','2100767','3504382','3504870','3503537','3501324','3502539','2101008','3504806','3504815','1700228','3504649','3504549','3501944','3501864','1700080','3503489','3502941','3500547','3501786','3501806','3501977','3502109','2100690'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('3503221','3500464','3505046','3505005','3503234','3505744','3505734','3505740','3505786','3505848','3505834','3505860','3505874','2101602','3505876','3505931','2101606','3505983','3505981','3505939','1600715','3501022','3503294','3503435','1800199','1800209','3503296','3501951','3500549','1800203','3503321','3500915','3502136','3500351','2100001','3501880','1800235','3500050','3500345','1600031','3500204','3503351','1600985','3501782','1800236','3501825','3503500','3501882','3503446','3501802','3501960','3500332','3501525','3501915','1800165','3502007','3503449','3503721','3503329','3503695','3503324','3503477','3503488','1600139','3502011','3503811','3502372','3503830','1600952','2101067','1600973','3502044','1800233','3501171','3500096','3504021','3501120','2100193','1700042','3502500','3100244','3500261','3504260','1800192','1600142','3502027','1600831','3502146','3502123','3504150','3501178','3503315','3504618','3504665','3504671','1800205','3501276','3504747','3501718','3504791','3504871','3500603','3504918','3500192','3504626','3504986','1800176','3503323','3501631','3500039','3500735','3505066','2200353','3501306','3500665','3505185','3502364','3504253','3504535','3505268','3502518','3501397','3505230','3505307','3505325','3504552','3504869','1700006','3500381','3505361','3505419','3505441','2100465','3505451','3500535','3500114','3502054','3505488','1800175','3505511','3505470','3503365','3503856','3503858','3503153','3505524','3502116','3505506','3505564','3501953','3505574','3505588','3500086','3505578','3500698','3500809','3505581','3505626','3505638','3503714','3505649','3505652','3505653','3505611','3505648','3505647','3503903','3505663','3505701','3505680','3505703','3501144','3505757','3500372','3504040','3500134','3500203','3100035','3502320','3500944','3505816','3505031','3505804','3505817','3505661','3500316','3505831','3505690','3500342','3505863','3505727','2101406','3501801','2101599','3505875','3500834','3502870','3505915','3505908','3505919','3502834','1601202','3505733','3505258','3505934','3504117','3505880','3505953','3500465','3503285','3505982','3505971','3505972','2101613','3505912','3505903','3505820','3505726'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('1800443','1700784','1700781','3506131','2101631','3506111','2101628','3506109','3506108','1700773','1700774','1700775','1700770','3506092','1700777','2101623','3506076','3506074','3506070','1700787','1700789','3506171','3506153','2101632'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('1700797','3505909','3505942','3505956','3505959','3505960','3505962','3505964','3505966','3505977','3505979','3505980','3505987','3505989','3505994','3505997','3506000','3506001','3506002','3506020','3506027','3506029','3506031','3506033','3506048','3506049','3506050','3506056','3506057','3506060','3506065','3506066','3506071','3506072','3506077','3506091','3506096','3506098','3506105','3506106','3506107','3506114','3506118','3506121','3506125','3506126','3506134','3506147','3506148','3506151','3506152','3506155','3506160','3506166','3506175','3506188','3506189','3506198','3506199','3506201','3506203','3506208','3506211','3506212','3506215','3506217','3506218','3506220','3506222','3506223','3506224','3506225','3506226','3506230','3506231','3506238','3506242','3506246','3506247','3506249','3506251','3506259','3506260','3506265','3506267','3506270','3506278','3506279','3506280','3506283','3506292','3506296','3506302','3506303','3506318','3506321','3506323','3506324','3506325','3506326','3506328','3506331','3506343','3506344'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE' AND EUA_USER_ID IN ('3506369','3506383','3506385','3506391','1700886','3506401','3506429','3506443','3506470','1700863','3506560','3506565','3506577','3506659','2201097','3506658','3506696','3506701','3506704','3506744','3506752','3506786','3506785','3506793','3506802','3506804','3506806','3506808','3506805','3506810','3506809','3506815','3506821','3506828','3506855'))");
	

	
	
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
	if(vendGenDataObj!=null)
		vendCnt=vendGenDataObj.getRowCount();
		
	vendGenDataObj.sort(new String[]{"EU_FIRST_NAME"},true);
	ezc.ezcommon.EzLog4j.log("** vendCnt in upload>>"+vendCnt,"I");


	int plantLen   = plantObj.getRowCount();


%>


    <div class="row" >
	<div class="overflow-hidden">	    
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
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	
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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css" />
 

<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY) %>";	 
</Script>
<!--<Script src="../../Library/JavaScript/Rfq/ezPrePRList1.js?ver=4"></Script>-->
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/ezCheckFormFields.js"></SCRIPT>
<script>
$(document).ready(function(){
	 $('#selVen').multiselect({
	     nonSelectedText: 'Select',
	     enableFiltering: true,
	     maxHeight: 250, 
	     enableCaseInsensitiveFiltering: true,
	     buttonWidth:'385px',
	     includeSelectAllOption:true
	 });
	 $('#purGrp').multiselect({
	  nonSelectedText: 'Select',
	  enableFiltering: true,
	  maxHeight: 250, 
	  enableCaseInsensitiveFiltering: true,
	  buttonWidth:'300px',
	  includeSelectAllOption:true
	 });
	 $('#docType').multiselect({
	   nonSelectedText: 'Select',
	   enableFiltering: true,
	   maxHeight: 250, 
	   enableCaseInsensitiveFiltering: true,
	   buttonWidth:'300px',
	   includeSelectAllOption:true
	 });
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

function checkEmpty(chkVal)
{
	if(chkVal=="" || chkVal==null)
		return "NA";
	else
		return chkVal;

}

function KeySubmit()
{
	if (event.keyCode==13)
		searchForMaterial()
}

function searchForMaterial()
{
	if(document.myForm.SearchMat[0].checked)
		searchMatByNumber();

	if(document.myForm.SearchMat[1].checked)
		searchMatByDesc();
}

function searchMatByNumber()
{
	var matNo	= 	document.myForm.matDescScrh.value;

	if(matNo=="" || matNo=="Enter Search String Here.")
	{
		alert("Please enter Material Number");
		document.myForm.matDescScrh.focus();
		return;
	}

	var url="ezMtrlSearch.jsp?matCode="+matNo;
	//newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});

}

function searchMatByDesc()
{
	var matDesc = document.myForm.matDescScrh.value;


	if(matDesc=="" || matDesc=="Enter Search String Here.")
	{
		alert("Please enter Material Description.");
		document.myForm.matDescScrh.focus();
		return;
	}

	var url="ezSearchMaterial.jsp?matDesc="+matDesc;
	//newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true}); 
}


function sendCredentials()
{

	var selVen = document.myForm.selVen.value;

	if(selVen =="")
	{
			alert("Please Enter atleast one Vendor");
			return false;
	}

	document.myForm.action = "ezSendUserLogin.jsp"; 
	document.myForm.submit();
			
}

function setEmpty()
{
	if(myForm.matDescScrh.value=="Enter Search String Here.")
		myForm.matDescScrh.value="";
}

function closeIframe()
{
	   $('#woModal').modal('toggle');
}	
</script>
