<%@ include file="../../../Includes/JSPs/Labels/iPlantAddress_Labels.jsp"%> 
<%//@ include file="../../../Includes/JSPs/Misc/iRFCReadCommon.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<%//@ include file="ezUserDefaults.jsp" %> 
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
<%

	String rfqNo=request.getParameter("rfqNo");
	String rfqItem=request.getParameter("rfqItem");	
	String itemPos=request.getParameter("itemPos");
	String vendCat=request.getParameter("vendCat");
	String reqFrom=request.getParameter("reqFrom");
	String userType=request.getParameter("userType");
	
	String readonly="readonly";
	if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom))) 
	{
		readonly="";
	}	
	
	
	ezc.ezparam.ReturnObjFromRetrieve qtyRet = null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
	//miscTableRow1.setQuery(dbInsQry);
	miscTableRow1.setQuery("SELECT * FROM EZC_RFQ_SERVICES WHERE ERS_SRV_RFQ='"+rfqNo+"' AND ERS_SRV_RFQ_ITEM='"+rfqItem+"'");
	miscTable.appendRow(miscTableRow1);
	mainParams.setLocalStore("Y"); 
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		 qtyRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
	}
	catch(Exception e)
	{
	}
	ezc.ezcommon.EzLog4j.log("** qtyRet11>>>"+qtyRet.getRowCount(),"I");
	
		
	String ibdQty="0";
	int qtyRetCnt = 0;
	if(qtyRet!=null)
	{
		qtyRetCnt = qtyRet.getRowCount();
		
	}	
	ezc.ezcommon.EzLog4j.log("** qtyRetCntservices>>>"+qtyRetCnt,"I");
			

%>
<Html>
<head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
</head>
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
<div id="woModalPop" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="220" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
        <span style="color:rgba(219, 143, 29, 0.808);">
          <h4><B>
            Services for RFQ:<span style="color:cornflowerblue;"><%=rfqNo%></span> with Line Item: <span style="color:cornflowerblue;"><%=rfqItem%></span>
          </B></h4>
        </section>

        <!-- Main content -->
        <section class="content">
        </head>
        <body onLoad="loadValues1()">
        <form name="myForm1"  method="post">
        <div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
<%
	if (qtyRetCnt==0)
	{
		String noDataStatement = "No Service Line(s) againt selected RFQ Line Item";
%>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>


<%
	}
	else{
%>
	<table class="table table-bordered">
		 <tr align="center">
			<th align="left">Line</th>
			<th align="left">Service No</th>
			<th align="left">Short Text</th>
			<!--<th align="left">Service Text</th>
			<th align="left">Line Text</th> -->
			<th align="left">Quantity</th>
			<th align="left">UOM</th>
			<!--<th align="left">SAC Code</th>
			<th align="left">GST</th> -->
			<th align="left">Unit Price</th>
			<th align="left">Total Price</th>
			<!--<th align="left">GST Value</th>-->
	    	 </tr>
<%

		ReturnObjFromRetrieve retGST = null;	
		
		String  servText="",lineText="";
		double  itemTotVal = 0.0;
		double  itemTotalGSTVal = 0.0;
		
		for(int i=0;i<qtyRetCnt;i++)
		{ 
			String actNum ="000000000000000000"+qtyRet.getFieldValueString(i,"ERS_SRV_ACT");
			String serItemQty = qtyRet.getFieldValueString(i,"ERS_SRV_QTY");
			try
			{
				serItemQty = (Double.parseDouble(serItemQty))+"";
				serItemQty  = new java.math.BigDecimal(serItemQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString(); 

			}catch(Exception e){} 
			
			String serSAC	  = qtyRet.getFieldValueString(i,"ERS_SRV_SAC");
			String serGST     = qtyRet.getFieldValueString(i,"ERS_SRV_GST");
			String serPrice   = new java.math.BigDecimal(qtyRet.getFieldValueString(i,"ERS_SRV_PRICE")).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			
			String itemValue  = "0";
			String itemGST  = "0";
			try
			{
				itemValue = (Double.parseDouble(serItemQty) * Double.parseDouble(serPrice))+"";
				itemValue  = new java.math.BigDecimal(itemValue).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();

			}catch(Exception e)
			{
				itemValue="0";
			}
			try
			{
				itemGST = (Double.parseDouble(itemValue) * Double.parseDouble(serGST)/100)+"";
				itemGST  = new java.math.BigDecimal(itemGST).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();

			}catch(Exception e)
			{
				itemGST="0";
			}			
			itemTotVal 	= itemTotVal+ Double.parseDouble(itemValue);
			itemTotalGSTVal = itemTotalGSTVal + Double.parseDouble(itemGST);
			
			String servActive="";
			String lineActive="";
			
			servText=checkNull(qtyRet.getFieldValueString(i,"ERS_SRV_ITEM_TEXT"));
			ezc.ezcommon.EzLog4j.log("servText:::::::::::::::"+servText,"I");
			servText = servText.replaceAll("'","`");
			servText = servText.replaceAll("\"", "`");
			servText = servText.replaceAll("$", "");
			servText = servText.replaceAll("&", "?");
			servText = servText.replaceAll("<", "&lt;");
			servText = servText.replaceAll("#", "");
			servText = servText.replaceAll("\\(", "");
			servText = servText.replaceAll("\\)", "");
			servText = servText.replaceAll("=", "");			
			servText = servText.trim();
			
			lineText=checkNull(qtyRet.getFieldValueString(i,"ERS_SRV_LINE_TEXT")); 
			lineText = lineText.replaceAll("'","`");
			lineText = lineText.replaceAll("\"", "`");
			lineText = lineText.replaceAll("$", "");
			lineText = lineText.replaceAll("&", "?");
			lineText = lineText.replaceAll("<", "&lt;");
			lineText = lineText.replaceAll("#", "");
			lineText = lineText.replaceAll("\\(", "");
			lineText = lineText.replaceAll("\\)", "");
			lineText = lineText.replaceAll("=", ""); 
			lineText = lineText.trim();			

			
			servActive="color:blue";
			lineActive="color:blue";
			
			if(servText!=null && !"null".equals(servText) && !"".equals(servText) && servText!="")
				servActive="color:orange";
				
			if(lineText!=null && !"null".equals(lineText) && !"".equals(lineText) && lineText!="")
				lineActive="color:orange";	
				
			String servAct  = "";
			try
			{
				servAct  = Long.parseLong(qtyRet.getFieldValueString(i,"ERS_SRV_ACT"))+"";
			}
			catch(Exception e)	
			{
				servAct  = "";
			}
			
		
%>		

        		<tr>
        			<input type=hidden name="serItem" value="<%=i%>">
        			<td align="center"><%=Long.parseLong(qtyRet.getFieldValueString(i,"ERS_SRV_LINE"))%><input type="hidden" name="serLine<%=i%>" value="<%=Long.parseLong(qtyRet.getFieldValueString(i,"ERS_SRV_LINE"))%>"></td>
        			<td align="center"><%=servAct%></td>
        			<td align="center"><%=qtyRet.getFieldValueString(i,"ERS_SRV_DESC")%></td>
				<td align="center"><%=serItemQty%><input type="hidden" name="serItemQty<%=i%>" value="<%=serItemQty%>"></td>
        			<td align="center"><%=qtyRet.getFieldValueString(i,"ERS_SRV_UOM")%></td>
        			<td align="center"><input type=number name="serItemPrice<%=i%>" style="width:100px;"  size=9 min="0"  class="form-control" value="<%=serPrice%>" onchange="checkNum1(this,'<%=i%>')" <%=readonly%>></td>
        			<td align="center"><input type="number" name="itemValue<%=i%>" style="width:100px;" size=9  class="form-control" value="<%=itemValue%>" readonly></td>
        		</tr>	
<%
		}
%>
			<tr>
				<th colspan="6">Total Value</th>
				<td align="center"><input type=number name="itemTotVal" style="width:100px;" size=9 class="form-control"   value="<%=new java.math.BigDecimal(itemTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString()%>" readonly></td>		
				<!--<td align="center"><%=new java.math.BigDecimal(itemTotVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString()%></td>		
				<td><%=new java.math.BigDecimal(itemTotalGSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString()%></td>-->
			</tr>
       	 </table>

	<br>
	<div class="row" align="right">
	    <button type="button" class="btn btn-primary pull-right" onclick="funClose()"  style="margin-right: 5px;">Close</button>

<%
	}
	if(("3".equals(userType) && "Req".equals(reqFrom)) || ("4".equals(userType) && "Req".equals(reqFrom))) 
	{
%>
		<button type="button" class="btn btn-primary pull-right" onclick="funUpdate()"  style="margin-right: 5px;">Update</button>
<%
	}
%>


</div>
</div></div></div></div>
</section><!-- /.content -->
</div><!-- /.content-wrapper --> 
<script>
function loadValues1()
{
	//alert("loadValues1>>>");
	var rfqItem=<%=rfqItem%>;
	//alert("rfqItem>>>"+rfqItem);
	var serPrice = eval("parent.document.myForm.serPrice"+rfqItem).value;
	//alert("rfqItem>>>"+rfqItem);
	var serQty = eval("parent.document.myForm.serQty"+rfqItem).value;

	//alert("serPrice>>>"+serPrice);
	//alert("serQty>>>"+serQty);

	var totalVal=0;
	

	if(serQty!="") 
	{
		var len = 0;
		 if(serQty.lastIndexOf("##")!=-1) 
			len=serQty.split("##").length;
		 else
			len= 1;

		 if(len == 1)
		 {
			eval("document.myForm1.serItemQty"+0).value = serQty;
			eval("document.myForm1.serItemPrice"+0).value = serPrice;
			
			var itemValObj   = eval("document.myForm1.itemValue"+0);
			itemValObj.value = (parseFloat(serQty)*parseFloat(serPrice)).toFixed(2); 

			totalVal= (parseFloat(totalVal)+ parseFloat(itemValObj.value)).toFixed(2); 
			

		 }
		 else
		 {
			for(i=0;i<len;i++)
			{
				eval("document.myForm1.serItemQty"+i).value = serQty.split("##")[i];
				eval("document.myForm1.serItemPrice"+i).value = serPrice.split("##")[i];
				
				var itemValObj   = eval("document.myForm1.itemValue"+i);
				itemValObj.value = (parseFloat(serQty.split("##")[i])*parseFloat(serPrice.split("##")[i])).toFixed(2); 					

				totalVal= (parseFloat(totalVal)+ parseFloat(itemValObj.value)).toFixed(2); 
			}
		 }
		 eval("document.myForm1.itemTotVal").value = totalVal;
		 
	}	 
}
function checkNum1(fieldObj,itemPos)
{
	var fieldVal = fieldObj.value;
	var Count='<%=qtyRetCnt%>';
	var totalVal=0;
	var totalGSTVal=0;
	for(var line=0;line<Count;line++)
	{
		var itemQtyObj   = eval("document.myForm1.serItemQty"+line);
		//alert("itemQtyObj>>>"+itemQtyObj.value);
		var itemPriceObj = eval("document.myForm1.serItemPrice"+line);
		//alert("itemPriceObj>>>"+itemPriceObj.value);
		
		if(itemPriceObj.value!='')
		{

			eval("document.myForm1.itemValue"+line).value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2); 
			var itemValObj   = eval("document.myForm1.itemValue"+line);
			
			totalVal=(parseFloat(itemValObj.value)+parseFloat(totalVal)).toFixed(2); 
			var itemTotValObj = eval("document.myForm1.itemTotVal");
			itemTotValObj.value=totalVal;
		}
	}
}
function funClose()
{
   window.parent.$('#woModalSer').modal('hide');
   parent.$.fancybox.close();
} 
function openItemDet(req,item,mat,text,type)
{ 
	var url="ezItemTextPopup.jsp?req="+req+"&item="+item+"&mat="+mat+"&text="+text+"&type="+type;      

	$('iframe').attr("src",url);
	$('#woModalPop').modal({show:true});
	$('.modal-dialog').draggable({
			    handle: ".modal-body"        
	});   		

}
function funUpdate()
{
	var rfqItem=<%=rfqItem%>;
	//alert("rfqItem>>>"+rfqItem); 
	var itemPos=<%=itemPos%>;
	//alert("itemPos>>>"+itemPos); 
	
	var allSerLine;
	var allSerPrice;
	var allSerQty;
	
	var serItemObj  = document.myForm1.serItem;
	var len = serItemObj.length;	
	//alert("len>>>"+len);
	
	var totalVal= 0.0;
	
	if(isNaN(len))
	{
	
		var serItemNo = document.myForm1.serItem.value;
		var serLine = eval("document.myForm1.serLine"+serItemNo).value;
		var serPrice = eval("document.myForm1.serItemPrice"+serItemNo).value;
		var serQty = eval("document.myForm1.serItemQty"+serItemNo).value;
		
		if(eval("document.myForm1.serItemPrice"+serItemNo).value<="0")
		{
			alert("Please Enter Positive Number for the line item:"+serLine);
			eval("document.myForm1.serItemPrice"+serItemNo).focus();
			return false;
		}
		var itemTotValObj = eval("document.myForm1.itemTotVal");
		totalVal=(parseFloat(itemTotValObj.value)).toFixed(2); 
		//alert("totalVal>>>"+totalVal);
	
		allSerLine=serLine;
		allSerPrice= serPrice;
		allSerQty = serQty;

		
	}
	else
	{
		for(var i=0;i<len;i++)
		{	
			var serItemNo = document.myForm1.serItem[i].value;
			var serLine = eval("document.myForm1.serLine"+serItemNo).value;
			var serPrice = eval("document.myForm1.serItemPrice"+serItemNo).value;
			var serQty   = eval("document.myForm1.serItemQty"+serItemNo).value;
			
			if(eval("document.myForm1.serItemPrice"+serItemNo).value<="0")
			{
				alert("Please Enter Positive Number for the line item:"+serLine);
				eval("document.myForm1.serItemPrice"+serItemNo).focus();
				return false;
			}	
			var itemTotValObj = eval("document.myForm1.itemTotVal");
			totalVal=(parseFloat(itemTotValObj.value)).toFixed(2); 
			
			if(i==0)
			{
				allSerLine= serLine;
				allSerPrice= serPrice;			
				allSerQty = serQty;
			}
			else
			{
				allSerLine= allSerLine+"##"+serLine;
				allSerPrice= allSerPrice+"##"+serPrice;	
				allSerQty = allSerQty+"##"+serQty;
			}

		}
	}
		//alert("allSerLine11>>>"+allSerLine);
		//alert("allSerPrice11>>>"+allSerPrice);
		//alert("allSerQty11>>>"+allSerQty);
		//alert("rfqItem11>>>"+rfqItem);

		var itemTotalVal = (parseFloat(itemTotalVal)+parseFloat(totalVal)).toFixed(2); 
		//alert("itemTotalVal after>>>>"+itemTotalVal);
		eval("parent.document.myForm.itemPrice"+itemPos).value=totalVal;
		eval("parent.document.myForm.itemValue"+itemPos).value=totalVal;
		eval("parent.document.myForm.itemTotalVal"+itemPos).value=itemTotalVal;
		var serPriceObj = eval("parent.document.myForm.itemPrice"+itemPos); 
		
		//LOAD VALUES
		eval("parent.document.myForm.serLine"+rfqItem).value=allSerLine;
		eval("parent.document.myForm.serPrice"+rfqItem).value=allSerPrice;
		eval("parent.document.myForm.serQty"+rfqItem).value=allSerQty;
		
		window.parent.checkNum(serPriceObj,itemPos);
		window.parent.$('#woModalSer').modal('hide');
		parent.$.fancybox.close();
	
	
}	

</script>  
   </form>
	</Body>
</Html>

 