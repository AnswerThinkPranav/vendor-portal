<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%
				String creditno="";
				String vendor 			= checkNull((String)Session.getUserId());
				String soldTo			= checkNull((String)Session.getUserPreference("ERPSOLDTO"));
				ezc.ezparam.ReturnObjFromRetrieve retVendTransCreditObj=null;
				ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);
				
				ezc.vendortransactions.params.EzDebitCreditNotesParams ezDebitCreditParams1 = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
				ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyDebitParams1 = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
				keyDebitParams1.setKey("GET_DEBIT_CREDIT_NOTES");
				mainParams1.setLocalStore("Y");
				if("3".equals(userType))
				{
					ezDebitCreditParams1.setVendor(vendor+"') AND EDCN_DEBIT_NOTE IN ('"+doc+"");
				}
				else
				{
					ezDebitCreditParams1.setVendor(soldTo+"') AND EDCN_DEBIT_NOTE IN ('"+doc+"");
				}
				
					
				mainParams1.setObject(keyDebitParams1);
				mainParams1.setObject(ezDebitCreditParams1);
				Session.prepareParams(mainParams1);
				
				try{
					ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
					retVendTransCreditObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams1);
					
					ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::"+retVendTransCreditObj.toEzcString(),"I");
					
				}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}
			
				
				if(retVendTransCreditObj!=null &&  retVendTransCreditObj.getRowCount()>0)
				{
					creditno=checkNull(retVendTransCreditObj.getFieldValueString(0,"EDCN_CREDIT_NOTE"));
				}
				ezc.ezcommon.EzLog4j.log("creditno>test>>>>>>>"+creditno,"I"); 
%>				