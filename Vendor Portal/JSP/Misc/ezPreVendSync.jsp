<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="java.util.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>  
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
      Vendor Synchronization
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
      
      	<table class="table table-bordered dt-responsive nowrap">
      	
      	<tr>	
      		<th>Vendor Code</th>
      		<td>
      			<input type='text'  class="form-control" maxlength='10' size='10' name='vendCode' id='vendCode' value=''>
      		</td>
      	</tr>	
      	<tr>
      		<th>Name</th>
      		<td><input type='text'  class="form-control" maxlength='50' name='vendName' id='vendName' value=''></td>
      	</tr>	
      	<tr>
      		<th>E-Mail</th>
      		<td colspan=3><input type='text' class="form-control" maxlength='50' name='vendEmail' id='vendEmail' value=''></td>
      	</tr>
      	<tr>
      		<th>Comp Code</th>
      		<td>
   		<Select name='cmpncode' id='cmpncode'>
			<option value=''>--Company Code--</option>
			<option value='5000' selected>5000</option>
		</Select> 
		<input type='hidden' name='sysKey' value='999800'>
      		</td>
      	</tr>      	
      	</table>

 	 <Br> 	 
	<center>
	<!--<button type="button" id="" class="btn btn-primary" onclick="funBack()" >&nbsp;Back</button>-->
	<button type="button" id="" class="btn btn-primary" onclick="JavaScript:funSave()" >&nbsp;Save</button>
	<!--<button type="button" id="" class="btn btn-primary" onclick="JavaScript:funSave('DEL')" >&nbsp;Delete</button></center>-->

	      </form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezFooter.jsp"%>

<script>
function funShow()
{
	document.getElementById("showAdd1").style.display = "inline";
}

function funSave()
{
	document.myForm.action = "ezVendSync.jsp"; 
  	document.myForm.submit();
}
function funBack()
{
	//document.myForm.action = "ezListFYMatBudgetPrice.jsp";
	//document.myForm.submit();  
}
</script>

