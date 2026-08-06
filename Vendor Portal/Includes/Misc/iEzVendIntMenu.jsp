<%
	if("SO".equals(userRole))
	{
%>
		<div id="ezDiv1"  onMouseOver="ezMouseOver1('ezDiv1',3);" onMouseOut="ezMouseOut1('ezDiv1')" style="Position:absolute;top:0;left:3%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Shipment/ezViewShimentList.jsp?orderBase=po" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>VIEW ASN</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv2"  onMouseOver="ezMouseOver1('ezDiv2',20);" onMouseOut="ezMouseOut1('ezDiv2')" style="Position:absolute;top:0;left:20%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>RETURNABLE ITEMS</a>
			</td>
		</Tr>
		</Table> 
		</div>

		<div id="ezDiv3"  onMouseOver="ezMouseOver1('ezDiv3',43);" onMouseOut="ezMouseOut1('ezDiv3')" style="Position:absolute;top:0;left:43%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezMaterialDocsInput.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>GOODS RECEIPTS</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv4"  onMouseOver="ezMouseOver1('ezDiv4',63);" onMouseOut="ezMouseOut1('ezDiv4')" style="Position:absolute;top:0;left:63%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>INVOICES</a>
			</td>
		</Tr>
		</Table>
		</div>
		
		<div id="ezDiv5"  onMouseOver="ezMouseOver1('ezDiv5',85);" onMouseOut="ezMouseOut1('ezDiv5')" style="Position:absolute;top:0;left:80%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezPassword.jsp?fromMenu=Y" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>CHANGE PASSWORD</a>
			</td>
		</Tr>
		</Table>
		</div>
<%
	} 
	else if("QA".equals(userRole))
	{
%>

		<div id="ezDiv1"  onMouseOver="ezMouseOver1('ezDiv1',3);" onMouseOut="ezMouseOut1('ezDiv1')" style="Position:absolute;top:0;left:3%;width:15%">
			<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
			<Tr>
				<Td class=menutext align="center" height = 22  valign="center">
				<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Shipment/ezViewShimentList.jsp?orderBase=po" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
				<Font color='WHITE' size=2><B>VIEW ASN</a>
				</td>
			</Tr>
			</Table>
		</div>
		
		<div id="ezDiv2"  onMouseOver="ezMouseOver1('ezDiv2',24);" onMouseOut="ezMouseOut1('ezDiv2')" style="Position:absolute;top:0;left:24%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezMaterialDocsInput.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>GOODS RECEIPTS</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv3"  onMouseOver="ezMouseOver1('ezDiv3',52);" onMouseOut="ezMouseOut1('ezDiv3')" style="Position:absolute;top:0;left:52%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>QA AUDIT</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv4"  onMouseOver="ezMouseOver1('ezDiv4',80);" onMouseOut="ezMouseOut1('ezDiv4')" style="Position:absolute;top:0;left:80%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezPassword.jsp?fromMenu=Y" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>CHANGE PASSWORD</a>
			</td>
		</Tr>
		</Table>
		</div>
<%
	}
	else if("FN".equals(userRole))
	{
%>
		<div id="ezDiv1"  onMouseOver="ezMouseOver1('ezDiv1',3);" onMouseOut="ezMouseOut1('ezDiv1')" style="Position:absolute;top:0;left:3%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezMaterialDocsInput.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>GOODS RECEIPTS</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv2"  onMouseOver="ezMouseOver1('ezDiv2',24);" onMouseOut="ezMouseOut1('ezDiv2')" style="Position:absolute;top:0;left:24%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>INVOICES</a>
			</td>
		</Tr>
		</Table> 
		</div>

		<div id="ezDiv3"  onMouseOver="ezMouseOver1('ezDiv3',52);" onMouseOut="ezMouseOut1('ezDiv3')" style="Position:absolute;top:0;left:52%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>VENDOR SELF SERVICE</a>
			</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv5"  onMouseOver="ezMouseOver1('ezDiv5',85);" onMouseOut="ezMouseOut1('ezDiv5')" style="Position:absolute;top:0;left:80%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
			<Td class=menutext align="center" height = 22  valign="center">
			<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezPassword.jsp?fromMenu=Y" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>CHANGE PASSWORD</a>
			</td>
		</Tr>
		</Table>
		</div>
<%
	}
	else
	{
%>
		<div id="ezDiv1" onMouseOver="ezMouseOver1('ezDiv1',3);" onMouseOut="ezMouseOut1('ezDiv1')" style="Position:absolute;top:0;left:3%;width:8%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center">

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>RFQ
		</a>

		</td>
		</Tr>
		</Table>
		</div>
		<div id="ezDiv2" onMouseOver="ezMouseOver1('ezDiv2',12);" onMouseOut="ezMouseOut1('ezDiv2')" style="Position:absolute;top:0;left:12%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center">

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>PURCHASE ORDERS
		</a>

		</td>
		</Tr>
		</Table>
		</div>
		<div id="ezDiv3" onMouseOver="ezMouseOver1('ezDiv3',28);" onMouseOut="ezMouseOut1('ezDiv3')" style="Position:absolute;top:0;left:24%;width:15%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center">

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>CONTRACTS
		</a>

		</td>
		</Tr>
		</Table>
		</div>
		<div id="ezDiv4" onMouseOver="ezMouseOver1('ezDiv4',39);" onMouseOut="ezMouseOut1('ezDiv4')" style="Position:absolute;top:0;left:39%;width:11%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center" nowrap>

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
		<Font color='WHITE' size=2><B>SCHD AGRMTS
		</a>

		</td>
		</Tr>
		</Table>
		</div>
		<div id="ezDiv5"  onMouseOver="ezMouseOver1('ezDiv5',50);" onMouseOut="ezMouseOut1('ezDiv5')" style="Position:absolute;top:0;left:50%;width:11%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center" nowrap>

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
		<Font color='WHITE' size=2><B>SHIPMENTS
		</a>

		</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv6"  onMouseOver="ezMouseOver1('ezDiv6',61);" onMouseOut="ezMouseOut1('ezDiv6')" style="Position:absolute;top:0;left:61%;width:11%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td class=menutext align="center" height = 22  valign="center">
		<a style="text-decoration:none; color:#ffffff;" class=subclass href="../Misc/ezSBUWelcome.jsp" target='display' onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
		<Font color='WHITE' size=2><B>INVOICES</a>

		</td>
		</Tr>
		</Table>
		</div>

		<div id="ezDiv7"  onMouseOver="ezMouseOver1('ezDiv7',72);" onMouseOut="ezMouseOut1('ezDiv7')" style="Position:absolute;top:0;left:72%;width:11%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center">

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
		<Font color='WHITE' size=2><B>SELF SERVICE
		</a>
		</td>
		</tr>
		</Table>
		</div>
		<div id="ezDiv8" onMouseOver="ezMouseOver1('ezDiv8',83);" onMouseOut="ezMouseOut1('ezDiv8')" style="Position:absolute;top:0;left:83%;width:11%">
		<TABLE width="100%" align=right  cellPadding=2 cellSpacing=0 >
		<Tr>
		<Td  class=menutext align="center" height = 22  valign="center">

		<a  style="text-decoration:none; color:#ffffff;"  class=subclass href="../Misc/ezSBUWelcome.jsp" target='display'  onMouseover="window.status=' '; return true" onMouseout="window.status=' '; return true">
			<Font color='WHITE' size=2><B>OPTIONS
		</a>

		</td>
		</Tr>
		</Table>
		</div>
<%
	}
%>