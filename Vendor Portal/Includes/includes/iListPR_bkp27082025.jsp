<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ page import ="java.util.*,ezc.ezbasicutil.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	ezc.ezcommon.EzLog4j.log("matlGrpObj>>"+matlGrpObj,"I");
	String Status = request.getParameter("Status");
	String fromDate = request.getParameter("fromDate");
	String toDate = request.getParameter("toDate");
	String relFromDate = request.getParameter("relFromDate");
	String relToDate = request.getParameter("relToDate"); 
	String prNum = request.getParameter("prNum"); 
	String prVer = request.getParameter("prVer"); 
	ezc.ezcommon.EzLog4j.log("prVer>>>"+prVer,"I");
	String days = request.getParameter("days"); 
	String daysStr = "-"+days;
	ezc.ezcommon.EzLog4j.log("==daysNew=="+days,"I");
	
	String toDtStr="";
	String fromDtStr="";
 	java.util.Date toDelDate = null;
 	java.util.Date fromDelDate = null;
 	if(fromDate == null || "null".equals(fromDate) || "".equals(fromDate))
 	{
 		Calendar cal = Calendar.getInstance();
 		Date toDateObj = cal.getTime();
 		toDtStr = convertDateObjToString(toDateObj);
 		toDelDate = convertStringToDateObj(toDtStr);

		//To fetch PR(s) older than 60/90 days(s)
 		
 		Date currDateObj = cal.getTime();
 		cal.add(Calendar.DAY_OF_MONTH,Integer.parseInt(daysStr));
 		Date fromDateObj = cal.getTime();
 		out.println("fromDateObj>>"+fromDateObj);
 		
 		fromDtStr = convertDateObjToString(fromDateObj);
 		out.println("fromDtStr>>"+fromDtStr);
 		fromDelDate = convertStringToDateObj(fromDtStr);
 	}  	

	java.util.Date fromDate1 = null;
	java.util.Date toDate1 = null;
	java.util.Date relFromDate1 = null;
	java.util.Date relToDate1 = null;
	
		
	if(!(fromDate==null || fromDate=="" || "".equals(fromDate)) || "null".equals(fromDate))
		fromDate1 = convertStringToDateObj(fromDate);
	if(!(toDate==null || toDate=="" || "".equals(toDate)) || "null".equals(toDate))
		toDate1 = convertStringToDateObj(toDate);
	
	if(!(relFromDate==null || relFromDate=="" || "".equals(relFromDate)) || "null".equals(relFromDate))
			relFromDate1 =convertStringToDateObj(relFromDate);
	if(!(relToDate==null || relToDate=="" || "".equals(relToDate)) || "null".equals(relToDate))
		relToDate1 = convertStringToDateObj(relToDate);
	
		
	ezc.ezcommon.EzLog4j.log("==fromDate=="+fromDate+"=fromDate1 "+fromDate1,"I");
	ezc.ezcommon.EzLog4j.log("==toDate=="+toDate+"=toDate1 "+toDate1,"I");
	ezc.ezcommon.EzLog4j.log("==relFromDate=="+relFromDate+"=relFromDate155555 "+relFromDate1,"I");
	ezc.ezcommon.EzLog4j.log("==relToDate=="+relToDate+"=relToDate1 "+relToDate1,"I");
	
	ezc.ezparam.EzcParams mainParams1=new ezc.ezparam.EzcParams(true);
	ezc.ezpreprocurement.client.EzPreProcurementManager cm=new ezc.ezpreprocurement.client.EzPreProcurementManager(); 
	
	Hashtable purGrpHT=new Hashtable();
	String pGrpArr[] = request.getParameterValues("purGrp");
	String purGrp="";
	if(pGrpArr!=null)
	{
		for(int i=0;i<pGrpArr.length;i++)
		{
			ezc.ezcommon.EzLog4j.log("pGrpArr>>>>>>> "+pGrpArr[i],"I");
			purGrp=pGrpArr[i];
			purGrpHT.put(purGrp,purGrp);
		}
	}
	
	String rNameArr[]	= request.getParameterValues("reqSr");
	String createdBy 	= request.getParameter("createdBy"); 
	String plant[] 		= request.getParameterValues("selplant");
	String docTypeArr[]     = request.getParameterValues("docType");
	String accCatArr[] 	= request.getParameterValues("accCat");
	String itemCatArr[]	= request.getParameterValues("itemCat");	
	String mrpArr[]		= request.getParameterValues("mrpCtl");
	String procArr[]	= request.getParameterValues("proStat");
	String matGrpArr[] 	= request.getParameterValues("matGrp");
	String fixVen 		= request.getParameter("fixVen"); 

	String trackNo 		= request.getParameter("trackNo"); 
	String prLow = request.getParameter("prLow"); 
	String prLowStr = "";
	try{
		
		prLowStr = "0000000000"+prLow;
		prLowStr = prLowStr.substring((prLowStr.length()-10),prLowStr.length());

	}
	catch(Exception e)
	{
		prLowStr = prLow;
	}	
	
	
	String prHigh = request.getParameter("prHigh"); 
	String prHighStr = "";
	try{
		
		prHighStr = "0000000000"+prHigh;
		prHighStr = prHighStr.substring((prHighStr.length()-10),prHighStr.length());

	}
	catch(Exception e)
	{
		prHighStr = prHigh;
	}	
	String prMulti = request.getParameter("prMulti"); 
	ezc.ezcommon.EzLog4j.log("prMulti>>>>>>> "+prMulti,"I");
	
	String matLow = request.getParameter("matLow"); 
	String matLowStr = "";
	try{
		
		matLowStr = "000000000000000000"+matLow;
		matLowStr = matLowStr.substring((matLowStr.length()-18),matLowStr.length());

	}
	catch(Exception e)
	{
		matLowStr = matLow;
	}	
	
	
	String matHigh = request.getParameter("matHigh"); 
	String matHighStr = "";
	try{
		
		matHighStr = "000000000000000000"+matHigh;
		matHighStr = matHighStr.substring((matHighStr.length()-18),matHighStr.length());

	}
	catch(Exception e)
	{
		matHighStr = matHigh;
	}		
	
	String matMulti = request.getParameter("matMulti"); 
	ezc.ezcommon.EzLog4j.log("matMulti>>>>>>> "+matMulti,"I");	
	
	java.util.Hashtable itmTxtHT=new java.util.Hashtable();
	java.util.Hashtable poTxtHT=new java.util.Hashtable();
	java.util.Hashtable servTxtHT=new java.util.Hashtable();
	java.util.Hashtable lineTxtHT=new java.util.Hashtable();	
	
	ezc.ezparam.ReturnObjFromRetrieve myRet= null;
	ezc.ezparam.ReturnObjFromRetrieve mySer= null;
	
	JCoFunction function = null;
	String systemKey = (String)session.getValue("SYSKEY");
	
	
	String logonSite = (String)session.getValue("SITE");
	
	

	
	int prCnt =0;
	int servCnt =0;
	//out.println("destination start>>>");
	try
	{
		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
		function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_PRS");

		JCoParameterList sapPreProc = function.getImportParameterList();
		JCoParameterList sapTabParam= function.getTableParameterList();
		
		//out.println("destination>>>"+destination);

		if(Status.equals("R"))
			sapPreProc.setValue("RELEASE_FLAG","Y");
		else
			sapPreProc.setValue("RELEASE_FLAG","N");
			
		
		
		//PURCHASE GROUP
		if(pGrpArr!=null)
		{
			JCoTable r_pGrp = sapTabParam.getTable("R_PUR_GROUP");	
			for(int i=0;i<pGrpArr.length;i++)
			{	
				r_pGrp.appendRow();
				r_pGrp.setValue("SIGN","I");
				r_pGrp.setValue("OPTION","EQ");
				r_pGrp.setValue("LOW",pGrpArr[i]);
				r_pGrp.setValue("HIGH","");
			}	
		}
		//MATERIAL GROUP
		if(matGrpArr!=null)
		{
			JCoTable r_matGrp = sapTabParam.getTable("R_MAT_GRP");	
			for(int j=0;j<matGrpArr.length;j++)
			{
				r_matGrp.appendRow();
				r_matGrp.setValue("SIGN","I");
				r_matGrp.setValue("OPTION","EQ");
				r_matGrp.setValue("LOW",matGrpArr[j]);
				r_matGrp.setValue("HIGH","");
			}		
		}	
		//PLANT
		if(plant!=null)
		{	
			JCoTable r_plant = sapTabParam.getTable("R_PLANT");	
			for(int q=0;q<plant.length;q++)
			{
				r_plant.appendRow();
				r_plant.setValue("SIGN","I");
				r_plant.setValue("OPTION","EQ");
				r_plant.setValue("LOW",plant[q]);
				r_plant.setValue("HIGH","");
			}	
		}
		//DOC TYPE
		if(docTypeArr!=null)
		{	
			JCoTable r_docType = sapTabParam.getTable("R_DOC_TYPE");	
			for(int r=0;r<docTypeArr.length;r++)
			{
				r_docType.appendRow();
				r_docType.setValue("SIGN","I");
				r_docType.setValue("OPTION","EQ");
				r_docType.setValue("LOW",docTypeArr[r]);
				r_docType.setValue("HIGH","");
			}	
		}

		//ACCOUNT ASSIGNMENT
		if(accCatArr!=null)
		{
			JCoTable r_acct = sapTabParam.getTable("R_ACC_ASS_CAT");	
			for(int k=0;k<accCatArr.length;k++)
			{
				r_acct.appendRow();
				r_acct.setValue("SIGN","I");
				r_acct.setValue("OPTION","EQ");
				r_acct.setValue("LOW",accCatArr[k]);
				r_acct.setValue("HIGH","");
			}			
		}
		//ITEM CATEGORY
		if(itemCatArr!=null)
		{	
			JCoTable r_itemCat = sapTabParam.getTable("R_ITEM_CATEGORY");
			for(int s=0;s<itemCatArr.length;s++)
			{
				if("U".equals(itemCatArr[s]))  
					itemCatArr[s] = "7";
				if("D".equals(itemCatArr[s]))  
					itemCatArr[s] = "9";

				r_itemCat.appendRow();
				r_itemCat.setValue("SIGN","I");
				r_itemCat.setValue("OPTION","EQ");
				r_itemCat.setValue("LOW",itemCatArr[s]);
				r_itemCat.setValue("HIGH","");
			}		
		}

		//MRP CONTROLLER
		/*if(mrpArr!=null)
		{
			JCoTable r_mrp = sapTabParam.getTable("R_MRP_CONTR");
			for(int l=0;l<mrpArr.length;l++)
			{
				r_mrp.appendRow();
				r_mrp.setValue("SIGN","I");
				r_mrp.setValue("OPTION","EQ");
				r_mrp.setValue("LOW",mrpArr[l]);
				r_mrp.setValue("HIGH","");
			}				
		}*/	

		// PROCESS_STATUS
		/*(procArr!=null)
		{	
			JCoTable r_proc = sapTabParam.getTable("R_PROCESS_STATUS");
			for(int t=0;t<procArr.length;t++)
			{
				r_proc.appendRow();
				r_proc.setValue("SIGN","I");
				r_proc.setValue("OPTION","EQ");
				r_proc.setValue("LOW",procArr[t]);
				r_proc.setValue("HIGH","");
			}		
		}*/
		//FIXED VENDOR
		/*
		String mySoldTo = "";
		if(!"".equals(fixVen) && !"null".equals(fixVen) && fixVen!=null )
		{	
			JCoTable r_fVen = sapTabParam.getTable("R_FIXED_VENDOR");
			r_fVen.appendRow();

			fixVen = fixVen.trim();
			try
			{
				int vend = Integer.parseInt(fixVen);
				mySoldTo = "0000000000"+fixVen;
				mySoldTo = mySoldTo.substring((mySoldTo.length()-10),mySoldTo.length());

			}catch(Exception e){
				mySoldTo = fixVen;
			}		
			r_fVen.setValue("SIGN","I");
			r_fVen.setValue("OPTION","EQ");
			r_fVen.setValue("LOW",mySoldTo);
			r_fVen.setValue("HIGH","");
		}*/

		//DELETED ITEMS
		//if(!("".equals(delInd) || delInd==null || "null".equals(delInd)))	
			//sapPreProc.setDELETED_ITEMS(delInd); 

		//MULTIPLE PRS
		if(!("".equals(prMulti) || prMulti==null || "null".equals(prMulti)))	
		{
			String prMultiArr[] = prMulti.split(",");
			JCoTable r_pr = sapTabParam.getTable("R_PR_NO");
			String prMultiStr ="";

			for(int kk=0;kk<prMultiArr.length;kk++)
			{	
				try
				{
					prMultiStr = "0000000000"+prMultiArr[kk];
					prMultiStr = prMultiStr.substring((prMultiStr.length()-10),prMultiStr.length());

				}
				catch(Exception e)
				{
					prMultiStr = prMultiArr[kk];
				}	
				r_pr.appendRow();
				r_pr.setValue("SIGN","I");
				r_pr.setValue("OPTION","EQ");
				r_pr.setValue("LOW",prMultiStr);
				r_pr.setValue("HIGH","");
			}
		}	
		else
		{
			//PR NUMBERS
			JCoTable r_pr = sapTabParam.getTable("R_PR_NO");
			if(!("".equals(prLow) || prLow==null || "null".equals(prLow)))		
			{	

				r_pr.appendRow();
				r_pr.setValue("SIGN","I");
				r_pr.setValue("LOW",prLowStr);
				if(!("".equals(prHigh) || prHigh==null || "null".equals(prHigh)))
				{
					r_pr.setValue("OPTION","BT");
					r_pr.setValue("HIGH",prHighStr);
				}
				else
				{
					r_pr.setValue("OPTION","EQ");
					r_pr.setValue("HIGH","");
				}
			}
		}	
		
		//MULTIPLE MATERAILS
		if(!("".equals(matMulti) || matMulti==null || "null".equals(matMulti)))	
		{
			String matMultiArr[] = matMulti.split(",");
			JCoTable r_mat = sapTabParam.getTable("R_MATERIALS");
			String matMultiStr ="";

			for(int kk=0;kk<matMultiArr.length;kk++)
			{	
				try
				{
					matMultiStr = "000000000000000000"+matMultiArr[kk];
					matMultiStr = matMultiStr.substring((matMultiStr.length()-18),matMultiStr.length());

				}
				catch(Exception e)
				{
					matMultiStr = matMultiArr[kk];
				}	
				r_mat.appendRow();
				r_mat.setValue("SIGN","I");
				r_mat.setValue("OPTION","EQ");
				r_mat.setValue("LOW",matMultiStr);
				r_mat.setValue("HIGH","");
			}
		}	
		else
		{
			//PR NUMBERS
			JCoTable r_mat = sapTabParam.getTable("R_MATERIALS");
			if(!("".equals(matLow) || matLow==null || "null".equals(matLow)))		
			{	

				r_mat.appendRow();
				r_mat.setValue("SIGN","I");
				r_mat.setValue("LOW",matLowStr);
				if(!("".equals(matHigh) || matHigh==null || "null".equals(matHigh)))
				{
					r_mat.setValue("OPTION","BT");
					r_mat.setValue("HIGH",matHighStr);
				}
				else
				{
					r_mat.setValue("OPTION","EQ");
					r_mat.setValue("HIGH","");
				}
			}
		}			

	
		sapPreProc.setValue("FROM_DATE",fromDelDate);
		sapPreProc.setValue("TO_DATE",toDelDate);

	       	//if(!("".equals(toDate1) || toDate1==null || "null".equals(toDate1)))
			
		if(!("".equals(relFromDate) || relFromDate==null || "null".equals(relFromDate)))
			sapPreProc.setValue("REL_FROM_DATE",relFromDate1);

	       if(!("".equals(relToDate1) || relToDate1==null || "null".equals(relToDate1)))
			sapPreProc.setValue("REL_TO_DATE",relToDate1);

		//Item Note	

		sapPreProc.setValue("WITH_TEXTS","X");
		sapPreProc.setValue("WITH_MAT_TEXT","X");
		sapPreProc.setValue("WITH_PR_TEXT","X");
		
		//Amended PRs 
		if(!"A".equals(prVer))
			sapPreProc.setValue("CHANGED_FLAG",prVer);


		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in GET PRs FM Exectution:::::::::::::::"+qe,"I");
		}
		
		//GET PRS LIST
		
		int itemTxtCnt=0;
		ArrayList itemsTxt =null;
		int servItemTxtCnt=0;

		JCoTable sapPurchReqList = function.getTableParameterList().getTable("REQUISITION_ITEMS");
		JCoTable sapTextTable = function.getTableParameterList().getTable("PR_ITEM_TEXTS");
		//out.println("destination start55>>>"+sapPurchReqList);
		//out.println("destination start55>>>"+sapTextTable);
		prCnt 		= sapPurchReqList.getNumRows();
		itemTxtCnt 	= sapTextTable.getNumRows();
		
		
		
		JCoTable sapSerList = function.getTableParameterList().getTable("R_SERVICE");
		JCoTable sapServTxt = function.getTableParameterList().getTable("SERVCES_TEXT");
		servCnt = sapSerList.getNumRows();
		servItemTxtCnt = sapServTxt.getNumRows();
		ezc.ezcommon.EzLog4j.log("servCnt:::::::::::::::"+servCnt,"I");	
		ezc.ezcommon.EzLog4j.log("servItemTxtCnt:::::::::::::::"+servItemTxtCnt,"I");	

		if(itemTxtCnt>0)
		{
			do
			{
				String sapPr=(String)sapTextTable.getValue("PR_NO");
				String sapPrItem =(String)sapTextTable.getValue("PR_ITEM");
				String keyStr = sapPr+"$$"+sapPrItem;
				String sapPrTxt=(String)sapTextTable.getValue("TEXT"); 

				ezc.ezcommon.EzLog4j.log("sapPr::::::::11:::::::"+sapPr,"I");
				ezc.ezcommon.EzLog4j.log("sapPrItem:::::::::::::::"+sapPrItem,"I");
				ezc.ezcommon.EzLog4j.log("keyStr:::::::::::::::"+keyStr,"I");
				ezc.ezcommon.EzLog4j.log("sapPrTxt:::::::::::::::"+sapPrTxt,"I");

				if(sapPrTxt!=null && !"null".equals(sapPrTxt) && !"".equals(sapPrTxt.trim()))
				{			
					if("B01".equals((String)sapTextTable.getValue("TYPE")))
					{

							if(itmTxtHT.containsKey(keyStr))
							{
								itmTxtHT.put(keyStr,(String)itmTxtHT.get(keyStr)+""+sapPrTxt);
							}
							else
							{
								itmTxtHT.put(keyStr,sapPrTxt);
							}

					}
					if("B04".equals((String)sapTextTable.getValue("TYPE")))
					{

							if(poTxtHT.containsKey(keyStr))
							{
								poTxtHT.put(keyStr,(String)poTxtHT.get(keyStr)+""+sapPrTxt);
							}
							else
							{
								poTxtHT.put(keyStr,sapPrTxt);
							}

					}				
				}	
			}while(sapTextTable.nextRow());
		}	
		//out.print(sapPurchReqList);			
		if(prCnt > 0)
		{
			myRet= new ReturnObjFromRetrieve(new String[]{"DOC_TYPE","REQNO","ITEM","REQDATE","REL_DATE","DESCRIPTION","MATERIAL","MAT_GRP","ACCTASSCAT","PLANT","QUANTITY","UNIT","DELIV_DATE","CREATED_BY","TRACKING_NO","INT_ORDER","VAL_TYPE","MRP_CONTR","PUR_GRP","CURRENCY","REQ_BY","ITEM_CAT","LAST_RESUB","FIXED_VEND","UNIT_PRICE","TOT_VAL","PCKG_NO","ITEM_TXT","PO_TXT","VERSION"});
			try 
			{	
				//Service Object
				ezc.ezcommon.EzLog4j.log("servCnt:::::::::::::::"+servCnt,"I");
				if(servCnt > 0)
				{
					mySer= new ReturnObjFromRetrieve(new String[]{"SERVPCKGNO","PCKGNO","EXTLINE","SERVACT","SERVTXT","SERVUOM","SERVQTY","SERVITEMTXT","SERVLINETXT","GRPRICE","NETVAL"});
					String serPckgNo="";
					String subPckgNo="";					
					do
					{
						String outInd=(String)sapSerList.getValue("OUTL_IND");
						if("X".equals(outInd))
						{						
							serPckgNo=(String)sapSerList.getValue("PCKG_NO");
							subPckgNo=(String)sapSerList.getValue("SUBPCKG_NO");
							ezc.ezcommon.EzLog4j.log("serPckgNo:::::11::::::::::"+serPckgNo,"I");
							ezc.ezcommon.EzLog4j.log("subPckgNo::::::11:::::::::"+subPckgNo,"I");													
						}
						String pckgNo=(String)sapSerList.getValue("PCKG_NO");
						ezc.ezcommon.EzLog4j.log("pckgNo:::::::::::::::"+pckgNo,"I");
						if(pckgNo.equals(subPckgNo))
						{
							ezc.ezcommon.EzLog4j.log("subPckgNo in IF:::::::::::::::"+pckgNo,"I");						
							mySer.setFieldValue("SERVPCKGNO",serPckgNo);
							mySer.setFieldValue("PCKGNO",pckgNo);
							mySer.setFieldValue("EXTLINE",sapSerList.getValue("EXT_LINE"));
							mySer.setFieldValue("SERVACT",sapSerList.getValue("SERVICE"));
							mySer.setFieldValue("SERVTXT",sapSerList.getValue("SHORT_TEXT"));
							mySer.setFieldValue("SERVUOM",sapSerList.getValue("BASE_UOM"));
							mySer.setFieldValue("SERVQTY",sapSerList.getValue("QUANTITY"));
							mySer.setFieldValue("GRPRICE",sapSerList.getValue("GR_PRICE"));
							mySer.setFieldValue("NETVAL",sapSerList.getValue("NET_VALUE"));
							ezc.ezcommon.EzLog4j.log("serAct:::::::::::::::"+sapSerList.getValue("SERVICE"),"I");
							ezc.ezcommon.EzLog4j.log("serActLine:::::::::::::::"+sapSerList.getValue("EXT_LINE"),"I");
							String keyStr 		= (String)sapSerList.getValue("SERVICE")+"$$"+(String)sapSerList.getValue("EXT_LINE");
							if(servTxtHT.containsKey(keyStr))
								mySer.setFieldValue("SERVITEMTXT",servTxtHT.get(keyStr));
							if(lineTxtHT.containsKey(keyStr))
								mySer.setFieldValue("SERVLINETXT",lineTxtHT.get(keyStr));							

							mySer.addRow();
						}
					}while(sapSerList.nextRow());	
				}	
				do
				{
					String purGrpFromSAP=(String)sapPurchReqList.getValue("PUR_GROUP");
					String itemCat=(String)sapPurchReqList.getValue("ITEM_CAT");
					String rfqmat=(String)sapPurchReqList.getValue("MATERIAL");
					
					java.math.BigDecimal qty =((java.math.BigDecimal)(sapPurchReqList.getValue("QUANTITY"))).setScale(0,java.math.BigDecimal.ROUND_UP);
					java.math.BigDecimal unitPrice = new java.math.BigDecimal("0");
					java.math.BigDecimal totValue = new java.math.BigDecimal("0");
					try
					{
						unitPrice=((java.math.BigDecimal)(sapPurchReqList.getValue("C_AMT_BAPI"))).setScale(2,java.math.BigDecimal.ROUND_UP);
						totValue = qty.multiply(unitPrice);
					}
					catch(Exception e)
					{

					}					

					//out.println("pr num=="+sapPurchReqList.getValue("PREQ_NO"));
					myRet.setFieldValue("REQNO", sapPurchReqList.getValue("PREQ_NO"));		//"BANFN"
					myRet.setFieldValue("ITEM",sapPurchReqList.getValue("PREQ_ITEM"));		//"BNFPO"
					ezc.ezcommon.EzLog4j.log("REQNO:::::::::::::::"+sapPurchReqList.getValue("PREQ_NO"),"I");
					ezc.ezcommon.EzLog4j.log("ITEM:::::::::::::::"+sapPurchReqList.getValue("PREQ_ITEM"),"I");
					ezc.ezcommon.EzLog4j.log("ITEM:::::::::::::::"+sapPurchReqList.getValue("MATERIAL"),"I");
					myRet.setFieldValue("REQDATE",sapPurchReqList.getValue("PREQ_DATE"));		//"BADAT"
					ezc.ezcommon.EzLog4j.log("REQDATE:::::::::::::::"+sapPurchReqList.getValue("PREQ_DATE"),"I");
					myRet.setFieldValue("DELIV_DATE",(Date)sapPurchReqList.getValue("DELIV_DATE"));	//"LFDAT"
					myRet.setFieldValue("REL_DATE",sapPurchReqList.getValue("REL_DATE"));		//"FRGDT"
					
					if("000000075000034121".equals(sapPurchReqList.getValue("MATERIAL")+""))
						myRet.setFieldValue("DESCRIPTION","Honey");	//"TXZ01"
					else
						myRet.setFieldValue("DESCRIPTION",sapPurchReqList.getValue("SHORT_TEXT"));	//"TXZ01"
					myRet.setFieldValue("MATERIAL",sapPurchReqList.getValue("MATERIAL"));           //"MATNR"
					myRet.setFieldValue("MAT_GRP",sapPurchReqList.getValue("MAT_GRP"));
					myRet.setFieldValue("PLANT",sapPurchReqList.getValue("PLANT"));		//"WERKS"
					myRet.setFieldValue("QUANTITY",sapPurchReqList.getValue("QUANTITY")); //qty);		//"MENGE"
					myRet.setFieldValue("UNIT",sapPurchReqList.getValue("UNIT"));			//"MEINS"
					myRet.setFieldValue("CREATED_BY",sapPurchReqList.getValue("CREATED_BY"));	//"ERNAM"
					myRet.setFieldValue("TRACKING_NO",sapPurchReqList.getValue("TRACKINGNO"));
					myRet.setFieldValue("INT_ORDER",sapPurchReqList.getValue("PROMOTION"));
					myRet.setFieldValue("VAL_TYPE",sapPurchReqList.getValue("VAL_TYPE"));
					myRet.setFieldValue("MRP_CONTR",sapPurchReqList.getValue("MRP_CONTR"));
					myRet.setFieldValue("PUR_GRP",sapPurchReqList.getValue("PUR_GROUP"));
					myRet.setFieldValue("CURRENCY",sapPurchReqList.getValue("CURRENCY"));
					myRet.setFieldValue("REQ_BY",sapPurchReqList.getValue("PREQ_NAME"));
					myRet.setFieldValue("ACCTASSCAT",sapPurchReqList.getValue("ACCTASSCAT"));
					myRet.setFieldValue("ITEM_CAT",sapPurchReqList.getValue("ITEM_CAT"));
					myRet.setFieldValue("LAST_RESUB",(Date)sapPurchReqList.getValue("LAST_RESUB"));
					myRet.setFieldValue("FIXED_VEND",sapPurchReqList.getValue("FIXED_VEND"));
					myRet.setFieldValue("UNIT_PRICE",unitPrice);
					myRet.setFieldValue("TOT_VAL",totValue.setScale(2,java.math.BigDecimal.ROUND_UP));
					myRet.setFieldValue("PCKG_NO",sapPurchReqList.getValue("PCKG_NO"));
					myRet.setFieldValue("DOC_TYPE",sapPurchReqList.getValue("DOC_TYPE"));
					myRet.setFieldValue("ITEM_TXT",itmTxtHT.get(sapPurchReqList.getValue("PREQ_NO")+"$$"+sapPurchReqList.getValue("PREQ_ITEM")));
					myRet.setFieldValue("PO_TXT",poTxtHT.get(sapPurchReqList.getValue("PREQ_NO")+"$$"+sapPurchReqList.getValue("PREQ_ITEM")));
					myRet.setFieldValue("VERSION",sapPurchReqList.getValue("BOMEXPL_NO"));
					myRet.addRow();
				
				}while(sapPurchReqList.nextRow());
			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exeception in building PRs ret obj:::::::::::::::"+e,"I");	
			}
		}
	}
	catch(Exception e6)
	{
		ezc.ezcommon.EzLog4j.log("Exeception in Getting PRs:::::::::::::::"+e6,"I");
	}
	int myRetCount =0;
	if(prCnt > 0)
		 myRetCount = myRet.getRowCount();
	else
		 myRetCount=0;

	//ezc.ezcommon.EzLog4j.log("myRetCount:::::::::::::::"+myRetCount,"I");
	/*
	if(myRetCount>0)
	{
		//myRet.sort(new String[]{"REQDATE","MATERIAL","PLANT"},false);
		//myRet.sort(new String[]{"REQDATE"},false);
	}*/
	
	//out.println("myRet"+myRet.toEzcString());
	//out.println("mySer>>>>>"+mySer.toEzcString());
	session.putValue("SERVOBJ",mySer);	
	/************* The following is for knowing RFQ created against PR(s) or not  ******************/	
	java.util.TreeSet prTreeSet=new java.util.TreeSet();
	java.util.Hashtable colRfqsHt=new java.util.Hashtable();
	ezc.ezparam.ReturnObjFromRetrieve retObj = null;

	/*
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezirfqheaderparams.setExt1("RFQ_PR");	
	mainParams1.setObject(ezirfqheaderparams);
	mainParams1.setLocalStore("Y");
	Session.prepareParams(mainParams1);
	
	try{
		retObj=(ezc.ezparam.ReturnObjFromRetrieve)cm.ezGetRFQList(mainParams1);
	}catch(Exception e){
		System.out.println("Exception Occured in iListPR.jsp while getting PR details"+e.getMessage());
	}	

	int retObjCount=0;
	if(retObj!=null)
		retObjCount=retObj.getRowCount();

	for(int i=0;i<retObjCount;i++)
	{
		String prText=retObj.getFieldValueString(i,"PR_TEXT");
		String colRfqNo=retObj.getFieldValueString(i,"COLLECTIVE_RFQ_NO");
		if(prText!=null && !"null".equals(prText) && !"".equals(prText.trim()))
		{

			EzStringTokenizer notesAllSt=null;
			notesAllSt = new EzStringTokenizer(prText,"$");
			int notesAllCt =notesAllSt.getTokens().size();
			if(notesAllCt>0)
			{
				for(int j=0;j<notesAllCt;j++)
				{
					EzStringTokenizer notesAllSt1 = new EzStringTokenizer((String)notesAllSt.getTokens().elementAt(j),"¥");
					int notesAllCt1 = notesAllSt1.getTokens().size();
					if(notesAllCt1>1)
					{

						String keyStr=(String)notesAllSt1.getTokens().elementAt(0)+"¥"+(String)notesAllSt1.getTokens().elementAt(1);

						prTreeSet.add(keyStr);
						colRfqsHt.put(keyStr,colRfqNo);
					}
				}	
			}
		}	
	}*/
	
	/***********RFQ CREATED AGAINST PRS ***********************************************/
	
	String qryPr="";
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false);
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	qryPr="SELECT ERP_QCF_NO,ERP_PR_NO,ERP_PR_ITEM FROM EZC_RFQ_PRS";

	ezc.ezcommon.EzLog4j.log("** qryPr"+qryPr,"I");

	rfqTableRow.setQuery(qryPr);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);

	try
	{
		retObj=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);

	}	 
	catch(Exception e)
	{
		out.println("Exception in getting PR List>>>>>"+e);
	}	
	ezc.ezcommon.EzLog4j.log("retObj iin PR LIST>>>>"+retObj.toEzcString(),"I");


	int retObjCount=0;
	if(retObj!=null)
		retObjCount=retObj.getRowCount();
	ezc.ezcommon.EzLog4j.log("retObjCount>>>>"+retObjCount,"I");		
		
	for(int i=0;i<retObjCount;i++)
	{
		String colRfqNo=retObj.getFieldValueString(i,"ERP_QCF_NO");
		String prNo=retObj.getFieldValueString(i,"ERP_PR_NO");
		String prItem=retObj.getFieldValueString(i,"ERP_PR_ITEM");
		
		String keyStr=prNo+"¥"+prItem;
		prTreeSet.add(keyStr);
		colRfqsHt.put(keyStr,colRfqNo);

	}		
	
	
	
%>
