<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*,ezc.ezparam.*"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<%@ page import="java.util.*,java.io.File,java.io.*,java.text.*,java.lang.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFColor,org.apache.poi.ss.util.CellRangeAddress"%>
<%


	FileOutputStream outputStream = null;

	String docId = checkNull(request.getParameter("docId"));

	Hashtable taxesHT =  new Hashtable();
	taxesHT.put("CGST","Central GST");
	taxesHT.put("SGST","State GST");
	taxesHT.put("IGST","Integrated GST");
	taxesHT.put("UGST","Union Territories GST");
	taxesHT.put("DISC","Discount");
	taxesHT.put("PKFW","Packing & Forwarding");
	taxesHT.put("FRT","Freight");
String excelFilePath="D:\\usr\\sap\\VMP\\J00\\j2ee\\cluster\\apps\\answerthink.com\\EzCFL\\servlet_jsp\\CFL\\root\\Uploads\\QCF\\"+docId+"\\QCF_"+docId+".xlsx";
File upFile1=new File("D:\\usr\\sap\\VMP\\J00\\j2ee\\cluster\\apps\\answerthink.com\\EzCFL\\servlet_jsp\\CFL\\root\\Uploads\\QCF\\"+docId);
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

CellStyle styleAmount = wb.createCellStyle();
styleAmount.setFillForegroundColor(IndexedColors.WHITE.getIndex());
styleAmount.setFillPattern(CellStyle.SOLID_FOREGROUND);
styleAmount.setAlignment(CellStyle.ALIGN_CENTER);
styleAmount.setBorderBottom(CellStyle.BORDER_THIN);
styleAmount.setBorderTop(CellStyle.BORDER_THIN);
styleAmount.setBorderRight(CellStyle.BORDER_THIN);
styleAmount.setBorderLeft(CellStyle.BORDER_THIN);

CellStyle styleItemAmount = wb.createCellStyle();
styleItemAmount.setFillForegroundColor(IndexedColors.AQUA.getIndex());
styleItemAmount.setFillPattern(CellStyle.SOLID_FOREGROUND);
styleItemAmount.setAlignment(CellStyle.ALIGN_CENTER);
styleItemAmount.setBorderBottom(CellStyle.BORDER_THIN);
styleItemAmount.setBorderTop(CellStyle.BORDER_THIN);
styleItemAmount.setBorderRight(CellStyle.BORDER_THIN);
styleItemAmount.setBorderLeft(CellStyle.BORDER_THIN);

ArrayList priceAL= new ArrayList();   
ArrayList materialAL= new ArrayList();
Hashtable vendorPriceHT =  new Hashtable();
Hashtable vendorPriceALHT =  new Hashtable();
Hashtable quotedlandedCostHT = new Hashtable();
Hashtable revisedlandedCostHT = new Hashtable();
Hashtable quotedtaxAmountHT = new Hashtable();
Hashtable revisedtaxAmountHT = new Hashtable();
Hashtable vendorsHT =  new Hashtable();
Hashtable materialTaxCodesHT =  new Hashtable();
Hashtable materialVendTaxValueHT =  new Hashtable();
Hashtable revisedMaterialVendTaxValueHT =  new Hashtable();
Hashtable quotedAmountHT = new Hashtable();
Hashtable revisedAmountHT = new Hashtable();
						

	String usersList="";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;
	
	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	
	EzoRFQHeaderParams    qcfDetailsRet 	= null;
	ReturnObjFromRetrieve rfqHeaderRet 	= null;
	ReturnObjFromRetrieve itemsRetObj 	= null;
	ReturnObjFromRetrieve rfqConditionsRet 	= null;
	
	int qcfDetailsRetCnt 	= 0;
	int rfqHeaderRetCnt 	= 0;
	int itemsRetObjCnt 	= 0;
	int rfqConditionsRetCnt = 0;
	
	EziRFQHeaderParams  inputParams = new EziRFQHeaderParams();

	inputParams.setCollectiveRFQNo(docId);
	inputParams.setStatus("Y");

	ezparams.setLocalStore("Y");
	ezparams.setObject(inputParams);
	Session.prepareParams(ezparams);
	
	try{
		qcfDetailsRet = (EzoRFQHeaderParams)rfqManager.ezGetRFQDetails(ezparams);
	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Error while getting QCF Details :::::::::"+e,"E");
	}
	
	rfqHeaderRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQHeader();
	itemsRetObj 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQDetails();
	rfqConditionsRet 	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQConditions();
//out.println(itemsRetObj.toEzcString());
//out.println(rfqConditionsRet.toEzcString());

	if(rfqHeaderRet!=null)
		rfqHeaderRetCnt    = rfqHeaderRet.getRowCount();
	if(itemsRetObj!=null)
		itemsRetObjCnt   = itemsRetObj.getRowCount();
	if(rfqConditionsRet!=null)
		rfqConditionsRetCnt= rfqConditionsRet.getRowCount();



for(int i=0;i<rfqHeaderRetCnt;i++)
{
	String soldToDB = checkNull(rfqHeaderRet.getFieldValueString(i,"ERH_SOLD_TO"));
	String rfqNo 	= checkNull(rfqHeaderRet.getFieldValueString(i,"ERH_RFQ_NO"));
	/*try{
		soldToDB = Integer.parseInt(soldToDB)+""
	}catch(Exception e){}*/
	String vendorStr="";
		try{
		vendorStr=Integer.parseInt(soldToDB)+"";
		}catch(Exception e){vendorStr= rfqHeaderRet.getFieldValueString(i,"ERH_SOLD_TO");}

			if(!userIdAL.contains(vendorStr))								
				userIdAL.add(vendorStr);
	
	vendorsHT.put(soldToDB,rfqNo);
}
	for(int i=0;i<userIdAL.size();i++)
	{
		if("".equals(usersList))
			usersList=(String)userIdAL.get(i);
		else
			usersList=usersList+"','"+(String)userIdAL.get(i);
				
	}
	try{
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();


	miscParams.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_LAST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+usersList+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	UserNamesRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

	if(UserNamesRetObj!=null)
	userNameCount = UserNamesRetObj.getRowCount();
	}catch(Exception e){System.out.println(e);}
	
	

//out.println(itemsRetObj.toEzcString());
//itemsRetObj.sort(new String[]{"ERD_LINE_NO"},true);
//out.println(itemsRetObj.toEzcString());
ReturnObjFromRetrieve itemsRetObjTemp= new ReturnObjFromRetrieve(new String[]{"ERD_MATERIAL","ERD_RFQ_NO","ERD_LINE_NO","ERD_PRICE","ERD_NEG_PRICE"});
int itemsRetObjTempCnt=0;
for(int i=0;i<itemsRetObjCnt;i++)
{
	String matNumber	= checkNull(itemsRetObj.getFieldValueString(i,"ERD_MATERIAL"));
	String rfqDB  		= checkNull(itemsRetObj.getFieldValueString(i,"ERD_RFQ_NO"));
	String price 		= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_PRICE"));
	String revisedPrice 	= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_NEG_PRICE"));
	String lineNo 		= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_LINE_NO"));
	
	itemsRetObjTemp.setFieldValue("ERD_MATERIAL",matNumber);
	itemsRetObjTemp.setFieldValue("ERD_RFQ_NO",rfqDB);
	itemsRetObjTemp.setFieldValue("ERD_LINE_NO",lineNo);
	itemsRetObjTemp.setFieldValue("ERD_PRICE",price);
	itemsRetObjTemp.setFieldValue("ERD_NEG_PRICE",revisedPrice);
	itemsRetObjTemp.addRow();
}
if(itemsRetObjTemp!=null)
{
itemsRetObjTempCnt=itemsRetObjTemp.getRowCount();
itemsRetObjTemp.sort(new String[]{"ERD_LINE_NO"},false);
}
for(int i=0;i<itemsRetObjTempCnt;i++)
{
	String matNumber	= checkNull(itemsRetObjTemp.getFieldValueString(i,"ERD_MATERIAL"));
	String rfqDB  		= checkNull(itemsRetObjTemp.getFieldValueString(i,"ERD_RFQ_NO"));
	String price 		= checkNullNum(itemsRetObjTemp.getFieldValueString(i,"ERD_PRICE"));
	String revisedPrice 	= checkNullNum(itemsRetObjTemp.getFieldValueString(i,"ERD_NEG_PRICE"));
	
	if(Float.parseFloat(revisedPrice)==0)revisedPrice=price;
	
	if(!materialAL.contains(matNumber))
	{
		materialAL.add(matNumber);
		priceAL= new ArrayList();
	}
	priceAL.add(new java.math.BigDecimal(revisedPrice));
	Collections.sort(priceAL);
	
	vendorPriceHT.put(matNumber+rfqDB,price+"#"+revisedPrice);
	vendorPriceALHT.put(matNumber,priceAL);
}
int materialCnt=0;
if(materialAL!=null)materialCnt = materialAL.size();
//out.println(rfqConditionsRet.toEzcString());
for(int i=0;i<rfqConditionsRetCnt;i++)
{
	String taxCode	= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_TAX_CODE"));
	String taxVendor= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_VENDOR"));
	String taxValue	= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_TAX_VALUE"));
	String revisedTaxValue	= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_NEG_TAX_VALUE"));
	String taxType	= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_TAX_TYPE"));
	String lineNo	= checkNull(rfqConditionsRet.getFieldValueString(i,"ERIC_LINE_NO"));
	String temp=taxCode;
	
	if(materialTaxCodesHT.containsKey(lineNo))
	{
		temp = (String)materialTaxCodesHT.get(lineNo);
		if(temp.indexOf(taxCode)<0)
		temp=taxCode+"#"+temp;
		
		materialTaxCodesHT.remove(lineNo);
	}
	materialTaxCodesHT.put(lineNo,temp);
	
	if("0".equals(taxValue) || "".equals(taxValue))taxValue="0.00";
	
	
	materialVendTaxValueHT.put(lineNo+taxVendor+taxCode,taxValue+"#"+taxType);
	revisedMaterialVendTaxValueHT.put(lineNo+taxVendor+taxCode,revisedTaxValue+"#"+taxType);
}
//out.println(revisedMaterialVendTaxValueHT);
%>

<!DOCTYPE html>
<html lang="en">
  <head>
      <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>

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
th{
background-color: '#f39c12 !important'
}
</style>
<script>
function funDownloadExcel()
{
document.myForm.action="ezQCFDownloadExcel.jsp";
document.myForm.submit();
}
function funSubmit()
{
	var chkObj = document.myForm.rank;
	var chkLen = chkObj.length;
	var checkedCnt=0;
	if(isNaN(chkLen))
	{
		if(chkObj.checked)checkedCnt=checkedCnt+1;
	}else{
	
	for(i=0;i<chkLen;i++)
	{
		if(chkObj[i].checked)checkedCnt=checkedCnt+1;
	}
	}
	
	if(checkedCnt==0)
	{
		alert("Please select atleast one vendor");
		return false;
	}
	$.confirm({
		    title: 'Confirm!',
		    content: 'Are you sure to submit ComparisionForm?',
		    buttons: {
		        YES:{
		        btnClass: 'btn-success',
		        action:function () {
			       document.myForm.action="ezSaveQuotationComparisionForm.jsp";
				document.myForm.submit();
		        }
		        },
		        NO: {
		           btnClass: 'btn-danger',
			   action:function () {
			 //  funAction("NO");
			   //    $.alert('caNCEL!');
		       	   }
		        }
		        
		    }
		});	
	
}

</script>
<style>

table {
  border-collapse: collapse;
  background: white;
  table-layout: fixed;
  width: 100%;
}
th, td {
  padding: 8px 16px;
  border: 1px solid black;
  
  overflow: hidden;
  
}

.pane {
  background: #eee;
}
.pane-hScroll {
  overflow: auto;
  width: 100%;
  
}
.pane-vScroll {
  overflow-y: auto;
  overflow-x: hidden;
  height: 300px;
  
}
</style>
</head>
<body style="overflow:auto">
<Form name="myForm">
<input type="hidden" name="docId" value="<%=docId%>"> 
<input type="hidden" name="itemCnt" value="<%=materialCnt%>"> 

<div class="container" style="width:100%;">

<div class="row" >
	<div class="box">
		<div class="box-header">
		<h4>Quotation Comparision Form <%=docId%></h4>
		</div>
	
		<div class="box-body">
		<div class="pane pane--table1">
		  <div class="pane-hScroll">
			<table class="table" border=1 style="font-size:12px;margin-bottom:0px !important">
			<thead>
			<tr style="background-color:palegreen !important">
			<th colspan=5 style="width:500px;text-align:left">Name of the party</th>
			<%
			style = wb.createCellStyle();
			style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setBorderLeft(CellStyle.BORDER_THIN);
			
			row  = sheet.createRow((short) 0);
			cell = row.createCell((short) 0);
			cell.setCellValue("Name of the party");
			cell.setCellStyle(style);
			
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
			maxColNumber=4;
			Enumeration suppIds  = vendorsHT.keys();
			while(suppIds.hasMoreElements())
			{
				String vendorCode 	= (String)suppIds.nextElement();
				String supplierdata 	= (String)vendorsHT.get(vendorCode);
				String vendorName="";
				
				int vendindex=-1;
				
				if(UserNamesRetObj!=null)
				{
					vendindex=UserNamesRetObj.getRowId("EU_ID",Integer.parseInt(vendorCode)+"");
					if(vendindex>=0)
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_LAST_NAME"));
					else	 vendorName=vendorCode;
				
				}
				style = wb.createCellStyle();
				style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				style.setAlignment(CellStyle.ALIGN_CENTER);
				style.setBorderBottom(CellStyle.BORDER_THIN);
				style.setBorderTop(CellStyle.BORDER_THIN);
				style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);

				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue(vendorName);
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(0, 0, maxColNumber+1, maxColNumber+4));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				maxColNumber=maxColNumber+4;
			%>
				<th colspan=4 style="width:400px;text-align:center"><%=vendorName%></th>
			<%
			}
			%>
			</tr>
			<tr style="width:100px;background-color:palegreen !important">
			<th colspan=5 style="width:500px;text-align:left">Make</th>
			<%
			style = wb.createCellStyle();
			style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);

			row  = sheet.createRow((short) 1);
			cell = row.createCell((short) 0);
			cell.setCellValue("Make");
			cell.setCellStyle(style);
						
			sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 4));
			maxColNumber=4;
			suppIds  = vendorsHT.keys();
			while(suppIds.hasMoreElements())
			{
				String vendorCode 	= (String)suppIds.nextElement();
				
				
				String vendorName="";
								
				int vendindex=-1;

				if(UserNamesRetObj!=null)
				{
					vendindex=UserNamesRetObj.getRowId("EU_ID",Integer.parseInt(vendorCode)+"");
					if(vendindex>=0)
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_FIRST_NAME"));
					else	 vendorName=vendorCode;		
				}
				
				style = wb.createCellStyle();
				style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				style.setAlignment(CellStyle.ALIGN_CENTER);
				style.setBorderBottom(CellStyle.BORDER_THIN);
				style.setBorderTop(CellStyle.BORDER_THIN);
				style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);
				
				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue(vendorName);
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				maxColNumber=maxColNumber+2;

				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue(vendorName);
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				maxColNumber=maxColNumber+2;
			%>
			<th colspan=2 style="width:200px;text-align:center"><%=vendorName%></th>
			<th colspan=2 style="width:200px;text-align:center"><%=vendorName%></th>
			<%
			}
			%>
			</tr>
			<tr style="background-color:palegreen !important">
				<th colspan=5 style="width:500px;text-align:left">Quotation Ref.No. & Date</th>
			<%
			style = wb.createCellStyle();
			style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);

			row  = sheet.createRow((short) 2);
			cell = row.createCell((short) 0);
			cell.setCellValue("Quotation Ref.No. & Date");
			cell.setCellStyle(style);
						
			sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 4));
			maxColNumber=4;
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
					String vendorCode 	= (String)suppIds.nextElement();
					String supplierdata 	= (String)vendorsHT.get(vendorCode);
					
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);
					
					//row  = sheet.createRow((short) 0);
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(supplierdata);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(2, 2, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					maxColNumber=maxColNumber+2;

					//row  = sheet.createRow((short) 0);
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(supplierdata);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(2, 2, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					maxColNumber=maxColNumber+2;
				%>
				<th colspan=2 style="width:200px;text-align:center"><%=supplierdata%></th>
				<th colspan=2 style="width:200px;text-align:center"><%=supplierdata%></th>
				<%
				}
				%>
			</tr>
			<tr style="background-color:khaki !important">
				<th rowspan=2  style="width:100px;text-align:center">S.No.</th>
				<th rowspan=2  style="width:100px;text-align:center">TAG NO</th>
				<th rowspan=2  style="width:100px;text-align:center">Description</th>
				<th rowspan=2  style="width:100px;text-align:center">UoM</th>
				<th rowspan=2  style="width:100px;text-align:center">Qty</th>
				<%
				style = wb.createCellStyle();
				style.setFillForegroundColor(IndexedColors.GOLD.getIndex());
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				style.setAlignment(CellStyle.ALIGN_CENTER);
				style.setBorderBottom(CellStyle.BORDER_THIN);
				style.setBorderTop(CellStyle.BORDER_THIN);
				style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);

				row  = sheet.createRow((short) 3);
				
				cell = row.createCell((short) 0);
				cell.setCellValue("S.No.");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(3, 4, 0, 0));
				
				cell = row.createCell((short) 1);
				cell.setCellValue("TAG NO");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(3, 4, 1, 1));

				cell = row.createCell((short) 2);
				cell.setCellValue("Description");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(3, 4, 2, 2));

				cell = row.createCell((short) 3);
				cell.setCellValue("UoM");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(3, 4, 3, 3));

				cell = row.createCell((short) 4);
				cell.setCellValue("Qty");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(3, 4, 4, 4));
				
				maxColNumber=4;
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
				String vendorCode 	= (String)suppIds.nextElement();
				
				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Quoted Price");
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(3, 3, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				maxColNumber=maxColNumber+2;

				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Revised");
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(3, 3, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				maxColNumber=maxColNumber+2;
				%>
					<th colspan=2 style="width:200px;text-align:center">Quoted Price</th>
					<th colspan=2 style="width:200px;text-align:center">Revised</th>
				<%
				}
				%>
			</tr>
			<tr style="background-color:khaki !important">
				<%
				row  = sheet.createRow((short) 4);
				maxColNumber=4;
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
				String vendorCode 	= (String)suppIds.nextElement();				
				
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Rate");
				cell.setCellStyle(style);
				sheet.autoSizeColumn(maxColNumber+1); 
				maxColNumber=maxColNumber+1;

				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Amount");
				cell.setCellStyle(style);
				sheet.autoSizeColumn(maxColNumber+1); 
				maxColNumber=maxColNumber+1;
				
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Rate");
				cell.setCellStyle(style);
				sheet.autoSizeColumn(maxColNumber+1); 
				maxColNumber=maxColNumber+1;

				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Amount");
				cell.setCellStyle(style);
				sheet.autoSizeColumn(maxColNumber+1); 
				maxColNumber=maxColNumber+1;
				%>
					<th style="width:100px;text-align:center">Rate<br>Rs./UOM </th>
					<th style="width:100px;text-align:center">Total<br>Amount Rs.</th>
					<th style="width:100px;text-align:center">Rate<br>Rs./UOM </th>
					<th style="width:100px;text-align:center">Total<br>Amount Rs.</th>
				<%
				}
				%>
			</tr>
			</thead>
			</table>
			
			<div class="pane-vScroll">
			<table class="table" border=1 style="font-size:12px">
			<tbody>
			<%		
				int maxRowNumber=4;
				Enumeration vendorPriceEnum  = vendorPriceALHT.keys();
				int j=0;
					  String trBGColor = "Bgcolor=\"#c9e0ff\"  style=\"color:black\"";
					  String color=trBGColor;

				while(vendorPriceEnum.hasMoreElements())
				{
				
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.AQUA.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					String matNumber 	= (String)vendorPriceEnum.nextElement();
				
					//String matNumber= checkNull(itemsRetObj.getFieldValueString(i,"ERD_MATERIAL"));
					int itemIndex=-1;
					itemIndex = itemsRetObj.getRowId("ERD_MATERIAL",matNumber);
					String desc 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_MATERIAL_DESC"));
					String uom 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_UOM"));
					String qty 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_QUANTITY"));
					String lineNo 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_LINE_NO"));
					String rfqNoDB 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_RFQ_NO"));
					
					//out.println(itemIndex+":::::"+lineNo);
					
					//color = "";
					//if(j%2==0) {color = trBGColor;} 
					
					row  = sheet.createRow((short) maxRowNumber+1);
					maxRowNumber=maxRowNumber+1;
					cell = row.createCell((short) 0);
					cell.setCellValue(lineNo);
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0);

					cell = row.createCell((short) 1);
					cell.setCellValue(Integer.parseInt(matNumber));
					cell.setCellStyle(style);
					sheet.autoSizeColumn(1);

					cell = row.createCell((short) 2);
					cell.setCellValue(desc);
					cell.setCellStyle(style);
					sheet.autoSizeColumn(2);

					cell = row.createCell((short) 3);
					cell.setCellValue(uom);
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3);

					cell = row.createCell((short) 4);
					cell.setCellValue(qty);
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4);

					maxColNumber=4;
			%>
				<tr <%=color%>>
					<td style="width:100px;text-align:center" ><%=lineNo%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=Integer.parseInt(matNumber)%>&nbsp;</td>
					<td style="width:100px;text-align:center;" ><%=desc%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=uom%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=qty%>&nbsp;</td>
					<%
						suppIds  = vendorsHT.keys();
						while(suppIds.hasMoreElements())
						{
							String vendorCode 	= (String)suppIds.nextElement();
							String rfq 	= (String)vendorsHT.get(vendorCode);
							
							java.math.BigDecimal quotedPriceBD = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
							java.math.BigDecimal revisedPriceBD= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);
							
							java.math.BigDecimal quotedAmountBD = quotedPriceBD.multiply(new java.math.BigDecimal(qty));
							java.math.BigDecimal revisedAmountBD= revisedPriceBD.multiply(new java.math.BigDecimal(qty));
							
							quotedAmountHT.put(vendorCode,quotedAmountBD);
							revisedAmountHT.put(vendorCode,revisedAmountBD);
							
							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(quotedPriceBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleItemAmount);
							sheet.autoSizeColumn(maxColNumber+1);
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(quotedAmountBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleItemAmount);
							sheet.autoSizeColumn(maxColNumber+1);
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedPriceBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleItemAmount);
							sheet.autoSizeColumn(maxColNumber+1);
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedAmountBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleItemAmount);
							sheet.autoSizeColumn(maxColNumber+1);
							maxColNumber=maxColNumber+1;
							
						%>
							<td style="width:100px;text-align:center"><%=quotedPriceBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp;</td>
							<td style="width:100px;text-align:center"><%=quotedAmountBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp;</td>
							<td style="width:100px;text-align:center"><%=revisedPriceBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp; </td>
							<td style="width:100px;text-align:center"><%=revisedAmountBD.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp;</td>
						<%
						}
					%>
				</tr>
				<!--<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Ex works Price</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">1&nbsp;</td>-->
					<%
					//suppIds  = vendorsHT.keys();
					//while(suppIds.hasMoreElements())
					//{
					//String vendorCode 	= (String)suppIds.nextElement();
					%>
						<!--<td style="width:100px;text-align:center">&nbsp;</td>
						<td style="width:100px;text-align:center">1&nbsp;</td>
						<td style="width:100px;text-align:center">&nbsp; </td>
						<td style="width:100px;text-align:center">1&nbsp;</td>-->
					<%
					//}
					%>
				<!--</tr>-->
				<%
				
				if(materialTaxCodesHT.size()>0)
				{
					String taxCodeStr = (String)materialTaxCodesHT.get(lineNo);
					String taxCodeArr[] =null;
					if(taxCodeStr.indexOf("#")>=0)
					{
						taxCodeArr = taxCodeStr.split("#");
					}
					else{
						taxCodeArr= new String[1];
						taxCodeArr[0] =taxCodeStr;
					}
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);
					
					
						for(int i=0;i<taxCodeArr.length;i++)
						{
							String taxCodeName = taxCodeArr[i];
							try{
								taxCodeName = checkNull((String)taxesHT.get(taxCodeArr[i]));
							}catch(Exception e){taxCodeName = taxCodeArr[i];}
							
							if("".equals(taxCodeName))taxCodeName = taxCodeArr[i];
							
							
							row  = sheet.createRow((short) maxRowNumber+1);
							
							cell = row.createCell((short) 1);
							cell.setCellValue(taxCodeName);
							cell.setCellStyle(style);
							sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
							sheet.autoSizeColumn(1,true); 

							
							maxRowNumber=maxRowNumber+1;
							
						%>
						<tr>
							<td style="width:100px;">&nbsp;</td>
							<td style="width:200px;text-align:left" colspan=2>&nbsp;<%=taxCodeName%></td>
							<td style="width:100px;">&nbsp;</td>
							<td style="width:100px;">&nbsp;</td>
							<%
							maxColNumber=4;
							java.math.BigDecimal quotedLandedCost = new java.math.BigDecimal("0");
							java.math.BigDecimal revisedLandedCost= new java.math.BigDecimal("0");
							suppIds  = vendorsHT.keys();
							while(suppIds.hasMoreElements())
							{
							String vendorCode 	= (String)suppIds.nextElement();
							String taxValue="0.00",revisedValue="0.00",taxAmount="0.00",revisedAmount="0.00",taxType="";
							try{
								taxValue =((String)materialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[0];
								revisedValue =((String)revisedMaterialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[0];
								taxType =((String)materialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[1];
							}catch(Exception e){taxValue="0.00";revisedValue="0.00";}
							String rfq 	= (String)vendorsHT.get(vendorCode);
							//out.println(":::"+lineNo+rfq+vendorCode+taxCodeArr[i]+":::"+revisedValue);
							java.math.BigDecimal quotedAmountBD= new java.math.BigDecimal("0");
							java.math.BigDecimal revisedAmountBD= new java.math.BigDecimal("0");
							
							try{
								quotedAmountBD =(java.math.BigDecimal)quotedAmountHT.get(vendorCode);
								revisedAmountBD =(java.math.BigDecimal)revisedAmountHT.get(vendorCode);
							}catch(Exception e){}
							
							if("P".equals(taxType))
							{
								taxType="%";
								try{
									if(Float.parseFloat(taxValue)>0)
									{
									taxAmount = ((quotedAmountBD.multiply(new java.math.BigDecimal(taxValue))).divide(new java.math.BigDecimal("100")))+"";
									}
								}catch(Exception e){taxAmount="0.00";}
								
								try{
									if(Float.parseFloat(revisedValue)>0)
									{
									revisedAmount=((revisedAmountBD.multiply(new java.math.BigDecimal(revisedValue))).divide(new java.math.BigDecimal("100")))+"";
									}
								}catch(Exception e){revisedAmount="0.00";}

								if("".equals(revisedValue))revisedValue="0";
								if("".equals(taxValue))taxValue="0";

							}else
							{
								if("".equals(revisedValue))revisedValue="0.00";
								if("".equals(taxValue))taxValue="0.00";

								taxAmount = taxValue;
								revisedAmount = revisedValue;
							}
							
							quotedtaxAmountHT.put(vendorCode,taxAmount);
							revisedtaxAmountHT.put(vendorCode,revisedAmount);
							

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(taxValue+""+taxType);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(new java.math.BigDecimal(taxAmount).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedValue+""+taxType);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(new java.math.BigDecimal(revisedAmount).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;
							//out.println(":::::code:::::"+taxCodeArr[i]+"::::actualAmount::::"+quotedAmountBD+":::::taxAmount::::::"+taxAmount+"::::::quotedLandedCost:::::::::"+quotedLandedCost);
							%>
								<td style="width:100px;text-align:center"><%=taxValue%><%=taxType%>&nbsp;</td>
								<td style="width:100px;text-align:center"><%=new java.math.BigDecimal(taxAmount).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp;</td>
								<td style="width:100px;text-align:center"><%=revisedValue%><%=taxType%>&nbsp; </td>
								<td style="width:100px;text-align:center"><%=new java.math.BigDecimal(revisedAmount).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%>&nbsp;</td>
							<%
							}
							%>
						</tr>
						<tr>
							<td style="width:100px;text-align:center">&nbsp;</td>
							<td style="width:200px;text-align:center" colspan=2>&nbsp;</td>
							<td style="width:100px;text-align:center">&nbsp; </td>
							<td style="width:100px;text-align:center">&nbsp;</td>
							<%
							row  = sheet.createRow((short) maxRowNumber+1);
														
							maxRowNumber=maxRowNumber+1;
							maxColNumber=4;
							suppIds  = vendorsHT.keys();
							while(suppIds.hasMoreElements())
							{
							String vendorCode 	= (String)suppIds.nextElement();
							String taxValue="",taxAmount="0.00",revisedAmount="0.00";
							
							try{
								taxAmount=(String)quotedtaxAmountHT.get(vendorCode);
								revisedAmount=(String)revisedtaxAmountHT.get(vendorCode);
							}catch(Exception e){}
							
							java.math.BigDecimal quotedAmountBD= new java.math.BigDecimal("0");
							java.math.BigDecimal revisedAmountBD= new java.math.BigDecimal("0");

							try{
								if(quotedlandedCostHT.containsKey(vendorCode))
								{
								quotedAmountBD =(java.math.BigDecimal)quotedlandedCostHT.get(vendorCode);
								revisedAmountBD =(java.math.BigDecimal)revisedlandedCostHT.get(vendorCode);
								}else{
								quotedAmountBD =(java.math.BigDecimal)quotedAmountHT.get(vendorCode);
								revisedAmountBD =(java.math.BigDecimal)revisedAmountHT.get(vendorCode);
								}

							}catch(Exception e){}
							
							if("DISC".equals(taxCodeArr[i]))
							{
							quotedLandedCost=quotedAmountBD.subtract(new java.math.BigDecimal(taxAmount));
							revisedLandedCost=revisedAmountBD.subtract(new java.math.BigDecimal(revisedAmount));
							}
							else
							{
							quotedLandedCost=quotedAmountBD.add(new java.math.BigDecimal(taxAmount));
							revisedLandedCost=revisedAmountBD.add(new java.math.BigDecimal(revisedAmount));
							}
							quotedlandedCostHT.put(vendorCode,quotedLandedCost);
							revisedlandedCostHT.put(vendorCode,revisedLandedCost);
							
							cell = row.createCell((short) maxColNumber+2);
							cell.setCellValue(quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+2); 
							maxColNumber=maxColNumber+2;

							cell = row.createCell((short) maxColNumber+2);
							cell.setCellValue(revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+2); 
							maxColNumber=maxColNumber+2;
							%>
								<td style="width:100px;text-align:center">&nbsp;</td>
								<td style="width:100px;text-align:center"><b><%=quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
								<td style="width:100px;text-align:center">&nbsp; </td>
								<td style="width:100px;text-align:center"><b><%=revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
							<%
							}
							%>
						</tr>
						<%
						}
					}else{
							suppIds  = vendorsHT.keys();
							while(suppIds.hasMoreElements())
							{
								String vendorCode 	= (String)suppIds.nextElement();
								java.math.BigDecimal quotedAmountBD= new java.math.BigDecimal("0");
								java.math.BigDecimal revisedAmountBD= new java.math.BigDecimal("0");

								try{
								quotedAmountBD =(java.math.BigDecimal)quotedAmountHT.get(vendorCode);
								revisedAmountBD =(java.math.BigDecimal)revisedAmountHT.get(vendorCode);
								}catch(Exception e){}

								quotedlandedCostHT.put(vendorCode,quotedAmountBD);
								revisedlandedCostHT.put(vendorCode,revisedAmountBD);
							}
					}
				%>
				
				
				<tr style="background-color:coral">
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Landed Cost</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.RED.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);
					
					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Landed Cost");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					maxColNumber=4;
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.RED.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					String vendorCode 	= (String)suppIds.nextElement();
					java.math.BigDecimal	quotedLandedCost = new java.math.BigDecimal("0");
					java.math.BigDecimal 	revisedLandedCost= new java.math.BigDecimal("0");

					try{
						quotedLandedCost = (java.math.BigDecimal)quotedlandedCostHT.get(vendorCode);
						revisedLandedCost = (java.math.BigDecimal)revisedlandedCostHT.get(vendorCode);
					}catch(Exception e){
						quotedLandedCost = new java.math.BigDecimal("0");
						revisedLandedCost= new java.math.BigDecimal("0");
					}
					if(quotedLandedCost==null)quotedLandedCost = new java.math.BigDecimal("0");
					if(revisedLandedCost==null)revisedLandedCost = new java.math.BigDecimal("0");
					

					cell = row.createCell((short) maxColNumber+2);
					cell.setCellValue(quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+2); 
					maxColNumber=maxColNumber+2;

					cell = row.createCell((short) maxColNumber+2);
					cell.setCellValue(revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+2); 
					maxColNumber=maxColNumber+2;
					%>
						<td style="width:100px;text-align:center">&nbsp;</td>
						<td style="width:100px;text-align:center"><b><%=quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
						<td style="width:100px;text-align:center">&nbsp; </td>
						<td style="width:100px;text-align:center"><b><%=revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Rank</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Rank");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					maxColNumber=4;
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);
					String vendorCode 	= (String)suppIds.nextElement();
					
					String rfq 	= (String)vendorsHT.get(vendorCode);
					
					priceAL = (ArrayList)vendorPriceALHT.get(matNumber);
												
					java.math.BigDecimal quotedPrice = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
					java.math.BigDecimal revisedPrice= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);

					String rankStr="",vendorCodeStr="";

					try{
						vendorCodeStr=(Integer.parseInt(vendorCode))+"";
					}catch(Exception e){}
					try{
						rankStr=(priceAL.indexOf(revisedPrice))+"";

						if(Integer.parseInt(rankStr)>=0)rankStr=(Integer.parseInt(rankStr)+1)+"";
					}catch(Exception e){}
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("Rank: "+rankStr);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber+1, maxRowNumber+1, maxColNumber+1, maxColNumber+4));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					maxColNumber=maxColNumber+4;
					
					%>
						<td style="width:400px;text-align:center" colspan=4><b>Rank:<%=rankStr%></b>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="rank" value="<%=vendorCodeStr+"#"+matNumber%>"><input type="hidden" name="participatedVendors" value="<%=vendorCodeStr+"#"+desc+"#"+rfq+"#"+matNumber%>">&nbsp;</td>
					<%
					}
					%>
				</tr>
				
			
			<%
			j=j+1;
				}
			%>
				
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Price Basis</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Price Basis");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String incoterm="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);

						incoterm=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_INCO_TERMS1"))+"-"+checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_INCO_TERMS2"));
					}
					%>
						<td style="width:200px;text-align:center" colspan=2><%=incoterm%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=incoterm%>&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Payment Terms</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Payment Terms");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String paymentTerms="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						
						paymentTerms=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_PAYMENT_TERMS"));
					}
					%>
						<td style="width:200px;text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
					<%
					}
					%>
				</tr>
<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Delivery Period</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Delivery Period");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String deliveryPeriod="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						
						deliveryPeriod=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_DELV_PERIOD"));
					}
						
					%>
						<td style="width:200px;text-align:center" colspan=2><%=deliveryPeriod%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=deliveryPeriod%>&nbsp;</td>
					<%
					}
					%>
				</tr>
<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Guarantee Period</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Guarantee Period");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String guaranteePeriod="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);

						guaranteePeriod=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_GUARANTEE_PERIOD"));
					}
					
					%>
						<td style="width:200px;text-align:center" colspan=2><%=guaranteePeriod%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=guaranteePeriod%>&nbsp;</td>
					<%
					}
					%>
				</tr>	
<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Validity of offer</td>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:100px;">&nbsp;</td>
					<%
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_LEFT);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					row  = sheet.createRow((short) maxRowNumber+1);
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Validity of offer");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					maxRowNumber=maxRowNumber+1;
					
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String quoteValidity="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						try{
						quoteValidity=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_QUOTE_VALIDITY"));
						SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date date = formatter.parse(quoteValidity);
						formatter = new SimpleDateFormat("dd/MM/yyyy");
						quoteValidity = formatter.format(date);
						}catch(Exception e){}
					}

					%>
						<td style="width:200px;text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
					<%
					}
					%>
				</tr>					
			</tbody>
			</table>
			</div>
			</div>
			</div>
		</div>
	</div>
</div>
<div class="row">

	<center><div class="col-md-12" id="UploadDiv1">
		<a href="javascript:funSubmit()" class="btn btn-info" >Submit</a>
		<a href="javascript:funDownloadExcel()" class="btn btn-info" >Download Excel</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div></center>
	
</div>

</div>
<%
try{
wb.write(outputStream);
}catch(Exception e){out.println(e);}
finally{
outputStream.close();
}
taxesHT=null;
vendorsHT=null;
vendorPriceHT=null;
vendorPriceALHT=null;
materialTaxCodesHT=null;
materialVendTaxValueHT=null;
quotedAmountHT=null;
revisedAmountHT=null;
quotedlandedCostHT =null;
revisedlandedCostHT=null;
quotedtaxAmountHT =null;
revisedtaxAmountHT =null;
userIdAL=null;
priceAL=null;
materialAL=null;
%>
</form>
<script>

$('.pane-hScroll').scroll(function() {
  $('.pane-vScroll').width($('.pane-hScroll').width() + $('.pane-hScroll').scrollLeft());
});

</script>
</body>
</html>
 <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>

