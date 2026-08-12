<%	

	
	
	String xlsRFQNum = "";
	FileInputStream fs =null;   
	HSSFWorkbook wb = null;
	HSSFSheet mySheet = null;

	
	if (upFile != null)
	{    
		try
		{
			fs = new FileInputStream(upFile); 
			if(fs!=null && !"null".equals(fs))
			wb = new HSSFWorkbook(fs); 
			mySheet = wb.getSheetAt(0); 
			HSSFRow myRow = mySheet.getRow(1);

			HSSFCell myCell = (HSSFCell) myRow.getCell((new Short("0")).shortValue());
			String celValue=(String)myCell.toString();

			xlsRFQNum = celValue;

		}
		catch(Exception Ex){System.out.println(Ex+":::Exception:::");}
		finally{
		if(fs!=null)
		fs.close();
		}				
	}
	//out.println("xlsRFQNum:::"+xlsRFQNum);
%>				