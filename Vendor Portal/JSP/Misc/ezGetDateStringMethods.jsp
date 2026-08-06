<%!
		private  String getSysDateStr(String format)
		{
			java.text.SimpleDateFormat sdf = null;
			java.util.Date dt = new java.util.Date();
			String dateStr = "";

			if("DATE_TIME".equals(format))
			{
				sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				dateStr = sdf.format(dt);     
			}	
			if("DATE".equals(format))
			{
				sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
				dateStr = sdf.format(dt);     
			}	

			return dateStr;
		}

		private  String getDateStr(java.util.Date inputDt, String format)
		{
			java.text.SimpleDateFormat sdf = null;
			String dateStr = "";

			if("DATE_TIME".equals(format))
			{
				sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				dateStr = sdf.format(inputDt);     
			}	
			if("DATE".equals(format))
			{
				sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
				dateStr = sdf.format(inputDt);     
			}	

			return dateStr;
		}
            
%>