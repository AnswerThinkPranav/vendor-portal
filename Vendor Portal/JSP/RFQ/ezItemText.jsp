<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*"%>
<%
	String itemtext=request.getParameter("itemtext");
	itemtext=itemtext.replaceAll(",", " ");

%>
<!DOCTYPE html>
<html lang="en">
  <head>
 <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/ionicons.min.css">
    
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-yellow.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
     <script src="../../Library/JavaScript/ezTrim.js"></script>
     <style>
     th{
     background-color: '#252320 !important'
     }
 </style>
 </head>
<body >
<Form name="myForm" ENCTYPE="multipart/form-data" method="POST" >

<div class="container" >
<br />
<div class="row" id="UploadDiv">
	<div class="span10 offset1">
<TABLE width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >

		
			
				<tr  style="height: 14px;background-color:black;color:white">
					<th>ITEM TEXT</th>
				</tr>	
			
		<tr>
			<Td ><textarea rows=4 cols=100 name="itemtext" value="<%=itemtext%>" style="font-size: medium;"><%=itemtext%></textarea></Td>

		</tr>   
			
		
</table>
	</div>
</div>

<div class="row">

	<center><div class="span3 offset5" id="UploadDiv1">
		
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Close</a>
	</div></center>	
</div>
	


</form>
 <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    
  


</body>
</html>

