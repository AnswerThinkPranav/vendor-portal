<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import ="java.util.*" %>
<%
String LIFNR       =	"";
String NAME1       =	"";
String NAME2       =	"";
String NAME3       =	"";
String NAME4       =	"";
String DLGRP       =	"";
String ANRED       =	"";
String ORT01       =	"";
String ORT02       =	"";
String REGIO       =	"";
String PSTL2       =	"";
String STRAS       =	"";
String LAND1       =	"";
String BANKN       =	"";
String BANKS       = 	"";
String BANKL       = 	"";
String BANKA       = 	"";
String PROVZ       = 	"";
String BRNCH       = 	"";
String SMTP_ADDR   =    "";  
String TELF1	   =	"";  

String ZTERM	   =	""; 
String ZTERMComp   =    "";
String ZWELS       =    "";
String BUKRS       =    "";
Date	CERDT	   =    new Date();
String	HBKID	   =    "";
String	KALSK	   =    "";
String  WAERS      = 	"";
String  LEBRE      = 	"";
String EKORG       =    "";
String TELFX       = 	"";
String TELF2       = 	"";
String NAMEV       = 	"";
String NAME1ConInfo       =    "";
String STCEG       = 	"";
String MINDK       = 	"";

String J_1ISERN    	= 	"";
String J_1IEXRG  	= 	"";			   
String J_1ICSTNO 	=	"";
String J_1IEXCD 	=	"";
String J_1IEXDI		=	"";
String J_1IPANNO	=	"";
String J_1IEXRN 	=	"";
String J_1IEXCO 	=	"";

 

%>
<%

	java.util.Hashtable openIBDItemsHT = new java.util.Hashtable();

	JCO.Client client=null;
	JCO.Function function = null;
	
	try
	{
			client = EzSAPHandler.getSAPConnection();
			function = EzSAPHandler.getFunction("Z_EZ_GET_VENDOR_DETAILS");
			
			//out.println("::client::"+client);
			//out.println("::function::"+function);
			
			JCO.ParameterList impParam = function.getImportParameterList();


			impParam.setValue("0000429867","VENDOR");
			impParam.setValue("CFL","COMPCODE");
			client.execute(function);
			//out.println("::client executed::");
			
			JCO.ParameterList expParam = function.getExportParameterList();
						
						JCO.Structure expTable = expParam.getStructure("GEN_DATA");
						//int expCoun         = expTable.getNumRows();
						//if(expCoun > 0)
						{
							//do
							{
								//String MANDT0       =  (String)expTable.getValue("MANDT");
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
								 TELF2       =  (String)expTable.getValue("TELF2");
								
								//String PSTLZ       =  (String)expTable.getValue("PSTLZ");								
								//String SORTL       =  (String)expTable.getValue("SORTL");								
								String ADRNR       =  (String)expTable.getValue("ADRNR");
								String WERKS       =  (String)expTable.getValue("WERKS");
								//String BBBNR       =  (String)expTable.getValue("BBBNR");
								//String BBSNR       =  (String)expTable.getValue("BBSNR");
								//String BUBKZ       =  (String)expTable.getValue("BUBKZ");
								//Date ERDAT         =  (Date)expTable.getValue("ERDAT");
								//String KTOKK       =  (String)expTable.getValue("KTOKK");
								//String ERNAM       =  (String)expTable.getValue("ERNAM");
								//String SPRAS       =  (String)expTable.getValue("SPRAS");
								//String TELF1       =  (String)expTable.getValue("TELF1");
								//String TAXBS       =  (String)expTable.getValue("TAXBS");
								//Date UPTIM       =  (Date)expTable.getValue("UPTIM");
								//String J_SC_CAPITAL       =  (String)expTable.getValue("J_SC_CAPITAL");
								//String STAGING_TIME       =  (String)expTable.getValue("STAGING_TIME");
								
								//out.println("::MANDT::"+LIFNR+"::::"+LAND1+"::::"+NAME1+"::::"+ORT01+"::::"+PSTLZ+"::::"+REGIO+"::::"+SORTL+"::::"+STRAS+"::::"+ADRNR+"::::"+BBBNR+"::::"+BBSNR+"::::"+BUBKZ+"::::"+ERDAT+"::::"+KTOKK+"::::"+ERNAM+"::::"+SPRAS+"::::"+TELF1+"::::"+TAXBS+"::::"+UPTIM+"::::"+J_SC_CAPITAL+"::::"+STAGING_TIME);	 
			
			
								//openIBDItemsHT.put(itemNo,itemOpenQty);	 
							}						 
							//while(expTable.nextRow());			 
						}
						
						JCO.Structure compTable = expParam.getStructure("COMP_DATA");
							
							CERDT	   	   =  (Date)compTable.getValue("CERDT");
							ZTERMComp   	   =  (String)compTable.getValue("ZTERM");
							HBKID	   	   =  (String)compTable.getValue("HBKID");
							ZWELS              =  (String)compTable.getValue("ZWELS");
							BUKRS              =  (String)compTable.getValue("BUKRS");
							MINDK	   	   =  (String)compTable.getValue("MINDK");
							
							//String MANDT       =  (String)compTable.getValue("MANDT");
							//String LIFNRComp   =  (String)compTable.getValue("LIFNR");								
							
							//String PERNR       =  (String)compTable.getValue("PERNR");
							//Date	ERDAT        =  (Date)compTable.getValue("ERDAT");
							//String ERNAM       =  (String)compTable.getValue("ERNAM");
							//String SPERR       =  (String)compTable.getValue("SPERR");
							//String LOEVM       =  (String)compTable.getValue("LOEVM");
							//String ZUAWA       =  (String)compTable.getValue("ZUAWA");
							//String AKONT       =  (String)compTable.getValue("AKONT");
							//String BEGRU       =  (String)compTable.getValue("BEGRU");
							//String VZSKZ       =  (String)compTable.getValue("VZSKZ");
							
							//String XVERR       =  (String)compTable.getValue("XVERR");								
							//String ZAHLS       =  (String)compTable.getValue("ZAHLS");
							
							//String EIKTO       =  (String)compTable.getValue("EIKTO");
							//String ZSABE       =  (String)compTable.getValue("ZSABE");
							//String KVERM       =  (String)compTable.getValue("KVERM");
							//String FDGRV       =  (String)compTable.getValue("FDGRV");
							//String BUSAB       =  (String)compTable.getValue("BUSAB");
							//String LNRZE       =  (String)compTable.getValue("LNRZE");
							//String LNRZB       =  (String)compTable.getValue("LNRZB");
							//String ZINDT       =  (String)compTable.getValue("ZINDT");
							//String ZINRT       =  (String)compTable.getValue("ZINRT");
								
								
							//String	DATLZ	   =  (String)compTable.getValue("DATLZ");
							//String	XDEZV	   =  (String)compTable.getValue("XDEZV");
							//String	WEBTR	   =  (String)compTable.getValue("WEBTR");
							//String	KULTG	   =  (String)compTable.getValue("KULTG");
							//String	REPRF	   =  (String)compTable.getValue("REPRF");
							//String	TOGRU	   =  (String)compTable.getValue("TOGRU");
							
							//String	XPORE	   =  (String)compTable.getValue("XPORE");
							//String	QSZNR	   =  (String)compTable.getValue("QSZNR");
							//String	QSZDT	   =  (String)compTable.getValue("QSZDT");
							//String	QSSKZ	   =  (String)compTable.getValue("QSSKZ");
							//String	BLNKZ	   =  (String)compTable.getValue("BLNKZ");
							
							//String	ALTKN	   =  (String)compTable.getValue("ALTKN");
							//String	ZGRUP	   =  (String)compTable.getValue("ZGRUP");
							//String	MGRUP	   =  (String)compTable.getValue("MGRUP");
							//String	UZAWE	   =  (String)compTable.getValue("UZAWE");
							//String	QSREC	   =  (String)compTable.getValue("QSREC");
							//String	QSBGR	   =  (String)compTable.getValue("QSBGR");
							//String	QLAND	   =  (String)compTable.getValue("QLAND");
							//String	XEDIP	   =  (String)compTable.getValue("XEDIP");
							//String	FRGRP	   =  (String)compTable.getValue("FRGRP");
							//String	TOGRR	   =  (String)compTable.getValue("TOGRR");
							//String	TLFXS	   =  (String)compTable.getValue("TLFXS");
							//String	INTAD	   =  (String)compTable.getValue("INTAD");
							//String	XLFZB	   =  (String)compTable.getValue("XLFZB");
							//String	GUZTE	   =  (String)compTable.getValue("GUZTE");
							//String	GRICD	   =  (String)compTable.getValue("GRICD");
							//String	GRIDT	   =  (String)compTable.getValue("GRIDT");
							//String	XAUSZ	   =  (String)compTable.getValue("XAUSZ");
							//String	CONFS	   =  (String)compTable.getValue("CONFS");
							//String	UPDAT	   =  (String)compTable.getValue("UPDAT");
							//Date	        UPTIM	   =  (Date)compTable.getValue("UPTIM");
							//String	NODEL	   =  (String)compTable.getValue("NODEL");
							//String	TLFNS	   =  (String)compTable.getValue("TLFNS");
							
							
							//String	J_SC_SUBCONTYPE	   =  (String)compTable.getValue("J_SC_SUBCONTYPE");
							//String	J_SC_COMPDATE	   =  (String)compTable.getValue("J_SC_COMPDATE");
							//String	J_SC_OFFSM	   =  (String)compTable.getValue("J_SC_OFFSM");
							//String	J_SC_OFFSR	   =  (String)compTable.getValue("J_SC_OFFSR");
							//String	BASIS_PNT	   =  (String)compTable.getValue("BASIS_PNT");
							//String	GMVKZK	   	   =  (String)compTable.getValue("GMVKZK");
							//String	PREPAY_RELEVANT	   =  (String)compTable.getValue("PREPAY_RELEVANT");
							//String	ASSIGN_TEST	   =  (String)compTable.getValue("ASSIGN_TEST");
													      
													      
													      
													      
													      
													      
			JCO.Table retTable  = function.getTableParameterList().getTable("PURORG_DATA");	      
			JCO.Table retTable1 = function.getTableParameterList().getTable("STATUTARY_DATA");
			JCO.Table retTable2 = function.getTableParameterList().getTable("CONTACT_INFO");
			JCO.Table retTable3 = function.getTableParameterList().getTable("VENDOR_BANKS");
			JCO.Table retTable4 = function.getTableParameterList().getTable("BANK_ADDRESS");
			JCO.Table retTable5 = function.getTableParameterList().getTable("VEND_EMAILS");
			
			int retCoun         = retTable.getNumRows();
			int retCoun1         = retTable1.getNumRows();
			int retCoun2         = retTable2.getNumRows();
			int retCoun3         = retTable3.getNumRows();
			int retCoun4         = retTable4.getNumRows();
			int retCoun5         = retTable5.getNumRows();

			if(retCoun > 0)
			{
				do
				{
					//String MANDT1       =  (String)retTable.getValue("MANDT");
					//String LIFNR1       =  (String)retTable.getValue("LIFNR");
					//Date ERDAT         =  (Date)retTable.getValue("ERDAT");
					//String ERNAM       =  (String)retTable.getValue("ERNAM");
					
					//String MINBW       =  (String)retTable.getValue("MINBW");
					 ZTERM       =  (String)retTable.getValue("ZTERM");
					 KALSK       =  (String)retTable.getValue("KALSK");
					 WAERS       =  (String)retTable.getValue("WAERS");
					 LEBRE       =  (String)retTable.getValue("LEBRE");
					 EKORG       =  (String)retTable.getValue("EKORG");
					 
					//String INCO1       =  (String)retTable.getValue("INCO1");
					//String INCO2       =  (String)retTable.getValue("INCO2");
					
					
					//out.println("::MANDT1::"+MANDT+"::::"+LIFNR+"::::"+EKORG+"::::"+ERDAT+"::::"+ERNAM+"::::"+WAERS+"::::"+MINBW+"::::"+ZTERM+"::::"+INCO1+"::::"+INCO2);	 
										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable.nextRow());			 
			}

			if(retCoun1 > 0)
			{
				do
				{
					// STCEG       	=  (String)retTable1.getValue("STCEG");
					 J_1ISERN       =  (String)retTable1.getValue("J_1ISERN");
					 J_1IEXRG       =  (String)retTable1.getValue("J_1IEXRG");					
					
					 J_1ICSTNO      =  (String)retTable1.getValue("J_1ICSTNO");
					 J_1IEXCD       =  (String)retTable1.getValue("J_1IEXCD");
					 J_1IEXDI       =  (String)retTable1.getValue("J_1IEXDI");
					 J_1IPANNO      =  (String)retTable1.getValue("J_1IPANNO");
					 J_1IEXRN       =  (String)retTable1.getValue("J_1IEXRN");
					 J_1IEXCO       =  (String)retTable1.getValue("J_1IEXCO");
					
					
					//out.println("::MANDT1::"+MANDT+"::::"+LIFNR+"::::"+EKORG+"::::"+ERDAT+"::::"+ERNAM+"::::"+WAERS+"::::"+MINBW+"::::"+ZTERM+"::::"+INCO1+"::::"+INCO2);	 
										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable.nextRow());			 
			}			
		if(retCoun2 > 0)
			{
				do
				{
					//String MANDT2       =  (String)retTable2.getValue("MANDT");
					//String PARNR       =  (String)retTable2.getValue("PARNR");
					NAMEV       =  (String)retTable2.getValue("NAMEV");					
					NAME1ConInfo       =  (String)retTable2.getValue("NAME1");
					//String ABTNR       =  (String)retTable2.getValue("ABTNR");
					//String UEPAR       =  (String)retTable2.getValue("UEPAR");
					 TELF1       =  (String)retTable2.getValue("TELF1");
					//String VRTNR       =  (String)retTable2.getValue("VRTNR");
					//Date ERDAT         =  (Date)retTable2.getValue("ERDAT");
					//String ERNAM       =  (String)retTable2.getValue("ERNAM");
					//String DUEFL       =  (String)retTable2.getValue("DUEFL");
					//String LIFNR2       =  (String)retTable2.getValue("LIFNR");
					//String KZHERK      =  (String)retTable2.getValue("KZHERK");
					//String PRSNR       =  (String)retTable2.getValue("PRSNR");
					
					
					//out.println("::MANDT2::"+MANDT+"::::"+PARNR+"::::"+NAMEV+"::::"+NAME1+"::::"+ABTNR+"::::"+UEPAR+"::::"+TELF1+"::::"+VRTNR+"::::"+ERDAT+"::::"+ERNAM+"::::"+DUEFL+"::::"+LIFNR+"::::"+KZHERK+"::::"+PRSNR);	 
										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable2.nextRow());			 
			}
		if(retCoun3 > 0)
			{
				do
				{
					//String MANDT3       =  (String)retTable3.getValue("MANDT");
					//String LIFNR3       =  (String)retTable3.getValue("LIFNR");
					//String BANKS       =  (String)retTable3.getValue("BANKS");
					//String BANKL       =  (String)retTable3.getValue("BANKL");					
					 BANKN       =  (String)retTable3.getValue("BANKN");
					
					
					
					//out.println("::MANDT3::"+MANDT+"::::"+LIFNR+"::::"+BANKS+"::::"+BANKL+"::::"+BANKN);	 
					//out.println("::::"+BANKN);	 										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable3.nextRow());			 
			}			
		
		if(retCoun4 > 0)
			{
				do
				{
					//String MANDT4       =  (String)retTable4.getValue("MANDT");
					 //ERDAT         =  (Date)retTable4.getValue("ERDAT");					
					//String ERNAM       =  (String)retTable4.getValue("ERNAM");					
					//String BNKLZ       =  (String)retTable4.getValue("BNKLZ");
					
					 BANKS       =  (String)retTable4.getValue("BANKS");
					//String STRAS       =  (String)retTable4.getValue("STRAS");
					 BANKL       =  (String)retTable4.getValue("BANKL");					
					 BANKA       =  (String)retTable4.getValue("BANKA");
					//String ORT01       =  (String)retTable4.getValue("ORT01");
					 PROVZ       =  (String)retTable4.getValue("PROVZ");
					 BRNCH       =  (String)retTable4.getValue("BRNCH");
					
					
					
					//out.println("::MANDT4::"+MANDT+"::::"+ERDAT+"::::"+BANKS+"::::"+BANKL+"::::"+ERNAM+"::::"+BANKA+"::::"+BNKLZ);
					//out.println("::MANDT4::"+BANKS+"::::"+BANKL+"::::"+BANKA+"::::"+PROVZ+"::::"+BRNCH);	 
										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable4.nextRow());			 
			}	
		if(retCoun5 > 0)
			{
				do
				{
					//String CLIENT           =  (String)retTable5.getValue("CLIENT");					
					//String ADDRNUMBER       =  (String)retTable5.getValue("ADDRNUMBER");
					//String PERSNUMBER       =  (String)retTable5.getValue("PERSNUMBER");	
					//Date DATE_FROM          =  (Date)retTable5.getValue("DATE_FROM");
					//String CONSNUMBER       =  (String)retTable5.getValue("CONSNUMBER");
					 SMTP_ADDR        =  (String)retTable5.getValue("SMTP_ADDR");
					//String SMTP_SRCH        =  (String)retTable5.getValue("SMTP_SRCH");
					
					
					//out.println("::CLIENT::"+SMTP_ADDR);	 										 
					//out.println("::CLIENT::"+CLIENT+"::::"+ADDRNUMBER+"::::"+PERSNUMBER+"::::"+DATE_FROM+"::::"+CONSNUMBER+"::::"+SMTP_ADDR+"::::"+SMTP_SRCH);	 
										 
										 
					//openIBDItemsHT.put(itemNo,itemOpenQty);	 
				}						 
				while(retTable5.nextRow());			 
			}			
	}	
	catch(Exception e){
		out.println(">>>>>>>>>EXCEPTION--Z_EZ_GET_VENDOR_DETAILS>>>>>>>>>>"+e);
	}
	finally
	{
			if(client!=null)
			{
				System.out.println(".........RELEASING CLIENT........");
				JCO.releaseClient(client);
				client = null;
				function=null;

			}
	}

	//System.out.println(">>>>>>>>>OPEN IBD ITEMS>>>>>>>>>>"+openIBDItemsHT);
	//out.println(openIBDItemsHT);
%>