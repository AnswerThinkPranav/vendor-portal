<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="java.util.*,java.nio.file.*,java.io.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%@ include file="ezGetVendMailId.jsp"%>
<Html>
<Head>
<Script src="../../Library/JavaScript/ezTrim.js" ></script>
<Script>
function funGetData()
{
	var userid=funTrim(document.myForm.userID.value);

	if(userid=="")
	{
		alert("Please Enter User ID");
		document.myForm.userID.focus();
		return;
	}

	document.myForm.action="ezGetVendUserMail.jsp";
	document.myForm.submit();
}
function funMailUpdate()
{
	var contactNum=funTrim(document.myForm.contactNum.value);

	/*if(contactNum=="")
	{
		alert("Please Enter email ID");
		document.myForm.contactNum.focus();
		return;
	}*/
	
	if(contactNum=="")
	{
		alert("Please Enter email ID");
		document.myForm.contactNum.focus();
		return;
	}

	if(confirm("Are sure to update E-Mail?"))
	{
		document.myForm.action="ezVendEMailUpdate.jsp";
		document.myForm.submit();
	}
}
</Script>
</Head>
<style>
.select2-container--default .select2-selection--multiple {
    height: 40px;
    width: 220px;
    border-radius: 0px;
} 
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Vendor Email
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->

<Body scroll=no>
<Form name="myForm" method="post">
<br>
	<Div align="center">
	<br><br>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="40%">
	<Tr>
		<Th align="right" valign="middle">Enter User ID/Vendor Code</Th>
		<Td valign="top">
			<input type="text" class=InputBox name="userID" size="15" value="" maxlength=10>&nbsp;&nbsp;&nbsp;&nbsp;
			<button type="button" class="btn btn-primary pull-right" onclick='funGetData()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
		</Td>
	</Tr>
	</Table>
	<center><Br> <Font color='RED'><B>Enter User Id/Vendor Code and Click on 'GO' button</B></Font></Center>
	<br><br><br><br>
<%
	if(count>0)
	{
%>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="60%">
	<Tr>
		<Th align="left" valign="middle">Vendor User Id : <%=userID%> <Br>[<%=userName%>]
		<input type="hidden" name="userid" value="<%=userID%>"></Th>
		<Td valign="top">
			<input type="text" class=InputBox name="contactNum" size="35" value="<%=contactNum%>">&nbsp;&nbsp;&nbsp;&nbsp;
			<button type="button" class="btn btn-primary pull-right" onclick='funMailUpdate()' style="margin-right: 5px;">Update <i class="fa fa-paper-plane"></i></button>
		</Td>
	</Tr>
	</Table>
	<center><Br> <Font color='RED'><B>Enter E-Mail and Click on 'Update' button. Use comma (,) if multiple ids present.</B></Font></Center>
<%
	}
	else if(retObj!=null && count==0)
	{
%>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="40%">
	<Tr>
		<Th>Given user ID doesn't exist</Th>
	</Tr>
	</Table>
<%
	}
	else
	{
%>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="40%">
	<Tr>
		<Th>Enter User ID and Click on Go Button</Th>
	</Tr>
	</Table>
	</Div>
<%
	}
%>	
</Form>	
</Body>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezFooter.jsp"%>
