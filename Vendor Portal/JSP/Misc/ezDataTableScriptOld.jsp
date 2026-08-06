<link rel="stylesheet" href="https://cdn.datatables.net/tabletools/2.0.0/css/TableTools.css" type="text/css" media="screen" />  	
	<script type="text/javascript" src="../Misc/datatable.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/tabletools/2.0.0/js/TableTools.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/tabletools/2.0.0/js/ZeroClipboard.js"></script>
	<!--
	<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.flash.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/jszip.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/vfs_fonts.js"></script>	
		<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/pdfmake.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.html5.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.print.min.js"></script>
	-->

<script>
$(document).ready( function () { 
  <link rel="stylesheet" href="https://cdn.datatables.net/tabletools/2.0.0/css/TableTools.css" type="text/css" media="screen" />  	
	<script type="text/javascript" src="../Misc/datatable.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/tabletools/2.0.0/js/TableTools.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/tabletools/2.0.0/js/ZeroClipboard.js"></script>
	<!--
	<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.flash.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/jszip.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/vfs_fonts.js"></script>	
		<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/pdfmake.min.js"></script>	
		<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.html5.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../Misc/datatables/buttons.print.min.js"></script>
	-->

<script>
$(document).ready( function () { 
  var table = $('#example').DataTable({
        
		"sDom": 'T<"clear">lfrtip', 
		"oTableTools": {
			    "sSwfPath": "https://cdn.datatables.net/tabletools/2.0.0/swf/copy_cvs_xls_pdf.swf",
			     "aButtons": [
					    {
							"sExtends": "xls",
							"sButtonText": "Excel",
							"mColumns": [ 0, 1, 2,3,5,6,7,8,9,10,11,12,13,14,15,16]
					    },
					    {
							"sExtends": "pdf",
							"sButtonText": "PDF",
							"mColumns": [ 0, 1, 2,3,5,6,7,8,9,10,11,12,13,14,15,16]
					    } ,
					    	
					 ]
					 
	}
	
	});
 var table1 = $('#example1').DataTable({
                                
		"sDom": 'T<"clear">lfrtip',            
		"oTableTools": {
			    "sSwfPath": "https://cdn.datatables.net/tabletools/2.0.0/swf/copy_cvs_xls_pdf.swf",
			     "aButtons": [
					    {
							"sExtends": "xls",
							"sButtonText": "Excel",
							"mColumns": [ 0, 1, 2,3,5,6,7,8,9,10,11,12,13,14,15,16]
					    },
					    {
							"sExtends": "pdf",
							"sButtonText": "PDF",
							"mColumns": [ 0, 1, 2,3,5,6,7,8,9,10,11,12,13,14,15,16]
					    } ,
					    	
					 ]
	}
	});	
	});
</script>
 	
	});
</script>
 