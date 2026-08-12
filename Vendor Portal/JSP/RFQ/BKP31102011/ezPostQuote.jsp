<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iGetCurrJCO.jsp"%>
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
	String payterm="";
	String loginType = (String)session.getValue("OFFLINE");
	
	String ext3Type		=  request.getParameter("ext3Type");
	String quoteStatus	=  request.getParameter("status");
	String extStatus	=  request.getParameter("ext");
	String selCurr		=  request.getParameter("curr");
	String ReQuote		=  request.getParameter("ReQuote");
	String topWidth="62%";
	

	if("Y".equals(ReQuote) || serviceRFQ)
	topWidth="60%";
	
	String priceString[] =request.getParameterValues("priceString");
	String qtyString[] =request.getParameterValues("quantityString");
	String currencyString[] =request.getParameterValues("currencyString");
	String valType[] =request.getParameterValues("valType");
	String taxCode[] =request.getParameterValues("taxCode");
	String itemCond[] =request.getParameterValues("itemCond");
	String remarks = "";
	boolean displaySubmit=true;
	//out.println("<font color=white"+rfqHeader.toEzcString());
	if(loginType != null && "Y".equals(loginType)) scrollInit="10";
	else scrollInit="100";	
	
	if (retHead!=null && retHead.getRowCount() > 0)	{
		vltnType = rfqHeader.getFieldValueString(0,"VAL_TYPE");
		txCode   = rfqHeader.getFieldValueString(0,"TAX_CODE");
		ordrUnit = rfqHeader.getFieldValueString(0,"ORDER_UNIT");
		remarks  = rfqHeader.getFieldValueString(0,"EXT1");
		
		if(remarks==null || "null".equals(remarks.trim()))
			remarks = "";
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
    

String vndrDefCurr="";
%>
<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%
	Date sysdate=new Date();
%>

<Script>
	var tabHeadWidth=94
	var tabHeight="35%"
	var matNum = "<%=dtlXML.getFieldValueString(0,"ITEM")%>";   
        var today=new Date('<%=sysdate.getYear()+1900%>',parseInt('<%=sysdate.getMonth()%>',10),'<%=sysdate.getDate()%>');
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/Rfq/ezPostQuote.js"></Script>
<Script>
  function adddocuments()
  {
  	var docs = document.myForm.attachDocs.value;
  	//alert("docsdocsdocs	"+docs)
	attach=window.open("../Attachments/ezAttachmentFile.jsp?attachDocs="+docs,"UserWindow","width=550,height=550,left=250,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no,status=no");
  }
  function showOther(indx)
  {
	

	document.myForm.target = "PopUp";
	var myObj=document.myForm.taxCode;
	var myObjLen=myObj.length;
	var valType="";
	var taxCode="";
	var condStr="";
	var curr="";
	var isServiceRFQ = '<%=serviceRFQ%>'
	
	if(isServiceRFQ=='false')
	{
		if(isNaN(myObjLen)){

			taxCode=document.myForm.taxCode.value; 
			condStr=document.myForm.itemCond.value;
			curr=document.myForm.Curr.value;

		}else{

			taxCode=document.myForm.taxCode[indx].value
			condStr=document.myForm.itemCond[indx].value
			curr=document.myForm.Curr[indx].value;
		}
	}
	
	document.myForm.action= "../Rfq/ezShowOther.jsp?isServiceRFQ="+isServiceRFQ+"&rowIndex="+indx+"&taxCode="+taxCode+"&condStr="+condStr+"&Curr="+curr;
	newWindow=window.open("","PopUp","width=800,height=600,left=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();

 }
 function showCondtions()
 {
	document.myForm.target = "PopUp"; 
	var po=document.myForm.PurchaseOrder.value; 
	var lineNo=document.myForm.ItemNo.value; 

             
	document.myForm.action= "../Rfq/ezGetConditions.jsp?&po="+po+"&lineNo="+lineNo;
	newWindow=window.open("","PopUp","width=600,height=400,left=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();
     
 }
 
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
function editNote(item)
{
	document.myForm.target = "PopUp";
	document.myForm.action= "../Rfq/ezReadItemNote.jsp?ItemNo="+item;
	newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();
}
</Script>


</Head>

<body onLoad="scrollInit(<%=scrollInit%>)" onResize="scrollInit(<%=scrollInit%>)">
<form name="myForm" method="post">

	<input type="hidden" name="attachFlag" value ="N">
	<input type="hidden" name="attachDocs" value ="" >	
	<input type="hidden" name="ext3Type" value="<%=ext3Type%>">
	<input type="hidden" name="status" value="<%=quoteStatus%>">
	<input type="hidden" name="ext" value="<%=extStatus%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVend%>">
	<input type="hidden" name="ReQuote" value="<%=ReQuote%>">
	



<%

	String userType = (String)session.getValue("UserType");
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	Vector types = new Vector();
	types.addElement("date");
	String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
        	
	
%>	

	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" value="<%=poNum%>" name="PurchaseOrder">
	<input type="hidden" name="serviceRFQ" value="<%=serviceRFQ%>">
	<input type="hidden" name="type" value="<%=request.getParameter("type")%>">

<%

	String display_header = "Quotation";
	String qtndate=FormatDate.getStringFromDate(new Date(),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
%>	

	<%@ include file="../Misc/ezDisplayHeader.jsp"%>

  	<br>
  	
  	
	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
		<tr>
			<th align="left" width="15%">RFQ Ref. No</th>
      			<td valign="middle" align="left" width="15%"><input type="hidden" name="RfqNo" value="<%=poNum%>"><%=poNum%></td>
			<th align="left" width="15%">RFQ Date</th>
        		<td valign="middle" align="left" width="15%"><%=OrderDate%></td>
 			<th align="left" width="15%">Qtn. Date<font color=red>* </font></th>
			<%
				java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd.MM.yyyy hh:mm a");

				Date qdt = new Date();
				String qtnDt = sdf.format(qdt);//(qdt.getHours())%12+":"+qdt.getMinutes()+":"+qdt.getSeconds();
			%>			
			<td valign="middle" align="left" width="25%">
				<%//=qtnDt%>
				<!--<input type="hidden" name="QtnDate" value="<%=qtndate%>">-->
				<input type="text" name="QtnDate" id="QtnDate" class="InputBox" size=12 value="<%=qtndate%>" readonly><%=getDateImageFromToday("QtnDate")%>
			</td>
		</tr>
		<tr>
			<th align="left" width="10%">Qtn. Ref. No<font color=red>* </font></th>
      			<td valign="middle" align="left" width="10%">
<%			
			String quotation="";
     			 String quoteExRate="";
			if (retHead!=null && retHead.getRowCount() > 0)	
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
			<th align="left" width="10%" colspan="1">Price Exp. Date<font color=red>* </font></th>
      			<td valign="middle" align="left" width="10%" ><input type="text" name="priceValExpDate" id="priceValExpDate" class="InputBox" size=12 value="<%=ExpireDt%>" readonly> <%=getDateImageFromToday("priceValExpDate")%></Td>
  <%
							
			String incoterm="";
			String incoterm2="";

			if (retHead!=null && retHead.getRowCount() > 0)	
			{
				incoterm=retHead.getFieldValueString(0,"INCOTERM1");
				incoterm2=retHead.getFieldValueString(0,"INCOTERM2");
			}

			if(request.getParameter("IncoTerms") != null)
				incoterm=request.getParameter("IncoTerms");

	%>		
			<th align="left" width="15%">Inco Terms<font color=red>* </font></th>
			<td width="30%">
			<div id="listBoxDiv1">
			<select name=IncoTerms style="width:100%;border:1px solid" id="CalendarDiv">
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
      			
      			</tr>
      			<Tr>
				<th align="left" width="20%" colspan=2>Payment Terms&nbsp;<font color=red>* </font><br>(Max Length: 50)</th>
				<td valign="middle" align="left" width="30%" colspan=2>
				<input type="text" class=InputBox  name="PaymentTerms" maxlength="48" size="65" value="<%=PmntTerms%>">
            			</td>
            			<th align="left" width="10%" >Incoterms (Part2)</th>
            			<td valign="middle" align="left" width="40%">
            			<input type="text" class=InputBox  name="incoTerms2" maxlength="30" size="45" value="<%=incoterm2%>">
				</td>
				
            		<Tr>
			<Tr>
				<th align="left" width="10%" colspan=2>Warranty (Max Length: 50)</th>
				<td valign="middle" align="left" width="90%" colspan=4>
				<input type="text" class=InputBox  name="Warranties" maxlength="48" size="135" value="<%=Warranties%>">
			        </td>
            		<Tr>
	</table>
	




	
		<table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
		
				
			
			<tr>
				
		
			</Tr>
			<Tr>
			<Th align="left" width="15%">Qtn. Remarks</Th>
			<td width="85%" colspan=3><%=remarks%>&nbsp;</td>
			</Tr>
			<Tr>
			<Th align="left" width="15%">Remarks (max of 500) entered : <input type="text" class=tx  name="shwlen" size=3 style="background-color: #CACACA" readonly></Th>
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
			<td width="85%" colspan=3><textarea name="Remarks" rows=3 style="width:100%;overflow:auto" maxlength="500" onkeyUp="checklen(this)"><%=Remarks%></textarea></td>
			</table>
	

	<br>
		<Div id="bottompart" style="position:absolute; top=55%;height:10;width:100%;visibility:visible;bottom:245px" align="center">

	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="94%">
	<tr align="center" valign="middle">
		<th width="10%">Material</th>
		<th width="14%">Description</th>
		<th width="5%">UOM</th>
		<th width="10%">Qty</th>
		<th width="10%">Price<font color=red>* </font></th>
		<th width="8%">Currency</th>
		<Th width="14%">Delivery Date</Th>
<%
		if(quotation==null || "null".equals(quotation.trim())) quotation="";
		
		if(!serviceRFQ)
     		{
		
			if("".equals(quotation.trim()) && !serviceRFQ)
			{
			%>
				<th width="10%">Taxes & other conditions</th>
			<%
			}
			else if("N".equals(ReQuote))
			{
			%>
				<th width="10%">Taxes & other conditions</th>
			<%
			}
		}	
%>
		      	<th width="9%">Item Note</th>

	</tr>
	</table>
 	</div>

	<DIV  style="overflow:auto;position:absolute;width:94%;top=<%=topWidth%>;height:30%;left:3%">
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
		if(priceString!=null && priceString[i] != null)
		amt = priceString[i];
		String inputType="text";
		if(serviceRFQ){
			inputType="hidden";
			amt="1";
		}
		fd = new ezc.ezutil.FormatDate();
		java.util.Date delDate = (java.util.Date)dtlXML.getFieldValue(i,"CONFIRMDELIVERYDATE");
		String delDateString = fd.getStringFromDate(delDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
        	

		if( amt!=null)
		{
			curr=  dtlXML.getFieldValueString(i,"CURRENCY");
			if(currencyString!=null && currencyString[i] != null)
			curr = currencyString[i];
		}      	
		if(curr == null || "null".equals(curr) || "".equals(curr.trim())){
			if(!"".equals(vndrDefCurr)) curr=vndrDefCurr;
			else curr="INR";
		}
        
%>
        	<tr>
      		<td width="10%" ><input type=hidden name="ItemNo" value="<%=dtlXML.getFieldValueString(i,"POSITION")%>">
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
			readOnly = "readOnly";
%>		
		<input type="hidden" name="hdnMatDesc" value="<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>">
		<td width="14%"><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></td>
		
		<input type="hidden" name="txtMatDesc" value="<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>" >
		<td width="5%" align="center"><%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></td>
<%
		String quantityString = dtlXML.getFieldValueString(i,"ORDEREDQUANTITY");
		String orderPer=dtlXML.getFieldValueString(i,"PO_UNIT_ISO");;
    		String orderPerUnit=dtlXML.getFieldValueString(i,"ORDERPR_UN_ISO");
    		
    		String valTypeStr="";
    		String taxCodeStr="";
    		String itemCondStr="";
    		
    		if(valType!=null && valType[i] != null)
    		valTypeStr=valType[i];
    		
    		if(itemCond!=null && itemCond[i] != null)
    		taxCodeStr=itemCond[i];
    		
    		if(orderPer==null||"null".equals(orderPer)) orderPer="";
    		if(orderPerUnit==null||"null".equals(orderPerUnit)) orderPerUnit="";
        
		if(qtyString!=null && qtyString[i] != null)
		quantityString = qtyString[i];
		if((userType.equals("3"))|| serviceRFQ)
		{
%>
			<td width="10%" align="center"><%=quantityString%></td>
			<Input type="hidden" name="updtdQty" value="<%=quantityString%>">
<%
		}
		else
		{
%>
        		<td width="10%" align="center">&nbsp;<Input type="<%=inputType%>" size="10" name="updtdQty" value="<%=quantityString%>" class= "InputBox" maxlength=12> </td>
<%
      		}
%>
			<td width="10%" align="center">&nbsp;<input type="<%=inputType%>" name="Price" size=8 maxlength=10 class=InputBox value="<%=amt%>"></td>
			<td width="8%">
			    <select name="Curr" class=InputBox style="width:100%" id="CalendarDiv">
			    
<%
			//vendorCurr.addElement("1");
			//currTM.put("1","INR" );
			if(vendorCurr.size()==0)
%>
				<option value="">Select Currency</option>
<%			else	
			{
			
				for(int k=0;k<vendorCurr.size();k++)
				{
					
					String venCurr=(String)vendorCurr.get(k);
%>					
					<Option value=<%=vendorCurr.get(k)%> ><%=currTM.get(venCurr)%></Option>
					
<%					
				}
			}	
		
%>
			      
			    </select>
     			</td>
     			<Td width="14%" align="center">
				<input type="text" class=InputBox  style="width:50%;valign:top" name="delivDateCal<%=i%>"  id="delivDateCal<%=i%>" value="<%=delDateString%>" size=10 readonly onfocus=this.blur()>
				<%=getDateImageFromToday("delivDateCal"+i)%> 
			</Td>
     			<input type="hidden" name="valType" value="<%=valTypeStr%>">
     			<input type="hidden" name="taxCode" value="<%=taxCodeStr%>">
     			<input type="hidden" name="itemCond" value="<%=taxCodeStr%>">
     			
     			<%
     				if(!serviceRFQ)
     				{
					if("".equals(quotation.trim()))
					{
     			%>
						<td width="10%" align="center">
						<a href="javascript:onClick=showOther('<%=i%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
						</td>
     			<%
     					}
					else if("N".equals(ReQuote))
					{
     				
     			%>
						 <td width="10%" align="center">
						     <a href="javascript:onClick=showCondtions('')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
						</td>
     			<%
     			       		}	
     			       	}	
     			%>        
     			<td align="center" width="9%">
			<a href="javascript:onClick=editNote('<%=(i+1)*10%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
			</td>
     			</tr>
<%	
			
			if(serviceRFQ){
				mySerRetTemp=(ReturnObjFromRetrieve)myItemSer.get(dtlXML.getFieldValueString(i,"POSITION"));
				if(mySerRetTemp!=null&&mySerRetTemp.getRowCount()>0){
%>
				<tr>
				<td colspan=10>
				<span id="span<%=i%>"  style="visibility:visible;display:visible">
				<table align=center width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
				<tr>
					
					<th  width = "10%">Service No</th>
					<th  width = "15%">Short Text</th>
					<th  width = "4%">UOM</th>
					<th  width = "7%">Quantity</th>
					<th  width = "7%">Price</th>
					<!--<th  width = "15%">&nbsp;</th>-->
					<%
					if("".equals(quotation.trim()))
					{
					%>
						<th width="10%">Taxes & other conditions</th>
					<%
					}
					else if("N".equals(ReQuote))
					{
					%>
						<th width="10%">Taxes & other conditions</th>
					<%
					}
					%>
					
							
				</tr>
				
<%
				String classType="";
				if(userType.equals("3"))
				classType=" class=\"tx\" readonly";
				else
				classType=" class=\"InputBox\"";
				
				
				for(int s=0;s<mySerRetTemp.getRowCount();s++)
				{
					
					String serviceNo = "";
					
					try
					{
						serviceNo = Integer.parseInt(mySerRetTemp.getFieldValueString(s,"SERVICE"))+"";
					}catch(Exception e){
						serviceNo = mySerRetTemp.getFieldValueString(s,"SERVICE");
					}
					
					String key = Integer.parseInt(dtlXML.getFieldValueString(i,"POSITION"))+""+Integer.parseInt(mySerRetTemp.getFieldValueString(s,"SER_LINE"));
					
					String SerTaxCodeStr = request.getParameter("SerTaxCode_"+key);
					
					if(SerTaxCodeStr!=null || !"null".equals(SerTaxCodeStr)) SerTaxCodeStr="";
%>
					<tr>
						<td  width = "10%" align="center">
						<input type="hidden" name="serToRFQLine" value="<%=dtlXML.getFieldValueString(i,"POSITION")%>">&nbsp;
						<%=serviceNo%> 
						<input type="hidden" name="serNum" value="<%=mySerRetTemp.getFieldValueString(s,"SERVICE")%>">
						<input type="hidden" name="serLine" value="<%=mySerRetTemp.getFieldValueString(s,"SER_LINE")%>">
						</td>
						<input type="hidden" name="serText" value="<%=mySerRetTemp.getFieldValueString(s,"SHORT_TEXT")%>">
						<input type="hidden" name="serUOM" value="<%=mySerRetTemp.getFieldValueString(s,"BASE_UOM")%>">
						
						<td  width = "15%" align="left">&nbsp;<%=mySerRetTemp.getFieldValueString(s,"SHORT_TEXT")%></td>
						<td  width = "4%"><%=mySerRetTemp.getFieldValueString(s,"BASE_UOM")%></td>
						<td  width = "7%" align="center"><input type="text" <%=classType%> size="10" maxlength=12 name="serQty"  value="<%=mySerRetTemp.getFieldValueString(s,"QUANTITY")%>"></td>
						<td  width = "7%" align="center"><input type="text" class="InputBox" size=8 maxlength=10 name="serPrice" value="<%=mySerRetTemp.getFieldValueString(s,"GROSS_VAL")%>"></td>
						<!--<td  width = "15%" align="center">&nbsp;</td> -->
						<input type="hidden" name="SerTaxCode_<%=key%>" value="<%=SerTaxCodeStr%>">
<%						
						if("".equals(quotation.trim()))
						{
%>
							<td width="10%" align="center">
							<a href="javascript:onClick=showOther('<%=key%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
							</td>
<%
						}
						else if("N".equals(ReQuote))
						{

%>
							 <td width="10%" align="center">
							     <a href="javascript:onClick=showCondtions('')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
							</td>
<%
     			       			}
%>						
						
					</tr>

<%
				}
%>				
				
			
				
				</table>
				</span>
<%
				}else{
				displaySubmit=false;
%>				
				<tr>
				<td colspan=10 align="center">No Service Line Items Exits To Post Quote</td>
				</tr>
<%				
				}
			
			
			}



	}
%>
	<input type="hidden" name="allconditions" value="<%=allconditions%>">
	<input type="hidden" name="allconditionsinrequote" value="">
	</table>
	</div>
















<%
	for(int i=0;i<rfqDetails.getRowCount();i++)
	{
	 	Date dDate = (java.util.Date)rfqDetails.getFieldValue(i,"DELIVERY_DATE");
	 	String delivDate = FormatDate.getStringFromDate(dDate,"/",FormatDate.MMDDYYYY);
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
	    buttonName.add("Back");
	    buttonMethod.add("goBack()");
	}    

    buttonName.add("Add Documents");
    if(displaySubmit)
    buttonName.add("Submit");
    buttonName.add("Clear");

    buttonMethod.add("adddocuments()");
    if(displaySubmit)
    buttonMethod.add("SubmitQuote()");
    buttonMethod.add("document.myForm.reset()");
    out.println(getButtonStr(buttonName,buttonMethod));
%>
          
			</span>
			<span id="EzButtonsMsgSpan" style="display:none">
				<Table align=center>
				<Tr>
					<Td >Your request is being processed... Please wait</Td>
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
	//setDefaultFields('<%=curr%>','<%=ordrUnit%>')
</Script>
</html>
