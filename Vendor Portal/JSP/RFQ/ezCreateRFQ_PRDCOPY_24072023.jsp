<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="java.util.*,java.nio.file.*,java.io.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>  
<%@ include file="../Misc/ezGetJGLVendorsList.jsp"%>   
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 


<% String selVendorCode="";%>

<%

	ArrayList<String> qcfPrQueries=new ArrayList<String>();
	Hashtable<String,String> htPRRFQItem=new Hashtable<String,String>();
	String logonSite = (String)session.getValue("SITE");
	session.setAttribute("RFQ_GENERATED","N");
	
	//out.println("::::::isRFQCreated:::::"+session.getAttribute("RFQ_GENERATED"));

	String selectedPRs[] = request.getParameterValues("purchReq");	
	String clubbedPRsStr = "";
	int selectedPRsCnt = 0;
	String prDetails[] = request.getParameterValues("prDetails");	
	
	if(selectedPRs!=null)
		selectedPRsCnt = selectedPRs.length;
	
	//ezc.ezcommon.EzLog4j.log("selectedPRsCnt>>>>>>>>>>>>>>>>"+selectedPRsCnt,"I"); 
	//ezc.ezcommon.EzLog4j.log("selectedPRs in Create::::::::"+selectedPRs[0],"I"); 
	//ezc.ezcommon.EzLog4j.log("selectedPRs in Create::::::::"+selectedPRs[1],"I"); 
	
	String flag= request.getParameter("flag");
	String qcfPrev= request.getParameter("qcfPrev");
	String[]   prTemp    = new String[selectedPRsCnt];
	String[]   prNo    = new String[selectedPRsCnt];
	String[]   matNo  = new String[selectedPRsCnt];
	String[]   prItem  = new String[selectedPRsCnt];
	String[]   plant = new String[selectedPRsCnt];
	String[]   prUom = new String[selectedPRsCnt];
	String[]   qty = new String[selectedPRsCnt];
	String[]   matDes = new String[selectedPRsCnt];
	String[]   deldt = new String[selectedPRsCnt];
	String[]   refDeldt = new String[selectedPRsCnt];
	String[]   itmTextArr = new String[selectedPRsCnt];
	String[]   poTextArr = new String[selectedPRsCnt];
	String[]   prTypeArr = new String[selectedPRsCnt];
	String[]   prPurGrp  = new String[selectedPRsCnt];
	String[]   docType = new String[selectedPRsCnt];
	String[]   accCat = new String[selectedPRsCnt];
	String[]   itemCat = new String[selectedPRsCnt];
	String[]   pckgNo = new String[selectedPRsCnt];
	String[]   currency = new String[selectedPRsCnt];
	String[]   matGrp = new String[selectedPRsCnt];
	String[]   prCreatedBy = new String[selectedPRsCnt];
	String[]   perQty = new String[selectedPRsCnt];
	String[]   remarksArr = new String[selectedPRsCnt];
	
	
	
	
	ezc.ezcommon.EzLog4j.log("selectedPRs in Create>>>>>>>>>>>>"+selectedPRs[0],"I"); 
	//ezc.ezcommon.EzLog4j.log("selectedPRs in Create>>>>>>>>>>>>"+selectedPRs[1],"I"); 
	
	ezc.ezparam.ReturnObjFromRetrieve sesServObj= (ezc.ezparam.ReturnObjFromRetrieve)session.getValue("SERVOBJ");
	//ezc.ezcommon.EzLog4j.log("sesServObj:::::::::::::::"+sesServObj.toEzcString(),"I");

	int retServCount=0;
	if(sesServObj!=null)
		retServCount=sesServObj.getRowCount();			
	
	for(int p=0;p<selectedPRsCnt;p++)
	{
	
		
		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(selectedPRs[p],"$$");
		java.util.Vector Tokens = EzToken.getTokens();
		String delDTEdit=request.getParameter("matDelDate"+p);
		String refDate=request.getParameter("refDelDate"+p);
		String itmtext=request.getParameter("itmText"+p);
		String poText=request.getParameter("poText"+p);
		ezc.ezcommon.EzLog4j.log(" delDTEdit::::::::"+p+">>>>"+delDTEdit,"I");	
		delDTEdit=delDTEdit.replaceAll("/",".");
		ezc.ezcommon.EzLog4j.log(" delDTEdit::::::::"+p+">>>>"+delDTEdit,"I");	
		refDate=refDate.replaceAll("/",".");
		ezc.ezcommon.EzLog4j.log(" refDate::::::::"+p+">>>>"+refDate,"I");
		String remarks=request.getParameter("remarks"+p);
		ezc.ezcommon.EzLog4j.log(" remarks::::::::"+p+">>>>"+remarks,"I");
		try
		{
			 prTemp[p]	= (String)Tokens.elementAt(6);	
			 prNo[p]	= prTemp[p].replace("$","");	
			 matNo[p]	= (String)Tokens.elementAt(0);	
			 prItem[p]	= (String)Tokens.elementAt(7);	
			 plant[p]	= (String)Tokens.elementAt(1);	
			 deldt[p]	=  (String)delDTEdit;//(String)Tokens.elementAt(2);
			 refDeldt[p]	=  (String)refDate;//(String)Tokens.elementAt(2);
			 qty[p]		= (String)Tokens.elementAt(3);	
			 prUom[p]	= (String)Tokens.elementAt(4);
			 matDes[p]	= (String)Tokens.elementAt(5);
			 prTypeArr[p]	= (String)Tokens.elementAt(12);	
			 accCat[p]	= (String)Tokens.elementAt(13);
			 itemCat[p]	= (String)Tokens.elementAt(14);
			 pckgNo[p]	= (String)Tokens.elementAt(15);	
			 currency[p]	= (String)Tokens.elementAt(16);	
			 matGrp[p]	= (String)Tokens.elementAt(17);
			 prCreatedBy[p]	= (String)Tokens.elementAt(18);
			 
			 
			 ezc.ezcommon.EzLog4j.log(" accCat[p]::::::::"+p+">>>>"+accCat[p],"I");	
			 ezc.ezcommon.EzLog4j.log(" itemCat[p]::::::::"+p+">>>>"+itemCat[p],"I");	
			 ezc.ezcommon.EzLog4j.log(" matGrp[p]::::::::"+p+">>>>"+matGrp[p],"I");	
			 ezc.ezcommon.EzLog4j.log(" currency in split::::::::"+p+">>>>"+matGrp[p],"I");
			 
			 itmTextArr[p]=itmtext;
			 poTextArr[p]=poText;
			 remarksArr[p]	= remarks;
			 
			ezc.ezcommon.EzLog4j.log(" deldt[p]::::::::"+p+">>>>"+deldt[p],"I");	
			if(p==0)
			{
				clubbedPRsStr = prNo[p]+"¥"+prItem[p]+"¥"+matNo[p]+"¥"+plant[p]+"¥"+qty[p];
			}
			else
			{
				clubbedPRsStr = clubbedPRsStr+"$"+prNo[p]+"¥"+prItem[p]+"¥"+matNo[p]+"¥"+plant[p]+"¥"+qty[p];
			}
			
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception in Create RFQ with PR>>>>>>>>>>>>"+e,"I"); 
		}	
	}
	ezc.ezcommon.EzLog4j.log("selectedPRs in Create$$$$$$$$$$$$$$$$"+selectedPRs[0],"I"); 
	

	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	
	String collNo		= request.getParameter("collNo");
	String currSysKey 	= (String)session.getValue("SYSKEY");
	String qtnEndDate 	= request.getParameter("qtnEndDate");
	String qtnEndTime 	= request.getParameter("qtnEndTime");
	String rfqPmntTms 	= checkNull(request.getParameter("PaymentTerms"));
	String rfqIncoTms1 	= checkNull(request.getParameter("IncoTerms"));	
	String material 	= request.getParameter("material");
	String delivDate 	= request.getParameter("delivDate");
	String matDesc 		= request.getParameter("matDesc");
	String itmText 		= request.getParameter("itmText");
	String uom 		= request.getParameter("uom");
	String prPlant 		= plant[0];//request.getParameter("plant");
	String prDocType 	= prTypeArr[0];
	String prMatNo		= matNo[0];
	String prItemCat	= itemCat[0];
	String prMatType	= "";
	String prCategory	= "";
	
	
	
	String Comments		= request.getParameter("comment");
	String tmpPrno		= request.getParameter("reqNo");
	String headPrno		= tmpPrno.replace("$","");
	String prItmNo		= request.getParameter("prItmNo");
	String selectedVendors[]= request.getParameterValues("selChk");
	String templateCode 	= (String)session.getValue("TEMPLATE");
	String purchReq		= request.getParameter("purchReq1");
	//String purchReq[]	=request.getParameterValues("purchReq");
	String valType		= request.getParameter("valuationType");
	String rfqType		= request.getParameter("rfqType");
	//String ldClause 	= checkNull(request.getParameter("ldClause"));	
	
	ezc.ezcommon.EzLog4j.log("uom>>>>"+uom,"I");
	ezc.ezcommon.EzLog4j.log("headPrno>>>>"+headPrno,"I");
	ezc.ezcommon.EzLog4j.log("rfqType>>>>"+rfqType,"I");
	ezc.ezcommon.EzLog4j.log("prPlant>>>>"+prPlant,"I");
	
	ezc.ezcommon.EzLog4j.log("prDocType>>>>"+prDocType,"I");
	ezc.ezcommon.EzLog4j.log("prMatNo>>>>"+prMatNo,"I");
	
	try
	{
		prMatNo ="000000000000000000"+prMatNo;
		prMatNo =prMatNo.substring(prMatNo.length()-18);
	}
	catch(Exception e)
	{
		prMatNo= prMatNo;
	}
	
	
	//TO Fetch Materail Type
	String [] outputFeilds =new String[]{"MTART"};
	String [] queryValues =new String[]{" MATNR EQ '"+prMatNo+"'"}; 
	
	ReturnObjFromRetrieve retMat = readRFCTable(logonSite,"MARA",outputFeilds,queryValues);
	//ezc.ezcommon.EzLog4j.log("retMatType"+retMat.getFieldValueString(0,"MTAT"),"I");	
	
	if(retMat!= null)
		prMatType =  checkNull(retMat.getFieldValueString(0,"MTART"));
	ezc.ezcommon.EzLog4j.log("prMatType"+prMatType,"I");	
	ezc.ezcommon.EzLog4j.log("prDocType"+prDocType,"I");	
	ezc.ezcommon.EzLog4j.log("prItemCat"+prItemCat,"I");	
	
	/*
	if("ZH07".equals(prDocType))
		prCategory = "EXT_MFG";
	else if	("ZH08".equals(prDocType))
		prCategory = "LOG";
	else if(("ZRAW".equals(prMatType)|| "ZSFP".equals(prMatType)|| "ZPPM".equals(prMatType)|| "ZTPM".equals(prMatType)  || "ZSPM".equals(prMatType))  && !"ZH08".equals(prDocType) && !"ZH07".equals(prDocType))
		prCategory = "RM_PM";
	else if(prMatType!="ZRAW" && prMatType!="ZSFP" && prMatType!="ZPPM" && prMatType!="ZTPM" && prMatType!="ZSPM" && prDocType!="ZH08" && prDocType!="ZH07")
		prCategory = "ENG_SER";
	else
		prCategory = "NA";
	*/
	/*
	if("ZH07".equals(prDocType))
		prCategory = "EXT_MFG";
	else if	("ZH08".equals(prDocType))
		prCategory = "LOG";
	else if(("ZRAW".equals(prMatType)|| "ZSFP".equals(prMatType)|| "ZPPM".equals(prMatType)|| "ZTPM".equals(prMatType)  || "ZSPM".equals(prMatType)) && ("NB".equals(prDocType)||"ZH01".equals(prDocType)))
		prCategory = "RM_PM";
	else 
		prCategory = "ENG_SER";
		
	*/
	prCategory = getWFCategory(Session,request.getParameter("purGroup"),prPlant,prDocType,prMatType);
	String msgText 		= "purchReq:"+purchReq+"***currSysKey:"+currSysKey+"***qtnEndDate:"+qtnEndDate+"***material:"+material+"***delivDate:"+delivDate+"***plant:"+plant+"***headPrno:"+headPrno;
	String msgSubject     	= "PRODUCTION>>RFQ ERROR";
	
	//if(Comments==null || "null".equals(Comments) || "".equals(Comments))
	// Comments="OK1";
	
	int vendorsCount =0;
	
	if(selectedVendors!=null)
	{
		vendorsCount	= selectedVendors.length;	
	}

	String[]   vendor    = new String[vendorsCount];
	String[]   quantity  = new String[vendorsCount];
	String[]   vendType  = new String[vendorsCount];
	String[]   agentCode = new String[vendorsCount];
	
	
	for(int i=0;i<vendorsCount;i++)
	{
		
		

		java.util.StringTokenizer vendSt =new java.util.StringTokenizer(selectedVendors[i],"#");
		try
		{
			vendSt.nextToken();
			vendor[i]	= vendSt.nextToken();
			quantity[i]	= vendSt.nextToken();
			vendType[i]	= vendSt.nextToken();
			
		}		
		catch(Exception e)
		{
		}
		if("N".equals(vendType[i]))
		{
			java.util.StringTokenizer typeSt =new java.util.StringTokenizer(vendor[i],"$");
			try
			{
				vendor[i]	= typeSt.nextToken();
				agentCode [i]	= typeSt.nextToken();
				if(agentCode[i]==null)
					agentCode [i]="";
			}
			catch(Exception e)
			{
			}			
		}
	}
			
	
	//String endDate = qtnEndDate;//dateConvertion(qtnEndDate,(String)session.getValue("DATEFORMAT"));
	String endDate = dateConvertion(qtnEndDate,(String)session.getValue("DATEFORMAT"));
	//out.println("==endDate="+endDate);
	String endDateDisp = endDate.substring(0,2)+"."+endDate.substring(3,5)+"."+endDate.substring(6,10);
	
	
	int mm=Integer.parseInt(endDate.substring(3,5));
	int dd=Integer.parseInt(endDate.substring(0,2));
	int yy=Integer.parseInt(endDate.substring(6,10));

	GregorianCalendar g=new GregorianCalendar(yy,mm-1,dd);
	Date eDate= g.getTime();
	
	
	endDate = endDate.substring(3,5)+"/"+endDate.substring(0,2)+"/"+endDate.substring(6,10);
	Date endDateFinal = new Date(endDate);
	
	
	String endDateDB = endDate.substring(6,10)+"-"+endDate.substring(0,2)+"-"+endDate.substring(3,5)+" "+qtnEndTime;
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy-MM-dd ");
	
	Date qdt = new Date();
	String qtnDt = sdf.format(qdt);
	
	String today 	= qtnDt;//formatDate.getStringFromDate(new Date(),"/",formatDate.DDMMYYYY);
	
	
	
	
	
	
	GregorianCalendar escG=new GregorianCalendar(yy,mm-1,dd);
	Date eDateEsc=escG.getTime();
	Date currentDateX = new Date();
	Date currentDate = new Date(currentDateX.getYear(),currentDateX.getMonth(),currentDateX.getDate(),0,0,0);
	long durationVal = (eDateEsc.getTime()-currentDate.getTime());
	int duration =(int) (durationVal/(24*60*60*1000));
	duration = duration + 1;
	
	ezc.ezparam.ReturnObjFromRetrieve rfqRet = null;
	
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	
	EzcParams 		ezcparams		= new ezc.ezparam.EzcParams(false);
	EzcParams 		ezcparamsSAP		= new ezc.ezparam.EzcParams(false);	
	EziRFQHeaderParams 	ezirfqheaderparams    	= new EziRFQHeaderParams();
	EziRFQHeaderParams	headerParams		= new EziRFQHeaderParams();
	EziRFQHeaderTable 	ezirfqheadertable 	= new EziRFQHeaderTable();
	EziRFQHeaderTableRow 	ezirfqheadertablerow   	= null;
	EziRFQDetailsTable 	ezirfqdetailstable 	= new EziRFQDetailsTable();
	EziRFQDetailsTableRow 	ezirfqdetailstablerow 	= null;	
	EziRFQItemTable     	itemTable       	= new EziRFQItemTable();
	EziRFQItemTableRow	itemTableRow		= null;
	EziRFQItemQtyTable  	qtyTable		= new EziRFQItemQtyTable();
	EziRFQItemQtyTableRow 	qtyTableRow		= null;
	EziRFQVendAddrTable 	vendAddr		= new EziRFQVendAddrTable();
	EziRFQVendAddrTableRow 	vendAddrRow  		= null;
	EziRFQPRItemsTable  	prItemTable		= new EziRFQPRItemsTable();
	EziRFQPRItemsTableRow 	prItemTableRow		= null;		
  	EziAuditTrailTable 	eziaudittable = new EziAuditTrailTable();
  	EziAuditTrailTableRow 	eziaudittablerow 	= null;	

	
	String purchOrg    = request.getParameter("purOrg");  //(String)Session.getUserPreference("PURORG"); 
	String purGrp  	   = request.getParameter("purGroup");  //"BY1";//(String)Session.getUserPreference("PURGROUP");
	String compCode	   = request.getParameter("compCode");
	ezc.ezcommon.EzLog4j.log("compCode>>>>"+compCode,"I");
	
	String defCollRfq  = (String)Session.getUserPreference("COLLECTIVERFQ");
	Hashtable<String,String> plantHT = getPlants(Session); 	
	boolean messflg	   = false;
	String delivDateDB ="";
	//String rfq="";
	String vendfrmsap="";
	
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;

	String retMessage = "";
	String retWarnMessage = "";	
	boolean isError = false;
	int rfqCount =0;
	
	//QCF NUMBER
	
	ezc.ezcommon.EzLog4j.log("collNo::::::::"+collNo,"I");
	ReturnObjFromRetrieve getMaxDocId = null;

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String docIdQry = "SELECT MAX(SUBSTRING(ERH_COLLETIVE_RFQ_NO,4,10)) AS 'MAXVALUE' FROM EZC_RFQ_HEADER WHERE ERH_PUR_GRP='"+purGrp+"'";

	ezc.ezcommon.EzLog4j.log("docIdQry::::::::"+docIdQry,"I");
	miscTableRow.setQuery(docIdQry);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);

	try
	{
		getMaxDocId = (ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
		System.out.println("Exception:::while saving header QUERY:::::::"+e);
	}
	String maxDocId = "";

	if(getMaxDocId!=null && getMaxDocId.getRowCount()>0)
	{
		maxDocId = getMaxDocId.getFieldValueString(0,"MAXVALUE");

	}

	if("null".equals(maxDocId) || maxDocId==null || "".equals(maxDocId) || maxDocId=="") maxDocId="0"; 

	try
	{
		maxDocId = (Integer.parseInt(maxDocId)+1)+"";

	}
	catch(Exception e){}

	maxDocId = "0000000"+maxDocId;
	maxDocId = maxDocId.substring(maxDocId.length()-7,maxDocId.length());
	maxDocId = purGrp+maxDocId;
	ezc.ezcommon.EzLog4j.log("maxDocId::::::::"+maxDocId,"I");
	
	if(!"null".equals(qcfPrev) && qcfPrev!=null && !"".equals(qcfPrev) && qcfPrev!="") 
		maxDocId= qcfPrev;
	
	
	boolean isError1 = false;
	
	ezc.ezcommon.EzLog4j.log("vendorsCount::::::::"+vendorsCount,"I");
	
	for(int i=0;i<vendorsCount;i++) 
	{
		ezc.ezcommon.EzLog4j.log("FOR  LOOP>>>>::::::::"+i,"I");
		ezcparams		= new ezc.ezparam.EzcParams(false);
		ezcparamsSAP		= new ezc.ezparam.EzcParams(false);	
		ezirfqheaderparams    	= new EziRFQHeaderParams();
		headerParams		= new EziRFQHeaderParams();
		ezirfqheadertable 	= new EziRFQHeaderTable();
		ezirfqheadertablerow   	= null;
		ezirfqdetailstable 	= new EziRFQDetailsTable();
		ezirfqdetailstablerow 	= null;	
		itemTable       	= new EziRFQItemTable();
		itemTableRow		= null;
		qtyTable		= new EziRFQItemQtyTable();
		qtyTableRow		= null;
		vendAddr		= new EziRFQVendAddrTable();
		vendAddrRow  		= null;
		prItemTable		= new EziRFQPRItemsTable();
	 	prItemTableRow		= null;			
		eziaudittable 		= new EziAuditTrailTable();
		eziaudittablerow 	= null;	
		
		String rfq="";
		String eMailData="",eMailDataComm="";
		String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		String bgColor = "bgcolor=\"#FFFFFF\"";
		String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
		String tdBGColor = "style=\"background-color: #EDF1F4;\"";
		
		
		ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable1 = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();		

		ReturnObjFromRetrieve getMaxRfq = null;
		
		
		miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow1.setQuery("SELECT CAST(MAX(ERH_RFQ_NO)+1 AS UNSIGNED) AS 'MAXRFQ' FROM EZC_RFQ_HEADER");
		ezc.ezcommon.EzLog4j.log("miscTableRow1>>>>>"+miscTableRow1.getQuery(),"I");
		miscTable1.appendRow(miscTableRow1);
		mainParams1.setLocalStore("Y");
		mainParams1.setObject(miscTable1);
		Session.prepareParams(mainParams1);

		try
		{
			getMaxRfq = (ReturnObjFromRetrieve)miscMgr1.ezGetMiscTransactions(mainParams1);

		}
		catch(Exception e)
		{
			System.out.println("Exception:::while saving header QUERY:::::::"+e);
		}
		

		if(getMaxRfq!=null && getMaxRfq.getRowCount()>0)
		{
			ezc.ezcommon.EzLog4j.log("getMaxRfqNew>>>>>"+getMaxRfq.toEzcString(),"I");
			try
			{
				rfq = new BigDecimal(getMaxRfq.getFieldValueString(0,"MAXRFQ"))+"";
				ezc.ezcommon.EzLog4j.log("rfqNew11>>>>>"+rfq,"I");
			}
			catch(Exception e)
			{
				rfq = "7000000001";
			}
			
		}	
		
			ezirfqheadertablerow = new EziRFQHeaderTableRow();
			ezirfqheadertablerow.setCollectiveRFQNo(maxDocId);
			ezirfqheadertablerow.setRFQNo(rfq);
			ezirfqheadertablerow.setSysKey((String)session.getValue("SYSKEY"));
			ezirfqheadertablerow.setSoldTo(vendor[i]);
			ezirfqheadertablerow.setPRNo(headPrno);
			ezirfqheadertablerow.setPRItmNo(prItmNo);
			ezirfqheadertablerow.setStatus("N");
			ezirfqheadertablerow.setRFQDate(today);
			ezirfqheadertablerow.setValidUpto(endDateDB);
			ezirfqheadertablerow.setCreatedBy(Session.getUserId());
			ezirfqheadertablerow.setModifiedBy(Session.getUserId());
			ezirfqheadertablerow.setPurchaseOrg(purchOrg); 
			ezirfqheadertablerow.setPurchaseGrp(purGrp); 
			ezirfqheadertablerow.setVendorType(vendType[i]); 
			ezirfqheadertablerow.setAgentCode(agentCode[i]); 
			ezirfqheadertablerow.setReleaseIndicator("N"); 
			ezirfqheadertablerow.setRankStatus(""); 
			//ezirfqheadertablerow.setExt1(Comments); 
			ezirfqheadertablerow.setExt2(rfqType);  //RFQ Type
			ezirfqheadertablerow.setExt3("N");
			ezirfqheadertablerow.setPmntTerms(rfqPmntTms); 
			ezirfqheadertablerow.setIncoTerms1(rfqIncoTms1); 					
			ezirfqheadertablerow.setPRDetails(clubbedPRsStr);
			//ezirfqheadertablerow.setValType(valType);   
			ezirfqheadertablerow.setValType(prMatType);   
			//ezirfqheadertablerow.setLDClause(ldClause);
			ezirfqheadertablerow.setPlant(prPlant);
			ezirfqheadertablerow.setCompCode(compCode);
			ezirfqheadertablerow.setMatCategory(prCategory);
			ezirfqheadertable.appendRow(ezirfqheadertablerow);
			
			//DOC COMMENTS

			if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0)
			{
				Comments = Comments.replaceAll("'","`");   
				Comments = Comments.trim();
				
				eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
				java.util.ArrayList<String> queriesList=new java.util.ArrayList<String>();
				queriesList.add("INSERT INTO EZC_DOCUMENT_COMMENTS(EDC_DOC_ID,EDC_DOC_TYPE,EDC_COMMENTS,EDC_USER_ID,EDC_DATE) VALUES('"+rfq+"','RFQ','"+Comments+"','"+Session.getUserId()+"',now())");
				ezMiscInsert(Session,queriesList);

			}	
			//FILES SAVING
			lineAttachString = request.getParameterValues("fileItem");
			ezc.ezcommon.EzLog4j.log("rfq>>>>>"+rfq,"I");  
			ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I"); 
			if(lineAttachString != null)
			{ 
				objNo 		= rfq;
				documentType 	= "RFQ"; 
				
			ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
			//for(int x=0;x<selectedPRsCnt;x++)
			//{
				String fileItemIndex = "H";
				String fileItem[]	= request.getParameterValues("fileItem"); 
				int fileLength = 0;
				if(fileItem != null)
					fileLength = fileItem.length;
					ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

				if(fileLength > 0)
				{
					String subDirPath = "RFQ"+"\\"+rfq+"\\"+fileItemIndex+"\\";
					String dirPath  = serverUpPath+subDirPath;
					String sessionId = session.getId()+"";
					Path path = Paths.get(dirPath);
					Files.createDirectories(path);
					for(int j=0;j<fileItem.length;j++)
					{
						try
						{
							String fileName = fileItem[j];	
							File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
							File notifDestFile = new File(dirPath+fileName);			
							FileInputStream inStream = new FileInputStream(notifSourceFile);
							FileOutputStream outStream = new FileOutputStream(notifDestFile);
							byte[] buffer = new byte[1024];
							int length;
							//copy the file content in bytes 
							while ((length = inStream.read(buffer)) > 0)
							{
								outStream.write(buffer, 0, length);
							}
							inStream.close();
							outStream.close();
							//notifSourceFile.delete();		
							ezc.misctransactions.params.EzMiscTableRow miscTableRow2 = new ezc.misctransactions.params.EzMiscTableRow();
							miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+rfq+"','"+fileItemIndex+"','RFQ','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
							miscTable2.appendRow(miscTableRow2);
						}catch(Exception e)
						{
						
						}
					}
				}
			//}
			mainParams2.setLocalStore("Y");
			mainParams2.setObject(miscTable2);
			Session.prepareParams(mainParams2);
			try
			{
			miscMgr2.ezSaveMiscTransactions(mainParams2);

			}
			catch(Exception e)
			{
			} 				

%>	
				<%//@ include file="../UploadFiles/ezSaveRFQAttach.jsp" %>	
<%				
						
			}
			
		//RFQ EMAIL
		
		

		
		eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>PR No.</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
		eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
		eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
		eMailData +=  "</Tr>";		 
			
			
					
			for(int q=0;q<selectedPRsCnt;q++)
			{
					String remarks=request.getParameter("remarks"+q);
					remarks = remarks.replaceAll("'","`");
					remarks = remarks.replaceAll("\"", "`"); 
					remarks = remarks.replaceAll("$", "");
					remarks = remarks.replaceAll("&", "&amp;");
					remarks = remarks.replaceAll("<", "&lt;");
					remarks = remarks.trim();
					
					String matDescStr=matDes[q]; 
					if(matDescStr != null)
					{					
						matDescStr = matDescStr.replaceAll("'","`");
						matDescStr = matDescStr.replaceAll("\"", "`");
						matDescStr = matDescStr.replaceAll("\\\\","");
						matDescStr = matDescStr.replaceAll("$", "");
						matDescStr = matDescStr.trim();	
					}
					
					String itmTextArrStr=itmTextArr[q];
					itmTextArrStr = itmTextArrStr.replaceAll("'","`");
					itmTextArrStr = itmTextArrStr.replaceAll("\"", "`"); 
					itmTextArrStr = itmTextArrStr.replaceAll("$", "");
					itmTextArrStr = itmTextArrStr.trim();	
					
					String poTextArrStr=poTextArr[q];
					poTextArrStr = poTextArrStr.replaceAll("'","`");
					poTextArrStr = poTextArrStr.replaceAll("\"", "`"); 
					poTextArrStr = poTextArrStr.replaceAll("$", "");
					poTextArrStr = poTextArrStr.trim();					
					
					
					
					String warranty=request.getParameter("warranty"+q);
					delivDateDB= deldt[q].substring(6,10)+"-"+deldt[q].substring(3,5)+"-"+deldt[q].substring(0,2);
					ezirfqdetailstablerow = new EziRFQDetailsTableRow();
					ezirfqdetailstablerow.setRFQNo(rfq); 
					ezirfqdetailstablerow.setLineNo(((q+1)*10)+""); 
					ezirfqdetailstablerow.setCounter("0"); 
					ezirfqdetailstablerow.setMaterial(matNo[q]); 
					ezirfqdetailstablerow.setMaterialDesc(matDescStr);
					ezirfqdetailstablerow.setUOM(prUom[q]); 
					ezirfqdetailstablerow.setDeliveryDate(delivDateDB);
					ezirfqdetailstablerow.setQuantity(qty[q]); 
					ezirfqdetailstablerow.setPlant(plant[q]); 
					ezirfqdetailstablerow.setPrice("0"); 
					ezirfqdetailstablerow.setRemarks(remarks); 
					//ezirfqdetailstablerow.setExt1(prNo[q]+"¥"+prItem[q]+"¥"+prTypeArr[q]); 
					//ezirfqdetailstablerow.setExt1(prNo[q]+"¥"+prItem[q]); 
					ezirfqdetailstablerow.setExt1(prNo[q]); 
					ezirfqdetailstablerow.setExt2(itmTextArrStr); 
					ezirfqdetailstablerow.setExt3(poTextArrStr);
					ezc.ezcommon.EzLog4j.log("currency[q]>>>>>"+currency[q],"I"); 
					ezirfqdetailstablerow.setCurr(currency[q]);
					ezirfqdetailstablerow.setAccCategory(accCat[q]);
					ezirfqdetailstablerow.setItemCategory(itemCat[q]);
					ezirfqdetailstablerow.setWarranty(warranty);
					ezirfqdetailstablerow.setDocType(prTypeArr[q]); 
					ezirfqdetailstablerow.setMatGroup(matGrp[q]);
					ezirfqdetailstablerow.setOrderUnit("1");
					ezirfqdetailstablerow.setPrCreatedBy(prCreatedBy[q]);
					ezirfqdetailstable.appendRow(ezirfqdetailstablerow);
					if(i == 0)
					{
						String [] tempPrValArr=prNo[q].split("/");
						if(tempPrValArr != null)
						{
							for(String tempPrVal:tempPrValArr)
								htPRRFQItem.put(tempPrVal,((q+1)*10)+"");
						}
					}
					
					eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+plantHT.get(plant[q])+"</Td>";
			if(!"FROMMAT".equals(flag))
			{			
				eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+prNo[q]+"</Td>";
				eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+prItem[q]+"</Td>";  
			}
			else
			{
				eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>N/A</Td>";
				eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>N/A</Td>";			
				
			}
			eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+matNo[q]+"</Td>";
			eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+matDes[q]+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+qty[q]+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+prUom[q]+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+deldt[q]+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+endDateDisp+"</Td>";
			eMailData +=  "</Tr>";						
					
					if("D".equals(itemCat[q]))
					{
						for(int r=0;r<retServCount;r++)
						{
							if(pckgNo[q].equals(sesServObj.getFieldValueString(r,"SERVPCKGNO")))
							{
								String servRfq		=  rfq;
								String servRfqItem	=((q+1)*10)+"";
								
								String tempServPR 	= prNo[q].split("-")[0];
								String tempServItem 	= prNo[q].split("-")[1];

								String servPr		=  tempServPR;
								String servPrItem 	=  tempServItem;
								String extLine		= (String)sesServObj.getFieldValueString(r,"EXTLINE");
								String servAct		= (String)sesServObj.getFieldValueString(r,"SERVACT");
								String servTxt		= checkNull((String)sesServObj.getFieldValueString(r,"SERVTXT"));
								servTxt = servTxt.replaceAll("'","`");
								servTxt = servTxt.replaceAll("\"", "`"); 
								servTxt = servTxt.replaceAll("$", "");
								servTxt = servTxt.replaceAll("&", "&amp;");
								servTxt = servTxt.replaceAll("<", "&lt;");
								servTxt = servTxt.trim();								
								
								String servItmTxt	= checkNull((String)sesServObj.getFieldValueString(r,"SERVITEMTXT"));
								servItmTxt = servItmTxt.replaceAll("'","`");
								servItmTxt = servItmTxt.replaceAll("\"", "`"); 
								servItmTxt = servItmTxt.replaceAll("$", "");
								servItmTxt = servItmTxt.replaceAll("&", "&amp;");
								servItmTxt = servItmTxt.replaceAll("<", "&lt;");
								servItmTxt = servItmTxt.trim();
								
								String servLineTxt	= checkNull((String)sesServObj.getFieldValueString(r,"SERVLINETXT"));
								servLineTxt = servLineTxt.replaceAll("'","`");
								servLineTxt = servLineTxt.replaceAll("\"", "`"); 
								servLineTxt = servLineTxt.replaceAll("$", "");
								servLineTxt = servLineTxt.replaceAll("&", "&amp;");
								servLineTxt = servLineTxt.replaceAll("<", "&lt;");
								servLineTxt = servLineTxt.trim();
								
								String servQty		= (String)sesServObj.getFieldValueString(r,"SERVQTY");
								String servUom		= (String)sesServObj.getFieldValueString(r,"SERVUOM");
								String servPckg		= (String)sesServObj.getFieldValueString(r,"SERVPCKGNO");

								ezc.ezcommon.EzLog4j.log("servPr>>>>>"+servPr,"I"); 
								ezc.ezcommon.EzLog4j.log("servPrItem>>>>>"+servPrItem,"I"); 									
								ezc.ezcommon.EzLog4j.log("extLine>>>>>"+extLine,"I");
								ezc.ezcommon.EzLog4j.log("servAct>>>>>"+servAct,"I");
								ezc.ezcommon.EzLog4j.log("servTxt>>>>>"+servTxt,"I");
								ezc.ezcommon.EzLog4j.log("servItmTxt>>>>>"+servItmTxt,"I");
								ezc.ezcommon.EzLog4j.log("servLineTxt>>>>>"+servLineTxt,"I");
								ezc.ezcommon.EzLog4j.log("servQty>>>>>"+servQty,"I");
								ezc.ezcommon.EzLog4j.log("servUom>>>>>"+servUom,"I");
								ezc.ezcommon.EzLog4j.log("servPckg>>>>>"+servPckg,"I");
								ezc.ezcommon.EzLog4j.log("servRfq111>>>>>"+servRfq,"I"); 
								ezc.ezcommon.EzLog4j.log("servRfqItem>>>>>"+servRfqItem,"I"); 

								String qryRfq = "";

								ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
								ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
								ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
								ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();

								qryRfq="INSERT INTO EZC_RFQ_SERVICES(ERS_SRV_PR,ERS_SRV_PR_ITEM,ERS_SRV_LINE,ERS_SRV_PKG,ERS_SRV_RFQ,ERS_SRV_RFQ_ITEM,ERS_SRV_ACT,ERS_SRV_DESC,ERS_SRV_ITEM_TEXT,ERS_SRV_LINE_TEXT,ERS_SRV_QTY,ERS_SRV_UOM,ERS_SRV_PRICE,ERS_SRV_SAC,ERS_SRV_GST,ERS_SRV_EXT1,ERS_SRV_EXT2,ERS_SRV_EXT3) VALUES ('"+servPr+"','"+servPrItem+"','"+extLine+"','"+servPckg+"','"+servRfq+"','"+servRfqItem+"','"+servAct+"','"+servTxt+"','"+servItmTxt+"','"+servLineTxt+"','"+servQty+"','"+servUom+"','0','','','','','')";
								ezc.ezcommon.EzLog4j.log("**qryRfq>>"+qryRfq,"I");

								qcfTableRow.setQuery(qryRfq);
								qcfTable.appendRow(qcfTableRow);
								qcfParams.setLocalStore("Y");
								qcfParams.setObject(qcfTable);
								Session.prepareParams(qcfParams);

								try
								{
									qcfMgr.ezSaveMiscTransactions(qcfParams);

								}
								catch(Exception e)
								{
									out.println("Exception in Service Insertion>>>>>"+e);
								}	

							}
						}	
					}										
					
			}
			eMailData +=  "</Table><Br>";
			/*
			ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
			for(int x=0;x<selectedPRsCnt;x++)
			{
				int fileItemIndex = ((x+1)*10);
				String fileItem[]	= request.getParameterValues("fileItem"+fileItemIndex); 
				int fileLength = 0;
				if(fileItem != null)
					fileLength = fileItem.length;
					ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

				if(fileLength > 0)
				{
					String subDirPath = "RFQ"+"\\"+rfq+"\\"+fileItemIndex+"\\";
					String dirPath  = serverUpPath+subDirPath;
					String sessionId = session.getId()+"";
					Path path = Paths.get(dirPath);
					Files.createDirectories(path);
					for(int j=0;j<fileItem.length;j++)
					{
						try
						{
							String fileName = fileItem[j];	
							File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
							File notifDestFile = new File(dirPath+fileName);			
							FileInputStream inStream = new FileInputStream(notifSourceFile);
							FileOutputStream outStream = new FileOutputStream(notifDestFile);
							byte[] buffer = new byte[1024];
							int length;
							//copy the file content in bytes 
							while ((length = inStream.read(buffer)) > 0)
							{
								outStream.write(buffer, 0, length);
							}
							inStream.close();
							outStream.close();
							notifSourceFile.delete();		
							ezc.misctransactions.params.EzMiscTableRow miscTableRow2 = new ezc.misctransactions.params.EzMiscTableRow();
							miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+rfq+"','"+fileItemIndex+"','RFQ','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
							miscTable2.appendRow(miscTableRow2);
						}catch(Exception e)
						{
						}
					}
				}
			}
			mainParams2.setLocalStore("Y");
			mainParams2.setObject(miscTable2);
			Session.prepareParams(mainParams2);
			try
			{
			miscMgr2.ezSaveMiscTransactions(mainParams2);

			}
			catch(Exception e)
			{
			} */

			//uploads end			
			isError1 = true;
			
			String dispSoldTo="";
			
			try{
					dispSoldTo = Long.parseLong(vendor[i])+""; 
			}catch(Exception e)
			{
					dispSoldTo= vendor[i];	
			}  					
			
			String dispVend = (String)gv_VendorsHT.get(vendor[i])+"["+dispSoldTo+"]"; // vend[i];
			if("".equals(retMessage))
			{
				
				retMessage = "<Tr><Td align='center'></Td><Th>"+ "RFQ(s)"+" added under QCF:<b> "+ maxDocId+"</b></Th></Tr>";
				retMessage = retMessage+"<br><br><Tr><Td align='center'></Td><Th>"+(i+1)+".RFQ:"+rfq+" created sucessfully against the vendor: "+dispVend+" </Th></Tr>";
			}		
			else
			{
				retMessage = retMessage+"<br><br><Tr><Td align='center'></Td><Th>"+(i+1)+".RFQ:"+rfq+" created sucessfully against the vendor:  "+dispVend+" </Th></Tr>";
			}	
		if(isError1)
		{		
			ezcparams.setObject(ezirfqheadertable);
			ezcparams.setObject(ezirfqdetailstable);
			ezcparams.setLocalStore("Y");
			Session.prepareParams(ezcparams);
			ezc.ezcommon.EzLog4j.log("::::::::Before ezAddRFQ:::::::::::","D");  
			ezrfqmanager.ezAddRFQ(ezcparams);

			ezcparamsSAP.setObject(eziaudittable);
			Session.prepareParams(ezcparamsSAP);
			ezrfqmanager.ezAddAuditTrail(ezcparamsSAP);

	//adding pr's
	if(i == 0)
	{
		try
		{

		for(int h=0;h<prDetails.length;h++)
		{
			ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(prDetails[h],"$$");
			java.util.Vector Tokens = EzToken.getTokens();


			String tempPr	= (String)Tokens.elementAt(6);

			String prNo_temp	= tempPr.replace("$","");
			String prItem_temp	= (String)Tokens.elementAt(7);


			String qty1_temp	= (String)Tokens.elementAt(3);	

			String prDocType_temp	= checkNull((String)Tokens.elementAt(12));
			String delivDate_temp= (String)Tokens.elementAt(2);
			String relDate_temp= (String)Tokens.elementAt(19);
			ezc.ezcommon.EzLog4j.log("::::::::relDate_temp:::::::::::"+relDate_temp,"I");  


			qcfPrQueries.add("INSERT INTO EZC_RFQ_PRS(ERP_QCF_NO,ERP_RFQ_LINE_NO,ERP_PR_NO,ERP_PR_ITEM,ERP_PR_QTY,ERP_PR_OPEN_QTY,ERP_PR_DEL_DATE,ERP_PR_TYPE,ERP_PR_REL_DATE) VALUES('"+maxDocId+"','"+htPRRFQItem.get(prNo_temp+"-"+prItem_temp)+"','"+prNo_temp+"','"+prItem_temp+"','"+qty1_temp+"','"+qty1_temp+"',STR_TO_DATE('"+delivDate_temp+"','%d.%m.%Y'),'"+prDocType_temp+"',STR_TO_DATE('"+relDate_temp+"','%d.%m.%Y'))");

		}
		}
		catch(Exception e){
		ezc.ezcommon.EzLog4j.log("::::::::Exeption while filling EZC_RFQ_PRS:::::::::::"+e,"I");  
		}
	//end
		ezMiscInsert(Session,qcfPrQueries);

	}
%>
			<%@ include file="ezSendQuotationMail.jsp" %>  	   				
<%
			/***
			     Checking for expiry of the quotation -- start
			***/

			ezc.ezworkflow.client.EzWorkFlowManager EzWorkFlow = new ezc.ezworkflow.client.EzWorkFlowManager();
			ReturnObjFromRetrieve finalRet = new ReturnObjFromRetrieve(new String[]{"PARTICIPANT","PARTICIPANT_TYPE","ROLE","STATUS","SYSKEY","DOCID","TEMPLATE","AUTHKEY","MODIFIEDBY","ACTIONCODE","DELPARTICIPANT","DELPARTICIPANTTYPE","ADDORUPDATE","PREVPARTICIPANT","PREVPARTICIPANT_TYPE","INITIATOR","WFTYPE","MAIL_EXTS","COMMENTS"});
			finalRet.setFieldValue("PARTICIPANT"		,	Session.getUserId());
			finalRet.setFieldValue("PARTICIPANT_TYPE"	,	"-");
			finalRet.setFieldValue("ROLE"			,	"-");
			finalRet.setFieldValue("STATUS"			,	"EXPIRY");
			finalRet.setFieldValue("SYSKEY"			,	(String)session.getValue("SYSKEY"));
			finalRet.setFieldValue("DOCID"			,	maxDocId);
			finalRet.setFieldValue("TEMPLATE"		,	templateCode);
			finalRet.setFieldValue("AUTHKEY"		,	"QCF_EXPIRY");
			finalRet.setFieldValue("MODIFIEDBY"		,	Session.getUserId());
			finalRet.setFieldValue("ACTIONCODE"		,	"-");
			finalRet.setFieldValue("DELPARTICIPANT"		,	"-");
			finalRet.setFieldValue("DELPARTICIPANTTYPE"	,	"-");
			finalRet.setFieldValue("ADDORUPDATE"		,	"ADD");
			finalRet.setFieldValue("PREVPARTICIPANT"	,	"-");
			finalRet.setFieldValue("PREVPARTICIPANT_TYPE"	,	"-");
			finalRet.setFieldValue("INITIATOR"		,	"-");
			finalRet.setFieldValue("WFTYPE"			,	"-");
			finalRet.setFieldValue("MAIL_EXTS"		,	"-");
			finalRet.setFieldValue("COMMENTS"		,	duration+"");
			finalRet.addRow();

			//EzWorkFlow.doEscalate(finalRet,null);

			/***
			     Checking for expiry of the quotation -- End
			***/		
		}
		else
		{
			java.util.Vector extMailIds = new java.util.Vector();
			extMailIds.addElement("hchowdary@answerthink.com");
			extMailIds.addElement("ezcsupport@answerthink.com");
%>
			<%//@ include file="../Inbox/ezSendExternalMail.jsp" %>				
<%	
		}
	}	
	
	
%>

<%@ include file="../../../Includes/JSPs/Misc/iblockcontrol.jsp" %>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Confirmation
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post">
<input type="hidden" name="reqFrom" value="InviteGrp">
<input type="hidden" name="flag" value="<%=flag%>">


<div class="panel">
	<div class="panel-heading"></div>
	<div class="panel-body"><%=retMessage%></div>
</div>

<%
	if(!"".equals(retWarnMessage))
	{
%>
		<!--<div class="panel panel-warning">
			<div class="panel-heading">WARNING</div>
			<div class="panel-body"><%=retWarnMessage%></div>
		</div>-->
<%
	}  	
%>

<div class="row no-print">
<div class="col-xs-12">
<%
if(isError)
{
%>
	<button type="button" class="btn btn-primary pull-right" onclick="funGo()" style="margin-right: 5px;">Ok</button>
<%
}
else
{
 %>
	<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;">Ok</button>  
<%
}
%>
<input type="hidden" name="purchaseHidden"   value="<%=purchReq%>">

<input type="hidden" name="qtnEndDate" value="<%=request.getParameter("qtnEndDate")%>">
<input type="hidden" name="qtnEndTime" value="<%=request.getParameter("qtnEndTime")%>">
<input type="hidden" name="rows" value="">
<input type="hidden" name="plant" value="<%=request.getParameter("plant")%>">
<input type="hidden" name="material" value="<%=material%>">
<input type="hidden" name="uom" value="<%=uom%>">
<input type="hidden" name="quantity" value="<%=request.getParameter("quantity")%>">
<input type="hidden" name="commentText" value="<%=request.getParameter("commentText")%>">
<input type="hidden" name="reqNo" value="<%=headPrno%>">
<input type="hidden" name="prItmNo" value="<%=prItmNo%>">
<input type="hidden" name="purchReq1" value="<%=purchReq%>">
<input type="hidden" name="soldTos" value="<%=request.getParameter("soldTos")%>">
<input type="hidden" name="purGrp" value="<%=request.getParameter("purGroup")%>"> 
<input type="hidden" name="reqDate" value="<%=request.getParameter("matDelDate")%>">  
<input type="hidden" name="comment" value="<%=Comments%>">  
<input type="hidden" name="matDesc" value="<%=matDesc%>">  
<%
	String selectedPRsMult[] = request.getParameterValues("purchReq");
	
	
		
	/************* The following is for storing pr details in db as for knowing RFQ created against PR(s) or not ******************/

	int prLen = 0;
	if(selectedPRsMult!=null)
		prLen = selectedPRsMult.length;

	for(int h=0;h<prLen;h++)
	{
%>		<input type=hidden name="purchReq" value="<%=selectedPRsMult[h]%>">
<%	
	}
	for(int s=0;s<vendorsCount;s++)
	{
%>
		<input type="hidden" name="selChk" value='<%=selectedVendors[s]%>'>
<%	
	}
%>
</div>
</div>
</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezFooter.jsp"%>

<script>



function checkAll()
	{
		var chkObj 	= document.myForm.chk;
		var chkObj1 	= document.myForm.chk1;
		var chkLen	= chkObj1.length;
		var chkValue	= "";
		var count	= 0;
	
		if(chkObj.checked)
		{
			if(!isNaN(chkLen))
			{
				for(i=0;i<chkLen;i++)
				{
					chkObj1[i].checked = true;
				}
			}
			else
			{
				chkObj1.checked = true;
			}
		}
		else
		{
			if(!isNaN(chkLen))
			{
				for(i=0;i<chkLen;i++)
				{
					chkObj1[i].checked = false;
				}
			}
			else
			{
				chkObj1.checked = false;
			}
		}
	}
	
	
	function checkSelction()
	{
		var rfqObj = document.myForm.chk1;
		var rfqLen = "";
		var count = 0;
		var args = "";
		var selRfq = "";
		var soldTo = "";

		if(rfqObj != null)
		{
			rfqLen = document.myForm.chk1.length
			if(!isNaN(rfqLen))
			{

				for(i=0;i<rfqLen;i++)
				{
					if(document.myForm.chk1[i].checked)
					{
						count++;
					}
				}
			}
			else
			{
				if(document.myForm.chk1.checked)
				{
					count++;
				}	
			}
		}

		
		if(count==0)
		{
			alert("Please select atleast one RFQ to Invite");
			return;
		}
		else
			return true;
	}	
	
	function sendInvitation()
	{
		if(checkSelction())
		{
			if(confirm("By pressing OK you can send an Invitation."))
			{					
				document.myForm.action="ezCounterOffer.jsp";
				document.myForm.submit();
			}

		}
	}




function funGo()
{
  var purGrp="<%=purGrp%>";
 
  //document.myForm.action="ezVendorViewList.jsp";  
  document.myForm.action="ezEnterEndDate.jsp";
  //document.myForm.action="../RFQ/ezListPR.jsp?Status=R&purGrp="+purGrp; 
  document.myForm.submit(); 
}
function funOk()
{
	var purGrp="<%=purGrp%>"; 
	//document.myForm.action="../RFQ/ezListPR.jsp?Status=R&purGrp="+purGrp;
	document.myForm.action="../RFQ/ezPrePRList.jsp?Status=R";
  document.myForm.submit();
}
</script>
<script language="Javascript1.2">
	am = "This function is disabled!";
	bV  = parseInt(navigator.appVersion)
	bNS = navigator.appName=="Netscape"
	bIE = navigator.appName=="Microsoft Internet Explorer"
	function nrc(e) 
	{
	   if (bNS && e.which > 1)
	   {
	      alert(am)
	      return false
	   } 
	   else if (bIE && (event.button >1)) 
	   {
	     alert(am)
	     return false;
	   }
	}
	document.onmousedown = nrc;
	if (document.layers) window.captureEvents(Event.MOUSEDOWN);
	if (bNS  && bV<5) window.onmousedown = nrc;
	
</script>
