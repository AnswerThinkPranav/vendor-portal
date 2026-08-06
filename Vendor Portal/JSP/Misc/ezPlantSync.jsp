<%@ page import="java.net.HttpURLConnection,java.net.URL,ezc.vendorprofile.params.*,ezc.ezparam.*,java.io.*,java.util.*" %>		
<%@ page import ="ezc.vendortransactions.params.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import ="ezc.ezparam.*,ezc.ezcommon.*,java.util.*, java.net.*" %>

<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();

		return value;
	}
%>
<%
	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
		
	logs.setUserId("SESSIONUSR");
	logs.setPassWd("portal");
	logs.setConnGroup("200");
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
	
	
	Calendar cal=Calendar.getInstance();
	cal.add(Calendar.DATE,-1);
	Date fromDate=cal.getTime();
	cal=Calendar.getInstance();
	Date toDate=cal.getTime();
	//out.println("FROMDARE"+fromDate+"TODATE"+toDate);
	ReturnObjFromRetrieve plantsRetObj=null;
	int plantsRetObjCnt=0;
	
	//ArrayList ProjAL	= new ArrayList();

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT * FROM EZC_PLANTS");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	
	try
	{
		plantsRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		if(plantsRetObj!=null)
		plantsRetObjCnt = plantsRetObj.getRowCount();
	}
	catch(Exception e){System.out.println(e);}
	for(int i=0;i<plantsRetObjCnt;i++)
	{
		String plant	= checkNull(plantsRetObj.getFieldValueString(i,"EP_PLANT"));
		//ProjAL.add(plant);
	}
	
        
        JCoDestination destination 	= EzSAPHandler.getDestination("200~999");
	//out.println(":::::destination:::::::"+destination);
	JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_PLANT_CREATED");
	JCoParameterList importParams 	= function.getImportParameterList();
      //  out.println(":::::function:::::::"+function);
        
        importParams.setValue("CDATE_FROM",fromDate);
	importParams.setValue("CDATE_TO",toDate);
	
	try
	{
		function.execute(destination);
			
	} 
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log(":::::::::::function:::::Exception::::::"+e,"E");
	}

	//ReturnObjFromRetrieve sapPlantRetObj	= new ReturnObjFromRetrieve(new String[]{"PLANT","NAME1","NAME2","STREET","POSTALCODE","CITY","COUNTRYKEY","STATE"});
	//int sapPlantRetObjCnt =0;
	ezc.ezcommon.EzLog4j.log(":::PLANTS FROM SAP:::BEFORE","I");
	try
	{
		JCoTable returnTable = function.getTableParameterList().getTable("PLANT");	
		int retCount         = returnTable.getNumRows();
		//out.println("::::retCount::::"+retCount);
		//out.println("returnTable"+returnTable);
		ezc.ezcommon.EzLog4j.log(returnTable+":::::::::::function:::::retCount::::::"+retCount,"I");
		ezc.ezcommon.EzLog4j.log(":::PLANTS FROM SAP:::AFTER","I");
		if(retCount>0)
		{
			do
			{
				String sapPalnt			= checkNull((String)returnTable.getValue("WERKS"));
				String plantName1		= checkNull((String)returnTable.getValue("NAME1"));
				String plantName2		= checkNull((String)returnTable.getValue("NAME2"));
				String street			= checkNull((String)returnTable.getValue("STRAS"));
				String postalCode		= checkNull((String)returnTable.getValue("PSTLZ"));
				String city			= checkNull((String)returnTable.getValue("ORT01"));
				String countryKey		= checkNull((String)returnTable.getValue("LAND1"));
				String state			= checkNull((String)returnTable.getValue("REGIO"));
				
				int index=-1;
				if(plantsRetObj!=null)
				{
					index=plantsRetObj.getRowId("EP_PLANT",sapPalnt);
					
					if(index<0)
					{
						mainParams = new ezc.ezparam.EzcParams(false);
						miscParams = new EziMiscParams();
						String query= "INSERT INTO EZC_PLANTS(EP_PLANT,EP_NAME1,EP_NAME2,EP_ADDRESS,EP_CITY,EP_PS_CODE,EP_STATE,EP_COUNTRY,EP_MOBILE,EP_LANDLINE,EP_EXT1,EP_EXT2,EP_EXT3)VALUES('"+sapPalnt+"','"+plantName1+"','"+plantName2+"','"+street+"','"+city+"','"+postalCode+"','"+state+"','"+countryKey+"','','','','','')";
						miscParams.setQuery(query);
						
						mainParams.setObject(miscParams);
						mainParams.setLocalStore("Y");
						Session.prepareParams(mainParams);
						try
						{
							ezMiscManager.ezAdd(mainParams);
						}
						catch(Exception e)
						{
							System.out.println(e);
						}

					}
					
				}
				
				
			}while(returnTable.nextRow());						
								
		}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log(":::::::Exception::::::"+e,"E");
	}
	
	/*	try{
									
			String mURL = "http://api.smscountry.com/SMSCwebservice_bulk.aspx?User=retailcoromandel&passwd=gromor&mobilenumber=9963923812&message=test&sid=GROMOR&mtype=N&DR=N";
	
			out.println("mURL::"+mURL);
	
			URL url = new URL(mURL);
			//HttpURLConnection uc = (HttpURLConnection)url.openConnection();
			//out.println(uc.getResponseMessage());
			//uc.disconnect();
	
		}catch(Exception e)
		{
			out.println(":::::::Exception ::::::::::::"+e);
		}*/
		/*
		
			String DESTINATION_NAME2 = "DESTINATION";
		
	
			try{	
	    
				Properties connectProperties = new Properties();
				properties.setProperty("jco.client.ashost", "172.26.2.61");
				properties.setProperty("jco.client.sysnr", "00");
				properties.setProperty("jco.client.client", "777");
				properties.setProperty("jco.client.user",   "cfproject");
				properties.setProperty("jco.client.passwd","venport@17" );
				properties.setProperty("jco.client.lang",   "en");
				properties.setProperty("jco.client.pool_capacity", "3");
				properties.setProperty("jco.client.peak_limit",    "10");
	
	File file = new File((new StringBuilder()).append(DESTINATION_NAME2).append(".jcoDestination").toString());
		try
		{
		    FileOutputStream fileoutputstream = new FileOutputStream(file, false);
		    connectProperties.store(fileoutputstream, "for tests only !");
		    fileoutputstream.close();
		}
		catch(Exception exception)
		{
		    throw new RuntimeException("Unable to create the destination files", exception);
		}
	        
				JCoDestination destination = JCoDestinationManager.getDestination(DESTINATION_NAME2);
				out.println("::::::before:::function::::");
				
				JCoFunction function = destination.getRepository().getFunction("Z_EZ_GET_VENDOR_UPDATE");
				out.println(function+"::::::after:::function::::");
	        }catch(Exception e){out.println(e+"::::::::priya::::::::::");}
	        */
	        
      try{ 
		ezc.ezcommon.EzLog4j.log("PLANTS_SYNCH_LOGOUT>>>>>>>>","I");
		Session.logOut(); 
      	} catch(Exception e) { 
      		ezc.ezcommon.EzLog4j.log("PLANTS_SYNCH_LOGOUT ERROR>>>>>>>>"+e,"E");
      	} 
	session.invalidate();
      %>
     
