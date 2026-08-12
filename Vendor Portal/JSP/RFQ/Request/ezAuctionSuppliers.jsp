<%@ page import="java.util.*,java.text.*" %>
<%@ include file="../../../Includes/JSPs/Request/iAppendLines.jsp"%>
<html>
<head>
	<title> -- Powered by EzCommerce Inc</title>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
	<!--<script src="../../Library/JavaScript/Calender.js"></script>-->
    <Script src="../../Library/JavaScript/CalendarDiv.js"></script>
    <script src="../../Library/JavaScript/ezTrim.js"></script>
<script>
	var tabHeadWidth=100
</script>
	<script src="../../Library/JavaScript/ezScrollDefine.js"></script>
	<script src="../../Library/JavaScript/ezScroll.js"></script>
	<script> var totTabs=3 </script>
	<%@ include file="../../../Includes/JSPs/Request/iGetUploadTempDir.jsp" %>
	<%@include file="../../../Includes/JSPs/Misc/iTopTabScript.jsp" %>
<%
	ResourceBundle payrb=ResourceBundle.getBundle("EzPaymentTerms");
	ResourceBundle incorb=ResourceBundle.getBundle("EzIncoTerms");
%>

<script>
function funOnLoad()
{
	document.getElementById("suprows").style.top=document.getElementById("suptable").offsetTop+document.getElementById("suptable").offsetHeight;
}

function funOpenFile(serverFile)
{
  var fVal = serverFile.split('*')
  sFile="";
  for(var i=0;i<fVal.length;i++)
  {
      sFile = sFile+fVal[i]+"/"
  }
  sFile = sFile.substring(0,sFile.length-1)
  window.open("/<%=uploadFilePathDir%>"+sFile,"newWin","titlebar=yes")
  //document.location.href="/<%=uploadFilePathDir%>"+sFile
}


	function datesEntry(index)
	{
		var matname=""
		var ind="";
		if(!isNaN(document.myForm.materialname.length))
		{
			matname=document.myForm.materialname[index].value;
			deliverables=escape(document.myForm.deliverables[index].value)
			ind=index;
		}
		else
		{
			ind=0;
			matname=document.myForm.materialname.value;
			deliverables=escape(document.myForm.deliverables.value)
		}
		newWindow=window.open("ezViewDatesEntry.jsp?materialname="+matname+"&index="+ind+"&deliverables="+deliverables,"Mywin","resizable=no,left=250,top=100,height=380,width=450,status=no,toolbar=no,menubar=no,location=no");
	}




var count=0;
  function ezAddNewRow()
  {
		count=1;
  		elementsArray=new Array();

  			rowId = ezTab.insertRow();

  			elementsArray[0]='<input type="checkbox" disabled>'
  			elementsArray[1]='Supplier Id'
  			elementsArray[2]='Supplier Name'
  			if(document.myForm.ratio!=null)
  				elementsArray[3]='Evaluation Factor in %'
  			eleWidth = new Array();
  			eleWidth[0] = "10%";
  			eleWidth[1] = "35%";
  			eleWidth[2] = "35%";
  			if(document.myForm.ratio!=null)
  				eleWidth[3] = "20%";
  			eleAlign = new Array();
  			eleAlign[0] = "center";
  			eleAlign[1] = "center";
  			eleAlign[2] = "center";
  			if(document.myForm.ratio!=null)
  				eleAlign[3] = "center";
  			eleColor=new Array();
  			eleColor[0]="labelcell";
  			eleColor[1]="labelcell";
  			eleColor[2]="labelcell";
  			if(document.myForm.ratio!=null)
  				eleColor[3]="labelcell";
  			len=elementsArray.length
  			for (i=0;i<len;i++)
  			{
  				cell0Data = elementsArray[i]
  				cell0=rowId.insertCell(i);
  				cell0.innerHTML=cell0Data;
  				cell0.align=eleAlign[i];
  				cell0.width= eleWidth[i];

  				cell0.className=eleColor[i]
  			}

	if(!isNaN(document.myForm.aliasname.length))
	{
		for(var i=0;i<document.myForm.aliasname.length;i++)
		{

			if(document.myForm.aliasname[i].value!="")
			{

				count++;
				rowId = ezTab.insertRow();
  				elementsArray[0]='<td width = "10%" align = "center"><input type="checkbox" name="chk1" disabled></td>'
  				elementsArray[1] ='<td width = "35%" align = "center">'+(i+1)+'</td>'
  				elementsArray[2] ='<td width = "35%" align = "center">'+document.myForm.aliasname[i].value+'</td>'
  				if(document.myForm.ratio!=null)
  					elementsArray[3] ='<td width = "20%" align = "center">&nbsp;'+document.myForm.ratio[i].value+'</td>'
  				eleWidth = new Array();
  				eleWidth[0] = "10%";
  				eleWidth[1] = "35%";
  				eleWidth[2] = "35%";
  				if(document.myForm.ratio!=null)
					eleWidth[3] = "20%";
  				eleAlign = new Array();
  				eleAlign[0] = "center";
  				eleAlign[1] = "center";
  				eleAlign[2] = "left";
  				if(document.myForm.ratio!=null)
  					eleAlign[3] = "right";
  				eleColor=new Array();
  				eleColor[0]="";
  				eleColor[1]="";
  				eleColor[2]="";
  				if(document.myForm.ratio!=null)
  					eleColor[3]="";
  				len=elementsArray.length
  				for (j=0;j<len;j++)
  				{
  					cell0Data = elementsArray[j]
  					cell0=rowId.insertCell(j);
  					cell0.innerHTML=cell0Data;
  					cell0.align=eleAlign[j];
  					cell0.width= eleWidth[j]
  					cell0.className=eleColor[j]
  				}
  				scrollInit()
  			}
  		}
  	}
  	else
  	{
			if(document.myForm.aliasname.value!="")
			{

				count++;
				rowId = ezTab.insertRow();
  				elementsArray[0]='<td width = "10%" align = "center"><input type="checkbox" name="chk1" disabled></td>'
  				elementsArray[1] ='<td width = "35%" align = "center">1</td>'
  				elementsArray[2] ='<td width = "35%" align = "left">'+document.myForm.aliasname.value+'</td>'
  				if(document.myForm.ratio!=null)
  					elementsArray[3] ='<td width = "20%" align = "right">&nbsp;'+document.myForm.ratio.value+'</td>'
  				eleWidth = new Array();
  				eleWidth[0] = "10%";
  				eleWidth[1] = "35%";
  				eleWidth[2] = "35%";
  				if(document.myForm.ratio!=null)
					eleWidth[3] = "20%";
  				eleAlign = new Array();
  				eleAlign[0] = "center";
  				eleAlign[1] = "left";
  				eleAlign[2] = "right";
  				if(document.myForm.ratio!=null)
  					eleAlign[3] = "center";
  				eleColor=new Array();
  				eleColor[0]="";
  				eleColor[1]="";
  				eleColor[2]="";
  				if(document.myForm.ratio!=null)
  					eleColor[3]="";
  				len=elementsArray.length
  				for (j=0;j<len;j++)
  				{
  					cell0Data = elementsArray[j]
  					cell0=rowId.insertCell(j);
  					cell0.innerHTML=cell0Data;
  					cell0.align=eleAlign[j];
  					cell0.width= eleWidth[j]
  					cell0.className=eleColor[j]
  				}
  				scrollInit()
  		}
  	}
 }

/*
   function showDiv(n)
   {

          for(var i=1;i<=3;i++)
	  {

	  	if(i==n)
		{

			document.getElementById("tab"+i).style.visibility="visible"
			document.getElementById("tab"+i+"color").style.color="#000000"
		}
		else
		{

			document.getElementById("tab"+i).style.visibility="hidden"
			document.getElementById("tab"+i+"color").style.color="#ffffff"

		}
	}

	tabfun(n)
   }
*/


function showDiv_new(currentTab,totalTabs)
 {
	  for(var i=1;i<=totalTabs;i++)
	  {
		if(i==currentTab)
		{
			document.getElementById("tab"+i).style.visibility="visible"
			document.getElementById("tab"+i).style.width="100%"
			document.getElementById("tab"+i+"color").style.color="#00385D"

			document.getElementById("tab"+i+"_3").src="../../../../EzCommon/Images/Tabs/ImgLftUp.gif"
			document.getElementById("tab"+i+"_2").src="../../../../EzCommon/Images/Tabs/ImgRgtUp.gif"
			document.getElementById("tab"+i+"_1").style.background="url('../../../../EzCommon/Images/Tabs/ImgCtrUp.gif')"

		}
		else
		{
			document.getElementById("tab"+i).style.visibility="hidden"
			document.getElementById("tab"+i+"color").style.color="#B7B7B7"

			document.getElementById("tab"+i+"_3").src="../../../../EzCommon/Images/Tabs/ImgLftDn.gif"
			document.getElementById("tab"+i+"_2").src="../../../../EzCommon/Images/Tabs/ImgRgtDn.gif"
			document.getElementById("tab"+i+"_1").style.background="url('../../../../EzCommon/Images/Tabs/ImgCtrDn.gif')"
			document.getElementById("tab"+i).style.width="0%"
		}
		
	  }
	  
	//tabfun(totalTabs)  
		   
 }

function funPreview()
{
	var bool=funSave('P');
	if(bool)
	{
		document.getElementById("preview").style.visibility="visible"
		document.getElementById("suppliers").style.visibility="hidden"
		document.getElementById("backdiv").style.visibility="visible"
		document.getElementById("tab1").style.visibility="visible"
		document.getElementById("tab3").style.visibility="hidden"
		document.getElementById("tab2").style.visibility="hidden"
		document.getElementById("tab"+1+"color").style.color="#ffffff"
		ezAddNewRow()
		//tabfun(1)
	}
}


function funSupplier()
{

		for(var i=0;i<count;i++)
		{

			document.all.ezTab.deleteRow();
		}

	document.getElementById("preview").style.visibility="hidden"
	document.getElementById("suppliers").style.visibility="visible"
	document.getElementById("backdiv").style.visibility="hidden"
	document.getElementById("tab1").style.visibility="hidden"
	document.getElementById("tab3").style.visibility="hidden"
	document.getElementById("tab2").style.visibility="hidden"

}

function funSave(flag)
{
	len=document.myForm.aliasname.length
	count=0
	if(!isNaN(len))
	{
		for(var i=0;i<len;i++)
		{
			if(document.myForm.chk1[i].checked==true)
			{
				count++;
			}
		}
		if(count<2)
		{
			alert("Please Select Atleast Two Suppliers");
			return false;
		}
		for(var i=0;i<len;i++)
		{
			if(document.myForm.chk1[i].checked==true && document.myForm.aliasname[i].value=="")
			{
				alert("Please enter Alias Names for Selected Suppliers.");
				document.myForm.aliasname[i].focus()
				return false;
			}
			if(document.myForm.chk1[i].checked!=true && document.myForm.aliasname[i].value!="")
			{
				alert("Please select Supplier.");
				document.myForm.chk1[i].focus()
				return false;
			}
			if(document.myForm.ratio!=null)
			{
				if(((document.myForm.ratio[i].value!="") && (document.myForm.aliasname[i].value!="")))
				{
					if(isNaN(document.myForm.ratio[i].value))
					{
						alert("Please Enter Valid Granted Ratio")
						document.myForm.ratio[i].focus()
						return false;

					}

					if(document.myForm.ratio[i].value!="" && funTrim(document.myForm.ratio[i].value)<0)
					{
						alert("Negative Values Are Not Allowed")
						document.myForm.ratio[i].focus()
						return false;

					}
					minbidvar=funTrim(document.myForm.ratio[i].value);
					minbidvar=parseFloat(minbidvar);
					if(document.myForm.ratio[i].value!="" && minbidvar>100)
					{
						alert("Evaluation Factor Should Be Lessthan 100");
						document.myForm.ratio[i].focus();
						return false;
					}
					minsplit=funTrim(document.myForm.ratio[i].value);
					if(document.myForm.ratio[i].value!="" && (minsplit.indexOf(".")!=-1))
					{
						decvalue=minsplit.substring((minsplit.indexOf(".")+1),minsplit.length)
						//alert(decvalue)
						if(decvalue.length>2)
						{
							alert("Decimal Places in Evaluation Factor Cannot be morethan 2 ");
							document.myForm.ratio[i].focus();
							return false;
						}
					}
				}
			}
		}
	}
	else
	{
		if(document.myForm.chk1.checked==false)
		{
			alert("Please Select The Supplier");
			return false;
		}
		if(document.myForm.chk1.checked==true && document.myForm.aliasname.value=="")
		{
			alert("Please Enter AliasName For Selected Supplier");
			return false;
		}
		if(document.myForm.ratio!=null)
		{
			if(((document.myForm.ratio.value!="")&&(document.myForm.aliasname.value!="")))
			{
					if(isNaN(document.myForm.ratio[i].value))
					{
						alert("Please Enter Valid Granted Ratio")
						document.myForm.ratio[i].focus()
						return false;

					}
					if(funTrim(document.myForm.ratio.value)!="" && funTrim(document.myForm.ratio.value)<0)
					{
						alert("Negative Values Are Not Allowed")
						document.myForm.ratio[i].focus()
						return false;

					}
					minbidvar=funTrim(document.myForm.ratio.value);
					minbidvar=parseFloat(minbidvar);
					if(funTrim(document.myForm.ratio.value)!="" && minbidvar>100)
					{
						alert("Evaluation Factor Should Be Lessthan 100");
						document.myForm.ratio.focus();
						return false;
					}

					minsplit=funTrim(document.myForm.ratio.value);
					if(funTrim(document.myForm.ratio.value)!="" && minsplit.indexOf(".")!="-1")
					{
						decvalue=minsplit.substring((minsplit.indexOf(".")+1),minsplit.length)
						if(decvalue.length>2)
						{
							alert("Decimal Places in Evaluation Factor Cannot be morethan 2 ");
							document.myForm.ratio.focus();
							return false;
						}
					}
				}
			}
		}

	if(document.myForm.auctionId.value=='null' || funTrim(document.myForm.auctionId.value)=="")
	{

		if(flag=='S')
		{

			document.myForm.action="ezAddSaveAuction.jsp"
			document.myForm.submit();
		}
		else
		{
			return true;
		}
	}
	else
	{
		if(flag=='E')
		{

			document.myForm.action="ezEditSaveAuction.jsp";
			document.myForm.submit();
		}
		else
		{
			return true;
		}
	}
}


function funBack()
{
	var len=document.myForm.chk1.length;
	if(!isNaN(len))
	{
		for(var i=0;i<len;i++)
		{
			if(document.myForm.chk1[i].checked==true)
			{
				document.myForm.chk2[i].value=document.myForm.chk1[i].value;
			}
			else
			{
				document.myForm.chk2[i].value="";
			}
		}
	}
	else
	{
		if(document.myForm.chk1.checked==true)
		{
			document.myForm.chk2.value=document.myForm.chk1.value;
		}
		else
		{
			document.myForm.chk2.value="";
		}
	}
	document.myForm.action="ezCreateAuctionLines.jsp";
	document.myForm.submit();
}



var totTabs=3;




function showTab(tabno)
{

	for(var z=1;z<=totTabs;z++)
	{
		obj=document.getElementById("Div"+z);
		if(tabno==z)
		{
			obj.style.visibility="visible"

			//tabfun(z,document.myForm)
		}
		else
		{
			obj.style.visibility="hidden"
		}
	}
}

function selectAll()
{
    var	len=document.myForm.chk1.length;
	if(isNaN(len))
	{
		if(document.myForm.chk1.checked)
		{
			document.myForm.chk1.checked=false
		}else{
			document.myForm.chk1.checked=true
		}
	}
	else
	{
	for(i=0;i<len;i++)
	{	if(document.myForm.chkId.checked)
		document.myForm.chk1[i].checked=true
		else
		document.myForm.chk1[i].checked=false
	}
	}
}



</script>
<script src="../../Library/JavaScript/ezTabs.js">
</script>
</head>
<body  scroll=no bgcolor="#336666" onLoad="funOnLoad()">

<%
	
	java.util.ResourceBundle rb =  java.util.ResourceBundle.getBundle("itemsellers");
	java.util.ResourceBundle rb1 =  java.util.ResourceBundle.getBundle("Suppliers");
	Hashtable finalsellers=new Hashtable();
	for(int i=0;i<materialname.length;i++)
	{
		if(!materialname[i].equals(""))
		{
			String selname=rb.getString(materialname[i]);

			StringTokenizer selst=new StringTokenizer(selname,",");
			while(selst.hasMoreElements())
			{
				 String name=(String)selst.nextToken();
				if(!finalsellers.containsKey(name.trim()))
					finalsellers.put(name,rb1.getString(name.trim()));
			}
		}
	}
%>
<form method="post"  name="myForm">
<div id="suppliers" style="position:absolute;top:0%;left:0%;height:100%;width:100%">

<%
	if(finalsellers.size()==0)
	{
%>
		<br><br><br><br><br>
		<table><tr><th align="center">No Suppliers Found For Selected Materials</th></tr></table>
<%
	return;
	}
	
	String display_header="List of Suppliers";
	
%>

<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<br>
<%

	ezc.ezreverseauction.params.EziAuctionSupplierTable supplierParams=(ezc.ezreverseauction.params.EziAuctionSupplierTable)session.getValue("Suppliers");
	ezc.ezreverseauction.params.EziAuctionSupplierTableRow supplierTabParams=null;
	String evalfactor="";
	if(supplierParams!=null)
	{
		if(supplierParams.getRowCount()>0)
		{
			supplierTabParams=(EziAuctionSupplierTableRow)supplierParams.getRow(0);
			evalfactor=supplierTabParams.getEvalFactor();
		}
	}


%>
<div id="suptable" >
<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width=90%>
<Tr>
	<th width = "5%"><input type=Checkbox name=chkId onClick="selectAll()" title = "Select / Deselect All"></th>
	<th width="10%">Supplier ID</th>
	<th width="25%">Supplier Name</th>
	<th width="25%">Alias Name</th>
<%
	if(("R".equals(evaluationtype)))
	{

%>
	<th width="25%">Evaluation Factor in %
<!--	<select class="control" name="evalfactor">
	<option value="">--Select--</option>
	<script>
		factor=new Array("Percentage","Amount");
		factorvalue=new Array("P","A");
		for(var i=0;i<factorvalue.length;i++)
		{
			var ftr='<%=evalfactor%>'
			if(ftr==factorvalue[i])
				document.write("<option value="+factorvalue[i]+" selected>"+factor[i]+"</option>");
			else
				document.write("<option value="+factorvalue[i]+" >"+factor[i]+"</option>");
		}
	</script>
	</select>-->
	</th>
<%
	}
%>
</Tr>
</table>
</div>
<div id="suprows" style="position:absolute;overflow:auto;top:20%;left:5%;height:80%;width:90%">
<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width=100%>
<%
int supid=1;
	if(supplierParams!=null)
	{
		for(int i=0;i<supplierParams.getRowCount();i++)
		{
			supplierTabParams=(EziAuctionSupplierTableRow)supplierParams.getRow(i);

			if(finalsellers.containsKey(supplierTabParams.getSupplierCode()))
			{
%>
				<Tr>
					<td width = "5%" align = "center"><input type=Checkbox name="chk1" value="<%=supplierTabParams.getSupplierCode()%>" checked></td>
					<td width="10%"><a href = "JavaScript:void(0)" ><%=supid%></a></td>
					<td width="25%"><%=(String)finalsellers.get(supplierTabParams.getSupplierCode())%></td>
					<td align="center" width="25%">
					<input type="text" class="inputBox" name="aliasname" value='<%=supplierTabParams.getSupplierAlias()%>' maxlength=15>
					<input type="hidden" name="chk2" value="<%=supplierTabParams.getSupplierCode()%>">
					</td>
<%
			String grantedratio=supplierTabParams.getEvalFactor();
			if(Float.parseFloat(grantedratio)==0)
			{
				grantedratio="";
			}
			if(("R".equals(evaluationtype)))
			{

%>
					<td align="center" width="25%"><input type="text" class="inputBox" name="ratio" value='<%=grantedratio%>' maxlength=6 style = "text-align:right"></td>
<%
			}
%>
				</Tr>

<%
			finalsellers.remove(supplierTabParams.getSupplierCode().trim());
			supid++;
			}

		}
	}


	Enumeration enum1=finalsellers.keys();

	while(enum1.hasMoreElements())
	{
		String key=(String)enum1.nextElement();
		String value=(String)finalsellers.get(key);
%>
		<Tr>
			<td width = "5%" align = "center"><input type=Checkbox name="chk1" value="<%=key%>"></td>
			<td width="10%"><a href = "JavaScript:void(0)" ><%=supid%></a></td>
			<td width="25%"><%=value%></td>
			<td align="center" width="25%">
				<input type="text" class="inputBox" name="aliasname" maxlength=15>
				<input type="hidden" name="chk2" value="<%=key%>">
			</td>
<%
			if(("R".equals(evaluationtype)))
			{

%>
					<td align="center" width="25%"><input type="text" class="inputBox" name="ratio" maxlength=6 style = "text-align:right"></td>
<%
			}
%>
		</Tr>
<%
	supid++;
	}
%>
</Table>

</div>
<div id="buttondir2" style="position:absolute;top:85%;left:37%">
<table align="center">
<br>
<tr>
	<Td class=blankcell>

<%
	if(auctionId!=null && !"".equals(auctionId) && !"null".equals(auctionId))
	{

			buttonName = new ArrayList();
			buttonMethod = new ArrayList();
			buttonName.add("Preview");
			buttonMethod.add("funPreview()");
			buttonName.add("Previous");
			buttonMethod.add("funBack()");
			buttonName.add("Approve");
			buttonMethod.add("funSave(\"E\")");
	}
	else
	{
	
			buttonName.add("Preview");
			buttonMethod.add("funPreview()");
			buttonName.add("Previous");
			buttonMethod.add("funBack()");
			buttonName.add("Approve");
			buttonMethod.add("funSave(\"S\")");
	}
	
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>
	</Td>
</tr>
</table>

</div>
<input type="hidden" name="finallines" value='<%=finallines%>' >
<input type="hidden" name="enddate" value='<%=enddate%>'>
<input type="hidden" name="auctionId" value="<%=auctionId%>" >
<input type="hidden" name="evaluationtype" value='<%=evaluationtype%>'>
</div>

<div id="preview" style="position:absolute;top:7%;left:5%;height:90%;visibility:hidden">
<%
	ezc.ezreverseauction.params.EziAuctionHeaderParams addParams= (ezc.ezreverseauction.params.EziAuctionHeaderParams)session.getValue("sessionHeader");
%>

	<table align=center id="header" width="90%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
  	<tr>
	<th width="8%" valign="middle" colspan=8 align=center>Request Details Of Auction : <%=addParams.getAuctionName()%></th>
	</tr>
	<tr>
    	<th align = "right" width = "8%">Start Date</th>
<%
		String temp="121212345"; 
		
		String startDate=addParams.getStartDate()+temp;
		String endDate=addParams.getEndDate()+temp;
		
		
		startDate=startDate.trim();
		endDate=endDate.trim();
		GregorianCalendar gc = new GregorianCalendar(Integer.parseInt(startDate.substring(6,10)),(Integer.parseInt(startDate.substring(3,5))-1),Integer.parseInt(startDate.substring(0,2)),Integer.parseInt(startDate.substring(11,13)),Integer.parseInt(startDate.substring(14,16)),0);
		GregorianCalendar gc1 = new GregorianCalendar(Integer.parseInt(endDate.substring(6,10)),(Integer.parseInt(endDate.substring(3,5))-1),Integer.parseInt(endDate.substring(0,2)),Integer.parseInt(endDate.substring(11,13)),Integer.parseInt(endDate.substring(14,16)),0);
	

	Date d = gc.getTime();
		Date d1=gc1.getTime();
		SimpleDateFormat sdf  = new SimpleDateFormat("dd.MM.yyyy hh:mm a");

		String sTime1 = sdf.format(d);
		String eTime1 = sdf.format(d1);

		sTime1 = sTime1.substring(11,sTime1.length());
		eTime1 = eTime1.substring(11,eTime1.length());

	//	out.println(sTime1);
		//out.println(eTime1);
%>
    	<td width = "11%"><%=(addParams.getStartDate()).substring(0,10)%></td>
    	<th align = "right" width = "10%">Start Time</th>
    	<td width = "10%"><%=sTime1%></td>
    	<th align = "right" width = "9%">End Date</th>
    	<td width = "16%" valign = "center"><%=(addParams.getEndDate()).substring(0,10)%></td>
    	<th align = "right" width = "1%">End Time</th>
    	<td width = "10%"><%=eTime1%></td>
	</tr>

	<tr>
    	<th align = "right" width = "8%" title = "Extension Time">Ext. Time</th>
    	<td width = "11%"><%=addParams.getExtensionTime()%>&nbsp;Minutes</td>
    	<th align = "right" width = "10%" title = "Number of Extensions">No. of Exts.</th>
    	<td width = "6%"><%=addParams.getExtensions()%></td>
	<th align = "right" width = "10%" nowrap>Min. Bid Var</th>
    	<td width = "16%"><%= addParams.getMinBidVariance()%>
<%
	String vartype="";
	if("P".equals(addParams.getVarianceType()))
	{
		vartype="%";
	}
	else
	{
		vartype=addParams.getCurrency();
	}
%>
   &nbsp;<%=vartype%></td>
    	<th align = "right" width = "8%" nowrap>Max. Bid Var.</th>
    	<td width = "15%"><%=addParams.getMaxBidVariance()%>&nbsp; <%=vartype%></td>
	</tr>

</table>

<Table align=center border=0 cellPadding=0 cellSpacing=0  width=90%>
 <TBODY>
 <Tr>
 <Td>
 	
  	<Table cellSpacing=0 cellPadding=0 width=100% border=0>
	<TBODY>
	<Tr>
	<Td vAlign=bottom  height=45 width=100%  class=blankcell>
	<Table cellSpacing=0 cellPadding=0 border=0 >
	<TBODY>
	<Tr>
		<!--
		<Td class=blankcell width=10 ><IMG name=startBack height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_front_left.gif" width=15 border=0></Td>
		<Td class=blankcell id="tab1_1" style="cursor:hand" background="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_fill_front.gif" onClick="showDiv('1')"><font id='tab1color' color=#000000>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Materials&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></Td>
		<Td class=blankcell width=10><IMG name="tab1_2" height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_front_right.gif" width=15  border=0></Td>
		<Td class=blankcell width=10><IMG name="tab1_3" height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_back1_left.gif" width=15 border=0></Td>
		<Td class=blankcell id="tab2_1" style="cursor:hand" background="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_fill_back.gif" onClick="showDiv('2')"><font id='tab2color' color=#ffffff>Terms And Conditions</font></Td>
		<Td class=blankcell width=10><IMG name="tab2_2" height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_back_right.gif" width=15 border=0></Td>
		<Td class=blankcell width=10 ><IMG name="tab2_3" height=27  src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_back2_left.gif" width=15 border=0></Td>
		<Td class=blankcell id="tab3_1" style="cursor:hand" background="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_fill_back.gif" onClick="showDiv('3')"><font id='tab3color' color=#ffffff>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Suppliers&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
		<Td class=blankcell width=10><IMG name="tab3_2" height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_back_right.gif" width=15 border=0></Td>
		<Td class=blankcell width=12><IMG name="tab3_3" height=27 src="../../Images/Buttons/<%=ButtonDir%>/Inbox_files/tab_back_end.gif" width=12 border=0></Td>
		-->
		
		
		<%
		java.util.Hashtable tabHash = new java.util.Hashtable();
		tabHash.put("TAB1","Materials");
		tabHash.put("TAB2","Terms & Conditions");
		tabHash.put("TAB3","Suppliers");
		
		for(int i=1;i<=3;i++)
		{
			%>
			<Td width=5 class='blankcell'><IMG id="tab<%=i%>_3" height=25 src="../../../../EzCommon/Images/Tabs/ImgLftUp.gif" width=5 border=0></Td>
			<Td id="tab<%=i%>_1" style="cursor:hand" style="background-image:url('../../../../EzCommon/Images/Tabs/ImgCtrUp.gif')" onClick="showDiv_new('<%=i%>',3)"><font id='tab<%=i%>color'><b>&nbsp;&nbsp;&nbsp;&nbsp;<%=(String)tabHash.get("TAB"+i)%>&nbsp;&nbsp;&nbsp;</b></font></Td>
			<Td width=10 class='blankcell'><IMG id="tab<%=i%>_2" height=25 src="../../../../EzCommon/Images/Tabs/ImgRgtUp.gif" width=10  border=0></Td>

		<%}%>
	
	</Tr>
	</TBODY>
	</Table>
	
	</Td>
	<Td class=blankcell vAlign=center align=right height=45>&nbsp; </Td>
	</Tr>
	</TBODY>
	</Table>
  </Td>
  </Tr>
</Table>

<div id="tab1" style="position:absolute;overflow:auto;height:250%;width:100%;visibility:hidden" align="center">
<div style="overflow:auto;position:absolute;height:100%;width:100%;left:0%;background-color:'#E6E6E6'">
<br>
<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=0 cellSpacing=0  width=80%>
<tr>
	<th width = "16%">Name</th>
	<th width = "14%">Specifications</th>
	<th width = "6%">UOM</th>
	<th width = "12%">Qty.</th>
	<th width = "10%">Required Date</th>
	<th width = "20%">Start Price (INR)</th>
	<th width = "14%">Reserve Price (INR)Hide
<%
	ezc.ezreverseauction.params.EziAuctionItemTable itemTable1= null;
	itemTable1=(ezc.ezreverseauction.params.EziAuctionItemTable)session.getValue("sessionLines");
	ezc.ezreverseauction.params.EziAuctionItemTableRow itemTableRow1=null;

	itemTableRow1= (ezc.ezreverseauction.params.EziAuctionItemTableRow)itemTable1.getRow(0);

     int itemCount = itemTable1.getRowCount();

	if("N".equals(itemTableRow1.getTargetShown()))
	{
%>
		<input type="checkbox" name="pricestatus" checked disabled>
<%
	}
	else
	{
%>
		<input type="checkbox" name="pricestatus"  disabled>
<%
	}
%>
</th>
</tr>

<%
     for(int i=0;i<itemCount;i++)
     {
     	itemTableRow1= (ezc.ezreverseauction.params.EziAuctionItemTableRow)itemTable1.getRow(i);
%>

<tr>
	<td width = "16%" align="left"><%=itemTableRow1.getItemCode()%></td>
	<%
	    if((itemTableRow1.getIsSpecExist()).equals("Y"))
	    {
			if(!"".equals(itemTableRow1.getExt2()))
			{

	%>

					<td width = "14%" align="center"><a href="JavaScript:funOpenFile('<%=itemTableRow1.getExt2()%>')" style="cursor:hand"><%=itemTableRow1.getExt1()%></a></td>

<%
			}
			else
			{
%>
				<td width = "14%" align="center"><%=itemTableRow1.getExt1()%></td>
<%
			}
%>

	<%  }else{  %>

		<td width = "14%">&nbsp;</td>

	<%  } %>

	<td width = "6%" align="center"><%=itemTableRow1.getUOM()%></td>
	<td width = "12%" align="right"><%=itemTableRow1.getQuantity()%><input type="hidden" name="materialname" value='<%=itemTableRow1.getItemCode()%>'>
<%
		ezc.ezreverseauction.params.EziAuctionDeliverablesTable deliverablesTable1= (ezc.ezreverseauction.params.EziAuctionDeliverablesTable)session.getValue("deliverables");
		String deliverablestr="";

		for(int j=0;j<deliverablesTable1.getRowCount();j++)
		{

			ezc.ezreverseauction.params.EziAuctionDeliverablesTableRow deliverablesTableRow1= (ezc.ezreverseauction.params.EziAuctionDeliverablesTableRow)deliverablesTable1.getRow(j);

			if(deliverablesTableRow1.getItemId().equals(""+(i+1)))
			{
				deliverablestr=deliverablestr+deliverablesTableRow1.getRequiredQuantity()+"*"+deliverablesTableRow1.getRequiredDate()+"~";

			}
		}
		if(!deliverablestr.equals(""))
			deliverablestr=deliverablestr.substring(0,deliverablestr.length()-1);
%>
			<input type="hidden" name="deliverables" value="<%=deliverablestr%>"></td>
<%
	if(!deliverablestr.equals("") && deliverablestr.indexOf("~")==-1)
	{
%>
		<td width = "10%" align="center"><%=deliverablestr.substring(deliverablestr.indexOf("*")+1,deliverablestr.length())%></td>
<%
	}
	else
	{
%>
		<td width = "10%" align="center"><a href="JavaScript:datesEntry(<%=i%>)" >View</a></td>
<%
	}
%>
	<td width = "20%" align="right"><%=itemTableRow1.getInitialPrice()%></td>
	<td width = "14%" align="right"><%=itemTableRow1.getTargetPrice()%></td>
</tr>



<%   }   %>
</table>
</div>
</div>


<div id="tab2" style="position:absolute;overflow:auto;height:250%;width:100%;visibility:hidden" align="center">
<div style="overflow:auto;position:absolute;height:100%;width:100%;left:0%;background-color:'#E6E6E6'">
<br>

<fieldset name="fieldset1" value="" style="width:80%;top:70%;height:22%" align="center">
	<legend><font color = "#336699" face = arial size = "2"><b>Delivery & Payment Terms</b></font></legend>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="100%">
	<Tr>
	<Th align="left" width=25%>Delivery Terms</Th>
	<Td width="25%"><%=incorb.getString(addParams.getIncoTerms())%></Td>
	<Th align="left" width=25%>Payment Terms</Th>
	<Td width="25%"><%=payrb.getString(addParams.getPaymentTerms())%></Td>
	</Tr>
	</Table>
</fieldset>

<fieldset name="fieldset1" value="" style="width:80%;top:70%;height:22%" align="center">
<%
	 ezc.ezupload.params.EziDocumentTextsTable docTable = (ezc.ezupload.params.EziDocumentTextsTable)session.getValue("longFields");
	 ezc.ezupload.params.EziDocumentTextsTableRow docTableRow =  null;

%>
<legend><font color = "#336699" face = arial size ="2"><b>Terms & Conditions</b></font></legend>
	<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="100%">
<%

	for(int i=0;i<docTable.getRowCount();i++)
	{
		docTableRow=(ezc.ezupload.params.EziDocumentTextsTableRow)docTable.getRow(i);
		if(docTableRow.getKey().equals("PACKING"))
		{
%>
			<Tr>
				<Th align="left" width="25%">Packing Instructions</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("LABEL"))
		{
%>

			<Tr>
				<Th align="left" width="25%">Label Instructions</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("INSPECTION"))
		{

%>
			<Tr>
				<Th align="left" width="25%">Inspection Clauses</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("HANDLING"))
		{
%>

			<Tr>
				<Th align="left" width="25%">Handling Specifications</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("REGULATORY"))
		{

%>
			<Tr>
				<Th align="left" width="25%">Regulatory Requirements</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("DOCUMENTS"))
		{

%>

			<Tr>
				<Th align="left"width="25%">Documents Required</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
		if(docTableRow.getKey().equals("OTHERS"))
		{
%>
			<Tr>
				<Th align="left" width="25%">Others</Th>
				<Td><%=docTableRow.getValue()%>&nbsp;</Td>
			</Tr>
<%
		}
	}
%>
	</Table>
</fieldset>
</div>
</div>
<div id="tab3" style="position:absolute;overflow:auto;height:250%;width:100%;visibility:hidden" align="center">
<div style="overflow:auto;position:absolute;height:100%;width:100%;left:0%;background-color:'#E6E6E6'">
<br>
<Table id="ezTab" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=0 cellSpacing=0  width=80%>
</table>
</div>
</div>
<div id="backdiv" align=center style="position:absolute;top:90%;width:100%;visibility:hidden">
<table align="center" >
<tr>
	<Td class=blankcell align=center>
	<%
				buttonName = new ArrayList();
				buttonMethod = new ArrayList();
				buttonName.add("Back");
				buttonMethod.add("funSupplier()");
				out.println(getButtonStr(buttonName,buttonMethod));
	%>
	
	</Td>
</tr>
</table>
</div>
</div>

<Div id="MenuSol"></Div>
</form>

</body>
</html>
