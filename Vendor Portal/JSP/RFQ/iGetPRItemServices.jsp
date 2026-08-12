<%!
		/****************************/
		/*Input PR NUMBER*/				
		/*PRITEM*/
		/***************************/
		private ezc.ezparam.ReturnObjFromRetrieve getServices(String prNo,String prItem,ezc.session.EzSession Session){
		
			ezc.ezparam.ReturnObjFromRetrieve myRet = null;
				
			ezc.ezpreprocurement.client.EzPreProcurementManager cm=new ezc.ezpreprocurement.client.EzPreProcurementManager();
			ezc.ezpreprocurement.params.EziPreProcurementParams param=new ezc.ezpreprocurement.params.EziPreProcurementParams();
								
			param.setExt1("SERVICE");
			param.setPONum(prNo);
			param.setOpenItems(prItem);
					
				
			ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(true);
			mainParams.setObject(param);
			Session.prepareParams(mainParams);
			try
			{
				myRet=(ezc.ezparam.ReturnObjFromRetrieve)cm.ezGetPurchReqList(mainParams);
			}catch(Exception e){}
					
			return 	myRet;
		}	

		


%>