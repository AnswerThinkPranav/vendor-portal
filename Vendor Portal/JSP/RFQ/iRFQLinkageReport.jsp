
<%	
	int retsldcnt = 0;
	String vndrCodes = (String)session.getValue("SOLDTOS");
		
	String fromDate=request.getParameter("fromDate");
	String toDate=request.getParameter("toDate");
	String fromDate1="";
	String toDate1="";
	
	ezc.ezparam.ReturnObjFromRetrieve myRet = null;	
	
	if ((fromDate!=null)&&(toDate!=null))
	{
	
		String token[]=fromDate.split("/");
		String toDttoken[]=toDate.split("/");
		fromDate1=token[1]+"/"+token[0]+"/"+token[2];
		toDate1=toDttoken[1]+"/"+toDttoken[0]+"/"+toDttoken[2];
		
		ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
		ezc.ezparam.EzcParams ezcparams				     		= new ezc.ezparam.EzcParams(false);
		ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
			
		String SysKey = (String)session.getValue("SYSKEY");
		String soldTo = (String)session.getValue("SOLDTO");	
		ezirfqheaderparams.setSoldTo(vndrCodes);
		ezirfqheaderparams.setStatus("C");
		ezirfqheaderparams.setExt1("LINKAGEREPORT");	
		ezirfqheaderparams.setExt2(fromDate1);	
		ezirfqheaderparams.setExt3(toDate1);
		ezirfqheaderparams.setSysKey(SysKey);
		ezcparams.setObject(ezirfqheaderparams);
		ezcparams.setLocalStore("Y");
		Session.prepareParams(ezcparams);
		
		try
		{
			myRet = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);
		}
		catch(Exception e)
		{
			System.out.println("Exception Occured while getting RFQ List:"+e);
		}
	}	
	int Count= 0;
	if(myRet!=null)
		Count = myRet.getRowCount();
	if (fromDate == null)
		fromDate = "";
	if (toDate == null)
		toDate = "";	
			
%>	