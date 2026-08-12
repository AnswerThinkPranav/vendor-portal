<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="ezc.ezutil.*"%>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />	
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<%!  
	private String checkNull(String str)
	{
		if("null".equals(str) ||str==null)
		str="";
		return str; 
    	}
%>
<%
	String reQuote = checkNull(request.getParameter("reQuote"));
	out.println(reQuote+"reQuote::::::::::::::::");
	session.removeValue("ATTACHEDFILES");
	
	//String rfqStatus = "";
	ezc.ezcommon.EzLog4j.log("****=RFQ" ,"I");
	ezc.ezparam.EzcParams rfqParams  = new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams = new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezirfqheaderparams.setRFQNo(rfqNumber);
	ezirfqheaderparams.setSysKey(rfqSysKey);
	rfqParams.setObject(ezirfqheaderparams);
	rfqParams.setLocalStore("Y");
	Session.prepareParams(rfqParams);

	ezc.ezpreprocurement.params.EzoRFQHeaderParams ezoRFQheaderparams = (ezc.ezpreprocurement.params.EzoRFQHeaderParams)Manager.ezGetRFQDetails(rfqParams);

	ezc.ezcommon.EzLog4j.log("****==before==Closing PRS==rfqHeader===**","I");
	ezc.ezparam.ReturnObjFromRetrieve rfqHeaderStatus  = (ezc.ezparam.ReturnObjFromRetrieve)ezoRFQheaderparams.getRFQHeader();
	//rfqHeaderStatus.getFieldValueString(0,"STATUS");
	//ezc.ezcommon.EzLog4j.log("****=RFQ Header==**"+rfqHeaderStatus.toEzcString(),"I");
	String rfqStatus = "",rfqFreight="";
	
	if(rfqHeaderStatus!=null)
	{
		if(rfqHeaderStatus.getRowCount()>0)
		{
		rfqStatus = rfqHeaderStatus.getFieldValueString(0,"ERH_STATUS");
		rfqFreight = "";//checkNull(rfqHeaderStatus.getFieldValueString(0,"FRIEGHT"));
		}
	}
	

%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />

	<script>

	function goToItemText(itemtext)
	{
		//alert("hi");
		$.fancybox.open({
		
			href : 'ezItemText.jsp?itemtext='+itemtext,
			type : 'iframe',
			padding : 5,
			width:'60%',
			height:'300px'
			
		});

		
	}
	function goToPlantAddr(plant)
	{
		window.open("../Purorder/ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,left=280,top=200,width=350,height=320");
	}
	function viewSchedules()
	{
		buttonhide();
		document.forms[0].action = "ezViewDeliverySchedules.jsp"
		document.forms[0].submit();
	}
	function goBack(){
		document.forms[0].action ="ezListRFQs.jsp?type=<%=request.getParameter("type")%>";
		document.forms[0].submit();
	}
	function funQuote()
	{
		buttonhide();
		document.forms[0].action = "ezPostQuote.jsp"
		document.forms[0].submit();
	}
	function funViewReQuote()
	{
		buttonhide();
		document.forms[0].action = "ezRequote.jsp"
		document.forms[0].submit();
	}
	function funView()
	{
		buttonhide();                
		document.forms[0].action = "ezViewQuoteDetails.jsp"
		document.forms[0].submit();
	}
	function funRequote()
	{
		buttonhide();
		document.myForm.action = "ezSendToReQuote.jsp";
		document.myForm.submit(); 
	}
	function buttonhide()
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "none"
			buttonsMsgSpan.style.display	= "block"
		}
	} 
	
	</script>
<Script>
var tabHeadWidth=96
var tabHeight="65%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>

<body bgcolor="#FFFFF7" onLoad="scrollInit('SHOWTOT')" onResize="scrollInit('SHOWTOT')">
<form  name="myForm"  method="post">

<input type="hidden" value="<%=rfqVendor%>" name="rfqVendor">
<input type="hidden" value="<%=rfqCompCode%>" name="rfqCompCode">
<input type="hidden" value="<%=rfqPurOrg%>" name="rfqPurOrg">
<input type="hidden" value="<%=rfqSysKey%>" name="rfqSysKey">
<input type="hidden" value="<%=rfqReQuote%>" name="rfqReQuote">
<input type="hidden" value="<%=rfqQuoteStatus%>" name="rfqQuoteStatus">
<input type="hidden" name="buyerSelVendor" value="<%=request.getParameter("buyerSelVendor")%>">	
<input type="hidden" name="menuItem" value="<%=request.getParameter("menuItem")%>">

<input type="hidden" value="<%=request.getParameter("FromDate")%>" name="FromDate">
<input type="hidden" value="<%=request.getParameter("ToDate")%>" name="ToDate">

<input type="hidden" name="freight" value="<%=rfqFreight%>">
<%			
		Date toDate = new Date();
		String[] rfqDatearr = new String[3];
		StringTokenizer stDate = new StringTokenizer(CDate,"/");
		int x=0;
		while (stDate.hasMoreTokens()) 
		{
			rfqDatearr[x] = stDate.nextToken();
			x++;
		}
		Date rfqEndDate =null;
		
		try{
		
		 	rfqEndDate = new Date((Integer.parseInt(rfqDatearr[2])-1900),Integer.parseInt(rfqDatearr[1])-1,Integer.parseInt(rfqDatearr[0])); 			
		}catch(Exception e){}
		int compDate = rfqEndDate.compareTo(toDate);			
		
		//out.println("RFQ DATE"+rfqEndDate+":::::"+toDate);
		
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String display_header	= "RFQ > RFQ's To Be Responded > RFQ Details";
		 
%>
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" name="rfqNumber" value="<%=rfqNumber%>">
	<input type="hidden" name="portRfqNum" value="<%=request.getParameter("portRfqNum")%>">
	<input type="hidden" name="Freight" value="<%=rfqFreight%>">
	<input type="hidden" name="QuotNo" value="<%=QuotNo%>">
	

	<%@ include file="../Misc/ezSubHeader.jsp"%> 	
	<Br>
 	<Table border="1" align="center" valign=middle width="60%" class=welcomecell>
	<Tr>
		<Th <%=trBGColorH%>>
			<font size=2><B>SAP RFQ&nbsp;:&nbsp;</B></font>
		</Th>
		<Td>
			&nbsp;<%=Long.parseLong(rfqNumber)%>
		</Td>
		<Th <%=trBGColorH%>>
			<font size=2><B>RFQ Date&nbsp;:&nbsp;</B></font>
		</Th>
		<Td>
			&nbsp;<%=checkNull(OrderDate)%>
		</Td>
	</Tr>
	</Table>
 	<br><br>

	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>>
		<th width="8%">Line</th>
		<th width="22%">Material Code</th>
		<th width="38%">Description</th>
		<th width="8%">UOM</th>
		<th width="12%">Qty</th>
		<th width="10%">Plant</th>
		<!--<th width="10%">Text</th>-->
 	</tr>
 	</Thead>
	<TBody>	


<%
//out.println(itemtexts);
	//out.println("::::dtlXML:::"+dtlXML.toEzcString());

   	for(int i=0;i<Count;i++) 
   	{
		String curr = dtlXML.getFieldValueString(i,"AMOUNT");
		String net  = dtlXML.getFieldValueString(i,"NET_VALUE");
		String myQty = dtlXML.getFieldValueString(i,"ORDEREDQUANTITY");
		String itemDesc="";
		try
		{
			itemDesc=checkNull(retItemText.getFieldValueString(i,"TEXTLINE").trim());
		}
		catch(Exception e){}
		itemDesc=itemDesc.replaceAll("\\s", ",");
		try
		{
			/*Double dddd=new Double(Double.parseDouble(net));
			int tt1=dddd.intValue();
			Double ddde=new Double(Double.parseDouble(curr));
			int tt2=ddde.intValue();
			myQty = tt1/tt2;
			
			java.math.BigDecimal netBDValue = new java.math.BigDecimal(net);
    			java.math.BigDecimal currBDValue = new java.math.BigDecimal(curr);
			myQty = netBDValue.divide(currBDValue, 2, java.math.BigDecimal.ROUND_FLOOR).toString();
			*/
			
			myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			//myQty = (Double.parseDouble(myQty)/1000)+"";
		}
		catch(Exception e){} 

%>
     		<tr>
      		<td width="8%"><%=dtlXML.getFieldValueString(i, "POSITION")%></td> 
      		<td width="22%">
<%		try{
				out.println(Long.parseLong(dtlXML.getFieldValueString(i,"ITEM")));
		}catch(Exception e){
				out.println(dtlXML.getFieldValueString(i,"ITEM"));
		}
%>
		</td>
      		<td width="38%"><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%><br><br>      		
      		<textarea rows="5" cols="80" disabled style="padding-top: 5px;">Specification: <%=itemDesc%></textarea></td>
      		<td align="center" width="8%"><%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></td>
      		<!--<td align="right" width="12%"><%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%></td>-->
      		<td align="right" width="12%"><%=myQty%></td>
      		<td align="center" width="10%"><a href="JavaScript:void(0)" onClick=goToPlantAddr('<%=dtlXML.getFieldValueString(i,"PLANT")%>')><%=dtlXML.getFieldValueString(i,"PLANT")%></a>&nbsp;</td>
      		<!--<td align="center" width="10%"><a href="JavaScript:void(0)" onClick=goToItemText('<%=itemDesc%>')><i class="fa fa-file-text"></i></a>&nbsp;</td>-->
      		<!--<td align="center" width="10%"><a href="JavaScript:void(0)" onClick=goToItemText('<%=itemtexts.get(rfqNumber+dtlXML.getFieldValueString(i,"POSITION"))%>')>Text</a>&nbsp;</td>-->
      		<!--<td align="center" width="10%"><a href="JavaScript:void(0)" onClick=goToItemText('<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>')>Text</a>&nbsp;</td>-->
      		
      		</tr>
<%
	}
%>
  	</Tbody>
  	</Table>
	<!--
 	<div align='center' style='position:absolute;top:88%'>
 	<table align="center" width="100%" >
 	<tr align="center">
 	<td class=blankcell> -->
	
	
	<!--<div id="ButtonDiv" style="position:absolute;top:80%;width:100%;visibility:visible">-->
	<center>


<!--<Div id="buttonDiv" align="center" style="position:absolute;left:0%;width:100%;top:90%;padding-top: 60px;">-->
<Div id="buttonDiv" align="center" style="position:relative;">
<span id="EzButtonsSpan" >

	<button type="button" class="btn btn-primary" onclick="goBack()">Back</button>  &nbsp;	
<%
		if(compDate<0)
		{
%>		
			<Br><font color='RED'><B>We regret to inform you that, your RFQ got expired</B></font>						
<%
		}
		else
		{
			String typeStr = request.getParameter("type");

			if(("3".equals(UserType)) && compDate<=0 && !("Y".equals(rfqStatus) || "C".equals(rfqStatus)))
			{
				if ("Y".equals(reQuote))
				{
%>
				<button type="button" class="btn btn-primary" onclick="funViewReQuote()">Re-Quote</button>  &nbsp;	
<%
				}else{
%>		
				<button type="button" class="btn btn-primary" onclick="funQuote()">Quote</button>  &nbsp;	
<%
				} 
			}
			if ((QuotNo!=null)&&(QuotNo.trim().length() > 0))
			{
%>		
				<button type="button" class="btn btn-primary" onclick="funView()">View Quotation</button>  &nbsp;	
<%			
				if(("2".equals(UserType)) && !"ToQuote".equals(typeStr))
				{
%>
					<button type="button" class="btn btn-primary" onclick="funRequote()">Send For ReQuote</button>  &nbsp;	
<%
				}
			}
%>
			<button type="button" class="btn btn-primary" onclick="viewSchedules()">View Delivery Schedules</button>  &nbsp;		
<%
		}	
%>
		
</span>
<span id="EzButtonsMsgSpan" style="display:none">
	<Table align=center>
		<Tr>
			<Td class="labelcell">Your request is being processed... Please wait</Td>
		</Tr>
	</Table>
</span>
	
	</center>
	</div>
	<%@ include file="../Misc/AddMessage.jsp" %>


</form>
<Div id="MenuSol"></Div>
</body>
</html>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
 <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>


<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
