<%@ page import ="java.util.*,ezc.ezbasicutil.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%
	String Status 	= request.getParameter("Status");
	String matNo 	= request.getParameter("matNo");
	String plant 	= request.getParameter("selplant");
	String fromDate = request.getParameter("fromDate");
	String toDate 	= request.getParameter("toDate");

	ezc.ezparam.ReturnObjFromRetrieve myRet = null;
	ezc.ezparam.ReturnObjFromRetrieve globalRet = null;
	ezc.ezpreprocurement.client.EzPreProcurementManager cm=new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziPreProcurementParams param=new ezc.ezpreprocurement.params.EziPreProcurementParams();

	if(!("".equals(matNo) || matNo==null || "null".equals(matNo)))
		param.setMaterial(matNo);
	
	if(!("".equals(plant) || plant==null || "null".equals(plant)))
		param.setPlant(plant); 
	
	String tpfromDate = "";
	if(!("".equals(fromDate) || fromDate==null || "null".equals(fromDate)))
	{
		try
		{
			tpfromDate = fromDate.substring(3,5)+"/"+fromDate.substring(0,2)+"/"+fromDate.substring(6,10);
			
		}
		catch(Exception e)
		{}
		
		param.setDelivDate(tpfromDate);
	}	
	if(!("".equals(toDate) || toDate==null || "null".equals(toDate)))	
		param.setDelivDateTo(toDate);
	
	
	
	
	
	if(Status.equals("R"))
	{		
		param.setExt1("Y");
	}
	else
	{	
		param.setExt1("N");
	}	
	
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(true);
	mainParams.setObject(param);
	Session.prepareParams(mainParams);
	try
	{
		myRet=(ezc.ezparam.ReturnObjFromRetrieve)cm.ezGetPurchReqList(mainParams);
	}
	catch(Exception e)
	{
		System.out.println("Exception Occured in iListPR.jsp"+e.getMessage());
	}
	
	int myRetCount = 0;
	if(myRet!=null)
	{
		myRetCount = myRet.getRowCount();
		myRet.addColumn("SORTING");
	}
	/*if(myRetCount>0)
	{
		myRet.sort(new String[]{"REQNO"},true);
		//myRet.sort(new String[]{"REQDATE"},false);
	}*/
	
	String sorting = "";
	
	if(myRetCount>0)
	{
		TreeSet hs =new TreeSet();
		
		for(int i=0;i<myRetCount;i++)
		{
			try
			{
				hs.add(new Long(Long.parseLong(myRet.getFieldValueString(i,"REQNO"))+""+Long.parseLong(myRet.getFieldValueString(i,"ITEM"))));
				
				sorting = myRet.getFieldValueString(i,"REQNO")+""+myRet.getFieldValueString(i,"ITEM");
				// out.println("sorting::"+sorting);
				
				myRet.setFieldValue("SORTING",sorting);
				myRet.addRow();
			} 
			catch(Exception e)
			{
			
			}
		}

		myRet.sort(new String[]{"SORTING"},true);
	}
	
	/************* The following is for knowing RFQ created against PR(s) or not  ******************/	
	java.util.TreeSet prTreeSet=new java.util.TreeSet();
	java.util.Hashtable colRfqsHt=new java.util.Hashtable();
	ezc.ezparam.ReturnObjFromRetrieve retObj = null;

	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezirfqheaderparams.setExt1("RFQ_PR");	
	mainParams.setObject(ezirfqheaderparams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	try
	{
		retObj=(ezc.ezparam.ReturnObjFromRetrieve)cm.ezGetRFQList(mainParams);
	}
	catch(Exception e)
	{
		System.out.println("Exception Occured in iListPR.jsp while getting PR details"+e.getMessage());
	}	

	int retObjCount=0;
	if(retObj!=null)
		retObjCount=retObj.getRowCount();

	for(int i=0;i<retObjCount;i++)
	{
		String prText=retObj.getFieldValueString(i,"PR_TEXT");
		String colRfqNo=retObj.getFieldValueString(i,"COLLECTIVE_RFQ_NO");
		if(prText!=null && !"null".equals(prText) && !"".equals(prText.trim()))
		{

			EzStringTokenizer notesAllSt=null;
			notesAllSt = new EzStringTokenizer(prText,"$");
			int notesAllCt =notesAllSt.getTokens().size();
			if(notesAllCt>0)
			{
				for(int j=0;j<notesAllCt;j++)
				{
					EzStringTokenizer notesAllSt1 = new EzStringTokenizer((String)notesAllSt.getTokens().elementAt(j),"¥");
					int notesAllCt1 = notesAllSt1.getTokens().size();
					if(notesAllCt1>1)
					{

						String keyStr=(String)notesAllSt1.getTokens().elementAt(0)+"¥"+(String)notesAllSt1.getTokens().elementAt(1);

						prTreeSet.add(keyStr);
						colRfqsHt.put(keyStr,colRfqNo);
					}
				}	
			}
		}	
	}
	
	
	
%>
