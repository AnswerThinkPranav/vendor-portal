<%
	String chkUserRole = (String)session.getValue("USERROLE");
%>
<script>

<%
	if("SO".equals(userRole))
	{
%>
		EZ_VENDOR2 = 
		[
			["Vedor Dispatched","javascript:void(0)",1,1,"No"],
			["MTR Returned","javascript:void(0)",1,1,"No"],
			["Report","",0,1,"No"]
		]
		EZ_VENDOR2_1 = 
		[
			["Rec. Qty Updated","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=RETURN",0,1,"No"],
			["Rec. Qty To Be Updated","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=RETURN",0,1,"No"]
		]
		EZ_VENDOR2_2 = 
		[
			["Add","../ReturnableItems/ezAddReturnItemDetails.jsp?flagStatus=RETURN",0,1,"No"],
			["Rec. Qty Updated By Vendor","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=RETURN",0,1,"No"],
			["Rec. Qty To Be Updated By Vendor","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=RETURN",0,1,"No"]
		]
		EZ_VENDOR4 = 
		[
			["Open","../Purorder/ezInvListWait.jsp?InvStat=O",0,1,"No"],
			["Closed","../Purorder/ezInvListWait.jsp?InvStat=C",0,1,"No"],
			["All","../Purorder/ezInvListWait.jsp?InvStat=A",0,1,"No"]
			,["Debit Notes","../Misc/ezListOfDebitNotes.jsp",0,1,"No"]
		]
		
<%
	}
	else if("QA".equals(userRole))
	{
%>	
		EZ_VENDOR2= 
		[
			["Add","../Misc/ezAddAudit.jsp",0,1,"No"],
			["List","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=AUDIT_FINDINGS",0,1,"No"]
		]
<%
	}
	else if("FN".equals(userRole))
	{
%>
		EZ_VENDOR2 = 
		[
			["Open","../Purorder/ezInvListWait.jsp?InvStat=O",0,1,"No"],
			["Closed","../Purorder/ezInvListWait.jsp?InvStat=C",0,1,"No"],
			["All","../Purorder/ezInvListWait.jsp?InvStat=A",0,1,"No"]
		]
		EZ_VENDOR3 = 
		[
			["GRs To Be Invoiced","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=GRTOBE_INVOICED",0,1,"No"],
			["Outstanding Balance","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=VEND_BALANCE",0,1,"No"],
			["A/C Statement","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=ACC_STATEMENT",0,1,"No"]
			,["Statement Confirm","",1,1,"No"]
			,["Debit Notes","../Misc/ezListOfDebitNotes.jsp",0,1,"No"]
		]
		EZ_VENDOR3_1 = 
		[
			["To Be Confirmed","../Misc/ezSelectIPParamas.jsp?Flag=TBC",0,1,"No"],
			["Confirmed","../Misc/ezSelectIPParamas.jsp?Flag=C",0,1,"No"]
		]
<%
	}
	else
	{
%>
		EZ_VENDOR1 = 
		[
			["Request Quote","../RFQ/ezListRFQs.jsp?type=ToQuote",0,1,"No"],
			["View Quotations","../RFQ/ezListRFQs.jsp?type=Quoted",0,1,"No"],
			["All","../RFQ/ezListRFQs.jsp?type=All",0,1,"No"]

		]

		EZ_VENDOR2 = 
		[
			["To be Acknowledged POs","javascript:void(0)",1,1,"No"],	
			["Accepted POs","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PO_ACKNOWLEDGED",0,1,"No"],
			["Rejected POs","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PO_REJECTED",0,1,"No"],
			["Open","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=OPEN_PO_LIST",0,1,"No"],
			["Closed","../Purorder/ezClosedListPOs.jsp",0,1,"No"],
			["All","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=ALL_PO_LIST",0,1,"No"],
			["Service POs","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=SER_PO_LIST",0,1,"No"],
			["Return POs","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=RET_PO_LIST",0,1,"No"]
			//,["Upload Excel","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PO_EXCEL",0,1,"No"]
		]

		EZ_VENDOR2_1 = 
		[
			["By Vendor","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PO_TOBE_ACK",0,1,"No"],
			["By All Vendors","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PO_TOBE_ACK&selVendor=ALL",0,1,"No"],
			["Not Ack in 24 Hrs","../Purorder/ezGetAllToBeAckPOs.jsp",0,1,"No"]
		]


		EZ_VENDOR3 = [
			["To Be Signed By Buyer","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=CON_TO_BE_SIGNED_BY_BUY",0,1,"No"],
			["Signed By Buyer","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=CON_SIGNED_BY_BUY",0,1,"No"],
			["To Be Signed By Vendor","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=CON_TO_BE_SIGNED_BY_VEN",0,1,"No"],
			["Signed By Vendor","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=CON_SIGNED_BY_VEN",0,1,"No"]
		]
		EZ_VENDOR4 = [
			["All","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=ALL_SA_LIST",0,1,"No"]
		]
		EZ_VENDOR5 = 
		[
			["Add ASN","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=TO_BE_ADD_SHIP_PO",0,1,"No"],
			["View ASN","../Shipment/ezViewShimentList.jsp?orderBase=po",0,1,"No"],
			["E-SUGAM Docs","",1,1,"No"]	
			//,["ASN's Pending For GR","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=PEND_ASN_LIST",0,1,"No"]
		]
		EZ_VENDOR5_1 = 
		[
			["Uploaded","../Shipment/ezListViewEsugamASNs.jsp?fromLink=UPLOADED",0,1,"No"],
			["To Be Uploaded","../Shipment/ezListViewEsugamASNs.jsp?fromLink=TOBEUP",0,1,"No"],
		]

		EZ_VENDOR6 = 
		[
			["Open","../Purorder/ezInvListWait.jsp?InvStat=O",0,1,"No"],
			["Closed","../Purorder/ezInvListWait.jsp?InvStat=C",0,1,"No"],
			["All","../Purorder/ezInvListWait.jsp?InvStat=A",0,1,"No"]
		]

		EZ_VENDOR7 = 
		[
			["Goods Receipts","../Misc/ezMaterialDocsInput.jsp",0,1,"No"]
			,["GRs To Be Invoiced","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=GRTOBE_INVOICED",0,1,"No"], 
			["Outstanding Balance","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=VEND_BALANCE",0,1,"No"],
			["A/C Statement","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=ACC_STATEMENT",0,1,"No"]
			,["Statement Confirm","",1,1,"No"]
			,["Debit Notes","../Misc/ezListOfDebitNotes.jsp",0,1,"No"]
			,["Audit Findings","",1,1,"No"]
			,["Dispatch Item","",1,1,"No"]
			,["Return Item","",1,1,"No"]
			,["Vendor Address Changes List","",1,1,"No"]
		]

		EZ_VENDOR7_1 = 
		[
			["To Be Confirmed","../Misc/ezSelectIPParamas.jsp?Flag=TBC",0,1,"No"],
			["Confirmed","../Misc/ezSelectIPParamas.jsp?Flag=C",0,1,"No"]
		]
		EZ_VENDOR7_2 = 
		[
			["Add","../Misc/ezAddAudit.jsp",0,1,"No"],
			["List","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=AUDIT_FINDINGS",0,1,"No"]
		]
		EZ_VENDOR7_3 = 
		[
			["View","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=DISPATCH",0,1,"No"]
		]

		EZ_VENDOR7_4 = 
		[
			["Add","../ReturnableItems/ezAddReturnItemDetails.jsp?flagStatus=RETURN",0,1,"No"],
			["View","../Misc/ezSelectDatesAndVendor.jsp?flagStatus=RETURN",0,1,"No"]
		]


		EZ_VENDOR7_5 = 
		[
			["To Be Approved","../Misc/ezVendorAddChangeList.jsp?statusFlag=TBA",0,1,"No"],
			["Approved","../Misc/ezVendorAddChangeList.jsp?statusFlag=A",0,1,"No"]
		]

		EZ_VENDOR8 = 
		[
			["Contact Us","../Misc/ezContactInfo.jsp",0,1,"No"],
			["Change Password","../Misc/ezPassword.jsp?fromMenu=Y",0,1,"No"],
			["Vendor Registration","javascript:void(0)",1,1,"No"],	
		]
		EZ_VENDOR8_1 = 
		[
		<%
			if("PP".equals(chkUserRole.trim()))
			{
		%>
			["Send Registration Link","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=VEN_REG_LINK",0,1,"No"],
			["Vendor Reg.Status Report","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=VEN_STATUS_REPORT",0,1,"No"]
		<%
			}
			else
			{

		%>
			["Vendor Reg.Status Report","../Misc/ezGCLoadingPageForMenuLinks.jsp?toPage=VEN_STATUS_REPORT",0,1,"No"]
		<%
			}
		%>
		]
<%
	}
%>
</script>
