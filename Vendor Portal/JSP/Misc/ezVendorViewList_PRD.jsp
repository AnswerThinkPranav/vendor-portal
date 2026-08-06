<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>   
<%@ include file="../../../Includes/JSPs/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iListSOS.jsp" %>         
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorDesc.jsp"%>    
<%@ page import="java.util.*" %>
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>

<%!      
	public String checkNull(String str)  
	{ 
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str)) 
			retStr = "";
		else
			retStr = str;
			
		return retStr;	
	}
%>
</head>
<%
	int tabCount = 2;  
	java.util.Hashtable tabHash = new java.util.Hashtable();     
	tabHash.put("TAB1","SAP Vendors");
	tabHash.put("TAB2","Non SAP Vendors");	 
	//tabHash.put("TAB2","SAP Vendors");
	//tabHash.put("TAB3","Non SAP Vendors");	 
	
	String tabNum = "1";
	if(request.getParameter("tabNo")!=null)
		tabNum = "2";
		
	String frmBack=request.getParameter("frmBack");
	//out.println("frmBack=="+frmBack);
	String chkdIndx="";
	//String qcfPrev=request.getParameter("qcfPrev");
	//ezc.ezcommon.EzLog4j.log("::qcfPrev:::"+qcfPrev,"I");
	
	//String selArr[]=request.getParameterValues("purchReq");
	String concatStringNew=request.getParameter("concatString");
	ezc.ezcommon.EzLog4j.log("::concatStringNew:::"+concatStringNew,"I");
	String selArr[]= null;
	if(concatStringNew!=null)
	{
		if(concatStringNew.endsWith("##"))
			concatStringNew=concatStringNew.substring(0,concatStringNew.length()-2);
		//out.println("concatStringNew=="+concatStringNew);
	
		selArr=concatStringNew.split("##");
	}
	String prReqNo="",prItemNo="";
	String selPRs="";
	//out.println("selArr.length=="+selArr.length); 
	//ezc.ezcommon.EzLog4j.log("::selArr:::"+selArr.length,"I");
	int prLen = 0;
	String puReqTot="";
	
	if(concatStringNew!=null)
	{	
		for(int p=0;p<selArr.length;p++)
		{
			java.util.StringTokenizer stNew =new java.util.StringTokenizer(selArr[p],"$$");
			stNew.nextToken();stNew.nextToken();stNew.nextToken();
			stNew.nextToken();stNew.nextToken();stNew.nextToken();

			prReqNo   = stNew.nextToken();
			prItemNo   = stNew.nextToken();
			if(p==0)
			{
				selPRs=prReqNo+"_"+prItemNo;
			}
			else
			{
				selPRs=selPRs+"___"+prReqNo+"_"+prItemNo;
			}
			stNew.nextToken();
		}
		puReqTot=checkNull(request.getParameter("puReqTot"));
		
		//out.println("puReqTot"+puReqTot);
		if(!"".equals(puReqTot))
			prLen=puReqTot.split("#RFQ#").length;
		Hashtable fixedVendHT=new Hashtable();
		//out.println("prLen"+prLen);
		for(int v=0;v<prLen;v++)
		{ 
			String fixVend=(String)puReqTot.split("#RFQ#")[v];
			fixVend=fixVend.replace("$$","##");
			if(fixVend.split("##").length>11)
			{
				fixVend=fixVend.split("##")[11];
				//out.println(fixVend);
				fixedVendHT.put(fixVend,fixVend);
			}	
		}	
	}	
%>
<!-- Content Wrapper. Contains page content -->       
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Select Vendor
   </h1>  
</section>
<!-- Main content -->      
<section class="invoice"> 
<body topmargin=0 rightmargin=0 leftmargin=0 onload="showDiv('<%=tabNum%>','<%=tabCount%>')" scroll=no>
<form  name="myForm" method="post">
<input type="hidden" name="frmBack" value="">
<input type="hidden" name="searchcriteria" value="$">    
<input type="hidden" name="ccKey"   	   value="">
<input type="hidden" name="hbId" 	   value="">
<input type="hidden" name="taxCode"    	   value="">
<input type="hidden" name="headerText" 	   value=""> 
<input type="hidden" name="shipInstr" 	   value=""> 

<input type="hidden" name="itemText" 	   value="">	

			
			<%@ include file="../Misc/ezTabDisplay.jsp"%>	
 			<%//@ include file="ezListSOS.jsp"%> 
			<Div id="tab1">
			<%@ include file="ezListIRL.jsp"%> 
			</Div>
			<Div id="tab2">
			<%@ include file="ezNonSAPVendors.jsp"%>
			<%//@ include file="ezListAgents.jsp"%>
			</Div>

<!-- this row will not appear when printing --> 

<div id="rfqdiv" class="row no-print"> 
	<div class="col-xs-12">
  		<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="createRFQ()"> Next <i class="fa fa-arrow-right"></i></button>
		<button type="button" class="btn btn-primary pull-right" onclick="funBack1()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Go Back</button>
	</div>
</div>
<input type="hidden" name="material"   value="<%=matNo%>">
<input type="hidden" name="matDesc"    value="<%=matDesc%>">
<input type="hidden" name="reqDate"    value="<%=delDate%>">
<input type="hidden" name="quantity"   value="<%=qty%>">
<input type="hidden" name="uom"        value="<%=uom%>">
<input type="hidden" name="plant"      value="<%=plant%>">
<input type="hidden" name="reqNo"      value="<%=reqNo%>">
<input type="hidden" name="prItmNo"    value="<%=itmNo%>">
<input type="hidden" name="purGrp"    value="<%=valType%>">
<input type="hidden" name="qtnEndDate" value="">
<input type="hidden" name="delivDate"  value="">
<input type="hidden" name="commentText" value="">
<input type="hidden" name="collNo"     value="">
<input type="hidden" name="Status"     value="R">
<input type="hidden" name="purchReq1"  value="<%=purchReq%>">
<input type="hidden" name="vendor"  value="">
<input type="hidden" name="price"  value=""> 
<input type="hidden" name="prsSel"  value="<%=selPRs%>"> 
<input type="hidden" name="flag"  value="<%=backChk%>"> 
<input type="hidden" name="qcfPrev"  value="<%=qcfPrev%>">

<%
	/************* The following hidden fields are for PO Creation ******************/  

%>

<input type="hidden" name="docType"   	   value="">
<input type="hidden" name="valuationType"  value="<%=valType%>">
<input type="hidden" name="SOS" 	   value="SOS">	
<input type="hidden" name="purchaseHidden"   value="<%=purchReq%>">	
<input type="hidden" name="tabNo"   value="">	


<input type="hidden" name="matNo" value="<%=request.getParameter("matNo")%>">
<input type="hidden" name="selplant" value="<%=request.getParameter("selplant")%>">
<input type="hidden" name="fromDate" value="<%=request.getParameter("fromDate")%>">
<input type="hidden" name="toDate" value="<%=request.getParameter("toDate")%>">


<%	
	/************* The following is for storing pr details in db as for knowing RFQ created against PR(s) or not ******************/
	
	String purchRequisition[]=request.getParameterValues("purchReq"); 
	
	/*if(purchRequisition!=null)
		prLen = purchRequisition.length;*/
	//out.println("prLen"+prLen);		
	for(int h=0;h<prLen;h++)
	{
%>		<input type=hidden name="purchReq" value="<%=puReqTot.split("#RFQ#")[h]%>">
<%	}
%>
<input type="hidden" name="allSelVendors">
</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezFooter.jsp"%>
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
<script>
		window.closeModal = function(){
		    $('#woModal').modal('hide');    
		};
		
	</script>
<Script>

function funBack()
{
	var backflag ='<%=backChk%>';
	var prsSel='<%=selPRs%>';
	//alert("prsSel=="+prsSel);
	
	if(backflag=='MAT')
	{
		document.myForm.action="ezPreSelectVendors.jsp";
	}
	else 
	{
		document.myForm.frmBack.value="Y";
		document.myForm.action="ezListPR.jsp";
	}
		 
	document.myForm.submit();
	
}
function funBack1()
{
	history.go(-1);
	
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
			document.myForm.action="ezVendorViewList.jsp";
			document.myForm.submit();
		}
	}
} 

function showQMInfo(vendorNo)
{
	var material = document.myForm.material.value
	var plant = document.myForm.plant.value
	
	//var retValue = window.showModalDialog("ezQMInfo.jsp?material="+material+"&plant="+plant+"&vendor="+vendorNo,window.self,"center=yes;dialogHeight=35;dialogWidth=45;help=no;titlebar=no;status=no;minimize:yes")		
	$('iframe').attr("src","ezQMInfo.jsp?material="+material+"&plant="+plant+"&vendor="+vendorNo);
	$('#woModal').modal({show:true});
}

var chkVal = [];
var valArr = [];
function removeA(arr) {
    var what, a = arguments, L = a.length, ax;
    while (L > 1 && arr.length) {
	what = a[--L];
	while ((ax= arr.indexOf(what)) !== -1) {
	    arr.splice(ax, 1);
	}
    }
    return arr;
}
function onChgChk(x,ind,type)
{              
	console.log("oncheck::"+x);
	console.log("oncheck::"+ind);
	//var chkField = document.myForm.purchReq[ind]
	//alert(x.value);
	var vendChk = x.value.split("#")[1];
	//alert("vendChk>>>"+vendChk);
	var plant = <%=plant%>;
	//alert("plant>>>"+plant);
	if(type == 'S')
	{
		//alert("SAP Vendor");
		$.ajax({
			url: 'ezVendorBlockChk.jsp', 
			data: { "vendChk":vendChk,"plant":plant},
			type: 'POST',
			success: function(result) {
			result=$.trim(result); 
			//alert("result>>>"+result);
				if(result !='')
				{
					x.checked = false;
					if(result == 'X')
						alert("Selected Vendor: "+parseInt(vendChk)+" Blocked in SAP");
					else if(result == 'E')	
						alert("Selected Vendor:"+parseInt(vendChk)+" has not been cerated for purcahse org:"+plant);
				}
				if(x.checked)
				{
					chkVal.push(ind);
					valArr[ind]=x.value;
				}
				else
					removeA(chkVal,ind);				
			},
			error: function()
			{
				alert("error::");
			}
			
		});

	}
	else if(type=='N')
	{
		//alert("Non SAP Vendor");
		if(x.checked)
		{
			chkVal.push(ind);
			valArr[ind]=x.value;
		}
		else
			removeA(chkVal,ind);
	}		
	//alert("chkVal>>>"+chkVal);
	//alert("valArr>>>"+valArr);
	//console.log(valArr);
}

function onChgChk2(x,ind)
{              
	//console.log("oncheck::"+x);
	//console.log("oncheck::"+ind);
	//var chkField = document.myForm.purchReq[ind]
	//alert(x.value);
	if(x.checked)
	{
		chkVal.push(ind);
		valArr[ind]=x.value;
	}
	else
		removeA(chkVal,ind);
	//alert(chkVal);
	//console.log(valArr);
}

function onChgChk1(x,ind)
{              
	//console.log("oncheck::"+x);
	//console.log("oncheck::"+ind);
	//var chkField = document.myForm.purchReq[ind]
	//alert(x.value);
	var vendChk = x.value.split("#")[1];
	//alert("vendChk>>>"+vendChk);
	var plant = <%=plant%>;
	//alert("plant>>>"+plant);
	$.ajax({
		url: 'ezVendorBlockChk.jsp', 
		data: { "vendChk":vendChk,"plant":plant},
		type: 'POST',
		success: function(result) {
		result=$.trim(result); 
		//alert("result>>>"+result);
			if(result !='')
			{
				x.checked = false;
				alert("Selected Vendor: "+parseInt(vendChk)+" Blocked in SAP");
			}
		},
		error: function()
		{
			alert("error::");
		}
	});	
	if(x.checked)
	{
		chkVal.push(ind);
		valArr[ind]=x.value;
	}
	else
		removeA(chkVal,ind);
	//alert(chkVal);
	//console.log(valArr);
}

function funLoad()
{
	//alert("Hi Onload");
	var frmBack='<%=frmBack%>';
	if(frmBack=="Y")
	{
		var indexes='<%=chkdIndx%>';
		//alert("indexes=="+indexes);
		var indVal="";
		var indLen=0;
		if(indexes.lastIndexOf("##")!=-1)indLen=indexes.split("##").length;
		else indLen=1;
		//alert("indLen=="+indLen);
		if(indLen==1)
		{
			indVal=indexes;
			var chkValOnChange= eval("document.myForm.selChk["+indVal+"]");
			//console.log("onload::"+indVal);
			//console.log("onload::"+chkValOnChange);
			onChgChk(chkValOnChange,indVal,'S');
		}
		else
		{
			for(var i=0;i<indLen;i++)
			{
				indVal=indexes.split("##")[i];
				var chkValOnChange= eval("document.myForm.selChk["+indVal+"]");
				//console.log("onload::"+indVal);
				//console.log("onload::"+chkValOnChange);
				onChgChk(chkValOnChange,indVal,'S');
			}
		}
	}
}

function createPO()
{

	/*if(!checkRoleAuthorizations("ADD_PO"))
	{
		alert("You are not authorized to create Purchase Order");
		return;
	}*/
	
	
	
        appendQuantities();   
     	var len = document.myForm.selChk.length      
     	var Count = 0;
     	var valCount = 0; 
     	var vendType; 
     	if(!isNaN(len))
     	{
     		for(var i=0;i<len;i++)
     		{
    		     if(document.myForm.selChk[i].checked)
     		     {
			   Count++;										     			
			   var str = document.myForm.selChk[i].value
			//alert("*str**"+str);   
			   //alert(str);
			   var values = str.split("#")
			   if(values[0]=="-" && values[3]=="A")
			   {
				valCount++;		   
			   }
			   else if(values[3]=="S")
			   {
				vendType ="S";	
			   }
     		     }
     		}	
     	}
     	else
     	{
     		if(document.myForm.selChk.checked)
     		{
     		    Count++;	
     		    var str = document.myForm.selChk.value
     		    //alert("*else str**"+str);   
		    var values = str.split("#")		   
		    if(values[0]=="-"  && values[3]=="A")
		    {
		    	valCount++;
		    }
		     else if(values[3]=="S")
		    {
		    	vendType ="S";	
		    }
     		}
     	}
	if(vendType=="S")
	{
		alert("You can not Create PO with Non Approved Vendors");
		return;
	}
     	else if(Count == 0 || valCount > 0)	
     	{
     		alert("Please Select Vendor With Contract To Create PO");
     		return;
     	}
     	else if(Count > 1)	
     	{
     		alert("Please Select Only One Vendor With Contract To Create PO");
     		return;
     	}     
     	
     	var plantObj=document.myForm.plant;
	if(plantObj!=null && plantObj.value=="NA")
	{
		alert("You can't create PO without selecting plant,Please select plant from material search to create PO")
		return false;
	}
     	
     	var vndr = "";
     	var qty = "";
     	var len = document.myForm.selChk.length;
     	if(!(isNaN(len)))
     	{
		for(var i=0;i<len;i++)
		{
			if(document.myForm.selChk[i].checked)
			{
				vndr = document.myForm.selChk[i].value;
				qty =  document.myForm.qtyTxt[i].value;
			}	
		}
     	}
     	else
     	{
     		vndr = document.myForm.selChk.value;
     		qty =  document.myForm.qtyTxt.value;
     	}
     	var chkdStr = vndr.split("#");
   	
   	buttonsSpan	  = document.getElementById("EzButtonsSpan");
	buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
	if(buttonsSpan!=null)
	{
	     	buttonsSpan.style.display	= "none"
	        buttonsMsgSpan.style.display	= "block"
     	}
     	
     	var url = "ezPopPoCreate.jsp?vendor="+chkdStr[1]+"&Quantity="+qty+"&valtype="+document.myForm.valuationType.value;
	dialogvalue=window.showModalDialog(url,window.self,"center=yes;dialogHeight=30;dialogWidth=40;help=no;titlebar=no;status=no;resizable=no")
	
	if(dialogvalue=="SUBMIT")
	{
		document.myForm.action="ezCreatePOByPopUp.jsp";
		document.myForm.submit();
	}
	else
	if(dialogvalue=="Cancel")
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "block"
			buttonsMsgSpan.style.display	= "none"
     		}
	}
	else
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "block"
			buttonsMsgSpan.style.display	= "none"
		}

     	}
	
     	
/*     	
     	buttonsSpan	  = document.getElementById("EzButtonsSpan")
     	buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
     	if(buttonsSpan!=null)
     	{
     	      	buttonsSpan.style.display	= "none"
           	buttonsMsgSpan.style.display	= "block"
     	}
     	document.myForm.action = "ezCreatePO.jsp";
     	document.myForm.submit();
*/     	

}


function checkVendor()
{
	var vendChkObj 		= 	document.myForm.selChk
	var vendChkObjLen	=	vendChkObj.length
	var chkdValue 		= 	""
	var ezAppVendors 	= new Array()
	var ezAppAgents 	= new Array()
	var vndCount 	= 0;
	var agntCount 	= 0;

	/*
	if(!isNaN(vendChkObjLen))
	{
		for(i=0;i<vendChkObjLen;i++)
		{
			if(vendChkObj[i].checked)
			{
				chkdValue = (vendChkObj[i].value).split("#")
				if(chkdValue[3] == "A")
				{
					ezAppVendors[vndCount] = chkdValue[1]
					vndCount++
				}
				if(chkdValue[3] == "N")
				{
					ezAppAgents[agntCount] = ((chkdValue[1]).split("$"))[0]
					agntCount++
				}

			}
		}
	}
	*/
	
	for (e=0;e<chkVal.length;e++) 
	{
		try
		{
			var temChk = parseInt(chkVal[e]);
			chkdValue = temChk.split("#")
			if(chkdValue[3] == "A")
			{
				ezAppVendors[vndCount] = chkdValue[1]
				vndCount++
			}
			if(chkdValue[3] == "N")
			{
				ezAppAgents[agntCount] = ((chkdValue[1]).split("$"))[0]
				agntCount++
			}
		}catch(e)
		{
			//alert(e);
		}
	}
		

	vndCount	=	ezAppVendors.length;
	agntCount	=	ezAppAgents.length;

	var checkFlag = false

	for(i=0;i<vndCount;i++)
	{
		for(j=0;j<agntCount;j++)
		{
			if(ezAppVendors[i]	==	ezAppAgents[j]) 
			{
				alert("Agent for the selected approved vendor "+ezAppVendors[i]+" cannot be selected to create the RFQ")
				checkFlag = true
				break;
			}
		}
	}

	return checkFlag;
}


function createRFQ()
{
	var rfqFlag ='<%=backChk%>'; 
	if(qtyFun())
	{
					
		//appendQuantities();
		var reqDate = document.myForm.reqDate.value;
		var len = document.myForm.selChk.length
		var Count = 0;
		var valCount = 0; 
		var agrmntCount = 0;
		var soldTos = "";
		var selVal="";
		var chkVend="";
		var qcfNo="<%=qcfPrev%>";

		/*
		if(!isNaN(len))
		{
			for(var i=0;i<len;i++)
			{
				if(document.myForm.selChk[i].checked)
				{
					var str = document.myForm.selChk[i].value
					var values = str.split("#")		   
					if(values[0]=="AGR")
					{
						document.myForm.selChk[i].value = values[0]+"#"+values[1]+"#"+document.myForm.qtyTxt[i].value+"#"+"A";
						//alert(document.myForm.selChk[i].value);
						agrmntCount++;		   
					}
					else
					{
						valCount++;		   
					}

					if(Count == 0)
						soldTos = values[0]
					else	
						soldTos += ","+values[0]
					Count++;	
				}
			}	
		}
		else
		{
			if(document.myForm.selChk.checked)
			{

				var str = document.myForm.selChk.value      	    
				var values = str.split("#")		   
				if(values[0]=="AGR")
				{
					document.myForm.selChk.value = values[0]+"#"+document.myForm.qtyTxt.value+"#"+values[2]+"#"+"A";
					agrmntCount++;		   
				}
				else
				{
					valCount++;		   
				}
				soldTos = values[0]
				Count++;
			}
		}


		if(Count == 0)	
		{
			alert("Please Select Atleast One Vendor To Create RFQ");
			return;
		}


		if(agrmntCount > 0)
		{
			//alert("Please Select Only Vendors Without Contract To Create RFQ");  

			if(!confirm("Contract already exists for selected vendor(s).Do you want to create RFQ for selected vendor(s)?"))
			return;
		}
		*/
		
		if(chkVal.length == 0)
		{
			alert("Please Select Atleast One Vendor To Create RFQ");
			return;
		}
		//alert("chkValLength"+chkVal.length);

		for (i=0;i<chkVal.length;i++) 
		{
			try
			{
				var temChk = parseInt(chkVal[i]);
				//alert("temChk>>>"+temChk);
				var str =valArr[temChk];
				//alert("str>>"+str);
				var values = str.split("#")
				//alert("values>>>"+values[0]);
				if(values[0]=="AGR")
				{
					selVal = selVal+"##"+values[0]+"#"+values[1]+"#"+values[4]+"#"+"A";
					//alert(document.myForm.selChk[i].value);
					agrmntCount++;		   
				}
				else
				{
					selVal = selVal+"##"+"-#"+values[1]+"#"+values[4]+"#"+values[3]+"#"+values[2];
					if(chkVend==="")
						chkVend = values[1];
					else
						chkVend = chkVend +"','"+values[1];
					
					valCount++;		   
				}

				if(Count == 0)
					soldTos = values[0]
				else	
					soldTos += ","+values[0]
				Count++;	
				
			}catch(e)
			{
				//alert(e);
			}
		}
		//alert("selValnew=="+selVal);
		if(selVal.startsWith("##"))selVal=selVal.substring(2);
		document.myForm.allSelVendors.value=selVal;
		//alert("selValnew11=="+selVal);
		//alert("chkVend>>"+chkVend);
		
		
		if(agrmntCount > 0)
		{
			//alert("Please Select Only Vendors Without Contract To Create RFQ");  

			if(!confirm("Contract already exists for selected vendor(s).Do you want to create RFQ for selected vendor(s)?"))
			return;
		}

		if(checkVendor())
			return;

		var entryWindow;
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan"); 
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "none"  
			buttonsMsgSpan.style.display	= "block"
		}
		arguments = document.myForm.qtnEndDate.value;
		material  = document.myForm.material.value;
		matDesc	  = document.myForm.matDesc.value;
		
		//entryWindow = window.showModalDialog("ezEnterEndDate.jsp?reqDate="+reqDate+"&material="+material+"&soldTos="+soldTos+"&matDesc="+matDesc,arguments,"center=yes;dialogHeight=30;dialogWidth=30;help=no;titlebar=no;status=no;minimize:yes")
		//$('iframe').attr("src","ezEnterEndDate.jsp?reqDate="+reqDate+"&material="+material+"&soldTos="+soldTos+"&matDesc="+matDesc+"&qtnEndDate="+encodeURIComponent(document.myForm.qtnEndDate.value));
		//$('#woModal').modal({show:true});
		//alert(rfqFlag);
		
		var ChkCnt= 0;
		if(qcfNo!='')
		{
			var qcfPrevChk="<%=checkNull(qcfPrev)%>";
			//alert("qcfPrevChk>>>"+qcfPrevChk);
			
			$.ajax({
			    url: 'ezQCFVendorCheck.jsp', 
			    data: { "qcfNo":qcfNo,"chkVend":chkVend},
			    type: 'POST',
			    success: function(result) {
			      result=$.trim(result);  
			      if(result === 'true')
			      {
			      	ChkCnt++;
			      	//alert("count in if>>"+ChkCnt)
				alert("Selected Vendor(s) already exists in QCF:"+qcfNo);
				return;
			      }
		  	     else
		  	     {
				if(qcfPrevChk!='')
				{
					if(confirm("Are you sure you want to add RFQ(s) to QCF:"+qcfPrevChk+"?"))
					{
						document.myForm.action="ezAddRfqVendor.jsp?reqDate="+reqDate+"&material="+material+"&soldTos="+soldTos+"&matDesc="+matDesc+"&qtnEndDate="+encodeURIComponent(document.myForm.qtnEndDate.value);
						document.myForm.submit(); 
					}	
				}
				else
				{
					//document.myForm.action="ezEnterEndDate.jsp?reqDate="+reqDate+"&material="+material+"&soldTos="+soldTos+"&matDesc="+matDesc+"&qtnEndDate="+encodeURIComponent(document.myForm.qtnEndDate.value);
					document.myForm.action="ezEnterEndDate.jsp";
					document.myForm.submit(); 
				}	
		  	      }			       

			    }
			});
		  }
		  else
		  {
			//document.myForm.action="ezEnterEndDate.jsp?reqDate="+reqDate+"&material="+material+"&soldTos="+soldTos+"&matDesc="+matDesc+"&qtnEndDate="+encodeURIComponent(document.myForm.qtnEndDate.value);
			document.myForm.action="ezEnterEndDate.jsp";
			document.myForm.submit(); 
		  }	
		  	
     	}	
}	 

function fillEntryWindow(entryWindow)
{
	//alert(entryWindow);
	var entryWindowValues = entryWindow.split('##');
	document.myForm.qtnEndDate.value=entryWindowValues[0];
	document.myForm.commentText.value=entryWindowValues[1];
	document.myForm.collNo.value=entryWindowValues[2];
	document.myForm.delivDate.value=entryWindowValues[3];
	document.myForm.matDesc.value=entryWindowValues[4];
	document.myForm.action="ezCreateRFQ.jsp";
	document.myForm.submit(); 
	
	
}

function appendQuantities()
{
	if(document.myForm.selChk != null)
	{
		var approvedVendorLength = document.myForm.selChk.length
		if(!isNaN(approvedVendorLength))
		{
			for(i=0;i<approvedVendorLength;i++)
			{
				if(document.myForm.selChk[i].checked)
				{
			
					var chkdValue = document.myForm.selChk[i].value
					//alert("*chkdValue**"+chkdValue);
					var chkdArgs = chkdValue.split('#')
					if(chkdArgs[0] == "AGR")
						document.myForm.selChk[i].value = "AGR#"+chkdArgs[1]+"#"+chkdArgs[2]+"#"+document.myForm.qtyTxt[i].value+"#"+chkdArgs[3]
					else
						document.myForm.selChk[i].value = "-#"+chkdArgs[1]+"#"+document.myForm.qtyTxt[i].value+"#"+chkdArgs[3]+"#"+chkdArgs[2];
						
					//alert(i+"**"+document.myForm.selChk[i].value);
				}
			}
		}
		else
		{
			if(document.myForm.selChk.checked)
			{
				var chkdValue = document.myForm.selChk.value
				//alert("else *chkdValue**"+chkdValue);
				var chkdArgs = chkdValue.split('#')
				if(chkdArgs[0] == "AGR")
					document.myForm.selChk.value = "AGR#"+chkdArgs[1]+"#"+chkdArgs[2]+"#"+document.myForm.qtyTxt.value+"#"+chkdArgs[3]
				else	
					document.myForm.selChk.value = "-#"+chkdArgs[1]+"#"+document.myForm.qtyTxt.value+"#"+chkdArgs[3]+"#"+chkdArgs[2];
				//alert("else="+i+"**"+document.myForm.selChk[i].value);
			}	
		}
	}
}
function funShowVndrDetails(syskey,soldto)
{
	var url = "ezVendorContactDetails.jsp?SysKey="+syskey+"&SoldTo="+soldto;	
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
function closeIframe()
{
	   $('#woModal').modal('toggle');
}
function qtyFun()
{
	qtyFlag = true;
	var approvedVendorLength = document.myForm.selChk.length
	/*
	if(!isNaN(approvedVendorLength))
	{
		for(i=0;i<approvedVendorLength;i++)
		{
		
			if(document.myForm.selChk[i].checked)
			{
				var qtyObj	= document.myForm.qtyTxt[i];
				var qtyVal	= qtyObj.value;
				var qtyLen	= qtyVal.length;

				if(qtyVal.indexOf('.')!=-1)
				{
					if(qtyLen>13)
					{
						alert("Quantity value Exceeded")
						qtyFlag = false;
					}
					else
					{
						var substr = qtyVal.substring(qtyVal.indexOf('.')+1,qtyLen);
						if(substr.length>3)
						{
							alert("Quantity value Exceeded")
							qtyFlag = false;
							document.myForm.qtyTxt[i].focus();
							break;
						}	
					}
				}
				else
				{
					if(qtyLen>9)
					{
						alert("Quantity value Exceeded")
						qtyFlag = false;
						document.myForm.qtyTxt[i].focus();
						break;
					}

				}	
				
			}
		}
	}
	else
	{
		if(document.myForm.selChk.checked)
		{
			var qtyObj	= document.myForm.qtyTxt;
			var qtyVal	= qtyObj.value;
			var qtyLen	= qtyVal.length;

			if(qtyVal.indexOf('.')!=-1)
			{
				if(qtyLen>13)
				{
					alert("Quantity Exceeded")
					qtyFlag = false;
				}
				else
				{
					var substr = qtyVal.substring(qtyVal.indexOf('.')+1,qtyLen);
					if(substr.length>3){
						alert("Quantity value Exceeded")
						qtyFlag = false;
						document.myForm.qtyTxt.focus();
					}	
				}				
			}
			else
			{
				if(qtyLen>9)
				{
					alert("Quantity value Exceeded")
					qtyFlag = false;
					document.myForm.qtyTxt.focus();
					//break;
				}

			}
					
		}
	}
	*/
	
	for (i=0;i<chkVal.length;i++) 
	{
		try
		{
			var qtyObj 	= parseInt(chkVal[i]);
			var qtyVal	= valArr[temChk].split("#")[4];
			var qtyLen	= qtyVal.length;

			if(qtyVal.indexOf('.')!=-1)
			{
				if(qtyLen>13)
				{
					alert("Quantity Exceeded")
					qtyFlag = false;
				}
				else
				{
					var substr = qtyVal.substring(qtyVal.indexOf('.')+1,qtyLen);
					if(substr.length>3){
						alert("Quantity value Exceeded")
						qtyFlag = false;
						//document.myForm.qtyTxt[i].focus();
					}	
				}				
			}
			else
			{
				if(qtyLen>9)
				{
					alert("Quantity value Exceeded")
					qtyFlag = false;
					//document.myForm.qtyTxt[i].focus();
					//break;
				}
			
			}
		}catch(e)
		{
			//alert(e);
		}
	}
	return qtyFlag;
}

</Script>
<script>
	$(document).ready( function () { funLoad()
	} );
</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
   /*
       $('#example').dataTable( {
   	"dom": 'T<"clear">lfrtip',
   	"lengthMenu": [[5, 10, 20, -1], [5, 10, 20, 'All']],
   	"oTableTools": {
   	
   	    "sSwfPath": "../../../../EzCommon/Library/dataTables/swf/copy_csv_xls_pdf.swf",
   	    "aButtons": [
   	     
   				{
   					"sExtends":    "xls",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as Excel",
   					"sTitle": "report", // Excel file name
   					 "sToolTip": "Save as Excel"
   
   				},
   				{
   					"sExtends":    "pdf",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as PDF",
   					"sTitle": "report",
   					 "sToolTip": "Save as PDF"
   
   				}
   		
   
   			]
   	}
   	 
       } );*/
       $("#myInput").on("keyup", function() {
           var value = $(this).val().toLowerCase();
           $("#myTable tr").filter(function() {
             $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
           });
  	});
  	$("#myInput1").on("keyup", function() {
	           var value = $(this).val().toLowerCase();
	           $("#myTable1 tr").filter(function() {
	             $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	           });
  	});
   } );
   
   function showDiv(currentTab,totalTabs)
    {
    	//alert("currentTab>>"+currentTab);
    	//alert("totalTabs>>"+totalTabs);
   	  for(var i=1;i<=totalTabs;i++)
   	  {
   		if(i==currentTab)
   		{
   			document.getElementById("tab"+i).style.visibility="visible";
   			document.getElementById("tab"+i+"color").style.color="#000000";
   			document.getElementById("tab"+i+i).style.display="block";
   			
   
   			//document.getElementById("tab"+i+"_3").src="../../../Offline/Images/Tabs/ImgLftUp.gif"
   			document.getElementById("tab"+i+"_2").src="../../../Offline/Images/Tabs/ImgRgtUp.gif"
   			document.getElementById("tab"+i+"_1").style.background="url('../../../Offline/Images/Tabs/ImgCtrUp.gif')"
   		}
   		else
   		{
   			document.getElementById("tab"+i).style.visibility="hidden";
   			document.getElementById("tab"+i+"color").style.color="#B7B7B7";
   			document.getElementById("tab"+i+i).style.display="none";
   			
   			
   			//document.getElementById("tab"+i+"_3").src="../../../Offline/Images/Tabs/ImgLftDn.gif"
   			document.getElementById("tab"+i+"_2").src="../../../Offline/Images/Tabs/ImgRgtDn.gif"
   			document.getElementById("tab"+i+"_1").style.background="url('../../../Offline/Images/Tabs/ImgCtrDn.gif')"
   			
   			
   		}
   	  }
   
}
   
   	
</script>