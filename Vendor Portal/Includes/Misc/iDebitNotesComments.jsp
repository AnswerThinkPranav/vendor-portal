
<%
		
		/***********For Getting comments of Debit Note***********************/
		ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		int retVendTransCnt=0;
		ezc.vendortransactions.params.EzDebitCreditNotesParams ezDebitCreditParams = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
		ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyDebitParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
		keyDebitParams.setKey("GET_DEBIT_CREDIT_NOTES");
		mainParams.setLocalStore("Y");
		if("3".equals(userType))
		{
			ezDebitCreditParams.setVendor(checkNull((String)Session.getUserId())+"')AND EDCN_DEBIT_NOTE IN ('"+doc+"");
		}
		else if(!"3".equals(userType))
		{
			ezDebitCreditParams.setVendor(soldTo+"')AND EDCN_DEBIT_NOTE IN ('"+doc+"");
		}


		mainParams.setObject(keyDebitParams);
		mainParams.setObject(ezDebitCreditParams);
		Session.prepareParams(mainParams);

		try{
			ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
			retVendTransObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams);

			ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::"+retVendTransObj.toEzcString(),"I");

		}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}

		String comments="";
		if(retVendTransObj!=null && retVendTransObj.getRowCount()>0)
		{
			 

				comments=retVendTransObj.getFieldValueString(0,"EDCN_VEND_COMMENTS");
			   
		}
%>	 	 		