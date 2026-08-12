
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
	ByteArrayOutputStream fileOut=null;
	Workbook wb = new XSSFWorkbook(); //or new HSSFWorkbook();
	Sheet sheet = wb.createSheet("new sheet");

	Row row = sheet.createRow((short) 0);
	Cell cell = row.createCell((short) 1);
	cell.setCellValue("This is a test of merging");

	sheet.addMergedRegion(new CellRangeAddress(0, 0, 1, 2));

	
	  fileOut = new ByteArrayOutputStream();
	wb.write(fileOut);
	
javax.servlet.ServletOutputStream servletoutputstream = null;
	try
	{
		String s2 = "priya.xlsx";		
		
		response.reset(); 
		response.setContentType("application/xlsx");
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