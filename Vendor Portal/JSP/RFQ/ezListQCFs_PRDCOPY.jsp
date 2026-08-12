<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>   
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iListQcfs.jsp"%>     
<%@ page import = "ezc.ezutil.FormatDate"%> 
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
<body>
<%
	String display_header = "QCF List";
%>
<%@ include file="../Misc/ezSubHeader.jsp"%>		
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">	    
<form name="myForm">
<table class="table table-striped" style="margin-bottom: 1%;"> 

		
		<Tr>
			<Td>
				<label for="fromDate">From Date</label>
			</Td>
			<Td>

				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="FromDate" id="FromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  <%=getDateImage("FromDate")%> 
					  </div>	  
				  </div>
			</Td>
			<Td>
				<label for="toDate">To Date</label> 
			</Td>
			<Td>

				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="ToDate" id="ToDate" value="<%=toDate%>" readonly> 
					  <div class="input-group-addon">
					  	<%=getDateImage("ToDate")%> 
					  </div>	  	
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
						<option value="New">New</option>
						<option value="Sub">Submitted</option>
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
			     	
				<th>QCF No.</th> 
				<th>Plant</th> 
				<!--<th>PR No.</th> 
				<th>PR ITEM No.</th> -->
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
				<th></th>

			</tr>
		</thead>
		<tbody> 
<%
	  
	if(qcfRetALLObjCnt > 0)
	{
		ezc.ezutil.FormatDate fd1 = new ezc.ezutil.FormatDate();
		SimpleDateFormat formatter1   = new SimpleDateFormat("dd/MM/yyyy"); 
		String status="",qcfNo="",prNo="",prItemNo="",createdBy="", createdOn="",expiryDate="",noOfVendCnt="",forBuyerApprCnt="",inNegCnt="",inReqCnt="",accpCnt="",rejCnt="",plant="";
		String showSubmit="Y";
		for(int i=0;i<qcfRetALLObjCnt;i++)
		{

			qcfNo		= qcfRetALLObj.getFieldValueString(i, "ERH_COLLETIVE_RFQ_NO");	  
			prNo		= qcfRetALLObj.getFieldValueString(i, "ERH_PR_NO");  
			prItemNo	= qcfRetALLObj.getFieldValueString(i, "ERH_PR_ITEM_NO");
			plant		= qcfRetALLObj.getFieldValueString(i, "ERH_PLANT");	
			try
			{
				prItemNo = Long.parseLong(prItemNo)+"";
			}
			catch(Exception e)
			{
				prItemNo=prItemNo;
			}			
			createdBy	= qcfRetALLObj.getFieldValueString(i, "ERH_CREATED_BY");
			createdOn 	= qcfRetALLObj.getFieldValueString(i, "ERH_RFQ_DATE");	 
			expiryDate 	= qcfRetALLObj.getFieldValueString(i, "ERH_VALID_UPTO");			
			if(type.equalsIgnoreCase("New")|| type.equalsIgnoreCase("Sub"))
			{
				createdOn 	= convertDateObjToString((Date)qcfRetALLObj.getFieldValue(i, "ERH_RFQ_DATE"));	 
				expiryDate 	= convertDateObjToString((Date)qcfRetALLObj.getFieldValue(i, "ERH_VALID_UPTO"));
			}	
			noOfVendCnt	= qcfRetALLObj.getFieldValueString(i, "NO_OF_VENDORS");
			forBuyerApprCnt	= qcfRetALLObj.getFieldValueString(i, "FOR_BUYER_APPROVAL");
			inNegCnt	= qcfRetALLObj.getFieldValueString(i, "IN_NEGOTIATION");
			inReqCnt	= qcfRetALLObj.getFieldValueString(i, "IN_REQUOTE");
			//out.println("inReqCnt>>>"+inReqCnt);
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
				bckGrdClr="#f2f540e0";
				//if(!noOfVendCnt.equals(accpCnt))continue;
			}
			if(type.equalsIgnoreCase("Sub")){bckGrdClr="#2abb1894";}
			if(type.equalsIgnoreCase("ALL")){
				if("SUB".equals(status))bckGrdClr="#2abb1894";
				if("NEW".equals(status))bckGrdClr="#f2f540e0";
				if(!noOfVendCnt.equals(accpCnt))bckGrdClr="#cfe420";
			}
   
%>
			<tr style="background-color:<%=bckGrdClr%>">
				<!--<td><a style='text-decoration:underline' href="javaScript:funSubmit('<%=qcfNo%>')"><%=qcfNo%></a></td>-->
				
				<td align="center">
					
					<%if(type.equalsIgnoreCase("ALL") && !noOfVendCnt.equals(accpCnt)|| ("0".equals(accpCnt) && "0".equals(inReqCnt)) ){%>
					<a href="#"><b><p style="color:#3a3636"><%=qcfNo%></p><b></a>
					<%}else if("DOM".equals(rfqType)){%>
					<a style='text-decoration:underline' href="ezQuotationComparisionForm.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
					<%}else if("IMP".equals(rfqType)){%>
					<a style='text-decoration:underline' href="ezImpQuoteCompForm.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
					<%}%>
				</td> 
				<td align="center"><%=plant%></td>
				<!--<td align="center"><%=prNo%></td>
				<td align="center"><%=prItemNo%></td> -->
				<td align="center"><%=createdBy%></td>
				<td align="center">
				<span style="display:none;"><%=fd1.getStringFromDate((Date)qcfRetALLObj.getFieldValue(i, "ERH_RFQ_DATE"),"",ezc.ezutil.FormatDate.MMDDYYYY)%></span>
				<%=createdOn%></td>
				<td align="center"><%=expiryDate%></td>
				<td align="center">
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','V','<%=noOfVendCnt%>')"  onMouseover="funViewDetails('<%=qcfNo%>','V','<%=noOfVendCnt%>')">
						<%=noOfVendCnt%>
					</a>
				</td>
				<td align="center">
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','P','<%=forBuyerApprCnt%>')"  onMouseover="funViewDetails('<%=qcfNo%>','P','<%=forBuyerApprCnt%>')">
						<%=accpCnt%>
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
				<td>
<%
	if("New".equals(type))
	{
%>
					<a href="javascript:deleteQCFConfirm('<%=qcfNo%>')" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i>&nbsp;Delete</a>
<%
	}
%>	
			</td>
			</tr> 
<%
		}
	}	
%>
		</tbody>
		</table>
		<i class="fa fa-square" style="color:#f2f540e0"></i>&nbsp;&nbsp;New
		<i class="fa fa-square" style="color:#2abb1894"></i>&nbsp;&nbsp;Submit
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
            <iframe src="" width="100%" height="300" frameborder="0" allowtransparency="true"></iframe> 
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
function deleteQCFConfirm(qcfNo)
{
	if(confirm("Are you sure you want to delete QCF : "+qcfNo+"?"))
	{
		location.href="ezDeleteQCF.jsp?docType=QCF&docNo="+qcfNo;
	}
	
}
   $(document).ready( function () {
       $("#type").val("<%=type%>");
       $("#rfqType").val("<%=rfqType%>");
       
       /*
       $('#example').Datatable({
       "columnDefs":[{"targets":[2],"visible":false}],
       "order": [[ 2, "desc" ]]
	}); */
	
	table.fnSort([[3,"desc"],[0,"desc"]])
      
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
  

