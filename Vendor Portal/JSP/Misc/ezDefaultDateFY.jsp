 <%! 
	public java.util.Date convertStringToDateObj(String inputDate)
	{ 
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		java.util.Date dateObj = null;
		try {
			dateObj = sdf.parse(inputDate);
		} catch (Exception e) {
			
		} 
		return dateObj;
		
	}
	public String convertDateObjToString(java.util.Date inputDate)
	{
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		String stringObj = "";
		try {
			stringObj = sdf.format(inputDate);

		} catch (Exception e) {
			
		}
		return stringObj;
		
	}
%>
<%  
 	String fromDate	=request.getParameter("fromDate");
 	String toDate	=request.getParameter("toDate");
 	String financiyalYearFrom="";		
 	if(fromDate == null || "null".equals(fromDate) || "".equals(fromDate))
 	{
 		Calendar cal = Calendar.getInstance();
 		Date toDateObj = cal.getTime();
 		//cal.add(Calendar.MONTH, -4);
		
		int CurrentYear = Calendar.getInstance().get(Calendar.YEAR);
		int CurrentMonth = (Calendar.getInstance().get(Calendar.MONTH)+1);
		//out.println("CurrentYear:::::::"+CurrentYear);
		//out.println("CurrentMonth::::::"+CurrentMonth);
		if(CurrentMonth<=7) 
		{
			//financiyalYearFrom="01/01/"+(CurrentYear);
			financiyalYearFrom="01/04/"+(CurrentYear-1);
		}
		else
		{
			financiyalYearFrom="01/04/"+(CurrentYear-1);	
		}
 		fromDate = financiyalYearFrom;
 		toDate = convertDateObjToString(toDateObj); 
 	}  
 	    
%>