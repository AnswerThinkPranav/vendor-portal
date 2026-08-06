<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import="ezc.ezcommon.*,ezc.ezparam.*,java.io.*,java.nio.file.*" %>   
<%@ page import="java.util.*"%>   

<%!
	public void addKeyRow(String docId,String tabName,String fieldName,HttpServletRequest  req,ezc.misctransactions.params.EzMiscTable miscTable)throws Exception
	{
	
		ezc.ezcommon.EzLog4j.log("fieldName>>>>>if1>>>"+fieldName,"I");
		if(req.getParameter(fieldName)!=null)
		{
			StringBuffer fieldVal = new StringBuffer(req.getParameter(fieldName));
			ezc.ezcommon.EzLog4j.log("fieldVal>>>>>if1>>>"+fieldVal,"I");
			// to get a String result: 
			String str2 = checkNull(fieldVal.toString()).replaceAll("'","`");
			// to get a StringBuffer result:
			StringBuffer str3 = new StringBuffer(str2);
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery("INSERT INTO EZC_CUSTOMER_FORM_DETAILS(ECFD_DOC_ID,ECFD_FIELD,ECFD_VALUE,ECFD_TAB_NAME) VALUES('"+docId+"','"+checkNull(fieldName).replaceAll("'","`")+"','"+str3+"','"+tabName+"')");
			ezc.ezcommon.EzLog4j.log("fieldName>>>>>if1>>>"+miscTableRow.getQuery(),"I");
			miscTable.appendRow(miscTableRow);
		}
	}
	public void addMultiKeyRow(String docId,String tabName,String fieldName,HttpServletRequest  req,ezc.misctransactions.params.EzMiscTable miscTable)throws Exception
	{
			ezc.ezcommon.EzLog4j.log("fieldName in MultiKeyRow>>>"+req.getParameterValues(fieldName),"I");

			String[] fieldValArr     = req.getParameterValues(fieldName);
			//ezc.ezcommon.EzLog4j.log("fieldValArr>>>>>>>>"+fieldValArr.length,"I");
			String fieldVal ="";
			if(fieldValArr!=null)
			{
				for(int i=0;i<fieldValArr.length;i++)
				{
					if(i == 0)
						fieldVal = fieldValArr[i];
					else
						fieldVal = fieldVal+"#"+fieldValArr[i];
				}
				
				ezc.ezcommon.EzLog4j.log("fieldVal in MultiKeyRow11>>>>>>>>"+fieldVal,"I");
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				miscTableRow.setQuery("INSERT INTO EZC_CUSTOMER_FORM_DETAILS(ECFD_DOC_ID,ECFD_FIELD,ECFD_VALUE,ECFD_TAB_NAME) VALUES('"+docId+"','"+checkNull(fieldName).replaceAll("'","`")+"','"+checkNull(fieldVal).replaceAll("'","`")+"','"+tabName+"')");
				ezc.ezcommon.EzLog4j.log("fieldName in MultiKey>>>>>if1>>>"+miscTableRow.getQuery(),"I");
				miscTable.appendRow(miscTableRow);	
			}
	}	
%> 
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
	
%> 


<%
ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
ezc.ezparam.ReturnObjFromRetrieve retErrorObj	  =	null;

int contctLineNumberVal=0;
int topCusLineNumberVal=0;
int plantSiteLineNumberVal=0;
int DPASLineNumberVal=0;
String docId=checkNull(request.getParameter("docId"));
ezc.ezcommon.EzLog4j.log("docIdNew>>>>>>>>"+docId,"I");
/*
String cMethodArr[]     = request.getParameterValues("conMethod");
ezc.ezcommon.EzLog4j.log("cMethodNew>>>>>>>>"+cMethodArr.length,"I");
String cMethodStr ="";
	if(cMethodArr!=null)
	{
		for(int i=0;i<cMethodArr.length;i++)
		{
			if(i == 0)
				cMethodStr = cMethodArr[i];
			else
			    	cMethodStr = cMethodStr+"#"+cMethodArr[i];
		}
	}
ezc.ezcommon.EzLog4j.log("cMethodStr>>>>>>>>"+cMethodStr,"I"); */

String tabVal1=checkNull(request.getParameter("tabVal1"));
String tabVal2=checkNull(request.getParameter("tabVal2"));
String tabVal3=checkNull(request.getParameter("tabVal3"));
ezc.ezcommon.EzLog4j.log("tabVal3>>>>>>>>"+tabVal3,"I");
String tabVal4=checkNull(request.getParameter("tabVal4"));
String tabVal5=checkNull(request.getParameter("tabVal5"));

String contctLineNumber=checkNull(request.getParameter("tLineNumberVal"));
String topCusLineNumber=checkNull(request.getParameter("topCusLineNumberVal"));
String plantSiteLineNumber=checkNull(request.getParameter("plantSiteLineNumberVal"));
String DPASLineNumber=checkNull(request.getParameter("DPASLineNumberVal"));
String paymntTerms=checkNull(request.getParameter("paymntTerms"));
ezc.ezcommon.EzLog4j.log("paymntTerms>>>>>>>>"+paymntTerms,"I");


String qry="";

	if(tabVal1!="")
	{
 	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS where ECFD_DOC_ID ='"+docId+"' and ECFD_TAB_NAME in ( 'CONTCT_DET','CONTCT_DET1','CONTCT_DET2')";
	}
	if(tabVal2!="")
	{
	ezc.ezcommon.EzLog4j.log("INTO TAB3>>>>>>>>");
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='CONSTN_DET'";
	}
	if(tabVal3!="")
	{
	ezc.ezcommon.EzLog4j.log("INTO TAB4>>>>>>>>");
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='MSME_DET'";
	}
	
	/*if(tabVal4!="")
	{
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME in('FINAC_DET','FINAC_DET1')";
	}*/
	if(tabVal4!="")
	{
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME in('DOC_DET')";
	}	
	if(tabVal5!="")
	{
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='BANK_DET'";
	}
	if(tabVal2=="" && !"".equals(paymntTerms))
	{
	qry="DELETE FROM EZC_CUSTOMER_FORM_DETAILS WHERE ECFD_DOC_ID='"+docId+"' AND ECFD_TAB_NAME='CONSTN_DET' and ECFD_FIELD in('paymntTerms')";
	}
	
	
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery(qry);
	miscTable.appendRow(miscTableRow);	


	if(tabVal1!="")
	{
	if(contctLineNumber!="")
		contctLineNumberVal=Integer.parseInt(contctLineNumber);

	if(topCusLineNumber!="")
		topCusLineNumberVal=Integer.parseInt(topCusLineNumber);


		addKeyRow(docId,"CONTCT_DET","title",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","vendName",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","searchTerm",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","careOf_Name",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","addrsLine1",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","districtName",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","phoneNum",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","addrsLine2",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","postalCode",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","altPhoneNum",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","addrsLine3",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","country",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","mobNum",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","addrsLine4",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","city",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","altMobNum",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","addrsLine5",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","state",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","fax",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","email_1",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","email_2",request,miscTable); 
		addKeyRow(docId,"CONTCT_DET","website",request,miscTable); 
		addMultiKeyRow(docId,"CONTCT_DET","conMethod",request,miscTable);
		addKeyRow(docId,"CONTCT_DET","othConMethod",request,miscTable);
		
		for(int i=1;i<=contctLineNumberVal;i++)
		{
			addKeyRow(docId,"CONTCT_DET1","contactTitle_"+i,request,miscTable);
			addKeyRow(docId,"CONTCT_DET1","contactName_"+i,request,miscTable);
			addKeyRow(docId,"CONTCT_DET1","contactPhone_"+i,request,miscTable);
			addKeyRow(docId,"CONTCT_DET1","contactDesgtn_"+i,request,miscTable);
			addKeyRow(docId,"CONTCT_DET1","contactEmail_"+i,request,miscTable);
		}
		/*
		for(int j=1;j<=topCusLineNumberVal;j++)
		{
		addKeyRow(docId,"CONTCT_DET2","TopCusName_"+j,request,miscTable);
		addKeyRow(docId,"CONTCT_DET2","TopCusPrdOff_"+j,request,miscTable);
		addKeyRow(docId,"CONTCT_DET2","TopCusValue_"+j,request,miscTable);
		addKeyRow(docId,"CONTCT_DET2","TopCusPercntOfTotBusiness_"+j,request,miscTable);
		addKeyRow(docId,"CONTCT_DET2","TopCusContPerson_"+j,request,miscTable);
		addKeyRow(docId,"CONTCT_DET2","TopCusPhone_"+j,request,miscTable);
		}*/
	}
	if(tabVal2!="")
	{
		addKeyRow(docId,"CONSTN_DET","typeOfOrg",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","othCompType",request,miscTable);
		addMultiKeyRow(docId,"CONSTN_DET","supType",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","othSupType",request,miscTable);
		addMultiKeyRow(docId,"CONSTN_DET","vendorType",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","purOrdCurr",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","paymntTermsText",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","paymntTerms",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","INCO_Terms2",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","INCO_Terms",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","PAN_Name",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","PAN_Attach",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","PAN_Number",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","gstVendorClas",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","gstType",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","gst_Number",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","BUS_Type",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","TAN_Number",request,miscTable);		
		addKeyRow(docId,"CONSTN_DET","iata_Number",request,miscTable);
		addKeyRow(docId,"CONSTN_DET","ssi_Number",request,miscTable);
	}
	
	if(tabVal3!="")
	{

		addKeyRow(docId,"MSME_DET","msme_Type",request,miscTable);		
		addKeyRow(docId,"MSME_DET","msme_Udyog_AdhrNo",request,miscTable);
		addKeyRow(docId,"MSME_DET","paymntTerms",request,miscTable);
		addKeyRow(docId,"MSME_DET","bus_Status",request,miscTable);
		addKeyRow(docId,"MSME_DET","e_Invoice",request,miscTable);
		addKeyRow(docId,"MSME_DET","vend_Jgl",request,miscTable);
		addKeyRow(docId,"MSME_DET","vend_Unit",request,miscTable);
		addKeyRow(docId,"MSME_DET","vend_Trans",request,miscTable);
		addKeyRow(docId,"MSME_DET","vend_Dtls",request,miscTable);
		addKeyRow(docId,"MSME_DET","vend_Site",request,miscTable);
		addKeyRow(docId,"MSME_DET","sitePerson",request,miscTable);
		addKeyRow(docId,"MSME_DET","siteViDt",request,miscTable);
		addKeyRow(docId,"MSME_DET","otherBusInfo",request,miscTable);
		//addKeyRow(docId,"MSME_DET","msme_CertfctnDate",request,miscTable);
		
	}
	/*
	if(tabVal4!="")
	{ 
		if(DPASLineNumber!="")
			DPASLineNumberVal=Integer.parseInt(DPASLineNumber);
		addKeyRow(docId,"FINAC_DET","annual_TurnOver",request,miscTable);
		addKeyRow(docId,"FINAC_DET","delt_With_HSIL",request,miscTable);

		for(int l=1;l<=DPASLineNumberVal;l++)
		{
			addKeyRow(docId,"FINAC_DET1","dpaPersonName_"+l,request,miscTable);
			addKeyRow(docId,"FINAC_DET1","dpaAddress_"+l,request,miscTable);
			addKeyRow(docId,"FINAC_DET1","dpaPhoneNum_"+l,request,miscTable);
			addKeyRow(docId,"FINAC_DET1","dpaEmail_"+l,request,miscTable);
		}
	}*/
	if(tabVal4!="")
	{ 	
			addKeyRow(docId,"DOC_DET","itrAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","moaAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","fsAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","saAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","kcAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","othAttach",request,miscTable);
			addKeyRow(docId,"DOC_DET","w9Attach",request,miscTable);
			addKeyRow(docId,"DOC_DET","w8Attach",request,miscTable);
			addKeyRow(docId,"DOC_DET","INTAttach",request,miscTable);
	}	
	if(tabVal5!="")
	{
			addKeyRow(docId,"BANK_DET","pmntMode",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Per",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Mobile",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Email",request,miscTable);
			addKeyRow(docId,"BANK_DET","rtgs_Code",request,miscTable);
			addKeyRow(docId,"BANK_DET","bankName",request,miscTable);
			addKeyRow(docId,"BANK_DET","bank_Branch",request,miscTable);
			addKeyRow(docId,"BANK_DET","accnt_Number",request,miscTable);
			addKeyRow(docId,"BANK_DET","bank_Swift",request,miscTable);
			addKeyRow(docId,"BANK_DET","chequeNo",request,miscTable);
			addKeyRow(docId,"BANK_DET","whTaxType",request,miscTable);
			addKeyRow(docId,"BANK_DET","whTaxCode",request,miscTable);
			addKeyRow(docId,"BANK_DET","recType",request,miscTable);
			addKeyRow(docId,"BANK_DET","reconAccount",request,miscTable);
			addKeyRow(docId,"BANK_DET","docAck",request,miscTable);
			
			//addKeyRow(docId,"BANK_DET","accnt_Type",request,miscTable);
			//addKeyRow(docId,"BANK_DET","bank",request,miscTable);
			//addKeyRow(docId,"BANK_DET","bank_Address_Line1",request,miscTable);
			//addKeyRow(docId,"BANK_DET","bank_Address_Line2",request,miscTable);
			//addKeyRow(docId,"BANK_DET","bank_Location",request,miscTable);
	}
	if(tabVal2=="" && !"".equals(paymntTerms))
	{

		qry="INSERT INTO EZC_CUSTOMER_FORM_DETAILS (ECFD_DOC_ID,ECFD_FIELD,ECFD_VALUE,ECFD_TAB_NAME)  VALUES ('"+docId+"','paymntTerms','"+paymntTerms+"','CONSTN_DET') ";
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery(qry);
		miscTable.appendRow(miscTableRow);
			
	}
	try
	{
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams); 
			retErrorObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(mainParams);
	}
	catch(Exception e){}	
		out.println("success");
%>
