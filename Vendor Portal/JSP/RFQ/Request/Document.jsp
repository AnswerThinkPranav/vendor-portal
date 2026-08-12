<%@ include file="../../../Includes/Lib/EzReverseAuctionBean.jsp"%>
<%@ page import="ezc.ezupload.params.*" %>
<%@ page import="ezc.ezreverseauction.params.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../../../Includes/JSPs/Request/iGetUploadTempDir.jsp" %>
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);

	EziAuctionHeaderParams addParams= new EziAuctionHeaderParams();
	addParams.setAuctionName("AN");
	addParams.setBuyerId("1");
	addParams.setBuyerName("BUYER");
	addParams.setAuctionType("R");
	addParams.setEvalType("E");
	addParams.setStartDate("05.05.2003");
	addParams.setEndDate("05.05.2003");
	addParams.setExtensionTime("15");
	addParams.setExtensions("2");
	addParams.setTimeLag("15");
	addParams.setMinBidVariance("2");
	addParams.setMaxBidVariance("5");
	addParams.setVarianceType("P");
	addParams.setAcknowledgeType("A");
	addParams.setPaymentTerms("PT");
	addParams.setIncoTerms("IT");
	addParams.setAuctionStatus("E");
	addParams.setNoItems("2");
	addParams.setCurrency("INR");
	addParams.setTargetValue("18000");
	addParams.setStartValue("25000");
	addParams.setFinalValue("17000");
	addParams.setRulesExist("N");
	addParams.setUploadFiles("N");
	addParams.setPhone1("'"+27846201+"'");
	addParams.setPhone2("'"+27846201+"'");
	addParams.setPhone3("'"+27846201+"'");
	addParams.setFlag1("N");
	addParams.setFlag2("N");
	addParams.setExt1("E1");
	addParams.setExt2("E2");
	addParams.setExt3("E3");
	addParams.setAuctionId("100054");
/*	
	EziAuctionItemTable finalItemTable= new EziAuctionItemTable();
	EziAuctionItemTableRow finalItemRow= new EziAuctionItemTableRow();

	finalItemRow.setItemId("'"+1+"'");
	finalItemRow.setItemCode("123");
	finalItemRow.setUOM("KG");
	finalItemRow.setQuantity("100");
	finalItemRow.setTolerance("1");
	finalItemRow.setReqStatus("R");
	finalItemRow.setInitialPrice("18000");
	finalItemRow.setTargetPrice("17000");
	finalItemRow.setTargetShown("Y");
	finalItemRow.setIncoTerms1("IT1");
	finalItemRow.setPaymentTerms("PT1");
	finalItemRow.setFinalPrice("20000");
	finalItemRow.setMinVariance("2");
	finalItemRow.setMaxVariance("5");
	finalItemRow.setVarianceType("P");
	finalItemRow.setIncoTerms2("IT2");
	finalItemRow.setIsSpecExist("N");
	finalItemRow.setIsFileExist("N");
	finalItemRow.setExt1("");
	finalItemRow.setExt2("");
	finalItemRow.setExt3("");
	finalItemTable.appendRow(finalItemRow);
*/


	//EziAuctionDeliverablesTable deliverablesTable= new EziAuctionDeliverablesTable();
	
	EziAuctionSupplierTable supplierParams= new EziAuctionSupplierTable();
	
	EziAuctionSupplierTableRow supplierTabParams= new EziAuctionSupplierTableRow ();

	supplierTabParams.setSupplierId("1");
	supplierTabParams.setSupplierCode("US20");    //"US20";
	supplierTabParams.setSupplierAlias("Aliasname1");
	supplierTabParams.setEvalFactor("E");
	supplierTabParams.setGrantedRatio("0");
	supplierTabParams.setSplitIndicator("Y");
	supplierTabParams.setAcknowledgedDate("");
	supplierTabParams.setAcknowledgeStatus("N");
	supplierTabParams.setReasonExists("N");
	supplierTabParams.setInitialQuote("0");
	supplierTabParams.setFinalQuote("0");
	supplierTabParams.setFinalRanking("0");
	supplierTabParams.setExt1("");
	supplierTabParams.setExt2("");
	supplierTabParams.setExt3("");
	supplierParams.appendRow(supplierTabParams);

	addMainParams.setObject(addParams);
	//addMainParams.setObject(finalItemTable);	
	addMainParams.setObject(supplierParams);		
	addMainParams.setLocalStore("Y");
	Session.prepareParams(addMainParams);

	//ReturnObjFromRetrieve retid=(ReturnObjFromRetrieve)
	EzReverseAuctionManager.updateAuction(addMainParams);

%>
