<%--*************************************************************************************

       /* Copyright Notice ===================================================
	* This file contains proprietary information of The Hackett Group Ind Ltd.
	* Copying or reproduction without prior written approval is prohibited.
	* Copyright (c) 2005-2006 =====================================*/
		Author: Ramesh.S
		Team:   EzcSuite
		Date:   22/09/2005
*****************************************************************************************--%>

<%@ page import="ezc.client.*"%>
<%@ page import ="ezc.ezparam.*"%>
<%@ page import="ezc.ezutil.*,java.util.*"%>
<jsp:useBean id="EzGlobal" class="ezc.ezbasicutil.EzGlobal" scope="session" />
<%
	int Count = 0;
	
	String soldTos = (String)session.getValue("SOLDTOS");
	String syskey = (String)session.getValue("SYSKEY");
	String ext3Type = request.getParameter("type");
		ezc.ezcommon.EzLog4j.log("*****I FromDate ******"+request.getParameter("FromDate")+"*******I ToDate****"+request.getParameter("ToDate"),"I");

	String FDate = fromDate;//request.getParameter("FromDate");
	String TDate = toDate;//request.getParameter("ToDate");
	String vendorSearch = request.getParameter("venSearch");
	String qryStr="";
	
	
	
	

	ezc.ezcommon.EzLog4j.log("*****I FromDate ******"+FDate+"*******I ToDate****"+TDate,"I");
	
	String defPurGrp= (String)session.getValue("USERDEFPURGRP");
	String ext3Stat = "";
	String Status   = "";
	 String userType    = (String)session.getValue("UserType");

	if(vendorSearch==null||"null".equals(vendorSearch)||"".equals(vendorSearch))
		qryStr= "AND ERH_RFQ_DATE between TO_DATE('"+FDate+":12:00:05AM','DD/MM/YYYY:hh:mi:ssam') and TO_DATE('"+TDate+":11:59:59PM','DD/MM/YYYY:hh:mi:ssam"; 
	else
		qryStr=" AND ERH_SOLD_TO='"+vendorSearch.trim()+"' AND ERH_RFQ_DATE between TO_DATE('"+FDate+":12:00:05AM','DD/MM/YYYY:hh:mi:ssam') and TO_DATE('"+TDate+":11:59:59PM','DD/MM/YYYY:hh:mi:ssam";
	
	if("Invite".equals(ext3Type))
	{
		ext3Stat = "N";   		//ext3Stat for to distinguish Invited(Y)/Not Invited(N) 
		Status	 = "N";			//Status for Quoted(Y)/ReQuoted(R)/not Quoted(N) 
	}	
	else if("ToBeQuote".equals(ext3Type))
	{
		ext3Stat = "Y";
		Status	 = "N','R";
	}
	else if("Quoted".equals(ext3Type))
	{
		ext3Stat = "Y";
		Status	 = "Y";
	}
	else if("All".equals(ext3Type))
	{
		ext3Stat = "Y','N";
		Status	 = "N','Y','R";
	}
	else if("EditRfq".equals(ext3Type))
	{
		ext3Stat = "Y','N";
		Status	 = "N";
	}
	
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams ezcparams					     	= new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	
	if(!"3".equals(userType))  
	{
		ezirfqheaderparams.setExt2("ALL"); 
		ezirfqheaderparams.setPurchaseGrp(defPurGrp); 
	}
	else
	{
		ezirfqheaderparams.setSoldTo(soldTos);
		ezirfqheaderparams.setPurchaseGrp("ALL"); 
	}	
		
	//ezirfqheaderparams.setSoldTo(soldTos);
	ezirfqheaderparams.setStatus(Status);
	ezirfqheaderparams.setExt1("LIST");
	ezirfqheaderparams.setExt3(ext3Stat);
	ezirfqheaderparams.setDateStr(qryStr);
	ezirfqheaderparams.setSysKey(syskey + "')"+qryStr);
	
	//out.println(FDate+":::::::::::::::::::::"+ezirfqheaderparams.getDateStr());
	
	ezcparams.setObject(ezirfqheaderparams);
	ezcparams.setLocalStore("Y");
	Session.prepareParams(ezcparams);
	//System.out.println("CYUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
	ezc.ezparam.ReturnObjFromRetrieve myRetrfq = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);
	
	//ezc.ezcommon.EzLog4j.log("***** myRetrfqg******"+myRetrfq.toEzcString(),"I");
	
	
	if(myRetrfq != null)
	{
		java.util.Date currentDateObj =new java.util.Date();
		
		java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
            	java.util.Date validUPToDate =null;
            	String validUPToStr = "";
            	
            	int month = 0,date = 0,year = 0;
            	
		if("ToBeQuote".equals(ext3Type))
		{
			for(int i=0;i<myRetrfq.getRowCount();i++)
			{
				//validUPToDate=(java.util.Date)myRetrfq.getFieldValue(i,"VALID_UPTO");                                               
				validUPToStr = myRetrfq.getFieldValueString(i,"VALID_UPTO");
				
				date = Integer.parseInt(validUPToStr.split("-")[2]);
				month = Integer.parseInt(validUPToStr.split("-")[1])-1;
				year = Integer.parseInt(validUPToStr.split("-")[0])-1900;
				
				validUPToDate = new java.util.Date(year,month,date);
				
				//if(myChkDateObj.compareTo(validUPToDate)<=0)
				//{
					Count++;
				//}	
			}
		
			
		}
		else
			Count = myRetrfq.getRowCount();
	}
		
	//out.println("CountCountCount	"+Count);
	
	//out.println("myRetrfqmyRetrfqmyRetrfq		"+myRetrfq.toEzcString());	
	
%>
