<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iMtrlSearch.jsp"%>
<html>
<head>
<Title>Search Result</Title>
<base target="_self">
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>
	var tabHeadWidth=95
	var tabHeight="60%"
</Script>
<Script>
var myIndex="<%=myIndex%>"
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
		if(myIndex=="NA")
		{
			opener.window.document.myForm.matNo.value=matArr[0];
			opener.window.document.myForm.matNo.readOnly = true;		
			opener.window.document.myForm.matDesc.value=matArr[1];
			opener.window.document.myForm.matDesc.readOnly = true;
			
			window.close();
		}else{
			eval("opener.window.document.myForm.matNumber"+myIndex).value=matArr[0];
			eval("opener.window.document.myForm.matNumber"+myIndex).readOnly = false;		
			eval("opener.window.document.myForm.matDesc"+myIndex).value=matArr[1];
			eval("opener.window.document.myForm.matDesc"+myIndex).readOnly = false;
			
			SendQuery(matArr[0]);
		}
		
	}
	var req;
	function Initialize()
	{
		req = '';
		reqType = '';

		try
		{
			req=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e)
		{
			try
			{
				req=new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(oc)
			{
				req=null;
			}
		} 
		if(!req&&typeof XMLHttpRequest!="undefined")
		{
			req=new XMLHttpRequest();
		}
	}

	function SendQuery(material)
	{
	
		Initialize()

		try
		{
			req=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e)
		{
			try
			{
				req=new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(oc)
			{
				req=null;
			}
		}

		if(!req&&typeof XMLHttpRequest!="undefined")
		{
			req=new XMLHttpRequest();
		}

		var url=location.protocol+"//"+location.host+"/j2ee/EzCommerce/EzVendor/Vendor2/JSPs/RFQ/ezGetMatGrpAndUom.jsp?material="+material+"&date="+new Date();	
		//document.write(url)
		if(req!=null)
		{
			req.onreadystatechange = Process;
			req.open("GET", url, true);
			req.send(null);

		}
	}

	function Process()
	{
	
	
		if(req.readyState == 4)
		{
		
			if(req.status == 200)
			{
				var resText=req.responseText;

				if(resText.indexOf("¥")!=-1)
				{

					var detArr = resText.split("¥")
					eval("opener.window.document.myForm.prUOM"+myIndex).value = detArr[1]
					eval("opener.window.document.myForm.prUOM"+myIndex).readOnly = true;
					window.close()
				}

			}
			else
			{

				alert("Error while validating the data.. Please try again")
			}
		}
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
			myForm.action="ezMtrlSearch.jsp";
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
		<Table width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=0>
			<tr>
				<th align="center">There are no Materials to List.</th>
			</tr>
		<Table>
		<br><br><br><br>
		
		<Div id="ButtonDiv" style="position:absolute;top=94%;width=100%" align="center" >
		<center>
<%
    		
    		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Cancel");
		buttonMethod.add("closeWin()");
		out.println(getButtonStr(buttonName,buttonMethod));
    
%>
	       </center>
		</Div>
<%
		return;
	}
%>
	<Div>
	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=5 cellSpacing=0  width="95%">
	    	<tr align="center" valign="middle">
			<Th width="70%">Materials List</Th>
			<Td  width="15%" align="center" >
				<input type="text" class=InputBox onFocus="setEmpty()" style="width:100%" name="maxRows"  size="11" value="Enter no of Rows">		   
			</Td>	
      <td >
          
<%
	   
	  	
			buttonName.add("Submit");
			buttonMethod.add("submitMaxRows()");
			out.println(getButtonStr(buttonName,buttonMethod)); 
			buttonName.clear();
			buttonMethod.clear();
%>
        
          
      </td>
		</tr>
 	</table>
 	</Div>

	<Div id="theads">
	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=5 cellSpacing=0  width="95%">
	    	<Tr align="center" valign="middle">
			<Th width="5%">&nbsp;</Th>
			<Th width="30%">Material Code</Th>
			<Th width="65%">Material Desc</Th>
	    	</Tr>
 	</table>
 	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;">
	<Table align=center id="InnerBox1Tab" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=0 width="100%">
<%
		String matCode ="",matDesc="";
		for(int i=0;i<materialsCount;i++)
		{
			matCode = retMaterialsList.getFieldValueString(i,"MAT_CODE").trim();
			matDesc = retMaterialsList.getFieldValueString(i,"MAT_DESC").trim();
			
			
			try
			{
				matCode = matCode+"";
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
	<Div id="ButtonDiv" style="position:absolute;top=94%;width=100%;bottom:80px;left:300px"  >
	
	<%
	    
	   		buttonName = new java.util.ArrayList();
	    		buttonMethod = new java.util.ArrayList();
	    		buttonName.add("Ok");
	    		buttonMethod.add("selectMaterials()");
	    		buttonName.add("Cancel");
	    		buttonMethod.add("closeWin()");
			out.println(getButtonStr(buttonName,buttonMethod));
	    
	%>
	</Div>
<input type="hidden" name="matCode" value="<%=material%>">
</form>
<Div id="MenuSol"></Div>
</body>
</html>