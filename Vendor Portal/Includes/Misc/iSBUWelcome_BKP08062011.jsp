<%!
            private  ezc.ezparam.EzPurchHdrXML getRetObj(ezc.session.EzSession Session,java.sql.Date FromDate,String POCON,String relFlag,String selFlag,String myPurGrp,String myPurOrg)
            {
                        ezc.ezparam.EzPurchHdrXML hdrXML =null;
                        ezc.client.EzPurchaseManager PoManager = new ezc.client.EzPurchaseManager();
                        ezc.ezparam.EzPSIInputParameters iparams = new ezc.ezparam.EzPSIInputParameters();
                        ezc.ezparam.EzcPurchaseParams Params = new ezc.ezparam.EzcPurchaseParams();
                        ezc.ezpurchase.params.EziPurchaseInputParams testParams = new ezc.ezpurchase.params.EziPurchaseInputParams();
                        if("A".equals(selFlag)){
                                    testParams.setSelectionFlag("A");
                        }else{
                                    testParams.setSelectionFlag("N");
                                    //iparams.setCostCenter("ALL");
                        }           
 
                        if("UNREL".equals(relFlag)) testParams.setMaterial("####");
                        else testParams.setDocType(POCON);
                        if(myPurGrp!=null && !"null".equals(myPurGrp) && !"".equals(myPurGrp.trim()))
                        testParams.setPurGroup(myPurGrp);
                        if(myPurOrg!=null&& !"null".equals(myPurOrg) && !"".equals(myPurOrg.trim()))
                        testParams.setPurOrg(myPurOrg);
                                                
                        if (FromDate != null) testParams.setFromDate(FromDate);
                                    
                        Params.createContainer();
                        Params.setObject(iparams);
                        Params.setObject(testParams);
                        Session.prepareParams(Params);
                        try{
                                    
                                    hdrXML = (EzPurchHdrXML)PoManager.ezGetNewPurchaseOrderList(Params);
                                    
                                            
                        }catch(Exception e){ }
                        return hdrXML; 
            }
            
            
            
            
            private  ezc.ezparam.ReturnObjFromRetrieve getWFObj(String userRole,ezc.session.EzSession Session,String defCatArea,String myTemplate,String userGroup,String POCON,String userId,String sessionRole)
            {
                        ezc.ezparam.EzcParams mainParams1 = new ezc.ezparam.EzcParams(false);
                        ezc.ezworkflow.params.EziWFDocHistoryParams paramsWf= new ezc.ezworkflow.params.EziWFDocHistoryParams();
                        ezc.ezworkflow.client.EzWorkFlowManager EzWorkFlowManager = new ezc.ezworkflow.client.EzWorkFlowManager();
                        paramsWf.setAuthKey("'PO_RELEASE','CON_RELEASE'");
                        paramsWf.setSysKey("'"+defCatArea+"'");
                        paramsWf.setTemplateCode(myTemplate);
                        paramsWf.setStatus("'Blocked','SUBMITTED','REJECTED'");
                        paramsWf.setParticipant("'"+userGroup+"','"+userRole+"','"+userId+"','"+sessionRole+"'");
                        paramsWf.setDelParticipant("'"+userGroup+"','"+userRole+"','"+userId+"','"+sessionRole+"'");
                        mainParams1.setObject(paramsWf);
                        Session.prepareParams(mainParams1);
                        ReturnObjFromRetrieve retWfobj= (ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams1);
                        return retWfobj;
            }
            
            
            public ezc.ezparam.ReturnObjFromRetrieve getWFHierarchy(ezc.session.EzSession Session,String syskey,String template)
            {
                        ezc.ezworkflow.client.EzWorkFlowManager EzWorkFlowManager = new ezc.ezworkflow.client.EzWorkFlowManager();
                        ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
                        ezc.ezworkflow.params.EziOrganogramLevelsParams params= new ezc.ezworkflow.params.EziOrganogramLevelsParams();
                        params.setTemplate(template);
                        params.setSysKey(syskey);
                        mainParams.setObject(params);
                        Session.prepareParams(mainParams);
                        ezc.ezparam.ReturnObjFromRetrieve listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getOrganogramLevelsDetails(mainParams);
                        return listRet;
            }
            
            
            public String prepareURL(int alertCount,String disDocument,String message)
            {
                        String retStr="";
                        
                        if(alertCount==0){
                                    retStr="<b>No "+message;
                        }else{
                                    retStr="<a href=\"javascript:replaceLocation('"+disDocument+"')\"><b> "+alertCount+"&nbsp;"+message+"<b></a> ";
                        }
                                                
                        return retStr;
                        
            }
            
            
%>
 
 
 
 
<%
            long initialTime = (new java.util.Date()).getTime();
            
            
            int toBeQuotedRFQCount=0;
            int toBeInvitedRFQCount=0;
            int newQCFCount=0;
            int toBeActQCFCount=0;
            int qcfCommentCount=0;
            
            int poAmendCount=0;
            int poBlockSuppCount=0;
            int conAmendCount=0;
            int conBlockSuppCount=0;
            int expQCFCount=0;
            
            
            
            String defCatArea  = (String)session.getValue("SYSKEY");
            
            String defPurGrp= (String)session.getValue("USERDEFPURGRP");
            
            String defErpVendor= (String)session.getValue("SOLDTO");
            String soldToInStr = (String)session.getValue("SOLDTOS");
            String userType    = (String)session.getValue("UserType");
            String template    = (String)session.getValue("TEMPLATE");
            String userRole    = (String)session.getValue("USERROLE");
            String userGroup   = (String)session.getValue("USERGROUP");
            String myTemplate  = (String)session.getValue("TEMPLATE");
            String sessionRole = (String)session.getValue("ROLE");
            
            
            
            ezc.client.EzcPurchaseUtilManager PurManager = new ezc.client.EzcPurchaseUtilManager(Session);
            PurManager.setPurAreaAndVendor(defCatArea,defErpVendor); 
  
            String myAuditDocNos="";
      
            
            java.util.Vector loginUsrSoldtos=(java.util.Vector)session.getValue("SOLDTOVECT");
            if(loginUsrSoldtos==null) loginUsrSoldtos=new java.util.Vector();
            
            String userId                  =          Session.getUserId();
            
            String wfCheckName      =          "'"+userId+"','"+userGroup+"','"+userRole+"','"+sessionRole+"'";     
            
            
            
            
            
            
                        
                        
            java.util.Vector newRFQVector=new java.util.Vector();
            java.util.Vector toBeActRFQVector=new java.util.Vector();
            java.util.Vector expiredQCFVector=new java.util.Vector();
  
  
                        
            EzcParams ezcContainer= null;
            EziRFQHeaderParams rfqHeaderParams =null;
            ReturnObjFromRetrieve rfqListRetObj =null;
            EziWFDocHistoryParams wfparams=null;
            
            ezcContainer    = new EzcParams(false);
            rfqHeaderParams = new EziRFQHeaderParams();
            rfqHeaderParams.setStatus("N");
            rfqHeaderParams.setExt1("LIST");           
            rfqHeaderParams.setExt3("Y");
            rfqHeaderParams.setSysKey(defCatArea);
            
             if(!"3".equals(userType))  
	     {
	     	rfqHeaderParams.setExt2("ALL"); 
	     	rfqHeaderParams.setPurchaseGrp(defPurGrp); 
	     	
	     }
	     else{
	     	rfqHeaderParams.setSoldTo(soldToInStr);
	     	rfqHeaderParams.setPurchaseGrp("ALL"); 
	     }	
		    
            ezcContainer.setObject(rfqHeaderParams);
            ezcContainer.setLocalStore("Y");
            Session.prepareParams(ezcContainer);
            
            rfqListRetObj =(ReturnObjFromRetrieve)PreProManager.ezGetRFQList(ezcContainer);
            ezc.ezcommon.EzLog4j.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>ENDINGGGG","D");
            
           // out.println("Check this block of code1  "+rfqListRetObj.toEzcString());
            
            Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
            
            if(rfqListRetObj!=null)
            {
		java.util.Date currentDateObj =new java.util.Date();

		java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
		java.util.Date validUPToDate =null;
		String validUPToStr = "";
		            	
            	int month = 0,date = 0,year = 0;
            
            
            	//java.util.Date myChkDateObj=new java.util.Date();
            	//java.util.Date validUPToDate =null;
            	
		for(int i=0;i<rfqListRetObj.getRowCount();i++)
		{
			//validUPToDate=(java.util.Date)rfqListRetObj.getFieldValue(i,"VALID_UPTO");  
			
			validUPToStr = rfqListRetObj.getFieldValueString(i,"VALID_UPTO");

			date = Integer.parseInt(validUPToStr.split("-")[2]);
			month = Integer.parseInt(validUPToStr.split("-")[1])-1;
			year = Integer.parseInt(validUPToStr.split("-")[0])-1900;

			validUPToDate = new java.util.Date(year,month,date);
			
			
			if(vendorsHT.containsKey(rfqListRetObj.getFieldValueString(i,"SOLD_TO")) && myChkDateObj.compareTo(validUPToDate)<=0)
			{
				toBeQuotedRFQCount++;
			}	
		}
           	
            }
            
            
            ezcContainer=new EzcParams(false);
            rfqHeaderParams = new EziRFQHeaderParams();
            rfqHeaderParams.setStatus("N");
            if(!"3".equals(userType))  
            {
            	rfqHeaderParams.setExt2("ALL"); 
            	rfqHeaderParams.setPurchaseGrp(defPurGrp); 
            }
            else{
            	rfqHeaderParams.setSoldTo(soldToInStr);
            	rfqHeaderParams.setPurchaseGrp("ALL"); 
            }	
            
            rfqHeaderParams.setExt1("LIST");           
            rfqHeaderParams.setExt3("N");
            rfqHeaderParams.setSysKey(defCatArea);
            
            ezcContainer.setObject(rfqHeaderParams);
            ezcContainer.setLocalStore("Y");
            Session.prepareParams(ezcContainer);
            rfqListRetObj= (ReturnObjFromRetrieve)PreProManager.ezGetRFQList(ezcContainer);
            
            System.out.println("Check this block of code2");
            
            if(rfqListRetObj!=null)
            {
                        toBeInvitedRFQCount=rfqListRetObj.getRowCount();
            }
            
            if(!"3".equals(userType))  
            {
                        
                        rfqHeaderParams =new EziRFQHeaderParams();
                        ezcContainer= new EzcParams(false);
                        rfqHeaderParams= new EziRFQHeaderParams();
                        rfqHeaderParams.setExt1("CR");
                        rfqHeaderParams.setSysKey(defCatArea);
                        rfqHeaderParams.setStatus("Y','N','R");
                        rfqHeaderParams.setPurchaseGrp(defPurGrp); 
                        ezcContainer.setObject(rfqHeaderParams);
                        ezcContainer.setLocalStore("Y");
 
                        Session.prepareParams(ezcContainer);
                        ezc.ezcommon.EzLog4j.log("RFQRFQRFQRFQRFQRFQRFQRFQRFQRFQ STARTED","I");
                        rfqListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)PreProManager.ezGetRFQList(ezcContainer);
                        ezc.ezcommon.EzLog4j.log("RFQRFQRFQRFQRFQRFQRFQRFQRFQRFQ ENDED","I");            
                        
                        System.out.println("Check this block of code3");
                       //java.util.Date myChkDateObj=new java.util.Date();
                       
			java.util.Date currentDateObj =new java.util.Date();
			java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
 
                        if(rfqListRetObj != null)
                        {
                                 int rfqCount = rfqListRetObj.getRowCount();
                                    
                                    

				java.util.Date validUPToDate =null;
				String validUPToStr = "";
				    		            	
            			int month = 0,date = 0,year = 0;
                                    
                                    
                                    
                                   // java.util.Date validUPToDate =null;
                                    for(int i=0;i<rfqCount;i++)
                                    {
                                                toBeActRFQVector.addElement(rfqListRetObj.getFieldValueString(i,"COLLETIVE_RFQ_NO"));
                                                newRFQVector.addElement(rfqListRetObj.getFieldValueString(i,"COLLETIVE_RFQ_NO"));
                                               // validUPToDate=(java.util.Date)rfqListRetObj.getFieldValue(i,"VALID_UPTO");
                                               
						validUPToStr = rfqListRetObj.getFieldValueString(i,"VALID_UPTO");

						date = Integer.parseInt(validUPToStr.split("-")[2]);
						month = Integer.parseInt(validUPToStr.split("-")[1])-1;
						year = Integer.parseInt(validUPToStr.split("-")[0])-1900;
					       
						validUPToDate = new java.util.Date(year,month,date);
                                               
                                               
                                                if(myChkDateObj.compareTo(validUPToDate)>=0)
                                                {
                                                  if(!expiredQCFVector.contains(rfqListRetObj.getFieldValueString(i,"COLLETIVE_RFQ_NO")))
                                                  expiredQCFVector.addElement(rfqListRetObj.getFieldValueString(i,"COLLETIVE_RFQ_NO"));
                                                }
        
        
                                    }
                        }
 
 
                        rfqListRetObj = null;
 
 
                        ezcContainer = new ezc.ezparam.EzcParams(false);
                        wfparams= new EziWFDocHistoryParams();
                        wfparams.setAuthKey("'QCF_RELEASE'");
                        wfparams.setSysKey(defCatArea);
                        wfparams.setTemplateCode(template);
                        ezcContainer.setObject(wfparams);
                        Session.prepareParams(ezcContainer);
                        rfqListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(ezcContainer);
                        if(rfqListRetObj != null)
                        {
                                    newQCFCount = rfqListRetObj.getRowCount();
                                    for(int i=0;i<newQCFCount;i++)
                                    {           
                                                if(toBeActRFQVector.contains(rfqListRetObj.getFieldValueString(i,"DOCID")))
                                                {
                                                            newRFQVector.remove(rfqListRetObj.getFieldValueString(i,"DOCID"));
                                                }
       
                                    }
                        }
                        newQCFCount = newRFQVector.size();
 
 
                        
                        int tempCount = 0;
                        ezcContainer = new ezc.ezparam.EzcParams(false);
                        wfparams= new EziWFDocHistoryParams();
                        wfparams.setAuthKey("'QCF_RELEASE'");
                        wfparams.setSysKey("'"+defCatArea+"'");
                        wfparams.setTemplateCode(template);
                        wfparams.setParticipant(wfCheckName);
                        wfparams.setStatus("'SUBMITTED','REJECTED'");
                        ezcContainer.setObject(wfparams);
                        Session.prepareParams(ezcContainer);
                        rfqListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(ezcContainer);
                        
                        System.out.println("Check this qry::::::::::::::::::::");
                        if(rfqListRetObj != null)
                        {
                                    tempCount = rfqListRetObj.getRowCount();
                                    String docNo="";
                                    for(int i=0;i<tempCount;i++){
 
                                                docNo=rfqListRetObj.getFieldValueString(i,"DOCID");
                                                docNo=docNo.trim();
 
                                                if(toBeActRFQVector.contains(docNo)){
                                                            toBeActQCFCount++;
 
                                                }
        
                                                if(expiredQCFVector.contains(rfqListRetObj.getFieldValueString(i,"DOCID")))
                                                {
                                                  expQCFCount++;
                                                }
 
 
                                    }
 
                        }
            
                                    
            }           
            
            
            
 
            /********    To get Vendor Time stamp(Last Login Time) from Local DB START    *********/
            
            ezcContainer = new ezc.ezparam.EzcParams(false);
            ezc.ezvendorapp.params.EziPurchaseOrderParams timeStampParams= new ezc.ezvendorapp.params.EziPurchaseOrderParams();
            ezcContainer.setLocalStore("Y");
            timeStampParams.setDocType("POUPDATEDDATE");
            timeStampParams.setSysKey(defCatArea);
            timeStampParams.setSoldTo(defErpVendor.trim());
            ezcContainer.setObject(timeStampParams);
            Session.prepareParams(ezcContainer);
            ezc.ezparam.ReturnObjFromRetrieve retDate=(ezc.ezparam.ReturnObjFromRetrieve)AppManager.ezGetVendorTimeStamp(ezcContainer);
            java.util.Date toDay=new java.util.Date();
            toDay.setMonth(toDay.getMonth()-2);
            java.sql.Date FromDate=new java.sql.Date(toDay.getYear(),toDay.getMonth(),toDay.getDay());
            
            ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
            if(retDate.getRowCount()>0)
            {
                        String lastLoginDate 	= formatDate.getStringFromDate((java.util.Date)retDate.getFieldValue(0,"DOCDATE"),"/",FormatDate.MMDDYYYY);
                        int dateArray[]      	= formatDate.getMMDDYYYY(lastLoginDate,true);
                        dateArray[0]           	= dateArray[0]-1;             
                        FromDate              = new java.sql.Date(dateArray[2]-1900,dateArray[0]-2,dateArray[1]);
                        //FromDate               	= new java.sql.Date(dateArray[2]-1900,dateArray[0],dateArray[1]);
            }
            else
            {
                        ezc.ezparam.EzcParams aParams = new ezc.ezparam.EzcParams(false);
                        ezc.ezvendorapp.params.EzVendorTimeStampStructure addtimeStampParams= new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
                        aParams.setLocalStore("Y");
                        addtimeStampParams.setAuthKey("POUPDATEDDATE");
                        addtimeStampParams.setSysKey(defCatArea);
                        addtimeStampParams.setSoldTo(defErpVendor.trim());
                        addtimeStampParams.setExt1("");
                        addtimeStampParams.setExt2("");
                        aParams.setObject(addtimeStampParams);
                        Session.prepareParams(aParams);
                        AppManager.ezAddVendorTimeStamp(aParams);
            }
                  
            
            
            
            
	ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
	ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
	ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	snkparams1.setSystemKey(defCatArea);
	snkparams1.setSiteNumber(200);
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);
	String myPurGrp="";
	String myPurOrg="";
	if(retdef!=null){
		    for(int d=0;d<retdef.getRowCount();d++){
				if("PURGROUP".equals(retdef.getFieldValueString(d,"ECAD_KEY"))){
					    myPurGrp=retdef.getFieldValueString(d,"ECAD_VALUE");
				}else if("PURORG".equals(retdef.getFieldValueString(d,"ECAD_KEY"))){
					    myPurOrg=retdef.getFieldValueString(d,"ECAD_VALUE");
				}
		    }

	}
	
	
	
	myPurGrp=(String)Session.getUserPreference("PURGROUP");
	if(myPurGrp!=null)
	    myPurGrp=(myPurGrp.toUpperCase()).trim();
	
	
	
	/*********************DRL--START********************************/
	
	
	
	int blkdPOsInLDBCnt = 0,amndPOsInSAPCnt = 0;
	String blkdDocNo = "",amndPONo = "",tmpPurGrp = "ALL",poVendor = "",poStatus = "";

	ezc.ezvendorapp.params.EzPOAcknowledgementTable updatePOsTab = null;
	ezc.ezvendorapp.params.EzPOAcknowledgementTableRow addToBeAckTabRow =  null;
	ezc.ezvendorapp.params.EzPOAcknowledgementTableRow blkdPOsTabRow =  null;
	ezc.ezparam.EzcParams toBeAckPOsContainer = new ezc.ezparam.EzcParams(true);
	ezc.ezparam.EzcParams toBeblkdPOsContainer = new ezc.ezparam.EzcParams(true);

	java.util.Vector blkdPOsVect = new java.util.Vector();
	java.util.Vector amndPOsInSAPVect = new java.util.Vector();
	java.util.Vector unBlkdPOsVect = new java.util.Vector();
	
	java.util.Date toDayDate = new java.util.Date();
	//java.sql.Date FromDateForBlkdPOs       = new java.sql.Date((toDayDate.getYear())-1,toDayDate.getMonth(),toDayDate.getDay());
	java.sql.Date FromDateForBlkdPOs       = new java.sql.Date((toDayDate.getYear()),toDayDate.getMonth(),toDayDate.getDay()-120);
	
	
	//out.println(":::FromDateForBlkdPOs:::::"+FromDateForBlkdPOs);
	
	java.text.SimpleDateFormat dtformat=new java.text.SimpleDateFormat("dd/MM/yyyy");
	java.util.Date todaydt = new java.util.Date();
	String crtdOn= dtformat.format(todaydt);


	ezc.ezparam.EzcParams blkdPOsContainer = new ezc.ezparam.EzcParams(true);
	ezc.ezvendorapp.params.EziPurchaseOrderParams iPOParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
	if(!"ALL".equalsIgnoreCase(myPurGrp))
		iPOParams.setSysKey(defCatArea+"' AND EZPA_EXT1='"+myPurGrp+"' AND EZPA_SOLD_TO= '"+defErpVendor);
	else
		iPOParams.setSysKey(defCatArea+"' AND EZPA_SOLD_TO= '"+defErpVendor);

	blkdPOsContainer.setLocalStore("Y");
	blkdPOsContainer.setObject(iPOParams);
	Session.prepareParams(blkdPOsContainer);
	ReturnObjFromRetrieve allBlkdPOsInLDB= (ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(blkdPOsContainer);

	if(allBlkdPOsInLDB != null)
		blkdPOsInLDBCnt = allBlkdPOsInLDB.getRowCount();

	if(blkdPOsInLDBCnt > 0)
	{
		for(int b=0;b<blkdPOsInLDBCnt;b++)
		{
			blkdDocNo = allBlkdPOsInLDB.getFieldValueString(b,"DOCNO");
			poStatus  = allBlkdPOsInLDB.getFieldValueString(b,"DOCSTATUS");
			
			
			if(blkdDocNo!=null)
				blkdDocNo = blkdDocNo.trim();
			if(poStatus!=null)
				poStatus = poStatus.trim();
			
			if("B".equals(poStatus))
                        	blkdPOsVect.addElement(blkdDocNo);
                        else
                        	unBlkdPOsVect.addElement(blkdDocNo);	
		}
	}


	if(!"3".equals(userType))
		tmpPurGrp = myPurGrp;
		
		ezc.ezcommon.EzLog4j.log("FromDateForBlkdPOs>>"+FromDateForBlkdPOs,"I");
		ezc.ezcommon.EzLog4j.log("FromDate>>"+FromDate,"I");

	EzPurchHdrXML amndPOsInSAP = getRetObj(Session,FromDateForBlkdPOs,"","UNREL","A",tmpPurGrp,myPurOrg);
	
	/*amndPOsInSAP.toEzcString();
	
	amndPOsInSAP.setFieldValue("ORDER","0480000002");
	amndPOsInSAP.setFieldValue("VENDOR_NUMBER","0000000013");
	amndPOsInSAP.addRow();

	amndPOsInSAP.setFieldValue("ORDER","0490000001");
	amndPOsInSAP.setFieldValue("VENDOR_NUMBER","0000000013");
	amndPOsInSAP.addRow();

	amndPOsInSAP.setFieldValue("ORDER","0400000564");
	amndPOsInSAP.setFieldValue("VENDOR_NUMBER","0000000013");
	amndPOsInSAP.addRow();

	amndPOsInSAP.setFieldValue("ORDER","0400000565");
	amndPOsInSAP.setFieldValue("VENDOR_NUMBER","0000000013");
	amndPOsInSAP.addRow();
	*/
	
	//out.println("****amndPOsInSAP****"+amndPOsInSAP.getRowCount());
	//out.println(amndPOsInSAP.toEzcString());
	

	if(amndPOsInSAP != null)
		amndPOsInSAPCnt = amndPOsInSAP.getRowCount();

	if(amndPOsInSAPCnt > 0)
	{
		updatePOsTab = new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
		for(int a=0;a<amndPOsInSAPCnt;a++)
		{
			amndPONo = amndPOsInSAP.getFieldValueString(a,"ORDER");
			poVendor = amndPOsInSAP.getFieldValueString(a,"VENDOR_NUMBER");
			
			if(poVendor!=null) 
				poVendor = poVendor.trim();
			
			if(defErpVendor!=null)
				defErpVendor = defErpVendor.trim();
			
			if(poVendor!=null && poVendor.equals(defErpVendor))
			{
				if(amndPONo!=null)
					amndPONo = amndPONo.trim();

				if(!amndPOsInSAPVect.contains(amndPONo))
				{
					amndPOsInSAPVect.add(amndPONo);
					
					if(!blkdPOsVect.contains(amndPONo) && unBlkdPOsVect.contains(amndPONo))
					{
						blkdPOsTabRow = new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();

						blkdPOsTabRow.setDocNo(amndPONo);
						blkdPOsTabRow.setDocStatus("B");
						blkdPOsTabRow.setModifiedOn(crtdOn);

						updatePOsTab.appendRow(blkdPOsTabRow);
					}	

				}	
			}
		}
		
		toBeblkdPOsContainer.setLocalStore("Y");
		toBeblkdPOsContainer.setObject(updatePOsTab);
		Session.prepareParams(toBeblkdPOsContainer);
		if(updatePOsTab.getRowCount()>0)
			AppManager.ezUpdatePOAcknowledgement(toBeblkdPOsContainer);
	}

               
	

	blkdPOsVect.removeAll(amndPOsInSAPVect);
	
	//out.println(blkdPOsVect);

	if(blkdPOsVect.size()>0)
	{
		updatePOsTab = new ezc.ezvendorapp.params.EzPOAcknowledgementTable();

		for(int x=0;x<blkdPOsVect.size();x++)
		{
			addToBeAckTabRow = new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();

			addToBeAckTabRow.setDocNo((String)blkdPOsVect.get(x));
			addToBeAckTabRow.setDocStatus("X");
			addToBeAckTabRow.setModifiedOn(crtdOn);
			addToBeAckTabRow.setExt2("DELDS");

			updatePOsTab.appendRow(addToBeAckTabRow);
		}	

		ezc.ezcommon.EzLog4j.log("Jagan After::::::::::::::::::::","I");
		toBeAckPOsContainer.setLocalStore("Y");
		toBeAckPOsContainer.setObject(updatePOsTab);
		Session.prepareParams(toBeAckPOsContainer);
		AppManager.ezUpdatePOAcknowledgement(toBeAckPOsContainer);
	}
	
	
	
	    	
	/*********************DRL--END********************************/

                        
         /********    To get Vendor Time stamp(Last Login Time) from Local DB START    *********/
            
            
            
            
            
            ezcContainer = new ezc.ezparam.EzcParams(true);
            ezc.ezvendorapp.params.EziPurchaseOrderParams iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
            if(!"ALL".equalsIgnoreCase(myPurGrp))
            iParams.setSysKey(defCatArea+"'AND EZPA_EXT1='"+myPurGrp+"' AND EZPA_SOLD_TO= '"+defErpVendor);
            else
            iParams.setSysKey(defCatArea+"' AND EZPA_SOLD_TO= '"+defErpVendor);
            
            ezcContainer.setLocalStore("Y");
            ezcContainer.setObject(iParams);
            Session.prepareParams(ezcContainer);
            ezc.ezcommon.EzLog4j.log("TO BE ACK POS CALL START>>","I");
            ReturnObjFromRetrieve allPOsInLDB= (ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(ezcContainer);
            ezc.ezcommon.EzLog4j.log("TO BE ACK POS CALL END>>","I");
            ezc.ezcommon.EzLog4j.log("allPOsInLDB>>"+allPOsInLDB.getRowCount(),"I");
            
            int allPOsInLDBCount=0;
            
            if(allPOsInLDB!=null)
            allPOsInLDBCount=allPOsInLDB.getRowCount();
            
            java.util.Vector unrelConVect=new java.util.Vector();
            java.util.Vector conBlockSuppVect=new java.util.Vector();
            java.util.Vector unrelPOVect=new java.util.Vector();
            java.util.Vector poBlockSuppVect=new java.util.Vector();
            java.util.Vector allDocVect=new java.util.Vector();
            
            java.util.Vector workFlowDocVect=new java.util.Vector();
            java.util.Vector poAmendVect=new java.util.Vector();
            java.util.Vector conAmendVect=new java.util.Vector();
            
            
            int toAckPOCount=0;
            int blockedPOCount=0;
            
            String docNo   ="";
            String docStatus = "";
            for(int i=0;i<allPOsInLDBCount;i++){
                        docNo=allPOsInLDB.getFieldValueString(i,"DOCNO");
                        docStatus=allPOsInLDB.getFieldValueString(i,"DOCSTATUS");
                        allDocVect.addElement(docNo);
                        if(docStatus!=null) docStatus=docStatus.trim();
                        if("M".equals(docStatus))
                        unrelConVect.addElement(docNo);
                        else if("K".equals(docStatus))
                        conBlockSuppVect.addElement(docNo);
                        else if("B".equals(docStatus))
                        unrelPOVect.addElement(docNo);
                        else if("P".equals(docStatus))
                        {
                                    blockedPOCount++;
                                    poBlockSuppVect.addElement(docNo);
                        }           
                        else if("X".equals(docStatus) && defErpVendor.equals(allPOsInLDB.getFieldValueString(i,"EXT1")))  
                        toAckPOCount++;
 
            }
                         
            ReturnObjFromRetrieve retWfobj= getWFObj(userRole,Session,defCatArea,myTemplate,userGroup,"CON",userId,sessionRole);
            int retWfobjCount= 0 ;
            if(retWfobj != null)
            retWfobjCount = retWfobj.getRowCount();
            
            
            
            
            for(int i=0;i<retWfobjCount;i++){
                        String wfDocStat=retWfobj.getFieldValueString(i,"STATUS");
                        String wfDocNo=retWfobj.getFieldValueString(i,"DOCID");
                        if(wfDocStat!=null) wfDocStat=wfDocStat.trim();
                                                
                        if("PO_RELEASE".equals(retWfobj.getFieldValueString(i,"AUTHKEY")) && unrelPOVect.contains(wfDocNo)){
                                    poAmendVect.add(wfDocNo);
                        }else if("CON_RELEASE".equals(retWfobj.getFieldValueString(i,"AUTHKEY")) && unrelConVect.contains(wfDocNo)){
                                    conAmendVect.add(wfDocNo);
                        }
                        
                        workFlowDocVect.add(wfDocNo);
            }
            
            
            
           
            
            
            //FromDate=  new java.sql.Date(107,0,1);            
            EzPurchHdrXML conRelHdrXML =new EzPurchHdrXML();//getRetObj(Session,FromDate,"K","REL","N",myPurGrp,myPurOrg);
            EzPurchHdrXML poRelHdrXML = getRetObj(Session,FromDate,"F","REL","N",myPurGrp,myPurOrg);
            
            //out.println(poRelHdrXML.toEzcString());
            
            EzPurchHdrXML unrelHdrXML =new EzPurchHdrXML();// getRetObj(Session,FromDate,"","UNREL","A",myPurGrp,myPurOrg);
            
            //out.println("===========>"+poRelHdrXML.toEzcString());
            
            java.util.Hashtable retObjHash=new java.util.Hashtable();
            retObjHash.put("UNREL",unrelHdrXML);
            retObjHash.put("POREL",poRelHdrXML);
            retObjHash.put("CONREL",conRelHdrXML);
            
            int conRelHdrXMLCount=0;
            int poRelHdrXMLCount=0;
            int unrelHdrXMLCount=0;
            
            if(conRelHdrXML!=null)
            conRelHdrXMLCount=conRelHdrXML.getRowCount();
            if(poRelHdrXML!=null)
            poRelHdrXMLCount=poRelHdrXML.getRowCount();
            if(unrelHdrXML!=null)
            unrelHdrXMLCount=unrelHdrXML.getRowCount();
            
            for(int i=0;i<unrelHdrXMLCount;i++)
            {
                        String docType = unrelHdrXML.getFieldValueString(i,"ORDERTYPE");
                        String docNum = unrelHdrXML.getFieldValueString(i,"ORDER");
                        String docAmdStat=unrelHdrXML.getFieldValueString(i,"RECORDSTATUS");
                        String sapVend =(unrelHdrXML.getFieldValueString(i,"VENDOR_NUMBER")).trim();
                        if("U".equals(docAmdStat)||"I".equals(docAmdStat))
                        {
                                    if(workFlowDocVect.contains(docNum)){
                                                if(loginUsrSoldtos.contains(sapVend))
                                                {
                                                            if("F".equals(docType)){
                                                                        if(!poAmendVect.contains(docNum))
                                                                        poAmendVect.add(docNum);
                                                            }else{
                                                                        if(!conAmendVect.contains(docNum))
                                                                        conAmendVect.add(docNum);
                                                            }
                                                }           
                                                            
                                    }
                        }           
                        
                        
                        
            }
            
                        
            
            /*******out.println("conRelHdrXMLCount==========>"+conRelHdrXML.getRowCount());
            out.println("poRelHdrXMLCount===========>"+poRelHdrXML.getRowCount());
            out.println("unrelHdrXMLCount===========>"+unrelHdrXML.getRowCount());*********/
            
            
            ezc.ezparam.ReturnObjFromRetrieve listTemplateRet = getWFHierarchy(Session,defCatArea,myTemplate);
            String userGroupKey="";
            String checkRole = "";
            
            if(listTemplateRet != null)
            {
                        userGroupKey = (listTemplateRet.getFieldValueString(0,"OWNERPARTICIPANT")).trim();
                        checkRole    = (listTemplateRet.getFieldValueString(0,"ROLE")).trim();
            }
            
            /********************************************************
                                    Work Flow Initialization
            *********************************************************/
            
             ezc.ezparam.EzcParams ezcParams = new ezc.ezparam.EzcParams(false);
             ezc.ezworkflow.params.EziWFParams eziWfparams       = new ezc.ezworkflow.params.EziWFParams();
             ezc.ezworkflow.params.EziWFDocHistoryParams eziWfDocHis = new ezc.ezworkflow.params.EziWFDocHistoryParams();
             eziWfparams.setRole(checkRole);
             eziWfDocHis.setStatus("Blocked");
             eziWfDocHis.setSysKey(defCatArea);
             eziWfDocHis.setTemplateCode(myTemplate);
             eziWfDocHis.setModifiedBy(userId);
             eziWfDocHis.setCreatedBy(userId);
             eziWfDocHis.setAction("100066");
            // eziWfDocHis.setSoldTo(defErpVendor+"#N");
             eziWfDocHis.setParticipant(userGroupKey);
             eziWfparams.setParticipant(userGroupKey);
 
 
 
 
            /*********************************************************/
 
            
            ezc.ezvendorapp.params.EzPOAcknowledgementTable addAckTab=new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
            ezc.ezvendorapp.params.EzPOAcknowledgementTable updateAckTab=new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
            ezc.ezvendorapp.params.EzPOAcknowledgementTableRow addAckTabRow=null;
            ezc.ezvendorapp.params.EzPOAcknowledgementTableRow updateAckTabRow=null;
            ezc.ezvendorapp.params.EzVendorTimeStampStructure ackTimeStamp=new ezc.ezvendorapp.params.EzVendorTimeStampStructure();
            
            String myOrderDate = "";
            
            java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd/MM/yyyy");
            java.util.Date dt = new java.util.Date();
            String createdOn= sdf.format(dt);//formatDate.getStringFromDate(new java.util.Date(),"/",FormatDate.DDMMYYYY);
            
            
            java.util.Enumeration enum=retObjHash.keys();
            
            while(enum.hasMoreElements())
            {
                        
                       

                        String myKey=(String)enum.nextElement();
                        int temHdrXMLCount=0;
                        EzPurchHdrXML temHdrXML= (EzPurchHdrXML)retObjHash.get(myKey);
                        if(temHdrXML!=null) temHdrXMLCount=temHdrXML.getRowCount();
                        
                        for(int i=0;i<temHdrXMLCount;i++){
                                    boolean addAckflg=false;
                                    boolean updateAckflg=false;
                                    
                                    boolean docContains=false;
                                    String tempDocNo  = temHdrXML.getFieldValueString(i,"ORDER");
                                    String tempSapVend=(temHdrXML.getFieldValueString(i,"VENDOR_NUMBER")).trim();
                                    String tempRecStat=(temHdrXML.getFieldValueString(i,"RECORDSTATUS"));
                                    String tempOrdType=(temHdrXML.getFieldValueString(i,"ORDERTYPE"));
                                    String tempOrdGrp=(temHdrXML.getFieldValueString(i,"PURGRP"));
                                    if(tempOrdGrp!=null)
                                    tempOrdGrp=(tempOrdGrp.toUpperCase()).trim();
                                    
                                   
                                   
                                    myOrderDate= formatDate.getStringFromDate((java.util.Date)temHdrXML.getFieldValue(i,"ORDERDATE"),"/",FormatDate.DDMMYYYY);
                                    if(tempRecStat==null||"null".equals(tempRecStat)) tempRecStat="";
                                    
                                    //if(!loginUsrSoldtos.contains(tempSapVend))
                                    //continue;
                                    
                                    docContains=allDocVect.contains(tempDocNo);   
                                    addAckTabRow =  new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();
                                    
                                    addAckTabRow.setSysKey(defCatArea);
                                    addAckTabRow.setSoldTo(tempSapVend);
                                    addAckTabRow.setDocNo(tempDocNo);
                                    addAckTabRow.setDocDate(myOrderDate);
                                    
                                    addAckTabRow.setCreatedOn(createdOn);
                                    addAckTabRow.setModifiedOn(createdOn);
                                    addAckTabRow.setCreatedBy(Session.getUserId());
                                    addAckTabRow.setModifiedOn(createdOn);
                                    addAckTabRow.setHeaderText("");
                                    addAckTabRow.setExt1(tempOrdGrp);
                                    addAckTabRow.setExt2("");
                                    addAckTabRow.setExt3(tempRecStat);
                                    
                                    
                                      
                                    
                                    
                                    if("UNREL".equals(myKey)){
                                                if("F".equals(tempOrdType)){
                                                            addAckTabRow.setDocStatus("B");
                                                            if(!docContains){
                                                                        unrelPOVect.add(tempDocNo);
                                                                        addAckflg=true;
                                                            }else if(docContains && !unrelPOVect.contains(tempDocNo)){
                                                                        unrelPOVect.add(tempDocNo);
                                                                        if(poBlockSuppVect.contains(tempDocNo))
                                                                        poBlockSuppVect.remove(tempDocNo);
                                                                        updateAckflg=true;
                                                            }
                                                            
                                                            if(updateAckflg || addAckflg){
                                                                        if(!poAmendVect.contains(tempDocNo)&&("Y".equals((String)session.getValue("FIRST"))))
                                                                        poAmendVect.add(tempDocNo);
                                                                        
                                                                        eziWfDocHis.setDocId(tempDocNo);
                                                                        eziWfDocHis.setAuthKey("PO_RELEASE");
                                                                        eziWfDocHis.setSoldTo(tempSapVend+"#N");
                                                                        if(updateAckflg)
                                                                                    eziWfDocHis.setComments("DELETE");
                                                                        
                                                                        ezcParams.setObject(eziWfparams);
                                                                        ezcParams.setObject(eziWfDocHis);
                                                                        Session.prepareParams(ezcParams);
                                                                        
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                }else{
                                                            addAckTabRow.setDocStatus("M");
                                                            if(!docContains){
                                                                        unrelConVect.add(tempDocNo);
                                                                        addAckflg=true;
                                                            }else if(docContains && !unrelConVect.contains(tempDocNo)){
                                                                        unrelConVect.add(tempDocNo);
                                                                        if(conBlockSuppVect.contains(tempDocNo))
                                                                        conBlockSuppVect.remove(tempDocNo);
                                                                        updateAckflg=true;
                                                                        
                                                            }
                                                            if(updateAckflg || addAckflg){
                                                                        if(!conAmendVect.contains(tempDocNo)&&("Y".equals((String)session.getValue("FIRST"))))
                                                                        conAmendVect.add(tempDocNo);
                                                                        eziWfDocHis.setDocId(tempDocNo);
                                                                        eziWfDocHis.setAuthKey("CON_RELEASE");
                                                                        eziWfDocHis.setSoldTo(tempSapVend+"#N");
                                                                        if(updateAckflg)
                                                                        eziWfDocHis.setComments("DELETE");
 
                                                                        ezcParams.setObject(eziWfparams);
                                                                        ezcParams.setObject(eziWfDocHis);
                                                                        Session.prepareParams(ezcParams);
                                                                                                                        
                                                            }
                                                }           
                                                            
                                                if(updateAckflg || addAckflg){
                                                            ezc.ezparam.ReturnObjFromRetrieve retPoWorkFlow = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.updateWFDoc(ezcParams);     
                                                            eziWfDocHis.setComments("");
                                                }
                                                
                                    }else if("POREL".equals(myKey)){
                                                addAckTabRow.setDocStatus("X");
                                                if(!docContains){
                                                            poBlockSuppVect.add(tempDocNo);
                                                            addAckflg=true;
                                                            toAckPOCount++;
                                                            
                                                }else if(docContains && unrelPOVect.contains(tempDocNo)){
                                                            poBlockSuppVect.add(tempDocNo);
                                                            unrelPOVect.remove(tempDocNo);
                                                            poAmendVect.remove(tempDocNo);
                                                            updateAckflg=true;
                                                            
                                                }
                                                
                                    }else if("CONREL".equals(myKey)){
                                                addAckTabRow.setDocStatus("K");
                                                if(!docContains){
                                                            conBlockSuppVect.add(tempDocNo);
                                                            addAckflg=true;
                                                }else if(docContains && unrelConVect.contains(tempDocNo)){
                                                            conBlockSuppVect.add(tempDocNo);
                                                            unrelConVect.remove(tempDocNo);
                                                            conAmendVect.remove(tempDocNo);
                                                            updateAckflg=true;
                                                            
                                                }
                                                
                                    }
                                                
                                    if(addAckflg){
        addAckTab.appendRow(addAckTabRow);
      }else if(updateAckflg){
        updateAckTab.appendRow(addAckTabRow);
        
      }
      if(addAckflg || updateAckflg){
        if("".equals(myAuditDocNos))
          myAuditDocNos=tempDocNo;
        else
          myAuditDocNos +="','"+tempDocNo;
      }  
                                    
                                    
                        }
            }
                        
            if(addAckTab.getRowCount()>0)
            {
                        ezcContainer = new ezc.ezparam.EzcParams(true);
                        ackTimeStamp.setExt1("");
                        ackTimeStamp.setExt2("");
                        ackTimeStamp.setAuthKey("POUPDATEDDATE");
                        ackTimeStamp.setSysKey(defCatArea);
                        ackTimeStamp.setSoldTo(defErpVendor.trim());
                        ackTimeStamp.setFlag("Y");
                        ezcContainer.setLocalStore("Y");
                        ezcContainer.setObject(addAckTab);
                        ezcContainer.setObject(ackTimeStamp);
                        Session.prepareParams(ezcContainer);
                        ReturnObjFromRetrieve retAdd= (ReturnObjFromRetrieve)AppManager.ezAddPOAcknowledgement(ezcContainer);
            }
            if(updateAckTab.getRowCount()>0)
            {           
                        ezcContainer = new ezc.ezparam.EzcParams(true);
                        ezcContainer.setLocalStore("Y");
                        ezcContainer.setObject(updateAckTab);
                        Session.prepareParams(ezcContainer);
                        ReturnObjFromRetrieve retAmendPos= (ReturnObjFromRetrieve)AppManager.ezUpdatePOAcknowledgement(ezcContainer);
            }
  
  
            java.util.Hashtable myAuditHT=new java.util.Hashtable();
            if(!"".equals(myAuditDocNos)){
            ezcContainer = new ezc.ezparam.EzcParams(true);
        ezcContainer.setLocalStore("Y");
        EziWFAuditTrailParams eziWFHistoryParams= new EziWFAuditTrailParams();
        eziWFHistoryParams.setEwhDocId(myAuditDocNos);
        ezcContainer.setObject(eziWFHistoryParams);
        Session.prepareParams(ezcContainer);
        ReturnObjFromRetrieve auditNoRetObj = (ReturnObjFromRetrieve)PreProManager.ezGetWFAuditTrailNo(ezcContainer);
        
        if(auditNoRetObj!=null){
          for(int i=0;i<auditNoRetObj.getRowCount();i++){
            myAuditHT.put(auditNoRetObj.getFieldValueString(i,"DOC_NO"),auditNoRetObj.getFieldValueString(i,"AUDIT_NO"));
          }
        }
        
        EziWFAuditTrailTable myAuditTab = new EziWFAuditTrailTable();
        EziWFAuditTrailTableRow myAuditTabRow = null;   
        
       String myAuditDocTemp="";
       String myAuditDocType="";
       String myAuditDocComment="";
       String myAuditNoTemp="";
       
       java.util.Hashtable commentHT=new java.util.Hashtable();
       commentHT.put("P","PO Released in SAP and blocked for supplier in Portal On "+createdOn);
      // commentHT.put("B","Unreleased PO in SAP picked by portal for approval On "+createdOn);
       commentHT.put("K","Contract Released in SAP and blocked for supplier in Portal On "+createdOn);
      // commentHT.put("M","Unreleased Contract in SAP picked by portal for approval On "+createdOn);
       EzPOAcknowledgementTable myAckTab=new EzPOAcknowledgementTable();
       for(int tabs=0;tabs<2;tabs++){
       
         if(tabs==0) myAckTab=addAckTab;
         else myAckTab=updateAckTab;
         
         for(int i=0;i<myAckTab.getRowCount();i++){
          addAckTabRow=(EzPOAcknowledgementTableRow)myAckTab.getRow(i);
          myAuditDocTemp=addAckTabRow.getDocNo();
          myAuditDocType=addAckTabRow.getDocStatus();
          myAuditNoTemp=(String)myAuditHT.get(myAuditDocTemp);
          if(commentHT.get(myAuditDocType) != null)
             {
          if(myAuditNoTemp==null||"null".equals(myAuditNoTemp)|| "".equals(myAuditNoTemp.trim())) myAuditNoTemp="1";
          myAuditTabRow=new EziWFAuditTrailTableRow();
          myAuditTabRow.setEwhAuditTrailNo(myAuditNoTemp);
          myAuditTabRow.setEwhDocId(myAuditDocTemp);
          myAuditTabRow.setEwhType("SUBMITTED");
          myAuditTabRow.setEwhSourceParticipant(userGroupKey);
          myAuditTabRow.setEwhSourceParticipantType("G");
          myAuditTabRow.setEwhDestParticipant(userGroupKey);
          myAuditTabRow.setEwhDestParticipantType("G");
          myAuditTabRow.setEwhComments((String)commentHT.get(myAuditDocType));
          myAuditTab.appendRow(myAuditTabRow);
          }
         }
       }
       
       
       if(myAuditTab.getRowCount()>0)
       {
            ezcContainer = new ezc.ezparam.EzcParams(true);
            ezcContainer.setLocalStore("Y");
            ezcContainer.setObject(myAuditTab);
            Session.prepareParams(ezcContainer);
            PreProManager.ezAddWFAuditTrail(ezcContainer);
       }
  }
            
            
            ezcContainer = new ezc.ezparam.EzcParams(false);
            ezcContainer.setLocalStore("Y");
            EziQcfCommentParams qcfCommentParams= new EziQcfCommentParams();
            qcfCommentParams.setQcfExt1("$$$");
            qcfCommentParams.setQcfDestUser(userId);
            qcfCommentParams.setQcfType("QUERY");
            qcfCommentParams.setQcfQueryMap("0");
            ezcContainer.setObject(qcfCommentParams);
            Session.prepareParams(ezcContainer);
            ReturnObjFromRetrieve qcfCommentRetObj = (ReturnObjFromRetrieve)PreProManager.getQcfCommentList(ezcContainer);
            if(qcfCommentRetObj!=null)
            qcfCommentCount=qcfCommentRetObj.getRowCount();
 
            /*********************START OF INTERNAL MAILS**********************/
              
              String temp="false";
                        ReturnObjFromRetrieve retMsgList = null;
                        ReturnObjFromRetrieve retFoldList = null;
                        String folderID="";
                        String folderName="";
                        String type="";
              
                        ezc.ezmail.EzcMailParams mailParams=new ezc.ezmail.EzcMailParams();
                        folderName = request.getParameter("FolderName");
                        if (folderName == null)
                                    folderName="Inbox";
                        mailParams.setFolderName(folderName);
              
                        type=request.getParameter("type");
                        if(type==null)
                        {
                                    type="allmess";
                        }
                        String language = "EN";
                        folderID = request.getParameter("FolderID");
                        if(folderID == null)
                        {
                                    folderID = "1000";
                        }
                        String client = "200";
                        EzcMessageParams  ezcMessageParams = new EzcMessageParams();
                        EzMessageParams ezMessageParams = new EzMessageParams();
                        ezMessageParams.setClient(client);
                        ezMessageParams.setToFolderId(folderID);
                        ezMessageParams.setLanguage(language);
                        ezcMessageParams.setObject(ezMessageParams);
                        Session.prepareParams(ezcMessageParams);
                        String newFlag = request.getParameter("msgFlag");
                        if (newFlag == null)
                        {
                                    newFlag = "0";
                        }
                        if(newFlag.equals("1"))
                        {
                                    //retMsgList = (ReturnObjFromRetrieve)Manager.getPersonalNewMsgHeader(ezcMessageParams);
                        }
                        else
                        {
                                  //retMsgList = (ReturnObjFromRetrieve)Manager.getPersonalAllMsgHeader(ezcMessageParams);
                        }
                        temp="false";
                        int MsgCount = 0;
                        if(retMsgList!=null)
                        {
                        for (int i = 0 ; i < retMsgList.getRowCount(); i++)
                        {
                                    if((retMsgList.getFieldValueString(i,NEW_MSG_FLAG)).equals("N"))
                                    {
                                                MsgCount++;
                                                
                                    }
                                    
                        }
                        }
                            
  /*********************END OF INTERNAL MAILS************************/
 
  /*********************START OF CURRENT AUCTIONS************************/           
            
            EzcParams mainAucParams = new EzcParams(false);
                        mainAucParams.setLocalStore("Y");
                        EziAuctionParams iAucParams = new EziAuctionParams();
                        String userAucType = (String)session.getValue("UserType");
            
                        //SimpleDateFormat sdfAuc  = new SimpleDateFormat("dd.MM.yyyy hh:mm:ss a");
            
                        if(userAucType.equals("3"))
                        {
                                    iAucParams.setSupplierCode(((String)session.getValue("SOLDTO")).trim());
                                    iAucParams.setStatus("A");
                                    iAucParams.setHeaderStatus("E");
                        }
                        else
                        {
                                    iAucParams.setHeaderStatus("E");
                        }
                        iAucParams.setAuctionCounter("CURRENT_RUN");
                        mainAucParams.setObject(iAucParams);
                        Session.prepareParams(mainAucParams);
            
                        ReturnObjFromRetrieve retAucobj = (ReturnObjFromRetrieve)AuctionManager.getAuctionsList(mainAucParams);
                        int currAucCount = 0;
                        if(retAucobj != null)
                                    currAucCount = retAucobj.getRowCount();
 
            //out.println("currAucCountcurrAucCount  "+currAucCount);
  /*********************END  OF CURRENT AUCTIONS************************/
  
  /*********************START OF TO BE Acknowledged AUCTIONS************************/      
            
            String status = "N";
            String headerstatus = "E";
            int AckAucCount = 0;
            if(userType.equals("3"))
            {
            
            EzcParams mainAckAucParams = new EzcParams(false);
            mainAckAucParams.setLocalStore("Y");
            EziAuctionParams iAckAucParams = new EziAuctionParams();
            iAckAucParams.setSupplierCode(((String)session.getValue("SOLDTO")).trim());
            iAckAucParams.setStatus(status);
            iAckAucParams.setHeaderStatus(headerstatus);
            mainAckAucParams.setObject(iAckAucParams);
            Session.prepareParams(mainAckAucParams);
            
            ReturnObjFromRetrieve retAckAucobj = (ReturnObjFromRetrieve)AuctionManager.getAuctionsList(mainAckAucParams);
            if(retAckAucobj!=null)
                        AckAucCount = retAckAucobj.getRowCount();
            }
            //out.println("AckAucCountAckAucCount  "+AckAucCount);
             /*********************END  OF TO BE Acknowledged AUCTIONS************************/
             
             /*********************Start of Schedule Agreements************************/
             
             int tobeAcknSACount = 0;
             
            // All SAs in Local Database
            ezcContainer = new ezc.ezparam.EzcParams(true);
            iParams =  new ezc.ezvendorapp.params.EziPurchaseOrderParams();
            iParams.setSysKey(defCatArea+"' AND EZDA_SOLD_TO= '"+defErpVendor);
            //iParams.setSoldTo(defErpVendor);
            iParams.setDocType("SA");
            ezcContainer.setLocalStore("Y");
            ezcContainer.setObject(iParams);
            Session.prepareParams(ezcContainer);
            ReturnObjFromRetrieve allSAsInLDB = (ReturnObjFromRetrieve)AppManager.ezGetPOAcknowledgement(ezcContainer);
                        ezc.ezcommon.EzLog4j.log("allSAsInLDB>>"+allSAsInLDB.getRowCount(),"I");

            Vector allSAsVector = new Vector();
            Vector toBeAcknSAsVector = new Vector();
            if(allSAsInLDB != null)
            {
            	int allSAsCount = allSAsInLDB.getRowCount(); 
            	for(int i=0;i<allSAsCount;i++)
            	{
            		String saDocNo = allSAsInLDB.getFieldValueString(i,"DOCNO");
            		if(!allSAsVector.contains(saDocNo))
            		{
            			allSAsVector.addElement(saDocNo);
            		}
            		if(!toBeAcknSAsVector.contains(saDocNo))
            		{
            			if("N".equals(allSAsInLDB.getFieldValueString(i,"DOCSTATUS")))
            			{
            				toBeAcknSAsVector.addElement(saDocNo);
            			}	
            		}
            		
            	}
            }
             tobeAcknSACount = toBeAcknSAsVector.size();
             // All Open SAs from SAPs
		EzPSIInputParameters iparams = new EzPSIInputParameters();
		ezc.ezparam.EzcPurchaseParams newParams = new ezc.ezparam.EzcPurchaseParams();
		ezc.ezpurcontract.params.EziPurchaseInputParams testParams = new ezc.ezpurcontract.params.EziPurchaseInputParams();
		testParams.setFromDate(FromDate);
		newParams.createContainer();
		newParams.setObject(testParams);
		newParams.setObject(iparams);
		Session.prepareParams(newParams);
		ezc.ezcommon.EzLog4j.log("TO BE ACK SHEDULE AGREEMENTS SAP CALL START>>","I");
		EzPurchCtrHdrXML purchctrhdr = (EzPurchCtrHdrXML)PoManager.ezOpenPurchaseContractList(newParams);
		ezc.ezcommon.EzLog4j.log("TO BE ACK SHEDULE AGREEMENTS SAP CALL END>>","I");
            ezc.ezcommon.EzLog4j.log("purchctrhdr>>"+purchctrhdr.getRowCount(),"I");

		if(purchctrhdr != null)
		{
			int sapSACount = purchctrhdr.getRowCount();
			for(int i=sapSACount-1; i>=0 ; i--)
			{
				if (allSAsVector.contains(purchctrhdr.getFieldValueString(i,"CONTRACT")))
				{
					purchctrhdr.deleteRow(i);
				}
			}
			sapSACount = purchctrhdr.getRowCount();
			if(sapSACount > 0)
			{
				ezc.ezvendorapp.params.EzPOAcknowledgementTable addDocAckTab = new ezc.ezvendorapp.params.EzPOAcknowledgementTable();
				ezc.ezvendorapp.params.EzPOAcknowledgementTableRow addDocAckTabRow = null;
				String contractDate = "";
				for(int i=0;i<sapSACount;i++)
				{
					contractDate = formatDate.getStringFromDate((java.util.Date)purchctrhdr.getFieldValue(i,"CONTRACTDATE"),"/",FormatDate.DDMMYYYY);
					addDocAckTabRow = new ezc.ezvendorapp.params.EzPOAcknowledgementTableRow();
					addDocAckTabRow.setSysKey(defCatArea);
					addDocAckTabRow.setSoldTo(defErpVendor);
					addDocAckTabRow.setDocNo(purchctrhdr.getFieldValueString(i,"CONTRACT"));
					addDocAckTabRow.setDocType("SA");
					addDocAckTabRow.setDocDate(contractDate);
					addDocAckTabRow.setDocStatus("N");
					addDocAckTabRow.setCreatedOn(createdOn);
					addDocAckTabRow.setCreatedBy(Session.getUserId());
					addDocAckTabRow.setModifiedOn(createdOn);
					addDocAckTabRow.setHeaderText("");
					addDocAckTabRow.setExt1(purchctrhdr.getFieldValueString(i,"NETAMOUNT"));
					addDocAckTabRow.setExt2(purchctrhdr.getFieldValueString(i,"CURRENCY"));
					addDocAckTabRow.setExt3("");
					addDocAckTab.appendRow(addDocAckTabRow);
					tobeAcknSACount++;
				}
				
				ezcContainer = new ezc.ezparam.EzcParams(true);
				ezcContainer.setLocalStore("Y");
				ezcContainer.setObject(addDocAckTab);
				ezcContainer.setObject(ackTimeStamp);
				Session.prepareParams(ezcContainer);
				ReturnObjFromRetrieve retAdd = (ReturnObjFromRetrieve)AppManager.ezAddPOAcknowledgement(ezcContainer);
			}	
		}
             
             
             /*********************End of Schedule Agreements************************/
             
             
            
            if(poAmendVect!=null)
            poAmendCount=poAmendVect.size();
            
            if(poBlockSuppVect!=null)
            poBlockSuppCount=poBlockSuppVect.size();
            
            if(conAmendVect!=null)
            conAmendCount=conAmendVect.size();
            
            if(conBlockSuppVect!=null)
            conBlockSuppCount=conBlockSuppVect.size();
            
            session.putValue("amendPosSess",poAmendVect);
            session.putValue("poVendorView",poBlockSuppVect);
            session.putValue("amendConsSess",conAmendVect);
            session.putValue("contBlockView",conBlockSuppVect);
 
            String toBeInviteLink=prepareURL(toBeInvitedRFQCount,"../Rfq/ezListGenRFQs.jsp?type=Invite","RFQ(s) pending for invite");
            String toBeQuoteLink=prepareURL(toBeQuotedRFQCount,"../Rfq/ezListGenRFQs.jsp?type=ToBeQuote","RFQ(s) pending for Quote");
            
            String newQCFLink=prepareURL(newQCFCount,"../Rfq/ezListQCS.jsp?status=CR","QCF(s) To submit for approval");
            String toBeActQCFLink=prepareURL(toBeActQCFCount,"../Rfq/ezWFListQcfs.jsp?Type=N","QCF(s) To take action");
            
            String unrelPOLink=prepareURL(poAmendCount,"../Purorder/ezListBlockedPOs.jsp?type=Amend","PO(s) To release");
            String blockedPOLink=prepareURL(poBlockSuppCount,"../Purorder/ezListBlockedPOsInPortal.jsp","PO(s) Blocked for Supplier");
            
            String unrelConLink=prepareURL(conAmendCount,"../Purorder/ezListBlockedContracts.jsp?type=Contract","Contract(s) To release");
            String blockedConLink=prepareURL(conBlockSuppCount,"../Purorder/ezListBlockedContractsInPortal.jsp","Contract(s) Blocked for Supplier");
            
            String toBeAckPOLink=prepareURL(toAckPOCount,"../Purorder/ezListAcknowledgedPOs.jsp?type=NotAcknowledged","PO(s) To Acknowledge");
            String qcfCommentLink=prepareURL(qcfCommentCount,"../Misc/ezNewQcfQueries.jsp","Query(s) To Reply");
            String expQCFLink=prepareURL(expQCFCount,"../Rfq/ezListQCS.jsp?Type=E","QCF(s) Expired");
            
            String msgLink=prepareURL(MsgCount,"../Inbox/ezListPersMsgs.jsp?type=newmess"," New Mail(s)");
            
            String auctCurrLink=prepareURL(currAucCount,"../Request/ezListActiveAuctions.jsp"," Current Auctions");
            String auctAckLink=prepareURL(AckAucCount,"../Request/ezListAuctionRequests.jsp?type=New"," Auctions To Acknowledge");
            
            String toBeAcknSALink = prepareURL(tobeAcknSACount,"../Purorder/ezListScheduleAgreements.jsp?docStatus=N","To Acknowledge");
                        
            java.util.Vector rfqAlertVect=new java.util.Vector();
            java.util.Vector qcfAlertVect=new java.util.Vector();
            java.util.Vector poAlertVect=new java.util.Vector();
            java.util.Vector conAlertVect=new java.util.Vector();
            java.util.Vector qryAlertVect=new java.util.Vector();
            java.util.Vector loginDtlVect=new java.util.Vector();
            java.util.Vector scAgrDtlVect=new java.util.Vector();
            java.util.Vector auctVect=new java.util.Vector();
            
            
            if("2".equals(userType)){
                        rfqAlertVect.add(toBeQuoteLink);
                        qcfAlertVect.add(newQCFLink);
            }
            
            if(!"PP".equals(userRole) && ("PH".equals(userRole)))
            {
                        //poAlertVect.add(blockedPOLink);
                        conAlertVect.add(blockedConLink);
            }
            if("3".equals(userType)){
                        rfqAlertVect.add(toBeQuoteLink);
                        poAlertVect.add(toBeAckPOLink);
            }else{                
                        //poAlertVect.add(blockedPOLink);
                        poAlertVect.add(toBeAckPOLink);                       
            }
            
            java.util.Hashtable alertHash=new java.util.Hashtable();
            java.util.Vector disOrdVect=new java.util.Vector();
            if(rfqAlertVect.size()>0){
                        alertHash.put("RFQ",rfqAlertVect);
                        disOrdVect.add("RFQ");
            }
            disOrdVect.add("Auctions");
            alertHash.put("Auctions",auctVect);
                        
            if(poAlertVect.size()>0){
                        alertHash.put("PO",poAlertVect);
                        disOrdVect.add("PO");
            }
            
            if(tobeAcknSACount > 0)
            {
            	scAgrDtlVect.add("<b>"+toBeAcknSALink+"</b>");
            }
            else
            {
            	scAgrDtlVect.add("<b> No Agreements to acknowledge.");
            }	
            
            disOrdVect.add(" Schedule Agreements");
            alertHash.put(" Schedule Agreements",scAgrDtlVect);
            
            if(currAucCount==0 && AckAucCount==0)
                        auctVect.add("<b> No Auctions To Acknowledge <br> No Current Auctions.  ");
 
            else if(currAucCount>0 && AckAucCount==0)
                        auctVect.add("<b> No Auctions To Acknowledge  <br>"+auctCurrLink);
 
            else if(currAucCount==0 && AckAucCount>0)
                        auctVect.add("<b> "+auctAckLink +"<br> <b> No Current Auctions.");
 
            else if(currAucCount>0 && AckAucCount>0)
                        auctVect.add(auctAckLink+"<br>"+auctCurrLink);
            
            //disOrdVect.add("Mails");
            //alertHash.put("Mails",loginDtlVect);
            
	
	
%>
