<%
	if((fromDate== null && toDate == null) || ("null".equals(fromDate) && "null".equals(toDate)) || ("".equals(fromDate) && "".equals(toDate)))
	{
		Date toDateObj=new Date();
		String toDay="",toMonth="",toYear="";
		String fromDay="",fromMonth="",fromYear="";

		toDay=""+(toDateObj.getDate());
		if(toDateObj.getDate()<10)
			toDay="0"+toDateObj.getDate();

		toMonth=""+(toDateObj.getMonth()+1);
		if((toDateObj.getMonth()+1)<10)
			toMonth="0"+(toDateObj.getMonth()+1);

		toYear=""+(toDateObj.getYear()+1900);

		toDate = toDay+"/"+toMonth+"/"+toYear;
		
		//out.println("::::::toDate::::toDate:::::"+toDate);

		Date fromDateObj=new Date(toDateObj.getYear(),toDateObj.getMonth(),toDateObj.getDate()-dateRange);

		fromDay=""+fromDateObj.getDate();
		if(fromDateObj.getDate()<10)
			fromDay="0"+fromDateObj.getDate();

		fromMonth=""+(fromDateObj.getMonth()+1);	
		if((fromDateObj.getMonth()+1)<10)
			fromMonth="0"+(fromDateObj.getMonth()+1);

		fromYear=""+(fromDateObj.getYear()+1900);

		fromDate = fromDay+"/"+fromMonth+"/"+fromYear;

		int tempMonth = Integer.parseInt(fromMonth);
		if(tempMonth==1 || tempMonth==2 || tempMonth==3)
			fromYear = (Integer.parseInt(fromYear)-1)+"";
		
		fromDate = "01/04/"+fromYear;
		//fromDate = "01/12/2017";

	}
%>