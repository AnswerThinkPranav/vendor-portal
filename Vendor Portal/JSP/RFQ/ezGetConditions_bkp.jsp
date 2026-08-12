 <%@ include file="../../Library/Globals/errorPagePath.jsp"%>
 <%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
 <%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
 <%@ page import ="java.io.*" %>
 <%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
 <%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
 <%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%
	String fields []= {"item","CONDITION","VALUE","CURRENCY","UOM"};
	ReturnObjFromRetrieve retTab = new ReturnObjFromRetrieve(fields);
	String rfqNO=request.getParameter("rfqNo");
	String item=request.getParameter("item");
	rfqNO="0000000000"+rfqNO;
	rfqNO=rfqNO.substring(rfqNO.length()-10,rfqNO.length());
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
	
	int retCount=0;
	
	//out.println(rfqNO+"  "+item);	
     	JCO.Client client1=null;
	JCO.Function function = null;
	JCO.Function function1 = null;
	JCO.Table ret=null;
	try
	{
		client1 = EzSAPHandler.getSAPConnection("245~999");
		function = EzSAPHandler.getFunction("Z_EZ_RFQ_COND_GET","245~999");
		JCO.ParameterList sapRFQ = function.getImportParameterList();
		JCO.ParameterList lineRFQ = function.getImportParameterList();
		
		
		sapRFQ.setValue(rfqNO,"I_EBELN");
		sapRFQ.setValue(item,"I_EBELP");
		//out.println("function>>>"+function);
		client1.execute(function);
		//out.println("client1>>>"+client1);
	
	}
	catch(Exception e)
	{
		out.println("Exception"+e);
		ezc.ezcommon.EzLog4j.log("Exception ====> "+e,"D");
	}
	try
	{

		ret = function.getTableParameterList().getTable("T_KONV");
		
		retCount = ret.getNumRows();
		//out.println("count="+retCount);
		
		if(retCount>0)
		{
			do
			{
				retTab.setFieldValue("item",ret.getValue("KPOSN"));
				retTab.setFieldValue("CONDITION",ret.getValue("KSCHL"));
				retTab.setFieldValue("VALUE",ret.getValue("KBETR"));
				retTab.setFieldValue("CURRENCY",ret.getValue("WAERS"));
				retTab.setFieldValue("UOM",ret.getValue("KMEIN"));
				retTab.addRow();

			}	
			while(ret.nextRow());
		}
		
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception occured while getting data from RETURN table====>"+e,"D");
		}

		finally
		{
			if (client1!=null)
			{
				JCO.releaseClient(client1);
				client1 = null;
				function=null;

			}
		}
		//out.println("retTabretTabretTabretTab>>>"+retTab.toEzcString());
	String display_header = "Condition Types";		
		
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<title>Create RFQ -- Powered By EzCommerce India</title>
<html>
<head>


<%
if(retTab!=null && retCount>0)
{%>

	<Div id="bottompart" style="position:absolute; top=15%;left:3%;height:10;width:100%;visibility:visible;" align="center">
	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
	<tr align="center" valign="middle">
		<th width="15%">Item</th>
		<th width="20%">Condition Type</th>
		<th width="33%">Description</th>
		<th width="10%">Price</th>
		<th width="12%">Currency</th>
		<th width="10%">UOM</th>
		
		
		
		</tr>
	</table>
 	</div>
 	
<DIV  style="overflow:auto;position:absolute;width:100%;top=20%;height:100%;left:3%">
<TABLE  width="94%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 > 	
 	
 	<%for (int i = 0; i < retCount; i++ )
 	{
 	
 	%>
 	
 	
 	<tr>
 		<td width="15%" ><%=retTab.getFieldValueString(i,"item")%>&nbsp;</Td>
 		<td width="20%" ><%=retTab.getFieldValueString(i,"CONDITION")%>&nbsp;</Td>
 		<td width="33%" ><%=ht.get(retTab.getFieldValueString(i,"CONDITION"))%>&nbsp;</Td>
 		<td width="10%" ><%=retTab.getFieldValueString(i,"VALUE")%>&nbsp;</Td>
 		<td width="12%" ><%=retTab.getFieldValueString(i,"CURRENCY")%>&nbsp;</Td>
 		<td width="10%" ><%=retTab.getFieldValueString(i,"UOM")%>&nbsp;</Td>
 	</tr>
 	<%}%>
</table> 	
</div>
<div align=center id="ButtonDiv" style="position:absolute;top:89%;width:100%;left:3%">
		 
<%
}
else
{
%>
<Div id='inputDiv' style='position:relative;align:center;top:20%;width:100%;'>
	<Table width="45%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'#F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" class=welcomecell>
				<Tr>
					<Td align="center">
					<font size="2px"><b>No conditions exist.</b></font>
					</Td>
				</Tr>
			</Table>
		</Td>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
</Div>	

<%
}
%>
<center>
<div id="ButtonDiv"  style="position:relative;top:0%;width:100%;visibility:visible;">

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Ok");
	buttonMethod.add("window.close()");
	
	
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>

</div>
</center>

</form>
</body>
</html>		
		
		