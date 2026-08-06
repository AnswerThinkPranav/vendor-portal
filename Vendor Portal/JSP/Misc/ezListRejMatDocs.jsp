<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>
<%@ page import="java.text.DateFormat,java.text.SimpleDateFormat"%>
   
<% 
	String fromDate = request.getParameter("FromDate");
	String toDate   = request.getParameter("ToDate");     
	int dateRange = 30;
%>  
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%> 
<%@ include file="../../../Includes/Jsps/Misc/iListRejMatDocs.jsp"%>
<Html> 
<Head>    
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezJQueryScript.jsp" %>

<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>		
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
		
		document.myForm.action = "ezListRejMatDocs.jsp";
		document.myForm.submit();
	}
	function funClick()
	{
		 var url = "ezRejMatDocPopUp.jsp";
		window.open(url,"UserWindow","width=200,height=200, left =left top =top resizable=no, menubar = no locationbar = no scrollbars=yes");
	
	}
</Script>
</head>

<Body scroll=no>
<form method="post" name="myForm">
<%
	String display_header = "List of Rejected Material Docs";
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


	<div style="position:absolute;top:20%;width:100%;left:0%;overflow:auto;height:328px">
	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Thead>
	<Tr>
			<th align="center" width="10%">Material Doc No.</th>
			<th align="center" width="10%">PO No.</th>
			<th align="center" width="10%">PO Item No.</th>
			<th align="center" width="10%">Material Code</th>
			<th align="center" width="20%">Material Desc.</th>
			<th align="center" width="5%">UOM</th>
			<th align="center" width="10%">Rejected Qty</th>
			<th align="center" width="10%">Result</th>
	</Tr>
	</Thead>
	<TBody>		        

<%	
	SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S"); 
	DateFormat toFormat = new SimpleDateFormat("dd-MMM-yyyy"); 
  	java.util.Date  dt=new java.util.Date();  
	String matDocNo="",poNum="",poItemNo="",materialCode="",materialDesc="",UOM="",Qty="",inspecLot="";
	for(int i=0;i<retRejMatDocsObjCnt;i++)    
	 {
		 matDocNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDOCNO"));
		 poNum		=checkNull(retRejMatDocsObj.getFieldValueString(i,"PONUM"));
		 poItemNo 	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POITEMNO"));
		 materialCode	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATCODE"));
		 materialDesc	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDESC"));
		 UOM		=checkNull(retRejMatDocsObj.getFieldValueString(i,"UOM"));
		 Qty		=checkNull(retRejMatDocsObj.getFieldValueString(i,"QTY"));
		 inspecLot	=checkNull(retRejMatDocsObj.getFieldValueString(i,"INSLOT"));
		 		 
%>
		<Tr>
			<td align="center" width="10%"><%=matDocNo%>&nbsp;</td>
			<td align="center" width="10%"><%=poNum%></td>
			<td align="center" width="10%"><%=poItemNo%></td>
			<td align="center" width="10%"><%=materialCode%></td>
			<td align="left" width="20%">&nbsp;&nbsp;&nbsp;<%=materialDesc%></td>
			<td align="center" width="5%"><%=UOM%></td>
			<td align="center" width="10%"><%=Qty%></td>
			<td align="center" width="10%"><a href="javascript:funClick()" >Click</a></td>
		</Tr>
	
<%
	}
	
%>	

</Tbody>
	</Table>
	
</form>

<Div id="MenuSol"></Div>
</body>
</html>
