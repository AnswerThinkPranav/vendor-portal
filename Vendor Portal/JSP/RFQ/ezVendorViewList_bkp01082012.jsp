<%//@ include file="../../Library/Globals/errorPagePath.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%//@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iListSOS.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iGetVendorDesc.jsp"%>
<%@ page import="java.util.*" %>
<html>
<head>
<script>
var tabHeadWidth=90
var tabHeight="86%"
</script>

<Script>

var selVenlisttemp ="<%=request.getParameter("selVenlist")%>";
    selVenlisttemp = selVenlisttemp.replace('null','');
function SelectedVendors()
{
	//newWindow=window.open("ezSelectedVendors.jsp","myWin","width=750,height=550,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.target = "PopUp";
	document.myForm.action= "ezSelectedVendors.jsp";
	newWindow=window.open("","PopUp","width=550,height=350,left=150,top=90,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();
	document.myForm.target = "_self";
}
function VendorSearch()
{

	document.myForm.target = "PopUp";
	document.myForm.action= "ezVendorSearch.jsp";
	newWindow=window.open("","PopUp","width=750,height=550,top=90,left=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();
	document.myForm.target = "_self";

	//newWindow=window.open("ezVendorSearch.jsp","myWin","width=750,height=550,top=30,left=60,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
function createRFQ1()
{
	var len = document.myForm.chk1.length
	var soldTosStr="";
	var tempArr;
	var Count = 0;
	var selVenlist ="";
	
	var showSelVendNames = "Vendor Code\t\tVendor Name\n============================================\n";
	
	if(!isNaN(len))
	{

		for(var i=0;i<len;i++)
		{

		     if(document.myForm.chk1[i].checked)
		     {
			  Count++;
			  tempArr=(document.myForm.chk1[i].value).split("#")
			  
			  if(soldTosStr=="") soldTosStr=tempArr[0];
			  else soldTosStr=soldTosStr+","+tempArr[0];
			  
			  
			  showSelVendNames += tempArr[0]+'\t\t'+tempArr[1]+'\n';
			  
			 // selVenlist = selVenlist+"#"+document.myForm.selVen[i].value 
			
		     }
		}

		if(Count==0)
		{
		  alert("Please Select Vendors for Creating RFQ")
		  return;
		}

	}
	else
	{
	  if(!document.myForm.chk1.checked)
	   {
		alert("Please Select Vendor for Creating RFQ")
		return;
	   }else{
	   	tempArr=(document.myForm.chk1.value).split("#")
	   	soldTosStr=tempArr[0];
	   	
	   	showSelVendNames += tempArr[0]+'\t\t'+tempArr[1]+'\n';
	   }
	   
	  // selVenlist = selVenlist+"#"+document.myForm.selVen.value 

	}
	
	if(confirm("You have selected below Vendor(s) for creating RFQ.\n\n"+showSelVendNames+"\n\n Click on 'Ok' to proceed else click on 'Cancel'."))
     	{	
		document.myForm.soldTos.value=soldTosStr;
		document.myForm.selVenlist.value=selVenlisttemp;
		document.getElementById("ButtonDiv").innerHTML="<Table border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 ><Tr><Th>Please wait .Your Request is being Processed ...</Th></Tr></Table>"
		document.myForm.action="ezConfirmRFQ.jsp";
		document.myForm.submit();
	}	
}
function funBack()
{
	var backflag ='<%=backChk%>'; 
	if(backflag=='MULMAT')document.myForm.action="ezPreRFQSelectVendors.jsp";
	else if(backflag=='MAT')
		document.myForm.action="ezPreSelectVendors.jsp";
	else 
		document.myForm.action="ezListPR.jsp";
	/*if(backflag=='PRS')
		document.myForm.action="ezListPR.jsp";
	else
		document.myForm.action="ezListPR.jsp?Status=R";	
	*/	
	
	
	document.myForm.submit();
}
function getAgmtDtl(agmtNo)
{
	var url="ezGetAgreementDetails.jsp?agmtNo="+agmtNo;
	var sapWindow=window.open(url,"newwin","width=500,height=350,left=270,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}

function ezAlphabet(alphabet)
{
	document.myForm.tabNo.value='2';
	searchstring=alphabet+"*";
	if(searchstring=="All*")
		document.myForm.searchcriteria.value="";
	else
		document.myForm.searchcriteria.value=searchstring;
	if(searchstring!=null)
	{
		if(searchstring.length!=0)
		{
			document.myForm.selVenlist.value=selVenlisttemp;
			document.myForm.action="ezVendorViewList.jsp?";
			document.myForm.submit();
		}
	}
}


function createAuction()
{
	
   if(document.myForm.chk1!=null)
   {
	var len = document.myForm.chk1.length
	var Count = 0;
	var temp="";
	var selVenlist ="<%=request.getParameter("selVenlist")%>";
	
	
	
	var showSelVendNames = "Vendor Code\t\tVendor Name\n============================================\n";
	
	if(!isNaN(len))
	{
		 for(var i=0;i<len;i++)
		 {
		     if(document.myForm.chk1[i].checked)
		     {
			        Count++;
			        temp = temp+document.myForm.venDet1[i].value+"@";
			      //  selVenlist = selVenlist+"#"+document.myForm.selVen[i].value 
			      
			      tempArr=(document.myForm.chk1[i].value).split("#");
			      
			      showSelVendNames += tempArr[0]+'\t\t'+tempArr[1]+'\n';
		     }
		}
		
     	}
     	else
     	{
     		
     		if(document.myForm.chk1.checked)
		 {
			Count++;
			temp = temp+document.myForm.venDet1.value+"@";
			//selVenlist = selVenlist+"#"+document.myForm.selVen.value 
			
			  tempArr=(document.myForm.chk1.value).split("#");
			
			showSelVendNames += tempArr[0]+'\t\t'+tempArr[1]+'\n';
		 }
		
     	}
     	
     	document.myForm.venDet.value=temp;
     	document.myForm.selVenlist.value=selVenlisttemp;
     	
	if(Count<2)
	{
		  alert("Please Select atleast two Vendors for Creating Auction")
		  return;
	}
	
	if(confirm("You have selected below Vendor(s) for creating Auction.\n\n"+showSelVendNames+"\n\n Click on 'Ok' to proceed else click on 'Cancel'."))
     	{
		document.myForm.action="../Request/ezCreateAuction.jsp";
		document.myForm.submit();
	}	
     }
     else
     {
     	alert("There are no Vendors to Create Auction")
     }
    
}

function selVendList(obj,value)
{
	var len = document.myForm.chk1.length
	var Count = 0;
	var temp="";
	
	if(obj.checked)
		selVenlisttemp = selVenlisttemp+"#"+value
	else
	{
		value = "#"+value
		selVenlisttemp = selVenlisttemp.replace(value,'');
	}	
	/*if(!isNaN(len))
	{
		for(var i=0;i<len;i++)
		{
		     if(document.myForm.chk1[i].checked)
		     	selVenlist = selVenlist+"#"+document.myForm.selVen[i].value 		     
		}
	}
	else
	{
		if(document.myForm.chk1.checked)
		 	selVenlist = selVenlist+"#"+document.myForm.selVen.value 		 
	}*/
	
	//alert(obj.checked+"		"+selVenlisttemp)
     	document.myForm.selVenlist.value=selVenlisttemp;
     	
}

function showDiv(currentTab,totalTabs)
 {
	  for(var i=1;i<=totalTabs;i++)
	  {
		if(i==currentTab)
		{
			document.getElementById("tab"+i).style.visibility="visible"
			document.getElementById("tab"+i).style.width="100%"
			document.getElementById("tab"+i+"color").style.color="#000000"

			document.getElementById("tab"+i+"_3").src="../../../Offline/Images/Tabs/ImgLftUp.gif"
			document.getElementById("tab"+i+"_2").src="../../../Offline/Images/Tabs/ImgRgtUp.gif"
			document.getElementById("tab"+i+"_1").style.background="url('../../../Offline/Images/Tabs/ImgCtrUp.gif')"
		}
		else
		{
			document.getElementById("tab"+i).style.visibility="hidden"
			document.getElementById("tab"+i+"color").style.color="#B7B7B7"

			document.getElementById("tab"+i+"_3").src="../../../Offline/Images/Tabs/ImgLftDn.gif"
			document.getElementById("tab"+i+"_2").src="../../../Offline/Images/Tabs/ImgRgtDn.gif"
			document.getElementById("tab"+i+"_1").style.background="url('../../../Offline/Images/Tabs/ImgCtrDn.gif')"
			document.getElementById("tab"+i).style.width="0%"
		}
	  }

}
</Script>
<Script src="../../Library/JavaScript/Rfq/ezVendorViewList.js"></Script>
<Script src="../../Library/JavaScript/Trim.js"></Script>
</head>
<%
//out.println("venodorsCityHTvenodorsCityHT		"+venodorsCityHT);
	int tabCount = 1;
	java.util.Hashtable tabHash = new java.util.Hashtable();
	tabHash.put("TAB1","Source List");
	tabHash.put("TAB2","SAP Vendors");
		
	String tabNum = "1";
	if(request.getParameter("tabNo")!=null)
		tabNum = "2";
		
	String matStr		=request.getParameter("matStr");
	
	
%>
<body topmargin=0 rightmargin=0 leftmargin=0 onload="showDiv('<%=tabNum%>','<%=tabCount%>')" scroll=no>
<form name="myForm" method="post">
<input type="hidden" name="searchcriteria" value="$"> 
<input type="hidden" name="ccKey"   	   value="">
<input type="hidden" name="hbId" 	   value="">
<input type="hidden" name="taxCode"    	   value="">
<input type="hidden" name="headerText" 	   value="">
<input type="hidden" name="shipInstr" 	   value="">
<input type="hidden" name="flag" 	   value="false">
<input type="hidden" name="finalDelDate"   value="<%=finalDelDate%>">
<input type="hidden" name="backChk"        value="<%=backChk%>">


<input type="hidden" name="itemText" 	   value="">	
<%
	int  noOfVndrsDisplayed = 0;
	String display_header = "Vendors List";
%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Br>


<Table align=center border=0 cellPadding=0 cellSpacing=0  width=90% height="78%">
	<Tr height=10>
	<Td class='blankcell'>
		<%@ include file="../Misc/ezTabDisplay.jsp"%>	
	</Td>
	
	</Tr>
	<Tr>
	<Td valign="top" class='blankcell' style="background-color:'#E6E6E6'">	<BR>

		<Div id="tab1" style="overflow:auto;position:absolute;height:86%;width:100%;visibility:hidden">
			<%@ include file="ezListSOS.jsp"%>
		</Div>
		<Div id="tab2" style="position:absolute;height:86%;width:100%;visibility:hidden">
			<%@ include file="ezListIRL.jsp"%>
		</Div>
		
	</Td>
	</Tr> 
</Table>	

<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:90%">
<Span id="EzButtonsSpan">

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Back");
	buttonMethod.add("funBack()");
	
	
	if("MAT".equals(backChk))
	{   
		buttonName.add("Create Auction");
		buttonMethod.add("createAuction()");  
	}
	else if("MULMAT".equals(backChk))
	{   
		buttonName.add("Create RFQ");
		buttonMethod.add("createRFQ1()");  
	}
	else
	{
		buttonName.add("Create RFQ");
		buttonMethod.add("createRFQ1()");
		
		buttonName.add("Create Auction");
		buttonMethod.add("createAuction()");
	}
    
    	buttonName.add("Vendor Search");
	buttonMethod.add("VendorSearch()");

	//buttonName.add("Selected Vendors");
	//buttonMethod.add("SelectedVendors()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>

</Span>

	<Span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Td >Your request is being processed... Please wait</Td>
			</Tr>
		</Table>
	</Span>

</Div>
<Script> 
<%
	//System.out.println("^^^^^^^^^^^^^^^^^^^^6"+request.getParameter("tabNo"));
	if(request.getParameter("tabNo")!=null)
	{
%>
		//alert('<%=request.getParameter("tabNo")%>');
		showDiv(parseInt('<%=request.getParameter("tabNo")%>'));
<%
	}
%>
</Script>

<input type="hidden" name="noOfVndrsDisplayed" value="<%=noOfVndrsDisplayed%>">

<input type="hidden" name="qtnEndDate" value="">
<input type="hidden" name="delivDate"  value="">
<input type="hidden" name="commentText" value="">
<input type="hidden" name="collNo"     value="">
<input type="hidden" name="Status"     value="R">
<input type="hidden" name="purchReq1"  value="<%=purchReq%>">
<input type="hidden" name="vendor"  value="">
<input type="hidden" name="price"  value="26.00">
<input type="hidden" name="selItemCount"  value=<%=request.getParameter("selItemCount")%>>
<%
	/************* The following hidden fields are for PO Creation ******************/
%>

<input type="hidden" name="docType"   	   value="">
<input type="hidden" name="SOS" 	   value="SOS">	
<input type="hidden" name="purchaseHidden"   value="<%=purchReq%>">	
<input type="hidden" name="tabNo"   value="">	


<input type="hidden" name="matNo" value="<%=request.getParameter("matNo")%>">
<input type="hidden" name="selplant" value="<%=request.getParameter("selplant")%>">
<input type="hidden" name="fromDate" value="<%=request.getParameter("fromDate")%>">
<input type="hidden" name="toDate" value="<%=request.getParameter("toDate")%>">
<input type="hidden" name="matDesc" value="<%=request.getParameter("matDesc")%>">
<input type="hidden" name="selpurchReq" value="<%=request.getParameter("selpurchReq")%>">
<input type="hidden" name="selVenlist" value="">

<Script>
	var selVenlist = "<%=request.getParameter("selVenlist")%>";
	var selVenArr;
	if(selVenlist!=null && selVenlist!="null" && selVenlist!="")
	{
		selVenArr = selVenlist.split("#");
		
		var selvenlen = document.myForm.selVen.length
		if(isNaN(selvenlen))
		{
			if(funTrim(selVenArr[1])==funTrim(document.myForm.selVen.value))
				document.myForm.chk1.checked=true;
		}
		else
		{
			for(i=0;i<selvenlen;i++)
			{
				for(j=0;j<selVenArr.length;j++)
				{
					if(funTrim(selVenArr[j])==funTrim(document.myForm.selVen[i].value))
						document.myForm.chk1[i].checked=true;
				}	

			}
		}
	}
	
</Script>

<%	
	/************* The following is for storing pr details in db as for knowing RFQ created against PR(s) or not ******************/
	
	String purchRequisition[]=request.getParameterValues("purchReq");
	int prLen = 0;
	if(purchRequisition!=null)
		prLen = purchRequisition.length;
		
	for(int h=0;h<prLen;h++)
	{
%>		<input type=hidden name="purchReq" value="<%=purchRequisition[h]%>">
<%	}
%>

<input type="hidden" name="matStr"   value="<%=matStr%>">
<input type="hidden" name="venDet"   value="">
<input type="hidden" name="material"   value="<%=allMatStr%>">
<input type="hidden" name="soldTos"   value="">


<Div id="MenuSol"></Div>
</form>
</body>
</html>
