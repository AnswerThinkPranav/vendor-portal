<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ page import = "ezc.ezparam.*,java.util.*,java.text.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp" %>
 <% 
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null; 
	miscTableRow.setQuery("SELECT EMKV_KEY from EZC_MASTER_KEY_VALUES WHERE EMKV_MASTER_TYPE='MATL_GRP'");
	
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
	}catch(Exception e){
		log("Exception in getting MATGRP from Portal>>>>>"+e); 
	}
	int dtlXMLCnt = 0;
	int retMasterCnt = 0;
	int chkCounter=0;
	if(dtlXML != null)
		dtlXMLCnt = dtlXML.getRowCount();
		out.println("::::dtlXMLCnt::::::"+dtlXMLCnt);
		out.println("::::dtlXML::::::"+dtlXML.toEzcString());
	
	Vector ptTTVect = new Vector();
	for(int p=0;p<dtlXMLCnt;p++)
	{
		String ptKey = dtlXML.getFieldValueString(p,"EMKV_KEY").trim();
		if("".equals(ptKey) || ptTTVect.contains(ptKey))
			continue;
		ptTTVect.addElement(ptKey);
	}
	out.println("::::ptTTVect::::::"+ptTTVect.size());

	
 	String site = "300";//request.getParameter("site");
 	String tableName = "T023T";
 	String [] outputFeilds = {"MATKL","WGBEZ"};
 	String [] queryValues = {};
 	
 	ReturnObjFromRetrieve retMaster = readRFCTable(site,tableName,outputFeilds,queryValues);
 	
	if(retMaster != null)
		retMasterCnt = retMaster.getRowCount();
		out.println("::::retMasterCnt::::::"+retMasterCnt);
		//out.println("::::retMaster::::::"+retMaster.toEzcString()); 	
 	
 	//if(dtlXMLCnt > 0)
 	//{ 	
 	
		mainParams = new ezc.ezparam.EzcParams(false); 				
		miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		miscTable = new ezc.misctransactions.params.EzMiscTable();
		

			try
			{
				for(int i=0;i<retMasterCnt;i++)
				{
					String sapKeyTT = retMaster.getFieldValueString(i,"MATKL").trim();
					String serDesc="NA";
					try
					{
						  serDesc = retMaster.getFieldValueString(i,"WGBEZ").trim();
					}catch(Exception e){}
					serDesc = serDesc.replaceAll("'", "\"");
					
					if("".equals(sapKeyTT) || ptTTVect.contains(sapKeyTT))
						continue;					
					
					miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
					miscTableRow.setQuery("INSERT INTO EZC_MASTER_KEY_VALUES (EMKV_MASTER_TYPE,EMKV_KEY,EMKV_VALUE,EMKV_VALUE1,EMKV_VALUE2,EMKV_VALUE3) VALUES ('MATL_GRP','"+sapKeyTT+"','"+serDesc+"','','','');");
					miscTable.appendRow(miscTableRow);
					chkCounter++;
					//out.println("sapKeyTT>>>>"+sapKeyTT);		
					out.println(miscTableRow.getQuery());		
					
					
				}
			}
			catch(Exception e)
			{
					ezc.ezcommon.EzLog4j.log(e+"Exception in RFC READ","I");
			}
			out.println("chkCounter>>>>"+chkCounter);
			try
			{

				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				miscMgr.ezSaveMiscTransactions(mainParams);
			}
			catch(Exception e){}
		
			//out.println(":::miscTable::"+miscTable.getRowCount());			

	//}	
		
 %>