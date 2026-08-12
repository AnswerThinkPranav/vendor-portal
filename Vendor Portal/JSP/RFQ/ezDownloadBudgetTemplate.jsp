<%@ page import="jxl.Sheet,jxl.Workbook,jxl.read.biff.BiffException,jxl.write.*"%>
<%@ page import="ezc.ezparam.*,java.util.*,java.util.Date,java.text.ParseException,java.text.SimpleDateFormat" %>
<%!
public void ezCreateExcel(HttpServletResponse response,String fileName,ArrayList headerData,ArrayList dispColNames,ReturnObjFromRetrieve rowsRetObj,ArrayList retObjCols)
{
	WritableWorkbook workbook = null;
	try
	{
		response.resetBuffer();//added by Ashok
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename="+fileName);
		
		workbook = Workbook.createWorkbook(response.getOutputStream());

		WritableSheet ws = workbook.createSheet("Sheet1", 0);

		for(int j=0;j<headerData.size();j++)
		{
			/*jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
			jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
			
			if(j%2==0)
			{
				boldRedFont.setColour(jxl.format.Colour.BLACK);
				boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
				boldRed.setShrinkToFit(false);
			}
			
			if(j==0)
				boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

			else if(j==(headerData.size()-1))
				boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

			ws.addCell(new Label(j, 0, (String)headerData.get(j), boldRed));*/
			jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
			boldRedFont.setColour(jxl.format.Colour.BLACK);
			jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
			boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
			boldRed.setShrinkToFit(false);

			if(j==0)
				boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

			else if(j==(headerData.size()-1))
				boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

			ws.addCell(new Label(j, 0, (String)headerData.get(j), boldRed));
			ws.setColumnView(j, 18);
		}
		
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

			ws.addCell(new Label(j, 1, (String)dispColNames.get(j), boldRed));
			ws.setColumnView(j, 18);
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
				if(j==retObjCols.size()-1)
				boldRed.setAlignment(Alignment.RIGHT);

				//if(j<7)
				{
					ws.addCell(new Label(j, k+3, rowsRetObj.getFieldValueString(k-1,(String)retObjCols.get(j)), boldRed));
				}
				if(j==9)
				{
					try{
						jxl.write.WritableCellFormat floatFormat = new WritableCellFormat (NumberFormats.FLOAT);
						jxl.write.Number number3 = new jxl.write.Number(j, k+3, Float.parseFloat(rowsRetObj.getFieldValueString(k-1,(String)retObjCols.get(j))), floatFormat);
						ws.addCell(number3);
					}catch(Exception e){
					  ws.addCell(new Label(j, k+3, "", boldRed));
					}
				

				}
				if(j==10)
				{
					try{
						jxl.write.WritableCellFormat floatFormat = new WritableCellFormat (NumberFormats.FLOAT);
						jxl.write.Number number3 = new jxl.write.Number(j, k+3, Float.parseFloat(rowsRetObj.getFieldValueString(k-1,(String)retObjCols.get(j))), floatFormat);
						ws.addCell(number3);
					}catch(Exception e){
					  ws.addCell(new Label(j, k+3, "", boldRed));
					}

				
				}
			}
		}
	}
	catch(Exception e)
	{
		//System.out.println("Following Exception occured in creating JExcel...."+e);
		//e.printStackTrace();
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

	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");  
	Date date = new Date();  
    	String dt = formatter.format(date);  
	
	ReturnObjFromRetrieve rowsRetObj=null;
	ArrayList headerData 	= new ArrayList();
	ArrayList dispColNames 	= new ArrayList();
	ArrayList retObjCols 	= new ArrayList();
	
	
	headerData.add("S.NO");
	headerData.add("Item Code"); 
	headerData.add("Description)");
	headerData.add("UOM");
	headerData.add("Currency");
	headerData.add("Budget Rate FY23");

	try
	{
		//ezCreateExcel(response,"Add_Delivery_Schedule_"+dt+".xls",headerData,dispColNames,rowsRetObj,retObjCols);
		ezCreateExcel(response,"BUDGET FY 23-24"+dt+".xls",headerData,dispColNames,rowsRetObj,retObjCols);
	}
	catch(Exception e)
	{
		//System.out.println("Excel Driver Exception in Page ezDownloadDelSchedExcel.jsp:"+e);
	}
%>