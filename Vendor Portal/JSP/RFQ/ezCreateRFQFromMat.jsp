<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>  
<style>

.modal-dialog {
  position: fixed;
  width: 50%;
  margin: 0;
  padding: 10px;
}
</style>

<%
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRow.setQuery("SELECT EP_PLANT,EP_NAME1 FROM EZC_PLANTS");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		plantObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
	
	}
	catch(Exception e)
	{
		//out.println("Exception in getting Item Category List:::::"+e);
	}
	
%>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
	<h1>
	      Create RFQ from Material
	</h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post" id="formid">
<input type=hidden name="puReqTot">
<input type="hidden" name="saveSubStatus">
<input type="hidden" name="backChk" value="FROMMAT">
<%
	String toDayDate="";
	toDayDate=fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.DDMMYYYY);
%>
<input type =hidden name="toDayDate" value="<%=toDayDate%>">
<input type =hidden name="toDayDateOriginal" value="<%=toDayDate%>">
<input type =hidden name="selPlant" value=''>
<!-- Table row -->
      <div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table id="ezRCItemTab" class="table table-bordered">
	<Tr>
		<Th align="center"><b><!--<a href="javascript:addLine()"><font color="red" >[+]</font></b></a>-->Item No</Th>
		<Th align='center'>Plant</Th> 
		<Th align='center'>Material</Th>
		<Th align='center'>ShortText</Th> 
		<!--<Th align='center'>ShortText</Th> -->
		<Th align='center'>UOM</Th>
		<Th align='center'>Quantity</Th>
		<Th align='center'>Delivery Date</Th> 
	</Tr> 
<%
	for(int m=0;m<1;m++)
	{
		int lineItemNo = (m+1)*10; 
		
%>
	<Tr>
		<Td  align="center">
			<input type="text" class="form-control tx" name="itemNumber<%=m%>" id="itemNumber<%=m%>" readonly value="<%=lineItemNo%>">
			<input type="hidden" name="tItemNumber" value="<%=lineItemNo%>" >
			<input type="hidden" name="matGroup<%=m%>" value=''>
		</Td>
		<Td>
			<select name="selplant<%=m%>" id="selplant<%=m%>" class="form-control select2" style="width:100% !important"> 
			<option value="">-- Select--</option>
<%	
		int plantLen   = plantObj.getRowCount();
		for(int j=0;j<plantLen;j++)
		{
			out.println("<option value="+plantObj.getFieldValueString(j,"EP_PLANT").trim()+">"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"->"+plantObj.getFieldValueString(j,"EP_NAME1")+"</option>");
		}
%>
			</select>
		</Td>
		<Td align="center">
			<!--<input type="text" class="form-control" name="matNumber<%=m%>" id="matNumber<%=m%>"  maxlength="18" value="">
			<img src="../../../../EzCommon/Images/Banner/search.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=search(<%=m%>)>-->
			<div class="input-group">
				  <input class="form-control input-sm" type="text" name="matNumber<%=m%>" id="matNumber<%=m%>" value="400149" readonly>
				  <label for="matNumber<%=m%>" onClick=search(<%=m%>) class="input-group-addon btn"><span id="matSearch" class="fa fa-search-plus"></span></label>  
			 </div>
		</Td>
		<Td  align="center">
					<input type="text" class="form-control" name="matDesc<%=m%>" id="matDesc<%=m%>"  maxlength="200" value="CB Selecta WB 745x320x555mm 5 PLY" readonly>
		</Td>
		<Td><input type="text" class="form-control" name="rfqUOM<%=m%>" id="rfqUOM<%=m%>"  maxlength="15" value="EA" readonly></Td>
		<Td><input type="text" class="form-control" name="rfqQty<%=m%>" id="rfqQty<%=m%>"  maxlength="7" value=""  onBlur=checkNumeric(this,"QTY")/></Td>
		<Td>
		<div class="input-group">
			  <input class="form-control input-sm" type="text"  name="delDt<%=m%>" id="delDt<%=m%>" value="" readonly>
			  <%=getDateImage("delDt"+m)%> 
		</div>
		</Td>			
	</Tr>
<%
	//out.println("row count::::"+lineItemNo);   
	}
%>
</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	
<div class="row no-print">
	<div class="col-xs-12">
		<button type="button" class="btn btn-primary pull-right" onclick="getSource()" style="margin-right: 5px;"><i class="fa fa-arrow-right"></i> Get Sources</button>
		<button type="button" class="btn btn-primary pull-right" onclick="addLine()" style="margin-right: 5px;"><i class="fa fa-plus-circle"></i> Add Line</button>
		<button type="button" name="delbut" id="delbut"  class="btn btn-primary pull-right" onclick="delLine()" style="margin-right: 5px;"><i class="fa fa-times-circle"></i> Delete Line</button>
		
		</div>
		</div>

 

<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal"  class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe  id="iframeid" src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
         
      </div>
   </div>
</div>
</form>
</section>

<%@ include file="../Misc/ezFooter.jsp"%>


<Script src="../../Library/JavaScript/ezTrim.js"></Script>

<script>
$(function() {
$('#nav')
    .stop()
    .animate({'marginRight':'-100px'},1000, function() { $(this).addClass('closed'); });

  function toggleDivs() {
    var $inner = $("#nav");
    var $img = $(".nav-btn img", $inner);

    if ($inner.hasClass('closed')) {
      $inner.animate({ right: "100px" }); 
      $img.attr('alt', 'close');
    } else {
      $inner.animate({ right: 0 });
      $img.attr('alt', 'open');
    }

    $inner.toggleClass('closed');
  }
$(".nav-btn").bind("click", function(){
    toggleDivs();
});

});
/*function getSetup(filedName,buttonId)
{
	var cal = new Zapatec.Calendar.setup({
		inputField     : filedName,    	// id of the input field
		ifFormat       : "%d/%m/%Y",   	//  of the input field
		//date	       : "<%=cMonth%>"+"/"+"<%=cDate%>"+"/"+"<%=cYear%>",
		button         : buttonId  // trigger button (well, IMG in our case)		
	});
	return cal;	
}*/
function addLine()
{
	var tabObj		= document.getElementById("ezRCItemTab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	var itemNumber_JS	= parseFloat(rowCountValue)*10;
	
	var myRCObj=eval("document.myForm.tItemNumber");
	var myRCObjLen=myRCObj.length;
	if(isNaN(myRCObjLen)) myRCObjLen="1";
	
	eleAlign = new Array();
	eleVal   = new Array();

	eleAlign[0] = "center";
	eleAlign[1] = "left";
	eleAlign[2] = "left";
	eleAlign[3] = "left";
	eleAlign[4] = "left";
	eleAlign[5] = "left";
	eleAlign[6] = "left";
	
	eleVal[0] ='<input type="text" class="form-control" name="itemNumber'+myRCObjLen+'" readonly value="'+itemNumber_JS+'"><input type="hidden" name="tItemNumber" value="'+itemNumber_JS+'" ><input type="hidden" name="matGroup'+myRCObjLen+'" value="">';
	eleVal[1] ='<select name="selplant'+myRCObjLen+'" id="selplant'+myRCObjLen+'" class="form-control select2" style="width:100% !important">'; 
	eleVal[1]=eleVal[1]+'<option value="">-- Select--</option>';
	
		<%			int plantLen   = plantObj.getRowCount();
					for(int j=0;j<plantLen;j++)
					{
		%>eleVal[1]=eleVal[1]+'<option value="<%=plantObj.getFieldValueString(j,"EP_PLANT").trim()%>"><%=plantObj.getFieldValueString(j,"EP_PLANT").trim()%>-><%=plantObj.getFieldValueString(j,"EP_NAME1")%></option>';
		<%			
					}
		%>
	eleVal[1] =eleVal[1]+'</select>';
	eleVal[2] ='<div class="input-group"><input class="form-control input-sm" type="text" name="matNumber'+myRCObjLen+'" id="matNumber'+myRCObjLen+'" value="" readonly><label for="matNumber'+myRCObjLen+'" onClick=search('+myRCObjLen+') class="input-group-addon btn"><span class="fa fa-search-plus"></span></label></div>'
	eleVal[3] ='<input type="text" class="form-control" name="matDesc'+myRCObjLen+'" id="matDesc'+myRCObjLen+'" maxlength="200" value="" readonly>';
	eleVal[4] ='<input type="text" class="form-control" name="rfqUOM'+myRCObjLen+'" id="rfqUOM'+myRCObjLen+'" value="" readonly>';
	eleVal[5] ='<input type="text" class="form-control" name="rfqQty'+myRCObjLen+'" id="rfqQty'+myRCObjLen+'"   maxlength="7" value="" onBlur=checkNumeric(this,"QTY") >';	
	
	eleVal[6] ='<div class="input-group"><input class="form-control input-sm" type="text"  name="delDt'+myRCObjLen+'" id="delDt'+myRCObjLen+'" value="" readonly>';
	eleVal[6] =eleVal[6]+'<label for="fromDate" class="input-group-addon btn" id="buttdelDt'+myRCObjLen+'"><span class="glyphicon glyphicon-calendar"></span></label>';  
	eleVal[6] =eleVal[6]+'<script>getSetup(\'delDt'+myRCObjLen+'\',\'buttdelDt'+myRCObjLen+'\');</';
	eleVal[6] =eleVal[6]+'script>';
	eleVal[6] =eleVal[6]+'</div>';
	


	
	
	
	
	
	var rowId = tabObj.insertRow(rowCountValue);
	for(i=0; i<eleVal.length;i++){
		var cell0=rowId.insertCell(i);
		cell0.align = eleAlign[i];
		cell0.innerHTML =eleVal[i];
	}
	getSetup("delDt"+myRCObjLen,"buttdelDt"+myRCObjLen); 
	$(".datePickObj").datepicker({ 
	       	format: 'dd/mm/yyyy', 
       }); 
	
}
function delLine()
{
	var tabObj		= document.getElementById("ezRCItemTab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	//alert(rowCountValue);
	var rowCnt=rowCountValue-1;
	if(rowCnt>1)
		var rowId = tabObj.deleteRow(rowCnt);
	

}
function getSource()
{
	var tabObj		= document.getElementById("ezRCItemTab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	var myRCObj=eval("document.myForm.tItemNumber");
	var myRCObjLen=myRCObj.length;
	var dd;
	
	if(isNaN(myRCObjLen)) myRCObjLen="1";
	//alert("myRCObjLen"+myRCObjLen);
	var dataArr= new Array();
	todayArr=(document.myForm.toDayDateOriginal.value).split(".")
	currDay =new Date(todayArr[2],(todayArr[1]-1),todayArr[0])
	//alert("currDay"+currDay);
	var puReqTot='';
	for(var k=0;k<myRCObjLen;k++)
	{
	var input1 = document.createElement("input");
	
	input1.setAttribute("type", "hidden");
	
	input1.setAttribute("name", "purchReq");
	
	var input2 = document.createElement("input");
		
	input2.setAttribute("type", "hidden");
		
	input2.setAttribute("name", "purchaseHidden");
	
	var input3 = document.createElement("input");
	
	input3.setAttribute("type", "hidden");
		
	input3.setAttribute("name", "concatString");	
	
	

	var material=document.getElementById("matNumber"+k).value;
	var plant=document.getElementById("selplant"+k).value;
	var qty=document.getElementById("rfqQty"+k).value;
	
	
	var uom=document.getElementById("rfqUOM"+k).value;
	var matDesc=document.getElementById("matDesc"+k).value;
	var delDateObj=document.getElementById("delDt"+k).value;
	
	/*
	if(k==0){dd=delDateObj;}*/
	dd=delDateObj;
//	alert(k+dd);
	var prno="RFQ";
	var itemno="RFQ";
	var valType="RFQ";
	var itmText="RFQ";
	var poText="RFQ";
	var h=k+1;
	
	h=parseInt(h*10);
	if(plant=='')
	{
		alert("Please select PLANT for line no"+h);
		return;
	}
	if(material=='')
	{
		alert("Please select material for line no"+h);
		return;
	}
	
	/*if(delDateObj.value=="")
	{
		alert("Please enter the Del Date."+h);
		delDateObj.focus()
		return
	}*/
	/*if(k==1){dd="28/03/2019";}*/
	tempDelvDateArr = dd.split("/");
	tempDelvDate =new Date(tempDelvDateArr[2],(tempDelvDateArr[1]-1),tempDelvDateArr[0]);
	if(tempDelvDate<currDay)
	{
		alert("Delivery date must be greater than Today's date")
		delDateObj=""
		delDateObj.focus()
		return
	}
	if(qty=='')
	{
		alert("Please enter quantity for line no"+h);
		return;
		
	}
	
	
	
	dataArr[k]= material+"$$"+plant+"$$"+dd+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itemno+"$$"+valType+"$$"+itmText+"$$"+poText;
	if(puReqTot=='')
		puReqTot=material+"$$"+plant+"$$"+dd+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itemno+"$$"+valType+"$$"+itmText+"$$"+poText;
	else
		puReqTot=puReqTot+"#RFQ#"+material+"$$"+plant+"$$"+dd+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itemno+"$$"+valType+"$$"+itmText+"$$"+poText;
	//alert(dataArr[k]);
	input1.setAttribute("value", dataArr[k]);
	input2.setAttribute("value", dataArr[k]);
	input3.setAttribute("value", dataArr[k]);
	document.getElementById("formid").appendChild(input1);
	document.getElementById("formid").appendChild(input2);
	document.getElementById("formid").appendChild(input3);
	//alert(document.myForm.concatString.value);
	
	}
	//alert(puReqTot+"puReqTot");
	document.myForm.puReqTot.value=puReqTot;
	document.myForm.action			= "ezVendorViewList.jsp";
	document.myForm.submit();

}
function addLineWithInfo(material,desc,uom,price,vendor,matGrp)
{
	document.getElementById("delbut").style.visibility="visible";
	var tabObj		= document.getElementById("ezRCItemTab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	
	
	
	var itemNumber_JS	= parseFloat(rowCountValue)*10;
	
	var myRCObj=eval("document.myForm.tItemNumber");
	var myRCObjLen=myRCObj.length;
	if(isNaN(myRCObjLen)) myRCObjLen="1";
	
		
	eleWidth = new Array();
	eleAlign = new Array();
  	eleVal   = new Array();

	eleWidth[0]  = "10%";	eleAlign[0] = "center";
	eleWidth[1]  = "20%";	eleAlign[1] = "center";
	eleWidth[2]  = "30";	eleAlign[2] = "center";
	eleWidth[3]  = "10%";	eleAlign[3] = "center";
	eleWidth[4]  = "10%";	eleAlign[4] = "center";
	eleWidth[5]  = "10%"; 	eleAlign[5] = "center";
	
	
	eleVal[0] ='<input type="text" class="form-control" name="itemNumber'+myRCObjLen+'" readonly size="5" value="'+itemNumber_JS+'"><input type="hidden" name="tItemNumber" value="'+itemNumber_JS+'" ><input type="hidden" name="matGroup'+myRCObjLen+'" value="'+matGrp+'">';
	eleVal[1] ='<input type="text" class="form-control" name="matNumber'+myRCObjLen+'"  size="30" maxlength="18" value="'+material+'" onKeyPress=" return onlyNumbers()"><img src="../../../../EzCommon/Images/Banner/search.gif" name="findMat" style="cursor:hand" height="18" alt="Find" onClick=search("'+myRCObjLen+'")>';
	eleVal[2] ='<input type="text" class="form-control" name="matDesc'+myRCObjLen+'"  size="45" maxlength="200" value="'+desc+'">';
	eleVal[3] ='<input type="text" class="form-control" name="prUOM'+myRCObjLen+'"  size="10" value="'+uom+'">';
	eleVal[4] ='<input type="text" class="form-control" name="prQty'+myRCObjLen+'"  size="12" maxlength="7" value="" onBlur=checkNumeric(this,"QTY")>';
	eleVal[5] ='<input type="text" class="form-control" name="delvDate'+myRCObjLen+'"  size=11 value="'+document.myForm.toDayDate.value+'" readonly> <img src="../../Images/calender.gif" style="cursor:hand" height="20" onClick=showCal("document.myForm.delvDate'+myRCObjLen+'",120,500,"<%=cDate%>","<%=cMonth%>","<%=cYear%>") >';
	
	
	


	var rowId = tabObj.insertRow(rowCountValue);
	for(i=0; i<eleVal.length;i++){
		var cell0=rowId.insertCell(i);
		cell0.width = eleWidth[i];
		cell0.align = eleAlign[i];
		cell0.innerHTML =eleVal[i];
	}

	
	
}
function closeIframe()
{
	   $('#woModal').modal('toggle'); 
} 
function checkMatType(obj)
{
	if(obj.checked)
		obj.value='Y'
	else
		obj.value='N'
}

function search(index) 
{
	var plantObj= eval(document.getElementById("selplant"+index)); 
	var selPlant = plantObj.value;
	if(selPlant=="")
	{
		alert("Please select Plant");
		plantObj.focus()
		return
	}
	var url="ezMatSearchOptions.jsp?myIndex="+index+"&selPlant="+selPlant+"&SAP=Y";
	//newWindow=window.open(url,"ReportWin","width=500,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
	$('.modal-dialog').draggable({
			    handle: ".modal-body"
	});	

}
function checkNumeric(numObj,type)
{	//alert(numObj.value);
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
function createPR()
{ 
	var tabObj		= document.getElementById("ezRCItemTab")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	

	var successMat = 0
	todayArr=(document.myForm.toDayDateOriginal.value).split(".")
	currDay =new Date(todayArr[2],(todayArr[1]-1),todayArr[0])
	for(k=0;k<parseFloat(rowCountValue)-1;k++)
	{
		matObj = eval("document.myForm.matNumber"+k)
		matDescObj = eval("document.myForm.matDesc"+k)
		uomObj = eval("document.myForm.prUOM"+k)
		delDateObj= eval("document.myForm.delvDate"+k)
		todayArr=(document.myForm.toDayDateOriginal.value).split(".")
		currDay =new Date(todayArr[2],(todayArr[1]-1),todayArr[0])
		if(matObj.value!='' || matDescObj.value!='')
		{
			qtyObj = eval("document.myForm.prQty"+k)
			valPriceObj = eval("document.myForm.valPrice"+k)

			if(delDateObj.value=="")
			{
				alert("Please enter the Del Date.");
				delDateObj.focus()
				return
			}	
			tempDelvDateArr = (delDateObj.value).split(".");
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
			
			if(valPriceObj.value=='')
			{
				alert('Please enter valuation price')
				valPriceObj.focus()
				return
			}
			
			successMat++
			
		}
	}
	if(successMat==0)
	{
		alert('Requisition cannot be created with no line items')
		return
	}
	var y = confirm("PR will be created for "+successMat+" line item(s) \n Click on OK to confirm");
	
	if(y)
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan")
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
		if(buttonsSpan!=null)
		{
		buttonsSpan.style.display	= "none"
		buttonsMsgSpan.style.display	= "block"
		}

		document.myForm.action="ezCreateSAPPR.jsp"; 
		document.myForm.submit();
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
function funcRemarks(index)
{
	var remarks = eval("document.myForm.remarks"+index).value
	var newRemarks = eval("document.myForm.newRemarks"+index).value
	newWindow=window.open("ezAddViewRemarks.jsp?index="+index+"&remarks="+remarks+"&newRemarks="+newRemarks,"Remarks","width=700,height=350,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
</script>
<script>
   $(document).ready(function() {
       $(".datePickObj").datepicker({ 
       	format: 'mm/dd/yyyy', 
       }); 
   });
</script>