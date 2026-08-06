<!DOCTYPE html>    
<!--                     
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->            
<html>            
<link href="../../../../EzCommon/CSS/dataurl.css" rel="stylesheet" />
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/fuzzycomplete.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.css">
<head>                
	<%@ include file="ezHeaderIncludes.jsp"%> 
	<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iLang_Labels.jsp"%> 
	<%//@ include file="../../../../EzVendor/Includes/JSPs/Labels/iMenuLabels.jsp"%>
	<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iHeaderLabels.jsp"%>
<script>
	var allowedFileExt = ["PDF","PNG","JPG","JPEG","MSG","XLS","XLSX","DOC","DOCX"];
	var allowedFileStr = "PDF,PNG,JPG,JPEG,MSG,XLS,XLSX,DOC,DOCX";
	var allowedFileSize = 11;
</script>
<style>
@media print
{
	.no-print
	{
		display:none !important;
	}
}

</style>
<%       
	java.util.Vector userAuth_Vect   = (java.util.Vector)session.getValue("USERAUTHS");
	String hdrSite = (String)session.getValue("SITE");
	//out.println(":::::userAuth_Vect::::::"+userAuth_Vect);
	String munuIetmIcon = "<i class=\"fa fa-circle-o text-yellow\"></i>";
	//out.println(v_UserType+":::"+v_UserType);
	if("3".equals(v_UserType))//  || "VENDOR".equals(v_PortalType))
	{
		
		//if(userAuth_Vect.contains("RFQ_LIST"))
		{
%> 
			<li class="treeview"> 
				<!--<a href="#"><i class="fa fa-newspaper-o"></i> <span>RFQ</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../RFQ/ezListRFQs.jsp?type=ToQuote"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?type=Quoted"><%=munuIetmIcon%>View Responded Quotations</a></li>
				</ul>-->
				
				<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=rfqs_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
					<ul class="treeview-menu">
						<li><a href="../RFQ/ezListRFQs.jsp?type=New"><%=list_L%></a></li>
						<!--<li><a href="../RFQ/ezRfqQueries.jsp?listType=ALL">RFQ Queries</a></li>-->
					</ul>				
			</li>
			<li class="treeview"> 
				<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=auc_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
					<ul class="treeview-menu">
						<!--<li><a href="../Request/ezListAuctionRequests.jsp?type=New">To Acknowledge</a></li>
						<li><a href="../Request/ezListAuctionRequests.jsp?type=Acknowledged">Acknowledged</a></li>
						<li><a href="../Request/ezListAuctionRequests.jsp?type=Rejected">Rejected</a></li>-->
						<li><a href="../Request/ezListAuctionRequests.jsp?type=Main"><%=list_L%></a></li>
						<li><a href="../Request/ezListActiveAuctions.jsp"><%=currAuc_L%></a></li>
						<li><a href="../Request/ezAuctionHistoryBySupplier.jsp"><%=aucHis_L%></a></li>
					</ul>				
			</li>
			
<%
		}
		/*
		if(userAuth_Vect.contains("PO_LIST"))
		{
%>
		
		<li class="treeview">
			<a href="#"><i class="fa fa-file-text"></i> <span>Purchase Order</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=NotAcknowledged&selVendor=null"><%=munuIetmIcon%>To Be Acknowledged</a></li>	    		    
				<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Acknowledged&selVendor=null"><%=munuIetmIcon%>Accepted</a></li>
				<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=Rejected&selVendor=null"><%=munuIetmIcon%>Rejected</a></li>
				<!--<li><a href="../Purorder/ezListPOs.jsp?OrderType=Open&menuItem=PO"><%=munuIetmIcon%>Open</a></li>-->
				<!-- <li><a href="../Purorder/ezClosedListPOs.jsp"><%=munuIetmIcon%>Closed</a></li>-->
				<!--<li><a href="../Purorder/ezListPOs.jsp?OrderType=Closed&menuItem=PO"><%=munuIetmIcon%>Closed</a></li>-->
				<!--<li><a href="../Purorder/ezListPOs.jsp?OrderType=Return"><%=munuIetmIcon%>Return Pos</a></li>-->
				<li><a href="../Prdplan/ezPOPrdPlanList.jsp?FROM=MENU&docStatus=ALL"><%=munuIetmIcon%>Production Plan</a></li>	    		    
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
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=A"><%=munuIetmIcon%>List</a></li>
				<!--<li><a href="../Shipment/ezGetVendorShipments.jsp?status=Y"><%=munuIetmIcon%>To Be Approved</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=A"><%=munuIetmIcon%>Approved</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=R"><%=munuIetmIcon%>Rejected</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=A&postedToSAP=Y"><%=munuIetmIcon%>Posted ASN Invoices List</a></li>-->
			</ul>
		</li>
<%
		} 
		if("300".equals(hdrSite))
		{
%>
			<li><a href="../Shipment/ezGetDelNoteList.jsp"><i class="fa fa-upload"></i>Upload Invoice.</a></li>
<%
		}
		*/
		/*
%>
		<li class="treeview">
			<a href="#"><i class="fa fa-upload"></i> <span>Upload Invoice</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
<%		
		
		{
%>		
				<li><a href="../Shipment/ezInvoiceWithoutASN.jsp?FROM=MENU&TYPE=WOASN"><%=munuIetmIcon%>Upload Material/Service Inv.</a></li>
				<li><a href="../Shipment/ezGetVendorShipments.jsp?status=I"><%=munuIetmIcon%>View Material/Service Inv.</a></li>
<%
		}
		if(userAuth_Vect.contains("UPLOAD_FRT_INV"))
		{
%>				
				<li><a href="../Invoice/ezSubmitFRTInvoice.jsp?fromMenu=Y"><%=munuIetmIcon%>Upload Freight Invoice</a></li>
				<li><a href="../Invoice/ezFreightInvList.jsp?type=3"><%=munuIetmIcon%>View Freight Invoice(s)</a></li>
<%
		}
		if(userAuth_Vect.contains("UPLOAD_LOAD_INV"))
		{
%>				 
				<!--<li><a href="../Invoice/ezLoadingInvDetails.jsp"><%=munuIetmIcon%>Upload Loading Invoice</a></li>-->
				<li><a href="../Invoice/ezLoading.jsp"><%=munuIetmIcon%>Upload Loading Invoice</a></li>
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=LOADING"><%=munuIetmIcon%>View Loading Invoice(s)</a></li>
				<!--<li><a href="../Invoice/ezRHLoadingInv.jsp"><%=munuIetmIcon%>Upload RH Loading Invoice</a></li>-->
				
<%
		}
		if(userAuth_Vect.contains("UPLOD_UNLOAD_IN"))
		{
%>				
				<!--<li><a href="../Invoice/ezUnloadingInvDetails.jsp"><%=munuIetmIcon%>Upload Unloading Invoice</a></li>-->
				<li><a href="../Invoice/ezUnLoading.jsp"><%=munuIetmIcon%>Upload Unloading Invoice</a></li>
				<li><a href="../Invoice/ezLoadingInvList.jsp?docType=UNLOADING"><%=munuIetmIcon%>View Unloading Invoice(s)</a></li>
				
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
				<li><a href="../Purorder/ezListOPENInvoices.jsp?InvStat=O"><%=munuIetmIcon%>Open</a></li>
				<li><a href="../Purorder/ezListInv.jsp?InvStat=C"><%=munuIetmIcon%>Closed</a></li>
				<li><a href="../Purorder/ezListInv.jsp?InvStat=A"><%=munuIetmIcon%>All</a></li>
			</ul>
		</li>
<%
		}
		
%>
   
		<li class="treeview">
			<a href="#"><i class="fa fa-user"></i> <span>Self Service</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="../Misc/ezAstatement.jsp?FROM=MENU"><%=munuIetmIcon%>Account Statement</a></li>			
				<li><a href="../Shipment/ezListASNPendingForGR.jsp"><%=munuIetmIcon%>ASN Pending For GR</a></li>
				<li><a href="../Purorder/ezListPendingDcs.jsp"><%=munuIetmIcon%>Pending Invoice Verification</a></li>
				<!--<li><a href="../Misc/ezListRejectMatDocs.jsp"><%=munuIetmIcon%>Rejected Materials</a></li>-->
				<li><a href="../Purorder/ezListToBeDelivered.jsp"><%=munuIetmIcon%>To Be Delivered Materials</a></li>
<%		
		if(userAuth_Vect.contains("VEND_CHNG_SUBMIT"))
		{
%>				
				<li><a href="../Misc/ezVendorDetails.jsp"><%=munuIetmIcon%>View / Change Profile</a></li>				
				<li><a href="../Misc/ezVendorOpenRequest.jsp"><%=munuIetmIcon%>View 'Profile Change' Request</a></li>
				<!--<li><a href="../Misc/ezVendorClosedRequests.jsp"><%=munuIetmIcon%>Closed Vendor Requests</a></li>-->
				<li><a href="../Misc/ezVendorRequests.jsp?Status=REJECTED&type=3"><%=munuIetmIcon%>Rejected Requests</a></li>
<%
		}

%>
			</ul>
		</li>
<%   
		*/
		if(userAuth_Vect.contains("VEND_CHNG_SUBMIT"))
		{
%>
			<li><a href="../Misc/ezVendorQuery.jsp"><i class="fa fa-question-circle"></i> <span><%=query_L%></span></a></li>
<%
		}
		/*
%>
		<li><a href="../Purorder/ezGetContractsList.jsp"><i class="fa fa-pencil-square"></i> <span>Contracts</span></a></li>
		<li><a href="../Purorder/ezContract.jsp?OrderType=All"><i class="fa fa-calendar-check-o"></i> <span>Schedule Agreements</span></a></li>
<%
		*/
		if("2".equals(v_UserType))
		{
%>
			<!--<li><a href="../Misc/ezBuyerWelcome.jsp"><i class="fa fa-edit"></i> <span>Buyer Portal</span></a></li>-->	
<%
		}
	} 
	else if("2".equals(v_UserType))
	{
%>		

		<li class="treeview"> 
			<a href="#"><i class="fa fa-edit"></i> <span><%=vendReg_L%></span> <i class="fa fa-angle-right pull-right"></i></a>
			<ul class="treeview-menu">
<%
		if("PP".equals(userRole) || "BY".equals(userRole))
		{
			if(isNABuyer)
			{
%>				
				<li><a href="../Misc/ezTempNAUserCreation.jsp"><%=munuIetmIcon%><%=inviteVend_L%></a></li>
<%				
			}else{
%>			
				<li><a href="../Misc/ezTempUserCreation.jsp"><%=munuIetmIcon%><%=inviteVend_L%></a></li>
<%
			}
%>			
				<li><a href="../Misc/ezTempVendList.jsp?type=ALL&venType=IN""><%=munuIetmIcon%><%=new_L%></a></li>
<%
		}
%>				
				<!--<li><a href="../Misc/ezListVendReg.jsp?type=Act&menuItem=vendReg"><%=munuIetmIcon%>List</a></li>-->
				<li><a href="../Misc/ezVNRList.jsp?type=ALL&venType=IN"><%=munuIetmIcon%><%=list_L%></a></li>
<%
		if("VAR".equals(userRole))
		{
%>				
				<li><a href="../Misc/ezVNRList.jsp?type=Pst"><%=munuIetmIcon%>To Post</a></li>
<%	
		}
%>
				<!--<li><a href="../Misc/ezListVendReg.jsp?statusSel=TOBEPOSTED&type=Act&menuItem=vendReg"><%=munuIetmIcon%>Approved</a></li>-->				
				<!--<li><a href="../Misc/ezVNRList.jsp?type=Apr&venType=IN"><%=munuIetmIcon%>Vendor Registration Reports</a></li> -->
				
			</ul>
		</li>
<%
		if("PP".equals(userRole) || "BY".equals(userRole))
		{
%>
			<li class="treeview"> 
				<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=budgPrice_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../RFQ/ezListFYMatBudgetPrice.jsp"><%=munuIetmIcon%><%=list_L%></a></li>
					<li><a href="../RFQ/ezPriceUpload.jsp"><%=munuIetmIcon%><%=upload_L%></a></li>
				</ul>	
			<li>
			<li class="treeview">
				<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=rfqs_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
 		  		<ul class="treeview-menu">
 		  		  <li><a href="../RFQ/ezPrePRList.jsp?Status=R"><%=fromPrs_L%></a></li>
 		  		  <!--<li><a href="../RFQ/ezPrStatus.jsp?Status=R">PR Status</a></li>-->
 		  		  <li><a href="../Request/ezSelectAuctionMat.jsp?from=RFQ"><%=fromMat_L%></a></li>
 		  		  <li><a href="../RFQ/ezListRFQs.jsp?type=ALL&rfqType=DOM"><%=rfqList_L%></a></li>				
 		  		  <!--<li><a href="../Misc/ezTempRfqVendor.jsp">Create Vendor</a></li>-->
				</ul>
			</li>
<%
		}	
%>			
 			<li class="treeview">
<%
			if(!"VAR".equals(userRole))
			{
				if("PP".equals(userRole)|| "BY".equals(userRole))
				{
%>			
 				  <a  id="qcfmenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=qcfs_L%></span><i class="fa fa-angle-left pull-right"></i></a> 			
 				  <ul class="treeview-menu">
 				  <li><a href="../RFQ/ezListQcfs.jsp?type=New&rfqType=DOM"><%=list_L%></a></li>
 				  <li><a href="../RFQ/ezQCSList.jsp?type=Sub"><%=toAct_L%></a></li>
 				  <li><a href="../RFQ/ezQCFPOList.jsp"><%=prPoRep_L%></a></li>
 				  </ul> 				  
<%
				}else{
%>
				<a  id="qcfmenu" href="../RFQ/ezQCSList.jsp?type=ALL"><i class="fa fa-newspaper-o"></i> <span><%=qcfs_L%></span></a> 	
				<a  id="pomenu" href="../RFQ/ezQCFPOList.jsp"><i class="fa fa-newspaper-o"></i> <span><%=purcOrder_L%></span></a> 	
				
<%			
				}
			
%>	

 			</li>
			
 			<li class="treeview"> 
			<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span><%=auc_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Request/ezSelectAuctionMat.jsp?from=AUCT"><%=create_L%></a></li>
					<li><a href="../Request/ezAuctionQCFs.jsp?"><%=createFromQcf_L%></a></li>
					<li><a href="../Request/ezListAuctionRequests.jsp?type=Main"><%=list_L%></a></li>
					<!--<li><a href="../Request/ezViewResponses.jsp">View Responses</a></li>-->
					<li><a href="../Request/ezListActiveAuctions.jsp"><%=currAuc_L%></a></li>
					<li><a href="../Request/ezListAuctionRequests.jsp?type=Closed"><%=compAuc_L%><%//=comp_auc_L%></a></li>
					<li><a href="../Request/ezAuctionList.jsp?type=ALL"><%=subAuc_L%></a></li>
					<li><a href="../Request/ezAuctionPendingForPO.jsp"><%=createPO_L%></a></li>
					<!--<li><a href="../Request/ezAuctionPOList.jsp">Auction_PO Reports</a></li>-->
					<li><a href="../MasterData/ezAddDestination.jsp"><%=dest_L%></a></li>
					<li><a href="../Request/ezAuctionLogs.jsp?type=ALL"><%=logs_L%></a></li>
					<!--<li><a href="../Request/ezAuctionHistoryByAuctionId.jsp">Search By Name</a></li>
					<li><a href="../Request/ezAuctionHistoryBySupplier.jsp">Search By Supplier</a></li>-->
				</ul>				
			</li>
			<li class="treeview"> 
				<a id="tatMenu" href="#"><i class="fa fa-bar-chart"></i> <span><%=reports_L%></span> <i class="fa fa-angle-left pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a  id="pomenu" href="../RFQ/ezRfqMisReport.jsp?selPlant=ALL"><%=munuIetmIcon%><span><%=rfqReport_L%></span></a></li>
					<li><a  id="pomenu" href="../RFQ/ezQCFPOList.jsp"><%=munuIetmIcon%><span><%=prPoReport_L%></span></a></li>
					<li><a href="../RFQ/ezTatReport.jsp"><%=munuIetmIcon%><span><%=tatReport_L%></span></a></li>
					<li><a href="../Request/ezAuctionPOList.jsp"><%=munuIetmIcon%><span><%=aucPOreport_L%></span></a></li>
					<li><a href="../RFQ/ezMatPrices.jsp"><%=munuIetmIcon%><span><%=priceTrends_L%></span></a></li>
<%	
			if("VIW".equals(userRole))
			{
%>					
					<li><a href="../Misc/ezVendRegReport.jsp?type=Apr&venType=IN"><%=munuIetmIcon%><span><%=vendRegReport_L%></span></a></li>
<%
			}else{
%>
					<li><a href="../Misc/ezVNRList.jsp?type=Apr&venType=IN"><%=munuIetmIcon%><span><%=vendRegReport_L%></span></a></li>
<%
			}
%>	
					<li><a href="../Request/ezAuctionVendIPReport.jsp"><%=munuIetmIcon%><span><%=aucVendReport_L%></span></a></li>
				</ul>
			</li> 			
<%
		}
		
		//if(userAuth_Vect.contains("PO_LIST"))
		{
%>		
			<li class="treeview">
				<a href="#"><i class="fa fa-file-text"></i> <span><%=purcOrder_L%></span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
					<li><a href="../Purorder/ezListUnreleasedPOs.jsp"><%=munuIetmIcon%><%=ammendPO_L%></a></li>
					<li><a href="../Purorder/ezSubmittedPOs.jsp?type=ALL"><%=munuIetmIcon%><%=submitPO_L%></a></li>
					<!--<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=NotAcknowledged&selVendor=null"><%=munuIetmIcon%>To Be Accepted By Vendor</a></li>	    		    
					<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=Acknowledged&selVendor=null"><%=munuIetmIcon%>Accepted By Vendor</a></li>
					<li><a href="../Purorder/ezListAcknowledgedPOs.jsp?menuItem=PO&FROM=MENU&type=Rejected&selVendor=null"><%=munuIetmIcon%>Rejected By Vendor</a></li>
					<li><a href="../Prdplan/ezPOPrdPlanList.jsp?FROM=MENU&docStatus=ALL"><%=munuIetmIcon%>Production Plan</a></li>	    		    
					<li><a href="../Purorder/ezListPOs.jsp?menuItem=PO&OrderType=Open"><%=munuIetmIcon%>Open POs-Vendor Wise</a></li>
					<li><a href="../Purorder/ezClosedListPOs.jsp?menuItem=PO&FROM=MENU"><%=munuIetmIcon%>Closed POs-Vendor Wise</a></li>
					<li><a href="../Purorder/ezListPOs.jsp?menuItem=PO&OrderType=Closed"><%=munuIetmIcon%>Closed POs-Vendor Wise</a></li>-->
				</ul>
			</li>   
<%
		}
		/*
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
		//if(userAuth_Vect.contains("ASN_LIST"))
		{
%>
			<li class="treeview">
				<a href="#"><i class="fa fa-truck"></i> <span>Shipments</span> <i class="fa fa-angle-right pull-right"></i></a> 
				<ul class="treeview-menu">
<%
			//if(userAuth_Vect.contains("ASN_APPROVE"))
			{
%>				
				<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=A"><%=munuIetmIcon%>List</a></li>
<%
			}
%>
					<!--<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=A"><%=munuIetmIcon%>Approved</a></li>
					<li><a href="../Shipment/ezGetVendorShipments.jsp?menuItem=ASN&status=R"><%=munuIetmIcon%>Rejected</a></li>-->
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
		*/
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
				<<ul class="treeview-menu">    
					<!--<li><a href="../RFQ/ezListRFQs.jsp?type=ToQuote"><%=munuIetmIcon%>RFQ’s To Be Responded</a></li>
					<li><a href="../RFQ/ezListRFQs.jsp?type=Quoted"><%=munuIetmIcon%>View Responded Quotations</a></li>-->
					<li><a href="../RFQ/ezListRFQs.jsp?type=New">List</a></li>
				</ul>
			</li>	
			<li class="treeview"> 
				<a id="rfqMenu" href="#"><i class="fa fa-newspaper-o"></i> <span>Auction</span> <i class="fa fa-angle-left pull-right"></i></a> 
					<ul class="treeview-menu">
						<li><a href="../Request/ezListAuctionRequests.jsp?type=Main">List</a></li>
						<li><a href="../Request/ezListActiveAuctions.jsp">Current Auctions</a></li>
						<li><a href="../Request/ezAuctionHistoryBySupplier.jsp">Auction History</a></li>
					</ul>				
			</li>
<%
		}
		if("Y".equals((String)session.getValue("ALLOW_REG"))) 
		{
%>
			<li><a href="../Misc/ezPageRedirect.jsp"><i class="fa fa-edit"></i> <span><%=regForm_L%></span></a></li>

<%
		}
	}
	
	if("2".equals(v_UserType) || "3".equals(v_UserType) || "4".equals(v_UserType))
	{
%>
		<!--<li><a href="../RFQ/ezUserVideoManuals.jsp"><%=munuIetmIcon%>User Video Manual</a></li>-->
		<li class="treeview">
			<a href="#"><i class="fa fa-edit"></i> <span><%=userVideoManu_L%></span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="../VideoManuals/ezOverView.jsp"><%=munuIetmIcon%><%=overView_L%></a></li>
				<li><a href="../VideoManuals/ezUserVideoManuals.jsp"><%=munuIetmIcon%><%=userManuals_L%></a></li>
				<li><a href="../VideoManuals/ezVendRegManuals.jsp"><%=munuIetmIcon%><%=vendReg_L%></a></li>
				<li><a href="../VideoManuals/ezPRPOManuals.jsp"><%=munuIetmIcon%><%=PRPOprocess_L%></a></li>
				<li><a href="../VideoManuals/ezUserAuctionManuals.jsp"><%=munuIetmIcon%><%=auc_L%></a></li>
				<li><a href="../VideoManuals/ezUserPOAmndManuals.jsp"><%=munuIetmIcon%><%=POAmmend_L%></a></li>
			</ul>
		</li>	
<%
	}
	if("PP".equals(userRole)) 
	{
%>
		<li class="treeview">
			<a href="#"><i class="fa fa-edit"></i> <span>Master Data</span> <i class="fa fa-angle-right pull-right"></i></a> 
			<ul class="treeview-menu">
				<li><a href="ezGetWFTemplates.jsp"><i class="fa fa-edit"></i> <span>Update Workflow</span></a></li>
			</ul>
			<ul class="treeview-menu">
				<li><a href="ezGetTemplates.jsp"><i class="fa fa-edit"></i> <span>Update Template</span></a></li>
			</ul>
			<ul class="treeview-menu">
				<li><a href="ezMasterUsersList.jsp"><i class="fa fa-edit"></i> <span>Users List</span></a></li>
			</ul>
		</li>
	
<%
	}
	
	if("2".equals(v_UserType) || "3".equals(v_UserType) || "4".equals(v_UserType))
	{
%>
		<li><a href="../Misc/ezPassword.jsp?fromMenu=Y"><i class="fa fa-key"></i> <span><%=changePwd_L%></span></a></li>
		<li><a href="../Misc/ezLogout.jsp"><i class="fa fa-sign-out"></i> <span><%=logout_L%></span></a></li>
<%
	}
%>
	 
     </section>
        <!-- /.sidebar -->
      </aside>
