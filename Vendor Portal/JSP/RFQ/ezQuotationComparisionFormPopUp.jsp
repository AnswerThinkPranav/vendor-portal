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
	
	 ezc.ezcommon.EzLog4j.log("::::destinationPath::: "+destinationPath,"I");

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
	taxesHT.put("FRT_GST","GST on Freight");
	
	String tempDocId="";
	if(docId.contains("/"))
	{
	tempDocId=docId.replaceAll("/","_");
	}
//String excelFilePath=destinationPath+"QCF\\"+docId+"\\QCF_"+docId+".xlsx";
//File upFile1=new File(destinationPath+"QCF\\"+docId);

String excelFilePath=destinationPath+"QCF\\"+tempDocId+"\\QCF_"+tempDocId+".xlsx";
File upFile1=new File(destinationPath+"QCF\\"+tempDocId);

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
ArrayList totalVendorLandedPriceAL= new ArrayList(); 
ArrayList materialAL= new ArrayList();
Hashtable vendorPriceHT =  new Hashtable();
Hashtable vendorPriceALHT =  new Hashtable();
Hashtable vendorLandedPriceHT =  new Hashtable();
Hashtable vendorLandedPriceALHT =  new Hashtable();
Hashtable revisedTotalVendorLandedPriceALHT =  new Hashtable();
Hashtable quotedTotalVendorLandedPriceALHT =  new Hashtable();
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
	ReturnObjFromRetrieve rfqQuoteHistoryRet 	= null;
	 	
	int qcfDetailsRetCnt 	= 0;
		int rfqHeaderRetCnt 	= 0;
		int itemsRetObjCnt 	= 0;
	int rfqConditionsRetCnt = 0;
 	int rfqQuoteHistoryRetCnt = 0;
	
	EziRFQHeaderParams  inputParams = new EziRFQHeaderParams();

	inputParams.setCollectiveRFQNo(docId);
	inputParams.setStatus("Y");

inputParams.setExt1("LATEST','PREVIOUS");	

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
	rfqQuoteHistoryRet	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQQuoteHistory();
//out.println("itemsRetObj::::"+itemsRetObj.toEzcString());
//out.println(rfqConditionsRet.toEzcString());

	if(rfqHeaderRet!=null)
		rfqHeaderRetCnt    = rfqHeaderRet.getRowCount();
	if(itemsRetObj!=null)
		itemsRetObjCnt   = itemsRetObj.getRowCount();
	if(rfqConditionsRet!=null)
		rfqConditionsRetCnt= rfqConditionsRet.getRowCount();
	if(rfqQuoteHistoryRet!=null)
 		rfqQuoteHistoryRetCnt= rfqQuoteHistoryRet.getRowCount();


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
		
		//out.println(vendorStr);
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
//out.println(vendorPriceALHT);
int materialCnt=0;
if(materialAL!=null)materialCnt = materialAL.size();
//out.println(rfqConditionsRet.toEzcString());
ArrayList duplicateTaxCodeAL= new ArrayList();

Vector quoteFlagIndexes=rfqQuoteHistoryRet.where(new String[]{"ERQH_QUOTE_FLAG"},new String[]{"PREVIOUS"});

if(quoteFlagIndexes!=null)
{
	for(int v=0;v<quoteFlagIndexes.size();v++)
	{
		int index = Integer.parseInt(quoteFlagIndexes.get(v)+"");

		if(index>=0)
		{

		String taxCode	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_CODE"));
		String taxVendor= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_VENDOR"));
		String taxValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_VALUE"));
		String revisedTaxValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_VALUE"));
		String taxType	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_TYPE"));
		String lineNo	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_LINE_NO"));
		String taxTotalValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_TOT_VALUE"));
		String finalValue= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_EXT1"));
		String temp=taxCode;

		/*if(materialTaxCodesHT.containsKey(lineNo))
		{
			temp = (String)materialTaxCodesHT.get(lineNo);
			//if(temp.indexOf(taxCode)<0)
			if(!duplicateTaxCodeAL.contains(taxCode))
			temp=taxCode+"#"+temp;

			materialTaxCodesHT.remove(lineNo);
		}
		if(!duplicateTaxCodeAL.contains(taxCode))
		duplicateTaxCodeAL.add(taxCode);

		materialTaxCodesHT.put(lineNo,temp);*/

		if("0".equals(taxValue) || "".equals(taxValue))taxValue="0.00";
		if("0".equals(taxTotalValue) || "".equals(taxTotalValue))taxTotalValue="0.00";
		if("0".equals(finalValue) || "".equals(finalValue))finalValue="0.00";


		materialVendTaxValueHT.put(lineNo+taxVendor+taxCode,taxValue+"#"+taxType+"#"+taxTotalValue+"#"+finalValue);
		}
	}
}
//out.println(materialVendTaxValueHT);
 quoteFlagIndexes=rfqQuoteHistoryRet.where(new String[]{"ERQH_QUOTE_FLAG"},new String[]{"LATEST"});
//out.println(quoteFlagIndexes.size()+"::::::::::");
if(quoteFlagIndexes!=null)
{
	for(int v=0;v<quoteFlagIndexes.size();v++)
	{
		int index = Integer.parseInt(quoteFlagIndexes.get(v)+"");

		if(index>=0)
		{

		String taxCode	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_CODE"));
		String taxVendor= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_VENDOR"));
		String taxValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_VALUE"));
		String revisedTaxValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_VALUE"));
		String taxType	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_TYPE"));
		String lineNo	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_LINE_NO"));
		String taxTotalValue	= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_COND_TOT_VALUE"));
		String finalValue= checkNull(rfqQuoteHistoryRet.getFieldValueString(index,"ERQH_EXT1"));
		String temp=taxCode;

		if(materialTaxCodesHT.containsKey(lineNo))
		{
			temp = (String)materialTaxCodesHT.get(lineNo);
			//if(temp.indexOf(taxCode)<0)
			if(!duplicateTaxCodeAL.contains(lineNo+taxCode))
			temp=taxCode+"#"+temp;

			materialTaxCodesHT.remove(lineNo);
		}
		if(!duplicateTaxCodeAL.contains(lineNo+taxCode))
		duplicateTaxCodeAL.add(lineNo+taxCode);

		materialTaxCodesHT.put(lineNo,temp);

		if("0".equals(taxValue) || "".equals(taxValue))taxValue="0.00";
		if("0".equals(taxTotalValue) || "".equals(taxTotalValue))taxTotalValue="0.00";
		if("0".equals(finalValue) || "".equals(finalValue))finalValue="0.00";


		revisedMaterialVendTaxValueHT.put(lineNo+taxVendor+taxCode,revisedTaxValue+"#"+taxType+"#"+taxTotalValue+"#"+finalValue);
		}
	}
}


java.math.BigDecimal 	totalRevisedLandedCost= new java.math.BigDecimal("0");
java.math.BigDecimal 	totalQuotedLandedCost= new java.math.BigDecimal("0");
//out.println(materialTaxCodesHT);
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
	
	if(document.myForm.vendorSelected.value=="N")
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
function funSelRank(that,type)
{
	if(that.checked)
	{
		document.myForm.rankType.value=type;
		document.myForm.vendorSelected.value="Y";
		var matObj = document.myForm.material;
		var matLen = matObj.length;

		if(isNaN(matLen))matLen=1;
		for(i=0;i<matLen;i++)
		{
			if(matLen==1)
			{
				if(type=="OVERALL")
				funCheckObj(eval("document.myForm.rank"+(matObj.value)),that.value);
				else
				funCheckObj(document.myForm.overallRank,that.value);
			}
			else
			{
				if(type=="OVERALL")
				funCheckObj(eval("document.myForm.rank"+(matObj[i].value)),that.value);
				else
				funCheckObj(document.myForm.overallRank,that.value);
			}
		}
	}
}
function funCheckObj(chkObj,vendor)
{
	var chkLen = chkObj.length;
	var checkedCnt=0;
	
	
	if(isNaN(chkLen))
	{
	
		if(vendor==((chkObj.value).split("#")[0]))
		chkObj.checked=true;
	}else{

		for(i=0;i<chkLen;i++)
		{
		
			if(vendor==((chkObj[i].value).split("#")[0]))
			chkObj[i].checked=true;
			else
			chkObj[i].checked=false;
		}
	}

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
  line-height: inherit !important;
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
<input type="hidden" name="rankType" value=""> 
<input type="hidden" name="vendorSelected" value="N">
<input type="hidden" name="itemCnt" value="<%=materialCnt%>"> 
<input type="hidden" name="excelFilePath" value="<%=excelFilePath%>">
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
			int maxRowNumber=0;
			style = wb.createCellStyle();
			style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setBorderLeft(CellStyle.BORDER_THIN);
			
			row  = sheet.createRow((short) maxRowNumber);
			
			cell = row.createCell((short) 0);
			cell.setCellValue("Name of the party");
			cell.setCellStyle(style);
			
			sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4));
			sheet.autoSizeColumn(0,true); 

 			  RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			  RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			  RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			  RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
 
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

				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 				
				maxColNumber=maxColNumber+4;
			%>
				<th colspan=4 style="width:400px;text-align:center"><%=vendorName%></th>
			<%
			}
			maxRowNumber=maxRowNumber+1;
			%>
			</tr>
			<!--<tr style="width:100px;background-color:palegreen !important">
			<th colspan=5 style="width:500px;text-align:left">Make</th>
			<%
			String vendorName="";
			/*style = wb.createCellStyle();
			style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
style.setBorderLeft(CellStyle.BORDER_THIN);

			row  = sheet.createRow((short) maxRowNumber+1);
			cell = row.createCell((short) 0);
			cell.setCellValue("Make");
			cell.setCellStyle(style);
						
			sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 4));
			sheet.autoSizeColumn(0,true); 
			
			RegionUtil.setBorderBottom(1, new CellRangeAddress(1, 1, 0, 4), sheet); 
			RegionUtil.setBorderTop(1, new CellRangeAddress(1, 1, 0, 4), sheet); 
			RegionUtil.setBorderLeft(1, new CellRangeAddress(1, 1, 0, 4), sheet); 
			RegionUtil.setBorderRight(1, new CellRangeAddress(1, 1, 0, 4), sheet); 
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
				RegionUtil.setBorderBottom(1, new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(1, 1, maxColNumber+1, maxColNumber+2), sheet); 
				
				maxColNumber=maxColNumber+2;

				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue(vendorName);
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				
				maxColNumber=maxColNumber+2;
				*/
			%>
			<th colspan=2 style="width:200px;text-align:center"><%=vendorName%></th>
			<th colspan=2 style="width:200px;text-align:center"><%=vendorName%></th>
			<%
			//}
			//maxRowNumber=maxRowNumber+1;
			%>
			</tr>-->
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

			row  = sheet.createRow((short) maxRowNumber);
			cell = row.createCell((short) 0);
			cell.setCellValue("Quotation Ref.No. & Date");
			cell.setCellStyle(style);
						
			sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4));
			sheet.autoSizeColumn(0,true); 
			RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, 0, 4), sheet); 
			
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

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 

					maxColNumber=maxColNumber+2;

					//row  = sheet.createRow((short) 0);
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(supplierdata);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 

					maxColNumber=maxColNumber+2;
				%>
				<th colspan=2 style="width:200px;text-align:center"><%=supplierdata%></th>
				<th colspan=2 style="width:200px;text-align:center"><%=supplierdata%></th>
				<%
				}
				maxRowNumber=maxRowNumber+1;
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

				row  = sheet.createRow((short) maxRowNumber);
				
				cell = row.createCell((short) 0);
				cell.setCellValue("S.No.");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber+1, 0, 0));
				sheet.autoSizeColumn(0,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 0, 0), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 0, 0), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 0, 0), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 0, 0), sheet); 

				cell = row.createCell((short) 1);
				cell.setCellValue("TAG NO");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber+1, 1, 1));
				sheet.autoSizeColumn(1,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 1, 1), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 1, 1), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 1, 1), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 1, 1), sheet); 				

				cell = row.createCell((short) 2);
				cell.setCellValue("Description");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber+1, 2, 2));
				sheet.autoSizeColumn(2,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 2, 2), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 2, 2), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 2, 2), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 2, 2), sheet); 				

				cell = row.createCell((short) 3);
				cell.setCellValue("UoM");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber+1, 3, 3));
				sheet.autoSizeColumn(3,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 3, 3), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 3, 3), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 3, 3), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 3, 3), sheet); 

				cell = row.createCell((short) 4);
				cell.setCellValue("Qty");
				cell.setCellStyle(style);
				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber+1, 4, 4));
				sheet.autoSizeColumn(4,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 4, 4), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 4, 4), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 4, 4), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber+1, 4, 4), sheet); 				
				
				maxColNumber=4;
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
				String vendorCode 	= (String)suppIds.nextElement();
				
				//row  = sheet.createRow((short) 0);
				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Quoted Price");
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				
				maxColNumber=maxColNumber+2;

				cell = row.createCell((short) maxColNumber+1);
				cell.setCellValue("Revised");
				cell.setCellStyle(style);

				sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
				sheet.autoSizeColumn(maxColNumber+1,true); 
				RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
				RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 				

				maxColNumber=maxColNumber+2;
				%>
					<th colspan=2 style="width:200px;text-align:center">Quoted Price</th>
					<th colspan=2 style="width:200px;text-align:center">Revised</th>
				<%
				}
				maxRowNumber= maxRowNumber+1;
				%>
			</tr>
			<tr style="background-color:khaki !important">
				<%
				row  = sheet.createRow((short) maxRowNumber);
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
					
					desc=desc.replaceAll("\"","``");
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
					<td style="width:100px;text-align:center" ><input type="hidden" name="material" value="<%=matNumber%>"><%=Integer.parseInt(matNumber)%>&nbsp;</td>
					<td style="width:100px;text-align:center;" ><%=desc%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=uom%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=qty%>&nbsp;</td>
					<%
						suppIds  = vendorsHT.keys();
						while(suppIds.hasMoreElements())
						{
							String vendorCode 	= (String)suppIds.nextElement();
							String rfq 	= (String)vendorsHT.get(vendorCode);
							
							//java.math.BigDecimal quotedPriceBD = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
							//java.math.BigDecimal revisedPriceBD= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);
							
							java.math.BigDecimal quotedPriceBD = new java.math.BigDecimal("10");
							java.math.BigDecimal revisedPriceBD= new java.math.BigDecimal("10");
							
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
							
cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
							cell = row.createCell((short) 1);
							cell.setCellValue(taxCodeName);
							cell.setCellStyle(style);
							sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
							sheet.autoSizeColumn(1,true); 
							RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
							RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
							RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
							RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					
							cell = row.createCell((short) 3);
							cell.setCellValue("");
							cell.setCellStyle(style);
							sheet.autoSizeColumn(3); 

							cell = row.createCell((short) 4);
							cell.setCellValue("");
							cell.setCellStyle(style);
							sheet.autoSizeColumn(4); 

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
							
							if("V".equals(taxType))
							{
								taxType="";

								try{
								taxValue=new java.math.BigDecimal(taxValue).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"";
								revisedValue=new java.math.BigDecimal(revisedValue).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"";
								}catch(Exception e){}
							}
							if("P".equals(taxType))taxType="%";

							if("".equals(revisedValue))revisedValue="0.00";
							if("".equals(taxValue))taxValue="0.00";

							try{
								taxAmount = new java.math.BigDecimal(checkNullNum(((String)materialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[2])).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"";
								revisedAmount = new java.math.BigDecimal(checkNullNum(((String)revisedMaterialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[2])).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"";
							}catch(Exception e){}							
							
							quotedtaxAmountHT.put(vendorCode,taxAmount);
							revisedtaxAmountHT.put(vendorCode,revisedAmount);
							

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(taxValue+""+taxType);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(taxAmount);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedValue+""+taxType);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedAmount);
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;
							//out.println(":::::code:::::"+taxCodeArr[i]+"::::actualAmount::::"+quotedAmountBD+":::::taxAmount::::::"+taxAmount+"::::::quotedLandedCost:::::::::"+quotedLandedCost);
							%>
								<td style="width:100px;text-align:center"><%=taxValue%><%=taxType%>&nbsp;</td>
								<td style="width:100px;text-align:center"><%=taxAmount%>&nbsp;</td>
								<td style="width:100px;text-align:center"><%=revisedValue%><%=taxType%>&nbsp; </td>
								<td style="width:100px;text-align:center"><%=revisedAmount%>&nbsp;</td>
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
							cell = row.createCell((short) 3);
							cell.setCellValue("");
							cell.setCellStyle(style);
							sheet.autoSizeColumn(3); 

							cell = row.createCell((short) 4);
							cell.setCellValue("");
							cell.setCellStyle(style);
							sheet.autoSizeColumn(4); 							
							maxRowNumber=maxRowNumber+1;
							maxColNumber=4;
							suppIds  = vendorsHT.keys();
							while(suppIds.hasMoreElements())
							{
							String vendorCode 	= (String)suppIds.nextElement();
							String taxValue="",taxAmount="0.00",revisedAmount="0.00";
							
							try{
								quotedLandedCost= new BigDecimal(checkNullNum(((String)materialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[3]));
								revisedLandedCost= new BigDecimal(checkNullNum(((String)revisedMaterialVendTaxValueHT.get(lineNo+vendorCode+taxCodeArr[i])).split("#")[3]));
							}catch(Exception e){}
							
							quotedlandedCostHT.put(vendorCode,quotedLandedCost);
							revisedlandedCostHT.put(vendorCode,revisedLandedCost);
							
							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue("");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;
							
							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;

							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue("");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;
							
							
							cell = row.createCell((short) maxColNumber+1);
							cell.setCellValue(revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
							cell.setCellStyle(styleAmount);
							sheet.autoSizeColumn(maxColNumber+1); 
							maxColNumber=maxColNumber+1;
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
					
					cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Landed Cost");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	
					
					maxRowNumber=maxRowNumber+1;
					
					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 					
						
					maxColNumber=4;
					suppIds  = vendorsHT.keys();
					materialAL=new ArrayList();
					ArrayList landedPriceAL=new ArrayList();
					while(suppIds.hasMoreElements())
					{
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
					
					String rfq 	= (String)vendorsHT.get(vendorCode);
					
					if(!materialAL.contains(matNumber))
					{
					materialAL.add(matNumber);
					landedPriceAL= new ArrayList();
					}
					landedPriceAL.add(revisedLandedCost);
					Collections.sort(landedPriceAL);
					
					vendorLandedPriceALHT.put(matNumber,landedPriceAL);
					
					vendorLandedPriceHT.put(matNumber+rfq,quotedLandedCost+"#"+revisedLandedCost);
					
					if(revisedTotalVendorLandedPriceALHT.containsKey(vendorCode))
					{
						totalRevisedLandedCost = revisedLandedCost.add(((BigDecimal)(revisedTotalVendorLandedPriceALHT.get(vendorCode))));
					}else
					totalRevisedLandedCost = revisedLandedCost;
					
					if(quotedTotalVendorLandedPriceALHT.containsKey(vendorCode))
					{
						totalQuotedLandedCost = quotedLandedCost.add(((BigDecimal)(quotedTotalVendorLandedPriceALHT.get(vendorCode))));
					}else
					totalQuotedLandedCost = quotedLandedCost;
					
					
					revisedTotalVendorLandedPriceALHT.put(vendorCode,totalRevisedLandedCost);
					quotedTotalVendorLandedPriceALHT.put(vendorCode,totalQuotedLandedCost);
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;
					%>
						<td style="width:100px;text-align:center">&nbsp;</td>
						<td style="width:100px;text-align:center"><b><%=quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
						<td style="width:100px;text-align:center">&nbsp; </td>
						<td style="width:100px;text-align:center"><b><%=revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
					<%
					}
					//out.println(vendorLandedPriceALHT);
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Rank");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	

					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 

					maxRowNumber=maxRowNumber+1;
										
					maxColNumber=4;
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					
					String rfq 	= (String)vendorsHT.get(vendorCode);
					
					//priceAL = (ArrayList)vendorPriceALHT.get(matNumber);
					priceAL = (ArrayList)vendorLandedPriceALHT.get(matNumber);
												
					//java.math.BigDecimal quotedPrice = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
					//java.math.BigDecimal revisedPrice= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);
					
					java.math.BigDecimal quotedPrice = new java.math.BigDecimal(((String)vendorLandedPriceHT.get(matNumber+rfq)).split("#")[0]);
					java.math.BigDecimal revisedPrice= new java.math.BigDecimal(((String)vendorLandedPriceHT.get(matNumber+rfq)).split("#")[1]);					

					String rankStr="",vendorCodeStr="";

					try{
						vendorCodeStr=(Integer.parseInt(vendorCode))+"";
					}catch(Exception e){}
					try{
						//rankStr=(priceAL.indexOf(revisedPrice))+"";
						rankStr=(priceAL.indexOf(revisedPrice))+"";
						if(Integer.parseInt(rankStr)>=0)rankStr=(Integer.parseInt(rankStr)+1)+"";
					}catch(Exception e){}

					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);					
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("Rank: "+rankStr); 
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 						
					
					maxColNumber=maxColNumber+4;
					%>
						<td style="width:400px;text-align:center" colspan=4><b>Rank:<%=rankStr%></b>&nbsp;&nbsp;&nbsp;<input type="radio" name="rank<%=matNumber%>" onClick="funSelRank(this,'MATERIAL')" value="<%=vendorCodeStr+"#"+matNumber%>"><input type="hidden" name="participatedVendors" value="<%=vendorCodeStr+"#"+desc+"#"+rfq+"#"+matNumber%>">&nbsp;</td>
					<%
					}
					%>
				</tr>
				
			
			<%
			j=j+1;
				}
				Enumeration enumeration = revisedTotalVendorLandedPriceALHT.keys();
				while (enumeration.hasMoreElements()) 
				{ 

					String vendorkey=(String) enumeration.nextElement();
					totalVendorLandedPriceAL.add(revisedTotalVendorLandedPriceALHT.get(vendorkey));
				}
				Collections.sort(totalVendorLandedPriceAL);
			%>
				
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Price Basis:</td>
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Price Basis");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	
					
					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 

					maxRowNumber=maxRowNumber+1;
					
					maxColNumber=4;
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
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(incoterm);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(incoterm);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2; 
					%>
						<td style="width:200px;text-align:center" colspan=2><%=incoterm%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=incoterm%>&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Payment Terms:</td>
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Payment Terms");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	
					
					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 					
					maxRowNumber=maxRowNumber+1;
					
					maxColNumber=4;
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
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(paymentTerms);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(paymentTerms);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;
					%>
						<td style="width:200px;text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
					<%
					}
					%>
				</tr>
<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Delivery Period:</td>
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Delivery Period");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	

					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 					
					maxRowNumber=maxRowNumber+1;
					
					maxColNumber=4;
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
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(deliveryPeriod);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(deliveryPeriod);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;						
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Guarantee Period");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	

					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 
					maxRowNumber=maxRowNumber+1;

					maxColNumber=4;
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
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(guaranteePeriod);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(guaranteePeriod);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;						
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
					cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Validity of offer");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	
					
					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 					
					maxRowNumber=maxRowNumber+1;

					maxColNumber=4;
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
					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(quoteValidity);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 						
					
					maxColNumber=maxColNumber+2;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(quoteValidity);
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+2), sheet); 	
					
					maxColNumber=maxColNumber+2;	
					%>
						<td style="width:200px;text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
						<td style="width:200px;text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
					<%
					}
					%>
				</tr>	

				<tr style="background-color:coral">
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Vendor Overall Landed Cost</td>
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
					
					cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 
					
					cell = row.createCell((short) 1);
					cell.setCellValue("Vendor Overall Landed Cost");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	
					
					maxRowNumber=maxRowNumber+1;
					
					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 					
						
					maxColNumber=4;
					
					suppIds  = vendorsHT.keys();
					materialAL=new ArrayList();
					ArrayList landedPriceAL=new ArrayList();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					java.math.BigDecimal	quotedLandedCost = new java.math.BigDecimal("0");
					java.math.BigDecimal 	revisedLandedCost= new java.math.BigDecimal("0");
					
					

					try{
						quotedLandedCost = (java.math.BigDecimal)quotedTotalVendorLandedPriceALHT.get(vendorCode);
						revisedLandedCost = (java.math.BigDecimal)revisedTotalVendorLandedPriceALHT.get(vendorCode);
					}catch(Exception e){
						quotedLandedCost = new java.math.BigDecimal("0");
						revisedLandedCost= new java.math.BigDecimal("0");
					}
					if(quotedLandedCost==null)quotedLandedCost = new java.math.BigDecimal("0");
					if(revisedLandedCost==null)revisedLandedCost = new java.math.BigDecimal("0");
					
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;
					
					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue(revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(maxColNumber+1); 
					maxColNumber=maxColNumber+1;
					%>
						<td style="width:100px;text-align:center">&nbsp;</td>
						<td style="width:100px;text-align:center"><b><%=quotedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
						<td style="width:100px;text-align:center">&nbsp; </td>
						<td style="width:100px;text-align:center"><b><%=revisedLandedCost.setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%></b>&nbsp;</td>
					<%
					}
					//out.println(vendorLandedPriceALHT);
					%>
				</tr>				
				<tr>
					<td style="width:100px;">&nbsp;</td>
					<td style="width:200px;text-align:left" colspan=2>&nbsp;Vendor Overall Rank</td>
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

cell = row.createCell((short) 0);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(0); 

					cell = row.createCell((short) 1);
					cell.setCellValue("Vendor Overall Rank");
					cell.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress( maxRowNumber+1,  maxRowNumber+1, 1, 2));
					sheet.autoSizeColumn(1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber+1,  maxRowNumber+1, 1, 2), sheet); 	

					cell = row.createCell((short) 3);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(3); 

					cell = row.createCell((short) 4);
					cell.setCellValue("");
					cell.setCellStyle(style);
					sheet.autoSizeColumn(4); 

					maxRowNumber=maxRowNumber+1;

					maxColNumber=4;
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();

					String rfq 	= (String)vendorsHT.get(vendorCode);

					java.math.BigDecimal revisedPrice=(((BigDecimal)revisedTotalVendorLandedPriceALHT.get(vendorCode)));					

					String rankStr="",vendorCodeStr="";

					try{
						vendorCodeStr=(Integer.parseInt(vendorCode))+"";
					}catch(Exception e){}
					try{
						//rankStr=(priceAL.indexOf(revisedPrice))+"";
						rankStr=(totalVendorLandedPriceAL.indexOf(revisedPrice))+"";
						if(Integer.parseInt(rankStr)>=0)rankStr=(Integer.parseInt(rankStr)+1)+"";
					}catch(Exception e){}

					style = wb.createCellStyle();
					style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
					style.setFillPattern(CellStyle.SOLID_FOREGROUND);
					style.setAlignment(CellStyle.ALIGN_CENTER);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setBorderLeft(CellStyle.BORDER_THIN);					

					cell = row.createCell((short) maxColNumber+1);
					cell.setCellValue("Rank: "+rankStr); 
					cell.setCellStyle(style);

					sheet.addMergedRegion(new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4));
					sheet.autoSizeColumn(maxColNumber+1,true); 
					RegionUtil.setBorderBottom(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderTop(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderLeft(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 
					RegionUtil.setBorderRight(1, new CellRangeAddress(maxRowNumber, maxRowNumber, maxColNumber+1, maxColNumber+4), sheet); 						

					maxColNumber=maxColNumber+4;
					%>
						<td style="width:400px;text-align:center" colspan=4><b>Rank:<%=rankStr%></b>&nbsp;&nbsp;&nbsp;<input type="radio" name="overallRank"  onClick="funSelRank(this,'OVERALL')" value="<%=vendorCodeStr%>">&nbsp;</td>
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
outputStream.flush();
outputStream.close();
}
taxesHT=null;
vendorsHT=null;
vendorPriceHT =  null;
vendorPriceALHT =  null;
vendorLandedPriceHT =  null;
vendorLandedPriceALHT =  null;
revisedTotalVendorLandedPriceALHT=null;
totalVendorLandedPriceAL=null;
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

