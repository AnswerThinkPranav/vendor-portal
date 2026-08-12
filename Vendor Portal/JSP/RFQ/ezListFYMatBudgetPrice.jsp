<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="java.util.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iezListFYMatBudgetPrice_Labels.jsp"%>

<%!
 	private String globalNullCheck(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull_Num(String str)
	 {
		if("null".equals(str) ||str==null || "".equals(str))
			str="0";
		
		return str;
 	}
%>
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
<%
	String finYear   	= globalNullCheck(request.getParameter("finYear"));
	String plant   		= globalNullCheck(request.getParameter("plant"));
	String month   		= globalNullCheck(request.getParameter("month"));
 
 	String qryStr = "";
 	
 	if(finYear==null || "".equals(finYear))
 		finYear = "FY-21-22";
 		
 	if(month==null || "".equals(month))
 		month = "10";	
 		
 	if(plant!=null && !"null".equals(plant) && !"".equals(plant))	
 		qryStr = " AND EMBP_PLANT='"+plant+"'";
 	else 
 		qryStr = " AND EMBP_PLANT IN ('"+gv_PlantForQry+"')";
 		
 
	ezc.ezparam.ReturnObjFromRetrieve listRetObj = null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr 	= new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable 		= new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow 	= new ezc.misctransactions.params.EzMiscTableRow();

	try{
		miscTableRow.setQuery("SELECT EMBP_FIN_YEAR,EMBP_PLANT,EMBP_MATERIAL,EMBP_DESCRIPTION,EMBP_BASIC_PRICE,EMBP_LANDED_PRICE,EMBP_FY_START_DATE,EMBP_FY_END_DATE,EMBP_EXT1,EMBP_EXT2 FROM EZC_MAT_BUDGET_PRICE WHERE EMBP_FIN_YEAR='"+finYear+"' AND EMBP_MONTH ='"+month+"' "+qryStr);
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);	

		listRetObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
	}catch(Exception e){}

	int listRetObjCnt = 0;
	if(listRetObj!=null)
		listRetObjCnt = listRetObj.getRowCount();
%>
<%@ include file="../Misc/ezGetPlants.jsp"%>  

<style>
.select2-container--default .select2-selection--multiple {
    height: 40px;
    width: 220px;
    border-radius: 0px;
} 
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Material Budget Price
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->
      <form name="myForm" method="post">   
      
      <input type='hidden' name='actionType' value=''>	
      
         <div class="box-body table-responsive no-padding">
            <div class="box-body"> 

  <table class="table table-responsive-xs" style="margin-bottom: 1%;">
  <Tr>
	  	<th><%=fin_Year_L%></th>	
		<Td>	
			 <Select name='finYear' id='finYear'>
				<option value='FY-21-22' selected>FY 21-22</option>
				<option value='FY-22-23'>FY 22-23</option>
				<option value='FY-23-24'>FY 23-24</option>
      			</Select>
		</Td>
	  	<th><%=month_L%></th>	
		<Td>	
			 <Select name='month' id='month'>
				<option value='01'>January</option>
				<option value='02'>February</option>
				<option value='03'>March</option>
				<option value='04'>April</option>
				<option value='05'>May</option>
				<option value='06'>June</option>
				<option value='07'>July</option>
				<option value='08'>August</option>
				<option value='09'>September</option>
				<option value='10' selected>October</option>
				<option value='11'>November</option>
				<option value='12'>December</option>
      			</Select>
		</Td>
		<th><%=plant_L%></th>	
		<Td>	
			 <Select name='plant' id='plant'>
			 	<option value=''>--select--</option>
				
<%
				for(int pl=0;pl<plantsRetObjCnt;pl++)
				{
					if(!gv_PlantVect.contains(plantsRetObj.getFieldValueString(pl,"EP_PLANT")))
						continue;
%>
					<option value='<%=plantsRetObj.getFieldValueString(pl,"EP_PLANT")%>'><%=plantsRetObj.getFieldValueString(pl,"EP_PLANT")+"-"+plantsRetObj.getFieldValueString(pl,"EP_CITY")%></option>
<%
				}
%>
			</Select>
		</Td>
		
		<td>
		  	<button type="button" class="btn btn-primary pull-right" onclick='funGetList()' style="margin-right: 5px;"><%=Go_L%><i class="fa fa-paper-plane"></i></button>
		</td>	
  </Tr>
  
  </Table>
	
	<Br>
          <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">	
	      <thead>
		 <tr>
		    <th><%=plant_L%></th>
		    <th><%=mat_L%></th> 
		    <th><%=desc_L%></th>
		    <th><%=basic_Price_L%></th>
		    <th><%=landed_Price_L%></th>
		     <th>&nbsp;</th>
 		</tr> 
                </thead>
                <tbody id="vendorsTable">
<%
		for(int b=0;b<listRetObj.getRowCount();b++)
		{
			String lv_material = listRetObj.getFieldValueString(b,"EMBP_MATERIAL");
			String lv_plant = listRetObj.getFieldValueString(b,"EMBP_PLANT");
			String lv_basePrice = listRetObj.getFieldValueString(b,"EMBP_BASIC_PRICE");
			String lv_landPrice = listRetObj.getFieldValueString(b,"EMBP_LANDED_PRICE");
%>
		 <tr id="myTableRow<%=b%>">
		    <td align=left><%=lv_plant+"-"+plantsHT.get(lv_plant)%></td>
		    <td align=center><%=lv_material%></td> 
		    <td><%=listRetObj.getFieldValueString(b,"EMBP_DESCRIPTION")%></td>
		    <td align=center><input type='text' class="form-control input-sm" name='basePrice<%=b%>' id='basePrice<%=b%>' value='<%=lv_basePrice%>' readonly></td>
		    <td align=center><input type='text' class="form-control input-sm" name='landPrice<%=b%>' id='landPrice<%=b%>' value='<%=lv_landPrice%>' readonly></td>
		    <td align=center>
			<a href="javascript:editRow('<%=b%>')" id='edit<%=b%>'><i class="fa fa-edit fa-lg"></i></a>
			<a href="javascript:saveRow('<%=b%>')" id='save<%=b%>' style='display:none'><i class="fa fa-save fa-lg"></i></a>
			<a href="javascript:delRow('<%=b%>')"><i class="fa fa-trash fa-lg"></i></a>
		</td>		

		<input type='hidden' name='hd_finYear<%=b%>' value='<%=finYear%>'>
		<input type='hidden' name='hd_plant<%=b%>' value='<%=lv_plant%>'>
		<input type='hidden' name='hd_material<%=b%>' value='<%=lv_material%>'>
		<input type='hidden' name='hd_month<%=b%>' value='<%=month%>'>
		    
 		</tr> 

<%
		}
%>
	                  </tbody>
	               </table>
	            </div>
	         </div>
 	 <Br> 	 
	<center>
	<!--<button type="button" id="" class="btn btn-primary" onclick="funBack()" >&nbsp;Back</button>-->
	<button type="button" id="" class="btn btn-primary" onclick="JavaScript:funAdd()" >&nbsp;<%=add_L%></button>
	<!--<button type="button" id="" class="btn btn-primary" onclick="JavaScript:funSaveOrDel('DEL')" >&nbsp;Delete</button></center>-->
<Br>
<div class="box-body" style="width: fit-content; display:none;" id="showAdd1">
	<table class="table table-bordered">
	<tr>
		<th align="center" colspan="3">Enter KEY and Description </th>
	</tr>
	<tr>
		<td>
			Key : <input type='text' size='5' name='payTerm' id='matType' maxlength="4" value=''>&nbsp;&nbsp;
		</td>
		<td>
			Desc : <input type='text' size='20' name='payTermDesc' id='matTypeDesc' maxlength="50" value=''>&nbsp;&nbsp;
		</td>
		<td>
			<button type="button" id="" class="btn btn-primary" onclick="JavaScript:funSaveOrDel('SAVE')" >&nbsp;Save</button></center>
		</td>
	</tr> 				
	</table>
	<br>	
</center>
</div>

	      </form>
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
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<!--<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>-->
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
	<Script src="../../Library/JavaScript/ezTrim.js"></Script>

<script>
   $(document).ready(function() {
   
       //window.history.forward(-1);
       $(".datePickObj").datepicker({ 
       	format: 'dd/mm/yyyy', 
       }); 
	    $('.timepicker').timepicker({
	    	 defaultTime: 'value',
	         showInputs: false,
	         showMeridian:false
    		});
    	$('.timepicker').timepicker({
	    defaultTime: 'value',
	    minuteStep: 1,
	    disableFocus: true,
	    template: 'dropdown',
	    showMeridian:false
});       
   });
  
function funAdd()
{
	//document.getElementById("showAdd1").style.display = "inline";
	document.myForm.action = "ezAddFYMatBudgetPrice.jsp"; 
  	document.myForm.submit();
}

function funSaveOrDel(actionType)
{
	document.myForm.actionType.value = actionType;
	document.myForm.action = "ezBIDSaveDeletePayTerm.jsp"; 
  	document.myForm.submit();
}

function funGetList()
{
	document.myForm.action = "ezListFYMatBudgetPrice.jsp";
	document.myForm.submit();  
}


function funBack()
{
	document.myForm.action = "ezBIDMasterDefaults.jsp";
	document.myForm.submit();  
}

function delRow(rowIndex)
{
	if(confirm("Are you sure you want to delete ?"))
	{
		var finYear 	= eval("document.myForm.hd_finYear"+rowIndex).value;
		var material 	= eval("document.myForm.hd_material"+rowIndex).value;
		var plant 	= eval("document.myForm.hd_plant"+rowIndex).value;
		var month 	= eval("document.myForm.hd_month"+rowIndex).value;
		
		//alert(finYear+":::::::::"+material+":::::::::"+plant);
		
		xmlhttp=GetXmlHttpObject();
		if (xmlhttp==null)
		{
			alert ("Your browser does not support Ajax HTTP");
			return;
		}
		xmlhttp.onreadystatechange=function() 
		{
			if (this.readyState == 4 && this.status == 200) {		
				//$('#myTableRow'+rowIndex).remove();
				
				document.myForm.action = "ezListFYMatBudgetPrice.jsp";
				document.myForm.submit();  			
			};
		}
		xmlhttp.open("GET","http://localhost/JUBL/EzCommerce/EzVendor/Vendor2/JSPs/RFQ/ezUpdateDelFYMatBudgetPrice.jsp?actFlag=DEL&finYear="+finYear+"&material="+material+"&plant="+plant+"&month="+month,true);
		xmlhttp.send(null);
	}
}	
function editRow(rowIndex)
{
	$("#basePrice"+rowIndex).prop('readonly', false);
	$("#landPrice"+rowIndex).prop('readonly', false);
	$("#edit"+rowIndex).hide();
	$("#save"+rowIndex).show();
}

function saveRow(rowIndex)
{
	var finYear 	= eval("document.myForm.hd_finYear"+rowIndex).value;
	var month 	= eval("document.myForm.hd_month"+rowIndex).value;
	var material 	= eval("document.myForm.hd_material"+rowIndex).value;
	var plant 	= eval("document.myForm.hd_plant"+rowIndex).value;
	var basePrice 	= eval("document.myForm.basePrice"+rowIndex).value;
	var landPrice 	= eval("document.myForm.landPrice"+rowIndex).value;
	
	xmlhttp=GetXmlHttpObject();
	if (xmlhttp==null)
	{
		alert ("Your browser does not support Ajax HTTP");
		return;
	}
	xmlhttp.onreadystatechange=function() 
	{
		if (this.readyState == 4 && this.status == 200) {
			$("#basePrice"+rowIndex).prop('readonly', true);
			$("#landPrice"+rowIndex).prop('readonly', true);
			$("#save"+rowIndex).hide();
			$("#edit"+rowIndex).show();
		};
	}
	xmlhttp.open("GET","http://localhost/JUBL/EzCommerce/EzVendor/Vendor2/JSPs/RFQ/ezUpdateDelFYMatBudgetPrice.jsp?actFlag=UPD&finYear="+finYear+"&material="+material+"&plant="+plant+"&basePrice="+basePrice+"&landPrice="+landPrice+"&month="+month,true);
	xmlhttp.send(null);

}

function GetXmlHttpObject()
{
	if (window.XMLHttpRequest)
		return new XMLHttpRequest();
	if (window.ActiveXObject)
		return new ActiveXObject("Microsoft.XMLHTTP");
	return null;
}

</script>

<script type="text/javascript" class="init">
   $(document).ready( function () {
   
   	$('.select2').select2({
		//maximumSelectionLength: 2
	});
   $("#finYear").val("<%=finYear%>");
   $("#plant").val("<%=plant%>");
   	$("#type").val("");
       $('#example').dataTable( {
   	"dom": 'T<"clear">lfrtip',
   	"order": [[ 0, "desc" ]],
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
</script>