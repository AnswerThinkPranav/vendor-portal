F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezPrePRList.jsp
 Include-->F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iSelectFields.jsp
 
 GET PRS:
 =========
 F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezListPR.jsp
 F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iListPR.jsp
 
 
 F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezCreateRFQ.jsp
 F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\UploadFiles\ezSaveRFQAttach.jsp
 F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\UploadFiles\ezSaveQuoteAttach.jsp
 
 
 DB CALLS:
 ========
 
 F:\ANSR\HSIL_WAS\HSIL\classes\ezc\ezapp\v2
 
 	EzPreProcurement
 	EzPreProcurementInputConversion
 	
F:\ANSR\workspace\HSIL\bin\ezc\ezapp\v2\ezpreprocurement\db

	EzPreProcurementResource
 
 
 PURCHASE GROUPS
 ================
 
select * from ezc_master_key_values

--insert into EZC_MASTER_KEY_VALUES values ('PUR_GRP','105','CD1 Packing Matl','','','')
--insert into EZC_MASTER_KEY_VALUES values ('PUR_GRP','110','CD1 Electricals','','','')

PURCHASE GROUP SYNC 

RFQ AUTH


FROM MATERIAL:
===============
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezCreateRFQFromMat.jsp
-->Material Search
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezMatSearchOptions.jsp
	RetunableContainerSearch
	
========================

SOURCE LIST:
============

	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezVendorViewList.jsp
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezListIRL.jsp
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iListSOS.jsp
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezQCFVendorCheck.jsp
	
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezEnterEndDate.jsp
	F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iListCollectiveRFQByMatWithoutBean.jsp
	
	
RFQ LIST:
=========
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezListRFQs.jsp
  -->F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\Misc\ezDefaultDate.jsp
  -->F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iListRFQs.jsp
  
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezViewRFQDetails.jsp

Extend RFQ:
===========
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezUpdateRFQCloseDate.jsp

Reminder:
=========
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezRemindRFQ.jsp

Quote by Vendor:
===============
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezPostQuote.jsp
-->F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Inbox\iGetUploadDocs.jsp

Save Quotation:
===============
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezQuotationSave.jsp

View Quotation:
===============
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezViewQuoteDetails.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iViewQuoteDetails.jsp

F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezGetQuoteHistory.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezQuotationComparisionForm.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Includes\JSPs\Rfq\iQuoteRFQDetails.jsp

Approve Quote:
=============
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezApproveQuote.jsp

Requote at Buyer:
================
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezReQuote.jsp

Requote at Vendor:
==================
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezQuotationUpdate.jsp

Reject at Buyer:
================
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezRejectQuote.jsp


Dashboard:
===========
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\Misc\ezWelcomePageCounts.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\Misc\ezWelcome_New.jsp

Queries:
=========
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezPostQuote.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezRfqQueries.jsp
F:\usr\sap\HJD\J00\j2ee\cluster\apps\answerthink.com\EzVendor\servlet_jsp\HSIL\root\EzCommerce\EzVendor\Vendor2\JSPs\Misc\ezSaveReply.jsp

==========================================================

MARA  --> Material Master

MTART  --> Material Type

LFM1  --> Vendor Master  Table

LIFNR --> Vendor

EKORG --> Purchase Org

WAERS --> Currency