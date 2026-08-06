<%@ page import="java.util.*" %>
<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

	String vendCode = ((String)session.getValue("SOLDTO")).trim();
	String selVendCompCode = request.getParameter("selCompCode");
	String financialYear = request.getParameter("selFinancialYear"); 
	String startYear = "", endYear = "";
	
	Date currDate = new Date();
	int curMonth=0, curYear = 0;
	
	curMonth=(currDate.getMonth()+1);
	curYear=currDate.getYear()+1900;
	
	Hashtable monIntHt=new Hashtable();
	monIntHt.put("1","April--June");
	monIntHt.put("2","July--Sept");
	monIntHt.put("3","Oct--Dec");
	monIntHt.put("4","Jan--March");
	
	int noOfQuarters = 4;
	
	if(financialYear!=null)
	{
		startYear = financialYear.split("FYR")[0];
		endYear = financialYear.split("FYR")[1];
	
		if(curYear == Integer.parseInt(startYear) || curYear == Integer.parseInt(endYear))
		{
			if(curMonth>3 && curMonth<=6)
				noOfQuarters = 4;
			else if(curMonth>=6 && curMonth<=9)
				noOfQuarters = 1;
			else if(curMonth>=9 && curMonth<=12)	
				noOfQuarters = 2;	
			else if(curMonth>=1 && curMonth<=3)
				noOfQuarters = 3;
		}	
	}else{ 
		if(curMonth<=6)
		{	
			startYear=(currDate.getYear()+1899)+"";
			endYear=(currDate.getYear()+1900)+"";
		}
		else
		{ 
			startYear=(currDate.getYear()+1900)+"";
			endYear=(currDate.getYear()+1901)+"";	
		}
		
		if(curMonth>3 && curMonth<=6)
			noOfQuarters = 4;
		else if(curMonth>=6 && curMonth<=9)
			noOfQuarters = 1;
		else if(curMonth>=9 && curMonth<=12)	
			noOfQuarters = 2;	
		else if(curMonth>=1 && curMonth<=3)
			noOfQuarters = 3;	
	}
	
	//out.println(financialYear+":::::::::"+startYear+":::::::::"+endYear);
	//out.println(curMonth+":::::::::"+curYear+":::::::::"+noOfQuarters);
	
	
	Hashtable startDateHT = new Hashtable();
	Hashtable endDateHT = new Hashtable();
	
	if(noOfQuarters==1)
	{
		startDateHT.put("Q1","01/04/"+startYear);
		endDateHT.put("Q1","31/06/"+startYear);
	}
	else if(noOfQuarters==2)
	{
		startDateHT.put("Q1","01/04/"+startYear);
		endDateHT.put("Q1","30/06/"+startYear);
		
		startDateHT.put("Q2","01/07/"+startYear);
		endDateHT.put("Q2","30/09/"+startYear);
		
	}
	else if(noOfQuarters==3)
	{
		startDateHT.put("Q1","01/04/"+startYear);
		endDateHT.put("Q1","30/06/"+startYear);
		
		startDateHT.put("Q2","01/07/"+startYear);
		endDateHT.put("Q2","30/09/"+startYear);
		
		startDateHT.put("Q3","01/10/"+startYear);
		endDateHT.put("Q3","31/12/"+startYear);
	}
	else if(noOfQuarters==4)
	{
		startDateHT.put("Q1","01/04/"+startYear);
		endDateHT.put("Q1","30/06/"+startYear);

		startDateHT.put("Q2","01/07/"+startYear);
		endDateHT.put("Q2","30/09/"+startYear);

		startDateHT.put("Q3","01/10/"+startYear);
		endDateHT.put("Q3","31/12/"+startYear);
		
		startDateHT.put("Q4","01/01/"+endYear);
		endDateHT.put("Q4","31/03/"+endYear);
		
	}
	
	if(selVendCompCode==null)
		selVendCompCode = compCodeArr[0];
	

	Vector<Integer> confimedQtrs = new Vector<Integer>();
	Hashtable<Integer,String> qtrComments=new Hashtable<Integer,String>(); 

	int count=0;
	ezc.ezparam.ReturnObjFromRetrieve VendorListRetObj=null;
	try

	{
		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.vendortransactions.params.EzVendorBalConfirmParams vendBalConfirmParams= new ezc.vendortransactions.params.EzVendorBalConfirmParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyParams.setKey("GET_VEND_BAL_CONFIRM_LIST_BY_VEND");
		addMainParams.setLocalStore("Y");

		vendBalConfirmParams.setVendor(vendCode+ "') AND EVBC_COMPANY_CODE IN ('"+selVendCompCode);
		vendBalConfirmParams.setQryString(" AND EVBC_QRTR_START_DATE >= TO_DATE('01/04/"+startYear+"','DD/MM/YYYY') AND EVBC_QRTR_END_DATE <= TO_DATE('31/03/"+endYear+"','DD/MM/YYYY')");
		addMainParams.setObject(keyParams);	
		addMainParams.setObject(vendBalConfirmParams);
		Session.prepareParams(addMainParams);

		VendorListRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
		if(VendorListRetObj!=null && VendorListRetObj.getRowCount()>0)
		{
			count=VendorListRetObj.getRowCount();
		}

	}
	catch(Exception e)
	{
		out.println(":::EEEE:::"+e);
	}
	for(int i=0;i<count;i++)
	{
		confimedQtrs.add(Integer.parseInt(VendorListRetObj.getFieldValueString(i,"EVBC_CONF_QUARTER")));
		qtrComments.put(Integer.parseInt(VendorListRetObj.getFieldValueString(i,"EVBC_CONF_QUARTER")),VendorListRetObj.getFieldValueString(i,"EVBC_VEND_COMMENTS"));
	}
%>	