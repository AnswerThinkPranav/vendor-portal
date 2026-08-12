<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%!  
	public String checkNull(String value)   
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<%
	String type = request.getParameter("type"); 
	String rfqType = request.getParameter("rfqType"); 
	ezc.ezcommon.EzLog4j.log("rfqType11>>>>"+rfqType,"I");
	String soldTo1 	 = "";//(String) session.getValue("SOLDTO");
	String selVendorCode 	= request.getParameter("selVendorCode");

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	if(type.equalsIgnoreCase("ALL"))
		qryStr+="ERH_STATUS IN ('N','R','Y','S','X','P','Q')";
	else if(type.equalsIgnoreCase("New"))
		qryStr+="ERH_STATUS IN ('N') AND ERH_VALID_UPTO > NOW()";
	else if(type.equalsIgnoreCase("Req"))
		qryStr+="ERH_STATUS IN ('R')";
	else if(type.equalsIgnoreCase("Apr"))
		qryStr+="ERH_STATUS IN ('Y','S')";
	else if(type.equalsIgnoreCase("Rej"))
		qryStr+="ERH_STATUS IN ('X')";	
	else if(type.equalsIgnoreCase("List"))
		qryStr+="ERH_STATUS IN ('P') AND ERH_VALID_UPTO > NOW()";	
	else if(type.equalsIgnoreCase("Act"))
		qryStr+="ERH_STATUS IN ('P') AND ERH_VALID_UPTO > NOW()";
	else if(type.equalsIgnoreCase("Qry"))
		qryStr+="ERH_STATUS IN ('Q')";		
	
	if("2".equals(userType))
	{
		if(type.equalsIgnoreCase("List"))
			qryStr="ERH_STATUS IN ('R','N') AND ERH_VALID_UPTO > NOW()";
		else if(type.equalsIgnoreCase("Exp"))
			qryStr="ERH_STATUS IN ('P','N') AND ERH_VALID_UPTO < NOW()";
	}
	
	if("3".equals(userType) || "4".equals(userType)) 
	{
		if(type.equalsIgnoreCase("Exp"))
			qryStr="ERH_STATUS IN ('P','N') AND ERH_VALID_UPTO < NOW()";
			
		soldTo1 = Session.getUserId();
		try{
			soldTo1 = Long.parseLong(soldTo1)+"";
			soldTo1 = "0000000000"+soldTo1;
			soldTo1 = soldTo1.substring(soldTo1.length()-10,soldTo1.length());
		}catch(Exception e){}
	
			qryStr+=" AND ERH_SOLD_TO='"+soldTo1+"'";
	}	
	else if("2".equals(userType)) 
	{
		qryStr+=" AND ERH_EXT2='"+rfqType+"'";
		if(!"VIW".equals(userRole) && !"AKUMARI".equals(Session.getUserId()))
			qryStr+=" AND ERH_CREATED_BY='"+Session.getUserId()+"'";
		if(!(selVendorCode==null || selVendorCode=="" || "".equals(selVendorCode)) || "null".equals(selVendorCode))
			qryStr+=" AND ERH_SOLD_TO='"+selVendorCode+"'";
	}	
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND ERH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	//RFQ LIST QUERY
	qryRFQ="SELECT ERH_RFQ_NO,ERH_COLLETIVE_RFQ_NO,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_RFQ_DATE,ERH_EXT2,ERH_EXT3,ERH_SOLD_TO,ERH_PUR_GRP,ERH_VALID_UPTO,ERH_CREATED_BY,ERH_MODIFIED_BY,ERH_PR_TEXT,ERH_STATUS,ERH_SAVE_FLG FROM EZC_RFQ_HEADER WHERE "+qryStr+" ORDER BY ERH_RFQ_NO DESC";
	ezc.ezcommon.EzLog4j.log("** qryRFQ12"+qryRFQ,"I");	
	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	
	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	//ezc.ezcommon.EzLog4j.log("hdrXML>>>>"+hdrXML.toEzcString(),"I");
	int Count = hdrXML.getRowCount();
	ezc.ezparam.ReturnObjFromRetrieve rfqListObj	  =	null;
	qryRFQ="SELECT * FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS  WHERE ERH_RFQ_NO=ERD_RFQ_NO AND ERH_RFQ_NO IN(SELECT ERH_RFQ_NO FROM EZC_RFQ_HEADER WHERE "+qryStr+" ORDER BY ERH_RFQ_NO DESC)" ;
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");

	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);

	try
	{
		rfqListObj=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

	}
	catch(Exception e)
	{
		out.println("Exception in getting RFQ List>>>>>"+e);
	}	
	Hashtable rfqPrHT=new Hashtable();
	for(int r=0;r<rfqListObj.getRowCount();r++)
	{
	
		String rfqNO=rfqListObj.getFieldValueString(r,"ERD_RFQ_NO");
		String prnoHeader=checkNull(rfqListObj.getFieldValueString(r,"ERH_PR_NO"));
		String rfqPR=checkNull(rfqListObj.getFieldValueString(r,"ERD_EXT1"));
		String rfqDesc=checkNull(rfqListObj.getFieldValueString(r,"ERD_MATERIAL_DESC"));
		String prno="RFQ";
		if("RFQ".equals(prnoHeader))rfqPrHT.put(rfqNO,prnoHeader);
		else
		{
			if(!"".equals(rfqPR))prno=rfqPR.split("¥")[0];
			if(rfqPrHT.containsKey(rfqNO))
			{
				String val=(String)rfqPrHT.get(rfqNO);
				val=val+","+prno;
				rfqPrHT.put(rfqNO,val);
				
			}
			else
			rfqPrHT.put(rfqNO,prno);
		}	
			
	}
	
	//out.println("rfqPrHT"+rfqPrHT);
   
%>

