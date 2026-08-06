 <jsp:useBean id="VendTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
 <%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
 <%
 
 java.util.Hashtable docsHT = new  java.util.Hashtable();
 int uploadedDocsListCnt=0;
 ezc.ezparam.ReturnObjFromRetrieve uploadedDocsList=null;
 try
 {
 	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
 	ezc.vendortransactions.params.EzVendorParams vendorParams = new ezc.vendortransactions.params.EzVendorParams();
 	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
 	
 	keyParams.setKey("GET_UPLOADED_DOCS");
 	addMainParams.setLocalStore("Y");
 	
 	
 	vendorParams.setVendor(vendCode.trim());
 	vendorParams.setType("CAPA");
 	vendorParams.setSyskey("999111");
 	
 	
 	addMainParams.setObject(keyParams);	
 	addMainParams.setObject(vendorParams);
 	Session.prepareParams(addMainParams);
 
 	uploadedDocsList=(ReturnObjFromRetrieve)VendTransactionsManager.ezGetVendorTransactions(addMainParams);
	

 	if(uploadedDocsList!=null && uploadedDocsList.getRowCount()>0)
 	{	
 		uploadedDocsListCnt=uploadedDocsList.getRowCount();	
 		
 		for(int d=0;d<uploadedDocsListCnt;d++)
 			docsHT.put(uploadedDocsList.getFieldValueString(d,"OBJECTNO"),uploadedDocsList.getFieldValueString(d,"UPLOADNO"));
 		
 	}	 
 }
 catch(Exception e)
 {
 	out.println(":::EEEE:::"+e);
 }
 
 
%>	 