<%!
	public String expToString(String cBalValueStr)
	{
		try
		{
			if(cBalValueStr.indexOf("E") >= 0)
			{
				java.math.BigDecimal myNumber = new java.math.BigDecimal(cBalValueStr);
				int myInt = myNumber.intValue(); 
				ezc.ezcommon.EzLog4j.log(myInt+"::::::myInt::::","I");
				cBalValueStr = myInt+"";
				ezc.ezcommon.EzLog4j.log(cBalValueStr+"::::::cBalValueStr::::","I");
			}
		}
		catch(Exception e)
		{
			cBalValueStr="0";
		}
		return cBalValueStr;
	}

%>
<%
	
	String path= request.getParameter("path");
	int lastIndex = 0;
	if(path!=null && !"null".equals(path))
	lastIndex = path.lastIndexOf("\\");

	String filename="UploadMaterials";

	if(lastIndex>0)
	filename=path.substring(lastIndex,path.length());
	
	File upFile=null;
	try
	{

		ResourceBundle rb=ResourceBundle.getBundle("Site");
		String serverPath=rb.getString("INBOXPATH");
		//INBOXPATH

		File dirFile=new File(serverPath+session.getId());


		if(!((dirFile.exists()) && (dirFile.isDirectory())))
		{
			boolean dir=dirFile.mkdirs();
		}
		String dirName=dirFile.getPath();
		MultipartRequest multi = new MultipartRequest(request, dirName, 10*1024*1024);

		java.util.Enumeration files = multi.getFileNames();

		if(files.hasMoreElements())
		{
			String name = (String)files.nextElement();
			upFile = multi.getFile(name);
		}



	}
	catch(Exception e)
	{
		System.out.println("Error while reading file : "+e);
	}
	

	
	short mNumRow=0;  

	String   matNum=""; 
	String matString = "";
	
	
	if (upFile != null)
	{    
		FileInputStream fs =null;
		if(upFile!=null)		
		fs = new FileInputStream(upFile);
		try
		{    
			    
			HSSFWorkbook wb = null;
			if(fs!=null && !"null".equals(fs))
			wb = new HSSFWorkbook(fs); 
			HSSFSheet mySheet = wb.getSheetAt(0); 
			Iterator rowIter = mySheet.rowIterator();
			

			    		int firstRow=0;
					while (rowIter.hasNext()) 
					{
					
						String matDetails = "";
						String mNum="";		
						String mdesc="";
						String mUOM="";
						String mQunty="";
						String mDate="";
						HSSFRow myRow = (HSSFRow) rowIter.next();
						//if(firstRow==0)
						//{
							//firstRow = firstRow+1;
							//continue;
						//}
						if(firstRow>0)
						{

							Iterator cellIter = myRow.cellIterator();
							int cellCnt=0;
							String cValue="";
							while (cellCnt<5)
							{
								HSSFCell myCell = null;
								String celValue="";
								if(cellIter.hasNext())
								{
									myCell = (HSSFCell) cellIter.next();
									celValue=(String)myCell.toString();
								}
								if("".equals(celValue.trim()))
								{
								
								cellCnt = cellCnt+1;
								//chkValue="N";
								continue;
								}								
								if(cellCnt==0)
								{ 
									if(celValue.indexOf("E")>=0)
									mNum = expToString(celValue.trim());
									else
									mNum = celValue.trim();
									
									if(!"".equals(mNum))
									{
									mNum = "000000000000000000"+mNum.trim();
									mNum = mNum.substring(mNum.length()-18);
									}
								}
								
								
								cellCnt = cellCnt+1;
							}
							if(!"".equals(mNum.trim()))
							{
								
								if("".equals(matString))matString = "'"+mNum.trim()+"'";

								matString = matString+",'"+mNum.trim()+"'";	
							}	
						}	
						firstRow = firstRow+1;
					}
			
			
  
		}    
		catch(Exception E){        System.out.println(E);    }
		finally
		{
			if(fs!=null)
			fs.close();

		}		
		
	}
	
	String r3SysSID = "245~999";
	JCO.Function function = null;
	JCO.Client client = null;		
	java.util.Hashtable matListHT = new java.util.Hashtable();

	try
	{
		
		client = EzSAPHandler.getSAPConnection(r3SysSID);
		function = EzSAPHandler.getFunction("RFC_READ_TABLE",r3SysSID);

		JCO.ParameterList reasonsParamIn    = function.getImportParameterList();
		JCO.ParameterList reasonsParamTable = function.getTableParameterList();

		JCO.Table reasonsFields  = reasonsParamTable.getTable("FIELDS");

		reasonsParamIn.setValue("MARA","QUERY_TABLE");
		reasonsParamIn.setValue("#","DELIMITER");

		reasonsFields.appendRow();
		reasonsFields.setValue("MATNR","FIELDNAME");
		reasonsFields.appendRow();
		reasonsFields.setValue("MEINS","FIELDNAME");

		JCO.Table options  = reasonsParamTable.getTable("OPTIONS");
		int matStrLen	= 0;
		if(matString!= null && !"null".equals(matString) && !"".equals(matString))
		{
			matString = "MATNR IN ("+matString+")";
			matStrLen	= matString.length();
		}
		int matStrLines	= 0,start=0,end=0,interval=42,lastStr=0;

		if(matStrLen>interval)
		{
		
			String matStr = ""; 
			
			matStrLines 	= matStrLen/interval;
			lastStr		= matStrLen%interval;

			end = interval;
			for(int i=0;i<matStrLines;i++)
			{
				if(i==0)end=52;
				matStr	= matString.substring(start,end);
				options.appendRow();
				options.setValue(matStr,"TEXT");
				start = end;
				end+=interval; 
			}
			
			if(lastStr>0)
			{
				matStr	= matString.substring(start,matString.length());
				options.appendRow();
				options.setValue(matStr,"TEXT");
			}
		}else{
			options.appendRow();
			options.setValue("MATNR IN ("+matString+")","TEXT");
		}
		try
		{
			client.execute(function);
		}catch(Exception e){
			ezc.ezcommon.EzLog4j.log("Exception while executing RFC call RFC_READ_TABLE"+e,"I");
		}	

		JCO.Table materialListOut 	= function.getTableParameterList().getTable("DATA");
		int materialListOutCount 	= materialListOut.getNumRows();
		if(materialListOutCount>0)
		{
			do
			{
				String matKeyValStr 	= (String)materialListOut.getValue("WA"); 
				String matKey 		= matKeyValStr.split("#")[0];
				String matVal 		= matKeyValStr.split("#")[1];
				
				if("PAK".equals(matVal))matVal="PAC";
				if("MLW".equals(matVal))matVal="MLI";
				if("BOT".equals(matVal))matVal="BT";
				if("CF".equals(matVal))matVal="CFU";
				if("GM1".equals(matVal))matVal="GML";
				if("GW".equals(matVal))matVal="GAI";
				if("IN1".equals(matVal))matVal="IN";
				if("KAN".equals(matVal))matVal="CAN";
				if("KAR".equals(matVal))matVal="CAR";
				if("KGW".equals(matVal))matVal="KAI";
				if("KI".equals(matVal))matVal="CRT";
				if("KWK".equals(matVal))matVal="KIK";
				if("LE".equals(matVal))matVal="AU";
				if("MLW".equals(matVal))matVal="MLI";
				if("PCT".equals(matVal))matVal="PRC";
				if("TB".equals(matVal))matVal="TUB";
				if("TH".equals(matVal))matVal="TS";
				
				matListHT.put(matKey.trim(),matVal.trim());
			}
			while(materialListOut.nextRow());
		}

	}catch(Exception e){ezc.ezcommon.EzLog4j.log("Exception while getting plant codes from SAP ::::"+e,"I");}
	finally
	{
		if (client!=null)
		{
			ezc.ezcommon.EzLog4j.log("R E L E A S I N G   C L I E N T .... ","I");
			JCO.releaseClient(client);
			client = null;
			function=null;
		}
	}
	
	
%>    
