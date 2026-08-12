<%@include file="../../Library/Globals/errorPagePath.jsp"%>
<%@include file="../../../Includes/Lib/ezAddButtonDir.jsp" %>

<head>
    <script>
    </script>
</head>
    
<html>
    
   <body bgcolor='#FFFFFF'  onResize="scrollInit('SHOWTOT')"   scroll=no>
	<form method="post" name="MyForm" >
	
	<%
		String display_header = "";
	%>	
	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<Div id="ezClosedDates" style="position:absolute;width:100%">
		   <Table  align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
			<Tr>	
			 <Th>Select Material</Th>
			      <Td>
			      	<div id="ListBoxDiv2">
					<select name=mat>
					<option value=''>--Select Material --</option>
<%
						for(int i=0;i<retObjCount;++i)
						{
							String crfqNo=retObj.getFieldValueString(i,"COLLETIVE_RFQ_NO");
%>
				       			<option value='<%=crfqNo%>'><%=crfqNo%></option>
<%
						}
%>
					</select>
	  			</div>
      				</Td>	
      				<Td>
				       <img src="../../Images/Buttons/<%= ButtonDir%>/Go.gif" style="cursor:hand" onClick="validate('<%=status%>')" border="none">
				</Td>
		</tr>
	</Table>	
</form>
<Div id="MenuSol"></Div>
</body> 
</html>			