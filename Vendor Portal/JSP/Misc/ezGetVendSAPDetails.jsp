<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import ="ezc.ezparam.*,java.util.*" %>

<%
	ReturnObjFromRetrieve bankListRetObj = new ReturnObjFromRetrieve(new String[]{"VENDOR","COUNTRY","KEY","ACCOUNT_CODE"});
	ReturnObjFromRetrieve bankAddrRetObj = new ReturnObjFromRetrieve(new String[]{"KEY","COUNTRY","DATE","BANK_NAME","REGION","STREET","CITY","BRANCH","IFSC","CURRENCY"});
	ReturnObjFromRetrieve orgListRetObj = new ReturnObjFromRetrieve(new String[]{"PURORG","GRBASED","SERBASED","CURRRENCY"});
	
	Date	CERDT	   =    new Date();
	String LIFNR = "",NAME1 = "",NAME2 = "",NAME3 = "",NAME4 = "",DLGRP = "",ANRED = "",ORT01 = "",ORT01Bank   =    "",ORT02 = "",REGIO = "",PSTL2 = "",PSTLZ = "",STRAS = "",STRASBank   = "",LAND1 = "",BANKN = "",BANKS = "",BKREF = "",BANKL = "",BANKA = "",PROVZ = "",BRNCH = "",SMTP_ADDR   =    "",TELF1 = "";
	String ZTERM = "",ZTERMComp   = "",ZWELS = "",BUKRS = "",CERDTStr = "",HBKID = "",KALSK = "",WAERS =  "",LEBRE =  "",WEBRE="",EKORG = "",TELFX =  "",TELF2 =  "",SPERQ =  "",NAMEV =  "",NAME1ConInfo= "",STCEG =  "",MINDK =  "",FLGDEFAULT="",R3_USER="";
	String J_1ISERN = "", J_1IEXRG  = "",J_1ICSTNO = "",J_1IEXCD = "",J_1IEXDI = "",J_1IPANNO= "",J_1IEXRN = "",J_1IEXCO = "",GSTIN = "",CLASSIF = "",CLASSIF_DESC = "";
	Hashtable classHT = new Hashtable();
/*
	classHT.put("01","Registered");
	classHT.put("02","Not Registered");
	classHT.put("03","Compounding Scheme");
	classHT.put("04","PSU/Government Organization");

	String defSoldTo    = (String)session.getValue("SOLDTO"); 
	//String userDefCompCode = "CFL";
	String userDefCompCode =(String)session.getValue("CCode");
	//out.println("::::::::::::::userDefCompCode::::::::::::"+userDefCompCode);

	//if(Session.getUserPreference("COMPCODE")!= null)
	//	userDefCompCode  = (String)Session.getUserPreference("COMPCODE");

	java.util.Hashtable openIBDItemsHT = new java.util.Hashtable();

	try
	{
		String logonSite = (String)session.getValue("SITE");
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
		JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_DETAILS");
		JCoParameterList impParam = function.getImportParameterList();

		impParam.setValue("VENDOR",defSoldTo);
		impParam.setValue("COMPCODE",userDefCompCode);

		try
		{
			function.execute(destination);
		}
		catch(Exception e){
			ezc.ezcommon.EzLog4j.log(":::EXCEPTION:::"+e,"E");
		}
			
		JCoParameterList expParam = function.getExportParameterList();
		JCoStructure expTable = expParam.getStructure("GEN_DATA");
					
		LIFNR       =  (String)expTable.getValue("LIFNR");
		NAME1       =  (String)expTable.getValue("NAME1");
		NAME2       =  (String)expTable.getValue("NAME2");
		NAME3       =  (String)expTable.getValue("NAME3");
		NAME4       =  (String)expTable.getValue("NAME4");
		DLGRP       =  (String)expTable.getValue("DLGRP");
		ANRED       =  (String)expTable.getValue("ANRED");
		ORT01       =  (String)expTable.getValue("ORT01");
		ORT02       =  (String)expTable.getValue("ORT02");
		REGIO       =  (String)expTable.getValue("REGIO");
		PSTL2       =  (String)expTable.getValue("PSTL2");
		STRAS       =  (String)expTable.getValue("STRAS");
		LAND1       =  (String)expTable.getValue("LAND1");
		STCEG       =  (String)expTable.getValue("STCEG");
		TELFX       =  (String)expTable.getValue("TELFX");
		TELF1       =  (String)expTable.getValue("TELF1");
		//TELF2       =  (String)expTable.getValue("TELF2");
		SPERQ	     =  (String)expTable.getValue("SPERQ");	
		PSTLZ       =  (String)expTable.getValue("PSTLZ");
		GSTIN	    =  (String)expTable.getValue("STCD3"); 
		
		session.putValue("VEND_GST",GSTIN);

		String ADRNR       =  (String)expTable.getValue("ADRNR");
		String WERKS       =  (String)expTable.getValue("WERKS");

		JCoStructure compTable = expParam.getStructure("COMP_DATA");
		CERDT	   	   =  (Date)compTable.getValue("CERDT");
		if(CERDT==null)
			CERDTStr="";
		else
		{
			SimpleDateFormat formatter = null;//new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = CERDT;//formatter.parse(modifiedOn);
			formatter = new SimpleDateFormat("dd/MM/yyyy");
			CERDTStr = formatter.format(date);
		}
		ZTERMComp   	   =  (String)compTable.getValue("ZTERM");
		HBKID	   	   =  (String)compTable.getValue("HBKID");
		ZWELS              =  (String)compTable.getValue("ZWELS");
		BUKRS              =  (String)compTable.getValue("BUKRS");
		MINDK	   	   =  (String)compTable.getValue("MINDK");

		JCoTable retTable  = function.getTableParameterList().getTable("PURORG_DATA");	      
		JCoTable retTable1 = function.getTableParameterList().getTable("STATUTARY_DATA");
		JCoTable retTable2 = function.getTableParameterList().getTable("CONTACT_INFO");
		JCoTable retTable3 = function.getTableParameterList().getTable("VENDOR_BANKS");
		JCoTable retTable4 = function.getTableParameterList().getTable("BANK_ADDRESS");
		JCoTable retTable5 = function.getTableParameterList().getTable("VEND_EMAILS");
		JCoTable retTable6 = function.getTableParameterList().getTable("TEL_NUMBER");
		//out.println("::::::::::::::TEL_NUMBER::::::::::::"+retTable6);		
		
		int retCoun         = retTable.getNumRows();
		int retCoun1         = retTable1.getNumRows();
		int retCoun2         = retTable2.getNumRows();
		int retCoun3         = retTable3.getNumRows();
		int retCoun4         = retTable4.getNumRows();
		int retCoun5         = retTable5.getNumRows();
		int retCoun6         = retTable6.getNumRows();
		//flgdefault  r3_user
		
		if(retCoun6 > 0)
		{
			do
			{
				FLGDEFAULT       =  (String)retTable6.getValue("FLGDEFAULT");
				R3_USER       =  (String)retTable6.getValue("R3_USER");
				TELF2       =  (String)retTable6.getValue("TEL_NUMBER");
				
				if((retCoun6 > 1)&& FLGDEFAULT.equals("X")&&(R3_USER.equals("2")||R3_USER.equals("3")))
				{
					TELF2       =  (String)retTable6.getValue("TEL_NUMBER");
				}	
				else if(R3_USER.equals("2")||R3_USER.equals("3"))
				{
					TELF2       =  (String)retTable6.getValue("TEL_NUMBER");					
				}	
			}						 
				while(retTable6.nextRow());			 
		}
		
		if(retCoun > 0)
		{
			do
			{
				ZTERM       =  (String)retTable.getValue("ZTERM");
				KALSK       =  (String)retTable.getValue("KALSK");
				WAERS       =  (String)retTable.getValue("WAERS");
				LEBRE       =  (String)retTable.getValue("LEBRE");
				WEBRE       =  (String)retTable.getValue("WEBRE");
				EKORG       =  (String)retTable.getValue("EKORG");

				orgListRetObj.setFieldValue("PURORG",EKORG);
				orgListRetObj.setFieldValue("GRBASED",WEBRE);
				orgListRetObj.setFieldValue("SERBASED",LEBRE);
				orgListRetObj.setFieldValue("CURRRENCY",WAERS);
				orgListRetObj.addRow();
			}						 
			while(retTable.nextRow());			 
		}
		if(retCoun1 > 0)
		{
			do
			{
				J_1ISERN       =  (String)retTable1.getValue("J_1ISERN");
				J_1IEXRG       =  (String)retTable1.getValue("J_1IEXRG");					

				J_1ICSTNO      =  (String)retTable1.getValue("J_1ICSTNO");
				J_1IEXCD       =  (String)retTable1.getValue("J_1IEXCD");
				J_1IEXDI       =  (String)retTable1.getValue("J_1IEXDI");
				J_1IPANNO      =  (String)retTable1.getValue("J_1IPANNO");
				J_1IEXRN       =  (String)retTable1.getValue("J_1IEXRN");
				J_1IEXCO       =  (String)retTable1.getValue("J_1IEXCO");

				try
				{
					CLASSIF       =  (String)retTable1.getValue("VEN_CLASS");
					CLASSIF_DESC  =  (String)classHT.get(CLASSIF);
				}catch(Exception e){}	 
			}						 
			while(retTable.nextRow());			 
		}			
		if(retCoun2 > 0)
		{
			do
			{
				NAMEV       =  (String)retTable2.getValue("NAMEV");					
				NAME1ConInfo       =  (String)retTable2.getValue("NAME1");
				//TELF1       =  (String)retTable2.getValue("TELF1");
			}						 
			while(retTable2.nextRow());			 
		}
		if(retCoun3 > 0)
		{
			do
			{
				BANKN       =  (String)retTable3.getValue("BANKN");
				BKREF       =  (String)retTable3.getValue("BKREF");

				bankListRetObj.setFieldValue("VENDOR",(String)retTable3.getValue("LIFNR"));
				bankListRetObj.setFieldValue("COUNTRY",(String)retTable3.getValue("BANKS"));
				bankListRetObj.setFieldValue("KEY",(String)retTable3.getValue("BANKL"));
				bankListRetObj.setFieldValue("ACCOUNT_CODE",BANKN);
				bankListRetObj.addRow();
			}						 
			while(retTable3.nextRow());			 
		}			
		if(retCoun4 > 0)
		{
			do
			{
				BANKS       =  (String)retTable4.getValue("BANKS");
				STRASBank       =  (String)retTable4.getValue("STRAS");
				BANKL       =  (String)retTable4.getValue("BANKL");					
				BANKA       =  (String)retTable4.getValue("BANKA");
				ORT01Bank       =  (String)retTable4.getValue("ORT01");
				PROVZ       =  (String)retTable4.getValue("PROVZ");
				BRNCH       =  (String)retTable4.getValue("BRNCH");

				bankAddrRetObj.setFieldValue("KEY",BANKL);
				bankAddrRetObj.setFieldValue("COUNTRY",BANKS);
				bankAddrRetObj.setFieldValue("DATE","");
				bankAddrRetObj.setFieldValue("BANK_NAME",BANKA);
				bankAddrRetObj.setFieldValue("REGION",PROVZ);
				bankAddrRetObj.setFieldValue("STREET",STRASBank);
				bankAddrRetObj.setFieldValue("CITY",ORT01Bank);
				bankAddrRetObj.setFieldValue("BRANCH",BRNCH);
				bankAddrRetObj.setFieldValue("IFSC",(String)retTable4.getValue("SWIFT"));
				bankAddrRetObj.setFieldValue("CURRENCY",WAERS);
				bankAddrRetObj.addRow();
			}						 
			while(retTable4.nextRow());			 
		}	
		if(retCoun5 > 0)
		{
			do
			{
				SMTP_ADDR        =  (String)retTable5.getValue("SMTP_ADDR");
			}						 
			while(retTable5.nextRow());			 
		}			

	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log(":::EXCEPTION:::"+e,"E");
	}
	*/
%>
