<%@page import="ezc.ezutil.*,java.util.*"%>
<%@ page import="java.text.*" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ include file="../Misc/ezDefaultDate.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%//@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iShowCal.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadDocs.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%!      
	public String checkNull(String str) 
	{ 
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str))
			retStr = "";
		else
			retStr = str;
			
		return retStr;	
	}
%>
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
.table thead th {
   
    padding: 10px;
    text-align: left;
   
    white-space: nowrap;
}
.table tbody td {
   
    padding: 10px;
  
    white-space: nowrap;
}
.zui-wrapper {
    position: relative;
}
.zui-scroller {

    overflow-x: scroll;
    overflow-y: visible;
    padding-bottom: 5px;
    
       width: auto;
   
}
.table .zui-sticky-col {
    border-left: solid 1px #DDEFEF;
    border-right: solid 1px #DDEFEF;
    left: 22px;
    position: absolute;
    top: auto;
    width: 120px;
}
.AED{
	display:inline-block;
	position: relative;
	}
.AED input{
	padding-left:15px;
	
	}
.AED:before {
	position: absolute;
	font-weight: bold;
    	content:"A";
    	left:5px;
	top:7px;
 	}  	
.AUD{
	display:inline-block;
	position: relative;
	}
.AUD input{
	padding-left:20px;
	
	}
.AUD:before {
	position: absolute;
	font-weight: bold;
    	content:"A$";
    	left:5px;
	top:7px;
 	}
.CHF{
	display:inline-block;
	position: relative;
	}
.CHF input{
	padding-left:15px;
	
	}
.CHF:before {
	position: absolute;
	font-weight: bold;
    	content:"C";
    	left:5px;
	top:7px;
 	}
.EUR{
	display:inline-block;
	position: relative;
	}
.EUR input{
	padding-left:15px;
	}
.EUR:before {
	position: absolute;
	font-weight: bold;
    	content:"€";
    	left:5px;
	top:7px;
 	} 	 	
.GBP{
	display:inline-block;
	position: relative;
	}
.GBP input{
	padding-left:15px;
	
	}
.GBP:before {
	position: absolute;
	font-weight: bold;
    	content:"£";
    	left:5px;
	top:7px;
 	} 
.IDR{
	display:inline-block;
	position: relative;
	}
.IDR input{
	padding-left:20px;
	
	}
.IDR:before {
	position: absolute;
	font-weight: bold;
    	content:"Rp";
    	left:5px;
	top:7px;
 	} 	
.INR{
	display:inline-block;
	position: relative;
	}
.INR input{
	padding-left:15px;
	}
.INR:before {
	position: absolute;
	font-weight: bold;
    	content:"\20B9";
    	left:5px;
    	top:7px;
 	}
.JPY{
	display:inline-block;
	position: relative;
	}
.JPY input{
	padding-left:15px;
	
	}
.JPY:before {
	position: absolute;
	font-weight: bold;
    	content:"¥";
    	left:5px;
	top:7px;
 	} 
.USD{
	display:inline-block;
	position: relative;
	}
.USD input{
	padding-left:15px;
	
	}
.USD:before {
	position: absolute;
	font-weight: bold;
    	content:"$";
    	left:5px;
	top:7px;
 	} 	
 th
{	
    color: white;
    background: #325786; 
	
} 	
</style>

<!-- Content Wrapper. Contains page content --> 
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
     	Vendor Quotation
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post">
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=ordDate%>">
	<input type="hidden" name="PurchaseOrder" value="<%=poNum%>">
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	<input type="hidden" name="expStat" value="<%=expStat%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVendor%>" >
	<input type="hidden" name="rfqBuyer" value="<%=rfqBuyer%>" >
	<input type="hidden" name="PaymentTermsHid" value="<%=dtlXML.getFieldValueString(0,"ERH_PAYMENT_TERMS")%>" >
	<input type="hidden" name="IncoTermsHid" value="<%=dtlXML.getFieldValueString(0,"ERH_INCO_TERMS1")%>" >
<%
	String logonSite = (String)session.getValue("SITE");
	//ezc.ezcommon.EzLog4j.log("::gv_UserAuthVect:::"+gv_UserAuthVect,"I");
	String PrNO= dtlXML.getFieldValueString(0,"ERH_PR_NO"); 
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();    
	String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
	int pmntLen   = pmntObj.getRowCount();
	int incoLen   = incoObj.getRowCount();
	java.util.Hashtable hashDisc = new java.util.Hashtable(); 
	hashDisc.put("P","Discount % on Basic");
	hashDisc.put("Q","Discount/Qty");
	hashDisc.put("V","Discount(Value)");
	hashDisc.put("","N/A");	
	
	//TO Fetch Vendor Payment Terms and Inco Terms
	String [] outputFeilds =new String[]{"ZTERM","INCO1"};
	String [] queryValues =new String[]{"LIFNR EQ '"+rfqVendor+"' AND EKORG EQ '1000'"}; 
	
	ReturnObjFromRetrieve retPaymentTerm = readRFCTable(logonSite,"LFM1",outputFeilds,queryValues);
	ezc.ezcommon.EzLog4j.log("::retPaymentTerm:::"+retPaymentTerm.toEzcString()+"::::::::","I");
	ezc.ezcommon.EzLog4j.log("::VendPaymentTerm:::"+retPaymentTerm.getFieldValueString(0,"ZTERM")+"::::::::","I");
	ezc.ezcommon.EzLog4j.log("::VendIncoTerm:::"+retPaymentTerm.getFieldValueString(0,"INCO1")+"::::::::","I");
	ezc.ezcommon.EzLog4j.log("::rfqVendor11:::"+rfqVendor,"I");
	
	String gv_VendCat ="DOM";
	

	
%>
	<!-- Table row -->
      <div class="row">
	<div class="col-xs-12 table-responsive" style="overflow-x: hidden;"> 	    
	<table class="table table-bordered">
	<tr>
		<th align="left" width="25%">RFQ Ref. No</th>
      		<td valign="middle" align="left" width="25%"><input type="hidden" name="RfqNo" value="<%=poNum%>"><%=poNum%></td>
		<th align="left" width="25%">RFQ Date</th>
        	<td valign="middle" align="left" width="25%"><%=OrderDate%></td>
	</tr>
	<tr>
		<th align="left" width="25%">Quotation End Date</th>
      		<td valign="middle" align="left" width="25%">
<%
			SimpleDateFormat formatter1   = new SimpleDateFormat("dd/MM/yyyy HH:mm"); 		
			SimpleDateFormat formatter2   = new SimpleDateFormat("dd/MM/yyyy"); 		
			String 	         qtndate      = convertDateObjToString(new Date());
			Date             rfqCloseDate = (java.util.Date)dtlXML.getFieldValue(0,"ERH_VALID_UPTO");
%>
       		<%=formatter2.format(rfqCloseDate)%>
       		</td>
       		<input type="hidden" name="qtnEndDate" value="<%=formatter1.format(rfqCloseDate)%>">
		<th align="left" width="25%">Qtn. Date</th>
      		<td valign="middle" align="left" width="25%"><%=qtndate%><input type="hidden" name="QtnDate" value="<%=qtndate%>">
        	</td>
	</tr>
	<tr>
	<th align="left" width="25%">LD Clause</th>
	<td colspan="3" class="form-control">&nbsp;&nbsp; 
	<%=checkNull(dtlXML.getFieldValueString(0,"ERH_LD_CLAUSE"))%></td>
	<td colspan="3">&nbsp;</td>
	
	</tr>
	<tr>
	<th align="left" width="25%">LD Clause Applicable</th>
	<td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="ldApp" value="Y">&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;<input type="radio"  name="ldApp" value="N" checked>&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;
		
	</td>	
	<th align="left" width="25%">Performance Guarantee</th>
	<td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="pgApp" value="Y">&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;<input type="radio"  name="pgApp" value="N" checked>&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;
			
	</td>
	</tr>
	<tr>
	<th align="left" width="25%">Payment Terms</th>
	<td width="25%" colspan="3">
	<select name=PaymentTerms class="form-control select2" style="width:100% !important">
		<option value="">Select Payment Terms</option>
<%
			for(int j=0;j<pmntLen;j++)
			{	
				String selected="";
				String payTmFromtbl="";
				payTmFromtbl=dtlXML.getFieldValueString(0,"ERH_PAYMENT_TERMS").trim();
				if(!"".equals(retPaymentTerm.getFieldValueString(0,"ZTERM")) && !"null".equals(retPaymentTerm.getFieldValueString(0,"ZTERM")))								         	
				payTmFromtbl=retPaymentTerm.getFieldValueString(0,"ZTERM").trim();
				String payTm=pmntObj.getFieldValueString(j,"EMKV_KEY").trim();
				if(payTmFromtbl.equals(payTm))selected="selected";
				out.println("<option value='"+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+"' "+selected+">"+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+pmntObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>					

 	 		</select>	
	    
	</td>
	<!--<th align="left" width="25%">Lead Time( in days)</th>
	<td width="25%" ><input type="number" value="0" min="1"  max="999" onKeyUp="if(this.value>999){this.value='999';}else if(this.value<0){this.value='0';}" name="leaddaysHeader" onchange="funSetItemLead(this)"/></td>-->
	</tr>
	<tr>
	<th align="left" width="25%">Inco Terms</th>
	<td width="25%" colspan="3">
	
	
 	<select name=IncoTerms class="form-control select2" style="width:100% !important" onChange="funIncoDom(this)">
			<option value="">Select Inco Terms</option>
<%
			for(int j=0;j<incoLen;j++)
			{
				String selected="";
				String incoTmFromtbl="";
				if(!"".equals(retPaymentTerm.getFieldValueString(0,"INCO1")) && !"null".equals(retPaymentTerm.getFieldValueString(0,"INCO1")))								         	
				incoTmFromtbl=retPaymentTerm.getFieldValueString(0,"INCO1").trim();
				String incoTm=incoObj.getFieldValueString(j,"EMKV_KEY").trim();
				
				if(incoTmFromtbl.equals(incoTm))selected="selected";
				/*if("DOM".equals(gv_VendCat))
				{
					if("EXW".equals(incoTm)||"DAP".equals(incoTm))
					{
						out.println("<option value='"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"' "+selected+"	>"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+incoObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					}
				}
				else*/
						out.println("<option value='"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"' "+selected+"	>"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+incoObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");		
			}
%>					
	
 	 </select>
			
	</td>
	
	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	
	<div>
	<!-- Table row --> 
        <div class="row">
	<div class="col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<div class="zui-wrapper">
	<div class="zui-scroller">	
	<table class="table table-bordered table-responsive"> 
    	<thead>
    	<tr>
    		<th>Line</th>
		<th>Material</th>
		<th align="center">Description</th>
		<!--
		<th>Item Text</th>
	    	<th>PO Text</th>-->
	    	<th>Delivery Date</th>
	    	<th>Remarks</th>
	    	<th>Warranty</th>
	    	<th>HSN/SAC</th>
	    	<!--<th>Query</th>-->
		<th>Qty</th>
		<th>UOM</th>
		<!--<th>Lead<br>Time(days)</th>-->
		<th>Currency</th>
		<th>MRP Price</th>
		<th>Basic Price</th>
		<th>Discount Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th>Discount Value</th>
		
		<th>GST(%)</th> 
		
		<th>Total</th>
		<!--<th>Discount Type</th>
		<th>Discount</th>
		<th>Discount Value</th>
		<th>Pkg & Fwd Type</th>
		<th>Pkg & Fwd Chrgs</th>
		<th>Pkg & Fwd Value</th>
		<th>Freight Type</th>
		<th>Freight</th>
		<th>Freight Value</th>
		<th>Supply Price</th> 
		<th>GST(%)</th> 
		<th>GST Value</th>
		<th>Gross Value</th>-->
		<th>Conditions</th>
		
	</tr>
 	</thead>
        <tbody>
 	<%
 	String curr="INR"; //gv_VendCurr.trim();
 	
 	ReturnObjFromRetrieve retcur = null;
	EzcSysConfigParams sparams1 = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams1 = new EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	retcur = (ReturnObjFromRetrieve)ConfigManager.getCurrencyDesc(sparams1);

	String fields[]= new String []{ "ECD_LONG_DESC"};
	retcur.sort(fields,true);
	int currLength = retcur.getRowCount();
	
	//TO Fetch HSN against maeterial
	
	String [] outputFeilds1 =new String[]{"STEUC"};
	String [] queryValues1 = null;
	ReturnObjFromRetrieve retHSN = null;
	
	//TO Fetch HSN Condition
	
	String [] outputFeilds2 =new String[]{"KNUMH"};
	String [] queryValues2 = null;
	ReturnObjFromRetrieve retHSNCond = null;	
	
	//TO Fetch GST 
	
	String [] outputFeilds3 =new String[]{"KBETR"};
	String [] queryValues3 = null;
	ReturnObjFromRetrieve retGST = null;	
	String  retGSTVal = "0";
	
	String readOnlyImp="";
	String readOnlySer="";
	
	if("DOM".equals(gv_VendCat))
		readOnlyImp="";
		
	String poActive="";
	String itemActive="";
	String currStr="";
	
	currStr="<div class="+curr+">";
	
	for(int i=0;i<Count;i++)
      	{
      		String rfqItemPos = i+"";
      		String net  = dtlXML.getFieldValueString(i,"NET_VALUE");
      		String amt = dtlXML.getFieldValueString(i,"AMOUNT");
      		
      		
      		try
		{
			amt = (Double.parseDouble(amt)*100)+"";
			amt  = new java.math.BigDecimal(amt).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
		}catch(Exception e){}
      		
      		
      		
      		//double myQty=100.0;
      		
      		String myQty = dtlXML.getFieldValueString(i,"ERD_QUANTITY");
      		String leaddays = "";//dtlXML.getFieldValueString(i,"ERD_LEAD_DAYS");
      		
      		
      		try
		{
			myQty = (Double.parseDouble(myQty))+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 
			
		}catch(Exception e){}      		
      		
		//if(amt!=null)
	      		//curr=  dtlXML.getFieldValueString(i,"CURRENCY"); 
	      	/*
	      	if("DOM".equals(gv_VendCat))
	      		curr="INR";
	      	else if("IMP".equals(gv_VendCat))
	      		curr="USD"; */
	      	//curr=gv_VendCurr.trim();
	      	/*
	      	
		String tempMat=dtlXML.getFieldValueString(i,"ERD_MATERIAL");
		tempMat  = "000000000000000000"+tempMat.trim();
		tempMat = tempMat.substring(tempMat.length()-18,tempMat.length());
		ezc.ezcommon.EzLog4j.log("::tempMat:::"+tempMat+"::::::::","I");
	      	
	      	
	      	queryValues1 = new String[]{"MATNR EQ '"+tempMat+"' AND WERKS EQ '"+dtlXML.getFieldValueString(i,"ERD_PLANT")+"'"};  
	      	retHSN = readRFCTable(logonSite,"MARC",outputFeilds1,queryValues1);
	      	ezc.ezcommon.EzLog4j.log("::retHSN:::"+retHSN.toEzcString()+"::::::::","I");
	      	
	      	queryValues2 = new String[]{"KAPPL EQ 'TX' AND KSCHL EQ 'JIIG' AND STEUC EQ '"+retHSN.getFieldValueString(0,"STEUC")+"'"}; 
	      	retHSNCond = readRFCTable(logonSite,"A802",outputFeilds2,queryValues2);
	      	ezc.ezcommon.EzLog4j.log("::retHSNCond:::"+retHSNCond.toEzcString()+"::::::::","I");	
	      	
	      	queryValues3 = new String[]{"KNUMH EQ '"+retHSNCond.getFieldValueString(0,"KNUMH")+"'"}; 
	      	retGST = readRFCTable(logonSite,"KONP",outputFeilds3,queryValues3);
	      	ezc.ezcommon.EzLog4j.log("::retGST:::"+retGST.toEzcString()+"::::::::","I");
	      	
	      	if(retGST!=null)
	      		retGSTVal = retGST.getFieldValueString(0,"KBETR").trim(); 

		try
		{
		retGSTVal = (Double.parseDouble(retGSTVal)/10)+"";
		retGSTVal  = new java.math.BigDecimal(retGSTVal).setScale(0,java.math.BigDecimal.ROUND_HALF_UP).toString();

		}catch(Exception e)
		{
			retGSTVal="0";
		} */
		retGSTVal="18";
	      	String  prDet=checkNull(dtlXML.getFieldValueString(i,"ERD_EXT1"));
		String prNo="",prItem="";
	      	if(!"".equals(prDet))
	      	{
	      		 prNo=prDet.split("¥")[0];
	      		 prItem=prDet.split("¥")[1];
	      	}	      	
	      	String  itemText=checkNull(dtlXML.getFieldValueString(i,"ERD_EXT2"));
	      	itemText=itemText.replaceAll("'","`");
		itemText = itemText.replaceAll("\"", "`");
		itemText = itemText.replaceAll("$", "");
		itemText = itemText.replaceAll("&", "&amp;");
		itemText = itemText.replaceAll("<", "&lt;");
		itemText = itemText.replaceAll("#", "");
		itemText = itemText.trim();	      
		
		
	      	String  poText=checkNull(dtlXML.getFieldValueString(i,"ERD_EXT3"));
		poText = poText.replaceAll("'","`");
		poText = poText.replaceAll("\"", "`");
		poText = poText.replaceAll("$", "");
		poText = poText.replaceAll("&", "&amp;");
		poText = poText.replaceAll("<", "&lt;");
		poText = poText.replaceAll("#", "");
		poText = poText.replaceAll(",", "");
		poText = poText.trim();	  
		
		poActive="color:blue";
		itemActive="color:blue";


		if(poText!=null && !"null".equals(poText) && !"".equals(poText) && poText!="")
			poActive="color:orange";

		if(itemText!=null && !"null".equals(itemText) && !"".equals(itemText) && itemText!="")
			itemActive="color:orange";
			
		String  remarks=checkNull(dtlXML.getFieldValueString(i,"ERD_REMARKS"));			
		String  warranty=checkNull(dtlXML.getFieldValueString(i,"ERD_WARRANTY"));			
			
	      	String  rfqLineItem =checkNull(dtlXML.getFieldValueString(i,"ERD_LINE_NO"));
	      	String matNo="";
	      	try{matNo=Long.toString(Long.parseLong(dtlXML.getFieldValueString(i,"ERD_MATERIAL")));
	      	}catch(Exception e){
						matNo=dtlXML.getFieldValueString(i,"ERD_MATERIAL");
		}
		if("NA".equals(matNo))
			matNo="";
		Date    delDate = (java.util.Date)dtlXML.getFieldValue(i,"ERD_DELIVERY_DATE");
		String accCat	= dtlXML.getFieldValueString(i,"ERD_ACC_CAT");
		String itemCat	= dtlXML.getFieldValueString(i,"ERD_ITEM_CAT");
		
		if("D".equals(itemCat))
		{		
%>
			<tr style="background-color:#e4ff00">
<%
		}
		else
		{
%>		
	      		<tr>
<%
		}
%>		
      		<input type=hidden name="rfqItem" value="<%=rfqItemPos%>">
      		<input type=hidden name="itemCat<%=rfqItemPos%>" value="<%=itemCat%>">
      		<td align="center"><%=rfqLineItem%></td>
      		<td align="center"><input type=hidden name="rfqLineItem<%=rfqItemPos%>" value="<%=dtlXML.getFieldValueString(i,"ERD_LINE_NO")%>">
			<%=matNo%>
			</td>
			<input  type="hidden" name="mat<%=rfqItemPos%>"  value="<%=matNo%>">   
			<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC")%></td>
			<input  type="hidden" name="matDesc<%=rfqItemPos%>"  value="<%=dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC")%>">     
			<input  type="hidden" name="plant<%=rfqItemPos%>"  value="<%=dtlXML.getFieldValueString(i,"ERD_PLANT")%>"> 
			<input  type="hidden" name="pr<%=rfqItemPos%>"  value="<%=prNo%>"> 
			<input  type="hidden" name="prItem<%=rfqItemPos%>"  value="<%=prItem%>"> 
		<!--<%if(!"RFQ".equals(prNo)){%>			
		<td align="left">
		<a href="javascript:openItemDet('<%=prNo%>','<%=prItem%>','<%=matNo%>','<%=itemText%>','I')"> <span style="<%=itemActive%>" class="fa fa-external-link"></span> </a></td> 
		<td align="left">
		<a href="javascript:openItemDet('<%=prNo%>','<%=prItem%>','<%=matNo%>','<%=poText%>','P')"> <span style="<%=poActive%>" class="fa fa-external-link"></span> </a></td> 
      		<%}%> -->
      		
      		<td align="center"><input type="hidden" name="delDate<%=i%>" value="<%=formatter2.format(delDate)%>"><%=formatter2.format(delDate)%></td>
      		<td align="center"><%=remarks%></td>
      		<td align="center"><input type="text" name="warranty<%=rfqItemPos%>"  style="width:120px;" value="<%=warranty%>" class="form-control"></td>
		<td align="center">
		<input type="hidden" name="SAPHSNCODE<%=rfqItemPos%>" value=""/>
		<input type=text name="vendHSNGST<%=rfqItemPos%>"  id="vendHSNGST<%=rfqItemPos%>" style="width:120px;"   class="form-control" value="" onkeypress='return event.charCode == 46 || (event.charCode >= 48 && event.charCode <= 57)' onchange="" <%=readOnlyImp%> ></td>      		
      		<!--<td align="left">
      		<a href="javascript:raiseQuery('<%=rfqLineItem%>')"> <span class="fa fa-external-link"></span> </a>
      		</td> -->
      		<td align="center"><%=myQty%><input type="hidden" name="rfqItemQty<%=rfqItemPos%>" value="<%=myQty%>"></td>
      		<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_UOM")%></td>
      		<input type="hidden" name="uom<%=rfqItemPos%>" value="<%=dtlXML.getFieldValueString(i,"ERD_UOM")%>"> 
      		
      		
      		<!--<td align="center" nowrap><input type="number" value="<%=leaddays%>" min="1"   max="999" onKeyUp="if(this.value>999){this.value='999';}else if(this.value<0){this.value='0';}" name="leaddays<%=rfqItemPos%>" style="width:100px;"/></td>-->
      		<!--<td align="center">
      		<select name="rfqItemCurr<%=rfqItemPos%>" class="form-control select2" style="width:100% !important"> 

		<%
		for(int j=0;j<currLength;j++)
		{
			if(retcur.getFieldValueString(j,"EC_CURR_KEY").trim().equals(curr))
				out.println("<option value="+retcur.getFieldValueString(j,"EC_CURR_KEY").trim()+" selected>"+retcur.getFieldValueString(j,"EC_CURR_KEY")+"</option>");
			else
				out.println("<option value="+retcur.getFieldValueString(j,"EC_CURR_KEY").trim()+">"+retcur.getFieldValueString(j,"EC_CURR_KEY")+"</option>");
		}
		%>
		</select>
     		</td> -->
     		<td align="center">
     			<input type="hidden" name="rfqItemCurr<%=rfqItemPos%>" value="<%=curr%>">
     		<%=curr%></td>
		<td  align="center" nowrap>
		<input type=number name="itemMRP<%=rfqItemPos%>"  style="width:120px;" size=9  min="0" class="form-control" value=''></td>     		
     		<td  align="center" nowrap>
     		
     		<!--<input type=number name="itemPrice<%=rfqItemPos%>"  style="width:100px;" size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=rfqItemPos%>')" >-->
     		<input type=hidden name="itemQty<%=rfqItemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=myQty%>'>
		
		
		
<%	
		
		if("D".equals(itemCat))
		{
			readOnlySer="readOnly";
		
			
%>			<div class="input-group">
				<input type=number name="itemPrice<%=rfqItemPos%>"  style="width:95px;" size=9  min="0" class="form-control" value='' onchange="checkNum(this,'<%=rfqItemPos%>')" readOnly>&nbsp;&nbsp;
				<a href="javascript:openService('<%=prNo%>','<%=prItem%>','<%=poNum%>','<%=rfqLineItem%>','<%=rfqItemPos%>')"><img src="services4.PNG" style="VERTICAL-ALIGN: -webkit-baseline-middle;"></a>
				<input type="hidden" name="serLine<%=rfqLineItem%>" value="">
				<input type="hidden" name="serSAC<%=rfqLineItem%>" value="">
				<input type="hidden" name="serGST<%=rfqLineItem%>" value="">
				<input type="hidden" name="serPrice<%=rfqLineItem%>" value="">
			</div>
<%
		}else{
%>					
			<input type=number name="itemPrice<%=rfqItemPos%>"  style="width:120px;" size=9  min="0" class="form-control" value='' onchange="checkNum(this,'<%=rfqItemPos%>')" ></td>
<%
		}
%>
		<td align="center">
				<select name="valTypeDISC<%=rfqItemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=rfqItemPos%>','DISC')" style="width:100% !important">
				<option value="">-- Select--</option>
				<option value="P">Discount % on Basic</option>
				<option value="Q">Discount/Qty</option>
				<option value="V">Discount(Value)</option> 
				</select>
     		</td> 		
		<td  align="center" nowrap><input type=number name="itemDISC<%=rfqItemPos%>"  style="width:100px;"  size=9 min="0" class="form-control" value="" onchange="funCheckDis(this,'<%=rfqItemPos%>')" ></td>
		
	

		<td  align="center" nowrap><input type="hidden" name="SAPGST<%=rfqItemPos%>" value=""/>
		<input type=number name="vendGST<%=rfqItemPos%>" id="vendGST<%=rfqItemPos%>"   style="width:100px;"   min="0" max="99"   class="form-control" value="" onKeyUp="if(this.value>99){this.value='99';}else if(this.value<0){this.value='0';}" onBlur="checkNum(this,'<%=rfqItemPos%>')" <%=readOnlyImp%> ></td>
		
		<td  align="center" nowrap><input type=number name="itemValue<%=rfqItemPos%>"  style="width:120px;" size=10  class="form-control" value='0' readonly>
	
		
		
		
		
		
		<input type=hidden name="itemDISCVal<%=rfqItemPos%>"  style="width:100px;" size=9  class="form-control" value="0" ></td>
		<input type="hidden" name="itemDISCCode<%=rfqItemPos%>" value="DISC">
     		<!--<input type="hidden" name="itemVal<%=rfqItemPos%>" value="0">  
     		<input type="hidden" name="itemTotalVal<%=rfqItemPos%>" value="0.00"> 
     		<input type="hidden" name="valTypeDISC<%=rfqItemPos%>" value="">
     		<input type="hidden" name="itemDISC<%=rfqItemPos%>" value="0">
     		<input type="hidden" name="itemDISCCode<%=rfqItemPos%>" value="DISC">
     		<input type="hidden" name="itemDISCVal<%=rfqItemPos%>" value="0.00">
     		<input type="hidden" name="valTypePKFW<%=rfqItemPos%>" value="">
     		<input type="hidden" name="itemPKFW<%=rfqItemPos%>" value="0">
     		<input type="hidden" name="itemPKFWCode<%=rfqItemPos%>" value="PKFW">
     		<input type="hidden" name="itemPKFWVal<%=rfqItemPos%>" value="0.00">  
     		<input type="hidden" name="valTypeFRT<%=rfqItemPos%>" value="">
     		<input type="hidden" name="itemFRT<%=rfqItemPos%>" value="0">
     		<input type="hidden" name="itemFRTCode<%=rfqItemPos%>" value="FRT">
     		<input type="hidden" name="itemFRTVal<%=rfqItemPos%>" value="0.00">    
     		<input type="hidden" name="itemSupplyPrice<%=rfqItemPos%>" value="0.00"> 
     		<input type="hidden" name="valTypeTAX<%=rfqItemPos%>" value="P">
     		<input type="hidden" name="itemTAX<%=rfqItemPos%>" value="0">
     		<input type="hidden" name="itemTAXCode<%=rfqItemPos%>" value="TAX">
     		<input type="hidden" name="itemTAXVal<%=rfqItemPos%>" value="0.00"> 
     		<input type="hidden" name="itemGrossVal<%=rfqItemPos%>" value="0.00">  -->
     		
     		<!--<td align="center" nowrap><input type=number name="itemTotalVal<%=rfqItemPos%>"  style="width:120px;" size=9  class="form-control" value="0" readonly></td>
     		
		<td align="center">
				<select name="valTypeDISC<%=rfqItemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=rfqItemPos%>','DISC')" style="width:100% !important">
				<option value="">-- Select--</option>
				<option value="P">Discount % on Basic</option>
				<option value="Q">Discount/Qty</option>
				<option value="V">Discount(Value)</option> 
				</select>
     		</td>     		
     		<td align="center" nowrap><input type=number name="itemDISC<%=rfqItemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=rfqItemPos%>')" readonly></td>
     		<td align="center" nowrap>
     				<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
				<input type=number name="itemDISCVal<%=rfqItemPos%>"  style="width:100px;" size=9  class="form-control" value="0" readonly>
		</td>
		<td align="center">
				<select name="valTypePKFW<%=rfqItemPos%>" class="form-control input-sm select2" onChange="chkSel(this,'<%=rfqItemPos%>','PKFW')" style="width:100% !important">
				<option value="">-- Select--</option>
				<option value="P">Pkg&Fwd chrgs(%)</option>
				<option value="Q">Pkg&Fwd/Qty</option>
				<option value="V">Pkg&Fwd chrg-value</option>
				</select>
     		</td> 		
     		
     		<td width="20%" style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW" id="itemPKFW" style="width:100px;"   size=9  class="form-control" value="0" min="0"   onchange="funCal(this,'PKFW')" ></td>
     		
     		<td align="center" nowrap>
     				
				<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
     				<input type=number name="itemPKFWVal<%=rfqItemPos%>" style="width:100px;"  size=9  class="form-control" value="0" readonly>
     		</td>  
		<td align="center">
				<select name="valTypeFRT<%=rfqItemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=rfqItemPos%>','FRT')" style="width:100% !important">
				<option value="">-- Select--</option>
				<option value="P">Freight(%)</option> 
				<option value="Q">Freight/Qty</option>
				<option value="V">Freight(Value)</option> 
				</select>
     		</td>  
     		<td align="center" nowrap><input type=number name="itemFRT<%=rfqItemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=rfqItemPos%>')" readonly></td>
     		<td align="center" nowrap>
				
				<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT">      		
     				<input type=number name="itemFRTVal<%=rfqItemPos%>" size=9  class="form-control" value="0" readonly>
     		</td>

     		<td align="center" nowrap><input type=number name="itemSupplyPrice<%=rfqItemPos%>"  style="width:120px;" size=9  class="form-control" value="0" readonly></td>
     		<td align="center" nowrap>
			<input  type="hidden" name="valTypeGST<%=rfqItemPos%>"  value="P"> 
			<input  type="hidden" name="itemGSTCode<%=rfqItemPos%>"  value="TAX">      		
     			<input type=number name="itemGST<%=rfqItemPos%>"  style="width:100px;"   size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=rfqItemPos%>')">
     		</td>
     		<td align="center" nowrap><input type=number name="itemGSTVal<%=rfqItemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly></td>
     		<td align="center"><input type=number name="itemGrossVal<%=rfqItemPos%>" style="width:100px;" size=9 class="form-control"    value="0" readonly></td>-->
     		<td align="center"><a href="javascript:saveConditions('<%=poNum%>','<%=dtlXML.getFieldValueString(i,"ERD_LINE_NO")%>','<%=rfqItemPos%>');"><img src="cond.PNG"></a></td>

     		</tr>
	<%}%>
	<tr>
<%
		if("DOM".equals(gv_VendCat))
		{
			if(!"RFQ".equals(PrNO)){
%>	
				<th colspan="16">Total Value</th>
				<td><input type=number name="itemTotalVal" style="width:120px;" size=9 class="form-control"    value="0" readonly></td>
			
<%			}
			else{
%>				<th colspan="12">Total Value</th>	
				<td><input type=number name="itemTotalVal" style="width:120px;" size=9 class="form-control"    value="0" readonly></td>		
<%			}
		}	
		else if("IMP".equals(gv_VendCat))
		{
%>	
		<th colspan="14">Total Value</th>
		<td><%=currStr%><input type=number name="itemTotalVal" style="width:120px;" size=9 class="form-control"    value="0" readonly></td>
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
 	</div>
 	</div>
 	</div> 
 	 <div class="row">
		<div class="col-xs-12">
		<div class="box box-primary">
		<div class="box-body">
		<div class="zui-wrapper">
		<div class="zui-scroller">	
		<table class="table table-bordered table-responsive"> 
		
		<tr>
			<th width="40%" >Pkg & Fwd</th>
			<td style="background-color:#d5dcef" align="center" width="40%">
				<select name="valTypePKFW" id="valTypePKFW" class="form-control input-sm select2" onChange="chkSel(this,'0','PKFW')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(gv_VendCat))
				{
%>					
					<option value="P" selected>Pkg&Fwd chrgs(%)</option>
					<option value="Q">Pkg&Fwd/Qty</option>
					<option value="V">Pkg&Fwd chrg-value</option>
				</select>
				</td> 		
				<td width="20%" style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW" id="itemPKFW" style="width:100px;"   size=9 class="form-control" value="0" min="0"   onchange="funCal(this,'PKFW')" ></td>					
<%	
				}
				else if("IMP".equals(gv_VendCat))
				{
%>	
					<option value="P">Pkg&Fwd chrgs(%)</option>
					<option value="V">Pkg&Fwd chrg-value</option>					
				</select>
				</td> 		
				<td width="20%" style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW" id="itemPKFW" style="width:100px;"   size=9 class="form-control" value="0" min="0"  onchange="funCal(this,'PKFW')" ></td>									
<%
				}
%>				
				

			<td style="background-color:#d5dcef" align="center" nowrap>

				<input  type="hidden" name="itemPKFWCode"  value="PKFW"> 
				<%=currStr%><input type=number name="itemPKFWVal" id="itemPKFWVal" style="width:120px;"  size=9  class="form-control" value="0" readonly>
			</td>
		</tr>
		<tr>
<%
			if("DOM".equals(gv_VendCat))
			{
%>			
				<th width="40%">Freight</th>
<%	
			}
			else if("IMP".equals(gv_VendCat))
			{
%>	
				<th width="40%">Ocean Freight</th>
<%
			}
%>			
				
				
			<td style="background-color:#d5dcef" align="center" width="40%">
				<select name="valTypeFRT" id="valTypeFRT"  class="form-control input-sm select2"  onChange="chkSel(this,'0','FRT')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(gv_VendCat))
				{
%>					
					<option value="P" selected>Freight(%)</option>
					<option value="Q">Freight/Qty</option>
					<option value="V">Freight(Value)</option>
				</select>
			</td>  
			<td style="background-color:#d5dcef" align="center" nowrap width="20%"><input type=number name="itemFRT" id="itemFRT"  style="width:100px;"  size=9  class="form-control" value="0" min="0"   onchange="funCal(this,'FRT')"></td>					
<%	
				}
				else if("IMP".equals(gv_VendCat))
				{
%>	
					<option value="P">Ocean Freight(%)</option>
					<option value="V">Ocean Freight(Value)</option>
					<option value="Q">Ocean Freight/Qty</option>
				</select>
			</td>  
			<td style="background-color:#d5dcef" align="center" nowrap width="20%"><input type=number name="itemFRT" id="itemFRT"  style="width:100px;"  size=9  class="form-control" value="0" min="0"  onchange="funCal(this,'FRT')"></td>
<%
				}
%>				
			<td style="background-color:#d5dcef" align="center" nowrap>

				<input  type="hidden" name="itemFRTCode"  value="FRT">      		
				<%=currStr%><input type=number name="itemFRTVal"  id="itemFRTVal"  style="width:120px;" size=9  class="form-control" value="0" readonly>
			</td>
		</tr> 
		<tr>
			<th width="40%">Charges</th>
			<td style="background-color:#d5dcef" align="center" width="40%"><input type="hidden" name="OTH" value="V" readonly>Others </td>		
			<td style="background-color:#d5dcef" align="center" nowrap>
				<input  type="hidden" name="itemOTHCode"  value="OTH"> 
				<input type=number name="itemOTH"  style="width:100px;"   size=9  class="form-control" value="0" onchange="funCal(this,'OTH')" >
			</td>
			<td style="background-color:#d5dcef" align="center" nowrap><%=currStr%><input type=number name="itemOTHVal" style="width:120px;" size=9  class="form-control" value="0" readonly></td>							
		</tr>
		
<%				
		String GSTstr="";
		if("DOM".equals(gv_VendCat))
		{
			GSTstr="GST";

				
%>					
		<tr>
			<th width="40%">Tax</th>
			<td style="background-color:#d5dcef" align="center" width="40%">
				<!--<select name="valTypeTAX" class="form-control input-sm select2"  onChange="chkSel(this,'0','TAX')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(gv_VendCat))
				{
%>					
					<option value="P" selected>GST</option>
<%	
				}
				else if("IMP".equals(gv_VendCat))
				{
%>
					<option value="P" selected>IGST</option>
<%
				}
%>					
						</select>-->
				
				<input type="hidden" name="valTypeTAX" value="P" readonly><%=GSTstr%> </td>		
								
					<td style="background-color:#d5dcef" align="center" nowrap>
						<input  type="hidden" name="itemTAXCode"  value="TAX"> 
						    		
						<input type=hidden name="itemTAX"  style="width:100px;"   size=9  class="form-control" value="<%=retGSTVal%>" onchange="funCal(this,'TAX')" readonly>
					</td>			
					<td style="background-color:#d5dcef" align="center" nowrap><%=currStr%><input type=number name="itemTAXVal" style="width:120px;" size=9  class="form-control" value="0" readonly></td>
				</tr>	
				<tr style="background-color:#00c0ef">
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=2 style="width:100px;text-align:center"><b>Gross Value</b>&nbsp;</td>
					<td align="left" nowrap><%=currStr%><input type=number name="itemGrossVal"  style="width:120px;" size=9  class="form-control" value='0' readonly></td>
				</tr>
<%
				}
				else if("IMP".equals(gv_VendCat))
				{
%>
				<input type="hidden" name="valTypeTAX" value="P" readonly><%=GSTstr%> </td>
				<input  type="hidden" name="itemTAXCode"  value="TAX"> 
				<input type=hidden name="itemTAX"  style="width:120px;"   size=9  class="form-control" value="<%=retGSTVal%>" onchange="funCal(this,'TAX')" readonly>
				<input type=hidden name="itemTAXVal" style="width:120px;" size=9  class="form-control" value="0" readonly>
				
				<tr style="background-color:#00c0ef">
					<td style="width:100px;text-align:center">&nbsp;</td>
					<td colspan=2 style="width:100px;text-align:center"><b>Supply Price</b>&nbsp;</td>
					<td align="center" nowrap><%=currStr%><input type=number name="itemGrossVal"  style="width:120px;" size=9  class="form-control" value='0' readonly></td>
				</tr>
<%
				}
%>
			</table>
			</div>
			</div>
		</div>
		</div>
		</div>
		</div>

<% 
	ReturnObjFromRetrieve retCom = null; //getDocComments(Session,poNum,"RFQ");
	if(retCom!= null)
	{
		if(retCom.getRowCount()>0)
		{
%>
      	<div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">	    
	<table class="table table-bordered">
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
	}
%>	 	
	<h4>
		 Comments
	</h4>	
	<div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
		<table class="table table-bordered">
			<td colspan=3><textarea class="form-control" name="Comments" placeholder="Enter Comments" rows="2"></textarea></td>
		</table>
	</div>
	</div>
	</div>
	</div>
<%
				
	ReturnObjFromRetrieve retUploadList = getDocUploadList(Session,poNum,"RFQ","H"); 
	int retUploadListCnt = 0; 
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();

	//if(retUploadListCnt>0)
	//{
%>
		<h4>
			Uploads
		</h4>
		<div class="row">
		  <div class="col-md-12 col-xs-12">
			<!-- general form elements -->
			<div class="box box-default">
				<div class="box-body table-responsive no-padding">
					<div class="box-body">
					       <table id="uploadTable" class="table  table-bordered dt-responsive nowrap" >
							<tr>
								<th>File Name</th>
								<th></th>
							</tr>
<%
		if(retUploadListCnt == 0)
		{
%>
			<tr id="noDataStatUpload">
				<td>No files attached</td>
			</tr>
<%
		}
		for(int r=0;r<retUploadListCnt;r++)
		{
%>
						<tr>
							<td align="left" width="95%"><input type="hidden" name="fileItem" value="<%=retUploadList.getFieldValueString(r,"EUF_CLIENT_FILE_NAME")%>"><a href="javascript:downloadFile('<%=retUploadList.getFieldValueString(r,"EUF_UPLOAD_NO")%>','<%=retUploadList.getFieldValueString(r,"EUF_CLIENT_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUF_CLIENT_FILE_NAME")%></a></td>
							<td width="5%"><span onclick="javascript:deleteFile(this,'<%=retUploadList.getFieldValueString(r,"EUF_UPLOAD_NO")%>','<%=retUploadList.getFieldValueString(r,"EUF_CLIENT_FILE_NAME")%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td>
						</tr>
<%
		}
%>
						</table>
	
			</div>
		      </div>
		     </div>
		    <!-- Your Page Content Here -->
		  </div>
		</div><!--row-->
<%
				//}
	
%>
	
	<div class="row no-print">
		<div class="col-xs-12">
			<button type="button" class="btn btn-primary pull-right" onclick="goBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Go Back</button>
			<button type="button" class="btn btn-primary pull-right" onclick="SubmitQuote()" id="review1" style="margin-right: 5px;"><i class="fa fa-check"></i> Submit Quote</button>
			<button type="button" class="btn btn-primary pull-right" title='Submit Questions' id="review2"  onclick="javascript:SubmitQuote()"  style="margin-right: 5px;display:none"><i class="fa fa-check"></i> Submit Questions</button>
			<!--<button type="button" id="btnRaiseQuery" class="btn btn-primary pull-right" ><i class="fa fa-pencil"></i> Query</button>-->
			<button type="button" id="uploadDialogBtn" class="btn btn-primary pull-right" ><i class="fa fa-upload"></i>&nbsp; Upload Attachments</button>
		</div>
	</div>

<input type="hidden" name="allconditions" value="">


</form>
 	 
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
 <div id="queryModal" class="modal fade" tabindex="-1" role="dialog">
   	<div class="modal-dialog">
   		
   			<div class="modal-content">
   				<div class="modal-header" style="background-color: #3c8dbc;">
   					<button type="button" class="close" data-dismiss="modal"
   						aria-label="Close">
   						<span aria-hidden="true">X</span>
   					</button>
   					<h4 class="modal-title">Raise Query</h4>
   				</div>
   				
   				<div class="modal-body">
   					<fieldset>
   						<div class="row">
   						<div class="col-xs-12" align="center">
   						<input type="hidden" name="queryext1" id="queryext1" value=""/>
   						<input type="hidden" name="queryLine" id="queryLine" value=""/>
   						<textarea style="width: 100%;" rows="4" name="query" id="query"></textarea>
   						</div>
   						</div>
   					</fieldset>
   
   				</div>
   				<div class="modal-footer">
   					<button type="submit" onclick="funSubmitQuery()" class="btn btn-primary" >Submit Query</button>
   					
   				</div>
   			</div>
   		
   	</div>
   </div>
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" >
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="580" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal1" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content" style="width: 140%;">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>	      


<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">New message</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form>
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">Recipient:</label>
            <input type="text" class="form-control" id="recipient-name">
          </div>
          <div class="form-group">
            <label for="message-text" class="col-form-label">Message:</label>
            <textarea class="form-control" id="message-text"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Send message</button>
      </div>
    </div>
  </div>
</div>

<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data"> 
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="">
			<input type="hidden" id="upDocId" name="upDocId" value="">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<input type="file" id="file" name="file"/>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form> 
   </div>  
</div> 	 
<%@ include file="../Misc/ezFooter.jsp"%>
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>

	<script>
	$('#queryModal').on('hidden.bs.modal', function () {
	   //location.reload();
	})
	$( function() {
	
	$(".sidebar-toggle").trigger("click");
	});
	function saveConditions(rfqNo,lineNO,itemPos)
	{
		var itemQty = eval("document.myForm.rfqItemQty"+itemPos).value;
		var itemPrice = eval("document.myForm.itemPrice"+itemPos).value; 
		var vendCat = "<%=gv_VendCat%>"; 
		//alert("vendCat>>"+vendCat);
		
		var url="ezSaveConditions.jsp?rfqNo="+rfqNo+"&lineNO="+lineNO+"&itemPos="+itemPos+"&itemQty="+itemQty+"&itemPrice="+itemPrice+"&vendCat="+vendCat; 
		
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
	
	}	
	function valUploadForm()
	{
	 	var upItemNo = $('#upItemNo').val();
	 	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
	 	var isValid = true;
	 	if(fileName == "")
		{
			alert("Please upload file");
			isValid = false;
			return false;
		}
	 	$('input[name="fileItem'+upItemNo+'"]').each(function(){
		  if($(this).val() == fileName)
		  {
		  	alert("File already uploaded");
		  	isValid = false;
			return false;
		  }	  
		});
		if(isValid)
		{
			$('#uploadbutton').hide(); 	
	       		$('#loadingInd').show();
		}
		return isValid;
 	}
	function funLineValid()
	{
		var rfqItemObj  = document.myForm.rfqItem;
		var len = rfqItemObj.length;
		
		//len=document.myForm.itemPrice.length;
		if(isNaN(len))
		{
			rfqItemNo = document.myForm.rfqItem.value;
			
			if(("document.myForm.itemPrice"+rfqItemNo).value=="0")
			{
				alert("Please Enter Price of the Material");
				return false;
			}
			else
				return true;
		}
		else
		{
			var bool="false"
			for(var i=0;i<len;i++)
			{
				rfqItemNo = document.myForm.rfqItem[i].value;
				if(("document.myForm.itemPrice"+rfqItemNo).value!="")
				{
					var bool="true"
					return true;
				}
			}
			if(bool=="false")
			{
				alert("Please Enter the price for atleast one material");
				return false;
			}
		}
	}
	function downloadFile(upItemNo,fileName)
  	{
		var upDocId 	= upItemNo;
		var upDocType 	= "RFQ";
		window.open("../Inbox/ezFileDownloadPost.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	}
	function downloadFilePreView(upItemNo,fileName)
  	{
		var upDocId 	= upItemNo;
		var upDocType 	= "RFQ";
		window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upplant+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	}	
	function funOpen()
	{
		values=document.myForm.allconditions.value;
		dialogvalue=window.showModalDialog("../Rfq/ezAllConditions.jsp",values,"center=yes;dialogHeight=30;dialogWidth=25;help=no;titlebar=no;status=no;resizable=no")
		if ((dialogvalue=='Canceld~~')||(dialogvalue==null)){
		}
		else{
			document.myForm.allconditions.value=dialogvalue; 
		}
	}
	function SubmitQuote(){
	
		var rfqCloseDate =document.myForm.qtnEndDate.value;
		var b=rfqCloseDate.split("/");
		var tempDt = b[1]+"/"+b[0]+"/"+b[2];
		var tempDt1 = new Date(tempDt)
		//alert("tempDtnew>>>"+tempDt1)
		var toDate  = new Date();		
		//alert("toDate>>"+toDate);
		
		if(tempDt1<toDate)
		{
			alert("Quotation Date Expired.");
			return false;
		}
		var rfqItemObj  = document.myForm.rfqItem;
		var len = rfqItemObj.length;
		//alert("len>>>"+len);
		if(isNaN(len))
		{
			var rfqItemNo = document.myForm.rfqItem.value;
			var hsnCode   = eval("document.myForm.vendHSNGST"+rfqItemNo).value;
			
			if(eval("document.myForm.itemPrice"+rfqItemNo).value=="0" || eval("document.myForm.itemPrice"+rfqItemNo).value=="0.0" || eval("document.myForm.itemPrice"+rfqItemNo).value=="0.00")
			{
				alert("Please Enter Price of the Material for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.itemPrice"+rfqItemNo).focus();
				return false;
			}
			if(eval("document.myForm.itemPrice"+rfqItemNo).value<="0")
			{
				alert("Please Enter Positive Number at Price for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.itemPrice"+rfqItemNo).focus();
				return false;
			}
			
			/*if(hsnCode=="")
			{
				alert("Please Enter HSN for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.vendHSNGST"+rfqItemNo).focus();
				return false;
			}*/
			if(hsnCode!="")
			{
				if(hsnCode.length < 4)
				{
					alert("Please Enter Valid HSN for the line item:"+((rfqItemNo+1)*10));
					eval("document.myForm.vendHSNGST"+rfqItemNo).focus();
					return false;
				}
			}
			/*
			if(eval("document.myForm.vendGST"+rfqItemNo).value=="")
			{
				alert("Please Enter GST for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.vendGST"+rfqItemNo).focus();
				return false;
			}
			if(eval("document.myForm.vendGST"+rfqItemNo).value<="0")
			{
				alert("Please Enter Positive Number at GST for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.vendGST"+rfqItemNo).focus();
				return false;
			}			
			
			
			if(eval("document.myForm.leaddays"+rfqItemNo).value=="")
			{
				alert("Please Enter Lead Time for the line item:"+((rfqItemNo+1)*10));
				eval("document.myForm.leaddays"+rfqItemNo).focus();
				return false;
			}*/	
	
				
			
		}
		else
		{
			//alert("len>>>>"+len);
			for(var i=0;i<len;i++)
			{
				var rfqItemNo = document.myForm.rfqItem[i].value;
				//alert("rfqItemNo>>>"+rfqItemNo)
				var hsnCode   = eval("document.myForm.vendHSNGST"+rfqItemNo).value;
				
				if(eval("document.myForm.itemPrice"+rfqItemNo).value=="0" || eval("document.myForm.itemPrice"+rfqItemNo).value=="0.0" || eval("document.myForm.itemPrice"+rfqItemNo).value=="0.00")
				{
					alert("Please Enter Price of the Material for the line item:"+((i+1)*10));
					eval("document.myForm.itemPrice"+rfqItemNo).focus();
					return false;
				}
				
				if(eval("document.myForm.itemPrice"+rfqItemNo).value<="0")
				{
					alert("Please Enter Positive Number for the line item:"+((i+1)*10));
					eval("document.myForm.itemPrice"+rfqItemNo).focus();
					return false;
				}
				if(hsnCode=="")
				{
					alert("Please Enter HSN for the line item:"+((rfqItemNo+1)*10));
					eval("document.myForm.vendHSNGST"+rfqItemNo).focus();
					return false;
				}
				if(hsnCode.length < 4)
				{
					alert("Please Enter Valid HSN for the line item:"+((rfqItemNo+1)*10));
					eval("document.myForm.vendHSNGST"+rfqItemNo).focus();
					return false;
				}			
				if(eval("document.myForm.vendGST"+rfqItemNo).value=="")
				{
					alert("Please Enter GST for the line item:"+((rfqItemNo+1)*10));
					eval("document.myForm.vendGST"+rfqItemNo).focus();
					return false;
				}
				if(eval("document.myForm.vendGST"+rfqItemNo).value<="0")
				{
					alert("Please Enter Positive Number at GST for the line item:"+((rfqItemNo+1)*10));
					eval("document.myForm.vendGST"+rfqItemNo).focus();
					return false;
				}				
				/*
				if(eval("document.myForm.leaddays"+rfqItemNo).value=="")
				{
					alert("Please Enter Lead Time for the line item:"+((i+1)*10));
					eval("document.myForm.leaddays"+rfqItemNo).focus();
					return false;
				}*/				

			}	

		}
		
		//alert(document.myForm.PaymentTerms.value);
		if (document.myForm.PaymentTerms.value==""){
			alert("Please Select Payment terms from the List."); 
			document.myForm.PaymentTerms.focus();
			return false;
		}else if (document.myForm.IncoTerms.value==""){
			alert("Please Select Inco Terms from the List.");
			document.myForm.IncoTerms.focus();
			return false;
		}else if(document.myForm.Comments.value==""){
			alert("Please Enter Comments");
			document.myForm.Comments.focus();
			return false;			
		}
		else
		{
			if(confirm("Are you sure you want to Submit the Quote?"))
			{
				buttonhide();
				document.myForm.action="ezQuotationSave.jsp";   
				document.myForm.submit();
			}	
		}
	}
	function goBack(){
		document.myForm.action = "ezViewRFQDetails.jsp"
		document.myForm.submit();
	}
	function funReset(){
			document.myForm.reset();
			
	}
	function buttonhide()
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "none"
			buttonsMsgSpan.style.display	= "block"
		}
	}
	function funIncoDom(fieldObj)
	{
		
		var vendCat= "<%=gv_VendCat%>";
		//alert(vendCat);
		var fieldVal = fieldObj.value;	
		//alert(fieldVal);
		if(vendCat === "DOM")
		{		
		
			if(fieldVal =="DAP")
			{
			
				document.getElementById("itemPKFW").value = "0";
				document.getElementById("itemPKFWVal").value = "0";
				document.getElementById("itemFRT").value = "0";
				document.getElementById("itemFRTVal").value = "0";
				
				document.getElementById("valTypePKFW").disabled = true;
				document.getElementById("itemPKFW").disabled = true;
				document.getElementById("valTypeFRT").disabled = true;
				document.getElementById("itemFRT").disabled = true;
				//alert("TAX CAL");
				chkSel(fieldObj,0,"TAX")
			}
			else
			{
				document.getElementById("valTypePKFW").removeAttribute('disabled');
				document.getElementById("itemPKFW").removeAttribute('disabled');
				document.getElementById("valTypeFRT").removeAttribute('disabled');
				document.getElementById("itemFRT").removeAttribute('disabled');
			}
		}		
		
	}
	function chkSel(fieldObj,itemPos,type)
	{
	
		var fieldVal = fieldObj.value;	
		//alert(fieldVal);
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");

		
		if(eval("document.myForm.itemPrice"+itemPos).value<="0")
		{
			var selObj = eval("document.myForm.valTypeDISC"+itemPos);			
			selObj.value="";
			alert("Please Enter Price of the Material for the line item:"+((parseInt(itemPos)+1)*10));
			return false;
		}		
		
		if(fieldVal=="")
		{
			if(type=="DISC")
			{
				alert("Please select the Discount Type");
				var itemDISCObj = eval("document.myForm.itemDISC");
				var itemDISCValObj = eval("document.myForm.itemDISCVal");
				itemDISCObj.value="0";
				itemDISCValObj.value="0";
				itemDISCObj.focus();			
				funCal(itemDISCObj,'DISC');
			}
			if(type=="PKFW")
			{
				//alert("Please select the Pkg & Fwd Type");
				//fieldObj.focus();
				itemPKFWValObj.value='0';
				var itemPKFWObj = eval("document.myForm.itemPKFW");
				itemPKFWObj.value='0';
				funCal(itemPKFWObj,'PKFW');
			}
			if(type=="FRT")
			{
				alert("Please select the Freight Type");
				//fieldObj.focus();
				itemFRTValObj.value='0';
				var itemFRTObj = eval("document.myForm.itemFRT");
				itemFRTObj.value='0';
				funCal(itemFRTObj,'FRT');
			}
			if(type=="TAX")
			{
				alert("Please select the Tax");
				//fieldObj.focus();
				itemTAXValObj.value='0';
				var itemTAXObj = eval("document.myForm.itemTAX");
				itemTAXObj.value='0';
				funCal(itemTAXObj,'TAX');
			}
		}
		
		if(type=="DISC")
		{
			var Count='<%=Count%>';
			for(var k=0;k<Count;k++)
			{
			var itemDISCObj = eval("document.myForm.itemDISC"+k);
			checkNum(itemDISCObj,k);
			
			}
			funCal(itemDISCObj,'DISC');
					
		}
		if(type=="PKFW")
		{
			var itemPKFWObj = eval("document.myForm.itemPKFW");
			
			funCal(itemPKFWObj,'PKFW');
			
		}
		
		
		if(type=="FRT")
		{
			var itemFRTObj = eval("document.myForm.itemFRT");
			
			funCal(itemFRTObj,'FRT');
			
		}
		if(type=="TAX")
		{
			var itemTAXObj = eval("document.myForm.itemTAX");

			funCal(itemTAXObj,'TAX');
					
		}
	}
	function funAddGST(fieldObj,itemPos)
	{
		
		var fieldVal = fieldObj.value;	
		var Count='<%=Count%>';
		var totalGSTVal=0;
		for(var c=0;c<Count;c++)
		{
			var lineItemGSTObjAdd = eval("document.myForm.vendGST"+c);
			totalGSTVal=parseFloat(lineItemGSTObjAdd.value)+parseFloat(totalGSTVal);
			
		}
		document.myForm.itemTAX.value=totalGSTVal;
		checkNum(fieldObj,itemPos);
		
	}
	function funCheckDis(fieldObj,itemPos)
	{
		var fieldVal = fieldObj.value;	
		var valTypeDISCObj = eval("document.myForm.valTypeDISC"+itemPos);
		var itemDISCObj = eval("document.myForm.itemDISC"+itemPos);
		var itemPriceObj = eval("document.myForm.itemPrice"+itemPos);
		
		if(valTypeDISCObj.value=="")
		{
			alert("Please select the Discount Type");
			itemDISCObj.value='';
			return;
			
		}
		else
		{
			
			if(itemPriceObj.value=='')
			{
				alert("Please provide Price");
				return true;
				
			}
			else
				checkNum(fieldObj,itemPos);
		}
		  
	}
	function checkNum(fieldObj,itemPos)
	{
		
		var fieldVal = fieldObj.value;
		//var itemFRTValObj = eval("document.myForm.itemFRTVal");
		//var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");
		var Count='<%=Count%>';
		//alert("Count>>>"+Count);
		
		var vendCat= "<%=gv_VendCat%>";
		
		var totalVal=0;
		var LinePKFWVal=0;
		var totalPKFWVal=0;
		var LineFRTVal=0;
		var totalFRTVal=0;
		var totalGSTVal=0;
		
		for(var line=0;line<Count;line++)
		{	
			//alert("In loop>>>"+line);
			var itemQtyObj   = eval("document.myForm.rfqItemQty"+line);
			//alert("itemQtyObj in CheckNum>>>>"+itemQtyObj.value);
			var itemPriceObj = eval("document.myForm.itemPrice"+line);
			
			//alert("itemPriceObj>>>"+itemPriceObj.value);
			var itemValObj   = eval("document.myForm.itemValue"+line);
			itemValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 

			var itemTotalValObj = eval("document.myForm.itemTotalVal");

			//DISCOUNT
			var itemDISCObj    = eval("document.myForm.itemDISC"+line);
			var valTypeDISCObj = eval("document.myForm.valTypeDISC"+line);
			var itemDISCValObj = eval("document.myForm.itemDISCVal"+line);
			
			//PKFW
			var itemPKFWObj    = eval("document.myForm.itemPKFW");
			var valTypePKFWObj = eval("document.myForm.valTypePKFW");
			var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
			
			//FRT
			var itemFRTObj    = eval("document.myForm.itemFRT");
			var valTypeFRTObj = eval("document.myForm.valTypeFRT");
			var itemFRTValObj = eval("document.myForm.itemFRTVal");
			
			if(itemPriceObj.value!='')
			{			

				if(itemDISCObj.value!='')
				{
					if(valTypeDISCObj.value == "P")
						itemDISCValObj.value = ((itemValObj.value * itemDISCObj.value)/100).toFixed(2);
					else if(valTypeDISCObj.value=="V")
						itemDISCValObj.value = itemDISCObj.value;
					else if(valTypeDISCObj.value=="Q")	
						itemDISCValObj.value = ((itemQtyObj.value * itemDISCObj.value)/100).toFixed(2);
						//itemDISCValObj.value = (itemDISCObj.value)/100) * parseFloat(itemQtyObj.value);
					//alert("itemDISCValObj in CheckNUm>>>"+itemDISCValObj.value);
					itemValObj.value=(parseFloat(itemValObj.value) - parseFloat(itemDISCValObj.value)).toFixed(2);
					//alert("itemValObj in CheckNUm>>>"+itemValObj.value);
				}
				totalVal=(parseFloat(itemValObj.value)+parseFloat(totalVal)).toFixed(2); 
				itemTotalValObj.value=totalVal;
				//alert("totalVal>>>"+totalVal);
				
				if(valTypePKFWObj.value!='')
				{
					//alert("itemValObj in PKFW>>>"+itemValObj.value);
					if(valTypePKFWObj.value == "P")
						itemPKFWValObj.value = (((itemValObj.value) * itemPKFWObj.value)/100).toFixed(2);
					else if(valTypePKFWObj.value=="V")
						itemPKFWValObj.value = (itemPKFWObj.value).toFixed(2);
					else if(valTypePKFWObj.value=="Q")	
						itemPKFWValObj.value =  ((parseFloat(totalQtyVal)* itemPKFWObj.value)/100).toFixed(2);;
						
				}
				LinePKFWVal= parseFloat(itemPKFWValObj.value);
				totalPKFWVal=parseFloat(itemPKFWValObj.value)+parseFloat(totalPKFWVal); 
				itemPKFWValObj.value=totalPKFWVal.toFixed(2);
				
				
				if(valTypeFRTObj.value!='')
				{				
				
					if(valTypeFRTObj.value == "P")
						itemFRTValObj.value = (((itemValObj.value) * itemFRTObj.value)/100).toFixed(2);
					else if(valTypeFRTObj.value=="V")
						itemFRTValObj.value = (itemFRTObj.value).toFixed(2);
					else if(valTypeFRTObj.value=="Q")	
						itemFRTValObj.value = (itemFRTObj.value * parseFloat(totalQtyVal)).toFixed(2);
				}	
				LineFRTVal= parseFloat(itemFRTValObj.value);
				totalFRTVal=parseFloat(itemFRTValObj.value)+parseFloat(totalFRTVal); 
				itemFRTValObj.value=totalFRTVal.toFixed(2);	
				
				var itemSupplyPrice = parseFloat(itemValObj.value)+ parseFloat(LinePKFWVal) + parseFloat(LineFRTVal);
				itemSupplyPrice= parseFloat(itemSupplyPrice).toFixed(2);
				//alert("itemSupplyPrice>>>"+"line"+line+itemSupplyPrice);
				
				var vendGSTObj =eval("document.myForm.vendGST"+line);
				totalGSTVal=((itemSupplyPrice * vendGSTObj.value)/100)+parseFloat(totalGSTVal); 
				//alert("totalGSTVal>>>"+"line"+line+totalGSTVal);
				itemTAXValObj.value = totalGSTVal.toFixed(2);				
			}
			if(vendCat === "DOM")
			{
				document.myForm.itemGrossVal.value = (parseFloat(itemTotalValObj.value)+ parseFloat(totalPKFWVal)+parseFloat(totalFRTVal)+parseFloat(totalGSTVal)).toFixed(2); 	
			}
			else if(vendCat === "IMP")
			{

				document.myForm.itemGrossVal.value = (parseFloat(itemTotalValObj.value)+ parseFloat(totalPKFWVal)+parseFloat(totalFRTVal)).toFixed(2); 	
			}
			
	
		}	
	}
	function checkNumBkp(fieldObj,itemPos)
	{
		//alert("fieldObj"+fieldObj);
		var fieldVal = fieldObj.value;
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");
		var Count='<%=Count%>';
		
		if(isNaN(fieldVal) || fieldVal=='')
		{
			/*alert("Please enter valid numeric value");
			fieldObj.value="0";
			fieldObj.focus();
			return;*/

		}
		else 
		{
			var itemQtyObj = eval("document.myForm.rfqItemQty"+itemPos);
			var itemPriceObj = eval("document.myForm.itemPrice"+itemPos);
			var itemDISCObj = eval("document.myForm.itemDISC"+itemPos);
			var itemValObj = eval("document.myForm.itemValue"+itemPos);
			var itemDISCValObj = eval("document.myForm.itemDISCVal"+itemPos);
			var valTypeDISCObj = eval("document.myForm.valTypeDISC");
			var itemTotalValObj = eval("document.myForm.itemTotalVal");
			//alert(itemQtyObj.value+itemPriceObj.value);
			itemValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 
			//alert("itemval"+itemValObj.value);
			if(itemDISCObj.value!='')
			{
				if(valTypeDISCObj.value == "P")
					itemDISCValObj.value = ((itemValObj.value * itemDISCObj.value)/100).toFixed(2);
				else if(valTypeDISCObj.value=="V")
					itemDISCValObj.value = itemDISCObj.value;
				else if(valTypeDISCObj.value=="Q")	
					itemDISCValObj.value = itemDISCObj.value * parseFloat(itemQtyObj.value);
				
				
				itemValObj.value=parseFloat(itemValObj.value) - parseFloat(itemDISCValObj.value);
			}
			//alert("ChkDiscVAlQty"+itemDISCValObj.value);
			
			var totalVal=0;
			var totBasePrice=0;
			for(var c=0;c<Count;c++)
			{
				var itemValObjAdd = eval("document.myForm.itemValue"+c);
				totalVal=parseFloat(itemValObjAdd.value)+parseFloat(totalVal);
				var itemPriceObj = eval("document.myForm.itemPrice"+c);
				var totBasePriceVal= (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 	
				totBasePrice=parseFloat(totBasePrice)+parseFloat(totBasePriceVal);
			}
			itemTotalValObj.value=totalVal;
			var itemPKFWObj = eval("document.myForm.itemPKFW");
			var valTypePKFWObj = eval("document.myForm.valTypePKFW");


			if(valTypePKFWObj.value == "P")
				itemPKFWValObj.value = (((itemTotalValObj.value) * itemPKFWObj.value)/100).toFixed(2);
			else if(valTypePKFWObj.value=="V")
				itemPKFWValObj.value = itemPKFWObj.value;
			else if(valTypePKFWObj.value=="Q")	
			itemPKFWValObj.value = itemPKFWObj.value * parseFloat(totalQtyVal) ;
			var itemFRTObj = eval("document.myForm.itemFRT");
			var valTypeFRTObj = eval("document.myForm.valTypeFRT");

			//itemFRTValObj.value = ((totBasePrice * itemFRTObj.value)/100).toFixed(2);
			if(valTypeFRTObj.value == "P")
				itemFRTValObj.value = (((itemTotalValObj.value) * itemFRTObj.value)/100).toFixed(2);
			else if(valTypeFRTObj.value=="V")
				itemFRTValObj.value = itemFRTObj.value;
			else if(valTypeFRTObj.value=="Q")	
				itemFRTValObj.value = itemFRTObj.value * parseFloat(totalQtyVal);			

			var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
			itemSupplyPrice= parseFloat(itemSupplyPrice).toFixed(2);	

			var itemTAXObj=eval("document.myForm.itemTAX");
			itemTAXValObj.value = ((itemSupplyPrice * itemTAXObj.value)/100).toFixed(2);
			
			//TAX VALUE
			var totalTaxVal=0;
			for(var c=0;c<Count;c++)
			{
				var itemValObjAdd = eval("document.myForm.itemTAX"+c);
				totalVal=parseFloat(itemValObjAdd.value)+parseFloat(totalVal);
				var itemPriceObj = eval("document.myForm.itemPrice"+c);
				var totBasePriceVal= (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 	
				totalTaxVal=parseFloat(totBasePrice)+parseFloat(totBasePriceVal);
			}
			
			
			//alert("valTypeDISCObj>>"+valTypeDISCObj.value)
			
			document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value);	
	
		}	
	}	
	function funCal(fieldObj,type)
	{
		//alert(type+"typestart");
		var fieldVal = fieldObj.value;	
		var totalQtyVal=0;
		var totBasePrice=0;
		var Count='<%=Count%>';
		var vendCat= "<%=gv_VendCat%>";
		var itemFRTValObj = eval("document.myForm.itemFRTVal");
		var itemPKFWValObj = eval("document.myForm.itemPKFWVal");
		var itemTAXValObj = eval("document.myForm.itemTAXVal");
		var itemTotalValObj = eval("document.myForm.itemTotalVal");
		for(var c=0;c<Count;c++)
		{
			var itemQtyObj = eval("document.myForm.rfqItemQty"+c);
			var itemPriceObj = eval("document.myForm.itemPrice"+c);
			var totBasePriceVal= (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 	
			totalQtyVal=parseFloat(itemQtyObj.value)+parseFloat(totalQtyVal);
			totBasePrice=parseFloat(totBasePrice)+parseFloat(totBasePriceVal);
		}
		if(type=="PKFW")
		{
			if(document.myForm.valTypePKFW.value=="")
			{
				alert("Please select the Pkg & Fwd");
				document.myForm.itemPKFW.value='0';
				
						
			}
			else
			{
				
				var itemPKFWObj = eval("document.myForm.itemPKFW");
				var valTypePKFWObj = eval("document.myForm.valTypePKFW");
				
				if(valTypePKFWObj.value == "P")
				{
					if(vendCat === "DOM")
					{
						//if(itemPKFWObj.value >4) 
							//itemPKFWObj.value="4";
						if(itemPKFWObj.value < 0)
							itemPKFWObj.value="0";
					}		
					itemPKFWValObj.value = (((itemTotalValObj.value) * itemPKFWObj.value)/100).toFixed(2);
				}	
				else if(valTypePKFWObj.value=="V")
					itemPKFWValObj.value = itemPKFWObj.value;
				else if(valTypePKFWObj.value=="Q")	
				itemPKFWValObj.value = itemPKFWObj.value * parseFloat(totalQtyVal) ;
			
			
			
			}
		//document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value);	
		}
		//alert(itemTotalValObj.value+"::"+itemPKFWValObj.value);
		if(type=="FRT")
		{
		//alert("type"+type+"totBasePrice"+totBasePrice);
			if(document.myForm.valTypeFRT.value=="")
			{
				alert("Please select the Freight");
				document.myForm.itemFRT.value='';
				

			}
			else
			{
				var itemFRTObj = eval("document.myForm.itemFRT");
				var valTypeFRTObj = eval("document.myForm.valTypeFRT");
				if(valTypeFRTObj.value == "P")
				{
					if(vendCat === "DOM")
					{
						//if(itemFRTObj.value >4) 
							//itemFRTObj.value="4";
						if(itemFRTObj.value < 0)
							itemFRTObj.value="0";				
					}			
					itemFRTValObj.value = (((itemTotalValObj.value) * itemFRTObj.value)/100).toFixed(2);
					//itemFRTValObj.value = ((totBasePrice * itemFRTObj.value)/100).toFixed(2);
				}	
				else if(valTypeFRTObj.value=="V")
					itemFRTValObj.value = itemFRTObj.value;
				else if(valTypeFRTObj.value=="Q")	
					itemFRTValObj.value = itemFRTObj.value * parseFloat(totalQtyVal);	

			}
		
		}
		if(type=="TAX")
		{
			if(document.myForm.valTypeTAX.value=="")
			{
				alert("Please select the Tax");
				document.myForm.itemTAX.value='';
				

			}
			else
			{	
				
				var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
				itemSupplyPrice = parseFloat(itemSupplyPrice).toFixed(2);

				var itemTAXObj=eval("document.myForm.itemTAX");
				itemTAXValObj.value = ((itemSupplyPrice * itemTAXObj.value)/100).toFixed(2);
			}
		
		}
		var itemPKFWObj = eval("document.myForm.itemPKFW");
		var valTypePKFWObj = eval("document.myForm.valTypePKFW");


		if(valTypePKFWObj.value == "P")
			itemPKFWValObj.value = (((itemTotalValObj.value) * itemPKFWObj.value)/100).toFixed(2);
		else if(valTypePKFWObj.value=="V")
			itemPKFWValObj.value = itemPKFWObj.value;
		else if(valTypePKFWObj.value=="Q")	
		itemPKFWValObj.value = itemPKFWObj.value * parseFloat(totalQtyVal) ;
		var itemFRTObj = eval("document.myForm.itemFRT");
		var valTypeFRTObj = eval("document.myForm.valTypeFRT");


		if(valTypeFRTObj.value == "P")
			//itemFRTValObj.value = ((totBasePrice * itemFRTObj.value)/100).toFixed(2);
			itemFRTValObj.value = (((itemTotalValObj.value) * itemFRTObj.value)/100).toFixed(2);
		else if(valTypeFRTObj.value=="V")
			itemFRTValObj.value = itemFRTObj.value;
		else if(valTypeFRTObj.value=="Q")	
			itemFRTValObj.value = itemFRTObj.value * parseFloat(totalQtyVal);			

		var itemSupplyPrice = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value);
		itemSupplyPrice= parseFloat(itemSupplyPrice).toFixed(2);	

		var itemTAXObj=eval("document.myForm.itemTAX");
		itemTAXValObj.value = ((itemSupplyPrice * itemTAXObj.value)/100).toFixed(2);
					

		//alert(itemTotalValObj.value+"::"+itemPKFWValObj.value);
		//document.myForm.itemGrossVal.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value);	
		
			if(vendCat === "DOM")
			{
				document.myForm.itemGrossVal.value = (parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)+parseFloat(itemTAXValObj.value)).toFixed(2);	
			}
			else if(vendCat === "IMP")
			{

				document.myForm.itemGrossVal.value = (parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value)+parseFloat(itemFRTValObj.value)).toFixed(2);	
			}		
		
	}
	$( function() {
	     $( "#uploadDialogBtn" ).button().on( "click", function() {
	        $("#upItemNo").val($(this).val());
	        $("#file").val("");
	       $('#uploadMod').modal('show');
	       	return false;
	     });
	     $('#uploadForm').ajaxForm({
	     	  beforeSubmit: valUploadForm,	
		  success: function(msg) {
		      $('#uploadbutton').show(); 	
	       	      $('#loadingInd').hide();
		      msg=$.trim(msg);
		      //alert(msg);
		      if(msg.split("##")[0] === 'true')
		      {
		    	  $('#noDataStatUpload').hide();
		      	  var upItemNo = $('#upItemNo').val();
		      	  var fileNameTemp = msg.split("##")[1];
		      	   $('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFilePreView(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
		      }
		      //alert("File has been uploaded successfully");
		      $('#uploadMod').modal('hide');
		  },
		  error: function(msg) {
		     $('#uploadbutton').show(); 	
	       	     $('#loadingInd').hide();	
		     alert("Couldn't upload file");
		  }
	     });
	
  	 } );
	function funSetItemLead(lead)
	{
		var Count='<%=Count%>';

		for(var c=0;c<Count;c++)
		{
			var leadObj = eval("document.myForm.leaddays"+c);
			leadObj.value=lead.value;
			
		}


	}
	function funSetItemDisc(disc)
	{
		var Count='<%=Count%>';
		if(document.myForm.valTypeDISC.value=="")
		{
			alert("Please select the Discount Type");
			itemDISCObj.value='';
			disc.value=0;
			return;
			
		}
		for(var c=0;c<Count;c++)
		{
			var discObj = eval("document.myForm.itemDISC"+c);
			discObj.value=disc.value;
			var x=funCheckDis(discObj,c)
			//alert("x"+x);
			if(x===true)break; 

		}
	}
	function funSetItemDisc1(disc)
	{
		
		var Count='<%=Count%>';
		//alert("Count>>"+Count);
		if(document.myForm.valTypeDISC.value=="")
		{
			alert("Please select the Discount Type");
			itemDISCObj.value='';
			disc.value=0;
			return;
			
		}
		for(var c=0;c<Count;c++)
		{
			var itemPriceObj = eval("document.myForm.itemPrice"+c);
			var discObj = eval("document.myForm.itemDISC"+c);
			//alert("itemPriceObj>>>"+itemPriceObj.value);
			
			if(itemPriceObj.value=='')
			{
				alert("Please provide Price at line Item:"+((parseInt(c)+1)*10));
				return true;
				
			}
			else if(itemPriceObj.value>0)
			{
				discObj.value=disc.value;
				checkNum(discObj,c);
			}			
			
			
			//var discObj = eval("document.myForm.itemDISC"+c);
			//discObj.value=disc.value;
			//var x=funCheckDis(discObj,c)
			//alert("x"+x);
			//if(x===true)break; 

		}
	}	
	
	 function openItemDet(req,item,mat,text,type)
	      { 
	      	//alert("text"+text);
	      	var url="ezItemTextPopup.jsp?req="+req+"&item="+item+"&mat="+mat+"&text="+encodeURI(text)+"&type="+type;     
	      	/*$.fancybox.open({
	      		href : url, 
	      		type : 'iframe',
	      		
	      		width:'60%',
	      		height:'38%',
	      		autoSize : false,
	      		closeBtn : false,
	      		keys : {
	      		    close  : true,
	      		},			
	      		helpers     : {  
	      			overlay : {closeClick: false}
	      			}
	      		});*/
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
  		});   			      		
	      
      }
      function funGetGST(item,prevHSN,prevGST)
      {
      	
	var hsnCode 	= $('#vendHSNGST'+item).val();
	var size = hsnCode.length;
	if(size != 10)
	{
		
		alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
		$('#vendHSNGST'+item).val(prevHSN);
		$('#vendGST'+item).val(prevGST);
		return false;
	}
	else
	{
		var hsnArr= hsnCode.split(".");
		if(hsnArr[0].length != 4)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
			$('#vendGST'+item).val("0");
			return false;
		}	
		if(hsnArr[1].length != 2)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));
			$('#vendGST'+item).val("0");
			return false;
		}	
		if(hsnArr[2].length != 2)
		{
			alert("Enter Valid HSN at line item:"+((parseInt(item)+1)*10));						
			$('#vendGST'+item).val("0");
			return false;
		}	
		
	}
      	
      $.ajax({
		    url: '../RFQ/ezGetGST.jsp', 
		    data: { hsn : hsnCode},
		    dataType: "json",
		    type: 'POST',
		    success: function(result) {
		      result=$.trim(result);
		      $('#vendGST'+item).val(result);	  
		    }
		});
	}
	function raiseQuery(lineItem)
	{
		$("#query").val("");
		$("#queryLine").val(lineItem);
		$('#queryModal').modal('show');
	}	
  	function funSubmitQuery() 
  	{
		var query = $('#query').val();
		//alert("query"+query);
		var docID='<%=poNum%>';
		//alert("docID"+docID);		
		var queryLine = $('#queryLine').val();
		//alert("queryLine"+queryLine);
		var createdBY='<%=rfqVendor%>';	
		//alert("createdBY"+createdBY);
		var ext1 = $('#queryext1').val();
		//alert("ext1>>>"+ext1);
		
		if(query=="")
		{
			alert("Please enter the Query");  
			return;

		}
		document.getElementById("review1").style.display="none"; 
		//document.getElementById("review2").style.display="";	 	
		$.ajax({
			url : 'ezSaveRFQQuery.jsp',
			data : {
				query : query,
				docID : docID,
				queryLine : queryLine,
				createdBY :createdBY
			},
			dataType : "json",
			type : 'POST',
			success : function(result) {
				result = $.trim(result);
				if (result === 'true') {
					$('#queryModal').modal('hide');
				}
			     }
			});
 	}
	function openService(prNo,prItem,rfqNo,rfqItem,itemPos)
	{ 
		var url="ezGetServices.jsp?prNo="+prNo+"&prItem="+prItem+"&rfqNo="+rfqNo+"&rfqItem="+rfqItem+"&itemPos="+itemPos;      
		$('iframe').attr("src",url);
		$('#woModal1').modal({show:true});
		$('.modal-dialog').draggable({
			   handle: ".modal-body"
		});   		
	}  	

	</script>
	<script type="text/javascript"> 
        function preventBack() { 
            window.history.forward();  
        } 
          
        setTimeout("preventBack()", 0); 
          
        window.onunload = function () { null }; 
    </script> 	
