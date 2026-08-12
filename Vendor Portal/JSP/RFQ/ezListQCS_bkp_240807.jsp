<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iListQcfs.jsp"%>
<%
	ezc.ezutil.FormatDate fD=new ezc.ezutil.FormatDate();
	int myRetCount = myRet.getRowCount();
%>
<html>
<head>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	var tabHeadWidth=95
	var tabHeight="70%"
	if(screen.width==800)
	{
		tabHeight="57%";
	}
</Script>
<script>
var newWindow
</script>
 <script src="../../Library/JavaScript/Rfq/ezListQCS.js"></Script>
 <Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
 <Script>
 function showTrail()
 {
 	var radLen = document.myForm.collectiveRFQNo.length
 	var colno = 0
 	if(!isNaN(radLen))
 	{
		for(i=0;i<radLen;i++)
		{
			if(document.myForm.collectiveRFQNo[i].checked)
			{
				colno = document.myForm.collectiveRFQNo[i].value
				break;
			}
		}
 	}
 	else
 	{
 		colno = document.myForm.collectiveRFQNo.value	
 	}
 	document.myForm.wf_trail_list.value = colno
 	hideButton();
 	document.myForm.action = "../Misc/ezWFAuditTrailList.jsp"
 	document.myForm.submit()
}
function funBack()
{
	document.location.href="../Misc/ezSBUWelcome.jsp";
}

</Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no>
<form name="myForm">
<input type ="hidden" name="status" value ="<%=status%>">
<input type ="hidden" name="reasons" value ="">
<input type=hidden name=wf_trail_list >
<input type=hidden name=wf_trail_type value='QCF_RELEASE'>
<%
	String display_header = "Collective RFQs List";
	if("A".equals(request.getParameter("Type")))
		display_header = "QCF List";
	if("CR".equals(request.getParameter("status")))
		display_header = "QCF List - Not Yet Submitted For Approval";		
  	if("E".equals(type))
		display_header = "Expired QCF List";   

	
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<Br>
<%
	if(myRetCount == 0)
	{
		
		
%>
		<br><br><br><br>
		<Table width="50%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 align="center">
		<Tr align="center">
			<th>No Collective RFQs Exist.</th>
		</Tr>
		</Table>
		<Div id="ButtonDiv" align=center style="position:absolute;top:91%;visibility:visible;width:100%">
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			buttonName.add("Back");
			buttonMethod.add("funBack()");
			out.println(getButtonStr(buttonName,buttonMethod));
%>
		</Div>

<%	}
	else
	{
	
		
		int keyCode = fD.MMDDYYYY;
		String dateSep = (String)session.getValue("DATESEPERATOR");
		
		ezc.ezparam.ReturnObjFromRetrieve globalRet = null;
		
		Vector grtypes = new Vector();
		grtypes.addElement("date");
		grtypes.addElement("date");
		grtypes.addElement("date");
		EzGlobal.setColTypes(grtypes);
		
		if(keyCode==3)
			EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");
		else if (keyCode==4)	
			EzGlobal.setDateFormat("dd"+dateSep+"MM"+dateSep+"yyyy hh:mm");

		Vector grColNames = new Vector();
		grColNames.addElement("RFQ_DATE");
		grColNames.addElement("VALID_UPTO");
		grColNames.addElement("WFDATE");
		EzGlobal.setColNames(grColNames);
		
		globalRet = EzGlobal.getGlobal(myRet);
	
%>
	<Div id="theads">
  	<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="95%">
	    	<Tr align="center" valign="middle">
	    	        
			<th width="15%">QCF</th>
			<th width="20%">RFQ Date</th>
			<th width="20%">RFQ Valid Upto</th>
			<th width="15%">Vendors</th>
			<th width="15%">Quoted</th>
			<th width="15%">Not&nbsp;Quoted</th>
			

			
	    	</Tr>
 	</Table>
 	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:100%;height:75%;">
	<Table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%	
	for(int i=0;i<myRetCount;i++)
	{
		java.util.Date rfqDate 	= (java.util.Date)myRet.getFieldValue(i,"RFQ_DATE");
		java.util.Date validUpto= (java.util.Date)myRet.getFieldValue(i,"VALID_UPTO");
		int totQuoted		= Integer.parseInt(myRet.getFieldValueString(i,"TOT_QUOTED"));
		int totRFQs		= Integer.parseInt(myRet.getFieldValueString(i,"TOT_RFQ"));
		
		if(!participant.equals(myRet.getFieldValueString(i,"NEXTPARTICIPANT")) && participant.equals(myRet.getFieldValueString(i,"DELPARTICIPANT")))
			isDelParticipant = myRet.getFieldValueString(i,"NEXTPARTICIPANT");
		else
			isDelParticipant = "NO";		
			
			
%>   
		<tr>
			
<%			if(totQuoted > 0)
			{
				if(totQuoted<4)
				{
				    if("A".equals(type))
				    {
%>					<td width="15%"><a href = 'ezQuotationComparisionForm.jsp?collectiveRFQNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>' onClick="hideButton()"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>
<%				
				    } 
				    else 
				    {
%>
					<td width="15%"><a href = 'ezQuotationComparisionForm.jsp?PAGE=NEW&status=<%=status%>&collectiveRFQNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>' onClick="hideButton()"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>
<%				    }	
				}
				else
				{
%>					<td width="15%"><a href = 'ezListRFQByCollectiveRFQ.jsp?collectiveRFQNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>'><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>
<%				}
%>				
<%			}
			else
			{
%>			
				<td width="15%"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></td>
				
<%
			}
%>			
			
			<td width="20%" align="center"><%=globalRet.getFieldValue(i,"RFQ_DATE")%></td>
			<td width="20%" align="center"><%=fD.getStringFromDate(validUpto,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%></td>
			
			
			<td width="15%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','A')"><%=myRet.getFieldValueString(i,"TOT_RFQ")%></a></td>
		    <%
		    	if("0".equals(myRet.getFieldValueString(i,"TOT_QUOTED")))
		    	{
		    %>
		 		<td width="15%" align="center"><%=myRet.getFieldValueString(i,"TOT_QUOTED")%></td>   
		    <%
		    	} else {
		    %>
				<td width="15%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','Y')"><%=myRet.getFieldValueString(i,"TOT_QUOTED")%></a></td>
		    <%
		    	}
		    	if("0".equals(myRet.getFieldValueString(i,"TOT_NOT_QUOTED")))
		    	{
		    %>
		    		<td width="15%" align="center"><%=myRet.getFieldValueString(i,"TOT_NOT_QUOTED")%></td>
		    <%
		    	} else {
		    %>
		    
				<td width="15%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','N')"><%=myRet.getFieldValueString(i,"TOT_NOT_QUOTED")%></a></td>
		    <%
		    	}
		    %>	
		    
	      	</tr>
<%
	}
%>
	</table>
	</div>

	<div id="ButtonDiv" align=center style="position:absolute;top:91%;visibility:visible;width:100%">
 	<Span id="EzButtonsSpan" >
		    
<%		    
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Back");
		buttonMethod.add("funBack()");
		
          
 	String chkUserRole = (String)session.getValue("USERROLE");
 	if("MG".equals(chkUserRole) || "SM".equals(chkUserRole))
 	{
 
 	buttonName.add("Close");
	buttonMethod.add("CloseQCF()");
	
 	}

 	if(!"CR".equals(status))
 	{
 
 	buttonName.add("Audit");
	buttonMethod.add("showTrail()");	
	
 	}
 	   out.println(getButtonStr(buttonName,buttonMethod));

 %>	
 	</Span>
 
 	<Span id="EzButtonsMsgSpan" style="display:none">
 		<Table align=center>
 			<Tr>
 				<Td >Your request is being processed... Please wait</Td>
 			</Tr>
 		</Table>
	</Span>
</Div>
<%   }  %>
</form>
<Div id="MenuSol"></Div>
</body>
</html>