<%@ page language="java" %>
<%@ page import="java.util.*,jxl.*,jxl.write.*,java.io.File,java.io.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve"%>

<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />


<%
	String ReQuote = request.getParameter("ReQuote");
	String RFQNo   = request.getParameter("PurchaseOrder");
  	//File file = File.createTempFile("QuoteRFQ",".xls");
  	String userId= (String) Session.getUserId();
	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);
	
  	 ByteArrayOutputStream fileOut=null;
	
	ReturnObjFromRetrieve rowsRetObj=null;
	rowsRetObj=(ReturnObjFromRetrieve)session.getValue("PORetObj");
	
	int rowsRetObjCount = 0;
	
	rowsRetObjCount = rowsRetObj.getRowCount();
	out.println(rowsRetObj.getFieldValueString("RFQNO"));
	System.out.println("rowsRetObj:"+rowsRetObj.toEzcString());
 try {

 //Writing Data to ExcelSheet
   HSSFWorkbook wb = null;

   //This is for creating Workbook
   	 wb = new HSSFWorkbook();
         HSSFSheet spreadSheet = wb.createSheet("Query_Report");
         HSSFRow row = spreadSheet.createRow(0);
         
         spreadSheet.protectSheet("Ashok"); 
        ///This is for Header Style
         HSSFCellStyle headerCellStyle = wb.createCellStyle();
         headerCellStyle.setFillForegroundColor(HSSFColor.BROWN.index);
         headerCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
         HSSFFont setFont = wb.createFont();
         setFont.setFontHeightInPoints((short)10);
         setFont.setColor(HSSFColor.WHITE.index);
         setFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
         headerCellStyle.setBorderBottom(headerCellStyle.BORDER_THIN);
         headerCellStyle.setFont(setFont);
      
                  
         HSSFCell cell = null;
         
	spreadSheet.setColumnWidth((short)0, (short) (256 * 15));
	spreadSheet.setColumnWidth((short)1, (short) (256 * 10));
	spreadSheet.setColumnWidth((short)2, (short) (256 * 20));
	spreadSheet.setColumnWidth((short)3, (short) (256 * 45));
	spreadSheet.setColumnWidth((short)4, (short) (256 * 10));
	spreadSheet.setColumnWidth((short)5, (short) (256 * 15));
	spreadSheet.setColumnWidth((short)6, (short) (256 * 15));
	spreadSheet.setColumnWidth((short)7, (short) (256 * 15));
	spreadSheet.setColumnWidth((short)8, (short) (256 * 100));
	spreadSheet.setColumnWidth((short)9, (short) (256 * 100));
	
	if(!"Y".equals(ReQuote))
	{
	spreadSheet.setColumnWidth((short)10, (short) (256 * 25));
	spreadSheet.setColumnWidth((short)11, (short) (256 * 25));
	spreadSheet.setColumnWidth((short)12, (short) (256 * 25));
	spreadSheet.setColumnWidth((short)13, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)14, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)15, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)16, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)17, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)18, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)19, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)20, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)21, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)22, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)23, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)24, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)25, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)26, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)27, (short) (256 * 35));
	spreadSheet.setColumnWidth((short)28, (short) (256 * 35));
	}
	
         cell = row.createCell((short) 0);
         cell.setCellValue("RFQNO");
         cell.setCellStyle(headerCellStyle);
         
         cell = row.createCell((short) 1);
         cell.setCellValue("LINE");
         cell.setCellStyle(headerCellStyle);
         
         
	cell = row.createCell((short) 2);
	cell.setCellValue("MATERIAL");
	cell.setCellStyle(headerCellStyle);
         

	cell = row.createCell((short) 3);
	cell.setCellValue("MATERIAL_DESC");
	cell.setCellStyle(headerCellStyle);


	cell = row.createCell((short) 4);
	cell.setCellValue("UOM");
	cell.setCellStyle(headerCellStyle);


	cell = row.createCell((short) 5);
	cell.setCellValue("QUANTITY	");
	cell.setCellStyle(headerCellStyle);


	cell = row.createCell((short) 6);
	cell.setCellValue("PRICE");
	cell.setCellStyle(headerCellStyle);
	
	cell = row.createCell((short) 7);
	cell.setCellValue("CURRENCY");
	cell.setCellStyle(headerCellStyle);
	
	cell = row.createCell((short) 8);
	cell.setCellValue("ITEM NOTES");
	cell.setCellStyle(headerCellStyle);
	
	
	cell = row.createCell((short) 9);
	cell.setCellValue("VENDOR NOTES");
	cell.setCellStyle(headerCellStyle);
	
	if(!"Y".equals(ReQuote))
	{
		cell = row.createCell((short) 10);
		cell.setCellValue("RA01[Discount % on Gross]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 11);
		cell.setCellValue("RB00[Absolute discount]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 12);
		cell.setCellValue("RC00[Discount/Quantity]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 13);
		cell.setCellValue("ZPA1[Packing and forw %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 14);
		cell.setCellValue("ZPB1[Packing and forw-val]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 15);
		cell.setCellValue("ZPC1[Packing and forw/qty]");
		cell.setCellStyle(headerCellStyle);
		cell = row.createCell((short) 16);
		cell.setCellValue("FRA1[Freight %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 17);
		cell.setCellValue("FRB1[Freight (Value)]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 18);
		cell.setCellValue("FRC1 [ Freight/Quantity]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 19);
		cell.setCellValue("ZIN1 [Insurance %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 20);
		cell.setCellValue("ZEX1[Excise for information %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 21);
		cell.setCellValue("ZEX1[Excise for information (value)]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 22);
		cell.setCellValue("ZVAT [ VAT %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 23);
		cell.setCellValue("WCTQWCT [for Info]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 24);
		cell.setCellValue("ZCST[Central sales Tax %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 25);
		cell.setCellValue("ZSRT [Service Tax]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 26);
		cell.setCellValue("ZP20[Overseas Freight %]");
		cell.setCellStyle(headerCellStyle);

		cell = row.createCell((short) 27);
		cell.setCellValue("ZP21[Overseas Freight value]");
		cell.setCellStyle(headerCellStyle);


		cell = row.createCell((short) 28);
		cell.setCellValue("ZP22[Overseas Freight Quantity]");
		cell.setCellStyle(headerCellStyle);

	}
         
         
         //This is for Data Style
         HSSFCellStyle dataCellStyle = wb.createCellStyle();
         HSSFFont setDataFont = wb.createFont();
         setDataFont.setColor(HSSFColor.LIGHT_BLUE.index);
         dataCellStyle.setBorderBottom(dataCellStyle.BORDER_THIN);
         dataCellStyle.setFont(setDataFont);
         
         
	//This is for Price Data Style
	HSSFCellStyle PriceCellStyle = wb.createCellStyle();
	HSSFFont setPriceFont = wb.createFont();
	setPriceFont.setColor(HSSFColor.LIGHT_BLUE.index);
	PriceCellStyle.setBorderBottom(PriceCellStyle.BORDER_THIN);
	PriceCellStyle.setFont(setPriceFont);
	PriceCellStyle.setLocked(false);

        
        HSSFCellStyle taxesCellStyle = wb.createCellStyle();
        if("Y".equals(ReQuote))taxesCellStyle=dataCellStyle;
        else taxesCellStyle=PriceCellStyle;
        
         
        for(int i=0;i<rowsRetObjCount;i++) 
        {
         
         row = spreadSheet.createRow((short) i+1); //First Data Row
         
	cell = row.createCell((short) 0);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"RFQNO"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 1);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"LINE"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 2);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"ITEM"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 3);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"ITEMDESCRIPTION"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 4);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"UOM"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 5);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"QUANTITY"));
	cell.setCellStyle(PriceCellStyle);

	cell = row.createCell((short) 6);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"PRICE"));
	cell.setCellStyle(PriceCellStyle);

	cell = row.createCell((short) 7);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"CURRENCY"));
	cell.setCellStyle(dataCellStyle);

	cell = row.createCell((short) 8);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"ITEMNOTE"));
	cell.setCellStyle(dataCellStyle);


	cell = row.createCell((short) 9);
	cell.setCellValue(rowsRetObj.getFieldValueString(i,"VENDITEMNOTE"));
	cell.setCellStyle(taxesCellStyle);

	if(!"Y".equals(ReQuote))
	{

		cell = row.createCell((short) 10);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 11);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 12);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 13);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 14);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 15);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 16);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 17);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 18);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 19);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 20);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 21);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 22);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 23);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 24);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 25);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);

		cell = row.createCell((short) 26);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);


		cell = row.createCell((short) 27);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);


		cell = row.createCell((short) 28);
		cell.setCellValue("");
		cell.setCellStyle(taxesCellStyle);
	}

	}

      fileOut = new ByteArrayOutputStream();
      wb.write(fileOut);
      
      System.out.println("XL Generated....!");

  } catch (Exception e) {
   e.printStackTrace();
  }
	FileInputStream fileinputstream = null;
	javax.servlet.ServletOutputStream servletoutputstream = null;
	//ByteArrayOutputStream outputStream=null;
	try
	{
		String s2 = "QuoteRFQ_"+userId+"_"+RFQNo+".xls";//file.getName();
		response.setContentType("application/xls");
		response.setHeader("Content-Disposition","attachment;filename=" + s2);
		servletoutputstream = response.getOutputStream();
		fileOut.writeTo(servletoutputstream);		

	}
	catch(IOException ioexception)
	{
		out.println("Got exception  : " + ioexception);
	}
	finally
	{
		try
		{
		servletoutputstream.flush();
		fileOut.close();
		}catch(Exception clex){}

	}



%>