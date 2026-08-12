<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AuctionManager" class="ezc.ezreverseauction.client.EzReverseAuctionManager" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezparam.*,java.util.*" %>
<%@ page import = "ezc.ezreverseauction.params.*" %>
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="ezAuctionCommon.jsp"%>
<%
	String auctionId 	= request.getParameter("auctionId");
	boolean isAuctionClosed = closeAuction(Session,auctionId);
	/*
	EzcParams mainParams = new EzcParams(false);
	mainParams.setLocalStore("Y");
	EziAuctionParams iParams = new EziAuctionParams();
	iParams.setAuctionId(auctionId);
	iParams.setStatus("C");
	mainParams.setObject(iParams);
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve retobj = (ReturnObjFromRetrieve)AuctionManager.updateStatus(mainParams);
	if(retobj != null)
	{
		EzcParams mainParamsIn = new EzcParams(false);
		EziAuctionParams iParamsIn = new EziAuctionParams();
		mainParamsIn.setLocalStore("Y");
		iParamsIn.setAuctionId(auctionId);
		iParamsIn.setSortType("D");
		mainParamsIn.setObject(iParamsIn);
		Session.prepareParams(mainParamsIn);
		ReturnObjFromRetrieve retAuctionHistory = (ReturnObjFromRetrieve)AuctionManager.getAuctionHistory(mainParamsIn);
		if(retAuctionHistory != null)
		{
									
		}

	}*/
	if(!isAuctionClosed)
		response.sendRedirect("ezCurrentAuctionDetails.jsp?auctionId="+auctionId);
	else if("3".equals((String)session.getValue("UserType")) || "4".equals((String)session.getValue("UserType")))
		response.sendRedirect("ezAuctionResultSupplier.jsp?auctionId="+auctionId);
	else
		response.sendRedirect("ezAuctionReport.jsp?auctionId="+auctionId);
%>  
  