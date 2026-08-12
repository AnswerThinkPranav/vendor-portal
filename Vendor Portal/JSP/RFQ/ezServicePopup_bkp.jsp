<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<%@ page import="java.io.*,java.util.*,java.math.*" %>
<%@page import="java.sql.*" %>
<%@ page import="ezc.ezcommon.*,java.text.*,ezc.ezparam.*" %>
<%//@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>   
        
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
    <!--<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.1.2/css/fixedHeader.dataTables.min.css">-->
    <!-- Font Awesome -->
    <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">-->
    <!-- Ionicons -->
    <!--<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">-->
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <!--<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/fuzzycomplete.css">-->
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/iCheck/all.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<!--<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">-->
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
 
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
  		if(value==null || "null".equals(value.trim()))value="";   		
  		return value.trim();
  	}  					  
  %>   
  <% 
  		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String req=checkNull(request.getParameter("req"));
		String item=checkNull(request.getParameter("item"));
		String pckgNo=checkNull(request.getParameter("pckgNo"));
		
		ezc.ezparam.ReturnObjFromRetrieve sesServObj= (ezc.ezparam.ReturnObjFromRetrieve)session.getValue("SERVOBJ");
		ezc.ezcommon.EzLog4j.log("sesServObj:::::::::::::::"+sesServObj.toEzcString(),"I");
		
		int retObjCount=0;
		if(sesServObj!=null)
			retObjCount= sesServObj.getRowCount();		
		
		
		
		
		
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
  	<!--<link type="text/css" href="library/jquery-ui-1.10.4/css/ui-lightness/jquery-ui-1.10.4.custom.css" rel="stylesheet" media="screen">  
  	<link type="text/css" href="library/css/menu.css" rel="stylesheet" media="all">
  	<link type="text/css" href="library/css/ezcui.css" rel="stylesheet" media="all">
  	<link type="text/css" href="library/css/ezprint.css" rel="stylesheet" media="print">
  	<link type="text/css" href="library/css/font-awesome.css" rel="stylesheet" media="all">  
  	<link type="text/css" href="library/css/flipscroll.css" rel="stylesheet" media="all">
  	<link type="text/css" href="library/css/jquery.dataTables.css" rel="stylesheet" media="all">
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  	<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>-->
  </head>	
  <Script type="text/javascript" src="../Common/JavaScript/ezTrim.js"></Script>
  <!--datatables css-->
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
 <!-- Content Wrapper. Contains page content -->
 <style>

</style>
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="220" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<form method="post" name="myForm">
    <div class="container">
        <div class="row">
            <div>
               <span style="color:rgba(219, 143, 29, 0.808);">
		<h4><B>Service(s) for PR :<span style="color:cornflowerblue;"><%=req%></span> with Item :<span style="color:cornflowerblue;"> <%=Long.parseLong(item)%></span></B></h4>
		</span>
             </div>
         </div>
         <div class="row">
         <div>
	 	<div class="box box-primary">
	  		<div class="box-body">
 				  <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
               				<tbody>
						<tr>
							<th>Line</th>
							<th>Service No</th>
							<th>Short Text</th>
							<!--<th>Service Text</th>
							<th>Line Text</th> -->
							<th>Quantity</th>
							<th>UOM</th>
							<th>Gross price</th>
							<!--<th>Currency</th>-->
							<th>Net Value</th>
							
						</tr>
<%
		String  servText="",lineText="";
		for(int i=0;i<retObjCount;i++)
		{	
			String servActive="";
			String lineActive="";
			
			servText=checkNull(sesServObj.getFieldValueString(i,"SERVITEMTXT"));
			ezc.ezcommon.EzLog4j.log("servText:::::::::::::::"+servText,"I");
			servText = servText.replaceAll("'","`");
			servText = servText.replaceAll("\"", "`");
			servText = servText.replaceAll("$", "");
			servText = servText.replaceAll("&", "?");
			servText = servText.replaceAll("<", "&lt;");
			servText = servText.replaceAll("#", "");
			servText = servText.replaceAll("\\(", "");
			servText = servText.replaceAll("\\)", "");
			servText = servText.replaceAll("=", "");			
			servText = servText.trim();
			
			lineText=checkNull(sesServObj.getFieldValueString(i,"SERVLINETXT"));
			lineText = lineText.replaceAll("'","`");
			lineText = lineText.replaceAll("\"", "`");
			lineText = lineText.replaceAll("$", "");
			lineText = lineText.replaceAll("&", "?");
			lineText = lineText.replaceAll("<", "&lt;");
			lineText = lineText.replaceAll("#", "");
			lineText = lineText.replaceAll("\\(", "");
			lineText = lineText.replaceAll("\\)", "");
			lineText = lineText.replaceAll("=", ""); 
			lineText = lineText.trim();			

			
			servActive="color:blue";
			lineActive="color:blue";
			
			if(servText!=null && !"null".equals(servText) && !"".equals(servText) && servText!="")
				servActive="color:orange";
				
			if(lineText!=null && !"null".equals(lineText) && !"".equals(lineText) && lineText!="")
				lineActive="color:orange";
				
			if(pckgNo.equals(sesServObj.getFieldValueString(i,"SERVPCKGNO")))
			{
			
				String servLine = Integer.parseInt(sesServObj.getFieldValueString(i,"EXTLINE"))+"";
				String servAct  = (sesServObj.getFieldValueString(i,"SERVACT"))+"";
				String serUOM  = (sesServObj.getFieldValueString(i,"SERVUOM"))+"";
				if("LE".equals(serUOM))
					serUOM = "AU";
%>			
			
						<tr>
							<td align="center"><%=servLine%></td>
							<td align="center"><%=servAct%></td>
							<td align="center"><%=sesServObj.getFieldValueString(i,"SERVTXT")%></td>
							<!--<td align="center"><a href="javascript:openItemDet('<%=servAct%>','<%=servLine%>','<%=servAct%>','<%=servText%>','S')"> <span style="<%=servActive%>" class="glyphicon glyphicon-new-window"></span> </a></td> 
							<td align="center"><a href="javascript:openItemDet('<%=servAct%>','<%=servLine%>','<%=servAct%>','<%=lineText%>','S')"> <span style="<%=lineActive%>" class="glyphicon glyphicon-new-window"></span> </a></td> -->
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"SERVQTY")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
							<td align="center"><%=serUOM%></td>
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"GRPRICE")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
							
							<!--<td><%=sesServObj.getFieldValueString(i,"SERVUOM")%></td>-->
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"NETVAL")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
						</tr>
<%
			}
		}
%>		
						
					</tbody>
				</table>
			</div>
               	</div>	
            </div>
        </div>
        <div class="row" align="right" >
            <button type="button" class="btn btn-primary" onclick="funClose()">CLOSE</button>
          
        </div>
    </div>
</form>  
 
      
 
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
   
           window.parent.$('#woModal1').modal('hide');
           window.parent.$('#woModal2').modal('hide');
           parent.$.fancybox.close();
   }
   function openItemDet(req,item,mat,text,type)
   { 
   	var url="ezItemTextPopup.jsp?req="+req+"&item="+item+"&mat="+mat+"&text="+text+"&type="+type;      

		$('iframe').attr("src",url);
		

		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"        
  		});   		
   
   }    
   </script>
</body>
</html>
	