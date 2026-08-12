<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AuctionManager" class="ezc.ezreverseauction.client.EzReverseAuctionManager" scope="session"></jsp:useBean>
<jsp:useBean id="UploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.ezreverseauction.params.*" %>

<%

	String auctionId = request.getParameter("auctionId");
	String buyerId = request.getParameter("buyerId");
	out.println("buyerIdbuyerIdbuyerIdbuyerId	"+buyerId);
	out.println("auctionIdauctionIdauctionId	"+auctionId);
	String supplierCode = ((String)session.getValue("SOLDTO")).trim();
	String purchaseArea = (String)session.getValue("SYSKEY");
	String status = request.getParameter("status");
	String remarks = request.getParameter("remarks");
	String erpNo = "";
	EzcParams mainParams1 = new EzcParams(false);
	mainParams1.setLocalStore("Y");
	EziAuctionParams iParams = new EziAuctionParams();

	iParams.setAuctionId(auctionId);
	iParams.setSupplierCode(supplierCode);
	iParams.setStatus(status);

	if(remarks.trim().equals(""))
	{
		iParams.setReasonExists("N");
	}
	else
	{
		iParams.setReasonExists("Y");

		ezc.ezparam.EzcParams oParams = new ezc.ezparam.EzcParams(true);
		oParams.setLocalStore("Y");
		ezc.ezupload.params.EziDocumentTextsTable docTable =  new ezc.ezupload.params.EziDocumentTextsTable();
		ezc.ezupload.params.EziDocumentTextsTableRow docTableRow =  null;

		docTableRow =  new ezc.ezupload.params.EziDocumentTextsTableRow();
		docTableRow.setDocType("SELLERREMARKS");
		docTableRow.setDocNo(auctionId+supplierCode);
		docTableRow.setSysKey(purchaseArea);
		docTableRow.setKey("REMARKS");
		docTableRow.setValue(remarks);
	   	docTable.appendRow(docTableRow);

	   	oParams.setObject(docTable);
		Session.prepareParams(oParams);
	   	UploadManager.addDocumentText(oParams);
	}
	
	mainParams1.setObject(iParams);
	Session.prepareParams(mainParams1);

	AuctionManager.acknowledgeAuction(mainParams1);
	Hashtable mailData = new Hashtable();
	String msgType = "";
	if("A".equals(status))
		msgType = "AUCTACK";
	else
		msgType = "AUCTREJ";
		
	boolean sendToExt = true ;  
	boolean isVendor  = true;
	erpNo = supplierCode;
	
%>	
	<%@ include file="ezGetIdByENo.jsp"%>

<%	
	supplierCode = retMailId.getFieldValueString(0,"ID");
	//if(buyerId!=null && !"null".equals(buyerId.trim()))
		//auctionId=auctionId+"¥"+buyerId;
		
	mailData.put(supplierCode,auctionId+"¤"+buyerId);
			
	
%>		
		<%//@include file="../Purorder/ezSendMailCounter.jsp"%>
	
<%
	response.sendRedirect("ezListAuctionRequests.jsp?type=New");

%>

