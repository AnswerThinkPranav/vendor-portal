<%@ page import="java.util.*,java.text.*" %>   
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>    
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@include file="../../../Includes/JSPs/Misc/iNewQcfQueries.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%>
<%//@ include file="../Misc/ezCommonMethods.jsp"%>  
<%@ include file="../Misc/ezNACompCodeMap.jsp"%> 

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
   
  
	String display_header ="List of Queries";
	


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
      <input type="hidden" name="compCode" id="compCode" value="">
      <input type="hidden" name="venType" id="venType" value="">
      <input type="hidden" name="docNo" id="docNo" value="">
      <input type="hidden" name="qrytype" id="qrytype" value="">
      
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
<%
			String qTypeArr[]={"ALL#ALL","QCF#QCF","VNR#Vendor"};
%>
			<Th>Type of Vendor</Th>
			<Td>
				  <div class="input-group">
					  <select class="form-control input-sm" name="qrytype" id="qrytype"> 
<%					  
					  for(int q=0;q<qTypeArr.length;q++)
					  {
					  	String qSel="";
					  	if(qrytype.equals(qTypeArr[q].split("#")[0]))qSel="selected";
%>
						<option value="<%=qTypeArr[q].split("#")[0]%>" <%=qSel%>><%=qTypeArr[q].split("#")[1]%></option>
<%
					  }
%>					  
					  </select>
				  </div>
			</Td>
<%
			String stArr[]={"Pending","Replied"};
%>			
			<Th>Status</Th> 
			<Td>
				<div class="input-group">
					<select class="form-control input-sm" name="status" id="status">
<%					  
					for(int q=0;q<stArr.length;q++)
					{
						String qSel="";
						if(status.equals(stArr[q]))qSel="selected";
%>
						<option value="<%=stArr[q]%>" <%=qSel%>><%=stArr[q]%></option>
<%
					}
%>					
					</select>
				</div>
			
			</Td>
			
			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go<i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
<Tr>
					<Th width="8%" align="left">Doc No&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="8%" align="left">Doc Type&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="18%" align="left">Sent By&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="12%" align="left">Sent On&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="53%" align="left" >Query&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
<%
					if("Pending".equals(status))
					{
%>					
					<Th width="9%" align="center">Reply&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
<%
					}
					else
					{
%>
					<Th width="9%" align="center">History&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
<%
					}
%>					
				</Tr>
                  </thead>
                  <tbody>
<%
			ezc.ezutil.FormatDate fd1 = new ezc.ezutil.FormatDate();		
			SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
			Hashtable<String,String> plantHT = getPlants(Session); 	
			String docType="",vendorNo="",tmpDType="";
			for(int i=0;i<qcsRetCnt;i++)
			{
				docNo = qcsRet.getFieldValueString(i,"EQC_CODE");
				//out.println("docNo::"+docNo);
				docType = qcsRet.getFieldValueString(i,"EQC_EXT2");
				//out.println("docType::"+docType);
				if("VNR".equals(docType))tmpDType="Vendor";
				else tmpDType="QCF";
				//vendorNo = qcsRet.getFieldValueString(i,"SOLD_TO");
				
				//collSyskey.put(docNo.trim(),qcsRet.getFieldValueString(i,"SYSKEY"));
				
				String requiDate=qcsRet.getFieldValueString(i,"EQC_DATE");
				//out.println("requiDate"+requiDate);
				String requiDat="";
				requiDat=requiDate.substring(6,10)+requiDate.substring(3,5)+requiDate.substring(0,2);
				String qryText = qcsRet.getFieldValueString(i,"EQC_COMMENTS");
				qryText=qryText.replace("\"","`");

%>	 	
                     
				<Tr>
					<!--<Td width="8%"><%=docNo%></Td>-->
					<!--<td align="left"><a href='ezVendReg.jsp?docId=<%=docNo%>'><%=docNo%></a></td>-->
					<td align="center">					
<%
				ezc.ezcommon.EzLog4j.log("docNo1>>>>>>>>"+docNo,"I");
				ezc.ezcommon.EzLog4j.log("qcsRetCompCode>>>>"+qcsRetCompCode.getFieldValueString(i,"ECFH_EXT1"),"I");
				String compCodeTest = "5000";
				boolean containsValue =hashCompCode.containsValue(compCodeTest);
				ezc.ezcommon.EzLog4j.log("**compCodeTest>>>>"+compCodeTest,"I");
				ezc.ezcommon.EzLog4j.log("**containsValue>>>>"+containsValue,"I");
				if(hashCompCode.containsKey(docNo))
				{
					ezc.ezcommon.EzLog4j.log("** India"+1111,"I");
					if("IN".equals(qcsRetCompCode.getFieldValueString(i,"ECFH_VEN_TYPE"))){
					ezc.ezcommon.EzLog4j.log("** 2nd IF>>>>"+2222,"I");
%>
						<a style='text-decoration:underline' href="ezVendReg.jsp?docId=<%=docNo%>"><%=docNo%></a>
<%		
					}else if("IM".equals(qcsRetCompCode.getFieldValueString(i,"ECFH_VEN_TYPE"))){
						ezc.ezcommon.EzLog4j.log("**ELSE IF>>>>"+3333,"I");
%>
						<a style='text-decoration:underline' href="ezImpVendReg.jsp?docId=<%=qcsRet.getFieldValueString(i,"EQC_CODE")%>"><%=qcsRet.getFieldValueString(i,"EQC_CODE")%></a>
<%
					}
				}
				else
				{
						ezc.ezcommon.EzLog4j.log("** ELSE>>>>"+4444,"I");

%>	
						<a style='text-decoration:underline' href="ezNAVendReg.jsp?docId=<%=qcsRet.getFieldValueString(i,"EQC_CODE")%>"><%=qcsRet.getFieldValueString(i,"EQC_CODE")%></a>
<%
				}
			
%>
			</td>				

					<Td width="8%"><%=tmpDType%></Td>
					<Td width="18%"><%=getUserName(Session,qcsRet.getFieldValueString(i,"EQC_USER"),"U",(String)session.getValue("SYSKEY"))%></Td>
					<Td width="12%"><span id="datehid" hidden="hidden"><%=requiDat%></span><%=convertDateObjToString((Date)qcsRet.getFieldValue(i,"EQC_DATE"))%></Td>
					<Td width="53%"><%=qryText%></Td>
					<Td align="center" width="9%">
<%
					if("Pending".equals(status))
					{
%>
					<a href="JavaScript:funOpenReplyWin('REPLY','<%=qcsRet.getFieldValueString(i,"EQC_CODE")%>','<%=qcsRet.getFieldValueString(i,"EQC_COMMENT_NO")%>','<%=qcsRet.getFieldValueString(i,"EQC_DEST_USER")%>','<%=qcsRet.getFieldValueString(i,"EQC_USER")%>','<%=qryText%>','<%=qcsRet.getFieldValueString(i,"EQC_DATE")%>','<%=docType%>','<%=qcsRet.getFieldValueString(i,"SYSKEY")%>')" title="Click To Reply For This Query"><Font color="red">Submit</Font></a>
<%
					}
					else
					{
%>
					<a href="JavaScript:funOpenReplyWin('VIEW','<%=qcsRet.getFieldValueString(i,"EQC_CODE")%>','<%=qcsRet.getFieldValueString(i,"EQC_COMMENT_NO")%>','<%=qcsRet.getFieldValueString(i,"EQC_DEST_USER")%>','<%=qcsRet.getFieldValueString(i,"EQC_USER")%>','<%=qryText%>','<%=qcsRet.getFieldValueString(i,"EQC_DATE")%>','<%=docType%>','<%=qcsRet.getFieldValueString(i,"SYSKEY")%>')" title="Click To Check For This Query"><Font color="red">View</Font></a>
<%
					}
%>					
					</Td>
					
					
									
				</Tr>
		     	
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
<div id="woModalQry" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="450" frameborder="0" allowtransparency="true"></iframe>
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
       
       $('[data-toggle=tooltip]').tooltip();
       
      	table.fnSort([[2,"desc"],[0,"desc"]])
      	
   } );

   
   	function ezSubmit()
   	{
		document.myForm.action = "ezListQueries.jsp";
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
	/*function funOpenReplyWin(qcf_code,qcf_comment_no,qcf_user,qcf_dest_user,query,qryDate,docType) 
	{
		newWindow=window.open("ezAddQueryReply.jsp?docType="+docType+"&qcf_code="+qcf_code+"&qcf_dest_user="+qcf_dest_user+"&qcf_comment_no="+qcf_comment_no+"&qcf_user="+qcf_user+"&query="+query+"&qryDate="+qryDate,"","width=500,height=350,left=40,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=no");
	}*/
	function funOpenReplyWin(qcf_mode,qcf_code,qcf_comment_no,qcf_user,qcf_dest_user,query,qryDate,docType)
	{
		//alert("Modal");
		var url="../Misc/ezAddQueryReply.jsp?qcf_mode="+qcf_mode+"&docType="+docType+"&qcf_code="+qcf_code+"&qcf_dest_user="+qcf_dest_user+"&qcf_comment_no="+qcf_comment_no+"&qcf_user="+qcf_user+"&query="+query+"&qryDate="+qryDate; 
		$('#woModalQry iframe').attr("src",url);
		$('#woModalQry').modal({show:true}); 
	}
	function closeIframe()
	{
		   $('#woModalQry').modal('toggle');
	}	
</script>

