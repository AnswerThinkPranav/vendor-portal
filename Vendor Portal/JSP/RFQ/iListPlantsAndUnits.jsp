<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%
	
	String selIndex   = request.getParameter("selIndex");
	String matNo = request.getParameter("chk");	
	ezc.ezbasicutil.EzStringTokenizer EzMatToken = new ezc.ezbasicutil.EzStringTokenizer(matNo,"##");
	java.util.Vector MatTokens = EzMatToken.getTokens();
	
	String material = (String)MatTokens.elementAt(0);

	if(material!=null)
		material = material.trim();
	//String addZrs = "000000000000000000"+material;
	//material = addZrs.substring(addZrs.length()-18,addZrs.length());

	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(true);
	ezc.ezpreprocurement.client.EzPreProcurementManager PreProcurementManager=new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziGenericFMParams param=new ezc.ezpreprocurement.params.EziGenericFMParams();
	param.setObjectId("MPU");
	param.setInput1("M");
	param.setInput2(material);	
	
	mainParams.setObject(param);
	Session.prepareParams(mainParams);
	
	System.out.println("materialmaterialmaterial>>>>>>>"+material);
	
	ezc.ezparam.ReturnObjFromRetrieve retObj=(ezc.ezparam.ReturnObjFromRetrieve)PreProcurementManager.ezCallGenericFM(mainParams);
	
	ezc.ezparam.ReturnObjFromRetrieve Uoms	  = (ezc.ezparam.ReturnObjFromRetrieve)retObj.getFieldValue("UOMS");
	ezc.ezparam.ReturnObjFromRetrieve Plants  = (ezc.ezparam.ReturnObjFromRetrieve)retObj.getFieldValue("PLANTS");
	
	int uomCount 	=0;
	int plantsCount =0;
	
	if(Uoms!=null){
		uomCount = Uoms.getRowCount();
		Uoms.toEzcString();
	}	
		
	if(Plants!=null){
		plantsCount = Plants.getRowCount();
		Plants.toEzcString();
	}	
%>

<%--
	Uoms.toEzcString();
	Plants.toEzcString();

 --------------- Row 0 ---------------------
05/10/02 15:22:48 0 :: 0 Field Name : UOMS ----> Field Value : KG
05/10/02 15:22:48 0 :: 1 Field Name : DESCRIPTION ----> Field Value : kg
05/10/02 15:22:48 
 --------------- End Of Row 0 --------------
05/10/02 15:22:48  In EzcString Row Count is 1
05/10/02 15:22:48 
 --------------- Row 0 ---------------------
05/10/02 15:22:48 0 :: 0 Field Name : MATNR ----> Field Value : 000000000062001176
05/10/02 15:22:48 0 :: 1 Field Name : PLANTS ----> Field Value : 1010
05/10/02 15:22:48 
 --------------- End Of Row 0 --------------
--%>