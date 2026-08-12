<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>   
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iListQcfs.jsp"%>     
<%@ page import = "ezc.ezutil.FormatDate"%> 
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import="java.text.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>  
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
 	
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      QCF List
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!--<div class="box-header with-border">
         <h3 class="box-title">Quick Example</h3>
         </div>--><!-- /.box-header -->
      <form name="myForm" method="post"> 
         <div class="box-body table-responsive no-padding">
            <div class="box-body">


		<table class="table table-striped" style="margin-bottom: 1%;">
		<Tr>
			<Td>
				<label for="fromDate">From Date</label>
			</Td>
			<Td>

				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="FromDate" id="FromDate" value="<%=fromDate%>" readonly>
					  <%=getDateImage("FromDate")%> 
				  </div>
			</Td>
			<Td>
				<label for="toDate">To Date</label> 
			</Td>
			<Td>

				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="ToDate" id="ToDate" value="<%=toDate%>" readonly>  
					  <%=getDateImage("ToDate")%> 
				  </div>
			</Td>
			<Td>
				<label for="rfqType">Type</label>  
			</Td>	
			<Td>
				<div class="input-group">
					 <select class="form-control input-sm" name="rfqType" id="rfqType" >
					 <option value="DOM" selected>Domestic</option> 
					 <option value="IMP">Import</option>
			 		</select>
		 		 </div>
			</Td>			
			
			
			<Td>
				<label for="vendor">Status</label>  
			</Td>	
			<Td>	
				  <div class="input-group">
					 <select class="form-control input-sm" name="type" id="type">
<%
	if("3".equals(userType)) {
%>	
						<option value="New">New</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option> 
						
<%
	}else if("2".equals(userType)) {
%>
						<!--<option value="ALL">All</option> -->
						<option value="WF">ToAct</option>
						<option value="Sub">Approved</option>
						<!--<option value="Rej">Rejected</option>-->
<%
	}
%>	

						
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
				<th>Collective RFQ No.</th> 
				<th>PR No.</th> 
				<th>PR ITEM No.</th> 
				<th>Created By</th>
				<th>Created On</th> 
				<th>Expiry Date</th>
				<th>No. Of Vendors<br>(Quotation Sent)</th>
				<th>No. Of Vendors<br>(Quotation Received)</th>
				<!--<th>To Approve</th>
				<th>To Quote</th>
				<th>To Requote</th>
				<th>Accepted</th>
				<th>Rejected</th>-->

			</tr>
		</thead>
		<tbody> 
<%
	  
	if(qcfRetALLObjCnt > 0)
	{
		SimpleDateFormat formatter1   = new SimpleDateFormat("dd/MM/yyyy"); 
		String status="",qcfNo="",prNo="",prItemNo="",createdBy="", createdOn="",expiryDate="",noOfVendCnt="",forBuyerApprCnt="",inNegCnt="",inReqCnt="",accpCnt="",rejCnt="";
		String showSubmit="Y";
		for(int i=0;i<qcfRetALLObjCnt;i++)
		{

			qcfNo		= qcfRetALLObj.getFieldValueString(i, "ERH_COLLETIVE_RFQ_NO");	  
			prNo		= qcfRetALLObj.getFieldValueString(i, "ERH_PR_NO");  
			prItemNo	= qcfRetALLObj.getFieldValueString(i, "ERH_PR_ITEM_NO");
			try
			{
				prItemNo = Long.parseLong(prItemNo)+"";
			}
			catch(Exception e)
			{
				prItemNo=prItemNo;
			}			
			createdBy	= qcfRetALLObj.getFieldValueString(i, "ERH_CREATED_BY");
			//createdOn 	= qcfRetALLObj.getFieldValueString(i, "ERH_RFQ_DATE");	 
			//expiryDate 	= qcfRetALLObj.getFieldValueString(i, "ERH_VALID_UPTO");			

			createdOn 	= convertDateObjToString((Date)qcfRetALLObj.getFieldValue(i, "ERH_RFQ_DATE"));	 
			expiryDate 	= convertDateObjToString((Date)qcfRetALLObj.getFieldValue(i, "ERH_VALID_UPTO"));
				
			noOfVendCnt	= qcfRetALLObj.getFieldValueString(i, "NO_OF_VENDORS");
			forBuyerApprCnt	= qcfRetALLObj.getFieldValueString(i, "FOR_BUYER_APPROVAL");
			inNegCnt	= qcfRetALLObj.getFieldValueString(i, "IN_NEGOTIATION"); 
			inReqCnt	= qcfRetALLObj.getFieldValueString(i, "IN_REQUOTE");
			accpCnt		= qcfRetALLObj.getFieldValueString(i, "ACCEPTED");
			if(Integer.parseInt(inNegCnt)>0 || Integer.parseInt(inReqCnt)>0)
				showSubmit="N";
			if(type.equalsIgnoreCase("Sub"))
				accpCnt = noOfVendCnt;
			rejCnt		= qcfRetALLObj.getFieldValueString(i, "REJECTED"); 
			status		= qcfRetALLObj.getFieldValueString(i, "STATUS"); 
			String statString="",bckGrdClr="";
			if("RFQ".equals(prNo)){prNo="NA";prItemNo="NA";}
			if(type.equalsIgnoreCase("New"))
			{
				bckGrdClr="#efdbe7";
				//if(!noOfVendCnt.equals(accpCnt))continue;
			}
			if(type.equalsIgnoreCase("Sub")){bckGrdClr="#2abb1894";}
			if(type.equalsIgnoreCase("WF")){bckGrdClr="#fbfb1bb3";}
			if(type.equalsIgnoreCase("ALL")){
				if("SUB".equals(status))bckGrdClr="#2abb1894";
				if("NEW".equals(status))bckGrdClr="#efdbe7";
				if(!noOfVendCnt.equals(accpCnt))bckGrdClr="#cfe420";
			}
   
%>
			<tr style="background-color:<%=bckGrdClr%>">
				<!--<td><a style='text-decoration:underline' href="javaScript:funSubmit('<%=qcfNo%>')"><%=qcfNo%></a></td>-->
				<td>
					<%if(type.equalsIgnoreCase("ALL") && !noOfVendCnt.equals(accpCnt)){%>
					<a href="#"><b><p style="color:#3a3636"><%=qcfNo%></p><b></a>
					<%}else if("DOM".equals(rfqType)){%>
					<a style='text-decoration:underline' href="ezViewDOMQCF.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
					<%}else if("IMP".equals(rfqType)){%>
					<a style='text-decoration:underline' href="ezImpQuoteCompForm.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
					<%}%>
				</td>
				<td><%=prNo%></td>
				<td><%=prItemNo%></td>
				<td><%=createdBy%></td>
				<td><%=createdOn%></td>
				<td><%=expiryDate%></td>
				<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','V','<%=noOfVendCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=noOfVendCnt%>
					</a>
				</td>
				<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','P','<%=forBuyerApprCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=forBuyerApprCnt%>
					</a>
				</td> 
				<!--<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','N','<%=inNegCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=inNegCnt%>
					</a>
				</td>
				<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','R','<%=inNegCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=inReqCnt%>
					</a>
				</td>				
				<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','Y','<%=accpCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=accpCnt%>
					</a>
				</td>

				<td>
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','X' ,'<%=rejCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=rejCnt%>
					</a>
				</td> -->
			</tr> 
<%
		}
	}	
%>
		</tbody>
		</table>
		<i class="fa fa-square" style="color:#fbfb1bb3"></i>&nbsp;&nbsp;To Act
		<i class="fa fa-square" style="color:#2abb1894"></i>&nbsp;&nbsp;Approved
		<!--<i class="fa fa-square" style="color:#cfe420"></i>&nbsp;&nbsp;At Vendor -->
		




            </div>
         </div>
         <!-- Your Page Content Here -->
      </form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
</form>
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
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>

<Div id="MenuSol"></Div>
</body>
</html>
<script type="text/javascript" class="init"> 
   $(document).ready( function () {
       $("#type").val("<%=type%>");
       $("#rfqType").val("<%=rfqType%>");
      
   } );
      	function ezSubmit()
      	{
   		document.myForm.action = "ezListQcfs.jsp"; 
   		document.myForm.submit();
	}
	function funViewDetails(qcfNo, countType, count)
	{
		var intCount = parseInt(count);
		if(intCount>0)
		{
			$('iframe').attr("src","../RFQ/ezViewQcfDetails.jsp?qcfNo="+qcfNo+"&countType="+countType);  
			$('#woModal').modal({show:true});
		}
		else
		{
			return false;
		}
	}
	window.closeModal = function(){
	    $('#woModal').modal('hide');
	};
	
	function funSubmit(qcfNo)
	{

			$('iframe').attr("src","../RFQ/ezQuotationComparisionFormPopUp.jsp?qcfNo="+qcfNo);
			$('#woModal').modal({show:true});

	}
	window.closeModal = function(){ 
	    $('#woModal').modal('hide');
	};	
   	
$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});
</script>
  

