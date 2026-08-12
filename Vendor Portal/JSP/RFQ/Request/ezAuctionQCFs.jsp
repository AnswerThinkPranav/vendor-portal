<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>   
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iQCFsLabels.jsp"%>
<%	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String type = request.getParameter("type");
	String rfqType = request.getParameter("rfqType"); 
	rfqType = "DOM";
	type  = "New";
	//if("".equals(type) || "null".equals(type) || type==null) type = "New";
	ezc.ezparam.ReturnObjFromRetrieve qcfRetObj = null;
	ezc.ezparam.ReturnObjFromRetrieve qcfRetNewRetObj = null;
	ezc.ezparam.ReturnObjFromRetrieve qcfRetALLObj = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"ERH_COLLETIVE_RFQ_NO","ERH_PR_NO","ERH_SOLD_TO","ERH_RFQ_DATE","ERH_CREATED_BY","ERH_VALID_UPTO","ERH_PR_ITEM_NO","NO_OF_VENDORS","FOR_BUYER_APPROVAL","IN_NEGOTIATION","IN_REQUOTE","ACCEPTED","REJECTED","STATUS"});	
	int qcfRetObjCnt = 0;
	int qcfRetALLObjCnt=0;
	ezc.ezparam.EzcParams qcfMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager qcfMiscParams = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	if(type.equalsIgnoreCase("New"))
	{
	qcfTableRow.setQuery("select DISTINCT(ERH_COLLETIVE_RFQ_NO),ERH_PR_NO,ERH_PR_ITEM_NO,ERH_PLANT,ERH_SOLD_TO,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,ERH_PR_ITEM_NO,"+
				"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
				"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
				"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
				"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
				"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
				"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
				"from EZC_RFQ_HEADER WHERE ERH_STATUS NOT IN('S') AND ERH_EXT2 IN('"+rfqType+"') AND ERH_PR_NO='0000000000'"+
				"AND ERH_COLLETIVE_RFQ_NO NOT IN (SELECT ERH_COLLETIVE_RFQ_NO FROM ezc_rfq_header WHERE ERH_STATUS IN ('S') AND ERH_EXT2 IN('"+rfqType+"')) AND ERH_COLLETIVE_RFQ_NO NOT IN (SELECT EAH_EXT3 FROM EZC_AUCTION_HEADER)"+
				"AND ERH_CREATED_BY='"+Session.getUserId()+"'"+
				"group by ERH_COLLETIVE_RFQ_NO;");
	}
	
	qcfTable.appendRow(qcfTableRow);
	qcfMainParams.setLocalStore("Y");
	qcfMainParams.setObject(qcfTable);
	Session.prepareParams(qcfMainParams);
	try{
		qcfRetObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMiscParams.ezGetMiscTransactions(qcfMainParams);
		
	}
	catch(Exception e){}	
	
	if(qcfRetObj!=null)
	{
		qcfRetObjCnt = qcfRetObj.getRowCount();
		ezc.ezcommon.EzLog4j.log("qcfRetObjCnt>>>"+qcfRetObjCnt,"I");
		
			
		
	}
	if(type.equalsIgnoreCase("ALL"))
	{
		qcfTableRow.setQuery("select DISTINCT(ERH_COLLETIVE_RFQ_NO),ERH_PR_NO, ERH_SOLD_TO,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,ERH_PR_ITEM_NO,"+
						"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
						"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
						"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
						"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
						"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
						"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
						"from EZC_RFQ_HEADER WHERE ERH_STATUS NOT IN('S') AND ERH_EXT2 IN('"+rfqType+"') AND ERH_COLLETIVE_RFQ_NO NOT IN (SELECT EAH_EXT3 FROM EZC_AUCTION_HEADER)"+
					"group by ERH_COLLETIVE_RFQ_NO;");
		qcfTable.appendRow(qcfTableRow);
		qcfMainParams.setLocalStore("Y");
		qcfMainParams.setObject(qcfTable);
		Session.prepareParams(qcfMainParams);
		try{
			qcfRetNewRetObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMiscParams.ezGetMiscTransactions(qcfMainParams);
			ezc.ezcommon.EzLog4j.log("qcfRetNewObjCnt>>>"+qcfRetNewRetObj.getRowCount(),"I");
		}
		catch(Exception e){}
	}	
	 if(type.equalsIgnoreCase("ALL"))
	 {
	 	for(int j=0;j<qcfRetNewRetObj.getRowCount();j++)
	 	{
	 		String qcfNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_COLLETIVE_RFQ_NO");	  
			String prNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_PR_NO");  
			String prItemNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_PR_ITEM_NO");
			String createdBy	= qcfRetNewRetObj.getFieldValueString(j, "ERH_CREATED_BY");	
			String createdOn 	= convertDateObjToString((Date)qcfRetNewRetObj.getFieldValue(j, "ERH_RFQ_DATE"));	
			String expiryDate 	= convertDateObjToString((Date)qcfRetNewRetObj.getFieldValue(j, "ERH_VALID_UPTO"));
			String noOfVendCnt	= qcfRetNewRetObj.getFieldValueString(j, "NO_OF_VENDORS");
			String forBuyerApprCnt	= qcfRetNewRetObj.getFieldValueString(j, "FOR_BUYER_APPROVAL");
			String inNegCnt		= qcfRetNewRetObj.getFieldValueString(j, "IN_NEGOTIATION");
			String inReqCnt		= qcfRetNewRetObj.getFieldValueString(j, "IN_REQUOTE");
			String accpCnt		= qcfRetNewRetObj.getFieldValueString(j, "ACCEPTED");
			String rejCnt		= qcfRetNewRetObj.getFieldValueString(j, "REJECTED"); 
	 		
	 		qcfRetALLObj.setFieldValue("ERH_COLLETIVE_RFQ_NO",qcfNo);
	 		qcfRetALLObj.setFieldValue("ERH_PR_NO",prNo);
	 		qcfRetALLObj.setFieldValue("ERH_PR_ITEM_NO",prItemNo);
	 		qcfRetALLObj.setFieldValue("ERH_CREATED_BY",createdBy);
	 		qcfRetALLObj.setFieldValue("ERH_RFQ_DATE",createdOn);
	 		qcfRetALLObj.setFieldValue("ERH_VALID_UPTO",expiryDate);
			qcfRetALLObj.setFieldValue("NO_OF_VENDORS",noOfVendCnt);
			qcfRetALLObj.setFieldValue("FOR_BUYER_APPROVAL",forBuyerApprCnt);
			qcfRetALLObj.setFieldValue("IN_NEGOTIATION",inNegCnt);
	 		qcfRetALLObj.setFieldValue("IN_REQUOTE",inReqCnt);
	 		qcfRetALLObj.setFieldValue("ACCEPTED",accpCnt);
	 		qcfRetALLObj.setFieldValue("REJECTED",rejCnt);
	 		qcfRetALLObj.setFieldValue("STATUS","NEW");
	 	
	 		qcfRetALLObj.addRow();
	 	}
	 	for(int j=0;j<qcfRetObj.getRowCount();j++)
		{
			String qcfNo		= qcfRetObj.getFieldValueString(j, "ERH_COLLETIVE_RFQ_NO");	  
			String prNo		= qcfRetObj.getFieldValueString(j, "ERH_PR_NO");  
			String prItemNo		= qcfRetObj.getFieldValueString(j, "ERH_PR_ITEM_NO");
			String createdBy	= qcfRetObj.getFieldValueString(j, "ERH_CREATED_BY");	
			String createdOn 	= convertDateObjToString((Date)qcfRetObj.getFieldValue(j, "ERH_RFQ_DATE"));	
			String expiryDate 	= convertDateObjToString((Date)qcfRetObj.getFieldValue(j, "ERH_VALID_UPTO"));
			String noOfVendCnt	= qcfRetObj.getFieldValueString(j, "NO_OF_VENDORS");
			String forBuyerApprCnt	= qcfRetObj.getFieldValueString(j, "FOR_BUYER_APPROVAL");
			String inNegCnt		= qcfRetObj.getFieldValueString(j, "IN_NEGOTIATION");
			String inReqCnt		= qcfRetObj.getFieldValueString(j, "IN_REQUOTE");
			String accpCnt		= qcfRetObj.getFieldValueString(j, "ACCEPTED");
			String rejCnt		= qcfRetObj.getFieldValueString(j, "REJECTED"); 

			qcfRetALLObj.setFieldValue("ERH_COLLETIVE_RFQ_NO",qcfNo);
			qcfRetALLObj.setFieldValue("ERH_PR_NO",prNo);
			qcfRetALLObj.setFieldValue("ERH_PR_ITEM_NO",prItemNo);
			qcfRetALLObj.setFieldValue("ERH_CREATED_BY",createdBy);
			qcfRetALLObj.setFieldValue("ERH_RFQ_DATE",createdOn);
			qcfRetALLObj.setFieldValue("ERH_VALID_UPTO",expiryDate);
			qcfRetALLObj.setFieldValue("NO_OF_VENDORS",noOfVendCnt);
			qcfRetALLObj.setFieldValue("FOR_BUYER_APPROVAL",forBuyerApprCnt);
			qcfRetALLObj.setFieldValue("IN_NEGOTIATION",inNegCnt);
			qcfRetALLObj.setFieldValue("IN_REQUOTE",inReqCnt);
			qcfRetALLObj.setFieldValue("ACCEPTED",accpCnt);
			qcfRetALLObj.setFieldValue("REJECTED",rejCnt);
			qcfRetALLObj.setFieldValue("STATUS","SUB");

			qcfRetALLObj.addRow();
	 	}
	 }	
	 else if(type.equalsIgnoreCase("New"))qcfRetALLObj=qcfRetObj;
	 else if(type.equalsIgnoreCase("Sub"))qcfRetALLObj=qcfRetObj;
	 else if(type.equalsIgnoreCase("WF"))qcfRetALLObj=qcfRetObj;
	 if(qcfRetALLObj!=null)
	 {
	 		qcfRetALLObjCnt = qcfRetALLObj.getRowCount();
	 		
	 			
	 		
	}
	 	
%>     
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
<input type="hidden" name="fromQCF" value="Y">
<input type="hidden" name="selCategory" value="LOG">
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
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

		
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
			     <tr>
			     	<th>&nbsp;</th> 
				<th><%=QCF_No_L%></th> 
				<th><%=plant_L%></th> 
				<!--<th>PR No.</th> 
				<th>PR ITEM No.</th> -->
				<th><%=created_By_L%></th>
				<th><%=created_On_L%></th> 
				<th><%=expired_Date_L%></th>
				<th><%=No_of_Vend_sent_L%></th>
				<th><%=No_of_Vend_rec_L%></th>
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
				<td align="center"><input type="radio" name="selQcfNo" value="<%=qcfNo%>"></td>
				<td align="center">
					<%if(type.equalsIgnoreCase("ALL") && !noOfVendCnt.equals(accpCnt)|| "0".equals(accpCnt)){%>
					<a href="#"><b><p style="color:#3a3636"><%=qcfNo%></p><b></a>
					<%}else if("DOM".equals(rfqType)){%>
					<a style='text-decoration:underline' href="../RFQ/ezQuotationComparisionForm.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
					<%}else if("IMP".equals(rfqType)){%>
					<a style='text-decoration:underline' href="../RFQ/ezImpQuoteCompForm.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&showSubmit=<%=showSubmit%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
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
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','V','<%=noOfVendCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
						<%=noOfVendCnt%>
					</a>
				</td>
				<td align="center">
					<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','P','<%=forBuyerApprCnt%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
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
	<div class="row no-print">
	<div class="col-xs-12">
		<button type="button" class="btn btn-primary pull-right" onclick="ezSubmitAuction()" style="margin-right: 5px;"><i class="fa fa-arrow-right"></i> Continue</button>
		
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
   	function ezSubmitAuction()
   	{
		var selChk = document.myForm.selQcfNo;
		var qcfCnt = 0;
		if(isNaN(selChk.length))
		{
			if(selChk.checked)
			{
				qcfCnt++;
			}
		}
		else
		{
			for(i=0;i<selChk.length;i++)
			{
				if(selChk[i].checked)
				{
					qcfCnt++;
				}
			}
		}
		if(qcfCnt == 0)
		{
			alert("Please select atleast one QCF");
			return ;
		}
		document.myForm.action = "ezSelectAuctionMat.jsp";
		document.myForm.submit();
   		
   	}
      	function ezSubmit()
      	{
   		document.myForm.action = "ezAuctionQCFs.jsp"; 
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
  

