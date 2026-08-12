<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iListCollectiveRFQByMat.jsp"%>
<%@ include file="../../../Includes/JSPs/Rfq/iGetPRItemServices.jsp" %>

<%
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String backChk=request.getParameter("backChk");
	String documentType=request.getParameter("documentType");
	
%>
 
<html>
<head>
<title>Create RFQ -- Powered By EzCommerce India</title>
<Script>
	var tabHeadWidth = 90;
	var tabHeight="40%";
	var newWindow;
	function itemSpec(mitemSpec,item)
	{
		document.myForm.target = "PopUp";
		document.myForm.action= "../Rfq/ezReadItemSpec.jsp?ItemSpec="+mitemSpec+"&ItemNo="+item;
		newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
	}
	function editNote(index,reqNo,itemNo)
	{
		document.myForm.target = "PopUp";
		var len = document.myForm.ItemNote.length
		if(isNaN(len))
			document.myForm.itemNotePOP.value = document.myForm.ItemNote.value
			
		else
			document.myForm.itemNotePOP[index].value = document.myForm.ItemNote[index].value
		
		document.myForm.index.value = index;
		document.myForm.prNo.value = reqNo;
		document.myForm.itemNo.value = itemNo;
		
		document.myForm.action= "../Rfq/ezEditItemNote.jsp";
		newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
	}
	function editQty(indx)
	{
		if(isNaN(document.myForm.vendQty.length))
			qty = document.myForm.vendQty.value;
		else
			qty = document.myForm.vendQty[indx].value;
		
		document.myForm.target = "PopUp";
		document.myForm.action= "../Rfq/ezEditQuantity.jsp?&rowIndex="+indx;
		newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
				
	}
	
	
	function editServiceQty(indx,serviceLine,initSerQty)
	{
		

		if(isNaN(document.myForm.vendQty.length))
			qty = document.myForm.vendQty.value;
		else
			qty = document.myForm.vendQty[indx].value;

		document.myForm.target = "PopUp";
		document.myForm.action= "../Rfq/ezEditServiceQuantity.jsp?&rowIndex="+indx+"&serviceLine="+serviceLine+"&initSerQty="+initSerQty;
		newWindow=window.open("","PopUp","width=500,height=400,left=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
						
	}
	
	function showSpan(indx)
	{
		openImg = new Image();
		openImg.src = "../../Images/Others/tree-select.gif";

		closeImg = new Image();
		closeImg.src = "../../Images/Others/tree-closed.gif";

		var spanObj = document.getElementById("span"+indx)
		imgobj	=document.getElementById("IMG"+indx);
		if(spanObj.style.visibility=="hidden")
		{
			spanObj.style.visibility="visible"
			spanObj.style.display=""
			imgobj.src = openImg.src;
		}
		else
		{
			spanObj.style.visibility="hidden"
			spanObj.style.display="none"
			imgobj.src = closeImg.src;
		}
		
		
					
	}
	
	
	 function adddocuments()
	 {
	  	var docs = document.myForm.attachDocs.value;
		attach=window.open("../Attachments/ezAttachmentFile.jsp?attachDocs="+docs,"UserWindow","width=400,height=400,left=250,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no,status=no");
  	 }
	
	function createRFQ1()
	{
		if(newWindow!=null)
		newWindow.close()
		var endDate 	= document.myForm.qtnEndDate.value;
		var delivDate	= document.myForm.delivDate.value;
		alert("endDate::"+endDate)
		alert("delivDate::"+delivDate)
		if(endDate=="")
		{
			
			alert("Please enter Quotation Deadline Date")
			document.myForm.qtnEndDate.focus()
			return;
		}
		if(delivDate=="")
		{
			alert("Please enter Quotation Delivery Date")
			document.myForm.delivDate.focus()
			return;
		}
		
		var date1Array=endDate.split("/");
		var date2Array=delivDate.split("/");

		date1Array[1]=date1Array[1]-1;
		date2Array[1]=date2Array[1]-1;

		var d1=new Date(date1Array[2],date1Array[1],date1Array[0]);
		var d2=new Date(date2Array[2],date2Array[1],date2Array[0]);

		if (d1>d2)
		{

			alert("Deadline Date Should be Less Than Delivery Date");
			document.myForm.delivDate.focus()
			return;
  		}
		
		document.myForm.target="_self";
		document.getElementById("ButtonDiv").innerHTML="<Table border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 ><Tr><Th>Please wait .Your Request is being Processed ...</Th></Tr></Table>"
		document.myForm.action="ezCreateRFQ.jsp";
		document.myForm.submit();
	}
	function funDateValid(date1,date2)
	{	


		var date1Array=date1.split("/");
		var date2Array=date2.split("/");

		date1Array[1]=date1Array[1]-1;
		date2Array[1]=date2Array[1]-1;

		var d1=new Date(date1Array[2],date1Array[1],date1Array[0]);
		var d2=new Date(date2Array[2],date2Array[1],date2Array[0]);

		if (d1>d2)
		 {

		  	alert("Deadline Date Should be Less Than Delivery Date");
		  	document.myForm.delivDate.focus()
			return;
		  }

}
	function funBack()
	{
		document.myForm.target="_self";
		document.myForm.action="ezVendorViewList.jsp";
		document.myForm.submit();
	}
	function checklen(obj)
	{
		var len = obj.value.length;
		if(len!="undefined")
			document.myForm.shwlen.value = len;
		if(len>499)
		{
			alert("you have enetered the maximum characters")
			obj.value = (obj.value).substring(0,499);
			document.myForm.shwlen.value = obj.value.length;
			return;
		}
	}
</Script>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no >
<form name="myForm" method="post">

<input type="hidden" name="index" value="">
<input type="hidden" name="prNo" value="">
<input type="hidden" name="itemNo" value="">

<%
	int retObjCnt = 0;
	if(myRet!=null)
	retObjCnt = myRet.getRowCount(); 
	String vendQtyStr = "";
	String display_header = "Create RFQ";
	String finalDelDate=request.getParameter("finalDelDate");
	String selectedVendors[] = request.getParameterValues("chk1");
	
	java.util.Hashtable clubQtys =new java.util.Hashtable();
	
	java.util.Hashtable tempReqItems =new java.util.Hashtable();
	
	java.util.Vector matNoVect=new java.util.Vector();
	java.util.Vector matPlantVect=new java.util.Vector();
	java.util.Vector delDateVect=new java.util.Vector();
	java.util.Vector matUOMVect=new java.util.Vector();
	java.util.Vector matDescVect=new java.util.Vector();
	java.util.Vector reqNoVect=new java.util.Vector();
	java.util.Vector reqItemVect=new java.util.Vector();
	java.util.Vector reqItemQtyVect=new java.util.Vector();
	

	
	for(int i=0;i<purchReq.length;i++){
%>
		<input type="hidden" name="purchReq" value="<%=purchReq[i]%>">
<%	}
	

%>	
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Br>
<input type="hidden" name="finalDelDate" value="<%=finalDelDate%>">
<input type="hidden" name="attachDocs" 	  value ="" >	
<input type="hidden" name="attachFlag" 	  value ="N">
<input type="hidden" name="PRDocType" 	  value ="<%=PRDocType%>">



<Div id="div1" align="center" style="visibility:visible;width:100%";left:2%">
    	<Table width="92%" align="center" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
    	<Tr>
		<Th width="20%" align="left">Collective RFQ No </Th>
		<Td width="20%">
			<Div id=listBoxDiv1 >
			<select name="collNo" style="width:100%" id="CalendarDiv"> <!--onChange="javascript:funLoad()"-->
			<option value="">Generate Collective RFQ</option>
<%
				for(int i=0;i<retObjCnt;i++)
				{
%>					<Option value='<%=myRet.getFieldValueString(i,"COLLECTIVE_RFQ_NO")%>'><%=myRet.getFieldValueString(i,"COLLECTIVE_RFQ_NO")%></Option>
					
<%				}
%>			</select>
			</Div>
		</Td>
    		<Th width="14%" align="left">Deadline Date<font color=red>*</font> </Th>
    		
		<Td width="16%">
			<input type="text" class=InputBox  style="width:50%;valign:top" name="qtnEndDate"  id="qtnEndDate" value="" size=12 readonly onfocus=this.blur()>
			<%=getDateImageFromToday("qtnEndDate")%>
		</Td>
		<Th width="14%" align="left">Delivery Date<font color=red>*</font> </Th>
		<Td width="16%">
			<input type="text" class=InputBox  style="width:50%;valign:top" name="delivDate"  id="delivDate" value="" size=12 readonly onfocus=this.blur()>
			<%=getDateImageFromToday("delivDate")%> 
		</Td>
		</Td>
	</Tr>
	<Tr>
		<Th width="15%" align="left">Description </Th>
		<Td width="85%" colspan=5>
			<input type="text" class=InputBox  name="Description"  value="" size=80 maxlength=50>
		</Td>	
	</Tr>
	</Table>
</Div>
<Div id="div1" align="center" style="visibility:visible;width:100%";left:2%" >
	<Table width='92%' valign='top'  align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr>
		<Th  width="20%" align="left">Remarks (max of 500) entered : <input type="text" class=tx  name="shwlen" size=3 style="background-color: #CACACA" readonly></Th>
		<Td  width="80%">
		<TEXTAREA  name=commentText rows=3 cols=88  maxlength="500" onkeyUp="checklen(this)"></TEXTAREA>
		</Td>	
	</Tr>
	</Table>
</Div>
<br>
<Div id="theads">
	<Table id="tabHead" width="90%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
	<Tr>
	
<%
		if(!"MAT".equals(backChk) && !"MULMAT".equals(backChk))
		{
%>			<th align="center" width="10%">PR No.</th>
			<th align="center" width="8%">Item No.</th>		
<%		}
%>		<th align="center" width="11%">Material</th>
		<th align="center" width="12%">Description</th>
		<th align="center" width="10%">Delivery Date</th>
<%	
		if(withPlant)
		{
%>			<th align="center" width="5%">Plant</th>
<%		}
%>		<th align="center" width="6%">Quantity</th>
		<th align="center" width="4%">UOM</th>
<%
		if("SERVICE".equals(PRDocType)){
%>
		<th align="center" width="11%">Services</th>
<%
		}else{
%>
		<th align="center" width="8%">Change Qty</th>
		<th align="center" width="9%">Item Note</th>
<%
		}
%>

<%
		for(int j=0;j<selectedVendors.length;j++){
%>
			<input type="hidden" name="chk1" value="<%=selectedVendors[j]%>">
<%
		}
%>
    
	</Tr>
	</Table>
</Div>

<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;left:2%">
<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
    
<%

	//for(int i=0;i<matNoVect.size();i++){
	for(int i=0;i<purchReq.length;i++){
	
	
		java.util.StringTokenizer st1 =new java.util.StringTokenizer(purchReq[i],"$$");
				
		//out.println("===========>"+purchReq[i]);

		String matNoStr="",plantStr="",delDateStr="";
		String qtyStr = "",uomStr="",matDescStr="",reqNoStr="",itmNoStr="",valTypeStr="",mitemSpec="";

		try{

			matNoStr	= st1.nextToken();
			plantStr	= st1.nextToken();
			delDateStr	= st1.nextToken();
			qtyStr 		= st1.nextToken();
			uomStr		= st1.nextToken();
			matDescStr 	= st1.nextToken();
			reqNoStr   	= st1.nextToken();
			itmNoStr   	= st1.nextToken();
			if(st1.hasMoreTokens())
			mitemSpec = st1.nextToken();
			
			if("N/A".equals(matNoStr))matNoStr="";
		}catch(Exception e){}
	
		/*String finalQty=(((java.math.BigDecimal)clubQtys.get((String)matNoVect.get(i)+(String)matPlantVect.get(i))).setScale(3,java.math.BigDecimal.ROUND_FLOOR)).toString();
		
		if("SERVICE".equals(PRDocType))
		finalQty=(((java.math.BigDecimal)reqItemQtyVect.get(i)).setScale(3,java.math.BigDecimal.ROUND_FLOOR)).toString();
		*/
		
		
		for(int j=0;j<selectedVendors.length;j++){
			if(j==0) vendQtyStr =selectedVendors[j]+"#"+qtyStr;
			else vendQtyStr =vendQtyStr +"@@"+ selectedVendors[j]+"#"+qtyStr;
			
		}
		
		String materialCodeDis="";
		try{
			materialCodeDis=Long.parseLong(matNoStr)+"";
		}catch(Exception err){materialCodeDis=matNoStr;}
%>

		<tr>
<%
		if(!"MAT".equals(backChk) && !"MULMAT".equals(backChk))
		{
%>			<td align="left" width="10%" title='<%=reqNoStr%>'><input type="hidden" name="reqNo" value="<%=reqNoStr%>"> <input type="text" name="ezcansr" value="<%=reqNoStr%>" readonly class='tx' size='17'></td>
			<td align="center" width="8%"><input type="hidden" name="prItmNo" value="<%=itmNoStr%>"> <%=itmNoStr%></td>		
<%		}else{
%>
		<input type="hidden" name="reqNo" value="-">
		<input type="hidden" name="prItmNo" value="-">
<%
		}
%>		<td align="center" width="11%">&nbsp;<input type="hidden" name="material" value="<%=matNoStr%>"><%=materialCodeDis%></td>
		<td align="center" width="12%"><input type="hidden" name="matDesc" value="<%=matDescStr%>"><%=matDescStr%></td>
		<td align="center" width="10%"><input type="hidden" name="matDelDate" value="<%=delDateStr%>"><%=delDateStr%></td>
<%	
		if(withPlant)
		{
%>			<td align="center" width="5%"><input type="hidden" name="plant" value="<%=plantStr%>"><%=plantStr%></td>
<%		}else{
%>
			<input type="hidden" name="plant" value="">
<%			
		}
%>		<td align="center" width="6%"><input type="hidden" name="actualPRQty" value="<%=qtyStr%>"><%=qtyStr%></td>
		<td align="center" width="4%"><input type="hidden" name="uom" value="<%=uomStr%>"><%=uomStr%></td>
		
		<input type="hidden" name="vendQty" value='<%=vendQtyStr%>'>
		<input type="hidden" name="vendServiceQty" value="NA">
<%
		if("SERVICE".equals(PRDocType)){
		
%>
		<td align="center" width="11%">
		<a href="javascript:onClick=showSpan('<%=i%>')"><img border=0 id="IMG<%=i%>"  src="../../Images/Others/tree-select.gif"></a>
		
		</td>

   		</tr>
   		
   		<tr>
   		<td colspan=9>
		<span id="span<%=i%>"  style="visibility:visible;display:visible">
		<table align=center width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
		<tr>
			<th  width = "5%">Line</th>
			<th  width = "15%">Service No</th>
			<th  width = "35%">Short Text</th>
			<th  width = "15%">Quantity</th>
			<th  width = "15%">UOM</th>
			<th  width = "15%">Change  Qty</th>
			
		</tr>
<%
		int myServicesCount=0;
		ezc.ezparam.ReturnObjFromRetrieve myServices=(ezc.ezparam.ReturnObjFromRetrieve)getServices(reqNoStr,itmNoStr,Session);	
		
		if(myServices!=null)
		myServicesCount=myServices.getRowCount();
		
		if(myServicesCount==0){
%>
		<tr>
		<td colspan=6>
		  No Services Exit 
		<td>
		</tr>
<%
			
		}else{
			for(int k=0;k<myServicesCount;k++)
			{
%>
				<tr>
					<td  width = "5%" align="center"><%=Long.parseLong(myServices.getFieldValueString(k,"EXT_LINE"))%></td>
					<td  width = "15%" align="center">&nbsp;<%=myServices.getFieldValueString(k,"SERVICE")%></td>
					<td  width = "35%"><%=myServices.getFieldValueString(k,"SHORT_TEXT")%></td>
					<td  width = "15%" align="center"><%=myServices.getFieldValueString(k,"QUANTITY")%></td>
					<td  width = "15%" align="center"><%=myServices.getFieldValueString(k,"BASE_UOM")%></td>
					<td  width = "15%" align="center">&nbsp;<a href="javascript:onClick=editServiceQty('<%=i%>','<%=myServices.getFieldValueString(k,"EXT_LINE")%>','<%=myServices.getFieldValueString(k,"QUANTITY")%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a></td>
							
				</tr>

<%
			}
		
		}
		

%>
		</table>
		</span>
		</td>
		</tr>
			
<%
		}else{
		
			String reqNoStrTemp = "0000000000"+reqNoStr.trim();
			reqNoStrTemp	 = reqNoStrTemp.substring(reqNoStrTemp.length()-10,reqNoStrTemp.length());
			String itmNoStrTemp = "00000"+itmNoStr.trim();
			itmNoStrTemp	 = itmNoStrTemp.substring(itmNoStrTemp.length()-5,itmNoStrTemp.length());
			
			String key = reqNoStrTemp+itmNoStrTemp;
			String itemNote = "";
			
			if(itemNoteVect.contains(key))
			{
				itemNote = (String)itemNoteHash.get(key);
				
				if(itemNote!=null)
				{
					itemNote = itemNote.replaceAll("'","`");
					itemNote = itemNote.replaceAll("\"","``");
				}	
			}
			
			/*int index = retItemNote.getRowId("TDNAME",key);
			
			String itemNote = "";
			
			if(index>=0)
				itemNote=retItemNote.getFieldValueString(index,"TDLINE");
			*/
			
%>
		
		<td align="center" width="8%">
		<a href="javascript:onClick=editQty('<%=i%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
		</td>
		<td align="center" width="9%">
		<%
		if("MULMAT".equals(backChk))
		{
		%>
		<a href="javascript:onClick=itemSpec('<%=mitemSpec%>','<%=(i+1)*10%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
		<input type="hidden" name="ItemSpec" size=8 maxlength=10 class=InputBox value="<%=mitemSpec%>">
		<%
		}else{
		%>		
		<a href="javascript:onClick=editNote('<%=i%>','<%=reqNoStrTemp%>','<%=itmNoStrTemp%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
		<%
		}
		%>
		</td>
		<input type="hidden" name="ItemNote" value='<%=itemNote%>'>
		<input type="hidden" name="itemNotePOP" value="">
   		</tr>
<%
		}
%>
				
<%
	
	}

%>
             
        </Table>
</Div>
<input type="hidden" name="backChk" value="<%=backChk%>">
<input type="hidden" name="matNo" value="<%=request.getParameter("matNo")%>">
<input type="hidden" name="selplant" value="<%=request.getParameter("selplant")%>">
<input type="hidden" name="fromDate" value="<%=request.getParameter("fromDate")%>">
<input type="hidden" name="toDate" value="<%=request.getParameter("toDate")%>">
<input type="hidden" name="matDesc" value="<%=request.getParameter("matDesc")%>">
<input type="hidden" name="selpurchReq" value="<%=request.getParameter("selpurchReq")%>">
<input type="hidden" name="selVenlist" value="<%=request.getParameter("selVenlist")%>">
<input type="hidden" name="matStr"   value='<%=request.getParameter("matStr")%>'>


<input type="hidden" name="noofitems" value='<%=request.getParameter("selItemCount")%>'>
<input type="hidden" name="selItemCount" value='<%=request.getParameter("selItemCount")%>'>
<input type="hidden" name="evaluationtype" value="V">

<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:90%">
<Span id="EzButtonsSpan" >

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Back");
	buttonMethod.add("funBack()");
	
	buttonName.add("Create RFQ");
	buttonMethod.add("createRFQ1()");
	
	buttonName.add("Add Documents");	   	
    	buttonMethod.add("adddocuments()");
	
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


</form>
<Div id="MenuSol"></Div>
</body>
</html>
