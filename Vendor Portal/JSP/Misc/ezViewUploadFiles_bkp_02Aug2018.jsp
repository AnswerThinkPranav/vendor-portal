
<%@page import="java.io.*"%>
<%@page import="java.util.*,java.text.ParseException,java.text.SimpleDateFormat"%>
<%@ page import="ezc.ezmisc.params.*,java.text.*,ezc.ezutil.*," %>
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>

<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="java.util.*,ezc.ezutil.*,java.text.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*" %>

<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>

<%
	String vendorDocId = checkNull(request.getParameter("docId"));
	String flag = checkNull(request.getParameter("flag"));
	
	if("".equals(flag))flag="O";
	
	
	ReturnObjFromRetrieve vendorUploadFiles=null;
	int vendorUploadFilesCnt=0;
	
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();

	miscParams.setQuery("SELECT * FROM EZC_UPLOAD_FILES WHERE EUF_DOC_ID IN('"+vendorDocId+"') ORDER BY EUF_ATTACHED_DATE");
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	try
	{
		vendorUploadFiles = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		//out.println("::vendorUploadFiles::"+vendorUploadFiles.toEzcString());


		if(vendorUploadFiles!=null)
		{
			vendorUploadFilesCnt = vendorUploadFiles.getRowCount();				
		}

	}catch(Exception e)
	{
	ezc.ezcommon.EzLog4j.log(":::::Exception occured while getting vendor UPload files details::::::"+e,"E");
	}
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%//@ include file="ezHeader.jsp" %>
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
   <style>
 .fileUpload {
 	position: relative;
 	overflow: hidden;
 	margin: 1px;
 }
 .fileUpload input.upload {
 	position: absolute;
 	top: 0;
 	right: 0;
 	margin: 0;
 	padding: 0;
 	font-size: 20px;
 	cursor: pointer;
 	opacity: 0;
 	filter: alpha(opacity=0);
 	float:none;
 }
 
 .filename {
 	width:150px;
 	float:right;
 }
</style>
<script type="text/javascript">	

function openViewUploadWindow(serverFile,clientFile)  
{
	var fVal = serverFile.split('*')
	sFile="";
	for(var i=0;i<fVal.length;i++)
	{
		sFile = sFile+fVal[i]+"/"
	}
	sFile = sFile.substring(0,sFile.length-1)
	//alert("<%=uploadFilePathDir%>"+sFile);
	window.open("/CFL/Uploads/"+sFile,"newWin","titlebar=yes")
}
</script>
</head>
<body>
<form name=myForm method=post>


<div class="container">
<br/>
	<div class="row">
<%
	if(vendorUploadFilesCnt>0)
	{
%>
	<div class="col-md-10 col-md-offset-1">
		 <table id="dataTab" class="table table-hover table-condensed table-bordered" >
			<thead>
				<tr>
					<th  style="background-color: #f39c12 !important">S.No</th>
					<th  style="background-color: #f39c12 !important">Description</th>
					<th  style="background-color: #f39c12 !important">Attachment</th>					
					
				</tr>
			</thead>
			<tbody>
			<%
			for(int i=0;i<vendorUploadFilesCnt;i++)
			{
				String attachemntDesc = checkNull(vendorUploadFiles.getFieldValueString(i,"EUF_FILE_DESCRTIPTION"));
				String attachedClientFile = checkNull(vendorUploadFiles.getFieldValueString(i,"EUF_CLIENT_FILE_NAME"));
				String attachedServerFile = checkNull(vendorUploadFiles.getFieldValueString(i,"EUF_SERVER_FILE_NAME"));
				String attachmentType = checkNull(vendorUploadFiles.getFieldValueString(i,"EUF_EXT1"));
				String fileTime="",fileName="";
				
				
				
				if("WO_ASN_INV".equals(attachmentType)) attachmentType = "Invoice Without ASN";
				
				if("".equals(attachmentType))attachmentType="GENERAL";
				if(attachedClientFile.indexOf("_")>=0)
				{
					fileTime = attachedClientFile.substring(0,attachedClientFile.indexOf("_"));
					try{
					String fileTimeDouble=Double.parseDouble(fileTime)+"";
					fileName = attachedClientFile.substring(attachedClientFile.indexOf("_")+1,attachedClientFile.length());
					}catch(Exception e){fileTime="";fileName=attachedClientFile;}
					
   				}else fileName=attachedClientFile;
				
				attachedServerFile= attachedServerFile.replaceAll("\\\\","*");
				
				
			%>
				<tr>
					<td align="center"><%=i+1%></td>
					<td ><%=attachemntDesc%></td>
					<td ><a href="javascript:openViewUploadWindow('<%=attachedServerFile%>','<%=attachedClientFile%>')" style="background-color:white"><%=fileName%></a></td>
					
				</tr>
			<%
			}
			%>
			</tbody>
		</table>
	</div>
	<%
	}else{
	%>
	<div class="col-md-10 col-md-offset-2">
		<table class="table table-hover table-condensed table-bordered display" id="dataTab" >
			<thead>
				<tr>
					<th style="text-align: center">No Upload files exists</th>
				</tr>
			</thead>
		</table>
	</div>
	<%
	}
	%>

</div>	
<div class="row">

	<div class="col-md-3 col-md-offset-9" style="margin-left: 250px;">
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Ok</a>
		
	</div>
</div>
</form>
</body>
</html>