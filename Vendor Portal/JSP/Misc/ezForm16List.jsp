<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%
String display_header = "List of Form16"; 
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iForm16List.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

<html>
<head>
<Script>
	var tabHeadWidth=70
	var tabHeight="50%"
	
function funClick()
{
	document.myForm.action="ezForm16List.jsp";
	document.myForm.submit();
}

</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>

</head>

<body onLoad = "scrollInit()" onResize="scrollInit()" scroll=no>
<form name="myForm">

<div style="position:absolute;top:10%;align:center;left:15%;width:70%">
	<table width="100%" align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
		<tr>
			<th width="15%">Assessment Year</th>
			<td width="30%">
				<select name="sYear" style="width:100%">
				<!--<option value="2011" >2011-12</option>-->
				<option value="2012" >2012-13</option>
				<%
					for(int i=2012;i<cYear+1;i++)
					{
					String nextYear  = i+2+"";
					
				%>
						<option value="<%=(i+1)%>"><%=(i+1)%>-<%=nextYear.substring((nextYear.length()-2),nextYear.length())%></option>
				<%
					}
				%>
				</select>
			</td>
			<th width="15%">Quarter</th>
			<td width="30%">
				<select name="sQtr" style="width:100%">
				<option value="Q1">Q1</option>
				<option value="Q2">Q2</option>
				<option value="Q3">Q3</option>
				<option value="Q4">Q4</option>
				</select>
			</td>
			<!--<Td style='font-size=11px;color:#00355D;font-weight:bold;align:center' width='10%' align=right>
				<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" onClick="funClick()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
			</Td>-->
			<Td onClick="funClick()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
				<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="funClick()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
			</Td>
		</tr>
	</table>
</div>
<br>
<br>
<%
if(venForm16DocsCnt>0)
{
%>
	<div id="theads" >
	<Table id="tabHead" width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
		<Tr>
			<th width="20%" align="center">Section</th>
			<th width="80%" align="center">File Name</th>
		</Tr>
	</table>
	</div>

	<div id="InnerBox1Div" STYLE='overflow:auto;Position:Absolute;width:70%;Left=15%;height:50%' align="center">
	<table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%
	for(int i=0;i<venForm16DocsCnt;i++)
	{
		String venDataStr	=	(String)venForm16Docs.get(i); 
		String venFileName	=	venDataStr.split("¥")[0];
		String venSections	=	venDataStr.split("¥")[1];
%>
		<tr>
		<td width="20%" align="center"><%=venSections%></td>
		<td width="80%" ><a href="ezFormDownload.jsp?year=<%=sYear%>&quarter=<%=sQtr%>&section=<%=venSections%>&filename=<%=venFileName%>" title="click here to download form"><%=venFileName%></a></td>
		</tr>
<%
	}
%>
	</table>
	</div>
<%	
}
else
{

%>
<Div id='NoDataDiv' style='position:relative;align:center;top:20%;left:15%;width:70%;height:100%'>
<Table width="100%" height="20%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
<Tr>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
</Tr>
<Tr height=100px>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'F3F3F3';font-size:12px" valign=middle align=center>
		<b>No records to list.</b>
	</Td>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
	<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
</Tr>
</Table>
</Div>

<%
}
%>
</form>
<script>
document.myForm.sYear.value="<%=sYear%>"
document.myForm.sQtr.value="<%=sQtr%>"
</script>
<Div id="MenuSol"></Div>
</body>
</html>