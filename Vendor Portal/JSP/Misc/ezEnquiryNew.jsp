<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="iVendorDetails.jsp" %>
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="esManager" class="ezc.client.EzSystemConfigManager" scope="session"/>


<%	
	ReturnObjFromRetrieve retsyskey=null;
	int sysRows = 0;	
	String sys_key = null;
	EzcSysConfigParams sparams = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams = new EzcSysConfigNKParams();
	snkparams.setLanguage("EN");
	sparams.setObject(snkparams);
	Session.prepareParams(sparams);
	try{
		retsyskey = (ReturnObjFromRetrieve)esManager.getPurchaseAreas(sparams);
		sysRows = retsyskey.getRowCount();
	}catch(Exception e){}
%>
<%
try{
session.removeValue("ATTACHEDFILES");
}catch(Exception e){}
%>
<%@ include file="ezHeader.jsp"%> 
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
    <form method="post"  name="myForm" id="myForm">
    
	<div class="login-box" style="width:40%;background-color:white">
	 <div class="login-logo"><img src="coromandel_logo.gif"/></div>
		<div style="width:100%;background-color:white">
		
			<table class="table table-bordered" style="width:100%"> 
			<tr>
				<th colspan="2" style="text-align:center">Enquiry</th>
			</tr>
			<tr>
			<th colspan="2" style="text-align:center">
 		<%
 	             if ( sysRows > 0 )
	      	{
	      		//out.println("orglist::"+orgList_V);
	      %>
	              <select name="SystemKey" name="SystemKey" style="width:47%" id=FullListBox >
	              	<option value="">-----------Select Location-----------</option>
		<%
			retsyskey.sort(new String[]{"ESKD_SYS_KEY_DESC"},true);
			for ( int i = 0 ; i < sysRows ; i++ )
			{
				String val = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY"));
				String checkFlag = (String)retsyskey.getFieldValue(i,"ESKD_SUPP_CUST_FLAG");
				String syskeyDesc = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY_DESC"));				
				//String descCode = syskeyDesc.substring(syskeyDesc.length()-5,syskeyDesc.length()-1);
				
				//if(!orgList_V.contains(descCode)) continue;
				
				val = val.toUpperCase();
				val = val.trim();
		%>
				<option value="<%=val%>"><%=syskeyDesc%></option>
		<%
			}
		%>	
			</select>
		<%
		}
		%>	
		</th>
		</tr>
			<tr>
				<th align="right" width="40%">Name</th>
				<Td colspan="4" >
				<Input  type="text"   name="name1" id="name1" value=""  style="width:400px"  maxlength="35">
				</Td>
			</tr>
			<tr>
				<th align="right" width="40%">City/Town</th>
				<Td colspan="4" >
				<Input  type="text"   name="city" id="city" value=""  style="width:400px"  maxlength="35">
				</Td>
			</tr>
			<tr>
				<th align="right" width="40%">State</th>
				<Td colspan="4" >
					<select  name="state" id="state">
					<option value="" ><--------Select state-------></option>
					<%
					for (int i=0;i<StateCnt;i++) 
					{
						 statekey = retState.getFieldValueString(i,"EMKV_VALUE");
						  statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
				
					%>
							<option value="<%=statekey%>"><%=statevalue%>--<%=statekey%></option>
					<%
						
					}
					%>
					</select>				
				</Td>
			</tr>
			<tr>	
				<th align="right" width="40%">EMail</th>
				<Td colspan="4" >
				<Input  type="text"   name="email" id="email" value=""  style="width:400px"  maxlength="240">
				</Td>
			</tr>
			<tr>
				<th align="right" width="40%">Landline</th>
				<Td colspan="4">
				<Input  type="text"   name="landline" id="landline" value=""  maxlength="16">
				</Td>			
			</tr>	
			<tr>
				<th align="right" width="40%">Mobile</th>
				<Td colspan="4" >
				<Input  type="text"   name="mobile" id="mobile" value=""  style="width:400px"  maxlength="16">
				</Td>
			</tr>
			<tr>
				<th align="right" width="40%">Comments</th>      			
				<td>
				<div class="input-group">
					<textarea class="form-control" style="width: 400px;" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
				</div>
				</td>    			
			</tr>
			
			
			<tr>
				<th align="center" colspan=2>
					<table class="table table-bordered" style="width:40%"> 
					<Tr>
					 <div class="col-md-6 col-md-offset-3 col-xs-12 ">
						<button type="button" class="btn btn-primary btn-block btn-flat" onclick="javascript:submitForm()">Submit</button></div>
					</tr>	
					</table>
				</th>    			
			</tr>
			
			</Table>
		</div><!-- /.login-box-body -->
	</div><!-- /.login-box -->
</div>
    
    <Div style="top:95%;left:35%" class="col-md-6  col-xs-12 ">
           
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
			var name1  	= document.myForm.name1.value;			
			var city  	= document.myForm.city.value;
			//var state  	= document.myForm.state.value;
			var email  	= document.myForm.email.value;
			var landline  	= document.myForm.landline.value;
			var mobile  	= document.myForm.mobile.value;			
			var SystemKey  	= document.myForm.SystemKey.value;
			
			document.myForm.action="ezSaveVendorDetails.jsp";
				document.myForm.submit();
		  }
        </script>
<!--<input type="hidden" name="vendCode" id="vendCode" value="1" />
<input type="hidden" name="bankKey" id="bankKey" value="1"/>
<input type="hidden" name="attachFlag" value ="N" >
<input type="hidden" name="attachDocDesc" value ="" >	
<input type="hidden" name="attachFileTime" value ="" >	
<input type="hidden" name="attachDocFiles" value ="" >	
<input type="hidden" name="attachType" value ="" >-->
<input type="hidden" name="vendType" id="vendType" value="NEW" />
    </form>
    
  </body>  
</html>
<%//@ include file="ezFooter.jsp"%> 