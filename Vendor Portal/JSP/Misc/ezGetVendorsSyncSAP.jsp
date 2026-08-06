<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<%
	String logonSite = (String)session.getValue("SITE");
	
	String dateStr = getDateStr(new java.util.Date(),"DATE");
	       dateStr = dateStr.replace("-","");
	
	String [] outputFeilds 	=	new String[]{"LIFNR","LAND1","KTOKK","NAME1","ERDAT"};
	String [] queryValues 	=	new String[]{"ERDAT EQ '"+dateStr+"'"};
	//String [] queryValues 	=	new String[]{"ERDAT EQ '20161220'"};
	String [] comCodeArr 	= 	new String[]{"1000","5000"};
	
	ezc.ezcommon.EzLog4j.log("::::::::::::::GETTING VENDORS FROM SAP-STARTS::::::::::::::"+queryValues[0],"I");
	
	java.util.Vector  vendAccCat = new java.util.Vector();
	java.util.Vector  comCodeVend = new java.util.Vector();
	
	vendAccCat.addElement("Z001");
	vendAccCat.addElement("Z002");
	vendAccCat.addElement("Z003");
	vendAccCat.addElement("Z004");
	vendAccCat.addElement("Z005");
	vendAccCat.addElement("Z006");
	vendAccCat.addElement("Z007");
	vendAccCat.addElement("Z008");
	vendAccCat.addElement("Z009");
	vendAccCat.addElement("Z010");
	vendAccCat.addElement("Z011");
	vendAccCat.addElement("Z012");
	vendAccCat.addElement("Z013");
	vendAccCat.addElement("Z014");
	vendAccCat.addElement("Z015");
	vendAccCat.addElement("Z016");
	vendAccCat.addElement("Z017");
	
	int retVendObjCnt = 0;
	ReturnObjFromRetrieve retVendObj = readRFCTable(logonSite,"LFA1",outputFeilds,queryValues);
	
	if(retVendObj!=null)
		retVendObjCnt = retVendObj.getRowCount();
	
	if(retVendObjCnt>0)
	{
		String qryStr = "", lv_VendCode = "";
		for(int a=0;a<retVendObjCnt;a++)
		{
			lv_VendCode = retVendObj.getFieldValueString(a,"LIFNR");
			try{
				lv_VendCode = Long.parseLong(lv_VendCode)+"";
			}catch(Exception e){}
			
			if(a==0)
				qryStr = lv_VendCode;
			else
				qryStr += "','"+lv_VendCode;
		}	
		
		qryStr = "SELECT EVGD_VENDOR FROM EZC_VEND_GEN_DATA WHERE EVGD_VENDOR IN ('"+qryStr+"')";

		ReturnObjFromRetrieve retDBVendObj = (ReturnObjFromRetrieve)ezMiscSelect(Session,qryStr);
		java.util.Vector  dbVendList = new java.util.Vector();
		
		if(retDBVendObj.getRowCount()>0)
		{
			for(int v=0;v<retDBVendObj.getRowCount();v++)
				dbVendList.addElement(retDBVendObj.getFieldValueString(v,"EVGD_VENDOR"));
		}

		ArrayList<String> queries=new ArrayList<String>();

		for(int c=0;c<comCodeArr.length;c++)
		{
			ezc.ezcommon.EzLog4j.log("::::::::::::::GETTING VENDORS FROM SAP-COMP-CODE::::::::::::::"+comCodeArr[c],"I");
			
			for(int a=0;a<retVendObjCnt;a++)
			{
				String soldToCode	= 	retVendObj.getFieldValueString(a,"LIFNR");// vendArr[a];
				String vendAccGrp	= 	retVendObj.getFieldValueString(a,"KTOKK");

				if(!vendAccCat.contains(vendAccGrp))
					continue;

				String lv_soldToCode    =	"";	
				try{
					lv_soldToCode = Long.parseLong(soldToCode)+"";
				}catch(Exception e){}	

				if(dbVendList.contains(lv_soldToCode))
					continue;
					
				if(comCodeVend.contains(lv_soldToCode))  //If Vendor is presented in two comp codes then first one is enough, else qry insertion failes
					continue;	

				String vendCrDat	= 	retVendObj.getFieldValueString(a,"ERDAT");
				String compCode		=	comCodeArr[c];//"1000";
				String vendName 	=	"";
				String vendMobileNo 	=	"";
				String eMail 		=	"";
				String FLGDEFAULT 	=	"";
				String R3_USER 		=	"";
				String country 		=	"";
				String crDateStr	=	"1900-01-01 00:00:00";

				try{
					crDateStr = vendCrDat.substring(0,4)+"-"+vendCrDat.substring(4,6)+"-"+vendCrDat.substring(6,8);
				}catch(Exception e){}


				if(soldToCode!=null)
				{
					try{
						soldToCode = "0000000000"+soldToCode;
						soldToCode = soldToCode.substring(soldToCode.length()-10,soldToCode.length());
					}catch(Exception e){}	
				}

				try
				{
					JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
					JCoFunction function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_DETAILS");
					JCoParameterList impParam = function.getImportParameterList();

					impParam.setValue("VENDOR",soldToCode);
					impParam.setValue("COMPCODE",compCode);

					try{
						function.execute(destination);
					}catch(Exception e){}


					JCoParameterList expParam = function.getExportParameterList();
					JCoStructure genDataStru  = expParam.getStructure("GEN_DATA");

					vendName 	= (String)genDataStru.getValue("NAME1");
					country		= (String)genDataStru.getValue("LAND1");

					JCoTable purOrgTable = function.getTableParameterList().getTable("PURORG_DATA");
					JCoTable emailTable = function.getTableParameterList().getTable("VEND_EMAILS");
					JCoTable telTable = function.getTableParameterList().getTable("TEL_NUMBER");
					if(emailTable.getNumRows()>0)
					{
						do{
							if("X".equals((String)emailTable.getValue("FLGDEFAULT")))
								eMail = (String)emailTable.getValue("SMTP_ADDR");
						}while(emailTable.nextRow());			 
					}	
				}catch(Exception e){}
				
				String vendQry = "";
				if(country!=null && !"null".equals(country) && !"".equals(country)) //if this is null then the vendor doesn't exist in the passed comp code
				{
					comCodeVend.addElement(lv_soldToCode);
					vendQry = "INSERT INTO EZC_VEND_GEN_DATA(EVGD_VENDOR,EVGD_NAME,EVGD_EMAIL,EVGD_COUNTRY,EVGD_ACC_GROUP,EVGD_CREATED_ON) VALUES('"+lv_soldToCode+"','"+vendName+"','"+eMail+"','"+country+"','"+vendAccGrp+"','"+crDateStr+"');";
					queries.add(vendQry);
				}	
			}	
		}	
		if(queries.size()>0)
			ezMiscInsert(Session,queries);
	}
	
	ezc.ezcommon.EzLog4j.log("::::::::::::::GETTING VENDORS FROM SAP-END::::::::::::::","I");
%>
