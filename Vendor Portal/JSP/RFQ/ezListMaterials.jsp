<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iListMaterials.jsp" %>
<html>
<head>
<Title>Search Result</Title>
<base target="_self">
<Script src="../../Library/JavaScript/Trim.js"></Script>
<Script>
	var tabHeadWidth=95
	var tabHeight="75%"
</Script>
<Script>
	function selectMaterials()
	{
		var chkLen = document.myForm.chk.length;
		indxV = 0;
		if(!isNaN(chkLen))
		{
			for(var i=0;i<chkLen;i++)
			{
				if(document.myForm.chk[i].checked)
				{
					indxV++;
				}	
			}
		}
		else
		{
			if(document.myForm.chk.checked)
				indxV++;
		}
		
		if(indxV==0)
		{
			alert("Please select one material");
			return;
		}
		
		
		
		var indx =0;		
		var chkObj = null;  
		if(!isNaN(chkLen))
		{
			for(var i=0;i<chkLen;i++)
			{
				if(document.myForm.chk[i].checked)
				{
					indx=i;
					break;
				}	
			}
			chkObj = document.myForm.chk[indx].value;
		}else
		{
			chkObj = document.myForm.chk.value;
		}
		var matArr = chkObj.split("##");
		opener.window.document.myForm.matNo.value=matArr[0];
		opener.window.document.myForm.matNo.readOnly = true;
		opener.window.document.myForm.matNum.value="";
		opener.window.document.myForm.matDesc.value=matArr[1];
		window.close();
	}
	function closeWin()
	{
		window.close();
	}
</Script>	
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body scroll="no" onLoad='scrollInit(10)' onResize='scrollInit(10)'>
<form name='myForm'>
<%
	if(materialsCount == 0)
	{
%>
		<br><br><br>
		<Table width="60%" align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1>
			<tr>
				<th align="center">There are no Materials to List.</th>
			</tr>
		<Table>
		<br><br><br><br>
		
		
		<Div id="image" align="center" style='Position:Absolute;visibility:visible;Left:10%;WIDTH:100%;height:70%;Top:94%'>
				<Table align="center">
					<tr align="center">
						<td class=blankcell align="center">
						<span id="EzButtonsSpan" >
			<%
						buttonName = new ArrayList();
						buttonMethod = new ArrayList();
						buttonName.add("Cancel");
						buttonMethod.add("closeWin()");
			
						out.println(getButtonStr(buttonName,buttonMethod));
			%>
						</span>
						
					</Td>
					</Tr>
				</Table>
</Div>
		
		
		
	
		
		
<%
		return;
	}
%>
	<Div>
	<Table id="tabHead" border=0 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=5 cellSpacing=1  width="95%">
	    	<tr align="center" valign="middle">
			<th width="50%">Materials List</th>
	    	</tr>
 	</table>
 	</Div>
	<Div id="theads">
	<Table id="tabHead" border=0 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=5 cellSpacing=1  width="95%">
	    	<tr align="center" valign="middle">
			<th width="5%">&nbsp;</th>
			<th width="30%">Material Code</th>
			<th width="65%">Material Desc</th>
	    	</tr>
 	</table>
 	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;">
	<Table align=center id="InnerBox1Tab" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 width="100%">
<%
		String matCode ="",matDesc="";
		for(int i=0;i<materialsCount;i++)
		{
			matCode = retMaterialsList.getFieldValueString(i,"MAT_CODE").trim();
			matDesc = retMaterialsList.getFieldValueString(i,"MAT_DESC").trim();
			
			
			try
			{
				matCode = Long.parseLong(matCode)+"";
			}
			catch(Exception e)
			{
				matCode = matCode;
			}
			
			

			if(matDesc==null || "null".equals(matDesc) || "".equals(matDesc))
			{
				matDesc = "&nbsp;";
			}
			if(matCode==null || "null".equals(matCode) || "".equals(matCode))
			{
				matCode = "&nbsp;";
			}
			
%>   
			<tr>
				<td width="5%"><input type=radio name="chk" value="<%=matCode+"##"+matDesc%>"></td>
				<td width="30%" align="left"><%=matCode%></td>
				<td width="65%" align="left"><%=matDesc%></td>
			</tr>				
<%						
		}
%>
	</Table>
	</Div>
	

	<Div id="image" align="center" style='Position:Absolute;visibility:visible;Left:4%;WIDTH:100%;height:70%;Top:90%'>
		<Table align="center">
			<tr align="center">
				<td class=blankcell align="center">
				<span id="EzButtonsSpan" >
	<%
				buttonName = new ArrayList();
				buttonMethod = new ArrayList();
	
				buttonName.add("OK");
				buttonMethod.add("selectMaterials()");
				buttonName.add("Cancel");
				buttonMethod.add("closeWin()");
	
				out.println(getButtonStr(buttonName,buttonMethod));
	%>
				</span>
				<span id="EzButtonsMsgSpan" style="display:none">
				<Table align=center>
				<Tr>
					<Td class="labelcell">Your request is being processed... Please wait</Td>
				</Tr>
				</Table>
				</span>
			</Td>
			</Tr>
		</Table>
</Div>
	
	
	
	
	
</form>
<Div id="MenuSol"></Div>
</body>
</html>

