<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

String materialArray[] 		= request.getParameterValues("material");
String materialDescArray[] 	= request.getParameterValues("materialDesc");
String uomArray[] 		= request.getParameterValues("uom");
String quantityArray[] 		= request.getParameterValues("quantity");
String serPriceArray[] 		= request.getParameterValues("Price");
String itemCondArray[] 		= request.getParameterValues("itemCond");
Hashtable ht=new Hashtable();
	
	ht.put("A001","Rebate");
	ht.put("A002","Material Rebate");
	ht.put("A003","Hierarchy Rebate");
	ht.put("A004","Hierarchy rebate/mat");
	ht.put("AK01","Customer Rebate");
	ht.put("AMO1","Internal Amort. %");
	ht.put("AMO2","Internal Amort./Qty");
	ht.put("AMRP","abatement on MRP");
	ht.put("CU00","Gross price cust.sim");
	ht.put("CUAC","Antidumping cus.qty");
	ht.put("CUAD","Anti-dumping cust %");
	ht.put("CUAE","Antidumping cust.wt");
	ht.put("CUAS","Customs exemption %");
	ht.put("CUDC","3rd country cust qty");
	ht.put("CUDE","3rd country weight");
	ht.put("CUDL","3rd country cust %");
	ht.put("CUFR","Freight qty customs");
	ht.put("CUIN","Insurance customs");
	ht.put("CUP1","Preference qty cust");
	ht.put("CUP2","Preference wt cust");
	ht.put("CUPC","Cust phys creat. qty");
	ht.put("CUPE","Cust. pharm. prd %");
	ht.put("CUPF","Cust. ph. prod. wgt");
	ht.put("CUPZ","Cust. preference %");
	ht.put("CURB","Absolute disc. cust");
	ht.put("CUZ1","Customs max. quant");
	ht.put("CUZ2","Customs max. wgt");
	ht.put("CUZC","Customs alloc. qty");
	ht.put("CUZE","Customs alloc. wgt");
	ht.put("CUZK","Customs alloc. &");
	ht.put("CUZP","Customs max. %");
	ht.put("EDI1","Confirmed Price");
	ht.put("EDI2","Value variance");
	ht.put("FRA1","Freight (domestic) %");
	ht.put("FRA2","Freight %");
	ht.put("FRB1","Freight (domest)-val");
	ht.put("FRB2","Freight (Value)");
	ht.put("FRC1","Freight (domest)-qty");
	ht.put("FRC2","Freight/Quantity");
	ht.put("GAU1","Orignl Price of Gold");
	ht.put("GAU2","Actual Price of Gold");
	ht.put("GBAS","GTM Exptd Base Value");
	ht.put("GC01","GTM Net Val. Picking");
	ht.put("GD01","GTM Disc/Surch MM(%)");
	ht.put("GD02","GTM Disc/Surch MM(W)");
	ht.put("GD03","GTM Disc/Surch MM(M)");
	ht.put("GE01","GTM AC Mat/Cre MM(%)");
	ht.put("GE02","GTM AC GL/Cre MM (%)");
	ht.put("GE03","GTM AC Mat/Cred (M)");
	ht.put("GE04","GTM AC HB/Cred (M)");
	ht.put("GE05","GTM AC Mat/Cred Fix");
	ht.put("GE06","GTM AC HB/Cred Fix");
	ht.put("GE07","GTM AC Debi/HB MM(%)");
	ht.put("GMPP","GTM Purchase Price");
	ht.put("GRWR","Statistical Value");
	ht.put("GWLB","Stat. Val. LB-Comp");
	ht.put("GXX1","GTM Ensured Value");
	ht.put("HB00","Header Surch.(Value)");
	ht.put("HB01","Header Disc.(Value)");
	ht.put("J1CV","Sec ECESS on CVD");
	ht.put("JADC","Addit  Customs Duty%");
	ht.put("JASS","Assessable Value");
	ht.put("JCDB","IN Basic customs");
	ht.put("JCDS","IN Special customs");
	ht.put("JCV1","IN CVD");
	ht.put("JECV","Edu cess on CVD");
	ht.put("JEDB","Edu cess on Basic Cu");
	ht.put("JEDC","Edu cess on CVD+eces");
	ht.put("JEXC","IN Manual Excise");
	ht.put("JEXS","Taxes on the PO");
	ht.put("JOCM","IN Octroi");
	ht.put("K000","Contrct HeaderDisc %");
	ht.put("KAD0","Mat. Costs  (VKHM)");
	ht.put("KAD1","Handling Costs(VKHM)");
	ht.put("KR00","Header Disc.(Value)");
	ht.put("LH01","Delivery Hierarchy");
	ht.put("LH02","Deliv.Hier/Materia");
	ht.put("LP00","Pallet Discount");
	ht.put("LP01","Incomp.Pallet Surch");
	ht.put("LP02","Mixed Pallet Disc");
	ht.put("LP03","Mixed Pallet Surch");
	ht.put("MAR1","Neutral % Accruals");
	ht.put("MM00","Minimum Qty (Amount)");
	ht.put("MM01","Minimum Quantity (%)");
	ht.put("MP01","Market Price");
	ht.put("MVK0","Sales Price inc. Tax");
	ht.put("MVK1","Sales Price excl.Tax");
	ht.put("MVK2","Sales Price excl.Tax");
	ht.put("MWAS","Output tax manually ");
	ht.put("MWST","Input tax");
	ht.put("MWVR","Input Tax Manually");
	ht.put("MWVS","Input tax manually");
	ht.put("NA00","% dsc on  excise dut");
	ht.put("NAVM","Non-Deductible Tax");
	ht.put("NAVS","Non-Deductible Tax");
	ht.put("NB00","abs. disc  on exc");
	ht.put("NC00","qty disc on excise");
	ht.put("NETP","Net Price Picking");
	ht.put("NTRG","Net Value Payer Doc.");
	ht.put("P000","Gross Price");
	ht.put("P001","Gross Price");
	ht.put("P100","Trans.Pr.Supply.Plnt");
	ht.put("P101","Val.Price Supply.Pln");
	ht.put("PA00","Promotion Price");
	ht.put("PA01","Promo Price 2");
	ht.put("PB00","Gross Price");
	ht.put("PBXX","Gross Price");
	ht.put("PNN0","Purch. Net/Net");
	ht.put("POAC","Accessable value");
	ht.put("POFC","price in Foreign cur");
	ht.put("POLC","price in Local curre");
	ht.put("QB00","Gross Price");
	ht.put("QBXX","Gross Price");
	ht.put("R000","Discount % on Gross");
	ht.put("R001","Discount/Quantity");
	ht.put("R002","Absolute discount");
	ht.put("R003","Discount % on Net");
	ht.put("RA00","Discount % on Net");
	ht.put("RA01","Discount % on Gross");
	ht.put("RA02","Promo Discount % 1");
	ht.put("RA03","Promo Discount % 2");
	ht.put("RA04","Promo. Disc. Deduct");
	ht.put("RA05","Promo. Disc. Deduct");
	ht.put("RB00","Absolute discount");
	ht.put("RC00","Discount/Quantity");
	ht.put("REST","Account Discount %");
	ht.put("RL00","Factoring Discount");
	ht.put("RL01","Vendor Discount %");
	ht.put("RL02","Pick.Agency Bus.Cust");
	ht.put("RL03","Pick.Agency Bus.Vend");
	ht.put("RUB1","Neutr.Accruals(Val.)");
	ht.put("RUC1","Neutral Accruals/Qty");
	ht.put("RUE1","Neutral % Accruals");
	ht.put("S000","Calculated Revenues");
	ht.put("SBCB","Basis");
	ht.put("SEXD","State Excise Duty  %");
	ht.put("SKTO","Cash Discount");
	ht.put("TRIG","Event Trigger");
	ht.put("VA00","Variants/Quantity");
	ht.put("VA01","Variants %");
	ht.put("VKP0","Sales Price inc. Tax");
	ht.put("VKP1","Sales Price excl.Tax");
	ht.put("VS00","Tax trigger");
	ht.put("VS01","Agency Tax");
	ht.put("VS15","Factoring Disc. Tax ");
	ht.put("VSRG","Tax Amount Payer");
	ht.put("WCTQ","WCT - Quotation");
	ht.put("WOTB","OTB Procurement");
	ht.put("XADC","Other Charges/qty");
	ht.put("YADC","Other Custom Charges");
	ht.put("YB00","Gross Price");
	ht.put("YBXX","Gross Price");
	ht.put("YECS","ECS %");
	ht.put("YEXD","Excise Duty %");
	ht.put("YEXQ","Excise Duty -Per uni");
	ht.put("YP00","Gross Price");
	ht.put("YPXX","Gross Price");
	ht.put("ZA00","Surcharge % on Net");
	ht.put("ZA01","Surcharge % on Gross");
	ht.put("ZAC1","Other Custom Charges");
	ht.put("ZAD0","Addit Customs Dut y-");
	ht.put("ZADC","Addit  Customs Duty%");
	ht.put("ZASV","Assessable Value");
	ht.put("ZB00","Surcharge (Value)");
	ht.put("ZC00","Surcharge/Quantity");
	ht.put("ZCAS","cash discount");
	ht.put("ZCDB","IN Basic customs");
	ht.put("ZCST","CST -  Quotation");
	ht.put("ZCV0","IN CVD -");
	ht.put("ZCV1","IN CVD");
	ht.put("ZEC0","Edu cess on CVD -");
	ht.put("ZEC1","SEdu cess on CVD - ");
	ht.put("ZEC2","E cess on CVD+eces -");
	ht.put("ZECD","Ecesson Excisefor FG");
	ht.put("ZECV","Edu cess on CVD");
	ht.put("ZEDB","Edu cess on Basic Cu");
	ht.put("ZEDC","Edu cess on CVD+eces");
	ht.put("ZEN1","Entry Tax %");
	ht.put("ZENT","Entry Tax ");
	ht.put("ZEX1","Excise for information");
	ht.put("ZEXC","Inventorising ED");
	ht.put("ZEXD","Excise duty for FG");
	ht.put("ZEXP","Extra Charges - Val");
	ht.put("ZG01","Markup Deliv. Plant");
	ht.put("ZHC1","Handling Charges(val");
	ht.put("ZIN1","Insurance %");
	ht.put("ZIN2","Insurance /Qty");
	ht.put("ZMRP","MRP Price");
	ht.put("ZNC0","Qty disc after tax");
	ht.put("ZNC1","Qty disc on base+ED");
	ht.put("ZOA1","Customs %");
	ht.put("ZOB1","Customs (Value)");
	ht.put("ZOC1","Customs/Quantity");
	ht.put("ZP00","Gross Price");
	ht.put("ZP10","Handling chgs in% ex");
	ht.put("ZP11","Handlg chgs inval ex");
	ht.put("ZP12","Handlg chgs inqty ex");
	ht.put("ZP20","Overseas freight %");
	ht.put("ZP21","Overseas freight val");
	ht.put("ZP22","Overseas freight qty");
	ht.put("ZP23","Overfrt Diff vendor%");
	ht.put("ZP24","Over frt val diff ve");
	ht.put("ZP25","Over frt qty diff ve");
	ht.put("ZP30","Overseas Insurance %");
	ht.put("ZP31","Overseas Insuran val");
	ht.put("ZP32","Insurance -CIF sta% ");
	ht.put("ZP35","Landing Due - %");
	ht.put("ZP50","Cust.Clg. charges-%");
	ht.put("ZP51","Cust.Clg.charges -va");
	ht.put("ZP60","CHA Charges - %");
	ht.put("ZP61","CHA Charges -value");
	ht.put("ZP70","CHA service tax - %");
	ht.put("ZPA1","Packing and forw %");
	ht.put("ZPB1","Packing and forw-val");
	ht.put("ZPB2","GrossPriceFreeSample");
	ht.put("ZPBX","GrossPriceFreeSample");
	ht.put("ZPC1","Packing and forw/qty");
	ht.put("ZPRU","Gross Price");
	ht.put("ZPXX","Gross Price");
	ht.put("ZRA1","Freight %");
	ht.put("ZRB1","Freight (Value)");
	ht.put("ZRC1","Freight/Quantity");
	ht.put("ZRU1","Customs duty %");
	ht.put("ZRU2","Customs fees");
	ht.put("ZRU3","Customs WH charges");
	ht.put("ZRU4","CustClearenceCharges");
	ht.put("ZRU5","LocalTranspCharges");
	ht.put("ZRU6","Additional Expenses");
	ht.put("ZRU7","VAT Russia");
	ht.put("ZRU8","VAT Rep Office");
	ht.put("ZSOP","InterCoSls Ord price");
	ht.put("ZSRT","SerTAX - Quotation");
	ht.put("ZTO2","TOT%  DO NOT USE");
	ht.put("ZTOT","TOT/Qty DO NOT USE");
	ht.put("ZTPR","InteCo Xfer price %");
	ht.put("ZUAC","Antidumping cus.qty");
	ht.put("ZVAT","VAT - Quotation");
	ht.put("ZZ01","Discount % on GrosT");
	ht.put("JMOP","IN: BED setoff %");	
	ht.put("JEC1","A/P ECESS Setoff");	
	ht.put("JSEP","IN:A/P SECess setoff");

%>

<html>
<head>
<Script>
	var tabHeadWidth=90
	var tabHeight="35%"
</Script>
<script>
function funOk()
{
	var flag = confirm("Are sure of submitting quotation?");
	
	if(flag)
	{
		opener.window.funSubmitFromPopUp();
		window.close();
	}else
		window.close();
}

</script>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body topmargin=0 rightmargin=0 leftmargin=0  scroll=no >
<form name="myForm" method="post">
<form name="myForm" method="post">
<%
	String display_header = "Quote Details";
	
	
	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));
%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

<%
if(materialArray.length>0)	
{
%>
<br>
	<Div id="theads" >
	<Table id="tabHead" width="90%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
		<th align="center" width="15%">Material</th>
		<th align="center" width="25%">Mat. Desc</th>
		<th align="center" width="10%">UOM</th>
		<th align="center" width="15%">Qty</th>
		<th align="center" width="15%">Price</th>
		<th align="center" width="30%">Basic Value</th>

		</tr>
	</Table>
	</Div>

	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:80%;left:5%">
	<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<%
	for(int i=0;i<materialArray.length;i++)
	{
		
		String material 	= ""; 		
		String materialDesc 	= materialDescArray[i] ;	
		String uom 		= uomArray[i] ;		
		String quantity 	= quantityArray[i] ;		
		String price 		= serPriceArray[i] ;
		
		try
		{
			material = Long.parseLong(materialArray[i])+"";
		}catch(Exception e){material = materialArray[i];}
		
%>
		<tr>
<%
			java.math.BigDecimal itemQty=new java.math.BigDecimal(quantity);
			java.math.BigDecimal itemPrice=new java.math.BigDecimal(price);
			itemPrice=itemPrice.multiply(itemQty).setScale(2, java.math.BigDecimal.ROUND_DOWN);
			
%>
			<td align="left" width="15%" style="background-color:pink"><b><%=material%>&nbsp;</b></td>
			<td align="left" width="25%" style="background-color:pink"><b><%=materialDesc%>&nbsp;</b></td>
			<td align="center" width="10%" style="background-color:pink"><b><%=uom%>&nbsp;</b></td>
        		<td align="right" width="15%" style="background-color:pink"><b><%=quantity%>&nbsp;</b></td>
        		<td align="right" width="15%" style="background-color:pink"><b><%=price%>&nbsp;</b></td>
        		<td align="right" width="30%" style="background-color:pink"><b><%=myFormat.getCurrencyString(itemPrice.toString())%>&nbsp;</b></td>
		</tr>
		
<%

	if(itemCondArray[i]!=null && !"null".equals(itemCondArray[i].trim()) && !"".equals(itemCondArray[i].trim()))	
	{
%>	
		<tr>
		<td colspan=10>
		<table align=right width="95%" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
		<tr>
			<th  width = "20%">Cond.Type</th>
			<th  width = "20%">Cond.Desc.</th>
			<th  width = "20%">Value</th>
			<th  width = "20%">Currency</th>
			<th  width = "10%">Per</th>
			<th  width = "10%">UOM</th>
		</tr>
<%		
		java.util.StringTokenizer itemCondToken = new java.util.StringTokenizer(itemCondArray[i],"^^");
		
		while(itemCondToken.hasMoreElements())
		{
			String itemCondTokenStr = itemCondToken.nextToken();
			java.util.StringTokenizer itemCondToken1 = new java.util.StringTokenizer(itemCondTokenStr,"$$"); 
			
			String condType 	= itemCondToken1.nextToken();
			String value	 	= itemCondToken1.nextToken();
			String Currency 	= itemCondToken1.nextToken();
			String per	 	= itemCondToken1.nextToken();
			String condUOM	 	= itemCondToken1.nextToken();
			
			if(condType==null || "null".equals(condType))condType="";
			if(value==null 	  || "null".equals(value))value="";
			if(Currency==null || "null".equals(Currency))Currency="";
			if(per==null      || "null".equals(per))per="";
			if(uom==null      || "null".equals(uom))uom="";
			
%>
			<tr>
				<td  width = "20%" align="center"><%=condType%>&nbsp;</td>
				<td  width = "20%" align="center"><%=ht.get(condType)%>&nbsp;</td>
				<td  width = "20%" align="center"><%=value%>&nbsp;</td>
				<td  width = "20%" align="center"><%=Currency%>&nbsp;</td>
				<td  width = "10%" align="center"><%=per%>&nbsp;</td>
				<td  width = "10%" align="center"><%=condUOM%>&nbsp;</td>

			</tr>

<%
		}
%>				

		</table>
<%
		if(i<materialArray.length-1)
		{
%>
		<tr><td colspan=5></td></tr> 
<%
		}

	}
	}
%>	
	</table>
	</div>
	<div id="buttons" style="position:absolute;top:90%;width:100%;visibility:visible" align="center">
<%		
		
   		buttonName = new java.util.ArrayList();
    		buttonMethod = new java.util.ArrayList();
    		
    		buttonName.add("Ok");
    		buttonMethod.add("funOk()");

		out.println(getButtonStr(buttonName,buttonMethod));	

    
%> 		
	</div>
<%		
} 

else
{
%>	
	<br><br><br><br><br>
	<Table width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th>No Vendors exist</th>
		</Tr>
	</Table>
	<div id="buttons" style="position:absolute;top:90%;width:100%;visibility:visible" align="center">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
    
%>
	</div>	
		
<%
}
%>