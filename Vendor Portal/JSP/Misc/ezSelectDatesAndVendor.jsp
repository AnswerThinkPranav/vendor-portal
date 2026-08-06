 <%//@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
 <%@ page import="java.util.*" %>
 <jsp:useBean id="ezAuditFindingManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
 <%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
 <%
 	String flagStatus = request.getParameter("flagStatus");
	String userType   = (String)session.getValue("UserType");
 	
 	String vendCode = request.getParameter("vendCode");	
 	String sysKey = (String) session.getValue("SYSKEY");
 	
 	Hashtable vendorsHT = new Hashtable(); 
 	Vector confirmedVend = new Vector(); 
 
 	int vendorsRetObjCnt = 0;
 	ezc.ezparam.ReturnObjFromRetrieve vendorsRetObj = null;
 	
 	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
 	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
 	ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();
 
 	try
 	{
 		keyParams.setKey("GET_VENDORS");
 		addMainParams.setLocalStore("Y");
 
 		vendParams.setSyskey(sysKey);
 		vendParams.setGroup("");
 		
 		addMainParams.setObject(keyParams);	
 		addMainParams.setObject(vendParams);
 		Session.prepareParams(addMainParams);
 
 		vendorsRetObj=(ReturnObjFromRetrieve)ezAuditFindingManager.ezGetVendorTransactions(addMainParams);
 		
 		if(vendorsRetObj!=null && vendorsRetObj.getRowCount()>0)
 		{
 			vendorsRetObjCnt = vendorsRetObj.getRowCount();
 			
 			//for(int v=0;v<vendorsRetObjCnt;v++)
 				//vendorsHT.put(vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO").trim(), vendorsRetObj.getFieldValueString(v,"ECA_NAME"));
 			
 		}	
 	}
 	catch(Exception e){
 		out.println(":::EEEE:::"+e);
 	}
 
 	//out.println(confirmedVend);
 	//out.println(vendorsHT);
%>	
 <html>   
 <head>  
 <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
 <%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
 <script> 	
 	function funSubmit(flgStat)
 	{
 		
 		//var radioLen = document.myForm.reportStatus.length;
 		//for(i=0;i<radioLen;i++)
 		//{
 			
 				url = document.myForm.reportStatus
 		//}
 		
 		if( flgStat=='DISPATCH')
 			document.myForm.action = "../ReturnableItems/ezListReturnables.jsp?flagStatus="+flgStat;
 		
 		else if(flgStat=='RETURN')
 			document.myForm.action = "../ReturnableItems/ezListMTRReturnables.jsp?flagStatus="+flgStat;

 		else if (flgStat=='AUDIT_FINDINGS')
 			document.myForm.action = "../Misc/ezListAudit.jsp";
 		
		else if(flgStat=='REPORT')
		{
			if(document.myForm.reportStatus[0].checked)
				document.myForm.action = "../ReturnableItems/ezDispatchReport.jsp";
			else if(document.myForm.reportStatus[1].checked)
				document.myForm.action = "../ReturnableItems/ezReturnReport.jsp";
		}
 			
 			
 		document.myForm.submit();
 	}
 	function addReturnables()
 	{
 		document.myForm.action = "../ReturnableItems/ezAddRetrnQty_MTR.jsp";
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
 	String display_header = "Selection Parameters";
 	
 	if("RETURN".equals(flagStatus)) display_header = "Returned Items List";
 	else if ("DISPATCH".equals(flagStatus)) display_header = "Dispatched Items List";
 
	String fromDate = request.getParameter("FromDate"); 
	String toDate   = request.getParameter("ToDate");     
	int dateRange = 30;        
%>  
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%> 
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
		 				<Td  height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
		 					<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
		 				</Td>
		 			</Tr>
		 			<Tr>
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
							To Date&nbsp;&nbsp;
		 				</Td>
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
							<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
		 				</Td>
		 			</Tr>
		 			<%if("2".equals(userType))
		 			{
		 			%>
		 			<Tr>
						<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
							Vendor&nbsp;&nbsp;
		 				</Td>
		 				<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
						<Select name='vendorCode'>
							<Option value=''>--Select Vendor--</Option>
<%
							for(int v=0;v<vendorsRetObjCnt;v++)
							{
%>
								<Option value='<%=vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO").trim()%>'><%=vendorsRetObj.getFieldValueString(v,"ECA_NAME")+"["+vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO")+"]"%></Option>
<%
							}
%>
						</Select>
		 				</Td>
					</Tr>
					
					
					
					<%}%>
					<%
						if("DISPATCH".equals(flagStatus))
						{
						%>
							<tr>
							<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
							
							&nbsp;Select Status&nbsp;</td>
							<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
							<input type=radio name="returnablesStatus" value="SUBMITTED" checked>Vendor Dispatched<br>
							<input type=radio name="returnablesStatus" value="UPDATED">MTR Received<br>
							<input type=radio name="returnablesStatus" value="ACKNOWLEDGED">Vendor Acknowledged<br>
							</td>
							</tr>

						<%
						}
						else if("RETURN".equals(flagStatus))
						{
						%>
							<tr>
							<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>

							&nbsp;Select Status&nbsp;</td>
							<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
							<input type=radio name="returnablesStatus" value="SUBMITTED" checked>MTR returned<br>
							<input type=radio name="returnablesStatus" value="UPDATED">Vendor Received<br>
							<input type=radio name="returnablesStatus" value="ACKNOWLEDGED">MTR Acknowledged
							</td>
							</tr>
							<%
							if("2".equals(userType))
							{
							%>
								<br><tr><Td height="40"  colspan =2 align=center style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
								<a href="JavaScript:addReturnables()"  onMouseover="window.status='Click to add returnable item Details '; return true" onMouseout="window.status=' '; return true">
								Add Return Quantity (New)</a></td></tr>
							

						<%
							}
						}
						else if ("REPORT".equals(flagStatus))
						{
						
						%>
							<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=right>
							
								&nbsp;Select Report&nbsp;</td>
								<Td height="40" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' valign=center>
								<input type=radio name="reportStatus" value="DISPREP" checked>Vendor Dispatched<br>
								<input type=radio name="reportStatus" value="RETREP">MTR Returned
								</td>
							</tr>
						
						<%
						}
					%>
					<Tr>
						<Td height="40" colspan=2 style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='50%' align=center>
<%
							buttonName = new java.util.ArrayList();
							buttonMethod = new java.util.ArrayList();

							buttonName.add("Go");
							
							if("RETURN".equals(flagStatus))
								buttonMethod.add("funSubmit(\"RETURN\")");
							else if ("DISPATCH".equals(flagStatus))
								buttonMethod.add("funSubmit(\"DISPATCH\")");
							else if ("AUDIT_FINDINGS".equals(flagStatus))
								buttonMethod.add("funSubmit(\"AUDIT_FINDINGS\")");
							else if ("REPORT".equals(flagStatus))
								buttonMethod.add("funSubmit(\"REPORT\")");
								
							out.println(getButtonStr(buttonName,buttonMethod));
%>
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