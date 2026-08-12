<%@ page import="java.util.*,java.text.*" %> 
<%@ page import = "ezc.ezutil.FormatDate"%>  

<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
           
<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*,java.math.*" %>

<%
	int tempPOLinesCnt=0;
	session.putValue("PO_CREATE","");
	String [] auctChkVal=request.getParameter("auctChkVal").split("#");
	String auctionId=auctChkVal[0];
	String supplierId=auctChkVal[1];
	ReturnObjFromRetrieve retAuctionHeader= ezMiscSelect(Session,"SELECT * FROM EZC_AUCTION_HEADER WHERE EAH_AUCTION_ID='"+auctionId+"'");
	ReturnObjFromRetrieve retAuctionItems= ezMiscSelect(Session,"SELECT  * FROM EZC_AUCTION_ITEM A,EZC_AUCTION_RECOMMENDED_ITEMS B WHERE A.EAI_AUCTION_ID=B.EARI_AUCTION_ID AND A.EAI_ITEM_ID=B.EARI_ITEM_ID AND B.EARI_PO_QTY > 0 AND (B.EARI_PO_CR_QTY IS NULL OR B.EARI_PO_QTY-B.EARI_PO_CR_QTY > 0) AND B.EARI_SUPPLIER_ID='"+supplierId+"' and a.EAI_AUCTION_ID='"+auctionId+"'");
	ReturnObjFromRetrieve retAuctionSuppliers= ezMiscSelect(Session,"SELECT  * FROM EZC_AUCTION_SUPPLIER WHERE EAS_AUCTION_ID='"+auctionId+"' AND EAS_SUPPLIER_ID='"+supplierId+"'");
	ReturnObjFromRetrieve retItemMinValues= ezMiscSelect(Session,"SELECT EAH_ITEM_ID,MIN(EAH_AUCTION_VALUE) AS MINVAL FROM EZC_AUCTION_HISTORY WHERE EAH_SUPPLIER_ID='"+supplierId+"' AND EAH_AUCTION_ID='"+auctionId+"' GROUP BY EAH_ITEM_ID");
	Hashtable<String,BigDecimal> htItemMinVal=new Hashtable<String,BigDecimal>();
	
	int retAuctionItemsCnt = 0;
	
	if(retAuctionItems != null)
		retAuctionItemsCnt = retAuctionItems.getRowCount();
		
	int retItemMinValuesCnt = 0;
		
	if(retItemMinValues != null)
		retItemMinValuesCnt = retItemMinValues.getRowCount();
	
	for(int i=0;i<retItemMinValuesCnt;i++)
	{
		htItemMinVal.put(retItemMinValues.getFieldValueString(i,"EAH_ITEM_ID"),(BigDecimal)retItemMinValues.getFieldValue(i,"MINVAL"));
	}

%>

<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786; 
	
}
</style>
 	
<%

   ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
   java.util.Date today = new java.util.Date();
   //out.println("today>>"+today); 
   
  
	String display_header ="";
	if("2".equals(userType))
	{
		display_header	= "PO Creation - Confirmation"; 
		
	}

	int purLength  = purGrpObj.getRowCount();
	int pOrgLength = purOrgObj.getRowCount();
	int ccLength   = ccObj.getRowCount();
	int pmntLen   = pmntObj.getRowCount();
	int incoLen   = incoObj.getRowCount();	
	boolean isServicePO=(!"RM_PM".equals(retAuctionHeader.getFieldValueString(0,"EAH_CATEGORY")));
	
	
%>
<style>
div.tooltip
{
    word-wrap:  break-word;
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      <%=display_header%>
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->
      <form name="myForm" method="post">
         <div class="box-body table-responsive no-padding">
            <div class="box-body"> 

<table class="table table-bordered" >
	<tr><th colspan=4>Header</th></tr>
	<tr>
	<Th align="left" >Auction Id </Th>
				
		<Td>
			<%=auctionId%>
		</Td>
	
	<Th align="left" >Vendor </Th>
					
			<Td>
				<%=retAuctionSuppliers.getFieldValueString(0,"EAS_SUPPLIER_CODE")+"["+retAuctionSuppliers.getFieldValueString(0,"EAS_EXT1")+"]"%>
			</Td>
	</tr>
	<tr>
		<Th align="left" >Purchase Group </Th>
		<Td>
			
			<select name="purGroup" id="purGroup" class="form-control select2" style="width:100% !important">
			<option value="">Select Purchase Group</option>
			
			<!--<input class="form-control  input-sm" type="text" name="purGroup" id="purGroup" value="<%=(String)request.getParameter("purGrp")%>" readonly>-->			
<%
			String selPurGrp="";
			//out.println("::::gv_PurGrpVect::::::"+gv_PurGrpVect);
			String proj="PROJECTS";
			//out.println("<option value="+proj+">"+proj+"->"+proj+"</option>");	
			for(int j=0;j<purLength;j++)
			{							    
				String purGrpFlg= "";
				if(selPurGrp.equals(purGrpObj.getFieldValueString(j,"VALUE1")))
					purGrpFlg = "selected";
				//out.println("purGrpObj>>"+purGrpObj.getFieldValueString(j,"EMKV_KEY").trim());
				//if(gv_PurGrpVect.contains(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))
				
				//if(purGrpHT.containsKey(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))
				{
					out.println("<option "+purGrpFlg+" value="+purGrpObj.getFieldValueString(j,"VALUE1").trim()+">"+purGrpObj.getFieldValueString(j,"VALUE1").trim()+"->"+purGrpObj.getFieldValueString(j,"VALUE2")+"</option>");
				}
				//else
					//continue;
				
			}
%>		
			</select>
			
 		</Td>
<%
		String plant=retAuctionHeader.getFieldValueString(0,"EAH_PLANT");
		//TO Fetch Purchase Org  and Company Code  based on Plant
		String logonSite = (String)session.getValue("SITE");
		String [] outputFeilds = null;
		String [] queryValues = null;
		
		queryValues =new String[]{"WERKS EQ '"+plant+"'"}; 
		outputFeilds =new String[]{"EKORG"};
		
		ReturnObjFromRetrieve retPOrg = readRFCTable(logonSite,"T024W",outputFeilds,queryValues);
		String selPOrg = retPOrg.getFieldValueString(0,"EKORG");
		ezc.ezcommon.EzLog4j.log("::selPOrg:::"+selPOrg,"I");		
		
		queryValues =new String[]{"BWKEY EQ '"+plant+"'"}; 		
		outputFeilds =new String[]{"BUKRS"};
		
		ReturnObjFromRetrieve retCC = readRFCTable(logonSite,"T001K",outputFeilds,queryValues);
		String selCC = retCC.getFieldValueString(0,"BUKRS");
		ezc.ezcommon.EzLog4j.log("::selCC:::"+selCC,"I");	
%> 		
		
		
		<Th align="left" >Purchase Org </Th>
			
		<Td>
			
			<select name="purOrg" id="purOrg" class="form-control" style="width:90% !important" >  
<%
				for(int j=0;j<pOrgLength;j++)
				{
					String purOrgFlg= "selected";
					if(selPOrg.equals(purOrgObj.getFieldValueString(j,"EMKV_KEY")))
						out.println("<option "+purOrgFlg+" value="+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+purOrgObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					//else	
						//out.println("<option value="+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+purOrgObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
				}
%>				
			</select>
		</Td>
		</tr>
		<tr>
		<Th align="left" >Company Code </Th>
		<Td>
			
			<select name="compCode" id="compCode" class="form-control" style="width:100% !important" >  
<%
				for(int j=0;j<ccLength;j++)
				{
					String ccFlg= "selected";
					if(selCC.equals(ccObj.getFieldValueString(j,"EMKV_KEY")))
						out.println("<option "+ccFlg+" value="+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+ccObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					//else	
						//out.println("<option  value="+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+ccObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
				}
%>					

			</select>
			
		</Td>
	<Th align="left">Payment Terms</Th>
	<Td>
			<select name="PaymentTerms" class="form-control select2" style="width:100% !important">
			<option value="">Select Payment Terms</option>
<%
			for(int j=0;j<pmntLen;j++)
			{
				out.println("<option value="+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+pmntObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>					

 	 		</select>
			
	</td>
	</tr>
	<tr>
	<Th align="left">Inco Terms</Th>
	<Td>
			<select name="IncoTerms" class="form-control select2" style="width:100% !important">
			<option value="">Select Inco Terms</option>
<%
			for(int j=0;j<incoLen;j++)
			{
				out.println("<option value="+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+incoObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>					

 	 		</select>
 	 		<input type="hidden" name="auctionId" value="<%=auctionId%>">
 	 		<input type="hidden" name="supplierId" value="<%=supplierId%>">
			<input type="hidden" name="plant" value="<%=plant%>">
			<input type="hidden" name="category" value="<%=retAuctionHeader.getFieldValueString(0,"EAH_CATEGORY")%>">
			<input type="hidden" name="poVendor" value="<%=retAuctionSuppliers.getFieldValueString(0,"EAS_SUPPLIER_CODE")%>">
	</td>
	</tr>
	
  </Table>

<table id="example" class="table table-striped table-bordered nowrap" cellspacing="0" width="100%">
			<thead>
			
			<Tr>
				<th>Line No</th>
				<th>Material</th>
				<th>Description</th>
				<th>UOM</th>
				<th>Rec. Quantity</th>
				<th>Price</th>
				<th>HSN/SAC</th>
			</Tr>
		</Thead>
		<TBody>	
		
<% 
		for(int i=0; i<retAuctionItemsCnt; i++)
		{
			if(!htItemMinVal.containsKey(retAuctionItems.getFieldValueString(i,"EAI_ITEM_ID")))
				retAuctionItems.deleteRow(i);
		}
		retAuctionItemsCnt=retAuctionItems.getRowCount();
		int counter =0;
		String color="";
		
		for(int i=0; i<retAuctionItemsCnt; i++)
		{
			color = "";
		
			String lineNum	= retAuctionItems.getFieldValueString(i,"EAI_ITEM_ID");
			String matNum 	= retAuctionItems.getFieldValueString(i,"EAI_MATERIAL");
			String matDesc 	= retAuctionItems.getFieldValueString(i,"EAI_ITEM_CODE");
			String uom 	= retAuctionItems.getFieldValueString(i,"EAI_UOM");
			String qty 	= retAuctionItems.getFieldValueString(i,"EARI_PO_QTY");
			/*
			if(!htItemMinVal.containsKey(lineNum))
                         continue;*/
                         tempPOLinesCnt++;
			java.math.BigDecimal totVal = htItemMinVal.get(lineNum);
			
			// This field is not coming proerly.Price is comining in Amount field.
			java.math.BigDecimal totQty = (java.math.BigDecimal)retAuctionItems.getFieldValue(i,"EAI_QUANTITY");
			java.math.BigDecimal price = totVal.divide(totQty,MathContext.DECIMAL128);
			
	
			
%> 
 
    			<tr align="center" > 
		      		<td width=4%" >
		      			<%=lineNum%>
					<input type="hidden" name="line" value="<%=lineNum%>">
					<input type="hidden" name="lineNum<%=i%>" value="<%=lineNum%>">
		      		</td>
				<td width="10%" align="left" >
					<%= matNum %>
					<input type="hidden" name="matNum<%=i%>" value="<%=matNum%>">
				</td>
			 	<td width="40%"  align="left" >
					<%=matDesc %>
					<input type="hidden" name="matDesc<%=i%>" value="<%=matDesc%>">
					<input type="hidden" name="uom<%=i%>" value="<%=uom%>">
					<input type="hidden" name="qty<%=i%>" value="<%=qty%>">
					<input type="hidden" name="price<%=i%>" value="<%=price%>">
    				</td>
				<td width="5%" ><%=uom %>&nbsp;</td>
				<td width="6%" align="right" ><%=qty%>&nbsp;</td>
				<td width="6%" align="right" ><%=price%>&nbsp;</td>
				<td align="center">
					<input type="text" name="hsnCode<%=i%>" class="InputBox" size="10" value="">
				</td>
				
	  		</tr>  
	  		<tr>
	  			<td colspan=7>
	  				<table class="table table-striped table-bordered">
	  					<tr>
	  						<th>PR No</th>
	  						<th>PR Item</th>
	  						<th>Delivery Date</th>
	  						<th>Quantity</th>
	  						<th>
<%
	  					if(!isServicePO)
	  					{
%>
	  							<a href="#" class="btn btn-xs btn-success tr_clone_add"><span class="glyphicon glyphicon-plus"></span> ADD</a>
<%
	  					}
%>
	  						<th>
	  					</tr>
	  					<tr class="tr_clone">
	  						<td align="center">
								<input type="text" name="prNo_<%=lineNum%>" class="InputBox" size="10" value="">
	  						</td>
	  						<td align="center">
								<input type="text" name="prItem_<%=lineNum%>" class="InputBox" size="6" value="">
	  						</td>
	  						<td align="center">
								<div class="input-group">
									<input type="text" name="schdDate_<%=lineNum%>" class="schdDate InputBox" size=25 readonly onfocus=this.blur()>
									<label for="schdDate"><span> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand'  border='none' valign='center'><span></label>  				
								</div>
	  						</td>
	  						<td align="center">
	  							<input type="text" name="schdQty_<%=lineNum%>" class="InputBox" size="6" class="EnterQty" value="">
	  						</td>
	  						<td align="center">
<%
	  					if(!isServicePO)
	  					{
%>
	  							<a href="#" class="btn btn-default removebutton"><span class="fa fa-trash"></span> </a>
<%
						}
%>
	  						</td>
	  					</tr>
	  				</table>
	  			</td>
	  		</tr>
<%
		
		}//end for
%>

</Tbody>
	</Table>
	<input type="hidden" name="polinesCnt" value='<%=tempPOLinesCnt%>'>
	<br><br><br><br><br><br><br><br><br><br><br>
            </div>
         </div>
         <!-- Your Page Content Here -->   
         <Center id ="ButtonDiv">
	 		<button type="button" class="btn btn-primary" onclick="funSubmit()">Create PO</button>  &nbsp;		
	 		<button type="submit" class="btn btn-primary" onclick="window.history.go(-1); return false;">Back</button>  &nbsp;
	</Center>
      </form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">      
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>  
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe> 
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezFooter.jsp"%>

<script>
function dispItemText(item,material,itemTxt)
{
	var Url="ezDisplayItemTxt.jsp?item="+item+"&material="+material+"&itemTxt="+itemTxt;
		$.fancybox.open({
		href : Url,
		type : 'iframe',
		padding : 5,
		width:'50%',
		height:'150px',
		autoSize : false,
		closeBtn : true,
		helpers     : {  
				overlay : {closeClick: false}
		 }
	});
}
function funSubmit()
{
	if(document.myForm.purGroup.value == "")
	{
		alert("Please select Purchase Group");
		return ;
	}
	if(document.myForm.PaymentTerms.value == "")
	{
		alert("Please select Payment Terms");
		return ;
	}
	if(document.myForm.IncoTerms.value == "")
	{
		alert("Please select Inco Terms");
		return ;
	}
	
	var polinesCnt = parseInt(document.myForm.polinesCnt.value);
	if(polinesCnt == 0)
	{
		alert("No Po Line Items Open To Submit");
		return ;
	}
	for(i=0;i<polinesCnt;i++)
	{
		var lineNo = eval("document.myForm.lineNum"+i).value;
		var lineQty = parseFloat(eval("document.myForm.qty"+i).value);
		var schdDate =  eval("document.myForm.schdDate_"+lineNo);
		var schdQty =  eval("document.myForm.schdQty_"+lineNo);
		var prNo =  eval("document.myForm.prNo_"+lineNo);
		var prItem =  eval("document.myForm.prItem_"+lineNo);
		
		var schdTotQty = 0.0;
		if(isNaN(schdDate.length))
		{
			if(schdDate.value == "")
			{
				alert("Please fill the delivery date for item : "+lineNo);
				return ;
			}
			if(schdQty.value == "")
			{
				alert("Please fill the schedule quantity for item : "+lineNo);
				return ;
			}
			if(prNo.value == "")
			{
				alert("Please fill the PR No for item : "+lineNo);
				return ;
			}
			if(prItem.value == "")
			{
				alert("Please fill the PR Item for item : "+lineNo);
				return ;
			}
			schdTotQty += parseFloat(schdQty.value);
			
		}
		else
		{
			for(j=0;j<schdDate.length;j++)
			{
				if(schdDate[j].value == "")
				{
					alert("Please fill the delivery date for item : "+lineNo);
					return ;
				}
				if(schdQty[j].value == "")
				{
					alert("Please fill the schedule quantity for item : "+lineNo);
					return ;
				}
				if(prNo[j].value == "")
				{
					alert("Please fill the PR No for item : "+lineNo);
					return ;
				}
				if(prItem[j].value == "")
				{
					alert("Please fill the PR Item for item : "+lineNo);
					return ;
				}
				schdTotQty += parseFloat(schdQty[j].value);
			}
		}
		if(schdTotQty != lineQty)
		{
			alert("Quantity scheduled does not match with item quantity for line : "+lineNo);
			return ;
		}
	}
	if(confirm("Are you sure you want to submit?"))
	{
		document.myForm.action="ezCreatePOAuction.jsp";
		document.myForm.submit();
	}
}
$(document).ready(function() {
		
       
       $(".schdDate").datepicker({ 
              	format: 'dd/mm/yyyy', 
       });
 
	$(".tr_clone_add").on('click', function() {
		debugger;
		var $closestTable    = $(this).closest('table');
		var $tr    = $closestTable.find('.tr_clone');
		var $clone = $tr.clone();
		$clone.removeClass('tr_clone');
		$clone.find(':text').val('');
		$clone.find('.schdDate').removeAttr('id').removeClass('hasDatepicker');
		debugger;
		$clone.find('.schdDate').datepicker({ 
			format: 'dd/mm/yyyy'
	       });
		//$tr.after($clone);
		$closestTable.append($clone);
		
		
	});
 
 	
 	
 });
$(document).on('click', '.removebutton', function () { 
     $(this).closest('tr').remove();
     return false;
 }); 
 
 
</script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>



</body>
</html>

