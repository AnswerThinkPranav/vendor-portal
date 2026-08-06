<%
	String popParam = request.getParameter("popParam");
	
	out.println("::::::popParam::::::::::::::"+popParam);
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
      <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
        <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    
    <script>
    function funReSend()
    {
    document.myForm.submit();
    }
    function funConfirm()
    {
  	window.parent.<%=popParam%>;	
    }
  </head>
<body>
<Form name="myForm">

<div class="container" >

<h1>Modified Vendor Details</h1>
<br>
	<div class="row">
	<div class="box">
		<div class="box-body">
		<table class="table" border=1 id="changedData">
			<thead>
			<tr>
			<th>Are </th>
			</tr>
			</thead>
		</table>
		</div>

		<div class="box-footer">
		Any changes made on portal will reflect post verification by company.

			<div class="col-md-5 col-md-offset-7" id="UploadDiv1">
				<a href="javascript:funConfirm()" class="btn btn-info" >Agree</a>
				<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Disagree</a>	
			</div>
		</div>
	</div>
	</div>
</div>
</form>

</body>
</html>

