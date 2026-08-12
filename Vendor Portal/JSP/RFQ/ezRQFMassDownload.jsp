<%@ page language="java" %>
<%@ page import="java.util.*,java.io.File,java.io.*,java.util.Random" %>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>
<%@ page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%
		String userId= (String) Session.getUserId();
		Random randomGenerator = new Random();
		int randomInt = randomGenerator.nextInt(1000);

	  	ByteArrayOutputStream fileOut=null;

		try 
		{

			//Writing Data to ExcelSheet
			HSSFWorkbook wb = null;

			//This is for creating Workbook
			wb = new HSSFWorkbook();
			HSSFSheet spreadSheet = wb.createSheet("Query_Report1");
			HSSFRow row = spreadSheet.createRow(0);


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
			headerCellStyle.setLocked(true);


			HSSFCell cell = null;

			spreadSheet.setColumnWidth((short)0, (short) (256 * 25));
			spreadSheet.setColumnWidth((short)1, (short) (256 * 25));
			spreadSheet.setColumnWidth((short)2, (short) (256 * 25));
			spreadSheet.setColumnWidth((short)3, (short) (256 * 25));
			spreadSheet.setColumnWidth((short)4, (short) (256 * 25));
			spreadSheet.setColumnWidth((short)5, (short) (256 * 100));
		
			cell = row.createCell((short) 0);
			cell.setCellValue("SAP Mat Code");
			cell.setCellStyle(headerCellStyle);

			cell = row.createCell((short) 1);
			cell.setCellValue("Mat Description");
			cell.setCellStyle(headerCellStyle);

			cell = row.createCell((short) 2);
			cell.setCellValue("UOM");
			cell.setCellStyle(headerCellStyle);

			cell = row.createCell((short) 3);
			cell.setCellValue("Quantity");
			cell.setCellStyle(headerCellStyle);


			cell = row.createCell((short) 4);
			cell.setCellValue("Delivery Date(MM/DD/YYYY)");
			cell.setCellStyle(headerCellStyle);

			cell = row.createCell((short) 5);
			cell.setCellValue("ITEM NOTES");
			cell.setCellStyle(headerCellStyle);
			
			//DataFormat format = wb.createDataFormat();

			//This is for Data Style
			HSSFCellStyle dataCellStyle = wb.createCellStyle();
			HSSFFont setDataFont = wb.createFont();
			setDataFont.setColor(HSSFColor.LIGHT_BLUE.index);
			dataCellStyle.setBorderBottom(dataCellStyle.BORDER_THIN);
			dataCellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);

			//dataCellStyle.setDataFormat(wb.createDataFormat().getFormat("0"));
			dataCellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("text"));
			dataCellStyle.setFont(setDataFont);
			dataCellStyle.setLocked(false);

			//This is for DATE Style
			HSSFCellStyle dateCellStyle = wb.createCellStyle();
			HSSFFont setDateFont = wb.createFont();
			setDateFont.setColor(HSSFColor.LIGHT_BLUE.index);
			dateCellStyle.setBorderBottom(dateCellStyle.BORDER_THIN);
			dateCellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);

			//dateCellStyle.setDataFormat(wb.createDataFormat().getFormat("0"));
			dateCellStyle.setDataFormat(wb.createDataFormat().getFormat("m/d/yy")); 
			dateCellStyle.setFont(setDateFont);
			dateCellStyle.setLocked(false);


			//This is for Price Data Style
			HSSFCellStyle quantityCellStyle = wb.createCellStyle();
			HSSFFont setPriceFont = wb.createFont();
			setPriceFont.setColor(HSSFColor.LIGHT_BLUE.index);
			quantityCellStyle.setBorderBottom(quantityCellStyle.BORDER_THIN);
			quantityCellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			//quantityCellStyle.setCellType( HSSFCell.CELL_TYPE_NUMERIC);
			quantityCellStyle.setDataFormat(wb.createDataFormat().getFormat("###0.00"));
			quantityCellStyle.setFont(setPriceFont);
			quantityCellStyle.setLocked(false);


			for(int i=0;i<500;i++) 
			{

				row = spreadSheet.createRow((short) i+1); //First Data Row

				cell = row.createCell((short) 0);
				cell.setCellValue("");
				cell.setCellType(Cell.CELL_TYPE_STRING);
				cell.setCellStyle(dataCellStyle);

				cell = row.createCell((short) 1);
				cell.setCellValue("");
				cell.setCellStyle(dataCellStyle);

				cell = row.createCell((short) 2);
				cell.setCellValue("");
				cell.setCellStyle(dataCellStyle);

				cell = row.createCell((short) 3);
				cell.setCellValue("");
				cell.setCellStyle(quantityCellStyle);

				cell = row.createCell((short) 4);
				cell.setCellValue("");
				cell.setCellStyle(dateCellStyle);
				
				cell = row.createCell((short) 5);
				cell.setCellValue("");
				cell.setCellStyle(dateCellStyle);


			}

			spreadSheet.protectSheet("Ansr"); 

		      fileOut = new ByteArrayOutputStream();
		      wb.write(fileOut);

		      System.out.println("XL Generated....!");

			System.out.println("XL Generated....!"+fileOut);


		} catch (Exception e) { e.printStackTrace();}

		
	javax.servlet.ServletOutputStream servletoutputstream = null;
	try
	{
		String s2 = "UploadMaterials_"+userId+"_"+randomInt+".xls";//file.getName();
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