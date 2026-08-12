<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/iListLanguage.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/iAddRoleDefinition.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/ezViewDept.jsp"%>

<html>
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script src="../../Library/JavaScript/AdminVal.js"></script>
<script  src="../../Library/JavaScript/Arms/ezAddRoleDefinition.js"></script>
<Script>

</Script> 
</head> 
<body>
<form name=myForm method=post action="ezSaveDepartment.jsp">
<br>
	<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
  		<Tr align="center">
    			<Td class="displayheader">Add Department</Td>
  		</Tr>
	</Table>
    	<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
      	<Tr>
        	<Th colspan="2" align="center">Please enter the following Department information</Th>
      	</Tr>
	<Tr>
        	<Td class="labelcell" width="37%" align="right">Department Code *:</Td>
        	<Td width="63%"><input type=text class = "InputBox" name="deptCode" maxlength="16"></Td>
      	</Tr>
      	<Tr>
        	<Td class="labelcell" width="37%" align="right"> Description*:</Td>
        	<Td width="63%"><input type=text class = "InputBox" name="deptDesc" maxlength=30></Td>
      	</Tr>
    	</Table>
	<br>
	<center>
		<input type="image" src="../../Images/Buttons/<%= ButtonDir%>/save.gif" alt="Click here to Save" >
		<a href="javascript:void(0)"><img src="../../Images/Buttons/<%= ButtonDir%>/reset.gif" border=none onClick="document.myForm.reset()" alt="Click here to Reset"></a>
	        <a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none alt="Click here to Back"></a>
	        <input type=hidden name="buscomponent" value = "ROLE">
	</center>
	<br>
	
	    	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width=50%>
		    <Tr>
		      <Th width=50%" colspan="2">Derpartment List</Th>
		    </Tr>
		    <Tr align="left">
		      <Th width="45%"style="text-align:center"> Department Name</Th>
		      <Th width="55%"style="text-align:center"> Description </Th>
		    </Tr>
		    <Tr>
		 <%
		 for(int i=0;i<retVendItemsCnt3;i++)
		 {
		 %>
        		 <Td width="45%"style="text-align:center"><%=retVendItems3.getFieldValue(i,"VALUE1")%></Td>
        		 <Td width="45%"style="text-align:center"><%=retVendItems3.getFieldValue(i,"VALUE2")%></Td>
        	
       		  </Tr>
       		  <%
		          	}
        	%>
</Table>
</form>
</body>
</html>
