<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import="ezc.ezutil.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iLang_Labels.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>  
 

<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<%
	//String item_Cond_L="",Qty_L="",Cn_Type_L="";
	//String name_L="",value_L="",curr_L="",Amount_L="",price_L="",disc_L="",Pkg_Fwd_L="",freight_L="",GST_L="",save_L="",close_L="";
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
				<select name="price<%=itemPos%>" class="form-control input-sm select2"  style="width:175px !important" readonly>
<%
				if("DOM".equals(vendCat))
				{
%>				
					<option value="PBXX">Basic Price</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>				
					<option value="P001">Basic Price</option>
<%
				}
	
%>
				</select>
			</td>	
			<input type=hidden name="rfqItemQty<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemQty%>' onBlur="checkNum(this,'<%=itemPos%>')" readonly></td>
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
					<option value="P">Discount % on Gross</option>
					<option value="Q">Discount/Quantity</option>
					
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>
					<option value="P">Discount % on Gross</option>
					<option value="Q">Discount/Quantity</option>
					
<%
				}
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
					<option value="P">Freight %</option>
					<option value="V">Freight(Value)</option>
					<option value="Q">Freight/Quantity</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">Freight %</option>
					<option value="V">Freight(Value)</option>
					<option value="Q">Freight/Quantity</option>
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
		if("IMP".equals(vendCat))
		{
%>		
		
			<tr>
				<th>Pallet Charges</th>

				<td style="background-color:#d5dcef"align="right" nowrap>&nbsp;</td>
	     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemOTH<%=itemPos%>"  style="width:125px;"  size=9  min="0" class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','OTH')"></td>
	     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
	     			<td style="background-color:#d5dcef" align="right" nowrap>
					<input  type="hidden" name="itemOTHCode<%=itemPos%>"  value="OTH">      		
     					<input type=number name="itemOTHVal<%=itemPos%>" style="width:120px;"  size=9  class="form-control" value="0.00" readonly>
	     			</td>
			</tr>
<%
		}
		if("DOM".equals(vendCat))
		{
%>			
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b><%=net_Value_L%></b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td align="center" nowrap><input type=number name="itemTotalVal<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value="<%=totVal%>" readonly></td>
		</tr>
		
		<tr>
			<th><%=GST_L%></th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','TAX')" style="width:100% !important">
					<option value="">-- Select--</option>
					
					<option value="W">Within State(Intra State)</option>
					<option value="O">Outside State(Inter State)</option>
					<option value="DC">DSIR(CGST+SGST)</option>
					<option value="DI">DSIR(IGST)</option>
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap>
				<input  type="hidden" name="itemTAXCode<%=itemPos%>"  value="TAX"> 
				<select name="itemTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="checkNum(this,'<%=itemPos%>','TAX')" style="width:100% !important">
					<option value="">-- Select--</option>
					<option value="0">0</option>
					<option value="3">3</option>
					<option value="5">5</option>
					<option value="12">12</option>
					<option value="18">18</option>
					<option value="28">28</option>
				</select>	
			</td>	
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td style="background-color:#d5dcef" align="right" nowrap><input type=number name="itemTAXVal<%=itemPos%>" style="width:125px;" size=9  class="form-control" value="0" readonly></td>
		</tr>
<%	
				}
				else
				{

%>
					<input  type="hidden" name="valTypeTAX<%=itemPos%>"  value=""> 
					<input  type="hidden" name="itemTAX<%=itemPos%>"  value=""> 
					<input  type="hidden" name="itemTAXCode<%=itemPos%>"  value="TAX"> 
					<input  type="hidden" name="itemTAXVal<%=itemPos%>"  value="0"> 
<%
				}
%>
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b><%=gross_Value_L%></b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:80px;" size=9  class="form-control" value='<%=currency%>'  <%=readonly%>></td>
			<td align="right" nowrap><input type=number name="itemGrossVal<%=itemPos%>"  style="width:125px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>		
		

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
		//alert("itemPos>>"+itemPos);
		var vendCat= "<%=vendCat%>";
		
		//alert("itemVal>>>"+itemVal)
		var itemQty = eval("parent.document.myForm.itemQty"+itemPos).value;
		//alert("itemQty>>>"+itemQty)
		var itemPrice = eval("parent.document.myForm.itemPrice"+itemPos).value;
		//alert("itemPrice>>>"+itemPrice)		
		var itemVal = (parseFloat(itemQty)*parseFloat(itemPrice)).toFixed(2)
		
		eval("document.myForm1.itemVal"+itemPos).value=itemVal;		
		
		//DISCOUNT
		
		var itemDISCCode = eval("parent.document.myForm.itemDISCCode"+itemPos).value;
		var itemDISC = eval("parent.document.myForm.itemDISC"+itemPos).value;
		var valTypeDISC = eval("parent.document.myForm.valTypeDISC"+itemPos).value;
		var itemDISCVal = eval("parent.document.myForm.itemDISCVal"+itemPos).value;
		
		eval("document.myForm1.itemDISCCode"+itemPos).value=itemDISCCode;
		eval("document.myForm1.itemDISC"+itemPos).value=itemDISC;
		eval("document.myForm1.valTypeDISC"+itemPos).value=valTypeDISC;
		eval("document.myForm1.itemDISCVal"+itemPos).value=itemDISCVal;	
		
		//PKFW
		
		var itemPKFWCode = eval("parent.document.myForm.itemPKFWCode"+itemPos).value;
		var itemPKFW = eval("parent.document.myForm.itemPKFW"+itemPos).value;
		var valTypePKFW = eval("parent.document.myForm.valTypePKFW"+itemPos).value;
		var itemPKFWVal = eval("parent.document.myForm.itemPKFWVal"+itemPos).value;
		
		eval("document.myForm1.itemPKFWCode"+itemPos).value=itemPKFWCode;
		eval("document.myForm1.itemPKFW"+itemPos).value=itemPKFW;
		eval("document.myForm1.valTypePKFW"+itemPos).value=valTypePKFW;
		eval("document.myForm1.itemPKFWVal"+itemPos).value=itemPKFWVal;	
		
		
		//FRT
		
		var itemFRTCode = eval("parent.document.myForm.itemFRTCode"+itemPos).value;
		var itemFRT = eval("parent.document.myForm.itemFRT"+itemPos).value;
		var valTypeFRT = eval("parent.document.myForm.valTypeFRT"+itemPos).value;
		var itemFRTVal = eval("parent.document.myForm.itemFRTVal"+itemPos).value;
		
		eval("document.myForm1.itemFRTCode"+itemPos).value=itemFRTCode;
		eval("document.myForm1.itemFRT"+itemPos).value=itemFRT;
		eval("document.myForm1.valTypeFRT"+itemPos).value=valTypeFRT;
		eval("document.myForm1.itemFRTVal"+itemPos).value=itemFRTVal;	
		
		//OTHER CHARGES
		
		if(vendCat === "IMP")
		{
			var itemOTH = eval("parent.document.myForm.itemOTH"+itemPos).value;
			var itemOTHVal = eval("parent.document.myForm.itemOTHVal"+itemPos).value;
			
			eval("document.myForm1.itemOTH"+itemPos).value=itemOTH;
			eval("document.myForm1.itemOTHVal"+itemPos).value=itemOTHVal;
		}
		
		//NET VALUE
		if(vendCat === "DOM")
		{
			var itemTotalVal = parseFloat(itemVal)-parseFloat(itemDISCVal)+parseFloat(itemPKFWVal)+parseFloat(itemFRTVal);
			eval("document.myForm1.itemTotalVal"+itemPos).value=itemTotalVal.toFixed(2);		
		}	
		
	
		
		
		//TAX
		
		var itemTAXCode = eval("parent.document.myForm.itemTAXCode"+itemPos).value;
		var itemTAX = eval("parent.document.myForm.itemTAX"+itemPos).value;
		var valTypeTAX = eval("parent.document.myForm.valTypeTAX"+itemPos).value;
		var itemTAXVal = eval("parent.document.myForm.itemTAXVal"+itemPos).value;
		
		eval("document.myForm1.itemTAXCode"+itemPos).value=itemTAXCode;
		eval("document.myForm1.itemTAX"+itemPos).value=itemTAX;
		eval("document.myForm1.valTypeTAX"+itemPos).value=valTypeTAX;
		eval("document.myForm1.itemTAXVal"+itemPos).value=itemTAXVal;
		
		
		
		
		//GROSS VALUE
		if(vendCat === "DOM")
			var itemGrossVal = (parseFloat(itemTotalVal) + parseFloat(itemTAXVal)).toFixed(2);
		else
			var itemGrossVal = (parseFloat(itemVal)-parseFloat(itemDISCVal)+parseFloat(itemPKFWVal)+parseFloat(itemFRTVal)+parseFloat(itemOTHVal)).toFixed(2);
			
		eval("document.myForm1.itemGrossVal"+itemPos).value=itemGrossVal;
		
		
		
		
	}
	function funClose()
	{
		window.parent.$('#woModal').modal('hide');
	}
	function funOk()
	{
		var itemPos=<%=itemPos%>;
		//alert("itemPos>>>"+itemPos);
		
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
		
		var itemDISCCode = eval("document.myForm1.itemDISCCode"+itemPos).value;
		var itemDISC = eval("document.myForm1.itemDISC"+itemPos).value;
		var valTypeDISC = eval("document.myForm1.valTypeDISC"+itemPos).value;
		var itemDISCVal = eval("document.myForm1.itemDISCVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemDISCCode"+itemPos).value=itemDISCCode;
		eval("parent.document.myForm.itemDISC"+itemPos).value=itemDISC;
		eval("parent.document.myForm.valTypeDISC"+itemPos).value=valTypeDISC;
		eval("parent.document.myForm.itemDISCVal"+itemPos).value=itemDISCVal;
		
		//PKFW
		
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
		var itemFRTVal = eval("document.myForm1.itemFRTVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemFRTCode"+itemPos).value=itemFRTCode;
		eval("parent.document.myForm.itemFRT"+itemPos).value=itemFRT;
		eval("parent.document.myForm.valTypeFRT"+itemPos).value=valTypeFRT;
		eval("parent.document.myForm.itemFRTVal"+itemPos).value=itemFRTVal;
		
		//OTHERS
		
		if(vendCat === "IMP")
		{
			var itemOTH = eval("document.myForm1.itemOTH"+itemPos).value;
			var itemOTHVal = eval("document.myForm1.itemOTHVal"+itemPos).value;
		
			eval("parent.document.myForm.itemOTH"+itemPos).value=itemOTH;
			eval("parent.document.myForm.itemOTHVal"+itemPos).value=itemOTHVal;
		}	
		
		//SUPPLY PRICE
		
		/*
		var itemSupplyPriceObj = eval("document.myForm1.itemSupplyPrice"+itemPos).value;
		eval("parent.document.myForm.itemSupplyPrice"+itemPos).value=itemSupplyPriceObj;		
		*/
		
		//TAX
		if(vendCat === "DOM")
		{		
		
			var itemTAXCode = eval("document.myForm1.itemTAXCode"+itemPos).value;
			var itemTAX = eval("document.myForm1.itemTAX"+itemPos).value;
			var valTypeTAX = eval("document.myForm1.valTypeTAX"+itemPos).value;
			var itemTAXVal = eval("document.myForm1.itemTAXVal"+itemPos).value;
			//alert("itemTAXVal>>>"+itemTAXVal);
			
			eval("parent.document.myForm.itemTAXCode"+itemPos).value=itemTAXCode;
			eval("parent.document.myForm.itemTAX"+itemPos).value=itemTAX;
			eval("parent.document.myForm.valTypeTAX"+itemPos).value=valTypeTAX;
			eval("parent.document.myForm.itemTAXVal"+itemPos).value=itemTAXVal; 
			

			
		}	
		//GROSS VALUE
		
		var itemGrossValObj = eval("document.myForm1.itemGrossVal"+itemPos).value;
		eval("parent.document.myForm.itemValue"+itemPos).value=itemGrossValObj;	
		
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
			if(type=="TAX")
			{
				alert("Please select the tax Type");
				//fieldObj.focus();
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
		if(type=="TAX")
		{
			var itemFRTObj = eval("document.myForm1.itemTAX"+itemPos);
			itemFRTObj.removeAttribute('readonly');
			itemFRTObj.value="";
			itemFRTObj.focus();
			
		}		
	}
	function checkNum(fieldObj,itemPos,type)
	{
		
		var fieldVal = fieldObj.value;	
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
			var valTypeDISCObj = eval("document.myForm1.valTypeDISC"+itemPos);
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
			//alert("valTypeDISCObj>>"+valTypeDISCObj.value)
			if(valTypeDISCObj.value == "P")
				itemDISCValObj.value = ((itemValObj.value * itemDISCObj.value)/100).toFixed(2);
			else if(valTypeDISCObj.value=="V")
				itemDISCValObj.value = itemDISCObj.value;
			else if(valTypeDISCObj.value=="Q")	
				itemDISCValObj.value = (itemDISCObj.value * parseFloat(itemQtyObj.value)).toFixed(2);
			
				
				
			var itemNetVal = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)).toFixed(2); 								
			
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
			
			if(valTypePKFWObj.value == "P")
				itemPKFWValObj.value = (((itemNetVal) * itemPKFWObj.value)/100).toFixed(2);
			else if(valTypePKFWObj.value=="V")
				itemPKFWValObj.value = itemPKFWObj.value;
			else if(valTypePKFWObj.value=="Q")	
				itemPKFWValObj.value = (itemPKFWObj.value * parseFloat(itemQtyObj.value)).toFixed(2);			
				
			//FRT
			
			var valTypeFRTObj = eval("document.myForm1.valTypeFRT"+itemPos);
			var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
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
			
			
			if(valTypeFRTObj.value == "P")
				itemFRTValObj.value = (((itemNetVal) * itemFRTObj.value)/100).toFixed(2);
			else if(valTypeFRTObj.value=="V")
				itemFRTValObj.value = itemFRTObj.value;
			else if(valTypeFRTObj.value=="Q")	
				itemFRTValObj.value = (itemFRTObj.value * parseFloat(itemQtyObj.value)).toFixed(2);	
				
			if(vendCat === "IMP")				
			{
				var itemOTHObj = eval("document.myForm1.itemOTH"+itemPos);
				var itemOTHValObj = eval("document.myForm1.itemOTHVal"+itemPos);
				itemOTHValObj.value = parseFloat(itemOTHObj.value).toFixed(2);
			}
			
			
			if(vendCat === "DOM")
			{
				var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos);
				itemTotalValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value)).toFixed(2); 								
						
			//GST
				
			var valTypeTAXObj = eval("document.myForm1.valTypeTAX"+itemPos);
			var itemTAXObj=eval("document.myForm1.itemTAX"+itemPos);
			if(type== "TAX")
			{
				if(valTypeTAXObj.value == "")
				{
					alert("Please Select Tax Type");
					itemTAXObj.value=0;
					return;
				}
				if(itemTAXObj.value == "")
				{
					alert("Please Select Tax Vlaue");
					itemTAXObj.value=0;
					return;
				}				
			}	
				var itemTAXValObj = eval("document.myForm1.itemTAXVal"+itemPos);
				itemTAXValObj.value = ((((parseFloat(itemTotalValObj.value)) * itemTAXObj.value)/100)).toFixed(2);
			
			}
			var itemGrossValObj=eval("document.myForm1.itemGrossVal"+itemPos);
			if(vendCat === "DOM")
				itemGrossValObj.value = (parseFloat(itemTotalValObj.value)+parseFloat(itemTAXValObj.value)).toFixed(2) ;
			else
				itemGrossValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value) + parseFloat(itemOTHValObj.value)).toFixed(2); 								
			
	
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