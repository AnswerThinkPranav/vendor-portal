<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>
<%@ page import="java.net.*,java.net.URL,ezc.vendorprofile.params.*,ezc.ezparam.*,java.io.*,java.util.*" %>	



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
    function funVerify()
    {
  	window.parent.funAgree();  	
    }
    function funLoad()
    {
    var changedValues=window.parent.document.myForm.changedValues.value
    
    var changedValuesArr = changedValues.split("##");
    var trHTML='';
    for(var i=0; i<changedValuesArr.length; i++)
    {
    	
	     trHTML += 
		'<tr><td >'+changedValuesArr[i].split("$$")[0]+
		'</td><td>'+changedValuesArr[i].split("$$")[1]+
		'</td></tr>';
    }
		$('#changedData').append(trHTML);
    }
    </script>
  </head>
  <body onLoad="funLoad()">
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
			<th style="text-align:center;background-color: #f39c12 !important">Field</th>
			<th style="text-align:center;background-color: #f39c12 !important">Changed Value</th>
			</tr>
			</thead>
		</table>
		</div>

		<div class="box-footer">
		Any changes made on portal will reflect post verification by company.

			<div class="col-md-5 col-md-offset-7" id="UploadDiv1">
				<a href="javascript:funVerify()" class="btn btn-info" >Agree</a>
				<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Disagree</a>	
			</div>
		</div>
	</div>
	</div>
</div>
</form>

</body>
</html>

