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
      Add Material Budget Price
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
      		<th>FY Year</th>
      		<td>
      			<Select name='finYear'>
      				<option value='FY-21-22'>FY 21-22</option>
      				<option value='FY-22-23'>FY 22-23</option>
      				<option value='FY-23-24'>FY 23-24</option>
      			</Select>
      		</td>
      	</tr>
      	<tr>
      		<th>Month</th>		
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
      	</tr>
      	<tr>	
      		<th>Plant</th>
      		<td>
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
      		</td>
      	</tr>
      	<tr>	
      		<th>Material</th>
      		<td>
      			<input type='text'  class="form-control" maxlength='40' name='material' id='material' value=''>
      		</td>
      	</tr>	
      	<tr>
      		<th>Descriptiom</th>
      		<td><input type='text'  class="form-control" maxlength='40' name='description' id='description' value=''></td>
      	</tr>	
      	<tr>
      		<th>Basic Price</th>
      		<td colspan=3><input type='text' class="form-control" maxlength='15' name='basicPrice' id='basicPrice' value=''></td>
      	</tr>
      	<tr>
      		<th>Landed Price</th>
      		<td colspan=3><input type='text' class="form-control" maxlength='15' name='landedPrice' id='landedPrice' value=''></td>
      	</tr>      	
      	</table>

 	 <Br> 	 
	<center>
	<button type="button" id="" class="btn btn-primary" onclick="funBack()" >&nbsp;Back</button>
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
	if(document.myForm.plant.value=='')
	{
		alert("Please select plant");
		document.myForm.plant.focus();
		return;
	}
	if(document.myForm.material.value=='')
	{
		alert("Please enter material code");
		document.myForm.material.focus();
		return;
	}
	if(document.myForm.description.value=='')
	{
		alert("Please enter material description");
		document.myForm.description.focus();
		return;
	}
	if(document.myForm.basicPrice.value=='')
	{
		alert("Please enter Basic price");
		document.myForm.basicPrice.focus();
		return;
	}
	if(document.myForm.landedPrice.value=='')
	{
		alert("Please enter Landed price");
		document.myForm.landedPrice.focus();
		return;
	}
	document.myForm.action = "ezSaveFYMatBudgetPrice.jsp"; 
  	document.myForm.submit();
}
function funBack()
{
	document.myForm.action = "ezListFYMatBudgetPrice.jsp";
	document.myForm.submit();  
}
</script>

