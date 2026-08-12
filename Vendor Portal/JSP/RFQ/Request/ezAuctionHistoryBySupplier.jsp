<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%>  
<%//@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@include file="../../../Includes/JSPs/Request/iAuctionHistoryBySupplier.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

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

	var tabHeadWidth=70
	var tabHeight="60%";

function mySelect()
{
	if(document.myForm.supplierCode.selectedIndex==0)
	{
		alert("Please Select Supplier")
	}
	else
	{
		document.myForm.action="ezAuctionHistoryBySupplier.jsp"
		document.myForm.submit();
	}
}
	
function funSelect()
{
	for(var i=0;i<document.myForm.supplierCode.length;i++)
	{
		if(document.myForm.supplierCode.options[i].value=='<%=supplierCode%>')
		{
			document.myForm.supplierCode.selectedIndex = i
		}
	}
}
</script>
<script src="../../Library/JavaScript/ezScrollDefine.js"></script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>

<%  
	if(userType.equals("2"))
	{ 
%>
		<body onLoad="scrollInit();funSelect()" onResize="scrollInit()" scroll=no>
<%  
	}
	else
	{  
%>
		<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no>
<%  
	}
%>
<% String display_header="Auction History"; %>
	<%@ include file="../Misc/ezSubHeader.jsp" %>
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">	    
<form name="myForm">
	
			
<%
	if(userType.equals("2"))
	{
%>
		<table class="table table-bordered">
			<Tr>
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='30%' >
				Select Vendor&nbsp;:&nbsp;
			</Td>
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='70%' align=center>
			<select name="supplierCode" onChange="mySelect()" style="width:100%" id = "listBoxDiv">
							<option value="¥">--Select--</option>
	<%
	
				java.util.Hashtable  templatehash = (Hashtable) session.getValue("VENDORHT");//REFFROM: iSelectSoldTo.jsp
				Enumeration enumIds  = templatehash.keys()  ;
				int k=0; 
				String toVendor = "",data = "";
				while(enumIds.hasMoreElements()){
									
					toVendor = (String)enumIds.nextElement();
					data 	 = (String)templatehash.get(toVendor);
					
					
							//java.util.ResourceBundle rb =  java.util.ResourceBundle.getBundle("Suppliers");
							//java.util.Enumeration enum = rb.getKeys();
							/*java.util.Vector loginUsrSoldtos = (java.util.Vector)session.getValue("SOLDTOVECT");
							int vectSize = loginUsrSoldtos.size();
							String key="";
							for(int i=0;i<vectSize;i++)
							{
								key = (String)loginUsrSoldtos.get(i);*/
	%>
								<option value="<%=toVendor%>"><%=data%>--><%=toVendor%></option>
	<%
							}
	%>
			</select>
			</Td>
			
			</TR>
			</table>

<%
	}
	String noDataStatement="";
	if(supplierCode!=null && !supplierCode.equals("¥"))
	{
	   	
	   	if(historyCount>0)
	   	{
%>

			<table class="table table-bordered">
  			<tr valign="middle">
	  			<th width="40%">Auction Id</th>
	  			<th width="60%">Auction Name</th>
  			</tr>
			
<%
     			for(int i=0;i<historyCount;i++)
			{
%>
				<tr>
				<td align="center" width="40%">
				<a href="ezAuctionHistoryDetails.jsp?auctionId=<%=history.getFieldValueString(i,"EAH_AUCTION_ID")%>&supplierId=<%=history.getFieldValueString(i,"EAS_SUPPLIER_ID")%>&auctionName=<%=history.getFieldValueString(i,"EAH_AUCTION_NAME")%>" ><%=history.getFieldValueString(i,"EAH_AUCTION_ID")%></a></td>
				<td align="left" width="60%"><%=history.getFieldValueString(i,"EAH_AUCTION_NAME")%></td>
				</tr>
<%	
			} 
%>
			</table>
			
<%	
		}
		else
		{ 
		           noDataStatement="There are no auctions to list to view History";

		}	
	}
	else
	{	

		noDataStatement="Please Select Supplier to View History";
	
	}

if(!("").equals(noDataStatement)){ %>
<%@ include file="../Misc/ezDisplayNoData.jsp" %>
<% } %>

</form>
</div>
</div>
</div>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

</html>
