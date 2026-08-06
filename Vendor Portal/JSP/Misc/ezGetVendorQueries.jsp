<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezVendTransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<% 
	int vendorsRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve vendorsRetObj = null;

	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzDispatchHeaderParams  vendParams= new ezc.vendortransactions.params.EzDispatchHeaderParams();

	try
	{
		v_KeyParams.setKey("GET_DISPATCH_LIST");
		addMainParams.setLocalStore("Y");
		
		vendParams.setQryStr((String)session.getValue("SYSKEY"));

		addMainParams.setObject(v_KeyParams);	
		addMainParams.setObject(vendParams);
		Session.prepareParams(addMainParams);

		vendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)ezVendTransactions.ezGetVendorTransactions(addMainParams);
	}
	catch(Exception e){
		//out.println(":::EEEE:::"+e);
	}

	//out.println("::::::vendorsHT:::::::"+vendorsHT);
%>	