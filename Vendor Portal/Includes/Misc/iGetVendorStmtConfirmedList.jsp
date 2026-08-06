<%@ page import="java.util.*" %>
<jsp:useBean id="EzAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

String vendCode = request.getParameter("Vndr");
String selCompCode=request.getParameter("selCompCode");
String financialYear=request.getParameter("financialYear");
String quarte=request.getParameter("quarter");

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
	
	vendBalConfirmParams.setVendor(vendCode+"') AND EVBC_CONF_QUARTER IN ("+quarte+") AND EVBC_CONF_YEAR in ("+financialYear+") AND EVBC_COMPANY_CODE in('"+selCompCode+"");
	//out.println("msg=="+vendBalConfirmParams.getVendor());
	//ezShortAckParams_stat.setVendor(vendorNo+"')AND ESA_MAT_DOC='"+doc+"' AND ESA_PO_ITEM_NO IN ('"+poItemNum+"");
	addMainParams.setObject(keyParams);	
	addMainParams.setObject(vendBalConfirmParams);
	Session.prepareParams(addMainParams);

	VendorListRetObj=(ReturnObjFromRetrieve)EzAuditFindingManager.ezGetVendorTransactions(addMainParams);
	//out.println("VendorListRetObj=="+VendorListRetObj.toEzcString());
	if(VendorListRetObj!=null && VendorListRetObj.getRowCount()>0)
	{
	count=VendorListRetObj.getRowCount();
	//out.println("count=="+count);
	}

}
catch(Exception e)
{
	out.println(":::EEEE:::"+e);
}

//out.println(confimedQtrs);
//out.println(qtrComments);
%>	