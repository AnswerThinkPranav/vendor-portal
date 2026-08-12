<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="../Rfq/ezGetMatUnits.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%
	String reQtFlg  = "N";
	String vltnType = "";
	String txCode = "";
	String ordrUnit = "KG";
	String scrollInit = "";
	String loginType = (String)session.getValue("OFFLINE");
	if(loginType != null && "Y".equals(loginType)) scrollInit="10";
	else scrollInit="100";	
	
	if (retHead!=null && retHead.getRowCount() > 0)	{
		vltnType = rfqHeader.getFieldValueString(0,"VAL_TYPE");
		txCode   = rfqHeader.getFieldValueString(0,"TAX_CODE");
		ordrUnit = rfqHeader.getFieldValueString(0,"ORDER_UNIT");
	}
	if("null".equals(ordrUnit) || "".equals(ordrUnit) || ordrUnit==null)
	ordrUnit = "KG";
	
	String allconditions = "";
	
	if(retCond!=null && retCond.getRowCount()>0){
		for(int i=0;i<retCond.getRowCount();i++){
			String ctype	=retCond.getFieldValueString(i,"CONDITION_ID");
			String cvalue	=retCond.getFieldValueString(i,"CONDITION_VAL");
			String currency	=retCond.getFieldValueString(i,"CURRENCY");
			String perVal	=retCond.getFieldValueString(i,"PER");
			String unitofmsr=retCond.getFieldValueString(i,"UOM");
			allconditions	=allconditions+ctype+"*"+cvalue+"*"+currency+"*"+perVal+"*"+unitofmsr+"#";

		}
		allconditions = allconditions.substring(0,allconditions.length()-1);
	}	
	
	if(request.getParameter("conditionsString") != null)
		allconditions = request.getParameter("conditionsString");
		
	if(request.getParameter("orderUnit") != null)
		ordrUnit = request.getParameter("orderUnit");
    
	ezc.ezpreprocurement.client.EzPreProcurementManager PreProMgr 	  = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	EzcParams ezcContainer= new EzcParams(false);
	 ezc.ezpreprocurement.params.EziRFQHeaderParams rfqExchHeaderParams =new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	rfqExchHeaderParams.setVendor((String)session.getValue("SOLDTO"));
	ezcContainer.setObject(rfqExchHeaderParams);
	Session.prepareParams(ezcContainer);
	ReturnObjFromRetrieve venExcRetObj=(ReturnObjFromRetrieve)PreProMgr.ezGetVendorExchangeRate(ezcContainer); 
  ReturnObjFromRetrieve exchRetObj=null;
  int exchRetObjCount=0;
  
	String vndrDefCurr="";
	String vndrDefExcRate="";
  if(venExcRetObj!=null&&venExcRetObj.getRowCount()>0){
    vndrDefCurr=venExcRetObj.getFieldValueString(0,"DEF_CURR");
    exchRetObj =(ReturnObjFromRetrieve)venExcRetObj.getFieldValue(0,"EXCH_RATE_OBJ");
  }
  
	
	if(exchRetObj!=null)
	{
		exchRetObjCount=exchRetObj.getRowCount();
	}
   
%>
<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	var tabHeadWidth=94
	var tabHeight="35%"
	var matNum = "<%=dtlXML.getFieldValueString(0,"ITEM")%>";
	
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/Rfq/ezPostQuote.js"></Script>

<Script>
  var currArray = new Array();
  function ezCurrency(currCode,exchRate)
  {
    this.currCode = currCode;
    this.exchRate = exchRate;
    
  }
  <%
    for(int i=0;i<exchRetObjCount;i++){
  %>
     currArray[currArray.length] = new ezCurrency('<%=exchRetObj.getFieldValueString(i,"FROM_CURR")%>','<%=exchRetObj.getFieldValueString(i,"EXCH_RATE")%>');
  <%
    }
  %>
 
  function setExchangeRate()
  {
    var curr=document.myForm.Curr.value;
    document.myForm.excRate.value="";
    for(i=0;i<currArray.length;i++){
      if(currArray[i].currCode == curr)
      document.myForm.excRate.value= currArray[i].exchRate;
    }
  }
  
  function checkVal(valObj)
	{
    
		var fldValue = funTrim(valObj.value);
    if(fldValue!="")
    {
      if(isNaN(fldValue)){
        alert("Please Enter Valid Number");
        valObj.focus();
      } 
    }
	}
</Script>


</Head>

<body onLoad="scrollInit(<%=scrollInit%>)" onResize="scrollInit(<%=scrollInit%>)">
<form name="myForm" method="post">
<%
	String userType = (String)session.getValue("UserType");
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	Vector types = new Vector();
	types.addElement("date");
	String OrderDate = fd.getStringFromDate(ordDate,".",fd.DDMMYYYY);
        	
	
%>	

	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" value="<%=poNum%>" name="PurchaseOrder">
	<input type="hidden" name="type" value="<%=request.getParameter("type")%>">

<%
	String display_header = "Quotation";
	String qtndate=FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY);
	
%>	

	<%@ include file="../Misc/ezDisplayHeader.jsp"%>

  	<br>
	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
		<tr>
			<th align="left" width="20%">RFQ Ref. No</th>
      			<td valign="middle" align="left" width="20%"><input type="hidden" name="RfqNo" value="<%=poNum%>"><%=poNum%></td>
			<th align="left" width="20%">RFQ Date</th>
        		<td valign="middle" align="left" width="15%"><%=OrderDate%></td>
 			<th align="left" width="10%">Qtn. Date</th>
			<%
				java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm a");

				Date qdt = new Date();
				String qtnDt = sdf.format(qdt);//(qdt.getHours())%12+":"+qdt.getMinutes()+":"+qdt.getSeconds();
			%>			
			<td valign="middle" align="left" width="35%">
				<%//=qtnDt%>
				<!--<input type="hidden" name="QtnDate" value="<%=qtndate%>">-->
				<input type="text" name="QtnDate" class="InputBox" size=12 value="<%=qtndate%>" readonly><%=getDateImage("QtnDate")%>
			</td>
		</tr>
		<tr>
			<th align="left" width="20%">Qtn. Ref. No</th>
      			<td valign="middle" align="left" width="20%">
<%			
			String quotation="";
      String quoteExRate="";
			if (retHead.getRowCount() > 0)
			{
				quotation   = retHead.getFieldValueString(0,"QUOTATION");
        quoteExRate = retHead.getFieldValueString(0,"EXCH_RATE");
        if(quoteExRate==null || "null".equals(quoteExRate)) quoteExRate="";
				if(!"".equals(quotation))
				reQtFlg = "Y";

				if(request.getParameter("QtnRef") != null)
					quotation = request.getParameter("QtnRef");

			}

			if(request.getParameter("ExpireDt") != null)
			ExpireDt = request.getParameter("ExpireDt");
%>
       			<input type="text" class=InputBox  name="QtnRef" maxlength="10" size="15" value="<%=quotation%>">
            		</td>
			<th align="left" width="20%" colspan="1">Quotation Exp. Date</th>
      			<td valign="middle" align="left" width="20%" colspan="3"><input type="text" name="priceValExpDate" class="InputBox" size=12 value="<%=ExpireDt%>" readonly> <%=getDateImage("priceValExpDate")%></Td> </tr>
	</table>












	<DIV id="theads" style="position:absolute; height=50%;width:100%;visibility:visible">
		<table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
		
		
		
		
		
		
		
		<%
			String payterm="";
			if(!(userType.equals("3")))
			{	
		%>	
				<tr>
					<th align="left" width="20%">Valuation Type</th>
					<td width="30%">
					<div id="listBoxDiv1">
					<select id="CalendarDiv" name="valType" style="width:100%">
						<option value="">Select Valuation Type</option>
		<%
					if(request.getParameter("valType") != null)
						vltnType = request.getParameter("valType");
					
			
					for(int k=0;k<valuationTypes.length;k++)
					{
						if(valuationTypes[k].equals(vltnType))
						{
		%>
							<Option value="<%=valuationTypes[k]%>" selected><%=valuationTypes[k]%></Option> 
		<%			
						}
						else
						{
		%>		
							<Option value="<%=valuationTypes[k]%>"><%=valuationTypes[k]%></Option>
		<%
						}
					}
		%>
					
					</select>
					</Div>
					</td>
					<th align="left" width="20%">Tax Code</th>
					<td width="30%">
					<div id="listBoxDiv1">
					<select name="taxCode"  style="width:100%" id="CalendarDiv">
					<option value="">Select Tax Code</option>
		
		<%				
				
				
					if(request.getParameter("taxCode") != null)
						txCode = request.getParameter("taxCode");
		
					while(taxIterator.hasNext())
					{
						taxObj = taxIterator.next();
						String taxStr = taxObj.toString();
						if(txCode==null || "null".equals(txCode) || "".equals(txCode))
							txCode = "AA";	
		
						if(taxStr.equals(txCode.trim()))
						{
		%>	
							<Option value="<%=taxStr%>" selected><%=taxStr%>--><%=taxTM.get(taxStr)%></Option>
		<%
						}
						else
						{
		%>					<Option value="<%=taxStr%>" ><%=taxStr%>--><%=taxTM.get(taxStr)%></Option>
		<%				}
					}
		%>		
					</select>
					</div>
					</td>		
		
				</tr>
		<%
			}
		%>	
			<tr>
				<th align="left" width="20%">Payment terms</th>
				<td width="30%">
				<div id="listBoxDiv1">
				<select id="CalendarDiv" name=PaymentTerms style="width:100%">
				<option value="">Select Payment Terms</option>
		<%
				
				String incoterm="";
				String incoterm2="";
			
				if (retHead.getRowCount() > 0)
				{
					payterm=retHead.getFieldValueString(0,"PMNTTERM");
					incoterm=retHead.getFieldValueString(0,"INCOTERM1");
					incoterm2=retHead.getFieldValueString(0,"INCOTERM2");
				}
				
				if(request.getParameter("IncoTerms") != null)
					incoterm=request.getParameter("IncoTerms");
					
				if(request.getParameter("PaymentTerms") != null)
					payterm=request.getParameter("PaymentTerms");
					
			
			      	while(payIterator.hasNext())
				{
					payObj = payIterator.next();
					String payStr = payObj.toString();
					if(payStr.equals(payterm))
					{
		%>				<Option value=<%=payStr%> selected><%=payStr%>--><%=payTM.get(payStr)%></Option>
		<%
					}
					else
					{
		%>				<Option value=<%=payStr%> ><%=payStr%>--><%=payTM.get(payStr)%></Option>
		<%			}
				}
		%>
				</select>
				</Div>
				</td>
				<th align="left" width="20%">Inco Terms</th>
				<td width="30%">
				<div id="listBoxDiv1">
				<select name=IncoTerms style="width:100%" id="CalendarDiv">
				<option value="">Select Inco Terms</option>
		<%
				String incoStr="",inco2 ="";
			      	while(incoIterator.hasNext())
				{
					incoObj = incoIterator.next();
					incoStr = incoObj.toString();
					inco2   = (String)incoTM.get(incoStr);
					if(incoStr.equals(incoterm))
					{
		%>
						<Option value="<%=incoStr%>¥<%=inco2%>" selected><%=incoStr%>--><%=inco2 %></Option>
		<%
					}
					else
					{
		%>
						<Option value="<%=incoStr%>¥<%=inco2%>" ><%=incoStr%>--><%=inco2 %></Option>
		<%
					}
				}
		%>
				</select>
				</div>
				</td>
			</Tr>
		
		<%
			if(request.getParameter("IncoTermsDesc") != null)
				incoterm2 = request.getParameter("IncoTermsDesc");
		%>
			
			<Tr>
			<Th align="left" width="20%">Inco Terms Details</Th>
			<Td width="80%" colspan=3><font size=4><input type=text name="IncoTermsDesc" size=140 maxlength=28 class=InputBox value='<%=incoterm2%>'></font></Td>
			<Tr>
			<Th align="left" width="20%">Remarks</Th>
		<%
			String remks = "";
			try
			{
				if (htexts.get(poNum)!=null)
					remks =(String)htexts.get(poNum.trim());
			}
			catch(Exception ex)
			{
			}
			if(request.getParameter("Remarks") != null)
				remks = request.getParameter("Remarks");
		%>
			<td width="80%" colspan=3><textarea name="Remarks" rows=2 style="width:100%;overflow:auto"><%=remks%></textarea></td>
			</table>
	</div>

		
		
		
		
		
		
		
		
		
		
		
		
		
		
			











	<div id="bottompart" style="position:absolute; top=50%;height:10;width:100%;visibility:visible" align="center">
	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">





<tr align="center" valign="middle">
				<th width="10%">Material</th>
				<th width="20%">Description</th>
				<th width="4%">UOM</th>
				<%--<th width="8%">Ord.Unit</th>--%>
				<th width="7%">Qty</th>
				<th width="7%">Price</th>
				<%--<th width="6%">Per</th>
				<th width="8%">Price Unit</th>--%>
				<th width="15%">Currency</th>
				<%--<th width="7%">Exc.Rate</th>
				
				
<%				if(!(userType.equals("3")))
				{
%>					<th width="8%">Conditions</th>
<%				}
%>
--%>
			</tr>
		</table>
 	</DIV>

	<DIV  style="overflow:auto;position:absolute;width:94%;top=54%;height:30%;left:3%">
	<TABLE  width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="94%">
<%
	String curr="";
	if(!"".equals(vndrDefCurr)) curr=vndrDefCurr;
	else curr="INR";
	for(int i=0;i<Count;i++)
	{
		String amt = dtlXML.getFieldValueString(i,"AMOUNT");
		if(amt!=null)
		//amt = amt.substring(0,amt.length()-2);
		if(request.getParameter("priceString") != null)
		amt = request.getParameter("priceString");


		if( amt!=null)
		{
			curr=  dtlXML.getFieldValueString(i,"CURRENCY");
			if(request.getParameter("currencyString") != null)
			curr = request.getParameter("currencyString");
		}      	
		if(curr == null || "null".equals(curr) || "".equals(curr.trim())){
			if(!"".equals(vndrDefCurr)) curr=vndrDefCurr;
			else curr="INR";
		}
        
%>
        	<tr>
      		<td width="10%"><input type=hidden name="ItemNo" value="<%=dtlXML.getFieldValueString(i,"POSITION")%>">
<%
			try
			{
				out.println(Long.parseLong(dtlXML.getFieldValueString(i,"ITEM")));
			}
			catch(Exception e)
			{
				out.println(dtlXML.getFieldValueString(i,"ITEM"));
			}
%>
		</td>
		
		
<%		
		String readOnly = "readonly";
		if(!(userType.equals("3")))
			readOnly = "";
%>		
		<input type="hidden" name="hdnMatDesc" value="<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>">
		<td width="20%"><input type="text" name="txtMatDesc" class=InputBox value="<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>" size="32" maxlength="50" <%=readOnly%>></td>
		<td width="4%" align="center"><%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></td>
		<%--<td width="8%">
		<Select name="orderUnit" style="width:100%" id="CalendarDiv">
		<Option value="-">Select</Option>
<%		
		for(int k=0;k<retMatUnitsCnt;k++)
		{
%>	
        		<Option value="<%=retMatUnits.getFieldValueString(k,"UOM")%>"><%=retMatUnits.getFieldValueString(k,"DESCRIPTION")%></Option>
<%
		}
%>
      		</Select>
      		</td>--%>
<%
		String quantityString = dtlXML.getFieldValueString(i,"ORDEREDQUANTITY");
    String orderPer=dtlXML.getFieldValueString(i,"PO_UNIT_ISO");;
    String orderPerUnit=dtlXML.getFieldValueString(i,"ORDERPR_UN_ISO");
    
    if(orderPer==null||"null".equals(orderPer)) orderPer="";
    if(orderPerUnit==null||"null".equals(orderPerUnit)) orderPerUnit="";
    
    
		if(request.getParameter("quantityString") != null)
		quantityString = request.getParameter("quantityString");
		if((userType.equals("3")))
		{
%>
			<td width="7%" align="center"><%=quantityString%></td>
			<Input type="hidden" name="updtdQty" value="<%=quantityString%>">
<%
		}
		else
		{
%>
        		<td width="7%" align="center"><Input type="text" size="8" name="updtdQty" value="<%=quantityString%>" class= "InputBox" maxlength=12> </td>
<%
      		}
%>
			<td width="7%" align="center"><input type=text name="Price" size=8 maxlength=10 class=InputBox value="<%=amt%>"></td>
			<td width="6%" align="center"><input type=text name="per" size=4 maxlength=10 onBlur="checkVal(this)" class=InputBox value="<%=orderPer%>"></td>
			<td width="8%">
			<Select name="perUnit" style="width:100%" id="CalendarDiv">
			<Option value=" ">Select</Option>
<%		
			for(int k=0;k<retMatUnitsCnt;k++)
			{
        String selected="";
        if(orderPerUnit.equals(retMatUnits.getFieldValueString(k,"UOM")))
        selected="Selected";
%>	
				<Option value="<%=retMatUnits.getFieldValueString(k,"UOM")%>" <%=selected%>><%=retMatUnits.getFieldValueString(k,"DESCRIPTION")%></Option>
<%
			}
%>
			</Select>
      			</td>
			
			<td width="15%">
			    <select name="Curr" onChange="setExchangeRate()" class=InputBox style="width:100%" id="CalendarDiv">
<%
				while(currIterator.hasNext())
				{
					String currKey = (String)currIterator.next();
%>					
					<Option value=<%=currKey%> ><%=currTM.get(currKey)%></Option>
					
<%				}
		
%>
			      
			    </select>
     			</td>
     			<td width="7%" align="center"><input type="text" name="excRate" onBlur="checkVal(this)" size=8 maxlength=10 class=InputBox value=""></td>
     			
<%		  	if(!(userType.equals("3")))
        		{
%>     				<td width="8%" align="center"><a href="javascript:funOpen(<%=i%>,'<%=i%>')"> <img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a></td>
<%		  	}
%> 		</tr>
<%	}
%>
	<input type="hidden" name="allconditions" value="<%=allconditions%>">
	<input type="hidden" name="allconditionsinrequote" value="">
	</table>
	</div>

















<%
	for(int i=0;i<rfqDetails.getRowCount();i++)
	{
	 	Date dDate = (java.util.Date)rfqDetails.getFieldValue(i,"DELIVERY_DATE");
	 	String delivDate = FormatDate.getStringFromDate(dDate,".",FormatDate.DDMMYYYY);
%>	

      		<input type=hidden name="counter" value="<%=rfqDetails.getFieldValueString(i,"COUNTER")%>">
      		<input type=hidden name="material" value="<%=rfqDetails.getFieldValueString(i,"MATERIAL")%>">
      		<input type=hidden name="materialDesc" value="<%=rfqDetails.getFieldValueString(i,"MATERIAL_DESC")%>">
      		<input type=hidden name="uom" value="<%=rfqDetails.getFieldValueString(i,"UOM")%>">
      		<input type=hidden name="quantity" value="<%=rfqDetails.getFieldValueString(i,"QUANTITY")%>">
      		<input type=hidden name="delivDate" value="<%=delivDate%>">
		<input type=hidden name="plant" value="<%=rfqDetails.getFieldValueString(i,"PLANT")%>">      		
<%	}
%>
	<br>
	<div id="buttons" style="position:absolute;top:90%;width:100%;visibility:visible" align="center">
		<span id="EzButtonsSpan" >	
<%
	if(!"Y".equals(session.getValue("OFFLINE")))
	{
	    buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Back&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	    buttonMethod.add("goBack()");
	}    

    
    buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clear&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");

    buttonMethod.add("SubmitQuote()");
    buttonMethod.add("document.myForm.reset()");
    out.println(getButtonStr(buttonName,buttonMethod));
%>
          
			</span>
			<span id="EzButtonsMsgSpan" style="display:none">
				<Table align=center>
				<Tr>
					<Td class="labelcell">Your request is being processed... Please wait</Td>
				</Tr>
				</Table>
			</span>
		</Td>
	</Tr>
</Table>
		
	</div>
<Input type="hidden" name="reQtFlg" value="<%=reQtFlg%>">
<Input type="hidden" name="OldCur" value="<%=curr%>">
</form>
<Div id="MenuSol"></Div>
</body>
<Script>
  
	function setDefaultFields(curr,ordUnit)
	{
		var optLen = document.myForm.Curr.options.length
		for(i=0;i<optLen;i++)	
		{
			if(document.myForm.Curr.options[i].value == curr)
			{	
				document.myForm.Curr.selectedIndex = i
				break; 
			}
      
		}
		
		var ordrUntLen = document.myForm.orderUnit.length;
		for(var i=0;i<ordrUntLen;i++)
		{
			if(document.myForm.orderUnit[i].value==ordUnit)
			{
				document.myForm.orderUnit.selectedIndex=i;
				break;
			}
		}
    
    if(document.myForm.reQtFlg.value=="Y"){
      document.myForm.excRate.value="<%=quoteExRate%>";
    }else{
      setExchangeRate();
     } 
		
	}
	setDefaultFields('<%=curr%>','<%=ordrUnit%>')
</Script>
</html>
