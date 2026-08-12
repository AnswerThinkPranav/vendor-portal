<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>

<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*"%>


<html>
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<Script>
var tabHeadWidth=90
var tabHeight="35%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
	<script>
	function funChangePaymentTerms()
	{
		document.myForm.target = "PopUp";
		document.myForm.action= "../Rfq/ezChangePmntTerms.jsp";
		newWindow=window.open("","PopUp","width=420,height=330,left=280,top=230,resizable=no,scrollbars=no,toolbar=no,menubar=no,status=no");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
		
	}
	function openViewUploadWindow()
	{
		var attachDocs=document.myForm.attachDocs.value
		var serverfiles=document.myForm.cposerverfiles.value;
		attach=window.open("../Attachments/ezViewAttachedPODocs.jsp?attachDocs="+attachDocs+"&serverfiles="+serverfiles+"&type=QUOTE","UserWindow1","width=420,height=330,left=150,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,status=no");
	}
	function funOpen()
	{
		window.open("../Misc/ezViewAllConditions.htm","AllConditions","menubar=no,statusbars=no,toolbar=no,width=700,height=500,left=10,top=10");
	}
	function goBack(){
		document.forms[0].target="_self"
		document.forms[0].action = "ezViewRFQDetails.jsp"
		document.forms[0].submit();
	}
	function displayList(){
		document.forms[0].target="_self"
		document.forms[0].action = "ezListRFQs.jsp?type=List"
		document.forms[0].submit();
	}
	function showOther(rfqNo,itemNO)
	{

		newWindow=window.open("ezGetConditions.jsp?rfqNo="+rfqNo+"&item="+itemNO,"PopUp","width=600,height=400,left=250,top=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	}
	function editNote(item)
	{
		document.myForm.target = "PopUp";
		document.myForm.action= "../Rfq/ezReadItemNote.jsp?ItemNo="+item;
		newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
	}
</script>

<%
	String ext3Type		=  request.getParameter("ext3Type");
	String quoteStatus	=  request.getParameter("status");
	String extStatus	=  request.getParameter("ext");
	String itemNO=request.getParameter("itemNO");
	


	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));

%>
<body onLoad="scrollInit()" onResize="scrollInit()">
<form name="myForm" method="post">
	<input type="hidden" name="attachDocs" value="<%=fstring%>" >
	<input type="hidden" name="cposerverfiles" value="<%=sfstr%>">	
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=ordDate%>">
	<input type="hidden" name="PurchaseOrder" value="<%=poNum%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVend%>">
	<input type="hidden" name="ext3Type" value="<%=ext3Type%>">
	<input type="hidden" name="status" value="<%=quoteStatus%>">
	<input type="hidden" name="ext" value="<%=extStatus%>">
	<input type="hidden" name="pmntTerms" value="<%=PmntTerms%>">
	
	
<%
	String reqFrom =request.getParameter("type");
	String display_header	= "Quotation";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<input type="hidden" name="type" value="<%=reqFrom%>">
	<br><br>
<%
 	if ((QuotNo!=null)&&(QuotNo.trim().length() > 0))
	{
%>

	<Table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="90%">
	<tr>
	<th align="left" width="25%">RFQ Ref. No</th>
      	<td valign="middle" align="left" width="25%"><%=poNum%></td>
	<th align="left" width="25%">RFQ Date</th>
      	<td valign="middle" align="left" width="25%"><%=(ordDate.getMonth()+1)+"/"+ordDate.getDate()+"/"+(ordDate.getYear()+1900)%></td>
	</tr>
	<tr>
	<th align="left" width="25%">Qtn. Ref. No</th>
      	<td valign="middle" align="left" width="25%"><%=retHead.getFieldValue(0,"QUOTATION")%>&nbsp;</td>
	<th align="left" width="25%">Qtn. Date</th>
      	<td valign="middle" align="left" width="25%">
	<%if (retHead.getFieldValue(0,"QUOTDATE")!=null)
		out.println(FormatDate.getStringFromDate((Date)retHead.getFieldValue(0,"QUOTDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT"))));
	%>
	&nbsp;</td>
	</tr>
	<!--	<tr>
	<th align="left" width="25%">All Conditions</th>
	<td width="75%"><a href='javascript:funOpen()'>Click</a></td>
	</tr>	-->
	<tr>
	<th align="left" width="25%">Payment Terms (Entered)</th>
	<td width="75%" colspan=3>
	<%

		try{
			//out.println(localPayTerms);
			out.println(PmntTerms);
		}catch(Exception e){
			out.println("&nbsp;");
		}
	%></td>
	</tr>
	<%
	if(("2".equals(UserType)))
	{%>
	
	<tr>
		<th align="left" width="25%">Payment Terms (SAP)</th>
		<td width="75%" colspan=3>
		<%
			try{
				out.println(retHead.getFieldValueString(0,"PMNTTERM")+"-->"+PayT.getString(retHead.getFieldValueString(0,"PMNTTERM")));
			}catch(Exception e){
				out.println("&nbsp;");
			}
		%></td>
	</tr> 
	<%}%>
	<tr>
		<th align="left" width="25%">Warranty (Entered)</th>
		<td width="75%" colspan=3>
		<%
			
			try{
				//out.println(localWarranties+"&nbsp;");
				out.println(Warranties+"&nbsp;");
			}catch(Exception e){
				out.println("&nbsp;");
			}
		%></td>
	</tr>
	<tr>
	<th align="left" width="25%">Inco Terms</th>
	<td width="75%" colspan=3>
	<%
		try{
			//out.println(retHead.getFieldValueString(0,"INCOTERM1")+"-->"+IncoT.getString(retHead.getFieldValueString(0,"INCOTERM1")));
			out.println(retHead.getFieldValueString(0,"INCOTERM1")+"-->"+retHead.getFieldValueString(0,"INCOTERM2"));
		}catch(Exception e){
			out.println("&nbsp;");
		}
	%></td>
	</Tr>
	<Tr>
	<Th align="left" width="25%">Remarks</th>
	<td width="75%" colspan=3><!--<textarea name="Remarks" readonly rows=2 style="width:100%;overflow:auto">-->
	<%
	try{
		if (RemarksFromSAP!=null)
			out.println(RemarksFromSAP);
		else
			out.println(Remarks);
	}catch(Exception ex){
	}%>
	<!--</textarea>-->&nbsp;</td>
	</Tr>
	</Table>
	<br>

  	<DIV id="theads">
  	<table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="90%">
    	<tr align="center" valign="middle">
      	<th width="10%">Material</th>
      	<th width="14%">Description</th>
      	<th width="5%">UOM</th>
      	<th width="10%">Qty</th>
      	<th width="10%">Price</th>
      	<th width="8%">Curr.</th>
      	<th width="8%">Del.Date</th>
      	<th width="10%">Taxes & other conditions</th>
      	<th width="9%">Item Note</th>
    	</tr>
	</table>
	</Div>


	<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;left:2%">
	<TABLE id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
 	<%
 	//out.println("==============>"+dtlXML.toEzcString());
 	//out.println(itemNO);
      	for(int i=0;i<Count;i++)
      	{
		String curr = dtlXML.getFieldValueString(i,"AMOUNT");
		String net  = dtlXML.getFieldValueString(i,"NET_VALUE");
		itemNO	    = dtlXML.getFieldValueString(i,"POSITION");
		
		
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		java.util.Date delDate = (java.util.Date)dtlXML.getFieldValue(i,"CONFIRMDELIVERYDATE");
		String delDateString = fd.getStringFromDate(delDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
        	
		
		double myQty = 100.0;
		try
		{
			Double dddd=new Double(Double.parseDouble(net));
			int tt1=dddd.intValue();
			Double ddde=new Double(Double.parseDouble(curr));
			int tt2=ddde.intValue();
			myQty = tt1/tt2;
			
		}
		catch(Exception e){ 
			myQty = 100.0; 
		}
	%>
        	<tr>
	  	<td width="10%">&nbsp;
		<%try{
			out.println(Long.parseLong(dtlXML.getFieldValueString(i,"ITEM")));
		}catch(Exception e){
			out.println(dtlXML.getFieldValueString(i,"ITEM"));
		}%>
		</Td>
		
			<td width="14%"><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></td>
			<td width="5%"><%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></td>
			<td width="10%" align="right"><%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%></td>
			<!--<td width="14%" align="right"><%=myQty%></td>-->
			<td width="10%" align="right"><%=myFormat.getCurrencyString(curr)%>&nbsp;</td>
		<%if((curr!=null)&&(Double.parseDouble(curr)!=0.0)){%>
	      	<td width="8%" align="center"><%=dtlXML.getFieldValueString(i,"CURRENCY")%>&nbsp;</td>
		<%}else{%>
			<td width="8%">&nbsp;</td>
		<%}%>
		<td width="8%" align="center"> <%=delDateString%> </td>
		<td width="10%" align="center">
		<a href="javascript:onClick=showOther('<%=poNum%>','<%=itemNO%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
		</td>
		<td align="center" width="9%">
		<a href="javascript:onClick=editNote('<%=(i+1)*10%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
		</td>
      		</tr>
      		
<%	

	if(serviceRFQ){
		mySerRetTemp=(ReturnObjFromRetrieve)myItemSer.get(dtlXML.getFieldValueString(i,"POSITION"));
		if(mySerRetTemp!=null&&mySerRetTemp.getRowCount()>0){
%>
		<tr>
		<td colspan=10>
		<span id="span<%=i%>"  style="visibility:visible;display:visible">
		<table align=center width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
		<tr>

			<th  width = "10%">Service No</th>
			<th  width = "20%">Short Text</th>
			<th  width = "4%">UOM</th>
			<th  width = "7%">Quantity</th>
			<th  width = "7%">Price</th>
			<th  width = "10%">Value</th>
			<th  width = "5%">Curr</th>
			


		</tr>

<%
		for(int s=0;s<mySerRetTemp.getRowCount();s++)
		{
%>
			<tr>
				<td  width = "10%" align="center">

				<input type="hidden" name="serToRFQLine" value="<%=dtlXML.getFieldValueString(i,"POSITION")%>">&nbsp;
				<%=mySerRetTemp.getFieldValueString(s,"SERVICE")%> 
				<input type="hidden" name="serLine" value="<%=mySerRetTemp.getFieldValueString(s,"SER_LINE")%>">
				</td>
				<td  width = "20%" align="left">&nbsp;<%=mySerRetTemp.getFieldValueString(s,"SHORT_TEXT")%></td>
				<td  width = "4%" align="center"><%=mySerRetTemp.getFieldValueString(s,"BASE_UOM")%></td>
				<td  width = "7%" align="right"><%=mySerRetTemp.getFieldValueString(s,"QUANTITY")%></td>
				<td  width = "7%" align="right"><%=mySerRetTemp.getFieldValueString(s,"GR_PRICE")%></td>
				<td  width = "10%" align="right"><%=mySerRetTemp.getFieldValueString(s,"GROSS_VAL")%></td>
				<td  width = "5%" align="center">&nbsp;<%=dtlXML.getFieldValueString(i,"CURRENCY")%></td>
				

			</tr>

<%
		}
%>				
								
		</table>
		</span>
<%
		}else{
		
%>				
		<tr>
		<td colspan=10 align="center">No Service Line Items Exits</td>
		</tr>
<%				
		}


	}

 %>     		
      		
  
      		
	<%}%>
	</table>
 	</div>

<%	}
	else
	{
%>
	<br><br><br><br>
	<Table width=60% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
	<Tr><Th>Quotation has not been submitted for RFQ No : <%=poNum%></Th></Tr>
	</Table>
	<br><br>
<%}
%>

	<div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
	<center>
<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		
		if(attachRetCnt>0 && upLoadedFilesCount>0)	
		{

			buttonName.add("View Documents");
			buttonMethod.add("openViewUploadWindow()");
		}
		if(("2".equals(UserType)))
		{
			buttonName.add("Change PaymentTerms");
			buttonMethod.add("funChangePaymentTerms()");
		}
		buttonName.add("Back");
		String userType = (String)session.getValue("UserType");	
 	   	if(userType.equals("2")){
		buttonMethod.add("goBack()");
		}else if("List".equalsIgnoreCase(reqFrom)){
		buttonMethod.add("displayList()");
		}else{
		buttonMethod.add("goBack()");
		}
		
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	</center>
	</div>
	<%@ include file="../Misc/AddMessage.jsp" %>
	
</form>
<Div id="MenuSol"></Div>
</body>
</html>
