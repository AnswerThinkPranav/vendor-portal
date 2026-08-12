<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*,java.text.*" %> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>       
<%@ page import = "ezc.ezutil.FormatDate,ezc.ezpreprocurement.params.*"%>
<%     
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();  
	String type = request.getParameter("type");   
%>     
     
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>   
<%   
	String status 	  = request.getParameter("type"); 
	int dateRange = 30; 
	     
	if("ToQuote".equals(status))
		dateRange = 1000; 
	
	String fromDate		= request.getParameter("FromDate");
	String toDate		= request.getParameter("ToDate");
%>	 
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%>

<%@include file="../../../Includes/JSPs/Rfq/iListRFQs.jsp"%>  
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%> 

<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<Html> 
<Head>     
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>               
	function ezBack(event)          
	{
		document.location.href = event;
	}
	function ezSubmit()  
	{
		/*var fromDate = document.myForm.FromDate.value;
		var toDate   = document.myForm.ToDate.value; 
		
		if(fromDate > toDate)
		{
			alert("From Date should be less than To Date!!");
			return false;
		}*/
		 
		document.myForm.action = "ezListRFQs.jsp";
		document.myForm.submit(); 
	}
</Script>   
</head> 
<Body scroll=no>
<form method="post" name="myForm">
<input type="hidden" name="type" value="<%=request.getParameter("type")%>">
<input type="hidden" name="menuItem" value="<%=request.getParameter("menuItem")%>">

<%
	String clickString = "onclick='ezSubmit()'";
	String display_header	= "RFQ > RFQ's To Be Responded"; 
	if("Quoted".equals(type)) display_header = "RFQ > View Responded Quotations"; 
	else if("All".equals(type)) display_header = "List of All RFQs";  
%>
		
	<%@ include file="../Misc/ezSubHeader.jsp"%> 
	<%@ include file="../Misc/ezSelectDate.jsp"%>  
	
	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
		<Tr <%=trBGColor%> >
			<th>RFQ</th>   
<%
			if("2".equals(userType))
			{
%>
				<th>Vendor</th>
<%
			}
%>
			<th>RFQ Date</th>
			<th>RFQ Closing Date</th>
<%
			if("ToQuote".equals(type))
			{
%>
				<!--<th>Sent For ReQuote</th>-->
<%
			}
%>
		</tr>
		</thead>
		<tbody>
		
<%
			//out.println(hdrXML.toEzcString());
			for(int i=0;i<Count;i++)
			{		
				String rfqNum 		= hdrXML.getFieldValueString(i,"RFQ_NO");		
				String rfqDate		= formatDate.getStringFromDate((java.util.Date)hdrXML.getFieldValue(i,"RFQ_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
				String rfqcloseDate	= formatDate.getStringFromDate((java.util.Date)hdrXML.getFieldValue(i,"VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
				String rfqReQuote	= hdrXML.getFieldValueString(i,"ERH_REQUEST_REQUOTE");
				String rfqSysKey	= hdrXML.getFieldValueString(i,"SYS_KEY");
				String rfqVendor	= hdrXML.getFieldValueString(i,"SOLD_TO");
				String rfqCompCode	= hdrXML.getFieldValueString(i,"ERH_COMP_CODE");
				String rfqPurOrg	= hdrXML.getFieldValueString(i,"ERH_PUR_ORG");
				String rfqQuoteStatus	= hdrXML.getFieldValueString(i,"STATUS");
				String rfqVendorType	= hdrXML.getFieldValueString(i,"ERH_VENDOR_TYPE");
				
				String reQuoteStatus 	= "";
				if("Y".equals(rfqReQuote))
					reQuoteStatus = "Yes";
				
				String fileName = "ezViewRFQDetails.jsp";
				if("Y".equals(rfqQuoteStatus)) 
					fileName = "ezViewQuoteDetails.jsp";
				if("N".equals(rfqQuoteStatus) && "Y".equals(rfqReQuote))
					fileName = "ezRequote.jsp";
				if("NON_SAP".equals(rfqVendorType) && "N".equals(rfqQuoteStatus))
					fileName = "ezNonSAPRfqQuote.jsp";
%>		
		<tr> 
			<td align="center"><a style='text-decoration:underline' href="<%=fileName%>?rfqNumber=<%=rfqNum%>&rfqSysKey=<%=rfqSysKey%>&rfqVendor=<%=rfqVendor%>&rfqCompCode=<%=rfqCompCode%>&rfqPurOrg=<%=rfqPurOrg%>&type=<%=type%>&EndDate=<%=rfqcloseDate%>&rfqDate=<%=rfqDate%>&FromDate=<%=fromDate%>&ToDate=<%=toDate%>&rfqReQuote=<%=rfqReQuote%>&rfqQuoteStatus=<%=rfqQuoteStatus%>&rfqVendorType=<%=rfqVendorType%>&buyerSelVendor=<%=request.getParameter("buyerSelVendor")%>&menuItem=<%=request.getParameter("menuItem")%>"><%=rfqNum%></a></td>
<%
			if("2".equals(userType))
			{
%>			
				<td align="left">&nbsp;<%=vendorsHT.get(rfqVendor)%></td>
<%
			}
%>
			<td align="center"><%=rfqDate%></td>
			<td align="center"><%=rfqcloseDate%></td>
			<%
			if("ToQuote".equals(type)) 
			{
			%>
				<!--<td align="center"><%=reQuoteStatus%></td>-->
			<%
			}
			%>
		</tr>
<%
			}
%>
	</tbody>
	</table>
</div>
<div class="spacer"></div> 
</div>
<Div id="MenuSol"></Div>
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>

<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
$(document).ready(function() {
		
       $("#FromDate").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
              	changeMonth: true,
          	changeYear: true
       });
        $("#ToDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                     	changeMonth: true,
          		changeYear: true
       });
 });
  
</script>