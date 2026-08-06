
<%
	ezc.ezcommon.EzLog4j.log(":in Get:News::","I");
	String syskey = (String)session.getValue("SYSKEY");
	String newsId = request.getParameter("newsid");
	ezc.ezparam.ReturnObjFromRetrieve newsRet = null;
	ezc.ezparam.ReturnObjFromRetrieve subnewsRet = null;
	ezc.ezparam.EzcParams mainParams_News = new ezc.ezparam.EzcParams(false);
	ezc.eznews.client.EzNewsManager newsManager = new ezc.eznews.client.EzNewsManager();
	ezc.eznews.params.EziNewsParams newsParam = new ezc.eznews.params.EziNewsParams();
	newsParam.setNewsSyskey(" NOW()>=EZN_START_DATE AND NOW()<=EZN_END_DATE");
	mainParams_News.setLocalStore("Y");
	mainParams_News.setObject(newsParam);
	Session.prepareParams(mainParams_News);
	int newsCount = 0;
	subnewsRet = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"EZN_ID","EZN_SYSKEY","EZN_CREATED_DATE","CREATED_DATE_CHAR","EZN_CREATED_BY","EZN_MODIFIED_BY","EZN_START_DATE","START_DATE_CHAR","EZN_END_DATE","END_DATE_CHAR","EZN_GROUP","EZN_ROLE","EZN_TYPE","EZN_TEXT"});
	if(syskey!=null)
	{
		try
		{
			ezc.ezcommon.EzLog4j.log(":in Get:News::","I");
			newsRet=(ezc.ezparam.ReturnObjFromRetrieve)newsManager.ezGetNews(mainParams_News);
			ezc.ezcommon.EzLog4j.log("::News::"+newsRet.toEzcString(),"I");
			
		}
		catch(Exception e){}
	}	
		
	if("3".equals(((String)session.getValue("UserType")).trim()))
	{
		String newsType= "";
		if(newsRet != null )
			newsCount = newsRet.getRowCount();
		for(int i=0;i<newsCount;i++)
		{
			newsType = newsRet.getFieldValueString(i,"EZN_TYPE").trim();
			if("G".equals(newsType))
			{
				subnewsRet.setFieldValue("EZN_ID",newsRet.getFieldValueString(i,"EZN_ID"));
				subnewsRet.setFieldValue("EZN_SYSKEY",newsRet.getFieldValueString(i,"EZN_SYSKEY"));
				subnewsRet.setFieldValue("EZN_CREATED_DATE",newsRet.getFieldValueString(i,"EZN_CREATED_DATE"));
				subnewsRet.setFieldValue("CREATED_DATE_CHAR",newsRet.getFieldValueString(i,"CREATED_DATE_CHAR"));
				subnewsRet.setFieldValue("EZN_CREATED_BY",newsRet.getFieldValueString(i,"EZN_CREATED_BY"));
				subnewsRet.setFieldValue("EZN_MODIFIED_BY",newsRet.getFieldValueString(i,"EZN_MODIFIED_BY"));
				subnewsRet.setFieldValue("EZN_START_DATE",newsRet.getFieldValueString(i,"EZN_START_DATE"));
				subnewsRet.setFieldValue("START_DATE_CHAR",newsRet.getFieldValueString(i,"START_DATE_CHAR"));
				subnewsRet.setFieldValue("EZN_END_DATE",newsRet.getFieldValueString(i,"EZN_END_DATE"));
				subnewsRet.setFieldValue("END_DATE_CHAR",newsRet.getFieldValueString(i,"END_DATE_CHAR"));
				subnewsRet.setFieldValue("EZN_GROUP",newsRet.getFieldValueString(i,"EZN_TYPE"));
				subnewsRet.setFieldValue("EZN_ROLE",newsRet.getFieldValueString(i,"EZN_ROLE"));
				subnewsRet.setFieldValue("EZN_TYPE",newsRet.getFieldValueString(i,"EZN_TYPE"));
				subnewsRet.setFieldValue("EZN_TEXT",newsRet.getFieldValueString(i,"EZN_TEXT"));
				subnewsRet.addRow();

			}
			
		}	
		
	newsRet=subnewsRet;
	
	//out.println("newsRetnewsRetnewsRet	"+newsRet.getRowCount());
	//out.println("newsRetnewsRetnewsRet	"+newsRet.toEzcString());
	}
	if(newsRet != null )
		newsCount = newsRet.getRowCount();
	
	
%>