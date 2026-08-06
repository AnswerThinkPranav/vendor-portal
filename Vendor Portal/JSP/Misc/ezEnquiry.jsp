<%
	String activeSession = (String)session.getValue("ValidVendorUser");
	if(activeSession==null)
		activeSession = (String)session.getValue("ValidAdminUser");
		
	//out.println("activeSession:::"+activeSession);	
	
	try{
		//if("Y".equals(activeSession))
			//response.sendRedirect("ezActiveSessionMsg.jsp");	
	}catch(Exception e){}		
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Coromandel Interntl Ltd.</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="Library/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="Library/dist/css/AdminLTE.min.css">
    <!-- iCheck -->
    <link rel="stylesheet" href="Library/plugins/iCheck/square/blue.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]--> 
    
 
  </head>
 
  <body class="hold-transition login-page" style="background:#8FBC8F !important">
   
    <div class="login-box">
      
      <div class="login-box-body">
       <div class="login-logo">
                  	<img src="coromandel_logo.gif"/>
                    <!--<a href=""><b>The Hackett Group</b></a>-->
      </div><!-- /.login-logo -->
        <form method="POST" name="myForm" action="/CFL/EzCommerce/EzCommon/JSPs/ezApplicationAreas.jsp" onSubmit="return submitForm()">
          <div class="form-group has-feedback">
            <input type="text" class="form-control" placeholder="User Id" name="username">
            <span class="glyphicon glyphicon-user form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback">
            <input type="password" class="form-control" placeholder="Password" name="password">
            <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            <input type="hidden" name="site" value="200">
          </div>
          <div class="row">
            <div class="col-xs-8">
            <a href="ezForgotPassword.jsp">I forgot my password</a><br>
        <a href="ezForgotPassword.jsp">Corporate Enquiry</a><br>
            </div>
            <div class="col-xs-4">
              <button type="button" class="btn btn-primary btn-block btn-flat" onclick="javascript:submitForm()">Sign In</button>
            </div><!-- /.col -->
          </div>
        
      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->
    
    <Div style="top:95%;left:35%">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <strong><font color="white">Copyright &copy; 2017 <a href="http://www.thehackettgroup.com/"><B>The Hackett Group</a>.</strong> All rights reserved.
    </Div>

    <!-- jQuery 2.1.4 -->
    <script src="Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- iCheck -->
    <script src="Library/plugins/iCheck/icheck.min.js"></script>
    <script>
      $(function () {
        $('input').iCheck({
          checkboxClass: 'icheckbox_square-blue',
          radioClass: 'iradio_square-blue',
          increaseArea: '20%' // optional 
        });
      });
      
      document.onkeydown = function (evt) {
        var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
        if (keyCode == 13) {
		if(checkFields())
			submitForm();
        }
        if (keyCode == 27) {
          // For Escape.
          // Your function here.
        } else {
          return true;
        }
};
      
    </script>
    
       <script>
		  function checkFields()
		  {

			if(document.myForm.username.value == '')
			{
				alert("Please enter username");
				document.myForm.username.focus();
				return false;
			}

			if(document.myForm.password.value == '')
			{
				alert("Please enter password");
				document.myForm.password.focus();
				return false;
        		}
			return true;
		  }
		  function submitForm()
		  {
			if(checkFields())
			{
				document.myForm.submit();
				return true;
			}
			else
			{
				return false;
			}
		  }
        </script>
    </form>
    
  </body>  
</html>
