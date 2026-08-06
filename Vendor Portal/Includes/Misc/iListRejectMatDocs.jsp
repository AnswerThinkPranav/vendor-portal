<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*, java.net.*" %>

<%! 
	private String checkNull(String str)
	{
		if("null".equals(str) ||str==null || str=="" || "".equals(str))
		str="NA";
		return str;
	}
%>    	
<%	
	String tempFromDate = fromDate.substring(6,10)+""+fromDate.substring(3,5)+""+fromDate.substring(0,2);
	String tempToDate = toDate.substring(6,10)+""+toDate.substring(3,5)+""+toDate.substring(0,2);
	
	String vendCode = (String)session.getValue("SOLDTO");
	String purOrg   = (String)session.getValue("PURORG");
	String ccode=(String)session.getValue("CCode");
	
	int RejMatDocsCount=0;
	ezc.ezparam.ReturnObjFromRetrieve retRejMatDocsObj=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"MATDOCNO","MVT_TYPE","PONUM","POITEMNO","MATCODE","MATDESC","UOM","REC_QTY","ACCEPTED_QTY","REJ_QTY","INSLOT","UD_TYPE","REF_DOC","REJ_DOC_NO"});

	try
	{
		String logonSite = (String)session.getValue("SITE");
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
		JCoFunction function 		= EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_REJECT_MATERIAL_DOCS");
		JCoParameterList parameterList 	= function.getImportParameterList();
		JCoTable dateTable 		= parameterList.getTable("DATE");	
		JCoTable compCodeTable 		= parameterList.getTable("COMPANY_CODE");	
		JCoTable vendTable 		= function.getTableParameterList().getTable("VENDOR");	
		
		
		parameterList.setValue("PUR_ORG",purOrg);
		
		vendTable.appendRow();
		vendTable.setValue("SIGN","I");	
		vendTable.setValue("OPTION","EQ");
		vendTable.setValue("LIFNR_LOW",vendCode);
		
		dateTable.appendRow();
		dateTable.setValue("SIGN","I");	
		dateTable.setValue("OPTION","BT");
		dateTable.setValue("LOW",tempFromDate);
		dateTable.setValue("HIGH",tempToDate);
				
		/*
		compCodeTable.appendRow();
		compCodeTable.setValue("SIGN","I");	
		compCodeTable.setValue("OPTION","EQ");
		compCodeTable.setValue("LOW","1000");
		*/
		
		//parameterList.setValue("REJ_ONLY","X");

		ezc.ezcommon.EzLog4j.log(":::::::::::PUR_ORG::::::::::"+parameterList.getValue("PUR_ORG"),"I");
		ezc.ezcommon.EzLog4j.log(":::::::::::REJ_ONLY::::::::::"+parameterList.getValue("REJ_ONLY"),"I");
		ezc.ezcommon.EzLog4j.log(":::::::::::FROM DATE::::::::::"+dateTable.getValue("LOW"),"I");
		ezc.ezcommon.EzLog4j.log(":::::::::::TO DATE::::::::::"+dateTable.getValue("HIGH"),"I");
		
		//ezc.ezcommon.EzLog4j.log(":::::::::::compCode::::::::::"+compCodeTable.getValue("LOW"),"I");
		try
		{
			function.execute(destination);
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_REJECT_MATERIAL_DOCS  exec"+e,"E");
		}

		JCoTable RejMatDocsTable= function.getTableParameterList().getTable("IT_DISPLAY");

		if(RejMatDocsTable!=null)
			RejMatDocsCount	= RejMatDocsTable.getNumRows();		
			
		if(RejMatDocsCount>0)
		{
			do
			{	  
				retRejMatDocsObj.setFieldValue("MATDOCNO",(String)RejMatDocsTable.getValue("MBLNR"));
				retRejMatDocsObj.setFieldValue("MVT_TYPE",(String)RejMatDocsTable.getValue("BWART"));
				retRejMatDocsObj.setFieldValue("PONUM",(String)RejMatDocsTable.getValue("EBELN"));					
				retRejMatDocsObj.setFieldValue("POITEMNO",(String)RejMatDocsTable.getValue("EBELP"));
				retRejMatDocsObj.setFieldValue("MATCODE",(String)RejMatDocsTable.getValue("MAT_CODE"));
				retRejMatDocsObj.setFieldValue("MATDESC",(String)RejMatDocsTable.getValue("MAKTX"));
				retRejMatDocsObj.setFieldValue("UOM",(String)RejMatDocsTable.getValue("MEINS"));
				retRejMatDocsObj.setFieldValue("REC_QTY",RejMatDocsTable.getValue("MENGE")+"");
				retRejMatDocsObj.setFieldValue("ACCEPTED_QTY",RejMatDocsTable.getValue("MENGE_105")+"");
				retRejMatDocsObj.setFieldValue("REJ_QTY",RejMatDocsTable.getValue("REJ_QUAN")+"");
				retRejMatDocsObj.setFieldValue("INSLOT",(String)RejMatDocsTable.getValue("PRUEFLOS"));
				retRejMatDocsObj.setFieldValue("UD_TYPE",(String)RejMatDocsTable.getValue("UD_CODE"));
				retRejMatDocsObj.setFieldValue("REF_DOC",(String)RejMatDocsTable.getValue("XBLNR"));
				retRejMatDocsObj.setFieldValue("REJ_DOC_NO",(String)RejMatDocsTable.getValue("REJ_DOC_NO"));
				retRejMatDocsObj.addRow();
			}while(RejMatDocsTable.nextRow());					
		}
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception while executing RFC call Z_EZ_GET_REJECT_MATERIAL_DOCS"+e,"E");
	}


	
	int retRejMatDocsObjCnt=0;
	if(retRejMatDocsObj!=null)retRejMatDocsObjCnt=retRejMatDocsObj.getRowCount();


	//ezc.ezcommon.EzLog4j.log(".....:::::retRejMatDocsObj::::.... "+retRejMatDocsObj.toEzcString(),"D");
	
%>      