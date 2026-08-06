<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@include file="../../../Includes/JSPs/Misc/iRejectToUser.jsp"%>
<%@include file="../../../Includes/JSPs/Misc/iWFMethods.jsp"%>
<%@include file="../../../Includes/JSPs/Misc/iGetUserName.jsp"%>
<html>
<head>
<title>Select User to reject the document</Title>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	var tabHeadWidth=90
	var tabHeight="70%"
	function funCancel()
	{
		window.returnValue="Canceld~~"
		window.close()
	}
	
	function returnUsers()
	{
		var rfqObj = document.myForm.chk1
		var rfqLen 
		var chooseUser = "";
		var chooseRfq = false;
		if(rfqObj != null)
		{
			rfqLen = document.myForm.chk1.length
			if(!isNaN(rfqLen))
			{
				for(i=0;i<rfqLen;i++)
				{
					if(document.myForm.chk1[i].checked)
					{
						chooseUser = document.myForm.chk1[i].value
						chooseRfq = true
						break
					}
					else
					{
						chooseRfq = false
					}
				}
			}
			else
			{
				if(document.myForm.chk1.checked)
				{
					chooseUser = document.myForm.chk1.value
					chooseRfq = true
				}	
				else
				{
					chooseRfq = true
				}
			}
			if(chooseRfq)
			{
				window.returnValue=chooseUser;
				window.close();
			}
			else
			{
				alert("Please select the user");
			}
		}	
	}
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll="no">
<form name=myForm>
<%
	if(stepCount > 0)
	{
%>
		<Div align=center style="position:absolute;top:10%;visibility:visible;width:100%">
		<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1  width="50%">
		<Tr>
			<Th width=20%>&nbsp;</Th><Th width=80%>User Name</Th>
		</Tr>
<%
		String partStep = "",partRole = "",partGroup = "",partType="",partName="";
		String chkValue = "",selected = "";
		
		for(int i=0;i<stepCount;i++)
		{
			partStep  = retRoles.getFieldValueString(i,"STEP");
			partRole  = retRoles.getFieldValueString(i,"ROLE");
			partGroup = retRoles.getFieldValueString(i,"OWNERPARTICIPANT");
			partType  = retRoles.getFieldValueString(i,"OPTYPE");
			partName  = getUserName(Session,partGroup,partType,sysKey);
			chkValue  = partStep+"¥"+partRole+"¥"+partGroup+"¥"+partType;
			if(i==0)
				selected="checked";
			else
				selected="";
			if(!"VIEWROLE".equals(partRole))
			{				
				if(partRole.equals(wfRole))
					break;
%>
			<Tr>
				<Td width=20% align=center><input type=radio name=chk1 value='<%=chkValue%>' <%=selected%>></Td>
				<Td width=80%><%=partName%></Td>
			</Tr>
<%
			}
		}
%>
		</Table>
		</Div>
<%
	}
	else
	{
%>
		<Div align=center style="position:absolute;top:10%;visibility:visible;width:100%">
		<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1  width="50%">
		<Tr>
			<Th>No previous users to send query</Th>
		</Tr>
		</Table>
		</Div>
<%
	}
%>
		<Div align=center style="position:absolute;top:90%;visibility:visible;width:100%">
<%
		buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ok&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");   
		buttonMethod.add("returnUsers()");
		buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cancel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");   
		buttonMethod.add("funCancel()");
		out.println(getButtonStr(buttonName,buttonMethod));
%>
		</Div>	

</form>
</body>
</html>
