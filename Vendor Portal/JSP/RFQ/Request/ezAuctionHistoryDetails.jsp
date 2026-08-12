<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%>  
<%//@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 

<%@ page import="ezc.ezutil.*,java.util.*,java.text.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@include file="../../../Includes/JSPs/Request/iAuctionHistoryDetails.jsp" %>


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
<script>
	
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
		scrollInit();
	}
		
</script>

<script>
	var tabHeadWidth=80
	var tabHeight="56%";
</script>

<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>


<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no>
<%
	String display_header	= "Auction History Details of "+auctionName;
%>
<%@ include file="../Misc/ezSubHeader.jsp" %>
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">	    
<form name="myForm">

<%
	   	
	   	if(historyCount>0)
	   	{
			String varType = history.getFieldValueString(0,"EAH_VARIANCE_TYPE");
			String minBidVar = history.getFieldValueString(0,"EAH_MIN_BID_VARIANCE");
			String maxBidVar = history.getFieldValueString(0,"EAH_MAX_BID_VARIANCE");
			if(varType.equals("P"))
			{
				int minIndex = minBidVar.indexOf(".");
				int maxIndex = maxBidVar.indexOf(".");
				if(minIndex!=-1)
					minBidVar = minBidVar.substring(0,minIndex);
				if(maxIndex!=-1)	
					maxBidVar = maxBidVar.substring(0,maxIndex);
					
				minBidVar += "%";
				maxBidVar += "%";
			}

				
%>

			<br>
			
		
		
		<table class="table table-bordered">
			<tr>
				<th width = "50%" align = "left"  style="background-color:'#F3F3F3'">Start Date/Time : <%=startDate%></th>
				<th width = "50%" align = "right" style="background-color:'#F3F3F3'">End Date/Time : <%=endDate%></th>
			</tr>
<%
			if("3".equals((String)session.getValue("UserType")))
			{
%>			
			<tr>
				<th align="center" colspan=2 style="background-color:'#F3F3F3'">Variance Value : <%=minBidVar%></th>
			</tr>
<%
			}
			else
			{
%>			
			<tr>
				<th align="center" colspan=2 style="background-color:'#F3F3F3'">
					<table class="table table-bordered">
					<tr>
						<th width = "33%" align = "center" style="background-color:'#F3F3F3'">Extension Time : <%=history.getFieldValueString(0,"EAH_EXTENSION_TIME")%>&nbsp;Minutes</th>
						<th width = "33%" align = "center" style="background-color:'#F3F3F3'">No. of Exts : <%=history.getFieldValueString(0,"EAH_EXTENSIONS")%></th>
						<th width = "34%" align = "center" style="background-color:'#F3F3F3'">Variance Value : <%=minBidVar%></th>
					</tr>
					</table>
				</th>
			</tr>
<%				
			}
%>
			</table>			

	
		<br>
		<table class="table table-bordered">
		<tr valign="middle">
			<th width="25%">&nbsp;</th>
			<th width="25%">Bid No</th>
			<th width="50%">Bid Value</th>
		</tr>
		<TR>
			<%
				//out.println("historyhistoryhistory	"+history.toEzcString());
				Enumeration enumIds  = acutHash.keys()  ;
				String counter = "",	bidValue = "";	

				while(enumIds.hasMoreElements())
				{
					counter 	= (String)enumIds.nextElement();
					bidValue        = (String)acutHash.get(counter);

			%>
			<table class="table table-bordered">
				<tr valign="middle">
				<td width="25%"><a href="javascript:showItems('<%=counter%>')"><img border=0 id="IMG<%=counter%>"  src="../../Images/Others/tree-closed.gif"></a></td>
				<td width="25%"><%=counter%></td>
				<td width="50%"><%=bidValue%></td>
				</tr>
			</table>
			<span id="span<%=counter%>"  style="visibility:hidden;display:none">
			<table class="table table-bordered">


			<%			
				int k=0;
				for(int i=0;i<historyCount;i++)
				{
					
					if(counter!=null && counter.equals(history.getFieldValueString(i,"EAH_AUCTION_COUNTER").trim()))
					{
					
					if(k==0)
					{
						k++;	
			%>
					<tr valign="middle">
						<th width="25%">Material Name</th>
						<th width="10%">UOM</th>
						<th width="15%">Quantity</th>
						<th width="20%">Price (<%=history.getFieldValueString(0,"EAH_CURRENCY")%>)</th>
						<th width="30%">Quote (<%=history.getFieldValueString(0,"EAH_CURRENCY")%>)</th>
					</tr>
			<%
					}
					BigDecimal tempPrice= new BigDecimal(0.0);
					tempPrice = (BigDecimal)history.getFieldValue(i,"ITEM_PRICE");
					tempPrice = tempPrice.setScale(2,RoundingMode.CEILING);
					BigDecimal tempVal= new BigDecimal(0.0);
					tempVal = (BigDecimal)history.getFieldValue(i,"EAH_AUCTION_VALUE");
					tempVal = tempVal.setScale(2,RoundingMode.CEILING);
			%>
					<tr>
						<td align="left" width="25%"><%=history.getFieldValueString(i,"EAI_ITEM_CODE")%></td>
						<td align="left" width="10%"><%=history.getFieldValueString(i,"EAI_UOM")%></td>
						<td align="right" width="15%"><%=history.getFieldValueString(i,"EAI_QUANTITY")%></td>
						<td align="right" width="20%"><%=tempVal%></td>
						<td align="right" width="20%"><%=tempPrice%></td>
					</tr>
		<%
					
					}
				} 
		%>

				</Table>
			</span>
			
		<%							
			}
		%>


		</table>
		
			
		<div class="row no-print">
		<div class="col-xs-12">
			<button type="button" class="btn btn-primary pull-right" onclick="javascript:history.go(-1)" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Back</button>
		</div>
		</div>
<%	
		}
		else
		{
%>
			<br><br><br>
			<table class="table table-bordered">
				<tr align="center">
					<th>No History Exixts.</th>
				</tr>
			</table>
			<br>
			<div class="row no-print">
					<div class="col-xs-12">
						<button type="button" class="btn btn-primary pull-right" onclick="javascript:history.go(-1)" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Back</button>
					</div>
			</div>
<%
		}
%>

</form>
</div>
</div>
</div>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

</html>
