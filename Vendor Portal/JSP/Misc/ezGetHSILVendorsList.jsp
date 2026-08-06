<%
	String vendorsSelBox = "";
	java.util.Hashtable gv_VendorsHT = new java.util.Hashtable();

	String lv_QryStr = "";
	
	
	if("3".equals(userType))
		lv_QryStr = " AND EU_ID = '"+Session.getUserId()+"'";

	ezc.ezparam.ReturnObjFromRetrieve gv_VendorsRetObj = null;
	int gv_VendorsRetObjCnt = 0;
	ezc.ezparam.EzcParams lv_VenMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager lv_VendMiscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable lv_VendTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow lv_VenTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	lv_VenTableRow.setQuery("SELECT EU_ID,EUD_VALUE,EU_FIRST_NAME FROM EZC_USERS,EZC_USER_DEFAULTS WHERE EU_ID = EUD_USER_ID AND EU_TYPE='3' AND EUD_KEY='SOLDTOPARTY'"+lv_QryStr+" ORDER BY EU_FIRST_NAME");
	lv_VendTable.appendRow(lv_VenTableRow);
	lv_VenMainParams.setLocalStore("Y");
	lv_VenMainParams.setObject(lv_VendTable);
	Session.prepareParams(lv_VenMainParams);
	try{
		gv_VendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)lv_VendMiscMgr.ezGetMiscTransactions(lv_VenMainParams);
	}
	catch(Exception e){}	
	
	if(gv_VendorsRetObj!=null)
	{
		gv_VendorsRetObjCnt = gv_VendorsRetObj.getRowCount();
		
		if(gv_VendorsRetObjCnt>0)
		{
			vendorsSelBox = "<Select class='form-control select2' name='selVendorCode' id='selVendorCode'>";
			vendorsSelBox += "<Option value=''>--ALL--</Option>";
			for(int lv=0;lv<gv_VendorsRetObjCnt;lv++)
			{
				String lv_Vendor 	= gv_VendorsRetObj.getFieldValueString(lv,"EUD_VALUE");
				String lv_VendorName 	= gv_VendorsRetObj.getFieldValueString(lv,"EU_FIRST_NAME");
				String selectStr   	= "";
				try{
					lv_Vendor = Long.parseLong(lv_Vendor)+"";
					lv_Vendor = "0000000000"+lv_Vendor;
					lv_Vendor = lv_Vendor.substring(lv_Vendor.length()-10,lv_Vendor.length());
				}catch(Exception e){}
				
				gv_VendorsHT.put(lv_Vendor,lv_VendorName);
				
				//if(lv_Vendor.equals(selVendorCode))
					//selectStr   	= "selected";
				
				vendorsSelBox += "<Option value='"+lv_Vendor+"' "+selectStr+">"+lv_VendorName+"["+lv_Vendor+"]</Option>";
			}	
			vendorsSelBox += "</Select>";
		}	
		
	}	
		
	//out.println("::::gv_VendorsHT::::::"+gv_VendorsHT);	
	
ezc.ezcommon.EzLog4j.log("::::::::gv_VendorsRetObjCnt::::::: "+gv_VendorsRetObjCnt,"I");
  		
%>