<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezbasicutil.*,java.text.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>


<%
	ezc.ezcommon.EzLog4j.log("exchRateNew Enter:::::::::::::::","I");
	String exchRate="";
	
	String toDtStr="";
	java.util.Date toDelDate = null;
	Calendar cal = Calendar.getInstance();
	Date toDateObj = cal.getTime();
	toDtStr = convertDateObjToString(toDateObj);	
	toDelDate = convertStringToDateObj(toDtStr);
	
	ezc.ezcommon.EzLog4j.log("toDelDate:::::::::::::::"+toDelDate,"I");
	
	JCoFunction function =null;	
	String logonSite = (String)session.getValue("SITE");	
	
	JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
	function = EzSAPHandler.getJCoFunction(destination,"BAPI_EXCHRATE_GETCURRENTRATES");	
	
	JCoParameterList sapPreProc = function.getImportParameterList();
	JCoParameterList sapTabParam= function.getTableParameterList();	

	sapPreProc.setValue("DATE",toDelDate);  //2020-12-10
	sapPreProc.setValue("DATE_TYPE","V");
	sapPreProc.setValue("RATE_TYPE","M");  
	sapPreProc.setValue("SHOW_PROTOCOL","");
	
	ezc.ezcommon.EzLog4j.log("CHK2:::::::::::::::","I");
	
	JCoTable r_fromCurr = sapTabParam.getTable("FROM_CURR_RANGE");	
	r_fromCurr.appendRow();
	r_fromCurr.setValue("SIGN","I");
	r_fromCurr.setValue("OPTION","EQ");
	r_fromCurr.setValue("LOW",curr);
	r_fromCurr.setValue("HIGH","");
	
	ezc.ezcommon.EzLog4j.log("CHK3:::::::::::::::","I");
	
	JCoTable r_toCurr = sapTabParam.getTable("TO_CURRNCY_RANGE");
	r_toCurr.appendRow();
	r_toCurr.setValue("SIGN","I");
	r_toCurr.setValue("OPTION","EQ");
	r_toCurr.setValue("LOW","INR");
	r_toCurr.setValue("HIGH","");
	
	ezc.ezcommon.EzLog4j.log("CHK4:::::::::::::::","I");
		
	try
	{
		function.execute(destination);
	}catch(Exception qe){
		ezc.ezcommon.EzLog4j.log("Exception in BAPI_EXCHRATE_GETCURRENTRATES FM Exectution:::::::::::::::"+qe,"I");
	}	

	int exchCnt =0;
	
	JCoTable exchList = function.getTableParameterList().getTable("EXCH_RATE_LIST");
	exchCnt = exchList.getNumRows();
	
	if(exchCnt>0)
	{
	
		try
		{
			exchRate =((java.math.BigDecimal)exchList.getValue("EXCH_RATE")).setScale(2,java.math.BigDecimal.ROUND_HALF_UP)+"";
			ezc.ezcommon.EzLog4j.log("exchRateNew:::::::::::::::"+exchRate,"I");
		}
		catch (Exception e) {
			exchRate="0.00";
		}
	}	

%>	
