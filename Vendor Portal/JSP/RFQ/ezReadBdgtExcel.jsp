<%//@ include file="../Misc/ezVendHeader.jsp"%>  
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.util.*, org.json.*" %>
<%@ page import="java.util.*,ezc.ezdelvschedules.params.*,ezc.ezparam.*,java.text.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<html>
<head>
<body></body>
<form name="myForm" method="post" ENCTYPE="multipart/form-data">


<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<% 
	String sNo = request.getParameter("sNo");
	String itemcode = request.getParameter("itemCode");
	String desc = request.getParameter("desc");
	String uom = request.getParameter("uom");
	String currency = request.getParameter("currency");
	String finyear = request.getParameter("finYear");
	String bdgtrate = request.getParameter("bdgtRate");
	
	String jsonData = request.getParameter("readTableData");
	out.println("jsonData>>>>>"+jsonData);
	ArrayList<ArrayList<String>> jsonTableData = new ArrayList<ArrayList<String>>();
	
	 try {
	        // Parse the JSON data into a list
	        if (jsonData != null && !jsonData.isEmpty()) {
	            //JsonReader jsonReader = Json.createReader(new StringReader(jsonData));
	            //JsonArray jsonArray = jsonReader.readArray();
			JSONArray jsonArray =new JSONArray(jsonData);
			
			out.println("jsonData>>>>>"+jsonData.length());
	 
			for (int i=0;i<jsonArray.length();i++)
			{
				JSONArray js = jsonArray.getJSONArray(i);
				 ArrayList<String> rowData = new ArrayList<String>();
				 for (int j=0; j<js.length();j++)
				 {
				 	rowData.add(js.getString(j));
				 }
				 jsonTableData.add(rowData);
			}
		}
	           
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	out.println("jsonTableData>>>>>>>>>"+jsonTableData);
	for (ArrayList<String> row : jsonTableData) 
	{ 
		for (String cell : row) 
		{ 
			out.println("cell>>>>>>"+cell);
 		} 
 	}
	

	//out.println("itemcode>>>>"+itemcode);
	//out.println("desc>>>>>>>>>>>>"+desc);
	//out.println("uom>>>>>>"+uom);
	//out.println("currency>>>>>>>>"+currency);
	//out.println("finyear>>>>>>>>>>>"+finyear);
	//out.println("bdgtrate>>>>>>>>"+bdgtrate);
	
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 

	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	rfqTableRow.setQuery("INSERT INTO EZC_MAT_BUDGET_PRICE(EMBP_FIN_YEAR, EMBP_MONTH, EMBP_PLANT, EMBP_MATERIAL, EMBP_DESCRIPTION,EMBP_MAT_TYPE, EMBP_BASIC_PRICE, EMBP_LANDED_PRICE, EMBP_FY_START_DATE, EMBP_FY_END_DATE, EMBP_EXT1, EMBP_EXT2)"+"VALUES ('"+finyear+"','01','1000','"+itemcode+"','"+desc+"','API','100.00','',now(),now(),'','')");
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);

	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezSaveMiscTransactions(rfqParams);

	}

	catch(Exception e)
	{
		out.println("Exception in adding Payment Terms>>>>>"+e);
	}
%>
