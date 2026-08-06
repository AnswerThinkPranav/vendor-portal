<%@ include file="../../../Includes/Lib/DateFunctions.jsp"%>
<%@ page import = "java.text.*"%> 
<%@ page import = "java.util.Date"%>  
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<Html>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<Head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<%
	int dateRange = 90;
	String fromDate                = request.getParameter("FromDate");
	String toDate                  = request.getParameter("ToDate");
	String cat                     = request.getParameter("cat");
	
	/*Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fromDate);
	DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); 
        fromDate = formatter.format(date1);
        
        Date date2=new SimpleDateFormat("dd/MM/yyyy").parse(toDate);	
        toDate = formatter.format(date2);
	*/
	
	
%>

	<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%>
<style>
{
		headerParams.setQryStr(" DATE(EDH_CREATED_ON) BETWEEN STR_TO_DATE('"+fromDate+"','%d/%m/%Y') AND STR_TO_DATE('"+toDate+"','%d/%m/%Y')");
		
		if(!"ALL".equals(selVendor))
		headerParams.setQryStr("EDH_VENDOR IN('"+selVendor+"') AND DATE(EDH_CREATED_ON) BETWEEN STR_TO_DATE('"+fromDate+"','%d/%m/%Y') AND STR_TO_DATE('"+toDate+"','%d/%m/%Y')");
}
.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
input
{
	    border: none;
}

.my-error-class {
    float:none;
    color:red;
    display: block;
    padding-left: .5em;
   vertical-align: top; 
}

</style>


</Head>

<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
      <section class="content-header">
        <!-- Content Header (Page header) -->
  <h5>
	     <B> Query</B>
	      <!--<small>Optional description</small>--> 
   </h5>
   </section>
<section class="content">
   <form method="post" action="" name='myForm' id='myForm'>
      <div class="row">
      <div class="col-md-6 col-md-offset-3 col-xs-12 ">
      <div class="box box-primary">
        

   <%String Name = (String)session.getValue("EZC_PORTAL_USER_ID");  %>
     <%		
     	ReturnObjFromRetrieve retQuery	=  null;
     	int    QueryCnt	=  0;
     	try
     	{
     		soldTo = Integer.parseInt(soldTo)+"";
     	}catch(Exception e){}
     	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
     	EziMiscParams miscParams		= new EziMiscParams();
     	
     	if(cat!=null)
     	{
		Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fromDate);
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); 
		fromDate = formatter.format(date1);
		Date date2=new SimpleDateFormat("dd/MM/yyyy").parse(toDate);	
		toDate = formatter.format(date2);
        
     		miscParams.setQuery("select * from ezc_partner_queries where EPQ_POSTED_BY='"+soldTo+"'and EPQ_TYPE='"+cat+"'and EPQ_POSTED_ON between '"+fromDate+" 00:00:01'and '"+toDate+" 23:59:59'");	
     	}
     	else
     	{
     		miscParams.setQuery("select * from ezc_partner_queries where EPQ_POSTED_BY='"+soldTo+"'");
     	
     	}
     	mainParams.setLocalStore("Y");
     	mainParams.setObject(miscParams);
     	Session.prepareParams(mainParams);
     	try
     	{		
     		retQuery=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
     	}
     	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
     	if(retQuery!=null)
     		QueryCnt=retQuery.getRowCount();     			
%>
         
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
               <table class="table table-bordered"> 
                 <!--<th colspan="2" width="50%">Query</th>-->
                 <td colspan="2"></td>
               <tr>
			<th align="right">Category</th>
			<td><select name="category" id="category" style="width: 400px;">
				<option value="">----------------------------------Select Category---------------------------</option>
				<option value="PO">PO</option>
				<option value="invoice">Invoice</option>
				<option value="Payment">Payment</option>
				<option value="ASN">ASN</option>
				<option value="Profile">Profile</option>
				<option value="RFQ">RFQ</option>
				<option value="Others">Others</option>
				
      			</select></td>
      			
			
      		</tr>
      		<tr>
      		</table>
      		 <table class="table table-bordered"> 
      		 <tr>
      		<th align="left">Query</th> 
      		</tr>
      		<tr>
      			<td><div class="input-group">
			 <textarea class="form-control"style="width: 500px;" rows="5" placeholder="Enter Query" name="comment" id="comment"></textarea>
			  
		 </div>
     			</td>    			
      			
      		</tr>
      		
      		
      		
		</Table>
          
             
               
                 </div></div></div> 
                

        <!-- Main content -->  
        
       
  
<div class="col-xs-12 col-xs-offset-5 col-md-12 col-md-offset-5" >

     <!--<button type="button" class="btn btn-primary" onclick="funUpload()">Upload Docs</button>-->
    <button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
   

 </div>
<div class="col-xs-12 col-md-12 >
<p>Note:Explain the query in detail and provide relevant details/inputs to us  for better and faster resolutions.</p>
 </div>
</div>



 
<% 	
 	
 	if(QueryCnt>0)
   	{
	
	String display_header ="";	
		display_header = "Query List";
%>
<%
	  String trBGColor = "Bgcolor=\"#f39c12\"  style=\"color:black\"";
	  String altRowColor = "style=\"background-color:#c9e0ff\""; 
%> 
<Script>
	function setMessageVisible()
	{
		var divVal = document.getElementById("ButtonDiv");
		if(divVal == null)
		 	alert("divVal is null !!!!");
		else
		divVal.style.visibility="hidden";
		document.getElementById("EzButtonsMsg").style.visibility="visible";
	}
</Script>	

       <h5>
             <B> <%=display_header%> </B>
             <!--<small>Optional description</small>-->
    </h5>
      <div class="box box-primary">
      <div class="box-body table-responsive no-padding">
      
	 <%//@ include file="../Misc/ezSubHeader.jsp"%> 			    
 	<Table border="1" align="center" valign=middle width="95%" cellpadding=0 cellspacing=0 class=welcomecell>
 	<Tr>
 		<Th style="width:10%" <%=trBGColor%>>
 			From Date&nbsp;&nbsp;
 		</Th>
 		<Td>
 			<!--<input type=text class=inputbox value="<%=fromDate%>"  style="width:70%" id="FromDate" name="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>-->
 			 <input class="form-control input-sm" type="text"  name="FromDate" id="FromDate"  >
		 </Td>
		 <Td>
 			 <!--<label for="FromDate" class="input-group-addon btn"><span class="glyphicon glyphicon-calendar"></span></label> -->
 			 <label for="FromDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
 		</Td>
 		 
 		<Th  style="width:10%" <%=trBGColor%>>
 			&nbsp;&nbsp;&nbsp;&nbsp;To Date&nbsp;&nbsp;
 		</Th>
 		<Td>
 			<!--<input type=text class=inputbox value="<%=toDate%>" name="ToDate" style="width:70%" id="ToDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>-->
 			<input class="form-control input-sm" type="text"  name="ToDate" id="ToDate"  >
 		</Td>	
 		<Td>
		  	<!--<label for="ToDate" class="input-group-addon btn"><span class="glyphicon glyphicon-calendar"></span></label>  -->
		  	<label for="ToDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label> 
 		</Td>
 		<Th <%=trBGColor%>>
 			&nbsp;&nbsp;&nbsp;&nbsp;Category&nbsp;&nbsp;
 		</Th>
 		<td>
 		<select name="cat" id="cat" width="100%"> 		
 		<option value="PO">PO</option>
		<option value="PRICE">Price</option>
		<option value="Quantity">Quantity</option>
		<option value="Other">Other</option> 		
 		</select>
 		</td>           
 		<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='10%' align=right>
 			<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand;width:30%" border="none" onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
 		</Td>-->
 		<Td onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
			<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
		</Td>
 	</Tr>
 
	</Table>             
	<table id="" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		<Tr <%=trBGColor%>>
			<Th width="6%" filter="false">Id</Th>
			<Th width="10%" filter="false">Catagory</Th>
			<Th width="20%" filter="false">Query</Th>
			<!--<Th width="8%" filter-type='ddl'>Posted By</Th>-->
			<Th width="8%" filter="false">Posted On</Th>						
			<Th width="8%" filter="false">Status</Th>
		</Tr>
		</thead>
		
		<tbody>   
	<%
		for (int i=0;i<QueryCnt;i++) 
		{
	%>	   <Tr>			
			<Td width="6%" align="center"><%=retQuery.getFieldValueString(i,"EPQ_ID")%></Td>
			<Td width="10%" align="left"><%=retQuery.getFieldValueString(i,"EPQ_TYPE")%></Td>
			<Td width="20%" align="center"><%=retQuery.getFieldValueString(i,"EPQ_QUERY")%></Td>
			<!--<Td width="8%" align="center"><%=retQuery.getFieldValueString(i,"EPQ_POSTED_BY")%></Td>-->
			<Td width="8%" align="center"><%=retQuery.getFieldValueString(i,"EPQ_STATUS")%></Td>
		  </tr>
	<%
		}
	%>

		</tbody>
	</Table>
        </div>
     </div>
<%
	}
%>
	<input type="hidden" name="cat" id="cat">
  </form>
  </Body>
  </section>
</div>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
  
 <script type="text/javascript">
 function funGo()
 {
var FromDate=document.myForm.FromDate.value;
if(FromDate.lastIndexOf("-")!=-1)
FromDate=FromDate.substring(8,10)+"/"+FromDate.substring(5,7)+"/"+FromDate.substring(0,4);
var ToDate=document.myForm.ToDate.value; 
if(ToDate.lastIndexOf("-")!=-1)
ToDate=ToDate.substring(8,10)+"/"+ToDate.substring(5,7)+"/"+ToDate.substring(0,4);
var cat=document.myForm.cat.value;
//alert(FromDate+":::"+ToDate+"<>"+cat);
document.myForm.action="ezVendorQuery.jsp?ToDate="+ToDate+"&FromDate="+FromDate;
 document.myForm.submit();
}
 function funSubmit()
 {
   var category	=document.myForm.category.value;
 
 	if (!$("#myForm").valid()) 
 	{
 		
 		return false;
	}
	else
	{
	document.myForm.action="ezSaveVendorQuery.jsp";
	document.myForm.submit();
	}
	
 }
 $(document).ready(function(){
	
 	$(function() { 
 	
 		  $.validator.addMethod("catv", function() {
		    return $('#category').val() != "";
			}, 'Please select category');
 		
 		$("#myForm").validate({
 			onfocusout: function (element) {
 				$(element).valid();
 			},
 			
 			errorClass: "my-error-class",
 			
 			rules: {
 				
 				
 				comment: {
					required: true,
					maxlength: 1000
				},
				category: {
					catv: true					
				}
 			},
 			messages: {
 				
 				
 				comment: {
				 	required: "Please Enter comments",				 	
				 	maxlength: "maxlength is 1000 characters"
 				}
 			}
 		});
 	});
 	 
});
</script>

</html>
<%//@ include file="../Misc/ezSubFooter.jsp"%>

<%@ include file="../Misc/ezFooter1.jsp"%>

 
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
$(document).ready(function() {
		
       $("#FromDate").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
              	changeMonth: true,
          	changeYear: true
       });
        $("#ToDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy',
                     	changeMonth: true,
          		changeYear: true
       });
 });
  
</script>