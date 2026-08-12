<%@ page import ="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<%@ page import="java.sql.*" %>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*,java.io.*,java.nio.channels.*" %> 
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull_Num(String str)
	{
		if("null".equals(str) ||str==null || "".equals(str)) 
			str="0";
		
		return str;
 	}
%>

<%

	ezc.ezcommon.EzLog4j.log("****started","I");
	EzcParams ezparams=new EzcParams(true);
	EzShipmentManager shManager=new EzShipmentManager(); 
	boolean isBatchSucess=false;
	String sqlStmtQuoteHis="";
	String rfqNumber 	= checkNull(request.getParameter("RfqNo"));
	String rfqVendor 	= checkNull(request.getParameter("rfqVendor")); 
	String rfqBuyer 	= checkNull(request.getParameter("rfqBuyer")); 
	String QtnDt 		= checkNull(request.getParameter("QtnDate"));
	String rfqPmntTms 	= checkNull(request.getParameter("PaymentTerms"));
	String rfqIncoTms1 	= checkNull(request.getParameter("IncoTerms"));
	String Comments 	= checkNull(request.getParameter("Comments"));
	Comments=Comments.replaceAll("'","`");
	Comments = Comments.trim();
	ezc.ezcommon.EzLog4j.log("**start2","I");
	String retMsg 		= "Quotation Re Quoted  Successfully in Portal";
	
	String objNo="";
	String documentType="";
	String[] lineAttachString=null;		

	int j=0;
	//Date fromDate = new Date();
	/*fromDate.setDate(Integer.parseInt(QtnDt.substring(0,2)));
	fromDate.setMonth(Integer.parseInt(QtnDt.substring(3,5))-1);
	fromDate.setYear(Integer.parseInt(QtnDt.substring(6,10))-1900);*/
	
	String rfqItems[]	= request.getParameterValues("rfqItem");	
	int rfqItemsCnt = 0;
	
	if(rfqItems!=null)
		rfqItemsCnt = rfqItems.length;	
		
	ezc.ezcommon.EzLog4j.log("****=rfqItems.length===requote==**"+rfqItems.length,"I");
	

	
	String counter="0";
		
	String dbInsQry = "SELECT MAX(ERQH_COUNTER) COUNT FROM EZC_RFQ_QUOTE_HISTORY  WHERE ERQH_RFQ_NO='"+rfqNumber+"'";
	ezc.ezparam.ReturnObjFromRetrieve retObj = null;
	
 	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
 	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
 	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
 	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
 
 	miscTableRow.setQuery(dbInsQry);
 			
 	try
 	{
 		miscTable.appendRow(miscTableRow);
 		mainParams.setLocalStore("Y");
 		mainParams.setObject(miscTable);
 		Session.prepareParams(mainParams);
 		retObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
 		if(retObj!=null)counter=retObj.getFieldValueString(0,"COUNT");
 		
 	}
 	catch(Exception e){
 	ezc.ezcommon.EzLog4j.log("Error while updatingRFQheader"+e,"E");
 	}
 	counter=(Integer.parseInt(counter)+1)+"";
 	
 	ezc.ezcommon.EzLog4j.log("****=counter==**"+counter,"I");		
	Connection con = null;
	java.sql.Statement stmt = null;
	java.sql.PreparedStatement prepareStmt = null;
	ResultSet rs = null;
	String qry = "",evrd_status = "";
	int PRItemCnt  = 0;
	int lineNO	=0;
	String ConnGroup ="200";
	String rfqItem="";
	String rfqLineItem="";
	String rfqItemCat="";
	String itemPrice="",rfqItemCurr="";
	String rfqQty="";
	ezc.ezcommon.EzLog4j.log("****=ConnGroup==**"+ConnGroup,"I");
	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		java.util.ResourceBundle mySite= java.util.ResourceBundle.getBundle("Site");
		con=DriverManager.getConnection(mySite.getString("ConnectString_"+ConnGroup),mySite.getString("UserId_"+ConnGroup),mySite.getString("Password_"+ConnGroup));
		//con 	= DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=ezlife;SelectMethod=cursor", "ezlife1", "ezlife1");
		stmt 	= con.createStatement();
		
		//String sqlStmtSrvUpt = "";
		//String sqlStmtSrvIns = "";
						
		String sqlStmtHeader   = "UPDATE  EZC_RFQ_HEADER SET ERH_MODIFIED_BY ='"+Session.getUserId()+"',ERH_MODIFIED_ON= NOW() ,ERH_STATUS='P',ERH_PAYMENT_TERMS='"+rfqPmntTms+"',ERH_INCO_TERMS1='"+rfqIncoTms1+"' WHERE ERH_RFQ_NO='"+rfqNumber+"'";

		stmt.addBatch(sqlStmtHeader);
		ezc.ezcommon.EzLog4j.log(":::sqlStmtHeader:sqlStmtHeader::"+sqlStmtHeader,"I");
		for (int i=0 ; i < rfqItemsCnt ; i++)
		{
			
			rfqItem 	= rfqItems[i];
			lineNO		=(i+1)*10; 
			rfqLineItem	= checkNull(request.getParameter("rfItemNo"+rfqItem));
			rfqItemCat	= checkNull(request.getParameter("itemCat"+rfqItem));
			rfqItemCurr 	= checkNull(request.getParameter("rfqItemCurr"+rfqItem));
			itemPrice 	= checkNull(request.getParameter("itemPrice"+rfqItem));
			rfqQty	= checkNull(request.getParameter("rfqQty"+rfqItem));
				
			String Price=checkNull_Num(request.getParameter("itemPrice"+rfqItem));
			String discType=checkNull(request.getParameter("valTypeDISC"));
			String condDisc=checkNull_Num(request.getParameter("condDisc"+rfqItem));
			String condDiscVal=checkNull_Num(request.getParameter("condDISCVal"+rfqItem));			
			String PKFWType=checkNull(request.getParameter("valTypePKFW"));
			String condPKFW=checkNull_Num(request.getParameter("itemPKFW"));
			String condPKFWVal=checkNull_Num(request.getParameter("itemPKFWVal"));
			String FRTType=checkNull(request.getParameter("valTypeFRT"));
			String condFRT=checkNull_Num(request.getParameter("itemFRT"));
			String condFRTVal=checkNull_Num(request.getParameter("itemFRTVal"));
			String valTypeGST=checkNull_Num(request.getParameter("valTypeTAX"));
			String condGSTCode=checkNull_Num(request.getParameter("itemTAXCode"));
			String condGST=checkNull_Num(request.getParameter("vendGST"+rfqItem));
			String condGSTVal=checkNull_Num(request.getParameter("itemTAXVal"+rfqItem));
			//String condGSTVal=checkNull_Num(request.getParameter("itemTAXVal"));
			String vendHSNGST=checkNull_Num(request.getParameter("vendHSNGST"+rfqItem));
			String leaddays = checkNull(request.getParameter("leaddays"+rfqItem));
			
			
			
			String sqlStmtDetails   = "UPDATE EZC_RFQ_DETAILS SET ERD_REMARKS='"+Comments+"', ERD_LEAD_DAYS='"+leaddays+"',ERD_PRICE='"+Price+"', ERD_VEND_HSN_CODE='"+vendHSNGST+"',ERD_VEND_GST='"+condGST+"' WHERE ERD_RFQ_NO='"+rfqNumber+"' AND ERD_LINE_NO='"+lineNO+"' AND ERD_COUNTER IN (SELECT ERD_COUNTER FROM (SELECT MAX(ERD_COUNTER) FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO='"+rfqNumber+"')AS TEMP)";	
			stmt.addBatch(sqlStmtDetails);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtDetails:sqlStmtDetails::"+sqlStmtDetails+"::discType::"+discType,"I");
			ezc.ezcommon.EzLog4j.log("rfqItemCat OUT >>>>"+rfqItemCat,"I");
			
			if("D".equals(rfqItemCat))
			{
				String srvCnt="0";
				ezc.ezparam.ReturnObjFromRetrieve srvCntObj = null;
				String srvCntQry = "SELECT MAX(ERSH_SRV_COUNTER) SRVCOUNT FROM EZC_RFQ_SERVICES_HISTORY WHERE ERSH_SRV_RFQ='"+rfqNumber+"'";
				
				mainParams = new ezc.ezparam.EzcParams(false); 				
 				miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
 				miscTable = new ezc.misctransactions.params.EzMiscTable();
 				miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
 
 				miscTableRow.setQuery(srvCntQry);
 			
				try
				{
					miscTable.appendRow(miscTableRow);
					mainParams.setLocalStore("Y");
					mainParams.setObject(miscTable);
					Session.prepareParams(mainParams);
					srvCntObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
					if(srvCntObj!=null)srvCnt=srvCntObj.getFieldValueString(0,"SRVCOUNT");

				}
				catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Error while Service Count"+e,"E");
				}
				srvCnt=(Integer.parseInt(srvCnt)+1)+"";

				ezc.ezcommon.EzLog4j.log("****=srvCnt==**"+srvCnt,"I");					
				
				

				String serLines[] = request.getParameter("serLine"+rfqLineItem).split("##");
				ezc.ezcommon.EzLog4j.log("serLines>>>"+serLines,"I");
				String serSAC[]   = request.getParameter("serSAC"+rfqLineItem).split("##");
				ezc.ezcommon.EzLog4j.log("serSAC>>>"+serSAC,"I");
				String serGST[]   = request.getParameter("serGST"+rfqLineItem).split("##");
				ezc.ezcommon.EzLog4j.log("serGST>>>"+serGST,"I");
				String serPrice[] = request.getParameter("serPrice"+rfqLineItem).split("##");
				ezc.ezcommon.EzLog4j.log("serPrice>>>"+serPrice,"I");
				String serQty[]   = request.getParameter("serQty"+rfqLineItem).split("##");
				ezc.ezcommon.EzLog4j.log("serQty>>>"+serQty,"I");
				
				
				
				int serLinesCnt = 0;
	
				if(serLines!=null)
					serLinesCnt = serLines.length;	
				
				ezc.ezcommon.EzLog4j.log("****=serLinesCnt**"+serLines.length,"I");
				
				for(int r=0;r<serLinesCnt;r++)
				{
					String sqlStmtSrvUpt = "UPDATE EZC_RFQ_SERVICES SET ERS_SRV_PRICE='"+serPrice[r]+"',ERS_SRV_GST='"+serGST[r]+"' WHERE ERS_SRV_RFQ='"+rfqNumber+"' AND ERS_SRV_RFQ_ITEM='"+rfqLineItem+"' AND ERS_SRV_LINE='"+serLines[r]+"'";
					stmt.addBatch(sqlStmtSrvUpt);
					ezc.ezcommon.EzLog4j.log(":::sqlStmtSrvUpt>>>>>"+sqlStmtSrvUpt,"I");
					
					String sqlStmtSrvIns = "INSERT INTO EZC_RFQ_SERVICES_HISTORY VALUES('"+rfqNumber+"','"+rfqLineItem+"','"+serLines[r]+"','"+srvCnt+"','"+serQty[r]+"','"+rfqItemCurr+"','"+serPrice[r]+"','"+serSAC[r]+"','"+serGST[r]+"','','','')";
					stmt.addBatch(sqlStmtSrvIns);
					ezc.ezcommon.EzLog4j.log(":::sqlStmtSrvIns>>>>>"+sqlStmtSrvIns,"I");
				}
			}	

			//ITEM_CONDITIONS
			
			sqlStmtQuoteHis   =  "UPDATE EZC_RFQ_ITEM_CONDITIONS set  ERIC_TAX_VALUE='"+condDisc+"',ERIC_TAX_TYPE='"+discType+"' ,ERIC_EXT3='"+condDiscVal+"',ERIC_NEG_TAX_VALUE='"+condDisc+"' where ERIC_RFQ_NO='"+rfqNumber+"' and ERIC_LINE_NO='"+lineNO+"' and ERIC_TAX_CODE='DISC'";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");
			
			sqlStmtQuoteHis   =  "UPDATE EZC_RFQ_ITEM_CONDITIONS set  ERIC_TAX_VALUE='"+condPKFW+"',ERIC_TAX_TYPE='"+PKFWType+"' ,ERIC_EXT3='"+condPKFWVal+"',ERIC_NEG_TAX_VALUE='"+condPKFWVal+"' where ERIC_RFQ_NO='"+rfqNumber+"' and ERIC_LINE_NO='"+lineNO+"' and ERIC_TAX_CODE='PKFW'";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");

			sqlStmtQuoteHis   =  "UPDATE EZC_RFQ_ITEM_CONDITIONS set  ERIC_TAX_VALUE='"+condFRT+"',ERIC_TAX_TYPE='"+FRTType+"' ,ERIC_EXT3='"+condFRTVal+"',ERIC_NEG_TAX_VALUE='"+condFRTVal+"'  where ERIC_RFQ_NO='"+rfqNumber+"' and ERIC_LINE_NO='"+lineNO+"' and ERIC_TAX_CODE='FRT'";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");
			
			sqlStmtQuoteHis   =  "UPDATE EZC_RFQ_ITEM_CONDITIONS set  ERIC_TAX_VALUE='"+condGST+"',ERIC_TAX_TYPE='"+valTypeGST+"' ,ERIC_EXT3='"+condGSTVal+"',ERIC_NEG_TAX_VALUE='"+condGSTVal+"' where ERIC_RFQ_NO='"+rfqNumber+"' and ERIC_LINE_NO='"+lineNO+"' and ERIC_TAX_CODE='TAX'";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");
			
			sqlStmtQuoteHis   =  "UPDATE EZC_RFQ_ITEM_CONDITIONS set  ERIC_TAX_VALUE='"+leaddays+"' where ERIC_RFQ_NO='"+rfqNumber+"' and ERIC_LINE_NO='"+lineNO+"' and ERIC_TAX_CODE='LEAD'";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");			
			
			//QUOTE HISTORY
			
			sqlStmtQuoteHis   =  "INSERT INTO EZC_RFQ_QUOTE_HISTORY (ERQH_VENDOR,ERQH_RFQ_NO,ERQH_LINE_NO,ERQH_COUNTER,ERQH_COND_CODE,ERQH_SEQ_NO,ERQH_COND_VALUE,ERQH_COND_TYPE,ERQH_COND_TOT_VALUE,ERQH_ENTERED_ON,ERQH_ENTERED_BY,ERQH_CFORM,ERQH_QUOTE_FLAG,ERQH_EXT1,ERQH_EXT2,ERQH_EXT3) VALUES('"+rfqVendor+"','"+rfqNumber+"','"+lineNO+"','"+counter+"','DISC','1','"+condDisc+"','"+discType+"','"+condDiscVal+"',NOW(),'"+rfqVendor+"','','LATEST','"+rfqQty+"','"+Price+"','')";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");			
			
			sqlStmtQuoteHis   =  "INSERT INTO EZC_RFQ_QUOTE_HISTORY (ERQH_VENDOR,ERQH_RFQ_NO,ERQH_LINE_NO,ERQH_COUNTER,ERQH_COND_CODE,ERQH_SEQ_NO,ERQH_COND_VALUE,ERQH_COND_TYPE,ERQH_COND_TOT_VALUE,ERQH_ENTERED_ON,ERQH_ENTERED_BY,ERQH_CFORM,ERQH_QUOTE_FLAG,ERQH_EXT1,ERQH_EXT2,ERQH_EXT3) VALUES('"+rfqVendor+"','"+rfqNumber+"','"+lineNO+"','"+counter+"','PKFW','2','"+condPKFW+"','"+PKFWType+"','"+condPKFWVal+"',NOW(),'"+rfqVendor+"','','LATEST','"+rfqQty+"','"+Price+"','')";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");

			sqlStmtQuoteHis   =  "INSERT INTO EZC_RFQ_QUOTE_HISTORY (ERQH_VENDOR,ERQH_RFQ_NO,ERQH_LINE_NO,ERQH_COUNTER,ERQH_COND_CODE,ERQH_SEQ_NO,ERQH_COND_VALUE,ERQH_COND_TYPE,ERQH_COND_TOT_VALUE,ERQH_ENTERED_ON,ERQH_ENTERED_BY,ERQH_CFORM,ERQH_QUOTE_FLAG,ERQH_EXT1,ERQH_EXT2,ERQH_EXT3) VALUES('"+rfqVendor+"','"+rfqNumber+"','"+lineNO+"','"+counter+"','FRT','3','"+condFRT+"','"+FRTType+"','"+condFRTVal+"',NOW(),'"+rfqVendor+"','','LATEST','"+rfqQty+"','"+Price+"','')";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");
			
			sqlStmtQuoteHis   =  "INSERT INTO EZC_RFQ_QUOTE_HISTORY (ERQH_VENDOR,ERQH_RFQ_NO,ERQH_LINE_NO,ERQH_COUNTER,ERQH_COND_CODE,ERQH_SEQ_NO,ERQH_COND_VALUE,ERQH_COND_TYPE,ERQH_COND_TOT_VALUE,ERQH_ENTERED_ON,ERQH_ENTERED_BY,ERQH_CFORM,ERQH_QUOTE_FLAG,ERQH_EXT1,ERQH_EXT2,ERQH_EXT3) VALUES('"+rfqVendor+"','"+rfqNumber+"','"+lineNO+"','"+counter+"','TAX','4','"+condGST+"','P','"+condGSTVal+"',NOW(),'"+rfqVendor+"','','LATEST','"+rfqQty+"','"+Price+"','')";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");
			
			sqlStmtQuoteHis   =  "INSERT INTO EZC_RFQ_QUOTE_HISTORY (ERQH_VENDOR,ERQH_RFQ_NO,ERQH_LINE_NO,ERQH_COUNTER,ERQH_COND_CODE,ERQH_SEQ_NO,ERQH_COND_VALUE,ERQH_COND_TYPE,ERQH_COND_TOT_VALUE,ERQH_ENTERED_ON,ERQH_ENTERED_BY,ERQH_CFORM,ERQH_QUOTE_FLAG,ERQH_EXT1,ERQH_EXT2,ERQH_EXT3) VALUES('"+rfqVendor+"','"+rfqNumber+"','"+lineNO+"','"+counter+"','LEAD','5','"+leaddays+"','P','"+leaddays+"',NOW(),'"+rfqVendor+"','','LATEST','"+rfqQty+"','"+Price+"','')";  
			stmt.addBatch(sqlStmtQuoteHis);
			ezc.ezcommon.EzLog4j.log(":::sqlStmtQuoteHis:sqlStmtQuoteHis::"+sqlStmtQuoteHis,"I");			
			
		
			
			
	       }
		
		try
		{
			int insertcount[]=stmt.executeBatch();	
			isBatchSucess=true;
			ezc.ezcommon.EzLog4j.log(":::::isBatchSucess:::"+isBatchSucess,"I");
		}
		catch(Exception e)
		{
			isBatchSucess=false;
			ezc.ezcommon.EzLog4j.log("::::::Batch query execution failed in ezQuotationUpdate.jsp:::::"+e,"E");
		}

		/*if(isBatchSucess)
			con.commit();
		else
			con.rollback();*/

	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log(":::::Exception occured while getting DB conection:::::::::: "+e,"E");
	}
	
	finally
	{

		if(con!=null)	
		con.close();
		if(prepareStmt!=null)
		prepareStmt.close();
	}		

		
	

	
	if(isBatchSucess)
	{
	
		//RFQ RE-QUOTE EMAIL

		Hashtable<String,String> plantHT = getPlants(Session); 	 

		String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		String bgColor = "bgcolor=\"#FFFFFF\"";
		String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
		String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

		String eMailData="",eMailDataComm="";
		eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ceat PR Reference</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
		eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
		eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
		eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
		eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
		eMailData +=  "</Tr>";
		
		
		if(Comments!=null && !"".equals(Comments) && Comments.trim().length()>0)
		{
			saveDocComments(Session,rfqNumber,"RFQ",Comments);
			eMailDataComm=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr><Th width= \"10%\" "+thBGColor+"><B>Comments</B></Th><td>"+Comments+"</td></Tr></Table><Br>";		
		}
		lineAttachString = request.getParameterValues("fileItem");
		ezc.ezcommon.EzLog4j.log("rfqNumber>>>>>"+rfqNumber,"I");  
		ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I"); 
		if(lineAttachString != null)
		{ 
			objNo 		= rfqNumber;
			documentType 	= "RFQ"; 
%>	
			<%@ include file="../UploadFiles/ezSaveQuoteAttach.jsp" %>	
<%				
						
		}
		
	
		

		String rfqItemPos = "";
		String rfqLineItem1= "";
		String rfqPlant="";
		String rfqPr="";
		String rfqPrItem="";
		String rfqMat="";
		String rfqMatDesc="";	
		String rfqItemQty="";
		String rfqUom="";	
		String rfqDelDt="";			
			
			
		//EMAIL
		
		for (int k=0 ; k < rfqItemsCnt ; k++) 
		{
			rfqItemPos 	= rfqItems[k];	
			rfqLineItem1	= checkNull(request.getParameter("rfItemNo"+rfqItemPos));  
			rfqPlant	= checkNull(request.getParameter("plant"+rfqItemPos));
			ezc.ezcommon.EzLog4j.log("****==rfqItemsCnt iin rfqPlant====**"+rfqPlant,"I");  
			rfqPr		= checkNull(request.getParameter("pr"+rfqItemPos));
			rfqPrItem 	= checkNull(request.getParameter("prItem"+rfqItemPos));
			rfqMat		= checkNull(request.getParameter("matNo"+rfqItemPos));
			ezc.ezcommon.EzLog4j.log("****==rfqItemsCnt iin rfqMat====**"+rfqMat,"I");
			rfqMatDesc	= checkNull(request.getParameter("matDesc"+rfqItemPos));	
			rfqItemQty	= checkNull(request.getParameter("rfqQty"+rfqItemPos));
			rfqUom  	= checkNull(request.getParameter("uom"+rfqItemPos));
			rfqDelDt	= checkNull(request.getParameter("delDate"+rfqItemPos));
			
			eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+plantHT.get(rfqPlant)+"</Td>"; 
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+rfqLineItem1+"</Td>";  
			eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
			eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
			eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDt+"</Td>"; 
			eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+QtnDt+"</Td>";
			eMailData +=  "</Tr>";		
		}
		eMailData +=  "</Table><Br>";		
			
		
		
%>
		<%@ include file="ezQuoteUpdateMail.jsp" %>
<%		
	}	
	response.sendRedirect("../Shipment/ezMessage.jsp?Msg="+retMsg);

%>
