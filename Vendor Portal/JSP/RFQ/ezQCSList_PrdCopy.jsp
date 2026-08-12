<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDateFY.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iQCSList.jsp"%>               
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
			display_header	= "List of QCF(s) To Approve"; 
		}
		else if(type.equals("Apr")) 
		{
			display_header	= "List of QCF(s) Approved";
		}
		else if(type.equals("Rej"))
		{
			display_header	= "List of QCF(s) Rejected";
		}
		else if(type.equals("ALL"))
		{
			display_header	= "List of QCF(s)";
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
						<option value="Act">To Act</option>
						<!--<option value="Req">Requote</option>-->
						<option value="Sub">Submitted</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option>
						<option value="POPend">Pending For PO</option>
						<option value="POCreat">PO Created</option>
						
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
                        <th>QCF</th> 
                        <th>Doc Value</th> 
<%
			//if(type.equalsIgnoreCase("Act")|| (type.equalsIgnoreCase("Sub") && "PP".equals(userRole)))
			//{
%>                        
			<th>No. Of <br>Vendors<br>(Qtn. <br> Sent)</th>
			<th>No. Of <br>Vendors<br>(Offer <br> Received)</th>
<%
			//}
%>			
                        <th>Plant</th> 
                        <th>Created On</th>
                        <th>Changed On</th>
                        <th>Buyer</th>
                        <th>Status</th>
                        <th>Query</th>
                        <th>Pending With</th>
                        <th>PR Creator</th>
			
                     </tr>
                  </thead>
                  <tbody>
<%
			String allQcfs="";
			for(int i=0;i<Count;i++)   
                        {
                        	if(i==0)allQcfs=hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
                        	else allQcfs=allQcfs+"','"+hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
                        }
                        ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"select * from ezc_qcf_comments where EQC_CODE in('"+allQcfs+"') and EQC_TYPE='QUERY' and EQC_QUERY_MAP='0'");
			int retQryCnt=0;
			if(retQry != null)
				retQryCnt= retQry.getRowCount();
			
			java.util.Hashtable qryHash=new java.util.Hashtable();
			for(int k=0;k<retQryCnt;k++)
			{
				qryHash.put(retQry.getFieldValueString(k,"EQC_CODE"),retQry.getFieldValueString(k,"EQC_QUERY_MAP"));
			}
		
                        ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
                        rfqParams = new ezc.ezparam.EzcParams(false); 
                        rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
                        ezc.misctransactions.params.EzMiscTable rfqDetTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow rfqDetTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			rfqDetTableRow.setQuery("select * from ezc_rfq_header,ezc_rfq_details where ERH_COLLETIVE_RFQ_NO in('"+allQcfs+"') and ERH_RFQ_NO=ERD_RFQ_NO group by ERH_COLLETIVE_RFQ_NO,ERD_PR_CREATED_BY");
			rfqDetTable.appendRow(rfqDetTableRow);
			rfqParams.setLocalStore("Y");
			rfqParams.setObject(rfqDetTable);
			Session.prepareParams(rfqParams);
			int dtlCount=0;
			try
			{
				dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
				dtlCount = dtlXML.getRowCount();
			}
			catch(Exception e)
			{
				out.println("Exception in getting rfq details>>>>>"+e);
			}
			java.util.Hashtable createdHash = new java.util.Hashtable();
			for(int k=0;k<dtlCount;k++)   
                        {
                        	createdHash.put(dtlXML.getFieldValueString(k,"ERH_COLLETIVE_RFQ_NO"),dtlXML.getFieldValueString(k,"ERD_PR_CREATED_BY"));
                        }
                        
                        ezc.ezparam.ReturnObjFromRetrieve auditXML	  =	null;
                        ezc.ezparam.EzcParams auditParams = new ezc.ezparam.EzcParams(false); 
                        ezc.misctransactions.client.EzMiscTransactionsManager auditMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
                        ezc.misctransactions.params.EzMiscTable auditTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow auditTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			auditTableRow.setQuery("select * from ezc_wf_audit_trail where EWAT_DOC_ID in('"+allQcfs+"') and EWAT_SOURCE_PARTICIPANT='"+Session.getUserId()+"'");
			auditTable.appendRow(auditTableRow);
			auditParams.setLocalStore("Y");
			auditParams.setObject(auditTable);
			Session.prepareParams(auditParams);
			int auditCount=0;
			try
			{
				if(type.equalsIgnoreCase("Sub"))
					auditXML=(ezc.ezparam.ReturnObjFromRetrieve)auditMgr.ezGetMiscTransactions(auditParams);
				if(auditXML!=null)auditCount = auditXML.getRowCount();
			}
			catch(Exception e)
			{
				out.println("Exception in getting rfq details>>>>>"+e);
			}
			java.util.Vector auditQcfVect = new java.util.Vector();
			for(int k=0;k<auditCount;k++)   
                        {
                        	auditQcfVect.add(auditXML.getFieldValueString(k,"EWAT_DOC_ID"));
                        }
                                                
			ezc.ezutil.FormatDate fd1 = new ezc.ezutil.FormatDate();		
			SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
			Hashtable<String,String> plantHT = getPlants(Session); 	
			String qcfNo="";
			String rfqType="";
			String plant="";
			String docValue="0.00";
			String prCreatedBy="";
			for(int i=0;i<Count;i++)   
                        {
                        		qcfNo	= hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
                        		if(type.equalsIgnoreCase("Sub"))
                        		{
                        			if(!auditQcfVect.contains(qcfNo))continue;
                        		}
                        		rfqType	= hdrXML.getFieldValueString(i,"ERH_EXT2");
                        		plant	= hdrXML.getFieldValueString(i,"ERH_PLANT");
                        		prCreatedBy = (String)createdHash.get(qcfNo);
                        		if(prCreatedBy==null || "null".equals(prCreatedBy))prCreatedBy="";
					try
					{
						docValue =  hdrXML.getFieldValueString(i,"ERH_FINAL_VALUE");  
						docValue = (Double.parseDouble(docValue))+"";
						docValue  = new java.math.BigDecimal(docValue).setScale(2,java.math.BigDecimal.ROUND_DOWN).toString();
					}
					catch(Exception e){
						docValue="0.00";
					}                        		
%>	 	
                     <tr>
                     	<td align="center">
<%
			if("DOM".equals(rfqType)){
%>			
			<a style='text-decoration:underline' href="ezViewDOMQCF.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&prCreatedBy=<%=prCreatedBy%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
<%
			}else if("IMP".equals(rfqType)){
%>			
			<a style='text-decoration:underline' href="ezViewIMPQCF.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>&prCreatedBy=<%=prCreatedBy%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
<%
			}
%>			
			<td align="center"><%=docValue%></td>

<%
		//if(type.equalsIgnoreCase("Act")|| (type.equalsIgnoreCase("Sub") && "PP".equals(userRole)))
		//{
%>			
			<td align="center">
			<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','V','<%=hdrXML.getFieldValueString(i,"TOTVEND")%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
			<%=hdrXML.getFieldValueString(i,"TOTVEND")%></td>
			<td align="center">
			<a href="Javascript:void(0)" onClick="funViewDetails('<%=qcfNo%>','Q','<%=hdrXML.getFieldValueString(i,"QTVEND")%>')"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
			<%=hdrXML.getFieldValueString(i,"QTVEND")%></td> 
<%
		//}
%>			
			
			<td align="center"><%=plant%></td>
			
                     	<td align="center"><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_CREATED_ON"))%></td>
                     	<td align="center">
                     	<span style="display:none;"><%=fd1.getStringFromDate((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"),"/",ezc.ezutil.FormatDate.MMDDYYYY)%></span>
                     	<%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"))%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"EWDHH_CREATED_BY")%></td>
<%
			if("X".equals(hdrXML.getFieldValueString(i,"ERH_PO_FLAG")))
			{
%>
				<td align="center">PO Created</td>
<%
			}else{
				if("PP".equals(userRole))
				{
%>			
					<td align="center"><%=hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS")%>&nbsp;&nbsp;<a href="javascript:deleteQcf('<%=qcfNo%>')" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i></a></td>
				
<%				
				
				}else{
%>
					<td align="center"><%=hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS")%></td>	
<%
				}
			}
			String qryStatus="";
			String qryVal=(String)qryHash.get(qcfNo);
			if(qryVal==null || "null".equals(qryVal))qryVal="";
                     	if("0".equals(qryVal))qryStatus="click";
%>                     		
                     	<td align="center"><a href="javascript:funQuery('<%=qcfNo%>')" ><%=qryStatus%></td>
<%
			if("APPROVED".equals(hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS")))
			{
%>                     	
                     		<td align="left">&nbsp;</td>
<%
			}else{
%>         
				<td align="left"><%=hdrXML.getFieldValueString(i,"NEXT_PART")%></td>
<%
			}
%>
			<td align="center"><%=prCreatedBy%></td>
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
      <iframe id="txtArea1" style="display:none"></iframe>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">      
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>  
            <iframe src="" width="100%" height="200" frameborder="0" allowtransparency="true"></iframe> 
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
       
      	table.fnSort([[2,"desc"],[0,"desc"]])
      	
   } );
	
	function deleteQcf(qcfNo)
	{
		if(confirm("Are you sure you want to delete QCF : "+qcfNo+"?"))
		{
			location.href="ezDeleteQCF.jsp?docType=QCF&docNo="+qcfNo+"&fromPage=WF";
		}
	}
   	function ezSubmit()
   	{
		document.myForm.action = "ezQCSList.jsp";
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
	function funQuery(docId)
	{
		//alert("TEST in SCRIPT");
		var url="../Misc/ezShowQueries.jsp?docId="+docId; 
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
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
	function closeIframe()
	{
	   $('#woModal').modal('toggle');
	}	
</script>

