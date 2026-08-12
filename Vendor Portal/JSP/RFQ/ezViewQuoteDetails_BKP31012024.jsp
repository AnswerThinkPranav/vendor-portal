<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iViewQuoteDetails.jsp"%>          
<%//@ include file="../../../Includes/JSPs/Inbox/iGetUploadDocs.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%>  
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*,java.lang.*"%>  
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>  
<%@ page import="java.text.*" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%!      
	public String checkNull(String str) 
	{ 
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str))
			retStr = "";
		else
			retStr = str;
			
		return retStr;	
	}
 	private String checkNull_Num(String str)
	{
		if("null".equals(str) ||str==null || "".equals(str))
			str="0";
		
		return str;
 	}	
%>
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
<%
	String statusCnt= request.getParameter("statusCnt");
	//out.println("statusCnt>>"+statusCnt);
	String qcfStatus="N";
	if("0".equals(statusCnt))
	{
		qcfStatus="Y";
	}
	out.println("qcfStatus>>"+qcfStatus);
	String rfqType="Quotation";
	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));
	
	java.util.Hashtable hashDisc = new java.util.Hashtable();
	hashDisc.put("P","Discount % on Basic");
	hashDisc.put("Q","Discount/Qty");
	hashDisc.put("V","Discount(Value)");
	hashDisc.put("","N/A");
	
	java.util.Hashtable hashPKFW = new java.util.Hashtable();
	hashPKFW.put("P","Pkg&Fwd chrgs(%)");
	hashPKFW.put("Q","Pkg&Fwd/Qty");
	hashPKFW.put("V","Pkg&Fwd chrg-value");
	hashPKFW.put("","N/A");
	
	java.util.Hashtable hashFRT = new java.util.Hashtable();
	hashFRT.put("P","Freight(%)");
	hashFRT.put("Q","Freight/Qty");
	hashFRT.put("V","Freight(Value)");
	hashFRT.put("","N/A");
	//******************************find Quote history*********************
	
	String counter="0";
	String rfqNumber=(String)dtlXML.getFieldValue(0,"ERH_RFQ_NO");		
	String dbInsQry = "SELECT MAX(ERQH_COUNTER) COUNT FROM EZC_RFQ_QUOTE_HISTORY  WHERE ERQH_RFQ_NO='"+rfqNumber+"'";
	String typeErh=dtlXML.getFieldValueString(0,"ERH_MAT_TYPE");  
	String leaddays=checkNull(dtlXML.getFieldValueString(0,"ERH_LEAD_DAYS"));  
	String percent=checkNull(dtlXML.getFieldValueString(0,"ERH_PERCENTAGE"));  
	ezc.ezparam.ReturnObjFromRetrieve retObj = null;
	if("".equals(leaddays))leaddays="0";
	ezc.ezparam.EzcParams hisParams = new ezc.ezparam.EzcParams(false); 				
	
	miscRfqTableRow.setQuery(dbInsQry);

	try
	{
		miscRfqTable.appendRow(miscRfqTableRow);
		hisParams.setLocalStore("Y");
		hisParams.setObject(miscRfqTable);
		Session.prepareParams(hisParams);
		retObj=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(hisParams);
		if(retObj!=null)counter=(String)retObj.getFieldValueString(0,"COUNT");

	}
	catch(Exception e){
	ezc.ezcommon.EzLog4j.log("Error while updatingRFQheader"+e,"E");
	}
	int cnt= 0; //Integer.parseInt(counter);
	
	try
	{
		cnt=Integer.parseInt(counter);
	}
	catch(Exception e){
		cnt=0;
	}	
	
	if("2".equals(userType))
	{
		if(cnt>1)
			rfqType="Re-Quoted RFQ Review by Buyer";
		else
			rfqType="Quotation Review by Buyer";
	}
	
%>
<style>

.modal-dialog {
  position: fixed;
  width: 50%;
  margin: 0;
  padding: 10px;
}

.table thead th {
   
    padding: 10px;
    text-align: left;
   
    white-space: nowrap;
}
.table tbody td {
   
    padding: 10px;
  
    white-space: nowrap;
}
.zui-wrapper {
    position: relative;
}
.zui-scroller {

    overflow-x: scroll;
    overflow-y: visible;
    padding-bottom: 5px;
    
       width: auto;
   
}
.table .zui-sticky-col {
    border-left: solid 1px #DDEFEF;
    border-right: solid 1px #DDEFEF;
    left: 22px;
    position: absolute;
    top: auto;
    width: 120px;
}
</style>
<link href="../../Library/Styles/ezCurrecy.css" rel="stylesheet">
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->  
<section class="content-header">
   <h1>
     <%=qtn_Rev_Buyer_L%>
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post"> 
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	<input type="hidden" name="rfqType" value=<%=request.getParameter("rfqType")%>>
	<input type="hidden" name="EndDate" value="<%=CDate%>">  
	<input type="hidden" name="OrderDate" value="<%=ordDate%>">
	<input type="hidden" name="PurchaseOrder" value="<%=poNum%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVendor%>" >
	<input type="hidden" name="rfqBuyer" value="<%=rfqBuyer%>" >
	<input type="hidden" name="vendCat" value="<%=vendCat%>" >
	<input type="hidden" name="calType" value="" >
	
<%
	String reqFrom =request.getParameter("type");
	String expStat1 =request.getParameter("expStat");
	//out.println("expStat1>>>>>"+expStat1); 
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();    
	String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
	SimpleDateFormat formatter1   = new SimpleDateFormat("dd/MM/yyyy HH:mm"); 	
	SimpleDateFormat formatter2   = new SimpleDateFormat("dd/MM/yyyy"); 	
	
	Date             rfqCloseDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_VALID_UPTO");
	
%>
	<input type="hidden" name="type" value="<%=reqFrom%>">
<%
	
	String ldYes="",ldNo="",pgYes="",pgNo="";
	String displdApp="none",disppgApp="none";
	String disabledStr="onclick='return false'";
	String ldStatus = checkNull(rfqLinesRet.getFieldValueString(0,"LDSTATUS"));
	String ldClause = checkNull(rfqLinesRet.getFieldValueString(0,"LDCLAUSE"));
	if("Y".equals(ldStatus))
	{
		ldYes="checked";
		displdApp="";
	}	
	else
	{
		ldNo="checked";
		displdApp="none";
	}	
		
 	String pgStatus = checkNull(rfqLinesRet.getFieldValueString(0,"PGSTATUS"));
 	String pgClause = checkNull(rfqLinesRet.getFieldValueString(0,"PGCLAUSE"));
	if("Y".equals(pgStatus))
	{
		pgYes="checked";
		disppgApp="";
	}	
	else
	{
		pgNo="checked"; 
		disppgApp="none";
	}
	String purOrg=(String)dtlXML.getFieldValue(0,"ERH_PUR_ORG");		
	ezc.ezcommon.EzLog4j.log("purOrg"+purOrg,"I");
	//String discType = checkNull(rfqLinesRet.getFieldValueString(0,"DISCTYPE")); 	
 	//out.println("discType>>"+discType);
 	
 	//DOMESTIC
	
	//String PKFWType = checkNull(rfqLinesRet.getFieldValueString(0,"PKFWTYPE"));
	//String condPKFW = rfqLinesRet.getFieldValueString(0,"PKFWVAL");
	//String FRTType = checkNull(rfqLinesRet.getFieldValueString(0,"FRTTYPE"));
	//String condFRT = rfqLinesRet.getFieldValueString(0,"FRTVAL");
	//String BFRTType = checkNull(rfqLinesRet.getFieldValueString(0,"BFRTTYPE"));
	//String condBFRT = rfqLinesRet.getFieldValueString(0,"BFRTVAL");
	//String INSType = checkNull(rfqLinesRet.getFieldValueString(0,"INSTYPE"));
	//String condINS = rfqLinesRet.getFieldValueString(0,"INSVAL");
	
	
	//IMPORT
	String condBCD 	= rfqLinesRet.getFieldValueString(0,"BCDVAL");
	String condSWC 	= rfqLinesRet.getFieldValueString(0,"SWCVAL");
	String condCHA 	= rfqLinesRet.getFieldValueString(0,"CHAVAL");
	String IFRTType = rfqLinesRet.getFieldValueString(0,"IFRTTYPE");
	String condIFRT = rfqLinesRet.getFieldValueString(0,"IFRTVAL");
	String DUTYType = rfqLinesRet.getFieldValueString(0,"DUTYTYPE");
	String condDUTY = rfqLinesRet.getFieldValueString(0,"DUTYVAL");
	
	
	//String CUSTType = checkNull(rfqLinesRet.getFieldValueString(0,"CUSTTYPE"));
	//String condCUST = "0";   //rfqLinesRet.getFieldValueString(0,"CUSTVAL");	
	//String condCESS = "0";   //rfqLinesRet.getFieldValueString(0,"CESSVAL");
	
	
	
	String condGST ="0";
	
	for(int i=0;i<rfqLinesRetCnt;i++)
      	{
		String itemcondGST= rfqLinesRet.getFieldValueString(i,"GSTVAL");
		if("".equals(itemcondGST) || "null".equals(itemcondGST) || itemcondGST==null)  
		itemcondGST = "0";
		
		double condGSTDb=Double.parseDouble(condGST)+Double.parseDouble(itemcondGST);
		condGST=new java.math.BigDecimal(condGSTDb).setScale(0,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
		
	}	

	
	/*if("".equals(condPKFW) || "null".equals(condPKFW) || condPKFW==null) 
		condPKFW = "0"; 
	if("".equals(condFRT) || "null".equals(condFRT) || condFRT==null) 
		condFRT = "0";
	if("".equals(condBFRT) || "null".equals(condBFRT) || condBFRT==null) 
		condBFRT = "0";	
	if("".equals(condINS) || "null".equals(condINS) || condINS==null) 
		condINS = "0";		
	if("".equals(condBCD) || "null".equals(condBCD) || condBCD==null) 
		condBCD = "0"; */	
		
		

	String discType = ""; 
	String condDisc	= "0";
	String PKFWType = ""; 
	String condPKFW	= "0";	
	String FRTType 	= "";
	String condFRT 	= "0";
	String BFRTType = "";
	String condBFRT = "0";
	String INSType 	= "";
	String condINS 	= "0";

	double totVal = 0.0;
	double totQty = 0.0;
	double totdiscVal = 0.0;
	double discVal = 0.0;
	double PKFWVal = 0.0;
	double totPKFWVal = 0.0;
	double FRTVal = 0.0;
	double totFRTVal = 0.0;
	double BFRTVal = 0.0;
	double totBFRTVal = 0.0;
	double INSVal = 0.0;
	double totINSVal = 0.0;	
	double GSTVal = 0.0;
	double sPrice = 0.0;
	double BCDVal = 0.0;
	double SWCVal = 0.0;
	double CHAVal = 0.0;
	double IFRTVal = 0.0;
	double DUTYVal=0.0;
	double grossVal = 0.0;
	double grossValInr = 0.0;
	double landCostValue=0.0;
	double landCostValueImp=0.0;
	double lineItemVal=0.0;
	double lineItemPrice=0.0;
	double lineGSTVal=0.0;
	double totGSTVal=0.0;
	double totCostVal=0.0;
	
	
	
	String landCostValueStr="0";
	String landCostValueImpStr="0";
	String totValStr="0";
	String discValStr="0";
	String PKFWValStr="0";
	String FRTValStr="0";
	String BFRTValStr="0";
	String INSValStr="0";
	String GSTValStr="0";
	String sPriceStr = "0";
	String BCDValStr = "0";
	String SWCValStr = "0";
	String CHAValStr = "0";
	String IFRTValStr = "0";
	String DUTYValStr = "0";
	String grossValStr = "0";
	String grossValInrStr="0";
	String totalCostStr = "0";
	
	
	
	for(int d=0;d<rfqLinesRet.getRowCount();d++)
	{
	
		String myQtyLines = rfqLinesRet.getFieldValueString(d,"QTY");
		
		//out.println("myQtyLines>>"+myQtyLines);
		String quotPriceLines = rfqLinesRet.getFieldValueString(d,"PRICE");

		String itemcondGST= rfqLinesRet.getFieldValueString(d,"GSTVAL");
		if("".equals(itemcondGST) || "null".equals(itemcondGST) || itemcondGST==null)  
			itemcondGST = "0";		
		totQty=totQty+(Double.parseDouble(myQtyLines));
		try
		{
		//totVal= (Double.parseDouble(myQtyLines) * Double.parseDouble(quotPriceLines));
		totVal=totVal+(Double.parseDouble(myQtyLines) * Double.parseDouble(quotPriceLines));
		
		}
		catch(Exception e){ 
		totVal = 00.0;  
		}
		
		try
		{
		lineItemVal= (Double.parseDouble(myQtyLines) * Double.parseDouble(quotPriceLines));
		}
		catch(Exception e){ 
		lineItemVal = 00.0;  
		}		
		//out.println("lineItemVal>>>"+lineItemVal);
		try
		{
		
		discType = checkNull(rfqLinesRet.getFieldValueString(d,"DISCTYPE")); 
		condDisc = rfqLinesRet.getFieldValueString(d,"DISCVAL"); 
		if("".equals(condDisc) || "null".equals(condDisc) || condDisc==null) 
			condDisc = "0";
		//out.println("condDisc>>"+condDisc);			
		
		if("P".equals(discType))
			discVal= lineItemVal * Double.parseDouble(condDisc)/100;
		else if("Q".equals(discType))
			discVal= (Double.parseDouble(myQtyLines)* Double.parseDouble(condDisc))/100 ;
		else if("V".equals(discType))
			discVal= Double.parseDouble(condDisc);	

		totdiscVal=totdiscVal+discVal;
		}
		catch(Exception e){ 
			discVal = 00.0;  
		}
		//out.println("discVal>>"+discVal);
		PKFWType = checkNull(rfqLinesRet.getFieldValueString(d,"PKFWTYPE"));
		condPKFW = rfqLinesRet.getFieldValueString(d,"PKFWVAL");
		try
		{
		if("P".equals(PKFWType))
			PKFWVal= (lineItemVal-discVal) * Double.parseDouble(condPKFW)/100;
		else if("Q".equals(PKFWType))
			PKFWVal= (Double.parseDouble(myQtyLines) * Double.parseDouble(condPKFW))/100;
		else if("V".equals(PKFWType))
			PKFWVal= Double.parseDouble(condPKFW);	
			
			totPKFWVal= PKFWVal;
		
		/*if("V".equals(PKFWType))
			totPKFWVal= PKFWVal;
		else
			totPKFWVal=totPKFWVal+PKFWVal;*/

		}
		catch(Exception e){ 
		PKFWVal = 00.0;  
		}
		FRTType = checkNull(rfqLinesRet.getFieldValueString(d,"FRTTYPE"));
		condFRT = rfqLinesRet.getFieldValueString(d,"FRTVAL");
		
		try
		{
		if("P".equals(FRTType))
			FRTVal= (lineItemVal-discVal) * Double.parseDouble(condFRT)/100;
		else if("Q".equals(FRTType))
			FRTVal= Double.parseDouble(condFRT) * totQty;
		else if("V".equals(FRTType))
			FRTVal= Double.parseDouble(condFRT);
		
		totFRTVal=FRTVal;
		/*if("V".equals(FRTType))
			totFRTVal=FRTVal;
		else
			totFRTVal=totFRTVal+FRTVal; */
			
		}
		catch(Exception e){ 
		FRTVal = 00.0;  
		}
		//BFRT
		BFRTType = checkNull(rfqLinesRet.getFieldValueString(d,"BFRTTYPE"));
		condBFRT = rfqLinesRet.getFieldValueString(d,"BFRTVAL");
		try
		{
		if("P".equals(BFRTType))
			BFRTVal= (lineItemVal-discVal) * Double.parseDouble(condBFRT)/100;
		else if("Q".equals(BFRTType))
			BFRTVal= Double.parseDouble(condBFRT) * totQty;
		else if("V".equals(BFRTType))
			BFRTVal= Double.parseDouble(condBFRT); 
			
			totBFRTVal=BFRTVal;
		
		/*if("V".equals(BFRTType))
			totBFRTVal=BFRTVal;
		else
			totBFRTVal=totBFRTVal+BFRTVal; */
		
		}
		catch(Exception e){ 
		BFRTVal = 00.0;  
		}
		//INS
		INSType = checkNull(rfqLinesRet.getFieldValueString(d,"INSTYPE"));
		condINS = rfqLinesRet.getFieldValueString(d,"INSVAL");		
		try
		{
		if("P".equals(INSType))
			INSVal= (lineItemVal-discVal) * Double.parseDouble(condINS)/100;
		else if("Q".equals(INSType))
			INSVal= Double.parseDouble(condINS) * totQty;
		else if("V".equals(INSType))
			INSVal= Double.parseDouble(condINS);
			
			totINSVal=INSVal;
		
		/*if("V".equals(INSType))
			totINSVal=INSVal;
		else
			totINSVal=totINSVal+INSVal; */
		}
		catch(Exception e){ 
		INSVal = 00.0;  
		}		
		try
		{
		lineItemPrice= lineItemVal - discVal +PKFWVal+FRTVal+BFRTVal+INSVal;
		}
		catch(Exception e){ 
		lineItemPrice = 00.0;  
		}
		//out.println("lineItemPrice>>>"+lineItemPrice);
		//GST VAL LINE ITEM WISE
		
		lineGSTVal= lineItemPrice * Double.parseDouble(itemcondGST)/100;
		//out.println("lineGSTVal>>>"+lineGSTVal);
		totGSTVal= totGSTVal+ lineGSTVal;
		//out.println("totGSTVal>>>"+totGSTVal);
		
		
		
		
	}

	totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
	discValStr  = new java.math.BigDecimal(totdiscVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	PKFWValStr  = new java.math.BigDecimal(totPKFWVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	FRTValStr  = new java.math.BigDecimal(totFRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	BFRTValStr  = new java.math.BigDecimal(totBFRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	INSValStr  = new java.math.BigDecimal(totINSVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	GSTValStr  = new java.math.BigDecimal(totGSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		
	//SUPPLY PRICE
	try
	{
	sPrice= totVal-totdiscVal+totPKFWVal+totFRTVal+totBFRTVal+totINSVal;
	sPriceStr  = new java.math.BigDecimal(sPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	}
	catch(Exception e){ 
	sPrice = 00.0;  
	}
	
	if("Credit".equals(typeErh))
	{
	
		landCostValue=sPrice-(((sPrice)*(Double.parseDouble("8")/Double.parseDouble("100")*(Double.parseDouble("1")/Double.parseDouble("365")))*Double.parseDouble(leaddays)));
	
	}
	if("Advance".equals(typeErh))
	{
	       landCostValue=sPrice-(((sPrice)*(Double.parseDouble("8")/Double.parseDouble("100"))*(Double.parseDouble("1")/Double.parseDouble("365"))*(Double.parseDouble("1")/(Double.parseDouble(percent))))*Double.parseDouble(leaddays));
	
	}	
	
	landCostValueStr=new java.math.BigDecimal(landCostValue).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
	
	
	if("IMP".equals(vendCat))
	{
		try
		{
			BCDVal= sPrice * Double.parseDouble(condBCD)/100;
			BCDValStr  = new java.math.BigDecimal(BCDVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){ 
			BCDVal = 0.0;  
		}
		try
		{
			SWCVal= BCDVal * Double.parseDouble(condSWC)/100;
			SWCValStr  = new java.math.BigDecimal(SWCVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){ 
			SWCVal = 0.0;  
		}
		try
		{
			CHAVal= Double.parseDouble(condCHA);
			CHAValStr  = new java.math.BigDecimal(CHAVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){ 
			CHAVal = 0.0;  
		}
		try
		{
			if("P".equals(IFRTType))
				IFRTVal= sPrice * Double.parseDouble(condIFRT)/100;
			else if("Q".equals(IFRTType))
				IFRTVal= Double.parseDouble(condIFRT) * totQty;
			else if("V".equals(IFRTType))
				IFRTVal= Double.parseDouble(condIFRT);

			IFRTValStr  = new java.math.BigDecimal(IFRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){ 
			IFRTVal = 0.0;  
		}
		try
		{
			condGST  = Double.parseDouble(condGST)/(rfqLinesRet.getRowCount())+"";
			condGST  = new java.math.BigDecimal(condGST).setScale(0,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
		}
		catch(Exception e){ 
			condGST = "0";  
		}		
		try
		{
			totGSTVal  = ((sPrice + BCDVal +SWCVal)* Double.parseDouble(condGST)/100);
			GSTValStr  = new java.math.BigDecimal(totGSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
		}
		catch(Exception e){ 
			totGSTVal = 0.0;  
		}
		try
		{
		if("E".equals(DUTYType))
			DUTYVal=  BCDVal+SWCVal;
		else if("D".equals(FRTType))
			DUTYVal= Double.parseDouble("0");
			
			DUTYValStr  = new java.math.BigDecimal(DUTYVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
		}
		catch(Exception e){ 
			DUTYVal = 0.0;  
		}
		if("Credit".equals(typeErh))
		{

			landCostValue=sPrice-(((sPrice)*(Double.parseDouble("8")/Double.parseDouble("100")*(Double.parseDouble("1")/Double.parseDouble("365")))*Double.parseDouble(leaddays)));

		}
		if("Advance".equals(typeErh))
		{
		       landCostValue=sPrice-(((sPrice)*(Double.parseDouble("8")/Double.parseDouble("100"))*(Double.parseDouble("1")/Double.parseDouble("365"))*(Double.parseDouble("1")/(Double.parseDouble(percent))))*Double.parseDouble(leaddays));

		}			
		
	}
	
	//GROSS VALUE
	try
	{
		if("DOM".equals(vendCat))
		{
			grossVal= totVal-totdiscVal+totPKFWVal+totFRTVal+totBFRTVal+totINSVal+totGSTVal;
			grossValStr  = new java.math.BigDecimal(grossVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		else
		{
			grossVal= totVal-totdiscVal+totPKFWVal+totFRTVal;
			grossValStr  = new java.math.BigDecimal(grossVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			grossValInr = grossVal * 74.25;
			grossValInrStr  = new java.math.BigDecimal(grossValInr).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
			totCostVal= grossVal+BCDVal+SWCVal+CHAVal+IFRTVal+totGSTVal;
			totalCostStr  = new java.math.BigDecimal(totCostVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();	
			
			landCostValueImp= grossVal+BCDVal+SWCVal+CHAVal+IFRTVal+totGSTVal-DUTYVal-totGSTVal;
			landCostValueImpStr=new java.math.BigDecimal(landCostValueImp).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 	
			
		}
	}
	catch(Exception e){ 
	grossVal = 00.0;  
	}	

			
		
 	String 	 qtndate      = convertDateObjToString(chgDate);    
 	if(("3".equals(userType)) && ("Req".equals(reqFrom) &&  "Y".equals(qcfStatus)) || ("4".equals(userType)) && ("Req".equals(reqFrom)&&  "Y".equals(qcfStatus))) 
 		qtndate      = convertDateObjToString(new Date());
 		
 	String readonlyLeadTime="readonly";
 	if ((QuotNo!=null)&&(QuotNo.trim().length() > 0))  
	{
%>
	<!-- Table row -->
      <div class="row">
	<div class="col-xs-12 table-responsive" style="overflow-x: hidden;"> 	    
	<table class="table table-bordered">
	<tr>
	<th align="left" width="25%"><%=req_Ref_No_L%></th>
      	<td valign="middle" align="left" width="25%"><%=poNum%><input type="hidden" name="RfqNo" value="<%=poNum%>"></td>
	<th align="left" width="25%"><%=RFQ_Date_L%></th>
      	<td valign="middle" align="left" width="25%" colspan=3><%=OrderDate%></td>
	</tr>
	<tr>
	<th align="left" width="25%"><%=quot_end_Date_L%></th>
	<td valign="middle" align="left" width="25%"><%=formatter2.format(rfqCloseDate)%></td>	
	<th align="left" width="25%"><%=Qtn_Date_L%></th>
<%      	
	if(("3".equals(userType)) && ("Req".equals(reqFrom) &&  "Y".equals(qcfStatus)) || ("4".equals(userType)) && ("Req".equals(reqFrom)&&  "Y".equals(qcfStatus)))       	
	{
%>	
		<td valign="middle" align="left" width="25%" colspan=3><%=formatter2.format(new Date())%>      	
<%
	}else{
%>
		<td valign="middle" align="left" width="25%" colspan=3><%=formatter2.format(chgDate)%>
		
<%
	}
%>	
	<input type="hidden" name="QtnDate" value="<%=qtndate%>">
	<input type="hidden" name="QtnEndDate" value="<%=formatter2.format(rfqCloseDate)%>">
	&nbsp;</td>
	
	</tr>
	<!--<tr>
	<th align="left" width="25%">All Conditions</th>
	<td width="75%"><a href='javascript:funOpen()'>Click</a></td>
	</tr>	
	<tr>
		<th align="left" width="25%">LD Clause</th>
		<td colspan="5" class="form-control">&nbsp;&nbsp; 
		<%=checkNull(dtlXML.getFieldValueString(0,"ERH_LD_CLAUSE"))%></td>
		
	
	</tr>	-->
	
	<tr>
		<th align="left" width="25%"><%=pmt_Terms_L%></th>
		<td width="25%" colspan="3">
		<%if(("3".equals(userType) && "Req".equals(reqFrom) &&  "Y".equals(qcfStatus)) || ("4".equals(userType) && "Req".equals(reqFrom)&&  "Y".equals(qcfStatus)) || ("2".equals(userType) && "Act".equals(reqFrom)&& "Y".equals(qcfStatus))) {%>
		 
		<select id="PaymentTerms" name=PaymentTerms class="form-control input-sm select2" style="width:100% !important" >
				<option value="">Select Payment Terms</option>
	<%
				int pmntLen   = pmntObj.getRowCount();
				String payterm=dtlXML.getFieldValueString(0,"ERH_PAYMENT_TERMS");
				for(int j=0;j<pmntLen;j++)
				{
					
					String payStr = pmntObj.getFieldValueString(j,"EMKV_KEY").trim();
					if(payStr.equals(payterm))
					{
	%>
						<Option value=<%=payStr%> selected><%=payStr%>--><%=pmntHash.get(payStr)%></Option>
	<%
					}
					else
					{
	%>
						<Option value=<%=payStr%> ><%=payStr%>--><%=pmntHash.get(payStr)%></Option>
	<%
					}
				}
	%>
				</select>
		 
		 <%}else{
		 try{
				out.println(dtlXML.getFieldValueString(0,"ERH_PAYMENT_TERMS")+"-->"+pmntHash.get(dtlXML.getFieldValueString(0,"ERH_PAYMENT_TERMS")));
			}catch(Exception e){
				out.println("&nbsp;");
			}
		    }	
		%>
	</td>

	<tr>
	<th align="left" width="25%"><%=inco_Terms_L%></th>
	<td width="25%" colspan="3">
	 <%if(("3".equals(userType) && "Req".equals(reqFrom)&&  "Y".equals(qcfStatus)) || ("4".equals(userType) && "Req".equals(reqFrom)&&  "Y".equals(qcfStatus)) || ("2".equals(userType) && "Act".equals(reqFrom)&&  "Y".equals(qcfStatus))) {%>
	 <select name="IncoTerms" id="IncoTerms"  class="form-control input-sm select2" style="width:100% !important" >
			<option value="">Select Inco Terms</option>
<%
	 		int incoLen   = incoObj.getRowCount();
	 		String incoterm=dtlXML.getFieldValueString(0,"ERH_INCO_TERMS1");
	 
		for(int j=0;j<incoLen;j++)
		{
			String incoStr = incoObj.getFieldValueString(j,"EMKV_KEY").trim();
			if(incoStr.equals(incoterm))
			{
%>
			<Option value=<%=incoStr%> selected><%=incoStr%>--><%=incoHash.get(incoStr)%></Option>
<%
			}
			else
			{

%>
			<Option value=<%=incoStr%> ><%=incoStr%>--><%=incoHash.get(incoStr) %></Option>
<%
			}

		}
%>
		</select>
	 
	<%}else{
		try{
			out.println(dtlXML.getFieldValueString(0,"ERH_INCO_TERMS1")+"-->"+incoHash.get(dtlXML.getFieldValueString(0,"ERH_INCO_TERMS1")));
		}catch(Exception e){
			out.println("&nbsp;");   
		}
	}	
	%></td>	
	</tr>
	<tr>
	<th align="left" width="25%"><%=LD_Clau_App_L%></th>
	<td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="ldApp" value="Y" <%=ldYes%> <%=disabledStr%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;<input type="radio"  name="ldApp" value="N" <%=ldNo%> <%=disabledStr%>>&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;
		
	</td>	
	<th align="left" width="25%" id="ldClause" style="display:<%=displdApp%>;" ><%=LD_Clau_L%></th>
		<td id="ldVal" style="display:<%=displdApp%>;">
			<textarea name = 'ldTxt' style='width:100%' rows=3 cols=73 value="<%=ldClause%>" readonly ><%=ldClause%></textarea>
	</td>
	</tr>
	<tr>
	<th align="left" width="25%"><%=per_Grnt_L%></th>
	<td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="pgApp" value="Y" <%=pgYes%> <%=disabledStr%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;<input type="radio"  name="pgApp" value="N" <%=pgNo%> <%=disabledStr%>>&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;
			
	</td>
	<th align="left" width="25%" id="pgClause" style="display:<%=disppgApp%>;" >Remarks</th>
	<td id="pgVal" style="display:<%=disppgApp%>;">
		<textarea name = 'pgTxt' style='width:100%' rows=3 cols=73  value="<%=pgClause%>" readonly><%=pgClause%></textarea>
	</td>		
	</tr>	
	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->
	<div >
  	<!-- Table row -->
        <div class="row">
	<div class="col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<div class="zui-wrapper">
	<div class="zui-scroller">	
	<table class="table table-bordered  table-responsive">	
	<thead>
		<tr>
			<th><%=RFQ_line_L%></th>
			<th><%=RFQ_Mat_L%></th>
			<th><%=RFQ_Des_L%></th>
			<th><%=RFQ_Mat_GrpL%></th>
			<th><%=HSN_SAC_L%></th>
			<!--<th>Plant</th>-->

			<!--<th>Query</th>-->
			<th><%=RFQ_Qty_L%></th>
			<th><%=RFQ_per_L%></th>
			<th><%=RFQ_UOM_L%></th>
			
			<!--<th>Lead<br>Time(days)</th>-->
			<%if("2".equals(userType)){%>			
			<th><%=last_PO_Price_L%></th>
			<th><%=bud_Price_L%></th>
			<%}%>
			<th><%=RFQ_Mrp_Price_L%></th>
			<th><%=RFQ_Basic_Price_L%></th>
			<th><%=RFQ_Currency_L%></th>
			<th><%=RFQ_Cond_L%></th>
			<th><%=total_L%></th>
			<th><%=remarks_L%></th>
			<th><%=RFQ_del_date_L%></th>
			<!--<th>Discount</th>
			<th>Discount Value</th>
			<th>GST(%)</th>-->
			
			<th><%=RFQ_Warr_L%></th>
			<th><%=item_text_L%></th>
			<th><%=PO_Text_L%></th>			
			
			<!--<th>Total</th>
			<th>Discount Type</th>
			<th>Discount</th>
			<th>Discount Value</th>
			<th>Pkg & Fwd Type</th>
			<th>Pkg & Fwd Chrgs</th>
			<th>Pkg & Fwd Value</th>
			<th>Freight Type</th>
			<th>Freight</th>
			<th>Freight Value</th>
			<th>Supply Price</th> 
			<th>GST(%)</th>
			<th>GST Value</th>
			<th>Gross Value</th>
			<th>Conditions</th>-->
			
<%
		if("2".equals(userType) || "3".equals(userType) || "4".equals(userType) )
		{
%>			
			<!--<th style="background-color:coral">History</th>-->
<%
		}
%>			

			
			
		</tr>	
	</thead>
        <tbody>
    	
 	<%
 	double tt1,tt2;
 	java.math.BigDecimal finalQty=null;
 	double totFinalValue=0.0;
 	//out.println(rfqLinesRet.toEzcString());
 	
 	//String curr="INR";//This is hardcoded for CEAT testing
 	curr="INR";//This is hardcoded for CEAT testing
 	

	
	ReturnObjFromRetrieve retcur = null;
	EzcSysConfigParams sparams1 = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams1 = new EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	retcur = (ReturnObjFromRetrieve)ConfigManager.getCurrencyDesc(sparams1);

	String fields[]= new String []{ "ECD_LONG_DESC"};
	retcur.sort(fields,true);
	int currLength = retcur.getRowCount();
	String totvalueLines="0";
      	for(int i=0;i<rfqLinesRetCnt;i++)
      	{
		/*String curr = dtlXML.getFieldValueString(i,"AMOUNT");
		String net  = dtlXML.getFieldValueString(i,"NET_VALUE");  
		
		String amt = curr;
		
		Double ddde=new Double(Double.parseDouble(curr));
		tt2=ddde.doubleValue()*100.0;
		
		amt = tt2+"";
		
		try
		{
			amt  = new java.math.BigDecimal(amt).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}catch(Exception e){}*/
      		
      		String myQty = rfqLinesRet.getFieldValueString(i,"QTY");
		
		try
		{
			myQty = (Double.parseDouble(myQty))+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(3,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}catch(Exception e){}
		
      		String mrpPrice = checkNull_Num(rfqLinesRet.getFieldValueString(i,"MRP"));
		try
		{
			mrpPrice = (Double.parseDouble(mrpPrice))+"";
			mrpPrice  = new java.math.BigDecimal(mrpPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}catch(Exception e){}	
		
      		String budgetPrice = "0";
      		budgetPrice = checkNull_Num(rfqLinesRet.getFieldValueString(i,"BUDGET"));
		try
		{
			budgetPrice = (Double.parseDouble(budgetPrice))+"";
			budgetPrice  = new java.math.BigDecimal(budgetPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}catch(Exception e)
		{
			budgetPrice="0";
		}    		
      		
      		String matNum = rfqLinesRet.getFieldValueString(i,"MATERIAL");
		matNum ="000000000000000000"+matNum;
		matNum =matNum.substring(matNum.length()-18);   
		String rfqPlant=(String)dtlXML.getFieldValueString(0,"ERD_PLANT");
		String uom = rfqLinesRet.getFieldValueString(i,"UOM");
		if("LE".equals(uom))
			uom="AU";
		
      		String lastPOPrice = "0";
		
		//To fetch last PO price			
		java.math.BigDecimal netPR=new java.math.BigDecimal(0);
		JCoFunction function =null;	
		String logonSite = (String)session.getValue("SITE");

		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
		function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_LAST_PO_PRICE");

		JCoParameterList sapPreProc = function.getImportParameterList();
		sapPreProc.setValue("PUR_ORG",purOrg);

		JCoParameterList sapTabParam= function.getTableParameterList();
		JCoTable poItemTable = sapTabParam.getTable("POITEMS");
		poItemTable.appendRow();
		poItemTable.setValue("MATNR",matNum);

		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in Z_EZ_GET_LAST_PO_PRICE FM Exectution:::::::::::::::"+qe,"I");
		}	
		
		int poCnt =0;
		ArrayList items =null;
		JCoTable sapPoList = function.getTableParameterList().getTable("POITEMS"); 
		poCnt 	= 	sapPoList.getNumRows();
		ezc.ezcommon.EzLog4j.log("poCnt:::::::::::::::"+poCnt,"I");
		
		ezc.ezparam.ReturnObjFromRetrieve myRet= null;

		if(poCnt > 0)
		{
			myRet= new ReturnObjFromRetrieve(new String[]{"VENDOR","VENDNAME","PLANT","MATERIAL","PONUM","CREATED_ON","UOM","CURRENCY","NETPR"});

		try 
		{		
			do
			{
				

				myRet.setFieldValue("VENDOR", sapPoList.getValue("LIFNR"));		
				myRet.setFieldValue("VENDNAME",sapPoList.getValue("NAME1"));		
				myRet.setFieldValue("PLANT",sapPoList.getValue("WERKS"));
				myRet.setFieldValue("MATERIAL",sapPoList.getValue("MATNR"));
				myRet.setFieldValue("PONUM",sapPoList.getValue("EBELN"));
				myRet.setFieldValue("CREATED_ON",sapPoList.getValue("AEDAT"));
				myRet.setFieldValue("UOM",sapPoList.getValue("MEINS"));
				myRet.setFieldValue("CURRENCY",sapPoList.getValue("WAERS"));
				myRet.setFieldValue("NETPR",sapPoList.getValue("NETPR"));
				myRet.addRow();


				
				String lastPOPlant=(String)sapPoList.getValue("WERKS");
				if(netPR.compareTo(java.math.BigDecimal.ZERO)!=0)
					if(rfqPlant.equals(lastPOPlant))
						netPR=(java.math.BigDecimal)sapPoList.getValue("NETPR");

			  		ezc.ezcommon.EzLog4j.log("rfqPlant"+rfqPlant,"I");
			  		ezc.ezcommon.EzLog4j.log("lastPOPlant"+lastPOPlant,"I");
			  		
			  }while(sapPoList.nextRow());
			  		
			 //out.println("myRet"+myRet.toEzcString());

		}
		catch (Exception e) {} 
		
		}
		if(myRet!= null)
		{
			String netPrStr=checkNull(myRet.getFieldValueString(0,"NETPR"));   
			java.math.BigDecimal netprBD=new java.math.BigDecimal(netPrStr);
			if(netPR.compareTo(java.math.BigDecimal.ZERO)==0)netPR=netprBD;
		}	
		
		
      		
      		if(("2".equals(userType) && "Act".equals(reqFrom)) || ("2".equals(userType) && "Req".equals(reqFrom)))
      		{
      			SimpleDateFormat formatter3   = new SimpleDateFormat("yy"); 	
      			String currYear = formatter3.format(Calendar.getInstance().getTime());
      			String finYear =  "FY"+"-"+currYear+"-"+(Integer.parseInt(currYear)+1);
      			String dispMonth = "";
      			//out.println("finYear>>>"+finYear);
      			
      			int currMonth = (Calendar.getInstance().get(Calendar.MONTH)+1);
      			
      			
      			if(currMonth<10)
      				dispMonth = "0"+String.valueOf(currMonth);
      			else
      				dispMonth = String.valueOf(currMonth);
      			//out.println("dispMonth>>>"+dispMonth);
      			
      			String dispMat = "";
      			
      			try
      			{	
      				dispMat = Long.parseLong(matNum)+"";
      			}
      			catch(Exception e)
      			{
      				dispMat = matNum;
      			}
      			
      					
      			
			ezc.ezparam.ReturnObjFromRetrieve budgetRet	=  null;
		    		
      			//Getting Budget Price
      	
      			//qryStr="SELECT EMBP_BASIC_PRICE FROM EZC_MAT_BUDGET_PRICE WHERE EMBP_MATERIAL='"+matNum+"'" ;
      			qryStr="select embp_basic_price from ezc_mat_budget_price where embp_fin_year='"+finYear+"' and embp_plant='"+rfqPlant+"' and embp_month='"+dispMonth+"' and EMBP_MATERIAL in('"+dispMat+"')";
			ezc.ezcommon.EzLog4j.log("** qryStrPRICE>>>"+qryStr,"I");

			miscRfqTableRow.setQuery(qryStr);
			miscRfqTable.appendRow(miscRfqTableRow);
			newParams.setLocalStore("Y");
			newParams.setObject(miscRfqTable);
			Session.prepareParams(newParams);  
		
			try
			{
				budgetRet=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(newParams);

			}
			catch(Exception e)
			{
				out.println("Exception in getting conditions>>>>>"+e);
			}

			if(budgetRet!=null && budgetRet.getRowCount()>0)
			{
				budgetPrice = budgetRet.getFieldValueString(0,"EMBP_BASIC_PRICE");

			}		
      		
      		}
      		
      		String quotPrice = rfqLinesRet.getFieldValueString(i,"PRICE");
		
		try
		{
			quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}catch(Exception e){}		
		
		double totValItem = 0.0;
		totVal=Double.parseDouble(myQty)*Double.parseDouble(quotPrice);
		totVal  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).doubleValue();
		//out.println("totVal>>"+totVal);
		
		String discTypeLine= "0";
		String condDiscLine= "0";
		double discValDB=0.0;
		String totItemVal="";
		try{
			discTypeLine = checkNull(rfqLinesRet.getFieldValueString(i,"DISCTYPE")); 
			condDiscLine=rfqLinesRet.getFieldValueString(i,"DISCVAL");
			
		if("P".equals(discTypeLine))
			discValDB= totVal* Double.parseDouble(condDiscLine)/100;
		else if("Q".equals(discTypeLine))
			discValDB= (Double.parseDouble(myQty)* Double.parseDouble(condDiscLine));
		else if("V".equals(discTypeLine))
			discValDB= Double.parseDouble(condDiscLine);
		
		totItemVal=new java.math.BigDecimal(totVal-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(totVal-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){out.println("exceptionin cal"+e);}
		//LINE PKFW
		String PKFWTypeLine= "0";
		String condPKFWLine= "0";
		double PKFWValDB=0.0;		
		try{
			PKFWTypeLine = checkNull(rfqLinesRet.getFieldValueString(i,"PKFWTYPE")); 
			condPKFWLine = checkNull_Num(rfqLinesRet.getFieldValueString(i,"PKFWVAL"));
			
				if("P".equals(PKFWTypeLine))
					PKFWValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condPKFWLine)/100;
				else if("Q".equals(PKFWTypeLine))
					PKFWValDB= (Double.parseDouble(myQty)* Double.parseDouble(condPKFWLine));
				else if("V".equals(PKFWTypeLine))
					PKFWValDB= Double.parseDouble(condPKFWLine);
		
		//totItemVal=new java.math.BigDecimal(totVal-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(totVal-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){out.println("exceptionin cal"+e);}	
		//LINE FRT
		String FRTTypeLine= "0";
		String condFRTLine= "0";
		double FRTValDB=0.0;		
		try{
			FRTTypeLine = checkNull(rfqLinesRet.getFieldValueString(i,"FRTTYPE")); 
			condFRTLine = checkNull_Num(rfqLinesRet.getFieldValueString(i,"FRTVAL"));
			
				if("P".equals(FRTTypeLine))
					FRTValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condFRTLine)/100;
				else if("Q".equals(FRTTypeLine))
					FRTValDB= (Double.parseDouble(myQty)* Double.parseDouble(condFRTLine));
				else if("V".equals(FRTTypeLine))
					FRTValDB= Double.parseDouble(condFRTLine);
		
		//totItemVal=new java.math.BigDecimal(totVal-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(totVal-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){out.println("exceptionin cal"+e);}			
		//LINE BFRT
		String BFRTTypeLine= "0";
		String condBFRTLine= "0";
		double BFRTValDB=0.00;		
		try{
			BFRTTypeLine = checkNull(rfqLinesRet.getFieldValueString(i,"BFRTTYPE")); 
			condBFRTLine = checkNull_Num(rfqLinesRet.getFieldValueString(i,"BFRTVAL"));
			
				if("P".equals(BFRTTypeLine))
					BFRTValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condBFRTLine)/100;
				else if("Q".equals(BFRTTypeLine))
					BFRTValDB= (Double.parseDouble(myQty)* Double.parseDouble(condBFRTLine));
				else if("V".equals(BFRTTypeLine))
					BFRTValDB= Double.parseDouble(condBFRTLine);
				
					
		
		//totItemVal=new java.math.BigDecimal(totVal-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(totVal-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){out.println("exceptionin cal"+e);}			
		//LINE INS
		String INSTypeLine= "0";
		String condINSLine= "0";
		double INSValDB=0.00;		
		try{
			INSTypeLine = checkNull(rfqLinesRet.getFieldValueString(i,"INSTYPE")); 
			condINSLine = checkNull_Num(rfqLinesRet.getFieldValueString(i,"INSVAL"));
			
				if("P".equals(INSTypeLine))
					INSValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condINSLine)/100;
				else if("Q".equals(INSTypeLine))
					INSValDB= (Double.parseDouble(myQty)* Double.parseDouble(condINSLine));
				else if("V".equals(INSTypeLine))
					INSValDB= Double.parseDouble(condINSLine);
		
		//totItemVal=new java.math.BigDecimal(totVal-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(totVal-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){out.println("exceptionin cal"+e);}		
		
		
		double sPriceLine = 0.0;
		
		sPriceLine = totVal-discValDB+PKFWValDB+FRTValDB+BFRTValDB+INSValDB;
		
		//LINE TAX
		String TAXTypeLine= "";
		String condTAXLine= "0";
		double TAXValDB=0.0;		
		try{
			TAXTypeLine = rfqLinesRet.getFieldValueString(i,"GSTTYPE"); 
			//out.println("TAXTypeLine>>>"+TAXTypeLine);
			condTAXLine=rfqLinesRet.getFieldValueString(i,"GSTVAL");
			//out.println("condTAXLine>>>"+condTAXLine);
			
			TAXValDB= sPriceLine * Double.parseDouble(condTAXLine)/100;
			TAXValDB  = new java.math.BigDecimal(TAXValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		catch(Exception e){out.println("exceptionin TAX"+e);}	
		
		double grossValLine=0.0;
		String grossValLineStr ="0.00";
		try{
			grossValLine = sPriceLine + TAXValDB;
			grossValLineStr = new java.math.BigDecimal(grossValLine).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			totFinalValue = totFinalValue+ Double.parseDouble(grossValLineStr);
		  
		}
		catch(Exception e){out.println("exceptionin cal"+e);}			
		
     		String quotCurr = rfqLinesRet.getFieldValueString(i,"CURR");
     		/*if("IMP".equals(vendCat)) 
      			quotCurr = "USD";
     		 else if("DOM".equals(vendCat)) 
      			quotCurr = "INR";*/
      			
		
		java.util.Date delDate = (java.util.Date)rfqLinesRet.getFieldValue(i,"DELDATE");  
		String prLineItem="";
		try
		{
			prLineItem = Long.parseLong(rfqLinesRet.getFieldValueString(i,"PRITEM"))+"";
		}
		catch(Exception e)
		{
			prLineItem = rfqLinesRet.getFieldValueString(i,"PRITEM");
		}
		String  remarks=checkNull(rfqLinesRet.getFieldValueString(i,"REMARKS"));			
		String warranty = rfqLinesRet.getFieldValueString(i,"WARRANTY");
		
		String accCat	= dtlXML.getFieldValueString(i,"ERD_ACC_CAT");
		String itemCat	= dtlXML.getFieldValueString(i,"ERD_ITEM_CAT");
		
		String matNo  = "";
		
		
	  	try
	  	{
			matNo=(Long.parseLong(rfqLinesRet.getFieldValueString(i,"MATERIAL")))+"";
		}catch(Exception e){
			matNo=rfqLinesRet.getFieldValueString(i,"MATERIAL");
		}		
		
		String  serBgColor ="";
		if("D".equals(itemCat))
		{
			matNo  = "";
			serBgColor="background-color:#e4ff00";		
		}
		
		String itmTextDisp="",poTextDisp="";
		String itmText	= checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"));		
		String poText	= checkNull(rfqLinesRet.getFieldValueString(i,"POTEXT"));
		
		if(itmText.length()>40)
			itmTextDisp= itmText.substring(0,40)+"...";
		else
			itmTextDisp= itmText;	    		

		if(poText.length()>40)
			poTextDisp= poText.substring(0,40)+"...";
		else
			poTextDisp= poText;
			
		String rfqItemPos = i+"";		
		
		
	%>
        	<tr style="<%=serBgColor%>">
        	<input type=hidden name="rfqItem" value="<%=i%>"> 
        	<input type="hidden" name="itemCat<%=i%>" value="<%=itemCat%>">
		<td align="center"><input type=hidden name="ItemNo" value="<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>"><input type=hidden name="rfItemNo<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>"><%=rfqLinesRet.getFieldValueString(i,"LINENO")%></td>  
      		<td align="center"><input type=hidden name="matNo<%=i%>" value="<%=matNo%>"><%=matNo%>     	

		</td>
		
			<td align="center"><input type=hidden name="matDesc<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"MATDESC")%>"><%=rfqLinesRet.getFieldValueString(i,"MATDESC")%></td>
			<td align="center"><%=checkNull(dtlXML.getFieldValueString(i,"ERD_MAT_GRP"))%></td>
			<td align="center" nowrap>
			<%if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom))){%> 
			<input type=text name="vendHSNGST<%=i%>" id="vendHSNGST<%=i%>"  style="width:100px;"   class="form-control" value="<%=rfqLinesRet.getFieldValueString(i,"VENDHSN")%>" onkeypress='return event.charCode == 46 || (event.charCode >= 48 && event.charCode <= 57)' onchange="funGetGST('<%=i%>','<%=rfqLinesRet.getFieldValueString(i,"VENDHSN")%>','<%=rfqLinesRet.getFieldValueString(i,"GSTVAL")%>')" ></td>
			
			<%}else{%>
			<%=rfqLinesRet.getFieldValueString(i,"VENDHSN")%></a>
			
			<%}%>			
			<!--<td align="center"><input type=hidden name="plant<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"PLANT")%>"><%=rfqLinesRet.getFieldValueString(i,"PLANT")%></td>-->
			<input type=hidden name="plant<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"PLANT")%>">
			<input  type="hidden" name="pr<%=i%>"  value="<%=rfqLinesRet.getFieldValueString(i,"REFPR")%>"> 
			<input  type="hidden" name="prItem<%=i%>"  value="<%=prLineItem%>"> 

			<!--<td><a><span class="glyphicon glyphicon-new-window"></span> </a></td> -->
			
			<td align="center"><%=rfqLinesRet.getFieldValueString(i,"QTY")%><input type="hidden" name="rfqQty<%=i%>" value="<%=myQty%>"></td>
			<td align="center">1<input type="hidden" name="rfqperQty<%=i%>" value="1"></td>
			<td align="center"><input type="hidden" name="uom<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"UOM")%>"><%=uom%></td>
<%
			if("2".equals(userType))
			{
%>
				<td align="center">
<%
				if(netPR.compareTo(java.math.BigDecimal.ZERO)==0){
%>
					<a><b><%=netPR%></b></a>&nbsp; 	
<%
				}else{
%>	
					<a><b><%=netPR%></b></a>
						<a href="javascript:openLastPO('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=purOrg%>','<%=rfqPlant%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>
<%
				}
%>
			</td>
<%
			}
			if("2".equals(userType)) {
				if("Act".equals(reqFrom))
				{
%>
					<td align="center"><input type=number name="itemBudget<%=i%>"  style="width:100px;" size=9 min="0"  class="form-control input-sm" value="<%=budgetPrice%>"></td>
<%
				}else {
%>
					<td align="center"><%=budgetPrice%></td>
<%
				}
			}
			if("2".equals(userType) && "Act".equals(reqFrom))
			{			
%>			
				<td align="center"><input type=number name="itemMRP<%=i%>"  style="width:120px;" size=9 min="0"  class="form-control input-sm" value="<%=mrpPrice%>"></td>
<%
			}else{
%>			
				<td align="center" style="width:120px;"><%=mrpPrice%></td>
<%
			}
%>				
			<td align="center" nowrap>
<%			
			if(("3".equals(userType) && "Req".equals(reqFrom) &&  "Y".equals(qcfStatus)) || ("4".equals(userType) && "Req".equals(reqFrom) &&  "Y".equals(qcfStatus)))
			{
				if("D".equals(itemCat))
				{			
%>
					<div class="input-group">

						<input type=number name="itemPrice<%=i%>"  style="width:100px;" size=9 min="0"  class="form-control" value="<%=quotPrice%>" onchange="checkNum(this,'<%=i%>')" readOnly>
						<a href="javascript:viewService1('<%=poNum%>','<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>','<%=rfqItemPos%>')"><img src="services4.PNG" style="VERTICAL-ALIGN: -webkit-baseline-middle;"></a>
							<input type="hidden" name="serLine<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" value="">
							<input type="hidden" name="serPrice<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" value="">
							<input type="hidden" name="serQty<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" value="">						
					</div>
<%				
				}
				else
				{
%>				
					<input type=number name="itemPrice<%=i%>"  style="width:100px;" size=9 min="0"  class="form-control" value="<%=quotPrice%>" onchange="checkNum(this,'<%=i%>')" >
					
<%
				}
			}
			else
			{
					if("D".equals(itemCat))
					{				
%>
						
						<%=quotPrice%><input type="hidden" name="itemPrice<%=i%>" value="<%=quotPrice%>">
						<a href="javascript:viewService1('<%=poNum%>','<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>','<%=rfqItemPos%>')"><img src="services4.PNG" style="VERTICAL-ALIGN: -webkit-baseline-middle;"></a>
			
			
<%					}
					else
					{
%>
						<%=quotPrice%><input type="hidden" name="itemPrice<%=i%>" value="<%=quotPrice%>">
<%
					}
			}		
%>
			</td>
			<td align="center">
			
			<%if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom)) ){%>
			
			<select name="Curr" class="form-control select2" style="width:120% !important">
			
			<%
			curr=quotCurr;
			for(int j=0;j<currLength;j++)
			{
				if(retcur.getFieldValueString(j,"EC_CURR_KEY").trim().equals(curr))
					out.println("<option value="+retcur.getFieldValueString(j,"EC_CURR_KEY").trim()+" selected>"+retcur.getFieldValueString(j,"EC_CURR_KEY")+"</option>");
				//else
					//out.println("<option value="+retcur.getFieldValueString(j,"EC_CURR_KEY").trim()+">"+retcur.getFieldValueString(j,"EC_CURR_KEY")+"</option>");
			}
			%>
			<input type="hidden" name="Curr<%=i%>" value="<%=quotCurr%>">
			</select>
			
			<%}else{%>
			<%=quotCurr%><input type="hidden" name="Curr<%=i%>" value="<%=quotCurr%>">
			<%}%>
			</td>			
			<!--<td align="center">
					<select name="valTypeDISC<%=i%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=i%>','DISC')" style="width:170px !important">
					<option value="">-- Select--</option>
					<option value="P" <%if("P".equals(discType))out.println("selected");%>>Discount % on Basic</option>
					<option value="Q" <%if("Q".equals(discType))out.println("selected");%>>Discount/Qty</option>
					<option value="V" <%if("V".equals(discType))out.println("selected");%>>Discount(Value)</option> 
					</select>
			</td> 					
			<td align="center" nowrap>
			<%if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom)) ){%>
			<input  type="hidden" name="condDISCCode<%=i%>"  value="DISC"> 
			<input type=number name="condDisc<%=i%>"  size=9  class="form-control" min="0" onchange="funCheckDis(this,'<%=i%>')" value="<%=rfqLinesRet.getFieldValueString(i,"DISCVAL")%>" >
			
			<%}else{%>
			<%=rfqLinesRet.getFieldValueString(i,"DISCVAL")%><input type="hidden" name="condDisc<%=i%>" value="<%=rfqLinesRet.getFieldValueString(i,"DISCVAL")%>">
			<%}%>
			</td> 
			<td align="center" >
			<%if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom)) ){%>
			<div class="input-group">
			<input type=number name="vendGST<%=i%>"  id="vendGST<%=i%>" style="width:60px;"  size="2" min="0" class="form-control" value="<%=rfqLinesRet.getFieldValueString(i,"GSTVAL")%>" onchange="funAddGST(this,'<%=i%>')" >
			<a href="javascript:openItemDet('<%=rfqLinesRet.getFieldValueString(i,"SAPGST")%>','<%=rfqLinesRet.getFieldValueString(i,"SAPHSN")%>','<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"))%>')"> <span class="glyphicon glyphicon-new-window" style="VERTICAL-ALIGN: -webkit-baseline-middle;"></span> </a>
			</div>
			<%}else{%>
			<%=rfqLinesRet.getFieldValueString(i,"GSTVAL")%> 
			<a href="javascript:openItemDet('<%=rfqLinesRet.getFieldValueString(i,"SAPGST")%>','<%=rfqLinesRet.getFieldValueString(i,"SAPHSN")%>','<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"))%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>
			<input type=hidden name="vendGST<%=i%>" id="vendGST<%=i%>"  style="width:100px;"  size=9 min="0" class="form-control" value="<%=rfqLinesRet.getFieldValueString(i,"GSTVAL")%>"  >
			<%}%>
			</td>-->

			<td align="center"><a href="javascript:showConditions('<%=rfqNumber%>','<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>','<%=i%>');"><img src="../../../Vendor2/Images/Common/cond1.PNG"></a></td>
			<td align="right">
			<input type=hidden name="condDISCVal<%=i%>"  style="width:100px;" size=9  class="form-control" value="<%=discValDB%>" >
			<input type=number name="itemValue<%=i%>" style="width:140px;" size=9 class="form-control" value="<%=grossValLineStr%>" readonly>
			</td>	
			<td><%=remarks%></td>
			<td align="center"><input type="hidden" name="delDate<%=i%>" value="<%=formatter2.format(delDate)%>"><%=formatter2.format(delDate)%></td>
			<td><%=checkNull(warranty)%></td>
			<td><a href="#"  data-toggle="tooltip" title="<%=itmText%>"><%=itmTextDisp%></a></td> 
			<td><a href="#"  data-toggle="tooltip" title="<%=poText%>"><%=poTextDisp%></a></td> 
			
			
			<%if("2".equals(userType)|| "3".equals(userType) || "4".equals(userType)){%>
			<!--<td align="center"><a href="javascript:showHis('<%=rfqNumber%>','<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>');"><i class="fa fa-history" aria-hidden="true"></i></a></td>-->
			<%}%></td>
			
			<input type="hidden" name="itemVal<%=i%>" value="<%=totVal%>">   
			<input type="hidden" name="itemTotalVal<%=i%>" value="<%=totItemVal%>">
			<input type="hidden" name="valTypeDISC<%=i%>" value="<%=discTypeLine%>">
			<input type="hidden" name="itemDISC<%=i%>" value="<%=condDiscLine%>">
			<input type="hidden" name="itemDISCCode<%=i%>" value="DISC">
			<input type="hidden" name="itemDISCVal<%=i%>" value="<%=discValDB%>"> 
			<input type="hidden" name="valTypePKFW<%=i%>" value="<%=PKFWTypeLine%>">
			<input type="hidden" name="itemPKFW<%=i%>" value="<%=condPKFWLine%>">
			<input type="hidden" name="itemPKFWCode<%=i%>" value="PKFW">
			<input type="hidden" name="itemPKFWVal<%=i%>" value="<%=PKFWValDB%>">  
			<input type="hidden" name="valTypeFRT<%=i%>" value="<%=FRTTypeLine%>">
			<input type="hidden" name="itemFRT<%=i%>" value="<%=condFRTLine%>">
			<input type="hidden" name="itemFRTCode<%=i%>" value="FRT">
			<input type="hidden" name="itemFRTVal<%=i%>" value="<%=FRTValDB%>">    
			<input type="hidden" name="valTypeBFRT<%=i%>" value="<%=BFRTTypeLine%>">
			<input type="hidden" name="itemBFRT<%=i%>" value="<%=condBFRTLine%>">
			<input type="hidden" name="itemBFRTCode<%=i%>" value="BFRT">
			<input type="hidden" name="itemBFRTVal<%=i%>" value="<%=BFRTValDB%>"> 
			<input type="hidden" name="valTypeINS<%=i%>" value="<%=INSTypeLine%>">
			<input type="hidden" name="itemINS<%=i%>" value="<%=condINSLine%>">
			<input type="hidden" name="itemINSCode<%=i%>" value="INS">
			<input type="hidden" name="itemINSVal<%=i%>" value="<%=INSValDB%>">    						
			<input type="hidden" name="itemSupplyPrice<%=i%>" value="<%=sPriceLine%>"> 
			<input type="hidden" name="valTypeTAX<%=i%>" value=<%=TAXTypeLine%>>
			<input type="hidden" name="itemTAX<%=i%>" value="<%=condTAXLine%>">
			<input type="hidden" name="itemTAXCode<%=i%>" value="TAX">
			<input type="hidden" name="itemTAXVal<%=i%>" value="<%=TAXValDB%>">  
			<input type="hidden" name="itemGrossVal<%=i%>" value="<%=grossValLineStr%>">
			

      		</tr>
	<%}%>
	<tr>
	<th colspan="14">Total Value</th>
	<td align="left"> <b> <%=new java.math.BigDecimal(totFinalValue+"").setScale(2,java.math.BigDecimal.ROUND_HALF_UP)%> </b> </td>
	<th colspan="5">&nbsp;</th>

	</tr>
	</tbody>
	</table>
	</div>
	</div>
 	</div>
 	</div>
 	</div>
 	</div>
 	</div>
<%
	}
	ReturnObjFromRetrieve commentsRet = getJGLDocComments(Session,poNum,"RFQ");
	int commentsCount =0;
	if(commentsRet!= null)
		commentsCount = commentsRet.getRowCount();
	
	if(commentsCount>0)
	{
		commentsRet.sort(new String[]{"EDC_DATE"},true);
%>
      			<div class="row">
			<div class="col-md-12 col-xs-12">
			<div class="box box-primary">
			<div class="box-body">	    
			<table class="table table-bordered">
			<thead>           
					<Th width="20%"><%=user_L%></Th>
					<Th width="20%"><%=date_L%></Th>
					<Th width="60%"><%=comments_L%></Th>
								        
			</thead>
			<tbody>
<%
			for(int s=0;s<commentsRet.getRowCount();s++)
			{
				String userid = checkNull(commentsRet.getFieldValueString(s,"EU_FIRST_NAME").toUpperCase());
				String commentedOn = checkNull(commentsRet.getFieldValueString(s,"EDC_DATE"));
				String comments = checkNull(commentsRet.getFieldValueString(s,"EDC_COMMENTS"));
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = formatter.parse(commentedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				String commentedOnDate = formatter.format(date);				
	
%>	
				<tr>
					<td align="left"><%=userid%></td>
					<td align="left"><%=commentedOnDate%></td>
					<td align="left"><%=comments%></td>
				</tr>

<%
			}
			
%>
			
	</tbody>
	</table>
	</div>
	</div>
	</div>
	</div>
<%
	}
	if(("2".equals(userType) && "Act".equals(reqFrom)&&  "Y".equals(qcfStatus))   || ("3".equals(userType) && "Req".equals(reqFrom)&&  "Y".equals(qcfStatus))|| ("4".equals(userType) && "Req".equals(reqFrom)&&  "Y".equals(qcfStatus))) 
	{
	
%>
	<h4>
		<%=comments_L%>
	</h4>	
	<div class="row">
	<div class="col-md-12 col-xs-12"> 
	<div class="box box-primary">
	<div class="box-body">
		<table class="table table-bordered">
			<td colspan=3><textarea class="form-control" name="Comments" placeholder="Enter Comments" rows="2" maxlength="3000"></textarea></td>
		</table>
	</div>
	</div>
	</div>
	</div>	
<%
	}
	//UPLOADS
	String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	ReturnObjFromRetrieve retUploadList = getUploadList(Session,poNum,"RFQ");
	int retUploadListCnt = 0; 
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();		

	//if(retUploadListCnt>0)
	//{
%>
		<h4>
			<%=attachments_L%>
		</h4>
		<div class="row">
		  <div class="col-md-12 col-xs-12">
			<!-- general form elements -->
			<div class="box box-default">
				<div class="box-body table-responsive no-padding">
					<div class="box-body">
	
		<table id="uploadTable<%=itemId%>" class="table  table-bordered dt-responsive nowrap" >
			<tr <%=trBGColor%>>
				<th width="95%" align='left'><%=file_Name_L%></th>
				<th width="5%"></th>
			</tr>		

<%
		if(retUploadListCnt == 0)
		{
%>
			<tr id="noDataStatUpload">
				<td>No files attached</td>
			</tr>
<%
		}
		for(int r=0;r<retUploadListCnt;r++)
		{
			if(!itemId.equals(retUploadList.getFieldValueString(r,"EUD_ITEM_NO")))
				continue;
%>
		<tr>
			<td align="left" width="95%"><input type="hidden" name="fileItem" value="<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>"><a href="javascript:downloadFile('<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%></a></td>
			<td width="5%"><span onclick="javascript:deleteFile(this,'<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td>
		</tr>
<%
		}
%>
					</table>

			</div>
		      </div>
		     </div>
		    <!-- Your Page Content Here -->
		  </div>
		</div><!--row-->
<%
	//}
	
%>
	<div class="row no-print">
	     <div class="col-xs-12">	
		<button type="button" class="btn btn-primary pull-right" onclick="goBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i><%=go_Back_L%></button>
<%
	if("2".equals(userType) && "Act".equals(reqFrom))  
	{
%>
		<button type="button" class="btn btn-primary pull-right" onclick="reQuote()" style="margin-right: 5px;"><i class="fa fa-check"></i> <%=requote_L%></button>
		<button type="button" class="btn btn-primary pull-right" onclick="rejectQuote()" style="margin-right: 5px;"><i class="fa fa-remove"></i> <%=reject_L%></button>
		<button type="button" class="btn btn-primary pull-right" onclick="approveQuote()" style="margin-right: 5px;"><i class="fa fa-check"></i> <%=submit_L%></button>		
<%
	}
	if(("3".equals(userType)) && ("Req".equals(reqFrom) &&  "Y".equals(qcfStatus)) || ("4".equals(userType)) && ("Req".equals(reqFrom)&&  "Y".equals(qcfStatus)))  
	{
%>	
		<button type="button" class="btn btn-primary pull-right" onclick="SubmitQuote()" style="margin-right: 5px;"><i class="fa fa-check"></i> <%=submit_L%></button>
		<button type="button" value="H" id="uploadDialogBtn" class="btn btn-primary pull-right" ><i class="fa fa-upload"></i>&nbsp; <%=uplo_Att_L%></button>	
<%
	}
%>	
		</div>
	</div>
	
	</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<div id="woModal" class="modal fade" tabindex="-1" role="dialog" >
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe id="frame" src="" width="100%" height="300" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal1" class="modal fade" tabindex="-1" role="dialog" >
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe id="frame" src="" width="100%" height="220" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal2" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content" style="width: 120%;">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="580" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModalSer" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content" style="width: 120%;">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="300" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>

<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachment(s)</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="RFQ">
			<input type="hidden" id="upDocId" name="upDocId" value="<%=rfqNumber%>">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<input type="file" id="file" name="file"/>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button> 
	 </div>
      </div>
     </form>
   </div>  
</div>
<%@ include file="../Misc/ezFooter.jsp"%>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
	<script>
	$( function() {

	$(".sidebar-toggle").trigger("click");
	
	});	
	function funOpen()
	{
		window.open("../Misc/ezViewAllConditions.htm","AllConditions","menubar=no,statusbars=no,toolbar=no,width=700,height=500,left=10,top=10");
	}
	function goBack(){
		document.myForm.action = "ezViewRFQDetails.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}
	function approveQuote(){
		//var creditDays=document.myForm.creditDays.value;
		//var leadTime=document.myForm.leadTime.value;
		//var leadTimePercent=document.myForm.leadTimePercent.value;
		//alert(creditDays+"creditDays"+document.myForm.selPayCal.value);
		/*
		if(document.myForm.selPayCal.value=='')
		{
			alert("Please select Payment Term Category ");
			document.myForm.selPayCal.focus();
			return false;
		
		}
		else
		{
			if(document.myForm.selPayCal.value=='CRD')
			{
				if(creditDays=='')
				{
					alert("Please Provide No of Credit days");
					return;
				}	

			}
			if(document.myForm.selPayCal.value=='ADV')
			{
				if(leadTime=='')
				{
					alert("Please provide Delivery Lead Time");
					return;
				}
				
				if(leadTimePercent=='')
				{
					alert("Please Provide Percentage");
					return;
				}
				
			}
		}*/
		/*if(document.myForm.Comments.value=="")
		{
			alert("Please Enter Comments");
			document.myForm.Comments.focus();
			return false;
		}*/	
		if(confirm("Are you sure you want to Approve the Quote?"))
		{	
			document.myForm.action = "ezApproveQuote.jsp";
			document.myForm.submit();
		}	
	}	
	function reQuote(){
		if(document.myForm.Comments.value=="")
		{
			alert("Please Enter Comments");
			document.myForm.Comments.focus();
			return false;
		}		
		if(confirm("Are you sure you want to Submit for Requote?"))
		{
			document.myForm.action = "ezReQuote.jsp";
			document.myForm.submit();
		}	

	}
	function rejectQuote(){
		if(document.myForm.Comments.value=="")
		{
			alert("Please Enter Comments");
			document.myForm.Comments.focus();
			return false;
		}	
		if(confirm("Are you sure you want to Reject the Quote?"))
		{	
			document.myForm.action = "ezRejectQuote.jsp";
			document.myForm.submit();
		}	
	}	
	
	function displayList(){
		document.myForm.action = "ezListRFQs.jsp?type=List"
		document.myForm.submit();
	}
	function showField(fieldObj)
	{
		var fieldVal = fieldObj.value;	
		if(fieldVal=="ADV")
		{
		document.getElementById("AdvCal").style.display="";
		document.getElementById("creditCal").style.display="none";
		document.getElementById("creditCalVal").style.display="none";
		document.getElementById("interest").style.display="";
		document.getElementById("intVal").style.display="";
		}
		else
		{
		document.getElementById("AdvCal").style.display="none";
		document.getElementById("creditCal").style.display="";
		document.getElementById("creditCalVal").style.display="";
		document.getElementById("interest").style.display="";
		document.getElementById("intVal").style.display="";		
		}
		
	}
	function chkSel(fieldObj,itemPos,type)
	{

		var fieldVal = fieldObj.value;	
		//alert(fieldVal);
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");
		var itemIFRTValObj = eval("document.myForm.itemIFRTVal");
		

		if(fieldVal=="")
		{
			if(type=="DISC")
			{
				alert("Please select the Discount Type");
				var itemDISCObj = eval("document.myForm.condDisc");
				var itemDISCValObj = eval("document.myForm.condDISCVal");
				itemDISCObj.value="0";
				itemDISCValObj.value="0";
				itemDISCObj.focus();			
				//funCal(itemDISCObj,'DISC');
			}
			if(type=="PKFW")
			{
				//alert("Please select the Pkg & Fwd Type");
				//fieldObj.focus();
				itemPKFWValObj.value='0';
				var itemPKFWObj = eval("document.myForm.itemPKFW");
				itemPKFWObj.value='0';
				funCal(itemPKFWObj,'PKFW');
			}
			if(type=="FRT")
			{
				alert("Please select the Freight Type");
				//fieldObj.focus();
				itemFRTValObj.value='0';
				var itemFRTObj = eval("document.myForm.itemFRT");
				itemFRTObj.value='0';
				funCal(itemFRTObj,'FRT');
			}
			if(type=="TAX")
			{
				alert("Please select the Tax");
				//fieldObj.focus();
				itemTAXValObj.value='0';
				var itemTAXObj = eval("document.myForm.itemTAX");
				itemTAXObj.value='0';
				funCal(itemTAXObj,'TAX');
			}
			if(type=="IFRT")
			{
				alert("Please select the Freight Type");
				//fieldObj.focus();
				itemIFRTValObj.value='0';
				var itemIFRTObj = eval("document.myForm.itemIFRT");
				itemIFRTObj.value='0';
				funCal(itemIFRTObj,'IFRT');
			}		
			if(type=="CHA")
			{
				alert("Please select CHA Charges");
				//fieldObj.focus();
				itemCHAValObj.value='0';
				var itemCHAObj = eval("document.myForm.itemCHA");
				itemCHAObj.value='0';
				funCal(itemCHAObj,'CHA');
			}					
			
		}

		if(type=="DISC")
		{
			var Count='<%=rfqLinesRet.getRowCount()%>';
			for(var k=0;k<Count;k++)
			{
			var itemDISCObj = eval("document.myForm.condDisc"+k);
			//alert("k"+k+"itemDISCObj"+itemDISCObj);
			checkNum(itemDISCObj,k);

			}
			funCal(itemDISCObj,'DISC');

		}
		if(type=="PKFW")
		{
			var itemPKFWObj = eval("document.myForm.itemPKFW");

			funCal(itemPKFWObj,'PKFW');

		}


		if(type=="FRT")
		{
			var itemFRTObj = eval("document.myForm.itemFRT");
			funCal(itemFRTObj,'FRT');

		}
		if(type=="TAX")
		{
			var itemTAXObj = eval("document.myForm.itemTAX");
			funCal(itemTAXObj,'TAX');

		}
		if(type=="IFRT")
		{
			var itemIFRTObj = eval("document.myForm.itemIFRT");
			funCal(itemIFRTObj,'IFRT');
		}		
		if(type=="CHA")
		{
			var itemCHAObj = eval("document.myForm.itemCHA");
			funCal(itemCHAObj,'CHA');
		}
		if(type=="LTAX")
		{
			var itemLTAXObj = eval("document.myForm.itemLTAX");
			funCal(itemTAXObj,'TAX');
		}		
		
		
	}
	function funAddGST(fieldObj,itemPos)
	{
		var fieldVal = fieldObj.value;	
		//alert("fieldVal>>"+fieldVal);
		var Count='<%=rfqLinesRet.getRowCount()%>';
		var totalGSTVal=0;
		for(var c=0;c<Count;c++)
		{
			var lineItemGSTObjAdd = eval("document.myForm.vendGST"+c);
			totalGSTVal=parseFloat(lineItemGSTObjAdd.value)+parseFloat(totalGSTVal);
			
		}
		document.myForm.itemTAX.value=totalGSTVal;
		checkNum(fieldObj,itemPos);
		
	}
	
	function funLineValid()
	{
		var rfqItemObj  = document.myForm.rfqItem;
		var len = rfqItemObj.length;

		//len=document.myForm.itemPrice.length;
		if(isNaN(len))
		{
			rfqItemNo = document.myForm.rfqItem.value;

			if(("document.myForm.Price"+rfqItemNo).value=="")
			{
				alert("Please Enter Price of the Material");
				return false;
			}
			else
				return true;
		}
		else
		{
			var bool="false"
			for(var i=0;i<len;i++)
			{
				rfqItemNo = document.myForm.rfqItem[i].value;
				if(("document.myForm.Price"+rfqItemNo).value!="")
				{
					var bool="true"
					return true;
				}
			}
			if(bool=="false")
			{
				alert("Please Enter the price for atleast one material");
				return false;
			}
		}
	}
	function SubmitQuote()
	{
	
		var rfqItemObj  = document.myForm.rfqItem;
		var len = rfqItemObj.length;
		//alert("len>>>"+len);
		
		if(isNaN(len))
		{
			var rfqItemNo = document.myForm.rfqItem.value;
			
			
			
			if(eval("document.myForm.itemPrice"+rfqItemNo).value=="")
			{
				alert("Please Enter Price of the Material for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.itemPrice"+rfqItemNo).focus();
				return false;
			}
			if(eval("document.myForm.itemPrice"+rfqItemNo).value< 0)
			{
				alert("Please Enter Positive Number for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.itemPrice"+rfqItemNo).focus();
				return false;
			}	
			/*if(eval("document.myForm.leaddays"+rfqItemNo).value=="")
			{
				alert("Please Enter Lead Time for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.leaddays"+rfqItemNo).focus();
				return false;
			}*/			
			
		}
		else
		{
			//alert("len>>>>"+len);
			for(var i=0;i<len;i++)
			{
				var rfqItemNo = document.myForm.rfqItem[i].value;
				//alert("rfqItemNo>>>"+rfqItemNo)
				if(eval("document.myForm.itemPrice"+rfqItemNo).value=="")
				{
					alert("Please Enter Price of the Material for the line item:"+((i+1)*10));
					eval("document.myForm.itemPrice"+rfqItemNo).focus();
					return false;
				}
				
				if(eval("document.myForm.itemPrice"+rfqItemNo).value < 0)
				{
					alert("Please Enter Positive Number for the line item:"+((i+1)*10));
					eval("document.myForm.itemPrice"+rfqItemNo).focus();
					return false;
				}
				/*if(eval("document.myForm.leaddays"+rfqItemNo).value=="")
				{
					alert("Please Enter Lead Time for the line item:"+((i+1)*10));
					eval("document.myForm.leaddays"+rfqItemNo).focus();
					return false;
				}*/				

			}	

		}
				
		if (document.myForm.PaymentTerms.value==""){
			alert("Please Select Payment terms from the List."); 
			document.myForm.PaymentTerms.focus()
			return false;
		}else if (document.myForm.IncoTerms.value==""){
			alert("Please Select Inco Terms from the List.");
			document.myForm.IncoTerms.focus()
			return false;
		}else if(document.myForm.Comments.value==""){
			alert("Please Enter Comments");
			document.myForm.Comments.focus()
			return false;			
		}else if (!funLineValid()){
			return false
		}
		else
		{
			if(confirm("Are you sure you want to Submit the Re-Quote?"))
			{		
				buttonhide();
				document.myForm.action="ezQuotationUpdate.jsp"; 
				document.myForm.submit();
			}	
		}
	}
	function buttonhide()
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "none"
			buttonsMsgSpan.style.display	= "block"
		}
	}
	function showConditions(rfqNo,lineNo,itemPos)
	{
		var itemQty   = eval("document.myForm.rfqQty"+itemPos).value;
		var itemPrice = eval("document.myForm.itemPrice"+itemPos).value;
		var currency = eval("document.myForm.Curr"+itemPos).value;
		//alert("itemPrice>>"+itemPrice);
		
		var vendCat= "<%=vendCat%>";
		//alert("vendCat>>>"+vendCat);
		var reqFrom="<%=reqFrom%>";
		var userType="<%=userType%>"
		
		var url="ezGetConditions.jsp?rfqNo="+rfqNo+"&lineNo="+lineNo+"&itemPos="+itemPos+"&itemQty="+itemQty+"&itemPrice="+itemPrice+"&vendCat="+vendCat+"&reqFrom="+reqFrom+"&userType="+userType+"&currency="+currency;
		$('iframe').attr("src",url);
		$('#woModal2').modal({show:true});
		$('.modal-dialog').draggable({
			handle: ".modal-body"
  		});			
		
	
	}	
	function showHis(rfqNo,lineNO)
	{
		
		var url="ezGetQuoteHistory.jsp?rfqNo="+rfqNo+"&lineNO="+lineNO;
		
		$('iframe').attr("src",url);
		

		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
  		});
	
	}
	

	function downloadFilePreView(upItemNo,fileName)
  	{
		var upDocId 	= upItemNo;
		var upDocType 	= "RFQ";
		window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	}
	function downloadFile(upItemNo,fileName)
	  {
	  	var upDocId 	= $('#upDocId').val();
	  	var upDocType 	= $('#upDocType').val();
	  	window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	 }	
	 function valUploadForm()
	 {
	 	var upItemNo = $('#upItemNo').val();
	 	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
	 	var isValid = true;
	 	if(fileName == "")
		{
			alert("Please upload file");
			isValid = false;
			return false;
		}
	 	$('input[name="fileItem'+upItemNo+'"]').each(function(){
		  if($(this).val() == fileName)
		  {
		  	alert("File already uploaded");
		  	isValid = false;
			return false;
		  }	  
		});
		if(isValid)
		{
			$('#uploadbutton').hide(); 	
	       		$('#loadingInd').show();
		}
		return isValid;
 	}	
	$( function() {
	     $( "#uploadDialogBtn" ).button().on( "click", function() {
	        $("#upItemNo").val($(this).val());
	        $("#file").val("");
	       $('#uploadMod').modal('show');
	       	return false;
	     });
	     $('#uploadForm').ajaxForm({
	     	  beforeSubmit: valUploadForm,	
		  success: function(msg) {
		      $('#uploadbutton').show(); 	
	       	      $('#loadingInd').hide();
		      msg=$.trim(msg);
		      //alert(msg);
		      if(msg.split("##")[0] === 'true')
		      {
		    	  $('#noDataStatUpload').hide();
		      	  var upItemNo = $('#upItemNo').val();
		      	  var fileNameTemp = msg.split("##")[1];
		      	   $('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFilePreView(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
		      }
		      //alert("File has been uploaded successfully");
		      $('#uploadMod').modal('hide');
		  },
		  error: function(msg) {
		     $('#uploadbutton').show(); 	
	       	     $('#loadingInd').hide();	
		     alert("Couldn't upload file");
		  }
	     });
	
  	 } );	
	function funCheckDis(fieldObj,itemPos)
	{
		var fieldVal = fieldObj.value;	
		var itemDISCObj = eval("document.myForm.condDISCVal"+itemPos);
		var itemPriceObj = eval("document.myForm.itemPrice"+itemPos);
		var valTypeDISCObj = eval("document.myForm.valTypeDISC"+itemPos);
		
		if(valTypeDISCObj.value=="")
		{
			alert("Please select the Discount Type");
			valTypeDISCObj.value='';
			return;
			
		}
		else
		{
			
			if(itemPriceObj.value=='')
			{
				alert("Please provide Price");
				return;
			}
			else
				checkNum(fieldObj,itemPos);
		}
		  
	}
	function checkNum(fieldObj,itemPos)
	{
		
		var fieldVal = fieldObj.value;
		//alert("fieldObj"+fieldObj);
		var line = itemPos;
		
		if(isNaN(fieldVal) || fieldVal=='')
		{
			alert("Please enter valid numeric value");
			fieldObj.value="0";
			fieldObj.focus();
			return;
		}
		else 
		{
			var itemQtyObj = eval("document.myForm.rfqQty"+line);
			//alert("itemQtyObj in CheckNum>>>>"+itemQtyObj.value);
			var itemPriceObj = eval("document.myForm.itemPrice"+line);
			//alert("itemPriceObj in CheckNum>>>>"+itemPriceObj.value);
			var itemValObj   = eval("document.myForm.itemValue"+line);
					
			var itemVal = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 
			//alert("itemVal>>>>"+itemVal);
			eval("document.myForm.itemVal"+line).value = itemVal;
			
			//DISCOUNT
			var itemDISCObj    = eval("document.myForm.itemDISC"+line);
			var valTypeDISCObj = eval("document.myForm.valTypeDISC"+line);
			var itemDISCValObj = eval("document.myForm.itemDISCVal"+line);
			
			//PKFW
			var itemPKFWObj    = eval("document.myForm.itemPKFW"+line);
			var valTypePKFWObj = eval("document.myForm.valTypePKFW"+line);
			var itemPKFWValObj = eval("document.myForm.itemPKFWVal"+line);

			//FRT
			var itemFRTObj    = eval("document.myForm.itemFRT"+line);
			var valTypeFRTObj = eval("document.myForm.valTypeFRT"+line);
			var itemFRTValObj = eval("document.myForm.itemFRTVal"+line);
			
			//TAX
			var itemTAXObj    = eval("document.myForm.itemTAX"+line);
			var valTypeTAXObj = eval("document.myForm.valTypeTAX"+line);		
			var itemTAXValObj = eval("document.myForm.itemTAXVal"+line);			
			
			if(itemPriceObj.value!='')
			{
				if(itemDISCObj.value!='')
				{
					if(valTypeDISCObj.value == "P")
						itemDISCValObj.value = ((itemVal * itemDISCObj.value)/100).toFixed(2);
					else if(valTypeDISCObj.value=="V")
						itemDISCValObj.value = parseFloat(itemDISCObj.value).toFixed(2);
					else if(valTypeDISCObj.value=="Q")	
						itemDISCValObj.value = itemDISCObj.value * parseFloat(itemQtyObj.value);
				}
				
				var itemNetVal = (parseFloat(itemVal)- parseFloat(itemDISCValObj.value)).toFixed(2);
				//alert("itemNetVal>>>>"+itemNetVal);
				eval("document.myForm.itemTotalVal"+line).value = itemNetVal;
				
				if(valTypePKFWObj.value!='')
				{
					if(valTypePKFWObj.value == "P")
						itemPKFWValObj.value = (((itemNetVal) * itemPKFWObj.value)/100).toFixed(2);
					else if(valTypePKFWObj.value=="V")
						itemPKFWValObj.value = parseFloat(itemPKFWObj.value).toFixed(2);
					else if(valTypePKFWObj.value=="Q")	
						itemPKFWValObj.value = (parseFloat(itemPKFWObj.value) * parseFloat(itemQtyObj.value)).toFixed(2);
				}
				if(valTypeFRTObj.value!='')
				{
					if(valTypeFRTObj.value == "P")
						itemFRTValObj.value = (((itemNetVal) * itemFRTObj.value)/100).toFixed(2);
					else if(valTypeFRTObj.value=="V")
						itemFRTValObj.value = parseFloat(itemFRTObj.value).toFixed(2);
					else if(valTypeFRTObj.value=="Q")	
						itemFRTValObj.value = (parseFloat(itemFRTObj.value) * parseFloat(itemQtyObj.value)).toFixed(2);
				}
				var itemTotal = (parseFloat(itemNetVal)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)).toFixed(2);
				eval("document.myForm.itemSupplyPrice"+line).value = itemTotal;
				if(valTypeTAXObj.value!='')
				{				

					itemTAXValObj.value = ((((parseFloat(itemTotal)) * itemTAXObj.value)/100)).toFixed(2);
				}
				
				eval("document.myForm.itemGrossVal"+line).value = (parseFloat(itemNetVal)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value)).toFixed(2);
				itemValObj.value = (parseFloat(itemNetVal)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value)).toFixed(2);
			}
		}	
	}	
	function funCal(fieldObj,type)
	{
		//alert(type+"type");
		var vendCat= "<%=vendCat%>";
		var fieldVal = fieldObj.value;	
		var totalQtyVal=0;
		var Count='<%=rfqLinesRet.getRowCount()%>';
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");
		var itemLTAXValObj = eval("document.myForm.itemLTAXVal");
		var itemCUSTValObj = eval("document.myForm.itemCUSTVal");
		var itemCESSValObj = eval("document.myForm.itemCESSVal");
		var itemCHAValObj = eval("document.myForm.itemCHAVal");
		var itemIFRTValObj = eval("document.myForm.itemIFRTVal");
		//alert("itemIFRTValObj>>>"+itemIFRTValObj.value)
		var itemTotalValObj = eval("document.myForm.itemTotalVal");
		var valTypeDUTYObj = eval("document.myForm.valTypeDUTY");
		
		
		
		for(var c=0;c<Count;c++)
		{
			var itemQtyObj = eval("document.myForm.rfqQty"+c);
			totalQtyVal=parseFloat(itemQtyObj.value)+parseFloat(totalQtyVal);
		}
		if(type=="PKFW")
		{
			if(document.myForm.valTypePKFW.value=="")
			{
				alert("Please select the Pkg & Fwd");
				document.myForm.itemPKFW.value='0';
				
						
			}
			else
			{
				var itemPKFWObj = eval("document.myForm.itemPKFW");
				var valTypePKFWObj = eval("document.myForm.valTypePKFW");

				if(valTypePKFWObj.value == "P")
					itemPKFWValObj.value = (((itemTotalValObj.value) * itemPKFWObj.value)/100).toFixed(2);
				else if(valTypePKFWObj.value=="V")
					itemPKFWValObj.value = parseFloat(itemPKFWObj.value).toFixed(2);
				else if(valTypePKFWObj.value=="Q")	
					itemPKFWValObj.value = (itemPKFWObj.value * parseFloat(totalQtyVal)).toFixed(2) ;
			}
		//document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value);	
		}
		
		if(type=="FRT")
		{
			if(document.myForm.valTypeFRT.value=="")
			{
				alert("Please select the Freight");
				document.myForm.itemFRT.value='';
				

			}
			else
			{
				var itemFRTObj = eval("document.myForm.itemFRT");
				var valTypeFRTObj = eval("document.myForm.valTypeFRT");
				
								
				if(valTypeFRTObj.value == "P")
					itemFRTValObj.value = ((itemTotalValObj.value * itemFRTObj.value)/100).toFixed(2);
				else if(valTypeFRTObj.value=="V")
					itemFRTValObj.value = parseFloat(itemFRTObj.value).toFixed(2);
				else if(valTypeFRTObj.value=="Q")	
					itemFRTValObj.value = (itemFRTObj.value * parseFloat(totalQtyVal)).toFixed(2);	

			}
		
		}
		var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
		itemSupplyPrice= parseFloat(itemSupplyPrice).toFixed(2);		

		if(type=="CUST")
		{
			if(document.myForm.valTypeCUST.value=="")
			{
				alert("Please select the Custom Duty");
				document.myForm.itemCUST.value='';
				

			}
			else
			{
				var itemCUSTObj=eval("document.myForm.itemCUST");
				itemCUSTValObj.value = ((itemSupplyPrice * itemCUSTObj.value)/100).toFixed(2);
				var itemTAXObj=eval("document.myForm.itemTAX");
				itemTAXValObj.value = (((parseFloat(itemSupplyPrice) +parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)) * itemTAXObj.value)/100).toFixed(2);
				document.myForm.itemLTAXVal.value = (parseFloat(itemTAXValObj.value)).toFixed(2);
				if(valTypeDUTYObj.value == "E")
					document.myForm.itemDUTYVal.value = parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value);
				else if(valTypeDUTYObj.value == "D")
					document.myForm.itemDUTYVal.value = parseFloat("0");				
								
			}
		
		}
		if(type=="CESS")
		{
			if(document.myForm.valTypeCESS.value=="")
			{
				alert("Please select the Social Welfare Cess");
				document.myForm.itemCESS.value='';

			}
			else
			{
				var itemCESSObj=eval("document.myForm.itemCESS");
				itemCESSValObj.value = ((itemCUSTValObj.value) * (itemCESSObj.value)/100).toFixed(2);
				var itemTAXObj=eval("document.myForm.itemTAX");
				itemTAXValObj.value = (((parseFloat(itemSupplyPrice) +parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)) * itemTAXObj.value)/100).toFixed(2);								
				document.myForm.itemLTAXVal.value = (parseFloat(itemTAXValObj.value)).toFixed(2);
				if(valTypeDUTYObj.value == "E")
					document.myForm.itemDUTYVal.value = parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value);
				else if(valTypeDUTYObj.value == "D")
					document.myForm.itemDUTYVal.value = parseFloat("0");								
			}
		
		}
		if(type=="CHA")
		{
			if(document.myForm.valTypeCHA.value=="")
			{
				alert("Please select the CHA charges");
				document.myForm.itemCHA.value='';
				

			}
			else
			{
				var itemCHAObj=eval("document.myForm.itemCHA");
				var valTypeCHAObj = eval("document.myForm.valTypeCHA");
				
				if(valTypeCHAObj.value=="V")
					itemCHAValObj.value = parseFloat(itemCHAObj.value).toFixed(2);				
				
				/*if(valTypeCHAObj.value == "P")
					itemCHAValObj.value = ((itemSupplyPrice * itemCHAObj.value)/100).toFixed(2);
				else if(valTypeCHAObj.value=="V")
					itemCHAValObj.value = itemCHAObj.value;
				else if(valTypeCHAObj.value=="Q")	
					itemCHAValObj.value = itemCHAObj.value * parseFloat(itemSupplyPrice);	*/
				
			}
		
		}
		if(type=="IFRT")
		{
			if(document.myForm.valTypeIFRT.value=="")
			{
				alert("Please select the Freight");
				document.myForm.itemIFRT.value='';
				

			}
			else
			{
				var itemIFRTObj = eval("document.myForm.itemIFRT");
				//alert("itemIFRTObj>>>"+itemIFRTObj.value)
				var valTypeIFRTObj = eval("document.myForm.valTypeIFRT");
				//alert("valTypeIFRTObj>>>"+valTypeIFRTObj.value)
				
				if(valTypeIFRTObj.value == "P")
					itemIFRTValObj.value = ((itemSupplyPrice * itemIFRTObj.value)/100).toFixed(2);
				else if(valTypeIFRTObj.value=="V")
					itemIFRTValObj.value = parseFloat(itemIFRTObj.value).toFixed(2);
				else if(valTypeIFRTObj.value=="Q")	
					itemIFRTValObj.value = itemIFRTObj.value * parseFloat(itemSupplyPrice);	

			}
		
		}	
		if(type=="TAX")
		{
			if(document.myForm.valTypeTAX.value=="")
			{
				alert("Please select the Tax");
				document.myForm.itemTAX.value='';
				

			}
			else if(vendCat === "DOM")
			{
				//alert("in DOM");
				var itemTAXObj=eval("document.myForm.itemTAX")/Count;
				itemTAXValObj.value = ((itemSupplyPrice * itemTAXObj.value)/100).toFixed(2);
			}
			else if(vendCat === "IMP")
			{
				//alert("in IMP");
				var itemTAXObj=eval("document.myForm.itemTAX");
				//alert("itemTAXObj>>>>"+itemTAXObj.value)
				//alert("itemCUSTValObj>>>>"+itemCUSTValObj.value)
				//alert("itemCESSValObj>>>>"+itemCESSValObj.value)
				itemTAXValObj.value = (((parseFloat(itemSupplyPrice) +parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)) * itemTAXObj.value)/100).toFixed(2);
				//alert("itemCESSValObj>>>>"+itemTAXValObj.value)
				
				
				if(valTypeDUTYObj.value == "E")
					document.myForm.itemDUTYVal.value = parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value);
				else if(valTypeDUTYObj.value == "D")
					document.myForm.itemDUTYVal.value = parseFloat("0");
				
				document.myForm.itemLTAX.value = parseFloat(itemTAXObj.value);				
				document.myForm.itemLTAXVal.value = (parseFloat(itemTAXValObj.value)).toFixed(2);
				
				
				
				
			}			
			
		
		}	
		if(type=="LTAX")
		{
			if(document.myForm.valTypeLTAX.value=="")
			{
				alert("Please select the Tax");
				document.myForm.itemTAX.value='';
				

			}

			else if(vendCat === "IMP")
			{
				//alert("in IMP");
				var itemLTAXObj=eval("document.myForm.itemLTAX");

				itemLTAXValObj.value = (((parseFloat(itemSupplyPrice) +parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)) * itemLTAXObj.value)/100).toFixed(2);
				//alert("itemCESSValObj>>>>"+itemTAXValObj.value)
				
				
				if(valTypeDUTYObj.value == "E")
					document.myForm.itemDUTYVal.value = parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value);
				else if(valTypeDUTYObj.value == "D")
					document.myForm.itemDUTYVal.value = parseFloat("0");
				
				document.myForm.itemLTAXVal.value = (parseFloat(itemLTAXValObj.value)).toFixed(2);
				
				
				
				
			}			
			
		
		}				
		if(type=="DUTY")
		{
			if(document.myForm.valTypeDUTY.value=="")
			{
				alert("Please select the Tax");
				document.myForm.itemTAX.value='';
				

			}
			else if(vendCat === "IMP")
			{
				//alert("in IMP");
				var itemTAXObj=eval("document.myForm.itemTAX");
				var valTypeDUTYObj = eval("document.myForm.valTypeDUTY");
				if(valTypeDUTYObj.value == "E")
					document.myForm.itemDUTYVal.value = parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value);
				else if(valTypeDUTYObj.value == "D")
					document.myForm.itemDUTYVal.value = parseFloat("0");
				
				
				
				
			}			
			
		
		}				
		if(vendCat === "DOM")
			document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value);	
		if(vendCat === "IMP")
		{
			document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value);				
			document.myForm.itemTotalCost.value =parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value)+parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)+parseFloat(itemCHAValObj.value)+parseFloat(itemIFRTValObj.value)+parseFloat(itemTAXValObj.value);
			document.myForm.landCostVal.value=parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value)+parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)+parseFloat(itemCHAValObj.value)+parseFloat(itemIFRTValObj.value)+parseFloat(itemTAXValObj.value)-parseFloat(eval(document.myForm.itemDUTYVal.value))-parseFloat(eval(document.myForm.itemLTAXVal.value));
			
			//document.myForm.itemTotalCost.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemIFRTValObj.value)+parseFloat(itemCUSTValObj.value)+parseFloat(itemCESSValObj.value)+parseFloat(itemCHAValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value);				
		}	
		
	}
	function funCalLandCost(type)
	{
	
		var Count='<%=rfqLinesRet.getRowCount()%>';
		var vendCat= "<%=vendCat%>";
		
		var creditDays=document.myForm.creditDays.value;
		var leadTime=document.myForm.leadTime.value;
		var leadTimePercent=document.myForm.leadTimePercent.value;
		var itemTotalValObj = eval("document.myForm.itemTotalVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemGrossValObj = eval("document.myForm.itemGrossVal");
		var totPriceVal=0;
		if(type=='C')
		{
			document.myForm.calType.value='Credit';
			if(vendCat === "DOM")
			{		
				
				for(var k=0;k<Count;k++)
				{
				var itemQtyObj = eval("document.myForm.rfqQty"+k);
				var itemPriceObj = eval("document.myForm.itemPrice"+k);
				itemValObj = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 	
				//alert("itemValObj"+itemValObj);
				totPriceVal=(parseFloat(totPriceVal)+parseFloat(itemValObj)).toFixed(2); 	

				}
				var landCostObj = eval("document.myForm.landCostVal");
				var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
				//alert("itemSupplyPrice>>"+itemSupplyPrice);
				var calVal=((itemSupplyPrice)*(8/100)*(1/365)*parseFloat(creditDays)).toFixed(2);
				//alert(calVal);
				landCostObj.value=(parseFloat(itemSupplyPrice)-parseFloat(calVal)).toFixed(2);
			}	
			if(vendCat === "IMP")
			{
				var landCostImpObj = eval("document.myForm.landCostValImp");
				var calVal=((itemGrossValObj.value)*(8/100)*(1/365)*parseFloat(creditDays)).toFixed(2);
				//alert(calVal);
				landCostImpObj.value=(parseFloat(itemGrossValObj.value)-parseFloat(calVal)).toFixed(2);				
			}
			
		}
		if(type=='A')
		{
			document.myForm.calType.value='Advance';
			
			if(vendCat === "DOM")
			{
			
				for(var k=0;k<Count;k++)
				{
				var itemQtyObj = eval("document.myForm.rfqQty"+k);
				var itemPriceObj = eval("document.myForm.itemPrice"+k);
				itemValObj = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 	
				//alert("itemValObj"+itemValObj);
				totPriceVal=(parseFloat(totPriceVal)+parseFloat(itemValObj)).toFixed(2); 	

				}
				var landCostObj = eval("document.myForm.landCostVal");
				var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
				var calVal=parseFloat(itemSupplyPrice)*(8/100)*(1/365)*(1/leadTimePercent)*parseFloat(leadTime);
				landCostObj.value=(parseFloat(itemSupplyPrice)+parseFloat(calVal)).toFixed(2);
			}
			if(vendCat === "IMP")
			{
				var landCostImpObj = eval("document.myForm.landCostValImp");
				var calVal=(itemGrossValObj.value)*(8/100)*(1/365)*(1/leadTimePercent)*parseFloat(leadTime);
				alert(calVal);
				landCostImpObj.value=(parseFloat(itemGrossValObj.value)+parseFloat(calVal)).toFixed(2);				
			}			
		
		}
		document.myForm.landCostVal.value=landCostObj.value;
	}
	function openItemDet(sapGst,sapHSN,mat,text)
      { 
      	var url="ezSAPDetPopup.jsp?sapGst="+sapGst+"&sapHSN="+sapHSN+"&mat="+mat+"&text="+text;     
      	/*$.fancybox.open({
      		href : url, 
      		type : 'iframe',
      		
      		width:'60%',
      		height:'38%',
      		autoSize : false,
      		closeBtn : false,
      		keys : {
      		    close  : true,
      		},			
      		helpers     : {  
      			overlay : {closeClick: false}
      			}
      		});*/
      		
		$('iframe').attr("src",url);
		

		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
  		});   		      		
      
      }
   	
      function openLongItem(mat,text,type)
      { 
	var url="ezItemTextPopup.jsp?mat="+mat+"&text="+text+"&type="+type;     
	/*$.fancybox.open({
		href : url, 
		type : 'iframe',

		width:'60%',
		height:'38%',
		autoSize : false,
		closeBtn : false,
		keys : {
		    close  : true,
		},			
		helpers     : {  
			overlay : {closeClick: false}
			}
		});*/
		
		$('iframe').attr("src",url);
		

		$('#woModal1').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
  		});   				

      }
      function funSetItemDisc(disc)
	{
		var Count='<%=rfqLinesRet.getRowCount()%>';
		if(document.myForm.valTypeDISC.value=="")
		{
			alert("Please select the Discount Type");
			itemDISCObj.value='';
			disc.value=0;
			return;

		}
		for(var c=0;c<Count;c++)
		{
			var discObj = eval("document.myForm.condDisc"+c);
			discObj.value=disc.value;
			funCheckDis(discObj,c)

		}



	}
	function funSetItemLead(lead)
	{
		var Count='<%=Count%>';

		for(var c=0;c<Count;c++)
		{
			var leadObj = eval("document.myForm.leaddays"+c);
			leadObj.value=lead.value;

		}
	
	
	}
      function funGetGST(item,prevHSN,prevGST)
      {
      	
	var hsnCode 	= $('#vendHSNGST'+item).val();
	var size = hsnCode.length;
	if(size != 10)
	{
		
		alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
		$('#vendHSNGST'+item).val(prevHSN);
		$('#vendGST'+item).val(prevGST);
		return false;
	}
	else
	{
		var hsnArr= hsnCode.split(".");
		if(hsnArr[0].length != 4)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
			$('#vendGST'+item).val("0");
			return false;
		}	
		if(hsnArr[1].length != 2)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
			$('#vendGST'+item).val("0");
			return false;
		}	
		if(hsnArr[2].length != 2)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));						
			$('#vendGST'+item).val("0");
			return false;
		}	
		
	}
      	
        $.ajax({
      			    url: '../RFQ/ezGetGST.jsp', 
      			    data: { hsn : hsnCode},
      			    dataType: "json",
      			    type: 'POST',
      			    success: function(result) {
      			      result=$.trim(result);
      			      $('#vendGST'+item).val(result);
      			      var vendGSTObj = eval("document.myForm.vendGST"+item);
      			      checkNum(vendGSTObj,item);
      			      
      			    }
			});
	}
	function funIncoDom(fieldObj)
	{
		
		var vendCat= "<%=vendCat%>"; 
		var Count='<%=Count%>';
		//alert(Count);
		var fieldVal = fieldObj.value;	
		//alert(fieldVal);
		if(vendCat === "DOM")
		{		
		
			if(fieldVal =="DAP")
			{
				document.getElementById("itemPKFW").value = "0";
				document.getElementById("itemPKFWVal").value = "0";
				document.getElementById("itemFRT").value = "0";
				document.getElementById("itemFRTVal").value = "0";
				
				var itemPKFWObj = eval("document.myForm.itemPKFW");
				funCal(itemPKFWObj,'PKFW');
				var itemFRTObj = eval("document.myForm.itemFRT");
				funCal(itemFRTObj,'FRT');
				var itemTAXObj = eval("document.myForm.itemTAX");
				//alert("itemTAXObj"+itemTAXObj.value/Count);
				
				var itemTotalValObj = eval("document.myForm.itemTotalVal");
				//alert(itemTotalValObj.value);
				
				document.myForm.itemTAXVal.value = (parseFloat(itemTotalValObj.value)* (itemTAXObj.value/Count)/100).toFixed(2);
				document.myForm.itemGrossVal.value = ((parseFloat(itemTotalValObj.value) + (parseFloat(itemTotalValObj.value)* (itemTAXObj.value/Count)/100))).toFixed(2);
				//funCal(itemTAXObj,'TAX');	
				//chkSel(fieldObj,0,"TAX")
				
				
				
				document.getElementById("valTypePKFW").disabled = true;
				document.getElementById("itemPKFW").disabled = true;
				document.getElementById("valTypeFRT").disabled = true;
				document.getElementById("itemFRT").disabled = true;
			}
			else
			{
				document.getElementById("valTypePKFW").removeAttribute('disabled');
				document.getElementById("itemPKFW").removeAttribute('disabled');
				document.getElementById("valTypeFRT").removeAttribute('disabled');
				document.getElementById("itemFRT").removeAttribute('disabled');
				
				var itemTAXObj = eval("document.myForm.itemTAX");
				funCal(itemTAXObj,'TAX');				
			}
		}		
		
	}	
	function openLastPO(mat,purOrg,plant)
	{ 
		var url="ezLastPOPriceDet.jsp?mat="+mat+"&purOrg="+purOrg+"&plant"+plant;
		$.fancybox.open({
			href : url, 
			type : 'iframe',

			width:'80%',
			height:'78%',
			autoSize : false,
			closeBtn : false,
			keys : {
			    close  : true,
			},			
			helpers     : {  
				overlay : {closeClick: false}
				}
			});

	}	
	function viewService(rfqNo,rfqItem)
	{ 
		var url="ezViewServices.jsp?rfqNo="+rfqNo+"&rfqItem="+rfqItem;      
		$('iframe').attr("src",url);
		$('#woModalSer').modal({show:true});
		$('.modal-dialog').draggable({
			   handle: ".modal-body"
		});   		
	}
	function viewService1(rfqNo,rfqItem,itemPos)
	{ 
		var vendCat= "<%=vendCat%>";
		//alert("vendCat>>>"+vendCat);	
		var reqFrom="<%=reqFrom%>";
		//alert("reqFrom>>>"+reqFrom);	
		var userType="<%=userType%>";
		//alert("userType>>>"+userType);	
		var url="ezViewServices.jsp?rfqNo="+rfqNo+"&rfqItem="+rfqItem+"&itemPos="+itemPos+"&vendCat="+vendCat+"&reqFrom="+reqFrom+"&userType="+userType;
		$('iframe').attr("src",url);
		$('#woModalSer').modal({show:true});
		$('.modal-dialog').draggable({
			   handle: ".modal-body"
		});   		
	} 	
   	
	
</script>
</script>
	<script type="text/javascript"> 
        function preventBack() { 
            window.history.forward();  
        } 
          
        setTimeout("preventBack()", 0); 
          
        window.onunload = function () { null }; 
</script> 