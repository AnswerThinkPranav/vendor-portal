<%@page import="ezc.ezparam.*,ezc.ezpreprocurement.params.*,ezc.ezworkflow.params.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.forums.params.*,ezc.messaging.params.*,ezc.trans.messaging.params.*,ezc.client.*,ezc.ezparam.*,java.util.*,java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%@ page import="ezc.valuemap.params.*,java.io.BufferedReader, java.io.InputStreamReader,java.io.OutputStreamWriter,java.net.HttpURLConnection,java.net.URLEncoder,java.net.*"%>
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %> 
<jsp:useBean id="vendorTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 

 <%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>
 <%
 	String tempUserIdsArr[] = request.getParameterValues("tempUserId");
 	String inputRfqNumber 	= request.getParameter("inputRfqNumber");

	boolean statusSuccess = false;
	String dispMessage="Problem occured in sending RFQs to vendors",dispMsgType="E",divWidth="90%"; 	
	
 	if(inputRfqNumber!=null && !"null".equals(inputRfqNumber) && !"".equals(inputRfqNumber) && tempUserIdsArr!=null)
 	{
 		inputRfqNumber = "0000000000"+inputRfqNumber;
 		inputRfqNumber = inputRfqNumber.substring(inputRfqNumber.length()-10,inputRfqNumber.length());
 		
 	
		String taxCodes[] = {"DISC","CGST","SGST","IGST","UGST","PKFW","FRT","FRT_GST"};

		ReturnObjFromRetrieve retSysKeys = null;
		String allSysKeys = "";

		Hashtable orgSysKeysHT = new Hashtable();

		EzcSysConfigParams sparams = new EzcSysConfigParams();
		EzcSysConfigNKParams snkparams = new EzcSysConfigNKParams();
		snkparams.setLanguage("EN");
		sparams.setObject(snkparams);
		Session.prepareParams(sparams);

		try
		{
			retSysKeys = (ReturnObjFromRetrieve) sysManager.getPurchaseAreas(sparams);		
		}catch(Exception e){}

		if(retSysKeys!=null)
		{
			for(int s=0;s<retSysKeys.getRowCount();s++)
			{
				if(s==0)
					allSysKeys = retSysKeys.getFieldValueString(s,"ESKD_SYS_KEY");
				else
					allSysKeys += "','"+retSysKeys.getFieldValueString(s,"ESKD_SYS_KEY");
			}
		}	


		if(!"".equals(allSysKeys))
		{
			ReturnObjFromRetrieve retdef = null;

			EzcSysConfigParams sparams1 = new EzcSysConfigParams();
			EzcSysConfigNKParams snkparams1 = new EzcSysConfigNKParams();
			snkparams1.setLanguage("EN");
			snkparams1.setSystemKey(allSysKeys);
			snkparams1.setSiteNumber(200);
			sparams1.setObject(snkparams1);
			Session.prepareParams(sparams1);
			try
			{
				retdef = (ReturnObjFromRetrieve)sysManager.getCatAreaDefaults(sparams1);
			}catch(Exception e){}	

			if(retdef!=null)
			{
				for(int p=0;p<retdef.getRowCount();p++)
				{
					if("PURORG".equals(retdef.getFieldValueString(p,"EUDD_KEY")))
						orgSysKeysHT.put(retdef.getFieldValueString(p,"ECAD_VALUE"),retdef.getFieldValueString(p,"ECAD_SYS_KEY"));	

				}	
			}
		}	

		ezc.ezcommon.EzLog4j.log("GET_RFQS_FROM_SAP_STARTS>>>>>>>>","I");	

		ReturnObjFromRetrieve rfqRelHdrXML = new ReturnObjFromRetrieve(new String[]{"ORDER","VENDOR_NUMBER","RECORDSTATUS","RECORDSTATUS","ORDERTYPE","PURCH_ORG","PURGRP","PURGRP_NAME","QUOT_DEAD","COLL_NO","ORDERDATE","COMPCODE","PLANT"});
		ReturnObjFromRetrieve dtlXML = new ReturnObjFromRetrieve(new String[]{"POSITION","ITEM","CURRENCY","ITEMDESCRIPTION","UOMPURCHASE","ORDEREDQUANTITY","PLANT","CONFIRMDELIVERYDATE"});

		JCoFunction poFunction = null;
		JCoParameterList sapPurOrd = null;
		
		String ccode=(String)session.getValue("CCode");
		try
		{
			JCoDestination destination = EzSAPHandler.getDestination("200~999");
			poFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_BAPI_PO_GETITEMS");

			sapPurOrd 	 = poFunction.getImportParameterList();

			sapPurOrd.setValue("PURCHASEORDER",inputRfqNumber);
			//sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","A");
			sapPurOrd.setValue("ITEMS_OPEN_FOR_RECEIPT","");
			//sapPurOrd.setValue("CO_CODE","CFL");	
			if(ccode!=null && !"null".equals(ccode))
			sapPurOrd.setValue("CO_CODE",ccode);
			else
			sapPurOrd.setValue("CO_CODE","CFL");
			sapPurOrd.setValue("WITH_PO_HEADERS","X");
			sapPurOrd.setValue("DOC_CATEGORY","A");

			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PURCHASEORDER>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("PURCHASEORDER"),"D"); 
			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>ITEMS_OPEN_FOR_RECEIPT>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("ITEMS_OPEN_FOR_RECEIPT"),"D");
			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>CO_CODE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("CO_CODE"),"D");
			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>DOC_CATEGORY>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("DOC_CATEGORY"),"D");
			ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>WITH_PO_HEADERS>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("WITH_PO_HEADERS"),"D");


			try{
				poFunction.execute(destination);
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_BAPI_PO_GETITEMS>>>"+e,"I");		
			}

			try {
				JCoTable sapPoList = poFunction.getTableParameterList().getTable("PO_HEADERS");

				int poCount = sapPoList.getNumRows();
				if (poCount>0)
				{
					do{
						//Set All required field Values
						rfqRelHdrXML.setFieldValue("ORDER", sapPoList.getValue("PO_NUMBER"));
						rfqRelHdrXML.setFieldValue("VENDOR_NUMBER",sapPoList.getValue("VENDOR"));
						rfqRelHdrXML.setFieldValue("RECORDSTATUS",sapPoList.getValue("TELEPHONE"));
						rfqRelHdrXML.setFieldValue("ORDERTYPE", sapPoList.getValue("DOC_TYPE"));
						rfqRelHdrXML.setFieldValue("PURGRP",sapPoList.getValue("PUR_GROUP"));
						rfqRelHdrXML.setFieldValue("COMPCODE", sapPoList.getValue("CO_CODE"));
						rfqRelHdrXML.setFieldValue("PURCH_ORG", sapPoList.getValue("PURCH_ORG"));

						try{
							rfqRelHdrXML.setFieldValue("PLANT",sapPoList.getValue("PLANT"));
						}catch(Exception e){}	

						rfqRelHdrXML.setFieldValue("PURGRP_NAME",sapPoList.getValue("PUR_GROUP_NAME"));

						rfqRelHdrXML.setFieldValue("ORDERDATE", sapPoList.getValue("DOC_DATE"));
						rfqRelHdrXML.setFieldValue("QUOT_DEAD",sapPoList.getValue("QUOT_DEAD"));
						rfqRelHdrXML.setFieldValue("COLL_NO",sapPoList.getValue("COLL_NO"));


						rfqRelHdrXML.addRow();
					}
					while(sapPoList.nextRow());
				}	

			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDERS TABLE>>>"+e,"I");
			}
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDERS>>>"+e,"I");
		}


		int rfqRelHdrXMLCount=0;

		if(rfqRelHdrXML!=null)
		    rfqRelHdrXMLCount=rfqRelHdrXML.getRowCount();

		ezc.ezcommon.EzLog4j.log("POS_FROM_SAP>>>>>>>>"+rfqRelHdrXMLCount,"I");  
		ezc.ezcommon.EzLog4j.log("GET_POS_FROM_SAP_END>>>>>>>>"+rfqRelHdrXML.toEzcString(),"I");	


		if(rfqRelHdrXMLCount>0)
		{

			poFunction = null;
			sapPurOrd = null;

			try
			{
				JCoDestination destination1 = EzSAPHandler.getDestination("200~999");
				poFunction = EzSAPHandler.getJCoFunction(destination1,"Z_EZ_GET_PURCHASE_ORDER_DTL");

				sapPurOrd 	 = poFunction.getImportParameterList();

				sapPurOrd.setValue("VENDOR",rfqRelHdrXML.getFieldValueString("VENDOR_NUMBER"));
				sapPurOrd.setValue("PURCH_ORG",rfqRelHdrXML.getFieldValueString("PURCH_ORG"));
				sapPurOrd.setValue("PUR_GROUP",rfqRelHdrXML.getFieldValueString("COMPCODE"));
				sapPurOrd.setValue("CO_CODE",rfqRelHdrXML.getFieldValueString("ORDER"));
				sapPurOrd.setValue("ITEMS","X");
				sapPurOrd.setValue("PURCHASEORDER",rfqRelHdrXML.getFieldValueString("ORDER"));

				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PURCHASEORDER>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("VENDOR"),"D"); 
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PURCH_ORG>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("PURCH_ORG"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PUR_GROUP>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("PUR_GROUP"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>CO_CODE>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("CO_CODE"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>ITEMS>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("ITEMS"),"D");
				ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>PURCHASEORDER>>>>>>>>>>>>>>>:"+sapPurOrd.getValue("PURCHASEORDER"),"D");


				try{
					poFunction.execute(destination1);
				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in Executing Z_EZ_GET_PURCHASE_ORDER_DTL>>>"+e,"I");		
				}

				try {
					JCoTable sapPoItems = poFunction.getTableParameterList().getTable("PO_ITEMS");

					int poItemsCount = sapPoItems.getNumRows();
					if (poItemsCount>0)
					{
						do{
							//Set All required field Values
							dtlXML.setFieldValue("POSITION", sapPoItems.getValue("PO_ITEM"));
							dtlXML.setFieldValue("ITEM",sapPoItems.getValue("MATERIAL"));
							dtlXML.setFieldValue("ITEMDESCRIPTION",sapPoItems.getValue("SHORT_TEXT"));
							dtlXML.setFieldValue("UOMPURCHASE", sapPoItems.getValue("UNIT"));
							//dtlXML.setFieldValue("CURRENCY", sapPoItems.getValue("CURRENCY"));
							dtlXML.setFieldValue("ORDEREDQUANTITY",sapPoItems.getBigDecimal("TARGET_QTY"));
							dtlXML.setFieldValue("PLANT", sapPoItems.getValue("PLANT"));
							dtlXML.setFieldValue("CONFIRMDELIVERYDATE", sapPoItems.getValue("LAST_TRANS"));

							dtlXML.addRow();
						}
						while(sapPoItems.nextRow());
					}	

				}
				catch(Exception e)
				{
					ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDER_DTL TABLE>>>"+e,"I");
				}
			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exception in Calling Z_EZ_GET_PURCHASE_ORDER_DTL>>>"+e,"I");
			}


			int dtlXMLCount=0;

			if(dtlXML!=null)
			    dtlXMLCount=dtlXML.getRowCount();

			ezc.ezcommon.EzLog4j.log("RFQ_DETAILS_FROM_SAP>>>>>>>>"+dtlXMLCount,"I");  
			ezc.ezcommon.EzLog4j.log("RFQ_DETAILS_FROM_SAP>>>>>>>>"+dtlXML.toEzcString(),"I");	


			String tempUserIdsStr = "";	
			String usrType = "";	
			int tempUserIdsArrCnt = 0;

			if(tempUserIdsArr!=null)
				tempUserIdsArrCnt = tempUserIdsArr.length;

			if(tempUserIdsArrCnt>0 && dtlXMLCount>0)  
			{
				for(int t=0;t<tempUserIdsArrCnt;t++)
				{out.println(tempUserIdsArr[t]+":::::::::usrType::::::::");
				System.out.println(tempUserIdsArr[t]+"::::::usrType:::::::::::");
					if(t==0)
					{
						tempUserIdsStr = tempUserIdsArr[t].split("_")[0];
						usrType=tempUserIdsArr[t].split("_")[1];
						usrType.equals("NONSAP");
						usrType="NON_SAP";
					}
					else
					{
						tempUserIdsStr += "','"+tempUserIdsArr[t].split("_")[0];
						usrType += "','"+tempUserIdsArr[t].split("_")[1];
						usrType.equals("NONSAP");
						usrType="NON_SAP";
					}	
					out.println(tempUserIdsStr+"::::::::usrType:::::::::");
				System.out.println(usrType+"::::::::usrType:::::::::");
				}

				ezc.ezparam.ReturnObjFromRetrieve vendorEMailContactRetObj=null;
				try
				{
					ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
					ezc.vendortransactions.params.EzVendorParams  vendorEmailParams= new ezc.vendortransactions.params.EzVendorParams();
					ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
					keyParams.setKey("GET_USER_EMAIL");
					addMainParams.setLocalStore("Y");

					vendorEmailParams.setUserId(tempUserIdsStr);


					addMainParams.setObject(keyParams);	
					addMainParams.setObject(vendorEmailParams);
					Session.prepareParams(addMainParams);

					vendorEMailContactRetObj=(ReturnObjFromRetrieve)vendorTransactionsManager.ezGetVendorTransactions(addMainParams);
				}
				catch(Exception e)
				{
					out.println(":::Exception while getting company codes:::"+e);
				}

				Hashtable userEmailHT = new Hashtable();
				Hashtable userContactNoHT = new Hashtable();

				if(vendorEMailContactRetObj!=null && vendorEMailContactRetObj.getRowCount()>0)
				{
					for(int ec=0;ec<vendorEMailContactRetObj.getRowCount();ec++)
					{				
						userEmailHT.put(vendorEMailContactRetObj.getFieldValueString(ec,"EU_ID"),vendorEMailContactRetObj.getFieldValueString(ec,"EU_EMAIL"));
						userContactNoHT.put(vendorEMailContactRetObj.getFieldValueString(ec,"EU_ID"),vendorEMailContactRetObj.getFieldValueString(ec,"EU_CONTACT_NO"));
					}	
				}

				ezc.ezcommon.EzLog4j.log("userEmailHT>>>>>>>>"+userEmailHT,"I");
				ezc.ezcommon.EzLog4j.log("userContactNoHT>>>>>>>>"+userContactNoHT,"I");

				boolean showStatusMsg = false;

				for(int vp=0;vp<tempUserIdsArrCnt;vp++)
				{
					String mobileNo = "",vendEmail="";
					boolean sendMail = true;

					String defErpVendor = tempUserIdsArr[vp].split("_")[0];

					try{
						vendEmail = (String)userEmailHT.get(Long.parseLong(defErpVendor)+"");
						mobileNo  = (String)userContactNoHT.get(Long.parseLong(defErpVendor)+"");
					}catch(Exception e){
						vendEmail = (String)userEmailHT.get(defErpVendor);
						mobileNo  = (String)userContactNoHT.get(defErpVendor);
					} 				

					defErpVendor = "0000000000"+defErpVendor;
					defErpVendor = defErpVendor.substring(defErpVendor.length()-10,defErpVendor.length());

					String portalRFQNumber = "";
					ReturnObjFromRetrieve	valMapRetObj = null;
					ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
					ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
					EziValueMappingParams valueParams =  new EziValueMappingParams();

					valueParams.setMapType("PORTAL_RFQ_NR_RANGE");

					mainParams.setObject(valueParams);	
					Session.prepareParams(mainParams);

					try{
						valMapRetObj = (ReturnObjFromRetrieve)valMapMgr.ezGetValueMapping(mainParams);
					}catch(Exception e){}	

					if(valMapRetObj!=null && valMapRetObj.getRowCount()>0)
					{
						portalRFQNumber = valMapRetObj.getFieldValueString(0,"VALUE1");

						String nextNr = "";

						try{

							nextNr = (Long.parseLong(portalRFQNumber)+1)+"";

							mainParams = new ezc.ezparam.EzcParams(true);
							valueParams =  new EziValueMappingParams();

							valueParams.setValue1(nextNr);
							valueParams.setMapType(" MAP_TYPE = 'PORTAL_RFQ_NR_RANGE'");

							mainParams.setObject(valueParams);	
							Session.prepareParams(mainParams);

							valMapMgr.ezUpdateValueMapping(mainParams);	

						}catch(Exception e){}	
					}

					portalRFQNumber = "0000000000"+portalRFQNumber;
					portalRFQNumber = portalRFQNumber.substring(portalRFQNumber.length()-10,portalRFQNumber.length());


					EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
					EzRFQQuoteHistoryTable 	rfqQuoteHistoryTable 	= new EzRFQQuoteHistoryTable();
					EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
					EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
					EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	

					EzRFQConditionsTable 	condTable 		= new EzRFQConditionsTable();
					EzRFQConditionsTableRow condTableRow 		= null;

					ezc.ezvendorapp.params.EzVendorTimeStampStructure ackTimeStamp=new ezc.ezvendorapp.params.EzVendorTimeStampStructure();

					java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					java.util.Date dt = new java.util.Date();
					String createdOn= sdf.format(dt);


					String tempSapVend	=(rfqRelHdrXML.getFieldValueString(0,"VENDOR_NUMBER")).trim();

					String myRFQDate = "";

					String rfqNo  		= portalRFQNumber;//rfqRelHdrXML.getFieldValueString(0,"ORDER");
					String colRfqNo		= rfqRelHdrXML.getFieldValueString(0,"COLL_NO");
					String purOrg  		= rfqRelHdrXML.getFieldValueString(0,"PURCH_ORG");
					String purGrp  		= rfqRelHdrXML.getFieldValueString(0,"PURGRP");
					String compCode 	= rfqRelHdrXML.getFieldValueString(0,"COMPCODE");

					String quoteEndDate = "";
					try{
						sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						dt = (java.util.Date)rfqRelHdrXML.getFieldValue(0,"QUOT_DEAD");
						quoteEndDate= sdf.format(dt);
					}catch(Exception e){
						 quoteEndDate = "1900-01-01 00:00:00";
					}


					sdf=new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					dt = (java.util.Date)rfqRelHdrXML.getFieldValue(0,"ORDERDATE");
					myRFQDate= sdf.format(dt);

					ezirfqheadertablerow = new EziRFQHeaderTableRow();
					ezirfqheadertablerow.setRFQNo(rfqNo);
					ezirfqheadertablerow.setCollectiveRFQNo(colRfqNo);
					ezirfqheadertablerow.setSysKey((String)orgSysKeysHT.get(purOrg));
					ezirfqheadertablerow.setSoldTo(defErpVendor);
					ezirfqheadertablerow.setPRNo("");
					ezirfqheadertablerow.setPRItmNo("");
					ezirfqheadertablerow.setStatus("N");
					ezirfqheadertablerow.setRFQDate(myRFQDate);
					ezirfqheadertablerow.setValidUpto(quoteEndDate);
					ezirfqheadertablerow.setCreatedBy(Session.getUserId());
					ezirfqheadertablerow.setModifiedBy(Session.getUserId());
					ezirfqheadertablerow.setCompCode(compCode);
					ezirfqheadertablerow.setPurchaseOrg(purOrg);		
					ezirfqheadertablerow.setPurchaseGrp(purGrp);
					ezirfqheadertablerow.setVendorType(usrType);
					ezirfqheadertablerow.setAgentCode("");
					ezirfqheadertablerow.setReleaseIndicator("");
					ezirfqheadertablerow.setRankStatus("");
					ezirfqheadertablerow.setExt1(inputRfqNumber);  //SAP RFQ number
					ezirfqheadertablerow.setExt2(tempSapVend);
					ezirfqheadertablerow.setExt3("");
					ezirfqheadertablerow.setValType("");
					ezirfqheadertablerow.setPRDetails("");
					ezirfqheadertablerow.setPriceValDate("1900-01-01 00:00:00");
					ezirfqheadertablerow.setQuoteRef("");
					ezirfqheadertablerow.setDelvPeriod("");
					ezirfqheadertablerow.setGuaranteePeriod("");
					ezirfqheadertablerow.setRequestRequote("");
					ezirfqheadertablerow.setPlant("");

					ezirfqheadertable.appendRow(ezirfqheadertablerow);	


					ezc.ezcommon.EzLog4j.log("TO_BE_INSERTED_RFQS_COUNT>>>>>>>>"+ezirfqheadertable.getRowCount(),"I");  

					for(int h=0;h<dtlXMLCount;h++)
					{

						ezirfqdetailstablerow = new EziRFQDetailsTableRow();


						java.util.Date dlvDtObj = (java.util.Date)dtlXML.getFieldValue(h,"CONFIRMDELIVERYDATE");
						String itemDlvDate = FormatDate.getStringFromDate(dlvDtObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));


						/*ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
						String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));

						try{
							sdf=new java.text.SimpleDateFormat("yyyy-MM-dd");
							dt = (java.util.Date)dtlXML.getFieldValue(h,"CONFIRMDELIVERYDATE");
							itemDlvDate= sdf.format(dt);
						}catch(Exception e){
							 itemDlvDate = "1900-01-01 00:00:00";
						}*/

						String rfqItemNo = dtlXML.getFieldValueString(h,"POSITION");


						ezirfqdetailstablerow.setRFQNo(portalRFQNumber);
						ezirfqdetailstablerow.setLineNo(rfqItemNo);
						ezirfqdetailstablerow.setCounter("1");
						ezirfqdetailstablerow.setMaterial(dtlXML.getFieldValueString(h,"ITEM"));
						ezirfqdetailstablerow.setMaterialDesc(dtlXML.getFieldValueString(h,"ITEMDESCRIPTION"));
						ezirfqdetailstablerow.setUOM(dtlXML.getFieldValueString(h,"UOMPURCHASE"));
						ezirfqdetailstablerow.setDeliveryDate(itemDlvDate);
						ezirfqdetailstablerow.setQuantity(dtlXML.getFieldValueString(h,"ORDEREDQUANTITY"));
						ezirfqdetailstablerow.setPrice("0");
						ezirfqdetailstablerow.setCurr("");		
						ezirfqdetailstablerow.setPlant(dtlXML.getFieldValueString(h,"PLANT"));
						ezirfqdetailstablerow.setRemarks("");
						ezirfqdetailstablerow.setExt1("");
						ezirfqdetailstablerow.setExt2("");
						ezirfqdetailstablerow.setExt3("");
						ezirfqdetailstablerow.setExchRate("0");	
						ezirfqdetailstablerow.setNegPrice("0");
						ezirfqdetailstablerow.setQuoteStatus("");
						ezirfqdetailstable.appendRow(ezirfqdetailstablerow);

						for(int x=0;x<taxCodes.length;x++)
						{

							condTableRow = new EzRFQConditionsTableRow();
							condTableRow.setVendor(defErpVendor);
							condTableRow.setRfqNo(portalRFQNumber);
							condTableRow.setRfqLineNo(rfqItemNo);
							condTableRow.setTaxCode(taxCodes[x]);
							condTableRow.setTaxValue("0");
							
							condTableRow.setTaxType("P");
														
							if("FRT".equals(taxCodes[x]))
								condTableRow.setTaxType("V");
							condTableRow.setCForm("");
							condTableRow.setExt1("");
							condTableRow.setExt2("");
							condTableRow.setExt3("");
							condTableRow.setSeqNo("1");
							condTable.appendRow(condTableRow);
						}	
					}				

					if(ezirfqheadertable.getRowCount()>0)
					{
						EzcParams ezcContainer = new EzcParams(true);
						ezcContainer.setLocalStore("Y");
						ezcContainer.setObject(ezirfqheadertable);
						ezcContainer.setObject(ezirfqdetailstable);
						ezcContainer.setObject(rfqQuoteHistoryTable);
						ezcContainer.setObject(condTable);
						Session.prepareParams(ezcContainer);
						try
						{
							ReturnObjFromRetrieve statusRet = (ReturnObjFromRetrieve)rfqManager.ezAddRFQ(ezcContainer);

							if(!statusRet.isError())
								statusSuccess = true;
						}
						catch(Exception e)
						{
							ezc.ezcommon.EzLog4j.log("Error while saving TEMP USER RFQs in DB"+e,"I");
							sendMail = false;
						}

					}

					/**************SMS and MAIL Sending Starts***********************/

					if(ezirfqheadertable.getRowCount()>0 && sendMail && statusSuccess)
					{
						showStatusMsg = true;
						String sentStatus="N",smsRFQ="",poAmended="";

						EziRFQHeaderTableRow linesRow = null;
						for(int p=0;p<ezirfqheadertable.getRowCount();p++)
						{
							linesRow = (EziRFQHeaderTableRow)ezirfqheadertable.getRow(p);
							smsRFQ = linesRow.getExt1();

							poAmended = "N";
							ezc.ezcommon.EzLog4j.log("::MOBILE NO::::"+mobileNo,"I");
							ezc.ezcommon.EzLog4j.log("SMS_PO>>>>>>>>"+smsRFQ,"I");  

							String smsMesg    = "Below RFQ is created from Coromandel "+smsRFQ+" Please login to the Vendor Portal make the Quotation.";
							
							ezc.ezmisc.client.EzMiscManager ezMiscManager = null;
	 %>						
							<%@ include file="../Misc/ezSendSMS.jsp"%>
	 <%
							ezc.ezcommon.EzLog4j.log("::EMAIL::::"+vendEmail,"I");
							
							String toEMailIds = vendEmail;
							String ccEMailIds = "";

							if("OK".equals(smsResponse))
								sentStatus = "Y";

							ezc.ezcommon.EzLog4j.log("SMS Sent STATUS>>>>>>>"+sentStatus,"I");	

							String msgSubject = "Coromandel : Request For Quotation -"+smsRFQ;
							String eMailData = "Dear Sir/Madam, <br><br>RFQ is created with "+smsRFQ+" <Br><Br>Please login to the vendor portal for quotation.<Br><Br>Contact helpdesk at 1800 425 5696 or mail aphelpdesk@coromandel.murugappa.com for any quarries. <br><br>Regards,<Br>Admin, Vendor Portal<br> Coromandel International Limited. <Br><Br><B>Portal Link : <a href="+request.getScheme()+"://"+request.getServerName()+"  target=_blank>"+request.getServerName()+"</a></B>";

							ezc.ezcommon.EzLog4j.log("MAIL MSGSUBJECT>>>>>>>"+msgSubject,"I");
							ezc.ezcommon.EzLog4j.log("MAIL MSGTEXT>>>>>>>"+eMailData,"I");
%>
							<%@ include file="../Misc/ezSendExternalMail.jsp"%>
<%
						}
					}
					/**************SMS and MAIL Sending End***********************/
				}

				if(showStatusMsg)
				{
					dispMessage="RFQ(s) sent to vendors successfully";
					dispMsgType="S";
				}	
			}	
		}	
	}
 	
 	String display_header = "Sending RFQ(s) to Non SAP Vendor";
%>

<html>
<head>
<%@ include file="../Misc/ezHeader.jsp"%> 
<script>
	function funOK()
	{
		location.href="../Misc/ezBuyerWelcome.jsp";
	}
</script>
</head>
<body scroll=no>
<form name="myForm" method="post">
<%@ include file="../Misc/ezSubHeader.jsp"%> 
<Br><Br><Br>
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>
<Br><Br><Br>
<center>
	<button type="button" class="btn btn-primary" onclick="funOK()">Ok</button>  &nbsp;	
</center>

<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 