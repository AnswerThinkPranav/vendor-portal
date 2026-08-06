<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%@include file="../../../Includes/JSPs/Misc/iListWebStats.jsp"%>               
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
			<Td>
				<label for="venType">Type</label>  
			</Td>			

			<Td>	
				  <div class="input-group">
					 <select class="form-control input-sm" name="type" id="type">

						<option value="ALL" selected>All</option>
						<option value="INU">Internal</option>
						<option value="EXT">Business</option>						


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
                        <th>User Id</th> 
                        <th>User Name</th> 
                        <th>IP</th> 
                        <th>Logged In</th>
                        <th>Logged Out</th>
                     </tr>
                  </thead>
                  <tbody>
<%

		ezc.ezutil.FormatDate fd1 = new ezc.ezutil.FormatDate();		
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			
		String userId="",userName = "",userIp="";
		String loggedIn = "";
		String loggedOut = "";
		String loggedInTime = "";
		String loggedOutTime = "";
		
		for(int i=0;i<Count;i++)   
		{
			userId 	 = retWebStats.getFieldValueString(i,"EWS_USER_ID"); 
			userName = retWebStats.getFieldValueString(i,"EU_FIRST_NAME");
			userIp   = retWebStats.getFieldValueString(i,"EWS_IP");
%>	 	
			<tr>
				<td align="center"><%=userId%></td>
				<td align="center"><%=userName%></td>
				<td align="left"><%=userIp%></td>
				<td align="left"><span style="display:none"><%=retWebStats.getFieldValue(i,"EWS_LOGGED_IN")%></span><%=sdf.format((Date)retWebStats.getFieldValue(i,"EWS_LOGGED_IN"))%></td>
				<td align="left"><%=sdf.format((Date)retWebStats.getFieldValue(i,"EWS_LOGGED_OUT"))%></td>
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
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>  
<Div id="MenuSol"></Div>
</body>
</html>
<script type="text/javascript" class="init"> 
	$(document).ready( function () {
	$("#type").val("<%=type%>");
	$('[data-toggle=tooltip]').tooltip();
	table.fnSort([[3,"desc"]])
	} );
	function ezSubmit()
   	{
		document.myForm.action = "ezListWebStats.jsp"; 
		document.myForm.submit();
	}

	
	$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});

</script>

