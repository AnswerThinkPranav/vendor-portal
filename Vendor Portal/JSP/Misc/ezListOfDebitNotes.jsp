<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>           
<%@ page import="java.text.DateFormat,java.text.SimpleDateFormat"%>
                     
<% 
	String fromDate = request.getParameter("FromDate");
	String toDate   = request.getParameter("ToDate"); 
	String userType  = (String)session.getValue("UserType"); 
	int dateRange = 30;        
%>  
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%> 
<%@ include file="../../../Includes/Jsps/Misc/iListDebitNotes.jsp"%>     
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezJQueryScript.jsp" %>  
<Html> 
<Head>    
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>
	function funCredit(ind,doc,creditno,docDate,postDate,grossAmt)   
	{
	    	var w = 500;
		var h = 500;
		var left = Number((screen.width/2)-(w/2));
		var top = Number((screen.height/2)-(h/2));

	    	var url = "ezEnterDebitCredit.jsp?creditno="+creditno+"&docDate="+docDate+"&doc="+doc+"&ind="+ind+"&postDate="+postDate+"&grossAmt="+grossAmt;
		window.open(url,"UserWindow","width=700,height=250, left ="+left+" top ="+top+" resizable=no,help=no,titlebar=no,status=off, menubar = no,minimize=no, locationbar = no scrollbars=yes");
	}
	function ezBack(event)        
	{
		document.location.href = event; 
	}
	function ezSubmit()
	{
		var fromDate = document.myForm.FromDate.value;
		var toDate   = document.myForm.ToDate.value;
		
		if(fromDate > toDate)
		{
			alert("From Date should be less than To Date!!");
			return false;
		}
		
		document.myForm.action = "ezListOfDebitNotes.jsp";
		document.myForm.submit(); 
	}	
</Script>
</head>

<Body scroll=no>
<form method="post" name="myForm">
<input type="hidden" id="status" value="">

<%
	String display_header = "List of Debit Notes -- <Font color='BLUE'>"+ session.getValue("Vendor")+"</Font>";  
%>
	
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
	<Table width="60%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
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
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' valign=center>
					From Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='28%' align=right valign=center>
					To Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate" readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
				</Td>
				<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='35%' align=right>
					<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" onclick='ezSubmit()' onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
				</Td>-->
				<Td onClick="ezSubmit()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
					<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="ezSubmit()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
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


	<Div style="position:absolute;top:20%;width:100%;left:0%;overflow:auto;height:328px">
	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Thead>
	<Tr>
			<th align="center" width="10%">Vendor Ref No</th>
			<th align="center" width="10%">Debit Note</th>
			<th align="center" width="10%">Posting Date</th>
			<th align="center" width="10%">Gross Amount</th>
			<th align="center" width="10%">Status</th>
			<th align="center" width="10%">Vendor Credit Note</th>  
	</Tr>
	</Thead>
	<TBody>		        

<%	
	SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");  
	DateFormat toFormat = new SimpleDateFormat("dd-MMM-yyyy"); 
  	java.util.Date  dt=new java.util.Date();  
  	int index=0;
	String debitNo="",debitYear="",debitDate="",postDate="",grossAmt="",accDocNo="",creditNo="",creditStatus="",creditDispStatus="";
	for(int i=0;i<retRejDebitNotesObjCnt;i++)      
	 {
	 	 debitNo	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"DOCNO"));  
	 	 accDocNo	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"ACCDOCNO"));
		 debitYear	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"DOCYEAR"));
		 postDate	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"POSTINGDATE"));
		 grossAmt 	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"GROSSAMT"));
		 debitDate	=checkNull(retRejDebitNotesObj.getFieldValueString(i,"DOCDATE"));
		 if(creditStat.size()>0)
		 {
		 	creditNo	=checkNull((String)creditStat.get(debitNo));  
		 }
%>
		<Tr>
			<td align="center" width="10%"><%=accDocNo%>&nbsp;</td>
			<td align="center" width="10%"><%=debitNo%></td> 
			<td align="center" width="10%"><%=postDate%></td>
			<td align="center" width="10%"><%=grossAmt%></td>
			
			
<%
			if("NA".equals(creditNo) || creditNo=="NA" || "".equals(creditNo) || creditNo=="")
			{
				creditDispStatus = "Not Yet Accepted";
				if("3".equals(userType))
					creditStatus="Enter Credit Note";
				else if(!"3".equals(userType))
					creditStatus="";  
			}
			else
			{
				creditDispStatus = "Accepted";
				creditStatus= creditNo;   
			}
%>
			<td align="center" width="10%"><%=creditDispStatus%></td>
			<td  align="center" width="10%"><a id="Entry_<%=index%>"  href="javascript:funCredit('<%=index%>','<%=debitNo%>','<%=creditNo%>','<%=debitDate%>','<%=postDate%>','<%=grossAmt%>')"><%=creditStatus%></a></td>

		</Tr>
	
<%
	index++;
	}
	
%>	

</Tbody>
	</Table>
	
</Form>

<Div id='MenuSol'/>
</Body>
</Html>
 
