<%
	String fDate="",fMonth="",fYear="";
	String tDate="",tMonth="",tYear="";
	String formatKey="/";
	java.util.Calendar cdObj1=java.util.Calendar.getInstance();
	int currYear=cdObj1.get(Calendar.YEAR);
	int currMonth=cdObj1.get(Calendar.MONTH);
	int currMonth1=cMonth+1;
	int currDate=cdObj1.get(Calendar.DATE);
	//if((fromDate== null && toDate == null) || ("null".equals(fromDate) && "null".equals(toDate)) || ("".equals(fromDate) && "".equals(toDate)))
	if(fromDate== null || "null".equals(fromDate)|| "".equals(fromDate))
	{
		Date dateObj=new Date(cdObj1.get(Calendar.YEAR),cdObj1.get(Calendar.MONTH)-1,cdObj1.get(Calendar.DATE));
		fDate=dateObj.getDate()+"";
		if(dateObj.getDate()<10)
			fDate="0"+dateObj.getDate();
		fMonth=(dateObj.getMonth()+1)+"";
		if((dateObj.getMonth()+1)<10)
			fMonth="0"+(dateObj.getMonth()+1);
		
		fromDate=fDate+formatKey+fMonth+formatKey+dateObj.getYear();
		out.println("getYeargetYear>>>"+dateObj.getYear());
		
	}
	out.println("fromDate>>>"+fromDate);
	if(toDate == null || "null".equals(toDate) || "".equals(toDate))
	{
		tDate=currDate+"";
		if(currDate<10)
			tDate="0"+currDate;
		tMonth=currMonth1+"";
		if(currMonth1<10)
			tMonth="0"+currMonth1;
		if(currMonth1>11)
			tMonth="12";
		toDate=tDate+formatKey+tMonth+formatKey+currYear;
	}
%>