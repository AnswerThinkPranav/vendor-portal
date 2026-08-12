<%@ include file="../../../Includes/Lib/EzReverseAuctionBean.jsp"%>
<%@ page import="ezc.ezupload.params.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ page import = "java.util.*,java.nio.file.*,java.io.*"%>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%//@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%>  
<%//@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<html>
<head>
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>
<body scroll=no>
<%
	String display_header = "Create Auction";
	
	
%>

<%@ include file="../Misc/ezSubHeader.jsp"%>		
<%
	String noDataStatement = "Unable to create the Auction. Please try to create again.<BR>If not able create again, Please contact portal administrator";
	ResourceBundle timeLagRB = ResourceBundle.getBundle("ezRaParameters");
	String timeLag	= timeLagRB.getString("TimeLag");
	Hashtable fileHash = new Hashtable();

	// Header 
	String selQcfNo    	= request.getParameter("selQcfNo");
	String auctionname    	= request.getParameter("auctionname");
	String buyername      	= request.getParameter("buyername");
	String evaluationtype 	= request.getParameter("evaluationtype");
	String startdate	= request.getParameter("startdate");
	String enddate		= request.getParameter("enddate");
	String extensiontime	= request.getParameter("exttime");
	String extensions	= request.getParameter("noofext");
	String autoExtTime	= request.getParameter("autoExtTime");
	String minbidvariance	= request.getParameter("minbidvar");
	//String maxbidvariance	= request.getParameter("maxbidvar");
	String bidvariancetype	= request.getParameter("bidvariancetype");
	String delterms		= request.getParameter("delterms");
	String paymentterms	= request.getParameter("paymentterms");
	String noofitems	= request.getParameter("noofitems");
	String currency		= request.getParameter("currency");
	String packing		= request.getParameter("packing");
	String inspection	= request.getParameter("inspection");
	String label		= request.getParameter("label");
	String handling		= request.getParameter("handling");
	String regulatory	= request.getParameter("regulatory");
	String documents	= request.getParameter("documents");
	String others		= request.getParameter("others");
	String modeOfTrans		= request.getParameter("modeOfTrans");
	String auctionType		= request.getParameter("auctionType");
	String maxbidvariance	= "0";
	String selPlant	= request.getParameter("selPlant");
	String selCategory	= request.getParameter("selCategory");
	
	if(noofitems==null || "".equals(noofitems) || "null".equals(noofitems))
		noofitems="0";
	if(selQcfNo==null || "".equals(selQcfNo) || "null".equals(selQcfNo))
		selQcfNo="";
	
	
	// Lines
	String pricestatus	= request.getParameter("pricestatus");
	String[] materialname	= request.getParameterValues("materialname");
	String[] matCode	= request.getParameterValues("matCode");
	String[] attachment	= request.getParameterValues("attachment");
	String[] serverfilename	= request.getParameterValues("serverfile");
	String[] deliverables	= request.getParameterValues("deliverables");
	String[] uom		= request.getParameterValues("uom");
	String[] qty		= request.getParameterValues("qty");
	String[] startprice	= request.getParameterValues("startprice");
	String[] budgetprice	= request.getParameterValues("budgetprice");
	String[] reserveprice	= request.getParameterValues("reserveprice");
	String[] drlRemarks	= request.getParameterValues("drlRemarks");
	String[] drlPRNum	= request.getParameterValues("drlPRNum");
	String[] drlPRItem	= request.getParameterValues("drlPRItem");
	
	// Suppliers
	String finallines	= materialname.length+"";
	String[] sellers	= request.getParameterValues("chk2");
	String[] aliasname	= request.getParameterValues("aliasname");
	String[] vendname	= request.getParameterValues("vendName");
	String[] vendType	= request.getParameterValues("vendType");
	String[] ratio		= request.getParameterValues("ratio");
	
	
	auctionname	= auctionname.replace('\'','`');
	buyername	= buyername.replace('\'','`');
	
	if(minbidvariance==null || "null".equals(minbidvariance) || "".equals(minbidvariance))
			minbidvariance="0";
	if(autoExtTime==null || "null".equals(autoExtTime) || "".equals(autoExtTime))
			autoExtTime="0";
			
		
	
	ezc.ezparam.EzcParams addMainParamsAuct = new ezc.ezparam.EzcParams(false);
	
	ezc.ezreverseauction.params.EziAuctionHeaderParams addParams= new ezc.ezreverseauction.params.EziAuctionHeaderParams();
	addParams.setNoItems(finallines);
	addParams.setAuctionName(auctionname);
	addParams.setBuyerId(Session.getUserId());
	addParams.setBuyerName(buyername);
	addParams.setAuctionType(auctionType);
	addParams.setEvalType(evaluationtype);
	addParams.setStartDate(startdate);
	addParams.setEndDate(enddate);
	addParams.setExtensionTime(extensiontime);
	addParams.setExtensions(extensions);
	addParams.setTimeLag(timeLag);
	addParams.setMinBidVariance(minbidvariance);
	addParams.setMaxBidVariance(maxbidvariance);
	addParams.setVarianceType(bidvariancetype);
	addParams.setAcknowledgeType("A");
	addParams.setPaymentTerms(paymentterms);
	addParams.setIncoTerms(delterms);
	addParams.setAuctionStatus("N");
	addParams.setNoItems(noofitems);
	addParams.setCurrency(currency);
	addParams.setTargetValue("0");
	addParams.setStartValue("0");
	addParams.setFinalValue("0");
	if(!(("".equals(packing) || "".equals(label) || "".equals(inspection) || "".equals(handling) || "".equals(regulatory) || "".equals(documents) || "".equals(others))))
		addParams.setRulesExist("Y");
	else
		addParams.setRulesExist("N");
	addParams.setUploadFiles("N");
	addParams.setPhone1("0");
	addParams.setPhone2("0");
	addParams.setPhone3("0");
	addParams.setFlag1("Y");
	addParams.setFlag2("N");
	addParams.setExt1(autoExtTime);
	addParams.setExt2(modeOfTrans);
	addParams.setExt3(selQcfNo);	
	addParams.setPlant(selPlant);
	addParams.setCategory(selCategory);
	
	ezc.ezreverseauction.params.EziAuctionItemTable itemTable = new ezc.ezreverseauction.params.EziAuctionItemTable();
	ezc.ezreverseauction.params.EziAuctionItemTableRow itemTableRow= null;
	for(int i=0;i<materialname.length;i++)
	{
		
		uom[i]=uom[i].replace('\'','`');
		drlRemarks[i]=drlRemarks[i].replaceAll("'","`");
		materialname[i]=materialname[i].replaceAll("'","`");
		materialname[i]=materialname[i].trim();
		
		if(startprice[i]==null || "null".equals(startprice[i]) || "".equals(startprice[i]))
			startprice[i]="0";
		if(budgetprice[i]==null || "null".equals(budgetprice[i]) || "".equals(budgetprice[i]))
			budgetprice[i]="0";
		
		if(!"".equals(qty[i]))
		{
			
			itemTableRow= new ezc.ezreverseauction.params.EziAuctionItemTableRow();
			itemTableRow.setItemId(""+(i+1));
			itemTableRow.setItemCode(materialname[i]);
			itemTableRow.setMaterial(matCode[i]);
			itemTableRow.setUOM(uom[i]);
			itemTableRow.setQuantity(qty[i]);
			itemTableRow.setTolerance("1");
			itemTableRow.setReqStatus("Y");
			itemTableRow.setInitialPrice(startprice[i]);
			itemTableRow.setBudgetPrice(budgetprice[i]);
			if(!reserveprice[i].equals(""))
				itemTableRow.setTargetPrice(reserveprice[i]);
			else
				itemTableRow.setTargetPrice("0");
			if(pricestatus==null || "null".equals(pricestatus))
				itemTableRow.setTargetShown("Y");
			else
				itemTableRow.setTargetShown(pricestatus);
			itemTableRow.setFinalPrice("0");
			itemTableRow.setMinVariance(minbidvariance);
			itemTableRow.setMaxVariance(maxbidvariance);
			itemTableRow.setVarianceType(bidvariancetype);
			itemTableRow.setIncoTerms1("IT1");
			itemTableRow.setIncoTerms2("IT2");
			itemTableRow.setPaymentTerms(paymentterms);
			
			//if(!attachment[i].equals(""))
			if(false)
			{
				
				itemTableRow.setIsSpecExist("Y");
				itemTableRow.setIsFileExist("Y");
				itemTableRow.setExt1(drlPRNum[i]);
				itemTableRow.setExt2(drlPRItem[i]);
				fileHash.put(""+(i+1),attachment[i]);
				
				
			}
			else
			{
				itemTableRow.setIsSpecExist("N");
				itemTableRow.setIsFileExist("N");
				itemTableRow.setExt1(drlPRNum[i]);
				itemTableRow.setExt2(drlPRItem[i]);
			}
			//itemTableRow.setExt3("");
			itemTableRow.setExt3(drlRemarks[i]);
			
			
			itemTable.appendRow(itemTableRow);
		}
	}	
	
	ezc.ezreverseauction.params.EziAuctionDeliverablesTable deliverablesTable = new ezc.ezreverseauction.params.EziAuctionDeliverablesTable();
	ezc.ezreverseauction.params.EziAuctionDeliverablesTableRow deliverablesTableRow = null;
	int count=1;
	String quantity = "";
	String reqdDate = "";
	for(int i=0;i<materialname.length;i++)
	{
		int delcount=1;
		if(!qty[i].equals(""))
		{
			StringTokenizer st=new StringTokenizer(deliverables[i],"~");
			while(st.hasMoreElements())
			{
				deliverablesTableRow= new ezc.ezreverseauction.params.EziAuctionDeliverablesTableRow();
				String completestr=(String)st.nextToken();
				StringTokenizer st1=new StringTokenizer(completestr,"*");
				while(st1.hasMoreElements())
				{
					
					//('03/13/2007','DD.MM.YYYY HH24:MI:SS'),10.000,'','','')
					quantity = (String)st1.nextToken();
					reqdDate = (String)st1.nextToken();
					/*
					StringTokenizer dateToken = new StringTokenizer(reqdDate,"/");
					String month = dateToken.nextToken()+"";
					String date  = dateToken.nextToken()+"";
					String year  = dateToken.nextToken()+"";
					String dateStr = date+"/"+month+"/"+year;
					*/
					deliverablesTableRow.setItemId(""+count);
					deliverablesTableRow.setDeliveryLine(""+delcount);
					deliverablesTableRow.setRequiredQuantity(quantity);
					deliverablesTableRow.setRequiredDate(reqdDate);
					deliverablesTableRow.setExt1("");
					deliverablesTableRow.setExt2("");
					deliverablesTableRow.setExt3("");

				}
				delcount++;
				deliverablesTable.appendRow(deliverablesTableRow);
			}
			count++;
		}
	}	
	
	ezc.ezreverseauction.params.EziAuctionSupplierTable supplierParams = new ezc.ezreverseauction.params.EziAuctionSupplierTable();
	ezc.ezreverseauction.params.EziAuctionSupplierTableRow supplierTabParams = null;
	for(int i=0;i<aliasname.length;i++)
	{
		if(!aliasname[i].equals(""))
		{
			supplierTabParams= new ezc.ezreverseauction.params.EziAuctionSupplierTableRow();
			supplierTabParams.setSupplierId(""+(i+1));
			supplierTabParams.setSupplierCode(sellers[i]);
			supplierTabParams.setSupplierAlias(aliasname[i]);

			if(ratio!=null && !ratio[i].equals(""))
				supplierTabParams.setEvalFactor(ratio[i]);

			else
			supplierTabParams.setEvalFactor("0");
			supplierTabParams.setGrantedRatio("0");
			supplierTabParams.setSplitIndicator("N");
			supplierTabParams.setAcknowledgedDate("");
			supplierTabParams.setAcknowledgeStatus("A");
			supplierTabParams.setReasonExists("N");
			supplierTabParams.setInitialQuote("0");
			supplierTabParams.setFinalQuote("0");
			supplierTabParams.setFinalRanking("0");
			supplierTabParams.setExt1(vendname[i]);
			supplierTabParams.setExt2(vendType[i]);
			supplierTabParams.setExt3("");
			supplierParams.appendRow(supplierTabParams);
		}
	}	
	
	addMainParamsAuct.setObject(addParams);
	addMainParamsAuct.setObject(itemTable);
	addMainParamsAuct.setObject(deliverablesTable);
	addMainParamsAuct.setObject(supplierParams);
	addMainParamsAuct.setLocalStore("Y");
	Session.prepareParams(addMainParamsAuct);
	ReturnObjFromRetrieve retid = (ReturnObjFromRetrieve)EzReverseAuctionManager.addAuctionHeader(addMainParamsAuct);
	
	String auctionid=null;
	if(retid!=null)
	{
		auctionid=retid.getFieldValueString(0,"AUCTIONID");

		String purchaseArea = (String)session.getValue("SYSKEY");
		java.util.Hashtable docHash = new java.util.Hashtable();
		docHash.put("PACKING",packing);
		docHash.put("INSPECTION",inspection);
		docHash.put("LABEL",label);
		docHash.put("HANDLING",handling);
		docHash.put("REGULATORY",regulatory);
		docHash.put("DOCUMENTS",documents);
		docHash.put("OTHERS",others);


		ezc.ezupload.params.EziDocumentTextsTable docTable =  new ezc.ezupload.params.EziDocumentTextsTable();
		ezc.ezupload.params.EziDocumentTextsTableRow docTableRow =  null;

		String documentStr = "";
		Enumeration hashEnum = docHash.keys();
		while(hashEnum.hasMoreElements())
		{
			documentStr = (String)hashEnum.nextElement();

			docTableRow =  new ezc.ezupload.params.EziDocumentTextsTableRow();
			docTableRow.setDocType("AUCTION");
			docTableRow.setDocNo(auctionid);
			docTableRow.setSysKey(purchaseArea);
			docTableRow.setKey(documentStr);
			docTableRow.setValue((String)docHash.get(documentStr));
			docTable.appendRow(docTableRow);
		}	
		addMainParamsAuct.setObject(docTable);
		Session.prepareParams(addMainParamsAuct);
		EzUploadManager.addDocumentText(addMainParamsAuct);
		//uploads start
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		for(int i=0;i<materialname.length;i++)
		{
			int fileItemIndex = (i+1);
			String fileItem[]	= request.getParameterValues("fileItem"+fileItemIndex); 
			int fileLength = 0;
			if(fileItem != null)
				fileLength = fileItem.length;

			if(fileLength > 0)
			{
				String subDirPath = "AUCTION"+"\\"+auctionid+"\\"+fileItemIndex+"\\";
				String dirPath  = serverUpPath+subDirPath;
				String sessionId = session.getId()+"";
				Path path = Paths.get(dirPath);
				Files.createDirectories(path);
				for(int j=0;j<fileItem.length;j++)
				{
					try
					{
						String fileName = fileItem[j];	
						File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
						File notifDestFile = new File(dirPath+fileName);			
						FileInputStream inStream = new FileInputStream(notifSourceFile);
						FileOutputStream outStream = new FileOutputStream(notifDestFile);
						byte[] buffer = new byte[1024];
						int length;
						//copy the file content in bytes 
						while ((length = inStream.read(buffer)) > 0)
						{
							outStream.write(buffer, 0, length);
						}
						inStream.close();
						outStream.close();
						notifSourceFile.delete();		
						ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
						miscTableRow.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+auctionid+"','"+fileItemIndex+"','AUCTION','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
						miscTable.appendRow(miscTableRow);
					}catch(Exception e)
					{
					}
				}
			}
		}
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try
		{
		miscMgr.ezSaveMiscTransactions(mainParams);

		}
		catch(Exception e)
		{
		}

		//uploads end
		
		
		/*
		ezc.ezupload.params.EziUploadDocsParams uploadParams= null;
		ezc.ezupload.params.EziUploadDocFilesTable tabParams= new ezc.ezupload.params.EziUploadDocFilesTable();
		ezc.ezupload.params.EziUploadDocFilesTableRow rowParams= null;
		String today=FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY);
				
		
		for(int i=0;i<serverfilename.length;i++)
		{
		
			addMainParamsAuct = new ezc.ezparam.EzcParams(false);
			uploadParams= new ezc.ezupload.params.EziUploadDocsParams();
			uploadParams.setSysKey("");
			uploadParams.setObjectType("AUCTION");
			uploadParams.setObjectNo(auctionid);
			uploadParams.setStatus("");
			uploadParams.setCreatedOn(today);
			uploadParams.setCreatedBy("BUYER");
			uploadParams.setUploadDirectory(serverfilename[i]);
			
			rowParams= new ezc.ezupload.params.EziUploadDocFilesTableRow();
			rowParams.setType(auctionid);
			rowParams.setClientFileName(attachment[i]);
			tabParams.appendRow(rowParams);
			addMainParamsAuct.setObject(uploadParams);
			addMainParamsAuct.setObject(tabParams);
			Session.prepareParams(addMainParamsAuct);
			EzUploadManager.uploadDoc(addMainParamsAuct);
		}
		*/
		/*
		if(fileHash.size()>0)
		{
			Enumeration fileEnum=fileHash.keys();
			while(fileEnum.hasMoreElements())
			{
				String key=(String)fileEnum.nextElement();
				rowParams= new ezc.ezupload.params.EziUploadDocFilesTableRow();
				rowParams.setType(auctionid+key);
				rowParams.setClientFileName((String)fileHash.get(key));
				tabParams.appendRow(rowParams);
			}
			addMainParamsAuct.setObject(tabParams);
			Session.prepareParams(addMainParamsAuct);
			EzUploadManager.uploadDoc(addMainParamsAuct);
		}
		*/
	     
		noDataStatement = "Auction <strong>"+auctionname+"</strong> created successfully with reference number : <a href='ezViewMainAuctionRequest.jsp?auctionId="+auctionid+"&status=N&auctionName="+auctionname+"'>"+auctionid+"</a>";
	}	
	
%>
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">	    

<div class="alert alert-success">
<%=noDataStatement%>
</div>

</div>
</div>
</div>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

</html>
