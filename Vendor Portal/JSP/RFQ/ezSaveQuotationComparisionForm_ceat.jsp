<%@ include file="../Misc/ezVendHeader.jsp"%> 
<%@ page import ="ezc.ezparam.*,java.util.*,java.text.*" %> 
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<%
	EzcParams ezparams=new EzcParams(true);
	EzShipmentManager shManager=new EzShipmentManager();
	String Comments = request.getParameter("comment");
	String qcfNo = request.getParameter("qcfNo");
	String chkVal = checkNull(request.getParameter("chkVal"));
	String rank = request.getParameter("rank");
	//String reason = request.getParameter("reason"); 
	int chkLen=0;
	if(!"".equals(chkVal))
	{
	chkLen=chkVal.split(",").length;
	}
	ezc.ezcommon.EzLog4j.log("chkVal>>>>>"+chkVal+">>rank>"+rank+"<<chkLen>>"+chkLen,"I");
	
	
	
	String rfqItems[]	= request.getParameterValues("rfqItem");	
	int rfqItemsCnt = 0;
	int rfqQtyCnt = 0;
	
	if(rfqItems!=null)
	{
		rfqItemsCnt = rfqItems.length/2;
		rfqQtyCnt = rfqItems.length;
	}	
		
	ezc.ezcommon.EzLog4j.log("rfqItemsCnt=====**"+rfqItemsCnt,"I");	
	ezc.ezcommon.EzLog4j.log("rfqQtyCnt=====**"+rfqQtyCnt,"I");	
	
	String selRfq 		= "";
	String rfqItem	 	= "";
	String rfqVen 		= "";
	String selVen 		= "";
	String hReason 		= "";
	String hRank 		= "";
	String hTxt 		= "";
	String fTxt 		= "";
	String iTxt 		= "";
	String bStatus		= "";
	
	String qtyRec		="";
	

	
	String retMsg = "QCF Approved in Portal";

	/***********Added to update status to S if Selected***********/
	ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
	ezc.ezparam.EzcParams updateRFQParams	= new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderTable updateezirfqheadertable	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow updateezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();

	ezc.ezpreprocurement.params.EziRFQItemQtyTable      updateezirfqqtystable = new ezc.ezpreprocurement.params.EziRFQItemQtyTable();
	ezc.ezpreprocurement.params.EziRFQItemQtyTableRow   updateezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();		
	
	//BOT CHANGES
	for(int i=0;i<rfqItemsCnt;i++)
	{
		
		selRfq	= checkNull(request.getParameter("selRfq"+i));	
		rfqVen	= checkNull(request.getParameter("rfqVen"+i));	
		selVen	= checkNull(request.getParameter("selVen"+i));
		hReason	= checkNull(request.getParameter("reason"+i));
		hRank	= checkNull(request.getParameter("rank"+i));
		hTxt	= checkNull(request.getParameter("hTxt"+i));
		fTxt	= checkNull(request.getParameter("fTxt"+i));
		iTxt	= checkNull(request.getParameter("iTxt"+i));
		
		ezc.ezcommon.EzLog4j.log("selRfq=====**"+selRfq,"I");
		ezc.ezcommon.EzLog4j.log("loop=====**"+i,"I");	
		ezc.ezcommon.EzLog4j.log("rfqVen=====**"+rfqVen,"I");	
		ezc.ezcommon.EzLog4j.log("selVen=====**"+selVen,"I");
		ezc.ezcommon.EzLog4j.log("hReason=====**"+hReason,"I");
		ezc.ezcommon.EzLog4j.log("hRank=====**"+hRank,"I");	
		ezc.ezcommon.EzLog4j.log("hTxt=====**"+hTxt,"I");	
		ezc.ezcommon.EzLog4j.log("fTxt=====**"+fTxt,"I");		
		ezc.ezcommon.EzLog4j.log("iTxt=====**"+iTxt,"I");
		
		
		if("R".equals(selVen))
			bStatus="S";
		else
			bStatus="Y";
			
		if(!"R".equals(selVen))
			selVen="N";
		
		updateezirfqheadertablerow.setRFQNo(selRfq); 
		updateezirfqheadertablerow.setStatus(""+bStatus+"',ERH_RANK_STATUS='"+selVen+"',ERH_RANK='"+hRank+"',ERH_REASON='"+hReason);   
		updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
		updateezirfqheadertable.appendRow(updateezirfqheadertablerow);
		
		for(int j=0;j<rfqItemsCnt;j++)
		{
			rfqItem = ((j+1)*10)+"";
			ezc.ezcommon.EzLog4j.log("rfqItem=====**"+rfqItem,"I");
			qtyRec	= checkNull(request.getParameter("rfqQty"+selRfq+((j+1)*10)));
			ezc.ezcommon.EzLog4j.log("qtyRec=====**"+qtyRec,"I");

			updateezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();		
			updateezirfqqtystablerow.setRemarks("test',ERD_PO_QTY='"+qtyRec);
			updateezirfqqtystablerow.setRFQNo(selRfq);
			updateezirfqqtystablerow.setItmNo(rfqItem);
			updateezirfqqtystable.appendRow(updateezirfqqtystablerow);	

		}
		try
		{
			updateRFQParams.setObject(updateezirfqheadertable);
			updateRFQParams.setObject(updateezirfqqtystable);
			updateRFQParams.setLocalStore("Y");
			Session.prepareParams(updateRFQParams);
			ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
			Manager.ezUpdateRFQ(updateRFQParams);
			ezc.ezcommon.EzLog4j.log("****==After Update RFQ Details=====**","I");		
		}
		catch(Exception e)	
		{

		}
	}
	
	//RFQ EMAIL

	Hashtable<String,String> plantHT = getPlants(Session); 	 
	
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

	String eMailData="",eMailDataComm="";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ceat PR Reference</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
	eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
	eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
	eMailData +=  "</Tr>";	
	
	String qryRfq="";
	ezc.ezparam.ReturnObjFromRetrieve rfqObj	  =	null;	
	
	String rfqPlant="";
	String rfqLineItem= "";
	String tempPr="";
	String rfqPr="";
	String rfqPrItem="";
	String tempMat="";
	String rfqMat="";
	String rfqMatDesc="";	
	String rfqItemQty="";
	String rfqUom="";
	String rfqDelDt="";
	String rfqQtnDt="";
	String rfqVendor="";
	String rfqDelDtDisp;
	String rfqQtnDtDisp;
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
	SimpleDateFormat formatter1 = new SimpleDateFormat("dd/MM/yyyy");
	
	for(int k=0;k<chkLen;k++)
	{
		String rfqNumber = chkVal.split(",")[k].split("#")[0];
		ezc.ezcommon.EzLog4j.log("rfqNumber>>>"+rfqNumber,"I"); 
		
		ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
		ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		
		qryRfq="SELECT *,ERH_SOLD_TO,ERH_VALID_UPTO FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS WHERE ERH_RFQ_NO=ERD_RFQ_NO AND ERD_RFQ_NO='"+rfqNumber+"'" ;
		
		ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");
		
		qcfTableRow.setQuery(qryRfq);
		qcfTable.appendRow(qcfTableRow);
		qcfParams.setLocalStore("Y");
		qcfParams.setObject(qcfTable);
		Session.prepareParams(qcfParams);
	
		try
		{
			rfqObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMgr.ezGetMiscTransactions(qcfParams);

		}
		catch(Exception e)
		{
			out.println("Exception in getting RFQ List>>>>>"+e);
		}	
		ezc.ezcommon.EzLog4j.log("rfqObj>>>>"+rfqObj.toEzcString(),"I");
	
		int rfqLinesCnt = rfqObj.getRowCount();
		Date date1 = new Date();

		for(int j=0;j<rfqLinesCnt;j++)
		{
			rfqPlant= rfqObj.getFieldValueString(j,"ERD_PLANT");
			tempPr= rfqObj.getFieldValueString(j,"ERD_EXT1");
			if("RFQ".equals(tempPr))
			{
				rfqPr="N/A";
				rfqPrItem="N/A";
			}
			else
			{
				rfqPr = tempPr.split("¥")[0];
				rfqPrItem= tempPr.split("¥")[1];
			}	
			rfqLineItem= rfqObj.getFieldValueString(j,"ERD_LINE_NO");
			tempMat= rfqObj.getFieldValueString(j,"ERD_MATERIAL");
			try
			{
				rfqMat = Long.parseLong(tempMat)+"";
			}
			catch(Exception  e)
			{
				rfqMat=tempMat;
			}
			rfqMatDesc= rfqObj.getFieldValueString(j,"ERD_MATERIAL_DESC");
			rfqUom= rfqObj.getFieldValueString(j,"ERD_UOM");
			rfqItemQty= rfqObj.getFieldValueString(j,"ERD_QUANTITY");
			rfqDelDt= rfqObj.getFieldValueString(j,"ERD_DELIVERY_DATE");
			date1 = formatter.parse(rfqDelDt);
			rfqDelDtDisp = formatter1.format(date1);	
			
			rfqQtnDt= rfqObj.getFieldValueString(j,"ERH_VALID_UPTO");
			date1 = formatter.parse(rfqQtnDt);
			rfqQtnDtDisp = formatter1.format(date1);
			
			rfqVendor= rfqObj.getFieldValueString(j,"ERH_SOLD_TO"); 


			eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+plantHT.get(rfqPlant)+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+rfqLineItem+"</Td>";  
			eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
			eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>"; 
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDtDisp+"</Td>"; 
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqQtnDtDisp+"</Td>";
			eMailData +=  "</Tr>";	

		}
		eMailData +=  "</Table><Br>";
		ezc.ezcommon.EzLog4j.log("::::::Comments::::::::::::"+Comments,"I");

		//DOC COMMENTS
		if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0) 
		{
			saveDocComments(Session,qcfNo,"QCF",Comments); 
			eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
		}	

%>
		<%@ include file="ezPOApprovalMail.jsp"%>    
<%	
	}
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);

%>
