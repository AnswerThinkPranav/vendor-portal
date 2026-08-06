
<%@ page import="java.util.*,ezc.ezutil.*,java.io.*,ezc.ezutil.FormatDate" %>

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

	private  String getDateStrForDB(String dateStr)
	{
		if(dateStr!=null)
		{
			try{
				dateStr = dateStr.substring(6,10)+"-"+dateStr.substring(3,5)+"-"+dateStr.substring(0,2);
			}catch(Exception e){
				dateStr = "1900-01-01";
			}	
		}else{
			dateStr = "1900-01-01";
		}
		return dateStr;
	}

	java.util.ResourceBundle buttonBundle = null;
	String button_lang = null;
	
	public String getButtonLabel(String LKey)
	{
		String buttonText="";
		if(LKey != null && buttonBundle != null)
		{
			try{
				//LKey =(LKey.trim()).replace(' ','_');
				buttonText = buttonBundle.getString(LKey);
			}catch(Exception e){ buttonText = LKey; }
		}
		else
			buttonText = LKey;

		return 	buttonText;
	}
	
	
	
	public String getNumberFormat(String dblValue,int maxDecimal)
	{
		String retValue = "";
		try
		{
			java.text.NumberFormat numberFormat = java.text.NumberFormat.getInstance();
			numberFormat.setMaximumFractionDigits(0);
			numberFormat.setMinimumFractionDigits(maxDecimal);
			if(dblValue != null && !"null".equals(dblValue) && !"".equals(dblValue.trim()))
				retValue = numberFormat.format(Double.valueOf(dblValue))+"";
			else	
				retValue = "0";
				
			retValue = retValue.replaceAll(",","");
		}
		catch(Exception ex)
		{
			retValue = dblValue;
		}
		return retValue;
	}
	
	public static String replaceString(String theString,String from,String to)
		{
			int go=0;
			String ret=theString;
			while (ret.indexOf(from,go)>=0)
			{
			go=ret.indexOf(from,go);
			ret=ret.substring(0,go)+to+ret.substring(go+from.length());
			go=go+to.length();
			}
			return ret;
	}		
	
	
	public static String getVendorEmail(String vendor,ezc.session.EzSession Session)
	{
		String email = "";
		
		ezc.ezparam.ReturnObjFromRetrieve retObj = null;
		
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendortransactions.client.EzVendorTransactionsManager vendortransactions = new ezc.vendortransactions.client.EzVendorTransactionsManager();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		ezc.vendortransactions.params.EzVendorParams vendorParams  = new ezc.vendortransactions.params.EzVendorParams();
		
		keyParams.setKey("GET_VENDOR_EMAIL");
		
		vendorParams.setVendor(vendor);
		
		mainParams.setLocalStore("Y");
		mainParams.setObject(keyParams);
		mainParams.setObject(vendorParams);
		Session.prepareParams(mainParams);


		try{
			retObj = (ezc.ezparam.ReturnObjFromRetrieve)vendortransactions.ezGetVendorTransactions(mainParams);
		}catch(Exception e){
			ezc.ezcommon.EzLog4j.log(":::::::::::::;ezGetVendorTransactions-UPDATE_SHIPMENT_STATUS:::::::::::"+e,"I");
		}
		
		if(retObj!=null && retObj.getRowCount()>0)
		{
			for(int v=0;v<retObj.getRowCount();v++)
			{
				if(v==0)
					email = retObj.getFieldValueString(v,"EU_EMAIL");
				else	
					email = email+","+retObj.getFieldValueString(v,"EU_EMAIL");
			}
			
		}
		return email;
			
		
	}	
	
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();

		return value;
	}
	public String checkNullWithSpChar(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim().replace('\'','`');

		return value;
	}
	
	public String checkNullNum(String value)
	{
		if(value==null || "null".equals(value.trim()) || "".equals(value.trim()))value="0";
		value=value.trim();

		return value;
	}
 	private String checkNull_Num(String str)
	{
		if("null".equals(str) ||str==null || "".equals(str))
			str="0";
		
		return str;
 	}	
	public Hashtable<String,String> getPlantsDesc(ezc.session.EzSession Session)
	{
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		Hashtable<String,String> plantDescHt = new Hashtable<String,String>();
		try
		{
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
		miscTableRow.setQuery("select EP_PLANT,EP_NAME1 from EZC_PLANTS");
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		
			dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			int dtlXMLCnt = 0;
			if(dtlXML != null)
				dtlXMLCnt = dtlXML.getRowCount();
			log("portal po count"+dtlXMLCnt);
			for(int i=0;i<dtlXMLCnt;i++)
			{
				plantDescHt.put(dtlXML.getFieldValueString(i,"EP_PLANT"),dtlXML.getFieldValueString(i,"EP_NAME1"));
			}

		}
		catch(Exception e)
		{
			
		}
		return plantDescHt;
	}
	public ezc.ezparam.ReturnObjFromRetrieve ezMiscSelect(ezc.session.EzSession Session,String qryStr)
	{
		ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
		try
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery(qryStr);
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

		}
		catch(Exception e)
		{

		}
		return dtlXML;
	} 
	public ezc.ezparam.ReturnObjFromRetrieve ezMiscInsert(ezc.session.EzSession Session,java.util.ArrayList<String> queriesList)
	{
		ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
		try
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			for(String query : queriesList)
			{
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				miscTableRow.setQuery(query);
				miscTable.appendRow(miscTableRow);
			}
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezUpdateMiscTransactions(mainParams);

		}
		catch(Exception e)
		{

		}
		return dtlXML;
	}
	public String checkNullTrimDecimal(String input)
	{
		try
		{
		    java.math.BigDecimal bd = new java.math.BigDecimal(input);
		    bd = bd.setScale(2, java.math.RoundingMode.HALF_UP);
		    return bd.doubleValue()+"";	
		}catch(Exception e){
			return "0.0";
		}
	}
	public java.math.BigDecimal checkBigDecNull(Object obj)
	{
		java.math.BigDecimal retVal=new java.math.BigDecimal(0.0);
		try
		{
			if(obj != null)
			{
				retVal=(java.math.BigDecimal)obj;
			}
		}catch(Exception e){
			
		}
		return retVal;
	}
	public String prefixZeros(String input,int zeroLen)
	{
		if(input == null || "null".equals(input)) input="";
		input += "00000000000000000000000000000000"+input;
		return input.substring(input.length()-zeroLen,input.length());			
		
	}
            
%>