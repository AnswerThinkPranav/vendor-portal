<%@ page import ="ezc.ezparam.*"%>
<%@ include file="../../../Includes/Lib/Address.jsp"%>
<%@ page import="ezc.ezvendor.csb.*" %>
<%@ page import ="ezc.client.EzcPurchaseUtilManager"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="VendorManager" class="ezc.ezvendor.client.EzVendorManager" scope="session"></jsp:useBean>
<%
	String companyName 	= "";
	String address1 	= "";
	String address2 	= "";
	String city		= "";
	String zipCode		= "";
	String country		= "";
	String noDataStatement	= "";
	String shpECANum	= "";
	String payECANum	= "";
	String telephone1	= "";
	String telephone2	= "";
	String email		= "";
	String remark		= "";
	String vendState	= "";
	
	String address	 	= "";
	String district 	= "";
	String houseNo	 	= ""; 
	
	boolean showAddressInfo = false;
	
	
	
	String vendorCode = (String)session.getValue("SOLDTO");
	String purchsArea = (String)session.getValue("SYSKEY");
	String compcode = compCodeArr[0];//request.getParameter("selCompCode") (String)session.getValue("COMPCODE");
	String purgrp = (String)session.getValue("PURGRP");

	ReturnObjFromRetrieve bizvendObj	= null;
	ReturnObjFromRetrieve addressObj	= null;	
	
	EzcVendorParams vendparams 	= new EzcVendorParams();
	EzVendorParams  vendnkparams 	= new EzVendorParams();
	vendnkparams.setLanguage("EN");
	vendnkparams.setVendor(vendorCode);
	vendnkparams.setSysKey(purchsArea);
	vendparams.setSysKey(purchsArea);
	vendnkparams.setCompCode(compcode);//company code added for mtr
	vendparams.setObject(vendnkparams);
	
	Session.prepareParams(vendparams);	
	bizvendObj = (ReturnObjFromRetrieve)VendorManager.getVendorsFromErp(vendparams);
	
	
	
	if(bizvendObj != null)
	{
		addressObj = (ReturnObjFromRetrieve)bizvendObj.getObject("VENDORADDRESSDETAILS");
		//out.println("addressObj=="+addressObj.toEzcString());
		
		if(addressObj != null)
		{
			showAddressInfo = true;
			companyName	= addressObj.getFieldValueString(0,"NAME1");	
			houseNo		= addressObj.getFieldValueString(0,"ADDRESS1");	
			address2	= addressObj.getFieldValueString(0,"DISTRICT");	
			city		= addressObj.getFieldValueString(0,"CITY");	
			zipCode		= addressObj.getFieldValueString(0,"POSTALCODE");	
			country		= addressObj.getFieldValueString(0,"COUNTRYKEY");
			telephone1	= addressObj.getFieldValueString(0,"TELEPHONE1");
			telephone2	= addressObj.getFieldValueString(0,"TELEPHONE2");
			email		= addressObj.getFieldValueString(0,"EMAIL");
			remark		= addressObj.getFieldValueString(0,"REMARK");
			vendState	= addressObj.getFieldValueString(0,"REGION");
			
			address		= addressObj.getFieldValueString(0,"STREET2");
			district	= addressObj.getFieldValueString(0,"DISTRICT");
			
			//out.println("addressObj:::"+addressObj.toEzcString());
			
			try{
			ezc.client.EzcPurchaseUtilManager ezUtil = new ezc.client.EzcPurchaseUtilManager(Session);
			String defPayTo 	= ezUtil.getUserDefPayTo();
			String defCatArea 	= ezUtil.getDefaultPurArea();
			if(defPayTo==null||"null".equals(defPayTo))
			defPayTo=vendorCode;
			ReturnObjFromRetrieve listOfPayTos = (ReturnObjFromRetrieve) ezUtil.getListOfPayTos(defCatArea);
			//ezc.ezcommon.EzLog4j.log("Before Exception in Get Info============>","I");
			
			int rowId = listOfPayTos.getRowId("EC_PARTNER_NO",defPayTo);
			
			if(listOfPayTos != null)
			{
				payECANum = listOfPayTos.getFieldValueString(rowId,EC_NO_X).trim();
			}	
			ReturnObjFromRetrieve listOfOrderTos = (ReturnObjFromRetrieve) ezUtil.getListOfOrdAddr(defCatArea);
			rowId = listOfOrderTos.getRowId("EC_PARTNER_NO",defPayTo);
			if(listOfOrderTos != null)
			{
				shpECANum = listOfOrderTos.getFieldValueString(rowId,EC_NO_X).trim();
			}
			}catch(Exception err)
			{
				showAddressInfo = false;
				noDataStatement	= "No Address Information available for the vendor "+vendorCode;
			}
		}
		else
		{
			showAddressInfo = false;
			noDataStatement	= "No Address Information available for the vendor "+vendorCode;
		}
	}
	else
	{
		showAddressInfo = false;
		noDataStatement	= "No Address Information available for the vendor "+vendorCode;
	}
%>

