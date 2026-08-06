<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<% 
	
	String vendorCode = (String)session.getValue("SOLDTO");
	String vendorName = (String)session.getValue("Vendor");
	String display_header = "New Vendor Registration Form";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Html>
<Head>

<Script type="text/javascript">
function funSubmit()
{
	document.myForm.action="ezSaveNewVendorDetails.jsp";
	document.myForm.submit();
}
</Script>
</Head>
<Body>
<form name = "myForm" method="post">
<input type="hidden" name="vendorCode" value="<%=vendorCode%>" >
<br><br><br>
<div style="position:absolute;top:15%;left:0%;width:100%;">
	<Table width="80%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<Tr>
		   <Th><input type="button" name="attachfile" onClick="window.open('../Inbox/ezAttachFileVendor.jsp?vendorCode=<%=vendorCode%>','popuppage','left=510,top=180,width=450,height=360,statusbar=yes');" value="Attach New Vendor"></Th>
		   <Td colspan=3>
		   <Select name='attachs' multiple=4 style="width:800px"></Select></td>
               </Tr>
               <Tr>
               	<Th colspan=2 align=center>Comments</Th>
               	<Td colspan=2><textarea rows=4 cols=100 name="comments"></textarea></Td>
               </Tr>
	</Table>
	<br>
	<Center>	
<%	
		buttonName.add("Submit");	
		buttonMethod.add("funSubmit()");  
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	<Center>
</Div>
<Div id="MenuSol"></Div>
</Form>
</Body>
</Html>
              
              