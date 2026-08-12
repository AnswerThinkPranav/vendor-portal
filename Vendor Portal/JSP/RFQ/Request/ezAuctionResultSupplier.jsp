<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*" %>

<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%//@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@include file="../../../Includes/JSPs/Request/iCurrentAuctionDetails.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%
	session.putValue("AUCTION_WF_UPDATE","");
	status=auctionHeader.getFieldValueString(0,"EAH_AUCTION_STATUS");
	
	BigDecimal docVal=new BigDecimal(0.00);
	
	
	
	
%>
<html>
<head>
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

<script src="../../Library/JavaScript/ezTrim.js"></script>
<script>
	
	function funCreateWF()
	{		
		document.myForm.action="ezSaveAuctionWF.jsp"
		document.myForm.submit()
	}
	function funSubmit(submitType)
	{	
		document.myForm.submitType.value=submitType;
		document.myForm.action="ezUpdateAuctionWF.jsp"
		document.myForm.submit()
	}
	
	function showItems(obj)
	{
	
		openImg = new Image();
		openImg.src = "../../Images/Others/tree-select.gif";
		
		closeImg = new Image();
		closeImg.src = "../../Images/Others/tree-closed.gif";
		
		var spanObj = document.getElementById("span"+obj)
		imgobj	=document.getElementById("IMG"+obj);
		if(spanObj.style.visibility=="hidden")
		{
			spanObj.style.visibility="visible"
			spanObj.style.display=""
			imgobj.src = openImg.src;
		}
		else
		{
			spanObj.style.visibility="hidden"
			spanObj.style.display="none"
			imgobj.src = closeImg.src;
		}
	}

	function hideAll()
	{
		var elements1 = document.getElementsByTagName("span")
		for(var i=0;i<elements1.length;i++)
		{
			elements1[i].style.visibility="hidden"
			elements1[i].style.display="none"
		}
	}

	
	
	function ezBackCall()
		{
					window.history.go(-1);
					return false;
	}
	
	function funPrint()
	{
		//var url="ezViewCompletedAuctionPrint.jsp?auctionId=<%=auctionId%>&auctionName=<%=auctionName%>&status=<%=status%>"
		//window.open(url,"newwin11","width=850,height=500,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		window.print();
	}
	
	
function funSummary()
{
	var url="ezViewSummary.jsp?auctionId=<%=auctionId%>";
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}	
function closeIframe()
{
	   $('#woModal').modal('toggle');
}
function funShowApprovalHirearchy(compCode,plant,category,docValue)
{
	var url="../Misc/ezShowApprovalHirearchy.jsp?compCode="+compCode+"&plant="+plant+"&category="+category+"&docValue="+docValue;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
function funAuditTrail(docId,docType)
{
	var url="../Misc/ezShowAuditTrail.jsp?docId="+docId+"&docType="+docType;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
</script>
	<Script>
		var tabHeadWidth=95
		var tabHeight="25%"
	</Script>
	<script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
</head>
<body onResize="scrollInit(1)"  scroll=no <%=onLoadString%>>
<%@ include file="../Misc/ezSubHeader.jsp"%>		
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">
<form name="myForm" method="post">
<%
	String compCode = "5000";
	for(int i=0;i<itemCount;i++)
	{
		out.println("<input type='hidden' name='material' value='"+auctionItems.getFieldValueString(i,"EAI_MATERIAL")+"'>");
		out.println("<input type='hidden' name='itemDesc' value='"+auctionItems.getFieldValueString(i,"EAI_ITEM_CODE")+"'>");
		out.println("<input type='hidden' name='reservePrice' value='"+auctionItems.getFieldValueString(i,"EAI_TARGET_PRICE")+"'>");
	}
%>



<table class="table table-bordered">
<tr>
	<th align = "right" width="16%">Start Date</th>
	<td width = "18%"><%=startDate%></td>
	<th align = "right" width = "16%">End Date</th>
	<td width = "18%"><%=endDate%>
	</td>
	<th align = "right" width = "16%">Variance Value</th>
	<td width = "16%" ><%=varianceValue%> <%=symbol%>
	<input type="hidden" name="headerVarianceVal" value='<%=varianceValue%>'>	
	<input type="hidden" name="plant" value='<%=auctionHeader.getFieldValueString(0,"EAH_PLANT")%>'>	
	<input type="hidden" name="compCode" value='<%=compCode%>'>	
	<input type="hidden" name="category" value='<%=auctionHeader.getFieldValueString(0,"EAH_CATEGORY")%>'>	
	</td>
</tr>
</table>


<%
	String supplierName = "",supplierdata = "",lowSupplier="";
	if(retAuctionHistory.getRowCount()>0 && auctionItems.getRowCount()>0)
	{
%>	

		
		<table class="table table-bordered">
		<tr>
			<th  width = "10%">&nbsp;</th>
			<!--<th  width = "10%">PR No.</th>
			<th  width = "10%">PR Item</th>-->
			<th  width = "60%">Material</th>
			<th  width = "10%">UOM</th>
		</tr>
		
<%
		//out.println("supplierCodesupplierCode	"+supplierCode);
		//out.println("auctionItems>>	"+auctionItems.toEzcString());
		//out.println("retAuctionHistory		"+retAuctionHistory.toEzcString());
		int supCount = 0;
		for(int j=0;j<auctionItems.getRowCount();j++)
		{
			String drlPRNumAu = "",drlPRItemAu="";
			
			if(auctionItems.getFieldValueString(j,"EAI_EXT1")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT1").trim()))
				drlPRNumAu = auctionItems.getFieldValueString(j,"EAI_EXT1");
								
			if(auctionItems.getFieldValueString(j,"EAI_EXT2")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT2").trim()))
				drlPRItemAu = auctionItems.getFieldValueString(j,"EAI_EXT2");
			String matNum = auctionItems.getFieldValueString(j,"EAI_ITEM_CODE").trim();
%>
			<table class="table table-bordered">
			<tr>
				<td width="10%" align=center><a href="javascript:showItems('<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>')"><img border=0 id="IMG<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>"  src="../../Images/Others/tree-select.gif"></a></td>
				<!--<td width="10%" align='center'>&nbsp;<b><%=drlPRNumAu%></b></td>				
				<td width="10%" align='center'>&nbsp;<b><%=drlPRItemAu%></b></td>-->
				<td width="60%"><b><%=matNum%>&nbsp;</b></td>
				<td width="10%"><b><%=matUOMTable.get(matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID"))%>&nbsp;</b></td>
			</tr>
			</table>
			<span id="span<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>" >
			<table class="table table-bordered">

			<tr>
				<th  width = "35%">Supplier Name</th>
				<th  width = "20%">Bid Time</th>
				<th  width = "10%">Quantity</th>
				<th  width = "15%">Price</th>
				<th  width = "15%">Value</th>
				<th  width = "5%">Rank</th>
			</tr>

<%							
			supplierName = "";supplierdata = "";lowSupplier="";
			//java.math.BigDecimal matPrice = null;
			Enumeration suppIds  = bidSummary.keys();
			int i = 0;
			String suId  ="",timeStamp ="",bidValue = "",sid = "";
			String[] supKey = new String[4];
			String[] matKeys = new String[2];
			while(suppIds.hasMoreElements())
			{
				String tempVal = "",matStr="",matValue="",matPrice="",matRank="";

				suId 		 = (String)suppIds.nextElement();
				supplierdata 	 = (String)bidSummary.get(suId);
				try
				{
					supKey = supplierdata.split("##");
					supplierName   =  supKey[0];
					timeStamp      =  supKey[1];
					bidValue       =  supKey[2];
					sid            =  supKey[3];
					lowSupplier= suId;


					if(supplierName==null || "null".equals(supplierName.trim()))
						supplierName = suId;
						
					matStr 	 = (String)finalMatValueTable.get(sid+matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID"));					
						
					if(matStr!=null)
					{	
						try
						{
							matKeys = matStr.split("#");
							matValue = new java.math.BigDecimal(matKeys[0]).setScale(2,RoundingMode.HALF_UP)+"";
							matRank  = matKeys[1];
							matPrice = ((new java.math.BigDecimal(matKeys[0])).divide(new java.math.BigDecimal(auctionItems.getFieldValueString(j,"EAI_QUANTITY")),java.math.BigDecimal.ROUND_HALF_UP)).setScale(2, java.math.BigDecimal.ROUND_HALF_UP)+"";
							if("1".equals(matRank))
								docVal=docVal.add(new java.math.BigDecimal(matKeys[0]));
						}catch(Exception e){}
					}
					
				
				}
				catch(Exception e2)
				{
					out.println(e2);
					ezc.ezcommon.EzLog4j.log("Exception Ocuured Getting Lowest Bid","I");
				}	
				
%>	
				<tr>

					<td width="35%">&nbsp;<%=supplierName%></td>
					<td width="20%">&nbsp;<%=timeStamp%></td>
					<td width="10%">&nbsp;<%=auctionItems.getFieldValueString(j,"EAI_QUANTITY")%></td>			
					<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_p_<%=matNum%>_<%=sid%>' value='<%=matPrice%>' style="text-align:right" readonly></td>
					<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_v_<%=matNum%>_<%=sid%>' value='<%=matValue%>' style="text-align:right" readonly></td>
					<td width="5%" align=right>&nbsp;<input type=text class='tx' name='text_r_<%=matNum%>_<%=sid%>' value='<%=matRank%>' style="text-align:right" readonly></td>
				</tr>
					
<%
			supCount++;
			i++;
			
		}

		if(supCount == 0)
		{
%>	
			<script>
				document.getElementById("IMG<%=matNum%>").style.visibility='hidden'
			</script>
<%
		}
%>
		</table>
		</span>
<%
	}
	}
	docVal=docVal.setScale(2,RoundingMode.HALF_UP);

%>
	</TD></TR>
	</Table>
	<br>
	<center class="no-print">
	
	
	
<%
	
		if(detailCount > 0)
		{
%>
				<button type="button" class="btn btn-primary" onclick="funSummary()" style="margin-right: 5px;"><i class="fa fa-history"></i> History</button>				
				<button type="button" class="btn btn-primary" onclick="ezBackCall()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Back</button>
<%		
		}
%>
	</center>
	
	

<%


			for(int i=0;i<supplierCount;i++)
			{
%>			
			<input type="hidden" name="chk1" value="<%=auctionSupplier.getFieldValueString(i,"EAS_SUPPLIER_CODE")%>">
<%				
			}
%>			
<input type="hidden" name="auctiondate" value="<%=startDate%>">
<input type="hidden" name="status" 	value="<%=status%>">
<input type="hidden" name="auctionId" 	value="<%=auctionId%>">
<input type="hidden" name="auctionName" value="<%=auctionName%>">
<input type="hidden" name="supplierId" 	value="<%//=supplierId%>">
<input type="hidden" name="endDate" 	value="<%=endDateFormat%>">
<input type="hidden" name="actualEndDate" value="<%=auctionHeader.getFieldValueString(0,"EAH_END_DATE")%>">
<input type="hidden" name="timeLag" 	  value="<%=auctionHeader.getFieldValueString(0,"EAH_TIME_LAG")%>">
<input type="hidden" name="extensions" 	  value="<%=auctionHeader.getFieldValueString(0,"EAH_EXTENSIONS")%>">
<input type="hidden" name="extensionTime" value="<%=auctionHeader.getFieldValueString(0,"EAH_EXTENSION_TIME")%>">
<input type="hidden" name="evalFactor" 	  value="<%=evalFactor%>">
<input type="hidden" name="counter" 	  value="<%=counter%>">
<input type="hidden" name="submitToSelf" value="Y">
<input type="hidden" name="submitType" value="">
</form>
</div>
</div>
</div>
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

</html>
