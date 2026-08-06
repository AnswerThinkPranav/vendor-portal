<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ page import ="org.json.*" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@page language="java" %>
<%!
		public org.json.JSONArray retToJsonArr(ezc.ezparam.ReturnObjFromRetrieve retInput)throws Exception
			{
				org.json.JSONArray jsonRetArray = new org.json.JSONArray();
				if(retInput != null)
				{
					
					org.json.JSONObject jsonRetObj = new org.json.JSONObject();
					 java.text.SimpleDateFormat sdfObj = new java.text.SimpleDateFormat("MM/dd/yyyy");
		
					for (int i = 0; i < retInput.getRowCount(); i++) {
						org.json.JSONObject jsonSubRetObj = new org.json.JSONObject();
		
						for (int j = 0; j < retInput.getColumnCount(); j++) {
							try {
								Object obj = retInput.getFieldValue(i, j);
								if(obj != null && obj instanceof java.util.Date) 
									obj = sdfObj.format((java.util.Date)obj);
								jsonSubRetObj.put(retInput.getFieldName(j),obj);
							} catch (Exception ex) {
							}
						}
						jsonRetArray.put(jsonSubRetObj);
					}

				}
				return jsonRetArray;
	}

%>
<%
	String query = (String)request.getParameter("search");
    	ezc.ezparam.ReturnObjFromRetrieve gv_VendorsRetObj = null;
    	int gv_VendorsRetObjCnt = 0; 
    	ezc.ezparam.EzcParams lv_VenMainParams = new ezc.ezparam.EzcParams(false); 				
    	ezc.misctransactions.client.EzMiscTransactionsManager lv_VendMiscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
    	ezc.misctransactions.params.EzMiscTable lv_VendTable = new ezc.misctransactions.params.EzMiscTable();
    	ezc.misctransactions.params.EzMiscTableRow lv_VenTableRow = new ezc.misctransactions.params.EzMiscTableRow(); 
    	lv_VenTableRow.setQuery("SELECT ECFH_CUST_NAME  from ezc_customer_form_header where ECFH_CUST_NAME like '%"+query+"%' order by ECFH_CUST_NAME asc limit 10");    	
    	lv_VendTable.appendRow(lv_VenTableRow);
    	lv_VenMainParams.setLocalStore("Y"); 
    	lv_VenMainParams.setObject(lv_VendTable);
    	Session.prepareParams(lv_VenMainParams);
    	try{ 
    		gv_VendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)lv_VendMiscMgr.ezGetMiscTransactions(lv_VenMainParams);
    		
	}
	catch(Exception e){}
	JSONArray jsonVendArray = retToJsonArr(gv_VendorsRetObj);
	out.println(jsonVendArray);        
%> 