<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />

<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 		str="";
 		return str;
 	}
 	private String checkNull1(String str)
	 {
		if("null".equals(str) ||str==null)
		str="NA";
		return str;
 	}
%>

<%	
 	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
 	
 	logs.setUserId("323306");
 	logs.setPassWd("cfl@2017");
 	logs.setConnGroup("200");
 	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);

	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	
	EziRFQHeaderParams	rfqheaderparams = new EziRFQHeaderParams();
	
	rfqheaderparams.setRFQNo("0006297548");
	rfqheaderparams.setSoldTo("0000324969");
	
	EziRFQHeaderTableRow 	rfqHeaderRow 	= null;
	EziRFQDetailsTableRow 	rfqDetailsRow 	= null;	
	EzRFQConditionsTableRow rfqCondTableRow = null;
	
	
	for(int count=0;count<1;count++)
	{
		rfqHeaderRow = new EziRFQHeaderTableRow();
		
		rfqHeaderRow.setRFQNo("123"+count);
		rfqHeaderRow.setStatus("34");
		
		//rfqHeaderRow.setCollectiveRFQNo("");
		//rfqHeaderRow.setSysKey("");
		//rfqHeaderRow.setSoldTo("");
		//rfqHeaderRow.setPRNo("");
		//rfqHeaderRow.setPRItmNo("");
		
		rfqHeaderRow.setRFQDate("");
		//rfqHeaderRow.setValidUpto("");
		//rfqHeaderRow.setCreatedBy("");
		rfqHeaderRow.setModifiedBy("");			
		//rfqHeaderRow.setCompCode("");			
		//rfqHeaderRow.setPurchaseOrg("");
		//rfqHeaderRow.setPurchaseGrp("");
		rfqHeaderRow.setVendorType("");
		//rfqHeaderRow.setAgentCode("");
		//rfqHeaderRow.setReleaseIndicator("");
		rfqHeaderRow.setRankStatus("");
		//rfqHeaderRow.setExt1("");
		rfqHeaderRow.setExt2("");
		//rfqHeaderRow.setExt3("");
		rfqHeaderRow.setValType("");
		//rfqHeaderRow.setPRDetails("");	
		rfqHeaderRow.setPriceValDate("");
		//rfqHeaderRow.setQuoteRef("");
		rfqHeaderRow.setDelvPeriod("");
		//rfqHeaderRow.setGuaranteePeriod("");
		rfqHeaderRow.setRequestRequote("");
		
		rfqHeaderTable.appendRow(rfqHeaderRow);
	}
	
	for(int count=0;count<1;count++)
	{
		rfqDetailsRow = new EziRFQDetailsTableRow();
		
		rfqDetailsRow.setRFQNo("RFQ121"+count);
		rfqDetailsRow.setLineNo("10");
		rfqDetailsRow.setCounter("1");
		rfqDetailsRow.setMaterial("MAT");
		rfqDetailsRow.setMaterialDesc("DESC");
		rfqDetailsRow.setUOM("UOM");
		rfqDetailsRow.setDeliveryDate("10/10/2017");
		rfqDetailsRow.setQuantity("3");
		rfqDetailsRow.setPrice("5");
		rfqDetailsRow.setPlant("123");
		rfqDetailsRow.setRemarks("sdfsd");
		rfqDetailsRow.setExt1("fdsgf");
		rfqDetailsRow.setExt2("fdgd");
		rfqDetailsRow.setExt3("dfsg");
		rfqDetailsRow.setCurr("dfg");
		rfqDetailsRow.setExchRate("4");	
		rfqDetailsRow.setNegPrice("0");
		rfqDetailsRow.setQuoteStatus("d");

		rfqDetailsTable.appendRow(rfqDetailsRow);
	}
	
	for(int count=0;count<4;count++)
	{
		rfqCondTableRow = new EzRFQConditionsTableRow();

		rfqCondTableRow.setVendor("sdfsd");
		rfqCondTableRow.setRfqNo("1221");
		rfqCondTableRow.setRfqLineNo("1"+count);
		rfqCondTableRow.setTaxCode("AA");
		rfqCondTableRow.setTaxValue("12");
		rfqCondTableRow.setTaxType("P");
		rfqCondTableRow.setCForm("FF");
		rfqCondTableRow.setExt1("11");
		rfqCondTableRow.setExt2("22");
		rfqCondTableRow.setExt3("33");
		rfqCondTableRow.setSeqNo("44");

		rfqCondTable.appendRow(rfqCondTableRow);
	}
		
	EziRFQHeaderParams params = new EziRFQHeaderParams();	
	
	params.setCollectiveRFQNo("11");

	ezparams.setLocalStore("Y");
	ezparams.setObject(params);
	ezparams.setObject(rfqHeaderTable);
	ezparams.setObject(rfqDetailsTable);
	ezparams.setObject(rfqCondTable);
	//ezparams.setObject(rfqheaderparams);
	
	Session.prepareParams(ezparams);
	
	try
	{
		rfqManager.ezGetRFQDetails(ezparams);
		//ReturnObjFromRetrieve retObj = (ReturnObjFromRetrieve)rfqManager.ezSaveQuote(ezparams);
		
		//out.println(":::::::retObj::::::::"+retObj.isError());
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Error while inserting RFQs in DB"+e,"I");
	}
	
%>