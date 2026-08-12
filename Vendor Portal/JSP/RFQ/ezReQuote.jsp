<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="ezc.ezparam.*,java.util.*" %>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />

<%
	EzcParams ezparams=new EzcParams(true);
	
	String rfqNum	=request.getParameter("PurchaseOrder"); 
	String rfqVendor = checkNull(request.getParameter("rfqVendor"));
	String QtnEndDt = checkNull(request.getParameter("QtnEndDate"));

	String Comments = request.getParameter("Comments");
	String retMsg = "Quotation Sent to  Vendor for Requote in portal";
	
	String [] rfqItems = request.getParameterValues("rfqItem");
	
	int totLines= 0;
	if(rfqItems!=null)
		totLines =rfqItems.length;
		ezc.ezcommon.EzLog4j.log("****==totLines iin Requote11====**"+totLines,"I");
		
	//RFQ EMAIL
	
	Hashtable<String,String> plantHT = getPlants(Session); 	
	
	String spaceCon ="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

	String eMailData="",eMailDataComm="";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ref. PR</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
	eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
	eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";		
	
	/***********Added to update status to R if requote***********/
	ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
	ezc.ezparam.EzcParams updateRFQParams	= new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderTable updateezirfqheadertable	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow updateezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();

	updateezirfqheadertablerow.setRFQNo(rfqNum);   
	updateezirfqheadertablerow.setStatus("R"); 
	updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
	updateezirfqheadertable.appendRow(updateezirfqheadertablerow);
	
	//DOC COMMENTS

	if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0)
	{
		Comments = Comments.replaceAll("'","`");   
		Comments = Comments.trim();
		eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
		java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
		queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+rfqNum+"','RFQ','"+Comments+"','"+Session.getUserId()+"',now())");
		ezMiscInsert(Session,queriesList);
	}	
	

	updateRFQParams.setObject(updateezirfqheadertable);
	updateRFQParams.setLocalStore("Y");
	Session.prepareParams(updateRFQParams);
	ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
	Object obj = Manager.ezUpdateRFQ(updateRFQParams);
	ezc.ezcommon.EzLog4j.log("****==After Update RFQ Details=====**","I");
	//response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);
	
	String rfqItem = "";
	String rfqLineItem= "";
	String rfqPlant="";
	String rfqPr="";
	String rfqPrItem="";
	String rfqMat="";
	String rfqMatDesc="";	
	String rfqItemQty="";
	String rfqUom="";	
	String rfqDelDt="";
	
	for (int i=0 ; i < totLines ; i++)  
	{
		rfqItem 	= rfqItems[i];	
		rfqLineItem	= checkNull(request.getParameter("rfItemNo"+rfqItem));  
		rfqPlant	= checkNull(request.getParameter("plant"+rfqItem));
		ezc.ezcommon.EzLog4j.log("****==totLines iin rfqPlant====**"+rfqPlant,"I");   
		rfqPr		= checkNull(request.getParameter("pr"+rfqItem));
		rfqPrItem 	= checkNull(request.getParameter("prItem"+rfqItem));
		rfqMat		= checkNull(request.getParameter("matNo"+rfqItem));
		ezc.ezcommon.EzLog4j.log("****==totLines iin rfqMat====**"+rfqMat,"I");
		rfqMatDesc	= checkNull(request.getParameter("matDesc"+rfqItem));	
		rfqItemQty	= checkNull(request.getParameter("rfqQty"+rfqItem));
		rfqUom  	= checkNull(request.getParameter("uom"+rfqItem));
		rfqDelDt	= checkNull(request.getParameter("delDate"+rfqItem));
		
		eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+plantHT.get(rfqPlant)+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+rfqLineItem+"</Td>";  
		eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
		eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDt+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+QtnEndDt+"</Td>"; 
		eMailData +=  "</Tr>";
	}
	eMailData +=  "</Table><Br>";		
%>
	<%@ include file="ezSendReQuoteMail.jsp" %> 
	
	<script>
		location.href="../Shipment/ezMessage.jsp?Msg=<%=retMsg%>";
	</script>
	
	