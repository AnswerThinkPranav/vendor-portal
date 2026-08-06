<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %>
<Html>
<Head>
<Script>
function funGo()
{

	document.myForm.action="ezAddAddr.jsp";
	document.myForm.submit();
}
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Company Code";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	

<Table width=40% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0>
<Tr>
	 <%
			if(compCodeArr != null && compCodeArr.length > 1){
				selCompFlg =true;
	 %>
			<Tr>
			<Th  align="left" width="5%">Company Code</Th>
			<Td  align="left" width="5%">
			<select name="selCompCode" >  
	 <%
			String selectedFlg = "";
			if(selCompCode==null || "null".equals(selCompCode) || "".equals(selCompCode) )
				selCompCode = compCodeArr[0];
			for(int k=0;k<compCodeArr.length;k++){
			if(compCodeArr[k].equals(selCompCode))
				selectedFlg="selected";
	 %>
				<option value="<%=compCodeArr[k]%>" <%=selectedFlg%> ><%=compCodeDesc.get(compCodeArr[k])%></option>
	 <%
			selectedFlg="";
			}
	 %>
			</select>
			</Td>
			</Tr>
	 <%
			}
			else{
	 %>
			<input type="hidden" name="selCompCode" value="<%=selCompCode%>">
	 <%
			}
%>
</Tr>

</Table>
<br><br><br>
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("GO");
	buttonMethod.add("funGo()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>	
<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>