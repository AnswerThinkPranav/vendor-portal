<%@ page import = "ezc.ezutil.FormatDate"%>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezPurchaseBean.jsp"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>

<% 
	String type = request.getParameter("type");

	
	String fromDate = request.getParameter("FromDate");
	String toDate   = request.getParameter("ToDate");
	String venSearch = request.getParameter("venSearch");
	String vendorName = request.getParameter("vendorName");
	if(venSearch==null||"null".equals(venSearch.trim())||"".equals(venSearch.trim()))
		venSearch="";
	if(vendorName==null||"null".equals(vendorName.trim())||"".equals(vendorName.trim()))
		vendorName="";	
	
	int dateRange = 30;
%>  
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iListGenRFQs.jsp"%>


<html> 
<head>    
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezJQueryScript.jsp" %>

<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>
				
				
	function ezBack(event)
	{
		document.location.href = event;
	}


	function viewRFQDetailsFun(orderNo,closeDate,vendor,collectiveNo,reQuote,status)
	{
		document.myForm.PurchaseOrder.value = orderNo
		document.myForm.EndDate.value 	    = closeDate
		document.myForm.rfqVendor.value     = vendor		
		document.myForm.collectiveRFQNo.value = collectiveNo
		document.myForm.reQuote.value = reQuote
		document.myForm.status.value = status


		
		document.myForm.action = "ezViewRFQDetails.jsp";
		document.myForm.submit()
	}

	function ezSubmit(){
		var venSearch = document.myForm.vendorName.value
		venSearch=funTrim(venSearch)
		
		if(venSearch!="")
			newWindow=window.open("../RFQ/ezRFQVndrSearch.jsp?venSearch="+venSearch,"myWin","width=750,height=550,top=30,left=60,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		else
		{
			document.myForm.action = "ezListGenRFQs.jsp";
			document.myForm.submit();
		}
	}
		
</Script>
</head>

<body scroll=no>
<form method="post" name="myForm">
<input type="hidden" name="PurchaseOrder">
<input type="hidden" name="reQuote">
<input type="hidden" name="rfqVendor">
<input type="hidden" name="EndDate">
<input type="hidden" name="OrderDate">
<input type="hidden" name="reqFrom" value="InviteGrp">
<input type="hidden" name="ext3Type" value="<%=ext3Type%>">
<input type="hidden" name="collectiveRFQNo" value="">
<input type="hidden" name="venSearch" value="">

<input type="hidden" name="vendType" value="">
<input type="hidden" name="soldToName" value="">
<input type="hidden" name="agentCode" value="">
<input type="hidden" name="RFQNo" value="">
<input type="hidden" name="status" value="">
<input type="hidden" name="ext" value="">
<input type="hidden" name=selAllImg value="0">

<%
	String display_header = "";
	String noListStr ="";
	String controlType ="radio";
	String noDataStatement	= "";
	if("Invite".equals(ext3Type))
	{
		display_header = "List of RFQs To be Invited";
		noListStr      = "No RFQs exist To be Invited.";
		controlType    = "checkbox";
		noDataStatement	= "No RFQs exist to Invite.";
	}	
	else if("ToBeQuote".equals(ext3Type))
	{
	%>
		<input type="hidden" name="type" value="ToBeQuote">
	<%
		display_header = "List of RFQs To be Quoted";
		noListStr      = "No RFQs exist To be Quoted.";
		noDataStatement	= "No RFQs exist to Quote.";
	}
	else if("Quoted".equals(ext3Type))
	{
		display_header = "List of Quoted RFQs";
		noListStr      = "No RFQs Quoted Yet.";
		noDataStatement	= "No RFQs exist.";
	}	
	else if("All".equals(ext3Type))
	{
		display_header = "List of RFQs";
		noListStr      = "No RFQs exist.";
		noDataStatement	= "No RFQs exist.";
	}
	else if("EditRfq".equals(ext3Type))
	{
		display_header = "List of RFQs For Edit";
		noListStr      = "No RFQs exist For Edit.";
		noDataStatement	= "No RFQs exist.";
	}
	else if("List".equals(ext3Type))
	{
		display_header = "List of RFQs ";
		noListStr      = "No RFQs exist.";
		noDataStatement	= "No RFQs exist.";
	}
	else if("New".equals(ext3Type))
	{
		display_header = "List of New RFQs ";
		noListStr      = "No New RFQs exist.";
		noDataStatement	= "No RFQs exist.";
	}
	
	String clickString = "onclick='ezSubmit()'";
	String tableWidth="45%",FDateWidth="45%",TDateWidth="43%";
	
			
	if(!("3".equals((String)session.getValue("UserType"))))
	{
		tableWidth="65%";
		FDateWidth="30%";
		TDateWidth="28%";
	}	
		
		
			
			
	
%>
	<input type="hidden" name="type" value=<%=type%> >
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
		
<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
	<Table width="<%=tableWidth%>" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
			<Tr>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='<%=FDateWidth%>' valign=center>
					From Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='<%=TDateWidth%>' align=right valign=center>
					To Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate" readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
				</Td>
<%
					if(!("3".equals((String)session.getValue("UserType"))))
					{
%>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' align=right valign=center>
					Vendor Name &nbsp;&nbsp;<input type=text class=inputbox value="<%=vendorName%>" name="vendorName"   size=15 maxlength="10">&nbsp;
				</Td>
<%
					}else{
%>
					<input type=hidden value="" name="vendorName">
<%
					}
%>
				<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='35%' align=right>
					<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
				</Td>-->
				<Td <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
					<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
				</Td>
				
			</Tr>
			
			</Table>
		</Td>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif" ></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
</Div>

<%
	ezc.ezcommon.EzLog4j ezLog4j=new ezc.ezcommon.EzLog4j();
	
	
	String dateSep = (String)session.getValue("DATESEPERATOR");
	Vector types = new Vector();
	types.addElement("date");
	types.addElement("date");	        
	EzGlobal.setColTypes(types);

	Vector names = new Vector();
	names.addElement("VALID_UPTO");
	names.addElement("RFQ_DATE");		
	EzGlobal.setColNames(names);
	//EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");
	
	//EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy");
	EzGlobal.setDateFormat("dd"+dateSep+"MM"+dateSep+"yyyy");
	ezc.ezparam.ReturnObjFromRetrieve ret = EzGlobal.getGlobal((ezc.ezparam.ReturnObjFromRetrieve)myRetrfq);
	
	
	String collectiveRFQNo  = "";
	String Description	= "";
	String orderNo 		= "";
	String soldToInfo	= "";
	String closeDate 	= "";
	String orderDate 	= "";
	String clDate 		= "";
	String status		= "";
	String agentCode	= "";
	String ext		= "";
	String ext1		= "";
	String custName		= ""; 
	String reQuote		= "";
	String reQouteRemarks   = "";
	String sysKey = (String)session.getValue("SYSKEY");
	String chkStatus ="0";
	String stat="";
	//String userType = (String)session.getValue("UserType");
	String VenSearch=request.getParameter("VenSearch");
	//out.println(myRetrfq.toEzcString());
	FormatDate fd = new FormatDate();
	//ezLog4j.log("Count:"+Count,"w");
	 Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	 
	 ezLog4j.log("vendorsHT:"+vendorsHT,"w");
%>
	<div style="position:absolute;top:20%;width:100%;left:0%;overflow:auto;height:328px">
	<table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<thead>
<%
	if("3".equals(userType) && "All".equals(ext3Type))
	{
%>
		<Tr>
			<th align="center" width="10%">RFQ No.</th>
			<th align="center" width="20%">Description</th>
			<th align="center" width="10%">Collective RFQ No.</th>
			<th align="center" width="10%">Vendor</th>
			<th align="center" width="20%">Vendor Name</th>
			<th align="center" width="10%">RFQ Date</th>
			<th align="center" width="10%">RFQ Closing Date</th>
			<th align="center" width="10%">Sent For ReQuote</th>

		</tr>
<%
	}
	else
	{
		if("ToBeQuote".equals(ext3Type)) 
		{
			if(!("3".equals((String)session.getValue("UserType"))))
			{
%>
				<Tr>
					<th align="center" width="10%">RFQ No.</th>
					<th align="center" width="15%">Description</th>
					<th align="center" width="10%">Collective RFQ No.</th>
					<th align="center" width="10%">Vendor</th>
					<th align="center" width="15%">Vendor Name</th>
					<th align="center" width="10%">RFQ Date</th>
					<th align="center" width="10%">RFQ Closing Date</th>
					<th align="center" width="10%">Sent For ReQuote</th>
					<th align="center" width="10%">Validity Expired</th>

				</tr>
<%
			}
			else
			{
%>
				<Tr>
					<th align="center" width="10%">RFQ No.</th>
					<th align="center" width="25%">Description</th>
					<th align="center" width="10%">Collective RFQ No.</th>
					<th align="center" width="10%">Vendor</th>
					<th align="center" width="25%">Vendor Name</th>
					<th align="center" width="10%">RFQ Date</th>
					<th align="center" width="10%">RFQ Closing Date</th>

				</tr>
<%
			}
		}
		else
		{
%>
			<Tr>
				<th align="center" width="10%">RFQ No.</th>
				<th align="center" width="25%">Description</th>
				<th align="center" width="10%">Collective RFQ No.</th>
				<th align="center" width="10%">Vendor</th>
				<th align="center" width="25%">Vendor Name</th>
				<th align="center" width="10%">RFQ Date</th>
				<th align="center" width="10%">RFQ Closing Date</th>

			</tr>		
<%
		}
	}	
%>
	</thead>
	</Thead>
	<TBody>		

	
	
	
	
<%
	java.util.Date currentDateObj =new java.util.Date();
	java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
	java.util.Date validUPToDate =null;
	String validUPToStr = ""; 
	String isValidExpire = ""; 
	String vendType	     = "";

	int month = 0,date = 0,year = 0; 
	
	String color = "";

	for(int i=0;i<myRetrfq.getRowCount();i++)
	{
		ezLog4j.log("SOLD_TO:"+myRetrfq.getFieldValueString(i,"SOLD_TO"),"w");

		if(vendorsHT.containsKey(myRetrfq.getFieldValueString(i,"SOLD_TO")))
		{
			vendType	= myRetrfq.getFieldValueString(i,"VENDOR_TYPE");
			collectiveRFQNo = myRetrfq.getFieldValueString(i,"COLLECTIVE_RFQ_NO");
			reQuote		= myRetrfq.getFieldValueString(i,"ERH_REQUOTE");
			orderNo 	= myRetrfq.getFieldValueString(i,"RFQ_NO");
			Description	= myRetrfq.getFieldValueString(i,"RFQ_TITLE");

			reQouteRemarks  = myRetrfq.getFieldValueString(i,"EXT1");

			if(reQouteRemarks==null || "null".equals(reQouteRemarks.trim()))
				reQouteRemarks="";

			String reQouteStatus="No";
			if("Y".equals(reQuote))
				reQouteStatus = "<b>Yes</b>";


			reQouteRemarks	= reQouteRemarks.replaceAll("&","&amp;");



			if(Description==null || "null".equals(Description))Description="";
			Description	= Description.replaceAll("&","&amp;");
			if(reQuote==null || "null".equals(reQuote) || "".equals(reQuote))reQuote="N";

			 ezLog4j.log("orderNo:"+orderNo,"w");

			soldToInfo	= myRetrfq.getFieldValueString(i,"SOLD_TO");			
			closeDate 	= getDateForDateObj((Date)myRetrfq.getFieldValue(i,"VALID_UPTO"));
			orderDate 	= getDateForDateObj((Date)myRetrfq.getFieldValue(i,"RFQ_DATE"));
			clDate 		= fd.getStringFromDate((Date)myRetrfq.getFieldValue(i,"VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			status		= myRetrfq.getFieldValueString(i,"STATUS");
			agentCode	= "";
			ext		= myRetrfq.getFieldValueString(i,"EXT3");
			custName	= (String)vendorsHT.get(myRetrfq.getFieldValueString(i,"SOLD_TO"));//myRetrfq.getFieldValueString(i,"SOLD_TO_NAME");
			custName	= custName.replaceAll("&","&amp;");

			if(custName==null||"null".equals(custName)) 
				custName="";
			ext1	= myRetrfq.getFieldValueString(i,"EXT1");
			if(custName!=null)
				custName = custName.trim();


			if("3".equals(userType) && "All".equals(ext3Type))
			{
				if("Y".equals(ext))
				{
				
					String rfqNumHyperLink = "<a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+reQuote+"','"+status+"')>"+orderNo+"</a>";
											
					color = "";
					if(i%2==0) {color = "style='background-color:#c9e0ff'";}	
%>
					<Tr>
						<td align="center" width="10%" <%=color%>><%=rfqNumHyperLink%>&nbsp;</td>
						<td align="left"   width="20%" <%=color%>>&nbsp;<%=Description%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=collectiveRFQNo%></td>
						<td align="center" width="10%" <%=color%>><%=agentCode%>&nbsp;</td>
						<td align="center" width="20%" <%=color%>><%=custName%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=orderDate%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=closeDate%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=reQouteStatus%>&nbsp;</td>
					</Tr>
<%
					
				}
			}
			else
			{

				if("ToBeQuote".equals(ext3Type))
				{
					 ezLog4j.log("validUPToDate:"+validUPToDate,"w");
					 ezLog4j.log("myChkDateObj:"+myChkDateObj,"w");

					 validUPToStr = myRetrfq.getFieldValueString(i,"VALID_UPTO");

					date = Integer.parseInt(validUPToStr.split("-")[2]);
					month = Integer.parseInt(validUPToStr.split("-")[1])-1;
					year = Integer.parseInt(validUPToStr.split("-")[0])-1900;

					 validUPToDate = new java.util.Date(year,month,date);


					if(myChkDateObj.compareTo(validUPToDate)<=0)
						isValidExpire = "No";
					else
						isValidExpire = "<font color='#FF3300'><b>Yes</b></font>";

					if(!("3".equals((String)session.getValue("UserType"))))
					{
					
						String rfqNumHyperLink = "<a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+reQuote+"','"+status+"')>"+orderNo+"</a>";
											
						color = "";
						if(i%2==0) {color = "style='background-color:#c9e0ff'";}
%>						
						<Tr>
							<td align="center" width="10%" <%=color%>><%=rfqNumHyperLink%>&nbsp;</td>
							<td align="left"   width="15%" <%=color%>>&nbsp;<%=Description%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=collectiveRFQNo%></td>
							<td align="center" width="10%" <%=color%>><%=soldToInfo%>&nbsp;</td>
							<td align="center" width="15%" <%=color%>><%=custName%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=orderDate%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=closeDate%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=reQouteStatus%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=isValidExpire%>&nbsp;</td>
						</Tr>
<%						
					}
					else
					{

						String rfqNumHyperLink = "<a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+reQuote+"','"+status+"')>"+orderNo+"</a>";
											
						color = "";
						if(i%2==0) {color = "style='background-color:#c9e0ff'";}
%>
						<Tr>
							<td align="center" width="10%" <%=color%>><%=rfqNumHyperLink%>&nbsp;</td>
							<td align="left" width="25%" <%=color%>>&nbsp;<%=Description%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=collectiveRFQNo%></td>
							<td align="center" width="10%" <%=color%>><%=soldToInfo%>&nbsp;</td>
							<td align="center" width="25%" <%=color%>><%=custName%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=orderDate%>&nbsp;</td>
							<td align="center" width="10%" <%=color%>><%=closeDate%>&nbsp;</td>
						</Tr>
						
<%
					}

				}
				else
				{
					String rfqNumHyperLink = "<a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+reQuote+"','"+status+"')>"+orderNo+"</a>";
					
					color = "";
					if(i%2==0) {color = "style='background-color:#c9e0ff'";}
%>					
					<Tr>
						<td align="center" width="10%" <%=color%>><%=rfqNumHyperLink%>&nbsp;</td>
						<td align="left" width="25%" <%=color%>>&nbsp;<%=Description%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=collectiveRFQNo%></td>
						<td align="center" width="10%" <%=color%>><%=soldToInfo%>&nbsp;</td>
						<td align="center" width="25%" <%=color%>><%=custName%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=orderDate%>&nbsp;</td>
						<td align="center" width="10%" <%=color%>><%=closeDate%>&nbsp;</td>
					</Tr>
			

<%
				}
			}
		}	
	}	

	
%>	
</Tbody>
	</Table>
	
</form>

<Div id="MenuSol"></Div>
</body>
</html>
