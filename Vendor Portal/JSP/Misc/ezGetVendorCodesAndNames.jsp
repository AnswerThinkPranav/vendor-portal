<jsp:useBean id="ezVendTransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope="session" />

<% 
	String v_VendUserType = (String)session.getValue("UserType");
	String vendUserSoldTo = (String)session.getValue("SOLDTO");

	java.util.Hashtable vendorsHT = new java.util.Hashtable(); 
	java.util.Vector vendorsVector= new java.util.Vector(); 
	int vendorsRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve vendorsRetObj = null;

	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();

	try
	{
		v_KeyParams.setKey("GET_VENDORS");
		addMainParams.setLocalStore("Y");
		
		if("2".equals(v_VendUserType))
			vendParams.setSyskey(userSyskeysStr);
			//vendParams.setSyskey((String)session.getValue("SYSKEY"));
		else
			vendParams.setSyskey((String)session.getValue("SYSKEY")+"') AND LTRIM(RTRIM(EC_ERP_CUST_NO)) = ('"+vendUserSoldTo.trim());
			
		vendParams.setGroup("");

		addMainParams.setObject(v_KeyParams);	
		addMainParams.setObject(vendParams);
		Session.prepareParams(addMainParams);

		vendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)ezVendTransactions.ezGetVendorTransactions(addMainParams);
		vendorsRetObj.sort(new String[]{"ECA_NAME"},true);
		if(vendorsRetObj!=null && vendorsRetObj.getRowCount()>0)
		{
			vendorsRetObjCnt = vendorsRetObj.getRowCount();

			for(int vc=0;vc<vendorsRetObjCnt;vc++)
			{
				vendorsHT.put(vendorsRetObj.getFieldValueString(vc,"EC_ERP_CUST_NO").trim(), vendorsRetObj.getFieldValueString(vc,"ECA_NAME"));
				vendorsVector.addElement(vendorsRetObj.getFieldValueString(vc,"EC_ERP_CUST_NO").trim());
			}

		}	
	}
	catch(Exception e){
		//out.println(":::EEEE:::"+e);
	}

	ezc.ezparam.ReturnObjFromRetrieve tempVendorsRetObj = null;
	int tempVendorsRetObjCnt = 0;
	if("RFQ".equals(request.getParameter("menuItem"))) //This is to get and show Temp Users List
	{
		EzcUserParams uparams= new EzcUserParams();
		Session.prepareParams(uparams);	
		EzcUserNKParams ezcUserNKParams = new EzcUserNKParams();
		ezcUserNKParams.setLanguage("EN");
		ezcUserNKParams.setSys_Key("999000') AND EU_CHANGED_BY IN ('"+Session.getUserId());
		uparams.createContainer();
		uparams.setObject(ezcUserNKParams);
		tempVendorsRetObj =	(ezc.ezparam.ReturnObjFromRetrieve)UserManager.getUsersForSalesArea(uparams);

		if(tempVendorsRetObj!=null)
			tempVendorsRetObjCnt = tempVendorsRetObj.getRowCount();

		for(int p=0;p<tempVendorsRetObjCnt;p++)
		{
			String tempVendUser = "0000000000"+tempVendorsRetObj.getFieldValueString(p,"EU_ID").trim();
			tempVendUser = tempVendUser.substring(tempVendUser.length()-10,tempVendUser.length());

			vendorsHT.put(tempVendUser, tempVendorsRetObj.getFieldValueString(p,"EU_FIRST_NAME"));
			vendorsVector.addElement(tempVendUser);
		}
	}	

	//out.println("::::::vendorsHT:::::::"+vendorsHT);
%>	