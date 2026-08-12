<%@ include file="../Misc/ezVendHeader.jsp"%>  
<%@ page import="ezc.ezparam.*,ezc.ezutil.*" %>
<%@ page import="ezc.ezupload.MultipartRequest"%> 
<%@page import="java.io.*,java.util.*,java.text.ParseException,java.text.SimpleDateFormat"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      Add Delivery Schedules
   </h1>
</section>
<!-- Main content -->  
<section class="content">
<form name="myForm" method="post" ENCTYPE="multipart/form-data">
	<div class="row">
		<div class="col-xs-12" align="center">
			<input type="hidden" name="fileName">
				<button type="button" class="btn btn-primary" title="click here to download Excel template" onclick="funExcel()"><span class="glyphicon glyphicon-save-file"></span> Download Excel Template</button>  &nbsp;
				<label for="file-upload" id="uploadExcel"  class="btn btn-primary">
					<span class="glyphicon glyphicon-open-file"></span> Upload Excel
				</label>
				<input id="file-upload" type="file"  name="file" style="display:none;" onchange="funShowFile()"/>
				<button type="button" id="uploadSelExcel" class="btn btn-primary" onclick="funUpload()" style="display:none;background-color:#E75400;border-color: #E75400;color:#fff;"><span class="glyphicon glyphicon-open-file"></span> Upload File </button>  &nbsp;
		</div>
	</div>
	

</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezVendFooter.jsp"%>

<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>

<script>

	function funUpload()
	{

		var fileName = document.myForm.fileName.value;
		
		document.myForm.action= "../Purorder/ezReadDeliverySchedules.jsp";
		document.myForm.submit();
		
	}
	function funShowFile()
	{
		var file = document.myForm.file;
		var dotPos 	= file.value.lastIndexOf('.');
		var fileExt	= file.value.substring(dotPos+1,file.length);

		if(fileExt=='xlsx' || fileExt=='xls')
		{
			
			document.getElementById("uploadExcel").style.display="none";
			document.getElementById("uploadSelExcel").style.display="inline-block";
			document.myForm.fileName.value=file.files[0].name;
			document.getElementById("uploadSelExcel").innerHTML = '<span class=\'glyphicon glyphicon-open-file\'></span>  Upload  '+file.files[0].name;
			
		}
		else
		{
			alert("Upload only Excel file!");
			document.getElementById("uploadExcel").style.display="inline-block"
			document.getElementById("uploadSelExcel").style.display="none"
		}
	}
	
	
	function funExcel()
	{
		document.myForm.action = "../Purorder/ezDownloadDelSchedExcel.jsp";  
		document.myForm.submit();
			
	}

	
</script>
