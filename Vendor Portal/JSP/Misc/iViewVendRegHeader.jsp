<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<%
	boolean vendSubmit = false;
	boolean vendReSubmit = false;
	boolean docSubmit = false;
	boolean docApprove = false; 
	boolean docPost = false;
	boolean isEditable = false;
	boolean isPPEditable = false;
	mainParams = new ezc.ezparam.EzcParams(false); 				
	
	miscTable = new ezc.misctransactions.params.EzMiscTable();
	miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve retVendHeader	  =	null;	 
	
	//***********************************GET ITEM DETAILS*****************************************************
	miscTableRow.setQuery("SELECT * from EZC_CUSTOMER_FORM_HEADER  WHERE ECFH_DOC_ID='"+docId+"'");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams); 
	try
	{
		retVendHeader=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		ezc.ezcommon.EzLog4j.log("after query of the reg page","I");
	}
	
	catch(Exception e)
	{
	}
	
	String compCode=retVendHeader.getFieldValueString(0,"ECFH_EXT1");
	String plant=retVendHeader.getFieldValueString(0,"ECFH_PLANT");
	String purOrg=retVendHeader.getFieldValueString(0,"ECFH_SALES_ORG");
	String dept=retVendHeader.getFieldValueString(0,"ECFH_EXT2");
	String docSts=retVendHeader.getFieldValueString(0,"ECFH_STATUS");
	String wfKey=retVendHeader.getFieldValueString(0,"ECFH_WF_KEY");
	String curLevel="";//retVendHeader.getFieldValueString(0,"ECFH_LEVEL");
	String hdrName = retVendHeader.getFieldValueString(0,"ECFH_CUST_NAME");
	String hdrPan = retVendHeader.getFieldValueString(0,"ECFH_PAN_NO"); 
	String venGrpVal = retVendHeader.getFieldValueString(0,"ECFH_VEN_GRP"); 
	String venWFPlant=retVendHeader.getFieldValueString(0,"ECFH_PLANT");
	String venWFCategory=retVendHeader.getFieldValueString(0,"ECFH_CATEGORY");
	String vendType=retVendHeader.getFieldValueString(0,"ECFH_VEN_TYPE");
	String accntPerName = retVendHeader.getFieldValueString(0,"ECFH_CUST_NAME");
	 
	int maxLevel = 0;
	if(wfKey != null && !"null".equals(wfKey) && !"".equals(wfKey))
	{
		mainParams = new ezc.ezparam.EzcParams(false); 				

		miscTable = new ezc.misctransactions.params.EzMiscTable();
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		ezc.ezparam.ReturnObjFromRetrieve retWFDet	  =	null;	 

		//***********************************GET ITEM DETAILS*****************************************************
		miscTableRow.setQuery("SELECT * from EZC_USER_WORKFLOW  WHERE EZWF_WORKFLOWKEY='"+wfKey+"'");
		ezc.ezcommon.EzLog4j.log("miscTableRow.getQuery()--EZC_USER_WORKFLOW__ iViewVendRegHeader.jsp>>>>>title>>>"+title,"I");
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams); 
		try
		{
			retWFDet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		}
		catch(Exception e)
		{
		}
		if(retWFDet != null)
		{
			//out.println(retWFDet.toEzcString()+":::ret");
			int retWFDetCnt = retWFDet.getRowCount();	
			for(int i=0;i<retWFDetCnt;i++)
			{
			
				if(Integer.parseInt(retWFDet.getFieldValueString(i,"EZWF_LEVEL")) > maxLevel)
					maxLevel=Integer.parseInt(retWFDet.getFieldValueString(i,"EZWF_LEVEL"));
				
				if(curLevel.equals(retWFDet.getFieldValueString(i,"EZWF_LEVEL")) && Session.getUserId().equals(retWFDet.getFieldValueString(i,"EZWF_USERID")))
				{
					docSubmit = true;
				}
			}
		}
		if(curLevel.equals(maxLevel+"") && docSubmit)
		{
			docApprove = true;
		}
	}
	if("4".equals(v_UserType) && "INITIATED".equals(docSts))
		vendSubmit = true;
	if("4".equals(v_UserType) && "RESUBMITTED".equals(docSts))
		vendReSubmit = true;		
	
	
	if("MDCELL".equals(Session.getUserId()) && "APPROVED".equals(docSts))
		docPost = true;
	/*
	out.println(docApprove+":::docApprove");
	out.println(vendSubmit+":::vendSubmit");
	out.println(docSubmit+":::docSubmit");
	out.println(curLevel+":::curLevel");
	out.println(wfKey+":::wfKey");
	*/
	if(vendSubmit || vendReSubmit)
		isEditable = true;
	if("PP".equals(userRole) || "BY".equals(userRole))
		isPPEditable = true;
		
	//WORKFLOW 
	
	session.putValue("QCF_WF_UPDATE","");
	
	String wfStatus="",wfTemplate="",wfNextPart="";
	int wfCurStep=0;
	boolean showApprove=false;
	boolean showSubmit=false;
	boolean showReject=false;
	boolean showCreate=false;
	ReturnObjFromRetrieve retWFDocDetails= ezMiscSelect(Session,"SELECT * FROM EZC_WF_DOC_HISTORY_HEADER WHERE EWDHH_DOC_ID='"+docId+"'");	
	
	if(retWFDocDetails != null && retWFDocDetails.getRowCount() > 0)
	{
		wfStatus=retWFDocDetails.getFieldValueString(0,"EWDHH_WF_STATUS");
		wfCurStep = Integer.parseInt(retWFDocDetails.getFieldValueString(0,"EWDHH_CURRENT_STEP"));
		wfTemplate = retWFDocDetails.getFieldValueString(0,"EWDHH_TEMPLATE_CODE");
		wfNextPart = retWFDocDetails.getFieldValueString(0,"EWDHH_NEXT_PARTICIPANT");
		ezc.ezcommon.EzLog4j.log("wfNextPart>>>>1>>>>"+wfNextPart,"I");
		
		if("SUBMITTED".equals(wfStatus) || "REJECTED".equals(wfStatus))
		{
			ezc.ezcommon.EzLog4j.log("Hello World>>>>1>>>>","I");
			if(workGrpVect != null && workGrpVect.contains(wfNextPart))
			{
				ezc.ezcommon.EzLog4j.log("Hello World>>>>2>>>>","I");
				ReturnObjFromRetrieve retWFDetails = getWFDetails(Session,wfTemplate,wfCurStep,wfNextPart);
				BigDecimal cmpVal=BigDecimal.valueOf((Long)retWFDetails.getFieldValue(0,"EWPC_QCF_RELEASE"));
				String cmpOp = retWFDetails.getFieldValueString(0,"EWPC_QCF_FLAG");
				out.println("cmpOp>>>"+cmpOp);
				out.println("cmpVal>>>"+cmpVal);
				if("LE".equals(cmpOp))
				{	
					ezc.ezcommon.EzLog4j.log("Hello World>>>>3>>>>","I");
					showSubmit=true;
					showReject=true;
				}
				if("GE".equals(cmpOp))
				{	
					showApprove=true;
					showReject=true;
				}				
			}
		}
		
		
	}
	else
	{
		showCreate=true;
	}	
%>
		
	