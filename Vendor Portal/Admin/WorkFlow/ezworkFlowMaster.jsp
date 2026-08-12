<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/iListLanguage.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/iAddRoleDefinition.jsp"%>
<%@ include file="../../../Includes/JSPs/Arms/ezViewDept.jsp"%>
<%@ include file="ezviewWorkFlow.jsp"%>

<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script src="../../Library/JavaScript/AdminVal.js"></script>
<script  src="../../Library/JavaScript/Arms/ezAddRoleDefinition.js"></script>

<% 
String dept1=request.getParameter("dept1");

%>    
</head>
<body>
<form name=myForm method=post action="">
<br>
	
    	<Table  border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width="80%">
      	<Tr>
        	<Th colspan="2" align="center">Please enter the following Work Flow information</Th>
      	</Tr>
	<Tr>
        	<Td class="labelcell" width="37%" align="right">Select Department*:</Td>
        	<td><select name="deptSel" style="width:100%" id="depSel"  onchange="myFunction()">
        	<option value="sel">---Select Department---</option>
        	
        	   
        <%   
        for(int i=0;i<retVendItemsCnt3;i++)
        {
        %>
      		<option value="<%=retVendItems3.getFieldValue(i,"VALUE1")%>" ><%=retVendItems3.getFieldValue(i,"VALUE1")%></option>
      	<%
      	}
      	%>
      		</select></td>
      	</Tr>
    	</Table>
	<br>
	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0 width=50%>
			    <Tr>
			      <Th width=50%" colspan="2">Add Work Flow</Th>
			    </Tr>
			    <Tr align="left">
			      <Th width="45%"style="text-align:center">Level</Th>
			      <Th width="55%"style="text-align:center">Name</Th>
			    </Tr>
		<%
		for(int m=0;m<5;m++)
		{
		%>
			    <Tr>
			 
	        		 <Td width="45%"style="text-align:center">
	        		 <input type=hidden name="levelVal_<%=m+1%>" value = "<%=m+1%>">
	        		 <%=m+1%>
	        		 </Td>
	        		 <Td width="45%"style="text-align:center">
	        	<select name="selName_<%=m+1%>" style="width:80%" id="selName_<%=m+1%>" onchange="myFunction2(<%=m+1%>)">
      				 <option value="sel2">---Select Name---</option>
      			<%
      			for(int k=0;k<retVendItemsCnt2;k++)
      			{
      			%>
      				<option value="<%=retVendItems2.getFieldValue(k,"EU_ID")%>"><%=retVendItems2.getFieldValue(k,"EU_ID")%></option>
      			<%
      			}
      			%>
      			</select>
      			</Td>
	        	
	       		  </Tr>
	       	<%
	       	}
	       	%>
	       	
	       		  
</Table>
<br>
	<center>
		<a href="javascript:void(0)"><img src="../../Images/Buttons/<%= ButtonDir%>/save.gif" border=none onClick="chckSave()" alt="Click here to Reset"></a>
		<a href="javascript:void(0)"><img src="../../Images/Buttons/<%= ButtonDir%>/reset.gif" border=none onClick="document.myForm.reset()" alt="Click here to Reset"></a>
	        <a href="JavaScript:history.go(-1)"><img src="../../Images/Buttons/<%= ButtonDir%>/back.gif" border=none alt="Click here to Back"></a>
	        <input type=hidden name="rowVal" value = "5">
	</center>
</form>
</body> 
</html>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
<script>  
var dept1="<%=dept1%>";
debugger;
if(dept1!="null")
{ 
document.getElementById("depSel").value="<%=dept1%>";
}
else
{
document.getElementById("depSel").value="sel";
}

var mapVal1="<%=workFlowUserMap.containsKey("1")%>"; 
if(mapVal1)
{
document.getElementById("selName_1").value="<%=workFlowUserMap.get("1")%>";
}

var mapVal2="<%=workFlowUserMap.containsKey("2")%>"; 
if(mapVal2)
{
document.getElementById("selName_2").value="<%=workFlowUserMap.get("2")%>";
}


var mapVal3="<%=workFlowUserMap.containsKey("3")%>"; 
if(mapVal3)
{
document.getElementById("selName_3").value="<%=workFlowUserMap.get("3")%>";
}


var mapVal4="<%=workFlowUserMap.containsKey("4")%>"; 
if(mapVal4)
{
document.getElementById("selName_4").value="<%=workFlowUserMap.get("4")%>";
}

var mapVal5="<%=workFlowUserMap.containsKey("5")%>"; 
if(mapVal5)
{
document.getElementById("selName_5").value="<%=workFlowUserMap.get("5")%>";
}


function myFunction()     
{
var x=document.getElementById("depSel").value;
document.myForm.action="ezworkFlowMaster.jsp?dept1="+x;
document.myForm.submit();		
}
		
function myFunction2(param)
{
var k=param;
var k1=document.getElementById("depSel").value;
if(k1!="sel")
{
if(k==1)
{
if(document.getElementById("selName_1").value==document.getElementById("selName_2").value || document.getElementById("selName_1").value==document.getElementById("selName_3").value || document.getElementById("selName_1").value==document.getElementById("selName_4").value || document.getElementById("selName_1").value==document.getElementById("selName_5").value)
{
alert(document.getElementById("selName_1").value+" "+" "+"Already Selected");
document.getElementById("selName_1").value="sel2";
}
}
if(k==2)
{
if(document.getElementById("selName_2").value==document.getElementById("selName_1").value || document.getElementById("selName_2").value==document.getElementById("selName_3").value || document.getElementById("selName_2").value==document.getElementById("selName_4").value || document.getElementById("selName_2").value==document.getElementById("selName_5").value)
{
alert(document.getElementById("selName_2").value+" "+" "+"Already Selected");
document.getElementById("selName_2").value="sel2";
}
}
if(k==3)
{
if(document.getElementById("selName_3").value==document.getElementById("selName_2").value || document.getElementById("selName_3").value==document.getElementById("selName_1").value || document.getElementById("selName_3").value==document.getElementById("selName_4").value || document.getElementById("selName_3").value==document.getElementById("selName_5").value)
{

alert(document.getElementById("selName_3").value+" "+" "+"Already Selected");
document.getElementById("selName_3").value="sel2";

}
}
if(k==4)
{
 if(document.getElementById("selName_4").value==document.getElementById("selName_2").value || document.getElementById("selName_4").value==document.getElementById("selName_3").value || document.getElementById("selName_4").value==document.getElementById("selName_1").value || document.getElementById("selName_4").value==document.getElementById("selName_5").value)
{

alert(document.getElementById("selName_4").value+" "+" "+"Already Selected");
document.getElementById("selName_4").value="sel2";

}
}
if(k==5)
{
if(document.getElementById("selName_5").value==document.getElementById("selName_2").value || document.getElementById("selName_5").value==document.getElementById("selName_3").value || document.getElementById("selName_5").value==document.getElementById("selName_4").value || document.getElementById("selName_5").value==document.getElementById("selName_1").value)
{

alert(document.getElementById("selName_5").value+" "+" "+"Already Selected");
document.getElementById("selName_5").value="sel2";
}
}
}
else
{
alert("Please Select the Department");
document.getElementById("selName_"+k).value="sel2";
}
}


function chckSave()
{
if(document.getElementById("depSel").value=="sel")
{
alert("Please Select Department");
return;
}
/*
else if(document.getElementById("selName_5").value=="sel2"||document.getElementById("selName_4").value=="sel2"||document.getElementById("selName_3").value=="sel2"||document.getElementById("selName_2").value=="sel2"||document.getElementById("selName_1").value=="sel2")
{
alert("Please Select The Name");
return;
}
else if(document.getElementById("selName_5").value==""||document.getElementById("selName_4").value==""||document.getElementById("selName_3").value==""||document.getElementById("selName_2").value==""||document.getElementById("selName_1").value=="")
{
alert("Please Select The Name");
return;
}*/
else
{
document.myForm.action="ezSaveWorkflow.jsp";
document.myForm.submit();
}

}
</script>