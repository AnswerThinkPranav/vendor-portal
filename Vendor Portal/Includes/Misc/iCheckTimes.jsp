<%!
	public String getHoursString(String dateObj)
	{
		String dateVal = dateObj.substring(0,10);
		String timeVal = dateObj.substring(11,19);
		java.util.StringTokenizer dateToken = new java.util.StringTokenizer(dateVal,"-");
		int year = Integer.parseInt(dateToken.nextToken());
		int month = Integer.parseInt(dateToken.nextToken());
		int day = Integer.parseInt(dateToken.nextToken());
		dateToken = new java.util.StringTokenizer(timeVal,":");
		int hours = Integer.parseInt(dateToken.nextToken());
		int minutes = Integer.parseInt(dateToken.nextToken());
		int seconds = Integer.parseInt(dateToken.nextToken());

		java.util.Date modDate = new java.util.Date(year-1900,month-1,day,hours,minutes,seconds);
		java.util.Date currentDate = new java.util.Date();
		return checkNextDate(modDate,currentDate);
	}
	public int[] returnNextDay(int curDay,int curMonth,int curYear) 
	{
		String tomorrowsDate = "";
		if (curYear < 100) 
		{
		    if (curYear > 40) 
		    {
			curYear = curYear + 1900;
		    }
		    else 
		    {
			curYear = curYear + 2000;
		    }
		}

		int tomDay = curDay + 1;
		int tomMonth = curMonth;
		int tomYear = curYear;

		if (curMonth == 1 || curMonth == 3 || curMonth == 5 || curMonth == 7 || curMonth == 8 || curMonth == 10 || curMonth == 12) 
		{
		    if (tomDay > 31) 
		    {
			tomMonth = curMonth + 1;
			tomDay = 1;
		    }
		}
		else if (curMonth == 4 || curMonth == 6 || curMonth == 9 || curMonth ==11) 
		{
		    if (tomDay > 30) 
		    {
			tomMonth = curMonth + 1;
			tomDay = 1;
		    }
		}
		else 
		{
		    if ((curYear % 4 == 0) && (!(curYear % 100 == 0) || (curYear % 400) == 0)) 
		    {
			if (tomDay > 29) 
			{
			    tomMonth = 3;
			    tomDay = 1;
			}
		    }
		    else 
		    {
			if (tomDay > 28) 
			{
			    tomMonth = 3;
			    tomDay = 1;
			}
		    }
		}

		if (tomMonth == 13) 
		{
		    tomMonth = 1;
		    tomYear = curYear + 1;
		}
		int[] retInt = {tomDay,tomMonth,tomYear};
		return retInt;
	}
	public String checkNextDate(java.util.Date fromDate,java.util.Date toDate)
	{
		ezc.ezbasicutil.EzHolidayCalendar ezHolidayCalendar = new ezc.ezbasicutil.EzHolidayCalendar();
		long actualTimeInMinutes = (toDate.getTime()-fromDate.getTime())/60000;
		int duration = (int)(((toDate.getTime() - fromDate.getTime())/3600000)/24)+1;
		if(duration > 1)
		{
			java.util.Date checkDate = fromDate;
			int[] gotInt = null;
			boolean isHoliday = false;
			int holidayCount = 0;
			for(int i=0;i<duration;i++)
			{
				if(i==0)
				{
					int[] got_Int = {checkDate.getDate(),checkDate.getMonth(),checkDate.getYear()};
					gotInt = got_Int;
				}	
				else
					gotInt = returnNextDay(checkDate.getDate(),checkDate.getMonth(),checkDate.getYear());
				checkDate = new java.util.Date(gotInt[2],gotInt[1],gotInt[0]);
				isHoliday = ezHolidayCalendar.isHoliday(checkDate);
				if(isHoliday)
					holidayCount++;
			}
			actualTimeInMinutes = actualTimeInMinutes - (holidayCount*24*60);
		}	
		return actualTimeInMinutes+"";
	}	
%>