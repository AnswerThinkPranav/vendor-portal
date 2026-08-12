
<%@ include file="../../../Includes/Lib/EzReverseAuctionBean.jsp"%>
<%@ page import="ezc.ezupload.params.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../../../Includes/JSPs/Request/iGetUploadTempDir.jsp" %>
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%
	String evalfactor=request.getParameter("evalfactor");
	String finallines=request.getParameter("finallines");
	String[] sellers=request.getParameterValues("chk2");
	String[] aliasname=request.getParameterValues("aliasname");
	String[] ratio=request.getParameterValues("ratio");
	Hashtable ht=new Hashtable();

	int count=0;
	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);

	ezc.ezreverseauction.params.EziAuctionHeaderParams addParams= (ezc.ezreverseauction.params.EziAuctionHeaderParams)session.getValue("sessionHeader");
	addParams.setNoItems(finallines);

	ezc.ezreverseauction.params.EziAuctionItemTable itemTable= (ezc.ezreverseauction.params.EziAuctionItemTable)session.getValue("sessionLines");
	ezc.ezreverseauction.params.EziAuctionItemTable finalItemTable= new ezc.ezreverseauction.params.EziAuctionItemTable();
	ezc.ezreverseauction.params.EziAuctionItemTableRow finalItemRow=null;
	count=itemTable.getRowCount();
	int itemcount=1;
	for(int i=0;i<count;i++)
	{

		EziAuctionItemTableRow itemRowParams=(EziAuctionItemTableRow)itemTable.getRow(i);
		finalItemRow=new ezc.ezreverseauction.params.EziAuctionItemTableRow();

		if(!"".equals(itemRowParams.getQuantity()))
		{
			finalItemRow.setItemId(""+itemcount);
			finalItemRow.setItemCode(itemRowParams.getItemCode());
			finalItemRow.setUOM(itemRowParams.getUOM());
			finalItemRow.setQuantity(itemRowParams.getQuantity());
//hard coded for time being
			finalItemRow.setTolerance(itemRowParams.getTolerance());
			finalItemRow.setReqStatus(itemRowParams.getReqStatus());
//end
			finalItemRow.setInitialPrice(itemRowParams.getInitialPrice());
			finalItemRow.setTargetPrice(itemRowParams.getTargetPrice());
			finalItemRow.setTargetShown(itemRowParams.getTargetShown());
			finalItemRow.setIncoTerms1(addParams.getIncoTerms());
			finalItemRow.setPaymentTerms(addParams.getPaymentTerms());

//hardcoded for time being

			finalItemRow.setFinalPrice(itemRowParams.getFinalPrice());
			finalItemRow.setMinVariance(itemRowParams.getMinVariance());
			finalItemRow.setMaxVariance(itemRowParams.getMaxVariance());
			finalItemRow.setVarianceType(itemRowParams.getVarianceType());

			finalItemRow.setIncoTerms2(itemRowParams.getIncoTerms2());

			finalItemRow.setIsSpecExist(itemRowParams.getIsSpecExist());
//end

			finalItemRow.setIsFileExist(itemRowParams.getIsFileExist());
			finalItemRow.setExt1("");

			finalItemRow.setExt2("");
			finalItemRow.setExt3("");
			finalItemTable.appendRow(finalItemRow);
			itemcount++;
		}


		if("Y".equals(itemRowParams.getIsFileExist()))
			ht.put(""+(i+1),itemRowParams.getExt1());


	}

	ezc.ezreverseauction.params.EziAuctionDeliverablesTable deliverablesTable=(ezc.ezreverseauction.params.EziAuctionDeliverablesTable)session.getValue("deliverables") ;
	ezc.ezreverseauction.params.EziAuctionSupplierTable supplierParams= new ezc.ezreverseauction.params.EziAuctionSupplierTable();
	ezc.ezreverseauction.params.EziAuctionSupplierTableRow supplierTabParams=null;
	for(int i=0;i<aliasname.length;i++)
	{
		if(!aliasname[i].equals(""))
		{
			supplierTabParams= new ezc.ezreverseauction.params.EziAuctionSupplierTableRow();
			supplierTabParams.setSupplierId(""+(i+1));
			supplierTabParams.setSupplierCode(sellers[i]);    //"US20";
			supplierTabParams.setSupplierAlias(aliasname[i]);

			if(ratio!=null && !ratio[i].equals(""))
				supplierTabParams.setEvalFactor(ratio[i]);

			else
				supplierTabParams.setEvalFactor("0");
			supplierTabParams.setGrantedRatio("0");
			supplierTabParams.setSplitIndicator("N");
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
		}
	}
	addMainParams.setObject(addParams);
	addMainParams.setObject(finalItemTable);
	addMainParams.setObject(deliverablesTable);
	addMainParams.setObject(supplierParams);
	addMainParams.setLocalStore("Y");
	Session.prepareParams(addMainParams);
	ReturnObjFromRetrieve retid=(ReturnObjFromRetrieve)EzReverseAuctionManager.addAuctionHeader(addMainParams);

	String auctionid=null;
	if(retid!=null)
	{
		auctionid=retid.getFieldValueString(0,"AUCTIONID");

		ezc.ezupload.params.EziDocumentTextsTable docTable =  (ezc.ezupload.params.EziDocumentTextsTable)session.getValue("longFields");
		ezc.ezupload.params.EziDocumentTextsTableRow docTableRow =  null;
		for(int i=0;i<docTable.getRowCount();i++)
		{
			docTableRow =  (ezc.ezupload.params.EziDocumentTextsTableRow)docTable.getRow(i);
			docTableRow.setDocNo(auctionid);
		}

		 addMainParams.setObject(docTable);
		 Session.prepareParams(addMainParams);
		 EzUploadManager.addDocumentText(addMainParams);

		ezc.ezupload.params.EziUploadDocsParams uploadParams= null;
		ezc.ezupload.params.EziUploadDocFilesTable tabParams= new ezc.ezupload.params.EziUploadDocFilesTable();
		ezc.ezupload.params.EziUploadDocFilesTableRow rowParams= null;
		String today=FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY);




			addMainParams = new ezc.ezparam.EzcParams(false);
			uploadParams= new ezc.ezupload.params.EziUploadDocsParams();
			uploadParams.setSysKey("999999");
			uploadParams.setObjectType("AUCTION");					// This key is added for identification of Schedules attachments
			String objno=auctionid;
			uploadParams.setObjectNo(objno);
			uploadParams.setStatus("");
			uploadParams.setCreatedOn(today);
			uploadParams.setCreatedBy("BUYER");
			uploadParams.setUploadDirectory(uploadTempDir+session.getId());
			addMainParams.setObject(uploadParams);

		if(ht.size()>0)
		{
			Enumeration enum=ht.keys();
			while(enum.hasMoreElements())
			{
				String key=(String)enum.nextElement();
				rowParams= new ezc.ezupload.params.EziUploadDocFilesTableRow();
				rowParams.setType(objno+key);
				rowParams.setClientFileName((String)ht.get(key));
				tabParams.appendRow(rowParams);
			}
				addMainParams.setObject(tabParams);
				Session.prepareParams(addMainParams);
				EzUploadManager.uploadDoc(addMainParams);
		}
	}

	session.removeValue("sessionHeader");
	session.removeValue("sessionLines");
	session.removeValue("deliverables");
	session.removeValue("longFields");
	session.removeValue("Suppliers");

	response.sendRedirect("ezConfirmSave.jsp?auctionid="+auctionid);
%>
