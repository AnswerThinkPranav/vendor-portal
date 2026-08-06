<%
	  String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	  String trBGColorH = "Bgcolor=\"#ded6d6\"  style=\"color:black\"";
	  String altRowColor = "style=\"background-color:#c4c9d8\""; 
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
<!--<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">-->
 <!-- Content Wrapper. Contains page content -->
 <div class="content-wrapper">
 <!-- Content Header (Page header) -->
 <section class="content-header">
    <h5>
       <B> <%=display_header%> </B>
       <!--<small>Optional description</small>-->
    </h5>
       <ol class="breadcrumb">
        <!-- <li class="active">Reports</li>-->
       </ol>
 </section>	
 <section class="content">
    <div class="row">
    <!-- left column -->
    <div class="col-sd-12 col-xs-12">
       <!-- general form elements -->
 
 		<div class="box box-primary" style="padding-bottom: 20px;">
 		         <div class="box-header with-border">
 		            <!--<h3 class="box-title">Leaves</h3>-->
		            </div><!-- /.box-header -->	
		<style>
		#example_wrapper{padding-left: 10px;padding-right: 10px;padding-top: 10px;}
		</style>