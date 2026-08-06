<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<% 
	String purOrg   = ((String)Session.getUserPreference("PURORG"));
	String vendorCode = (String)session.getValue("SOLDTO");
	String vendorName = (String)session.getValue("Vendor");
	String display_header = "Create Price Sanction Form";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Html>
<Head>
<Script type="text/javascript">
function addLine()
{
	
	var tabObj		= document.getElementById("lineItems")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	
	

	for(k=0;k<rowCountValue-3;k++)
	{
		if(rowCountValue==4 && document.myForm.indexNum.value!=undefined)
		{
		index = document.myForm.indexNum.value
		}
		else
		{
		index = document.myForm.indexNum[k].value
		}

		if(eval("document.myForm.partNo"+index)!=undefined)
		{
		
		partNoObj 		= eval("document.myForm.partNo"+index);
		partDescObj 		= eval("document.myForm.partDesc"+index);
		existingPriceObj 	= eval("document.myForm.existingPrice"+index);
		reqPriceObj 		= eval("document.myForm.reqPrice"+index);
		reqINCRObj 		= eval("document.myForm.reqINCR"+index);
		reqPercObj 		= eval("document.myForm.reqPerc"+index);
		negoPriceObj		= eval("document.myForm.negoPrice"+index);
		negINCRObj 		= eval("document.myForm.negINCR"+index);
		negoPercObj 		= eval("document.myForm.negoPerc"+index);
		incrDecrObj 		= eval("document.myForm.incrDecr"+index);
		itmNum 			= eval("document.myForm.itemNumber"+index).value;
		
		/*
		if(isNaN(partNoObj.value))
		{
			alert('Please enter Numerical values Only for CMO Code');
			partNoObj.focus();
			return;
		}  
		*/
		if(partNoObj.value=="")
		{
			alert("Please enter Part No for Item"+itmNum);
			partNoObj.focus();
			return;
		} 


		/*if(partDescObj.value=="")
		{
			alert("Please enter Description for Item"+itmNum);
			partDescObj.focus();
			return;
		}	
		if(existingPriceObj.value=="")
		{
			alert("Please enter Existing Price for Item"+itmNum);
			existingPriceObj.focus();
			return;
		} */
		if(reqPriceObj.value=="")
		{
			alert("Please enter Requested Price for Item"+itmNum);
			reqPriceObj.focus();
			return;
		}
		/*
		if(reqINCRObj.value=="")
		{
			alert("Please enter Requested INCR for Item"+itmNum);
			reqINCRObj.focus();
			return;
		} 	   	
		if(reqPercObj.value=="")
		{
			alert("Please enter Requested Percentage for Item"+itmNum);
			reqPercObj.focus();
			return;
		}*/
		if(negoPriceObj.value=="")
		{
			alert("Please enter Negotiated/Recommended Price for Item"+itmNum);
			negoPriceObj.focus();
			return;
		}		
		/*if(negINCRObj.value=="")
		{
			alert("Please enter Negotiated/Recommended INCR for Item"+itmNum);
			negINCRObj.focus();
			return;
		} 	   	

		if(negoPercObj.value=="")
		{
			alert("Please enter Negotiated/Recommended Percentage for Item"+itmNum);
			negoPercObj.focus();
			return;
		}
		if(incrDecrObj.value=="")
		{
			alert("Please enter Incr/Decr W.E.F for Item"+itmNum);
			incrDecrObj.focus();
			return;
		}*/
	}
	else
	continue;
	}
	
	var tabObj		= document.getElementById("lineItems")
	
	var rowItems 		= tabObj.getElementsByTagName("tr");
	
	var rowCountValue 	= rowItems.length;
	var val;
	var myRCObjLen;
	var index=0;

	if(!isNaN(rowCountValue))
	{
		for(i=0;i<rowCountValue-3;i++)
		{
			
			if(rowCountValue==4 && document.myForm.indexNum.value!=undefined)
				index = document.myForm.indexNum.value
			else
				index =  document.myForm.indexNum[i].value
			
			eval("document.myForm.itemNumber"+index).value = (i+1);
			itemNumber_JS = (i+1);
		}
	}
	myRCObjLen=parseInt(index)+1;
	itemNumber_JS = itemNumber_JS+1;
	
	

	eleWidth = new Array();
	eleAlign = new Array();
  	eleVal   = new Array();
  	
  	eleWidth[0]  = "4%";	eleAlign[0]  = "center";
	eleWidth[1]  = "8%";	eleAlign[1]  = "center";
	eleWidth[2]  = "12%";	eleAlign[2]  = "left";
	eleWidth[3]  = "8%";	eleAlign[3]  = "center";
	eleWidth[4]  = "8%"; 	eleAlign[4]  = "center";
	eleWidth[5]  = "8%"; 	eleAlign[5]  = "center";
	eleWidth[6]  = "8%"; 	eleAlign[6]  = "center";
	eleWidth[7]  = "8%"; 	eleAlign[7]  = "center";
	eleWidth[8]  = "8%"; 	eleAlign[8]  = "center";
	eleWidth[9]  = "8%"; 	eleAlign[9]  = "center";
	eleWidth[10] = "8%";	eleAlign[10] = "center";
		
		
	eleVal[0]  ='&nbsp;&nbsp;<b><img src="../../Images/trash.jpeg" height="15" style="cursor:hand" onClick="funDelete('+itemNumber_JS+','+myRCObjLen+')"></b><input type="text" name="itemNumber'+myRCObjLen+'" class="tx" readonly size="5" value="'+itemNumber_JS+'"><input type="hidden" name="indexNum" value="'+myRCObjLen+'" >';
	eleVal[1]  ='<input type="text" name="partNo'+myRCObjLen+'"  class="InputBox"   value="" size="18" >';
	eleVal[2]  ='<input type="text" name="partDesc'+myRCObjLen+'" class="tx"  value="" readonly>';
	eleVal[3]  ='<input type="text" name="existingPrice'+myRCObjLen+'" class="tx"   value="" size="18" readonly>';
	eleVal[4]  ='<input type="text" name="reqPrice'+myRCObjLen+'" size="18" class="InputBox" value="" >';
	eleVal[5]  ='<input type="text" name="reqINCR'+myRCObjLen+'" size="18" class="InputBox" value="">';
	eleVal[6]  ='<input type="text" name="reqPerc'+myRCObjLen+'" size="18" class="InputBox" value="">';
	eleVal[7]  ='<input type="text" name="negoPrice'+myRCObjLen+'" size="18" class="InputBox" value="" >';
	eleVal[8]  ='<input type="text" name="negINCR'+myRCObjLen+'" size="18" class="InputBox"  value="" >';
	eleVal[9]  ='<input type="text" name="negoPerc'+myRCObjLen+'" size="18" class="InputBox" value="">';
	eleVal[10] ='<input type="text" name="incrDecr'+myRCObjLen+'" size="18" class="InputBox" value="">';
	
	var rowId = tabObj.insertRow(rowCountValue);
	
	for(i=0; i<eleVal.length;i++)
		{
	
		var cell0=rowId.insertCell(i);
		cell0.width = eleWidth[i];
		cell0.align = eleAlign[i];
		cell0.innerHTML =eleVal[i];		
		}	
}
function funDelete(itmNum,indexM)
{
	var tabObj		= document.getElementById("lineItems")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	
	
	
	
	if(!isNaN(rowCountValue))
	{
		for(i=0;i<rowCountValue-3;i++)
		{

			/*if(rowCountValue==2){
			alert("hi")
			return false;
			}
			else*/
			if(rowCountValue!=4)
			{
			index =  document.myForm.indexNum[i].value
			
			
			if(index==indexM)
			{
				var rowId = tabObj.deleteRow((i+3));
				break;

			}
			}

		}
	}
	
	
	var tabObj		= document.getElementById("lineItems")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
	
	if(!isNaN(rowCountValue))
	{
		for(i=0;i<rowCountValue-3;i++)
		{
			
			if(rowCountValue==2)
			index = document.myForm.indexNum[0].value
			else
			index =  document.myForm.indexNum[i].value
			
						
			eval("document.myForm.itemNumber"+index).value = (i+1);
		}
	}
	
	
	
}
function funSubmit()
{
	document.myForm.action="ezSavePriceForm.jsp";
	document.myForm.submit();

}
</Script>
</Head>
<Body>
<form name = "myForm" method="post">
<div style="position:absolute;top:12%;left:0%;width:100%;">
	<Table width="80%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		
		<Tr>
			<Th width="20%">Supplier Code : </Th>
			<Td width="30%"><%=vendorCode%></Td>
			<Th width="20%">Plant : </Th>
			<Td width="30%"><Input type="text" size="28" class="Inputbox" name="plant" value=""></Td>
		</Tr>
		<Tr>
			<Th width="20%">Supplier Name : </Th>
			<Td width="30%"><%=vendorName%></Td>
			<Th width="20%">Purchase Org. : </Th>
			<Td width="30%"><%=purOrg%></Td>
		</Tr>
	</Table>
	<br>
	<Table width="99%" id="lineItems" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>		
		<Tr>
			<Th align="left" >&nbsp;</Th>
			<Th align="left" >&nbsp;</Th>
			<Th align="left" >&nbsp;</Th>
			<Th align="center"  rowspan=2>Existing Price</Th>
			<Th align="center"  colspan=3>Requested</Th>
			<Th align="center"  colspan=3>Negotiated/Recommended</Th>
			<Th align="left" >Incr/Decr W.E.F</Th>
		</Tr>
		<Tr>
			<Th align="left" >S. No</Th>
			<Th align="left" >Part No.</Th>
			<Th align="left" >Description</Th>
			<Th align="left" >Price(Rs.)</Th>
			<Th align="left" >INCR(Rs.)</Th>
			<Th align="left" >%</Th>
			<Th align="left" >Price(Rs.)</Th>
			<Th align="left" >INCR(Rs.)</Th>
			<Th align="left" >%</Th>
			<Th align="left" >&nbsp;</Th>
		</Tr>	
		<Tr>
			<Th>Location</Th>
			<Td colspan=2>&nbsp;</Td>
			<Th>Vendor Info Record</Th>
			<Th>Manual</Th>
			<Th>&nbsp;</Th>
			<Th>&nbsp;</Th>
			<Th>Manual</Th>
			<Th>&nbsp;</Th>
			<Th>&nbsp;</Th>
			<Th>Reduction</Th>
		</Tr>	
	
<%
		for(int m=0;m<1;m++)
		{
			
			int lineItemNo = (m+1); 
		
%>

		<Tr>
			<Td width="4%" align="center"><b><a href="javascript:funDelete('<%=lineItemNo%>','<%=m%>')"><img src="../../Images/trash.jpeg" height="15" style="cursor:hand"></a></b><Input type="text" class="tx"  name="itemNumber<%=m%>" readonly size="3" value="<%=lineItemNo%>"><input type="hidden" name="indexNum" value="<%=m%>" ></Td>
			<Td width="8%" align="center"><Input type="text" class="Inputbox" name="partNo<%=m%>" value="" size="18"></Td>
			<Td width="12%" align="left"><Input type="text" class="tx" name="partDesc<%=m%>" value="" readonly></Td>
			<Td width="8%" align="center"><Input type="text" class="tx" name="existingPrice<%=m%>" value="" size="18" readonly></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="reqPrice<%=m%>" value=""></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="reqINCR<%=m%>" value=""></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="reqPerc<%=m%>" value=""></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="negoPrice<%=m%>" value=""  ></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="negINCR<%=m%>" value=""></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="negoPerc<%=m%>" value=""></Td>
			<Td width="8%" align="center"><Input type="text" size="18" class="Inputbox" name="incrDecr<%=m%>" value=""></Td>
		</Tr>
<%
		}
%>

	</Table>
	<Table align=left   cellPadding=0 cellSpacing=0>
	
		<a href="JavaScript:addLine()"><h5>Add More Rows..</h5></a>
		
	</Table><br><br>
	<Table width="99%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<!--<Tr>
			<Th width="15%">Requested Date</Th>
			<Td width="20%">&nbsp;</Td>	
			<Th width="20%">Negotiated Effective Date</Th>
			<Td width="20%">&nbsp;</Td>
		</Tr>	-->
		<Tr>
			<Th colspan=2 align=left>Reasons for Price Change</Th>
			<!--<Th colspan=2>Change in Price due to</Th>-->
		</Tr>
		<Tr>
			<Td colspan=2><textarea rows=6 cols=160></textarea></Td>
			<!--<Td colspan=2><textarea rows=6 cols=50></textarea></Td>-->
		</Tr>
		<!--<Tr>
			<Th align="left">Proposed By<br><br><br>Buyer</Th>
			<Th >Pricing Committee<br><br><br>RS&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;KRK&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;SVS</Th>
			<Th colspan=2>Approved By<br><br><br>JS&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;SK</Th>
		</Tr>-->
	</Table>
	<br>
	<Center>	
<%	
		buttonName.add("Submit");	
		buttonMethod.add("Approve()");  
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	<Center>
<Div>
</from>
<Div id="MenuSol"></Div>
</Body>
</Html>