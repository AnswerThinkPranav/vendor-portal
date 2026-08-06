<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="java.util.*,java.text.*" %>
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.ezwebstats.params.*" %>
<jsp:useBean id="WebStatsManager" class="ezc.ezwebstats.client.EzWebStatsManager">
</jsp:useBean>
<%!
	public String returnNextDay(int curDay,int curMonth,int curYear,String delim) 
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
		/*if(".".equals(delim))
			tomorrowsDate = tomDay + "." + tomMonth + "." + tomYear;
		else*/
			tomorrowsDate = tomMonth + "." + tomDay + "." + tomYear;
		return tomorrowsDate;
	}
	private String millisecondsToString(long time)
	{
		String returnTime = ""; 
		int milliseconds = (int)(time % 1000);
		int seconds = (int)((time/1000) % 60);
		int minutes = (int)((time/60000) % 60);
		System.out.println("mionsmionsmionsmions"+minutes);
		int hours = (int)((time/3600000) % 24);
		int days = (int)((time/3600000)/24);
		hours += days*24;	    
		String millisecondsStr = (milliseconds<10 ? "00" : (milliseconds<100 ? "0" : ""))+milliseconds;
		String secondsStr = (seconds<10 ? "0" : "")+seconds;
		String minutesStr = (minutes<10 ? "0" : "")+minutes;
		String hoursStr = (hours<10 ? "0" : "")+hours;
		returnTime = hoursStr+":"+minutesStr+":"+secondsStr+":"+millisecondsStr;
		return returnTime;
	}	
	private String changeDateFormat(String changeDate)
	{
		String dateString = changeDate.substring(0,10);
		String timeString = changeDate.substring(10);
		System.out.println(changeDate);
		System.out.println(dateString+"$$$$$$$"+timeString);
		java.util.StringTokenizer stoken = new java.util.StringTokenizer(dateString,"-");
		String year 	= stoken.nextToken();
		String months 	= stoken.nextToken();
		String days 	= stoken.nextToken();
		
		return 	days+"."+months+"."+year+" "+timeString;
	}
%>
<%
	session.putValue("MYLOGINMILLIS",String.valueOf(System.currentTimeMillis()));
	
	String WebSysKey 	= (String)session.getValue("SYSKEY");
	String userId 		= (String)Session.getUserId();
	
	int succesfullLogins 	= 0;
	int unSuccesfullLogins 	= 0;
	
	java.util.Date todaysDateObj = new java.util.Date();
	int curMonth 	= todaysDateObj.getMonth()+1;
	int curYear 	= todaysDateObj.getYear()+1900;
	int curDate	= todaysDateObj.getDate();
	
	String lastLoginDate = "";
	String parallelLogins = "";
	
	String checkFromDate	= curMonth+"."+curDate+"."+curYear;
	String checkToDate	= returnNextDay(curDate,curMonth,curYear,".");
	
	String fromMenu = "N";
	if(request.getParameter("FROMMENU") != null)
		fromMenu = request.getParameter("FROMMENU");
	
	
	
	EzcParams mainParams = new EzcParams(false);
	EziWebStatsParams  webStatparams= new EziWebStatsParams();
	webStatparams.setSysKey("'"+WebSysKey+"'");
	webStatparams.setUserId(userId);
	webStatparams.setFromDate(checkFromDate);
	webStatparams.setToDate(checkToDate);
	mainParams.setObject(webStatparams);
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve retWebStats=(ReturnObjFromRetrieve)WebStatsManager.getWebStatsList(mainParams);
	int webCount = 0;
	if(retWebStats != null)
	{
		webCount = retWebStats.getRowCount();
		boolean getLastLogin = true;
		for(int i=0;i<webCount;i++)
		{
			if(!"LOGINFAIL".equals(retWebStats.getFieldValueString(i,"SYSKEY")))
				succesfullLogins++;
			if(!"LOGINFAIL".equals(retWebStats.getFieldValueString(i,"SYSKEY")) && getLastLogin)
			{
				lastLoginDate = (retWebStats.getFieldValueString(i,"LOGGED_IN")).trim();
				String logdate = lastLoginDate.substring(0,10);
				String logTime = lastLoginDate.substring(11,19);
				lastLoginDate = logdate.substring(8,10)+"."+logdate.substring(5,7)+"."+logdate.substring(0,4)+" "+logTime;
				getLastLogin = false;
			}
		}	
	}
	
	webStatparams.setSysKey("'LOGINFAIL') AND EWS_USER_ID IN ('"+userId+"'");
	mainParams.setObject(webStatparams);
	Session.prepareParams(mainParams);
	retWebStats = (ReturnObjFromRetrieve)WebStatsManager.getWebStatsList(mainParams);
	if(retWebStats != null)
	{
		unSuccesfullLogins = retWebStats.getRowCount();
	}
	
	java.util.Date currentDate = new java.util.Date();
	int monthValue = currentDate.getMonth()+1;
	String monthString = "";
	if(monthValue < 10)
		monthString = "0"+monthValue;
		
	int dateValue = currentDate.getDate();
	String dateString = "";
	if(dateValue < 10)
		dateString = "0"+dateValue;

		
	currentDate.setTime(currentDate.getTime() - (1000L*60L*15L));
	String currentDateFromString 	= (currentDate.getYear()+1900)+"-"+monthString+"-"+dateString+" "+currentDate.getHours()+":"+currentDate.getMinutes()+":"+currentDate.getSeconds();
	
	
	currentDate = new java.util.Date();
	currentDate.setTime(currentDate.getTime() + (1000L*60L*15L));
	String currentDateToString 	= (currentDate.getYear()+1900)+"-"+monthString+"-"+dateString+" "+currentDate.getHours()+":"+currentDate.getMinutes()+":"+currentDate.getSeconds();
	
	retWebStats = null;
	mainParams = new EzcParams(false);
	webStatparams= new EziWebStatsParams();
	webStatparams.setSysKey("¥'"+WebSysKey+"' ");
	webStatparams.setUserId(userId);
	webStatparams.setFromDate(currentDateFromString);
	webStatparams.setToDate(currentDateToString);
	mainParams.setObject(webStatparams);
	Session.prepareParams(mainParams);
	retWebStats=(ReturnObjFromRetrieve)WebStatsManager.getWebStatsList(mainParams);	
	if(retWebStats != null)
	{
		if(retWebStats.getRowCount() > 1)
		{
			parallelLogins = retWebStats.getRowCount()+"";
			parallelLogins = "<a href=\"../WebStats/ezListWebStatsByUser.jsp?Area=V&chkField=&chkdindex=17&WebSysKey="+WebSysKey+"&fromLoginDetails=Y&fromDate="+changeDateFormat(currentDateFromString)+"&toDate="+changeDateFormat(currentDateToString)+"\">"+parallelLogins+"</a>";
		}
		else
		{
			parallelLogins = "0";
		}
	}
%>



