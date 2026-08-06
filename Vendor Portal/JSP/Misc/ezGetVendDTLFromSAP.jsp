<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%
	//String vendArr[] = {"312599","312569","312556","309408","312557","312534","310463","309596","312513","312566","312557","307350","312533","312622","400989","800995","400902","401246","401246","312638","312628","312627","307418","312530","312554","312564","312644","401280","312575","307540","312517","308940","308940","307540","312517","312648","312655","312649","312624","312624","312554","312530","307540","401241","312649","307540","309273","801930","307540","312519","307540","310706","308940","401246","401046","309408","600804","401246","312572","401070","312746","307350","312536","401070","312572","312463","401329","400902","312534","312643","308926","312513","401280","601058","400813","401341","307441","307441","312547","309955","601058","401249","401342","600835","308368","307540","312531","311916","601348","601351","312581","312580","312674","309408","601341","700449","601341","700449","308688","601298","601361","601298","308565","308565","312625"};
	String vendArr[] = {"310706","312463","308926","400813","307441","307441","309955","401249"};
	
	for(int a=0;a<vendArr.length;a++)
	{
	String soldToCode	= 	vendArr[a];
	//String compCode		=	"1000";
	String compCode		=	"5000";
	String vendName 	=	"";
	String vendMobileNo 	=	"";
	String eMail 		=	"";
	String FLGDEFAULT 	=	"";
	String R3_USER 		=	"";
	String country 		=	"";
	
	ezc.ezcommon.EzLog4j.log(":soldToCode:::::::::::::::"+soldToCode,"I");
	
	//out.println(":soldToCode111:"+soldToCode);
	if(soldToCode!=null)
	{
		try{
			Long.parseLong(soldToCode);
			soldToCode = "0000000000"+soldToCode;
			soldToCode = soldToCode.substring(soldToCode.length()-10,soldToCode.length());
		}catch(Exception e){}	
	}

	java.util.Vector purOrgSysKey = new java.util.Vector();
	java.util.Vector purOrgVect   = new java.util.Vector();
	String logonSite = (String)session.getValue("SITE");

	try
	{
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
		JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_DETAILS");
		JCoParameterList impParam = function.getImportParameterList();

		impParam.setValue("VENDOR",soldToCode);
		impParam.setValue("COMPCODE",compCode);
		//out.println(":soldToCode:"+soldToCode);
		//out.println(":compCode:"+compCode);	
		try
		{
			function.execute(destination);
			//out.println("executed::");
		}catch(Exception e){
			//out.println("Exception::::::"+e);
		}
			
			
		JCoParameterList expParam = function.getExportParameterList();
		JCoStructure genDataStru  = expParam.getStructure("GEN_DATA");
		
		vendName 	= (String)genDataStru.getValue("NAME1");
		country		= (String)genDataStru.getValue("LAND1");
		
		//vendMobileNo 	= (String)genDataStru.getValue("TELF2");
		
		//if(vendMobileNo!=null)
			//vendMobileNo = vendMobileNo.replaceAll("-","");
			
		//out.println(":vendName	::"+vendName);
		//out.println(":Country	::"+(String)genDataStru.getValue("LAND1"));
		
		
		JCoTable purOrgTable = function.getTableParameterList().getTable("PURORG_DATA");
		JCoTable emailTable = function.getTableParameterList().getTable("VEND_EMAILS");
		JCoTable telTable = function.getTableParameterList().getTable("TEL_NUMBER");
		//out.println("::::::::::::::TEL_NUMBER::::::::::::"+telTable);

		/*if(telTable.getNumRows()>0)
		{
			do
			{
				FLGDEFAULT       =  (String)telTable.getValue("FLGDEFAULT");
				R3_USER       =  (String)telTable.getValue("R3_USER");
				vendMobileNo       =  (String)telTable.getValue("TEL_NUMBER");
				
				if((telTable.getNumRows() > 1)&& FLGDEFAULT.equals("X")&&(R3_USER.equals("2")||R3_USER.equals("3")))
				{
					vendMobileNo       =  (String)telTable.getValue("TEL_NUMBER");
					if(vendMobileNo!=null)
					vendMobileNo = vendMobileNo.replaceAll("-","");
				}	
				else if(R3_USER.equals("2")||R3_USER.equals("3"))
				{
					vendMobileNo       =  (String)telTable.getValue("TEL_NUMBER");	
					if(vendMobileNo!=null)
					vendMobileNo = vendMobileNo.replaceAll("-","");
					
					//out.println(":vendMobileNo::"+vendMobileNo);
				}	
			}						 
				while(telTable.nextRow());				 
		}
			//out.println(":purOrgTable::"+purOrgTable.getNumRows());
		if(purOrgTable.getNumRows()>0)
		{
			do{
				purOrgVect.addElement(purOrgTable.getValue("EKORG"));
				//out.println(":EKORG::"+purOrgTable.getValue("EKORG"));

			} 
			while(purOrgTable.nextRow());			 
		}*/
		if(emailTable.getNumRows()>0)
		{
			do{
				if("X".equals((String)emailTable.getValue("FLGDEFAULT")))
					eMail = (String)emailTable.getValue("SMTP_ADDR");
					
				//out.println(":eMail::"+eMail);	

			}						 
			while(emailTable.nextRow());			 
		}	
	}
	catch(Exception e){
		//out.println(":::::Exception:::::::"+e);
	}
	
	out.println("INSERT INTO EZC_VEND_GEN_DATA(EVGD_VENDOR,EVGD_NAME,EVGD_EMAIL,EVGD_COUNTRY) VALUES('"+vendArr[a]+"','"+vendName+"','"+eMail+"','"+country+"');");
	//ezc.ezcommon.EzLog4j.log("INSERT INTO EZC_VEND_GEN_DATA(EVGD_VENDOR,EVGD_NAME,EVGD_EMAIL,EVGD_COUNTRY) VALUES('"+vendArr[a]+"','"+vendName+"','"+eMail+"','"+country+"');","I");
	
	//out.println(vendArr[a]+"\t"+vendName+"\t"+country+"\t"+eMail);
	}	
	
	
%>
