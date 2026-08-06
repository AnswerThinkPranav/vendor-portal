 <%@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
 
 <html>   
 <head>  
 <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
 <%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
 <script>
 	function getMatDocList(selType)
 	{
 		document.myForm.selType.value = selType;
 		document.myForm.fDate.value = document.myForm.FromDate.value;
 		document.myForm.tDate.value = document.myForm.ToDate.value;
 		
 		if(document.myForm.selType.value == 'GE')
 			document.myForm.action = "../Misc/ezListGateEntryMatDocs.jsp";
 		if(document.myForm.selType.value == 'SH')
 			document.myForm.action = "../Misc/ezListShortagMatDocs.jsp";
 		if(document.myForm.selType.value == 'AC')
 			document.myForm.action = "../Misc/ezListAcceptedMatDocs.jsp";
 		if(document.myForm.selType.value == 'RE')
 			document.myForm.action = "../Misc/ezListRejectMatDocs.jsp";
 		
 		document.myForm.submit();
 		
 	}
 </script>
 </head>
 <body scroll=no>
 <form name = 'myForm' method="post">	
 <input type='hidden' name='fDate' value=''>
 <input type='hidden' name='tDate' value=''>
 <input type='hidden' name='selType' value=''> 
 
 <%
 	String display_header = "Material Documents -- <Font color='BLUE'>"+ session.getValue("Vendor")+"</Font>"; 
 
	String fromDate = request.getParameter("FromDate"); 
	String toDate   = request.getParameter("ToDate");     
	int dateRange = 30;        
	
	String userType   = (String)session.getValue("UserType");
%>  
<%//@ include file="../Misc/ezGetDefaultFromToDates.jsp"%> 
<%
	if(fromDate== null && toDate == null)
	{
		Date toDateObj=new Date();
		String toDay="",toMonth="",toYear="";
		String fromDay="",fromMonth="",fromYear="";

		toDay=""+toDateObj.getDate();
		if(toDateObj.getDate()<10)
			toDay="0"+toDateObj.getDate();

		toMonth=""+(toDateObj.getMonth()+1);
		if((toDateObj.getMonth()+1)<10)
			toMonth="0"+(toDateObj.getMonth()+1);

		toYear=""+(toDateObj.getYear()+1900);

		toDate = toDay+"/"+toMonth+"/"+toYear;

		Date fromDateObj=new Date(toDateObj.getYear(),toDateObj.getMonth(),toDateObj.getDate()-dateRange);

		fromDay=""+fromDateObj.getDate();
		if(fromDateObj.getDate()<10)
			fromDay="0"+fromDateObj.getDate();

		fromMonth=""+(fromDateObj.getMonth()+1);	
		if((fromDateObj.getMonth()+1)<10)
			fromMonth="0"+(fromDateObj.getMonth()+1);

		fromYear=""+(fromDateObj.getYear()+1900);

		fromDate = fromDay+"/"+fromMonth+"/"+fromYear;
		
		/*int tempMonth = Integer.parseInt(fromMonth);
		if(tempMonth==1 || tempMonth==2 || tempMonth==3)
			fromYear = (Integer.parseInt(fromYear)-1)+"";
		
		fromDate = "01/04/"+fromYear;*/

	}
%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
 <%@ include file="ezDisplayHeader.jsp"%>
 <BR>
 <TABLE align=center style="background:#ffffff;BORDER-RIGHT: #4374a6 1px solid; BORDER-TOP: #4374a6 1px solid; BORDER-LEFT: #4374a6 1px solid; BORDER-BOTTOM: #4374a6 1px solid" cellSpacing=0 cellPadding=0 width="50%"  height=65% border=0>
 <TR>
 	<TD style="background:#ffffff" width="80%" align=left valign=middle>
 		<Table height=100% width="100%" border="0" cellspacing="0" cellpadding="0">
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
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
		 					From Date&nbsp;&nbsp;
		 				</Td>
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
		 					<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
		 				</Td>
		 			</Tr>
		 			<Tr>
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
							To Date&nbsp;&nbsp;
		 				</Td>
		 				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
							<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
		 				</Td>
		 			</Tr>
		 			
		 			</Table>
		 		</Td>
		 		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif" ></Td>
		 	</Tr>
		 	<Tr>
				<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
				<Td style="background-color:'F3F3F3'" valign=middle>
					<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
					<Tr>
						<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=center>
							&nbsp;&nbsp;<Br><Br><Br>
<%
							if(!"3".equals(userType))
							{
%>
								<Font color='RED' size=2><b><a href="javascript:getMatDocList('GE')">Gate Entry</a></b></Font><Br><Br>
<%
							}
%>
							<Font color='RED' size=2><b><a href="javascript:getMatDocList('AC')">Accepted</a></b></Font><Br><Br>
							<Font color='RED' size=2><b><a href="javascript:getMatDocList('RE')">Rejected</a></b></Font><Br><Br>
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
 		</table>
 	</td>
 	</tr>	
 </table>		
 </form>

 </div>
 <Div id="MenuSol">
 </Div>	
 </body>
</html>