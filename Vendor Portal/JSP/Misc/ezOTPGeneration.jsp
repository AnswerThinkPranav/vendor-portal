<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>
<%@ page import="java.net.*,java.net.URL,ezc.vendorprofile.params.*,ezc.ezparam.*,java.io.*,java.util.*" %>		

<%
	String vendor = request.getParameter("vendor");
	String mobile = request.getParameter("mobile");
	
	if(mobile==null || "null".equals(mobile))mobile="";
	
	mobile=mobile.trim();
	//if("".equals(mobile))
	//mobile="9700504168";
	try{
	vendor=Integer.parseInt(vendor)+"";
	}catch(Exception e){}
	String numbers = "0123456789";

	Random rndm_method = new Random();

	char[] otp = new char[6];

	for (int i = 0; i < 6; i++)
	{
	    otp[i] =
	     numbers.charAt(rndm_method.nextInt(numbers.length()));
	}

String otpStr=String.valueOf(otp);
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	EziOTPParams otpParams = new EziOTPParams();

	otpParams.setUserId(vendor);
	otpParams.setOtp(otpStr);
	otpParams.setOtpFor("VENDOR_PROFILE_EDIT");
	otpParams.setMobileNo(mobile);
	otpParams.setVendor(vendor);
	otpParams.setExt1("");
	otpParams.setExt2("");
	otpParams.setExt3("");

	mainParams.setLocalStore("Y");			
	mainParams.setObject(otpParams);	
	Session.prepareParams(mainParams); 
	
	try{
		 otpManager.ezGenerateOTP(mainParams);
		 
		 try{
		 	//String smsText=otpStr+" is the One Time Password (OTP) to edit vendor profile";	
		 	String smsText="One Time Password for your profile changes at Vendor Portal is "+otpStr+". Do not share it with anyone";
		 	
			String mURL = "http://api.smscountry.com/SMSCwebservice_bulk.aspx?User=retailcoromandel&passwd=gromor&mobilenumber="+mobile+"&message="+URLEncoder.encode(smsText, "UTF-8")+"&sid=GROMOR&mtype=N&DR=N";

			ezc.ezcommon.EzLog4j.log("mURL::"+mURL,"I");

			URL url = new URL(mURL);
			HttpURLConnection uc = (HttpURLConnection)url.openConnection();
			ezc.ezcommon.EzLog4j.log(uc.getResponseMessage(),"I");
			uc.disconnect();
		 
		 	}catch(Exception e)
		 	{
		 		//out.println(":::::::Exception ::::::::::::"+e);
		 		ezc.ezcommon.EzLog4j.log("::::Exception occured while sending OTP:::::::"+e,"E");
			}
	}catch(Exception e){}
	
	
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
    <script>
    function funReSend()
    {
    document.myForm.submit();
    }
    function funVerify()
    {
   // alert("hi");
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
            		window.parent.funSubmit();
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
        xmlhttp.open("GET","ezVerifyOTP.jsp?vendor=<%=vendor%>&otp="+document.myForm.otp.value,true);
    xmlhttp.send();
    	
    }
    </script>
  </head>
  <body >
<Form name="myForm">
<input type="hidden" name="vendor" value="<%=vendor%>">
<input type="hidden" name="mobile" value="<%=mobile%>">
<div class="container" >
<center>
<h1> Verify OTP</h1>

<div class="row" >

OTP has been sent to your mobile
<br>
Please enter the one time password
<BR>
<input type="text"  name="otp" value="" autofocus>
</div>

<div style="visibility:hidden" id="messageId">
<b><font color="red">Please enter valid OTP</font></b>
</div>
</center>
<br>

<div class="row">

	<div class="col-md-5 col-md-offset-7 col-xs-offset-1" id="UploadDiv1">
		<a href="javascript:funVerify()" class="btn btn-info" >Verify OTP</a>
		<a href="javascript:funReSend()" class="btn btn-info" >Re-Send OTP</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div>
</div>
</div>
</form>

</body>
</html>

