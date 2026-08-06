<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>	

 <%	
	String tempVendCode = request.getParameter("tempVendCode");
	String venRegAuth = request.getParameter("venRegAuth");
	String rfqAuth = request.getParameter("rfqAuth");
	
	//out.println(":::::tempVendCode::::::::"+tempVendCode);
	//out.println(":::::venRegAuth::::::::"+venRegAuth);
	//out.println(":::::rfqAuth::::::::"+rfqAuth);	
	
	 ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
     	 EziMiscParams miscParams		= new EziMiscParams();
	
	miscParams.setQuery("UPDATE EZC_USER_DEFAULTS SET EUD_VALUE = '"+rfqAuth+"' where EUD_KEY = 'ALLOW_RFQ' AND EUD_USER_ID = '"+tempVendCode+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
		ezMiscManager.ezUpdate(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}		
	
	miscParams.setQuery("UPDATE EZC_USER_DEFAULTS SET EUD_VALUE = '"+venRegAuth+"' where EUD_KEY = 'ALLOW_REG' AND EUD_USER_ID = '"+tempVendCode+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
		ezMiscManager.ezUpdate(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}	

%>
<html>
<head>
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/font-awesome.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/ionicons.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-yellow.min.css">
<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
</head>
</head>
<body scroll=no>
<form name="myForm" method="post">
<div class="container" >
<h6>Successfully Updated</h6>
<Br><Br><Br>
<div class="row">
	<div class="col-md-5 col-xs-offset-5" id="UploadDiv1">		
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Ok</a>		
	</div>	
</div>
</div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 

