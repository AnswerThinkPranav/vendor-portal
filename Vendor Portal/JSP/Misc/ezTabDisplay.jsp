<Table cellSpacing=0 cellPadding=0 border=0>
<Tr>
<%
	for(int i=1;i<=tabCount;i++)
	{
%>
		<Td width=5 class='blankcell'><IMG id="tab<%=i%>_3" height=27 src="../../../Offline/Images/Tabs/ImgLftUp.gif" width=5 border=0></Td>
		<Td id="tab<%=i%>_1" style="cursor:hand" style="background-image:url('../../../Offline/Images/Tabs/ImgCtrUp.gif')" onClick="showDiv('<%=i%>','<%=tabCount%>')"><font id='tab<%=i%>color'><b>&nbsp;&nbsp;&nbsp;&nbsp;<%=(String)tabHash.get("TAB"+i)%>&nbsp;&nbsp;&nbsp;</b></font></Td>
		<Td width=10 class='blankcell'><IMG id="tab<%=i%>_2" height=27 src="../../../Offline/Images/Tabs/ImgRgtUp.gif" width=10  border=0></Td>
<%
	}
	if("Y".equals((String)session.getValue("OFFLINE")))
	{
%>

	<Td width=100% class=blankcell align=right>
		<Table cellSpacing=0 cellPadding=0 border=0>
		<Tr>
		<Td width=5 class='blankcell'><IMG id="tab<%=tabCount+1%>_3" height=27 src="../../../Offline/Images/Tabs/ImgLftUp.gif" width=5 border=0></Td>
		<Td id="tab<%=tabCount+1%>_1" style="cursor:hand" style="background-image:url('../../../Offline/Images/Tabs/ImgCtrUp.gif')"><font id='tab<%=tabCount+1%>color'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;QCFs Pending For Approval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></font></Td>
		<Td width=10 class='blankcell'><IMG id="tab<%=tabCount+1%>_2" height=27 src="../../../Offline/Images/Tabs/ImgRgtUp.gif" width=10  border=0></Td>
		</Tr>
		</Table>
	</Td>
<%
	}
%>
</Tr>
</Table>
