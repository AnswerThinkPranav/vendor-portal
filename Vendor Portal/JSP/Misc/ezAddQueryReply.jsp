<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iAddQueryReply.jsp" %>
<html>
<head>
<style>
.modal-backdrop {
	opacity: 0
}
</style>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<Title>Submit Your Reply -- Powered by The Hackett Group India Pvt Ltd.</Title>
<base TARGET="_self">
<Script>

var qcf_code = '<%=request.getParameter("qcf_code")%>';

function save()
{
	if(document.myForm.qcfComments.value=="")
	{
		alert("Please Enter Reply Query");
		document.myForm.qcfComments.value=""
		document.myForm.qcfComments.focus();
		return;
	}
	else
	if(document.myForm.qcfComments.value.length>1000)
	{
		alert("Query String Should Not Be More Than 1000 Characters");
		document.myForm.qcfComments.focus();
		return;
	}

	//document.getElementById("ButtonsDiv").style.visibility="hidden"
	//document.getElementById("msgDiv").style.visibility="visible"

	document.myForm.action="ezAddSaveQcfQueries.jsp";
	document.myForm.submit();
}
		
function closeQuery()
{
	document.getElementById("ButtonsDiv").style.visibility="hidden"
	document.getElementById("msgDiv").style.visibility="visible"

	document.myForm.action="ezCloseQuery.jsp";
	document.myForm.submit();	
	
}	
	
</Script>

</head>
<body scroll=no>
<form name="myForm">
<input type=hidden name="qcf_code" value='<%=request.getParameter("qcf_code")%>'>
<input type=hidden name="qcf_dest_user" value='<%=request.getParameter("qcf_dest_user")%>'>
<input type=hidden name="qcf_comment_no" value='<%=request.getParameter("qcf_comment_no")%>'>
<input type=hidden name="qcf_user" value='<%=request.getParameter("qcf_user")%>'>
<input type=hidden name="qcf_comment" value='<%=request.getParameter("query")%>'>
<input type=hidden name="docType" value="<%=docType%>">
<input type=hidden name="attachflag" value="">
<input type="hidden" name="attachString" value="">
<input type="hidden" name="qryDate" value='<%=request.getParameter("qryDate")%>'>

<%
	String qcf_mode = request.getParameter("qcf_mode");
	String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	if("VIEW".equals(qcf_mode))
	{
		int qcsRetCnt=0;
		ezc.ezparam.ReturnObjFromRetrieve qcsRet = null;

		ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);  

		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		
		miscTableRow1.setQuery("select * from ezc_qcf_comments where EQC_CODE='"+request.getParameter("qcf_code")+"' order by EQC_DATE");
		miscTable1.appendRow(miscTableRow1);
		mainParams1.setLocalStore("Y");
		mainParams1.setObject(miscTable1);
		Session.prepareParams(mainParams1);

		try
		{
			qcsRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);

		}
		catch(Exception e)
		{
			out.println("Exception in getting Purchase Group List>>>>>"+e);
		}
		if(qcsRet!=null || !"null".equals(qcsRet))
			qcsRetCnt = qcsRet.getRowCount();
%>
		<DIV style="position:absolute;width:100%;top:15%">
			<Table class="table table-bordered" id="ezRCItemTab1">
				<Tr <%=trBGColor%>>
                          		<Th align="center" colspan="6" width=10%><b>Query History</b></Th>
				</Tr>
				<Tr>
					<th>Document No.</th>
					<th>Sent By</th>
					<th>Sent On</th>
					<th>Sent To</th>
					<th>Type</th>
					<th>Comments</th>
				</Tr>
<%				
				for(int i=0;i<qcsRetCnt;i++)
				{
					String tmpDate=qcsRet.getFieldValueString(i,"EQC_DATE");
					tmpDate=tmpDate.substring(8,10)+"/"+tmpDate.substring(5,7)+"/"+tmpDate.substring(0,4);
%>					
					<Tr>
						<td><%=qcsRet.getFieldValueString(i,"EQC_CODE")%></td>
						<td><%=qcsRet.getFieldValueString(i,"EQC_USER")%></td>
						<td width="16%"><%=tmpDate%></td>
						<td><%=qcsRet.getFieldValueString(i,"EQC_DEST_USER")%></td>
						<td><%=qcsRet.getFieldValueString(i,"EQC_TYPE")%></td>
						<td><%=qcsRet.getFieldValueString(i,"EQC_COMMENTS")%></td>
					</Tr>
<%				
				}
%>				
				
			</Table>
			<Br>
		</Div>
		<div class="row" style="position:absolute;top:90%;width:100%;">
			<div class="col-xs-12" align="center">
				<button type="button" class="btn btn-primary" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
			</div>
	    	</div>
<%		
	}
	else if(sendReply)
	{
%>
		<DIV id="addCmntTab" style="position:absolute;width:100%;top:15%">
			<Table align="center" width="96%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
				<Tr <%=trBGColor%>>
                          <Th align="left" width=10%><b>Enter your Reply here</b></Th>
				</Tr>		
				<Tr>
					<Td class='blankcell' width='100%'>
					<textarea name = 'qcfComments' style='width:100%' rows=3 cols=73 ></textarea>
					
				</Tr>
				</Table>
				<Br>
				
				<div class="row">
				<div class="col-md-12 col-xs-12">
				<div class="box box-primary">
				<div class="box-body">
				<h5>
					 <b>Attachment(s)</b>
				</h5>			
					<table id="uploadTableH" class="table  table-bordered dt-responsive nowrap" >	
								<tr>
									<th class="fborder" width="95%" align='left'>File Name</th>
									<th class="fborder" width="5%"></th>
								</tr>
								<tr id="noDataStatUpload">
									<td>No files attached</td>
								</tr>						
				</table>
				</div>
				</div>
				</div>
				</div>
				
		</Div>	
		<div class="row" style="position:absolute;top:70%;width:100%;">
			<div class="col-xs-12" align="center">
						
						
						<button type="button"  value="H" class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload Attachments</button>
						<button type="button" class="btn btn-success" style="margin:5px" onclick="save()"><i class="fa fa-save"></i>&nbsp;Save</button>
						<button type="button" class="btn btn-primary" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
	    
	    		</div>
	    	</div>	
		  
      		<Div id="msgDiv" style="position:absolute;top:90%;width:100%;visibility:hidden" align="center">
			<Table align="center" width="60%" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=0 >
				<Tr>
					<Th  align="center">Your request is being processed. Please wait ...............</Th>
				</Tr>
			</Table>
		</Div>
<%
	}
	else
	{
%>
		<input type=hidden name='qcfComments' value="<%=request.getParameter("query")+"',EQC_TYPE='QRY_CLOSED"%>">
		<DIV id="addCmntTab" style="position:absolute;width:100%;top:15%">
			<Table align="center" style="width:90%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
			<Tr>
				<Th align="left" width=10%>
				Reply can not be sent due to one of the following reasons.<BR>
				1 . Document was submitted for further approval<BR>
				2 . Document was approved / released<BR>
				3 . Document Closed <Br><BR><BR>If you want to close the query click <a href='javascript:closeQuery()'>here</a></Th>
			</Tr>
			</Table>
		</Div>
		<DIV id="ButtonsDiv" style="position:absolute;width:100%;top:80%">	
			<Table style="width:100%" border="0" cellspacing="0" cellpadding="0" align = center>	
				<Tr>
					<Td class="TDCommandBarBorder" align='center'>
						<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>

					</Td>
				</Tr>
			</Table>
		</Div>
		<Div id="msgDiv" style="position:absolute;top:90%;width:100%;visibility:hidden" align="center">
					<Table align="center" width="60%" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=0 >
						<Tr>
							<Th  align="center">Your request is being processed. Please wait ...............</Th>
						</Tr>
					</Table>
		</Div>
<%
	}
%>
<Div id="MenuSol">
</Div>
</form>
</body>
</html>
<div id="uploadMod" class="modal " tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeUploadModal()">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="">
			<input type="hidden" id="upDocId" name="upDocId" value="">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<input type="file" id="file" name="file"/>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div>
<script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
<script>
window.closeUploadModal = function(){
			    $('#uploadMod').modal('hide');
}
function downloadFilePreView(upItemNo,fileName)
{
	var upDocId 	= upItemNo;
	var upDocType 	= "<%=docType%>";
	window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upplant+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
}
function deleteFile(thisObj,upItemNo,fileName)
{
	var upDocId 	= $('#upDocId').val();
 	var upDocType 	= $('#upDocType').val();
 	$.ajax({
	    url: '../Inbox/ezDeleteFileTemp.jsp',
	    data: { upDocId: upDocId, upDocType : upDocType,upItemNo:upItemNo,fileName:fileName},
	    dataType: "json",
	    type: 'POST',
	    success: function(result) {
	      result=$.trim(result);  
	      if(result === 'true')
	      {
	      	$(thisObj).closest("tr").remove();	
	      }
	    }
	});
}
function valUploadForm()
{
	var upItemNo = $('#upItemNo').val();
	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
	var isValid = true;
 	if(fileName == "")
	{
		alert("Please upload file");
		isValid = false;
		return false;
	}
 	$('input[name="fileItem'+upItemNo+'"]').each(function(){
	  if($(this).val() == fileName)
	  {
	  	alert("File already uploaded");
	  	isValid = false;
		return false;
	  }	  
	});
	if(isValid)
	{
		$('#uploadbutton').hide(); 	
       		$('#loadingInd').show();
	}
	return isValid;
}
 
$( function()
{
     $( ".uploadDialogBtn" ).button().on( "click", function() {
        $("#upItemNo").val($(this).val());
        $("#file").val("");
       $('#uploadMod').modal('show');
       	return false;
     });
     $('#uploadForm').ajaxForm({
     	  beforeSubmit: valUploadForm,	
	  success: function(msg) {
	      $('#uploadbutton').show(); 	
       	      $('#loadingInd').hide();
	      msg=$.trim(msg);
	      //alert(msg);
	      if(msg.split("##")[0] === 'true')
	      {
	      	  $('#noDataStatUpload').hide();
	      	  var upItemNo = $('#upItemNo').val();
	      	  var fileNameTemp = msg.split("##")[1];
	      	   $('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFilePreView(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
	      }
	      //alert("File has been uploaded successfully");
	      $('#uploadMod').modal('hide');
	  },
	  error: function(msg) {
	     $('#uploadbutton').show(); 	
       	     $('#loadingInd').hide();	
	     alert("Couldn't upload file");
	  }
     });
} );

   
</script>   