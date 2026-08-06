<%@ page import ="ezc.ezparam.*"%>
<%@ page import="ezc.client.*,java.util.*" %>
<jsp:useBean id="VendManager" class ="ezc.ezvendor.client.EzVendorManager" scope="page"></jsp:useBean>
<jsp:useBean id="OrderedDictionary" class="ezc.record.util.EzOrderedDictionary" scope = "session"></jsp:useBean>
<%
	double invoiceLCBAL = 0;
	double invoiceLCBALV = 0;
	String amtCurrency  = "";
	String amtOutAmount = "0";
	String amtOutAmountV = "0";
	
	String 	venCompCode =(String)session.getValue("COMPCODE");
	
	String outBalDate = request.getParameter("outBalDate");
	String vendor = soldTo;

	ezc.ezcommon.EzLog4j.log("::::::::VEND BAL::::::::::"+vendor,"I");

	final String ORDBAL = "ORDERBALANCE";
	final String INVBAL = "INVOICEBALANCE";
	final String ORDER = "PURCHASEORDER";   

	ezc.client.EzcPurchaseUtilManager ezUtil = new ezc.client.EzcPurchaseUtilManager(Session);

	EzSupplBalance supplbal = new EzSupplBalance();
	EzVendorParams vendparams_bal = new EzVendorParams();

	String dt = new ezc.ezutil.FormatDate().getStringFromDate(new Date(),".", ezc.ezutil.FormatDate.DDMMYYYY);

	int yr = (new Integer(dt.substring(6))).intValue();
	int mm = (new Integer(dt.substring(3,5))).intValue();
	int dd = (new Integer(dt.substring(0,2))).intValue();

	java.util.GregorianCalendar gc = new java.util.GregorianCalendar(yr,mm,dd);

	Date dt1 =  new Date(2001,10,24);
	
	if(outBalDate!=null && !"null".equals(outBalDate) && !"".equals(outBalDate))
	{
		dd = (new Integer(outBalDate.substring(0,2))).intValue();
		mm = (new Integer(outBalDate.substring(3,5))).intValue();
		yr = (new Integer(outBalDate.substring(6,10))).intValue();
		
		dt1 =  new Date(yr-1900,mm-1,dd);
	}
		
	ezc.ezparam.EzcVendorParams newParams_bal = new ezc.ezparam.EzcVendorParams();

	vendparams_bal.setToDate(dt1);
	vendparams_bal.setVendor(vendor);
	vendparams_bal.setCompCode(venCompCode);

	newParams_bal.createContainer();
	newParams_bal.setObject(vendparams_bal);
	Session.prepareParams(newParams_bal);

	try{
		supplbal = (EzSupplBalance)VendManager.getVendorBalance(newParams_bal);
	}catch(Exception e){}	
	
	if(supplbal!=null && supplbal.getRowCount()>0)
	{
		ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
		myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
		myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
		myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
		myFormat.setSymbol((String)session.getValue("CURRENCY"));

		for(int i=0;i<supplbal.getRowCount();i++)
		{
			if (!"O".equalsIgnoreCase(supplbal.getFieldValueString(i,"SPGLIND")))
			{
				try{
					invoiceLCBAL += Double.parseDouble(supplbal.getFieldValueString(i,"LCBAL"));
				}catch(Exception e){
					invoiceLCBAL += 0;
				}	
			}	
			
			//out.println(":::FOR:::::invoiceLCBAL:::::::::::::"+invoiceLCBAL);
		}
		if(invoiceLCBAL<0)
		{
			//invoiceLCBALV=(invoiceLCBAL*= -1);
		}
		else
		{
			invoiceLCBALV=invoiceLCBAL;
		}
		invoiceLCBAL *= -1;
		
		//out.println("::::::::invoiceLCBAL:::::::::::::"+invoiceLCBAL);

		amtCurrency = supplbal.getFieldValueString("LOCCURRENCY");
		amtOutAmount = myFormat.getCurrencyString(invoiceLCBAL).trim();
		amtOutAmountV = myFormat.getCurrencyString(invoiceLCBALV).trim();
	}	
%>

