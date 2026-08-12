<%
/*******This file is included in pages RFQ\ezRequote.jsp and RFQ\ezNonSAPRfqQuote.jsp and RFQ\ezPostQuote.jsp************/
%>
<script>
function SubmitQuote()
{
<%

	if("TO_QUOTE".equals(fromPage) || "NON_SAP_QUOTE".equals(fromPage))
	{
%>
		var quoteRefNo 		= document.myForm.quoteRefNo.value;
		var priceValidUpto 	= document.myForm.priceValidUpto.value;
		var rfqPayTerms 	= document.myForm.rfqPayTerms.value;
		var rfqIncoTerms1 	= document.myForm.rfqIncoTerms1.value;
		var rfqIncoTerms2 	= document.myForm.rfqIncoTerms2.value;
		var rfqDelvPeriod 	= document.myForm.rfqDelvPeriod.value;
		var rfqGrtyPeriod 	= document.myForm.rfqGrtyPeriod.value;
		//var applTax 		= document.myForm.applTax.value;

		if(quoteRefNo=='')
		{
			alert("Please enter quote reference number");
			document.myForm.quoteRefNo.focus();
			return;
		}
		if(priceValidUpto=='')
		{
			alert("Please select Price valid Upto Date");
			document.myForm.priceValidUpto.focus();
			return;
		}
		if(rfqIncoTerms1=='')
		{
			alert("Please select Inco Terms1");
			document.myForm.rfqIncoTerms1.focus();
			return;
		}
		if(rfqIncoTerms2=='')
		{
			alert("Please enter Inco Terms2");
			document.myForm.rfqIncoTerms2.focus();
			return;
		}
		if(rfqPayTerms=='')
		{
			alert("Please enter Payment Terms");
			document.myForm.rfqPayTerms.focus();
			return;
		}

		if(rfqDelvPeriod=='')
		{
			alert("Please enter Delivery Period");
			document.myForm.rfqDelvPeriod.focus();
			return;
		}
		if(rfqGrtyPeriod=='')
		{
			alert("Please enter Delivery Guarantee");
			document.myForm.rfqGrtyPeriod.focus();
			return;
		}
		
		/*if(applTax=='')
		{
			alert("Please select Applicable Tax");
			document.myForm.applTax.focus();
			return;
		}*/
		var rfqItemObj  = document.myForm.rfqItem;
		var rfqItemObjLen = rfqItemObj.length;

		var rfqItemNo;

		if(isNaN(rfqItemObjLen))
		{
			rfqItemNo = document.myForm.rfqItem.value;
			
			applTaxType	= eval("document.myForm.applTax"+rfqItemNo).value;
			if(applTaxType=='')
			{
				alert("Please select Applicable Tax");
				eval("document.myForm.applTax"+rfqItemNo).focus();
				return;
			}
		}else{
			for(var i=0;i<rfqItemObjLen;i++)
			{
				rfqItemNo = document.myForm.rfqItem[i].value;
				applTaxType	= eval("document.myForm.applTax"+rfqItemNo).value;
				if(applTaxType=='')
				{
					alert("Please select Applicable Tax");
					eval("document.myForm.applTax"+rfqItemNo).focus();
					return;
				}
			}
		}			
<%
	}
%>

	buttonhide();
	
$('input:disabled').each(function () {
       $(this).removeAttr('disabled');
    });	
	
	document.forms[0].action="<%=submitPageName%>";
	document.forms[0].submit();
}

function allowVndrHSNEntry(chkObj,itemPos)
{
	var vndrHSNCodeObj = eval("document.myForm.vndrHSNCode"+itemPos);

	if(chkObj.checked)
		vndrHSNCodeObj.disabled = false;
	else
	{
		vndrHSNCodeObj.disabled = true;
		vndrHSNCodeObj.value = "";
	}
}

function checkNum(fieldObj,itemPos)
{	
	var fieldVal = fieldObj.value;

	if(isNaN(fieldVal) || fieldVal=='')
	{
		alert("Please enter valid numeric value");
		fieldObj.value="0";
		fieldObj.focus();
		return;
	}
	else 
	{
		var itemPriceObj = eval("document.myForm.itemPrice"+itemPos);
		var itemQtyObj = eval("document.myForm.rfqItemQty"+itemPos);
		var itemTotObj = eval("document.myForm.itemPriceTotVal"+itemPos);
				
		itemTotObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceObj.value)).toFixed(2);

		var itemDISCObj = eval("document.myForm.itemDISCVal"+itemPos);
		var itemDISCTotObj = eval("document.myForm.itemDISCTotVal"+itemPos);
		itemDISCTotObj.value = ((itemTotObj.value * itemDISCObj.value)/100).toFixed(2);
		
		var itemPriceAftrDISCObj = eval("document.myForm.itemPriceAftrDISC"+itemPos);
		itemPriceAftrDISCObj.value = (parseFloat(itemPriceObj.value) - ((itemPriceObj.value * itemDISCObj.value)/100)).toFixed(2);	
		
		var itemTotValAftrDISCObj = eval("document.myForm.itemTotValAftrDISC"+itemPos);
		itemTotValAftrDISCObj.value = (parseFloat(itemQtyObj.value)*parseFloat(itemPriceAftrDISCObj.value)).toFixed(2);

		var itemPKFWObj = eval("document.myForm.itemPKFWVal"+itemPos);
		var itemTotPKFWObj = eval("document.myForm.itemPKFWTotVal"+itemPos);
		
		itemTotPKFWObj.value = ((itemTotValAftrDISCObj.value * itemPKFWObj.value)/100).toFixed(2);
		
		var itemFinalPriceObj = eval("document.myForm.itemFinalPrice"+itemPos);
		var itemFinalTotValObj = eval("document.myForm.itemFinalTotVal"+itemPos);
		
		//alert(itemFinalPriceObj.value+":::"+itemFinalPriceObj.value+":::"+itemPriceAftrDISCObj.value);
		
		var pkFwVal = (itemPriceAftrDISCObj.value * itemPKFWObj.value)/100; 

		itemFinalPriceObj.value  = (parseFloat(itemPriceAftrDISCObj.value) + pkFwVal).toFixed(2);
		itemFinalTotValObj.value = (parseFloat(itemTotValAftrDISCObj.value) + parseFloat(itemTotPKFWObj.value)).toFixed(2);
		
		
		var itemCGSTObj = eval("document.myForm.itemCGSTVal"+itemPos);
		var itemTotCGSTObj = eval("document.myForm.itemCGSTTotVal"+itemPos);
		var itemTotValAftrCGSTObj = eval("document.myForm.itemTotValAftrCGST"+itemPos);
		itemTotCGSTObj.value = ((itemFinalTotValObj.value * itemCGSTObj.value)/100).toFixed(2);
		itemTotValAftrCGSTObj.value = (parseFloat(itemFinalTotValObj.value) + parseFloat(itemTotCGSTObj.value)).toFixed(2);

		var itemSGSTObj = eval("document.myForm.itemSGSTVal"+itemPos);
		var itemTotSGSTObj = eval("document.myForm.itemSGSTTotVal"+itemPos);
		var itemTotValAftrSGSTObj = eval("document.myForm.itemTotValAftrSGST"+itemPos);
		itemTotSGSTObj.value = ((itemFinalTotValObj.value * itemSGSTObj.value)/100).toFixed(2);
		itemTotValAftrSGSTObj.value = (parseFloat(itemTotValAftrCGSTObj.value) + parseFloat(itemTotSGSTObj.value)).toFixed(2);
		
		var itemIGSTObj = eval("document.myForm.itemIGSTVal"+itemPos);
		var itemTotIGSTObj = eval("document.myForm.itemIGSTTotVal"+itemPos);
		var itemTotValAftrIGSTObj = eval("document.myForm.itemTotValAftrIGST"+itemPos);
		itemTotIGSTObj.value = ((itemFinalTotValObj.value * itemIGSTObj.value)/100).toFixed(2);
		itemTotValAftrIGSTObj.value = (parseFloat(itemTotValAftrSGSTObj.value) + parseFloat(itemTotIGSTObj.value)).toFixed(2);
		
		var itemUGSTObj = eval("document.myForm.itemUGSTVal"+itemPos);
		var itemTotUGSTObj = eval("document.myForm.itemUGSTTotVal"+itemPos);
		var itemTotValAftrUGSTObj = eval("document.myForm.itemTotValAftrUGST"+itemPos);
		itemTotUGSTObj.value = ((itemFinalTotValObj.value * itemUGSTObj.value)/100).toFixed(2);
		itemTotValAftrUGSTObj.value = (parseFloat(itemTotValAftrIGSTObj.value) + parseFloat(itemTotUGSTObj.value)).toFixed(2);
	
		
		var itemFRTObj = eval("document.myForm.itemFRTVal"+itemPos);		
		var itemTotFRTObj = eval("document.myForm.itemFRTTotVal"+itemPos);
		var itemTotValAftrFRTObj = eval("document.myForm.itemTotValAftrFRT"+itemPos);
		itemTotFRTObj.value =  itemFRTObj.value;
		itemTotValAftrFRTObj.value = (parseFloat(itemTotValAftrUGSTObj.value) + parseFloat(itemTotFRTObj.value)).toFixed(2);
		
		
		var itemFRTGSTValObj = eval("document.myForm.itemFRTGSTVal"+itemPos);		
		var itemTotFRTGSTObj = eval("document.myForm.itemFRTGSTTotVal"+itemPos);
		
		if(parseFloat(itemFRTObj.value)>0)
		{
			itemFRTGSTValObj.value = '5';
			itemTotFRTGSTObj.value = (parseFloat(itemFRTObj.value)*5/100).toFixed(2);
		}
		else
		{
			itemFRTGSTValObj.value = '0';
			itemTotFRTGSTObj.value = '0';
		}
		var itemTotValAftrFRTGSTObj = eval("document.myForm.itemTotValAftrFRTGST"+itemPos);
		itemTotValAftrFRTGSTObj.value = (parseFloat(itemTotValAftrFRTObj.value) + parseFloat(itemTotFRTGSTObj.value)).toFixed(2);
		var itemTotalValueObj = eval("document.myForm.itemTotalValue"+itemPos);

		/*
		alert(parseFloat(itemTotObj.value));
		alert(parseFloat(itemDISCTotObj.value));
		alert(parseFloat(itemTotCGSTObj.value));
		alert(parseFloat(itemTotSGSTObj.value));
		alert(parseFloat(itemTotIGSTObj.value));
		alert(parseFloat(itemTotUGSTObj.value));
		alert(parseFloat(itemTotPKFWObj.value));
		alert(parseFloat(itemTotFRTObj.value));
		*/

		itemTotalValueObj.value = parseFloat(itemFinalTotValObj.value)+
					  parseFloat(itemTotCGSTObj.value)+
					  parseFloat(itemTotSGSTObj.value)+
					  parseFloat(itemTotIGSTObj.value)+
					  parseFloat(itemTotUGSTObj.value)+
					  parseFloat(itemTotFRTObj.value)+
					  parseFloat(itemTotFRTGSTObj.value);

		itemTotalValueObj.value = (parseFloat(itemTotalValueObj.value)).toFixed(2);		  
	}
}

function buttonhide()
{
	buttonsSpan	  = document.getElementById("EzButtonsSpan");
	buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
	if(buttonsSpan!=null)
	{
		buttonsSpan.style.display	= "none"
		buttonsMsgSpan.style.display	= "block"
	}
}
</script>