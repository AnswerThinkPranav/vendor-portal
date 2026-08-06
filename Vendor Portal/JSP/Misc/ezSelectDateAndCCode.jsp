<Br>
	<Table border="1" align="center" valign=middle width="50%" cellpadding=0 cellspacing=0 class=welcomecell>
	<Tr>
		<Th <%=trBGColor%>>
			From Date&nbsp;&nbsp;
		</Th>
		<Td>
			<input type=text class=inputbox value="<%=fromDate%>"  id="FromDate" name="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
		</Td>
		<Th <%=trBGColor%>>
			&nbsp;&nbsp;&nbsp;&nbsp;To Date&nbsp;&nbsp;
		</Th>
		<Td>
			<input type=text class=inputbox value="<%=toDate%>" name="ToDate"  id="ToDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
		</Td>			
		<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='10%' align=right>
			<!--<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">-->
			<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
			
		</Td>
	</Tr>

	</Table>
<Br>
