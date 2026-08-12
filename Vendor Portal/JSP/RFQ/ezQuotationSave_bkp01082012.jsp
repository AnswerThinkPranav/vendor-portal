<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ page import ="ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*,java.text.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %> 




<%
	String userType = (String)session.getValue("UserType");	
	String fdate		= (String) session.getValue("DATEFORMAT");
	
	String conditionsString = null;
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();

	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	     = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams ezcparams				     		     = new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderTable ezirfqheadertable 	     = new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow ezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();
	ezc.ezpreprocurement.params.EziRFQDetailsTable ezirfqdetailstable 	     = new ezc.ezpreprocurement.params.EziRFQDetailsTable();
	ezc.ezpreprocurement.params.EziRFQDetailsTableRow ezirfqdetailstablerow = null;
	ezc.ezpreprocurement.params.EziRFQHeaderParams	headerParams	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezc.ezpreprocurement.params.EziRFQItemQtyTable  qtyTable	= new ezc.ezpreprocurement.params.EziRFQItemQtyTable();
	ezc.ezpreprocurement.params.EziRFQItemQtyTableRow qtyTableRow	= null;
	ezc.ezpreprocurement.params.EziRFQItemServiceTable  serTable	= new ezc.ezpreprocurement.params.EziRFQItemServiceTable();
	ezc.ezpreprocurement.params.EziRFQItemServiceTableRow serTableRow = null;
	
	
	 
	
	ezc.ezpreprocurement.params.EziAuditTrailTable eziaudittable = new ezc.ezpreprocurement.params.EziAuditTrailTable();
  	ezc.ezpreprocurement.params.EziAuditTrailTableRow 	eziaudittablerow 	= null;	
  	
  	 String purchOrg    = (String)Session.getUserPreference("PURORG");
    	 String purGrp  	   = (String)Session.getUserPreference("PURGROUP");
    	 String auditStr = "Quotation has been posted";

	EzcParams ezparams=new EzcParams(true);
	
	String reQtFlg		= request.getParameter("reQtFlg");
	
	System.out.println("+++++++++++++reQtFlg+++++++++++++"+reQtFlg);

	String QtnDt 	        = request.getParameter("QtnDate");
	String priceValExpDate 	= request.getParameter("priceValExpDate");
	String remarks 		= request.getParameter("Remarks");
	String fromoffline 	= request.getParameter("fromoffline");
	String orderUnit	= request.getParameter("orderUnit");
	String OldCur	= request.getParameter("OldCur");
	String rfqVend= request.getParameter("rfqVendor");
	String PaymentTerms = request.getParameter("PaymentTerms");
	String Warranties = request.getParameter("Warranties");
	String ReQuote = request.getParameter("ReQuote");
	
	if("-".equals(orderUnit))
		orderUnit = null;
	
	System.out.println("remarksremarksremarksremarks:"+remarks);
	
	if(remarks !=null && !"".equals(remarks) && remarks.indexOf("'")!=-1)
	{
		remarks = remarks.trim();
		remarks = replaceString(remarks,"'","`");	
	}	
	
	// Added By Balu on 14th Aug to insert Remarks in SAP
	
	int remLen	= 0;
	if(remarks!= null && !"null".equals(remarks) && !"".equals(remarks))
		remLen	= remarks.length();
	int remarkLines	= 0,start=0,end=0,interval=80,lastStr=0;
	
	ezc.ezpurchase.params.EzBapieslltxTable  txtTable 	= new ezc.ezpurchase.params.EzBapieslltxTable();
	ezc.ezpurchase.params.EzBapieslltxTableRow  txtTableRow 	= null;
	
	int headerTextCounter = 0;
	
	if(remLen>interval)
	{

		
		String remarksStr = "";

		
		
		
		remarkLines 	= remLen/interval;
		lastStr		= remLen%interval;
		
		end = interval;
		for(int i=0;i<remarkLines;i++)
		{
			remarksStr	= remarks.substring(start,end);
			txtTableRow 	= new ezc.ezpurchase.params.EzBapieslltxTableRow();
			txtTableRow.setTextId("A01");
			txtTableRow.setTextLine(remarksStr);
			//txtTable.appendRow(txtTableRow);
			txtTable.insertRow(headerTextCounter,txtTableRow);
			start = end;
			end+=interval; 
			System.out.println("Start"+txtTableRow.getTextLine()+"End");
			headerTextCounter++;
		}
		if(lastStr>0)
		{
			remarksStr	= remarks.substring(start,remarks.length());
			txtTableRow = new ezc.ezpurchase.params.EzBapieslltxTableRow();
			txtTableRow.setTextId("A01");
			txtTableRow.setTextLine(remarksStr);
			//txtTable.appendRow(txtTableRow);
			txtTable.insertRow(headerTextCounter,txtTableRow);
			System.out.println("Start"+txtTableRow.getTextLine()+"End");
			headerTextCounter++;
		}
	}
	// Ends Here	
	
	
	if(PaymentTerms!= null && !"null".equals(PaymentTerms))
	{
		txtTableRow 	= new ezc.ezpurchase.params.EzBapieslltxTableRow();
		txtTableRow.setTextId("A07");
		txtTableRow.setTextLine(PaymentTerms);
		txtTable.insertRow(headerTextCounter,txtTableRow);
		headerTextCounter++;
		
		PaymentTerms = PaymentTerms.replaceAll("'","`");
		
		
	}
	
	if(Warranties!= null && !"null".equals(Warranties))
	{
		txtTableRow 	= new ezc.ezpurchase.params.EzBapieslltxTableRow();
		txtTableRow.setTextId("A08");
		txtTableRow.setTextLine(Warranties);
		txtTable.insertRow(headerTextCounter,txtTableRow);
		headerTextCounter++;
		
		Warranties = Warranties.replaceAll("'","`");
			
	}
	
	
	String [] items = request.getParameterValues("ItemNo");
	String [] prices = request.getParameterValues("Price");
	String [] currs = request.getParameterValues("Curr");
	//String [] exchangeRate=request.getParameterValues("excRate");
	//String [] orderPer=request.getParameterValues("per");
	//String [] orderPerUnit=request.getParameterValues("perUnit");

	String [] hdnMatDesc = request.getParameterValues("hdnMatDesc");
	String [] txtMatDesc = request.getParameterValues("txtMatDesc");

  

	String [] counter 	=  request.getParameterValues("counter");	
	String [] material 	=  request.getParameterValues("material");
	String [] materialDesc 	=  request.getParameterValues("materialDesc");
	String [] uom 		=  request.getParameterValues("uom");	
	String [] quantity 	=  request.getParameterValues("quantity");		
	String [] delivDate 	=  request.getParameterValues("delivDate");			
	String [] plant 	=  request.getParameterValues("plant");		
	String [] itemCond 	=  request.getParameterValues("itemCond");	
	
	
	/****Newly Added *****/
	
	String serToRFQLine[]	= request.getParameterValues("serToRFQLine");
	String serLine[]	= request.getParameterValues("serLine");
	String serQty[]		= request.getParameterValues("serQty");
	String serPrice[]	= request.getParameterValues("serPrice");
	java.util.Vector serToRFQVect =new java.util.Vector();
	
	if(serToRFQLine!=null &&serToRFQLine.length>0){
	double sQty = 0;
		for(int s=0;s<serToRFQLine.length;s++){
			try
			{
				sQty = Double.parseDouble(serQty[s]);
				//sQty = sQty/1000;
				serQty[s] = sQty+"";				
			}
			catch(Exception e)
			{}
			
			serTableRow=new ezc.ezpreprocurement.params.EziRFQItemServiceTableRow();
			serTableRow.setPRItmNo(serToRFQLine[s]);
			serTableRow.setSerLine(serLine[s]);
			serTableRow.setSerQuantity(serQty[s]);
			double price1=Double.valueOf(serPrice[s]).doubleValue()*0.1;
			String newPrice = price1+"";
			serTableRow.setSerPrice(newPrice);
			serTable.appendRow(serTableRow);
			
			if(!serToRFQVect.contains(serToRFQLine[s]))
			serToRFQVect.add(serToRFQLine[s]);
		}
	
	}
	
	/******end***********/
	
	
	
	String currencyString = currs[0];
	String quantityString = quantity[0];
	String priceString = prices[0];
	 

	
	System.out.println("************************>>>>>>>>>>>>>>>>>>>>>>>>"+fromoffline);

	Date fromDate = new Date();
	fromDate.setDate(Integer.parseInt(QtnDt.substring(3,5)));
	fromDate.setMonth(Integer.parseInt(QtnDt.substring(0,2))-1);
	fromDate.setYear(Integer.parseInt(QtnDt.substring(6,10))-1900);
	
	Date prcValDate = new Date(); 
	prcValDate.setDate(Integer.parseInt(priceValExpDate.substring(3,5)));
	prcValDate.setMonth(Integer.parseInt(priceValExpDate.substring(0,2))-1);
	prcValDate.setYear(Integer.parseInt(priceValExpDate.substring(6,10))-1900);
	
	//prcValDate  = dateConvertion(priceValExpDate,fdate);
	String prcValDate1=formatDate.getStringFromDate(prcValDate,"/",formatDate.DDMMYYYY);
	//out.println(""+prcValDate1);

	String rfqNo = request.getParameter("RfqNo");
	
	String IncoTerms 	= request.getParameter("IncoTerms");
	String IncoTerms2	= request.getParameter("incoTerms2");
	String IncoTermsDesc 	= request.getParameter("IncoTermsDesc");
	
	if(IncoTerms2==null || "null".equals(IncoTerms2))IncoTerms2="";
	IncoTerms2=IncoTerms2.trim();
	
	java.util.StringTokenizer strk = new java.util.StringTokenizer(IncoTerms,"¥");
	
	
	String 	inctrm1 = strk.nextToken();
	String 	inctrm2 = strk.nextToken();	
	
	if(!"".equals(IncoTerms2)) inctrm2 = IncoTerms2;
	
	String taxCode[] = request.getParameterValues("taxCode");
	String valType[] = request.getParameterValues("valType");
	String qtnRefNo = request.getParameter("QtnRef");
	

	ezirfqheadertablerow.setRFQNo(rfqNo); 
	ezirfqheadertablerow.setVendor("S-1006"); 
	ezirfqheadertablerow.setDocType("A");
	ezirfqheadertablerow.setAgreement(qtnRefNo);
	ezirfqheadertablerow.setDocDate(fromDate);	
	ezirfqheadertablerow.setPriceValDate(prcValDate);	
	ezirfqheadertablerow.setPriceValString(prcValDate1);	
	ezirfqheadertablerow.setIncoTerms1(inctrm1);
	ezirfqheadertablerow.setIncoTerms2(inctrm2);
	ezirfqheadertablerow.setPmntTerms(PaymentTerms);	
	ezirfqheadertablerow.setWarranties(Warranties);
	ezirfqheadertablerow.setOrderUnit(orderUnit); 
	
	ezirfqheadertablerow.setStatus("Y"); 
	//ezirfqheadertablerow.setRequoteStatus("N"); 
	
	ezirfqheadertablerow.setValType(valType[0]); 
	//ezirfqheadertablerow.setTaxCode(taxCode[0]); 
	ezirfqheadertablerow.setTaxCode(""); 
	ezirfqheadertablerow.setQuantity(quantity[0]); 
	
	ezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
	ezirfqheadertablerow.setCurrency(currs[0]); 
	
	if(remLen<interval)
		ezirfqheadertablerow.setRemarks(remarks); 
	
	
	if("Y".equals(reQtFlg))
	{
		System.out.println("++++++++++Old Currency+++++++++"+OldCur);
		System.out.println("++++++++++New Currency+++++++++"+currs[0]);
		auditStr = "Quotation has been re-posted";
		
		if(!OldCur.equals(currs[0]))
			ezirfqheadertablerow.setIsCurrChanged("Y"); 
	}
	
	ezirfqheadertable.appendRow(ezirfqheadertablerow);
	java.text.DateFormat df = new SimpleDateFormat("MM/dd/yyyy"); 

	ezc.ezpreprocurement.params.EziPOItemTable 	itemTable = new ezc.ezpreprocurement.params.EziPOItemTable();	
	

	ezc.ezpreprocurement.params.EziPOCondTable condTable	= new ezc.ezpreprocurement.params.EziPOCondTable();
	int count = 0,j=0;
	for (int i=0 ; i < items.length ; i++)
	{
		String delivDateCal 	=  request.getParameter("delivDateCal"+i);
		Date delivDateCalObj = null;
		
		try
		{
			delivDateCalObj = df.parse(delivDateCal);
		}catch(Exception e){	
			ezc.ezcommon.EzLog4j.log("Exception occured while converting delDate from string to date>>>"+e,"E");
		}
		
		ezc.ezcommon.EzLog4j.log("delivDateCalObj>>>"+delivDateCalObj,"D");


		ezc.ezpreprocurement.params.EziPOCondTableRow sapCondRow = null;
		if ((prices[i]!=null)&&(prices[i].length()!=0))
		{
			
			prices[i] = prices[i].trim();
			
			ezc.ezpreprocurement.params.EziPOItemTableRow 	itemRow	  = null;
			itemRow = new ezc.ezpreprocurement.params.EziPOItemTableRow();
			itemRow.setRFQItem(items[i]);
			itemRow.setValType(valType[i]);
			itemRow.setTaxCode(taxCode[i]);
			itemRow.setOrderUnit(orderUnit); 
			
			if(serToRFQVect.contains(items[i]))
			itemRow.setExt1("D"); 
			
			if("Y".equals(ReQuote))
  				itemRow.setIsReQuote("X");

			if(delivDateCalObj!=null && !"null".equals(delivDateCalObj))
				itemRow.setDelDate(delivDateCalObj);
			
			double price1=Double.valueOf(prices[i]).doubleValue()*0.1;
			String newPrice = price1+"";
			itemRow.setPrice(newPrice);
			String tempQtyStr="";
			try{
				//tempQtyStr= ""+(Double.parseDouble(quantity[i])/1000);
				tempQtyStr=quantity[i];
			}catch(Exception err){tempQtyStr=quantity[i];}
			
			itemRow.setQuantity(tempQtyStr);
			itemTable.appendRow(itemRow);
			
			
			
			
			
			
			count = Integer.parseInt(counter[i]);
			count = count+1;
			ezirfqdetailstablerow = new ezc.ezpreprocurement.params.EziRFQDetailsTableRow();
			ezirfqdetailstablerow.setRFQNo(rfqNo); 
			ezirfqdetailstablerow.setLineNo(items[i]); 
			
			
			
			ezirfqdetailstablerow.setCounter(""+count); 
			ezirfqdetailstablerow.setMaterial(material[i]); 
			ezirfqdetailstablerow.setMaterialDesc(materialDesc[i]);
			ezirfqdetailstablerow.setUOM(uom[i]); 
			
			Date delDateObj = new Date(); 
			/*
			delDateObj.setDate(Integer.parseInt(delivDate[i].substring(3,5)));
			delDateObj.setMonth(Integer.parseInt(delivDate[i].substring(0,2))-1);
			delDateObj.setYear(Integer.parseInt(delivDate[i].substring(6,10))-1900);
			*/
			
			
			delDateObj.setDate(Integer.parseInt(delivDateCal.substring(3,5)));
			delDateObj.setMonth(Integer.parseInt(delivDateCal.substring(0,2))-1);
			delDateObj.setYear(Integer.parseInt(delivDateCal.substring(6,10))-1900);
						
			ezirfqdetailstablerow.setDeliveryDate(formatDate.getStringFromDate(delDateObj,"/",formatDate.DDMMYYYY));
			//out.println("quantity[i]	"+quantity[i]);
			//out.println("prices[i]		"+prices[i]);

			ezirfqdetailstablerow.setQuantity(quantity[i]); 
			ezirfqdetailstablerow.setPrice(prices[i]); 
			ezirfqdetailstablerow.setCurr(currs[i]); 
			
			ezirfqdetailstablerow.setPlant(plant[i]); 			
			ezirfqdetailstablerow.setRemarks(remarks); 
			//ezirfqdetailstablerow.setRemarks(""); 
			ezirfqdetailstablerow.setExt1(""); 
			ezirfqdetailstablerow.setExt2(""); 
			ezirfqdetailstablerow.setExt3(""); 
			ezirfqdetailstable.appendRow(ezirfqdetailstablerow);	
			
			
			
			
			if(itemCond!=null && !"null".equals(itemCond[i]) && !"".equals(itemCond[i].trim()))
			{
			  		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(itemCond[i],"^^");
			  		java.util.Vector Tokens = EzToken.getTokens();
			  		String condTypeTemp="";
			  		String condValTemp="";
			  		String condCurrTemp="";
			  		String condPerTemp="";
			  		String condUOMTemp="";
			  		String condPerOrCurrTemp="";
			  		for(int v=0;v<Tokens.size();v++)
					{
						ezc.ezbasicutil.EzStringTokenizer EzToken1 = new ezc.ezbasicutil.EzStringTokenizer((String)Tokens.elementAt(v),"$$");
						java.util.Vector Tokens1 = EzToken1.getTokens();
						condTypeTemp=(String)Tokens1.elementAt(0);
						condValTemp=(String)Tokens1.elementAt(1);
						condCurrTemp=(String)Tokens1.elementAt(2);
						condPerTemp=(String)Tokens1.elementAt(3);
						condUOMTemp=(String)Tokens1.elementAt(4);
						condPerOrCurrTemp=(String)Tokens1.elementAt(5);
						
						if("-".equals(condCurrTemp.trim())) condCurrTemp="";
						if("-".equals(condPerTemp.trim())) condPerTemp="";
						if("-".equals(condUOMTemp.trim())) condUOMTemp="";
						
						//if("ZEX1".equals(condTypeTemp.trim()) && "P".equals(condPerOrCurrTemp)) condCurrTemp="";
						if("P".equals(condPerOrCurrTemp)) condCurrTemp="";
						condCurrTemp = condCurrTemp.trim();
							
						
						sapCondRow = new ezc.ezpreprocurement.params.EziPOCondTableRow();
						sapCondRow.setConditionNo(items[i]);
						sapCondRow.setIsSerRFQ("N");
						sapCondRow.setConditionType(condTypeTemp);
						sapCondRow.setConditionValue(condValTemp);
						sapCondRow.setCurrency(condCurrTemp);
						sapCondRow.setConditionPer(condPerTemp);
						sapCondRow.setConditionUom(condUOMTemp);
						condTable.appendRow(sapCondRow);
						
								
					}	
  			}	
  			if("Y".equals(ReQuote))
  			{
  				sapCondRow = new ezc.ezpreprocurement.params.EziPOCondTableRow();
				sapCondRow.setConditionNo(items[i]);
				sapCondRow.setIsSerRFQ("N");
				sapCondRow.setConditionType("PBXX");
				sapCondRow.setConditionValue(prices[i]);
				condTable.appendRow(sapCondRow);  				
  			}
			
			
		}
	}

	ezparams.setObject(ezirfqheadertable);
	ezparams.setObject(itemTable);
	ezparams.setObject(serTable);
	ezparams.setObject(txtTable);
	
	ezparams.setObject(condTable);
	Session.prepareParams(ezparams);
	System.out.println("--------------------------------------------------------------");
	
	ReturnObjFromRetrieve ret=(ReturnObjFromRetrieve)ezrfqmanager.ezSaveQuote(ezparams);
	//ReturnObjFromRetrieve ret= new ReturnObjFromRetrieve();
  	//out.println(ret.toEzcString());
  
	
	String retMsg = "Error:In Quotation Posting ";
	String retWarnMsg = "";
	boolean retWarnFlg = false;
	
	String errFlg = "N";
	for ( int i=0;i<ret.getRowCount();i++)
	{
		String Msg = ret.getFieldValueString(i,"MSG");
		String Type = ret.getFieldValueString(i,"TYPE");
		String Code = ret.getFieldValueString(i,"CODE");
		String MsgNo = ret.getFieldValueString(i,"MSGNO");
		
		System.out.println(Type);
		System.out.println(Msg);
		retMsg = "";
		if ("E".equalsIgnoreCase(Type.trim()))
		{
			errFlg = "Y";
			retMsg= Msg;
			//break;
		}
		if ("W".equalsIgnoreCase(Type.trim()))
		{
			retWarnFlg = true;
			retWarnMsg=Msg+"<Br>"+retWarnMsg;
		}
	}
	//retMsg="";
	if ("".equals(retMsg))
	{
		retMsg = "Quotation Posted Successfully";
		ezcparams.setObject(ezirfqheadertable);
		ezcparams.setObject(ezirfqdetailstable);
		ezcparams.setLocalStore("Y");
		Session.prepareParams(ezcparams);
		ezrfqmanager.ezUpdateRFQ(ezcparams);
			
		/***********************MATERIAL DESCRIPTION UPDATE START**************************/	
		ezc.ezparam.EzcParams matEditParams	= new ezc.ezparam.EzcParams(false);
	
		boolean mDescEdited = false;						
		headerParams.setRFQNo(rfqNo);


		for(int m=0;m<items.length;m++)
		{	
			String actlMDesc = hdnMatDesc[m];
			String mdfdMDesc = txtMatDesc[m];
			actlMDesc = actlMDesc.trim();
			mdfdMDesc = mdfdMDesc.trim();

			String delivDateCal 	=  request.getParameter("delivDateCal"+m);
			
			if(!actlMDesc.equals(mdfdMDesc))
			{
				mDescEdited = true;
				qtyTableRow     = new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();
				qtyTableRow.setRFQNo(rfqNo);
				qtyTableRow.setQuantity(quantity[m]);
				
				Date delDateObj = new Date(); 
				/*
				delDateObj.setDate(Integer.parseInt(delivDate[m].substring(3,5)));
				delDateObj.setMonth(Integer.parseInt(delivDate[m].substring(0,2))-1);
				delDateObj.setYear(Integer.parseInt(delivDate[m].substring(6,10))-1900);
				*/
				
				
				delDateObj.setDate(Integer.parseInt(delivDateCal.substring(3,5)));
				delDateObj.setMonth(Integer.parseInt(delivDateCal.substring(0,2))-1);
				delDateObj.setYear(Integer.parseInt(delivDateCal.substring(6,10))-1900);
								
				qtyTableRow.setDelDate(formatDate.getStringFromDate(delDateObj,"/",formatDate.DDMMYYYY));
				qtyTableRow.setItmNo(items[m]);
				qtyTableRow.setMaterialDesc(mdfdMDesc);
				qtyTable.appendRow(qtyTableRow);			
			}	
		}

		matEditParams.setObject(headerParams);
		matEditParams.setObject(qtyTable);
		Session.prepareParams(matEditParams);
		if(mDescEdited)
		{
			ezc.ezparam.ReturnObjFromRetrieve matEditRet = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezEditRFQ(matEditParams);
			if(matEditRet!=null && matEditRet.getRowCount()>0)
			{
				int matEditRetCnt = matEditRet.getRowCount();
				for(int r=0;r<matEditRetCnt;r++)
				{
					if("E".equals(matEditRet.getFieldValueString(r,"MSGTYP")))
					{
						retMsg = retMsg+"<Br>Error in updating Material Description : <Br>"+matEditRet.getFieldValueString(r,"MESSAGE");
					}
				}
			}
				
		}	
		/***********************MATERIAL DESCRIPTION UPDATE END**************************/	


  		
  		eziaudittablerow 	= new ezc.ezpreprocurement.params.EziAuditTrailTableRow();	
		eziaudittablerow.setDocId(rfqNo);
		eziaudittablerow.setDocType("AN");
		eziaudittablerow.setDocCategory("A");
		eziaudittablerow.setUserName(Session.getUserId());
		eziaudittablerow.setFMName("Z_EZ_PO_CHANGE");
		eziaudittablerow.setIPAddress(request.getRemoteAddr());
		eziaudittablerow.setPurOrg(purchOrg);
		eziaudittablerow.setPurGrp(purGrp);
		eziaudittablerow.setComments(auditStr);
		eziaudittablerow.setChangeInd("U");
       		eziaudittable.appendRow(eziaudittablerow);
       		 
       		ezparams.setObject(eziaudittable);
		Session.prepareParams(ezparams);
  		//ezrfqmanager.ezAddAuditTrail(ezparams);
  		
  		String docType="QUOTE";
		String docVal=rfqNo;
		String attachFlag=request.getParameter("attachFlag");

		if("Y".equals(attachFlag))
		{
%>
			<%@ include file="../Attachments/iUploadDocs.jsp"  %> 	
<%
		}

%>
	<%@ include file="ezPostQuotationMail.jsp"  %> 	
<%	
	}
	if ("Y".equals(fromoffline))
	{
		response.sendRedirect("ezMessage.jsp?Msg="+retMsg);
	}
	else
	{	
		//response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg+"&errorFlg="+errFlg);	
%>
	<html>
	<head>
	<title>
	Message
	</title>
	<%//@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
	<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<Script>
		function sendBack()
		{
			document.myForm.action='ezPostQuote.jsp';
			document.myForm.submit()
		}
	</Script>
	<script language="Javascript1.2">
		am = "This function is disabled!";
		bV  = parseInt(navigator.appVersion)
		bNS = navigator.appName=="Netscape"
		bIE = navigator.appName=="Microsoft Internet Explorer"
		function nrc(e) 
		{
		   if (bNS && e.which > 1)
		   {
		      alert(am)
		      return false
		   } 
		   else if (bIE && (event.button >1)) 
		   {
		     alert(am)
		     return false;
		   }
		}
		document.onmousedown = nrc;
		if (document.layers) window.captureEvents(Event.MOUSEDOWN);
		if (bNS && bV<5) window.onmousedown = nrc;
 function funOk()
{
	
	document.myForm.action="ezListGenRFQs.jsp?type=ToBeQuote"
	document.myForm.submit()	

}
	</script>
	
	</head>
	<body bgcolor="#FFFFF7">

	<Form name=myForm method="post">
	<input type=hidden name='rfqVendor' value='<%=rfqVend%>'>
	<%
		String display_header = "";
	%>
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<br>
	<br>
	<br>

	<table width="60%" align="center" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1>
<%
	String align = "align=left";
	if("Y".equals(errFlg))
	{
%>
		<tr align="center">
		    	<th>ERRORS</th>
		</tr>

<%
	}
	else
	{
		align = "align=center";
	}
%>
	  <tr>
	    <th <%=align%>><%=retMsg%></th>
	  </tr>
	</table>
	<br><br>
<%
	if(retWarnFlg && !"3".equals(userType))
	{
%>
		
		<table width="60%" align="center" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1>
			<tr align="center">
				    <th>WARNINGS</th>
			  </tr>
			  <tr align="center">
				    <th align="left"><%=retWarnMsg%></th>
			  </tr>
		</table>
		<br><br>
<%
	}
	if(!"Y".equals((String)session.getValue("OFFLINE")))
	{
		if("Y".equals(errFlg))
		{
%>
			<center>
<%
			    buttonName.add("Back");
			    buttonMethod.add("sendBack()");
			    out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>		
<%
		}
		else
		{
%>	
			<center>
      
<%
    buttonName.add("Ok");

    buttonMethod.add("funOk()");
    out.println(getButtonStr(buttonName,buttonMethod));
%>
      
      </center>
<%	
		}
	}
%>
	
	<Div id="MenuSol"></Div>



	<input type=hidden name='PurchaseOrder' value='<%=rfqNo%>'>
	<input type=hidden name='EndDate' value='<%=QtnDt%>'>
	<input type=hidden name='QtnRef' value='<%=qtnRefNo%>'>
	<input type=hidden name='ExpireDt' value='<%=priceValExpDate%>'>
	<input type=hidden name='PaymentTerms' value='<%=PaymentTerms%>'>
	<input type=hidden name='IncoTerms' value='<%=inctrm1%>'>
	<input type=hidden name='IncoTermsDesc' value='<%=IncoTermsDesc%>'>
	<input type=hidden name='Remarks' value='<%=remarks%>'>
	<input type=hidden name='orderUnit' value='<%=orderUnit%>'>
	<input type=hidden name='conditionsString' value='<%=conditionsString%>'>
	
	
<%
	for(int i=0;i<prices.length;i++){
%>
	<input type=hidden name='priceString' value='<%=prices[i]%>'>
	<input type=hidden name='quantityString' value='<%=quantity[i]%>'>
	<input type=hidden name='currencyString' value='<%=currs[i]%>'>
	<input type=hidden name='valType' value='<%=valType[i]%>'>
	<input type=hidden name='taxCode' value='<%=taxCode[i]%>'>
	<input type=hidden name='itemCond' value='<%=itemCond[i]%>'>
	
	
	
<%
	}
%>
	
	
		
	</Form>
	</body>
	</html>
<%
	}
%>

