<%@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iPassword_Labels.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iPassword.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<html>   
<head>  
<%
	minPassLen_L = "Password Length should be 10-20 Characters";
	passOneNum_L = "Password should be Alpha Numeric";
	String splChar_L	= "Password should contain special character.";
	String upper_L		= "Password should contain Upper case letter.";
	passOneCaps_L		= "Password should contain Upper case letter.";
	
	//String fromMenu = request.getParameter("fromMenu");
	String fromMenu = "Y";
%>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script language="JavaScript">
var userid 		= '<%=((String)Session.getUserId()).toUpperCase()%>'
var passCantBeUsid_L 	= '<%=passCantBeUsid_L%>';
var minPassLen_L 	= '<%=minPassLen_L%>';
var passSplChar_L 	= '<%=passSplChar_L%>';
var passOneNum_L 	= '<%=passOneNum_L%>';
var passOneCaps_L 	= '<%=passOneCaps_L%>';
var passSHNotPrev_L 	= '<%=passSHNotPrev_L%>';
function fun1(){
	var pword = '<%=mypwd%>';
	if (pword !=''){
		document.forms[0].password1.focus();
	}
	else{
		document.forms[0].oldpasswd.focus();
	}
}


function clearPasswordFields()
{
	document.forms[0].elements['password1'].value=""
	document.forms[0].elements['password2'].value=""
	document.forms[0].elements['password1'].focus
}

function passContinue()
{
	top.document.location.href="../Misc/ezSelectSoldTo.jsp";	

}

function VerifyEmptyFields() 
{
	
	specChrsStr = "~!@#$%^&*()";
	numChrsStr = "0123456789";
	alphaChrsStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	
	password1 = document.forms[0].elements['password1'].value;
	
	var passwordLength = password1.length
	var checkContinue = true
	if(password1.toUpperCase() == userid)
	{
		alert(passCantBeUsid_L);
		checkContinue = false
	}	
	
	if((passwordLength < 10 || passwordLength > 20) && checkContinue)
	{
		alert(minPassLen_L);
		checkContinue = false
	}
	
	if(!checkContinue)
	{
		clearPasswordFields()
		return false;
	}
	
	
	if(password1!="")
	{

		var nLoop=0;
		var nLength=password1.length;
		sFlag = false;
		nFlag = false;
		aFlag = false;

		
		for(nLoop=0;nLoop<nLength;nLoop++)
		{
			pChar=password1.charAt(nLoop);
			if (specChrsStr.indexOf(pChar)>0)
			{
				sFlag = true;
				break;
			}
		}
		if(!sFlag)
		{
			alert("Please enter atleast one special character like "+specChrsStr);
			clearPasswordFields()
			document.forms[0].password1.focus();
			document.returnValue = false;
			return false;
		}
		

		for(nLoop=0;nLoop<nLength;nLoop++)
		{
			pChar=password1.charAt(nLoop);
			if (numChrsStr.indexOf(pChar)!=-1)
			{
				nFlag = true;
				break;
			}
		}

		if(nFlag == false)
		{
			alert(passOneNum_L);
			clearPasswordFields()
			document.forms[0].password1.focus();
			document.returnValue = false;
			return false;
		}

		
		for(nLoop=0;nLoop<nLength;nLoop++)
		{
			pChar=password1.charAt(nLoop);
			if (alphaChrsStr.indexOf(pChar)!=-1)
			{
				aFlag = true;
				//alert(aFlag);
				break;
			}
		}

		if(aFlag == false)
		{
			alert(passOneCaps_L);
			clearPasswordFields()
			document.forms[0].password1.focus();
			document.returnValue = false;
			return false;
		}
		
	}

	if (document.forms[0].oldpasswd.value == "" || document.forms[0].password1.value == "" || document.forms[0].password2.value == "" ){
		alert("<%=plzOldNewPwds_A%>");
		clearPasswordFields()
		document.returnValue = false;
	}else{
		y=confirmNewpasswd();
		if(eval(y)){
			setMessageVisible();
			document.password.submit();
			document.returnValue = true;
		}else{
			document.returnValue = false;
			return false;
		}
	}

	setMessageVisible();
	document.password.submit();
	document.returnValue = true;
}

function confirmNewpasswd() {
	passwd1 = document.forms[0].elements['password1'].value;
	passwd2 = document.forms[0].elements['password2'].value;
	if (passwd1 != passwd2) {
		alert("<%=newOldNotSame_A%>");
		document.returnValue = false;
		return false
	}else{
		return true;
		document.returnValue = true;
	}
}

function setAction(){
	document.forms[0].action = "../Misc/ezPassword.jsp";
	document.forms[0].submit();
}
function ezBack(event)
{
	document.location.href = event;
}
function quit()
{
	document.password.target = "_parent";
	document.password.action = "../Misc/ezLogout.jsp";
	document.password.submit();
}
function setMessageVisible()
	{
		var divVal = document.getElementById("ButtonDiv");
		if(divVal == null)
		 	alert("divVal is null !!!!");
		else
		divVal.style.visibility="hidden";
		document.getElementById("EzButtonsMsg").style.visibility="visible";
	}
</script>

<title><%=changePwd_L%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>
<body scroll=no>
<form method="post" action="../Misc/ezSavePassword.jsp" name="password" id="password">
<input type=hidden name="fromMenu" value='<%=fromMenu%>'>

<%
	//String str=request.getParameter("Flag");
	String str="Y";
	String updtFlag=request.getParameter("updtFlag");
	
	if(updtFlag==null)
		updtFlag = "";
	
	if (str!=null){
		out.println("<input type=hidden name=Flag value=X>");
	}
%>
	<input type=hidden name="updtFlag" value="<%=updtFlag%>">

  <%
  	String display_header = changePwd_L;
  %>	 
  
<%//@ include file="../Misc/ezSubHeader.jsp"%> 
<%
	  String trBGColor = "Bgcolor=\"#f39c12\"  style=\"color:black\"";
	  String altRowColor = "style=\"background-color:#c9e0ff\""; 
%> 
	
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
 <!-- Content Wrapper. Contains page content -->
 <div class="content-wrapper">
 <!-- Content Header (Page header) -->
 <section class="content-header">
    <h5>
       <B> <%=display_header%> </B>
       <!--<small>Optional description</small>-->
    </h5>
       <ol class="breadcrumb">
        <!-- <li class="active">Reports</li>-->
       </ol>
 </section>	
 <section class="content">
    <div class="row">
    <!-- left column -->
    <div class="col-sd-8 col-xs-8 col-xs-offset-2">
       <!-- general form elements -->
 
 		<div class="box box-primary">
 		         <div class="box-header with-border">
 		            <!--<h3 class="box-title">Leaves</h3>-->
		            </div><!-- /.box-header -->	
<BR>


		

    <div class="login-box" style="width:40%;background-color:white">
    	 <div class="login-logo"><img src="../../../../../EzcLogin/header-logo.png" height="55px"/></div>
    	 
    	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	 &nbsp;&nbsp;<b>Change Password</b><BR>
    		<div style="width:100%;background-color:white">
    		<div><BR>
		    				
    			</div>
    			
    			<table class="table table-bordered" style="width:100%"> 
    				
    			
		 <tr> <th><b>Current Password </b></th>
			<Td style="text-align:center">

				  <input type="password" tabindex=1 name="oldpasswd"  class="Inputbox"  style="width:100%" size="10" maxlength="20"  value="<%=mypwd%>" >
				</td>
			      </tr>
			      <tr> 
			      <th><b>New Password </b></th>
				<Td style="text-align:center">

				  <input type="password" class="Inputbox" tabindex=2 name="password1" size="10"  style="width:100%"  maxlength="20" >
				</td>
			      </tr>
			      <tr> 
			      <th><b>Confirm Password </b></th>
				<Td style="text-align:center">

				  <input type="password" class="Inputbox" tabindex=3 name="password2" size="10" maxlength="20"  style="width:100%" >
				</td>
		<tr>
			<Td style="background:#ffffff" colspan=2 width=100%><font color="#FF0000" size=2>
			<ul>
				<li><nobr><%=upper_L%></nobr></li><br>
				<li><nobr><%=minPassLen_L%></nobr></li><br>
				<li><nobr><%=passOneNum_L%></nobr></li><br>
				<li><nobr><%=splChar_L%></nobr></li>
			</ul>

		</td>
	      </tr>   			
    			</Table>
    			
    			<Div id="ButtonDiv" align="center">
			    <br>
			    
			    <button type="button" class="btn btn-primary" onclick="VerifyEmptyFields()">Submit</button>  &nbsp;
    <button type="button" class="btn btn-primary" onclick="javascript:document.password.reset()">Clear</button>  &nbsp;
    </div>
    		</div><!-- /.login-box-body -->
    	</div><!-- /.login-box -->
</div>
<%
	if(!"Y".equals(fromMenu))
	{
%>
	    <button type="button" class="btn btn-primary" onclick="quit()">Cancel</button>  &nbsp;
<%
	}
	String offline = (String)session.getValue("OFFLINE");
	if("Y".equals(offline))
	{
%>
   		 <button type="button" class="btn btn-primary" onclick="ezBack('../Misc/ezOfflineLogout.jsp')">Logout</button>  &nbsp;
<%
	}
%>	
<input type="hidden" name="ErrFlag" size="5" value="<%=error%>">
<input type="hidden" name="oldPswd" value="<%=oldPwd%>">
</br>
</div>
<a href="ezSelectSoldTo.jsp">.</a>



<SCRIPT language="JavaScript">

$(document).ready(function(){
	$(function() { 	
	

		$("#password").validate({
				onfocusout: function (element, event) {		       
				$(element).valid();				
		},
			
			errorClass: "my-error-class",
					errorPlacement: function(error, element) {
					    if (element.attr("name") == "termc" )
					        error.insertAfter(".errorTxt");
					    else
					        error.insertAfter(element);
		},
			
			rules: {
				password1: {
					required: true,
					pwcheck:true,
					password: true
				},
				password2: {
					required: true,					
					password: true,
					equalTo : "#password1"
				}
				
			},
			messages: {
				password1: {
					required: "You can't leave this empty",
					password:"You can't leave this empty"
				},
				password2: {
					required: "You can't leave this empty",
					password:"You can't leave this empty"
				}
			}
		});
	});
	
});

</SCRIPT>
<%@ include file="../Misc/AddMessage.jsp" %>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>