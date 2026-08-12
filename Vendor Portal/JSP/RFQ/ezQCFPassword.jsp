<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>
<%@ page import="java.net.*,java.net.URL,ezc.vendorprofile.params.*,ezc.ezparam.*,java.io.*,java.util.*" %>		

<%
 	String v_User_Id	= (String)Session.getUserId();//(String)session.getValue("EZC_PORTAL_USER_ID");
 	String email 	= (String)session.getValue("EMAIL_ID");
 	String site     = request.getParameter("site");
 	String fileName = request.getParameter("fileName");
 	String qcfQote = request.getParameter("qcfQote");
 	 	
 	 	//out.println(v_User_Id+"::::::v_User_Id::::::");
 	if(site==null || "null".equals(site))
 		site = "200";
 		
	String query	= "";
 	String msgSubject = ""; 
	String eMailData = "";
	
	String userId 		= "";
	String passWd 		= "";
	String toEMailIds 	= "";		
	String ccEMailIds 	= "";		
	String firstName 	= "";
	String middleName 	= "";
	String lastName 	= "";	
	String mobile	 	= "";
	
	
	ezc.ezcommon.EzLog4j.log(":::::email:::::"+email,"D");
	ezc.ezcommon.EzLog4j.log(":::::site:::::"+site,"D");	
%>
<%@ include file="../Misc/ezSendExternalMail.jsp"%>
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
    <script>
    function funReSend()
    {
    document.myForm.submit();
    }
    function funVerify()
    {
   // alert("hi");
   var qcfQote='<%=qcfQote%>';
   
       var xmlhttp;
        if (window.XMLHttpRequest)
          {// code for IE7+, Firefox, Chrome, Opera, Safari
          xmlhttp=new XMLHttpRequest();
          }
        else
          {// code for IE6, IE5
          xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
          }
        xmlhttp.onreadystatechange=function()
          {
          if (xmlhttp.readyState==4 && xmlhttp.status==200)
            {
          //  alert((xmlhttp.responseText).split("$")[1]);
            	if((xmlhttp.responseText).split("$")[1]=="true")
            	{
            	//alert("if");
            	//alert("qcfQote"+qcfQote);
			if((qcfQote==null)||(qcfQote=='')||(qcfQote=='null'))
			{
				
				window.parent.funSubmit();
			}
			else{
			window.parent.document.myForm.qcfQote.value=qcfQote;
				window.parent.funSubmit();
			}
            		
            	}else{
            //	alert("else");
			//alert("Please enter valid OTP");
			document.getElementById("messageId").style.visibility="visible";
			document.myForm.otp.value="";
			document.myForm.otp.focus();
			return;
            	}
            }
          }
        xmlhttp.open("GET","../Misc/ezVerifyOTP.jsp?otp="+document.myForm.otp.value+"&vendor="+document.myForm.vendor.value,true);
    xmlhttp.send();
    	
    }
    </script>
  </head>
  <body >
<Form name="myForm">
<input type="hidden" name="vendor" value="<%=v_User_Id%>">
<input type="hidden" name="mobile" value="<%=mobile%>">
<div class="container" >

<center>
<h3>Verify Password</h3>

<div class="row" >
<h6>Please enter the password</h6>
<input type="text"  name="otp" value="" autofocus>
</div>

<div style="visibility:hidden" id="messageId">
<b><font color="red">Please enter valid Password</font></b>
</div>
<br>

<div class="row">

	<div class="col-xs-11 col-xs-offset-1 " id="UploadDiv1">
		<a href="javascript:funVerify()" class="btn btn-info" >Verify Password</a>		
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div>
</div>
</center>
</div>
</form>

</body>
</html>

