<%@ page import="java.util.*" %>

<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%

// To Get Company codes :: start
		ezc.ezparam.ReturnObjFromRetrieve VendorCCRetObj=null;
		int c=0;
		String userid="";
		
		try
		{	String purchaseArea = (String)session.getValue("SYSKEY");
			ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendortransactions.params.EzVendorParams  vendorParams= new ezc.vendortransactions.params.EzVendorParams();
			ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
			keyParams.setKey("GET_INT_USER_EMAIL");
			addMainParams.setLocalStore("Y");
			
			
			vendorParams.setGroup("VENDOR");
			vendorParams.setSyskey(purchaseArea);
			
			
			addMainParams.setObject(keyParams);	
			addMainParams.setObject(vendorParams);
			Session.prepareParams(addMainParams);
		
			VendorCCRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
			//out.println("VendorCCRetObj=="+VendorCCRetObj.toEzcString());
			if(VendorCCRetObj!=null && VendorCCRetObj.getRowCount()>0)
			{
			
				c=VendorCCRetObj.getRowCount();
			
			
			}
			out.println("c="+c);
			for(int i=0;i<c;i++)
			
			{
			
			userid=userid+VendorCCRetObj.getFieldValueString(i,"EU_ID")+",";
			
			}
			
			out.println("userid="+userid);
		
		}
		catch(Exception e)
		{
			out.println(":::Exception while getting company codes:::"+e);
		}
		// To Get Company codes :: end
%>		
		