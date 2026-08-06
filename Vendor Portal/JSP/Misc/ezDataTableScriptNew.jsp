<script>
	   $(document).ready(function() {
	       $("#fromDate").datepicker({ 
	       	format: 'dd/mm/yyyy', 
	       }); 
	       $("#toDate").datepicker({ 
	              	format: 'dd/mm/yyyy', 
	       }); 
	   });
	</script> 
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>
	<script type="text/javascript" class="init">
	
	
	
	$(document).ready( function () {
	    $('#example').dataTable( {
		"dom": 'T<"clear">lfrtip',
		"oTableTools": {
		
		    "sSwfPath": "../../../../EzCommon/Library/dataTables/swf/copy_csv_xls_pdf.swf",
		    "aButtons": [
		    		    			
					{
						"sButtonClass": "DTTT_button_xls",
						"sExtends":    "xls",
						// "sPdfOrientation": "landscape",
						"sButtonText": "Download as Excel",
						"sTitle": "Full Report", // Excel file name
						 "sToolTip": "Download as Excel",
						 "sFileName": "*.xls",
	
					},
					
					{
						"sExtends":    "pdf",
						 "sPdfOrientation": "landscape",
						"sButtonText": "Download as PDF",
						"sTitle": "Full Report",
						 "sToolTip": "Download as PDF",
						 "sPdfMessage": "Coromandel International Limited", 	 				  
						
						
	
					},
					
			
	
				]
		}
		
	    } );
	} );
	
</script>  