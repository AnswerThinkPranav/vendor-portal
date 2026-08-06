<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>

<%
	String vendor = request.getParameter("vendor");
	String mobile = request.getParameter("mobile");
	
	if(mobile==null || "null".equals(mobile))mobile="";
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
	otpParams.setMobileNo("9963923812");
	otpParams.setVendor(vendor);
	otpParams.setExt1("");
	otpParams.setExt2("");
	otpParams.setExt3("");

	mainParams.setLocalStore("Y");			
	mainParams.setObject(otpParams);	
	Session.prepareParams(mainParams); 
	
	try{
		 otpManager.ezGenerateOTP(mainParams);
	}catch(Exception e){}
	
	/*String qry="INSERT INTO EZC_SMS_OTP (ESO_USER_ID,ESO_OTP,ESO_OTP_FOR,ESO_MOBILE_NO,ESO_VENDOR,ESO_VALID_FROM,ESO_VALID_TO,ESO_EXT1,ESO_EXT2,ESO_EXT3) VALUES('"+vendor+"','"+otpStr+"','VENDOR_PROFILE_EDIT','9963923812','"+vendor+"',NOW(),NOW() + INTERVAL 15 MINUTE,'','','')" ;

	mainParams = new ezc.ezparam.EzcParams(true);
	EziMiscParams miscParams = new EziMiscParams();
	miscParams.setQuery(qry);
	mainParams.setObject(miscParams);	
	Session.prepareParams(mainParams);

	try{
	miscManager.ezAdd(mainParams);
}catch(Exception e){}*/
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

<h1>Verify OTP</h1>
<br>
<div class="row" style="margin-left:auto">

<%=otp%><br>
OTP has been sent to your mobile
<br>
Please enter the one time password
<BR>
<input type="text" name="otp" value="">
</div>

<div style="visibility:hidden" id="messageId">
<b><font color="red">Please enter valid OTP</font></b>
</div>
<br>
<br>
<div class="row">

	<div class="col-md-5 col-md-offset-7" id="UploadDiv1">
		<a href="javascript:funVerify()" class="btn btn-info" >Verify OTP</a>
		<a href="javascript:funReSend()" class="btn btn-info" >Re-Send OTP</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div>
</div>
</div>
</form>

</body>
</html>

