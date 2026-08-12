<%@ page import = "ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO,ezc.ezparam.*,ezc.ezutil.*" %>
<jsp:useBean id="ezadminutilsmanager" class="ezc.ezadmin.ezadminutils.client.EzAdminUtilsManager" scope="session"></jsp:useBean>

<%
	ezc.ezpreprocurement.client.EzPreProcurementManager PreProcurementManager=new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziPreProcurementParams param=new ezc.ezpreprocurement.params.EziPreProcurementParams();
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	String qry="";	
	ezc.ezparam.ReturnObjFromRetrieve vendObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve sapvendRet	=  new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"EC_ERP_CUST_NO","ECA_NAME"});
	
 	ezc.ezcommon.EzLog4j.log("at iListSOS>>>>","I");
	
	String backChk=request.getParameter("backChk");
	String purchReq=request.getParameter("purchaseHidden");
	String qcfPrev=request.getParameter("qcfPrev");
	ezc.ezcommon.EzLog4j.log("::qcfPrev22:::"+qcfPrev,"I");
	String matNo="",plant="",delDate="";
	String qty = "",uom="",matDesc="",reqNo="",itmNo="",valType="";
	
	if(purchReq!=null)
	{
		java.util.StringTokenizer st =new java.util.StringTokenizer(purchReq,"$$");
		try
		{
			matNo	= st.nextToken();
			plant	= st.nextToken();
			delDate	= st.nextToken();
			qty 	= st.nextToken();
			uom 	= st.nextToken();
			matDesc = st.nextToken();
			//matDesc=matDesc.replace("\"","SS");
			reqNo   = st.nextToken();
			itmNo   = st.nextToken();
			valType = st.nextToken();
		}
		catch(Exception e)
		{
		}
		
		ezc.ezcommon.EzLog4j.log("purchReq>>>> "+purchReq,"I");
		ezc.ezcommon.EzLog4j.log("matNo "+matNo,"I");
		ezc.ezcommon.EzLog4j.log("plant "+plant,"I");
		ezc.ezcommon.EzLog4j.log("delDate>>>> "+delDate,"I");
		ezc.ezcommon.EzLog4j.log("qty "+qty,"I");
		ezc.ezcommon.EzLog4j.log("uom "+uom,"I");
		ezc.ezcommon.EzLog4j.log("matDesc "+matDesc,"I");
		ezc.ezcommon.EzLog4j.log("reqNo "+reqNo,"I");
		ezc.ezcommon.EzLog4j.log("itmNo "+itmNo,"I");
		ezc.ezcommon.EzLog4j.log("valType "+valType,"I");

		if(delDate!= null && !"null".equals(delDate) && !"".equals(delDate))
			delDate = delDate.substring(0,2)+"/"+delDate.substring(3,5)+"/"+delDate.substring(6,10);
		ezc.ezcommon.EzLog4j.log("delDate "+delDate,"I");
	}
	if(!"null".equals(qcfPrev) && qcfPrev!=null && !"".equals(qcfPrev) && qcfPrev!="") 
	{
		plant=request.getParameter("plant");
		valType=request.getParameter("purGrp");
		qty=request.getParameter("qty");
		ezc.ezcommon.EzLog4j.log("plant with qcfprev>>>> "+plant,"I");
	}	
		
%>
