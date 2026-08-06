<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /><jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%
	EzcParams mainParams = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	
	String contactNum=request.getParameter("contactNum");
	String userid=request.getParameter("userid");
	contactNum = contactNum.trim();
	userid = userid.trim();
	
	boolean updateSuccess = true;

	if(userid!=null && !"null".equals(userid) && !"".equals(userid))
	{
		//miscParams.setQuery("UPDATE EZC_USERS SET EU_CONTACT_NO='"+contactNum+"' WHERE EU_ID='"+userid+"'");
		miscParams.setQuery("UPDATE EZC_USERS SET EU_EMAIL='"+contactNum+"' WHERE EU_ID='"+userid+"' AND EU_TYPE='3'");
		
		out.println("::miscParams.setQuery::"+miscParams.getQuery());
		
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);	
		try 
		{
			ezMiscManager.ezUpdate(mainParams);
		}
		catch(Exception e)
		{
			updateSuccess = false;
		}
	}
%>
<Html>
<Head>
<Script>
function funOk()
{
	document.myForm.action="ezGetVendUserMail.jsp";
	document.myForm.submit();
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
      Confirmation
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
<input type="hidden" name="userID" value="<%=userid%>">
<br>
	<br><br><br><br>
<%
	if(updateSuccess)
	{
%>
		<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="40%">
		<Tr>
			<Th>EMail is updated successfully<Br>
				User Id : <%=userid%><Br>
				EMail : <%=contactNum%><Br>
			</Th>
		</Tr>
		</Table>
<%
	}
	else
	{
%>
		<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="40%">
		<Tr>
			<Th>Problem occurred while updating EMail</Th>
		</Tr>
		</Table>
<%
	}
%>	
<center>
	<button type="button" class="btn btn-primary pull-center" onclick='funOk()' style="margin-right: 5px;">Ok <i class="fa fa-paper-plane"></i></button>
</center>	
</Form>	
</Body>
</Html>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezFooter.jsp"%>
