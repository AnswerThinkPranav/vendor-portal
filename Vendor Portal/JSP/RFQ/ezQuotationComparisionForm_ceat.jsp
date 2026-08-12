<%@ include file="../Misc/ezVendHeader.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iQuoteImpRFQDetails.jsp"%>                          
<%//@include file="../../../Includes/JSPs/Rfq/iGetExchangeRate.jsp"%>   
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@ include file="../Misc/ezGetVendorsList.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ page import="ezc.ezutil.*,java.text.*"%>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>           
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />       
<%@ page import="org.apache.poi.xssf.usermodel.*"%>                
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>            
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.*,org.apache.poi.ss.util.RegionUtil"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFColor,org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import ="ezc.ezbasicutil.*" %>
<%@ page import="javax.xml.ws.soap.SOAPFaultException"%>
<%@ page import ="javax.xml.ws.BindingProvider,java.util.*,ezc.wsdl.util.*,java.math.*" %>
<%@ page import="ezc.wsdl.PO.price.*" %> 
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null) 
		str="";
		return str.trim();
	}
%>
<%
	
	
	SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
	SimpleDateFormat inputFormat1 = new SimpleDateFormat("dd.MM.yyyy");
	
	String status = request.getParameter("type");
	ezc.ezcommon.EzLog4j.log("status>>>>>>"+status,"I");  	
	
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
	outputStream = new FileOutputStream(excelFilePath);

	Workbook wb = new XSSFWorkbook(); //or new HSSFWorkbook(); 
	Sheet sheet = wb.createSheet("QCF");
	
	ArrayList rfqList = new ArrayList();
	Hashtable rfqHash = new Hashtable();
	int x=0;

%>
<Html>
<Head>

<link rel="stylesheet" href="../Misc/library/assets/bootstrap-3.3.2/css/bootstrap.css">
<style>
#cont {
	height: 600px;
}

#table-1 {
	width: 1800px !important;
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
  padding: 8px 16px;
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
<input type="hidden" name="vendorSelected" value="N">
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
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Recommendation</th>
<%
				String checkedRec="";
				chkList = new ArrayList();
				int t=0;
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					String selRfq= rfqVendLinesRet.getFieldValueString(i,"RFQNO");
					String rfqVen= rfqVendLinesRet.getFieldValueString(i,"VENDOR"); 
					String selVal= selRfq;
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))   
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));
					if(chkVen.contains(rfqVen))	
						checkedRec="checked";
					else
						checkedRec="";					
%>					
					<input type="hidden" name="selRfq<%=t%>" id="selRfq<%=t%>" value="<%=selRfq%>">
					<input type="hidden" name="rfqVen<%=t%>" id="rfqVen<%=t%>" value="<%=rfqVen%>">
					<th colspan=5 style="width:200px;text-align:center">
						<div>
							<select class="form-control" name="selVen<%=t%>" id="selVen<%=t%>" style="width:50%;display: inline-block;">
								<option valie="">Select</option>
								<option value="R">Recommended</option>
								<option value="N">Not Recommended</option>
								
								
							</select>
						</div>

					</th>  
					
<%
				t++;
				}
%>
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Rank</th>
<%		
			int q=0;
			chkList = new ArrayList();			
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))          
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
				
				String vend=rfqLinesRet.getFieldValueString(i,"VENDOR");
			
%>
			<th colspan=5 style="width:200px;text-align:center">
			<select class="form-control" name="rank<%=q%>" style="width:50%;display: inline-block;" >
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
			q++;
			}
%>
		</tr>	
		<tr style="background-color:#575f9452 !important">
		<th colspan=11 style="width:500px;text-align:left">Reason</th>
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
			<th colspan=5 style="width:200px;text-align:center">
				<div>
					<select class="form-control" name="reason<%=p%>" id="reason<%=p%>" style="width:50%;display: inline-block;">
						<option valie="">Select Reason</option>
						<option value="SS" <%if("SS".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>Single Source</option>
						<option value="OEM" <%if("OEM".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%> >OEM</option>
						<option value="OAD" <%if("OAD".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>OEM-Authorized Dealer</option>
						<option value="SOP" <%if("SOP".equals(rfqLinesRet.getFieldValueString(i,"REASON")))out.println("selected");%>>SOP</option>
					</select>
				</div>
			</th>  

<%			p++;			
			}
%>
		</tr>					
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">PO Document type (Supply)</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"POTYPE")%></th>
<%
				}
%>
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">PO Document type (Service)</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center">ZSRV</th>
<%
				}
%>
		</tr>
		<tr style="background-color:coral !important">
		<th colspan=11 style="width:500px;text-align:left">Name of the Party(Supply)</th>
<%	
			String checked="";
			chkList = new ArrayList();
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
				
%>		
				<th colspan=5 style="width:400px;text-align:center"><%=gv_VendorsHT.get(tempVend)+"["+rfqVen+"]"%></th>		
				
<%
			}
		
%>		
		</tr>
		<tr style="background-color:coral !important">
		<th colspan=11 style="width:500px;text-align:left">Name of the Party(Service)</th>
<%	
			String checkedSer="";
			chkList = new ArrayList();
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
				String selVal= selRfq;
				if(chkList.contains(rfqVen))
					continue;
				else
					chkList.add(rfqVen);	

				if(chkVen.contains(rfqVen))	
					checkedSer="checked";
				else
					checkedSer="";
				
%>		
					<th colspan=5 style="width:400px;text-align:center"><%=gv_VendorsHT.get(tempVend)+"["+rfqVen+"]"%></th>
<%
			}
%>		
		</tr>			
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Purchase Organization (Supply)</th>
<%
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));				
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"PURORG")%></th>
					
<%
			}
%>		
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Purchasing Group (Supply)</th>
<%
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));				
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"PURGRP")%></th>
<%
			}
%>		
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Company code</th>
<%
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));							
%>					
					<th colspan=5 style="width:200px;text-align:center">1000</th>					
<%
			}
%>		
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Incoterms Version</th>
<%
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));				
			
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"INCOVER")%></th>
					
<%
			}
%>		
		</tr>

		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Quotation Ref.No.</th>
<%
				chkList = new ArrayList();
				for(int i=0;i<rfqVendLinesRetCnt;i++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));				
			
%>					
					<th colspan=2 style="width:200px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"RFQNO")%>[RO]</th>
					<th colspan=3 style="width:200px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"RFQNO")%>[FINAL]</th>
<%
				}
%>		
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Payment Terms(Supply)</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++) 
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));			
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=pmntHash.get(rfqVendLinesRet.getFieldValueString(i,"PMNT"))%>[<%=rfqVendLinesRet.getFieldValueString(i,"PMNT")%>]</th>					
<%
				}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Payment Terms(Service)</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++) 
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));			
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=pmntHash.get(rfqVendLinesRet.getFieldValueString(i,"PMNT"))%>[<%=rfqVendLinesRet.getFieldValueString(i,"PMNT")%>]</th>					
<%
				}
%>
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Inco Terms</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=incoHash.get(rfqVendLinesRet.getFieldValueString(i,"INCO"))%>[<%=rfqVendLinesRet.getFieldValueString(i,"INCO")%>]</th>
					
<%
				}
%>
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Incoterms Location</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
						continue;
					else
						chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>				
					<!--<th colspan=1 >&nbsp;</th>	
					<th colspan=3 style="width:50px;text-align:center"><input class="form-control input" type="text" value="" name="IncLoc" id="IncLoc" size="5" ></th>
					<th colspan=1  style="border-top-style:hidden; border-top-width:0px; border-top-color:white; border-top:0;">&nbsp;</th>-->
					<th colspan=5 style="width:200px;text-align:center"><%=rfqVendLinesRet.getFieldValueString(i,"INCOLOC")%></th>
<%
				}
%>
		</tr>	
		<tr style="background-color:yellow !important">
			<th colspan=11 style="width:500px;text-align:left"><font color="yellow">Payment Processing(Supply) </font></th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>
<%
				}
%>
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">DP Category</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
				
						
%>
			<th colspan=5 style="width:200px;text-align:center"><%=dpHT.get(rfqLinesRet.getFieldValueString(i,"DPCAT"))%></th>  

<%						
			}
%>
			</tr>
			<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Down payment %</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"DPPER")%>%</th>

<%
				}
%>
			</tr>
			<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Downpayment Amount INR </th>  
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"DPAMT")%></th>

<%
				}
%>
				</tr> 
			<tr>
			<th colspan=11 style="width:500px;text-align:left">Due date</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"><%=inputFormat1.format((java.util.Date)inputFormat.parse(rfqLinesRet.getFieldValueString(i,"DPDUEDT")))%></th>

<%
				}
%>
			</tr>	
			<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Retention</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><%=retentionHT.get(rfqLinesRet.getFieldValueString(i,"RETTYPE"))%></th>  
<%				
			}
%>
			<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Retention %</th>
			
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"RETPER")%>%</th>  
<%			
			}
%>			
		<tr>
		<tr style="background-color:yellow !important">
			<th colspan=11 style="width:500px;text-align:left"><font color="yellow">Payment Processing(Service) </font></th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>
<%
				}
%>
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">DP Category</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
				continue;
			else
				chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
			<th colspan=5 style="width:200px;text-align:center"><%=dpHT.get(rfqLinesRet.getFieldValueString(i,"DPCAT"))%></th>  

<%						
			}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Down payment %</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center">50%</th>

<%
				}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Downpayment Amount INR </th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"></th>
<%
				}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Due date</th>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<th colspan=5 style="width:200px;text-align:center"></th>
<%
				}
%>
			</tr>	
			<tr style="background-color:#575f9452 !important">
				<th colspan=11 style="width:500px;text-align:left">Retention</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
				<th colspan=5 style="width:200px;text-align:center"><%=retentionHT.get(rfqLinesRet.getFieldValueString(i,"RETTYPE"))%></th>  
<%			
			}
%>
			</tr>
			<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Retention %</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">10%</th>  
<%			
			}
%>			
			</tr>	
			<tr style="background-color:#575f9452 !important">
				<th colspan=11 style="width:500px;text-align:left">Header Text</th>
<%			
			int r=0;
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center;"><p><font color="black"><input type="text" class=class="form-control"  name="hTxt<%=r%>" id="hTxt<%=r%>" value="As per final quotation 0707" style="width:50%;display:inline-block;"></font></th>  
<%		
			r++;
			}
%>			
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Footer Text</th>
<%		
			int s=0;
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><p><font color="black"><input type="text" class=class="form-control input"  name="fTxt<%=s%>" id="fTxt<%=s%>" value="Please read general Guidelines" style="width:50%;display:inline-block;"></font></th>  
<%		
			s++;
			}
%>			
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Item Text</th>
<%			
			int u=0;
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><p><font color="black"><input type="text" class=class="form-control input"  name="iTxt<%=u%>" id="iTxt<%=u%>" value="As per Signed Specification" style="width:50%;display: inline-block;"></font></th>  
<%			
			u++;
			}
%>			
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Additional Data-Service PO - Start Date:</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Additional Data-Service PO - End Date:</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>				
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Delivery Schedule - Date for Supply</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>			
		</tr>	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Delivery Schedule - Date for Services</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Run Flag</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">Email</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><%=getUserMail(Session,Session.getUserId())%></th>  
<%			
			}
%>
		</tr>		
		

		<!--<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">JCDB Vendor - Code - Sea / Air Shipment</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">1200000</th>  
<%			
			}
%>
		</tr>-->	
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">JSWC Vendor - Code - Sea / Air Shipment</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">1200003</th>  
<%			
			}
%>
		</tr>		
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">&nbsp;</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>				
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">&nbsp;</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>				
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">&nbsp;</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>				
		<tr style="background-color:#575f9452 !important">
			<th colspan=11 style="width:500px;text-align:left">&nbsp;</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>
		</tr>						
		<tr style="background-color:#575f9452 !important">
			<th colspan=5 style="width:500px;text-align:left">Budget in INR Cr.</th> 
			<th colspan=2 style="width:500px;text-align:left">2</th>
			<th colspan=4 style="width:500px;text-align:left">&nbsp;</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>			
		<tr style="background-color:#575f9452 !important">
			<th colspan=5 style="width:500px;text-align:left">&nbsp;</th>
			<th colspan=2 style="width:500px;text-align:left">USD</th>
			<th colspan=2 style="width:500px;text-align:left">EURO</th>
			<th colspan=2 style="width:500px;text-align:left">JPY</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center">&nbsp;</th>  
<%			
			}
%>			
		</tr>						
		<tr style="background-color:#575f9452 !important">
			<th colspan=5 style="width:500px;text-align:left">Exchange Rate</th>
			<th colspan=2 style="width:500px;text-align:left">74</th>
			<th colspan=2 style="width:500px;text-align:left">89</th>
			<th colspan=2 style="width:500px;text-align:left">0.70</th>
<%			
			chkList = new ArrayList();
			for(int i=0;i<rfqVendLinesRetCnt;i++)
			{
				if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
				else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));	
%>
					<th colspan=5 style="width:200px;text-align:center"><font color="yellow">SUPPLY</font></th>  
<%			
			}
%>			
		</tr>								
		<tr style="background-color:#575f9452 !important">
					<th rowspan=2  style="width:100px;text-align:center">S.No.</th>
					<th rowspan=2  style="width:100px;text-align:center">Item</th>
					<th rowspan=2  style="width:100px;text-align:center">Material</th>
					<th rowspan=2  style="width:100px;text-align:center">Description</th>
					<th rowspan=2  style="width:100px;text-align:center">Item<br>Text</th>
					<th rowspan=2  style="width:100px;text-align:center">PO<br>Text</th>					
					<th rowspan=2  style="width:20px;text-align:center">UOM</th>
					<th rowspan=2  style="width:20px;text-align:center">Qty</th>
					<th rowspan=2  style="width:150px;text-align:center">PR No.</th>
					<th rowspan=2  style="width:150px;text-align:center">PR Item</th>
					<th rowspan=2  style="width:100px;text-align:center">Last PO <br> Price</th>
		<tr>
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
				<th style="width:100px;text-align:center">Rate<br><%=vendWiseCurrency.get(vend)%>/UOM</th>
				<th style="width:100px;text-align:center">Total<br>Amount<%=vendWiseCurrency.get(vend)%></th>
				<th style="width:100px;text-align:center">Rate<br><%=vendWiseCurrency.get(vend)%>/UOM</th>
				<th style="width:100px;text-align:center">Total<br>Amount<%=vendWiseCurrency.get(vend)%></th>
				<th style="width:100px;text-align:center">Qty<br>Recommended</th>
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
		
		
		
		//To fetch last PO price			
		java.math.BigDecimal netPR=new java.math.BigDecimal(0);
		GetLastPOPriceSyncOutService patchService= new GetLastPOPriceSyncOutService();
		GetLastPOPriceSyncOut patchPort=patchService.getHTTPPort();

		ezc.ezcommon.EzLog4j.log("patchService in PO Price>>>>>>> "+patchService,"I");
		ezc.ezcommon.EzLog4j.log("patchPort in PO price>>>>>>> "+patchPort,"I");

		BindingProvider prov = (BindingProvider)patchPort;
		ResourceBundle site1=null;
		String PIUSER = "",PIPASSWORD="";
		try
		{
			site1= ResourceBundle.getBundle("Site");
			PIUSER = site1.getString("PI_USER");
			PIPASSWORD = site1.getString("PI_PASSWORD");
		}
		catch(Exception e)
		{ 
		    log("Got Exception while getting PI Details "+e);	
		}
		prov.getRequestContext().put(BindingProvider.USERNAME_PROPERTY,PIUSER);
		prov.getRequestContext().put(BindingProvider.PASSWORD_PROPERTY,PIPASSWORD);

		Z_EZ_GET_LAST_PO_PRICE sapPreProc = new Z_EZ_GET_LAST_PO_PRICE();
		sapPreProc.setPUR_ORG("1000");

		ezc.wsdl.PO.price.Z_EZ_GET_LAST_PO_PRICE.POITEMS poItemTable = new ezc.wsdl.PO.price.Z_EZ_GET_LAST_PO_PRICE.POITEMS();
		ezc.wsdl.PO.price.ZEZ_PO_STRUCT poItemTableRow = new ezc.wsdl.PO.price.ZEZ_PO_STRUCT ();	

		poItemTableRow.setMATNR(rfqLinesRet.getFieldValueString(i,"MATERIAL")); 
		poItemTable.getItem().add(poItemTableRow);
		sapPreProc.setPOITEMS(poItemTable);

		String msgOut="";
		Z_EZ_GET_LAST_PO_PRICEResponse compResponse=null;
		try
		{
			ezc.ezcommon.EzLog4j.log("before1:::::::::::::::","I");
			compResponse=patchPort.getLastPOPriceSyncOut(sapPreProc); 
			ezc.ezcommon.EzLog4j.log("after:::::::::::::::","I");
		}
		catch(SOAPFaultException e)
		{
			out.print("SOAPFaultException in  Z_EZ_GET_LAST_PO_PRICE::"+e);
			ezc.ezcommon.EzLog4j.log("after:::::::::::::::"+e,"I");
		}
		catch(Exception e)
		{
			out.println("SOAP Exception in  Z_EZ_GET_LAST_PO_PRICE"+e);
		} 

		int poCnt =0;
		ArrayList items =null;

		if(compResponse!=null)
		{
			List<ZEZ_PO_STRUCT> poList = null;

			if(compResponse.getPOITEMS()!=null)
				poList=compResponse.getPOITEMS().getItem();

			if(poList!=null)
			{
				items = new ArrayList(poList);		
				poCnt = items.size();	
			}
			ezc.ezcommon.EzLog4j.log("poCnt:::::::::::::::"+poCnt,"I"); 

		}
	ezc.ezparam.ReturnObjFromRetrieve myRet= null;
	
	if(poCnt > 0)
	{
		myRet= new ReturnObjFromRetrieve(new String[]{"VENDOR","VENDNAME","PLANT","MATERAIL","PONUM","CREATED_ON","UOM","CURRENCY","NETPR"});
	
	try 
	{		
		for(int k=0;k<poCnt;k++)
		{
			ZEZ_PO_STRUCT sapPoList = (ZEZ_PO_STRUCT)items.get(k);
		    	//out.println("po num=="+sapPoList.getEBELN());
			myRet.setFieldValue("VENDOR", sapPoList.getLIFNR());		
			myRet.setFieldValue("VENDNAME",sapPoList.getNAME1());		
			myRet.setFieldValue("PLANT",sapPoList.getWERKS());
			myRet.setFieldValue("MATERAIL",sapPoList.getMATNR());
			myRet.setFieldValue("PONUM",sapPoList.getEBELN());
			myRet.setFieldValue("CREATED_ON",sapPoList.getAEDAT());
			myRet.setFieldValue("UOM",sapPoList.getMEINS());
			myRet.setFieldValue("CURRENCY",sapPoList.getWAERS());
			myRet.setFieldValue("NETPR",sapPoList.getNETPR());
			//ezc.ezcommon.EzLog4j.log("CREATED_ON:::::::::::::::"+sapPoList.getAEDAT(),"I");
			
			myRet.addRow();
			
			
			String rfqPlant=(String)dtlXML.getFieldValueString(0,"ERD_PLANT");
			String lastPOPlant=(String)sapPoList.getWERKS();
			if(netPR.compareTo(java.math.BigDecimal.ZERO)!=0)
			{
				if(rfqPlant.equals(lastPOPlant))netPR=(java.math.BigDecimal)sapPoList.getNETPR();
			
			
			}
			//out.println("rfqPlant"+rfqPlant+"lastPOPlant"+lastPOPlant);
		  }
		  //out.println("myRet"+myRet.toEzcString());
			
	}
	catch (Exception e) {}
	String netPrStr=checkNull(myRet.getFieldValueString(0,"NETPR"));   
	BigDecimal netprBD=new BigDecimal(netPrStr);
	if(netPR.compareTo(java.math.BigDecimal.ZERO)==0)netPR=netprBD;
	}
	totPOPrice=(netPR.doubleValue()*Double.parseDouble(myQty))+totPOPrice;
	//totPOPrice= totPOPrice * Double.parseDouble(exchRate);
	totPOPriceStr=new java.math.BigDecimal(totPOPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	String prNum=rfqVendLinesRet.getFieldValueString(i,"PRDET").split("¥")[0];
	
%>	
	<input type=hidden name="rfqItem" value="<%=i%>">		      	
				<tr>
					
					<td style="width:5px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"LINENO")%></td>
					<td style="width:5px;text-align:center"><%=rfqLinesRet.getFieldValueString(i,"LINENO")%></td>
					<td style="width:20px;text-align:center">
					<%try{
						out.println(Long.parseLong(rfqLinesRet.getFieldValueString(i,"MATERIAL")));
					     }catch(Exception e){
						out.println(rfqLinesRet.getFieldValueString(i,"MATERIAL")); 
					     }%>&nbsp;</td>
					<td style="width:20px;text-align:center;" ><%=rfqLinesRet.getFieldValueString(i,"MATDESC")%></td>
					<td style="width:20px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"))%>','I')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 
					<td style="width:20px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"POTEXT"))%>','P')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 					
					<td style="width:10px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"UOM")%></td>
					<td style="width:20px;text-align:center" ><input type="hidden" name="prItemQty<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" id="prItemQty<%=rfqLinesRet.getFieldValueString(i,"LINENO")%>" value="<%=myQty%>"><%=myQty%>&nbsp;</td>
					
					<%if("RFQ".equals(prNum)){%>
					<td style="width:150px;text-align:center" >From Material</td>
					<td style="width:150px;text-align:center" >From Material</td>
					<%}else{%>
					<td style="width:150px;text-align:center" ><%=(rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[0]%></td>
					<td style="width:150px;text-align:center" ><%=Long.parseLong((rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[1])%></td>
					<%}%>  
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
							//totVal = totVal * Double.parseDouble(exchRate);
							totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totVal = 00.0;
						}
						try
						{
							totHisVal= (Double.parseDouble(myQty) * basicUOMHis);
							//totHisVal = totHisVal * Double.parseDouble(exchRate);
							totHisValStr  = new java.math.BigDecimal(totHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
						}
						catch(Exception e)
						{
							totHisVal = 00.0;
						}
						
						String saphsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPHSNCODE")); 
						String sapgstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPGSTCODE")); 
						String gstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"GSTCODE"));
						String hsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"HSNCODE"));  
						//   out.println(minMatHT+"minMatHT");
						double minMatCost=minMatHT.get(material);
						if(totVal==minMatCost)styleCl="background-color:greenyellow;";
%>
						<td style="width:100px;text-align:center" ><%=basicUOMHisStr%>&nbsp;<a href="javascript:openDet('<%=quotHisPrice%>','<%=leaddays1%>','<%=condDisc%>','<%=discType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>&nbsp;</td>  
						<td style="width:100px;text-align:center" ><%=totHisValStr%>&nbsp;</td>  
						<td  style="width:100px;text-align:center;" ><input type="hidden" name="itemPrice<%=chkStr%>" id="itemPrice<%=chkStr%>" value="<%=basicValStr%>"><%=basicValStr%>&nbsp;<a href="javascript:openDet('<%=quotPrice%>','<%=leaddays1%>','<%=condDisc%>','<%=discType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a></td>
						<td  style="width:100px;text-align:center;<%=styleCl%>" ><%=totValStr%>&nbsp;</td>
						<td  style="width:100px;text-align:center;"><input type="number" name="rfqQty<%=chkStr%>" id="rfqQty<%=chkStr%>" value="0" onchange="calcBot('<%=chkStr%>','<%=chkRfq%>','<%=chkLine%>','<%=vendWiseExchange.get(vendorLoop)%>')"></td>
						
						
<%
						} 
					}
%>
			</tr>
<%			
			}		
%>
		<tr style="background-color:bisque;"> 
			<td colspan=10 style="width:100px;text-align:left"><b>Total Value Supply</b></td>
			<td colspan=1 style="width:100px;text-align:center"></b><%=totPOPriceStr%></b></td>
<%	
		//out.println("vendWiseTotqty"+vendWiseTotqty);	
		chkList = new ArrayList();
		for(int i=0;i<rfqVendLinesRetCnt;i++)
		{
			if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))     
			continue;
			else
			chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));
			
			String vend=rfqVendLinesRet.getFieldValueString(i,"VENDOR");
%>						
			<td style="width:100px;text-align:center"></td>
			<td style="width:100px;text-align:center">&nbsp;</td> 
			<td style="width:100px;text-align:center"></td>
			<td style="width:100px;text-align:center"><b><%=((String)vendWiseTotAmount.get(vend))%></b>&nbsp;</td>
			<td style="width:100px;text-align:center"><input type="text" name="botTotVal<%=rfqVendLinesRet.getFieldValueString(i,"RFQNO")%>" value="0.00" readOnly></td>
<%
		}
%>		
		</tr>				
<%		double totQty=0.0;
		double totPrice=0.0;
		for(int k=0;k<rfqLinesRetCnt;k++)
		{
			
			String myQty = rfqLinesRet.getFieldValueString(k,"QTY");
			String quotPrice = rfqVendLinesRet.getFieldValueString(k,"PRICE");
			if("".equals(quotPrice) || "null".equals(quotPrice) || quotPrice==null) quotPrice = "0";
			try
			{
				totQty=totQty+Double.parseDouble(myQty);
				totPrice=totPrice+Double.parseDouble(quotPrice); 
			}
			catch(Exception e){}
			
		}
%>			
			<tr >
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:right">Pkg & Fwd Chrgs&nbsp;</td> 
<%		
				chkList = new ArrayList(); 
				for(int k=0;k<rfqVendLinesRetCnt;k++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(k,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(k,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(k,"VENDOR"); 
					
%>					
					<td style="width:100px;text-align:center"><%=((String)vendWisePKGValueHT.get(vend)).split("#")[0]%><%=hashType.get(PKFWHisType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWisePKGHT.get(vend)).split("#")[1]%>&nbsp;</td>  
					<td style="width:100px;text-align:center"><%=((String)vendWisePKGValueHT.get(vend)).split("#")[1]%><%=hashType.get(PKFWType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemPKFWVal<%=rfqVendLinesRet.getFieldValueString(k,"RFQNO")%>" value="<%=((String)vendWisePKGHT.get(vend)).split("#")[1]%>"><%=((String)vendWisePKGHT.get(vend)).split("#")[1]%>&nbsp;</td> 
					<td style="width:100px;text-align:center"><input type="text" name="botPKGVal<%=rfqVendLinesRet.getFieldValueString(k,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>				
				</tr>
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Ocean Freight&nbsp;</td>
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))    
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
					
%>					
					<td style="width:100px;text-align:center"><%=((String)vendWiseFRTValueHT.get(vend)).split("#")[0]%><%=hashType.get(FRTHisType)%>&nbsp;</td> 
					<td style="width:100px;text-align:center"><%=((String)vendWiseFRTHT.get(vend)).split("#")[0]%>&nbsp;</td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseFRTValueHT.get(vend)).split("#")[1]%><%=hashType.get(FRTType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemFRTVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseFRTHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseFRTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:right"><input type="text" name="botFRTVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%				}
%>
				</tr>
				<!--<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Ocean Freight/Quantity&nbsp;</td>
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))    
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
					
%>					
					<td style="width:100px;text-align:center"><%=((String)vendWiseFRTValueHT.get(vend)).split("#")[0]%><%=hashType.get(FRTHisType)%>&nbsp;</td> 
					<td style="width:100px;text-align:center"><%=((String)vendWiseFRTHT.get(vend)).split("#")[0]%>&nbsp;</td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseFRTValueHT.get(vend)).split("#")[1]%><%=hashType.get(FRTType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemFRTQtyVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseFRTHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseFRTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botFRTQtyVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%				}
%>
				</tr>	--->			
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>SUPPLY PRICE CIF IN FOREIGN CURRENCY</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"><input type="text" name="botSupVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				
				}  
%>					
				</tr>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>SUPPLY PRICE CIF IN INR</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEINRHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"><input type="text" name="botSupInrVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				
				} 
%>					
				</tr>									
				<tr>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Basic Custom Duty&nbsp;</td>     
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");   
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseBCDValueHT.get(vend)).split("#")[0]%><%=hashType.get(BCDHisType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseBCDHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><input type="hidden" name="itemBCDVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseBCDValueHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseBCDValueHT.get(vend)).split("#")[1]%><%=hashType.get(BCDType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseBCDHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botBCDVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Social Welfare Cess&nbsp;</td>
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO")); 
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseSWCValueHT.get(vend)).split("#")[0]%><%=hashType.get(SWCHisType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseSWCHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><input type="hidden" name="itemSWC<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseSWCValueHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseSWCValueHT.get(vend)).split("#")[1]%><%=hashType.get(SWCType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseSWCHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botSWCVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>	   
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">CHA Charges&nbsp;</td>  
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseCHAValueHT.get(vend)).split("#")[0]%><%=hashType.get(CHAHisType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseCHAHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseCHAValueHT.get(vend)).split("#")[1]%><%=hashType.get(CHAType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemCHAVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseCHAHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseCHAHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botCHAVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">CHA Charges/Qty&nbsp;</td>  
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));  
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseCHA1ValueHT.get(vend)).split("#")[0]%><%=hashType.get(CHA1HisType)%>&nbsp;</td> 
					<td style="width:100px;text-align:center"><%=((String)vendWiseCHA1HT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><input type="hidden" name="itemCHA1<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseCHA1ValueHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseCHA1ValueHT.get(vend)).split("#")[1]%><%=hashType.get(CHA1Type)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseCHA1HT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botCHA1Val<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>				
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Freight&nbsp;</td>
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseIFRTValueHT.get(vend)).split("#")[0]%><%=hashType.get(IFRTHisType)%>&nbsp;</td> 
					<td style="width:100px;text-align:center"><%=((String)vendWiseIFRTHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseIFRTValueHT.get(vend)).split("#")[1]%><%=hashType.get(IFRTType)%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemIFRTVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseIFRTHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseIFRTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botIFRTVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>
				<tr >
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Other Charges&nbsp;</td>  
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));  
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
					String reason1="";
					try
					{
						reason1=((String)vendWiseOTHReasonHT.get(vend)).split("#")[0]; 
					}
					catch(Exception e)
					{
						reason1="";
					}
					String reason2="";
					try
					{
						reason2=((String)vendWiseOTHReasonHT.get(vend)).split("#")[1];
					}
					catch(Exception e)
					{
						reason2="";
					}					
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseOTHValueHT.get(vend)).split("#")[0]%><%=hashType.get(OTHHisType)%>&nbsp;
					<a href="javascript:openReason('<%=reason1%>')"><span class="glyphicon glyphicon-new-window"></span></a></td></td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseOTHHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseOTHValueHT.get(vend)).split("#")[1]%><%=hashType.get(OTHHisType)%>&nbsp;
					<a href="javascript:openReason('<%=reason2%>')"><span class="glyphicon glyphicon-new-window"></span></a></td></td>
					<td style="width:100px;text-align:center"><input type="hidden" name="itemOTHVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseOTHHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseOTHHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="text" name="botOTHVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>				
				<tr>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Add:IGST&nbsp;</td>  
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))    
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR"); 
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[0]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><input type="hidden" name="itemGST<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="<%=((String)vendWiseGSTValueHT.get(vend)).split("#")[1]%>"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[1]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="number" name="botGSTVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></td>
<%
				}
%>										
				</tr>				
				
				<tr style="background-color:orange"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Total Cost in INR</b>&nbsp;</td> 	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO")); 

					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
					 	
					
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseTotValHT.get(vend)).split("#")[0]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"><b><input type="number" name="botGrossVal<%=rfqVendLinesRet.getFieldValueString(f,"RFQNO")%>" value="0.00" readOnly></b></td>
<%
				
				}
%>					
				</tr>
				<tr >
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:right">Less Duty&nbsp;</td> 
<%				chkList = new ArrayList();
				for(int g=0;g<rfqVendLinesRetCnt;g++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
					condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
					
%>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseDUTYHT.get(vend)).split("#")[0]%></td>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseDUTYHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="number" name="botDUTYVal<%=rfqVendLinesRet.getFieldValueString(g,"RFQNO")%>" value="0.00" readOnly></td>
<%
				
				}
%>				
				</tr>				
				<tr >
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:right">Less:IGST&nbsp;</td>
<%				chkList = new ArrayList();
				for(int g=0;g<rfqVendLinesRetCnt;g++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
					condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
					
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[0]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[0]%></td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[1]%>(%)&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="number" name="botLGSTVal<%=rfqVendLinesRet.getFieldValueString(g,"RFQNO")%>" value="0.00" readOnly></td>
<%
				
				}
%>				
				</tr>
				<tr style="background-color:deepskyblue"> 
				<td style="width:100px;text-align:center">&nbsp;</td> 
				<td colspan=10 style="width:100px;text-align:center"><b>Landed Cost Value</b>&nbsp;</td>
<%				 
				Double minGrossVal = Collections.min(gvList);  
				chkList = new ArrayList();
				for(int g=0;g<rfqVendLinesRetCnt;g++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO"))) 
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));
					
					String styleTotCostCl="";
					String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
					double grossValie=Double.parseDouble(((String)vendWiseGrossValHT.get(vend)).split("#")[0]);
					String grossValieStr = new java.math.BigDecimal(grossValie).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					String minGrossValStr=new java.math.BigDecimal(minGrossVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					//out.println("grossValie"+grossValieStr+"minGrossVal"+minGrossValStr);  
					//if(grossValie==minGrossVal)  
					if(grossValieStr.equals(minGrossValStr))
					{
					styleTotCostCl="background-color:greenyellow;";
					}
%>

					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td   style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center;<%=styleTotCostCl%>"><%=grossValieStr%>&nbsp;</td>
					<td style="width:100px;text-align:center"><input type="number" name="botLCVal<%=rfqVendLinesRet.getFieldValueString(g,"RFQNO")%>" value="0.00" readOnly></td>
<%
				
				}
%>				
		</tr>
		<tr style="background-color:orange">
			<td colspan=11 style="width:500px;text-align:left">&nbsp;</td>
<%
				chkList = new ArrayList();			
				for(int i=0;i<rfqVendLinesRetCnt;i++)    
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(i,"RFQNO")))  
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(i,"RFQNO"));		
%>					
					<td colspan=5 style="width:200px;text-align:center"><b>SERVICES</b></td>
<%
				}
%>
		</tr>			
		<tr style="background-color:#575f9452 !important">
					<th rowspan=2  style="width:100px;text-align:center">S.No.</th>
					<th rowspan=2  style="width:100px;text-align:center">Item</th>
					<th rowspan=2  style="width:100px;text-align:center">Material</th>
					<th rowspan=2  style="width:100px;text-align:center">Description</th>
					<th rowspan=2  style="width:100px;text-align:center">Item<br>Text</th>
					<th rowspan=2  style="width:100px;text-align:center">PO<br>Text</th>					
					<th rowspan=2  style="width:20px;text-align:center">UOM</th>
					<th rowspan=2  style="width:20px;text-align:center">Qty</th>
					<th rowspan=2  style="width:150px;text-align:center">PR No.</th>
					<th rowspan=2  style="width:150px;text-align:center">PR Item</th>
					<th rowspan=2  style="width:100px;text-align:center">Last PO <br> Price</th>
		<tr>
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
					<th style="width:100px;text-align:center">Rate<br><%=vendWiseCurrency.get(vend)%>/UOM </th>
					<th style="width:100px;text-align:center">Total<br>Amount <%=vendWiseCurrency.get(vend)%></th>
					<th style="width:100px;text-align:center">Rate<br><%=vendWiseCurrency.get(vend)%>/UOM </th>
					<th style="width:100px;text-align:center">Total<br>Amount <%=vendWiseCurrency.get(vend)%></th>
					<th style="width:100px;text-align:center">Qty<br>Recommended</th>
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
		
		
		
		//To fetch last PO price			
		java.math.BigDecimal netPR=new java.math.BigDecimal(0);
		GetLastPOPriceSyncOutService patchService= new GetLastPOPriceSyncOutService();
		GetLastPOPriceSyncOut patchPort=patchService.getHTTPPort();

		ezc.ezcommon.EzLog4j.log("patchService in PO Price>>>>>>> "+patchService,"I");
		ezc.ezcommon.EzLog4j.log("patchPort in PO price>>>>>>> "+patchPort,"I");

		BindingProvider prov = (BindingProvider)patchPort;
		ResourceBundle site1=null;
		String PIUSER = "",PIPASSWORD="";
		try
		{
			site1= ResourceBundle.getBundle("Site");
			PIUSER = site1.getString("PI_USER");
			PIPASSWORD = site1.getString("PI_PASSWORD");
		}
		catch(Exception e)
		{ 
		    log("Got Exception while getting PI Details "+e);	
		}
		prov.getRequestContext().put(BindingProvider.USERNAME_PROPERTY,PIUSER);
		prov.getRequestContext().put(BindingProvider.PASSWORD_PROPERTY,PIPASSWORD);

		Z_EZ_GET_LAST_PO_PRICE sapPreProc = new Z_EZ_GET_LAST_PO_PRICE();
		sapPreProc.setPUR_ORG("1000");

		ezc.wsdl.PO.price.Z_EZ_GET_LAST_PO_PRICE.POITEMS poItemTable = new ezc.wsdl.PO.price.Z_EZ_GET_LAST_PO_PRICE.POITEMS();
		ezc.wsdl.PO.price.ZEZ_PO_STRUCT poItemTableRow = new ezc.wsdl.PO.price.ZEZ_PO_STRUCT ();	

		poItemTableRow.setMATNR(rfqLinesRet.getFieldValueString(i,"MATERIAL")); 
		poItemTable.getItem().add(poItemTableRow);
		sapPreProc.setPOITEMS(poItemTable);

		String msgOut="";
		Z_EZ_GET_LAST_PO_PRICEResponse compResponse=null;
		try
		{
			ezc.ezcommon.EzLog4j.log("before1:::::::::::::::","I");
			compResponse=patchPort.getLastPOPriceSyncOut(sapPreProc); 
			ezc.ezcommon.EzLog4j.log("after:::::::::::::::","I");
		}
		catch(SOAPFaultException e)
		{
			out.print("SOAPFaultException in  Z_EZ_GET_LAST_PO_PRICE::"+e);
			ezc.ezcommon.EzLog4j.log("after:::::::::::::::"+e,"I");
		}
		catch(Exception e)
		{
			out.println("SOAP Exception in  Z_EZ_GET_LAST_PO_PRICE"+e);
		} 

		int poCnt =0;
		ArrayList items =null;

		if(compResponse!=null)
		{
			List<ZEZ_PO_STRUCT> poList = null;

			if(compResponse.getPOITEMS()!=null)
				poList=compResponse.getPOITEMS().getItem();

			if(poList!=null)
			{
				items = new ArrayList(poList);		
				poCnt = items.size();	
			}
			ezc.ezcommon.EzLog4j.log("poCnt:::::::::::::::"+poCnt,"I"); 

		}
	ezc.ezparam.ReturnObjFromRetrieve myRet= null;
	
	if(poCnt > 0)
	{
		myRet= new ReturnObjFromRetrieve(new String[]{"VENDOR","VENDNAME","PLANT","MATERAIL","PONUM","CREATED_ON","UOM","CURRENCY","NETPR"});
	
	try 
	{		
		for(int k=0;k<poCnt;k++)
		{
			ZEZ_PO_STRUCT sapPoList = (ZEZ_PO_STRUCT)items.get(k);
		    	//out.println("po num=="+sapPoList.getEBELN());
			myRet.setFieldValue("VENDOR", sapPoList.getLIFNR());		
			myRet.setFieldValue("VENDNAME",sapPoList.getNAME1());		
			myRet.setFieldValue("PLANT",sapPoList.getWERKS());
			myRet.setFieldValue("MATERAIL",sapPoList.getMATNR());
			myRet.setFieldValue("PONUM",sapPoList.getEBELN());
			myRet.setFieldValue("CREATED_ON",sapPoList.getAEDAT());
			myRet.setFieldValue("UOM",sapPoList.getMEINS());
			myRet.setFieldValue("CURRENCY",sapPoList.getWAERS());
			myRet.setFieldValue("NETPR",sapPoList.getNETPR());
			//ezc.ezcommon.EzLog4j.log("CREATED_ON:::::::::::::::"+sapPoList.getAEDAT(),"I");
			
			myRet.addRow();
			
			
			String rfqPlant=(String)dtlXML.getFieldValueString(0,"ERD_PLANT");
			String lastPOPlant=(String)sapPoList.getWERKS();
			if(netPR.compareTo(java.math.BigDecimal.ZERO)!=0)
			{
				if(rfqPlant.equals(lastPOPlant))netPR=(java.math.BigDecimal)sapPoList.getNETPR();
			
			
			}
		  //out.println("rfqPlant"+rfqPlant+"lastPOPlant"+lastPOPlant); 
		  }
		  //out.println("myRet"+myRet.toEzcString());
			
	}
	catch (Exception e) {}
	String netPrStr=checkNull(myRet.getFieldValueString(0,"NETPR"));   
	BigDecimal netprBD=new BigDecimal(netPrStr);
	if(netPR.compareTo(java.math.BigDecimal.ZERO)==0)netPR=netprBD;
	}
	totPOPrice=(netPR.doubleValue()*Double.parseDouble(myQty))+totPOPrice;
	totPOPrice= totPOPrice * Double.parseDouble(exchRate);
	totPOPriceStr=new java.math.BigDecimal(totPOPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	String prNum=rfqVendLinesRet.getFieldValueString(i,"PRDET").split("¥")[0];
	
%>			      	
				<tr>
					
					<td style="width:100px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"LINENO")%>&nbsp;</td>
					<td style="width:100px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"LINENO")%>&nbsp;</td>
					<td style="width:100px;text-align:center" >
					<%try{
						out.println(Long.parseLong(rfqLinesRet.getFieldValueString(i,"MATERIAL")));
					     }catch(Exception e){
						out.println(rfqLinesRet.getFieldValueString(i,"MATERIAL")); 
					     }%>&nbsp;</td>
					<td style="width:100px;text-align:center;" ><%=rfqLinesRet.getFieldValueString(i,"MATDESC")%>&nbsp;</td>
					<td style="width:100px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"ITEMTEXT"))%>','I')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 
					<td style="width:100px;text-align:center;"><a href="javascript:openLongItem('<%=rfqLinesRet.getFieldValueString(i,"MATERIAL")%>','<%=checkNull(rfqLinesRet.getFieldValueString(i,"POTEXT"))%>','P')"> <span class="glyphicon glyphicon-new-window"></span> </a></td> 					
					<!--<td style="width:100px;text-align:center" ><%=rfqLinesRet.getFieldValueString(i,"UOM")%>&nbsp;</td>-->
					<td style="width:200px;text-align:center" >EA&nbsp;</td>
					<td style="width:20px;text-align:center" ><%=myQty%>&nbsp;</td>
					
					<%if("RFQ".equals(prNum)){%>
					<td style="width:150px;text-align:center" >From Material</td>
					<%}else{%>
					<td style="width:150px;text-align:center" ><%=(rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[0]%></td>
					<td style="width:150px;text-align:center" ><%=Long.parseLong((rfqVendLinesRet.getFieldValueString(i,"PRDET")).split("¥")[1])%></td>
					<%}%>  
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
							totVal = totVal * Double.parseDouble(exchRate);
							totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
						}
						catch(Exception e)
						{
							totVal = 00.0;
						}
						try
						{
							totHisVal= (Double.parseDouble(myQty) * basicUOMHis);
							totHisVal = totHisVal * Double.parseDouble(exchRate);
							totHisValStr  = new java.math.BigDecimal(totHisVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
						}
						catch(Exception e)
						{
							totHisVal = 00.0;
						}
						
						String saphsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPHSNCODE")); 
						String sapgstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"SAPGSTCODE")); 
						String gstCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"GSTCODE"));
						String hsnCode=checkNull(rfqVendLinesRet.getFieldValueString(j,"HSNCODE"));  
						//   out.println(minMatHT+"minMatHT");
						double minMatCost=minMatHT.get(material);
						if(totVal==minMatCost)styleCl="background-color:greenyellow;";
%>
						<td style="width:100px;text-align:center" ><%=basicUOMHisStr%>&nbsp;<a href="javascript:openDet('<%=quotHisPrice%>','<%=leaddays1%>','<%=condDisc%>','<%=discType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a>&nbsp;</td>  
						<td style="width:100px;text-align:center" ><%=totHisValStr%>&nbsp;</td>  
						<td  style="width:100px;text-align:center;" ><%=basicValStr%>&nbsp;<a href="javascript:openDet('<%=quotPrice%>','<%=leaddays1%>','<%=condDisc%>','<%=discType%>','<%=saphsnCode%>','<%=sapgstCode%>','<%=gstCode%>','<%=hsnCode%>')"> <span class="glyphicon glyphicon-new-window"></span> </a></td>
						<td  style="width:100px;text-align:center;<%=styleCl%>" ><%=totValStr%>&nbsp;</td>
						<td  style="width:100px;text-align:center;"><%=myQty%>&nbsp;</td>
						
<%
						} 
					}
%>
			</tr>
<%			
			}		
%>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>SERVICE VALUE IN FOREIGN CURRENCY</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>SERVICE VALUE IN INR</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>
				<tr>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=10 style="width:100px;text-align:right">Add:IGST&nbsp;</td>
<%				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[0]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[0]%></td>
					<td  style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[1]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
<%
				}
%>										
				</tr>
				<tr> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:right">Gross Value-Services  in INR</td> 	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));

					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
					 	
					
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseTotValHT.get(vend)).split("#")[0]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				}
%>					
				</tr>				
				<tr>
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:right">Less:IGST&nbsp;</td>
<%				chkList = new ArrayList();
				for(int g=0;g<rfqVendLinesRetCnt;g++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(g,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(g,"RFQNO"));
					
					String vend=rfqVendLinesRet.getFieldValueString(g,"VENDOR");
					condGST  = checkNull((String)vendWiseTotGSTHT.get(vend));
					
%>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[0]%><%=hashType.get("P")%>&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[0]%></td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTValueHT.get(vend)).split("#")[1]%>(%)&nbsp;</td>
					<td style="width:100px;text-align:center"><%=((String)vendWiseGSTHT.get(vend)).split("#")[1]%>&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
<%
				
				}
%>				
				</tr>	
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>LANDED VALUE SERVICES IN INR</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>LANDED VALUE SUPPLY AND SERVICES IN INR</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>									
				<tr style="background-color:bisque"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>CIF VALUE SUPPLY AND SERVICES IN FOREIGN CURRENCY</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>
				<tr style="background-color:bisque"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>CIF VALUE SUPPLY AND SERVICES IN FOREIGN CURRENCY WITH HEDGING COST</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b><%=((String)vendWiseSUPPPRICEHT.get(vend)).split("#")[1]%></b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>					
				
				<tr style="background-color:coral"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Landed Cost Value(Including Payment Term Criteria) </b>&nbsp;</td>
<%				
				
				Double minList = Collections.min(list); 
				chkList = new ArrayList();
				for(int v=0;v<rfqVendLinesRetCnt;v++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(v,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(v,"RFQNO"));

					String vend=rfqVendLinesRet.getFieldValueString(v,"VENDOR");
	        		
	           			
	                            	String landCostStr="";   
	                            	String landCostHisStr="";
	                            	try
	                            	{
	                            		landCostStr = ((String)TotalCostStrHT.get(vend)).split("#")[0];
	                            	}
	                            	catch(Exception e)
	                            	{
	                            		landCostStr="";
	                            	}
	                            	try
	                            	{
	                            		landCostHisStr=((String)TotalCostStrHT.get(vend)).split("#")[1];
	                            	}
	                            	catch(Exception e)
	                            	{
	                            		landCostHisStr="";
	                            	}	                            	
	                            	
	                            	
	                            	double landCostDb=Double.parseDouble(landCostStr);
					
%>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center">&nbsp;<b><%=landCostHisStr%></b></td>
					<td style="width:100px;text-align:center;"><b><%=landCostStr%></b>&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
<% 
				}
%>				
				</tr>	
				<tr style="background-color:coral"> 
					<td style="width:100px;text-align:center"><b>Ref. Only</b></td>
					<td colspan=10 style="width:100px;text-align:center"><b>Landed Cost Value(Including Payment Term Criteria + Hedging Cost)</b>&nbsp;</td>
<%				
				
				minList = Collections.min(list); 
				chkList = new ArrayList();
				for(int v=0;v<rfqVendLinesRetCnt;v++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(v,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(v,"RFQNO")); 

					String vend=rfqVendLinesRet.getFieldValueString(v,"VENDOR"); 
	        		
	           			
	                            	String landHedCostStr="";
	                            	String landHedCostHisStr="";
	                            	try
	                            	{
	                            		landHedCostStr = ((String)TotalHedCostStrHT.get(vend)).split("#")[0];
	                            	}
	                            	catch(Exception e)
	                            	{
	                            		landHedCostStr="";
	                            	}
	                            	try
	                            	{
	                            		landHedCostHisStr=((String)TotalHedCostStrHT.get(vend)).split("#")[1];
	                            	}
	                            	catch(Exception e)
	                            	{
	                            		landHedCostHisStr="";
	                            	}	                            	
	                            	
	                            	
	                            	double landCostDb=Double.parseDouble(landHedCostStr); 
					
%>
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center">Hedge</td>
					<td style="width:100px;text-align:center">&nbsp;<b><%=landHedCostHisStr%></b></td>
					<td style="width:100px;text-align:center;"><b><%=landHedCostStr%></b>&nbsp;</td>
					<td style="width:100px;text-align:center"></td>
<% 
				}
%>				
				</tr>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Saving</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b>25%</b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Delivery Period</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b>6 TO 8 MONTHS</b>&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>					
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Warranty</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b>18 Months from Shipment & 12 Months from Commissioning</b></td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>	
				<tr style="background-color:yellow"> 
				<td style="width:100px;text-align:center">&nbsp;</td>
				<td colspan=10 style="width:100px;text-align:center"><b>Payment Terms</b>&nbsp;</td>  	
<%				
				chkList = new ArrayList();
				for(int f=0;f<rfqVendLinesRetCnt;f++)
				{
					if(chkList.contains(rfqVendLinesRet.getFieldValueString(f,"RFQNO")))
					continue;
					else
					chkList.add(rfqVendLinesRet.getFieldValueString(f,"RFQNO"));
					String vend=rfqVendLinesRet.getFieldValueString(f,"VENDOR");
%>					
					<td style="width:100px;text-align:center">&nbsp;</td>  
					<td style="width:100px;text-align:center"></td>
					<td  style="width:100px;text-align:center">&nbsp;</td>
					<td style="width:100px;text-align:center"><b>20% Adv. Agn. ABG, 80% agn. L/c. against and  PBG OF 10% Value</b></td>  
					<td style="width:100px;text-align:center"></td>
<%
				
				} 
%>					
				</tr>	

			</tbody>
			</table>
			</div>
			

		  </div>
		</div> 
		</div> 
<%
	if(!"FromQuote".equals(fromType))
	{
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
<%
	}
%>		
		<br>
		<div class="row">
		<div class="col-xs-12" align="center">
			<button type="button" class="btn btn-primary" onclick="funBack()" ><i class="fa fa-backward"></i>&nbsp;Back</button>
<%
			if("New".equals(status))
			{
%>			
			<button type="button" class="btn btn-primary" onclick="funSubmit1()" ><i class="fa fa-check"></i>&nbsp;Submit</button>
<%
			}
%>			
			<!--<button type="button" class="btn btn-primary" onclick="funDownloadExcel()" ><i class="fa fa-check"></i>&nbsp;Download Excel</button>-->
			<button id="btnExport" class="btn btn-primary" onclick="fnExcelReport();"> <i class="fa fa-check"></i>&nbsp;Download Excel </button>
			<!--<button type="button" class="btn btn-primary" onclick="funPrint()" ><i class="fa fa-check"></i>&nbsp;Print</button>-->
		</div>
 	 	</div>			
		</div>
<%
		ezc.ezcommon.EzLog4j.log("rfqHashsize:::::::::::::::"+rfqHash,"I");
%>	
</form>
<iframe id="txtArea1" style="display:none"></iframe>
</body>
</html>
<%@ include file="../Misc/ezVendFooter.jsp"%>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../Misc/library/js/tableHeadFixer.js"></script>
<script>
/*
$(document).ready(function() {
$("#table-1").tableHeadFixer({"left" : 7}); 
});*/
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

function funSubmit()
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
					}
				}
			}
			alert("chkVal"+chkVal);
		       document.myForm.chkVal.value  = chkVal;
		       if(confirm("Are sure to submit the QCF Form?"))
		       {
		       		document.myForm.action="ezSaveQuotationComparisionForm.jsp";
		       		document.myForm.submit();
        	       }
}        	    
function funSubmit1()
{

			var len='<%=(rfqLinesRetCnt/2)%>';
			alert("len>>"+len)

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
		
		width:'100%',
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
function openReason(reason)
{ 
	var url="ezReason.jsp?reason="+reason;     
	$.fancybox.open({
		href : url, 
		type : 'iframe',
		
		width:'100%',
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
function calcBot(chkStr,chkRfq,chkLine,exchRate)
{ 
	
		//alert("chkStr"+chkStr);
		//alert("chkRfq"+chkRfq);
		//alert("chkLine"+chkLine);
		var itemQtyObj = eval("document.myForm.rfqQty"+chkRfq+chkLine);
		//alert("itemQtyObj"+itemQtyObj.value);
		if(itemQtyObj.value=='')
		{
			alert("Enter Recommended Qty at line"+chkLine+"with RFQ:"+chkRfq);
			itemQtyObj.value=0;
			itemQtyObj.focus()
			return;
		}
		
		var prItemQtyObj = eval("document.myForm.prItemQty"+chkLine);
		//alert("prItemQtyObjNew"+prItemQtyObj.value);
		if(itemQtyObj.value >prItemQtyObj.value)
		{
			alert("Recommended Qty should not be greater than PR Qty at line"+chkLine);
			itemQtyObj.value=0;
			itemQtyObj.focus()
			return;
		}		
		var rfqCount='<%=rfqHash.size()%>';
		//alert("rfqCount>>>>"+rfqCount);
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
		//alert("exchRate"+exchRate);
		var botTotValObj = eval("document.myForm.botTotVal"+chkRfq);
		var botPKGValObj = eval("document.myForm.botPKGVal"+chkRfq);		
		var botFRTValObj = eval("document.myForm.botFRTVal"+chkRfq);		
		//var botFRTQtyValObj = eval("document.myForm.botFRTQtyVal"+chkRfq);		
		var botSupValObj = eval("document.myForm.botSupVal"+chkRfq);		
		var botSupValInrObj = eval("document.myForm.botSupInrVal"+chkRfq);
		
		var itemBCDObj = eval("document.myForm.itemBCDVal"+chkRfq);
		var botBCDValObj = eval("document.myForm.botBCDVal"+chkRfq);
		
		var itemSWCObj = eval("document.myForm.itemSWC"+chkRfq);
		var botSWCValObj = eval("document.myForm.botSWCVal"+chkRfq);
		
		var botCHAValObj = eval("document.myForm.botCHAVal"+chkRfq);
		var itemCHA1Obj = eval("document.myForm.itemCHA1"+chkRfq);
		var botCHA1ValObj = eval("document.myForm.botCHA1Val"+chkRfq);
		var botIFRTValObj = eval("document.myForm.botIFRTVal"+chkRfq);
		var botOTHValObj = eval("document.myForm.botOTHVal"+chkRfq);
		var itemGSTObj = eval("document.myForm.itemGST"+chkRfq);
		var botGSTValObj = eval("document.myForm.botGSTVal"+chkRfq);
		var botGrossValObj = eval("document.myForm.botGrossVal"+chkRfq);
		var botDUTYValObj = eval("document.myForm.botDUTYVal"+chkRfq);
		var botLGSTValObj = eval("document.myForm.botLGSTVal"+chkRfq);
		var botLCValObj = eval("document.myForm.botLCVal"+chkRfq);
		
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
		alert("totalQuantity>>>>"+totalQuantity);
		//alert(totPriceVal);
		totPriceVal=(parseFloat(totPriceVal)).toFixed(2); 	
		botTotValObj.value = totPriceVal;
		if(totalQuantity>0)
		{
			botPKGValObj.value = eval("document.myForm.itemPKFWVal"+chkRfq).value;
			botFRTValObj.value = eval("document.myForm.itemFRTVal"+chkRfq).value;
			//botFRTQtyValObj.value = eval("document.myForm.itemFRTQtyVal"+chkRfq).value;

			var itemSupplyPrice = (parseFloat(botTotValObj.value)+ parseFloat(botPKGValObj.value) + parseFloat(botFRTValObj.value)).toFixed(2);
			var itemSupplyInrPrice=(parseFloat(itemSupplyPrice)* parseFloat(exchRate)).toFixed(2); 
			botSupValObj.value= itemSupplyPrice;
			botSupValInrObj.value=itemSupplyInrPrice;
			botBCDValObj.value = ((itemSupplyInrPrice * itemBCDObj.value)/100).toFixed(2);
			botSWCValObj.value = (((botBCDValObj.value) * itemSWCObj.value)/100).toFixed(2);
			botCHAValObj.value = eval("document.myForm.itemCHAVal"+chkRfq).value;
			botCHA1ValObj.value = (totalQuantity * eval("document.myForm.itemCHA1"+chkRfq).value).toFixed(2);
			botIFRTValObj.value = eval("document.myForm.itemIFRTVal"+chkRfq).value;
			botOTHValObj.value = eval("document.myForm.itemOTHVal"+chkRfq).value;
			botGSTValObj.value = ((parseFloat(botSupValInrObj.value)+ parseFloat(botBCDValObj.value) +parseFloat(botSWCValObj.value)) * parseFloat(itemGSTObj.value)/100).toFixed(2);
			botGrossValObj.value =( parseFloat(botSupValInrObj.value)+ parseFloat(botBCDValObj.value)+ parseFloat(botSWCValObj.value) + parseFloat(botCHAValObj.value) + parseFloat(botCHA1ValObj.value)+ parseFloat(botIFRTValObj.value) + parseFloat(botOTHValObj.value) + parseFloat(botGSTValObj.value) ).toFixed(2);
			botDUTYValObj.value = (parseFloat(botBCDValObj.value)+ parseFloat(botSWCValObj.value)).toFixed(2);
			botLGSTValObj.value = parseFloat(botGSTValObj.value).toFixed(2);
			botLCValObj.value = (parseFloat(botGrossValObj.value)-parseFloat(botDUTYValObj.value)-parseFloat(botLGSTValObj.value)).toFixed(2);
		}
		else
		{
			botPKGValObj.value = "0.00";
			botFRTValObj.value = "0.00";
			botSupValObj.value = "0.00";
			botSupValInrObj.value = "0.00";
			botBCDValObj.value = "0.00";
			botSWCValObj.value = "0.00";
			botCHAValObj.value = "0.00";
			botCHA1ValObj.value = "0.00";
			botIFRTValObj.value = "0.00";
			botOTHValObj.value = "0.00";
			botGSTValObj.value = "0.00";
			botGrossValObj.value = "0.00";
			botDUTYValObj.value = "0.00";
			botLGSTValObj.value = "0.00";
			botLCValObj.value = "0.00";
			
			
		}
			
		
		
		
}

</script>
