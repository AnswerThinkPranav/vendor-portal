
<%
	String index		 = request.getParameter("index");
	String name		 = request.getParameter("name"+index)==null?"":request.getParameter("name"+index);;
	String address		 = request.getParameter("address"+index);
	String location		 = request.getParameter("location"+index);
	String eccnumber	 = request.getParameter("eccnumber"+index);
	String tinno		 = request.getParameter("tinno"+index);
	String Category		 = request.getParameter("category"+index);
	String phone		 = request.getParameter("phone"+index);
	String cst		 = request.getParameter("cst"+index);
	String code 		 = request.getParameter("code"+index);
	String fax		 = request.getParameter("fax"+index);
	
	String exciseRegNo	 = request.getParameter("exciseRegNo"+index);
	String exciseRange	 = request.getParameter("exciseRange"+index);
	String exciseDivision	 = request.getParameter("exciseDivision"+index);
	String exciseComm	 = request.getParameter("exciseComm"+index);
	String cstNum		 = request.getParameter("cstNum"+index);
	String lstNum		 = request.getParameter("lstNum"+index);
	String permanentAccNum	 = request.getParameter("permanentAccNum"+index);
	String serviceTaxRegNum	 = request.getParameter("serviceTaxRegNum"+index);
	
	
	
%>
<%@ include file="../../../Includes/Lib/ezCountries.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iListSbuPlantAddresses_Lables.jsp"%>
<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
	<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
	<SCRIPT SRC="../../../Service1/Library/JavaScript/checkFormFields.js"></script>
	<script>
		function savePrice()
		{

			document.myForm.action="ezEditSaveSbuPlantAddress.jsp"
			document.myForm.submit();
		}
		function back()
		{

			document.myForm.action="ezListSbuPlantAddresses.jsp"
			document.myForm.submit();
		}
		
	</script>
</head>
<body onLoad="document.myForm.name.focus()">
<form name=myForm method=post>

<%
	String display_header = editPlntAdd_L;
%>	

	<%@ include file="ezDisplayHeader.jsp"%>

	<br>
	<Table align=center border=1 width=80% borderColorLight=#006666 bordercolordark=#ffffff cellpadding=2 cellspacing=0>
	<Tr width="20%">
		<Th width="20%" align="left" ><%=name_L%></Th>
		<Td width="30%" ><input type="text" name=name value="<%=name%>" style="width:100%" class="InputBox"></Td>
		
		<Th width="20%" align="left" >Category</Th>
		<Td width="30%" ><input type="text" name=category value="<%=Category%>" style="width:100%" class="InputBox"></Td>
	</Tr>
	<Tr>
		<Th width="20%" align="left" >Address</Th>
		<Td width="80%" colspan=3><input type=text name=address size=150 value="<%=address%>" class="InputBox"></Td>		
	</Tr>
	<Tr >	
		<Th width="20%" align="left" >Ecc No</Th>
		<Td width="30%"><input type=text name=eccnumber  size=50 value="<%=eccnumber%>" class="InputBox"></Td>

		<Th width="20%" align="left" >Tin No</th>
		<Td width="30%"><input type=text name=tinno  size=50 value="<%=tinno%>" class="InputBox"></Td>
	</Tr>
	<Tr>
		<Th width="20%" align="left" >Location</Th>
		<Td width="30%"><input type=text name=location size=50 value="<%=location%>" class="InputBox"></Td>
	
		<Th width="20%" align="left" ><%=cst_L%></Th>
		<Td width="30%"><input type=text name=cst size=50 value="<%=cst%>" class="InputBox"></Td>
	</Tr>
	<Tr>
		<Th width="20%" align="left" ><%=phone_L%></Th>
		<Td width="30%"><input type=text name=phone size=50 value="<%=phone%>" class="InputBox"></Td>
		
		<Th width="20%" align="left" >Fax</Th>
		<Td width="30%"><input type=text name=fax size=50 value="<%=fax%>" class="InputBox"></Td> 
	</Tr>
	
	
	<Tr>
		<Th align="left" width="20%">Excise Registration No</Th>
		<Td width="30%"><input type=text name="exciseRegNo" style="width:100%" value="<%=exciseRegNo%>" class="InputBox"></Td>

		<Th align="left" width="20%">Excise Range</Th>
		<Td width="30%"><input type=text name="exciseRange" style="width:100%" value="<%=exciseRange%>" class="InputBox"></Td>

	</Tr>


	<Tr>
		<Th align="left" width="20%">Excise Division</Th>
		<Td width="30%"><input type=text name="exciseDivision" style="width:100%" value="<%=exciseDivision%>" class="InputBox"></Td>

		<Th align="left" width="20%">Excise Commissionerate</Th>
		<Td width="30%"><input type=text name="exciseComm" style="width:100%" value="<%=exciseComm%>" class="InputBox"></Td>

	</Tr>	


	<Tr>
		<Th align="left" width="20%">CST Number</Th>
		<Td width="30%"><input type=text name="cstNum" style="width:100%" value="<%=cstNum%>" class="InputBox"></Td>

		<Th align="left" width="20%">LST Number</Th>
		<Td width="30%"><input type=text name="lstNum" style="width:100%" value="<%=lstNum%>" class="InputBox"></Td>

	</Tr>


	<Tr>
		<Th align="left" width="20%">Permanent Account Number</Th>
		<Td width="30%"><input type=text name="permanentAccNum" style="width:100%" value="<%=permanentAccNum%>" class="InputBox"></Td>

		<Th align="left" width="20%">Service Tax Registration Number</Th>
		<Td width="30%"><input type=text name="serviceTaxRegNum" style="width:100%" value="<%=serviceTaxRegNum%>" class="InputBox"></Td>
			
	</Tr>
	
	
	
	
	</Table>
	
	<Div id="ButtonDiv" align=center style="position:absolute;top:85%;visibility:visible;width:100%">
		<Table align="center">
		<tr align="center">
		<td class=blankcell align="center">
		<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			
			buttonName.add("Back");
			buttonMethod.add("back()");
			buttonName.add("Save");
			buttonMethod.add("savePrice()");
			out.println(getButtonStr(buttonName,buttonMethod));	
		%>
		</Td>
		</Tr>
		</Table>
	</div>

<input type="hidden" name="code" value="<%=code%>" >
<input type="hidden" name="index" value="<%=index%>">
<Div id="MenuSol">
</Div>
</form>
</body>
</html>

