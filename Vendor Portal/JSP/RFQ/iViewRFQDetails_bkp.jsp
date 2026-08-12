<%@ page import ="ezc.ezparam.*" %>
<%@ include file="../../../Includes/Lib/PurchaseBean.jsp"%>
<%@ page import = "java.util.*"%>
<jsp:useBean id="PoManager" class="ezc.client.EzPurchaseManager" scope="page"></jsp:useBean>
<jsp:useBean id="StockManager" class="ezc.ezstock.client.EzStockInfoManager" />
<%@ page import="ezc.ezstock.params.*" %>
<%
	String valuationTypes[] = {"01","02","A/L (SFG)","A/L FOR RM","C1","C2","C3","DOM. (SFG)","DOM.FOR RM","EIGEN","FREMD","LAND 1","LAND 2","MFD (FG)","MFD (SFG)","OGL (SFG)","OGL FOR RM","PROC (FG)","RAKTION","RM MOHALI","RM TOANSA","RNORMAL"};
	
	String UserType = (String)session.getValue("UserType");
	String userRole = (String)session.getValue("USERROLE");
	
	String poNum = request.getParameter("PurchaseOrder");
	String CDate = request.getParameter("EndDate");
	String myCollRFQNoT=request.getParameter("collectiveRFQNo");
	
	
	
	
	//out.println(poNum+":"+CDate);


	ResourceBundle IncoT	= ResourceBundle.getBundle("EzPurIncoTerms");
	ResourceBundle PayT	= ResourceBundle.getBundle("EzPurPayTerms");
	ResourceBundle TaxC 	= ResourceBundle.getBundle("EzTaxCodes");
  	ResourceBundle CurrC 	= ResourceBundle.getBundle("EzCurrCodes");
	Enumeration incoEnu 	= IncoT.getKeys();
	Enumeration payEnu 	= PayT.getKeys();
	Enumeration taxEnu 	= TaxC.getKeys();
  	Enumeration currEnu 	= CurrC.getKeys();
	
	
	java.util.TreeMap incoTM= new java.util.TreeMap();	
	java.util.TreeMap payTM = new java.util.TreeMap();	
	java.util.TreeMap taxTM = new java.util.TreeMap();	
  	java.util.TreeMap currTM = new java.util.TreeMap();

	while(incoEnu.hasMoreElements())
	{
		String s=(String)incoEnu.nextElement();
		incoTM.put(s,IncoT.getString(s));
	}
  	while(currEnu.hasMoreElements())
	{
		String s=(String)currEnu.nextElement();
		currTM.put(s,s+"-->"+CurrC.getString(s));
	}
  	Iterator currIterator = currTM.keySet().iterator();
	Iterator incoIterator = incoTM.keySet().iterator();
  	Object incoObj = new Object();


	while(payEnu.hasMoreElements())
	{
		String s1=(String)payEnu.nextElement();
		payTM.put(s1,PayT.getString(s1));
	}
	Iterator payIterator = payTM.keySet().iterator();
  	Object payObj = new Object();
  	
  	
  	
  	while(taxEnu.hasMoreElements())
	{
		String s2=(String)taxEnu.nextElement();
		taxTM.put(s2,TaxC.getString(s2));
	}
	Iterator taxIterator = taxTM.keySet().iterator();
  	Object taxObj = new Object();
  	

	String rfqVend=request.getParameter("rfqVendor");
	//out.println(rfqVend);
	
	if(CDate!=null && CDate.length()>9){
		int mm=Integer.parseInt(CDate.substring(3,5));
		int dd=Integer.parseInt(CDate.substring(0,2));
		int yy=Integer.parseInt(CDate.substring(6,10));
		Date closingDate=null;
		GregorianCalendar gc=new GregorianCalendar(yy,mm-1,dd,23,59,59);
		closingDate=gc.getTime();
	}
		//year-month-day-hour-min-sec
	

	Date today = new Date();

	EzPurchDtlXML dtlXML = null;
	EzPSIInputParameters iparams = new EzPSIInputParameters();
	String poNumberTemp="0000000000"+poNum;
	iparams.setOrderNumber(poNumberTemp.substring(poNumberTemp.length()-10,poNumberTemp.length()));
	if(rfqVend!=null && !"null".equals(rfqVend)&& !"".equals(rfqVend)){
		iparams.setCostCenter(rfqVend);
	}
	
	//String defCatArea  = (String)session.getValue("SYSKEY");
	
	//PurManager.setPurAreaAndVendor(defCatArea,defErpVendor); 
	ezc.ezparam.EzcPurchaseParams newParams = new ezc.ezparam.EzcPurchaseParams();
	ezc.ezpurchase.params.EziPurOrderDetailsParams testparams = new ezc.ezpurchase.params.EziPurOrderDetailsParams();
	newParams.createContainer();
	newParams.setObject(iparams);
	newParams.setObject(testparams);
	Session.prepareParams(newParams);

	dtlXML =  (EzPurchDtlXML)PoManager.ezPurchaseOrderStatus(newParams);
	

	java.util.Date ordDate = (java.util.Date)dtlXML.getFieldValue(0,"ORDERDATE");

	int Count = dtlXML.getRowCount();
	
	ReturnObjFromRetrieve retHead = (ReturnObjFromRetrieve)dtlXML.getObject("HEADER");
  
	ezc.ezcommon.EzLog4j.log("MY CHK VALUE1212121212QUOTE>>>"+retHead.toEzcString(),"D");
	String QuotNo="";
	if (retHead!=null && retHead.getRowCount() > 0)
		QuotNo= retHead.getFieldValueString(0,"QUOTATION");
	////out.println(UserType)	;

	ReturnObjFromRetrieve retHeadText = (ReturnObjFromRetrieve)dtlXML.getObject("HEADERTEXT");
	ReturnObjFromRetrieve serRetObj   = (ReturnObjFromRetrieve)dtlXML.getObject("POITEM_SERVICE");
	int serRetObjCount=0;
		ezc.ezcommon.EzLog4j.log("MY CHK VALUE retHeadText>>>"+retHeadText.toEzcString(),"D");

	if(serRetObj!=null)
	serRetObjCount=serRetObj.getRowCount();
	
	String serFields []= {"PO_LINE","SER_LINE","SERVICE","QUANTITY","BASE_UOM","UOM_ISO","PRICE_UNIT","GR_PRICE","GROSS_VAL","NET_VALUE","SHORT_TEXT","MATL_GROUP"};
	ReturnObjFromRetrieve mySerRetTemp= null;
	
	java.util.Hashtable myItemSer=new java.util.Hashtable();
	boolean serviceRFQ=false;
	
	if(retHead!=null && retHead.getRowCount()>0 && "ANS".equals((retHead.getFieldValueString(0,"DOC_TYPE")).trim()))
	serviceRFQ=true;
	
	if(serRetObjCount>0&&Count>0){
		serviceRFQ=true;
		for(int i=0;i<Count;i++){
			String rfqLine=dtlXML.getFieldValueString(i,"POSITION");
			for(int j=0;j<serRetObjCount;j++){
				String serRFQLine=serRetObj.getFieldValueString(j,"PO_LINE");
				if(rfqLine.equals(serRFQLine)){
					if(myItemSer.containsKey(rfqLine)){

						mySerRetTemp=(ReturnObjFromRetrieve)myItemSer.get(rfqLine);


					}else{
						mySerRetTemp=new ReturnObjFromRetrieve(serFields);
						myItemSer.put(rfqLine,mySerRetTemp);

					}
					
					
					for(int k=0;k<serFields.length;k++){
						mySerRetTemp.setFieldValue(serFields[k],serRetObj.getFieldValue(j,serFields[k]));
					}
					
					mySerRetTemp.addRow();
					
				
				}
				
				
			}
			
		}
	
	}
	
	
	
	
	
	
	Hashtable htexts=new Hashtable();
	if(retHeadText!=null)
	{
		for (int i=0; i < retHeadText.getRowCount() ; i++)
		{
			htexts.put(retHeadText.getFieldValueString(i,"TEXT_ID").trim(),retHeadText.getFieldValueString(i,"TEXTLINE"));
		}
	}



	String PmntTerms = "";
	if(htexts.get("A07")!=null)
		PmntTerms =(String)htexts.get("A07");	
		
	String Warranties = "";
	if(htexts.get("A08")!=null)
		Warranties =(String)htexts.get("A08");	

	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams ezcparams				   		  = new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	  = new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezirfqheaderparams.setRFQNo(poNum);
	ezirfqheaderparams.setSysKey((String)session.getValue("SYSKEY"));
	ezcparams.setObject(ezirfqheaderparams);
	ezcparams.setLocalStore("Y");
	Session.prepareParams(ezcparams);
	ezc.ezpreprocurement.params.EzoRFQHeaderParams ezorfqheaderparams = (ezc.ezpreprocurement.params.EzoRFQHeaderParams)ezrfqmanager.ezGetRFQDetails(ezcparams);
	
	ezc.ezparam.ReturnObjFromRetrieve rfqHeader  = (ezc.ezparam.ReturnObjFromRetrieve)ezorfqheaderparams.getRFQHeader();
	ezc.ezparam.ReturnObjFromRetrieve rfqDetails = (ezc.ezparam.ReturnObjFromRetrieve)ezorfqheaderparams.getRFQDetails();
	String qtype=request.getParameter("type");
	
		
	String ExpireDt = "";
	String Remarks = "";
	String localPayTerms = "",localWarranties = "";
	if(rfqHeader!=null && rfqHeader.getRowCount()>0)
	{
		java.util.Date ExpireDtObj = (java.util.Date)rfqHeader.getFieldValue(0,"PRICE_VALID_DATE");
		localPayTerms = rfqHeader.getFieldValueString(0,"PAY_TERMS");
		localWarranties = rfqHeader.getFieldValueString(0,"ERH_WARRANTIES");
		
		if(localPayTerms==null || "null".equals(localPayTerms.trim()))
			localPayTerms = "";
			
		if(localWarranties==null || "null".equals(localWarranties.trim()))
			localWarranties = "";	
		
		if(ExpireDtObj!=null)
			ExpireDt = FormatDate.getStringFromDate(ExpireDtObj,"/",FormatDate.MMDDYYYY);
	}	
	if(rfqDetails!=null && rfqDetails.getRowCount()>0)
	{
		if(rfqDetails.getFieldValueString("REMARKS")!=null)
			Remarks = rfqDetails.getFieldValueString("REMARKS");
	}
		if(Remarks==null || "null".equals(Remarks))
			Remarks="";
	EzcParams ezcparamsnew=new EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQConditionsTable ezirfconditiontable 	     = new ezc.ezpreprocurement.params.EziRFQConditionsTable();
	ezc.ezpreprocurement.params.EziRFQConditionsTableRow ezirfconditiontablerow   = null;//new ezc.ezpreprocurement.params.EziRFQConditionsTableRow();

	ezirfconditiontablerow = new ezc.ezpreprocurement.params.EziRFQConditionsTableRow();

	ezirfconditiontablerow.setRFQNo(poNum);

	ezirfconditiontable.appendRow(ezirfconditiontablerow);
	
	ezcparamsnew.setObject(ezirfconditiontable);
	ezcparamsnew.setLocalStore("Y");
	Session.prepareParams(ezcparamsnew);
	ReturnObjFromRetrieve retCond =(ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQConditions(ezcparamsnew);
	
	
	
	
	
	/***************For Getting Uploaded Files********************/
	int attachRetCnt = 0;
	int upLoadedFilesCount = 0;
	String fstring="";
	String sfstr="";
	
	ezc.ezparam.ReturnObjFromRetrieve attachRet=null;
	ezc.ezparam.ReturnObjFromRetrieve uploadFilesRet = null;
	ezc.ezparam.ReturnObjFromRetrieve uploadFilesRet1 = null;
	
	String [] uploadFilesRetCols={"CLIENTFILENAME","SERVERFILENAME"};
	String upldCONNo="";
	if(qtype!=null && "ToBeQuote".equals(qtype.trim()))
	{
		//out.println(""+rfqHeader.toEzcString());
		if(rfqHeader!=null && rfqHeader.getRowCount()>0)
		{
			
			upldCONNo="'"+(String)session.getValue("SYSKEY")+"QCF"+rfqHeader.getFieldValue(0,"COLLETIVE_RFQ_NO")+"'";
				
		}
		
	}
	else
		upldCONNo="'"+(String)session.getValue("SYSKEY")+"QUOTE"+poNum+"'";
		
	ezc.ezupload.client.EzUploadManager EzUploadManager=new ezc.ezupload.client.EzUploadManager();
	ezc.ezparam.EzcParams ezUploadContainer = new ezc.ezparam.EzcParams(false);
	ezc.ezupload.params.EziUploadDocsParams uploadDocsParams= new ezc.ezupload.params.EziUploadDocsParams();
	uploadDocsParams.setObjectNo(upldCONNo);
	ezUploadContainer.setObject(uploadDocsParams);
	Session.prepareParams(ezUploadContainer);
	attachRet=(ezc.ezparam.ReturnObjFromRetrieve)EzUploadManager.getUploadedDocs(ezUploadContainer);

	/*if(attachRet!=null && attachRet.getRowCount()>0)
	{
		attachRetCnt   = attachRet.getRowCount();
		uploadFilesRet =(ezc.ezparam.ReturnObjFromRetrieve)attachRet.getFieldValue(0,"FILES");

	}*/
	
	if(attachRet!=null && attachRet.getRowCount()>0)
	{
		attachRetCnt   = attachRet.getRowCount();
		uploadFilesRet=new ezc.ezparam.ReturnObjFromRetrieve(uploadFilesRetCols);

		for(int i=0;i<attachRetCnt;i++)
		{
			uploadFilesRet1 =(ezc.ezparam.ReturnObjFromRetrieve)attachRet.getFieldValue(i,"FILES");
			uploadFilesRet.append(uploadFilesRet1);
		}	
	}

	if(uploadFilesRet!=null)
		upLoadedFilesCount = uploadFilesRet.getRowCount();

	for(int i=0;i<upLoadedFilesCount;i++)   
	{

	       fstring=fstring+uploadFilesRet.getFieldValueString(i,"CLIENTFILENAME")+"§";
	       sfstr=sfstr+uploadFilesRet.getFieldValueString(i,"SERVERFILENAME")+"µ";
	}

	if(!fstring.equals("") && !sfstr.equals(""))
	{
		fstring=fstring.substring(0,fstring.length()-1);
		sfstr=sfstr.substring(0,sfstr.length()-1);
	}
	else 
	{
		fstring="";
		sfstr="";
	}
	
	
	
%>
