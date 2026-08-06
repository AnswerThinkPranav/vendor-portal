<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,ezc.ezsap.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
   	
<%
	String inspLotNo = request.getParameter("inspLotNo");
	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Table CharRequirementsTable=null,ResultsDateTable=null;
	int requirmentCount=0,resultsCount=0;
	ezc.ezparam.ReturnObjFromRetrieve CharRequirementsRetObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"ITEMNO","MATDESC","MEAS_UNIT","MEAS_VALUE"});
	ezc.ezparam.ReturnObjFromRetrieve ResultsRetObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"INLOT","ITEMNUM","STAT","QTY"});
			
	try
	{
		client1 = EzSAPHandler.getSAPConnection("200~999");
		function = EzSAPHandler.getFunction("BAPI_INSPOPER_GETDETAIL","200~999");
		JCO.ParameterList  parameterList = function.getImportParameterList();
		parameterList.setValue(inspLotNo,"INSPLOT");
		parameterList.setValue("0010","INSPOPER");
		parameterList.setValue("X","READ_INSPPOINTS");
		parameterList.setValue("X","READ_CHAR_REQUIREMENTS");
		parameterList.setValue("X","READ_CHAR_RESULTS");   
		parameterList.setValue("X","READ_SAMPLE_RESULTS");
		parameterList.setValue("X","READ_CHARS_WITH_CLASSES");
		parameterList.setValue("X","READ_CHARS_WITHOUT_RECORDING");
		
		
		
		try
 		{
  		 	client1.execute(function);
		}
		catch(Exception e)
		{
		 	ezc.ezcommon.EzLog4j.log("Exception while executing RFC call BAPI_INSPOPER_GETDETAIL  exec"+e,"I");
 		}
 		
 			 CharRequirementsTable= function.getTableParameterList().getTable("CHAR_REQUIREMENTS");
 			 ResultsDateTable= function.getTableParameterList().getTable("CHAR_RESULTS");
 	 		
			if(CharRequirementsTable!=null)
			requirmentCount	= CharRequirementsTable.getNumRows();
			if(ResultsDateTable!=null)
			resultsCount	= ResultsDateTable.getNumRows();
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception while executing RFC call BAPI_INSPOPER_GETDETAIL"+e,"I");
		out.println("ERROR::::::"+e);
 	}
 	finally
	{
		if (client1!=null)
		{
			ezc.ezcommon.EzLog4j.log("R E L E A S I N G   C L I E N T .... ","D");
			JCO.releaseClient(client1);
			client1 = null;
			function=null;
		}
	}
	
	//out.println("requirmentCount=="+CharRequirementsTable.toString());
	//out.println("requirmentCount=="+ResultsDateTable.toString());
	//out.println("requirmentCount=="+requirmentCount);
	//out.println("resultsCount=="+resultsCount);
	if(requirmentCount>0)
	{
		do
		{	  
		
			//out.println("MEAS_UNITT=="+CharRequirementsTable.getValue("MEAS_UNITT"));
			//out.println("<Br>LW_TOL_LMT=="+CharRequirementsTable.getValue("LW_TOL_LMT"));
			//out.println("<Br>LW_PLS_LMT=="+CharRequirementsTable.getValue("LW_PLS_LMT"));
		
			String lessThanVal = "",greaterThanVal = "",finalValue="";
			
			String measurement = (String)CharRequirementsTable.getValue("MEAS_UNITT");
			
			if(measurement!=null)
				measurement = measurement.trim();
				
			
			
			if("Percentage".equals(measurement))
			{
				lessThanVal = "";
				greaterThanVal = "";
				finalValue="";
				
				lessThanVal = (String)CharRequirementsTable.getValue("UP_TOL_LMT"); 
				greaterThanVal = (String)CharRequirementsTable.getValue("LW_TOL_LMT"); 

				try{
					if(!"".equals(lessThanVal))
						lessThanVal = "<="+lessThanVal.trim();;
				}catch(Exception e){
					lessThanVal = ""; 
				}
				
				try{
					if(!"".equals(greaterThanVal))
						greaterThanVal = ">="+greaterThanVal.trim();;
				}catch(Exception e){
					greaterThanVal = ""; 
				}
				
				finalValue = lessThanVal+""+greaterThanVal;
							
			}	
			
			
			if("Numbers".equals(measurement))
			{
				lessThanVal = "";
				greaterThanVal = "";
				finalValue="";
				
				lessThanVal = (String)CharRequirementsTable.getValue("UP_TOL_LMT"); 
				greaterThanVal = (String)CharRequirementsTable.getValue("LW_TOL_LMT"); 

				try{
					if(!"".equals(lessThanVal))
						lessThanVal = "<="+lessThanVal.trim();
				}catch(Exception e){
					lessThanVal = ""; 
				}
				
				try{
					if(!"".equals(greaterThanVal))
						greaterThanVal = ">="+greaterThanVal.trim();;
				}catch(Exception e){
					greaterThanVal = ""; 
				}
				
				finalValue = greaterThanVal+""+lessThanVal;				
			}	
			
			//out.println("<Br>measurement=="+measurement+"::::::::::::::::"+measurement.length()+":::::::::"+finalValue);	
			
			  CharRequirementsRetObj.setFieldValue("MEAS_UNIT",(String)CharRequirementsTable.getValue("MEAS_UNITT")); 
			  CharRequirementsRetObj.setFieldValue("MEAS_VALUE",finalValue); 
			  CharRequirementsRetObj.setFieldValue("ITEMNO",(String)CharRequirementsTable.getValue("INSPCHAR"));
			  CharRequirementsRetObj.setFieldValue("MATDESC",(String)CharRequirementsTable.getValue("CHAR_DESCR"));					
			  CharRequirementsRetObj.addRow();


		}while(CharRequirementsTable.nextRow());					

	}
	//out.println("CharRequirementsRetObj=="+CharRequirementsRetObj.toEzcString());
	//out.println("CharRequirementsRetObj=="+CharRequirementsRetObj.toEzcString());
	   int requirmentROCount=0;
   	if(CharRequirementsRetObj!=null)requirmentROCount=CharRequirementsRetObj.getRowCount();
   	if(resultsCount>0)
	{
		do
		{	
			
		
			  ResultsRetObj.setFieldValue("ITEMNUM",(String)ResultsDateTable.getValue("INSPCHAR"));
			  ResultsRetObj.setFieldValue("STAT",(String)ResultsDateTable.getValue("EVALUATION"));
			  ResultsRetObj.setFieldValue("INLOT",(String)ResultsDateTable.getValue("INSPLOT"));
			  ResultsRetObj.setFieldValue("QTY",(String)ResultsDateTable.getValue("MEAN_VALUE")); 
			  ResultsRetObj.addRow();
			  


		}while(ResultsDateTable.nextRow()); 					

	}
	
	int resultsROCount=0;
   	if(ResultsRetObj!=null)resultsROCount=ResultsRetObj.getRowCount();
	
	
		

%>      