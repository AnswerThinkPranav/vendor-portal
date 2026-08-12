<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../Misc/ezDefaultDate.jsp"%>     
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="java.util.*,java.math.BigDecimal" %>
<%@ page import = "ezc.ezparam.*,ezc.ezutil.FormatDate.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable,com.sap.conn.jco.JCoContext"%>
<%@ page import="ezc.ezmisc.params.*,java.text.SimpleDateFormat" %> 
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>
<%!
	public void closePO(ezc.session.EzSession Session,String qcfNo)
	{
		
		ReturnObjFromRetrieve retRFQObj=ezMiscSelect(Session,"SELECT COUNT(ERD_RFQ_NO) AS RFQCNT FROM ezc_rfq_details where (ERD_PO_CR_QTY is null or ERD_PO_QTY-ERD_PO_CR_QTY >= 1) and ERD_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO='"+qcfNo+"')");
		Long tempCnt=(Long)retRFQObj.getFieldValue(0,"RFQCNT");
		if(tempCnt == 0)
		{
			ArrayList<String> queries=new ArrayList<String>();
			queries.add("UPDATE EZC_RFQ_HEADER SET ERH_PO_FLAG='X' WHERE ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'");
			ezMiscInsert(Session,queries);
		}
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
	htTaxMap.put("5##O","I2");
	htTaxMap.put("12##O","I4");
	htTaxMap.put("18##O","I6");
	htTaxMap.put("28##O","I8");
	htTaxMap.put("3##O","IB");
	htTaxMap.put("5##W","K2");
	htTaxMap.put("12##W","K4");
	htTaxMap.put("18##W","K6");
	htTaxMap.put("28##W","K8");
	htTaxMap.put("3##W","K9");
	htTaxMap.put("5##I","J2");
	htTaxMap.put("12##I","J4");
	htTaxMap.put("18##I","J6");
	htTaxMap.put("28##I","J8");
	
	
	Hashtable<String,String> htCondMap = new Hashtable<String,String>();
	htCondMap.put("DOM##DISC##P","R000##N##I");
	htCondMap.put("DOM##DISC##Q","R001##N##I");
	htCondMap.put("DOM##PKFW##P","ZPF1##N##U");
	htCondMap.put("DOM##PKFW##V","ZPF2##N##U");
	htCondMap.put("DOM##PKFW##Q","ZPF3##N##U");
	htCondMap.put("DOM##FRT##P","FRA1##Y##U");
	htCondMap.put("DOM##FRT##V","FRB1##Y##U");
	htCondMap.put("DOM##FRT##Q","FRC1##Y##U");
	htCondMap.put("DOM##BFRT##P","FRA2##Y##U");
	htCondMap.put("DOM##BFRT##V","FRB2##Y##U");
	htCondMap.put("DOM##BFRT##Q","FRC2##Y##U");
	htCondMap.put("DOM##INS##P","ZINP##N##U");
	htCondMap.put("DOM##INS##Q","ZINQ##N##U");
	htCondMap.put("IMP##DISC##P","R000##N##I");
	htCondMap.put("IMP##DISC##Q","R001##N##I");
	htCondMap.put("IMP##PKFW##P","ZPF1##N##U");
	htCondMap.put("IMP##PKFW##V","ZPF2##N##U");
	htCondMap.put("IMP##PKFW##Q","ZPF3##N##U");
	htCondMap.put("IMP##FRT##P","FRA1##Y##U");
	htCondMap.put("IMP##FRT##V","FRB1##Y##U");
	htCondMap.put("IMP##FRT##Q","FRC1##Y##U");
	htCondMap.put("IMP##BFRT##P","FRA2##Y##U");
	htCondMap.put("IMP##BFRT##V","FRB2##Y##U");
	htCondMap.put("IMP##BFRT##Q","FRC2##Y##U");
	htCondMap.put("IMP##INS##P","ZINP##N##U");
	htCondMap.put("IMP##INS##Q","ZINQ##N##U");
	
	
	String dispMessage 	= "";
	boolean isError 	= false;
	String dispMsgType 	= "S";
	String plantCity = "";
	String qcfNo ="";
	for(int i=0;i<rfqNo.length;i++)
	{
		if(isError)
			break;
		Hashtable<String,String> htPRUSedQty = new Hashtable<String,String>();
		Hashtable<String,BigDecimal> htRFQUSedQty = new Hashtable<String,BigDecimal>();
		
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		ezc.ezparam.ReturnObjFromRetrieve rfqDtlRetObj  =	null;

		miscTableRow.setQuery("select ERH_COLLETIVE_RFQ_NO,ERD_DOC_TYPE,ERH_INCO_TERMS1,ERH_PAYMENT_TERMS,ERD_PO_QTY,ERD_EXT1,ERH_SOLD_TO,ERD_MATERIAL,ERD_QUANTITY,ERD_PRICE,ERD_PLANT,ERD_DELIVERY_DATE,ERD_LINE_NO,ERH_PUR_ORG,ERH_PUR_GRP,ERH_EXT2 from EZC_RFQ_HEADER,EZC_RFQ_DETAILS where ERH_RFQ_NO = ERD_RFQ_NO  AND ERD_RFQ_NO = '"+rfqNo[i]+"' AND ERD_PO_QTY > 0 AND (ERD_PO_CR_QTY is null or ERD_PO_QTY-ERD_PO_CR_QTY >= 1)"); 
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try{
			rfqDtlRetObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

		}catch(Exception e){
			log("Exception in getting RFQ DETAILS>>>>>"+e);
		}
		int rfqDtlRetObjCnt = 0;
		if(rfqDtlRetObj != null)
			rfqDtlRetObjCnt = rfqDtlRetObj.getRowCount();

		//out.println(":::::rfqDtlRetObj::::::"+rfqDtlRetObj.toEzcString());
	
		if(rfqDtlRetObjCnt == 0)
			continue;
		
		String rfqType = rfqDtlRetObj.getFieldValueString(0,"ERH_EXT2");
		qcfNo = rfqDtlRetObj.getFieldValueString(0,"ERH_COLLETIVE_RFQ_NO");
		String poTaxCode = "";


		ReturnObjFromRetrieve rfqCondRetObj=ezMiscSelect(Session,"SELECT * FROM EZC_RFQ_ITEM_CONDITIONS WHERE ERIC_RFQ_NO = '"+rfqNo[i]+"'");
		
		int rfqCondRetObjCnt = 0;
		if(rfqCondRetObj != null)
			rfqCondRetObjCnt = rfqCondRetObj.getRowCount();
			
		ReturnObjFromRetrieve rfqServRetObj=ezMiscSelect(Session,"SELECT * FROM EZC_RFQ_SERVICES WHERE ERS_SRV_RFQ = '"+rfqNo[i]+"'");
				
		int rfqServRetObjCnt = 0;
		if(rfqServRetObj != null)
			rfqServRetObjCnt = rfqServRetObj.getRowCount();
		
		ReturnObjFromRetrieve prDetailsRetObj=ezMiscSelect(Session,"SELECT * FROM EZC_RFQ_PRS WHERE ERP_QCF_NO='"+qcfNo+"' AND ERP_PR_OPEN_QTY > 0");
		
		ReturnObjFromRetrieve plantRetObj=ezMiscSelect(Session,"SELECT EP_CITY FROM EZC_PLANTS WHERE EP_PLANT='"+rfqDtlRetObj.getFieldValueString(0,"ERD_PLANT")+"'");
			
		if(plantRetObj != null)
			plantCity = plantRetObj.getFieldValueString(0,"EP_CITY");
			
		int prDetailsRetObjCnt = 0;
		if(prDetailsRetObj != null)
			prDetailsRetObjCnt = prDetailsRetObj.getRowCount();
		
		for(int s=0;s<rfqCondRetObjCnt;s++)
		{
			if("TAX".equals(rfqCondRetObj.getFieldValueString(s,"ERIC_TAX_CODE")))
			{
				if("IMP".equals(rfqType))
				{
					poTaxCode = htTaxMap.get(rfqCondRetObj.getFieldValueString(s,"ERIC_TAX_VALUE")+"##I");
				}
				else
				{
					poTaxCode = htTaxMap.get(rfqCondRetObj.getFieldValueString(s,"ERIC_TAX_VALUE")+"##"+rfqCondRetObj.getFieldValueString(s,"ERIC_TAX_TYPE"));
				}
				
				break;
			}
		}
		
		

		String poNo 		= "";
		String poNum = null;
		String prDocType = "";
		String poDocType = "";
		String rfqSoldTo = rfqDtlRetObj.getFieldValueString(0,"ERH_SOLD_TO");
		
		try
		{
			prDocType = rfqDtlRetObj.getFieldValueString(0, "ERD_DOC_TYPE");
		}
		catch(Exception e)
		{
		}
		ezc.ezcommon.EzLog4j.log("prDocType:::::"+prDocType,"I");
		ezc.ezcommon.EzLog4j.log("poDocType:::::"+poDocType,"I");
		
		if(htPRPOMap.containsKey(prDocType))
			poDocType = htPRPOMap.get(prDocType);
		
		
		String logonSite = (String)session.getValue("SITE");
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
		JCoFunction poFunction = null;
		JCoFunction commitFunction = null;
		SimpleDateFormat sapDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		SimpleDateFormat portalDateFormat = new SimpleDateFormat("dd/MM/yyyy");
		try
		{
			poFunction = EzSAPHandler.getJCoFunction(destination,"BAPI_PO_CREATE1");
			commitFunction = EzSAPHandler.getJCoFunction(destination,"BAPI_TRANSACTION_COMMIT");
			JCoParameterList sapImpParam = poFunction.getImportParameterList();
			JCoParameterList sapTabParam= poFunction.getTableParameterList();


			JCoStructure PoHeader  = sapImpParam.getStructure("POHEADER");
			JCoStructure PoHeaderx = sapImpParam.getStructure("POHEADERX");

			JCoTable PoItem       = sapTabParam.getTable("POITEM");
			JCoTable PoItemx      = sapTabParam.getTable("POITEMX");

			JCoTable PoSchedule   	= sapTabParam.getTable("POSCHEDULE");
			JCoTable PoSchedulex 	= sapTabParam.getTable("POSCHEDULEX");

			JCoTable PoCond	= sapTabParam.getTable("POCOND");
			JCoTable PoCondx	= sapTabParam.getTable("POCONDX");
			
			JCoTable PoCond	= sapTabParam.getTable("POCOND");
			JCoTable PoCondx	= sapTabParam.getTable("POCONDX");
			
			JCoTable PoServices = sapTabParam.getTable("POSERVICES");
			/*
							PoAccount.appendRow();
							PoAccountX.appendRow();
							PoAccount.setValue("GL_ACCOUNT","830502");
							PoAccountX.setValue("GL_ACCOUNT","X");
							PoAccount.setValue("COSTCENTER","530010051");
							PoAccountX.setValue("COSTCENTER","X");
							PoAccount.setValue("QUANTITY","1");
							PoAccountX.setValue("QUANTITY","X");
							PoAccount.setValue("PO_ITEM",tempPOItem);
							PoAccountX.setValue("PO_ITEM",tempPOItem);
							PoAccountX.setValue("PO_ITEMX","X");*/
							
				

			JCoTable PoTextHeader            = sapTabParam.getTable("POTEXTHEADER");
			JCoTable PoTextItem    = sapTabParam.getTable("POTEXTITEM");

			PoHeader.setValue("COMP_CODE","5000");
			PoHeaderx.setValue("COMP_CODE","X");

			PoHeader.setValue("CREATED_BY",Session.getUserId()+"");
			PoHeaderx.setValue("CREATED_BY","X");

			PoHeader.setValue("PURCH_ORG",rfqDtlRetObj.getFieldValueString(0, "ERH_PUR_ORG"));
			PoHeaderx.setValue("PURCH_ORG","X");

			PoHeader.setValue("PUR_GROUP",rfqDtlRetObj.getFieldValueString(0, "ERH_PUR_GRP"));
			PoHeaderx.setValue("PUR_GROUP","X");

			PoHeader.setValue("DOC_TYPE",poDocType);
			PoHeaderx.setValue("DOC_TYPE","X");

			PoHeader.setValue("PMNTTRMS",rfqDtlRetObj.getFieldValueString(0,"ERH_PAYMENT_TERMS"));
			PoHeaderx.setValue("PMNTTRMS","X");
			
			PoHeader.setValue("INCOTERMS1",rfqDtlRetObj.getFieldValueString(0,"ERH_INCO_TERMS1"));
			PoHeaderx.setValue("INCOTERMS1","X");
			
			if("EXW".equals(rfqDtlRetObj.getFieldValueString(0,"ERH_INCO_TERMS1")))
				plantCity="Ex Works";
			
			PoHeader.setValue("INCOTERMS2",plantCity);
			PoHeaderx.setValue("INCOTERMS2","X");

			sapImpParam.setValue("NO_PRICE_FROM_PO","X");

			PoHeader.setValue("VENDOR",rfqDtlRetObj.getFieldValueString(0,"ERH_SOLD_TO"));//
			PoHeaderx.setValue("VENDOR","X");

			ezc.ezcommon.EzLog4j.log("VENDOR:::::"+PoHeader.getValue("VENDOR"),"I");
			ezc.ezcommon.EzLog4j.log("DOC_TYPE:::::"+PoHeader.getValue("DOC_TYPE"),"I");
			ezc.ezcommon.EzLog4j.log("PUR_GROUP:::::"+PoHeader.getValue("PUR_GROUP"),"I");
			ezc.ezcommon.EzLog4j.log("PURCH_ORG:::::"+PoHeader.getValue("PURCH_ORG"),"I");
			ezc.ezcommon.EzLog4j.log("COMP_CODE:::::"+PoHeader.getValue("COMP_CODE"),"I");
			ezc.ezcommon.EzLog4j.log("PMNTTRMS:::::"+PoHeader.getValue("PMNTTRMS"),"I");
			ezc.ezcommon.EzLog4j.log("INCOTERMS1:::::"+PoHeader.getValue("INCOTERMS1"),"I");
			ezc.ezcommon.EzLog4j.log("INCOTERMS2:::::"+PoHeader.getValue("INCOTERMS2"),"I");

			for(int p=0;p<rfqDtlRetObjCnt;p++)
			{

				String dlvDate = sapDateFormat.format((java.util.Date)rfqDtlRetObj.getFieldValue(p, "ERD_DELIVERY_DATE"));
				String [] prItemArr = rfqDtlRetObj.getFieldValueString(p, "ERD_EXT1").split("¥");
				String rfqLineNo = rfqDtlRetObj.getFieldValueString(p, "ERD_LINE_NO");
				BigDecimal rfqLineQty = new BigDecimal(rfqDtlRetObj.getFieldValueString(p, "ERD_QUANTITY"));
				ezc.ezcommon.EzLog4j.log("rfqLineNo:::::"+rfqLineNo,"I");
				ezc.ezcommon.EzLog4j.log("rfqLineQty:::::"+rfqLineQty,"I");
				String tempPOItem=((p+1)*10)+"";

				PoItem.appendRow();
				PoItemx.appendRow();

				PoItem.setValue("PO_ITEM",tempPOItem);
				PoItemx.setValue("PO_ITEM",tempPOItem);
				PoItemx.setValue("PO_ITEMX","X");

				PoItem.setValue("MATERIAL",rfqDtlRetObj.getFieldValueString(p,"ERD_MATERIAL"));//0000000007320000110
				PoItemx.setValue("MATERIAL","X");
				

				PoItem.setValue("PLANT",rfqDtlRetObj.getFieldValueString(p,"ERD_PLANT"));
				PoItemx.setValue("PLANT","X");

				PoItem.setValue("NET_PRICE",rfqDtlRetObj.getFieldValueString(p,"ERD_PRICE"));
				PoItemx.setValue("NET_PRICE","X");
				/*
				PoItem.setValue("PREQ_NO",prItemArr[0]);
				PoItemx.setValue("PREQ_NO","X");

				PoItem.setValue("PREQ_ITEM",prItemArr[1]);
				PoItemx.setValue("PREQ_ITEM","X");
				*/
				PoItem.setValue("TAX_CODE",poTaxCode);
				PoItemx.setValue("TAX_CODE","X");

				ezc.ezcommon.EzLog4j.log("Items - PO_ITEM:::::"+PoItem.getValue("PO_ITEM"),"I");
				ezc.ezcommon.EzLog4j.log("Items -MATERIAL:::::"+PoItem.getValue("MATERIAL"),"I");
				ezc.ezcommon.EzLog4j.log("Items -NET_PRICE:::::"+PoItem.getValue("NET_PRICE"),"I");
				//ezc.ezcommon.EzLog4j.log("Items -PREQ_NO:::::"+PoItem.getValue("PREQ_NO"),"I");
				//ezc.ezcommon.EzLog4j.log("Items -PREQ_ITEM:::::"+PoItem.getValue("PREQ_ITEM"),"I");
				ezc.ezcommon.EzLog4j.log("Items -TAX_CODE:::::"+PoItem.getValue("TAX_CODE"),"I");
				
				BigDecimal lineRFQQty=new BigDecimal(rfqDtlRetObj.getFieldValueString(p,"ERD_PO_QTY"));
				BigDecimal lineRFQQtyFin=new BigDecimal(rfqDtlRetObj.getFieldValueString(p,"ERD_PO_QTY"));
				htRFQUSedQty.put(rfqLineNo,lineRFQQtyFin);
				int schdIndex = 1;
				for(int q=0;q<prDetailsRetObjCnt;q++)
				{
					if(lineRFQQty.compareTo(BigDecimal.ZERO) == 0)
						break;
					ezc.ezcommon.EzLog4j.log(prDetailsRetObj.getFieldValueString(q,"ERP_RFQ_LINE_NO")+"rfqLineNo:::::"+rfqLineNo,"I");					
					if(!rfqLineNo.equals(prDetailsRetObj.getFieldValueString(q,"ERP_RFQ_LINE_NO")))
						continue;
					
					String prReq = prDetailsRetObj.getFieldValueString(q,"ERP_PR_NO");
					String prReqItem = prDetailsRetObj.getFieldValueString(q,"ERP_PR_ITEM");
					BigDecimal prQty=new BigDecimal(prDetailsRetObj.getFieldValueString(q,"ERP_PR_OPEN_QTY"));	
					BigDecimal deductedQty=new BigDecimal(0.0);
					
					if(prQty.compareTo(lineRFQQty) == 0)
					{
						deductedQty=lineRFQQty;
						
					}
					else if(prQty.compareTo(lineRFQQty) > 0)
					{
						//deductedQty = prQty.subtract(lineRFQQty);
						deductedQty=lineRFQQty;
					}
					else if(prQty.compareTo(lineRFQQty) < 0)
					{
						deductedQty = lineRFQQty.subtract(prQty);
					}
					lineRFQQty = lineRFQQty.subtract(deductedQty);
					
					htPRUSedQty.put(prDetailsRetObj.getFieldValueString(q,"ERP_RFQ_LINE_NO")+"##"+prDetailsRetObj.getFieldValueString(q,"ERP_PR_NO")+"##"+prDetailsRetObj.getFieldValueString(q,"ERP_PR_ITEM"),deductedQty+"##"+tempPOItem);
					
					ezc.ezcommon.EzLog4j.log("lineRFQQty:::::"+lineRFQQty,"I");					
					ezc.ezcommon.EzLog4j.log("prQty:::::"+prQty,"I");					
					ezc.ezcommon.EzLog4j.log("deductedQty:::::"+deductedQty,"I");					
					ezc.ezcommon.EzLog4j.log("htPRUSedQty:::::"+htPRUSedQty,"I");					
					
					PoSchedule.appendRow();
					PoSchedulex.appendRow();

					PoSchedule.setValue("PO_ITEM",tempPOItem);
					PoSchedule.setValue("SCHED_LINE",schdIndex);
					PoSchedule.setValue("QUANTITY",deductedQty);
					PoSchedule.setValue("PREQ_NO",prReq);
					PoSchedule.setValue("PREQ_ITEM",prReqItem);
					//PoSchedule.setValue("DELIVERY_DATE",dlvDate);

					ezc.ezcommon.EzLog4j.log("Schedules - PO_ITEM:::::"+PoSchedule.getValue("PO_ITEM"),"I");
					ezc.ezcommon.EzLog4j.log("Schedules - SCHED_LINE:::::"+PoSchedule.getValue("SCHED_LINE"),"I");
					ezc.ezcommon.EzLog4j.log("Schedules - QUANTITY:::::"+PoSchedule.getValue("QUANTITY"),"I");
					ezc.ezcommon.EzLog4j.log("Schedules - PREQ_NO:::::"+PoSchedule.getValue("PREQ_NO"),"I");
					ezc.ezcommon.EzLog4j.log("Schedules - PREQ_ITEM:::::"+PoSchedule.getValue("PREQ_ITEM"),"I");
					//ezc.ezcommon.EzLog4j.log("DELIVERY_DATE:::::"+PoSchedule.getValue("DELIVERY_DATE"),"I");

					PoSchedulex.setValue("PO_ITEM",tempPOItem);
					PoSchedulex.setValue("SCHED_LINE",schdIndex);
					PoSchedulex.setValue("PO_ITEMX","X");
					PoSchedulex.setValue("SCHED_LINEX","X");
					PoSchedulex.setValue("QUANTITY","X");
					PoSchedulex.setValue("PREQ_NO","X");
					PoSchedulex.setValue("PREQ_ITEM","X");
					//PoSchedulex.setValue("DELIVERY_DATE","X");
					schdIndex++;
				}

				
				for(int u=0;u<rfqCondRetObjCnt;u++)
				{
					if(!rfqLineNo.equals(rfqCondRetObj.getFieldValueString(u,"ERIC_LINE_NO")))
						continue;
					
					String tempTaxCode=rfqCondRetObj.getFieldValueString(u,"ERIC_TAX_CODE");
					BigDecimal tempTaxValue=new BigDecimal(rfqCondRetObj.getFieldValueString(u,"ERIC_TAX_VALUE"));
					String tempTaxType=rfqCondRetObj.getFieldValueString(u,"ERIC_TAX_TYPE");
					String tempKey = rfqType+"##"+tempTaxCode+"##"+tempTaxType;
					
					ezc.ezcommon.EzLog4j.log("tempTaxCode:::::"+tempTaxCode,"I");
					ezc.ezcommon.EzLog4j.log("tempTaxValue:::::"+tempTaxValue,"I");
					ezc.ezcommon.EzLog4j.log("tempTaxType:::::"+tempTaxType,"I");
					ezc.ezcommon.EzLog4j.log("tempKey:::::"+tempKey,"I");
					
					if(tempTaxValue.compareTo(BigDecimal.ZERO) == 0 || "TAX".equals(tempTaxCode) || !htCondMap.containsKey(tempKey))
						continue;
					String [] tempTaxArr=htCondMap.get(tempKey).split("##");
					if("V".equals(tempTaxType))
					{
						BigDecimal tempCondVal=tempTaxValue.divide(rfqLineQty);
						tempCondVal = tempCondVal.multiply(lineRFQQtyFin);
						tempCondVal = tempCondVal.setScale(2,java.math.BigDecimal.ROUND_HALF_UP);
						ezc.ezcommon.EzLog4j.log("V:::tempCondVal3:::::"+tempCondVal,"I");
						ezc.ezcommon.EzLog4j.log("V:::tempTaxValue3:::::"+tempTaxValue,"I");
						tempTaxValue = tempCondVal;
						
					}
					
					PoCond.appendRow();
					PoCondx.appendRow();
					PoCond.setValue("ITM_NUMBER",tempPOItem);
					PoCond.setValue("COND_TYPE",tempTaxArr[0]);
					
					if("P".equals(tempTaxType))
						PoCond.setValue("COND_VALUE",tempTaxValue);
					else
						PoCond.setValue("COND_VALUE",tempTaxValue.divide(new BigDecimal(10)));
					
					PoCond.setValue("CHANGE_ID",tempTaxArr[2]);
					
					PoCondx.setValue("ITM_NUMBER",tempPOItem);
					PoCondx.setValue("COND_TYPE","X");
					PoCondx.setValue("COND_VALUE","X");
					PoCondx.setValue("CHANGE_ID","X");
					
					if("Y".equals(tempTaxArr[1]))
					{
						PoCond.setValue("VENDOR_NO",rfqSoldTo);
						PoCondx.setValue("VENDOR_NO","X");
					}
					
					ezc.ezcommon.EzLog4j.log("Conditions - ITM_NUMBER:::::"+PoCond.getValue("ITM_NUMBER"),"I");
					ezc.ezcommon.EzLog4j.log("Conditions - COND_TYPE:::::"+PoCond.getValue("COND_TYPE"),"I");
					ezc.ezcommon.EzLog4j.log("Conditions - COND_VALUE:::::"+PoCond.getValue("COND_VALUE"),"I");
					ezc.ezcommon.EzLog4j.log("Conditions - CHANGE_ID:::::"+PoCond.getValue("CHANGE_ID"),"I");
					ezc.ezcommon.EzLog4j.log("Conditions - VENDOR_NO:::::"+PoCond.getValue("VENDOR_NO"),"I");
					
					

				}
				
				for(int v=0;v<rfqServRetObjCnt;v++)
				{
					if(!rfqLineNo.equals(rfqServRetObj.getFieldValueString(u,"ERIC_LINE_NO")))
						continue;
					PoServices.appendRow();
					PoServices.setValue("PCKG_NO","5000");
					
				}
				
			}	
			

			try{
				JCoContext.begin(destination);
				poFunction.execute(destination);
				commitFunction.execute(destination);
				JCoContext.end(destination);
			}catch(Exception e){
				out.print(e);
			}


			JCoTable retOut = poFunction.getTableParameterList().getTable("RETURN");
			
			JCoParameterList expParam = poFunction.getExportParameterList();
			poNum=(String)expParam.getValue("EXPPURCHASEORDER");
			int poCount = retOut.getNumRows();
			ezc.ezcommon.EzLog4j.log(poCount+"::::::::::::::"+poNum,"I");	
			ezc.ezcommon.EzLog4j.log("retOut::::::::::::::"+retOut,"I");	
			if(poCount>0)
			{
				do
				{
					String lv_Type = (String)retOut.getValue("TYPE");
					String lv_Msg  = (String)retOut.getValue("MESSAGE");

					ezc.ezcommon.EzLog4j.log(lv_Type+"::::::::::::::"+lv_Msg,"I");	

					if("S".equals(lv_Type))
					{
						dispMessage += lv_Msg+"<Br>"; 
					}else if("E".equals(lv_Type)){
						isError      = true;
						dispMessage += lv_Msg+"<Br>"; 
					}
				}while(retOut.nextRow());
			}
		}catch(Exception e){ 
			ezc.ezcommon.EzLog4j.log("Got Exception in PO Creation "+e,"E");	
			isError      = true;
			dispMessage  += "Exception in creating PO";
		}

		if(!isError)
		{
			ArrayList<String> queries=new ArrayList<String>();
			Set<String> poItemSet=htPRUSedQty.keySet();
			for(String tempKey:poItemSet)
			{
				String [] tempKeyArr=tempKey.split("##");
				String [] tempValArr=htPRUSedQty.get(tempKey).split("##");
				queries.add("INSERT INTO EZC_RFQ_POS(ERP_RFQ_NO,ERP_RFQ_LINE_NO,ERP_PR_NO,ERP_PR_ITEM,ERP_PO_NO,ERP_PO_ITEM,ERP_QUANTITY) VALUES('"+rfqNo[i]+"','"+tempKeyArr[0]+"','"+tempKeyArr[1]+"','"+tempKeyArr[2]+"','"+poNum+"','"+tempValArr[1]+"','"+tempValArr[0]+"')");
				queries.add("UPDATE EZC_RFQ_PRS SET ERP_PR_OPEN_QTY=ERP_PR_OPEN_QTY-"+tempValArr[0]+" where ERP_QCF_NO='"+qcfNo+"' and ERP_RFQ_LINE_NO='"+tempKeyArr[0]+"' and ERP_PR_NO='"+tempKeyArr[1]+"' and ERP_PR_ITEM='"+tempKeyArr[2]+"'");
			}
			Set<String> rfqItemSet=htRFQUSedQty.keySet();
			
			for(String tempRfqKey:rfqItemSet)
			{
				queries.add("UPDATE EZC_RFQ_DETAILS SET ERD_PO_CR_QTY=ERD_PO_CR_QTY+"+htRFQUSedQty.get(tempRfqKey)+" WHERE ERD_RFQ_NO = '"+rfqNo[i]+"' AND ERD_LINE_NO='"+tempRfqKey+"'");
			}
			
			
			
			
			ezMiscInsert(Session,queries);
			
		}
	}

	
	closePO(Session,qcfNo);
		
	if(isError)
		dispMsgType = "E";
		
	String divWidth    = "90%";
	String display_header = "Confirmation";
	if("".equals(dispMessage))
		dispMessage 	= "No RFQ(s) to create PO";
%>
 <html> 
 <head>
  
 <script>
 	function checkList()
 	{
 		location.href="../Misc/ezWelcome_New.jsp";
 	}
 </script>
 </head>
 <body scroll=no>
 <form name="myForm" method="post">
 <%@ include file="../Misc/ezSubHeader.jsp"%> 
 <Br><Br><Br>
 <center> 
 
 	<div class="alert alert-<%=isError?"warning":"success"%>" style="width:30%">
 	<h4><i class="icon fa fa-check"></i> <%=isError?"Error":"Success"%></h4>
 	<%=dispMessage%>
 	</div>
 </center>
 <Br><Br><Br>
 <center>
 	<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	
 </center>
 <Div id="MenuSol"></Div>
 </form>
 <%@ include file="../Misc/ezSubFooter.jsp"%>
 <%@ include file="../Misc/ezFooter.jsp"%> 
  
 
