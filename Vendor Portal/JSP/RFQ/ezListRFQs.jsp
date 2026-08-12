<%@ page import="java.util.*,java.text.*" %> 
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>   
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%//@ include file="../../../Includes/JSPs/Misc/iGetSbuPlantAddress.jsp"%>   
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iListRFQs.jsp"%>             
<%@include file="../Misc/ezGetJGLVendorsList.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>
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
	if("3".equals(userType)|| "4".equals(userType)) 
	{
		if(type.equals("New"))   
		{
			display_header	= "List of RFQs To Quote";
		}
		else if(type.equals("Req")) 
		{
			display_header	= "List of RFQs To Requote";
		}	
		else if(type.equals("Apr")) 
		{
			display_header	= "List of RFQs Approved";
		}
		else if(type.equals("Rej"))
		{
			display_header	= "List of RFQs Rejected";
		}	
		else if(type.equals("List")) 
		{
			display_header	= "List of RFQs At JGL";
		}
		/*else if(type.equals("Qry")) 
		{
			display_header	= "List of RFQs with Queries";
		}*/		
		
	}
	else if("2".equals(userType))
	{
		if(type.equals("Act"))   
		{
			display_header	= "List of RFQs To Approve"; 
		}
		else if(type.equals("Req")) 
		{
			display_header	= "List of RFQs In Requote";
		}	
		else if(type.equals("Apr")) 
		{
			display_header	= "List of RFQs Approved";
		}
		else if(type.equals("Rej"))
		{
			display_header	= "List of RFQs Rejected";
		}	
		else if(type.equals("List")) 
		{
			display_header	= "List of RFQs At Vendor";
		}
		else if(type.equals("Exp")) 
		{
			display_header	= "Expired of RFQs";
		}
		/*else if(type.equals("Qry")) 
		{
			display_header	= "List of RFQs with Queries";
		}*/			
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
			<Th><%=from_Date_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th><%=to_Date_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("toDate")%> 
					  </div>
				  </div>
			</Td>
			<!--<Td>
				<label for="vendor">Vendor</label>   
				  <div >
					  
				  </div>
			</Td> -->
<%			
 	if("2".equals(userType))
	{
%>
		<Th><%=type_L%></Th>
		<Td>	
		  <div class="input-group">
			 <select name="rfqType" id="rfqType" class="form-control input-sm" >
				<option value="DOM" selected>Domestic</option> 
				<option value="IMP">Import</option>
			 </select>
		  </div>
		</Td>
<%
	}
%>
		<Th><%=status_L%></Th>
		<Td>	
				  <div class="input-group">
					 <select class="form-control input-sm" name="type" id="type">
<%
	if("3".equals(userType)|| "4".equals(userType)) {
%>	
						<option value="ALL" selected><%=ALL_L%>l</option>
						<option value="New">To Quote</option>
						<option value="Req">To Requote</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option>
						<option value="Exp">Expired</option>
						<!--<option value="Qry">Queries</option>-->
						<option value="List">At JGL</option>
						
						
<%
	}else if("2".equals(userType)) {
%>
						<option value="ALL" selected>All</option>
						<option value="Act">To Approve</option>
						<option value="Req">Requote</option>
						<option value="Apr">Approved</option>
						<option value="Rej">Rejected</option>
						<option value="Exp">Expired</option>
						<!--<option value="Qry">Queries</option>-->
						<option value="List">At Vendor</option>
<%
	}
%>	

						
					 </select>
				  </div>
			</Td>

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;"><%=Go_L%><i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th><%=RFQ_L%> </th> 
                     <!--<th>RFQ Description</th>-->
                        <TH><%=QCF_NO_L%> </th>
                        <TH><%=QCF_TITLE_L%> </th>
                        <TH><%=PR_NO_L%></th>
                       <!-- <TH>MULTIPLE PR NO</th>-->
                        <th><%=RFQ_Date_L%> </th>
                        <th><%=Vendor_L%> </th>
			<!--<th>Plant</th>-->
			<th><%=Pur_Grp_L%></th>
			<th><%=Buyer_L%></th> 
                        <!--<th>RFQ Closing Date & Time</th> -->
                        <th><%=RFQ_Closing_Date_L%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>  
                        <th><%=RFQ_Status_L%></th>
                        
<%
		if("2".equals(userType) && "List".equals(type) || "2".equals(userType) && "Req".equals(type)) {
%>		
                        <th>Action</th>
<%
		}if("3".equals(userType)|| "4".equals(userType)){
%>		
                        <th><%=Expired_L%></th>
<%
		}
%>		
                     </tr>
                  </thead>
                  <tbody>
                     <%
                     	
                        for(int i=0;i<Count;i++)   
                        {
                        	String expStat ="N";
                        	String rfqNum 		= hdrXML.getFieldValueString(i,"ERH_RFQ_NO"); 
                        	String prNo		= checkNull((String)rfqPrHT.get(rfqNum));//hdrXML.getFieldValueString(i, "ERH_PR_NO");
				String prItemNo		= hdrXML.getFieldValueString(i, "ERH_PR_ITEM_NO");
				String prText 		= hdrXML.getFieldValueString(i, "ERH_PR_TEXT");
				String status 		= hdrXML.getFieldValueString(i, "ERH_STATUS"); 
				String createdBy	= hdrXML.getFieldValueString(i, "ERH_CREATED_BY");
				String modBy 		= hdrXML.getFieldValueString(i, "ERH_MODIFIED_BY");
				String validTo 		= hdrXML.getFieldValueString(i, "ERH_VALID_UPTO");
				String quoteBy 		= hdrXML.getFieldValueString(i, "ERH_SAVE_FLG");
				
				String typeRFQ="";
				java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date validDt=sdf.parse(validTo);
				Date todayDT=new Date();
				//out.println("validDt"+validDt+"dddd"+validDt.compareTo(todayDT));
				//out.println(validDt+"validDt");
				String[] refPR 		= prText.split("$");
				String statString="",bckGrdClr="",quoteIndClr="";
				if("2".equals(quoteBy))
					quoteIndClr="orange";
				if("3".equals(quoteBy)|| "4".equals(quoteBy))
					quoteIndClr="#58fb30";  				
				if("P".equals(status))
				{
					statString="To Approve";
					typeRFQ="Act";
					bckGrdClr="#f5b43d";

				}
				if("Y".equals(status) || "S".equals(status))
				{
					statString="Approved";
					bckGrdClr="#2abb1894";
					typeRFQ="Apr";
					
				}
				if("X".equals(status)){statString="Rejected";bckGrdClr="#ef5a618f";typeRFQ="Rej";}
				if("R".equals(status)){statString="Requote";bckGrdClr="#bb981894";typeRFQ="Req";}
				if(("N".equals(status)) && createdBy.equals(modBy)){statString="At Vendor";bckGrdClr="#f1df09ed";typeRFQ="List";}
				if(("Q".equals(status))){statString="Query";bckGrdClr="#fb020275";typeRFQ="Qry";}
				if(("P".equals(status) || "N".equals(status)) && (validDt.compareTo(todayDT)<0)){statString="Expired";bckGrdClr="#bdb7b7ed";typeRFQ="Exp";}
				//out.println("refPR111>>"+refPR);
				
				String rfqDate		= formatDate.getStringFromDate((java.util.Date)hdrXML.getFieldValue(i,"ERH_RFQ_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
                        	String rfqcloseDate	= formatDate.getStringFromDate((java.util.Date)hdrXML.getFieldValue(i,"ERH_VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
                        	String rfqTypeDB	= hdrXML.getFieldValueString(i,"ERH_EXT2");
                        	String collRFQNO	= checkNull(hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO"));
                        	String qcfTitle 	= hdrXML.getFieldValueString(i,"ERH_EXT3");
                        	ezc.ezcommon.EzLog4j.log("** qcfTitle**asdffs*"+qcfTitle,"I");
				if("N".equals(qcfTitle) || qcfTitle == null || qcfTitle.isEmpty()){
					qcfTitle=collRFQNO;
					ezc.ezcommon.EzLog4j.log("** qcfTitle***"+qcfTitle,"I");
				}
                        	//String rfqDesc		= checkNull(rfqListObj.getFieldValueString(i,"ERD_MATERIAL_DESC"));
                        	
                        	java.util.Date tempDate = (java.util.Date)hdrXML.getFieldValue(i,"ERH_VALID_UPTO");
                        	
                        	//SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                        	String prNOIntVal="";
                        	if("RFQ".equals(prNo))prNo="NA";
                        	else
                        	{
                        		if(!"".equals(prNo))
                        		{
                        			if(prNo.split(",").length>1)prNOIntVal=prNo.split(",")[0]+"...";
                        			else
                        			prNOIntVal=prNo;
                        		}	
                        	}
                        	if("RFQ".equals(prItemNo))prNo="NA";
                        	else
                        	{
                        		
                        		if(!"".equals(prItemNo))
                        		{
                        			prItemNo= Long.parseLong(prItemNo)+"";
                        		}
                        		else
                        		{
                        			prItemNo = "";
                        		}
                        			
                        	}	
                        	
                        	
                        	/*
                        	if("".equals(rfqCloseTime) || "null".equals(rfqCloseTime) || rfqCloseTime==null)  
                        		rfqCloseTime="00:00";
				
                        	String tempTime		= today.getHours()+":"+today.getMinutes();
                        	
				SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
				Date d1 = sdf.parse(rfqCloseTime);
				Date d2 = sdf.parse(tempTime);
				long elapsed = d2.getTime() - d1.getTime(); 
				out.println("elapsed"+elapsed);
				if(tempDate.before(today) && elapsed>=0) 
				{
					expStat ="Y"; 
                        	}*/
				if(tempDate.before(today)) 
				{
					expStat ="Y"; 
                        	}                        	
                        	
                        %>	 	
                     <tr style="background-color:<%=bckGrdClr%>;"%>
<%
			if("2".equals(userType))
			{
%>			
                        <td style="background-color:<%=quoteIndClr%>;" align="center"><a href="ezViewRFQDetails.jsp?PurchaseOrder=<%=rfqNum%>&type=<%=typeRFQ%>&rfqType=<%=rfqType%>&EndDate=<%=rfqcloseDate%>&OrderDate=<%=rfqDate%>&expStat=<%=expStat%>"><b><p style="color:#3a3636"><%=rfqNum%></p></b></a></td>
<%
			}else{
%>
			<td align="center"><a href="ezViewRFQDetails.jsp?PurchaseOrder=<%=rfqNum%>&type=<%=typeRFQ%>&rfqType=<%=rfqTypeDB%>&EndDate=<%=rfqcloseDate%>&OrderDate=<%=rfqDate%>&expStat=<%=expStat%>&collRFQNO=<%=collRFQNO%>"><b><p style="color:#3a3636"><%=rfqNum%></p></b></a></td>
<%
			}
%>			
			<!--<td align="center"><%//=rfqDesc%></td>-->
                        <td align="center"><%=collRFQNO%></td>
                        <td align="center"><%=qcfTitle%></td>
                       <td align="center"><a href="#" data-toggle="tooltip" title="<%=prNo%>"><%=prNOIntVal%></a></td>
                       
                        <!--<td align="center"><%=prNo%></td>-->
                        <td align="center"><%=rfqDate%></td>
<%
			String soldList=hdrXML.getFieldValueString(i,"ERH_SOLD_TO");
			String dispSoldTo="";
			try{
					soldList = Long.parseLong(soldList)+""; 
					dispSoldTo=soldList;
					soldList = "0000000000"+soldList;
					soldList = soldList.substring(soldList.length()-10,soldList.length());
				}catch(Exception e){
					dispSoldTo=soldList;	
					}  
%>				
                        
                        <td><%=checkNull((String)gv_VendorsHT.get(soldList))+" ["+dispSoldTo+"]"%></td>
			<!--<td>&nbsp;</td> -->
			<td><%=pGrpHash.get(hdrXML.getFieldValueString(i,"ERH_PUR_GRP"))+"["+hdrXML.getFieldValueString(i,"ERH_PUR_GRP")+"]"%></td>
			<td><%=createdBy%></td>
<%
		if("2".equals(userType) && "Act".equals(type) || "2".equals(userType) && "Req".equals(type)||"2".equals(userType) && "Exp".equals(type)||"2".equals(userType) && "List".equals(type)) {
%>	
			<td> 
			<div class="input-group">		
				<input class="form-control input-sm" type="text"  name="RFQCloseDate<%=i%>" id="RFQCloseDate<%=i%>"  value="<%=formatter.format(tempDate)%>"  readonly>
				<div class="input-group-addon">
				<%=getDateImageFromToday("RFQCloseDate"+i)%>
				</div>
				<label for="RFQCloseDate<%=i%>" class="input-group-addon btn"><span class="glyphicon glyphicon-floppy-disk" onclick="javascript:updateRFQ('<%=rfqNum%>',<%=i%>)"></span></label>	
                    	</div>
                    	</td>
<%
			}else{
%>			
			<td align="center"><%=formatter.format(tempDate)%></td> 
<%
			}
%>			
			<td align="center"><%=statString%></td>
<%
		if("2".equals(userType) && "List".equals(type) || "2".equals(userType) && "Req".equals(type)) {
%>		
                <Td  align="center">
			<a href = "#" onclick="ezReminder('<%=rfqNum%>','<%=typeRFQ%>','<%=rfqType%>','<%=rfqcloseDate%>','<%=rfqDate%>','<%=expStat%>')"> <font color="red"><i class="fa fa-arrow-left" ></i></font></a> 
		</Td> 		
<%
		}if("3".equals(userType)|| "4".equals(userType)){
		
			if("Y".equals(expStat)){
%>                        
                        <td align="center"><font color="red">Yes</td>     
<%
			}
			else
			{
%>
			<td align="center"><font color="green">No</td>
<%
			}
		}
%>		
                        
                     </tr>
                     <%
                        }
                        %>
                  </tbody>
               </table>
               <!--<i class="fa fa-square" style="color:#f5b43d"></i>&nbsp;&nbsp;To Approve-->
               <i class="fa fa-square" style="color:#58fb30"></i>&nbsp;&nbsp;Online
               <i class="fa fa-square" style="color:#30c3fb"></i>&nbsp;&nbsp;Offline
               <i class="fa fa-square" style="color:#f5b43d"></i>&nbsp;&nbsp;To Approve
               <i class="fa fa-square" style="color:#bb981894"></i>&nbsp;&nbsp;Requote
               <i class="fa fa-square" style="color:#2abb1894"></i>&nbsp;&nbsp;Approved
               <i class="fa fa-square" style="color:#ef5a618f"></i>&nbsp;&nbsp;Rejected 
               <i class="fa fa-square" style="color:#bdb7b7ed"></i>&nbsp;&nbsp;Expired 
               <!--<i class="fa fa-square" style="color:#fb020275"></i>&nbsp;&nbsp;Query-->
               <i class="fa fa-square" style="color:#f1df09ed"></i>&nbsp;&nbsp;At Vendor
               
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
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>  

<Div id="MenuSol"></Div>
</body>
</html>
<script type="text/javascript" class="init"> 
   $(document).ready( function () {
       $("#type").val("<%=type%>");
       $("#rfqType").val("<%=rfqType%>");
       $('[data-toggle=tooltip]').tooltip();
       
       table.fnSort([[0,"desc"]])
       
    } );

   
   	function ezSubmit()
   	{
		document.myForm.action = "ezListRFQs.jsp";
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
				url: "../RFQ/ezRemindRFQ.jsp",
				data: { PurchaseOrder:rfqNo,type:type,rfqType:rfqType,EndDate:endDt,OrderDate:ordDt,expStat:stat},
				dataType:"json", 
				type: "POST", 
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

