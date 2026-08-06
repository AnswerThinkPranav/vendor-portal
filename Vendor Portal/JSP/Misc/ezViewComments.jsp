<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Html>
<Head>
<Script>
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Comments";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<br>
	<Br>
	<Table width="80%" height="5%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<TR>
	<Th>Quater</Th>
	<Td><%=request.getParameter("qtr")%></Td>
	<Th>Year</Th>
	<Td><%=request.getParameter("yr")%></Td>
	</Tr>
	</Table>
	<br>
	<Div id='inputDiv'>
	<Table width="80%" height="30%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'#F3F3F3'" valign=middle align=right>
			<Div id='inputDiv'>
			<Table width="100%" height="100%" border="1" cellspacing="0" cellpadding="10" align=center valign=center>
			<Tr>
				<Td wrap width="2%" style='background:#F3F3F3' valign=top>
				<%=request.getParameter("comm")%>
				</Td>
			</Tr>	
			</Table>
			</Div>
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
	
	<Div id="ButtonDiv"  style="position:absolute;left:0%;width:100%;top:90%">
	<center>
	<%
	
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Close");
		buttonMethod.add("window.close()");
		out.println(getButtonStr(buttonName,buttonMethod));
	%>
	</center>
</Div>

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>