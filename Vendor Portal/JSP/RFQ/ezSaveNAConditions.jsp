<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import="ezc.ezutil.*"%>
<%@ include file="../Misc/ezNACompCodeMap.jsp"%>
<%//@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iLang_Labels.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>     
 

<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
	public java.util.Hashtable<String,String> getPricingConditions(ezc.session.EzSession Session,String pricProc)
	{
		java.util.Hashtable<String,String> htPricCond = new java.util.Hashtable<String,String>();
		try
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager(); 
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve condRet = null; 
			miscTableRow.setQuery("SELECT * FROM EZC_PRICING_PROCEDURE WHERE  EPP_PROCEDURE='"+pricProc+"' and EPP_EXT1='DOM' and EPP_EXT2='A'");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			condRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			int condRetCnt = 0;
			if(condRet != null)
			{
				condRetCnt = condRet.getRowCount(); 
			}
			for(int i=0;i<condRetCnt;i++)
			{
				htPricCond.put(condRet.getFieldValueString(i,"EPP_SEQ"),condRet.getFieldValueString(i,"EPP_COND"));
			}
		}
		catch(Exception e)
		{
		}
		return htPricCond;
	}
	public java.util.Hashtable<String,String> getCondDesc(ezc.session.EzSession Session)
	{
		java.util.Hashtable<String,String> htCondDesc = new java.util.Hashtable<String,String>();
		try
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			ezc.ezparam.ReturnObjFromRetrieve condDescRet = null; 
			miscTableRow.setQuery("SELECT EPCD_COND,EPCD_DESC FROM EZC_PRICING_COND_DESC");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			condDescRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			int condDescRetCnt = 0;
			if(condDescRet != null)
			{
				condDescRetCnt = condDescRet.getRowCount();
			}
			for(int i=0;i<condDescRetCnt;i++)
			{
				htCondDesc.put(condDescRet.getFieldValueString(i,"EPCD_COND"),condDescRet.getFieldValueString(i,"EPCD_DESC"));
			}
		}
		catch(Exception e)
		{
		}
		return htCondDesc;
	}			
%>
<%
	//String item_Cond_L="",Qty_L="",Cn_Type_L="";
	//String name_L="",value_L="",curr_L="",Amount_L="",price_L="",disc_L="",Pkg_Fwd_L="",freight_L="",GST_L="",save_L="",close_L="";
	String compCode = request.getParameter("compCode");
	java.util.Hashtable hashDisc = new java.util.Hashtable();
	hashDisc.put("P","Discount % on Basic");
	hashDisc.put("Q","Discount/Qty");
	hashDisc.put("V","Discount(Value)");
	hashDisc.put("","N/A");
	
	java.util.Hashtable hashPKFW = new java.util.Hashtable();
	hashPKFW.put("P","Pkg&Fwd chrgs(%)");
	hashPKFW.put("Q","Pkg&Fwd/Qty");
	hashPKFW.put("V","Pkg&Fwd chrg-value");
	hashPKFW.put("","N/A");
	
	java.util.Hashtable hashFRT = new java.util.Hashtable();
	hashFRT.put("P","Freight(%)");
	hashFRT.put("Q","Freight/Qty");
	hashFRT.put("V","Freight(Value)");
	hashFRT.put("","N/A");
%>

<%
	String rfqNo=request.getParameter("rfqNo");
	String lineNO=request.getParameter("lineNO");
	String itemPos=request.getParameter("itemPos");
	String itemQty=request.getParameter("itemQty");
	String itemPrice=request.getParameter("itemPrice");
	String vendCat=request.getParameter("vendCat");
	String currency=request.getParameter("currency");
	String editFlag=request.getParameter("editFlag");
	String compCode2 = request.getParameter("compCode");
	String pricProc=request.getParameter("pricProc");
	//out.println("itemPrice>>>>>"+itemPrice);
	ezc.ezcommon.EzLog4j.log(":::::compCode::::compCode:::"+compCode2,"I");

	
	
	java.util.Hashtable<String,String> condHT = getPricingConditions(Session,pricProc); 	
	//out.print("condHT>>>"+condHT);
	
	java.util.Hashtable<String,String> condDescHT = getCondDesc(Session); 	
	//out.print("condDescHT>>>"+condDescHT);	
	//out.print("condDescHTDesc>>>"+condDescHT.get("PBXX"));	
	
	String readonly="readonly";
	
	double totVal = 0.0;
	String totValStr="0";
	

	try
	{
		totVal= (Double.parseDouble(itemQty) * Double.parseDouble(itemPrice));
		totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
	}
	catch(Exception e)
	{
		totVal = 00.0;
	}	
%>
<html>
  <head>
	<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
  </head>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
	<h1>
		<%=item_Cond_L%>  <%=rfqNo%>(<%=lineNO%>)
	</h1>
	<!--<div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table id="ezRCItemTab" class="table table-bordered">
		<tr>
			<th><%=Qty_L%></th>
			<td><%=itemQty%><td>
		</tr>	
	</table>
	</div>
	</div>-->
</section>
<!-- Main content -->  
<section class="invoice">
<body onLoad="fillValues()">
<form name="myForm1"  method="post">
	<div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table id="ezRCItemTab" class="table table-bordered">
		
		<tr>
			<th><%=Cn_Type_L%></th>
			<th><%=name_L%></th>
			<th><%=value_L%></th>
			<th><%=curr_L%></th>
			<th><%=Amount_L%></th>
		</tr>	
		<tr>
			<th><%=price_L%></th>
			<td style="background-color:#d5dcef" align="center">
				<select name="price<%=itemPos%>" class="form-control input-sm select2"  style="width:175px !important" >
<%
			 if("DOM".equals(vendCat))
			{
%>				
				<option value="PBXX">Gross Price</option>	
<%
			}
			else
			{
%>			
				<option value="PB00">Gross Price</option>
<%				
			}
	
%>
				</select>
			</td>	
			<input type=hidden name="rfqItemQty<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemQty%>'  readonly></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPrice<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value='<%=itemPrice%>' onBlur="checkNum(this,'<%=itemPos%>','NA')" ></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemVal<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>
		
		<tr>
			<th><%=disc_L%></th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeDISC<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','DISC')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P##RA00">RA00-->Discount % on Net</option>
					<option value="P##RA01">RA01-->Discount % on Gross</option>
					<option value="V##RB00">RB00-->Absolute discount/SKTO</option>
					<option value="Q##RC00">RC00-->Discount/Quantity</option>
					
<%	
				}
				//else if("IMP".equals(vendCat))
				//{
%>
					<!--<option value="SKTO">Cash Discount</option>-->
					
					
<%
				//}
%>				
				
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemDISC<%=itemPos%>"  style="width:125px;"  size=9 min="0" class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','DISC')" ></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td style="background-color:#d5dcef" align="right" nowrap>
					<input  type="hidden" name="itemDISCCode<%=itemPos%>"  value="DISC"> 
					<input type=number name="itemDISCVal<%=itemPos%>"  style="width:120px;" size=9  class="form-control" value="0.00" readonly>
			</td>			
		</tr>
		<tr>
			<th><%=Pkg_Fwd_L%></th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypePKFW<%=itemPos%>" class="form-control input-sm select2" onChange="chkSel(this,'<%=itemPos%>','PKFW')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">P&F% on Net</option>
					<!--<option value="V">P&F Value</option>-->
					<option value="Q">P&F QTY</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">P&F% on Net</option>
					<!--<option value="V">P&F Value</option>-->
					<option value="Q">P&F QTY</option>					
<%
				}
%>				
				</select>
     			</td> 		
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW<%=itemPos%>" style="width:125px;"   size=9 min="0"  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','PKFW')" ></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
     			<td style="background-color:#d5dcef" align="right" nowrap>
     				
				<input  type="hidden" name="itemPKFWCode<%=itemPos%>"  value="PKFW"> 
     				<input type=number name="itemPKFWVal<%=itemPos%>" style="width:120px;"  size=9  class="form-control" value="0.00" readonly>
     			</td>
		</tr>
		<tr>
			<th><%=freight_L%></th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeFRT<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','FRT')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P##FRA1">FRA1-->Freight %</option>
					<option value="V##FRB1">FRB1-->Freight Value</option>
					<option value="Q##FRC1">FRC1-->Freight/QTY</option>
					<option value="V##Z001">Z001-->Material Master Price</option>
					<option value="V##Z002">Z002-->Expediting Cost-Val</option>
					<option value="V##Z003">Z003-->Art Work Charges Val</option>
					<option value="V##Z005">Z005-->Shipping & Handling</option>
					<option value="V##Z006">Z006-->Typeset Proof-Prep</option>
					<option value="V##Z008">Z008-->Die , Mold & Tooling</option>
					<option value="V##Z009">Z009-->Service Charges</option>
					<option value="V##Z010">Z010-->Hazardous Mat Free</option>
					<option value="V##Z011">Z011-->Minimum Charges</option>
					<option value="V##Z012">Z012-->Misc Charges</option>
					<option value="V##Z029">Z029-->HS- Custom Charges</option>
					<option value="V##ZFRD">ZFRD-->Freight (Value)</option>
					<option value="Q##ZFRG">ZFRG-->Freight/Quantity</option>
<%							
				}			
							
%>				
					
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemFRT<%=itemPos%>"  style="width:125px;"  size=9  min="0" class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','FRT')"></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>     			
     			<td style="background-color:#d5dcef"align="right" nowrap>
				
				<input  type="hidden" name="itemFRTCode<%=itemPos%>"  value="FRT">      		
     				<input type=number name="itemFRTVal<%=itemPos%>" style="width:120px;"  size=9  class="form-control" value="0.00" readonly>
     			</td>
		</tr>
<%
		if("DOM".equals(vendCat))
		{
%>			
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b><%=net_Value_L%></b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td align="center" nowrap><input type=number name="itemTotalVal<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value="<%=totVal%>" readonly></td>
		</tr>
<%	
		}
%>
		<!--<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b><%=gross_Value_L%></b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td align="right" nowrap><input type=number name="itemGrossVal<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>-->		
		

	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	 
	<div class="row no-print">
	<div class="col-xs-12">
		<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;"><%=save_L%></button>
		<!--<button type="button" class="btn btn-primary pull-right" onclick="funClose()" style="margin-right: 5px;"><%=close_L%></button>-->
	</div>
	</div>

 
</form>
</section>

<!-- /.content -->
</div><!-- /.content-wrapper --> 





<Script src="../../Library/JavaScript/ezTrim.js"></Script>
 <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
<script>
$(function() {
$('#nav')
    .stop()
    .animate({'marginRight':'-100px'},1000, function() { $(this).addClass('closed'); });

  function toggleDivs() {
    var $inner = $("#nav");
    var $img = $(".nav-btn img", $inner);

    if ($inner.hasClass('closed')) {
      $inner.animate({ right: "100px" }); 
      $img.attr('alt', 'close');
    } else {
      $inner.animate({ right: 0 });
      $img.attr('alt', 'open');
    }

    $inner.toggleClass('closed');
  }
$(".nav-btn").bind("click", function(){
    toggleDivs();
});

});
	function fillValues()
	{
		
		var itemPos=<%=itemPos%>;
		var vendCat= "<%=vendCat%>";
		//alert("vendCat>>"+vendCat);
		
		//alert("itemVal>>>"+itemVal)
		var itemQty = eval("parent.document.myForm.itemQty"+itemPos).value;
		//alert("itemQty>>>"+itemQty)
		var itemPrice = eval("parent.document.myForm.itemPrice"+itemPos).value;
		//alert("itemPrice>>>"+itemPrice)		
		var itemVal = (parseFloat(itemQty)*parseFloat(itemPrice)).toFixed(2)
		
		
		eval("document.myForm1.itemVal"+itemPos).value=itemVal;		
		
		//DISCOUNT
		//alert("valTypeDISC>>>>>"+valTypeDISC.value);
		var itemDISCCode = eval("parent.document.myForm.itemDISCCode"+itemPos).value;
		var itemDISC = eval("parent.document.myForm.itemDISC"+itemPos).value;
		var valTypeDISC = eval("parent.document.myForm.valTypeDISC"+itemPos).value;
		var itemDISCVal = eval("parent.document.myForm.itemDISCVal"+itemPos).value;
		
		
		eval("document.myForm1.itemDISCCode"+itemPos).value=itemDISCCode;
		eval("document.myForm1.itemDISC"+itemPos).value=itemDISC;
		eval("document.myForm1.valTypeDISC"+itemPos).value=valTypeDISC;
		eval("document.myForm1.itemDISCVal"+itemPos).value=itemDISCVal;	
		//alert("alert1");
		
		//PKFW
		
		var itemPKFWCode = eval("parent.document.myForm.itemPKFWCode"+itemPos).value;
		var itemPKFW = eval("parent.document.myForm.itemPKFW"+itemPos).value;
		var valTypePKFW = eval("parent.document.myForm.valTypePKFW"+itemPos).value;
		var itemPKFWVal = eval("parent.document.myForm.itemPKFWVal"+itemPos).value;
		//alert("alert2");
		
		
		eval("document.myForm1.itemPKFWCode"+itemPos).value=itemPKFWCode;
		eval("document.myForm1.itemPKFW"+itemPos).value=itemPKFW;
		eval("document.myForm1.valTypePKFW"+itemPos).value=valTypePKFW;
		eval("document.myForm1.itemPKFWVal"+itemPos).value=itemPKFWVal;
		//alert("alert3");
		
		
		//FRT
		var itemFRTCode = eval("parent.document.myForm.itemFRTCode"+itemPos).value;
		var itemFRT = eval("parent.document.myForm.itemFRT"+itemPos).value;
		var valTypeFRT = eval("parent.document.myForm.valTypeFRT"+itemPos).value;
		var itemFRTVal = eval("parent.document.myForm.itemFRTVal"+itemPos).value;
		
		eval("document.myForm1.itemFRTCode"+itemPos).value=itemFRTCode;
		eval("document.myForm1.itemFRT"+itemPos).value=itemFRT;
		eval("document.myForm1.valTypeFRT"+itemPos).value=valTypeFRT;
		eval("document.myForm1.itemFRTVal"+itemPos).value=itemFRTVal;	
		
		//NET VALUE
		if(vendCat === "DOM")
		{
				/*alert("itemVal>>>"+itemVal);
				alert("itemDISCVal>>>"+itemDISCVal);
				alert("itemPKFWVal>>>"+itemPKFWVal);
				alert("itemTotalVal>>>"+itemTotalVal.value);*/
			var itemTotalVal = parseFloat(itemVal)-parseFloat(itemDISCVal)+parseFloat(itemPKFWVal)+parseFloat(itemFRTVal);
				//alert("itemTotalVal>>>>>"+itemTotalVal);
				//eval("document.myForm1.itemTotalVal"+itemPos).value=itemTotalVal.toFixed(2);
			
			
		}	
		
		
		//GROSS VALUE
		
		if(vendCat === "DOM")
		{
			//alert("INTO IF");
			var itemGrossVal = (parseFloat(itemTotalVal)).toFixed(2);
			//alert("itemGrossVal>>>"+itemGrossVal);
			
		}
		else
		{
			//alert("ELSE IF");
			var itemGrossVal = (parseFloat(itemVal)-parseFloat(itemDISCVal)+parseFloat(itemPKFWVal)+parseFloat(itemFRTVal)).toFixed(2);
		}
		eval("document.myForm1.itemTotalVal"+itemPos).value=itemGrossVal;	
		//alert("alert8");
		
		
	}
	function funClose()
	{
		window.parent.$('#woModal').modal('hide');
	}
	function funOk()
	{
		//alert("INTO FUNOK");
		var itemPos=<%=itemPos%>;
		//alert("itemPos>>>"+itemPos);
		//alert("itemPrice>>>"+itemPrice);
		var vendCat= "<%=vendCat%>";
		
		var itemPriceObj = eval("document.myForm1.itemPrice"+itemPos).value;
		eval("parent.document.myForm.itemPrice"+itemPos).value=itemPriceObj;
		
		
		var itemValObj = eval("document.myForm1.itemVal"+itemPos).value;
		eval("parent.document.myForm.itemVal"+itemPos).value=itemValObj;		
		
		if(vendCat === "DOM")
		{
			var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos).value;
			eval("parent.document.myForm.itemTotalVal"+itemPos).value=itemTotalValObj;
		}
		//DISCOUNT
		//alert("DISCOUNT");
		var itemDISCCode = eval("document.myForm1.itemDISCCode"+itemPos).value;
		var itemDISC = eval("document.myForm1.itemDISC"+itemPos).value;
		var valTypeDISC = eval("document.myForm1.valTypeDISC"+itemPos).value;
		var itemDISCVal = eval("document.myForm1.itemDISCVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemDISCCode"+itemPos).value=itemDISCCode;
		eval("parent.document.myForm.itemDISC"+itemPos).value=itemDISC;
		eval("parent.document.myForm.valTypeDISC"+itemPos).value=valTypeDISC;
		eval("parent.document.myForm.itemDISCVal"+itemPos).value=itemDISCVal;
		
		//PKFW
		//alert("PKFW");
		var itemPKFWCode = eval("document.myForm1.itemPKFWCode"+itemPos).value;
		var itemPKFW = eval("document.myForm1.itemPKFW"+itemPos).value;
		var valTypePKFW = eval("document.myForm1.valTypePKFW"+itemPos).value;
		var itemPKFWVal = eval("document.myForm1.itemPKFWVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemPKFWCode"+itemPos).value=itemPKFWCode;
		eval("parent.document.myForm.itemPKFW"+itemPos).value=itemPKFW;
		eval("parent.document.myForm.valTypePKFW"+itemPos).value=valTypePKFW;
		eval("parent.document.myForm.itemPKFWVal"+itemPos).value=itemPKFWVal;	
		
		//FRT
		var itemFRTCode = eval("document.myForm1.itemFRTCode"+itemPos).value;
		var itemFRT = eval("document.myForm1.itemFRT"+itemPos).value;
		var valTypeFRT = eval("document.myForm1.valTypeFRT"+itemPos).value;
		//alert("valTypeFRT>>>>"+valTypeFRT);
		var itemFRTVal = eval("document.myForm1.itemFRTVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemFRTCode"+itemPos).value=itemFRTCode;
		eval("parent.document.myForm.itemFRT"+itemPos).value=itemFRT;
		eval("parent.document.myForm.valTypeFRT"+itemPos).value=valTypeFRT;
		eval("parent.document.myForm.itemFRTVal"+itemPos).value=itemFRTVal;
		
			
		//NET VALUE
			//alert("NET VALUE0");
		var itemGrossValObj = eval("document.myForm1.itemTotalVal"+itemPos).value;
			//alert("NET VALUE1");
		eval("parent.document.myForm.itemValue"+itemPos).value=itemGrossValObj;	
			//alert("NET VALUE2");
		
		/*
		if(valTypeTAX =="")
		{
			alert("Please Select Tax");
			return;
		}
		else
		{
			if(itemTAXVal == "0.00")
			{
				if(confirm("Please confirm to proceed GST with 0%"))
				{
					window.parent.$('#woModal2').modal('hide');
				}
				else
				{
					return false;
				}
			}			
		}*/
		window.parent.$('#woModal2').modal('hide');
		
			
	}
	function chkSel(fieldObj,itemPos,type)
	{
	
		var fieldVal = fieldObj.value;	
		//alert(fieldVal);

		/*if(eval("document.myForm1.itemPrice"+itemPos).value<="0")
		{
			var selObj = eval("document.myForm1.valTypeDISC"+itemPos);			
			selObj.value="";
			alert("Please Enter Price of the Material for the line item:"+((parseInt(itemPos)+1)*10));
			return false;
		}*/		
		
		if(fieldVal=="")
		{
			if(type=="DISC")
			{
				//alert("Please select the Discount Type");
				var itemDISCObj = eval("document.myForm1.itemDISC"+itemPos);
				var itemDISCValObj = eval("document.myForm1.itemDISCVal"+itemPos);
				itemDISCObj.value="0";
				itemDISCValObj.value="0.00";
				itemDISCObj.focus();			
				//return false;
			}
			if(type=="PKFW")
			{
				//alert("Please select the Pkg & Fwd Type");
				var itemPKFWObj = eval("document.myForm1.itemPKFW"+itemPos);
				var itemPKFWValObj = eval("document.myForm1.itemPKFWVal"+itemPos);
				itemPKFWObj.value="0";
				itemPKFWValObj.value="0.00";
				itemPKFWObj.focus();				
				//return false;
			}
			if(type=="FRT")
			{
				//alert("Please select the Freight Type");
				var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
				var itemFRTValObj = eval("document.myForm1.itemFRTVal"+itemPos);
				itemFRTObj.value="0";
				itemFRTValObj.value="0.00";
				itemFRTObj.focus();								
				//return false;
			}
					
		}
		

		if(type=="DISC")
		{
			var itemDISCObj = eval("document.myForm1.itemDISC"+itemPos);
			itemDISCObj.removeAttribute('readonly');
			itemDISCObj.value="0";
			itemDISCObj.focus();
			
		}
		if(type=="PKFW")
		{
			var itemPKFWObj = eval("document.myForm1.itemPKFW"+itemPos);
			itemPKFWObj.removeAttribute('readonly');
			itemPKFWObj.value="0";
			itemPKFWObj.focus();
			
		}
		if(type=="FRT")
		{
			var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
			itemFRTObj.removeAttribute('readonly');
			itemFRTObj.value="0";
			itemFRTObj.focus();
			
		}
		/*if(type=="TAX")
		{
			var itemFRTObj = eval("document.myForm1.itemTAX"+itemPos);
			itemFRTObj.removeAttribute('readonly');
			itemFRTObj.value="";
			itemFRTObj.focus();
			
		}*/		
	}
	
	function checkNum(fieldObj,itemPos,type)
	{
		
		var fieldVal = fieldObj.value;	
		//alert("type>>>"+type+"   fieldVal>>>"+fieldVal);
		var vendCat= "<%=vendCat%>";

		if(isNaN(fieldVal) || fieldVal=='')
		{
			alert("Please enter valid numeric value");
			fieldObj.value="0";
			fieldObj.focus();
			return;
		}
		else 
		{
			var itemQtyObj = eval("document.myForm1.rfqItemQty"+itemPos);
			var itemPriceObj = eval("document.myForm1.itemPrice"+itemPos);
			//alert("itemQtyObj>>>"+itemQtyObj.value);
			//alert("itemPriceObj>>>"+itemPriceObj.value);
			
			var itemValObj = eval("document.myForm1.itemVal"+itemPos);
			itemValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 			
			
			//DISCOUNT
			//var valTypeDISCObj = eval("document.myForm1.valTypeDISC"+itemPos);
			var valTypeDISCObjVal = eval("document.myForm1.valTypeDISC"+itemPos);
			var valTypeDISCObj = valTypeDISCObjVal.value.split("##",1);
			//alert("valTypeDISCObj>>>>>>"+valTypeDISCObj);
			var itemDISCObj = eval("document.myForm1.itemDISC"+itemPos);
			if(type== "DISC")
			{
				if(valTypeDISCObj.value == "" && itemDISCObj.value > 0)
				{
					alert("Please Select Discount Type");
					itemDISCObj.value=0;
					return;
				}
			}
			var itemDISCValObj = eval("document.myForm1.itemDISCVal"+itemPos);
			//alert("itemValObj>>"+itemValObj.value+"    itemDISCObj>>>>"+itemDISCObj.value)
			//alert("checking"+itemDISCValObj.value);
			if(valTypeDISCObj == "P")
				itemDISCValObj.value = ((itemValObj.value * itemDISCObj.value)/100).toFixed(2);
			else if(valTypeDISCObj=="V")
				itemDISCValObj.value = itemDISCObj.value;
			else if(valTypeDISCObj=="Q")	
				itemDISCValObj.value = (itemDISCObj.value * parseFloat(itemQtyObj.value)).toFixed(2);
			
			var itemNetVal = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)).toFixed(2); 								
			//alert("itemNetVal>>>>>"+itemNetVal);
			var itemNetVal2 = itemNetVal;
			
			
			//PKFW
			
			var valTypePKFWObj = eval("document.myForm1.valTypePKFW"+itemPos);
			var itemPKFWObj = eval("document.myForm1.itemPKFW"+itemPos);
			if(type== "PKFW")
			{
				if(valTypePKFWObj.value == "" && itemPKFWObj.value > 0)
				{
					alert("Please Select Pkg & Fwd Type");
					itemPKFWObj.value=0;
					return;
				}			
			}
			var itemPKFWValObj = eval("document.myForm1.itemPKFWVal"+itemPos);
			//alert("itemNetVal>>>"+itemNetVal+"   itemPKFWObj>>>>"+itemPKFWObj.value);
			if(valTypePKFWObj.value == "P")
			{
				//alert("itemNetVal>>>"+itemNetVal+"   itemPKFWObj>>>>"+itemPKFWObj.value);
				itemPKFWValObj.value = (((itemNetVal) * itemPKFWObj.value)/100).toFixed(2);
			}
			else if(valTypePKFWObj.value=="V")
				itemPKFWValObj.value = itemPKFWObj.value;
			else if(valTypePKFWObj.value=="Q")	
				itemPKFWValObj.value = (itemPKFWObj.value * parseFloat(itemQtyObj.value)).toFixed(2);			
				
			//FRT
			
			//var valTypeFRTObj = eval("document.myForm1.valTypeFRT"+itemPos);
			var valTypeFRTObjVal = eval("document.myForm1.valTypeFRT"+itemPos);
			var valTypeFRTObj = valTypeFRTObjVal.value.split("##",1);
			//out.println("valTypeFRTObj>>>>>>"+valTypeFRTObj);
			var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
			//alert("itemNetVal>>>"+itemNetVal+"     itemFRTObj>>>>>>"+itemFRTObj.value+"    itemQtyObj>>>>"+itemQtyObj.value);
			if(type== "FRT")
			{
				if(valTypeFRTObj.value == "" && itemFRTObj.value > 0)
				{
					alert("Please Select Freight Type");
					itemFRTObj.value=0;
					return;
				}			
			}
			var itemFRTValObj = eval("document.myForm1.itemFRTVal"+itemPos);
			
			
				// alert("checking"+itemFRTValObj.value);
				if(valTypeFRTObj == "P")
					itemFRTValObj.value = (((itemNetVal) * itemFRTObj.value)/100).toFixed(2);
				else if(valTypeFRTObj=="V")
					itemFRTValObj.value = itemFRTObj.value;
				else if(valTypeFRTObj=="Q")	
					itemFRTValObj.value = (itemFRTObj.value * parseFloat(itemQtyObj.value)).toFixed(2);	
				
			/*if(vendCat === "IMP")				
			{
				var itemOTHObj = eval("document.myForm1.itemOTH"+itemPos);
				var itemOTHValObj = eval("document.myForm1.itemOTHVal"+itemPos);
				itemOTHValObj.value = parseFloat(itemOTHObj.value).toFixed(2);
			}*/
			
			
			if(vendCat === "DOM")
			{
				
				var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos);
				//alert("itemTotalValObj>>>>"itemTotalValObj);
				//alert("itemQtyObj>>>>"+itemQtyObj.value+"   itemPriceObj>>>>"+itemPriceObj.value+"   itemDISCValObj>>>"+itemDISCValObj.value+"   itemPKFWValObj>>>"+itemPKFWValObj.value+"    itemFRTValObj>>>"+itemFRTValObj.value);
				//alert("itemTotalValObj>>>>>"+itemTotalValObj.value);
				itemTotalValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value)).toFixed(2); 								
				

			}
			var itemGrossValObj=eval("document.myForm1.itemTotalVal"+itemPos);
			
			//alert("itemGrossValObj>>>>>>>>>>>>>"+itemGrossValObj);
			if(vendCat === "DOM")
			{
					//alert("alert44");
					//alert("itemTotalValObj>>>>>>>>>>>>>"+itemTotalValObj.value);
				itemGrossValObj.value = parseFloat(itemTotalValObj.value).toFixed(2);
				//itemGrossValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value)).toFixed(2); 								
			}				
			else
				itemGrossValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value)).toFixed(2); 								
			
	
		}	
	}	

</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
       $('#').dataTable( {
  	"dom": 'tp',
  	    "lengthMenu": [[5,10, 25, 50, -1], [5,10, 25, 50, "All"]]

   	
   	
       } );
   } );

</script>