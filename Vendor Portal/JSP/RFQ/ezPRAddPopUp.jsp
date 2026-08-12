<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%
String PRNums=request.getParameter("purReqNum");
%>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<Script>
function addprId()
{
	var len=document.myForm.prId.length;
	if(isNaN(len))
	{
		if(document.myForm.prId.value=="")
		{
			alert("Please inter information in the existing line");
			document.myForm.prId.focus();
			return;
		}
	}
	else
	{
		for(i=0;i<len;i++)
		{
			if(document.myForm.prId[i].value=="")	
			{
				alert("Please enter information in the existing lines");
				document.myForm.prId[i].focus();
				return;

			}
		}
	
	}
	var tabObj=document.getElementById("InnerBox1Tab")
	var rowItems = tabObj.getElementsByTagName("Tr");
	var rowCountValue = rowItems.length;

	var rowId = tabObj.insertRow(rowCountValue);


	elementsArray=new Array();

	elementsArray[0]="<input type='text'  class='inputbox' name='prId' >"
	eleWidth = new Array();
	eleAlign = new Array();
	eleWidth[0]  = "50%";
	eleAlign[0] = "";
		
	len=elementsArray.length
	for (i=0;i<len;i++)
	{
		cell0Data = elementsArray[i]
		cell0=rowId.insertCell(i);
		cell0.innerHTML=cell0Data;
		cell0.align=eleAlign[i];
		cell0.width= eleWidth[i];
	}




}

function funWindowClose()
{  
	var len=document.myForm.prId.length;
	var PRValue="";
		
	for(i=0;i<len;i++)
	{
		if(funTrim(document.myForm.prId[i].value)!="")	
		{
			if(isNaN(document.myForm.prId[i].value))
			{
			alert("Please Enter Vaild PR Number");
			document.myForm.prId[i].focus();
			document.myForm.prId[i].value="";
			return false;
			}
			if(i==0)
			PRValue=document.myForm.prId[i].value;
			else
			PRValue=PRValue + "¥" + document.myForm.prId[i].value;
		}
	}
	
	parent.opener.document.myForm.purReqNum.value=PRValue;
		
	window.close();
}

</Script>

</Script>  

</head>
<body scroll=yes>
<form name="myForm">
<TABLE id='InnerBox1Tab' align='center'  width="40%"  border=0>
	<TR >
		<th  align='center'  >PR Number</th>
		
				
	</TR>
<%
	if(PRNums!=null && !"null".equals(PRNums.trim()) && !"".equals(PRNums.trim()))
	{
		
		StringTokenizer st = new StringTokenizer(PRNums,"¥");
		
		while(st.hasMoreTokens())
		{
%>
		<TR>
			<td ><input type='text' class='inputbox' name="prId" value="<%=st.nextToken()%>"></td>

		</TR>
<%
		}
	}
	else
	{
		for(int i=0; i<5;i++)
		{
%>
		<TR>
			<td ><input type='text' class='inputbox' name="prId"></td>

		</TR>
<%

		}
	}
%>
	
	
 
</Table>
<div id="ButtonDiv" align=center style="position:absolute;top:87%;width:100%" visibility:visible">
<center>
<%		
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

		
	buttonName.add("Ok");
	buttonMethod.add("funWindowClose()");
	
	buttonName.add("Add Row");
	buttonMethod.add("addprId()");

	out.println(getButtonStr(buttonName,buttonMethod));

%>			
</center>
</div>
</form>
</body>
</html>