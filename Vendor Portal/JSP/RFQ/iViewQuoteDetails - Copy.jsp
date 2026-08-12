<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*,ezc.ezutil.*," %>
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%	
 	String rfqSysKey = request.getParameter("rfqSysKey");
	String rfqVendor = request.getParameter("rfqVendor");
	String rfqNumber = request.getParameter("rfqNumber");
	String rfqReQuote = request.getParameter("rfqReQuote");
	String rfqQuoteStatus = request.getParameter("rfqQuoteStatus");
	String rfqVendorType = request.getParameter("rfqVendorType");
	String editType = request.getParameter("type");
 
  	EzcParams 		ezparams	= new EzcParams(true);
 	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
 	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
 	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
 	
 	EzoRFQHeaderParams    qcfDetailsRet 	= null;
 	ReturnObjFromRetrieve rfqHeaderRet 	= null;
 	ReturnObjFromRetrieve rfqDetailsRet 	= null;
 	ReturnObjFromRetrieve rfqConditionsRet 	= null;
 	ReturnObjFromRetrieve rfqQuoteHistoryRet 	= null;
 	
 	int qcfDetailsRetCnt 	= 0;
 	int rfqHeaderRetCnt 	= 0;
 	int rfqDetailsRetCnt 	= 0;
 	int rfqConditionsRetCnt = 0;
 	int rfqQuoteHistoryRetCnt = 0;
 	
 	
 	EziRFQHeaderParams  inputParams = new EziRFQHeaderParams();
 
 	inputParams.setRFQNo(rfqNumber);
 	
 	inputParams.setStatus("Y");
 	if("N".equals(rfqQuoteStatus) && "Y".equals(rfqReQuote))
 		inputParams.setStatus("N");
	if("NON_SAP".equals(rfqVendorType) && ("N".equals(rfqQuoteStatus)))
 		inputParams.setStatus("Y','N");	
 		
	inputParams.setExt1("LATEST");	

 	ezparams.setLocalStore("Y");
 	ezparams.setObject(inputParams);
 	Session.prepareParams(ezparams);
 	
 	try{
 		qcfDetailsRet = (EzoRFQHeaderParams)rfqManager.ezGetRFQDetails(ezparams);
 	}
 	catch(Exception e){
 		ezc.ezcommon.EzLog4j.log("Error while getting QCF Details :::::::::"+e,"E");
 	}
 	
 	rfqHeaderRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQHeader();
 	rfqDetailsRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQDetails();
 	rfqConditionsRet 	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQConditions();
 	rfqQuoteHistoryRet	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQQuoteHistory();
 
 	if(rfqHeaderRet!=null)
 		rfqHeaderRetCnt    = rfqHeaderRet.getRowCount();
 	if(rfqDetailsRet!=null)
 		rfqDetailsRetCnt   = rfqDetailsRet.getRowCount();
 	if(rfqConditionsRet!=null)
 		rfqConditionsRetCnt= rfqConditionsRet.getRowCount();
 	if(rfqQuoteHistoryRet!=null)
 		rfqQuoteHistoryRetCnt= rfqQuoteHistoryRet.getRowCount();
 		
 	Hashtable discHT = new Hashtable();
 	Hashtable discTotValHT = new Hashtable();
 	Hashtable totAftrDiscHT = new Hashtable();
 	
 	Hashtable cgstHT = new Hashtable();
 	Hashtable cgstTotValHT = new Hashtable();
 	Hashtable totAftrCgstHT = new Hashtable();
 	
 	Hashtable sgstHT = new Hashtable();
 	Hashtable sgstTotValHT = new Hashtable();
 	Hashtable totAftrSgstHT = new Hashtable();
 	
 	Hashtable igstHT = new Hashtable();
 	Hashtable igstTotValHT = new Hashtable();
 	Hashtable totAftrIgstHT = new Hashtable();
 	
 	Hashtable ugstHT = new Hashtable();
 	Hashtable ugstTotValHT = new Hashtable();
 	Hashtable totAftrUgstHT = new Hashtable();
 	
 	Hashtable pkfwHT = new Hashtable();
 	Hashtable pkfwTotValHT = new Hashtable();
 	Hashtable totAftrPkfwHT = new Hashtable();
 	
 	Hashtable frtHT = new Hashtable();
 	
 	Hashtable frtGstHT = new Hashtable();
 	Hashtable frtGstTotValHT = new Hashtable();
 	Hashtable totAftrFrtGstHT = new Hashtable();
 	
 	String quoteHistoryMaxCount="";
 	
 	if(rfqQuoteHistoryRetCnt>0)
 	{
 		quoteHistoryMaxCount 	= rfqQuoteHistoryRet.getFieldValueString(0,"ERQH_COUNTER");
 		ezc.ezcommon.EzLog4j.log("::::::quoteHistoryMaxCount::::::::"+quoteHistoryMaxCount,"I");
 	}
 	
 	String condItemNo="",condCode = "",condVal = "", condTotVal="", totAftrTax;
 	for(int c=0;c<rfqConditionsRetCnt;c++)
 	{
 		condItemNo 	= rfqConditionsRet.getFieldValueString(c,"ERIC_LINE_NO");
 		condCode 	= rfqConditionsRet.getFieldValueString(c,"ERIC_TAX_CODE");
 		
 		if("Y".equals(rfqReQuote))
 			condVal 	= rfqConditionsRet.getFieldValueString(c,"ERIC_NEG_TAX_VALUE");
 		else	
 			condVal 	= rfqConditionsRet.getFieldValueString(c,"ERIC_TAX_VALUE");
 			
 		condTotVal = 	rfqConditionsRet.getFieldValueString(c,"ERIC_EXT1");
 		totAftrTax = 	rfqConditionsRet.getFieldValueString(c,"ERIC_EXT2");
 			
 		if("DISC".equals(condCode))
 		{
 			discHT.put(condItemNo,condVal);
 			discTotValHT.put(condItemNo,condTotVal);  
 			totAftrDiscHT.put(condItemNo,totAftrTax);  
 		}
 		
		if("PKFW".equals(condCode))
		{
			pkfwHT.put(condItemNo,condVal);	
			pkfwTotValHT.put(condItemNo,condTotVal);
			totAftrPkfwHT.put(condItemNo,totAftrTax);  
 		}
 		if("CGST".equals(condCode))
 		{
 			cgstHT.put(condItemNo,condVal);
 			cgstTotValHT.put(condItemNo,condTotVal);
 			totAftrCgstHT.put(condItemNo,totAftrTax);  
 		}
 		
 		if("SGST".equals(condCode))
 		{
 			sgstHT.put(condItemNo,condVal);
 		 	sgstTotValHT.put(condItemNo,condTotVal);
 		 	totAftrSgstHT.put(condItemNo,totAftrTax);  
 		}	
 		if("IGST".equals(condCode))
 		{
 			igstHT.put(condItemNo,condVal);
 		 	igstTotValHT.put(condItemNo,condTotVal);
 		 	totAftrIgstHT.put(condItemNo,totAftrTax);  
 		}	
 		if("UGST".equals(condCode))
 		{
 			ugstHT.put(condItemNo,condVal);	
 		 	ugstTotValHT.put(condItemNo,condTotVal);
 		 	totAftrUgstHT.put(condItemNo,totAftrTax);  
 		}	
 			
 		if("FRT".equals(condCode))
 			frtHT.put(condItemNo,condVal);
 			
		if("FRT_GST".equals(condCode))
		{
 			frtGstHT.put(condItemNo,condVal); 			
 		 	frtGstTotValHT.put(condItemNo,condTotVal);
 		 	totAftrFrtGstHT.put(condItemNo,totAftrTax);  
 		}	
 	}
 	
 	
	ResourceBundle IncoT= ResourceBundle.getBundle("EzPurIncoTerms");
	ResourceBundle PayT= ResourceBundle.getBundle("EzPurPayTerms");
	Enumeration incoEnu =IncoT.getKeys();
	Enumeration payEnu =PayT.getKeys();

	java.util.TreeMap incoTM = new java.util.TreeMap();	
	java.util.TreeMap payTM = new java.util.TreeMap();	

	while(incoEnu.hasMoreElements())
	{
		String s=(String)incoEnu.nextElement();
		incoTM.put(s,IncoT.getString(s));
	}
	Iterator incoIterator = incoTM.keySet().iterator();
	Object incoObj = new Object();


	while(payEnu.hasMoreElements())
	{
		String s1=(String)payEnu.nextElement();
		payTM.put(s1,PayT.getString(s1));
	}
	Iterator payIterator = payTM.keySet().iterator();
	Object payObj = new Object();
	

	ReturnObjFromRetrieve vendorUploadFiles=null;
	int vendorUploadFilesCnt=0;

	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();

	miscParams.setQuery("SELECT * FROM EZC_UPLOAD_FILES WHERE EUF_DOC_ID IN('"+rfqNumber+"') ORDER BY EUF_ATTACHED_DATE");
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	try
	{
		vendorUploadFiles = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		//out.println("::vendorUploadFiles::"+vendorUploadFiles.toEzcString());


		if(vendorUploadFiles!=null)
		{
			vendorUploadFilesCnt = vendorUploadFiles.getRowCount();				
		}

	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log(":::::Exception occured while getting vendor UPload files details::::::"+e,"E");
	}
%>