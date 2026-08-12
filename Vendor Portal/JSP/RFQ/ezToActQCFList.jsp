<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>   
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@include file="../../../Includes/JSPs/Rfq/iToActQCFList.jsp"%>             
<%//@ include file="../Misc/ezCommonMethods.jsp"%>   
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

   ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
   java.util.Date today = new java.util.Date();
   //out.println("today>>"+today); 
   
  
	String display_header ="";
	if("2".equals(userType))
	{
		if(type.equals("Act"))   
		{
			display_header	= "List of Auctions To Approve"; 
		}
		else if(type.equals("Apr")) 
		{
			display_header	= "List of Auctions Approved";
		}
		else if(type.equals("Rej"))
		{
			display_header	= "List of Auctions Rejected";
		}
		else if(type.equals("ALL"))
		{
			display_header	= "List of Auctions";
		}
	}


%>
<style>
div.tooltip
{
    word-wrap:  break-word;
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      <%=display_header%>
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
         <div class="box-body table-responsive no-padding">
            <div class="box-body"> 

		<table class="table table-striped" style="margin-bottom: 1%;"> 
		<Tr>
			<Th>From Date</Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th>To Date</Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("toDate")%> 
					  </div>
				  </div>
			</Td>
		<Th>Status</Th>
		<Td>	
				  <div class="input-group">
					 <select class="form-control input-sm" name="type" id="type">

						<option value="ALL" selected>All</option>
						<option value="Act">To Approve</option>
						<option value="Req">Requote</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option>

						
					 </select>
				  </div>
			</Td>

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th>Auction Id</th> 
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Initiated On</th>
                        <th>Last Modified On</th>
                        <th>Buyer</th>
                        <th>Status</th>
                        <th>Pending With</th>
			
                     </tr>
                  </thead>
                  <tbody>
<%
			SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy hh:mm aaa");
			for(int i=0;i<Count;i++)   
                        {
%>	 	
                     <tr>
                     	<td align="center"><a href='ezAuctionReport.jsp?auctionId=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%>&auctionName=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_NAME")%>'><%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%></a></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EAH_START_DATE"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EAH_END_DATE"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_CREATED_ON"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"))%></td>
                     	<td><%=hdrXML.getFieldValueString(i,"EWDHH_CREATED_BY")%></td>
                     	<td><%=hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS")%></td>
                     	<td><%=hdrXML.getFieldValueString(i,"NEXT_PART")%></td>
		     </tr>	
<%
                        }
%>
                  </tbody>
               </table>                              
            </div>
         </div>
         <!-- Your Page Content Here -->   
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

<Div id="MenuSol"></Div>
</body>
</html>
<script type="text/javascript" class="init"> 
   $(document).ready( function () {
       $("#type").val("<%=type%>");
       $('[data-toggle=tooltip]').tooltip();
       
      
   } );

   
   	function ezSubmit()
   	{
		document.myForm.action = "ezAuctionList.jsp";
		document.myForm.submit();
	}
	function goToPlantAddr(plant)
	{
		//window.open("ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,width=350,height=330,left=250,top=200");
		$('iframe').attr("src","../Purorder/ezPlantAddress.jsp?plant="+plant);
		$('#woModal').modal({show:true});
	}
   	function ezReminder1(rfqNo,type,rfqType,endDt,ordDt,stat)
   	{
		document.myForm.action = "ezRemindRFQ.jsp?PurchaseOrder="+rfqNo+"&type="+type+"&rfqType="+rfqType+"&EndDate="+endDt+"&OrderDate="+ordDt+"&expStat="+stat;
		document.myForm.submit();
	}	
	$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});
	function updateRFQ(rfq,index) 
	{
		var closeDate = document.getElementById("RFQCloseDate"+index).value;
		//alert(closeDate);
		
		b=closeDate.split("/");
		var extDate = new Date(b[2],(b[1]-1),b[0]);
		//alert(extDate);
		
		var toDate  = new Date();
		//alert("toDate>>"+toDate);
		
		/*if(extDate <= toDate)	
		{
			alert("Extended date must greater than Today's date");
			return;
		}*/		
	
		$.ajax({
			url: "../RFQ/ezUpdateRFQCloseDate.jsp?rfqNo="+rfq+"&closeDate="+closeDate, 
			type: "POST",    
			dataType:"text",   
			error: function (response) 
			{ 
			//alert(":::::error:::::"+response);
				return false;
			},
			success: function (response) 
			{
			alert("RFQ "+rfq+" closing date successfully extended to "+closeDate);
			document.myForm.submit();
			}
		});
	}
	function ezReminder(rfqNo,type,rfqType,endDt,ordDt,stat)
	{
		var msgTxt="Are you sure you want to Send Quote Reminder to Vendor?";
		if(confirm(msgTxt))
		{	

			$.ajax({
				url: "../RFQ/ezRemindRFQ.jsp?PurchaseOrder="+rfqNo+"&type="+type+"&rfqType="+rfqType+"&EndDate="+endDt+"&OrderDate="+ordDt+"&expStat="+stat, 
				type: "POST",    
				dataType:"text",   
				error: function (response) 
				{ 
				//alert(":::::error:::::"+response);
					return false;
				},
				success: function (response) 
				{
				alert("Reminder for RFQ:"+rfqNo+" has been sent successfully");
				//document.myForm.submit();
				}
			});
		}
	}	
</script>

