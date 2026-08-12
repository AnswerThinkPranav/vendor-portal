<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@page import="java.util.*"%>
<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>
<%@ include file="../../../Includes/Lib/Countries.jsp" %>


<html>
<head>
<title>Enter Material For Select Vendors -- Powered By EzCommerce India</title>
<head>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/checkFormFields.js"></SCRIPT>
<script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),"/",FormatDate.MMDDYYYY) %>";
	var tabHeadWidth=98
 	var tabHeight="60%"
</script>
<Script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
<script>
function searchByMaterial(index)
{
	var matDesc	= 	eval("document.myForm.matDesc"+index).value; 
	
	if(matDesc=="")
	{
		alert("Please enter Material Desc");
		eval("document.myForm.matDesc"+index).focus();
		return;
	}	

	var url="ezSearchMaterial.jsp?matDesc="+matDesc+"&myIndex="+index;
	newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
function search(index)
{
	var matNo	= 	eval("document.myForm.matNumber"+index).value; 
	 matNo = funTrim(matNo)
	if(matNo=="")
	{
		alert("Please enter Material Number");
		eval("document.myForm.matNumber"+index).focus();
		return;
	}	

	var url="ezMtrlSearch.jsp?matCode="+matNo+"&myIndex="+index;
	newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");

}
var myIndex;
function funGetMatDetails(index)
{
	myIndex   = index;
	var matNo = eval("document.myForm.matNumber"+index).value; 
	matNo = funTrim(matNo)

	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	if(keycode == "13")
	SendQuery(matNo);
	
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

				var detArr = resText.split("¥");
				
				if(detArr[2]=="")
				{
					alert("Entered material does not exists.\nPlease enter correct material.")
				}else{
					eval("document.myForm.prUOM"+myIndex).value = detArr[1]
					eval("document.myForm.matDesc"+myIndex).value = detArr[2] 
					eval("document.myForm.matNumber"+myIndex).value = detArr[3]
					window.close()
				}	
			}

		}
		else
		{

			alert("Error while validating the data.. Please try again")
		}
	}
}
function onlyNumbers(evt)
{
	var e = event || evt; 
	var charCode = e.which || e.keyCode;
	if (charCode > 31 && (charCode < 48 || charCode > 57))
	{
		//alert("Materail should be numeric");
		return false;
	}	
	return true;
}
function checkNumeric(numObj,type)
{
	if(type == "QTY")
	{
		var quantity = numObj.value;
		if(quantity != "")
		{
			if(isNaN(quantity))
			{

				alert("Please enter valid quantity");
				numObj.value=''
				numObj.focus();
				return false;
			}
			else if(parseFloat(quantity) <= 0)
			{
				alert("Quantity should not be less than or equals to 0");
				numObj.value=''
				numObj.focus();
				return false;
			}

		}
	}
	else if(type == "VALUE")
	{
		var valPrice = numObj.value;
		if(valPrice != "")
		{
			if(isNaN(valPrice))
			{

				alert("Please enter valid valuation price");
				numObj.value=''
				numObj.focus();
				return false;
			}
			else if(parseFloat(valPrice) <= 0)
			{
				alert("Valuation price should not be less than or equals to 0");
				numObj.value=''
				numObj.focus();
				return false;
			}

		}
	}
}
function addLine()
{
	var tabObj		= document.getElementById("InnerBox1Tab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;

	
	var itemNumber_JS	= (parseFloat(rowCountValue)+1)*10;
	
	var myRCObj=eval("document.myForm.tItemNumber");
	var myRCObjLen=myRCObj.length;
	if(isNaN(myRCObjLen)) myRCObjLen="1";
	eleWidth = new Array();
	eleAlign = new Array();
  	eleVal   = new Array();
		eleWidth[0]  = "8%" ;	eleAlign[0] = "center";
		eleWidth[1]  = "15%";	eleAlign[1] = "center";
		eleWidth[2]  = "25" ;	eleAlign[2] = "center";
		eleWidth[3]  = "15%"; 	eleAlign[3] = "center";
		eleWidth[4]  = "10%" ;	eleAlign[4] = "center";
		eleWidth[5]  = "7%" ;	eleAlign[5] = "center";
		eleWidth[6]  = "10%";	eleAlign[6] = "center";
		

		eleVal[0] ='<input type="text" name="itemNumber'+myRCObjLen+'" class="tx" readonly size="5" value="'+itemNumber_JS+'"><input type="hidden" name="tItemNumber" value="'+itemNumber_JS+'" ><input type="hidden" name="purchReq" value="" >';
		eleVal[1] ='<input type="text" name="matNumber'+myRCObjLen+'" class="InputBox" size="20" maxlength="18" value="" onKeyPress=funGetMatDetails("'+myRCObjLen+'")><img src="../../Images/Others/find.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=search("'+myRCObjLen+'")>';
		eleVal[2] ='<input type="text" name="matDesc'+myRCObjLen+'" class="InputBox" size="35" maxlength="200" value=""><img src="../../Images/Others/find.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=searchByMaterial("'+myRCObjLen+'")>';
		eleVal[3] ='<input type="text" name="deliveryDate'+myRCObjLen+'" class="InputBox" size=14 value="'+document.myForm.toDayDate.value+'" readonly><img src="../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif" style="cursor:hand" id="buttdeliveryDate'+myRCObjLen+'" valign="center" onclick=getSetup("deliveryDate'+myRCObjLen+'","buttdeliveryDate'+myRCObjLen+'")>'
		eleVal[4] ='<input type="text" name="prQty'+myRCObjLen+'" class="InputBox" size="10" maxlength="7" value="" onBlur=checkNumeric(this,"QTY")>';
		eleVal[5] ='<input type="text" name="prUOM'+myRCObjLen+'" class="InputBox" size="7" value="">';
		eleVal[6] ='<Select name = "plant'+myRCObjLen+'" id="FullListBox" style="width:100%"><option value="NA">-Select Plant-</option>';			
<%	   	
		for(int i=0;i<count;i++)
		{
			String plant =ret.getFieldValueString(i,"CODE");	
%>		
			plant = "<%=plant%>";
			eleVal[6] = eleVal[6]+'<option value="'+plant+'">'+plant+'</option>';
<%
		}
%>
		eleVal[6] = eleVal[6]+'</Select>';
		
		var rowId = tabObj.insertRow(rowCountValue);
		for(i=0; i<eleVal.length;i++){
			var cell0=rowId.insertCell(i);
			cell0.width = eleWidth[i];
			cell0.align = eleAlign[i];
			cell0.innerHTML =eleVal[i];		
		}	
		
	


}
function vendorList()
{
	var tabObj		= document.getElementById("InnerBox1Tab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	var successMat = 0
	
	todayArr=(document.myForm.toDayDate.value).split("/")
	currDay =new Date(todayArr[2],(todayArr[1]-1),todayArr[0])
	//alert(rowCountValue)
	for(k=0;k<parseFloat(rowCountValue);k++)
	{
	
		matObj 		= eval("document.myForm.matNumber"+k)
		matDescObj 	= eval("document.myForm.matDesc"+k)
		qtyObj 		= eval("document.myForm.prQty"+k)
		uomObj 		= eval("document.myForm.prUOM"+k)
		delDateObj	= eval("document.myForm.deliveryDate"+k)
		plantObj 	= eval("document.myForm.plant"+k)
		if(rowCountValue==1)
		purchReqObj 	= document.myForm.purchReq
		else
		purchReqObj 	= document.myForm.purchReq[k]
	
		if(matObj.value=="")
		{
			alert("Please enter Material Code.");
			matObj.focus()
			return
		}else{
			if(!isNaN(matObj.value))
			{
				material = "000000000000000000"+matObj.value;
				material = material.substring((material.length-18),material.length);
				matObj.value = material;
			}
		}
		if(matDescObj.value=="")
		{
			alert("Please enter Material Description.");
			matDescObj.focus()
			return
		}
			
		if(matObj.value!='' || matDescObj.value!='')
		{
			if(isNaN(matObj.value))
			{
				alert('Please enter Numerical values Only for Material')
				matObj.focus()
				return
			}
			if(delDateObj.value=="")
			{
				alert("Please enter the Del Date.");
				delDateObj.focus()
				return
			}
			tempDelvDateArr = (delDateObj.value).split("/");			
			tempDelvDate =new Date(tempDelvDateArr[2],(tempDelvDateArr[1]-1),tempDelvDateArr[0]);			
			if(tempDelvDate<currDay)
			{
				alert("Delivery date must be greater than Today's date")
				delDateObj.value=""
				delDateObj.focus()
				return
			}
			if(qtyObj.value=='')
			{
				alert('Please enter quantity')
				qtyObj.focus()
				return
			}
			if(uomObj.value=='')
			{
				alert('Please enter UOM')
				uomObj.focus()
				return
			}
			/*if(plantObj.value=='NA')
			{
				alert('Please select plant')
				plantObj.focus()

				return
			}*/
			
			var purreq = matObj.value+"$$"+plantObj.value+"$$"+delDateObj.value+"$$"+qtyObj.value+"$$"+uomObj.value+"$$"+matDescObj.value+"$$-$$-$$";
			purchReqObj.value=purreq;
			successMat++
			
		}
		if(successMat==0)
		{
			alert('RFQ cannot be created with no line items')
			return
		}

	}	
		
	var y = confirm("RFQ will be created for "+successMat+" line item(s) \n Click on OK to confirm");
	
	if(y)
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan")
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
		if(buttonsSpan!=null)
		{
		buttonsSpan.style.display		= "none"
		buttonsMsgSpan.style.display	= "block"
		}

		document.myForm.action="ezVendorViewList.jsp";
		document.myForm.submit();
	}
}

</script>

</head>


<%
	
	String display_header = "Material Details";
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String toDayDate=fd.getStringFromDate(new java.util.Date(),"/",ezc.ezutil.FormatDate.DDMMYYYY);
%>

<body bgcolor="#FFFFF7" onLoad="scrollInit()" onResize="scrollInit()"  scroll=no>
<form name="myForm">
<input type=hidden name="backChk" value="MULMAT">
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<input type =hidden name="toDayDate" value="<%=toDayDate%>">

    <br>
<Div id="theads">
<Table id="tabHead" width="98%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<Tr>
	<Th width="8%" height="30" align="center"><b><a href="javascript:addLine()"><font color="red" >[+]</font></a></b>Item No</Th>
	<Th width="15%" height="30" align="center">Material</Th>
	<Th width="20%" height="30" align="center">Material Desc</Th> 
	<Th width="15%" height="30" align="center">Del. Date</Th> 
	<Th width="12%" height="30" align="center">Quantity</Th>
	<Th width="10%" height="30" align="center">UOM</Th>
	<Th width="10%" height="30" align="center">Plant</Th> 
	
</Tr>  
</Table>
</Div>

<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:98%;left:2%">
<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<Tr>
	<input type="hidden" name="purchReq" value="">
	<Td width="8%" height="30" align="center">
		<input type="text" name="itemNumber0" class="tx" readonly size="5" value="10">
		<input type="hidden" name="tItemNumber" value="10" >
	</Td>
	<Td width="15%" height="30" align="center">
		<input type="text" name="matNumber0" class="InputBox" size="20" maxlength="18" value="" onKeyPress=funGetMatDetails(0) >
		<img src="../../Images/Others/find.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=search(0)>
	</Td>
	<Td width="20%" height="30" align="center">
		<input type="text" name="matDesc0" class="InputBox" size="35" maxlength="200" value="">
		<img src="../../Images/Others/find.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=searchByMaterial(0)>
	</Td> 
	<Td width="15%" height="30" align="center">
		<input type="text" name="deliveryDate0" class="InputBox" size=14 value="<%=toDayDate%>" readonly>
		<!--<img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' onClick=showCal("document.myForm.delvDate0",205,200,"<%=cDate%>","<%=cMonth%>","<%=cYear%>") >-->
		<img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' id='buttdeliveryDate0' border='none' valign='center'><script>var cal = getSetup('deliveryDate0','buttdeliveryDate0');</script>

	</Td>
	<Td width="12%" height="30" align="center">
		<input type="text" name="prQty0" class="InputBox" size="10" maxlength="7" value="" onBlur=checkNumeric(this,"QTY")>
	</Td> 
	<Td width="10%" height="30" align="center">
		<input type="text" name="prUOM0" class="InputBox" size="7" maxlength="15" value="EA">
	</Td>
	<Td width="10%" height="30" align="center">
		<select name = 'plant0' id = "FullListBox" style="width:100%">
		<option value="NA">-Select Plant-</option>
<%	   	
		for(int i=0;i<count;i++)
		{
%>	
			<option value="<%=ret.getFieldValueString(i,"CODE")%>"><%=ret.getFieldValueString(i,"CODE")%></option>
<%	   		
		}
%>  	   		
		</select>	
	</Td> 
	
</Tr>
</Table>
</Div>

<br><br>    
<Div id="back" align=center style="position:absolute;top:87%;visibility:visible;width:100%">
<Table>
	<Tr>
		<Td class=blankcell>
			<font color="red"><b>*If you are entering material manually press enter key for description and UOM.<b></font>
		</Td>
	</Tr>
</Table>
<span id="EzButtonsSpan" >
<center>

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("GetSources");
	buttonMethod.add("vendorList()");
	buttonName.add("Clear");
	buttonMethod.add("reset()");
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>

</center>
</span>
<span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Th >Your request is being processed... Please wait</Th>
			</Tr>
		</Table>
		</span>
    </Div>

</form>
<Div id="MenuSol"></Div>
</body>
</html>
