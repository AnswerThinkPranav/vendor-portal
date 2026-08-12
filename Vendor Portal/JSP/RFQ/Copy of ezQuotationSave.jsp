<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>

<%@ page import ="ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<%@ page import ="java.util.*,ezc.ezutil.*" %>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*" %>
 
<%
	EzcParams ezparams=new EzcParams(true);

	EzShipmentManager shManager=new EzShipmentManager();
	ezc.ezpreprocurement.client.EzPreProcurementManager ezPreProcManager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();

	String QtnDt = request.getParameter("QtnDate");
	String Remk = request.getParameter("Remarks");

	Date fromDate = new Date();
	fromDate.setDate(Integer.parseInt(QtnDt.substring(0,2)));
	fromDate.setMonth(Integer.parseInt(QtnDt.substring(3,5))-1);
	fromDate.setYear(Integer.parseInt(QtnDt.substring(6,10))-1900);

	EzBapiekkocStructure header = new EzBapiekkocStructure();

	header.setPoNumber(request.getParameter("RfqNo"));
	header.setDocType("A");
	header.setAgreement(request.getParameter("QtnRef"));
	header.setDocDate(fromDate);

	EzBapiekkoaStructure headerAdd = new EzBapiekkoaStructure();

	headerAdd.setIncoterms1(request.getParameter("IncoTerms"));
	headerAdd.setIncoterms2("DRL");
	headerAdd.setPmnttrms(request.getParameter("PaymentTerms"));


	String [] items = request.getParameterValues("ItemNo");
	String [] prices = request.getParameterValues("Price");
	String [] currs = request.getParameterValues("Curr");

	EzBapicondTable sapCond =  new EzBapicondTable();
	int j=0;
	for (int i=0 ; i < items.length ; i++)
	{
		EzBapicondTableRow sapCondRow = new EzBapicondTableRow();
		if ((prices[i]!=null)&&(prices[i].length()!=0)){
			sapCondRow.setItmNumberString(items[i]);
			sapCondRow.setCondType("PBXX");
			sapCondRow.setCondValueString(prices[i]);
			sapCondRow.setCondvalueString(prices[i]);
			sapCondRow.setCurrency(currs[i]);
			sapCond.insertRow(j,sapCondRow);
			j++;
		}
	}
	
/*	log("CondClass>>"+condRow.getCondclass());
	log("CondNo>>>>>"+condRow.getCondNo());*/

	String Conditions = request.getParameter("allconditions");
	//System.out.println("All Cond>>>>>"+Conditions);
	if ((Conditions!=null)&&(Conditions.trim().length()!=0))
	{
		StringTokenizer st1=new StringTokenizer(Conditions,"#");
		while (st1.hasMoreTokens())
		{
			//System.out.println("All Cond>>>>>");
			StringTokenizer st2=new StringTokenizer(st1.nextToken(),"*");
			String str = st2.nextToken();
			//System.out.println("All Cond>>>>>"+str);

			if (!"NA".equalsIgnoreCase(str)){
				EzBapicondTableRow sapCondRow = new EzBapicondTableRow();
				//sapCondRow.setCondtype(str);	//length 1
				sapCondRow.setCondType(str);
				String condVal= st2.nextToken();
				sapCondRow.setCondvalueString(condVal);
				sapCondRow.setCondValueString(condVal);
				sapCond.appendRow(sapCondRow);
			}
		}
	}	
		
	EzBapieslltxTable slltxTable = new EzBapieslltxTable();
	EzBapieslltxTableRow slltxRow = new EzBapieslltxTableRow();
	slltxRow.setTextLine(Remk);
	//slltxRow.setTextId("00");
	slltxTable.insertRow(0,slltxRow);

	ezparams.setObject(header);
	ezparams.setObject(headerAdd);
	ezparams.setObject(sapCond);
	ezparams.setObject(slltxTable);
	Session.prepareParams(ezparams);

	ReturnObjFromRetrieve ret=(ReturnObjFromRetrieve)ezPreProcManager.ezSaveQuote(ezparams);
	System.out.println(ret.toEzcString()+">>>");
	String retMsg = "";
	for ( int i=0;i<ret.getRowCount();i++){
		String Msg = ret.getFieldValueString(i,"MSG");
		String Type = ret.getFieldValueString(i,"TYPE");
		String Code = ret.getFieldValueString(i,"CODE");
		String MsgNo = ret.getFieldValueString(i,"MSGNO");
		if ("E".equalsIgnoreCase(Type.trim())){
			retMsg= "ERROR : "+Msg;
			break;
		}
	}
	if ("".equals(retMsg))
		retMsg = "Quotation Posted Successfully";


	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);

%>
