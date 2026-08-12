<%@ page import = "ezc.session.EzLogonStructure" %>
<%@ page import = "ezc.ezparam.EzLogonStatus" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<%@ page import="java.io.*,java.util.*" %>
<%@page import="java.sql.*" %>
<%@ page import="ezc.ezcommon.*,java.text.*,ezc.ezparam.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>   
        
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>Ceat</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.1.2/css/fixedHeader.dataTables.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/fuzzycomplete.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/iCheck/all.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/pace/pacetopline.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">	
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
	.tx 
	{ 
		    border:0px;
	}
	th
	{
		    background-color: #3c8dbc;
		    color:white;
	}
	button
	{
		margin-left:2px;
	}
</style>
    
  <%!
  	public String checkNull(String value){
  		if(value==null || "null".equals(value.trim()))value="0.00";   		
  		return value.trim();
  	}  					  
  %>   
  <% 
  		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String req=checkNull(request.getParameter("req"));
		String item=checkNull(request.getParameter("item"));
		String mat=checkNull(request.getParameter("mat"));
		String text=checkNull(request.getParameter("text")).trim();
		String type=checkNull(request.getParameter("type"));
		
		
  %>
  <html>
  <head>
      	<title>Supplier Acknowledgement</title>
      	<meta charset="utf-8">    			
          <meta http-equiv="X-UA-Compatible" content="IE=edge">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <meta name="description" content="">
          <meta name="author" content="">
          <link rel="shortcut icon" href="favicon.ico"> 
  	<!-- Bootstrap -->
  	<link type="text/css" href="library/css/bootstrap.css" rel="stylesheet" media="all">  
  <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
      <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">
  	<link type="text/css" href="library/jquery-ui-1.10.4/css/ui-lightness/jquery-ui-1.10.4.custom.css" rel="stylesheet" media="screen">  
  	<link type="text/css" href="library/css/menu.css" rel="stylesheet" media="all">
  	<link type="text/css" href="library/css/ezcui.css" rel="stylesheet" media="all">
  	<link type="text/css" href="library/css/ezprint.css" rel="stylesheet" media="print">
  	<link type="text/css" href="library/css/font-awesome.css" rel="stylesheet" media="all">  
  	<link type="text/css" href="library/css/flipscroll.css" rel="stylesheet" media="all">
  	  <link type="text/css" href="library/css/jquery.dataTables.css" rel="stylesheet" media="all">
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
  </head>	
  <Script type="text/javascript" src="../Common/JavaScript/ezTrim.js"></Script>
  <!--datatables css-->
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
 <!-- Content Wrapper. Contains page content -->
 <style>
 body,html{
   overflow:hidden
}
</style>
<form method="post" name="myForm">
    <div class="container" style="margin-left:20px;">
        <div class="row">
            <div>
                <span style="color:rgba(219, 143, 29, 0.808);">
                <%if("0.00".equals(req) ||  "0.00".equals(item))
                {
                	if("I".equals(type))
                	{
%>
                		<h4><B>  Item Text of Material:<span style="color:cornflowerblue;"><%=Long.parseLong(mat)%></span></B></h4>
<%	
			}
			else
			{
%>
				<h4><B>  Material PO Text of Material:<span style="color:cornflowerblue;"><%=Long.parseLong(mat)%></span></B></h4>			
<%
			}
		}
                else
                {
                	if("I".equals(type))
                	{
%>		
				<h4><B>Item Text for PR NO:<span style="color:cornflowerblue;"><%=req%></span> Item NO:<span style="color:cornflowerblue;"> <%=Long.parseLong(item)%></span>  Material:<span style="color:cornflowerblue;"><%=mat%></span></B></h4>
<%
			}
			else if("P".equals(type))
			{
%>		
			<h4><B>Material PO Text for PR NO:<span style="color:cornflowerblue;"><%=req%></span> Item NO:<span style="color:cornflowerblue;"> <%=Long.parseLong(item)%></span>  Material:<span style="color:cornflowerblue;"><%=mat%></span></B></h4>
<%
			}
		}
%>
                </span>
             </div>
         </div>
         <div class="row">
         <div class="col-md-12 col-xs-24">
	 	<div class="box box-primary">
	  		<div class="box-body">
 				  <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
               
				  
				   <tbody>
				 	
				   	<tr>
					<td>
					<textarea style="width:100%;align-content:center;" readonly><%=text%></textarea>
					</td>
					</tr>
				 
				   </tbody>
				</table>
               		</div>
               	</div>	
            </div>
        </div>
        <div class="row" align="right">
            <button type="button" class="btn btn-primary" onclick="funClose()">CLOSE</button>
          
        </div>
    </div>
</form>  
 
      
 
  
     <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
     <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/iCheck/icheck.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/fuse/dist/fuse.js"></script>
     <script src="../../../../EzCommon/Library/dist/js/fuzzycomplete.js"></script>
      
     <!-- Bootstrap 3.3.5 -->
     <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
     <!-- AdminLTE App --> 
     <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
     <script src="../../../../EzCommon/Library/js/alert_confirm.js?2"></script>
     <script src="../../../../EzCommon/Library/dist/js/app.min.js?2"></script>
 	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
 	<!--<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>-->
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
 	<!--datatables download -->
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/dataTables.buttons.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.flash.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/jszip.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/vfs_fonts.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.html5.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.print.min.js"></script>	
 
 	<!--end-->
 	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
     
          <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
          <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
  <script>
  $(document).ready( function () {
  	   	
  	       $('#example').dataTable( {
  	       "order":[[4,"desc"]],
  	       "bInfo": false,
  	       "bPaginate": false,
  	       "bAutoWidth": false ,
  	   	"lengthMenu": [[10, 20, -1], [10, 20, 'All']]
  	      
  	   	
  	   	
  	       } );
   } );
   function funClose()
   {
   
           window.parent.$('#woModal').modal('hide');
           window.parent.$('#woModal1').modal('hide');
           parent.$.fancybox.close();
}
   </script>
</body>
</html>
	