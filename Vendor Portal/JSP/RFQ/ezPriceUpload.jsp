<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ page import="ezc.ezparam.*,ezc.ezutil.*" %>
<jsp:useBean id="esManager" class="ezc.client.EzSystemConfigManager" scope="session"/>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%@ page import="ezc.ezupload.MultipartRequest"%> 
<%@page import="java.io.*,java.util.*,java.text.ParseException,java.text.SimpleDateFormat"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%!
	public String checkNull(String str)
	{
		if("null".equals(str) || str == null) 
		{
			str = "";
		}
		return str.trim();
	}
				
	String display_header = "Budget Price > Upload";
%>
<%@ include file="../Misc/ezSubHeader.jsp"%>
<!-- Content Wrapper. Contains page content -->

<!-- Main content -->  
<section class="content">
<form name="myForm" method="post" ENCTYPE="multipart/form-data">

<input type="hidden" name="sNo" id="sNo" value="">
<input type="hidden" name="uom" id="uom" value="">
<input type="hidden" name="currency" id="currency" value="">
<input type="hidden" name="itemCode" id="itemCode" value="">
<input type="hidden" name="desc" id="desc" value="">
<input type="hidden" name="finYear" id="finYear" value="">
<input type="hidden" name="bdgtRate" id="bdgtRate" value="">
<input type="hidden" name="readTableData" id="readTableData" value="">

	<div class="row">
		<div class="col-md-12" align="center">
			<input type="hidden" name="fileName"> 
			
			<button type="button" class="btn btn-primary" title="click here to download Excel template" onclick="funExcel()"><span class="glyphicon glyphicon-save-file"></span> Download Excel Template</button>  &nbsp;

			<label for="file-upload" id="uploadExcel"  class="btn btn-primary">
				<span class="glyphicon glyphicon-open-file"></span> Upload Excel
			</label>
			<input id="file-upload" type="file"  name="file" style="display:none;" onchange="funShowFile()"/>
			<button type="button" id="uploadSelExcel" class="btn btn-primary" onclick="funUpload()" style="display:none;background-color:#E75400;border-color: #E75400;color:#fff;"><span class="glyphicon glyphicon-open-file"></span> Upload File </button>  &nbsp;
			<br><br><br>
			<table id = "hidden-table" style = "display:none" class="table table-bordered ">
			<Thead>
			<Tr>
				<th>S.NO</th>
				<th>ITEM CODE</th>
				<th>DESCRIPTION</th>
				<th>UOM</th>
				<th>CURRENCY</th>
				<th>FINANCIAL YEAR</th>
				<th>BUDGET PRICE</th>
			</Tr>
			</Thead>
			<tbody></tbody>
			</table>
			
			<button type="button" id="saveSelExcel" class="btn btn-primary" style="display:none" title="click here to save Excel" onclick="funSave()"><span class="glyphicon glyphicon-save-file"></span> Save Excel</button>  &nbsp;
		</div>
	</div>
	
	
	<input type="hidden" name="tableData" id="tableData" value="">
	
	
</section>
<!-- /.content -->
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<Div id="MenuSol"></Div>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<script src="xlsx.full.min.js"></Script>
			
<%
		String sNo = "";
		String uom = "";
		String currency = "";
		String itemCode = "";
		String desc = "";
		String finYear = "";
		String bdgtRate = "";
	
		ReturnObjFromRetrieve budgetExcel = new ReturnObjFromRetrieve(new String[] {"S.NO","Item Code","Description","UOM","Currency","Financial year","Budget Rate FY23"});
		
		budgetExcel.setFieldValue("S.NO",sNo);
		budgetExcel.setFieldValue("Item Code",itemCode);
		budgetExcel.setFieldValue("Description",desc);
		budgetExcel.setFieldValue("UOM",uom);
		budgetExcel.setFieldValue("Currency",currency);
		budgetExcel.setFieldValue("Financial year",finYear);
		budgetExcel.setFieldValue("Budget Rate FY23",bdgtRate);
		budgetExcel.addRow();
		
		session.putValue("BUDGET_EXCEL_TEMPLATE",budgetExcel);
%>

<script>
		function funUpload() {
			    //alert("1111");
			    
			 var table = document.getElementById('hidden-table');
			 
			   table.style.display = "block";
			   
			   document.getElementById('saveSelExcel').style.display = "block";
			    
			    var fileInput = document.getElementById("file-upload");
			    //alert("fileInput>>>>>>>>"+fileInput);
			    
				//alert("222222");
				var file = fileInput.files[0];

				if (file) {
				    var reader = new FileReader();

				    reader.onload = function (event) {
				//alert("File has been loaded!");

		
		                var data = event.target.result;
		
		                var workbook = XLSX.read(data, { type: 'binary', cellText: false, cellDates: true });
		
		
		                var sheetName = workbook.SheetNames[0];
		
		                var sheet = workbook.Sheets[sheetName];
		
		                var tableData = XLSX.utils.sheet_to_json(sheet, { header: 1 });
		
		                tableData.shift();
		
		
		                var tableBody = document.querySelector("#hidden-table tbody");
		
		                tableBody.innerHTML = '';
		
		
		                tableData.forEach(function (rowData) {
		
		                    var row = document.createElement("tr");
		
		                    rowData.forEach(function (cellValue) {
		
		                        var cell = document.createElement("td");
		
		                        cell.textContent = cellValue || "0";
					//alert("cell>>>>>>>>>>>>>"+cell);
		                        row.appendChild(cell);
		
		                    });
		
		                    tableBody.appendChild(row);
		
		                });
		
		            };
		
		
		            reader.readAsBinaryString(file);
		
		        } else {
		
		            alert("Please select a file to upload.");
		
		        }
		        //alert("3333333");	
		
		    // Trigger the file input click when the button is clicked
		
    
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
		location.href = "BUDGET_EXCEL_TEMPLATE.xlsx";
			
	}
	
	function funSave() {
	    var table = document.getElementById('hidden-table');
	    //alert("table>>>>"+table);
	    var rows = table.getElementsByTagName('tr');
	    //alert("rows>>>>"+rows.length);
	
	    // Determine the number of columns based on the first row
	    var numColumns = 0;
	   //var numColumns = rows[0].getElementsByTagName('td').length;
	   for (var i = 0; i < rows.length; i++) 
	   {
	   	 var cells = rows[i].getElementsByTagName('td');
	   	 numColumns = Math.max(numColumns,cells.length)
	   }
	    //alert("numColumns>>>>>"+numColumns);
	
	    var dataArray = [];
	
	 
	
	    for (var i = 0; i < rows.length; i++) {
	        var cells = rows[i].getElementsByTagName('td');
	
	        // Initialize an array to hold the data for this row
	        var rowData = [];
	
	        // Loop through the cells in this row and add their content to the rowData array
	        for (var j = 0; j < numColumns; j++) {
	            rowData.push(cells[j] ? cells[j].textContent : "");
	        }
	
	        // Add the rowData array to the dataArray
	        dataArray.push(rowData);      
	    }
	
	 
	
	    // Convert the dataArray to a JSON string
	    var jsonData = JSON.stringify(dataArray);
	    //alert("dataArray>>>>>>>>>"+dataArray);
	    //alert("jsonData>>>>>>>>>"+jsonData);

	  jsonData = document.myForm.readTableData.value;
		//alert("hiddenData>>>>>>>>"+ document.myForm.readTableData.value;
	    //Submit the form to the next page
	    document.myForm.action = "ezReadBdgtExcel.jsp";
	    document.myForm.submit();
}
	
</script>
</form>
