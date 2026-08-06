<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      INVOICE
      <!--<small>Optional description</small>-->
   </h1>
      <ol class="breadcrumb">
       <!-- <li class="active">Reports</li>-->
      </ol>
</section>	
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-sd-12 col-xs-12">
      <!-- general form elements -->

		<div class="box box-primary">
		         <div class="box-header with-border">
		            <!--<h3 class="box-title">Leaves</h3>-->
		            <form method="post" action="" name='myForm'>
		            </div><!-- /.box-header -->	

<Script> 
var ctrlKeyFlag = false
document.onkeyup = function()
{
    if(window.event && window.event.keyCode == 17)
                ctrlKeyFlag = false
}
document.onkeydown = function()
{
             if(window.event && window.event.keyCode == '17')
             {
                        ctrlKeyFlag = true
             }
             if(window.event && window.event.keyCode == 78 && ctrlKeyFlag)
             {
                        return false; // Must return false or the browser will execute old code
             }
}

<%

String toFile = null;
String userRole = (String)session.getValue("UserRole");
String selVendor = request.getParameter("selVendor");

String toPage = request.getParameter("toPage");
String pageLoadingMsg = "Please wait while the page loads...";

	if("CON_TO_BE_SIGNED_BY_BUY".equals(toPage))
	{
		toFile = "../Purorder/ezGetContractsList.jsp?FROM=MENU&conType=TBSB";
		pageLoadingMsg = "Please wait while the <B> Contracts To Be Signed By Buyer list</B> loads..";
	
	}

	if("CON_SIGNED_BY_BUY".equals(toPage))
	{
		toFile = "../Purorder/ezGetContractsList.jsp?FROM=MENU&conType=SB";
		pageLoadingMsg = "Please wait while the <B> Signed By Buyer list</B> loads..";
	
	}
	
	if("CON_TO_BE_SIGNED_BY_VEN".equals(toPage))
	{
		toFile = "../Purorder/ezGetContractsList.jsp?FROM=MENU&conType=TBSV";
		pageLoadingMsg = "Please wait while the <B> Contracts To Be Signed By Vendor list</B> loads..";
		
	}
	
	if("CON_SIGNED_BY_VEN".equals(toPage))
	{
		toFile = "../Purorder/ezGetContractsList.jsp?FROM=MENU&conType=SV";
		pageLoadingMsg = "Please wait while the <B> Signed By Vendor list</B> loads..";
		
	}

	if("TO_BE_ADD_SHIP_SA".equals(toPage))
	{
		toFile = "../Shipment/ezToBeAddShipmentSAs.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B> SA List</B> loads..";
	
	}
	
	if("TO_BE_ADD_SHIP_PO".equals(toPage))
	{
		toFile = "../Shipment/ezToBeAddShipmentPOs.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B> PO List</B> loads..";
	
	}
	if("TO_OPEN_INVOICES".equals(toPage))
	{
		toFile = "../Purorder/ezListOPENInvoices.jsp?FROM=MENU&InvStat=O&PurchaseOrder=null";
		pageLoadingMsg = "Please wait while the <B> Open Invoices List</B> loads..";

	}

	if("TO_CLOSED_INVOICES".equals(toPage))
	{
		toFile = "../Purorder/ezListInv.jsp?FROM=MENU&InvStat=C&PurchaseOrder=null";
		pageLoadingMsg = "Please wait while the <B> Closed Invoices  List</B> loads..";

	}
	if("TO_ALL_INVOICES".equals(toPage))
	{
		toFile = "../Purorder/ezListInv.jsp?FROM=MENU&InvStat=A&PurchaseOrder=null";
		pageLoadingMsg = "Please wait while the <B>  Invoices  List</B> loads..";

	}	

	
	if("PEND_FOR_BILL".equals(toPage))
	{
		toFile = "../Purorder/ezListPendingDcs.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B>Pending For Bill Booking</B> loads..";

	}     
	
	if("OPEN_SA_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezContract.jsp?FROM=MENU&OrderType=Open";
		pageLoadingMsg = "Please wait while the <B>Open SAs List</B> loads..";
	
	}     
	
	if("CLOSED_SA_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezContract.jsp?FROM=MENU&OrderType=Closed";
		pageLoadingMsg = "Please wait while the <B>Closed SAs List</B> loads..";
		
	}     
	
	if("ALL_SA_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezContract.jsp?FROM=MENU&OrderType=All";
		pageLoadingMsg = "Please wait while the <B>All SAs List</B> loads..";
		
	}     
	
	if("OPEN_PO_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezListPOs.jsp?FROM=MENU&OrderType=Open";
		pageLoadingMsg = "Please wait while the <B>Open POs List</B> loads..";

	}     

	if("CLOSED_PO_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezListClosedPOs.jsp?FROM=MENU&OrderType=Closed";
		pageLoadingMsg = "Please wait while the <B>Closed POs List</B> loads..";

	}     

	if("ALL_PO_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezListPOs.jsp?FROM=MENU&OrderType=All";
		pageLoadingMsg = "Please wait while the <B>All POs List</B> loads..";
			
	} 
	if("SER_PO_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezListPOs.jsp?FROM=MENU&OrderType=Service";
		pageLoadingMsg = "Please wait while the <B>All POs List</B> loads..";
				
	} 
	if("RET_PO_LIST".equals(toPage))
	{
		toFile = "../Purorder/ezListPOs.jsp?FROM=MENU&OrderType=Return";
		pageLoadingMsg = "Please wait while the <B>All POs List</B> loads..";
					
	} 
	if("PO_EXCEL".equals(toPage))
	{
		toFile = "../Purorder/ezPOExcelUpload.jsp?FROM=MENU&OrderType=Return";
		pageLoadingMsg = "Please wait while the page loads..";
						
	} 	
	if("VEND_BALANCE".equals(toPage))
	{
		toFile = "../Purorder/ezVendbal.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B>Outstanding Balance </B> loads..";
			
	}   
	
	if("ACC_STATEMENT".equals(toPage))
	{
		toFile = "../Misc/ezAstatement.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B>A/C Statement </B> loads..";
			
	}  
	
	if("PO_ACKNOWLEDGED".equals(toPage))
	{
		toFile = "../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Acknowledged";
		pageLoadingMsg = "Please wait while the <B>Acknowledged POs </B> loads..";

	}    

	if("PO_TOBE_ACK".equals(toPage))
	{
		toFile = "../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=NotAcknowledged&selVendor="+selVendor;
		pageLoadingMsg = "Please wait while the <B>To be Acknowledged POs </B> loads..";

	}    

	if("PO_REJECTED".equals(toPage))
	{
		toFile = "../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Rejected";
		pageLoadingMsg = "Please wait while the <B>Rejected POs </B> loads..";
				
	} 
	
	if("SA_ACKNOWLEDGED".equals(toPage))
	{
		toFile = "../Purorder/ezListScheduleAgreements.jsp?FROM=MENU&docStatus=A";
		pageLoadingMsg = "Please wait while the <B>Acknowledged SAs </B> loads..";

	}    

	if("SA_TOBE_ACK".equals(toPage))
	{
		toFile = "../PurOrder/ezListScheduleAgreements.jsp?FROM=MENU&docStatus=N";
		pageLoadingMsg = "Please wait while the <B>To be Acknowledged SAs </B> loads..";
	} 
	
	if("SA_LINES_TOBE_ACK".equals(toPage))
	{
		toFile = "../Purorder/ezToBeAcknowledgedSALines.jsp?FROM=MENU&docStatus=X";
		pageLoadingMsg = "Please wait while the <B>To be Acknowledged SA Lines </B> loads..";
	}    

	if("SA_LINES_ACKNOWLEDGED".equals(toPage))
	{
		toFile = "../Purorder/ezAcknowledgedSALines.jsp?FROM=MENU&docStatus=A";
		pageLoadingMsg = "Please wait while the <B>Acknowledged SA Lines </B> loads..";
	
	} 
	
	if("ASN_LINE_ITEMS".equals(toPage))
	{
		String ponum = request.getParameter("ponum");
		String orderBase = request.getParameter("orderBase"); 
		String showData = request.getParameter("showData");
		String vendor = request.getParameter("vendor");
		String poPlant = request.getParameter("poPlant");
		String poPurGrp = request.getParameter("poPurGrp");
		String purOrdDocType = request.getParameter("purOrdDocType");

		toFile = "../Shipment/ezUpdateIBDGRStatus.jsp?ponum="+ponum+"&orderBase="+orderBase+"&showData="+showData+"&vendor="+vendor+"&poPlant="+poPlant+"&poPurGrp="+poPurGrp+"&purOrdDocType="+purOrdDocType;
		pageLoadingMsg = "Please wait while the <B> Lines </B> loads..";
		
	} 
	
	if("PEND_ASN_LIST".equals(toPage))
	{
		toFile = "../Shipment/ezAsnsPendingForGR.jsp?FROM=MENU";
		pageLoadingMsg = "Please wait while the <B>Pending ASN's List </B> loads..";
		
	}   
	if("SHORTAGE_DOC".equals(toPage))
	{
		toFile = "../Misc/ezListShortagMatDocs.jsp";
		pageLoadingMsg = "Please wait while the <B>Shortage Documents List </B> loads..";
	}
	if("REJECTED_DOC".equals(toPage))
	{
		toFile = "../Misc/ezListRejectMatDocs.jsp";
		pageLoadingMsg = "Please wait while the <B>Rejected Documents List </B> loads..";
	}
	if("ACCEPTED_DOC".equals(toPage))
	{
		toFile = "../Misc/ezListAcceptedMatDocs.jsp";
		pageLoadingMsg = "Please wait while the <B>Accepted Documents List </B> loads..";
	}
	if("VEN_REG_LINK".equals(toPage))
	{
		toFile = "../VendorReg/ezSendVendorRegLink.jsp";
		pageLoadingMsg = "Please wait while the <B>Page </B> loads..";
	}
	if("VEN_STATUS_REPORT".equals(toPage))
	{
		toFile = "../VendorReg/ezVendorStatusReport.jsp";
		pageLoadingMsg = "Please wait while the <B>Vendor Status Report </B> loads..";
	}
	if("ASN_LIST_PO_INT".equals(toPage))
	{
		toFile = "../Shipment/ezListViewEsugamASNs.jsp?type=PO";
		pageLoadingMsg = "Please wait while the <B>ASN list </B> loads..";
	}
	if("ASN_LIST_CON_INT".equals(toPage))
	{
		toFile = "../Shipment/ezListViewEsugamASNs.jsp?type=CON";
		pageLoadingMsg = "Please wait while the <B>ASN list </B> loads..";
	}
	if("ASN_LIST_PO_VEN".equals(toPage))
	{
		toFile = "../Shipment/ezListViewEsugamASNs.jsp?type=PO";
		pageLoadingMsg = "Please wait while the <B>ASN list </B> loads..";
	}
	if("ASN_LIST_CON_VEN".equals(toPage))
	{
		toFile = "../Shipment/ezListViewEsugamASNs.jsp?type=CON";
		pageLoadingMsg = "Please wait while the <B>ASN list </B> loads..";
	}
	if("GRTOBE_INVOICED".equals(toPage))
	{
		toFile = "../Purorder/ezListPendingDcs.jsp";
		pageLoadingMsg = "Please wait while the <B>GRs To Be Invoiced List </B> loads..";
	}
    
%>
function fun1()
{
         //document.body.style.cursor='wait'
         document.location.replace("<%=toFile%>");
}
</script>

<%
        // Clearing the Cache
response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-cache");
%>
<body bgcolor="##C7D7DE" onLoad="fun1()" onContextMenu="return  false">
<form>
<% 
	String display_header = "";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<center>
<br><br><br><br><br><br><br>
	<img src='../../Images/gcloading.gif' style='display:block;' border='0'/>
	<%=pageLoadingMsg%><br /> <br /> </center>
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
						"sExtends":    "xls",
						 "sPdfOrientation": "landscape",
						"sButtonText": "Download as Excel",
						"sTitle": "Full Report", // Excel file name
						 "sToolTip": "Save as Excel"
	
					},
					{
						"sExtends":    "pdf",
						 "sPdfOrientation": "landscape",
						"sButtonText": "Download as PDF",
						"sTitle": "Full Report",
						 "sToolTip": "Save as PDF"
	
					}
			
	
				]
		}
		
	    } );
	} );
	
</script>

