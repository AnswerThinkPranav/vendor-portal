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

<h1>Terms and Conditions</h1>
<br>
	<div class="row">
	<div class="box">
		<div class="box-body">
		<p>	Once you have registered to use the Website, completed the Vendor Portal Set-up Form, and
			ABCR has approved your participation in the Vendor Portal, ABCR will authorize ACS to issue to
			Vendor usernames and passwords (“User Names and Passwords”). Vendor may distribute such
			user names and passwords to its Employees, Factors and other agents whom it has authorized to
			transact business on the Website on behalf of Vendor Individuals who have been given a user
			name and password by Vendor are referred to herein as “Authorized Users.” It is the
			responsibility of the Vendor to inform ABCR if there are any changes to Vendor’s Authorize
			Users. Removal of Authorized Users is effective upon ABCR’s deactivation of the applicable
			passwords. Vendor, through its Authorized Users, may inquire on invoices status and upload
			invoice data. By uploading invoice data, Vendor warrants the accuracy of such data and agrees
			the uploaded invoices are valid and not duplicates. Uploaded invoices may be changed by
			writing to ABCR. Any invoices uploaded through Website by Authorized Users shall be binding
			upon Vendor and subject to review and approval by ABCR. ABCR is not responsible for any
			errors or unauthorized postings or transactions by Vendor and/or its Authorized Users. Vendor is
			responsible for maintaining the confidentiality of usernames and passwords. Vendor shall be
			responsible for all uses of its usernames and passwords, whether or not authorized by Vendor.
			Vendor must immediately notify ABCR if Vendor becomes aware of any unauthorized use of its
			usernames and passwords or the Website. 
		</p>
		</div>

		<div class="box-footer">
			<div class="col-xs-12 col-md-12 col-md-offset-5 col-xs-offset-6 " id="UploadDiv1">				
				<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >OK</a>	
			</div>
		</div>
	</div>
	</div>
</div>
</form>

</body>
</html>

