<%@ page import="jxl.Sheet,jxl.Workbook,jxl.read.biff.BiffException,jxl.write.*"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import="ezc.ezparam.*,java.util.*,java.util.Date,java.text.ParseException,java.text.SimpleDateFormat" %>
<%!
public String checkNullinDown(String str)  
 	{ 
 		String retStr = "";
 		 
 		if(str == null || "null".equals(str) || "".equals(str)) 
 			retStr = "";
 		else
 			retStr = str;
 			
 		return retStr;	
	}
public void ezCreateExcel(HttpServletResponse response,String fileName,ArrayList dispColNames,ReturnObjFromRetrieve rowsRetObj,ArrayList retObjCols)
 {
 	WritableWorkbook workbook = null;
 	try
	 	{
	 		response.resetBuffer();
	 		response.setContentType("application/vnd.ms-excel");
	 		response.setHeader("Content-Disposition", "attachment; filename="+fileName);
	 		response.setContentLength(600000);
	 		workbook = Workbook.createWorkbook(response.getOutputStream());
	 
	 		WritableSheet ws = workbook.createSheet("Sheet1", 0);
	 		String empty="";
	 		for(int j=0;j<dispColNames.size();j++)
	 		{
	 			jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
	 			boldRedFont.setColour(jxl.format.Colour.BLACK);
	 			jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
	 			boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
	 			boldRed.setShrinkToFit(false);
	 
	 			if(j==0)
	 				boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 			else if(j==(dispColNames.size()-1))
	 				boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 			ws.addCell(new Label(j, 0, (String)dispColNames.get(j), boldRed));
	 		}
	 
	 		for(int k=1;k<=rowsRetObj.getRowCount();k++)
	 		{
	 			for(int j=0;j<retObjCols.size();j++)
	 			{
	 				jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
	 				jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
	 
	 				if(k==1 && j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				else if(k<rowsRetObj.getRowCount())
	 				{
	 					if(j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 					else if(j==(retObjCols.size()-1))
	 						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				}
	 				else if(k==rowsRetObj.getRowCount())
	 				{
	 					if(j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 					else if(j==(retObjCols.size()-1))
	 						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 
	 					boldRed.setBorder(jxl.format.Border.BOTTOM , jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				}
	 
	 				ws.addCell(new Label(j, k, rowsRetObj.getFieldValueString(k-1,(String)retObjCols.get(j)), boldRed));
	 			}
	 		}
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("Following Exception occured in creating JExcel...."+e);
	 		e.printStackTrace();
	 	}
	 	finally
	 	{
	 		try{
	 			workbook.write();
	 			workbook.close();
	 		}catch(Exception ex){}
 	}
 	
 	
 }
 %>
 


<%

	ReturnObjFromRetrieve budgetExcel=(ReturnObjFromRetrieve)session.getValue("CLR_Report_Ret");
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");  
		Date date = new Date();  
	    	String dt = formatter.format(date);  
		
		ReturnObjFromRetrieve rowsRetObj=null;
		ArrayList headerData 	= new ArrayList();
		ArrayList dispColNames 	= new ArrayList();
		ArrayList retObjCols 	= new ArrayList();
		
		dispColNames.add("S.NO");
		dispColNames.add("Item Code*"); 
		dispColNames.add("Description)");
		dispColNames.add("UOM");
		dispColNames.add("Currency");
		dispColNames.add("Budget Rate FY23");
		
		retObjCols.add("S.NO");
		retObjCols.add("Item Code*"); 
		retObjCols.add("Description)");
		retObjCols.add("UOM");
		retObjCols.add("Currency");
		retObjCols.add("Budget Rate FY23");
		
		
		try
		{
			ezCreateExcel(response,"Budget FY 22-23"+dt+".xls",dispColNames,budgetExcel,retObjCols);
			
		}
		catch(Exception e)
		{
		}
%>