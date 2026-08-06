<%!
		 
		public String getVendorName(ezc.session.EzSession Session,String soldTo)
		{
			String retStr = "";
			try
			{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve vendRet	  =	null; 
			miscTableRow.setQuery("SELECT B.ECA_NAME,B.ECA_COMPANY_NAME FROM EZC_CUSTOMER A,EZC_CUSTOMER_ADDR B WHERE A.EC_NO=B.ECA_NO AND A.EC_ERP_CUST_NO='"+soldTo+"' AND A.EC_PARTNER_FUNCTION='VN'");
			//miscTableRow.setQuery("select EVGD_NAME from EZC_VEND_GEN_DATA WHERE LPAD(TRIM(EVGD_VENDOR),10,0)='"+soldTo+"'");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
		
				vendRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				if(vendRet != null && vendRet.getRowCount()>0)
				{
					retStr = vendRet.getFieldValueString(0,"ECA_NAME");
				}
			}
			catch(Exception e)
			{
			}
			return retStr;
		}
		public String getVendorMail(ezc.session.EzSession Session,String soldTo)
		{
			String retStr = "";
			try
			{
				if(soldTo != null)
					soldTo = soldTo.replaceFirst("^0+(?!$)", "");
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				ezc.ezparam.ReturnObjFromRetrieve userRet	  =	null; 
				miscTableRow.setQuery("select DISTINCT EU_EMAIL from ezc_users where EU_ID IN('"+soldTo+"')");
				//miscTableRow.setQuery("select DISTINCT EU_EMAIL from ezc_users where EU_BUSINESS_PARTNER in (select EC_BUSINESS_PARTNER from EZC_CUSTOMER where EC_ERP_CUST_NO='"+soldTo+"' and EC_PARTNER_FUNCTION='VN')");
				//miscTableRow.setQuery("SELECT DISTINCT EU_EMAIL FROM EZC_USERS WHERE EU_ID IN (SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='SOLDTOPARTY' AND EUD_VALUE in ('"+soldTo+"'))");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);

				userRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int userRetCnt = 0;
				if(userRet != null)
				{
					userRetCnt = userRet.getRowCount();
				}
				for(int i=0;i<userRetCnt;i++)
				{
					if(i == 0)
						retStr += userRet.getFieldValueString(i,"EU_EMAIL");
					else
						retStr += ","+userRet.getFieldValueString(i,"EU_EMAIL");
				}
			}
			catch(Exception e)
			{
			}
			return retStr;
		}
		public String getTempVendorMail(ezc.session.EzSession Session,String soldTo)
		{
			String retStr = "";
			try
			{
				if(soldTo != null)
					soldTo = soldTo.replaceFirst("^0+(?!$)", "");
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				ezc.ezparam.ReturnObjFromRetrieve userRet	  =	null; 
				miscTableRow.setQuery("SELECT EU_EMAIL FROM EZC_USERS WHERE  EU_TYPE IN('3' ,'4') AND EU_ID='"+soldTo+"'");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);

				userRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int userRetCnt = 0;
				if(userRet != null && userRet.getRowCount()>0)
				{
					retStr = userRet.getFieldValueString(0,"EU_EMAIL");
				}	

			}
			catch(Exception e)
			{
			}
			return retStr;
		}		
		

		public boolean sendMail(ezc.session.EzSession Session,String toMail,String ccMail,String bccMail,String msgText,String msgSubject) throws Exception
		{
			ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();	
			mailParams.setGroupId("Ezc");
			mailParams.setTo(toMail);
			mailParams.setCC(ccMail);
			mailParams.setBCC(bccMail);
			mailParams.setMsgText(msgText);
			mailParams.setSubject(msgSubject);
			mailParams.setSendAttachments(false);
			mailParams.setContentType("text/html");
			ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
			if(Session.getUserId().startsWith("OLDDAT"))
				return true;
			else
				return myMail.ezSend(mailParams,Session);
		}

		public String getWFMails(ezc.session.EzSession Session,String purGrp,String roleStr,String key)
		{
			String retStr = "";
			try
			{
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		 		ezc.ezparam.ReturnObjFromRetrieve userRet = null; 
				if("ALL_USER".equals(key))
					miscTableRow.setQuery("SELECT DISTINCT EU_EMAIL FROM EZC_USERS WHERE EU_ID IN (SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='USERROLE' AND EUD_VALUE IN ("+roleStr+"))");
				else if("PLANT".equals(key))
					miscTableRow.setQuery("SELECT DISTINCT EU_EMAIL FROM EZC_USERS WHERE EU_ID IN (SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='PLANT' AND EUD_VALUE LIKE '%"+purGrp+"%' AND EUD_USER_ID IN(SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='USERROLE' AND EUD_VALUE IN ("+roleStr+")))");				
				else if("GET_EMAIL".equals(key))
					miscTableRow.setQuery("SELECT DISTINCT EU_EMAIL FROM EZC_USERS WHERE EU_ID IN (SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY  = '"+roleStr+"')");	
				else
					miscTableRow.setQuery("SELECT DISTINCT EU_EMAIL FROM EZC_USERS WHERE EU_ID IN (SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='PURGROUP' AND EUD_VALUE LIKE '%"+purGrp+"%' AND EUD_USER_ID IN(SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='USERROLE' AND EUD_VALUE IN ("+roleStr+")))");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				userRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int userRetCnt = 0;
				if(userRet != null)
				{
					userRetCnt = userRet.getRowCount();
				}
				for(int i=0;i<userRetCnt;i++)
				{
					if(i == 0)
						retStr += userRet.getFieldValueString(i,"EU_EMAIL");
					else
						retStr += ","+userRet.getFieldValueString(i,"EU_EMAIL");
				}
			}
			catch(Exception e)
			{
			}
			return retStr;
		}
		
		public String getRoundingDecVal(String valStr,int scale)
		{
			String retValue = "0";


			if(valStr!=null)
			{
				try{
					java.math.BigDecimal bdObj = new java.math.BigDecimal(valStr);
					bdObj = bdObj.setScale(scale);	
					retValue = bdObj.toString();
				}catch(Exception e){}	
			}

			return retValue;
		}
		
		public boolean getDocSaveFlag(ezc.session.EzSession Session,String docNo,String colName,String tabName)
		{
			boolean saveFailed = true;
			try
			{
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				ezc.ezparam.ReturnObjFromRetrieve retObj = null; 
				miscTableRow.setQuery("SELECT "+colName+" FROM "+tabName+ " WHERE "+colName+"='"+docNo+"'");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				retObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				
				if(retObj!=null && retObj.getRowCount()>0)
					saveFailed = false; 
				
			}
			catch(Exception e){}
			
			return saveFailed;
		}
		
		public boolean saveChangeLog(ezc.session.EzSession Session,String docId,String docType,String feild,String newVal,String oldVal,String changedBy)
		{
			boolean saveFailed = true;
			try
			{
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				miscTableRow.setQuery("INSERT INTO EZC_CHANGE_LOG(ECL_DOC_ID,ECL_DOC_TYPE,ECL_FEILD,ECL_NEW_VALUE,ECL_OLD_VALUE,ECL_CHANGED_BY,ECL_CHANGED_ON) VALUES('"+docId+"','"+docType+"','"+feild+"','"+newVal+"','"+oldVal+"','"+changedBy+"',NOW())");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				miscMgr.ezSaveMiscTransactions(mainParams);

			}
			catch(Exception e){}

			return true;
		}
		public ezc.ezparam.ReturnObjFromRetrieve getChangeLog(ezc.session.EzSession Session,String docId,String docType,String feild)
		{
			ezc.ezparam.ReturnObjFromRetrieve vendRet	  =	null; 
			try
			{
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				miscTableRow.setQuery("SELECT * FROM EZC_CHANGE_LOG WHERE ECL_DOC_ID='"+docId+"' AND ECL_DOC_TYPE='"+docType+"' AND ECL_FEILD='"+feild+"'");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				vendRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			}
			catch(Exception e)
			{
			}

			return vendRet;
		}	
		
		public void saveDocAudit(ezc.session.EzSession Session,String docNo,String docType,String comments)
		{
			ezc.ezparam.EzcParams historyMainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezpreprocurement.client.EzPreProcurementManager Manager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
			historyMainParams.setLocalStore("Y");
			ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFHistoryParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
			eziWFHistoryParams.setEwhDocId(docNo);
			historyMainParams.setObject(eziWFHistoryParams);
			Session.prepareParams(historyMainParams);
			ezc.ezparam.ReturnObjFromRetrieve wfMyRet = (ezc.ezparam.ReturnObjFromRetrieve)Manager.ezGetWFAuditTrailNo(historyMainParams);
			String historyNo = "";
			if(wfMyRet != null)
			{
				historyNo = wfMyRet.getFieldValueString(0,"AUDIT_NO");
				if(historyNo == "null")
					historyNo = "1";
			}
			else
				historyNo = "1";
			eziWFHistoryParams.setEwhAuditTrailNo(historyNo);
			eziWFHistoryParams.setEwhDocId(docNo);
			eziWFHistoryParams.setEwhType(docType);
			eziWFHistoryParams.setEwhSourceParticipant((String)Session.getUserId());
			eziWFHistoryParams.setEwhSourceParticipantType("");
			eziWFHistoryParams.setEwhDestParticipant("");
			eziWFHistoryParams.setEwhDestParticipantType("");
			ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();	
			String strDate = fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.DDMMYYYY);
			eziWFHistoryParams.setEwhComments(comments);
			historyMainParams.setObject(eziWFHistoryParams);
			Session.prepareParams(historyMainParams);
			Manager.ezAddWFAuditTrail(historyMainParams);
		}
		public void saveDocAudit(ezc.session.EzSession Session,String docNo,String docType,String comments,String srcType)
		{
			ezc.ezparam.EzcParams historyMainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezpreprocurement.client.EzPreProcurementManager Manager = new ezc.ezpreprocurement.client.EzPreProcurementManager();
			historyMainParams.setLocalStore("Y");
			ezc.ezpreprocurement.params.EziWFAuditTrailParams eziWFHistoryParams= new ezc.ezpreprocurement.params.EziWFAuditTrailParams();
			eziWFHistoryParams.setEwhDocId(docNo);
			historyMainParams.setObject(eziWFHistoryParams);
			Session.prepareParams(historyMainParams);
			ezc.ezparam.ReturnObjFromRetrieve wfMyRet = (ezc.ezparam.ReturnObjFromRetrieve)Manager.ezGetWFAuditTrailNo(historyMainParams);
			ezc.ezcommon.EzLog4j.log("audit_trail>>>>>>>::::::::::123","I"); 
			String historyNo = "";
			if(wfMyRet != null)
			{
				historyNo = wfMyRet.getFieldValueString(0,"AUDIT_NO");
				if(historyNo == "null")
					historyNo = "1";
			}
			else
				historyNo = "1";
			ezc.ezcommon.EzLog4j.log("audit_trail>>>>>>>"+historyNo,"I"); 
			eziWFHistoryParams.setEwhAuditTrailNo(historyNo);
			eziWFHistoryParams.setEwhDocId(docNo);
			eziWFHistoryParams.setEwhType(docType);
			eziWFHistoryParams.setEwhSourceParticipant((String)Session.getUserId());
			eziWFHistoryParams.setEwhSourceParticipantType(srcType);
			eziWFHistoryParams.setEwhDestParticipant("");
			eziWFHistoryParams.setEwhDestParticipantType("");
			ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();	
			String strDate = fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.DDMMYYYY);
			eziWFHistoryParams.setEwhComments(comments);
			historyMainParams.setObject(eziWFHistoryParams);
			Session.prepareParams(historyMainParams);
			Manager.ezAddWFAuditTrail(historyMainParams);
		}		
		
		public double round(double value, int places) {
		    if (places < 0) throw new IllegalArgumentException();
		
		    long factor = (long) Math.pow(10, places);
		    value = value * factor;
		    long tmp = Math.round(value);
		    return (double) tmp / factor;
		}
		public String getUserContact(ezc.session.EzSession Session,String user)
		{
			String retStr="";
			try
			{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve vendRet	  =	null; 
			miscTableRow.setQuery("SELECT * FROM EZC_USERS where EU_ID='"+user+"'");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);

				vendRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				if(vendRet != null && vendRet.getRowCount()>0)
				{
					retStr = vendRet.getFieldValueString(0,"EU_CONTACT_NO");
				}
				
			}
			catch(Exception e)
			{
			}
			return retStr;
		}	
		public String getUserMail(ezc.session.EzSession Session,String userID)
		{
			String retStr = "";
			try
			{
				if(userID != null)
					userID = userID.replaceFirst("^0+(?!$)", "");
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				ezc.ezparam.ReturnObjFromRetrieve userRet	  =	null; 
				miscTableRow.setQuery("SELECT EU_EMAIL FROM EZC_USERS WHERE  EU_ID='"+userID+"'");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);

				userRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int userRetCnt = 0;
				if(userRet != null && userRet.getRowCount()>0)
				{
					retStr = userRet.getFieldValueString(0,"EU_EMAIL");
				}	

			}
			catch(Exception e)
			{
			}
			return retStr;
		}
		public java.util.Hashtable<String,String> getPlants(ezc.session.EzSession Session)
		{
			java.util.Hashtable<String,String> htPlants = new java.util.Hashtable<String,String>();
			try
			{
				ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
				ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
				ezc.ezparam.ReturnObjFromRetrieve userRet = null; 
				miscTableRow.setQuery("SELECT EP_PLANT,EP_NAME1 FROM EZC_PLANTS");
				miscTable.appendRow(miscTableRow);
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscTable);
				Session.prepareParams(mainParams);
				userRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
				int userRetCnt = 0;
				if(userRet != null)
				{
					userRetCnt = userRet.getRowCount();
				}
				for(int i=0;i<userRetCnt;i++)
				{
					htPlants.put(userRet.getFieldValueString(i,"EP_PLANT"),userRet.getFieldValueString(i,"EP_NAME1"));
				}
			}
			catch(Exception e)
			{
			}
			return htPlants;
		}		
		
%>		
