<%!
	public void closePO(ezc.session.EzSession Session,String qcfNo) 
	{
		
		ReturnObjFromRetrieve retRFQObj=ezMiscSelect(Session,"SELECT COUNT(ERD_RFQ_NO) AS RFQCNT FROM ezc_rfq_details where (ERD_PO_CR_QTY is null or ERD_PO_QTY-ERD_PO_CR_QTY > 0) and ERD_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO='"+qcfNo+"')");
		Long tempCnt=(Long)retRFQObj.getFieldValue(0,"RFQCNT");
		if(tempCnt == 0)
		{
			ArrayList<String> queries=new ArrayList<String>();
			queries.add("UPDATE EZC_RFQ_HEADER SET ERH_PO_FLAG='X' WHERE ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'");
			ezMiscInsert(Session,queries);
		}
	}
	public ReturnObjFromRetrieve getPRData(String site,ArrayList<String> prList)
	{
		ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve(new String[]{"BANFN","BNFPO","KOSTL","SAKTO","PS_PSP_PNR","NPLNR","AUFNR","ACTIVITY"});
		JCoFunction poFunction = null;
		JCoParameterList sapPurOrd = null;
		for(String tempPrNo:prList)
		{
		try
		{
			JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
			poFunction = EzSAPHandler.getJCoFunction(destination,"BAPI_PR_GETDETAIL");		
			sapPurOrd 	 = poFunction.getImportParameterList();
			sapPurOrd.setValue("NUMBER",tempPrNo);
			sapPurOrd.setValue("ACCOUNT_ASSIGNMENT","X");

			try{
				poFunction.execute(destination);
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing BAPI_PR_GETDETAIL>>>"+e,"I");		
			}

			try {
				JCoTable dataTable = poFunction.getTableParameterList().getTable("PRACCOUNT");
				if(dataTable != null)
				{
					do
					{						
						retObj.setFieldValue("BANFN",tempPrNo);
						retObj.setFieldValue("BNFPO",dataTable.getValue("PREQ_ITEM"));
						retObj.setFieldValue("KOSTL",dataTable.getValue("COSTCENTER"));
						retObj.setFieldValue("SAKTO",dataTable.getValue("GL_ACCOUNT"));
						retObj.setFieldValue("PS_PSP_PNR",dataTable.getValue("WBS_ELEMENT"));
						retObj.setFieldValue("NPLNR",dataTable.getValue("NETWORK"));
						retObj.setFieldValue("AUFNR",dataTable.getValue("ORDERID"));
						retObj.setFieldValue("ACTIVITY",dataTable.getValue("ACTIVITY"));
						retObj.addRow();

					}
					while(dataTable.nextRow());
				}

			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
			}

		}catch(Exception e){
						ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
		}
		}
		return retObj;	
	}
	
	public Hashtable<String,ReturnObjFromRetrieve> getPRAllDetails(String site,ArrayList<String> prList)
	{
			Hashtable<String,ReturnObjFromRetrieve> htPRDetails = new Hashtable<String,ReturnObjFromRetrieve>();
			ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve(new String[]{"BANFN","BNFPO","KOSTL","SAKTO","PS_PSP_PNR","NPLNR","AUFNR","ACTIVITY"});
			ReturnObjFromRetrieve retObjHeader= new ReturnObjFromRetrieve(new String[]{"BANFN","DOCTYPE"});
			ReturnObjFromRetrieve retObjItem= new ReturnObjFromRetrieve(new String[]{"BANFN","BNFPO","SHORT_TEXT","PCKG_NO","MATL_GROUP","ITEM_CAT","ACCTASSCAT"});
			ReturnObjFromRetrieve retObjServLines= new ReturnObjFromRetrieve(new String[]{"BANFN","BNFPO","UOM","SHORT_TEXT","SERVICE","SRV_LINE"});
			JCoFunction poFunction = null;
			JCoParameterList sapPurOrd = null;
			for(String tempPrNo:prList)
			{
			try
			{
				JCoDestination destination = EzSAPHandler.getDestination(site+"~999");
				poFunction = EzSAPHandler.getJCoFunction(destination,"BAPI_PR_GETDETAIL");		
				sapPurOrd 	 = poFunction.getImportParameterList();
				sapPurOrd.setValue("NUMBER",tempPrNo);
				sapPurOrd.setValue("ACCOUNT_ASSIGNMENT","X");
				sapPurOrd.setValue("SERVICES","X");
				
	
				try{
					poFunction.execute(destination);
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing BAPI_PR_GETDETAIL>>>"+e,"I");		
				}
	
				try {
					JCoTable dataTable = poFunction.getTableParameterList().getTable("PRACCOUNT");
					JCoTable prItemTable = poFunction.getTableParameterList().getTable("PRITEM");
					JCoTable prServLinesTable = poFunction.getTableParameterList().getTable("SERVICELINES");
					JCoStructure prHeader = poFunction.getExportParameterList().getStructure("PRHEADER");
					if(dataTable != null && dataTable.getNumRows() > 0)
					{
						do
						{						
							retObj.setFieldValue("BANFN",tempPrNo);
							retObj.setFieldValue("BNFPO",dataTable.getValue("PREQ_ITEM"));
							retObj.setFieldValue("KOSTL",dataTable.getValue("COSTCENTER"));
							retObj.setFieldValue("SAKTO",dataTable.getValue("GL_ACCOUNT"));
							retObj.setFieldValue("PS_PSP_PNR",dataTable.getValue("WBS_ELEMENT"));
							retObj.setFieldValue("NPLNR",dataTable.getValue("NETWORK"));
							retObj.setFieldValue("AUFNR",dataTable.getValue("ORDERID"));
							retObj.setFieldValue("ACTIVITY",dataTable.getValue("ACTIVITY"));
							retObj.addRow();
	
						}
						while(dataTable.nextRow());
					}
					if(prItemTable != null && prItemTable.getNumRows() > 0)
					{
						do
						{						
							retObjItem.setFieldValue("BANFN",tempPrNo);
							retObjItem.setFieldValue("BNFPO",prItemTable.getValue("PREQ_ITEM"));
							retObjItem.setFieldValue("SHORT_TEXT",prItemTable.getValue("SHORT_TEXT"));
							retObjItem.setFieldValue("PCKG_NO",prItemTable.getValue("PCKG_NO"));
							retObjItem.setFieldValue("MATL_GROUP",prItemTable.getValue("MATL_GROUP"));
							retObjItem.setFieldValue("ITEM_CAT",prItemTable.getValue("ITEM_CAT"));
							retObjItem.setFieldValue("ACCTASSCAT",prItemTable.getValue("ACCTASSCAT"));
							retObjItem.addRow();

						}
						while(prItemTable.nextRow());
					}
					if(prServLinesTable != null && prServLinesTable.getNumRows() > 0)
					{
						do
						{						
							retObjServLines.setFieldValue("BANFN",tempPrNo);
							retObjServLines.setFieldValue("BNFPO",prServLinesTable.getValue("DOC_ITEM"));
							retObjServLines.setFieldValue("UOM",prServLinesTable.getValue("UOM"));
							retObjServLines.setFieldValue("SHORT_TEXT",prServLinesTable.getValue("SHORT_TEXT"));
							retObjServLines.setFieldValue("SRV_LINE",prServLinesTable.getValue("SRV_LINE"));
							retObjServLines.setFieldValue("SERVICE",prServLinesTable.getValue("SERVICE"));
							retObjServLines.addRow();

						}
						while(prServLinesTable.nextRow());
					}
					retObjHeader.setFieldValue("BANFN",tempPrNo);
					retObjHeader.setFieldValue("DOCTYPE",prHeader.getValue("PR_TYPE"));
					retObjHeader.addRow();
	
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
				}
	
			}catch(Exception e){
							ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
			}
			}
			htPRDetails.put("ACCDET",retObj);
			htPRDetails.put("ITEMDET",retObjItem);
			htPRDetails.put("HEADDET",retObjHeader);
			htPRDetails.put("SERLINES",retObjServLines);
			return htPRDetails;
	}
%>
<%
	String [] rfqNo = request.getParameterValues("selVen");
	//Hashtable<String,String> htPRPOMap = getPOPRMap(Session);
	Hashtable<String,String> htPRPOMap = new Hashtable<String,String>();
	htPRPOMap.put("NB","ZH01");
	htPRPOMap.put("ZH01","ZH01");
	htPRPOMap.put("ZH02","ZH02");
	htPRPOMap.put("ZH03","ZH03"); 
	htPRPOMap.put("ZH04","ZH04");
	htPRPOMap.put("ZH05","ZH05");
	htPRPOMap.put("ZH07","ZH01");
	htPRPOMap.put("ZH08","ZH02");
	
	Hashtable<String,String> htTaxMap = new Hashtable<String,String>();
	htTaxMap.put("0##O","I0");
	htTaxMap.put("5##O","I2");
	htTaxMap.put("12##O","I4");
	htTaxMap.put("18##O","I6");
	htTaxMap.put("28##O","I8");
	htTaxMap.put("3##O","IB");
	htTaxMap.put("0##W","K0");
	htTaxMap.put("5##W","K2");
	htTaxMap.put("12##W","K4");
	htTaxMap.put("18##W","K6");
	htTaxMap.put("28##W","K8");
	htTaxMap.put("3##W","K9");
	htTaxMap.put("5##I","J2");
	htTaxMap.put("12##I","J4");
	htTaxMap.put("18##I","J6");
	htTaxMap.put("28##I","J8");
	htTaxMap.put("5##DI","IY");
	htTaxMap.put("5##DC","KY");
	
	
	
	Hashtable<String,String> htCondMap = new Hashtable<String,String>();

	/*htCondMap.put("DOM##PKFW##P##ZPF1","ZPF1##N##U");
	htCondMap.put("DOM##PKFW##V##ZPF2","ZPF2##N##U");
	htCondMap.put("DOM##PKFW##Q##ZPF3","ZPF3##N##U");*/
	htCondMap.put("DOM##BFRT##P##FRA2","FRA2##Y##U");
	htCondMap.put("DOM##BFRT##V##FRB2","FRB2##Y##U");
	htCondMap.put("DOM##BFRT##Q##FRC2","FRC2##Y##U");
	htCondMap.put("DOM##BFRT##P##FRA1","FRA1##Y##U");
	htCondMap.put("DOM##BFRT##V##FRB1","FRB1##Y##U");
	htCondMap.put("DOM##BFRT##Q##FRC1","FRC1##Y##U");
	htCondMap.put("DOM##BFRT##V##Z001","Z001##Y##U");
	htCondMap.put("DOM##BFRT##V##Z002","Z002##Y##U");
	htCondMap.put("DOM##BFRT##V##Z003","Z003##Y##U");
	htCondMap.put("DOM##BFRT##V##Z005","Z005##Y##U");
	htCondMap.put("DOM##BFRT##V##Z006","Z006##Y##U");
	htCondMap.put("DOM##BFRT##V##Z008","Z008##Y##U");
	htCondMap.put("DOM##BFRT##V##Z009","Z009##Y##U");
	htCondMap.put("DOM##BFRT##V##Z010","Z010##Y##U");
	htCondMap.put("DOM##BFRT##V##Z011","Z011##Y##U");
	htCondMap.put("DOM##BFRT##V##Z012","Z012##Y##U");
	htCondMap.put("DOM##BFRT##V##Z029","Z029##Y##U");
	htCondMap.put("DOM##BFRT##V##ZFRD","ZFRD##Y##U");
	htCondMap.put("DOM##BFRT##Q##ZFRG","ZFRG##Y##U");
	htCondMap.put("DOM##FRT##P##FRA1","FRA1##Y##I");
	htCondMap.put("DOM##FRT##V##FRB1","FRB1##Y##U");
	htCondMap.put("DOM##FRT##Q##FRC1","FRC1##Y##I");
	htCondMap.put("DOM##FRT##V##Z001","Z001##Y##U");
	htCondMap.put("DOM##FRT##V##Z002","Z002##Y##U");
	htCondMap.put("DOM##FRT##V##Z003","Z003##Y##U");
	htCondMap.put("DOM##FRT##V##Z005","Z005##Y##U");
	htCondMap.put("DOM##FRT##V##Z006","Z006##Y##U");
	htCondMap.put("DOM##FRT##V##Z008","Z008##Y##U");
	htCondMap.put("DOM##FRT##V##Z009","Z009##Y##U");
	htCondMap.put("DOM##FRT##V##Z010","Z010##Y##U");
	htCondMap.put("DOM##FRT##V##Z011","Z011##Y##U");
	htCondMap.put("DOM##FRT##V##Z012","Z012##Y##U");
	htCondMap.put("DOM##FRT##V##Z029","Z029##Y##U");
	htCondMap.put("DOM##FRT##V##ZFRD","ZFRD##Y##U");
	htCondMap.put("DOM##FRT##Q##ZFRG","ZFRG##Y##U");
	htCondMap.put("DOM##DISC##P##RA00","RA00##N##I");
	htCondMap.put("DOM##DISC##P##RA01","RA01##N##I");
	htCondMap.put("DOM##DISC##V##RB00","RB00##N##I");
	htCondMap.put("DOM##DISC##Q##RC00","RC00##N##I");
	htCondMap.put("DOM##INS##P","ZINP##N##U");
	htCondMap.put("DOM##INS##Q","ZINQ##N##U");
	/*htCondMap.put("IMP##PKFW##P","ZPF1##N##U");
	htCondMap.put("IMP##PKFW##V","ZPF2##N##U");
	htCondMap.put("IMP##PKFW##Q","ZPF3##N##U");*/
	htCondMap.put("IMP##FRT##P","FRA1##Y##U");
	htCondMap.put("IMP##FRT##V","FRB1##Y##U");
	htCondMap.put("IMP##FRT##Q","FRC1##Y##U");
	htCondMap.put("IMP##BFRT##P","FRA2##Y##U");
	htCondMap.put("IMP##BFRT##V","FRB2##Y##U");
	htCondMap.put("IMP##BFRT##Q","FRC2##Y##U");
	htCondMap.put("IMP##INS##P","ZINP##N##U");
	htCondMap.put("IMP##INS##Q","ZINQ##N##U");
	
	htCondMap.put("IMP##FOB##P","ZFRA##Y##U");
	htCondMap.put("IMP##FOB##V","ZFRB##Y##U");
	htCondMap.put("IMP##FOB##Q","ZFRC##Y##U");
	htCondMap.put("IMP##BCD##P","JCDB##N##U");
	htCondMap.put("IMP##SWC##P","JEDB##N##U");
	htCondMap.put("IMP##CLR##P","ZCL1##N##U");
	htCondMap.put("IMP##CLR##V","ZCl4##N##U");
	htCondMap.put("IMP##OTH##V","ZPAL##N##U");
	
	Hashtable<String,String> htPurGrp = new Hashtable<String,String>();
	htPurGrp.put("1001","101");
	htPurGrp.put("1002","102");
	htPurGrp.put("1003","103");
	htPurGrp.put("1004","104");
%>