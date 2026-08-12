<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iListMaterials.jsp" %>
<%	
	String searchFlag = request.getParameter("searchFlag");
	String selIndex   = request.getParameter("selIndex");
	
%>
<html>
<head>
<Title>Search Result</Title>
<base target="_self">
<Script src="../../Library/JavaScript/Misc/Trim.js"></Script>
<Script>
	var tabHeadWidth=95
	var tabHeight="75%"
</Script>
<Script>
	var selIndex = '<%=selIndex%>';
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
		if(opener.window.document.myForm.matNo!=null)
		{
			opener.window.document.myForm.matNo[selIndex].value=matArr[0];
			//opener.window.document.myForm.matNo.readOnly = true;		
		}	
		if(opener.window.document.myForm.matDesc!=null)
		{
			opener.window.document.myForm.matDesc[selIndex].value=matArr[1];
			//opener.window.document.myForm.matDesc.readOnly = true;
		}	
		if(opener.window.document.myForm.PO!=null)
			opener.window.document.myForm.PO.value=matArr[0];
		
		if('N'==('<%=searchFlag%>'))
		{
			window.close();
		}
		else if(true)
		{
			document.myForm.action="ezListPlantsAndUnits.jsp?selIndex="+selIndex;
			document.myForm.submit();
		}	
		else
			window.close();
	}
	function closeWin()
	{
		window.close();
	}
	function chkMaxRows()
	{
		var maxRows = myForm.maxRows.value;
		if(!isNaN(maxRows))
			return true;
		else
		{
			alert("Please Enter Number");
			myForm.maxRows.focus();
		}	
		return false;	
	}
	function submitMaxRows()
	{
		if(chkMaxRows())
		{
			myForm.action="ezListMaterials.jsp";
			myForm.submit();
		}	
	}
	function setEmpty()
	{
		myForm.maxRows.value="";
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
		<Table width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
			<tr>
				<th align="center">There are no Materials to List.</th>
			</tr>
		<Table>
		<br><br><br><br>
		
		<Div id="buttonDiv" align=center style="position:absolute;top:94%;visibility:visible;width:100%">
		<Table align="center">
		<tr align="center">
		<td class=blankcell align="center">

		<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Cancel");
			buttonMethod.add("closeWin()");
			out.println(getButtonStr(buttonName,buttonMethod));
		%>
		</Td>
		</Tr>
		</Table>	
		</Div>

<%
		return;
	}
%>
	<Div>
	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0  width="95%">
	    	<tr align="center" valign="middle">
			<Th width="70%">Materials List</Th>
			<Td  width="15%" align="center" class=blankcell>
				<input type="text" class=InputBox onFocus="setEmpty()" style="width:100%" name="maxRows"  size="11" value="Enter no of Rows">		   
			</Td>	
			<Td  width="15%" align="center" class=blankcell>
			
			<%
						buttonName = new java.util.ArrayList();
						buttonMethod = new java.util.ArrayList();
			
						buttonName.add("Submit");
						buttonMethod.add("submitMaxRows()");
						out.println(getButtonStr(buttonName,buttonMethod));
			%>
			</Td>	
		</tr>
 	</table>
 	</Div>

	<Div id="theads">
	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0  width="95%">
	    	<tr align="center" valign="middle">
			<th width="5%">&nbsp;</th>
			<th width="30%">Material Code</th>
			<th width="65%">Material Desc</th>
	    	</tr>
 	</table>
 	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;">
	<Table align=center id="InnerBox1Tab" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="100%">
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
<Div id="buttonDiv" align=center style="position:absolute;top:94%;visibility:visible;width:100%">
<Table align="center">
<tr align="center">
<td class=blankcell align="center">

	
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
		
		if("N".equals(searchFlag) || "N"==searchFlag)
		{
		
			buttonName.add("OK");
			buttonMethod.add("selectMaterials()");

		}
		else
		{
				
			buttonName.add("Next");
			buttonMethod.add("selectMaterials()");
		}
		buttonName.add("Cancel");
		buttonMethod.add("closeWin()");
		out.println(getButtonStr(buttonName,buttonMethod));
%>
</Td>
</Tr>
</Table>	
</Div>
<input type="hidden" name="matCode" value="<%=material%>">
<input type="hidden" name="searchFlag" value="<%=searchFlag%>">
<input type="hidden" name="selIndex" value="<%=selIndex%>">
</form>
<Div id="MenuSol"></Div>
</body>
</html>