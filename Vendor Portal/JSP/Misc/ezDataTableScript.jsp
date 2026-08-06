<link rel="stylesheet" type="text/css" href="../../Library/datatables/css/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../../Library/datatables/buttons/css/buttons.bootstrap.css"/>
<style>
.dataTables_filter
{
    display: inline;
    float: right;
}

.dataTables_length
{
   display: inline;
}
.dt-buttons
{
   margin-left:25%;
}
</style>
 
<script type="text/javascript" src="../../Library/datatables/jszip/jszip.js"></script>
<script type="text/javascript" src="../../Library/datatables/pdfmake/pdfmake.js"></script>
<script type="text/javascript" src="../../Library/datatables/pdfmake/vfs_fonts.js"></script>
<script type="text/javascript" src="../../Library/datatables/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="../../Library/datatables/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/dataTables.buttons.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/buttons.bootstrap.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/buttons.colVis.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/buttons.flash.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/buttons.html5.js"></script>
<script type="text/javascript" src="../../Library/datatables/buttons/js/buttons.print.js"></script>

<script>
     var table;
$(document).ready( function () { 
  table=$('#example').dataTable( {
        	stateSave: true,
         	dom: 'lBfrtip',
         	lengthMenu: [[5, 10, -1], [5, 10, 'All']],
          buttons: [  { extend: 'excel', text: '<i class="fa fa-file-excel-o" style="color:green"> </i> EXCEL',title:null,filename:'Download' },{ extend: 'pdf', text: '<i class="fa fa-file-pdf-o" style="color:red"></i> PDF',title:null }],
           //columnDefs: [  { width: '1%', targets: [0, 2, 3, 7, 9] }]
     	
       } );

  
  });
</script>
 