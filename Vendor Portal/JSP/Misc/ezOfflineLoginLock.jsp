

<html>
	<Script>
		function funBack()
		{
			document.myForm.action = "/EzCommerce/EzVendor/EzRanbaxyVendor/EzMisc/JSPs/ezVendorLogin.jsp";
			document.myForm.submit();
		}
	</Script>
<head>
</head>
<title>User blocked </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
</head>

<body bgcolor="#FFFFF7">
<form name="myForm">
<br><br><br><br><br><br><br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">

  <tr>
    <td align="center"><font face="Trebuchet MS" size="5" color="#990000"><font face="Rockwell">Your User Id has been blocked please contact your administrator</font></font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  </table>
        <br><br>
<%  
    butNames.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Close&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");  
    butActions.add("window.close()");
    out.println(getButtons(butNames,butActions));	
%>
</form>
</body>
</html>
