<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AuctionManager" class="ezc.ezreverseauction.client.EzReverseAuctionManager" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.ezreverseauction.params.*" %>
<%@ page import="ezc.ezutil.*,java.util.*" %>
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../Misc/ezWFCommonMethods.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%
	if("Y".equals(session.getValue("AUCTION_ACTIVATE")))
	{ 
		response.sendRedirect("../../../Vendor2/Library/Globals/ezValidVendorUserError.jsp");
	}
	session.putValue("AUCTION_ACTIVATE","Y");
	String logonSite = (String)session.getValue("SITE");
	String portalURL = "";
	ResourceBundle sitBundleObj=null;
	try 
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		portalURL=sitBundleObj.getString("PORTAL_URL");
	}
	catch(Exception e)
	{ 

	}
	
	String auctionId = request.getParameter("auctionId");
	String [] selAuctUser = request.getParameterValues("selAuctUser");
	String erpNo = "";
	EzcParams mainParams1 = new EzcParams(false);
	mainParams1.setLocalStore("Y");
	EziAuctionParams iParams = new EziAuctionParams();
	iParams.setStatus("E");
	iParams.setAuctionId(auctionId);
	mainParams1.setObject(iParams);
	Session.prepareParams(mainParams1);
	ReturnObjFromRetrieve retobj   = (ReturnObjFromRetrieve)AuctionManager.updateStatus(mainParams1);
	
	ReturnObjFromRetrieve auctRet = ezMiscSelect(Session,"select DATE_FORMAT(EAH_START_DATE,'%d/%m/%Y %h:%i:%s %p')  START_DATE,DATE_FORMAT(EAH_END_DATE,'%d/%m/%Y %h:%i:%s %p')  END_DATE,EAH_AUCTION_NAME from ezc_auction_header where EAH_AUCTION_ID='"+auctionId+"'");
	ReturnObjFromRetrieve auctItemRet = ezMiscSelect(Session,"select * from ezc_auction_item where EAI_AUCTION_ID='"+auctionId+"'");
	int auctItemRetCnt=0;
	if(auctItemRet != null)
		auctItemRetCnt=auctItemRet.getRowCount();
	//ReturnObjFromRetrieve userRet = ezMiscSelect(Session,"select DISTINCT a.EU_ID,a.EU_FIRST_NAME,a.EU_EMAIL,b.EC_ERP_CUST_NO from ezc_users a,ezc_customer b where a.EU_BUSINESS_PARTNER=b.EC_BUSINESS_PARTNER and trim(b.EC_ERP_CUST_NO) IN (select EAS_SUPPLIER_CODE from ezc_auction_supplier where eas_auction_id='"+auctionId+"') and b.EC_PARTNER_FUNCTION='VN'");
	ReturnObjFromRetrieve userRet = ezMiscSelect(Session,"select DISTINCT a.EU_ID,a.EU_FIRST_NAME,a.EU_EMAIL from ezc_users a where eu_id in (select TRIM(LEADING '0' FROM EAS_SUPPLIER_CODE) from ezc_auction_supplier where eas_auction_id='"+auctionId+"')");
	String auctionName = auctRet.getFieldValueString(0,"EAH_AUCTION_NAME");
	String startDate = auctRet.getFieldValueString(0,"START_DATE");
	String endDate = auctRet.getFieldValueString(0,"END_DATE");
	String mailSub="",mailText="";
	String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	
	
	mailSub="JUBILANT GENERICS-AUCTION INVITE - "+auctionId;
	mailText +=  "Dear Business Partner,<br> You are invited to participate in auction.Please find below auction details.<br>";
	mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Auction Id.</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+auctionId+"</Td></Tr>";	
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Auction Name.</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+auctionName+"</Td></Tr>";	
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Start Date.</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+startDate+"</Td></Tr>";	
	mailText +=  "<Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>End Date.</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+endDate+"</Td></Tr>";	
	mailText +=  "</Table><Br>";
	mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
	mailText +=  "<Tr "+bgColor+"><Th width= \"60%\" "+thBGColor+"><B>Item</B></Th><Th width= \"20%\" "+thBGColor+"><B>UOM</B></Th><Th width= \"50%\" "+thBGColor+"><B>Quantity</B></Th></Tr>";	
	for(int i=0;i<auctItemRetCnt;i++)
	{
		mailText +=  "<Tr "+bgColor+"><Td width= \"60%\" "+tdBGColor+" align=\"center\">"+auctItemRet.getFieldValueString(i,"EAI_ITEM_CODE")+"</Td><Td width= \"20%\" "+tdBGColor+" align=\"center\">"+auctItemRet.getFieldValueString(i,"EAI_UOM")+"</Td><Td width= \"20%\" "+tdBGColor+" align=\"center\">"+auctItemRet.getFieldValueString(i,"EAI_QUANTITY")+"</Td></Tr>";		
	}
	mailText +=  "</Table><Br>";
	mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	mailText +=  "<br>Regards, \n<br><b>" + (String)session.getValue("FIRST_NAME") + "(" +Session.getUserId()+").";
	
	int userRetCnt = 0;
	if(userRet != null)
	{
		userRetCnt = userRet.getRowCount();
	}
	for(int i=0;i<userRetCnt;i++)
	{
		String linkId=saveLinkControllerData(Session,auctionId,"AUCTBID",userRet.getFieldValueString(i,"EU_ID"),userRet.getFieldValueString(i,"EU_EMAIL"),mailText);
		sendMails(Session,userRet.getFieldValueString(i,"EU_EMAIL"),"","",mailText.replace("JBTEID",linkId),mailSub);
	}	
	if(selAuctUser != null && selAuctUser.length > 0)
	{
		for(int z=0;z<selAuctUser.length;z++)
		{
			String tempArr[] = selAuctUser[z].split("#");
			String linkId=saveLinkControllerData(Session,auctionId,"AUCTBID",tempArr[0],tempArr[2],mailText);
			sendMails(Session,tempArr[2],"","",mailText.replace("JBTEID",linkId),mailSub);
			
		}
	}
	//response.sendRedirect("ezListAuctionRequests.jsp?type=Main");

%>
<form name="myForm" method="post">
<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            Confirmation
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">
        <div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<center> 
	
		<div class="alert alert-success">
		<h4><i class="icon fa fa-check"></i> Success</h4>
		Auction : <strong><%=auctionId%></strong> activated sucessfully. Email invite sent to the vendors & users.
		</div>
	</center>

<div style="margin-top:2%;margin-bottom:2%">
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>	
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      		
</form>
</Body>
</Html>

