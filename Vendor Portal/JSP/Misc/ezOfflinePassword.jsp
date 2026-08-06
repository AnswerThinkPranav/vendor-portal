<%@ include file="/EzCommerce/EzVendor/Vendor2/Library/Globals/errorPagePath.jsp"%>
<%@ include file="/EzCommerce/EzVendor/Includes/Jsps/Labels/iPassword_Labels.jsp" %>
<%@ include file="/EzCommerce/EzVendor/Includes/Jsps/Misc/iPassword.jsp"%>

<html>   
<head>  

<script language="JavaScript">
var userid = '<%=((String)Session.getUserId()).toUpperCase()%>'
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
		alert("Password cannot be same as your userid");
		checkContinue = false
	}	
	
	if(passwordLength < 8 && checkContinue)
	{
		alert("Minimum password length 8 charactes");
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
			if (specChrsStr.indexOf(pChar)!=-1)
			{
				sFlag = true;
				break;
			}
		}
		if(sFlag == false)
		{
			alert("Password should have atleast one special character e.g. ~!@#$%^&*()");
			//document.forms[0].password1.value = "";
			//document.forms[0].password2.value = "";
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
			alert("Password should have atleast one Numeric");
			//document.forms[0].password1.value = "";
			//document.forms[0].password2.value = "";
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
				break;
			}
		}

		if(aFlag == false)
		{
			alert("Password should have atleast one alphabet in capital letter");
			//document.forms[0].password1.value = "";
			//document.forms[0].password2.value = "";
			clearPasswordFields()
			document.forms[0].password1.focus();
			document.returnValue = false;
			return false;
		}
		
		/*var oldPswds=document.forms[0].oldPswd;
		if(oldPswds!=null){
			var oldVal=oldPswds.value;
			if(oldVal!=""){
				
				var oldValArr=oldVal.split("¥");
				var len=oldValArr.length;
				if(len>5){
					for(i=len-5;i<len;i++){
						if(password1!=oldValArr[i]){
							alert("Password enterd should not equals previous enterd 5 passwords");
							document.forms[0].password1.focus();
							return;
						}
					}
				}else{
					for(i=0;i<len;i++){
						if(password1==oldValArr[i]){
							alert("Password enterd should not equals previous enterd 5 passwords");
							document.forms[0].password1.focus();
							return;
						}
					}
				}
				
			}
			
		}*/


	}

	if (document.forms[0].oldpasswd.value == "" || document.forms[0].password1.value == "" || document.forms[0].password2.value == "" ){
		alert("<%=plzOldNewPwds_A%>");
		clearPasswordFields()
		document.returnValue = false;
	}else{
		y=confirmNewpasswd();
		if(eval(y)){
			document.password.submit();
			document.returnValue = true;
		}else{
			document.returnValue = false;
			return false;
		}
	}

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
</script>

<title><%=changePwd_L%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ include file="/EzCommerce/EzVendor/Includes/Lib/AddButtonDir.jsp" %>
</head>
<body onLoad="fun1()">
<form method="post" action="/EzCommerce/EzVendor/Misc/ezSavePassword.jsp" name="password">

<%
	String str=request.getParameter("Flag");
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
  
<%//@ include file="ezDisplayHeader.jsp"%>

<div align="center"> 
<Table id="header" width="100%" border="0" cellspacing="0" cellpadding="0">
	<Tr class=trclass>
		<Td colspan=2 width=100%><font color="#FF0000" size=1>
		<ul>
			<li>Password cannot be same as your userid</li>
			<li>Minimum password length 8 charactes</li>
			<li>Password should have atleast one alphabet in capital letter</li>
			<li>Password should have atleast one character from ~!@#$%^&*()</li>
			<li>Password should have atleast one number</li>
		</ul>
		</font></Td>
	</Tr>
</Table>
</div>

<div align="center" style='position:absolute;top:40%;width:100%'> 
<TABLE width="35%" align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=1 >
      <tr> 
        <th width="45%" align="left"><%=currPwd_L%></th>
        <td valign="top" width="55%"> 
          <input type="password" tabindex=1 name="oldpasswd"  class="Inputbox"  style="width:100%" size="10" maxlength="16" onChange="setAction()" value="<%=mypwd%>" >
        </td>
      </tr>
      <tr> 
        <th width="45%" align="left"><%=newPwd_L%></th>
        <td width="55%" valign="top"> 
          <input type="password" class="Inputbox" tabindex=2 name="password1" size="10"  style="width:100%"  maxlength="16" >
        </td>
      </tr>
      <tr> 
        <th width="45%" align="left"><%=confPwd_L%></th>
        <td width="55%" valign="top"> 
          <input type="password" class="Inputbox" tabindex=3 name="password2" size="10" maxlength="16"  style="width:100%" >
        </td>
      </tr>
    </table>

    <div align="center"><br>
   
      <img src="../../Images/Buttons/<%=ButtonDir%>/submit.gif" tabindex=4 border="none" style="cursor:hand" onClick="VerifyEmptyFields()">
      <img style="cursor:hand" border=none src="../../Images/Buttons/ENGLISH/GREEN/clear.gif" onClick="javascript:reset()">
<%
	String offline = (String)session.getValue("OFFLINE");
	if("Y".equals(offline))
	{
%>
		<a href="../Misc/ezOfflineLogout.jsp" target="_top"><img src="../../Images/Buttons/<%=ButtonDir%>/logout_butt.gif" alt="Logout" border=none></a>
<%
	}
%>
      <input type="hidden" name="ErrFlag" size="5" value="<%=error%>">
</div>
	<input type="hidden" name="oldPswd" value="<%=oldPwd%>">
    </form>
  <SCRIPT language="JavaScript">
<!--
	errorFlag = document.forms[0].elements['ErrFlag'].value;
	//alert(errorFlag);
	if (errorFlag == "E" ){
		alert("<%=wrongPwd_L%>");
		document.forms[0].elements['oldpasswd'].focus();
	} else {
		if (errorFlag == "S") {
			document.forms[0].elements['password1'].focus();
		}else{
			if (errorFlag == "W") {
				document.forms[0].elements['oldpasswd'].focus();
			} else {
				document.forms[0].elements['password1'].focus();
			}
		}//end if
	}//end if
-->
</SCRIPT>
</div>
<Div id="MenuSol">
</Div>	
</body>
</html>