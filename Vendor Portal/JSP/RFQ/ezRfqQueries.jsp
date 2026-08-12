<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Misc/ezDefaultDate.jsp"%>      
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%!  

	public String convertDateObjToDataTable(java.util.Date inputDate)
	{
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyyMMdd");
		String stringObj = "";
		try {
			stringObj = "<span style='display:none'>"+sdf1.format(inputDate)+"</span>";
			stringObj += sdf.format(inputDate);

		} catch (Exception e) {

		}
		return stringObj;
	}
%>	

<%
	String selVendorCode = "";
%>
<%
	String vendorsSelBox = "";
	java.util.Hashtable gv_VendorsHT = new java.util.Hashtable();

	String lv_QryStr = "";
	
	if("3".equals(userType))
		lv_QryStr = " AND EU_ID = '"+Session.getUserId()+"'";

	ezc.ezparam.ReturnObjFromRetrieve gv_VendorsRetObj = null;
	int gv_VendorsRetObjCnt = 0;
	ezc.ezparam.EzcParams lv_VenMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager lv_VendMiscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable lv_VendTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow lv_VenTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	lv_VenTableRow.setQuery("SELECT EUD_VALUE,EU_FIRST_NAME FROM EZC_USERS,EZC_USER_DEFAULTS WHERE EU_ID = EUD_USER_ID AND EU_TYPE='3' AND EUD_KEY='SOLDTOPARTY'"+lv_QryStr+" ORDER BY EU_FIRST_NAME");
	lv_VendTable.appendRow(lv_VenTableRow);
	lv_VenMainParams.setLocalStore("Y");
	lv_VenMainParams.setObject(lv_VendTable);
	Session.prepareParams(lv_VenMainParams);
	try{
		gv_VendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)lv_VendMiscMgr.ezGetMiscTransactions(lv_VenMainParams);
	}
	catch(Exception e){}	
	
	if(gv_VendorsRetObj!=null)
	{
		gv_VendorsRetObjCnt = gv_VendorsRetObj.getRowCount();
		
		if(gv_VendorsRetObjCnt>0)
		{
			vendorsSelBox = "<Select class='form-control input-sm' name='selVendorCode' id='selVendorCode'>";
			vendorsSelBox += "<Option value=''>--ALL--</Option>";
			for(int lv=0;lv<gv_VendorsRetObjCnt;lv++)
			{
				String lv_Vendor 	= gv_VendorsRetObj.getFieldValueString(lv,"EUD_VALUE");
				String lv_VendorName 	= gv_VendorsRetObj.getFieldValueString(lv,"EU_FIRST_NAME");
				String selectStr   	= "";
				
				gv_VendorsHT.put(lv_Vendor,lv_VendorName);
				
				if(lv_Vendor.equals(selVendorCode))
					selectStr   	= "selected";
				
				vendorsSelBox += "<Option value='"+lv_Vendor+"' "+selectStr+">"+lv_VendorName+"["+lv_Vendor+"]</Option>";
			}	
			vendorsSelBox += "</Select>";
		}	
		
	}	
		
	//out.println("::::gv_VendorsHT::::::"+gv_VendorsHT);	
%>
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<%
	String qryStr = "";
	String listType = request.getParameter("listType"); 
	
	
	if("2".equals(userType))
	{
		qryStr += " EPQ_TYPE='RFQ'";
	}
	else
	{
		qryStr += " EPQ_POSTED_BY='"+Session.getUserId()+"'";
	}
	
	if("SUBMITTED".equals(listType))
		qryStr += " AND EPQ_STATUS='S'"; 
	else if("CLOSED".equals(listType))
		qryStr += " AND EPQ_STATUS='C'";
	else if("ANSWERED".equals(listType))
		qryStr += " AND EPQ_STATUS='A'";
	
	qryStr += " AND ERD_RFQ_NO=EPQ_EXT2 AND ERD_LINE_NO=EPQ_EXT3";
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND EPQ_POSTED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";
		
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null; 
	//miscTableRow.setQuery("SELECT EPQ_ID,EPQ_EXT2,EPQ_EXT3,EPQ_QUERY,EPQ_POSTED_BY,EPQ_POSTED_ON,EPQ_REPLIED_BY,EPQ_REPLIED_ON FROM EZC_PARTNER_QUERIES WHERE "+qryStr);
	miscTableRow.setQuery("SELECT EPQ_ID,EPQ_EXT2,EPQ_EXT3,EPQ_QUERY,EPQ_POSTED_BY,EPQ_POSTED_ON,EPQ_REPLIED_BY,EPQ_REPLIED_ON,EPQ_STATUS,ERD_EXT1 FROM EZC_PARTNER_QUERIES,EZC_RFQ_DETAILS WHERE "+qryStr);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		//out.print(dtlXML.toEzcString());
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int dtlXMLCnt = 0;
	if(dtlXML != null)
		dtlXMLCnt = dtlXML.getRowCount();


%>
<style>
.group
{  
    background-color: #f3c312 !important;	  
    color: white;   
    font-family: cursive;  
} 
#docChkListId {
    display: inline-table; 
    width: 50%;
}
table.dataTable td {
  word-break: break-word;
}
 
 
</style>
<%	      
		Hashtable<String,String> plantHT = getPlants(Session);  
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		 
		String display_header ="";         
		
		if("SUBMITTED".equals(listType))     
		{ 
			display_header	= "Pending RFQ Queries";   
		}
		else if("ALL".equals(listType))     
		{
			display_header	= "ALL RFQ QUERIES";
		}
		
		
		
%>



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
      <!--<div class="box-header with-border">
         <h3 class="box-title">Quick Example</h3>
         </div>--><!-- /.box-header -->
      <form name="myForm" method="post"> 
      
	
            
         <div class="box-body table-responsive no-padding">
            <div class="box-body">
  <table class="table table-striped" style="margin-bottom: 1%;">
  <Tr>
	<Td>
		<label for="toDate">From Date</label><Br>		
		  <div class="input-group">
			  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
			  <%=getDateImage("fromDate")%> 
		  </div>
	</Td>
	<Td>
		<label for="toDate">To Date</label><Br>	
		  <div class="input-group">
			  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
			  <%=getDateImage("toDate")%> 
		  </div> 
  	</Td>


	
  	<Td>	
  		 <label for="toDate">Status</label><Br>	
		  <div class="input-group">
			 <select class="form-control input-sm" name="listType" id="listType">  
				<option value="SUBMITTED">Pending</option>
				<option value="ANSWERED">Answered</option>
				<option value="CLOSED">Closed</option>
				<option value="ALL">All</option>
			 </select>
		  </div>
  	</Td>
  	<Td>
  		<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  	</Td>
  </Tr>
  
  </Table>
 
  
               <table id="example" class="table table-striped table-bordered dt-responsive" cellspacing="0" width="100%">			
		<thead>
			<tr>
				<!--<th>Query Id</th>-->
				<th>RFQ</th>
				<th>Line</th>
				<th>PR No</th>
				<th>Posted By</th>
				<th>&nbsp;&nbsp;&nbsp;Posted On&nbsp</th> 
				<!--<th>Query</th> -->
				<th>Last Replied By</th>
				<th>Last Replied On</th>
				<!--<th>Status</th>-->
				<th>Action</th>
			</tr>
		</thead>  
		<tbody>
<%				
	//out.print(dtlXML.toEzcString());
	String docStatusDisp="",shipDocType="",shipApprStatus="";
	for(int i=0;i<dtlXMLCnt;i++)   
	{
		String tempSts=dtlXML.getFieldValueString(i,"EPQ_STATUS");
		String tempStsDisp = "";
		String bckGrdClr="";
		if("S".equals(tempSts))
		{
			tempStsDisp = "Pending";
			bckGrdClr="#f5b43d";
		}	
		else if("A".equals(tempSts))
		{
			tempStsDisp = "Answered";
			bckGrdClr="#bb981894";
			
		}	
		else if("C".equals(tempSts))
		{
			tempStsDisp = "Closed";
			bckGrdClr="#2abb1894";
			
		}	
%>
		

		<tr style="background-color:<%=bckGrdClr%>;">
			<input type="hidden" name="queryId" value="<%=dtlXML.getFieldValueString(i,"EPQ_ID")%>">
			<td align=center><%=dtlXML.getFieldValueString(i,"EPQ_EXT2")%></td>
			<td align=center><%=dtlXML.getFieldValueString(i,"EPQ_EXT3")%></td>
			<td align=center><%=dtlXML.getFieldValueString(i,"ERD_EXT1").split("¥")[0]%></td>
			<td align=center><%=gv_VendorsHT.get(dtlXML.getFieldValueString(i,"EPQ_POSTED_BY").trim())+" ["+dtlXML.getFieldValueString(i,"EPQ_POSTED_BY")+"]"%></td>
			<td align=center><%=convertDateObjToDataTable((java.util.Date)dtlXML.getFieldValue(i,"EPQ_POSTED_ON"))%></td> 
			<!--<td><%=dtlXML.getFieldValueString(i,"EPQ_QUERY")%></td>-->
			<td align=center><%=checkNull(dtlXML.getFieldValueString(i,"EPQ_REPLIED_BY"))%></td>
			<td align=center><%=convertDateObjToDataTable((java.util.Date)dtlXML.getFieldValue(i,"EPQ_REPLIED_ON"))%></td> 
			<!--<td><%=tempStsDisp%></td>-->
			<td>
<%
	if("S".equals(tempSts) && !"3".equals(userType))
	{
%>
		<button type="button" class="btn btn-primary pull-right" onclick="replyToQuery('<%=dtlXML.getFieldValueString(i,"EPQ_ID")%>','<%=dtlXML.getFieldValueString(i,"EPQ_EXT2")%>','<%=dtlXML.getFieldValueString(i,"EPQ_EXT3")%>','RFQ')" style="margin-right: 5px;">REPLY&nbsp<i class="fa fa-comments"></i></button>
<%
	}
	else
	{
%>
		<button type="button" class="btn btn-primary pull-right" onclick="viewReply('<%=dtlXML.getFieldValueString(i,"EPQ_ID")%>','<%=dtlXML.getFieldValueString(i,"EPQ_EXT2")%>','<%=dtlXML.getFieldValueString(i,"EPQ_EXT3")%>','RFQ')" style="margin-right: 5px;">VIEW&nbsp<i class="fa fa-comments"></i></button>
<%
	}
%>
			</td>
		</tr>  
<%  
	}
%>
		</tbody> 
		</table>
	       	<i class="fa fa-square" style="color:#f5b43d"></i>&nbsp;&nbsp;Pending
	       	<i class="fa fa-square" style="color:#bb981894"></i>&nbsp;&nbsp;Answered
	       	<i class="fa fa-square" style="color:#2abb1894"></i>&nbsp;&nbsp;Closed
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
<div id="queryFrame" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="queryForm" action="../Misc/ezSaveReply.jsp" method="post">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Query</h4>
	</div>
	 <div class="modal-body">	     
	         <fieldset>
	         	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">			
	         	<tr>
				<th>Query Id</th>	
				<td>
					<div class="input-group">
					  <input class="form-control input-sm" type="text"  name="queryId" id="queryId" value="" readonly>
					</div> 
				</td>
			</tr>
			<tr>
				<th>Query</th>	
				<td>
					<div class="input-group">
					  <textarea class="form-control input-sm" type="text" rows=3 cols=100  name="queryMsg" id="queryMsg" readonly></textarea>
					</div> 
				</td>
			</tr>
			<tr>
				<th>Reply</th>	
				<td>
					<div class="input-group">
					  <textarea class="form-control input-sm" type="text" rows=3 cols=100 name="replyMsg" id="replyMsg" placeholder="write reply here"></textarea>
					</div> 
				</td>
			</tr>
			</table>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="saveReply" class="btn btn-primary">Send Reply</button>
	 </div>
      </div>
     </form>
   </div>  
</div> 

<div id="queryViewFrame" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Query</h4>
	</div>
	 <div class="modal-body">	     
	         <fieldset>
	         	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">			
	         	<tr>
				<th>Query Id</th>	
				<td>
					<div class="input-group">
					  <input class="form-control input-sm" type="text"  name="queryDispId" id="queryDispId" value="" readonly>
					</div> 
				</td>
			</tr>
			<tr>
				<th>Query</th>	
				<td>
					<div class="input-group">
					  <textarea class="form-control input-sm" type="text" rows=3 cols=100  name="queryDispMsg" id="queryDispMsg" readonly></textarea>
					</div> 
				</td>
			</tr>
			<tr>
				<th>Reply</th>	
				<td>
					<div class="input-group">
					  <textarea class="form-control input-sm" type="text" rows=3 cols=100 name="replyDispMsg" id="replyDispMsg" readonly></textarea>
					</div> 
				</td>
			</tr>
			</table>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	
	 </div>
      </div>
   </div>  
</div> 

<%@ include file="../Misc/ezFooter.jsp"%>
<script type="text/javascript" class="init">
   $(document).ready( function () {
       $("#listType").val("<%=listType%>");

       $('#example').dataTable( {
   	"dom": 'T<"clear">lfrtip',
   	lengthMenu: [[4, 8, 12, -1], [4, 8, 12, 'All']],
   	"responsive": true,
   	"oTableTools": {
   	
   	    "sSwfPath": "../../../../EzCommon/Library/dataTables/swf/copy_csv_xls_pdf.swf",
   	    "aButtons": [
   	    
   				{
   					"sExtends":    "xls",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as Excel",
   					"sTitle": "report", // Excel file name
   					 "sToolTip": "Save as Excel"
   
   				},
   				{
   					"sExtends":    "pdf",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as PDF",
   					"sTitle": "report",
   					 "sToolTip": "Save as PDF"
   
   				}
   		
   
   			]
   	}
   	
       } );
       
   $('#queryForm').ajaxForm({
          beforeSubmit: valQueryForm,	
   	  success: function(msg) {
   	      $('#saveReply').show(); 	
              $('#loadingInd').hide();
   	      $('#queryFrame').modal('hide');
   	      location.reload();
   	  },
   	  error: function(msg) {
   	     $('#saveReply').show(); 	
             $('#loadingInd').hide();	
   	     alert("Couldn't upload file");
   	  }
     });
   
   } );
   function replyToQuery(queryId,docId,docItem,fromPage)
   {
   	$('iframe').attr("src","../Misc/ezQueryReply.jsp?queryId="+queryId+"&docId="+docId+"&docItem="+docItem+"&fromPage="+fromPage); 
        $('#woModal').modal({show:true});
   	
   }
   function viewReply(queryId,docId,docItem,fromPage)
      {
     
      $('iframe').attr("src","../Misc/ezQueryReply.jsp?queryId="+queryId+"&docId="+docId+"&docItem="+docItem+"&fromPage="+fromPage); 
      $('#woModal').modal({show:true});
   }
   function valQueryForm()
    { 
    	var replyMsg = $('#replyMsg').val();
	var isValid =true;
    	
    	if(replyMsg == "")
   	{
   		alert("Please enter reply");
   		isValid = false;
   		return false;
   	}
   	if(isValid)
   	{
   		$('#saveReply').hide(); 	
          	$('#loadingInd').show();
   	}
   	return isValid;
 }
 function ezSubmit(){
	document.myForm.action = "ezRfqQueries.jsp";
	document.myForm.submit();
}
	window.closeModal = function(){
	    $('#woModal').modal('hide');
	    location.reload();
	};
$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});
</script>

