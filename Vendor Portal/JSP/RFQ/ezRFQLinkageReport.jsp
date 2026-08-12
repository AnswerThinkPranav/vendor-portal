<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ page import="java.util.*,java.text.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>

<%@ include file="../../../Includes/Jsps/Rfq/iRFQLinkageReport.jsp"%>

<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<Script>
	var tabHeadWidth=95
	var tabHeight="57%"
	var syskey = '<%=(String)session.getValue("SYSKEY")%>'
	var colno = 0
	if(screen.width==800)
	{
		tabHeight="40%";
	}
	function funShowVndrDetails(soldto)
	{
		var retValue = window.showModalDialog("../RFQ/ezVendorContactDetails.jsp?SysKey="+syskey+"&SoldTo="+soldto,window.self,"center=yes;dialogHeight=25;dialogWidth=40;help=no;titlebar=no;status=no;minimize:yes")	
	} 
	function checkFields()
	{
		var radLen = document.myForm.chk1.length
	 	
	 	var count = 0
	 	if(!isNaN(radLen))
	 	{
	 		for(i=0;i<radLen;i++)
	 		{
	 			if(document.myForm.chk1[i].checked)
	 				count++
	 		}
	 		
	 		if(count == 0)
	 		{
	 			alert("Please select the Collective RFQ No");
	 			return false;
	 		}
	 		
	 		for(i=0;i<radLen;i++)
	 		{
				if(document.myForm.chk1[i].checked)
				{
					colno = document.myForm.chk1[i].value
					break;
				}
	 		}
	 	}
	 	else
	 	{
			if(document.myForm.chk1.checked)
			{
				colno = document.myForm.chk1.value
			}
			else
			{
	 			alert("Please select the Collective RFQ No");
	 			return false;
			}
 		}
 		return true;
	}
	
	
	
	function getDefaultsFromTo()
	{
		<%
		java.util.Date today = new java.util.Date();
		java.util.Date tomorrow = new java.util.Date();
		today.setDate(today.getDate()-1);
		
		ezc.ezutil.FormatDate format = new ezc.ezutil.FormatDate();


		if (("".equals(fromDate))&&("".equals(toDate)))
		{%> 
			document.myForm.fromDate.value = "<%=format.getStringFromDate(today,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>";
			document.myForm.toDate.value = "<%=format.getStringFromDate(tomorrow,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>";
		<%}%> 
		

	}   
	function funOpenWin()
	{
		if(checkFields())
		{
			document.myForm.commentType.value="QUERY";
			var retValue = window.showModalDialog("ezAddQcfQueriesWindow.jsp?COLNO="+colno+"&DOCTYPE=QCF",window.self,"center=yes;dialogHeight=30;dialogWidth=50;help=no;titlebar=no;status=no;minimize:yes")	
		}
	}
 function showTrail()
 {
 	if(checkFields())
	{
 	document.myForm.wf_trail_list.value = colno;
 	var url="../Misc/ezOfflineWFAuditTrailList.jsp?wf_trail_type=QCF_RELEASE&wf_trail_list="+colno
 	//window.showModalDialog(url,window.self,"center=yes;dialogHeight=40;dialogWidth=50;help=no;titlebar=no;status=no;resizable=no")	
 	
 	var mywind=window.open(url,"AuditWin","width=700,height=300,left=150,top=150,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=no");
 	//document.myForm.action='../Misc/ezWFAuditTrailList.jsp'
 	//document.myForm.submit()
 	}
}	
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/ezConvertDates.js"></Script>

<Script>
function SAPView(num)
{
	//var url="ezQcfSAPView.jsp?qcfNumber="+num;
	var url="ezQCFSAPPrint.jsp?qcfNumber="+num;
	var sapWindow=window.open(url,"newwin","width=850,height=650,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}

function chkDates()
{
	var fd = document.myForm.fromDate.value;
	var td = document.myForm.toDate.value;
		
	if(document.myForm.fromDate.value=="")
	{
		alert("Please select From Date from calendar.");
		document.myForm.fromDate.focus();
		return;
	}
	if(document.myForm.toDate.value=="")
	{
		alert("Please select To Date from calendar.");
		document.myForm.toDate.focus();
		return;
	}
		
	var toSelDate = document.myForm.toDate.value;
	var fromSelDate = document.myForm.fromDate.value;

	var toDate = toSelDate.split("/");
	var fromDate = fromSelDate.split("/");
	var tDate = new Date();
	var fDate = new Date();

	var a1 = parseInt(toDate[1],10)-1;
	var b1 = parseInt(fromDate[1],10)-1;

	tDate = new Date(toDate[2],a1,toDate[0]);
	fDate = new Date(fromDate[2],b1,fromDate[0]);

	if(fDate >= tDate)
	{
		alert("To Date should be greater than  From Date");
		document.myForm.toDate.focus();
		return;
	}		
	return true;
}

function ezSubmit()
{
	y=chkDates();
	if(y)
	{
		document.myForm.action="ezRFQLinkageReport.jsp";
		document.myForm.submit();
	}
}
</script>
</head>


<body bgcolor="#FFFFF7" onLoad="scrollInit();getDefaultsFromTo()"  onResize="scrollInit()" scroll="no">
<form  method="post" name="myForm">
<input type=hidden name=wf_trail_list >
<%
	String display_header = "PR-RFQ-PO Report";
	boolean dispflag=false;
%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>

	<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
	<Table width="45%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
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
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='45%' align=center valign=center>
					From Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=fromDate%>" name="fromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("fromDate")%>
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='45%' align=center valign=center>
					To Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=toDate%>" name="toDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("toDate")%>
				</Td>
				<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='45%' align=right>
					<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none"  onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" onClick="ezSubmit()">
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

	<br>
<%
	if (Count > 0)
	{
		
		String dateSep = (String)session.getValue("DATESEPERATOR");
		ezc.ezparam.ReturnObjFromRetrieve globalRet = null;

		Vector grtypes = new Vector();
		grtypes.addElement("date");
		grtypes.addElement("date");
		EzGlobal.setColTypes(grtypes);
		EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm:ss");

		Vector grColNames = new Vector();
		grColNames.addElement("CREATED_ON");
		grColNames.addElement("MODIFIED_ON");
		EzGlobal.setColNames(grColNames);
				
		globalRet = EzGlobal.getGlobal(myRet);
%>

	<Div id="theads">
	<Table  id="tabHead"  width="95%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
	<Tr>
	      <th width="5%">&nbsp;</th>	
	      <th width="9%">PR No</th>
	      <th width="9%">Coll.RFQ No</th>
	      <th width="9%">RFQ No</th>
	      <th width="13%">RFQ Created By</th>
	      <th width="9%">RFQ Created On</th>
	      <th width="10%">Vendor Sent To</th>
	      <th width="10%">PO/Con. No.</th>
	      <th width="16%">PO/Con. Created By</th>
	      <th width="10%">PO/Con. Created On</th>
	      
      	</Tr>
	</Table>
	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:87%;height:57%;">
	<Table id="InnerBox1Tab"  width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
<%
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String rowColor ="",poconNo="",poconCreatedBy="",poconCreatedDate="";
	String colRFQNo = "";
	for (int i=0 ; i < Count ; i++)
	{
		poconNo="";
		poconCreatedBy="";
		poconCreatedDate="";
		if(!"null".equals(myRet.getFieldValueString(i,"PO_NO")))
		{
			poconNo = myRet.getFieldValueString(i,"PO_NO");
			poconCreatedBy = myRet.getFieldValueString(i,"MODIFIED_BY");
			poconCreatedDate = fd.getStringFromDate((Date)myRet.getFieldValue(i,"MODIFIED_ON"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		}
	
		if("C".equals(myRet.getFieldValueString(i,"POCONSTAT")))
			rowColor = "#0000ff";
		else
			rowColor = "#ff0000";
		
		colRFQNo = myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO");
%>		
		<Tr>
			<Td width="5%" align="center"><input type=radio name=chk1 value="<%=colRFQNo%>"></Td>
			<Td width="9%" align="center"><%=myRet.getFieldValueString(i,"PR_NO")%>&nbsp;</Td>
			<Td width="9%" align="center"><a href="javascript:SAPView('<%=colRFQNo%>')"><%=colRFQNo%></a></Td>
			<Td width="9%" align="center"><%=myRet.getFieldValueString(i,"RFQ_NO")%></Td>
			<Td width="13%" align="center"><%=myRet.getFieldValueString(i,"CREATED_BY")%></Td>
			<!--<Td width="9%" align="center"><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"RFQ_DATE"),".",ezc.ezutil.FormatDate.DDMMYYYY)%></Td>-->
			<Td width="9%" align="center"><%=globalRet.getFieldValue(i,"CREATED_ON")%></Td>
			<Td width="10%" align="center"><a href="javascript:funShowVndrDetails('<%=myRet.getFieldValueString(i,"SOLD_TO")%>')"><%=myRet.getFieldValueString(i,"SOLD_TO")%></a></Td>
			<Td width="10%" align="center"><font color="<%=rowColor%>"><%=poconNo%></font>&nbsp;</Td>
			<Td width="16%" align="center"><%=poconCreatedBy%>&nbsp;</Td>
			<Td width="16%" align="center"><%=globalRet.getFieldValue(i,"MODIFIED_ON")%>&nbsp;</Td>
			<!--<Td width="10%" align="center"><%=poconCreatedDate%>&nbsp;</Td>-->
			
			
		</Tr>
<%
	}
%>
		</Table>
		</Div>
		
		
		
		
			
		
		
		
		
		
		<Div id="back" align=center style="position:absolute;top:85%;visibility:visible;width:100%">
		
		<Table>
		<Tr>
			<Td class=blankcell><font color="#ff0000">
			* for PO 
			</font></Td>
			<Td class=blankcell>
			</Td>
			<Td class=blankcell><font color="#0000ff">
			* for Contract
			</font></Td>
					
		</Tr>
		</Table>
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Audit");   
			buttonMethod.add("showTrail()");
			buttonName.add("Queries");   
			buttonMethod.add("funOpenWin()");
			out.println(getButtonStr(buttonName,buttonMethod));


%>
</Div>
<%
}
else if ("".equals(fromDate))
{
%>
	<br><br><br><br>
	<Table width=60% align="center" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=1>
	<Tr><Th>Please Select From Date and To Date and click on Go Button to view List of RFQs converted as POs/Contracts between the dates.</Th></Tr></Table>
<%
}
else
{
	%>
	<br><br><br><br>
	<Table width=50% align="center" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=1>
	<Tr><Th>
	No RFQs converted as POs/Contracts with in the selected Period.
	</Th></Tr></Table>
<%
}%>
<input type=hidden name='commentType' >
</form>
<Div id="MenuSol"></Div>
</body>
</html>
