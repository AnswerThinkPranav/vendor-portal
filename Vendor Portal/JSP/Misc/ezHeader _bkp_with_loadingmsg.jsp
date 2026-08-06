<!DOCTYPE html>    
<!--                     
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->            
<html>            
<link href="../../../../EzCommon/CSS/dataurl.css" rel="stylesheet" />          
<head>                
	<%@ include file="ezHeaderIncludes.jsp"%>     
<script>	

</script> 

<%       
	java.util.Vector userAuth_Vect   = (java.util.Vector)session.getValue("USERAUTHS");
	//out.println(":::::userAuth_Vect::::::"+userAuth_Vect);
	String munuIetmIcon = "<i class=\"fa fa-circle-o text-yellow\"></i>";
	//out.println(v_UserType+":::"+userAuth_Vect);
	if("3".equals(v_UserType))//  || "VENDOR".equals(v_PortalType))
	{
		if(userAuth_Vect.contains("RFQ_LIST"))
		{
%> 
			<li class="treeview"> 
				<a href="#"><i class="fa fa-newspaper-o"></i> <span>RFQ</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<!--<li><a href="../RFQ/ezListRFQs.jsp?type=ToQuote"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?type=Quoted"><%=munuIetmIcon%>View Responded Quotations</a></li>-->
					
					<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=RFQS_TO_BE_RESPONDED"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=VIEW_RESPONDED_QUOTATIONS"><%=munuIetmIcon%>View Responded Quotations</a></li>
				</ul>
			</li> 
<%
		}
		if(userAuth_Vect.contains("PO_LIST")) 
		{
%> 
		
		<li class="treeview">  
			<a href="#"><i class="fa fa-file-text"></i> <span>Purchase Order</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<!--<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=NotAcknowledged&selVendor=null"><%=munuIetmIcon%>To Be Acknowledged</a></li>
				<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Acknowledged&selVendor=null"><%=munuIetmIcon%>Accepted</a></li>
				<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Rejected&selVendor=null"><%=munuIetmIcon%>Rejected</a></li>
				<li><a href="../Purorder/ezListPOs.jsp?OrderType=Open&menuItem=PO"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezClosedListPOs.jsp"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezListPOs.jsp?OrderType=Closed&menuItem=PO"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezListPOs.jsp?OrderType=Return"><%=munuIetmIcon%>Return Pos</a></li>-->
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=TO_BE_AKNOWLEDGED_POS"><%=munuIetmIcon%>To Be Acknowledged</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=ACCEPTED_POS"><%=munuIetmIcon%>Accepted</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=REJECTED_POS"><%=munuIetmIcon%>Rejected</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=OPEN_POS"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=CLOSED_POS"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=RETURN_POS"><%=munuIetmIcon%>Return Pos</a></li>
				
			</ul>
		</li>  
<%
		}
		if(userAuth_Vect.contains("ADD_ASN"))
		{
%>
		
		<li class="treeview">
			<a href="#"><i class="fa fa-truck"></i> <span>Shipments</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="../Shipment/ezToBeAddShipmentPOs.jsp?FROM=MENU&TYPE=ASN"><%=munuIetmIcon%>Add</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=Y"><%=munuIetmIcon%>To Be Approved</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=A"><%=munuIetmIcon%>Approved</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=R"><%=munuIetmIcon%>Rejected</a></li>
				<!--<li><a href="../Shipment/ezGetVendorShipments.jsp?status=A&postedToSAP=Y"><%=munuIetmIcon%>Posted ASN Invoices List</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=ADD_ASN"><%=munuIetmIcon%>Add</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=TO_BE_APPROVED_ASN"><%=munuIetmIcon%>To Be Approved</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=APPROVED_ASN"><%=munuIetmIcon%>Approved</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=REJECTED_ASN"><%=munuIetmIcon%>Rejected</a></li>
			</ul>
		</li>
<%
		}
%>
		<li class="treeview">
			<a href="#"><i class="fa fa-upload"></i> <span>Upload Invoice</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
<%			
		if(userAuth_Vect.contains("UPLOAD_PO_INV"))
		{
%>		
				<!--<li><a href="../Shipment/ezInvoiceWithoutASN.jsp?FROM=MENU&TYPE=WOASN"><%=munuIetmIcon%>Upload Material/Service Inv.</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=I"><%=munuIetmIcon%>View Material/Service Inv.</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=UPLOAD_MAT_SRV_INV"><%=munuIetmIcon%>Upload Material/Service Inv.</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=VIEW_MAT_SRV_INV"><%=munuIetmIcon%>View Material/Service Inv.</a></li>
<%
		}
		if(userAuth_Vect.contains("UPLOAD_FRT_INV"))
		{
%>				
				<!--<li><a href="../Invoice/ezSubmitFRTInvoice.jsp?fromMenu=Y"><%=munuIetmIcon%>Upload Freight Invoice</a></li>
				<li><a href="../Invoice/ezFreightInvList.jsp?type=3"><%=munuIetmIcon%>View Freight Invoice(s)</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=UPLOAD_FRT_INV"><%=munuIetmIcon%>Upload Freight Invoice</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=VIEW_FRT_INV"><%=munuIetmIcon%>View Freight Invoice(s)</a></li>
<%
		}
		if(userAuth_Vect.contains("UPLOAD_LOAD_INV"))
		{
%>				 
				<!--<li><a href="../Invoice/ezLoadingInvDetails.jsp"><%=munuIetmIcon%>Upload Loading Invoice</a></li>
				<li><a href="../Invoice/ezLoading.jsp"><%=munuIetmIcon%>Upload Loading Invoice</a></li>
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=LOADING"><%=munuIetmIcon%>View Loading Invoice(s)</a></li>
				<li><a href="../Invoice/ezRHLoadingInv.jsp"><%=munuIetmIcon%>Upload RH Loading Invoice</a></li>-->
				
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=UPLOAD_LOADING_INV"><%=munuIetmIcon%>Upload Loading Invoice</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=VIEW_LOADING_INV"><%=munuIetmIcon%>View Loading Invoice(s)</a></li>
				
<%
		}
		if(userAuth_Vect.contains("UPLOD_UNLOAD_IN"))
		{
%>				
				<!--<li><a href="../Invoice/ezUnloadingInvDetails.jsp"><%=munuIetmIcon%>Upload Unloading Invoice</a></li>
				<li><a href="../Invoice/ezUnLoading.jsp"><%=munuIetmIcon%>Upload Unloading Invoice</a></li>
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=UNLOADING"><%=munuIetmIcon%>View Unloading Invoice(s)</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=UPLOAD_UNLOADING_INV"><%=munuIetmIcon%>Upload Unloading Invoice</a></li>
				<li><a href="../Invoice/ezLoadingInvList.jsp?toPage=VIEW_UNLOADING_INV"><%=munuIetmIcon%>View Unloading Invoice(s)</a></li>
				
<%
		}
%>				
				<!--<li><a href="../Purorder/ezFailedSAPPostingsList.jsp?status=UNLOADING"><%=munuIetmIcon%>Failed Invoice Posting List</a></li>-->
			</ul>
		</li> 
<%
		if(userAuth_Vect.contains("INV_LIST"))
		{
%>		
		<li class="treeview">
			<a href="#"><i class="fa fa-calculator"></i> <span>Invoice</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<!--<li><a href="../Purorder/ezListOPENInvoices.jsp?InvStat=O"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=OPEN_INV_LIST"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezListInv.jsp?InvStat=C"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezListInv.jsp?InvStat=A"><%=munuIetmIcon%>All</a></li>-->
				
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=OPEN_INV_LIST"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=CLOSED_INV_LIST"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=ALL_INV_LIST"><%=munuIetmIcon%>All</a></li>
				
				
			</ul>
		</li>
<%
		}
%>
   
		<li class="treeview">
			<a href="#"><i class="fa fa-user"></i> <span>Self Service</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<!--<li><a href="../Misc/ezAstatement.jsp?FROM=MENU"><%=munuIetmIcon%>Account Statement</a></li>			
				<li><a href="../Purorder/ezListPendingDcs.jsp"><%=munuIetmIcon%>Pending Invoice Verification</a></li>
				<li><a href="../Misc/ezListRejectMatDocs.jsp"><%=munuIetmIcon%>Rejected Materials</a></li>
				<li><a href="../Purorder/ezListToBeDelivered.jsp"><%=munuIetmIcon%>To Be Delivered Materials</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=ACCOUNT_STATEMENT"><%=munuIetmIcon%>Account Statement</a></li>			
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=PENDING_INV_VERIFICATION"><%=munuIetmIcon%>Pending Invoice Verification</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=REJECTED_MATERIALS"><%=munuIetmIcon%>Rejected Materials</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=TO_BE_DELIVERED_MATERIALS"><%=munuIetmIcon%>To Be Delivered Materials</a></li>
<%
		if(userAuth_Vect.contains("VEND_CHNG_SUBMIT"))
		{
%>				
				<!--<li><a href="../Misc/ezVendorDetails.jsp"><%=munuIetmIcon%>View / Change Profile</a></li>				
				<li><a href="../Misc/ezVendorOpenRequest.jsp"><%=munuIetmIcon%>View 'Profile Change' Request</a></li>
				<li><a href="../Misc/ezVendorClosedRequests.jsp"><%=munuIetmIcon%>Closed Vendor Requests</a></li>
				<li><a href="../Misc/ezVendorRequests.jsp?Status=REJECTED&type=3"><%=munuIetmIcon%>Rejected Requests</a></li>-->
				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=VIEW_CHANGE_PROFILE"><%=munuIetmIcon%>View / Change Profile</a></li>				
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=PROFILE_CHANGE_REQUEST"><%=munuIetmIcon%>View 'Profile Change' Request</a></li>
				<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=REJECTED_REQUESTS"><%=munuIetmIcon%>Rejected Requests</a></li>
<%
		}
%>
			</ul>
		</li>
<%   
		if(userAuth_Vect.contains("VEND_CHNG_SUBMIT"))
		{
%>
			<!--<li><a href="../Misc/ezVendorQuery.jsp"><i class="fa fa-question-circle"></i> <span>Query</span></a></li>-->
			
			<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=QUERY"><i class="fa fa-question-circle"></i> <span>Query</span></a></li>
<%
		}
%>
		<!--<li><a href="../Purorder/ezGetContractsList.jsp"><i class="fa fa-pencil-square"></i> <span>Contracts</span></a></li>
		<li><a href="../Purorder/ezContract.jsp?OrderType=All"><i class="fa fa-calendar-check-o"></i> <span>Schedule Agreements</span></a></li>-->
		
		<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=CONTRACTS"><i class="fa fa-pencil-square"></i> <span>Contracts</span></a></li>
		<li><a href="../Purorder/ezLoadingMessage.jsp?toPage=SCHEDULE_AGREEMENTS"><i class="fa fa-calendar-check-o"></i> <span>Schedule Agreements</span></a></li>
<%
		if("2".equals(v_UserType))
		{
%>
			<!--<li><a href="../Misc/ezBuyerWelcome.jsp"><i class="fa fa-edit"></i> <span>Buyer Portal</span></a></li>-->	
<%
		}
	} 
	else if("2".equals(v_UserType))
	{
		if(userAuth_Vect.contains("VEND_CHANGE_LIST") || "SSC".equals(userRole))
		{
%> 
			<li class="treeview"> 
				<a href="#"><i class="fa fa-edit"></i> <span>Vendor Profile Requests</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Misc/ezVendorRequests.jsp?Status=OPEN"><%=munuIetmIcon%>Open Requests</a></li>
					<li><a href="../Misc/ezVendorRequests.jsp?Status=CLOSED"><%=munuIetmIcon%>Approved Requests</a></li>
					<li><a href="../Misc/ezStatReport.jsp"><%=munuIetmIcon%>Status Report</a></li>
					<!--<li><a href="../Misc/ezVendorRequests.jsp?Status=REJECTED&type=2">Rejected</a></li>-->
				</ul>
			</li>
<%
		}	
		if(userAuth_Vect.contains("ENQUIRIES_LIST"))
		{
%>			
			<li><a href="../Misc/ezEnquiryList.jsp"><i class="fa fa-edit"></i> <span>Vendor corporate Enquiry</span></a></li>
<%
		}	
		if(userAuth_Vect.contains("RFQ_LIST"))
		{
%>
			<li class="treeview">
				<a href="#"><i class="fa fa-newspaper-o"></i> <span>Request For Quote[RFQ]</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../RFQ/ezListRFQs.jsp?menuItem=RFQ&type=ToQuote"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?menuItem=RFQ&type=Quoted"><%=munuIetmIcon%>View Responded Quotations</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?menuItem=RFQ&type=EditQuoted"><%=munuIetmIcon%>Ex-works RFQs</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?menuItem=RFQ&type=ExpiredRFQ"><%=munuIetmIcon%>Extend Expired RFQs</a></li>
<%					
			if(userAuth_Vect.contains("QCF_LIST"))
			{
%>		
				<li><a href="../RFQ/ezToActQCFsList1.jsp"><%=munuIetmIcon%>Quotes Compare Form[QCF]</a></li>
				<!--<li><a href="javaScript:funEDIT()"><%=munuIetmIcon%>Quotes Compare Form[QCF]</a></li>-->
				<li><a href="../RFQ/ezClosedQCFsList.jsp"><%=munuIetmIcon%>Closed QCF(s)</a></li>
<%
			}
%>
				</ul>
			</li>    
<%
		}
		if(userAuth_Vect.contains("PO_LIST"))
		{
%>		
			<li class="treeview">
				<a href="#"><i class="fa fa-file-text"></i> <span>Purchase Order[PO]</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=NotAcknowledged&selVendor=null"><%=munuIetmIcon%>To Be Accepted By Vendor</a></li>	    		    
					<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=Acknowledged&selVendor=null"><%=munuIetmIcon%>Accepted By Vendor</a></li>
					<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=Rejected&selVendor=null"><%=munuIetmIcon%>Rejected By Vendor</a></li>
					<li><a href="../Purorder/ezListPOs.jsp?menuItem=PO&OrderType=Open"><%=munuIetmIcon%>Open POs-Vendor Wise</a></li>
					<!-- <li><a href="../Purorder/ezClosedListPOs.jsp?menuItem=PO&FROM=MENU"><%=munuIetmIcon%>Closed POs-Vendor Wise</a></li>-->
					<li><a href="../Purorder/ezListPOs.jsp?menuItem=PO&OrderType=Closed"><%=munuIetmIcon%>Closed POs-Vendor Wise</a></li>
				</ul>
			</li>   
<%
		}
		if(userAuth_Vect.contains("INV_LIST"))
		{
%>
		<li class="treeview">
			<a href="#"><i class="fa fa-calculator"></i> <span>Invoice</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="../Purorder/ezListOPENInvoices.jsp?menuItem=INV&InvStat=O"><%=munuIetmIcon%>Open-Vendor Wise</a></li>
				<li><a href="../Purorder/ezListInv.jsp?menuItem=INV&InvStat=C"><%=munuIetmIcon%>Closed-Vendor Wise</a></li>
				<li><a href="../Purorder/ezListInv.jsp?menuItem=INV&InvStat=A"><%=munuIetmIcon%>All</a></li>
			</ul>
		</li>
<%
		}
		if(userAuth_Vect.contains("ACC_STATEMENT"))
		{
%>
			<li><a href="../Misc/ezAstatement.jsp?menuItem=ACSTMT&FROM=MENU"><%=munuIetmIcon%>Account Statement-Vendor Wise</a></li>	
<%
		}
		if(userAuth_Vect.contains("ASN_LIST"))
		{
%>
			<li class="treeview">
				<a href="#"><i class="fa fa-truck"></i> <span>Shipments</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
<%
			if(userAuth_Vect.contains("ASN_APPROVE"))
			{
%>				
				<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=Y"><%=munuIetmIcon%>To Be Approved</a></li>
<%
			}
%>
					<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=A"><%=munuIetmIcon%>Approved</a></li>
					<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=R"><%=munuIetmIcon%>Rejected</a></li>
				</ul>
			</li>    
<%
		}	
		if(userAuth_Vect.contains("PO_INV_LIST") || userAuth_Vect.contains("FRT_INV_LIST") || userAuth_Vect.contains("LOAD_INV_LIST") || userAuth_Vect.contains("UNLOAD_INV_DTL"))
		{
%>
	<li class="treeview">
		<a href="#"><i class="fa fa-upload"></i> <span>Invoices Submitted</span> <i class="fa fa-angle-right pull-right"></i></a> 
		<ul class="treeview-menu">
<%
		if(userAuth_Vect.contains("PO_INV_LIST"))
		{
%>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=I"><%=munuIetmIcon%>View Material/Service Inv.</a></li>
<%
		}
		if(userAuth_Vect.contains("FRT_INV_LIST"))
		{
%>
				<li><a href="../Invoice/ezFreightInvList.jsp?type=2"><%=munuIetmIcon%>View Freight Invoice(s)</a></li>
<%
		}
		if(userAuth_Vect.contains("LOAD_INV_LIST"))
		{
%>				
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=LOADING"><%=munuIetmIcon%>View Loading Invoice(s)</a></li>
<%
		}
		if(userAuth_Vect.contains("UNLOAD_INV_DTL"))
		{
%>				
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=UNLOADING"><%=munuIetmIcon%>View Unloading Invoice(s)</a></li>
<%
		}
%>
			</ul>
		</li>
<%
		}
		if(userAuth_Vect.contains("ADD_STMT_CNFRM"))
		{	
%>		
			<li class="treeview">
				<a href="#"><i class="fa fa-edit"></i> <span>Confirmations</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Confirmations/ezAddConfirmations.jsp"><%=munuIetmIcon%>Add Statement Confirmations</a></li>
					<li><a href="../Confirmations/ezListAccStmtConfHeader.jsp"><%=munuIetmIcon%>List Statement Confirmations</a></li>	
					<li><a href="../News/ezListNews.jsp"><%=munuIetmIcon%>News</a></li>					
				</ul>
			</li>
<%
		}
	
		if(userAuth_Vect.contains("ENQUIRIES_LIST"))
		{	
%>
			<!--<li><a href="../Misc/ezEnquiryList.jsp"><i class="fa fa-edit"></i> <span>Vendor corporate Enquiry</span></a></li>-->
			<!--<li><a href="../Misc/ezVendorQuery.jsp"><i class="fa fa-edit"></i> <span>Query</span></a></li>-->
<%
		}
		if(userAuth_Vect.contains("TEMP_USER_CREATE"))
		{
%>
			<li class="treeview">
				<a href="#"><i class="fa fa-user"></i> <span>Temporary Users</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Misc/ezTempUserCreation.jsp"><%=munuIetmIcon%>Create User</a></li>
					<li><a href="../Misc/ezTempUsersList.jsp"><%=munuIetmIcon%>User-Authorizations</a></li>	
					<li><a href="../RFQ/ezSelectTempUsers.jsp"><%=munuIetmIcon%>Send RFQ For Multiple Users</a></li>	
				</ul>
			</li>	            	
<%		
		}
		if("MDM".equals(userRole))//&& userAuth_Vect.contains("VN_POST_TO_SAP"))
		{
%>
			<li class="treeview"> 
				<a href="#"><i class="fa fa-edit"></i> <span>Vendor Profile Requests</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Misc/ezVendorRequests.jsp?Status=OPEN&WFStatus=APPROVED"><%=munuIetmIcon%>To Be Posted</a></li>
					<li><a href="../Misc/ezVendorRequests.jsp?Status=POSTED&WFStatus=POSTEDTOSAP"><%=munuIetmIcon%>Posted</a></li>
				</ul>
			</li>		
<%		
		}		
%>
		<!--<li><a href="../Misc/ezGetVendorsList.jsp"><i class="fa fa-edit"></i> <span>Vendor Portal</span></a></li>-->
<%		
	}
	else if("4".equals(v_UserType))
	{
		if("Y".equals((String)session.getValue("ALLOW_RFQ")))
		{
%>
			<li class="treeview">
				<a href="#"><i class="fa fa-edit"></i> <span>RFQ</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">    
					<li><a href="../RFQ/ezListRFQs.jsp?type=ToQuote"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?type=Quoted"><%=munuIetmIcon%>View Responded Quotations</a></li>
				</ul>
			</li>	
<%
		}
		if("Y".equals((String)session.getValue("ALLOW_REG"))) 
		{
%>
			<li><a href="../Misc/ezNewVendorRegistrationFormNew.jsp"><i class="fa fa-edit"></i> <span>Registration Form</span></a></li>
<%
		}
	}
		
	if("2".equals(v_UserType) || "3".equals(v_UserType) || "4".equals(v_UserType))
	{
%>
		<li><a href="../Misc/ezPassword.jsp?fromMenu=Y"><i class="fa fa-key"></i> <span>Change Password</span></a></li>
		<li><a href="../Misc/ezLogout.jsp"><i class="fa fa-sign-out"></i> <span>Logout</span></a></li>
<%
	}
%>
	 
     </section>
        <!-- /.sidebar -->
      </aside>
