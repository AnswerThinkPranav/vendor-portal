<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%
	
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
	
	String display_header = "Frequently Asked Questions";
%>
<html>
<head>
<title>FAQs</title>
<script>
	function funOpen(obj,obj1)
	{
		newWindow = window.open(obj,"Mywin"+obj1,"resizable=yes,left=20,top=8,height=800,width=1250,status=no,toolbar=no,menubar=no,location=no")
	}
	var tabHeadWidth=100
	var tabHeight="65%"
	
</script>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script src="../../Library/JavaScript/ezTabScroll.js"></script>
<style>
td.pagestyle {
	
    	background-color: #ffffff
    	
}
td.faqdata{
	background-color: #ffffff
}
table
{
	background-color: #ffffff
}

</style>

</head>

<%--<body onContextMenu="return true" scroll=yes onLoad="scrollInit();" onResize="scrollInit()">--%>

<body background="../../../../EzCommon/Images/Body/NOTEBOOK.JPG" onContextMenu="return true" scroll=no onLoad="scrollInit()" onResize="scrollInit()">


<Div id="faqDiv" style="overflow:auto;position:absolute;width:100%;height:100%">
<TABLE id="faqTab" border=0 cellPadding=0 bgcolor="#FOFODD" cellSpacing=0 style="width=90%" align="center">
<TBODY>
<TR> <a name="top"></a><td><%@ include file="ezDisplayHeader.jsp"%></td></TR>
<TR >
	
	<TD width="50%" class="pagestyle">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href = "ezFAQs.jsp#rfq">
			<img src="../../Images/FAQs/question.gif" style="border:0;" background-color="#DEDCB6">
			<font size=2 style="color:blue;">How do I view RFQ's ?<br></font>
		</a>
	</td>
</tr>
<TR >
	
	<TD width="50%" class="pagestyle">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href = "ezFAQs.jsp#one">
			<img src="../../Images/FAQs/question.gif" style="border:0;" background-color="#DEDCB6">
			<font size=2 style="color:blue;">How do I view Purchase Orders ?<br></font>
		</a>
	</td>
</tr>
<TR >
	
	<TD width="50%" class="pagestyle">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href = "ezFAQs.jsp#schd">
			<img src="../../Images/FAQs/question.gif" style="border:0;" background-color="#DEDCB6">
			<font size=2 style="color:blue;">How do I View Schedule Agreements ?<br></font>
		</a>
	</td>
</tr>
<TR>
	<a href = "ezFAQs.jsp#three">
	<TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#three"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I Add and View Shipment details ?<br></font></a></td></tr>

<%
	String userType = (String)session.getValue("UserType");
	if(!userType.equals("2"))
	{
	
%>

<!--	
<TR><a href = "ezFAQs.jsp#four"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#four"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I Add Shipment details ?<br></font></a></td></tr>

<TR><a href = "ezFAQs.jsp#five"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#five"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I track status of shipments made by me ?<br></font></a></td></tr>
-->
<%

 }
 
 %>

<TR><a href = "ezFAQs.jsp#six"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#six"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I view Invoice details ?<br></font></a></td></tr>
<!--
<TR><a href = "ezFAQs.jsp#seven"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#seven"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I view Invoice Payment Details ?<br></font></a></td></tr>
-->
<TR >
	
	<TD width="50%" class="pagestyle">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href = "ezFAQs.jsp#util">
			<img src="../../Images/FAQs/question.gif" style="border:0;" background-color="#DEDCB6">
			<font size=2 style="color:blue;">How do I view Utilities details ?<br></font>
		</a>
	</td>
</tr>
<TR><a href = "ezFAQs.jsp#nine"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#nine"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I view the Outstanding Balance ?<br></font></a></td></tr>

<TR><a href = "ezFAQs.jsp#eight"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#eight"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I view my Account Statement ? <br></font></a></td></tr>

<TR><a href = "ezFAQs.jsp#eight"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#plantInfo"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I view Plant Info ? <br></font></a></td></tr>

<TR><a href = "ezFAQs.jsp#password"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#eight"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I change my password ? <br></font></a></td></tr>


<!--
<TR><a href = "ezFAQs.jsp#ten"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#ten"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I communicate with the buyer at Enterprise ?</font></a></td></tr>

<TR><a href = "ezFAQs.jsp#eleven"><TD width="100%" style="align:center" class="pagestyle">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href = "ezFAQs.jsp#eleven"><img src="../../Images/FAQs/question.gif" style="border:0"><font size=2 style="color:blue;">How do I inform Enterprise about changes in my Address ?<br></font></a></td></tr>
-->

		<TR>
			<TD class="pagestyle">
			<TD width="50%" style="align:center" class="pagestyle">
			<br><br><br><br>
			</TD>
			</TD>
		</TR>
</Table>

			<TABLE id="InnerBox1Tab" border=0 cellPadding=0 cellSpacing=2 width="90.5%" align="center">
				<TBODY>
		<TR>
		<TD width="100%" class="pagestyle">
		
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="rfq"><b>How do I view RFQ's ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		The RFQ can be viewed by their status;Request Quote,All,View Quotations.Vendor captures the RFQs of Enterprise for a particular vendor through a link ‘RFQ' in the main menu. 
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Purchase Orders';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour12_0.html","RFQDeatails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		
		
		
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="one"><b>How do I view Purchase Orders ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Vendor Module captures the Purchase orders of EzCommerce Suite for a particular vendor through a link 'Purchase Orders' in the main menu. 
		Purchase Orders option shows sub links 'To Be Acknowledged'  'Acknowledged',’Open’, 'Closed' and 'All'.
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Purchase Orders';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour13_0.html","PODetails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		
		
		
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="schd"><b>How do I View Schedule Agreements details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		To view the Schedule Agreements details go through "Schd Agreements" link in the main menu.
		Based on their status, Schedule Agreements are divided into 	<br>
		1. Acknowledgements<br>
		2. Open<br>
		3. Closed<br>
		4. All<br>
		5. Schedule Lines
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Schedule Agreement Details';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour14_0.html","ViewScheduleAgreementDetails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>

		
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="three"><b>How do I Add and View Shipment details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Drill down capability is available to view shipment and item details, quantity, descriptions, revision history, and associated receipts and invoices. User can go through the freighting details of his commodity directly using this menu option. Its submenu provides the user to add or simply view the shipment details of a purchase Order by clicking 'add' or 'view' correspondingly. 
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Shipment Details';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour15_0.html","ViewShipmentsDetails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		
		&nbsp;&nbsp;&nbsp;&nbsp;
		
<%
			userType = (String)session.getValue("UserType");
			if(!userType.equals("2"))
			{
			
%>
		
		<!--
		<font class="faqheader"><font size=2><a name="four"><b>How do I Add Shipment details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		You can add shipment details through;  Order Details, Add Shipments.
		The purchase order details and the schedule agreement details screen has a button in the bottom to add shipment details associated with those orders.
		The Add Shipment option in the Shipments menu allows you to choose a specific purchase order or schedule agreement for which you would like to add the shipment details.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='Add Shipment Details';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour61.html","AddPoAcknowledgement")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="five"><b>How do I track status of shipments made by me ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		You can track the status of your shipments through: Order Details, View Shipments, Search.
		The Purchase Order and Schedule Agreement details screen has a button "View Receipts" on the bottom. This takes you to the list of Receipts screen associated with the order. You can see the status of each receipt in the column. You can also see the reasons for rejection, if any, by clicking on the rejected quantity.
		The View Shipments option in the Shipments menu allows you to choose the order for which shipment you are trying to track.
		The Delivery Challan option in the Search menu allows you to enter your Delivery Challan number to track the status of your shipment.  This is the fastest way to track the status.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='Track Status of Shipments';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour41.html","PoReceipts")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;-->
<%		
		}		
%>		
		<font class="faqheader"><font size=2><a name="six"><b>How do I view Invoice details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Vendors/Suppliers can review the status of their invoices and payments. Access to this information helps increase supplier satisfaction, while eliminating the need for your purchasing and payables department to handle routine supplier inquiries. 
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Invoice Details';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour16_0.html","InvoiceDetails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<!--
		<font class="faqheader"><font size=2><a name="seven"><b>How do I view Invoice Payment Details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		You can view the payment status of any invoice by selecting the invoice details as per above and clicking on the Payment Details button. If the payment has been made, the check number, date and bank on which the check was drawn is displayed.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Invoice Payment Details';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour53.html","InvoicePaymentDetails")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		-->
		<font class="faqheader"><font size=2><a name="util"><b>How do I view Utilities details ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Utilties access for suppliers will enhance supplier relationships while reducing administrative time and costs for your purchasing department. Your company's purchasing professionals can now be released from administrative tasks, so they can concentrate on high value activities such as sourcing, negotiating, and expenditure analysis.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Account Statement';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour17_0.html","AcStatement")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="nine"><b>How do I view the Outstanding Balance ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		From the Utilities menu, choose the Outstanding Balance option.  You will see the balance due to you from Enterprise.  This will show you the Details Like Account Balance And Due Balance.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Outstanding Balance';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour17_1.html","OutStandingBalance")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		<font class="faqheader"><font size=2><a name="eight"><b>How do I view my Account Statement ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		From the Utilities menu, choose the A/c Statement option. This will show the Statement of account as in enterprise books (Purchaser) of this particular vendor.You have to select the period for which Statement you would like to view.  To faster response from the system, keep your selection as brief as possible.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Account Statement';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour17_2.html","AcStatement")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		<!--
		<font class="faqheader"><font size=2><a name="ten"><b>How do I communicate with the buyer at Enterprise ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Apart from the conventional methods of telephone and fax, you can now communicate with the buyer at Enterprise efficiently via the mail feature in this portal.
		</font></td></tr>
		
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='Know how to communicate with Enterprise';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATourss06.html","mailing")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		
		</tr>
		</table>
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="eleven"><b>How do I inform Enterprise about changes in my Address ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		Use the Change Address option in the Self Service menu to enter details of your new address and press the submit button.  This new information is updated in Enterprise records.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='Know how to update Enterprise about your change of address';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATourss04.html","ChangeAddress")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		-->
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="plantInfo"><b>How do I view Plant Info ? </b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		From the Utilities menu, choose the Outstanding Balance option.  You will see the balance due to you from Enterprise.  This will show you the Details Like Account Balance And Due Balance.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Outstanding Balance';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour18.html","OutStandingBalance")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		
		
		<br><br>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="faqheader"><font size=2><a name="password"><b>How do I change my password ?</b></a></font></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
		<table width="95%" align="center"><tr><td align="left" class="faqdata"><font size=2>
		From the Utilities menu, choose the Outstanding Balance option.  You will see the balance due to you from Enterprise.  This will show you the Details Like Account Balance And Due Balance.
		</font></td></tr>
		<tr>
		<td class="pagestyle"><a href="javascript:void(0)" onMouseOver="window.status='View Outstanding Balance';return true;" onMouseOut="window.status=' ';return true;" onClick=funOpen("../../Htmls/TakeATour/TakeATour19.html","OutStandingBalance")>Take A Tour</a></td>
		<td align="right" class="pagestyle"><a href="ezFAQs.jsp#top"><img border =0 src = "../../Images/Others/go_up_arrow.png"></a></td>
		</tr>
		</table>
		</table>

<br><br>

		<br><br>


<br>

</td>
</tr>
</tbody>
</table>
</Div>
<Div id="MenuSol">
</Div>	
</body>
</html>
