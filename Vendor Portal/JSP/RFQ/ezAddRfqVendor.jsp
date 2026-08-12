<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../Misc/ezDefaultDate.jsp"%>
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/timepicker/bootstrap-timepicker.min.css">
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ include file="../Misc/ezGetJGLVendorsList.jsp"%>     
<%@ page import ="java.util.*,java.nio.file.*,java.io.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*,java.text.*" %>

<%
	session.setAttribute("RFQ_GENERATED","N");
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate(); 
	
	String link="";
	ResourceBundle sitBundleObj=null;
	try
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		//link=sitBundleObj.getString("PORTAL_URL");
		link = "https://vendor.jolcorp.info/JUBL/ezLogin.jsp";
	}
	catch(Exception e)
	{ 
	}    
	
	
	String qtnEndDate	= request.getParameter("qtnEndDate");
	String plant 		= request.getParameter("plant");
	String allSelVendors	= request.getParameter("allSelVendors");
	String selectedVendors[]= allSelVendors.split("##");
	String qcfPrev		=request.getParameter("qcfPrev");	
	ezc.ezcommon.EzLog4j.log("qcfPrev::::::::"+qcfPrev,"I");
	String retMessage = "";
	String retWarnMessage = "";	
	boolean isError = false;
			
	int vendorsCount = 0;
	
	if(selectedVendors!=null)
	{
		vendorsCount	= selectedVendors.length;	
	}
	ezc.ezcommon.EzLog4j.log("vendorsCount>>>>::::::::"+vendorsCount,"I");
	
	String[]   vendor    = new String[vendorsCount];
	String[]   quantity  = new String[vendorsCount];
	String[]   vendType  = new String[vendorsCount];
	String[]   agentCode = new String[vendorsCount];
	
	//GETTING RFQ NUMBER
	
	String refRfq="";
	int retRfqCnt=0;
	
	ReturnObjFromRetrieve retRfq= ezMiscSelect(Session,"select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO='"+qcfPrev+"' order by erh_rfq_no LIMIT 1 ");		
	if(retRfq != null)
		retRfqCnt= retRfq.getRowCount(); 
	if(retRfqCnt>0)
		refRfq = retRfq.getFieldValueString(0,"ERH_RFQ_NO");
	ezc.ezcommon.EzLog4j.log("refRfq>>>>::::::::"+refRfq,"I");
	
	//ITEM CATEGORY
	String itemCat="N";
	int retSerCnt=0;
	ReturnObjFromRetrieve retSer= ezMiscSelect(Session,"select ERD_ITEM_CAT from ezc_rfq_details where ERD_RFQ_NO='"+refRfq+"' order by erd_rfq_no LIMIT 1 ");		
	if(retSer != null)
		retSerCnt= retSer.getRowCount(); 
	if(retSerCnt>0)
		itemCat = retSer.getFieldValueString(0,"ERD_ITEM_CAT");	
	ezc.ezcommon.EzLog4j.log("itemCat>>>>::::::::"+itemCat,"I");	
	
	for(int i=0;i<vendorsCount;i++)
	{
		
		java.util.StringTokenizer vendSt =new java.util.StringTokenizer(selectedVendors[i],"#");
		try
		{
			vendSt.nextToken();
			vendor[i]	= vendSt.nextToken();
			quantity[i]	= vendSt.nextToken();
			vendType[i]	= vendSt.nextToken();
		}		
		catch(Exception e)
		{
		}
		if("N".equals(vendType[i]))
		{
			java.util.StringTokenizer typeSt =new java.util.StringTokenizer(vendor[i],"$");
			try
			{
				vendor[i]	= typeSt.nextToken();
				agentCode [i]	= typeSt.nextToken();
				if(agentCode[i]==null)
					agentCode [i]="";
			}
			catch(Exception e)
			{
			}			
		}
	}	
	
	String maxDocId = "";

	if(!"null".equals(qcfPrev) && qcfPrev!=null && !"".equals(qcfPrev) && qcfPrev!="") 
		maxDocId= qcfPrev;
		
	for(int i=0;i<vendorsCount;i++) 
	{
		String rfq="";
		ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		
		//RFQ NUMBER

		ReturnObjFromRetrieve getMaxRfq = null;
		miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow1.setQuery("SELECT CAST(MAX(ERH_RFQ_NO)+1 AS UNSIGNED) AS 'MAXRFQ' FROM EZC_RFQ_HEADER");
		ezc.ezcommon.EzLog4j.log("miscTableRow1>>>>>"+miscTableRow1.getQuery(),"I");
		miscTable1.appendRow(miscTableRow1);
		mainParams1.setLocalStore("Y");
		mainParams1.setObject(miscTable1);
		Session.prepareParams(mainParams1);

		try
		{
			getMaxRfq = (ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);

		}
		catch(Exception e)
		{
			System.out.println("Exception:::while saving header QUERY:::::::"+e);
		}
		

		if(getMaxRfq!=null && getMaxRfq.getRowCount()>0)
		{
			ezc.ezcommon.EzLog4j.log("getMaxRfqNew>>>>>"+getMaxRfq.toEzcString(),"I");
			try
			{
				rfq = new BigDecimal(getMaxRfq.getFieldValueString(0,"MAXRFQ"))+"";
				ezc.ezcommon.EzLog4j.log("rfqNew in Add RFQ>>>>>"+rfq,"I");
			}
			catch(Exception e)
			{
				rfq = "7000000001";
			}
			
		}	
	
		//out.println("rfqAdd"+rfq);
		
		String qryRfq = "";
		String qryRfqDtl = "";
		String qryService = "";
		String qryComments = "";
		String rfqStatus="N";
		String rfqCounter="0";

		
		ezc.misctransactions.client.EzMiscTransactionsManager gv_miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable gv_miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow gv_miscTableRow = null;
		
		//RFQ HEADER

		qryRfq+="INSERT INTO ezc_rfq_header(ERH_RFQ_NO,ERH_COLLETIVE_RFQ_NO,ERH_SYS_KEY,ERH_SOLD_TO,ERH_STATUS,ERH_RFQ_DATE,";
		qryRfq+="ERH_VALID_UPTO,ERH_CREATED_BY,ERH_CREATED_ON,ERH_MODIFIED_BY,ERH_MODIFIED_ON,ERH_PUR_ORG,ERH_PUR_GRP,";
		qryRfq+="ERH_VENDOR_TYPE,ERH_AGENT_CODE,ERH_RELEASE_INDICATOR,ERH_RANK_STATUS,ERH_EXT1,ERH_EXT2,ERH_EXT3,ERH_PR_NO,";
		qryRfq+="ERH_PRICE_VALID,ERH_PO_NO,ERH_PO_OR_CON,ERH_PR_ITEM_NO,ERH_VAL_TYPE,ERH_TAX_CODE,ERH_ORDER_UNIT,ERH_PAYMENT_TERMS,";
		qryRfq+="ERH_INCO_TERMS1,ERH_PR_TEXT,ERH_INCO_TERMS2,ERH_MAT_TYPE,ERH_PERCENTAGE,ERH_LEAD_DAYS,ERH_RANK,";
		qryRfq+="ERH_REASON,ERH_LD_STATUS,ERH_LD_CLAUSE,ERH_PG_STATUS,ERH_PG_CLAUSE,ERH_PLANT,ERH_COMP_CODE,ERH_CATEGORY,";
		qryRfq+="ERH_WF_STATUS,ERH_FINAL_VALUE,ERH_REC_VALUE,ERH_PO_FLAG)";
		qryRfq+="select '"+rfq+"' AS ERH_RFQ_NO,ERH_COLLETIVE_RFQ_NO,ERH_SYS_KEY,'"+vendor[i]+"' AS ERH_SOLD_TO,";
		qryRfq+="'"+rfqStatus+"' AS ERH_STATUS,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_CREATED_BY,NOW() AS ERH_CREATED_ON,ERH_MODIFIED_BY,";
		qryRfq+=" NOW() AS ERH_MODIFIED_ON,ERH_PUR_ORG,ERH_PUR_GRP,ERH_VENDOR_TYPE,ERH_AGENT_CODE,ERH_RELEASE_INDICATOR,";
		qryRfq+=" ERH_RANK_STATUS,ERH_EXT1,ERH_EXT2,ERH_EXT3,ERH_PR_NO,ERH_PRICE_VALID,ERH_PO_NO,ERH_PO_OR_CON,ERH_PR_ITEM_NO,";
		qryRfq+=" ERH_VAL_TYPE,ERH_TAX_CODE,ERH_ORDER_UNIT,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_PR_TEXT,ERH_INCO_TERMS2,";
		qryRfq+=" ERH_MAT_TYPE,ERH_PERCENTAGE,ERH_LEAD_DAYS,ERH_RANK,ERH_REASON,ERH_LD_STATUS,ERH_LD_CLAUSE,";
		qryRfq+=" ERH_PG_STATUS,ERH_PG_CLAUSE,ERH_PLANT,ERH_COMP_CODE,ERH_CATEGORY,ERH_WF_STATUS,ERH_FINAL_VALUE,ERH_REC_VALUE,ERH_PO_FLAG";
		qryRfq+=" from ezc_rfq_header where ERH_RFQ_NO='"+refRfq+"'";
		
		ezc.ezcommon.EzLog4j.log("**qryRfqNew BATCH11>>"+qryRfq,"I");

		gv_miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		gv_miscTableRow.setQuery(qryRfq);
		gv_miscTable.appendRow(gv_miscTableRow);
		
		//RFQ DETAILS
		
		qryRfqDtl+="INSERT INTO EZC_RFQ_DETAILS (ERD_RFQ_NO,ERD_LINE_NO,ERD_COUNTER,ERD_MATERIAL,ERD_MATERIAL_DESC,";
		qryRfqDtl+="ERD_UOM,ERD_DELIVERY_DATE,ERD_QUANTITY,ERD_ORDER_UNIT,ERD_PR_CREATED_BY,ERD_PO_NO,ERD_PO_QTY,";
		qryRfqDtl+="ERD_BUDGET_PRICE,ERD_MRP_PRICE,ERD_PRICE,ERD_PLANT,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_EXT1,ERD_EXT2,";
		qryRfqDtl+="ERD_EXT3,ERD_CURRENCY,ERD_EXCH_RATE,ERD_LEAD_DAYS,ERD_VEND_GST,ERD_SAP_GST,ERD_VEND_HSN_CODE,";
		qryRfqDtl+="ERD_SAP_HSN_CODE,ERD_STATUS,ERD_WARRANTY,ERD_DOC_TYPE,ERD_MAT_GRP,ERD_PO_CR_QTY)";
		qryRfqDtl+=" SELECT '"+rfq+"' AS ERD_RFQ_NO,ERD_LINE_NO,'"+rfqCounter+"' AS ERD_COUNTER,ERD_MATERIAL,ERD_MATERIAL_DESC,";
		qryRfqDtl+=" ERD_UOM,ERD_DELIVERY_DATE,ERD_QUANTITY,ERD_ORDER_UNIT,ERD_PR_CREATED_BY,ERD_PO_NO,ERD_PO_QTY,";
		qryRfqDtl+=" ERD_BUDGET_PRICE,'0' AS ERD_MRP_PRICE,'0' AS ERD_PRICE,ERD_PLANT,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_EXT1,ERD_EXT2,";
		qryRfqDtl+=" ERD_EXT3,ERD_CURRENCY,ERD_EXCH_RATE,ERD_LEAD_DAYS,'0' AS ERD_VEND_GST,'0' AS ERD_SAP_GST,ERD_VEND_HSN_CODE,ERD_SAP_HSN_CODE,";
		qryRfqDtl+=" ERD_STATUS,ERD_WARRANTY,ERD_DOC_TYPE,ERD_MAT_GRP,ERD_PO_CR_QTY from ezc_rfq_details where ERD_RFQ_NO='"+refRfq+"'";
		
		ezc.ezcommon.EzLog4j.log("**qryRfqDtl BATCH11>>"+qryRfqDtl,"I");
		
		//RFQ SERVICES
		
		if("D".equals(itemCat))
		{
		
			qryService+="INSERT INTO EZC_RFQ_SERVICES(ERS_SRV_PR,ERS_SRV_PR_ITEM,ERS_SRV_LINE,ERS_SRV_PKG,ERS_SRV_RFQ,ERS_SRV_RFQ_ITEM,";
			qryService+="ERS_SRV_ACT,ERS_SRV_DESC,ERS_SRV_ITEM_TEXT,ERS_SRV_LINE_TEXT,ERS_SRV_QTY,ERS_SRV_UOM,ERS_SRV_PRICE,ERS_SRV_SAC,";
			qryService+="ERS_SRV_GST,ERS_SRV_EXT1,ERS_SRV_EXT2,ERS_SRV_EXT3)";
			qryService+=" SELECT ERS_SRV_PR,ERS_SRV_PR_ITEM,ERS_SRV_LINE,ERS_SRV_PKG,'"+rfq+"' AS ERS_SRV_RFQ,ERS_SRV_RFQ_ITEM,";
			qryService+=" ERS_SRV_ACT,ERS_SRV_DESC,ERS_SRV_ITEM_TEXT,ERS_SRV_LINE_TEXT,ERS_SRV_QTY,ERS_SRV_UOM,'0' AS ERS_SRV_PRICE,";
			qryService+=" '' AS ERS_SRV_SAC,'' AS ERS_SRV_GST,'' AS ERS_SRV_EXT1,'' AS ERS_SRV_EXT2,'' AS ERS_SRV_EXT3 ";
			qryService+=" from ezc_rfq_services where ERS_SRV_RFQ='"+refRfq+"'";

			ezc.ezcommon.EzLog4j.log("**qryService BATCH11>>"+qryService,"I");		
		}	
		
		//RFQ Comments
		qryComments+=" INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE)";
		qryComments+=" SELECT'"+rfq+"' AS EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,NOW() AS EDC_DATE from ";
		qryComments+=" EZC_DOCUMENT_COMMENTS WHERE EDC_DOC_TYPE='RFQ' AND EDC_DOC_ID='"+refRfq+"' ORDER BY EDC_DATE LIMIT 1";
		
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add(qryRfq);
		queriesList.add(qryRfqDtl);
		if("D".equals(itemCat))
		{		
			queriesList.add(qryService);
		}	
		queriesList.add(qryComments);
		ezMiscInsert(Session,queriesList);
				
		
		//RFQ Attachments
		//Confirmation
		String dispSoldTo="";

		try{
				dispSoldTo = Long.parseLong(vendor[i])+""; 
		}catch(Exception e)
		{
				dispSoldTo= vendor[i];	
		}  					

		String dispVend = (String)gv_VendorsHT.get(vendor[i])+"["+dispSoldTo+"]"; // vend[i];		
		
		if("".equals(retMessage))
		{

			retMessage = "<Tr><Td align='center'></Td><Th>"+ "RFQ(s)"+" added under QCF:<b> "+ maxDocId+"</b></Th></Tr>";
			retMessage = retMessage+"<br><br><Tr><Td align='center'></Td><Th>"+(i+1)+".RFQ:"+rfq+" created sucessfully against the vendor: "+dispVend+" </Th></Tr>";
		}		
		else
		{
			retMessage = retMessage+"<br><br><Tr><Td align='center'></Td><Th>"+(i+1)+".RFQ:"+rfq+" created sucessfully against the vendor:  "+dispVend+" </Th></Tr>";
		}		
		
	}
	for(int i=0;i<vendorsCount;i++) 
	{
		String rfqNo="";
		String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		String bgColor = "bgcolor=\"#FFFFFF\"";
		String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
		String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

		String eMailData="",eMailDataComm="";
		String qcfText= "",msgQCFMailSubject = "",toEmailStr = "",ccEmailStr = "";		
		
		eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ref. PR </B></Th>";
		eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
		eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
		eMailData +=  "</Tr>";
		
		ReturnObjFromRetrieve retRfqDtl= ezMiscSelect(Session,"SELECT ERH_RFQ_NO,ERH_SOLD_TO,ERH_STATUS,ERH_CREATED_BY,ERH_MODIFIED_ON,ERH_RFQ_DATE,ERH_VALID_UPTO,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,ERH_PR_NO,ERH_LD_CLAUSE,ERH_EXT2,ERD_LINE_NO,ERD_MATERIAL,ERD_DELIVERY_DATE,ERD_MATERIAL_DESC,ERD_UOM,ERD_QUANTITY,ERD_PRICE,ERD_CURRENCY,ERD_REMARKS,ERD_PLANT,ERD_EXT1,ERD_EXT2,ERD_EXT3,ERD_ACC_CAT,ERD_ITEM_CAT,ERD_WARRANTY,ERD_MAT_GRP  FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND  ERD_RFQ_NO IN (SELECT ERH_RFQ_NO FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO='"+qcfPrev+"' AND ERH_SOLD_TO='"+vendor[i]+"')");		
		int retRfqDtlCnt=0;
		if(retRfqDtl != null)
			retRfqDtlCnt= retRfqDtl.getRowCount(); 
			
		ezc.ezcommon.EzLog4j.log("retRfqDtlCnt>>>>::::::::"+retRfqDtlCnt,"I");		
		ezc.ezcommon.EzLog4j.log("retRfqDtl>>>>::::::::"+retRfqDtl.toEzcString(),"I");					
			
		if(retRfqDtlCnt>0)
			rfqNo = retRfqDtl.getFieldValueString(0,"ERH_RFQ_NO");	
		ezc.ezcommon.EzLog4j.log("rfqNo>>>>::::::::"+rfqNo,"I");
		
		
		String rfqLineItem1= "";
		String rfqPlant="";
		String rfqPr="";
		String rfqMat="";
		String rfqMatDesc="";	
		String rfqItemQty="";
		String rfqUom="";	
		Date rfqDelDt= null;	
		Date rfqEndDt= null;
		
		SimpleDateFormat formatter2   = new SimpleDateFormat("dd/MM/yyyy"); 	
		
		for (int k=0 ; k < retRfqDtlCnt ; k++) 
		{
				
			rfqLineItem1	= checkNull(retRfqDtl.getFieldValueString(k,"ERD_LINE_NO"));  
			rfqPlant	= checkNull(retRfqDtl.getFieldValueString(k,"ERD_PLANT"));
			ezc.ezcommon.EzLog4j.log("****==rfqPlant in AddVendor ====**"+rfqPlant,"I");  
			rfqPr		= checkNull(retRfqDtl.getFieldValueString(k,"ERD_EXT1"));
			rfqMat		= checkNull(retRfqDtl.getFieldValueString(k,"ERD_MATERIAL"));
			ezc.ezcommon.EzLog4j.log("****==rfqItemsCnt iin rfqMat====**"+rfqMat,"I");
			rfqMatDesc	= checkNull(retRfqDtl.getFieldValueString(k,"ERD_MATERIAL_DESC"));
			rfqItemQty	= checkNull(retRfqDtl.getFieldValueString(k,"ERD_QUANTITY"));
			rfqUom  	= checkNull(retRfqDtl.getFieldValueString(k,"ERD_UOM"));
			rfqDelDt 	= (java.util.Date)retRfqDtl.getFieldValue(k,"ERD_DELIVERY_DATE");
			rfqEndDt 	= (java.util.Date)retRfqDtl.getFieldValue(k,"ERH_VALID_UPTO");

			ezc.ezcommon.EzLog4j.log("****==rfqDelDt ====**"+rfqDelDt,"I");  
			ezc.ezcommon.EzLog4j.log("****==rfqEndDt ====**"+rfqEndDt,"I");  
			
			eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqLineItem1+"</Td>"; 
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+plantHT.get(rfqPlant)+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
			eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
			eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+formatter2.format(rfqDelDt)+"</Td>"; 
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+formatter2.format(rfqEndDt)+"</Td>"; 
			eMailData +=  "</Tr>";		
		}
		eMailData +=  "</Table><Br>";	
		
		
		
		
		String comments="";
		int retRfqCmntCnt=0;
		
		ReturnObjFromRetrieve retRfqCmnt= ezMiscSelect(Session,"SELECT EDC_COMMENTS FROM EZC_DOCUMENT_COMMENTS  WHERE EDC_DOC_TYPE='RFQ' AND  EDC_DOC_ID='"+rfqNo+"'") ;	
		if(retRfqCmnt != null)
			retRfqCmntCnt= retRfqCmnt.getRowCount(); 
			
		if(retRfqCmntCnt>0)
		{
			comments = retRfqCmnt.getFieldValueString(0,"EDC_COMMENTS");				
			eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+comments+"</td></Tr></Table><Br>";			
		}	
		
		ezc.ezcommon.EzLog4j.log("eMailDataQCF>>>"+eMailData,"I");
		
		String dispSoldTo="";

		try{
				dispSoldTo = Long.parseLong(vendor[i])+""; 
		}catch(Exception e)
		{
				dispSoldTo= vendor[i];	
		}  							
		
		String lv_VendName = (String) gv_VendorsHT.get(vendor[i]);
		msgQCFMailSubject = "Request For Quotation From JGL Ltd:"+rfqNo;
		qcfText = "Dear Sir/Madam,<Br><Br>This is a Request For Quotation from JGL Ltd.";
		qcfText += " to quote the RFQ:"+rfqNo+" for Vendor "+dispSoldTo+"("+lv_VendName+").<Br><Br>";
		qcfText += eMailData;
		qcfText += eMailDataComm;
		qcfText += "<Br>Please ensure to send the Quotation through Vendor Portal only , Login details already assigned to you .<br>";
		qcfText += "<Br><b>*Quotations received via Email or any other media will not be considered for this RFQ</b><br>";
		qcfText	+= "<b><a href ="+link+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
		qcfText	+= "<Br>This is system generated email after receipt of RFQ/Enquiry to the vendor , <B>Please DO NOT reply on this email ID as it is only for outgoing emails, & reply to this email is system prohibited.</B><br>";
		qcfText += "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";
		qcfText += "<br><b>*</b>This is electronically generated mail/document.Hence signature is not required.<br>";									
		
		ezc.ezcommon.EzLog4j.log("qcfText>>>"+qcfText,"I");		
		
		toEmailStr = getVendorMail(Session,dispSoldTo);
		ccEmailStr = getUserMail(Session,(String)Session.getUserId());
		ezc.ezcommon.EzLog4j.log("toEmailStr in Add Vendor>>>"+toEmailStr,"I"); 
		ezc.ezcommon.EzLog4j.log("ccEmailStr in Add Vendor>>>"+ccEmailStr,"I");  
		
		//MAIL
		boolean sendMailReq=sendMail(Session,toEmailStr,ccEmailStr,"",qcfText,msgQCFMailSubject);
		ezc.ezcommon.EzLog4j.log("sendMailReq>>>"+sendMailReq,"I");		
	}	
	
	
		
		
		

		
	
	
%>
<%@ include file="../../../Includes/JSPs/Misc/iblockcontrol.jsp" %>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Confirmation
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post">
<div class="panel">
	<div class="panel-heading"></div>
	<div class="panel-body"><%=retMessage%></div>
</div>
<div class="row no-print">
<div class="col-xs-12">
	<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;">Ok</button>  
</div>
</div>
</form>
</section>
</div><!-- /.content-wrapper -->
<%@ include file="../Misc/ezFooter.jsp"%>
<script>
function funOk()
{
	document.myForm.action="../RFQ/ezPrePRList.jsp?Status=R";
  	document.myForm.submit();
}
</script>
	







