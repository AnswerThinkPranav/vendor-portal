<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%@page import="ezc.ezutil.*,java.math.*"%>
<html>
<%
	String ReQuote="N";
	String ext3Type 	= request.getParameter("ext3Type");
	Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	String vendorName = (String)vendorsHT.get(rfqVend.trim());
	String frmWeltype 	= request.getParameter("type");
	
	if(vendorName==null || "null".equals(vendorName)) vendorName="";
	if(frmWeltype!=null && !("null".equals(frmWeltype)) && "New".equals(frmWeltype) )
		ext3Type="ToBeQuote";
		
%>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<script>
	function openViewUploadWindow()
	{
		var attachDocs=document.myForm.attachDocs.value
		var serverfiles=document.myForm.cposerverfiles.value;
		attach=window.open("../Attachments/ezViewAttachedPODocs.jsp?attachDocs="+attachDocs+"&serverfiles="+serverfiles+"&type=QUOTE","UserWindow1","width=470,height=450,left=150,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,status=no");
	}
	
	function goToPlantAddr(plant)
	{
		window.open("../Purorder/ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,left=280,top=200,width=400,height=400");
	}
	function viewSchedules(){
		document.forms[0].action = "ezViewDeliverySchedules.jsp"
		document.forms[0].submit();
	}
	function deleteRFQ(){
		var flag=confirm("Are you sure of deleting the RFQ?");
		
		if(flag==true)
		{
			//hideButton();
			buttonsSpan	  = document.getElementById("EzButtonsSpan")
			buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
			if(buttonsSpan!=null)
			{
			     buttonsSpan.style.display		= "none"
			     buttonsMsgSpan.style.display	= "block"
			     buttonsSpan.style.visibility		= "hidden"
			     buttonsMsgSpan.style.visibility	= "visible"	     
     			}	
			document.forms[0].action = "ezDeleteRFQ.jsp"
			document.forms[0].submit();
		}
		
		
	}
	function goBack(){
		document.forms[0].action ='ezListGenRFQs.jsp?type=<%=ext3Type%>';
		document.forms[0].submit();
	}	
	function goInvite(){
			document.forms[0].action ="ezListRFQsToInvite.jsp?type=Invite";
			document.forms[0].submit();
	}
	function funQuote(){
			document.forms[0].action = "ezPostQuote.jsp"
			document.forms[0].submit();
	}
	function funView(){
			document.forms[0].action = "ezViewQuoteDetails.jsp"
			document.forms[0].submit();
	}
	function Requote(){
			document.forms[0].action ='ezViewQuoteRemarks.jsp';
			document.forms[0].submit();
	}
	</script>
<Script>
var tabHeadWidth=96
var tabHeight="65%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>

<body bgcolor="#FFFFF7" onLoad="scrollInit('SHOWTOT')" onResize="scrollInit('SHOWTOT')">
<form  name="myForm" method="post">
<%		


		String quoteStatus = request.getParameter("status");
		String extStatus   = request.getParameter("ext");
		
		Date toDate = new Date();
		String[] rfqDatearr = new String[3];
		StringTokenizer stDate = null;
		if(CDate.indexOf(".")>-1)
			stDate = new StringTokenizer(CDate,".");
		else
			stDate = new StringTokenizer(CDate,"/");
			
		int x=0;
		while (stDate.hasMoreTokens()) 
		{
			rfqDatearr[x] = stDate.nextToken();
			x++;
		}
		Date rfqEndDate =null;
		try{
		 	rfqEndDate = new Date((Integer.parseInt(rfqDatearr[2])-1900),Integer.parseInt(rfqDatearr[0])-1,Integer.parseInt(rfqDatearr[1]));			
		}catch(Exception e){}
		
		
		//int compDate = rfqEndDate.compareTo(toDate);	
		
		java.util.Date currentDateObj =new java.util.Date();
		
		java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
            	java.util.Date validUPToDate =null;
		
		int month = 0,date = 0,year = 0;
		
		date = Integer.parseInt(rfqDatearr[1]);
		month = Integer.parseInt(rfqDatearr[0])-1;
		year = Integer.parseInt(rfqDatearr[2])-1900;

		validUPToDate = new java.util.Date(year,month,date);
		int compDate = validUPToDate.compareTo(myChkDateObj);	
		
		ezc.ezcommon.EzLog4j.log(validUPToDate+"*****"+myChkDateObj+"*****"+compDate,"I");
		
		
	
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String display_header	= "RFQ Details";
		
%>
	<input type="hidden" name="attachDocs" value="<%=fstring%>" >
	<input type="hidden" name="cposerverfiles" value="<%=sfstr%>">
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" name="PurchaseOrder" value="<%=poNum%>">
	<input type="hidden" name="ext3Type" value="<%=ext3Type%>">
	<input type="hidden" name="status" value="<%=quoteStatus%>">
	<input type="hidden" name="ext" value="<%=extStatus%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVend%>">
	
	
 	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
 	<Div id='inputDiv' style='position:relative;align:center;top:2%;width:100%;'>
			<Table width="60%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
			<Tr>
				<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
				<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
				<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
			</Tr>
			<Tr>
				<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
				<Td style="background-color:'#F3F3F3'" valign=middle>
					<Table border="0" align="center" valign=middle width="100%" class=welcomecell>
						<Tr>
							<Td style="background-color:'#F3F3F3';" align='center'>
								<font size=2><B>Vendor&nbsp;:&nbsp;</B><%=vendorName%></font>
							</Td>
							<Td style="background-color:'#F3F3F3';" align='center'>
								<font size=2><B>RFQ&nbsp;:&nbsp;</B><%=Long.parseLong(poNum)%></font>
							</Td>
							
							<Td style="background-color:'#F3F3F3';" align='center'>
								<font size=2><B>RFQ Date&nbsp;:&nbsp;</B><%=OrderDate%></font>
							</Td>
						</Tr>
					</Table>
				</Td>
				<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
			</Tr>
			<Tr>
				<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
				<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
				<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
			</Tr>
			</Table>
		</Div>			
 	<br><br>
<%
if(dtlXML!=null && dtlXML.getRowCount()>0)
{
%>
	<DIV id="theads">
 	<table id="tabHead" width="96%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
 	<tr align="center" valign="middle">
    	<th width="8%">Line</th>
    	<th width="22%">Material</th>
      	<th width="38%">Description</th>
      	<th width="8%">UOM</th>
     	<th width="12%">Qty</th>
     	<th width="10%">Plant</th>
 	</tr>
 	</table>
 	</div>

	<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:96%;height:60%;left:2%">
	<table id="InnerBox1Tab" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
<%
	//out.println("dtlXMLdtlXMLdtlXML		"+dtlXML.toEzcString());
   	for(int i=0;i<Count;i++)
   	{
		String curr = dtlXML.getFieldValueString(i,"AMOUNT");
		String net  = dtlXML.getFieldValueString(i,"NET_VALUE");
		String Qty  = dtlXML.getFieldValueString(i,"ORDEREDQUANTITY");
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
		
		/*try
		{
			Qty = (new BigDecimal(Qty).divide(new BigDecimal("1000"),3,BigDecimal.ROUND_HALF_UP))+"";
		}catch(Exception e){
			Qty = dtlXML.getFieldValueString(i,"ORDEREDQUANTITY");
		}*/

%>
     		<tr>
      		<td width="8%"><%=dtlXML.getFieldValueString(i, "POSITION")%></td>
      		<td width="22%">&nbsp;
<%		try{
				out.println(Long.parseLong(dtlXML.getFieldValueString(i,"ITEM")));
		}catch(Exception e){
				out.println(dtlXML.getFieldValueString(i,"ITEM"));
		}
%>
		</td>
      		<td width="38%"><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></td>
      		<td align="center" width="8%"><%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></td>
      		<td align="right" width="12%"><%=Qty%></td>
      		<!--<td align="right" width="12%"><%=myQty%></td>-->
      		<td align="center" width="10%"><a href="JavaScript:void(0)" onClick=goToPlantAddr('<%=dtlXML.getFieldValueString(i,"PLANT")%>')><%=dtlXML.getFieldValueString(i,"PLANT")%></a>&nbsp;</td>
    		</tr>
    		<input type="hidden" name="plant" value="<%=dtlXML.getFieldValueString(i,"PLANT")%>">
    		<input type="hidden" name="itemNO" value="<%=dtlXML.getFieldValueString(i, "POSITION")%>"> 		
    		
    		
<%
		
	
	}
%>
  	</table>
	</div>

	<div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
		<center>
		<Span id="EzButtonsSpan" >
		<%
			String type = request.getParameter("RFQtype");
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
	
			
				buttonName.add("Back");
				buttonMethod.add("goBack()");
			if(attachRetCnt>0 && upLoadedFilesCount>0)	
			{
	
				buttonName.add("View Documents");
				buttonMethod.add("openViewUploadWindow()");
			}
				
				
				
			if (("3".equals(UserType)) || "PP".equals(userRole.trim()))
			{
			
				if(compDate>=0 )			    		
				{
					
					if(quoteStatus!=null && ("N".equals(quoteStatus.trim()) || "R".equals(quoteStatus.trim())))
					{
						if(extStatus!=null && !"N".equals(extStatus.trim()))
						{
							buttonName.add("Quote");
							buttonMethod.add("funQuote()");
						}
	
					}	
				}
					
			}	
			if ((QuotNo!=null)&&(QuotNo.trim().length() > 0))
			{
				ReQuote="Y";
				buttonName.add("View Quote");
				buttonMethod.add("funView()");
			}
			
			buttonName.add("View Delivery Schedules");
			buttonMethod.add("viewSchedules()");
			
			
			if(("2".equals(UserType)))
			{
				buttonName.add("Delete RFQ");
				buttonMethod.add("deleteRFQ()");	
			}
			if("Quoted".equals(ext3Type)&&("2".equals(UserType) ))
			{
				buttonName.add("Requote");
				buttonMethod.add("Requote()");
			}
			out.println(getButtonStr(buttonName,buttonMethod));
				
			
			
			if(compDate<0 )			    		
			{
				out.println("<font color=red>Note:	Quote period has expired.");
			}
		%>
		
		</Span>
		 
		<Span id="EzButtonsMsgSpan" style="display:none">
			<Table align=center>
				<Tr>
					<Td >Your request is being processed... Please wait</Td>
				</Tr>
			</Table>
		</Span>
		</center>
	</div>
<%
}else{
%>
<Div id='inputDiv' style='position:relative;align:center;top:20%;width:100%;'>
	<Table width="45%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'#F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" class=welcomecell>
				<Tr>
					<Td align="center">
					<font size="2px"><b>No line items exists.</b></font>
					</Td>
				</Tr>
			</Table>
		</Td>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
</Div>	

<%
}
%>
<input type="hidden" name="ReQuote" value="<%=ReQuote%>">
	<%@ include file="../Misc/AddMessage.jsp" %>
	
</form>
<Div id="MenuSol"></Div>
</body>
</html>
