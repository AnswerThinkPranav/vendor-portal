<%	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String type = request.getParameter("type");
	String qryStr="";
	if(!"AKUMARI".equals(Session.getUserId())
	{
		qryStr+=" AND ERH_CREATED_BY='"+Session.getUserId()+"'";
	}
	String rfqType = request.getParameter("rfqType"); 
	//if("".equals(type) || "null".equals(type) || type==null) type = "New";
	ezc.ezparam.ReturnObjFromRetrieve qcfRetObj = null;
	ezc.ezparam.ReturnObjFromRetrieve qcfRetNewRetObj = null;
	ezc.ezparam.ReturnObjFromRetrieve qcfRetALLObj = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"ERH_COLLETIVE_RFQ_NO","ERH_PR_NO","ERH_SOLD_TO","ERH_COMP_CODE","ERH_RFQ_DATE","ERH_CREATED_BY","ERH_VALID_UPTO","ERH_PR_ITEM_NO","NO_OF_VENDORS","FOR_BUYER_APPROVAL","IN_NEGOTIATION","IN_REQUOTE","ACCEPTED","REJECTED","STATUS"});	
	int qcfRetObjCnt = 0;
	int qcfRetALLObjCnt=0;
	ezc.ezparam.EzcParams qcfMainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager qcfMiscParams = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	if(type.equalsIgnoreCase("New"))
	{
	qcfTableRow.setQuery("select DISTINCT(ERH_COLLETIVE_RFQ_NO),ERH_PR_NO,ERH_PR_ITEM_NO,ERH_PLANT,ERH_SOLD_TO,ERH_COMP_CODE,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,ERH_PR_ITEM_NO,"+
				"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
				"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
				"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
				"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
				"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
				"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
				"from EZC_RFQ_HEADER WHERE ERH_STATUS NOT IN('S') AND ERH_EXT2 IN('"+rfqType+"')"+
				"AND ERH_COLLETIVE_RFQ_NO NOT IN (SELECT ERH_COLLETIVE_RFQ_NO FROM ezc_rfq_header WHERE ERH_STATUS IN ('S') AND ERH_EXT2 IN('"+rfqType+"'))"+
				qryStr+" group by ERH_COLLETIVE_RFQ_NO;");
	}
	else if(type.equalsIgnoreCase("Sub"))
	{
	qcfTableRow.setQuery("select ERH_COLLETIVE_RFQ_NO,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_PLANT, ERH_SOLD_TO,ERH_COMP_CODE,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,"+
				"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
				"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
				"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
				"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
				"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
				"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
				"from EZC_RFQ_HEADER WHERE ERH_STATUS IN ('S') AND ERH_EXT2 IN('"+rfqType+"')"+
				qryStr+"group by ERH_COLLETIVE_RFQ_NO;");	
	}
	else if(type.equalsIgnoreCase("WF"))
	{
	qcfTableRow.setQuery("select ERH_COLLETIVE_RFQ_NO,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_PLANT,ERH_SOLD_TO,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,"+
				"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
				"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
				"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
				"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
				"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
				"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
				"from EZC_RFQ_HEADER WHERE ERH_STATUS IN ('S') AND ERH_EXT2 IN('"+rfqType+"')"+
				"AND ERH_WF_STATUS IN ('SUBMITTED')"+
				//"AND ERH_CREATED_BY='"+Session.getUserId()+"'"+
				"group by ERH_COLLETIVE_RFQ_NO;");	
	}	
	else if(type.equalsIgnoreCase("ALL"))
	{
	qcfTableRow.setQuery("select ERH_COLLETIVE_RFQ_NO,ERH_PR_NO,ERH_PR_ITEM_NO,ERH_PLANT, ERH_SOLD_TO,ERH_COMP_CODE,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,"+
				"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
				"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
				"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
				"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
				"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
				"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
				"from EZC_RFQ_HEADER WHERE ERH_STATUS IN ('S','R') AND ERH_EXT2 IN('"+rfqType+"')"+
				qryStr+"group by ERH_COLLETIVE_RFQ_NO;");	
	}
	qcfTable.appendRow(qcfTableRow);
	qcfMainParams.setLocalStore("Y");
	qcfMainParams.setObject(qcfTable);
	Session.prepareParams(qcfMainParams);
	try{
		qcfRetObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMiscParams.ezGetMiscTransactions(qcfMainParams);
		
	}
	catch(Exception e){}	
	
	if(qcfRetObj!=null)
	{
		qcfRetObjCnt = qcfRetObj.getRowCount();
		ezc.ezcommon.EzLog4j.log("qcfRetObjCnt>>>"+qcfRetObjCnt,"I");
		
			
		
	}
	if(type.equalsIgnoreCase("ALL"))
	{
		qcfTableRow.setQuery("select DISTINCT(ERH_COLLETIVE_RFQ_NO),ERH_PR_NO, ERH_SOLD_TO,ERH_COMP_CODE,ERH_RFQ_DATE, ERH_CREATED_BY, ERH_VALID_UPTO,ERH_PR_ITEM_NO,"+
						"COUNT(ERH_SOLD_TO) as NO_OF_VENDORS, "+
						"COUNT(CASE WHEN ERH_STATUS = 'P' then 1 ELSE NULL END) as FOR_BUYER_APPROVAL, "+
						"COUNT(CASE WHEN ERH_STATUS = 'N' then 1 ELSE NULL END) as IN_NEGOTIATION, "+
						"COUNT(CASE WHEN ERH_STATUS = 'R' then 1 ELSE NULL END) as IN_REQUOTE, "+
						"COUNT(CASE WHEN ERH_STATUS IN('P','Y') then 1 ELSE NULL END) as ACCEPTED, "+
						"COUNT(CASE WHEN ERH_STATUS = 'X' then 1 ELSE NULL END) as REJECTED "+
						"from EZC_RFQ_HEADER WHERE ERH_STATUS NOT IN('S') AND ERH_EXT2 IN('"+rfqType+"')"+
					"group by ERH_COLLETIVE_RFQ_NO;");
		qcfTable.appendRow(qcfTableRow);
		qcfMainParams.setLocalStore("Y");
		qcfMainParams.setObject(qcfTable);
		Session.prepareParams(qcfMainParams);
		try{
			qcfRetNewRetObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMiscParams.ezGetMiscTransactions(qcfMainParams);
			ezc.ezcommon.EzLog4j.log("qcfRetNewObjCnt>>>"+qcfRetNewRetObj.getRowCount(),"I");
		}
		catch(Exception e){}
	}	
	 if(type.equalsIgnoreCase("ALL"))
	 {
	 	for(int j=0;j<qcfRetNewRetObj.getRowCount();j++)
	 	{
	 		String qcfNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_COLLETIVE_RFQ_NO");	  
			String prNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_PR_NO");  
			String prItemNo		= qcfRetNewRetObj.getFieldValueString(j, "ERH_PR_ITEM_NO");
			String compCode		= qcfRetNewRetObj.getFieldValueString(j, "ERH_COMP_CODE");
			String createdBy	= qcfRetNewRetObj.getFieldValueString(j, "ERH_CREATED_BY");	
			String createdOn 	= convertDateObjToString((Date)qcfRetNewRetObj.getFieldValue(j, "ERH_RFQ_DATE"));	
			String expiryDate 	= convertDateObjToString((Date)qcfRetNewRetObj.getFieldValue(j, "ERH_VALID_UPTO"));
			String noOfVendCnt	= qcfRetNewRetObj.getFieldValueString(j, "NO_OF_VENDORS");
			String forBuyerApprCnt	= qcfRetNewRetObj.getFieldValueString(j, "FOR_BUYER_APPROVAL");
			String inNegCnt		= qcfRetNewRetObj.getFieldValueString(j, "IN_NEGOTIATION");
			String inReqCnt		= qcfRetNewRetObj.getFieldValueString(j, "IN_REQUOTE");
			String accpCnt		= qcfRetNewRetObj.getFieldValueString(j, "ACCEPTED");
			String rejCnt		= qcfRetNewRetObj.getFieldValueString(j, "REJECTED"); 
	 		
	 		qcfRetALLObj.setFieldValue("ERH_COLLETIVE_RFQ_NO",qcfNo);
	 		qcfRetALLObj.setFieldValue("ERH_PR_NO",prNo);
	 		qcfRetALLObj.setFieldValue("ERH_PR_ITEM_NO",prItemNo);
	 		qcfRetALLObj.setFieldValue("ERH_COMP_CODE",compCode);
	 		qcfRetALLObj.setFieldValue("ERH_CREATED_BY",createdBy);
	 		qcfRetALLObj.setFieldValue("ERH_RFQ_DATE",createdOn);
	 		qcfRetALLObj.setFieldValue("ERH_VALID_UPTO",expiryDate);
			qcfRetALLObj.setFieldValue("NO_OF_VENDORS",noOfVendCnt);
			qcfRetALLObj.setFieldValue("FOR_BUYER_APPROVAL",forBuyerApprCnt);
			qcfRetALLObj.setFieldValue("IN_NEGOTIATION",inNegCnt);
	 		qcfRetALLObj.setFieldValue("IN_REQUOTE",inReqCnt);
	 		qcfRetALLObj.setFieldValue("ACCEPTED",accpCnt);
	 		qcfRetALLObj.setFieldValue("REJECTED",rejCnt);
	 		qcfRetALLObj.setFieldValue("STATUS","NEW");
	 	
	 		qcfRetALLObj.addRow();
	 	}
	 	for(int j=0;j<qcfRetObj.getRowCount();j++)
		{
			String qcfNo		= qcfRetObj.getFieldValueString(j, "ERH_COLLETIVE_RFQ_NO");	  
			String prNo		= qcfRetObj.getFieldValueString(j, "ERH_PR_NO");  
			String prItemNo		= qcfRetObj.getFieldValueString(j, "ERH_PR_ITEM_NO");
			String compCode		= qcfRetObj.getFieldValueString(j, "ERH_COMP_CODE");
			String createdBy	= qcfRetObj.getFieldValueString(j, "ERH_CREATED_BY");	
			String createdOn 	= convertDateObjToString((Date)qcfRetObj.getFieldValue(j, "ERH_RFQ_DATE"));	
			String expiryDate 	= convertDateObjToString((Date)qcfRetObj.getFieldValue(j, "ERH_VALID_UPTO"));
			String noOfVendCnt	= qcfRetObj.getFieldValueString(j, "NO_OF_VENDORS");
			String forBuyerApprCnt	= qcfRetObj.getFieldValueString(j, "FOR_BUYER_APPROVAL");
			String inNegCnt		= qcfRetObj.getFieldValueString(j, "IN_NEGOTIATION");
			String inReqCnt		= qcfRetObj.getFieldValueString(j, "IN_REQUOTE");
			String accpCnt		= qcfRetObj.getFieldValueString(j, "ACCEPTED");
			String rejCnt		= qcfRetObj.getFieldValueString(j, "REJECTED"); 

			qcfRetALLObj.setFieldValue("ERH_COLLETIVE_RFQ_NO",qcfNo);
			qcfRetALLObj.setFieldValue("ERH_PR_NO",prNo);
			qcfRetALLObj.setFieldValue("ERH_PR_ITEM_NO",prItemNo);
			qcfRetALLObj.setFieldValue("ERH_CREATED_BY",createdBy);
			qcfRetALLObj.setFieldValue("ERH_RFQ_DATE",createdOn);
			qcfRetALLObj.setFieldValue("ERH_VALID_UPTO",expiryDate);
			qcfRetALLObj.setFieldValue("NO_OF_VENDORS",noOfVendCnt);
			qcfRetALLObj.setFieldValue("FOR_BUYER_APPROVAL",forBuyerApprCnt);
			qcfRetALLObj.setFieldValue("IN_NEGOTIATION",inNegCnt);
			qcfRetALLObj.setFieldValue("IN_REQUOTE",inReqCnt);
			qcfRetALLObj.setFieldValue("ACCEPTED",accpCnt);
			qcfRetALLObj.setFieldValue("REJECTED",rejCnt);
			qcfRetALLObj.setFieldValue("STATUS","SUB");
			qcfRetALLObj.setFieldValue("ERH_COMP_CODE",compCode);

			qcfRetALLObj.addRow();
	 	}
	 }	
	 else if(type.equalsIgnoreCase("New"))qcfRetALLObj=qcfRetObj;
	 else if(type.equalsIgnoreCase("Sub"))qcfRetALLObj=qcfRetObj;
	 else if(type.equalsIgnoreCase("WF"))qcfRetALLObj=qcfRetObj;
	 if(qcfRetALLObj!=null)
	 {
	 		qcfRetALLObjCnt = qcfRetALLObj.getRowCount();
	 		
	 			
	 		
	}
	ezc.ezcommon.EzLog4j.log("qcfRetObj_NA>>>"+qcfRetObj,"I"); 	
%>