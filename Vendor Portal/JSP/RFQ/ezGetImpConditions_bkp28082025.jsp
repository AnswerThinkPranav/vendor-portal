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
	String lineNo=request.getParameter("lineNo");
	String itemPos=request.getParameter("itemPos");
	String itemQty=request.getParameter("itemQty");
	String itemPrice=request.getParameter("itemPrice");
	String vendCat=request.getParameter("vendCat");
	String reqFrom=request.getParameter("reqFrom");
	String userType=request.getParameter("userType");
	String currency=request.getParameter("currency");
	
	String readOnly="readonly";
	String disabled="disabled";
	if("3".equals(userType) && "Req".equals(reqFrom)) 
	{
		readOnly="";
		disabled="";
	}
	/*
	String readOnlyPP="";
	String disabledPP="";	
	
	if(("2".equals(userType) && "Apr".equals(reqFrom)) || ("3".equals(userType) && !"Req".equals(reqFrom))) 
	{
		readOnlyPP="readonly";
		disabledPP="disabled";
	}	
	*/
	String readOnlyPP="readonly";
	String disabledPP="disabled";	
	
	if("2".equals(userType) && "Act".equals(reqFrom)) 
	{
		readOnlyPP="";
		disabledPP="";
	}	
	
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
		Item Conditions for  <%=rfqNo%>(<%=lineNo%>)
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
<form name="myForm1" method="post">
	<div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table id="ezRCItemTab" class="table table-bordered">
		
		<tr>
			<th>Cn Type</th>
			<th>Name</th>
			<th>Value</th>
			<th>Currency</th>
			<th>Amount</th>
			
		</tr>	
		<tr>
			<th>Price</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="price<%=itemPos%>" class="form-control input-sm select2"  style="width:170px !important" <%=readOnly%> <%=disabled%>>
<%
				if("DOM".equals(vendCat))
				{
%>				
					<option value="PBXX">PBXX-->Basic Price</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>				
					<option value="P001">P001-->Basic Price</option>
<%
				}
	
%>					
				</select>
			</td>	
			<input type=hidden name="rfqItemQty<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemQty%>' onBlur="checkNum(this,'<%=itemPos%>')" <%=readOnly%>></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPrice<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=itemPrice%>' onBlur="checkNum(this,'<%=itemPos%>','NA')" <%=readOnly%>></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>
		<!--<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b>Total</b>&nbsp;</td>
			<td align="center" nowrap><input type=number name="itemTotalVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value="<%=totVal%>" <%=readOnly%>></td>
		</tr> -->
		<tr>
			<th>Discount</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeDISC<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','DISC')" style="width:100% !important" <%=readOnly%> <%=disabled%>>
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">R000-->Discount % on Gross</option>
					<option value="Q">R001-->Discount/Quantity</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>
					<option value="P">R000-->Discount % on Gross</option>
					<option value="Q">R001-->Discount/Quantity</option>
<%
				}
%>					
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemDISC<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>','DISC')" <%=readOnly%>></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
			<td style="background-color:#d5dcef" align="center" nowrap>
					<input  type="hidden" name="itemDISCCode<%=itemPos%>"  value="DISC"> 
					<input type=number name="itemDISCVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value="0" readonly>
			</td>			
		</tr>	
		<tr>
			<th>Pkg & Fwd</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypePKFW<%=itemPos%>" class="form-control input-sm select2" onChange="chkSel(this,'<%=itemPos%>','PKFW')" style="width:100% !important" <%=readOnly%> <%=disabled%>>
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">ZPF1-->P&F% on Net</option>
					<!--<option value="V">ZPF2-->P&F Value</option>-->
					<option value="Q">ZPF3-->P&F QTY</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">ZPF1-->P&F% on Net</option>
					<!--<option value="V">ZPF2-->P&F Value</option>-->
					<option value="Q">ZPF3-->P&F QTY</option>					
<%
				}
%>				
				</select>

				</select>
     			</td> 		
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemPKFW<%=itemPos%>" style="width:100px;"   size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>','PKFW')" <%=readOnly%>></td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
     			<td style="background-color:#d5dcef" align="center" nowrap>
     				
				<input  type="hidden" name="itemPKFWCode<%=itemPos%>"  value="PKFW"> 
     				<input type=number name="itemPKFWVal<%=itemPos%>" style="width:100px;"  size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>
		<tr>
			<th>Vendor Freight</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeFRT<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','FRT')" style="width:100% !important" <%=readOnly%> <%=disabled%>>
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
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemFRT<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>','FRT')" <%=readOnly%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemFRTCode<%=itemPos%>"  value="FRT">      		
     				<input type=number name="itemFRTVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>
		<tr>
			<th>Pallet Charges</th>
			<td style="background-color:#d5dcef"align="right" nowrap>&nbsp;</td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemOTH<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" onBlur="checkNum(this,'<%=itemPos%>','OTH')" <%=readOnly%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemOTHCode<%=itemPos%>"  value="OTH">      		
     				<input type=number name="itemOTHVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>
		<tr>
			<th>Buyer FOB</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeFOB<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','FOB')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
					<option value="P">ZFRA-->FOB Freight %</option>
					<option value="V">ZFRB-->FOB(Value)</option>
					<option value="Q">ZFRC-->FOB Freight Quantity </option>					
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemFOB<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0"  min="0" onBlur="checkNum(this,'<%=itemPos%>','FOB')" <%=readOnlyPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemFOBCode<%=itemPos%>"  value="FOB">      		
     				<input type=number name="itemFOBVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>		
		
		<tr>
			<th>Buyer Freight</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeBFRT<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','BFRT')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">FRA2-->Freight %</option>
					<option value="V">FRB2-->Freight(Value)</option>
					<option value="Q">FRC2-->Freight/Quantity</option>
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">FRA2-->Freight %</option>
					<option value="V">FRB2-->Freight(Value)</option>
					<option value="Q">FRC2-->Freight/Quantity</option>					
<%
				}
%>
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemBFRT<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','BFRT')" <%=disabledPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemBFRTCode<%=itemPos%>"  value="BFRT">      		
     				<input type=number name="itemBFRTVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly >
     			</td>
		</tr>	
		<tr>
			<th>Insurance</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeINS<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','INS')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
<%
				if("DOM".equals(vendCat))
				{
%>					
					<option value="P">ZINP-->Insurance(%)</option>
					<option value="Q">ZINQ-->Insurance(Qty)</option>
					
<%	
				}
				else if("IMP".equals(vendCat))
				{
%>	
					<option value="P">ZINP-->Insurance(%)</option>
					<option value="Q">ZINQ-->Insurance(Qty)</option>
					
<%
				}
%>
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemINS<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','INS')" <%=readOnlyPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemINSCode<%=itemPos%>"  value="INS">      		
     				<input type=number name="itemINSVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>			
		
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b>Net Value</b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
			<td align="center" nowrap><input type=number name="itemSupplyPrice<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>
		<tr>
			<th>Customs</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeCUST<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','CUST')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
					<option value="P">JCDB-->IN Basic Customs(%)</option>
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemCUST<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0"  min="0" onBlur="checkNum(this,'<%=itemPos%>','CUST')" <%=readOnlyPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemCUSTCode<%=itemPos%>"  value="CUST">      		
     				<input type=number name="itemCUSTVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>
		<tr>
			<th>SWC</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeSWC<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','SWC')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
					<option value="P">JEDB-->Social Wel Surcharge(%)</option>
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemSWC<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','SWC')" <%=readOnlyPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemSWCCode<%=itemPos%>"  value="SWC">      		
     				<input type=number name="itemSWCVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>
		<tr>
			<th>Clearing</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeCLR<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','CLR')" style="width:120% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
					<option value="P">ZCL1-->Clearing(%)</option>
					<option value="V">ZCL4-->Clearing(Reimburse)</option>
				</select>
     			</td>  
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemCLR<%=itemPos%>"  style="width:100px;"  size=9  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>','CLR')" <%=readOnlyPP%>></td>
     			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>
     			<td style="background-color:#d5dcef" align="center" nowrap>
				
				<input  type="hidden" name="itemCLRCode<%=itemPos%>"  value="CLR">      		
     				<input type=number name="itemCLRVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly>
     			</td>
		</tr>		
		
		<tr>
			<th>GST</th>
			<td style="background-color:#d5dcef" align="center">
				<select name="valTypeTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="chkSel(this,'<%=itemPos%>','TAX')" style="width:100% !important" <%=disabledPP%>>
					<option value="">-- Select--</option>
					<option value="P" selected>IGST</option>
				</select>
			</td>			
			<td style="background-color:#d5dcef" align="center" nowrap>
				<input  type="hidden" name="itemTAXCode<%=itemPos%>"  value="TAX"> 
				    		
				<!--<input type=number name="itemTAX<%=itemPos%>"  style="width:100px;"   size=9  class="form-control" value="0" min="0" onBlur="checkNum(this,'<%=itemPos%>')">-->
				<select name="itemTAX<%=itemPos%>" class="form-control input-sm select2"  onChange="checkNum(this,'<%=itemPos%>','TAX')" style="width:100% !important" <%=disabledPP%>>
					<!--<option value="">-- Select--</option> -->
					<option value="0">0</option>
					<option value="3">3</option>
					<option value="5">5</option>
					<option value="12">12</option>
					<option value="18">18</option>
					<option value="28">28</option>
				</select>				
			</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
			<td style="background-color:#d5dcef" align="center" nowrap><input type=number name="itemTAXVal<%=itemPos%>" style="width:100px;" size=9  class="form-control" value="0" readonly></td>
		</tr>
		
		<tr style="background-color:#00c0ef">
			<td style="width:100px;text-align:center">&nbsp;</td>
			<td colspan=2 style="width:100px;text-align:center"><b>Gross Value</b>&nbsp;</td>
			<td style="background-color:#d5dcef" align="center" nowrap><input type=text name="itemCurr<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=currency%>'  readonly></td>     		
			<td align="center" nowrap><input type=number name="itemGrossVal<%=itemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=totVal%>' readonly></td>
		</tr>		
		

	</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	 
	<div class="row no-print">
	<div class="col-xs-12">
<%	
	if("3".equals(userType) && "Req".equals(reqFrom)) 
	{
%>	
		<button type="button" class="btn btn-primary pull-right" onclick="funUpdate()" style="margin-right: 5px;">Update</button>
<%
	}
	else if("2".equals(userType) && "Apr".equals(reqFrom) || "3".equals(userType) && !"Req".equals(reqFrom)) 
	{
%>
		<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;">ok</button>
	
<%
	}
	else
	{
%>	
	
		<button type="button" class="btn btn-primary pull-right" onclick="funClose()" style="margin-right: 5px;">Save</button>
<%
	}
%>	
		
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
		
		var itemPrice = eval("parent.document.myForm.itemPrice"+itemPos).value;
		eval("document.myForm1.itemPrice"+itemPos).value=itemPrice;		
		
		var itemValObj = eval("parent.document.myForm.itemVal"+itemPos);
		eval("document.myForm1.itemVal"+itemPos).value=parseFloat(itemValObj.value).toFixed(2);	
		
		
		//DISCOUNT
		
		var itemDISCCode = eval("parent.document.myForm.itemDISCCode"+itemPos).value;
		var itemDISC = eval("parent.document.myForm.itemDISC"+itemPos).value;
		var valTypeDISC = eval("parent.document.myForm.valTypeDISC"+itemPos).value;
		var itemDISCValObj = eval("parent.document.myForm.itemDISCVal"+itemPos);
		//alert("itemDISCValObj>>"+itemDISCValObj.value);
		
		eval("document.myForm1.itemDISCCode"+itemPos).value=itemDISCCode;
		eval("document.myForm1.itemDISC"+itemPos).value=itemDISC;
		eval("document.myForm1.valTypeDISC"+itemPos).value=valTypeDISC;
		eval("document.myForm1.itemDISCVal"+itemPos).value=parseFloat(itemDISCValObj.value).toFixed(2);	
		//alert("itemDISCValObj>>"+itemDISCValObj.value);
		
		//PKFW
		
		var itemPKFWCode = eval("parent.document.myForm.itemPKFWCode"+itemPos).value;
		var itemPKFW = eval("parent.document.myForm.itemPKFW"+itemPos).value;
		var valTypePKFW = eval("parent.document.myForm.valTypePKFW"+itemPos).value;
		var itemPKFWValObj = eval("parent.document.myForm.itemPKFWVal"+itemPos);
		
		eval("document.myForm1.itemPKFWCode"+itemPos).value=itemPKFWCode;
		eval("document.myForm1.itemPKFW"+itemPos).value=itemPKFW;
		eval("document.myForm1.valTypePKFW"+itemPos).value=valTypePKFW;
		eval("document.myForm1.itemPKFWVal"+itemPos).value=parseFloat(itemPKFWValObj.value).toFixed(2);	
		
		//FRT
		
		var itemFRTCode = eval("parent.document.myForm.itemFRTCode"+itemPos).value;
		var itemFRT = eval("parent.document.myForm.itemFRT"+itemPos).value;
		var valTypeFRT = eval("parent.document.myForm.valTypeFRT"+itemPos).value;
		var itemFRTValObj = eval("parent.document.myForm.itemFRTVal"+itemPos);
		
		eval("document.myForm1.itemFRTCode"+itemPos).value=itemFRTCode;
		eval("document.myForm1.itemFRT"+itemPos).value=itemFRT;
		eval("document.myForm1.valTypeFRT"+itemPos).value=valTypeFRT;
		eval("document.myForm1.itemFRTVal"+itemPos).value=parseFloat(itemFRTValObj.value).toFixed(2);	
		
		//OTH
		var itemOTHCode = eval("parent.document.myForm.itemOTHCode"+itemPos).value;
		var itemOTH = eval("parent.document.myForm.itemOTH"+itemPos).value;
		var itemOTHValObj = eval("parent.document.myForm.itemOTHVal"+itemPos);
		
		eval("document.myForm1.itemOTHCode"+itemPos).value=itemOTHCode;
		eval("document.myForm1.itemOTH"+itemPos).value=itemOTH;
		eval("document.myForm1.itemOTHVal"+itemPos).value=parseFloat(itemOTHValObj.value).toFixed(2);
		
		//FOB
		
		var itemFOBCode = eval("parent.document.myForm.itemFOBCode"+itemPos).value;
		var itemFOB = eval("parent.document.myForm.itemFOB"+itemPos).value;
		var valTypeFOB = eval("parent.document.myForm.valTypeFOB"+itemPos).value;
		var itemFOBValObj = eval("parent.document.myForm.itemFOBVal"+itemPos);
		
		eval("document.myForm1.itemFOBCode"+itemPos).value=itemFOBCode;
		eval("document.myForm1.itemFOB"+itemPos).value=itemFOB;
		eval("document.myForm1.valTypeFOB"+itemPos).value=valTypeFOB;
		eval("document.myForm1.itemFOBVal"+itemPos).value=parseFloat(itemFOBValObj.value).toFixed(2);			
		
		//BFRT
		
		var itemBFRTCode = eval("parent.document.myForm.itemBFRTCode"+itemPos).value;
		var itemBFRT = eval("parent.document.myForm.itemBFRT"+itemPos).value;
		var valTypeBFRT = eval("parent.document.myForm.valTypeBFRT"+itemPos).value;
		var itemBFRTValObj = eval("parent.document.myForm.itemBFRTVal"+itemPos);
		
		eval("document.myForm1.itemBFRTCode"+itemPos).value=itemBFRTCode;
		eval("document.myForm1.itemBFRT"+itemPos).value=itemBFRT;
		eval("document.myForm1.valTypeBFRT"+itemPos).value=valTypeBFRT;
		eval("document.myForm1.itemBFRTVal"+itemPos).value=parseFloat(itemBFRTValObj.value).toFixed(2);
		
		//INS
		
		var itemINSCode = eval("parent.document.myForm.itemINSCode"+itemPos).value;
		var itemINS = eval("parent.document.myForm.itemINS"+itemPos).value;
		var valTypeINS = eval("parent.document.myForm.valTypeINS"+itemPos).value;
		var itemINSValObj = eval("parent.document.myForm.itemINSVal"+itemPos);
		
		eval("document.myForm1.itemINSCode"+itemPos).value=itemINSCode;
		eval("document.myForm1.itemINS"+itemPos).value=itemINS;
		eval("document.myForm1.valTypeINS"+itemPos).value=valTypeINS;
		eval("document.myForm1.itemINSVal"+itemPos).value=parseFloat(itemINSValObj.value).toFixed(2);	
		
		//SUPPLY PRICE
		var itemSupplyPriceObj = eval("parent.document.myForm.itemSupplyPrice"+itemPos);
		eval("document.myForm1.itemSupplyPrice"+itemPos).value=parseFloat(itemSupplyPriceObj.value).toFixed(2);
		
		//CUSTOMS
		
		var itemCUSTCode = eval("parent.document.myForm.itemCUSTCode"+itemPos).value;
		var itemCUST = eval("parent.document.myForm.itemCUST"+itemPos).value;
		var valTypeCUST = eval("parent.document.myForm.valTypeCUST"+itemPos).value;
		var itemCUSTValObj = eval("parent.document.myForm.itemCUSTVal"+itemPos);
		
		eval("document.myForm1.itemCUSTCode"+itemPos).value=itemCUSTCode;
		eval("document.myForm1.itemCUST"+itemPos).value=itemCUST;
		eval("document.myForm1.valTypeCUST"+itemPos).value=valTypeCUST;
		eval("document.myForm1.itemCUSTVal"+itemPos).value=parseFloat(itemCUSTValObj.value).toFixed(2);		
		
		//SWC
		
		var itemSWCCode = eval("parent.document.myForm.itemSWCCode"+itemPos).value;
		var itemSWC = eval("parent.document.myForm.itemSWC"+itemPos).value;
		var valTypeSWC = eval("parent.document.myForm.valTypeSWC"+itemPos).value;
		var itemSWCValObj = eval("parent.document.myForm.itemSWCVal"+itemPos);
		
		eval("document.myForm1.itemSWCCode"+itemPos).value=itemSWCCode;
		eval("document.myForm1.itemSWC"+itemPos).value=itemSWC;
		eval("document.myForm1.valTypeSWC"+itemPos).value=valTypeSWC;
		eval("document.myForm1.itemSWCVal"+itemPos).value=parseFloat(itemSWCValObj.value).toFixed(2);	
		
	
		
		//CLR
		
		var itemCLRCode = eval("parent.document.myForm.itemCLRCode"+itemPos).value;
		var itemCLR = eval("parent.document.myForm.itemCLR"+itemPos).value;
		var valTypeCLR = eval("parent.document.myForm.valTypeCLR"+itemPos).value;
		var itemCLRValObj = eval("parent.document.myForm.itemCLRVal"+itemPos);
		
		eval("document.myForm1.itemCLRCode"+itemPos).value=itemCLRCode;
		eval("document.myForm1.itemCLR"+itemPos).value=itemCLR;
		eval("document.myForm1.valTypeCLR"+itemPos).value=valTypeCLR;
		eval("document.myForm1.itemCLRVal"+itemPos).value=parseFloat(itemCLRValObj.value).toFixed(2);			
		
		
		//TAX
		
		var itemTAXCode = eval("parent.document.myForm.itemTAXCode"+itemPos).value;
		var itemTAX = eval("parent.document.myForm.itemTAX"+itemPos).value;
		var valTypeTAX = eval("parent.document.myForm.valTypeTAX"+itemPos).value;
		var itemTAXValObj = eval("parent.document.myForm.itemTAXVal"+itemPos);
		
		eval("document.myForm1.itemTAXCode"+itemPos).value=itemTAXCode;
		eval("document.myForm1.itemTAX"+itemPos).value=itemTAX;
		eval("document.myForm1.valTypeTAX"+itemPos).value=valTypeTAX;
		eval("document.myForm1.itemTAXVal"+itemPos).value=parseFloat(itemTAXValObj.value).toFixed(2);	
				
		
		//GROSS VALUE
		var itemGrossVal = eval("parent.document.myForm.itemValue"+itemPos).value;
		//alert("itemGrossVal>>>"+itemGrossVal);
		eval("document.myForm1.itemGrossVal"+itemPos).value=itemGrossVal;		
		//eval("document.myForm1.itemGrossVal"+itemPos).value=(parseFloat(itemSupplyPrice)+parseFloat(itemTAXVal)).toFixed(2);		
		
	}
	function funClose()
	{
		var itemPos=<%=itemPos%>;
		//alert("itemPos>>>"+itemPos);
		
		var itemPriceObj = eval("document.myForm1.itemPrice"+itemPos).value;
		eval("parent.document.myForm.itemPrice"+itemPos).value=itemPriceObj;
		
		var itemValObj = eval("document.myForm1.itemVal"+itemPos).value;
		eval("parent.document.myForm.itemVal"+itemPos).value=itemValObj;
		
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
		
		//OTH
		
		var itemOTH = eval("document.myForm1.itemOTH"+itemPos).value;
		var itemOTHVal = eval("document.myForm1.itemOTHVal"+itemPos).value;
		
		eval("parent.document.myForm.itemOTH"+itemPos).value = itemOTH;
		eval("parent.document.myForm.itemOTHVal"+itemPos).value;		
		
		//FOB
		var itemFOBCode = eval("document.myForm1.itemFOBCode"+itemPos).value;
		var itemFOB = eval("document.myForm1.itemFOB"+itemPos).value;
		var valTypeFOB = eval("document.myForm1.valTypeFOB"+itemPos).value;
		var itemFOBVal = eval("document.myForm1.itemFOBVal"+itemPos).value;
		
		
		
		eval("parent.document.myForm.itemFOBCode"+itemPos).value=itemFOBCode;
		eval("parent.document.myForm.itemFOB"+itemPos).value=itemFOB;
		eval("parent.document.myForm.valTypeFOB"+itemPos).value=valTypeFOB;
		eval("parent.document.myForm.itemFOBVal"+itemPos).value=itemFOBVal;		
		
	
		
		//BFRT
		
		var itemBFRTCode = eval("document.myForm1.itemBFRTCode"+itemPos).value;
		var itemBFRT = eval("document.myForm1.itemBFRT"+itemPos).value;
		var valTypeBFRT = eval("document.myForm1.valTypeBFRT"+itemPos).value;
		var itemBFRTVal = eval("document.myForm1.itemBFRTVal"+itemPos).value;
		
		
		
		eval("parent.document.myForm.itemBFRTCode"+itemPos).value=itemBFRTCode;
		eval("parent.document.myForm.itemBFRT"+itemPos).value=itemBFRT;
		eval("parent.document.myForm.valTypeBFRT"+itemPos).value=valTypeBFRT;
		eval("parent.document.myForm.itemBFRTVal"+itemPos).value=itemBFRTVal;	
		
		//INS
		
		var itemINSCode = eval("document.myForm1.itemINSCode"+itemPos).value;
		var itemINS = eval("document.myForm1.itemINS"+itemPos).value;
		var valTypeINS = eval("document.myForm1.valTypeINS"+itemPos).value;
		var itemINSVal = eval("document.myForm1.itemINSVal"+itemPos).value;
		
		eval("parent.document.myForm.itemINSCode"+itemPos).value=itemINSCode;
		eval("parent.document.myForm.itemINS"+itemPos).value=itemINS;
		eval("parent.document.myForm.valTypeINS"+itemPos).value=valTypeINS;
		eval("parent.document.myForm.itemINSVal"+itemPos).value=itemINSVal;
		
		
		//SUPPLY PRICE
		var itemSupplyPriceObj = eval("document.myForm1.itemSupplyPrice"+itemPos).value;
		eval("parent.document.myForm.itemSupplyPrice"+itemPos).value=itemSupplyPriceObj;
		
		//CUSTOMS
		
		var itemCUSTCode = eval("document.myForm1.itemCUSTCode"+itemPos).value;
		var itemCUST = eval("document.myForm1.itemCUST"+itemPos).value;
		var valTypeCUST = eval("document.myForm1.valTypeCUST"+itemPos).value;
		var itemCUSTVal = eval("document.myForm1.itemCUSTVal"+itemPos).value;
		
		eval("parent.document.myForm.itemCUSTCode"+itemPos).value=itemCUSTCode;
		eval("parent.document.myForm.itemCUST"+itemPos).value=itemCUST;
		eval("parent.document.myForm.valTypeCUST"+itemPos).value=valTypeCUST;
		eval("parent.document.myForm.itemCUSTVal"+itemPos).value=itemCUSTVal;	
		
		//SWC
		
		var itemSWCCode = eval("document.myForm1.itemSWCCode"+itemPos).value;
		var itemSWC = eval("document.myForm1.itemSWC"+itemPos).value;
		var valTypeSWC = eval("document.myForm1.valTypeSWC"+itemPos).value;
		var itemSWCVal = eval("document.myForm1.itemSWCVal"+itemPos).value;
		
		eval("parent.document.myForm.itemSWCCode"+itemPos).value=itemSWCCode;
		eval("parent.document.myForm.itemSWC"+itemPos).value=itemSWC;
		eval("parent.document.myForm.valTypeSWC"+itemPos).value=valTypeSWC;
		eval("parent.document.myForm.itemSWCVal"+itemPos).value=itemSWCVal;
		
		//CLR
		
		var itemCLRCode = eval("document.myForm1.itemCLRCode"+itemPos).value;
		var itemCLR = eval("document.myForm1.itemCLR"+itemPos).value;
		var valTypeCLR = eval("document.myForm1.valTypeCLR"+itemPos).value;
		var itemCLRVal = eval("document.myForm1.itemCLRVal"+itemPos).value;
		
		eval("parent.document.myForm.itemCLRCode"+itemPos).value=itemCLRCode;
		eval("parent.document.myForm.itemCLR"+itemPos).value=itemCLR;
		eval("parent.document.myForm.valTypeCLR"+itemPos).value=valTypeCLR;
		eval("parent.document.myForm.itemCLRVal"+itemPos).value=itemCLRVal;		
		
		
		
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
				
		window.parent.$('#woModal2').modal('hide');
	}
	function funOk()
	{
		window.parent.$('#woModal2').modal('hide');
	}
	function funUpdate()
	{
		var itemPos=<%=itemPos%>;
		//alert("itemPos>>>"+itemPos);
		
		var itemPriceObj = eval("document.myForm1.itemPrice"+itemPos).value;
		eval("parent.document.myForm.itemPrice"+itemPos).value=itemPriceObj;
		
		var itemValObj = eval("document.myForm1.itemVal"+itemPos).value;
		eval("parent.document.myForm.itemVal"+itemPos).value=itemValObj;		
		
		//var itemTotalValObj = eval("document.myForm1.itemTotalVal"+itemPos).value;
		//eval("parent.document.myForm.itemTotalVal"+itemPos).value=itemTotalValObj;
		
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
		
		
		
		//SUPPLY PRICE
		
		var itemSupplyPriceObj = eval("document.myForm1.itemSupplyPrice"+itemPos).value;
		eval("parent.document.myForm.itemSupplyPrice"+itemPos).value=itemSupplyPriceObj;		
		
		
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
		eval("parent.document.myForm.itemGrossVal"+itemPos).value=itemGrossValObj;		
		
		
		
		
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
				//itemDISCObj.removeAttribute('readonly');
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
			if(type=="FOB")
			{
				//alert("Please select the Freight Type");
				var itemFOBObj = eval("document.myForm1.itemFOB"+itemPos);
				var itemFOBValObj = eval("document.myForm1.itemFOBVal"+itemPos);
				itemFOBObj.value="0";
				itemFOBValObj.value="0.00";
				itemFOBObj.focus();								
				//return false;
			}			

			if(type=="BFRT")
			{
				var itemBFRTObj = eval("document.myForm1.itemBFRT"+itemPos);
				var itemBFRTValObj = eval("document.myForm1.itemBFRTVal"+itemPos);
				itemBFRTObj.value="0";
				itemBFRTValObj.value="0.00";
				itemBFRTObj.focus();								
				
			}			
			if(type=="INS")
			{
				var itemINSObj = eval("document.myForm1.itemINS"+itemPos);
				var itemINSValObj = eval("document.myForm1.itemINSVal"+itemPos);
				itemINSObj.value="0";
				itemINSValObj.value="0.00";
				itemINSObj.focus();								
				
			}
			if(type=="CUST")
			{
				var itemCUSTObj = eval("document.myForm1.itemCUST"+itemPos);
				var itemCUSTValObj = eval("document.myForm1.itemCUSTVal"+itemPos);
				itemCUSTObj.value="0";
				itemCUSTValObj.value="0.00";
				itemCUSTObj.focus();								
				
			}
			if(type=="SWC")
			{
				var itemSWCObj = eval("document.myForm1.itemSWC"+itemPos);
				var itemSWCValObj = eval("document.myForm1.itemSWCVal"+itemPos);
				itemSWCObj.value="0";
				itemSWCValObj.value="0.00";
				itemSWCObj.focus();								
				
			}
			if(type=="CLR")
			{
				var itemCLRObj = eval("document.myForm1.itemCLR"+itemPos);
				var itemCLRValObj = eval("document.myForm1.itemCLRVal"+itemPos);
				itemCLRObj.value="0";
				itemCLRValObj.value="0.00";
				itemCLRObj.focus();								
				
			}			
			
			if(type=="TAX")
			{
				//alert("Please select the Freight Type");
				var itemTAXObj = eval("document.myForm1.itemTAX"+itemPos);
				var itemTAXValObj = eval("document.myForm1.itemTAXVal"+itemPos);
				itemTAXObj.value="0";
				itemTAXValObj.value="0.00";
				itemTAXObj.focus();								
				//return false;
			}			
		}
		
		/*

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
			
		}	*/
		
		if(type=="FOB")
		{
			//alert("Please select the Freight Type");
			var itemFOBObj = eval("document.myForm1.itemFOB"+itemPos);
			var itemFOBValObj = eval("document.myForm1.itemFOBVal"+itemPos);
			itemFOBObj.value="0";
			itemFOBValObj.value="0.00";
			itemFOBObj.focus();								
			//return false;
		}
		
		if(type=="BFRT")
		{
			var itemBFRTObj = eval("document.myForm1.itemBFRT"+itemPos);
			var itemBFRTValObj = eval("document.myForm1.itemBFRTVal"+itemPos);
			itemBFRTObj.value="0";
			itemBFRTValObj.value="0.00";
			itemBFRTObj.focus();								

		}			
		if(type=="INS")
		{
			var itemINSObj = eval("document.myForm1.itemINS"+itemPos);
			var itemINSValObj = eval("document.myForm1.itemINSVal"+itemPos);
			itemINSObj.value="0";
			itemINSValObj.value="0.00";
			itemINSObj.focus();								

		}
		if(type=="CUST")
		{
			var itemCUSTObj = eval("document.myForm1.itemCUST"+itemPos);
			var itemCUSTValObj = eval("document.myForm1.itemCUSTVal"+itemPos);
			itemCUSTObj.value="0";
			itemCUSTValObj.value="0.00";
			itemCUSTObj.focus();								

		}
		if(type=="SWC")
		{
			var itemSWCObj = eval("document.myForm1.itemSWC"+itemPos);
			var itemSWCValObj = eval("document.myForm1.itemSWCVal"+itemPos);
			itemSWCObj.value="0";
			itemSWCValObj.value="0.00";
			itemSWCObj.focus();								

		}
		if(type=="CLR")
		{
			var itemCLRObj = eval("document.myForm1.itemCLR"+itemPos);
			var itemCLRValObj = eval("document.myForm1.itemCLRVal"+itemPos);
			itemCLRObj.value="0";
			itemCLRValObj.value="0.00";
			itemCLRObj.focus();								

		}

	}
	function checkNum(fieldObj,itemPos,type)
	{
		
		var fieldVal = fieldObj.value;
		//alert("fieldVal>>"+fieldVal);

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
			
			//DISC
			
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
			
			//PKFW
			
			var itemPKFWObj = eval("document.myForm1.itemPKFW"+itemPos);
			var valTypePKFWObj = eval("document.myForm1.valTypePKFW"+itemPos);
			var itemPKFWValObj = eval("document.myForm1.itemPKFWVal"+itemPos);
			
			if(valTypePKFWObj.value == "P")
				itemPKFWValObj.value = (((itemValObj.value-itemDISCValObj.value) * itemPKFWObj.value)/100).toFixed(2);
			else if(valTypePKFWObj.value=="V")
				itemPKFWValObj.value = itemPKFWObj.value;
			else if(valTypePKFWObj.value=="Q")	
				itemPKFWValObj.value = itemPKFWObj.value * parseFloat(itemQtyObj.value) ;
				
			//FRT
			
			var itemFRTObj = eval("document.myForm1.itemFRT"+itemPos);
			var valTypeFRTObj = eval("document.myForm1.valTypeFRT"+itemPos);
			var itemFRTValObj = eval("document.myForm1.itemFRTVal"+itemPos);
			
			
			if(valTypeFRTObj.value == "P")
				itemFRTValObj.value = (((itemValObj.value-itemDISCValObj.value) * itemFRTObj.value)/100).toFixed(2);
			else if(valTypeFRTObj.value=="V")
				itemFRTValObj.value = itemFRTObj.value;
			else if(valTypeFRTObj.value=="Q")	
				itemFRTValObj.value = itemFRTObj.value * parseFloat(itemQtyObj.value);	
				
			//OTH
			var itemOTHObj = eval("document.myForm1.itemOTH"+itemPos);
			var itemOTHValObj = eval("document.myForm1.itemOTHVal"+itemPos);
				itemOTHValObj.value = parseFloat(itemOTHObj.value).toFixed(2);
				
			//BUYER ENTERY
			
			//FOB	
	
			var itemFOBObj = eval("document.myForm1.itemFOB"+itemPos);
			var valTypeFOBObj = eval("document.myForm1.valTypeFOB"+itemPos);
			
			if(type== "FOB")
			{
				if(valTypeFOBObj.value == "" && itemFOBObj.value > 0)
				{
					alert("Please Select FOB Type");
					itemFOBObj.value=0;
					return;
				}				
			}			
			var itemFOBValObj = eval("document.myForm1.itemFOBVal"+itemPos);

			if(valTypeFOBObj.value == "P")
				itemFOBValObj.value = (((itemValObj.value-itemDISCValObj.value) * itemFOBObj.value)/100).toFixed(2);
			else if(valTypeFOBObj.value=="V")
				itemFOBValObj.value = itemFOBObj.value;
			else if(valTypeFOBObj.value=="Q")	
				itemFOBValObj.value = itemFOBObj.value * parseFloat(itemQtyObj.value);	
					
						
				
			//BFRT	
				
			var itemBFRTObj = eval("document.myForm1.itemBFRT"+itemPos);
			var valTypeBFRTObj = eval("document.myForm1.valTypeBFRT"+itemPos);
			if(type== "BFRT")
			{
				if(valTypeBFRTObj.value == "" && itemBFRTObj.value > 0)
				{
					alert("Please Select Freight Type");
					itemBFRTObj.value=0;
					return;
				}				
			}			
			var itemBFRTValObj = eval("document.myForm1.itemBFRTVal"+itemPos);
			
			
			if(valTypeBFRTObj.value == "P")
				itemBFRTValObj.value = (((itemValObj.value-itemDISCValObj.value) * itemBFRTObj.value)/100).toFixed(2);
			else if(valTypeBFRTObj.value=="V")
				itemBFRTValObj.value = itemBFRTObj.value;
			else if(valTypeBFRTObj.value=="Q")	
				itemBFRTValObj.value = itemBFRTObj.value * parseFloat(itemQtyObj.value);					
			
			
			//INS
			
			var itemINSObj = eval("document.myForm1.itemINS"+itemPos);
			var valTypeINSObj = eval("document.myForm1.valTypeINS"+itemPos);
			
			if(type== "INS")
			{
				if(valTypeINSObj.value == "" && itemINSObj.value > 0)
				{
					alert("Please Select Insurance Type");
					itemINSObj.value=0;
					return;
				}				
			}			
			var itemINSValObj = eval("document.myForm1.itemINSVal"+itemPos);
			
			
			if(valTypeINSObj.value == "P")
				itemINSValObj.value = (((itemValObj.value-itemDISCValObj.value) * itemINSObj.value)/100).toFixed(2);
			else if(valTypeINSObj.value=="Q")	
				itemINSValObj.value = itemINSObj.value * parseFloat(itemQtyObj.value);					
				
			
			var itemSupplyPriceObj=eval("document.myForm1.itemSupplyPrice"+itemPos);
			itemSupplyPriceObj.value = parseFloat(itemValObj.value) - parseFloat(itemDISCValObj.value)+ parseFloat(itemPKFWValObj.value) + parseFloat(itemFRTValObj.value)+ parseFloat(itemOTHValObj.value)+ parseFloat(itemFOBValObj.value)+ parseFloat(itemBFRTValObj.value)+ parseFloat(itemINSValObj.value);
			itemSupplyPriceObj.value = parseFloat(itemSupplyPriceObj.value).toFixed(2);
			
			//CUSTOMS
			var valTypeCUSTObj = eval("document.myForm1.valTypeCUST"+itemPos);
			var itemCUSTObj=eval("document.myForm1.itemCUST"+itemPos);
			
			if(type== "CUST")
			{
				if(valTypeCUSTObj.value == "" && itemCUSTObj.value > 0)
				{
					alert("Please Select Customs Type");
					itemCUSTObj.value=0;
					return;
				}				
			}			
			var itemCUSTValObj=eval("document.myForm1.itemCUSTVal"+itemPos);
			
				if(valTypeCUSTObj.value == "P")
					itemCUSTValObj.value = (((itemSupplyPriceObj.value)* itemCUSTObj.value)/100).toFixed(2); 
			
			//SWC
			var valTypeSWCObj = eval("document.myForm1.valTypeSWC"+itemPos);
			var itemSWCObj=eval("document.myForm1.itemSWC"+itemPos);
			if(type== "SWC")
			{
				if(valTypeSWCObj.value == "" && itemSWCObj.value > 0)
				{
					alert("Please Select SWC Type");
					itemSWCObj.value=0;
					return;
				}				
			}			
			var itemSWCValObj=eval("document.myForm1.itemSWCVal"+itemPos);
				if(valTypeSWCObj.value == "P")
					itemSWCValObj.value = (((itemCUSTValObj.value)* itemSWCObj.value)/100).toFixed(2); 	
			//CLR
			var valTypeCLRObj = eval("document.myForm1.valTypeCLR"+itemPos);
			var itemCLRObj=eval("document.myForm1.itemCLR"+itemPos);
			
			if(type== "CLR")
			{
				if(valTypeCLRObj.value == "" && itemCLRObj.value > 0)
				{
					alert("Please Select Clearing Type");
					itemCLRObj.value=0;
					return;
				}				
			}			
			
			var itemCLRValObj=eval("document.myForm1.itemCLRVal"+itemPos);
			if(valTypeCLRObj.value == "P")
				itemCLRValObj.value = (((parseFloat(itemSupplyPriceObj.value) + parseFloat(itemCUSTValObj.value) +parseFloat(itemSWCValObj.value))* parseFloat(itemCLRObj.value))/100).toFixed(2); 						
			if(valTypeCLRObj.value== "V")
				itemCLRValObj.value = parseFloat(itemCLRObj.value).toFixed(2);						
			
			
			//TAX
			var valTypeTAXObj = eval("document.myForm1.valTypeTAX"+itemPos);
			var itemTAXObj=eval("document.myForm1.itemTAX"+itemPos);
			
			if(type== "TAX")
			{
				if(valTypeTAXObj.value == "" && itemTAXObj.value > 0)
				{
					alert("Please Select Tax Type");
					itemTAXObj.value=0;
					return;
				}				
			}			
			
			var itemTAXValObj = eval("document.myForm1.itemTAXVal"+itemPos);
			itemTAXValObj.value = (((parseFloat(itemSupplyPriceObj.value) + parseFloat(itemCUSTValObj.value) +parseFloat(itemSWCValObj.value))* parseFloat(itemTAXObj.value))/100).toFixed(2); 						
			
			var itemGrossValObj=eval("document.myForm1.itemGrossVal"+itemPos);
			itemGrossValObj.value = (parseFloat(itemSupplyPriceObj.value)+parseFloat(itemCUSTValObj.value)+parseFloat(itemSWCValObj.value)+ parseFloat(itemCLRValObj.value) +parseFloat(itemTAXValObj.value)).toFixed(2) ;
			itemGrossValObj.value = parseFloat(itemGrossValObj.value).toFixed(2);
	
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