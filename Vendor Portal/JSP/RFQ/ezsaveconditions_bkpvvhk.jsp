<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import="ezc.ezutil.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<%
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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>Ceat</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">-->
    <link rel="stylesheet" href="../Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <!--<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">-->
    <link rel="stylesheet" href="../Library/bootstrap/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/pace/pacetopline.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">	
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <!--<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script> -->
    <![endif]-->
    <style>
	.tx 
	{
		    border:0px;
	}
	th
	{
		    background-color: #3c8dbc;
		    color:white;
	}
	button
	{
		margin-left:2px;
	}
</style>	
  </head>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
	<h1>
		Item Conditions for  <%=rfqNo%>(<%=lineNO%>)
	</h1>
	<!--<div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table id="ezRCItemTab" class="table table-bordered">
		<tr>
			<th>Qunatity</th>
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
			<th>Cn Type</th>
			<th>Name</th>
			<th>Amount</th>
			<th>Value</th>
		</tr>	
		<tr>
			<th>Price</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="price<%=itemPos%>" class="form-control input-sm select2"  style="width:100% !important" readonly>
<%
				if("DOM".equals(vendCat))
				{
%>				
					<option value="PBXX">Basic Price[PBXX]</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>				
					<option value="P001">Basic Price[P001]</option>
<%
				}
	
%>
				</select>
			</td>	
			<input type=hidden name="rfqItemQty<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemQty%>' onBlur="checkNum(this,'<%=itemPos%>')" readonly></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPrice<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemPrice%>' onBlur="checkNum(this,'<%=itemPos%>')" ></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>
		
		<tr>
			<th>Discount</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeDISC<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','DISC')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">Discount % on Gross[R000]</option>
					<option value="Q">Discount/Quantity[R001]</option>
					<!--<option value="V">Discount(Value)[R002]</option>-->
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>
					<option value="P">Discount % on Gross[R000]</option>
					<option value="Q">Discount/Quantityty[R001]</option>
					<!--<option value="V">Absolute discount[R002]</option>-->
<%
				}
%>				
				
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemDISC<%=itemPos%>"  style="width:100px;"  size=9 min="0" class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>')" ></td>
			<td style="background-color:#d5dcef" align="right" nowrap>
					<input  type="hidden" name="itemDISCCode<%=itemPos%>"  value="DISC"> 
					<input type=number name="itemDISCVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value="0.00" readonly>
			</td>			
		</tr>
		<tr>
			<th>Pkg & Fwd</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypePKFW<%=itemPos%>" class="form-control input-sm select2" onChange="chkSel(this,'<%=itemPos%>','PKFW')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">Pkg&Fwd chrgs(%)[ZPF1]</option>
					<option value="V">P&F Value[ZPF2]</option>					
					<option value="Q">P&F QTY[ZPF3]</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">P&F% on Net[ZPF1]</option>
					<option value="V">P&F Value[ZPF2]</option>					
					<option value="Q">P&F QTY[ZPF3]</option>					
<%
				}
%>				
				</select>
     			</td> 		
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW<%=itemPos%>" style="width:100px;"   size=9 min="0"  class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>')" ></td>
     		
     			<td style="background-color:#d5dcef" align="right" nowrap>
     				
				<input  type="hidden" name="itemPKFWCode<%=itemPos%>"  value="PKFW"> 
     				<input type=number name="itemPKFWVal<%=itemPos%>" style="width:100px;"  size=9  class="form-control" value="0.00" readonly>
     			</td>
		</tr>
		<tr>
			<th>Freight</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeFRT<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','FRT')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">FRA1-->Freight %</option>
					<option value="V">FRB1-->Freight(Value)</option>
					<option value="Q">FRC1-->Freight/Quantity</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">FRA1-->Freight %</option>
					<option value="V">FRB1-->Freight(Value)</option>
					<option value="Q">FRC1-->Freight/Quantity</option>
<%
				}
%>				
					
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemFRT<%=itemPos%>"  style="width:100px;"  size=9  min="0" class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>')"></td>
     			<td style="background-color:#d5dcef"align="right" nowrap>
				
				<input  type="hidden" name="itemFRTCode<%=itemPos%>"  value="FRT">      		
     				<input type=number name="itemFRTVal<%=itemPos%>" style="width:100px;"  size=9  class="form-control" value="0.00" readonly>
     			</td>
		</tr> 
		<tr>
			<th>Others</th>
			<td style="background-color:#d5dcef" align="center">
			&nbsp;
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemOTH<%=itemPos%>"  style="width:100px;"  size=9  min="0" class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>')"></td>
     			<td style="background-color:#d5dcef" align="right" nowrap>
				
				<input  type="hidden" name="itemOTHCode<%=itemPos%>"  value="OTH">      		
     				<input type=number name="itemOTHVal<%=itemPos%>" style="width:100px;"  size=9  class="form-control" value="0.00" readonly>
     			</td>
		</tr>		
		
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b>Net Value</b>&nbsp;</td>
			<td align="center" nowrap><input type=number name="itemTotalVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value="<%=totVal%>" readonly></td>
		</tr>	
		<tr>
			<th>GST</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','TAX')" style="width:100% !important">
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="W">Within State(Intra State)</option>
					<option value="O">Outside State(Inter State)</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>
					<option value="P">IGST Imports(%)</option>
<%
				}
%>					
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap>
				<input  type="hidden" name="itemTAXCode<%=itemPos%>"  value="TAX"> 
				<select name="itemTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="checkNum(this,'<%=itemPos%>')" style="width:100% !important">
					<!--<option value="">-- Select--</option> -->
					<option value="0">0</option>
					<option value="3">3</option>
					<option value="5">5</option>
					<option value="12">12</option>
					<option value="18">18</option>
					<option value="28">28</option>
				</select>	

				
			</td>			
			<td style="background-color:#d5dcef" align="right" nowrap><input type=number name="itemTAXVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="99" readonly></td>
		</tr>

		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b>Gross Value</b>&nbsp;</td>
			<td align="right" nowrap><input type=number name="itemGrossVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>		
		

	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	 
	<div class="row no-print">
	<div class="col-xs-12">
		<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;">OK</button>
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
		
		var itemOTH = eval("parent.document.myForm.itemOTH"+itemPos).value;
		var itemOTHVal = eval("parent.document.myForm.itemOTHVal"+itemPos).value;
		
		eval("document.myForm1.itemOTH"+itemPos).value=itemOTH;
		eval("document.myForm1.itemOTHVal"+itemPos).value=itemOTHVal;
		
		
		//NET VALUE
		var itemTotalVal = parseFloat(itemVal)-parseFloat(itemDISCVal)+parseFloat(itemPKFWVal)+parseFloat(itemFRTVal)+parseFloat(itemOTHVal);
		eval("document.myForm1.itemTotalVal"+itemPos).value=itemTotalVal.toFixed(2);		
		
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
		var itemGrossVal = (parseFloat(itemTotalVal) + parseFloat(itemTAXVal)).toFixed(2);
		eval("document.myForm1.itemGrossVal"+itemPos).value=itemGrossVal;
		
		
		
		
	}
	function funOk()
	{
		var itemPos=<%=itemPos%>;
		//alert("itemPos>>>"+itemPos);
		
		var itemPriceObj = eval("document.myForm1.itemPrice"+itemPos).value;
		eval("parent.document.myForm.itemPrice"+itemPos).value=itemPriceObj;
		
		
		var itemValObj = eval("document.myForm1.itemVal"+itemPos).value;
		eval("parent.document.myForm.itemVal"+itemPos).value=itemValObj;		
		
		var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos).value;
		eval("parent.document.myForm.itemTotalVal"+itemPos).value=itemTotalValObj;
		
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
		var itemOTH = eval("document.myForm1.itemOTH"+itemPos).value;
		var itemOTHVal = eval("document.myForm1.itemOTHVal"+itemPos).value;
		
		eval("parent.document.myForm.itemOTH"+itemPos).value=itemOTH;
		eval("parent.document.myForm.itemOTHVal"+itemPos).value=itemOTHVal;
		
		
		//SUPPLY PRICE
		
		/*
		var itemSupplyPriceObj = eval("document.myForm1.itemSupplyPrice"+itemPos).value;
		eval("parent.document.myForm.itemSupplyPrice"+itemPos).value=itemSupplyPriceObj;		
		*/
		
		//TAX
		
		var itemTAXCode = eval("document.myForm1.itemTAXCode"+itemPos).value;
		var itemTAX = eval("document.myForm1.itemTAX"+itemPos).value;
		var valTypeTAX = eval("document.myForm1.valTypeTAX"+itemPos).value;
		var itemTAXVal = eval("document.myForm1.itemTAXVal"+itemPos).value;
		
		
		eval("parent.document.myForm.itemTAXCode"+itemPos).value=itemTAXCode;
		eval("parent.document.myForm.itemTAX"+itemPos).value=itemTAX;
		eval("parent.document.myForm.valTypeTAX"+itemPos).value=valTypeTAX;
		eval("parent.document.myForm.itemTAXVal"+itemPos).value=itemTAXVal; 
		
		//GROSS VALUE
		
		var itemGrossValObj = eval("document.myForm1.itemGrossVal"+itemPos).value;
		eval("parent.document.myForm.itemValue"+itemPos).value=itemGrossValObj;		
		
		
		
		
		window.parent.$('#woModal').modal('hide');	
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
				alert("Please select the Discount Type");
				var itemDISCObj = eval("document.myForm1.itemDISC"+itemPos);
				var itemDISCValObj = eval("document.myForm1.itemDISCVal"+itemPos);
				//itemDISCObj.removeAttribute('readonly');
				itemDISCObj.value="0";
				itemDISCValObj.value="0";
				itemDISCObj.focus();			
				return false;
			}
			if(type=="PKFW")
			{
				alert("Please select the Pkg & Fwd Type");
				//fieldObj.focus();
				return false;
			}
			if(type=="FRT")
			{
				alert("Please select the Freight Type");
				//fieldObj.focus();
				return false;
			}
			if(type=="TAX")
			{
				alert("Please select the tax Type");
				//fieldObj.focus();
				return false;
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
			itemFRTObj.value="0";
			itemFRTObj.focus();
			
		}		
	}
	function checkNum(fieldObj,itemPos)
	{
		
		var fieldVal = fieldObj.value;	

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
			
			var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos);
			
			//DISCOUNT
			
			var itemDISCObj = eval("document.myForm1.itemDISC"+itemPos);
			var valTypeDISCObj = eval("document.myForm1.valTypeDISC"+itemPos);
			var itemDISCValObj = eval("document.myForm1.itemDISCVal"+itemPos);
			//alert("valTypeDISCObj>>"+valTypeDISCObj.value)
			if(valTypeDISCObj.value == "P")
				itemDISCValObj.value = ((itemValObj.value * itemDISCObj.value)/100).toFixed(2);
			else if(valTypeDISCObj.value=="V")
				itemDISCValObj.value = itemDISCObj.value;
			else if(valTypeDISCObj.value=="Q")	
				itemDISCValObj.value = itemDISCObj.value * parseFloat(itemQtyObj.value);
				
			var itemNetVal = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)).toFixed(2); 								
			
			var itemPKFWObj = eval("document.myForm1.itemPKFW"+itemPos);
			var valTypePKFWObj = eval("document.myForm1.valTypePKFW"+itemPos);
			var itemPKFWValObj = eval("document.myForm1.itemPKFWVal"+itemPos);
			
			if(valTypePKFWObj.value == "P")
				itemPKFWValObj.value = (((itemNetVal) * itemPKFWObj.value)/100).toFixed(2);
			else if(valTypePKFWObj.value=="V")
				itemPKFWValObj.value = itemPKFWObj.value;
			else if(valTypePKFWObj.value=="Q")	
				itemPKFWValObj.value = itemPKFWObj.value * parseFloat(itemQtyObj.value) ;			
				
			//FRT
			
			var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
			var valTypeFRTObj = eval("document.myForm1.valTypeFRT"+itemPos);
			var itemFRTValObj = eval("document.myForm1.itemFRTVal"+itemPos);
			
			
			if(valTypeFRTObj.value == "P")
				itemFRTValObj.value = (((itemNetVal) * itemFRTObj.value)/100).toFixed(2);
			else if(valTypeFRTObj.value=="V")
				itemFRTValObj.value = itemFRTObj.value;
			else if(valTypeFRTObj.value=="Q")	
				itemFRTValObj.value = itemFRTObj.value * parseFloat(itemQtyObj.value);			
			
			var itemOTHObj = eval("document.myForm1.itemOTH"+itemPos);
			var itemOTHValObj = eval("document.myForm1.itemOTHVal"+itemPos);
			itemOTHValObj.value = parseFloat(itemOTHObj.value).toFixed(2);
			
			itemTotalValObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)- parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value)+ parseFloat(itemFRTValObj.value) + parseFloat(itemOTHValObj.value)).toFixed(2); 								
			//alert("itemTotalValObj>>>"+itemTotalValObj.value);			
						
			
			//var itemSupplyPriceObj=eval("document.myForm1.itemSupplyPrice"+itemPos);
			//itemSupplyPriceObj.value = parseFloat(itemTotalValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value)+ parseFloat(itemOTHValObj.value);
			//itemSupplyPriceObj.value = parseFloat(itemSupplyPriceObj.value).toFixed(2);
			
			//GST
			var itemTAXObj=eval("document.myForm1.itemTAX"+itemPos);
			var itemTAXValObj = eval("document.myForm1.itemTAXVal"+itemPos);
			itemTAXValObj.value = ((((parseFloat(itemTotalValObj.value)) * itemTAXObj.value)/100)).toFixed(2);
			
			var itemGrossValObj=eval("document.myForm1.itemGrossVal"+itemPos);
			itemGrossValObj.value = (parseFloat(itemTotalValObj.value)+parseFloat(itemTAXValObj.value)).toFixed(2) ;
			
	
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