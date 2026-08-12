<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />

<%	
 	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
 	
 	logs.setUserId("323306");
 	logs.setPassWd("cfl@2017");
 	logs.setConnGroup("200");
 	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);

	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	
	ReturnObjFromRetrieve    qcfDetailsRet 	= null;
	ReturnObjFromRetrieve rfqHeaderRet 	= null;
	ReturnObjFromRetrieve rfqDetailsRet 	= null;
	ReturnObjFromRetrieve rfqConditionsRet 	= null;
	
	int qcfDetailsRetCnt 	= 0;
	int rfqHeaderRetCnt 	= 0;
	int rfqDetailsRetCnt 	= 0;
	int rfqConditionsRetCnt = 0;
	
	
	ezc.ezpreprocurement.params.EziRFQHeaderParams  inputParams = new ezc.ezpreprocurement.params.EziRFQHeaderParams();

	inputParams.setCollectiveRFQNo("RM15-1561");
	inputParams.setStatus("N");
	inputParams.setExt1("CR");

	ezparams.setLocalStore("Y");
	ezparams.setObject(inputParams);
	Session.prepareParams(ezparams);
	
	try{
		qcfDetailsRet = (ReturnObjFromRetrieve)rfqManager.ezGetRFQList(ezparams);
	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Error while getting QCF Details :::::::::"+e,"E");
	}
	
	/*rfqHeaderRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQHeader();
	rfqDetailsRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQDetails();
	rfqConditionsRet 	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQConditions();

	if(rfqHeaderRet!=null)
		rfqHeaderRetCnt    = rfqHeaderRet.getRowCount();
	if(rfqDetailsRet!=null)
		rfqDetailsRetCnt   = rfqDetailsRet.getRowCount();
	if(rfqConditionsRet!=null)
		rfqConditionsRetCnt= rfqConditionsRet.getRowCount();

	out.println("<Br>::::::::::::::::"+rfqHeaderRetCnt);	
	out.println("<Br>::::::::::::::::"+rfqDetailsRetCnt);	
	out.println("<Br>::::::::::::::::"+rfqConditionsRetCnt);*/

	out.println("<Br>::::::::::::::::"+qcfDetailsRet.toEzcString());
%>