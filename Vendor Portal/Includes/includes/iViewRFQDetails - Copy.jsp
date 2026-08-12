<%@ page import ="ezc.ezparam.*" %>
<%@ include file="../../../Includes/Lib/PurchaseBean.jsp"%>
<%@ page import = "java.util.*"%>
<jsp:useBean id="PoManager" class="ezc.client.EzPurchaseManager" scope="page"></jsp:useBean>
<jsp:useBean id="EzRfqCondManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />


<%

	String UserType=(String)session.getValue("UserType");
	
	String myPurGrp	  = (String)Session.getUserPreference("PURGROUP");
	String defErpVendor= "";

	if("2".equals(UserType))
		defErpVendor = (String)session.getValue("SOLDTO");
	else if("3".equals(UserType))
		defErpVendor = (String)Session.getUserId();

	if(myPurGrp!=null)
		myPurGrp=(myPurGrp.toUpperCase()).trim();
	if(defErpVendor!=null)
		defErpVendor = defErpVendor.trim();
	

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



	String poNum = request.getParameter("PurchaseOrder");

	String CDate = request.getParameter("EndDate");
		//CDate="28.11.2003";
	int mm=Integer.parseInt(CDate.substring(3,5));

	int dd=Integer.parseInt(CDate.substring(0,2));
	int yy=Integer.parseInt(CDate.substring(6,10));
	GregorianCalendar gc=new GregorianCalendar(yy,mm-1,dd,23,59,59);	//year-month-day-hour-min-sec
	Date closingDate=gc.getTime();

	Date today = new Date();

	EzPurchDtlXML dtlXML = null;
	EzPSIInputParameters iparams = new EzPSIInputParameters();
	iparams.setOrderNumber(poNum);
	iparams.setCostCenter(defErpVendor);
	
	ezc.ezparam.EzcPurchaseParams newParams = new ezc.ezparam.EzcPurchaseParams();
	ezc.ezpurchase.params.EziPurOrderDetailsParams testparams = new ezc.ezpurchase.params.EziPurOrderDetailsParams();
	newParams.createContainer();
	newParams.setObject(iparams);
	newParams.setObject(testparams);
	Session.prepareParams(newParams);

	dtlXML =  (EzPurchDtlXML)PoManager.ezPurchaseOrderStatus(newParams);
	java.util.Date ordDate = (java.util.Date)dtlXML.getFieldValue(0,"ORDERDATE");
	String OrderDt = FormatDate.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
	int Count = dtlXML.getRowCount();

	ReturnObjFromRetrieve retHead = (ReturnObjFromRetrieve)dtlXML.getObject("HEADER");
	
	
	
	String QuotNo="";
	if ( retHead.getRowCount() > 0)
		QuotNo= retHead.getFieldValueString(0,"QUOTATION");

	ReturnObjFromRetrieve retHeadText = (ReturnObjFromRetrieve)dtlXML.getObject("HEADERTEXT");


	Hashtable htexts=new Hashtable();
	if(retHeadText!=null)
	{
		for (int i=0; i < retHeadText.getRowCount() ; i++)
		{
			htexts.put(retHeadText.getFieldValueString(i,"PONO"),retHeadText.getFieldValueString(i,"TEXTLINE"));
		}
	}
	
	
	ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** dtlXML"+dtlXML.toEzcString()+"::htexts::"+htexts,"I");
	ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** retHead"+retHead.toEzcString(),"I");
	ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** retHeadText"+retHeadText.toEzcString(),"I");
	
	/**************Retrieving RFQ Conditions******************/
	String user = Session.getUserId();
	java.util.Map rfqCondHt=new  java.util.HashMap();
	int rfqCondCnt=0;
	String condString="",lineNo="",taxType="";
	  org.apache.commons.collections .MultiMap mhm = new org.apache.commons.collections .MultiHashMap();
		try
		{
			ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendortransactions.params.EzRFQConditionsTableRow rfqCondTableRow=new ezc.vendortransactions.params.EzRFQConditionsTableRow();
			ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
			keyParams.setKey("GET_RFQ_CONDITIONS");
			addMainParams.setLocalStore("Y");

			rfqCondTableRow.setVendor(user);
			rfqCondTableRow.setRfqNo(poNum);
			
			addMainParams.setObject(keyParams);	
			addMainParams.setObject(rfqCondTableRow);
			Session.prepareParams(addMainParams);

			ReturnObjFromRetrieve RfqCondRetObj=(ReturnObjFromRetrieve)EzRfqCondManager.ezGetVendorTransactions(addMainParams);
			if(RfqCondRetObj!=null && RfqCondRetObj.getRowCount()>0)
			{
				rfqCondCnt=RfqCondRetObj.getRowCount();
				for(int i=0;i<rfqCondCnt;i++)
				{
					lineNo="00000"+RfqCondRetObj.getFieldValueString(i,"ERIC_LINE_NO");
					lineNo=lineNo.substring((lineNo.length()-5),lineNo.length());
					if("P".equals(RfqCondRetObj.getFieldValueString(i,"ERIC_TAX_TYPE")))
					{
						taxType="%";
					}
						
					condString = "<B>"+RfqCondRetObj.getFieldValueString(i,"ERIC_TAX_CODE")+"</B>-->"+RfqCondRetObj.getFieldValueString(i,"ERIC_TAX_VALUE")+taxType;				
					mhm.put(lineNo,condString);
					ezc.ezcommon.EzLog4j.log("**i>>>>"+i+"lineNo>>>>"+lineNo+"condString>>>"+condString,"I");
				}
				
			//ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** RfqCondRetObj"+RfqCondRetObj.toEzcString(),"I");
			
			
			}
			ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** rfqCondHt"+mhm.size(),"I");
			ezc.ezcommon.EzLog4j.log("**end iViewRFQDetails** rfqCondHt"+mhm.get("00010"),"I");
			
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("**end RFQ Conditions** "+e,"I");
		}
	
	
	out.println(mhm);
	
	/**************Retrieving RFQ Conditions******************/

%>
