<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*,ezc.ezparam.*"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<%@ page import="java.util.*,java.io.File,java.io.*,java.text.*,java.lang.*,java.math.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.*,org.apache.poi.ss.util.RegionUtil"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFColor,org.apache.poi.ss.util.CellRangeAddress"%>
<%
String destinationPath="";
	
	try
	{
		ResourceBundle site1= ResourceBundle.getBundle("Site");
		destinationPath=site1.getString("SERVERUPLOADPATH");
	}
	catch(Exception e)
	{ 
	    ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
	}

	FileOutputStream outputStream = null;

	String docId = checkNull(request.getParameter("docId"));

String excelFilePath=destinationPath+"QCF\\"+docId+"\\QCF_"+docId+".xlsx";
File upFile1=new File(destinationPath+"QCF\\"+docId);
if(!((upFile1.exists()) && (upFile1.isDirectory())))
{
boolean dir=upFile1.mkdirs();
ezc.ezcommon.EzLog4j.log(":::directory:::::"+dir,"I");
}
outputStream = new FileOutputStream(excelFilePath);

Workbook wb = new XSSFWorkbook(); //or new HSSFWorkbook();
Sheet sheet = wb.createSheet("QCF");
CellStyle style =null;
Row row   = null;
Cell cell = null;
int maxColNumber=0;


try{
wb.write(outputStream);
}catch(Exception e){out.println(e);}
finally{
outputStream.flush();
outputStream.close();
}
%>
<html>
<head>
<script>
function funDownloadExcel()
{
document.myForm.action="ezQCFDownloadExcel.jsp";
document.myForm.submit();
}
</script>
</head>

<body>
<form name="myForm">
<input type="hidden" name="excelFilePath" value="<%=excelFilePath%>">

<div class="row">

	<center><div class="col-md-12" id="UploadDiv1">
		<a href="javascript:funSubmit()" class="btn btn-info" >Submit</a>
		<a href="javascript:funDownloadExcel()" class="btn btn-info" >Download Excel</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div></center>
	
</div>
</form>
</body>
</html>