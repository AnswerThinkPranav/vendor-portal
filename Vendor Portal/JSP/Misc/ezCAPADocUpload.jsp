<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iAttachmentFile_Labels.jsp"%>
<html>
<head><title>Attachment</title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%
	String matDocNo = request.getParameter("matDocNo");
	String poNo = request.getParameter("poNo");
	String poItem = request.getParameter("poItem");
	String matCode = request.getParameter("matCode");
	String matDesc = request.getParameter("matDesc");
	
	/*out.println("::::::::matDocNo::::::::"+matDocNo);
	out.println("::::::::poNo::::::::"+poNo);
	out.println("::::::::poItem::::::::"+poItem);
	out.println("::::::::matCode::::::::"+matCode);
	out.println("::::::::matDesc::::::::"+matDesc);*/
%>
<script>
var parentObj="";
var docObj="";
if(!document.all)
{
  parentObj = opener.document.myForm	
  docObj = opener.document
}
else
{
  parentObj = parent.opener.myForm	
  docObj = parent.opener.document
}

var attach;
function funAttach(i)
{
	attach=window.open("../Shipment/ezAttachFile.jsp?index="+i,"UserWindow2","width=450,height=250,left=150,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no");
}

function funLoad()
{
	var filestr=document.myForm.shipupload.value;

	if(filestr!="")
	{

		var filearr=filestr.split("§");

		if(!isNaN(document.myForm.n1.length))
		{
			for(var i=0;i<document.myForm.n1.length;i++)
			{
				if(filearr[i]=="NA")
				{
					finalval="";

				}
				else
				{
					finalval=filearr[i];
					document.getElementById("remove"+i).style.visibility="visible"
					document.getElementById("attachment"+i).style.visibility="hidden";
				}
				document.myForm.n1[i].value=finalval;
			}
		}
		else
		{
			document.myForm.n1.value=filestr;
			document.getElementById("remove"+i).style.visibility="visible"
			document.getElementById("attachment"+i).style.visibility="hidden";
		}
	}
}

function funDone()
{
	if(document.myForm.n1.value=='')
	{
		alert("Please upload file and then click on Save");
		return;
	}
	document.myForm.action = 'ezSaveCAPADoc.jsp';
	document.myForm.submit();

	/*finalstr=""
	shipflag="N";
	
	
	if(!isNaN(document.myForm.n1.length))
	{
		for(var i=0;i<document.myForm.n1.length;i++)
		{
			if(document.myForm.n1[i].value!="")
			{
				finalstr=finalstr+document.myForm.n1[i].value+"§";
				shipflag="Y";
			}
			else
			{
				finalstr=finalstr+"NA"+"§";
			}

		}
	}
	else
	{
		finalstr=finalstr+document.myForm.n1.value+"§";
		shipflag="Y";
	}
	

	finalstr=finalstr.substring(0,finalstr.length-1);
	parentObj.conDocUpload.value=finalstr;
	parentObj.conDocFlag.value=shipflag;
	window.close();
	*/
}

	function removeFile(x)
	{
	   document.myForm.n1.value="";
	   document.getElementById("remove"+x).style.visibility="hidden"
	   document.getElementById("attachment"+x).style.visibility="visible";
	}

	function funCancel()
	{
		window.close();
	}

	function funUnLoad()
	{
		if(attach!=null && attach.open)
		{
			attach.close();
		}
	}
</script>
</head>

<body onLoad="funLoad()"  onUnLoad="funUnLoad()" scroll=no>
<form name="myForm">

	<table width="80%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
		<th align="left">Document No.</th>
		<td align="left"><%=matDocNo%></td>
	</tr>
	<tr>
		<th align="left">Material Code</th>
		<td align="left"><%=matCode%></td>
	</tr>
	<tr>
		<th align="left">Material Desc</th>
		<td align="left"><%=matDesc%></td>
	</tr>
	</table>
	<Br><Br>
	<table width="90%">
	<tr><td><b><%=attachFiles_L%></b></td>

	<tr><td class="blankcell"><hr></td>
	<tr><td class="blankcell">1.<%=clickAttachFile_L%></td>
	</tr></table>
	<table width="80%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
	<th colspan=3 align="left">CAPA Document</th>
	</tr>
	<tr>

<td align="left"><input type=text size="25" class=InputBox  value="" name="n1"></td>
<td align="center">
	<img id="attachment0" src="../../../../EzCommon/Images/Body/attachfile.jpg" style="cursor:hand" border=none onclick="funAttach(0)" >
	<img id="remove0" alt="Delete Attachment"  src='../../../../EzCommon/Images/Body/remove.gif' style='cursor:hand;visibility:hidden' border=none onClick="removeFile(0)" ></td>
</tr>

</table>

<table width="90%">
<tr><td class="blankcell"><hr></td>
<tr><td class="blankcell">2.<%=clkDone_L%></td>
<tr><td class="blankcell">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Save");
	buttonMethod.add("funDone()");

	buttonName.add("Cancel");
	buttonMethod.add("window.close()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</td>
<tr><td class="blankcell"><hr></td>
</tr></table>

<input type="hidden" name="docNo" value="<%=request.getParameter("matDocNo")+""+request.getParameter("poItem")%>" >
</form>
<Div id="MenuSol"></Div>
</body>
</html>
