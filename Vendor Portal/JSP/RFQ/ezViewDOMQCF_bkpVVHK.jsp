<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iQuoteRFQDetails.jsp"%>          
<%@ include file="../Misc/ezGetJGLVendorsList.jsp"%>    
<%//@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ page import="ezc.ezutil.*"%>
<%@ page import="java.text.*" %>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>           
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager"/>      
<%//@ page import="org.apache.poi.xssf.usermodel.*"%>                
<%//@ page import="org.apache.poi.ss.usermodel.Cell"%>            
<%//@ page import="org.apache.poi.ss.usermodel.Row"%>
<%//@ page import="org.apache.poi.ss.usermodel.Sheet"%> 
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%> 
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%> 
<%//@ page import="org.apache.poi.ss.usermodel.*,org.apache.poi.ss.util.RegionUtil"%>
<%//@ page import="org.apache.poi.xssf.usermodel.XSSFColor,org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import ="ezc.ezbasicutil.*" %>
<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)   
		str="";
		return str.trim(); 
	}
%>
<%
	session.putValue("QCF_WF_UPDATE","");
	
	String wfStatus="",wfTemplate="",wfNextPart="";
	int wfCurStep=0;
	boolean showApprove=false;
	boolean showSubmit=false;
	boolean showReject=false;
	boolean showCreate=false;
	BigDecimal docVal= new BigDecimal(300000);//new BigDecimal(0.00);
	ReturnObjFromRetrieve retWFDocDetails= ezMiscSelect(Session,"SELECT * FROM EZC_WF_DOC_HISTORY_HEADER WHERE EWDHH_DOC_ID='"+qcfNo+"'");
	
	String status = request.getParameter("type");
	ezc.ezcommon.EzLog4j.log("status>>>>>>"+status,"I");
	String showSubmit = request.getParameter("showSubmit");
	
	String readOnly="";
	if("Sub".equals(status)) readOnly="readonly";
	
	Hashtable taxesHT =  new Hashtable();
	taxesHT.put("DISC","Discount");
	taxesHT.put("PKFW","Packing & Forwarding");
	taxesHT.put("FRT","Freight"); 
	taxesHT.put("GST","GST");

	java.util.Hashtable hashType = new java.util.Hashtable();
	hashType.put("P","(%)"); 
	hashType.put("Q","(/Qty)");
	hashType.put("V","(Value)");
	hashType.put("","");
	
	String destinationPath="";
	
	try
	{
		ResourceBundle site1= ResourceBundle.getBundle("Site");
		destinationPath=site1.getString("UPLOADFILEPATHDIR");
	}
	catch(Exception e)
	{ 
	    ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
	}
	
	 ezc.ezcommon.EzLog4j.log("::::destinationPath::: "+destinationPath,"I");

	FileOutputStream outputStream = null;
	
	String tempDocId="";
	if(qcfNo.contains("/"))
	{
		tempDocId=qcfNo.replaceAll("/","_");
	}
	else
	{
		tempDocId=qcfNo;
	}
	String excelFilePath=destinationPath+"QCF\\"+tempDocId+"\\QCF_"+tempDocId+".xlsx";
	File upFile1=new File(destinationPath+"QCF\\"+tempDocId);
	
	if(!((upFile1.exists()) && (upFile1.isDirectory())))
	{
	boolean dir=upFile1.mkdirs();
	ezc.ezcommon.EzLog4j.log(":::directory:::::"+dir,"I");
	}
	/*outputStream = new FileOutputStream(excelFilePath);

	Workbook wb = new XSSFWorkbook(); //or new HSSFWorkbook();
	Sheet sheet = wb.createSheet("QCF");*/
	
	ArrayList rfqList = new ArrayList();
	Hashtable rfqHash = new Hashtable();
	int x=0;	

%>
<Html>
<Head>

<link rel="stylesheet" href="../Misc/library/assets/bootstrap-3.3.2/css/bootstrap.css">
<style>
#cont {
	height: 450px;
}

#table-1 {
	width: 1300px !important;
}
</style>
<style>
table {
  border-collapse: collapse;
  background: white;
  table-layout: fixed;
  width: 100%;
}
th, td {
  padding: 5px 5px;
  border: 1px solid black;
  line-height: inherit !important;
  overflow: hidden;
  
}

.pane {
  background: #eee;
}
.pane-hScroll {
 overflow: auto;
  width: 100%;
  
}
.pane-vScroll {
  overflow-y: auto;
  overflow-x: hidden;
  height: 600px;
  
}

@media only print {
   #idOfYourDiv {
     width: auto;
     height: auto;
    overflow: visible;
   }
}
</style>
</Head>
<body >
<Form name="myForm">
<input type="hidden" name="qcfNo" value="<%=qcfNo%>">  
<input type="hidden" name="rankType" value=""> 
<input type="hidden" name="vendorSelected" value="N">
<input type="hidden" name="chkVal">
<input type="hidden" name="type" value="<%=status%>">
<input type="hidden" name="excelFilePath" value="<%=excelFilePath%>">


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->	
	<section class="content-header">
   	      <h4>Quotation Comparison Form:<b> <%=qcfNo%></b></h4> 
   	</section>
   	
<!-- Main content -->  
		<div class="box-body">
		<div class="pane pane--table1" id="idOfYourDiv">
		  <div class="pane-hScroll">
		  <div id="cont">
			<table id="table-1" class="table" border=1 style="font-size:12px;margin-bottom:0px !important">
				<thead>
				<tr style="background-color:coral !important">
				<th colspan=12 style="width:150px;text-align:left">Name of the Party</th>
<%	

		//out.print(rfqVendLinesRet.toEzcString());
		String checked="";
		for(int i=0;i<rfqVendLinesRetCnt;i++)  
		{
			String selQcf= rfqVendLinesRet.getFieldValueString(i,"QCFNO");
			String selRfq= rfqVendLinesRet.getFieldValueString(i,"RFQNO");
			String rfqVen= rfqVendLinesRet.getFieldValueString(i,"VENDOR"); 
			String tempVend= rfqVendLinesRet.getFieldValueString(i,"VENDOR"); 
			try{
					tempVend = Long.parseLong(tempVend)+"";
					tempVend = "0000000000"+tempVend;
					tempVend = tempVend.substring(tempVend.length()-10,tempVend.length());
				}catch(Exception e){} 			
			//String selVal= selQcf+"##"+selRfq+"##"+rfqVen;
			String selVal= selRfq;
			
			if(chkList.contains(rfqVen))
				continue;
			else
				chkList.add(rfqVen);	
			
			if(chkVen.contains(rfqVen))	
				checked="checked";
			else
				checked="";
			
			if("".equals(checked))checked="disabled";
				
			//if("FromQuote".equals(status)) checked="disabled";
				
%>		
						
				<th colspan=2 style="width:75px;text-align:center"><input class="" type="checkbox"  name="selVen" id="selVen" value="<%=selVal%>" <%=checked%> <%=readOnly%>>&nbsp;<%=gv_VendorsHT.get(tempVend)+"["+rfqVen+"]"%></th>
<%
		}
		
%>		
				</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=12 style="width:150px;text-align:left">Rank</th>
<%			
			chkList = new ArrayList();			
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))          
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
			
			String vend=rfqLinesRet.getFieldValueString(i,"VENDOR");
			
%>
			<th colspan=2 style="width:60px;text-align:center">
			<select class="form-control" name="rank" style="width:50%;display: inline-block;" disabled>
			<option valie="">Select Rank</option>
<%			
			Enumeration names = vendRankHT.keys(); 
			   while(names.hasMoreElements()) 
			   {
			      String key = (String) names.nextElement();
			      String val=(String)vendRankHT.get(key);
			      String rank=(String)rankWiseHT.get(vend);
			      String selectStr=""; 
			      if(val.equals(rank))selectStr="selected"; 
%>
				<option value="<%=vendRankHT.get(key)%>" <%=selectStr%>><%=vendRankHT.get(key)%></option>
<%	
			  }
%>
			</select>
			</th>   
<%			
			}
%>

<%
		if(!"FromQuote".equals(status))
		{
%>		
			<tr style="background-color:#575f9452 !important">
			<th colspan=12 style="width:150px;text-align:left">Reason</th>
			
<%			
			chkList = new ArrayList();
			int p=0;
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
				
						
%>
			<th colspan=2 style="width:60px;text-align:center">
			<div>
			<select class="form-control" name="reason<%=p%>" id="reason<%=p%>" style="width:50%;display: inline-block;" disabled>
			<option value="">Select Reason</option>
			<option value="SS" <%if("SS".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>Single Source</option>
			<option value="OEM" <%if("OEM".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%> >OEM</option>
			<option value="OAD" <%if("OAD".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>OEM-Authorized Dealer</option>
			<option value="SOP" <%if("SOP".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>SOP</option>
			<option value="LPO" <%if("LPO".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>LPO</option>
			</select>
			</div>
			</th>  

<%			p++;			
			}
%>
		</tr>
<%
		}
%>		
				<tr style="background-color:#575f9452 !important">
					<th colspan=12 style="width:150px;text-align:left">Quotation Ref.No.</th>
<%

		chkList = new ArrayList();
		for(int i=0;i<rfqVendLinesRetCnt;i++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));				
			
%>					
					<!--<th colspan=2 style="width:200px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"RFQNO")%>[RO]</th>-->
					<th colspan=2 style="width:60px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"RFQNO")%></th>
<%
		}
%>		
				</tr>
				<tr style="background-color:#575f9452 !important">
					<th colspan=12 style="width:150px;text-align:left">Payment Terms</th>
<%
		chkList = new ArrayList();			
		for(int i=0;i<rfqVendLinesRetCnt;i++) 
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));			
%>					
					<th colspan=2 style="width:60px;text-align:center"><%=pmntHash.get(rfqVendLinesRet.getFieldValueString(i,"PMNT"))%>[<%=rfqVendLinesRet.getFieldValueString(i,"PMNT")%>]</th>
					
<%
		}
%>
				</tr>
				<tr style="background-color:#575f9452 !important">
					<th colspan=12 style="width:150px;text-align:left">Inco Terms</th>
<%
		chkList = new ArrayList();			
		for(int i=0;i<rfqVendLinesRetCnt;i++)    
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=2 style="width:60px;text-align:center"><%=incoHash.get(rfqVendLinesRet.getFieldValueString(i,"INCO"))%>[<%=rfqVendLinesRet.getFieldValueString(i,"INCO")%>]</th>
					
<%
		}
%>
		</tr>	
			<tr style="background-color:#575f9452 !important">
			<th rowspan=2  style="width:100px;text-align:center">S.No.</th>
			<th rowspan=2  style="width:200px;text-align:center">Material</th>
			<th rowspan=2  style="width:100px;text-align:center">Description</th>
			<th rowspan=2  style="width:100px;text-align:center">Mat Group</th>
			<th rowspan=2  style="width:100px;text-align:center">Item<br>Text</th>
			<th rowspan=2  style="width:100px;text-align:center">PO<br>Text</th>
			<th rowspan=2  style="width:100px;text-align:center">UOM</th>
			<th rowspan=2  style="width:100px;text-align:center">Qty</th>
			<th rowspan=2  style="width:100px;text-align:center">PR No.</th>
			<th rowspan=2  style="width:50x;text-align:center">PR Item.</th>
			<th rowspan=2  style="width:50px;text-align:center">Budget Price</th>
			<th rowspan=2  style="width:50px;text-align:center">Last PO <br> Price</th>
					
					
				
<%		
		chkList = new ArrayList();
		for(int i=0;i<rfqVendLinesRetCnt;i++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
				<!--<th style="width:80px;text-align:center">Rate<br>Rs./UOM </th>
				<th style="width:100px;text-align:center">Total<br>Amount Rs.</th> -->
				<th style="width:100px;text-align:center">Rate<br>Rs./UOM </th>
				<th style="width:100px;text-align:center">Total<br>Amount Rs.</th>
				<!--<th style="width:100px;text-align:center">Qty<br>Recommended</th> -->
				
<%
		}
%>
		</tr>	
		</thead>
		<tbody>
<%      	 rfqLinesList = new ArrayList();
		for(int i=0;i<rfqLinesRetCnt;i++)
		{
			String qcfH = rfqLinesRet.getFieldValueString(i,"QCFNO");
			String lineH = rfqLinesRet.getFieldValueString(i,"LINENO");
			String vend=rfqLinesRet.getFieldValueString(i,"VENDOR");
			String payMentType=checkNull(rfqLinesRet.getFieldValueString(i,"PAYMENTTYPE"));
			String leadDays=checkNull(rfqLinesRet.getFieldValueString(i,"LEADTIME"));
			String percent=checkNull(rfqLinesRet.getFieldValueString(i,"PERCENT"));
			if("".equals(percent))percent="NA";
			vendWisePaymentTypeHT.put(vend,payMentType+"#"+leadDays+"#"+percent);
 
			if(rfqLinesList.contains(rfqLinesRet.getFieldValueString(i,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(i,"LINENO")))
				continue;
			else
				rfqLinesList.add(rfqLinesRet.getFieldValueString(i,"QCFNO")+"##"+rfqLinesRet.getFieldValueString(i,"LINENO"));

			String myQty = rfqLinesRet.getFieldValueString(i,"QTY");

			try
			{
				myQty = (Double.parseDouble(myQty))+"";
				myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e){}
			totalQuantity=totalQuantity+Double.parseDouble(myQty);  
			
			String purOrg =(String)dtlXML.getFieldValueString(0,"ERH_PUR_ORG");
			ezc.ezcommon.EzLog4j.log(":::purOrg:::::"+purOrg,"I");
		
	//To fetch last PO price			
	java.math.BigDecimal netPR=new java.math.BigDecimal(0);
	JCoFunction function =null;	
	String logonSite = (String)session.getValue("SITE");

		JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
		function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_LAST_PO_PRICE");

		JCoParameterList sapPreProc = function.getImportParameterList();
		sapPreProc.setValue("PUR_ORG",purOrg);

		JCoParameterList sapTabParam= function.getTableParameterList();
		JCoTable poItemTable = sapTabParam.getTable("POITEMS");

		poItemTable.appendRow();
		
		//poItemTable.setValue("MATNR","000000000000402102");
		String matNo = rfqLinesRet.getFieldValueString(i,"MATERIAL");
		matNo ="000000000000000000"+matNo;
		matNo =matNo.substring(matNo.length()-18);
		poItemTable.setValue("MATNR",matNo);

		try
		{
			function.execute(destination);
		}catch(Exception qe){
			ezc.ezcommon.EzLog4j.log("Exception in Z_EZ_GET_LAST_PO_PRICE FM Exectution:::::::::::::::"+qe,"I");
		}	


		int poCnt =0;
		ArrayList items =null;
		JCoTable sapPoList = function.getTableParameterList().getTable("POITEMS"); 
		poCnt 	= 	sapPoList.getNumRows();
		ezc.ezcommon.EzLog4j.log("poCnt:::::::::::::::"+poCnt,"I");
		ezc.ezparam.ReturnObjFromRetrieve myRet= null;

		if(poCnt > 0)
		{
			myRet= new ReturnObjFromRetrieve(new String[]{"VENDOR","VENDNAME","PLANT","MATERAIL","PONUM","CREATED_ON","UOM","CURRENCY","NETPR"});

		try 
		{		
			do
			{
				String chkStr = (String)sapPoList.getValue("EBELN");
				//if(chkStr.startsWith("6"))
				 	//continue;
				myRet.setFieldValue("VENDOR", sapPoList.getValue("LIFNR"));		
				myRet.setFieldValue("VENDNAME",sapPoList.getValue("NAME1"));		
				myRet.setFieldValue("PLANT",sapPoList.getValue("WERKS"));
				myRet.setFieldValue("MATERAIL",sapPoList.getValue("MATNR"));
				myRet.setFieldValue("PONUM",sapPoList.getValue("EBELN"));
				myRet.setFieldValue("CREATED_ON",sapPoList.getValue("AEDAT"));
				myRet.setFieldValue("UOM",sapPoList.getValue("MEINS"));
				myRet.setFieldValue("CURRENCY",sapPoList.getValue("WAERS"));
				myRet.setFieldValue("NETPR",sapPoList.getValue("NETPR"));
				myRet.addRow();


				String rfqPlant=(String)dtlXML.getFieldValueString(0,"ERD_PLANT");
				String lastPOPlant=(String)sapPoList.getValue("WERKS");
				if(netPR.compareTo(java.math.BigDecimal.ZERO)!=0)
					if(rfqPlant.equals(lastPOPlant))
						netPR=(java.math.BigDecimal)sapPoList.getValue("NETPR");

			  		ezc.ezcommon.EzLog4j.log("rfqPlant"+rfqPlant,"I");
			  		ezc.ezcommon.EzLog4j.log("lastPOPlant"+lastPOPlant,"I");
			  		
			  }while(sapPoList.nextRow());
			  		
			  		//out.println("myRet"+myRet.toEzcString());

		}
		catch (Exception e) {}
			
		String netPrStr= checkNull(myRet.getFieldValueString(0,"NETPR"));   
		java.math.BigDecimal netprBD=new java.math.BigDecimal(netPrStr);
		if(netPR.compareTo(java.math.BigDecimal.ZERO)==0)netPR=netprBD;
		}
		totPOPrice=(netPR.doubleValue()*Double.parseDouble(myQty))+totPOPrice;
		totPOPriceStr=new java.math.BigDecimal(totPOPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		String prNum=rfqVendLinesRet.getFieldValueString(i,"PRDET").split("¥")[0];
		
      		String budgetPrice = "0";
      		
		ezc.ezparam.ReturnObjFromRetrieve budgetRet	=  null;
		    		
      		//Getting Budget Price
      	
      		String qryStr="SELECT EMBP_BASIC_PRICE FROM EZC_MAT_BUDGET_PRICE WHERE EMBP_MATERIAL='"+matNo+"'" ;
		ezc.ezcommon.EzLog4j.log("** qryStrPRICE>>>"+qryStr,"I");

		quoteTableRow.setQuery(qryStr);
		quoteTable.appendRow(quoteTableRow);
		quoteParams.setLocalStore("Y");
		quoteParams.setObject(quoteTable);
		Session.prepareParams(quoteParams);  
		
		
		try
		{
			budgetRet=(ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(quoteParams);
		
		}
		catch(Exception e)
		{
			out.println("Exception in getting conditions>>>>>"+e);
		}
		
		if(budgetRet!=null && budgetRet.getRowCount()>0)
		{
			budgetPrice = budgetRet.getFieldValueString(0,"EMBP_BASIC_PRICE");

		}				

	
%>	
		<input type=hidden name="rfqItem" value="<%=i%>">		      	
				<tr>
					
					<td style="width:100px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"LINENO")%>&nbsp;</td> 
					<td style="width:100px;text-align:center" >
					<%try{
						out.println(Long.parseLong(rfqLinesRet.getFieldValueString(i,"MATERIAL")));
					     }catch(Exception e){
						out.println(rfqLinesRet.getFieldValueString(i,"MATERIAL")); 
					     }%>&nbsp;</td>
					<td style="width:200px;text-align:center;" ><%=rfqLinesRet.getFieldValueString(i,"MATDESC")%>&nbsp;</td>
					<td style="width:200px;text-align:center;" ><%=checkNull(rfqLinesRet.getFieldValueString(i,"MATGRP"))%>&nbsp;</td>
					<td style="width:200px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"))%>','I')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 
					<td style="width:100px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"POTEXT"))%>','P')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 
					<td style="width:200px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"UOM")%>&nbsp;</td>
					<td style="width:20px;text-align:center"><input type="hidden" name="prItemQty<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" id="prItemQty<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" value="<%=myQty%>"><%=myQty%></td>
					
					<%if("RFQ".equals(prNum)){%>
					<td style="width:150px;text-align:center" >From Material</td>
					<%}else{%>
					<td style="width:150px;text-align:center" >
					<%=(rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[0]%></td>
					<td>
					<%=Long.parseLong((rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[1])%>
					</td><%}%> 
					<td style="width:100px;text-align:center" ><%=budgetPrice%></td>
					<td style="width:100px;text-align:center" >
					<%if(netPR.compareTo(java.math.BigDecimal.ZERO)==0){%>
					<a><b><%=netPR%></b></a>&nbsp; 
					<!--<a href="javascript:openLastPO('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>-->
					<%}else{%>
					    
					<a><b><%=netPR%></b></a>&nbsp; 
					<a href="javascript:openLastPO('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>
					<%}%>
					</td>
<%
					//chkList = new ArrayList();  
					for(int j=0;j<rfqVendLinesRetCnt;j++)
					{
						/*if(chkList.contains(rfqVendLinesRet.getFieldValueString(j,"RFQNO")))
							continue; 
						else
							chkList.add(rfqVendLinesRet.getFieldValueString(j,"RFQNO"));*/
							
						String vendorLoop=rfqLinesRet.getFieldValueString(j,"VENDOR");	 
						
						if(qcfH.equals(rfqVendLinesRet.getFieldValueString(j,"QCFNO")) && lineH.equals(rfqVendLinesRet.getFieldValueString(j,"LINENO")))
						{
						String material="";
						try{
						material=(Long.parseLong(rfqLinesRet.getFieldValueString(i,"MATERIAL")))+"";
						}catch(Exception e){
						material=rfqLinesRet.getFieldValueString(i,"MATERIAL");
						}
						String quotCurr = rfqVendLinesRet.getFieldValueString(j,"CURR");
								if("".equals(quotCurr) || "null".equals(quotCurr) || quotCurr==null) quotCurr = "INR";
						String HSNCode=	rfqVendLinesRet.getFieldValueString(j,"HSNCODE");	
						String quotPrice = rfqVendLinesRet.getFieldValueString(j,"PRICE");
						if("".equals(quotPrice) || "null".equals(quotPrice) || quotPrice==null) quotPrice = "0";
						try
						{
							quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e){}
						
						try
						{
							totVal= (Double.parseDouble(myQty) * Double.parseDouble(quotPrice));
							totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totVal = 00.0;
						}
						String leaddays1 = checkNull(rfqVendLinesRet.getFieldValueString(j,"LEADDAYS"));
						String leaddaysCurr = checkNull(rfqVendLinesRet.getFieldValueString(j,"LEADVAL"));
						String leaddaysHis = checkNull(rfqVendLinesRet.getFieldValueString(j,"LEADHISVAL"));
						ezc.ezcommon.EzLog4j.log("leaddaysCurr:::::::::::::::"+leaddaysCurr,"I");   
						ezc.ezcommon.EzLog4j.log("leaddaysHis:::::::::::::::"+leaddaysHis,"I");   
						String quotHisPrice = rfqVendLinesRet.getFieldValueString(j,"PRICEHIS");   
						if("".equals(quotHisPrice) || "null".equals(quotHisPrice) || quotHisPrice==null) quotHisPrice = "0";
						try
						{
							quotHisPrice  = new java.math.BigDecimal(quotHisPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}						
						catch(Exception e){}
						try
						{
							totHisVal= (Double.parseDouble(myQty) * Double.parseDouble(quotHisPrice));
							totHisValStr  = new java.math.BigDecimal(totHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totHisVal = 00.0;
						}
						//out.println("quotHisPrice"+quotHisPrice+"myQty"+myQty);
						String styleCl="";  
						String keyStr=rfqLinesRet.getFieldValueString(i,"MATERIAL")+"#"+rfqVendLinesRet.getFieldValueString(j,"VENDOR")+"#"+rfqVendLinesRet.getFieldValueString(j,"RFQNO");
						String chkStr=rfqVendLinesRet.getFieldValueString(j,"RFQNO")+rfqVendLinesRet.getFieldValueString(j,"LINENO");
						String chkRfq=rfqVendLinesRet.getFieldValueString(j,"RFQNO");
						String chkLine=rfqVendLinesRet.getFieldValueString(j,"LINENO");
						ezc.ezcommon.EzLog4j.log("chkRfq:::::::::::::::"+chkRfq,"I");	
						if(!rfqList.contains(chkRfq))
						{
							x++;
							rfqList.add(chkRfq);
							rfqHash.put(x,chkRfq);
						}	
						ezc.ezcommon.EzLog4j.log("chkRfq:::::::::::::::"+chkRfq,"I");						
						
						discType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCTYPE")); 
						condDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCVAL"));
						condGST	 =checkNull(rfqVendLinesRet.getFieldValueString(j,"TAXVAL"));
						if("".equals(condDisc) || "null".equals(condDisc) || condDisc==null) condDisc = "0";
						if("".equals(condGST) || "null".equals(condGST) || condGST==null) condGST = "0";
						
						try
						{
							if("P".equals(discType))
								discVal= Double.parseDouble(quotPrice) * Double.parseDouble(condDisc)/100;
							else if("Q".equals(discType))
								discVal= Double.parseDouble(condDisc) * Double.parseDouble(myQty);
							else if("V".equals(discType))
								discVal= Double.parseDouble(condDisc);			

							discValStr  = new java.math.BigDecimal(discVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							discVal = 00.0;
						}
						try
						{
							discTotVal= Double.parseDouble(quotPrice)-discVal;
							//out.println("quotPrice"+quotPrice+"discVal"+discVal);
							basicVal=Double.parseDouble(quotPrice)-discVal;
							if(basicVal<0)basicVal=0.0;
							basicValStr  = new java.math.BigDecimal(basicVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
							discTotValStr  = new java.math.BigDecimal(discTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{ 
							discTotVal = 00.0;  
						}				
						discHisType = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCHISTYPE"));
						condHisDisc = checkNull(rfqVendLinesRet.getFieldValueString(j,"DISCHISVAL"));
						if("".equals(condHisDisc) || "null".equals(condHisDisc) || condHisDisc==null) condHisDisc = "0";
						try
						{
							if("P".equals(discHisType))
								discHisVal= totHisVal * Double.parseDouble(condHisDisc)/100;
							else if("Q".equals(discHisType))
								discHisVal= Double.parseDouble(condHisDisc) * Double.parseDouble(myQty);
							else if("V".equals(discHisType))
								discHisVal= Double.parseDouble(condHisDisc);			

							discHisValStr  = new java.math.BigDecimal(discHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{ 
							discHisVal = 00.0;
						}
						try
						{
							if("P".equals(discHisType))
								discUOMHisVal=  Double.parseDouble(quotHisPrice) * Double.parseDouble(condHisDisc)/100;
							else if("Q".equals(discHisType))
								discUOMHisVal= Double.parseDouble(condHisDisc) * Double.parseDouble(myQty);
							else if("V".equals(discHisType))
								discUOMHisVal= Double.parseDouble(condHisDisc);			

							discUOMHisValStr  = new java.math.BigDecimal(discUOMHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							discHisVal = 00.0;
						}
						//out.println("discHisVal"+discHisVal);
						String basicUOMHisStr="";
						double basicUOMHis=0.0;
						try
						{
							basicUOMHis =Double.parseDouble(quotHisPrice)-discUOMHisVal;
							if(basicUOMHis<0)basicUOMHis=0.0;
							basicUOMHisStr  = new java.math.BigDecimal(basicUOMHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
							discHisTotVal= totHisVal-discHisVal;
							basicValHis=totHisVal-discHisVal;
							basicValHisStr  = new java.math.BigDecimal(basicValHis).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
							discHisTotValStr  = new java.math.BigDecimal(discHisTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{ 
							discHisTotVal = 00.0;  
						}
												//out.println("keyStr"+keyStr);
						try
						{
							totVal= (Double.parseDouble(myQty) * basicVal);
							totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totVal = 00.0;
						}
						try
						{
							totHisVal= (Double.parseDouble(myQty) * basicUOMHis);
							totHisValStr  = new java.math.BigDecimal(totHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totHisVal = 00.0;   
						}
						//Recommended Quantity
						String qtyRec = "0";
						

						try
						{
							qtyRec =  rfqVendLinesRet.getFieldValueString(j,"POQTY");  
							qtyRec = (Double.parseDouble(qtyRec))+"";
							qtyRec  = new java.math.BigDecimal(qtyRec).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e){
							qtyRec="0";
						}
						ezc.ezcommon.EzLog4j.log(":::qtyRecDec:::::"+qtyRec,"I");      						
						
						String saphsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPHSNCODE")); 
						String sapgstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPGSTCODE")); 
						String gstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"GSTCODE"));
						String hsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"HSNCODE"));  
						//   out.println(minMatHT+"minMatHT");
						double minMatCost=minMatHT.get(material);
						if(totVal==minMatCost)styleCl="background-color:greenyellow;";
%>
						<!--<td style="width:100px;text-align:center" ><%=basicUOMHisStr%>&nbsp;<a href="javascript:openDet('<%=quotHisPrice%>','<%=leaddaysHis%>','<%=condHisDisc%>','<%=discHisType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>&nbsp;</td>  
						<td style="width:100px;text-align:center" ><%=totHisValStr%>&nbsp;</td>  -->
						<td  style="width:100px;text-align:center;" ><input type="hidden" name="itemPrice<%=chkStr%>" id="itemPrice<%=chkStr%>" value="<%=basicValStr%>"><%=basicValStr%>&nbsp;<a href="javascript:openDet('<%=quotPrice%>','<%=leaddaysCurr%>','<%=condDisc%>','<%=discType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a></td>
						<td  style="width:100px;text-align:center;<%=styleCl%>" ><%=totValStr%>&nbsp;</td>
						<!--<td  style="width:100px;text-align:center;"><input type="number" name="rfqQty<%=chkStr%>" id="rfqQty<%=chkStr%>" value="<%=qtyRec%>" onchange="calcBot('<%=chkStr%>','<%=chkRfq%>','<%=chkLine%>')"  <%=readOnly%>></td>-->
<%
						}
					}
%>
			</tr>
<%			
			}		

%>			
			</tbody>
			</table>
			</div>
			

		  </div>
		</div> 
		</div>  
<%
	if(retWFDocDetails != null && retWFDocDetails.getRowCount() > 0)
	{
		//docVal = auctionHeader.getFieldValueString(0,"EAH_CATEGORY");
		wfStatus=retWFDocDetails.getFieldValueString(0,"EWDHH_WF_STATUS");
		wfCurStep = Integer.parseInt(retWFDocDetails.getFieldValueString(0,"EWDHH_CURRENT_STEP"));
		wfTemplate = retWFDocDetails.getFieldValueString(0,"EWDHH_TEMPLATE_CODE");
		wfNextPart = retWFDocDetails.getFieldValueString(0,"EWDHH_NEXT_PARTICIPANT");

		if("SUBMITTED".equals(wfStatus) || "REJECTED".equals(wfStatus))
		{
			if(workGrpVect != null && workGrpVect.contains(wfNextPart))
			{
				ReturnObjFromRetrieve retWFDetails = getWFDetails(Session,wfTemplate,wfCurStep,wfNextPart);
				BigDecimal cmpVal=BigDecimal.valueOf((Long)retWFDetails.getFieldValue(0,"EWPC_QCF_RELEASE"));
				String cmpOp = retWFDetails.getFieldValueString(0,"EWPC_QCF_FLAG");
				//out.println("cmpOp>>>"+cmpOp);
				//out.println("cmpVal>>>"+cmpVal);
				if("LE".equals(cmpOp))
				{	
					if(cmpVal.compareTo(BigDecimal.ZERO) == 0 || cmpVal.compareTo(docVal) <= 0)
					{
						showSubmit=true;
						showReject=true;
					}
					else
					{
						showApprove=true;
						showReject=true;
					}
				}
				if("GE".equals(cmpOp))
				{	
					if(docVal.compareTo(cmpVal) >= 0)
					{
						showApprove=true;
						showReject=true;
					}
					else
					{
						showSubmit=true;
						showReject=true;
					}	
				}				
			}
		}
	}
	else
	{
		showCreate=true;
	}
	
	//COMMENTS
	int retComCnt =0;
	ReturnObjFromRetrieve retCom = null; //getDocComments(Session,qcfNo,"QCF");
	
	if(retCom!= null)
		retComCnt = retCom.getRowCount();
	if("Sub".equals(status))
	{
	if(retComCnt > 0)
	{
%>
	
	<div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<h4>
		Comments
	</h4>	
	<table class="table table-bordered" id="example">
	<thead>           
			<th>Name</th>
			<th>Comments Date</th>
			<th>Comments</th>
							        
	</thead>
	<tbody>
<%
			for(int s=0;s<retCom.getRowCount();s++)
			{
				String userid = checkNull(retCom.getFieldValueString(s,"EU_FIRST_NAME").toUpperCase());
				String commentedOn = checkNull(retCom.getFieldValueString(s,"EDC_DATE"));
				String comments = checkNull(retCom.getFieldValueString(s,"EDC_COMMENTS"));
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = formatter.parse(commentedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				String commentedOnDate = formatter.format(date);				
	
%>	
			<tr>
				<td align="center"><%=userid%></td>
				<td align="center"><%=commentedOnDate%></td>
				<td align="center"><%=comments%></td>
			</tr>

<%
			}
%>
			
	</tbody>
	</table>
	</div>
	</div>	
	</div>
	</div>
<%
	}
%>	
	<div class="row">
		<div class="col-xs-12" align="center">
			<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)" ><i class="fa fa-backward"></i>&nbsp;Back</button>	
			<button id="btnExport" class="btn btn-primary" onclick="fnExcelReport();"> <i class="fa fa-check"></i>&nbsp;Download Excel </button>
			<button id="btnExport" class="btn btn-primary" onclick="createPO();"> <i class="fa fa-check"></i>&nbsp;Create PO </button>
		</div>
	</div>
<%
	}
	//if("WF".equals(status))
	//{
%>			
		
		<div class="row">
		<div class="col-md-12 col-xs-12">
		<div class="box box-primary">
		<div class="box-body">
		<h4>
				 Comments
		</h4>
			<table class="table table-bordered">
				<td colspan=3><textarea class="form-control" name="comment" placeholder="Enter Comments" rows="2" ></textarea></td>
			</table>
		</div>
		</div>
		</div>
		</div>		
			<div class="row">
			<div class="col-xs-12" align="center">
				<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)" ><i class="fa fa-backward"></i>&nbsp;Back</button>
<%

			if(showCreate)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funCreateWF()" style="margin-right: 5px;"><i class="fa fa-check"></i> Submit</button>
<%
			}
			if(showSubmit)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('SUBMITTED')" style="margin-right: 5px;"><i class="fa fa-check"></i> Submit</button>
<%
			}
			if(showApprove)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('APPROVED')" style="margin-right: 5px;"><i class="fa fa-check"></i> Approve</button>
<%
			}
			if(showReject)	
			{
%>
<%
			}	
%>
			<button type="button" class="btn btn-primary" onclick="funShowApprovalHirearchy('5000','<%=(String)dtlXML.getFieldValueString(0,"ERD_PLANT")%>','RM_PM','300000')" style="margin-right: 5px;"><i class="fa fa-users"></i> Show Approval Hirearchy</button>
			<button type="button" class="btn btn-primary" onclick="funAuditTrail('<%=qcfNo%>','QCF')" style="margin-right: 5px;"><i class="fa fa-list"></i> Audit Trail</button>			
			<!--<button id="btnExport" class="btn btn-primary" onclick="fnExcelReport();"> <i class="fa fa-check"></i>&nbsp;Download Excel </button>-->
			<!--<button type="button" class="btn btn-primary" onclick="funPrint()" ><i class="fa fa-check"></i>&nbsp;Print</button>-->
		</div>
 	 	</div>	
<%
	//}
%> 	 	
		</div>
<input type="hidden" name="submitType" value="">
<input type="hidden" name="wfTemplate" value="<%=wfTemplate%>">
<input type="hidden" name="wfCurStep" value="<%=wfCurStep%>">
<input type="hidden" name="wfNextPart" value="<%=wfNextPart%>">
<input type="hidden" name="docVal" value="<%=docVal%>">
		
	
</form>
<!--<iframe id="txtArea1" style="display:none"></iframe>-->
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
</body>
</html>

<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>

<script src="../Misc/library/js/tableHeadFixer.js"></script>
<script>
/*
$(document).ready(function() {
$("#table-1").tableHeadFixer({"left" : 7}); 
}); */
$( function() {

$(".sidebar-toggle").trigger("click"); 
});


function funBack()
{
	
	document.myForm.action ="ezListQcfs.jsp"; 
	document.myForm.submit(); 
		
}
function funDownloadExcel()
{
document.myForm.action="ezQCFDownloadExcel.jsp";
document.myForm.submit();
}
function funSubmit(submitType)
{	
	document.myForm.submitType.value=submitType;
	document.myForm.action="ezUpdateQCFWF.jsp"
	document.myForm.submit()
}
function funShowApprovalHirearchy(compCode,plant,category,docValue)
{
	var url="../Misc/ezShowApprovalHirearchy.jsp?compCode="+compCode+"&plant="+plant+"&category="+category+"&docValue="+docValue;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
function funAuditTrail(docId,docType)
{
	var url="../Misc/ezShowAuditTrail.jsp?docId="+docId+"&docType="+docType;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
function closeIframe()
{
	   $('#woModal').modal('toggle');
}
function funSubmit1()
{

			var chkObj = document.myForm.selVen;
			var len = chkObj.length;
			var count = 0;
			var chkVal;
			var reason;
			var chkCount = 0;

			if(isNaN(len))
			{
				if(chkObj.checked)
				{
					count++;
				}
			}
			else
			{
				for(i=0;i<len;i++)
				{
					if(chkObj[i].checked)
					{
						count++;
					}
				}
			}
			
			if(count==0)
			{
				alert("Please select atleast one vendor");
				return;
			}
			
			if(isNaN(len))
			{
				chkVal = chkObj.value;
				reason=document.getElementById("reason0").value;
				chkVal=chkVal+'#'+reason;
			}
			else
			{
				var countChk = 0;
				for(i=0;i<len;i++)
				{
					if(chkObj[i].checked)
					{
						countChk++;
						if(countChk==1)
						{
							chkVal = chkObj[i].value;
							reason=document.getElementById("reason"+i).value;
							chkVal=chkVal+'#'+reason;
						}
						else
						{
							reason=document.getElementById("reason"+i).value;
							chkVal = chkVal+','+chkObj[i].value+'#'+reason;  
						} 
						//alert("reason>>>"+reason);
						if(reason=="")
						{
							alert("Please select reason");
							return;
						}
						
					}
				}
			}
			
			//alert("chkVal"+chkVal);
			document.myForm.chkVal.value  = chkVal;
			if(document.myForm.comment.value=="")
			{
				alert("Please Enter Comments");
				document.myForm.comment.focus()
				return;
			}				
		       
		       if(confirm("Are sure to submit the QCF Form?"))
		       {
		       		document.myForm.action="ezSaveQuotationComparisionForm.jsp"; 
		       		document.myForm.submit();
        	       }
}        	       
function funPrint()
{
	window.print();
}
function createPO()
{
	document.myForm.action="ezCreatePO.jsp";
	document.myForm.submit();
}
function fnExcelReport()
{
    var tab_text="<table border='2px'><tr bgcolor='#87AFC6'>";
    var textRange; var j=0;
    tab = document.getElementById('table-1'); // id of table

    for(j = 0 ; j < tab.rows.length ; j++) 
    {     
        tab_text=tab_text+tab.rows[j].innerHTML+"</tr>";
        //tab_text=tab_text+"</tr>";
    }
 
tab_text=tab_text+"</table>";
    tab_text= tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
    tab_text= tab_text.replace(/<img[^>]*>/gi,""); // remove if u want images in your table
    tab_text= tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE "); 

    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
    {
        txtArea1.document.open("txt/html","replace");
        txtArea1.document.write(tab_text);
        txtArea1.document.close();
        txtArea1.focus(); 
        sa=txtArea1.document.execCommand("SaveAs",true,"QCF.xls");
    }  
    else     
    {
    	 let a = $("<a />", {
             href: 'data:application/vnd.ms-excel,' + encodeURIComponent(tab_text),
             download: "QCF_<%=qcfNo%>.xls"
         })
         .appendTo("body")
         .get(0)
         .click();
         e.preventDefault();
   }   

    return (sa);
}
function openLastPO(mat)
{ 
	var url="ezLastPOPriceDet.jsp?mat="+mat;
	$.fancybox.open({
		href : url, 
		type : 'iframe',
		
		width:'80%',
		height:'78%',
		autoSize : false,
		closeBtn : false,
		keys : {
		    close  : true,
		},			
		helpers     : {  
			overlay : {closeClick: false}
			}
		});

}
function openLongItem(mat,text,type)
{ 
	var url="ezItemTextPopup.jsp?mat="+mat+"&text="+text+"&type="+type;     


	$('iframe').attr("src",url);

	$.fancybox.open({
		href : url, 
		type : 'iframe',
		
		width:'80%',
		height:'50%',
		autoSize : false,
		closeBtn : false,
		keys : {
		    close  : true,
		},			
		helpers     : {  
			overlay : {closeClick: false}
			}
		});  				

}
function openDet(basicVal,leadDays,disc,type,sapHsn,sapGst,gst,hsn)
{ 
	var url="ezDiscDet.jsp?basicVal="+basicVal+"&leadDays="+leadDays+"&disc="+disc+"&type="+type+"&sapHsn="+sapHsn+"&sapGst="+sapGst+"&gst="+gst+"&hsn="+hsn;
	$.fancybox.open({
		href : url, 
		type : 'iframe',
		
		width:'40%',
		height:'40%',
		autoSize : false,
		closeBtn : false,
		keys : {
		    close  : true,
		},			
		helpers     : {  
			overlay : {closeClick: false}
			}
		});

} 
function calcBot(chkStr,chkRfq,chkLine)
{ 
	
		//alert("chkStr"+chkStr);
		//alert("chkRfq"+chkRfq);
		//alert("chkLine"+chkLine);
		var itemQtyObj = eval("document.myForm.rfqQty"+chkRfq+chkLine);
		//alert("itemQtyObj"+itemQtyObj.value);
		if(itemQtyObj.value=='')
		{
			alert("Enter Recommended Qty at line"+chkLine+" against RFQ:"+chkRfq);
			itemQtyObj.value=0;
			itemQtyObj.focus()
			return;
		}
		
		var prItemQtyObj = eval("document.myForm.prItemQty"+chkLine);
		//alert("prItemQtyObjNew"+prItemQtyObj.value);
		
		if( parseFloat(itemQtyObj.value) > parseFloat(prItemQtyObj.value))
		{
			alert("Recommended Qty should not be greater than PR Qty at line"+chkLine+" against RFQ:"+chkRfq);
			itemQtyObj.value=0;
			itemQtyObj.focus()
			return;
		}
		var rfqCount='<%=rfqHash.size()%>';
		//alert("rfqCount>>>>"+rfqCount);
		var lineTotQty=0;		
		var lineTotQty=0;
<%
		for(int j=0;j<rfqHash.size();j++)
		{
			String  rfqChk = (String)rfqHash.get(j+1);
%> 
			var rfqChk= '<%=rfqChk%>';
			//alert("rfqChk>>>"+rfqChk);
			var lineQtyObj = eval("document.myForm.rfqQty"+rfqChk+chkLine);
			//alert("lineQtyObj>>>"+lineQtyObj.value);
			lineTotQty=lineTotQty+parseFloat(lineQtyObj.value);
<%
		}
%>
		//alert("lineTotQty>>>"+lineTotQty);
		//alert("prItemQtyObj>>>"+prItemQtyObj.value);
		if(lineTotQty >prItemQtyObj.value)
		{
			alert("Total Line Qty should not be greater than PR Qty at line"+chkLine);
			itemQtyObj.value=0;
			itemQtyObj.focus()
			return;
		}
		var Count='<%=(rfqLinesRetCnt/2)%>';
		//alert("Count"+Count);
		var botTotValObj = eval("document.myForm.botTotVal"+chkRfq);
		var botPKGValObj = eval("document.myForm.botPKGVal"+chkRfq);		
		var botFRTValObj = eval("document.myForm.botFRTVal"+chkRfq);
		var botBFRTValObj = eval("document.myForm.botBFRTVal"+chkRfq);
		var botINSValObj = eval("document.myForm.botINSVal"+chkRfq);
		var botSupValObj = eval("document.myForm.botSupVal"+chkRfq);
		var itemGSTObj = eval("document.myForm.itemGST"+chkRfq);
		var botGSTValObj = eval("document.myForm.botGSTVal"+chkRfq);
		var botLCValObj = eval("document.myForm.botLCVal"+chkRfq);
		var itemPKFWObj = eval("document.myForm.itemPKFW"+chkRfq);
		var valTypePKFWObj = eval("document.myForm.valTypePKFW"+chkRfq);		
		var itemFRTObj = eval("document.myForm.itemFRT"+chkRfq);
		var valTypeFRTObj = eval("document.myForm.valTypeFRT"+chkRfq);
		var itemBFRTObj = eval("document.myForm.itemBFRT"+chkRfq);
		var valTypeBFRTObj = eval("document.myForm.valTypeBFRT"+chkRfq);				
		var itemINSObj = eval("document.myForm.itemINS"+chkRfq);
		var valTypeINSObj = eval("document.myForm.valTypeINS"+chkRfq);				
		var totPriceVal=0;
		var totalQuantity=0.0;
		for(var k=0;k<Count;k++)
		{
			var itemQtyObj = eval("document.myForm.rfqQty"+chkRfq+((k+1)*10));
			//alert("itemQtyObj"+itemQtyObj.value);
			var itemPriceObj = eval("document.myForm.itemPrice"+chkRfq+((k+1)*10));
			//alert("itemPriceObj"+itemPriceObj.value);
			var itemValObj = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 
			//alert("itemValObj"+parseFloat(itemValObj));
			totalQuantity=(parseFloat(totalQuantity)+parseFloat(itemQtyObj.value)).toFixed(2);
			totPriceVal=(parseFloat(totPriceVal)+parseFloat(itemValObj)).toFixed(2);
			
		}
		//alert("totalQuantity>>>>"+totalQuantity);
		//alert(totPriceVal);
		totPriceVal=(parseFloat(totPriceVal)).toFixed(2); 	
		botTotValObj.value = totPriceVal;
		if(totalQuantity>0)
		{
			if(valTypePKFWObj.value == "P")
				botPKGValObj.value = (((botTotValObj.value) * itemPKFWObj.value)/100).toFixed(2);
			if(valTypePKFWObj.value == "V")
				botPKGValObj.value = eval("document.myForm.itemPKFWVal"+chkRfq).value;
			if(valTypePKFWObj.value == "Q")
				botPKGValObj.value = itemPKFWObj.value * parseFloat(totalQuantity);
				
			if(valTypeFRTObj.value == "P")
				botFRTValObj.value = (((botTotValObj.value) * itemFRTObj.value)/100).toFixed(2);
			if(valTypeFRTObj.value == "V")
				botFRTValObj.value = eval("document.myForm.itemFRTVal"+chkRfq).value;
			if(valTypeFRTObj.value == "Q")
				botFRTValObj.value = itemFRTObj.value * parseFloat(totalQuantity);
				
			if(valTypeBFRTObj.value == "P")
				botBFRTValObj.value = (((botTotValObj.value) * itemBFRTObj.value)/100).toFixed(2);
			if(valTypeBFRTObj.value == "V")
				botBFRTValObj.value = eval("document.myForm.itemBFRTVal"+chkRfq).value;
			if(valTypeBFRTObj.value == "Q")
				botBFRTValObj.value = itemBFRTObj.value * parseFloat(totalQuantity);				
				
			if(valTypeINSObj.value == "P")
				botINSValObj.value = (((botTotValObj.value) * itemINSObj.value)/100).toFixed(2);
			if(valTypeINSObj.value == "V")
				botINSValObj.value = eval("document.myForm.itemINSVal"+chkRfq).value;
			if(valTypeINSObj.value == "Q")
				botINSValObj.value = itemINSObj.value * parseFloat(totalQuantity);								
			
			var itemSupplyPrice = (parseFloat(botTotValObj.value)+ parseFloat(botPKGValObj.value) + parseFloat(botFRTValObj.value)+ parseFloat(botBFRTValObj.value)+ parseFloat(botINSValObj.value)).toFixed(2);
			botSupValObj.value= itemSupplyPrice;
			botGSTValObj.value = ((parseFloat(botSupValObj.value)) * parseFloat(itemGSTObj.value)/100).toFixed(2);
			botLCValObj.value = (parseFloat(botSupValObj.value) + parseFloat(botGSTValObj.value)).toFixed(2);
		}
		else
		{
			botPKGValObj.value = "0.00";
			botFRTValObj.value = "0.00";
			botBFRTValObj.value = "0.00";
			botINSValObj.value = "0.00";
			botSupValObj.value = "0.00";
			botGSTValObj.value = "0.00";
			botLCValObj.value = "0.00";
		}	
}
</script>
