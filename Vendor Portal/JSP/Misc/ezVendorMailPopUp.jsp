<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session">
</jsp:useBean>
<%
String venMailAndSeqNum = request.getParameter("venMailAndSeqNumber");%>
<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<Script>
function funWindowClose()
{
	
	var emailObj 		= document.myForm.mailId;
	var seqNumObj 		= document.myForm.seqNum;
	var len			= emailObj.length;
	var mailSeqNumValue	= "";
	if(isNaN(len))
	{
		
		if(funTrim(emailObj.value)=="")
		{
			alert("Please Enter Information in the existing line")
			document.myForm.mailId.focus();
			return;
		}
		if(seqNumObj.value!="")
		mailSeqNumValue = emailObj.value+"¥"+seqNumObj.value
		
	}
	else
	{
		for(i=0;i<len;i++)
		{
			if(funTrim(emailObj[i].value)=="" && funTrim(seqNumObj[i].value)!="")
			{
				alert("Please Enter Information in the existing line")
				document.myForm.mailId[i].focus();
				return;
			}
			
			
			if(funTrim(emailObj[i].value)!="" )
			{
				if(i==0)
				mailSeqNumValue = emailObj[i].value+"¥"+seqNumObj[i].value;
				else
				mailSeqNumValue = (emailObj[i].value+"¥"+seqNumObj[i].value)+","+mailSeqNumValue
			}
		}
	}
	
	//alert(mailSeqNumValue)
	parent.opener.document.myForm.email.value=mailSeqNumValue;
	
	window.close();
}
function addMailID()
{
	var len=document.myForm.mailId.length;
	if(isNaN(len))
	{
		if(document.myForm.mailId.value=="")
		{
			alert("Please Enter Information in the existing line");
			document.myForm.mailId.focus();
			return;
		}
	}
	else
	{
		for(i=0;i<len;i++)
		{
			if(document.myForm.mailId[i].value=="")	
			{
				alert("Please Enter Information in the existing lines");
				document.myForm.mailId[i].focus();
				return;

			}
		}
	
	}
	var tabObj=document.getElementById("InnerBox1Tab")
	var rowItems = tabObj.getElementsByTagName("Tr");
	var rowCountValue = rowItems.length;

	var rowId = tabObj.insertRow(rowCountValue);


	elementsArray=new Array();

	elementsArray[0]="<input type='text' Size='60' class='InputBox' Maxlength='50' name='mailId' >"
	elementsArray[1]="<input type='hidden' name='seqNum' value=' '>"
	eleWidth = new Array();
	eleAlign = new Array();
	eleWidth[0]  = "50%";	eleAlign[0] = "";
	eleWidth[1]  = "50%";	eleAlign[1] = "";
	
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


</Script>
</head>
<body scroll=yes>
<form name="myForm">
	<TABLE id='InnerBox1Tab' align=center cellSpacing=0 cellPadding=0 width="100%"  border=0>
	<TR>
		<th>Email Id</th>
		<td><input type=button name=addID value='+' onclick='addMailID()'></td>
				
	</TR>
	
<%	

if(venMailAndSeqNum!=null)
{
	String HTValue = (String)venMailAndSeqNum;
	
	String splitArray[] = HTValue.split(",");

	for(int i=0;i<splitArray.length;i++)
	{
	
%>
		<Tr>
		<td>
		<input type="text" Size="60" class="InputBox" Maxlength="50" name="mailId" value="<%=splitArray[i].split("¥")[0]%>" ></td>
		
		<input type="hidden" name="seqNum" value="<%=splitArray[i].split("¥")[1]%>" >
		</td>
		</Tr>
<%
	}

}else{
%>
		<Tr>
		<td>
		<input type="text" Size="40" class="InputBox" Maxlength="50" name="mailId" value="" >
		<input type="hidden" name="seqNum" value="" >
		</td>
		</Tr>
<%		
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

	out.println(getButtonStr(buttonName,buttonMethod));

%>			
</center>
</div>
</form>
</body>
</html>