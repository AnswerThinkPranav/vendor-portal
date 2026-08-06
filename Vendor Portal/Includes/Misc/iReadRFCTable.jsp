<%@page import="ezc.ezparam.ReturnObjFromRetrieve,ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%!

		public ReturnObjFromRetrieve readRFCTableBBP(String site,String tableName,String [] outputFeilds, String [] queryValues)
		{
			ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve();
			JCoFunction poFunction = null;
			JCoParameterList sapPurOrd = null;
	
			try
			{
				JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
				poFunction = EzSAPHandler.getJCoFunction(destination,"BBP_RFC_READ_TABLE");		
				sapPurOrd 	 = poFunction.getImportParameterList();
				sapPurOrd.setValue("QUERY_TABLE",tableName);
				sapPurOrd.setValue("DELIMITER","#");
				JCoTable optionTable = poFunction.getTableParameterList().getTable("OPTIONS");
				for(int i=0;i<queryValues.length;i++)
				{
					optionTable.appendRow();
					optionTable.setValue("TEXT",queryValues[i]);
				}
				JCoTable fieldTable = poFunction.getTableParameterList().getTable("FIELDS");
				for(int i=0;i<outputFeilds.length;i++)
				{
					fieldTable.appendRow();
					fieldTable.setValue("FIELDNAME",outputFeilds[i]);
					retObj.addColumn(outputFeilds[i]);
				}
	
				try{
					poFunction.execute(destination);
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing BBP_RFC_READ_TABLE>>>"+e,"I");		
				}
	
				try {
					JCoTable dataTable = poFunction.getTableParameterList().getTable("DATA");
					if(dataTable != null)
					{
						do
						{
							String [] tempOutArr 	= ((String)dataTable.getValue("WA")).split("#");
							for(int i=0;i<tempOutArr.length;i++)
							{
								retObj.setFieldValue(i, tempOutArr[i]);
							}
							retObj.addRow();
						}
						while(dataTable.nextRow());
					}
					
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing BBP_RFC_READ_TABLE>>>"+e,"I");		
				}
		
			}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing BBP_RFC_READ_TABLE>>>"+e,"I");		
			}
			return retObj;	
	}

	public ReturnObjFromRetrieve readRFCTable(String site,String tableName,String [] outputFeilds, String [] queryValues)
	{
		ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve();
		JCoFunction poFunction = null;
		JCoParameterList sapPurOrd = null;

		try
		{
			JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
			poFunction = EzSAPHandler.getJCoFunction(destination,"RFC_READ_TABLE");		
			sapPurOrd 	 = poFunction.getImportParameterList();
			sapPurOrd.setValue("QUERY_TABLE",tableName);
			sapPurOrd.setValue("DELIMITER","#");
			JCoTable optionTable = poFunction.getTableParameterList().getTable("OPTIONS");
			for(int i=0;i<queryValues.length;i++)
			{
				optionTable.appendRow();
				optionTable.setValue("TEXT",queryValues[i]);
			}
			JCoTable fieldTable = poFunction.getTableParameterList().getTable("FIELDS");
			for(int i=0;i<outputFeilds.length;i++)
			{
				fieldTable.appendRow();
				fieldTable.setValue("FIELDNAME",outputFeilds[i]);
				retObj.addColumn(outputFeilds[i]);
			}

			try{
				poFunction.execute(destination);
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing RFC_READ_TABLE>>>"+e,"I");		
			}

			try {
				JCoTable dataTable = poFunction.getTableParameterList().getTable("DATA");
				if(dataTable != null)
				{
					do
					{
						String [] tempOutArr 	= ((String)dataTable.getValue("WA")).split("#");
						for(int i=0;i<tempOutArr.length;i++)
						{
							retObj.setFieldValue(i, tempOutArr[i]);
						}
						retObj.addRow();
					}
					while(dataTable.nextRow());
				}
				
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing RFC_READ_TABLE>>>"+e,"I");		
			}
	
		}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing RFC_READ_TABLE>>>"+e,"I");		
		}
		return retObj;	
	}

%>

<%
	
	/*
	String [] outputFeilds =new String[]{"LIFNR"};
	String [] queryValues =new String[]{"EBELN EQ '0000132957' AND BELNR EQ '5000280875'"};
	ReturnObjFromRetrieve ret = readRFCTable("200","EKBZ",outputFeilds,queryValues);
	out.print(ret.toEzcString());
	*/
%>