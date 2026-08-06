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
 		cal.add(Calendar.DATE, -10);
 		Date fromDateObj = cal.getTime();

 		toDate = convertDateObjToString(toDateObj); 
 		fromDate = convertDateObjToString(fromDateObj); 
 	}  
 	    
%>