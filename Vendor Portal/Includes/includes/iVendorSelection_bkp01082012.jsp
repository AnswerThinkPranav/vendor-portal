<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@page import="com.sap.mw.jco.*,ezc.sapconnection.EzSAPHandler"%>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,ezc.ezcommon.*" %>

<%

	
	ReturnObjFromRetrieve retRfqRanks = new ReturnObjFromRetrieve(new String[]{"RFQ_NUM","RFQ_ITEM","MATERIAL","CO_CODE","RFQ_VALUE","RANK","VENDOR_CODE","MATERIAL_DESC","MAT_QUANTITY","EXT1"});
	ReturnObjFromRetrieve retRfqReasons = new ReturnObjFromRetrieve(new String[]{"REASONS_KEY","REASONS_VALUE"});
	ReturnObjFromRetrieve retRFQDetails = null;
	java.util.ArrayList rfqLineItems = new java.util.ArrayList();
	java.util.ArrayList rfqMatList = new java.util.ArrayList();
	java.util.Hashtable itemMaterialHt = new java.util.Hashtable();
	
	java.util.ArrayList qcfRfqItemsList = new java.util.ArrayList();

	
	String flag = request.getParameter("flag");
	int noOfQcfRFQItems = 0;
	int itemSize = 0;
	boolean mulMaterials = false;

	String r3SysSID = "245~999";
	JCO.Function function = null;
	JCO.Client client = null;

	String qcfNo = request.getParameter("QcfNumber");
	if("VIEW".equals(flag.trim()))
	{
	
		java.util.Hashtable reasonsHT = new java.util.Hashtable();
		 	
		try
		{
			
			client = EzSAPHandler.getSAPConnection(r3SysSID);
			function = EzSAPHandler.getFunction("RFC_READ_TABLE",r3SysSID);

			JCO.ParameterList reasonsParamIn    = function.getImportParameterList();
			JCO.ParameterList reasonsParamTable = function.getTableParameterList();

			JCO.Table reasonsFields  = reasonsParamTable.getTable("FIELDS");

			reasonsParamIn.setValue("TBSGT","QUERY_TABLE");
			reasonsParamIn.setValue("¥","DELIMITER");

			reasonsFields.appendRow();
			reasonsFields.setValue("BSGRU","FIELDNAME");
			reasonsFields.appendRow();
			reasonsFields.setValue("BEZEI","FIELDNAME");

			JCO.Table options  = reasonsParamTable.getTable("OPTIONS");

			options.appendRow();
			options.setValue("SPRAS = 'EN'","TEXT");

			try
			{
				client.execute(function);
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception while executing RFC call RFC_READ_TABLE"+e,"I");
			}	

			JCO.Table reasonsFieldsOut 	= function.getTableParameterList().getTable("DATA");
			int reasonsFieldsOutCount 	= reasonsFieldsOut.getNumRows();

			if(reasonsFieldsOutCount>0)
			{
				do
				{
					String reasonsKeyValStr = (String)reasonsFieldsOut.getValue("WA"); 
					String reaKey 		= reasonsKeyValStr.split("¥")[0];
					String reaVal 		= reasonsKeyValStr.split("¥")[1];
					reasonsHT.put(reaKey.trim(),reaVal);
				}
				while(reasonsFieldsOut.nextRow());
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
	
	
		ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();

		//miscParams.setQuery("SELECT DISTINCT(ERD_RFQ_NO),ERD_LINE_NO,ERD_MATERIAL,ERD_NET_VALUE,ERD_REASONS,ERD_QUOT_COMMENTS,ERD_QUOT_CMMT_TEXT,ERD_REJ_INDICATOR FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO IN(SELECT  ERH_RFQ_NO FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO='"+qcfNo+"' AND ERH_STATUS='Y')");
		miscParams.setQuery("SELECT DISTINCT(ERD_RFQ_NO),ERH_SOLD_TO,ERD_LINE_NO,ERD_MATERIAL,ERD_MATERIAL_DESC,ERD_UOM,ERD_NET_VALUE,ERD_QUOT_COMMENTS,ERD_REASONS,ERD_QUOT_CMMT_TEXT,ERD_REJ_INDICATOR,ERD_COUNTER_QUANTITY FROM EZC_RFQ_DETAILS ,EZC_RFQ_HEADER WHERE ERD_RFQ_NO = ERH_RFQ_NO AND ERH_COLLETIVE_RFQ_NO='"+qcfNo+"' AND ERH_STATUS='Y' order by ERD_QUOT_COMMENTS");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		retRFQDetails=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		retRFQDetails.addColumn("KEY");
		
		if(retRFQDetails!=null)
		{
			for(int i=0;i<retRFQDetails.getRowCount();i++)
			{
				String reasonsKey=retRFQDetails.getFieldValueString(i,"ERD_REASONS");
				String reasonsValue="";
				String rfqValueFromdb = retRFQDetails.getFieldValueString(i,"ERD_NET_VALUE");
				if(rfqValueFromdb==null || "null".equals(rfqValueFromdb.trim()))rfqValueFromdb="0";
				if(reasonsHT!=null)
					reasonsValue	= (String)reasonsHT.get(reasonsKey.trim());

			
				retRFQDetails.setFieldValueAt("KEY",(retRFQDetails.getFieldValueString(i,"ERD_RFQ_NO")+retRFQDetails.getFieldValueString(i,"ERD_LINE_NO")),i);
				
				if(!rfqLineItems.contains(retRFQDetails.getFieldValueString(i,"ERD_LINE_NO")))
				{
					itemMaterialHt.put(retRFQDetails.getFieldValueString(i,"ERD_LINE_NO"),retRFQDetails.getFieldValueString(i,"ERD_MATERIAL"));
					rfqLineItems.add(retRFQDetails.getFieldValueString(i,"ERD_LINE_NO"));
				}else{
					String tempMat = (String)itemMaterialHt.get(retRFQDetails.getFieldValueString(i,"ERD_LINE_NO"));
					if(!tempMat.equals(retRFQDetails.getFieldValueString(i,"ERD_MATERIAL")))mulMaterials = true;
				}
				if(!qcfRfqItemsList.contains(retRFQDetails.getFieldValueString(i,"ERD_RFQ_NO")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_LINE_NO")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_MATERIAL")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_MATERIAL_DESC")))	
					qcfRfqItemsList.add(retRFQDetails.getFieldValueString(i,"ERD_RFQ_NO")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_LINE_NO")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_MATERIAL")+"¥"+retRFQDetails.getFieldValueString(i,"ERD_MATERIAL_DESC"));
					
					
				retRfqRanks.setFieldValue("RFQ_NUM",retRFQDetails.getFieldValueString(i,"ERD_RFQ_NO"));
				retRfqRanks.setFieldValue("RFQ_ITEM",retRFQDetails.getFieldValueString(i,"ERD_LINE_NO"));
				retRfqRanks.setFieldValue("MATERIAL",retRFQDetails.getFieldValueString(i,"ERD_MATERIAL"));
				retRfqRanks.setFieldValue("CO_CODE","1000");
				retRfqRanks.setFieldValue("RFQ_VALUE",rfqValueFromdb);
				retRfqRanks.setFieldValue("RANK",retRFQDetails.getFieldValueString(i,"ERD_QUOT_COMMENTS"));
				retRfqRanks.setFieldValue("VENDOR_CODE",retRFQDetails.getFieldValueString(i,"ERH_SOLD_TO"));
				retRfqRanks.setFieldValue("MATERIAL_DESC",retRFQDetails.getFieldValueString(i,"ERD_MATERIAL_DESC"));
				retRfqRanks.setFieldValue("MAT_QUANTITY",retRFQDetails.getFieldValueString(i,"ERD_COUNTER_QUANTITY"));
				retRfqRanks.addRow();	
				
				retRfqReasons.setFieldValue("REASONS_KEY",reasonsKey);
				retRfqReasons.setFieldValue("REASONS_VALUE",reasonsValue);
				retRfqReasons.addRow();
			}	
						
		}
		
	}
	else
	{
		try
		{
			if(qcfNo!=null && !"null".equals(qcfNo) && !"".equals(qcfNo))
			{
				client = EzSAPHandler.getSAPConnection(r3SysSID);
				function = EzSAPHandler.getFunction("Z_EZ_GET_VENDOR_RANKS",r3SysSID);

				JCO.ParameterList paramIn = function.getImportParameterList();

				paramIn.setValue(qcfNo,"COLLECTIVE_NO");

				client.execute(function);

				JCO.Table fieldsOut = function.getTableParameterList().getTable("RFQITEMS");
				JCO.Table fieldsReasons = function.getTableParameterList().getTable("REASONS");

				int fieldsOutCount = fieldsOut.getNumRows();
				int fieldsReasonsCount = fieldsReasons.getNumRows();

				if(fieldsOutCount>0)
				{
					do
					{
						String rfqNum 	= (String)fieldsOut.getValue("RFQ");
						String rfqItem	= (String)fieldsOut.getValue("RFQ_ITEM");
						String material = (String)fieldsOut.getValue("MATERIAL");
						String compCode = (String)fieldsOut.getValue("CO_CODE");
						String rfqValue = (String)fieldsOut.getValue("EFF_VALUE");
						String rank 	= (String)fieldsOut.getValue("EST_PRICE");
						String vendCode	= (String)fieldsOut.getValue("PRIOR_VEND");
						String matDesc	= (String)fieldsOut.getValue("SHORT_TEXT");
						String quantity	= (String)fieldsOut.getValue("TARGET_QTY");
	
						
						String tempRFQValue = "00000000000000000000"+rfqValue;
						
						tempRFQValue = tempRFQValue.substring(rfqValue.length(),tempRFQValue.length());
						if(!rfqLineItems.contains(rfqItem))
						{
							itemMaterialHt.put(rfqItem,material);
							rfqLineItems.add(rfqItem);
						}else{
							String tempMat = (String)itemMaterialHt.get(rfqItem);
							if(!tempMat.equals(material))mulMaterials = true;
						}
						
						if(!rfqMatList.contains(material))
						rfqMatList.add(material);
					
						if(!qcfRfqItemsList.contains(rfqNum+"¥"+rfqItem+"¥"+material+"¥"+matDesc))	
							qcfRfqItemsList.add(rfqNum+"¥"+rfqItem+"¥"+material+"¥"+matDesc);
						
						//if(!qcfRfqItemsList.contains(rfqItem+"¥"+material+"¥"+matDesc))	
						//	qcfRfqItemsList.add(rfqItem+"¥"+material+"¥"+matDesc);


						retRfqRanks.setFieldValue("RFQ_NUM",rfqNum);
						retRfqRanks.setFieldValue("RFQ_ITEM",rfqItem);
						retRfqRanks.setFieldValue("MATERIAL",material);
						retRfqRanks.setFieldValue("CO_CODE",compCode);
						retRfqRanks.setFieldValue("RFQ_VALUE",rfqValue);
						retRfqRanks.setFieldValue("RANK",rank);
						retRfqRanks.setFieldValue("VENDOR_CODE",vendCode);
						retRfqRanks.setFieldValue("MATERIAL_DESC",matDesc);
						retRfqRanks.setFieldValue("MAT_QUANTITY",quantity);
						retRfqRanks.setFieldValue("EXT1",tempRFQValue);
						retRfqRanks.addRow();
					}
					while(fieldsOut.nextRow());
				}
				if(fieldsReasonsCount>0)
				{
					do
					{
						String reasonKey 	= (String)fieldsReasons.getValue("BSGRU");
						String reasonValue	= (String)fieldsReasons.getValue("BEZEI");

						retRfqReasons.setFieldValue("REASONS_KEY",reasonKey);
						retRfqReasons.setFieldValue("REASONS_VALUE",reasonValue);
						retRfqReasons.addRow();
					}
					while(fieldsReasons.nextRow());
				}

			}
		}
		catch(Exception e)
		{
			System.out.println("Exception :::"+e);
		}
		finally
		{
			if(client!=null)
			{
				JCO.releaseClient(client);
				client = null;
				function = null;
			}
		}

	
	}
	if(qcfRfqItemsList!=null)
		noOfQcfRFQItems = qcfRfqItemsList.size();
		
	if(rfqLineItems!=null)
		itemSize = rfqLineItems.size();

		ezc.ezcommon.EzLog4j.log(":::::::retRfqRanks::::::::"+retRfqRanks.toEzcString(),"I");

	if(mulMaterials && !"VIEW".equals(flag.trim()))
	{
		
		retRfqRanks.sort(new String[]{"EXT1"},true);
		Vector matVector = null;
		for(int i=0;i<rfqMatList.size();i++)
		{
			int rank = 0;
			String matFormList = (String)rfqMatList.get(i);
			matVector = new Vector();
			for(int r=0;r<retRfqRanks.getRowCount();r++)
			{
				if(matFormList.equals(retRfqRanks.getFieldValueString(r,"MATERIAL")))
				matVector.add(new Integer(r+""));
			}
			ezc.ezcommon.EzLog4j.log("::::matVector:::::"+matVector+":::::::"+(String)rfqMatList.get(i),"I");
			for(int j=0;j<matVector.size();j++)
			{
				int rowIndex 	= ((Integer)matVector.elementAt(j)).intValue();
				rank = j+1;
				retRfqRanks.setFieldValueAt("RANK",new Integer(rank),rowIndex);
			}
		
		}
		/*
		int rank=0;
		String tempSortMat = "";

		for(int i=0;i<retRfqRanks.getRowCount();i++)
		{	
			String sortMat = retRfqRanks.getFieldValueString(i,"MATERIAL");
			
			ezc.ezcommon.EzLog4j.log("::tempSortMat::::"+tempSortMat+"::::sortMat::"+sortMat,"I");
			if(tempSortMat.equals(sortMat))
			{
				rank = rank+1;
			}else {
				rank =1;
				tempSortMat = sortMat;
			}
			retRfqRanks.setFieldValueAt("RANK",new Integer(rank),i);
		}*/
		
		ezc.ezcommon.EzLog4j.log(":::::::retRfqRanks AFTER::::::::"+retRfqRanks.toEzcString(),"I");
	}
%>