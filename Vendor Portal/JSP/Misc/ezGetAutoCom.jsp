<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ page import ="org.json.*" %>


<%
	String query = request.getParameter("q");
	String type = request.getParameter("type"); 
	String plantName = request.getParameter("plantName");
	String plantNameVal = request.getParameter("plant");
	String matrixName = request.getParameter("matrixName"); 
	String landedVal = request.getParameter("landedVal");  
	String userName = request.getParameter("userName");
	
	if(query != null)
	{
		query = query.toUpperCase();
		
	
	}
	ezc.ezparam.ReturnObjFromRetrieve gv_VendorsRetObj = null;
	int gv_VendorsRetObjCnt = 0; 
	ezc.ezparam.EzcParams lv_VenMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager lv_VendMiscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable lv_VendTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow lv_VenTableRow = new ezc.misctransactions.params.EzMiscTableRow(); 
	if("VEND".equals(type))
		lv_VenTableRow.setQuery("SELECT EU_ID,EU_FIRST_NAME FROM EZC_USERS WHERE UPPER(EU_ID) LIKE '%"+query+"%' OR UPPER(EU_FIRST_NAME) LIKE '%"+query+"%' AND EU_TYPE IN ('3','4')  LIMIT 10");
	else if("PLANT".equals(type))
		lv_VenTableRow.setQuery("SELECT EP_PLANT,EP_NAME1 FROM EZC_PLANTS WHERE UPPER(EP_PLANT) LIKE '%"+query+"%' OR UPPER(EP_NAME1) LIKE '%"+query+"%'  LIMIT 10");
	else if("USERNAME".equals(type))
		lv_VenTableRow.setQuery("SELECT ECFH_DOC_ID,ECFH_CUST_NAME  from ezc_customer_form_header where ECFH_CUST_NAME like '%"+userName+"%' order by ECFH_CUST_NAME asc limit 10");
	else if("USEREMAIL".equals(type))
		lv_VenTableRow.setQuery("select * from ezc_customer_form_header where ECFH_CUST_NAME like '%"+query+"%' order by ECFH_CUST_NAME asc limit 10");
	else if("USER".equals(type))
		lv_VenTableRow.setQuery("SELECT EU_ID,EU_FIRST_NAME FROM EZC_USERS WHERE UPPER(EU_ID) LIKE '%"+query+"%' OR UPPER(EU_FIRST_NAME) LIKE '%"+query+"%'  LIMIT 10");
		
	else if("WOAPPRS".equals(type))
		lv_VenTableRow.setQuery("SELECT EWW_APPR_LEVEL,EWW_APPROVER FROM EZC_WO_WORKFLOW WHERE EWW_LANDED_PRICE ='"+landedVal+"' AND EWW_PLANT IN ('"+plantNameVal+"') ORDER BY EWW_APPR_LEVEL ASC");	
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