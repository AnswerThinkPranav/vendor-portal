 <SCRIPT>

EZ_VENDOR1 = 
[
	["Purchase Req.","javascript:void(0)",1,1,"No"],
	["RFQs","javascript:void(0)",1,1,"No"],
	["QCF","../Rfq/ezListQCS.jsp?status=CR",0,1,"No"],
	["Reverse Auction","javascript:void(0)",1,1,"No"]
	//["Reports","javascript:void(0)",1,1,"No"]
	//["View Quotations","../RFQ/ezListRFQs.jsp?type=List",0,1,"No"]
	
]
EZ_VENDOR1_1 = 
[
	//["Create PRs","../RFQ/ezCreatePR.jsp",0,1,"No"],
	["Released PRs","../RFQ/ezPrePRList.jsp?Status=R",0,1,"No"],
	["Unreleased PRs","../RFQ/ezPrePRList.jsp?Status=U",0,1,"No"],
	["Auction From Material","../RFQ/ezPreSelectVendors.jsp",0,1,"No"],
	["RFQ From Materials","../RFQ/ezPreRFQSelectVendors.jsp",0,1,"No"]
	//["Display Q-Info","../RFQ/ezPreQMInfo.jsp",0,1,"No"]
]

EZ_VENDOR1_2 = 
[
	//["To Invite","../RFQ/ezListGenRFQs.jsp?type=Invite&menu=Y",0,1,"No"],
	["To Quote","../RFQ/ezListGenRFQs.jsp?type=ToBeQuote",0,1,"No"],	
	["All","../RFQ/ezListGenRFQs.jsp?type=All",0,1,"No"],
	["View Quotations","../RFQ/ezListGenRFQs.jsp?type=Quoted",0,1,"No"]
	//["NEW","../RFQ/ezListRFQsToInvite.jsp?type=ToBeQuote",0,1,"No"]
	//["Edit","../RFQ/ezGetEditRFQList.jsp",0,1,"No"]
]

EZ_VENDOR1_3 = 	
[
	["Auctions List","../Request/ezListAuctionRequests.jsp?type=Main",0,1,"No"],
	["Acknowledge","javascript:void(0)",1,1,"No"],
	["View Responses","../Request/ezViewResponses.jsp",0,1,"No"],
	["Current Auctions","../Request/ezListActiveAuctions.jsp",0,1,"No"],
	["Completed Auctions","../Request/ezListAuctionRequests.jsp?type=Closed",0,1,"No"],
	["Auction History","javascript:void(0)",1,1,"No"]
]

EZ_VENDOR1_3_1 = 
[
	["To Acknowledge","../Request/ezListAuctionRequests.jsp?type=New",0,1,"No"],
	["Acknowledged","../Request/ezListAuctionRequests.jsp?type=Acknowledged",0,1,"No"],
	["Rejected","../Request/ezListAuctionRequests.jsp?type=Rejected",0,1,"No"]
]

EZ_VENDOR1_3_2 = 
[	
	
	["By Name","../Request/ezAuctionHistoryByAuctionId.jsp",0,1,"No"],
	["By Supplier","../Request/ezAuctionHistoryBySupplier.jsp",0,1,"No"]
]


/*EZ_VENDOR2 = 
[
	["Purchase Orders","javascript:void(0)",1,1,"No"],
	//["Contracts","javascript:void(0)",1,0,"No"],
	//["Approval Status","../Purorder/ezPoConWFList.jsp?",0,1,"No"]
]
*/

EZ_VENDOR2 = [

		//["UnReleased","../Purorder/ezListBlockedPOs.jsp?type=Amend",0,1,"No"],
		//["Blocked For Supplier","../Purorder/ezListBlockedPOsInPortal.jsp",0,1,"No"],
		["Acknowledgements","javascript:void(0)",1,1,"No"],
		["Amended","../PurOrder/ezListAmendedPOs.jsp",0,1,"No"],
		["Open","../Purorder/ezListPOs.jsp?OrderType=Open",0,1,"No"],
		["Closed","../Purorder/ezListPOs.jsp?OrderType=Closed",0,1,"No"],
		["All","../Purorder/ezListPOs.jsp?OrderType=All",0,1,"No"]
]	

EZ_VENDOR2_1 = 
[
	
	["Acknowledged","../PurOrder/ezListAcknowledgedPOs.jsp?type=Acknowledged",0,1,"No"],
	["To be Acknowledged","../PurOrder/ezListAcknowledgedPOs.jsp?type=NotAcknowledged",0,1,"No"],
	["Rejected","../PurOrder/ezListAcknowledgedPOs.jsp?type=Rejected",0,1,"No"]
]

/*
EZ_VENDOR2_2 = 
[
	["UnReleased","../Purorder/ezListBlockedContracts.jsp?type=Contract",0,1,"No"],
	["Blocked For Supplier","../Purorder/ezListBlockedContractsInPortal.jsp",0,1,"No"],
	["View Contracts","../Purorder/ezGetContractsList.jsp",0,1,"No"]
]
*/

EZ_VENDOR3 = [
["Acknowledgements","javascript:void(0)",1,1,"No"],
["Open","../Purorder/ezContract.jsp?OrderType=Open",0,1,"No"],
["Closed","../Purorder/ezContract.jsp?OrderType=Closed",0,1,"No"],
["All","../Purorder/ezContract.jsp?OrderType=All",0,1,"No"]
]

EZ_VENDOR3_1 = 
[
	["To be Acknowledged","../Purorder/ezListScheduleAgreements.jsp?docStatus=N",0,1,"No"],
	["Acknowledged","../Purorder/ezListScheduleAgreements.jsp?docStatus=A",0,1,"No"]
]


EZ_VENDOR4 = 
[
	["View","../Shipment/ezViewShipmentHeader.jsp",0,1,"No"]
]

EZ_VENDOR5 = 
[
	["Open","../Purorder/ezListInvWait.jsp?InvStat=O",0,1,"No"],
	["Closed","../Purorder/ezListInvWait.jsp?InvStat=C",0,1,"No"],
	["All","../Purorder/ezListInvWait.jsp?InvStat=A",0,1,"No"]
]

EZ_VENDOR6 = 
[
	["Outstanding Balance","../Purorder/ezVendbal.jsp",0,1,"No"],
	["A/C Statement","../Misc/ezAstatement.jsp",0,1,"No"],
	["Bank Details","../Purorder/ezBankDet.jsp",0,1,"No"],
	["To Be Delivered","javascript:void(0)",1,1,"No"],
	["Total POs Acknowledged By Vendors","../Purorder/ezListAcknowledgedVendors.jsp?Status=A",0,1,"No"],
	["Total POs Not Acknowledged By Vendors","../Purorder/ezListAcknowledgedVendors.jsp?Status=X",0,1,"No"],
	["Vendor Profile","../Materials/ezViewVendorProfile.jsp",0,1,"No"],
	["Change Address","../Misc/ezGetInfo.jsp",0,1,"No"],
	["Change Password","../Misc/ezPassword.jsp",0,1,"No"]
]
EZ_VENDOR6_1 = 
[
	["POs","../Purorder/ezListToBeDelivered.jsp?flag=PO",0,1,"No"],
	["Schd Agreements","../Purorder/ezListToBeDelivered.jsp?flag=SCHD",0,1,"No"]
]

EZ_VENDOR5_1 = 
[
	["New","../Purorder/ezQcf.jsp",0,1,"No"],
	["Action To be Taken","../Purorder/ezListQcfs.jsp?Type=N",0,1,"No"],
	["All","../Purorder/ezListQcfs.jsp?Type=A",0,1,"No"]
]

EZ_VENDOR7 = 
[
	//["Search","ezSelectSearch.jsp",0,1,"No"],
	["Search","../Search/ezSearch.jsp",0,1,"No"],
	["Mail","../Inbox/ezListPersMsgs.jsp",0,1,"No"],
	["Web Stats","javascript:void(0)",1,1,"No"],
	["Plant Info","../Misc/ezListSbuPlantAddresses.jsp",0,1,"No"],
	["News ","../News/ezListNews.jsp",0,1,"No"],
	["Vendor Data Bank","../Misc/ezVendorFiles.jsp",0,1,"No"],
	["User Manuals","../Misc/ezManual.jsp",0,1,"No"],
	["Supplier Code of Conduct","../Misc/ezSupplierCodeofConduct.jsp",0,1,"No"],
	["FAQs","../Misc/ezFAQs.jsp",0,1,"No"], 
	["Contact Info","../Misc/ezContactInfo.jsp",0,1,"No"]
]

EZ_VENDOR7_1 = 
[
	["By SBU","../WebStats/ezListWebStatsBySBU.jsp?Area=V",0,1,"No"],
	["Time Stats","../WebStats/ezTimeStats.jsp?Area=V",0,1,"No"],
	["User Frequency","../WebStats/ezListUserFrequency.jsp?Area=V",0,1,"No"]
]
</SCRIPT>