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
<%@include file="../../../Includes/JSPs/Misc/iVNRList.jsp"%>               
<%//@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%> 
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
			display_header	= "List of Vendor(s) To Approve"; 
		}
		else if(type.equals("Apr")) 
		{
			display_header	= "List of Vendor(s) Approved";
		}
		else if(type.equals("Rej"))
		{
			display_header	= "List of Vendor(s) Rejected";
		}
		else if(type.equals("ALL"))
		{
			display_header	= "List of Vendor(s)";
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
			<Th><%=FromDate_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th><%=ToDate_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("toDate")%> 
					  </div>
				  </div>
			</Td>
			<Td>
				<label for="venType"><%=Type_L%> </label>  
			</Td>			
			<Td>
				<div class="input-group">
					 <select class="form-control input-sm" name="venType" id="venType" >
					 <option value="IN" selected>Domestic</option> 
					 <option value="IM">Import</option>
			 		</select>
		 		 </div>
			</Td>			
		<Th><%=vendStatus_L%> </Th>
		<Td>	
				  <div class="input-group">
					 <select class="form-control input-sm" name="type" id="type">

						<option value="ALL" selected>All</option>
						<option value="Act">To Act</option>
						<option value="Sub">Submitted</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option>
						<option value="Ven">At Vendor</option>						
						<!--<option value="Pnd">To Post </option>
						<option value="Pst">Completed</option> -->

					</select>
				  </div>
			</Td>

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;"><%=Go_L%> <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th><%=vendDocNum_L%></th> 
                        <th><%=Vendor_L%></th> 
<%
			if(type.equalsIgnoreCase("Apr"))
			{
%>                        
                        <th><%=sapVendor_L%></th> 
<%
			}
%>                        
                        <th><%=vendPurOrg_L%></th> 
                        <th><%=vendInitiator_L%></th>
                        <th><%=vendCreatedOn_L%></th>
                        <th><%=vendChangedOn_L%></th>
                       	<th><%=vendStatus_L%></th>
                        <th><%=vendQuery_L%></th>
<%
			if(!type.equalsIgnoreCase("Pst"))
			{
%>                         
                        <th><%=pendingWith_L%></th>
<%
			}
%>                        
			
                     </tr>
                  </thead>
                  <tbody>
<%
			String allQcfs="";
			for(int i=0;i<Count;i++)   
                        {
                        	if(i==0)allQcfs=hdrXML.getFieldValueString(i,"ECFH_DOC_ID");
                        	else allQcfs=allQcfs+"','"+hdrXML.getFieldValueString(i,"ECFH_DOC_ID");
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
			String purOrg="";
			String docValue="0.00";
			String createdBy="";
			String docStatus="";
			String sapVen="";
			for(int i=0;i<Count;i++)   
                        {
                        		qcfNo	= hdrXML.getFieldValueString(i,"ECFH_DOC_ID");
                        		if(type.equalsIgnoreCase("Sub"))
                        		{
                        			if(!auditQcfVect.contains(qcfNo))continue;
                        		}
                        		
                        		purOrg	= hdrXML.getFieldValueString(i,"ECFH_SALES_ORG");
                        		createdBy = hdrXML.getFieldValueString(i,"ECFH_CREATED_BY");
                        		if(createdBy==null || "null".equals(createdBy))createdBy="";
                        		docStatus = hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS");
                        		sapVen = hdrXML.getFieldValueString(i,"ECFH_SAP_CODE");
					//if(!"".equals(sapVen)&& sapVen!= null && !"null".equals(sapVen))  
						//docStatus = "Completed";
                       		
%>	 	
                     <tr>
                     	<td align="center">
			<%if("IN".equals(venType)){%>
			<a style='text-decoration:underline' href="ezVendReg.jsp?docId=<%=hdrXML.getFieldValueString(i,"ECFH_DOC_ID")%>"><%=hdrXML.getFieldValueString(i,"ECFH_DOC_ID")%></a>
			<%}else if("IM".equals(venType)){%>
			<a style='text-decoration:underline' href="ezImpVendReg.jsp?docId=<%=hdrXML.getFieldValueString(i,"ECFH_DOC_ID")%>"><%=hdrXML.getFieldValueString(i,"ECFH_DOC_ID")%></a>
			<%}%>
			</td>
			<td><%=hdrXML.getFieldValueString(i,"ECFH_CUST_NAME").toUpperCase()%></td>
<%
			if(type.equalsIgnoreCase("Apr"))
			{
%>			
			<td align="center"><%=checkNull(sapVen)%></td>
<%
			}
%>			
			<td align="center"><%=purOrg%></td>
			<td align="center"><%=createdBy%></td>
                     	<td align="center"><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_CREATED_ON"))%></td>
                     	<td align="center">
                     	<span style="display:none;"><%=fd1.getStringFromDate((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"),"/",ezc.ezutil.FormatDate.MMDDYYYY)%></span>
                     	<%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"))%></td>
			<td align="center"><%=docStatus%></td>	
<%
			String qryStatus="";
			String hyperText="";
			String qryVal=(String)qryHash.get(qcfNo);
			if(qryVal==null || "null".equals(qryVal))qryVal="";
                     	if("0".equals(qryVal))
                     	{
                     		qryStatus="Pending";
                     		hyperText="style=color:red";
                     	}	
%>                     		
                     	<td align="center"><a href="javascript:funQuery('<%=qcfNo%>')" <%=hyperText%>><%=qryStatus%></td>
<%
			if(!type.equalsIgnoreCase("Pst"))
			{
				if("APPROVED".equals(hdrXML.getFieldValueString(i,"EWDHH_WF_STATUS")))
				{
%>                     	
                     			<td align="left">&nbsp;</td>
<%
				}else{
%>         
					<td align="left"><%=checkNull(hdrXML.getFieldValueString(i,"NEXT_PART"))%></td>
<%
				}
			}	
%>		     </tr>	
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
       $("#venType").val("<%=venType%>");
       $('[data-toggle=tooltip]').tooltip();
       table.fnSort([[2,"desc"],[0,"desc"]]);
       
      	$('#example').on('page.dt',function(){
       		//alert("test");
       		//$('input[type=search]').val('');
       });       
      	
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
		document.myForm.action = "ezVNRList.jsp";
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
	function closeIframe()
	{
	   $('#woModal').modal('toggle');
	}	
</script>

