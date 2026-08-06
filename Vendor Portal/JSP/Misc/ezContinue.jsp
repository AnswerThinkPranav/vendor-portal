
<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
    <title>Coromandel Interntl Ltd.</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="Library/css/bootstrap.min.css">
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
        
     <style>
     .my-error-class {
         float:none;
         color:red;
         padding-left: .5em;
         padding-top: .2em;
        vertical-align: top; 
    }
    body { 
      
        background-repeat: no-repeat;
        background-attachment: fixed;
        background-position: center; 
        background-size: cover;
            overflow-y: -webkit-paged-x;
}
.login-logo
{
	font-size:20px;
	text-align:center;
	margin-bottom:45px;
	font-weight:300;
}
 </style> 
<script>
	 function funContinue()
	 {
	 	document.myForm.action="/CFL/EzCommerce/EzCommon/JSPs/ezApplicationAreas.jsp";
	 	document.myForm.submit();
 }
</script>

  </head> 
 <!-- <body class="hold-transition login-page" style="background:#8FBC8F !important">-->
  <body  scroll=no>
 
 <center><h4><font color="red">Note:Please read complete text and click on "Continue" button.</font></h4></center>

 <!--<marquee><p><b><font color='white' size="4">Please do NOT open multiple sessions/use multiple browsers to submit invoices. It will result in delayed payment.</font></b></p></marquee>-->
 
   <div class="login-box">      
     <div class="login-box-body" style="width:800px;margin-left:300px;background-color:lightgrey;">
	<div class="login-logo" style="padding-top:10px;">
		<img src="coromandel_logo.gif"/>
		
	</div> 
        <form method="POST" name="myForm" id="myForm" style="margin-bottom: 0px;"> 
	<b><p><font color="black">Dear Sir/Madam,</p> <br>
 
<p>Thank you for using the services of our Vendor Portal www.vendors.coromandel.biz extensively. As part of “Digital” journey, we at Coromandel have built this portal to better manage our network of suppliers, provide current status of your transactions, collect digital documents and keep track of your balances. Appreciate your ongoing support and patronage of this service.
</p>
<p>We have embarked on a journey to migrate onto a latest ERP platform i.e. SAP S/4 HANA. This is a huge project which will have positive impact on our day to day transactions and our management information systems. Our project will go-live in the first week of November 2019. This would require some preparatory activities and support from you. 
</p>
<p>Due to this migration, we would be making a few changes in the Vendor Portal enabled processes – </p>

<ul>
	<li>Please note that services like Invoice submission, PO acknowledgement will not be active from <font color="#ff571a">22-Oct-2019 to 10-Nov-2019; </font></li>
	<li>During this period, please contact your respective Buyer Teams/Divisional Offices in Coromandel to provide the Purchase Order number(s) before submitting the invoices by “Courier” to our Shared Service Centre at the below mentioned address - </li>
<p><font color="#ff571a">Shared Service Centre</font></p>
<p>Coromandel International Limited, </p>
<p>Ground Floor, Administrative Block, Sriharipuram, Malkapuram Post</p>
<p>Visakhapatnam, Andhra Pradesh – 530011</p>

</li>
	<li>Please ensure to download all relevant/requisite data by <font color="#ff571a">31-Oct-2019</font> since <ul>historical data</ul> will <ul>not</ul> be available from <font color="#ff571a">01-Nov-2019</font> onwards </li>
</ul>
 
<p>With this communication, we intend to provide answers to the frequently asked questions – ></p>
 
<ol>
	<li>Till what date is the vendor portal accessible for invoice submission? – <font color="#ff571a">22nd Oct 2019</font> </li>
	<li>Can I submit invoices on vendor portal after 22nd October 2019? – <font color="#ff571a">No. From 22-Oct-2019 to 10-Nov-19 invoices cannot be submitted through vendor portal</font> </li>
	<li>How should I submit invoices between the period 22-Oct-2019 to 10-Nov2019? – <font color="#ff571a">Invoices needs to be couriered to SSC Vizag at the above mentioned address</font> </li>
        <li>Will my Vendor Portal user id change after 10th November? – <font color="#ff571a">No. User Id will remain the same </font></li>
        <li>Can we submit invoices dated prior to 01-Nov-2019 on the vendor portal? – <font color="#ff571a">No. Those original hard copy invoices need to be couriered to SSC at the above-mentioned address</font></li>
        <li>Will data for the period prior to 01-Nov-2019 be available for view/download? - <font color="#ff571a">No </font></li>
        <li>Can we download account statement during the period 22-Oct-2019 to 10Nov-2019? – <font color="#ff571a">Yes. Account statement can be downloaded between 22-Oct2019 & 31-Oct-2019</font></li>
        <li>Can we have access to the previous period records [account statement etc]? – <font color="#ff571a">Previous period data will not be available from 01-Nov-2019 </font></li>
       	<li>Can we have access to any of the Self services? - <font color="#ff571a">YES </font></li>
       	<li>Whom should we contact to know the status of the invoices submitted via couriers? – <font color="#ff571a">SSC AP Helpdesk - <ul>aphelpdesk@coromandel.murugappa.com</ul></font> </li>
</ol>
<p>Hope we have addressed majority of the questions you may have. Please feel free to reach out to us on  <font color="#ff571a"><ul>aphelpdesk@coromandel.murugappa.com</ul></font> for any queries and clarifications.</p>
 
<p>We are making best of our efforts to ensure that there will be no disturbance on our transactions due to this migration. Sincerely thank your support in advance. </p>
 
<p>Thanks & regards, </p><br>
 
<p>Coromandel SSC Team </font></p></b>
		
		
          </div> 
          	<Div id="ButtonDiv" align="center">
					<button type="button" class="btn btn-primary" onclick="javascript:funContinue()" style="width: 70px;height: 25px;padding-left: 5px;background-color:#3c8dbc;border-color:##367fa9">Continue</button>
		</div>
          
      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->    
    <input type="hidden" name="site" value="200">
    <input type="hidden" name="username" value="<%=username%>">
    <input type="hidden" name="password" value="<%=password%>">
</form>
    
  </body>  
<!-- jQuery 2.1.4 -->
<script src="Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<!-- Bootstrap 3.3.5 -->
<script src="Library/bootstrap/js/bootstrap.min.js"></script>
<!-- iCheck -->
<script src="Library/plugins/iCheck/icheck.min.js"></script>
<script src="EzCommerce/EzCFL/Vendor2/Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="EzCommerce/EzCFL/Vendor2/Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>

<%@ include file="../Misc/AddMessage.jsp" %>
	
</html>
