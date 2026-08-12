<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="ezVendorPayTerms.jsp"%>
<%@ include file="ezRFQTaxCodes.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import="java.text.*" %>
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

<%@page import="ezc.ezutil.*,java.util.*"%>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>

<%
String SAPRFQNo = rfqNumber;
try{
 	SAPRFQNo= Integer.parseInt(SAPRFQNo)+"";
 	}catch(Exception e){}
try{
session.removeValue("ATTACHEDFILES");
}catch(Exception e){}
%>
<%
	String Frieght=checkNull(request.getParameter("Freight")); 
	
String usersList = "";
	String userName	= "";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;

	ReturnObjFromRetrieve docCommentsRet	=  null;
	int docCommentsRetCnt = 0;
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();
	
	
		miscParams.setQuery("SELECT * FROM EZC_DOCUMENT_COMMENTS WHERE EDC_DOC_ID IN ('"+rfqNumber+"')");
	
		mainParams.setObject(miscParams);
		mainParams.setLocalStore("Y");
		Session.prepareParams(mainParams);
	docCommentsRet = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
if(docCommentsRet!=null)
	{
	docCommentsRetCnt = docCommentsRet.getRowCount();
			docCommentsRet.sort(new String[]{"EDC_DATE"},true);
		}
	for(int i=0;i<docCommentsRetCnt;i++)
	{
		String uid	= checkNull(docCommentsRet.getFieldValueString(i,"EDC_USER_ID"));
		try{
		uid=Integer.parseInt(uid)+"";
		}catch(Exception e){uid= docCommentsRet.getFieldValueString(i,"EDC_USER_ID");}
		if(!userIdAL.contains(uid))
			userIdAL.add(uid);
	}
	for(int i=0;i<userIdAL.size();i++)
	{
		if("".equals(usersList))
			usersList=(String)userIdAL.get(i);
		else
			usersList=usersList+"','"+(String)userIdAL.get(i);
		
	}
	mainParams	= new ezc.ezparam.EzcParams(false);
	 miscParams = new EziMiscParams();


	miscParams.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_LAST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+usersList+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	UserNamesRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	try
	{
	if(UserNamesRetObj!=null)
	userNameCount = UserNamesRetObj.getRowCount();
	}catch(Exception e){System.out.println(e);}
		
%>
<html>
<head>
<Script>
var tabHeadWidth=94
var tabHeight="35%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<%
	String submitPageName = "ezQuotationSave.jsp";
	String fromPage       = "TO_QUOTE";
%>
	<%@ include file="ezRFQ_JS.jsp" %>	
	
	<Script>
	function goBack(){
	var portRfqNum=document.myForm.RfqNo.value;
		document.forms[0].action = "ezViewRFQDetails.jsp?portRfqNum="+portRfqNum;
		document.forms[0].submit();
	}
	function funReset()
	{
		document.myForm.reset(); 
			
	}	
	
	document.onkeydown = function (evt) 
	{
		var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
		if (keyCode == 13) 
		{
<%
			for(int j=0;j<Count;j++)
			{
%>
				checkNum(eval("document.myForm.itemPrice<%=dtlXML.getFieldValueString(j,"POSITION")%>"),'<%=dtlXML.getFieldValueString(j,"POSITION")%>');
<%
			}
%>
		}
	}
	
	function enableTaxes()
	{
		var applTaxType	= document.myForm.applTax.value;
		var rfqItemObj  = document.myForm.rfqItem;
		var rfqItemObjLen = rfqItemObj.length;
		
		var rfqItemNo;
		
		if(isNaN(rfqItemObjLen))
		{
			rfqItemNo = document.myForm.rfqItem.value;
			if( applTaxType == 'SCGST')
			{
				eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=false;
				eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=false;
			}
			else
			{
				eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=true;
				eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=true;	
			}
			if( applTaxType == 'IGST')
				eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=false;
			else
				eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=true;	
			
			if( applTaxType == 'UGST')
				eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=false;
			else
				eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=true;	
		}else{
			for(var i=0;i<rfqItemObjLen;i++)
			{
				rfqItemNo = document.myForm.rfqItem[i].value;
				if( applTaxType == 'SCGST')
				{
					eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=false;
					eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=false;
				}
				else
				{
					eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=true;
					eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=true;	
				}
				if( applTaxType == 'IGST')
					eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=false;
				else
					eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=true;
					
				if( applTaxType == 'UGST')
					eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=false;
				else
					eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=true;					
			}
		}	
	}
function enableTaxes(index)
{
	var applTaxType	= eval("document.myForm.applTax"+index).value;
	var rfqItemObj  = document.myForm.rfqItem;
	var rfqItemObjLen = rfqItemObj.length;

	var rfqItemNo;
 
	
		rfqItemNo = index;
		if( applTaxType == 'SCGST') 
		{
			eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=false;
			eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=false;
		}
		else
		{
			eval("document.myForm.itemCGSTVal"+rfqItemNo).disabled=true;
			eval("document.myForm.itemSGSTVal"+rfqItemNo).disabled=true;	
		}
		if( applTaxType == 'IGST')
			eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=false;
		else
			eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=true;	

		if( applTaxType == 'UGST')
			eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=false;
		else
			eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=true;	
	
}

	
	</script>
</Head>
<body>
<form name="myForm" method="post">

	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="rfqDate" value="<%=rfqDate%>">
	<input type="hidden" name="rfqNumber" value="<%=rfqNumber%>" >
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	
	<input type="hidden" value="<%=rfqVendor%>" name="rfqVendor">
	<input type="hidden" value="<%=rfqCompCode%>" name="rfqCompCode">
	<input type="hidden" value="<%=rfqPurOrg%>" name="rfqPurOrg">
	<input type="hidden" value="<%=rfqSysKey%>" name="rfqSysKey">
	<input type="hidden" name="portRfqNum" value="<%=request.getParameter("portRfqNum")%>">
	<input type="hidden" name="attachFlag" value ="N" >
	<input type="hidden" name="attachDocDesc" value ="" >	
	<input type="hidden" name="attachFileTime" value ="" >	
	<input type="hidden" name="attachDocFiles" value ="" >
	
<% 
	String display_header	= "RFQ > RFQ's To Be Responded > RFQ Details > Quotation";
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%> 	  
	<br>
<%
	String payterm="";String incoterm="";
%>
	<%@ include file="ezQuoteHeader.jsp" %>	
	<br>
<% 
	String inpBoxColor = "style='background-color:grey;color:white;text-align:right'";
	String currSymbol = "&#8377;";
	String taxFieldsSize = " size='5' maxlength='5' ";
	
      	for(int i=0;i<Count;i++)
      	{		
      		String rfqItemPos 		= dtlXML.getFieldValueString(i,"POSITION");
      		java.util.Date dlvDateObj 	= (java.util.Date)dtlXML.getFieldValue(i,"CONFIRMDELIVERYDATE");
      		String rfqItemDlvDate 		= FormatDate.getStringFromDate(dlvDateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
      		String currency			= dtlXML.getFieldValueString(i,"CURRENCY");
      		
      		if("".equals(currency) || "null".equals(currency) || currency==null)
      			currency = "INR";
      		
      		
      		String rfqMatCode = dtlXML.getFieldValueString(i,"ITEM");
      		
      		
      		try{
      			rfqMatCode = Long.parseLong(rfqMatCode)+"";
      		}catch(Exception e){}
      		
%>
		<input type='hidden' name='rfqItem' value='<%=rfqItemPos%>'>
		<input type='hidden' name='rfqMatCode<%=rfqItemPos%>' value='<%=dtlXML.getFieldValueString(i,"ITEM")%>'>
		<input type='hidden' name='rfqMatDesc<%=rfqItemPos%>' value='<%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%>'>
		<input type='hidden' name='rfqItemUOM<%=rfqItemPos%>' value='<%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%>'>
		<input type='hidden' name='rfqItemQty<%=rfqItemPos%>' value='<%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%>'>
		<input type='hidden' name='rfqItemCurr<%=rfqItemPos%>' value='<%=currency%>'>
		<input type='hidden' name='rfqItemDlvDate<%=rfqItemPos%>' value='<%=rfqItemDlvDate%>'>
<%
		if(i%3==0)
      		{
%>
			<table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
			<Tr>
			<Td width="33%">
				<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
				<Tr>
					<Th <%=trBGColor%> width="100%" colspan=2><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></Th>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Material</Td>
					<Td width="65%">&nbsp;<%=rfqMatCode%></Td>
				</Tr> 
				<!--<Tr>
					<Td width="35%">&nbsp;Enquiry Description</Td>
					<Td width="65%">&nbsp;<%=checkNull(retItemText.getFieldValueString(i,"TEXTLINE"))%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Vendor Description</Td>
					<Td width="65%"><textarea rows="5" cols="30" disabled style="padding-top: 5px;"> </textarea></Td>
				</Tr>-->
				<Tr>
					<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
					<Td valign="middle" align="left" width="15%" colspan=5>
						<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
							<option value=''>--Select Tax Type--</option>
							<option value='SCGST'>SGST & CGST</option>
							<option value='IGST'>IGST</option>
							<option value='UGST'>UGST</option>
						</Select>
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;UOM </Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Quantity </B></Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%></Td>
				</Tr>
				<Tr> 
					<Td width="35%">&nbsp;Currency </Td>
					<Td width="65%">&nbsp;<%=currency%></Td>
				</Tr>  
				<Tr>
					<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td> 
					<Td width="65%">&nbsp;
						<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="" size="10" maxlength="10" readonly>
						<input  class=InputBox type="text" disabled name="testHSN<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
						<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')">
						<Font color='RED' size=2><B>Incorrect</B></Font>
					</Td>
				</Tr>

				<Tr>
					<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="0" size="6" maxlength="8"  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Discount </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
						<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>     
					<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>        
				
				<Tr>   
					<Td width="35%">&nbsp;Packing & Fowarding </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
						<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>  

				<Tr>  
					<Td width="35%">&nbsp;<B>Total Price</B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>


				<Tr>
					<Td width="35%">&nbsp;Central GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
						<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;State GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
						<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Integrated GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
						<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Union Trty GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
						<input  type="hidden" name="valType<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
							 	     					
				<Tr>
					<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="V"> 
						<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
						<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>   
				<Tr>
					<Td width="35%">&nbsp;GST on Freight </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				
				<Tr>
					<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
					<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
					<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="0" size="7" readonly></Td>
				</Tr>

				</table>
			</Td>
<%
			}
			if(i%3==1)
      			{
%>
			<Td width="33%">
				<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
				<Tr>
					<Th <%=trBGColor%> width="100%" colspan=2><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></Th>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Material</Td>
					<Td width="65%">&nbsp;<%=rfqMatCode%></Td>
				</Tr>
				<!--<Tr>
					<Td width="35%">&nbsp;Enquiry Description</Td>
					<Td width="65%">&nbsp;<%=checkNull(retItemText.getFieldValueString(i,"TEXTLINE"))%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Vendor Description</Td>
					<Td width="65%"><textarea rows="5" cols="30" disabled style="padding-top: 5px;"> </textarea></Td>
				</Tr>-->
				<Tr>
					<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
					<Td valign="middle" align="left" width="15%" colspan=5>
						<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
							<option value=''>--Select Tax Type--</option>
							<option value='SCGST'>SGST & CGST</option>
							<option value='IGST'>IGST</option>
							<option value='UGST'>UGST</option>
						</Select>
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;UOM</Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Quantity</B> </Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Currency </Td>
					<Td width="65%">&nbsp;<%=currency%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="" size="10" maxlength="10" readonly>
						<input  class=InputBox type="text" disabled name="testHSN<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
						<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')">
						<Font color='RED' size=2><B>Incorrect</B></Font>
					</Td>
				</Tr>

				<Tr>
					<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="0" size="6" maxlength="8"  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Discount </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
						<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>     
					<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>        
				
				<Tr>   
					<Td width="35%">&nbsp;Packing & Fowarding </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
						<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>  

				<Tr>  
					<Td width="35%">&nbsp;<B>Total Price</B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>


				<Tr>
					<Td width="35%">&nbsp;Central GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
						<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;State GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
						<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Integrated GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
						<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Union Trty GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
						<input  type="hidden" name="valType<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
							 	   					
				<Tr>
					<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="V"> 
						<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
						<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;GST on Freight </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				
				<Tr>
					<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
					<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
					<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="0" size="7" readonly></Td>
				</Tr>

				</table>
			</Td>
<%
			}
			if(i%3==2)
      			{
%>			
			<Td width="33%">
				<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
				<Tr>
					<Th <%=trBGColor%> width="100%" colspan=2><%=dtlXML.getFieldValueString(i,"ITEMDESCRIPTION")%></Th>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Material</Td>
					<Td width="65%">&nbsp;<%=rfqMatCode%></Td>
				</Tr>
				<!--<Tr>
					<Td width="35%">&nbsp;Enquiry Description</Td>
					<Td width="65%">&nbsp;<%=checkNull(retItemText.getFieldValueString(i,"TEXTLINE"))%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Vendor Description</Td>
					<Td width="65%"><textarea rows="5" cols="30" disabled style="padding-top: 5px;"> </textarea></Td>
				</Tr>-->
				<Tr>
					<Td width="15%">Applicable Tax &nbsp;&nbsp;</Td>
					<Td valign="middle" align="left" width="15%" colspan=5>
						<Select name='applTax<%=rfqItemPos%>' onChange="enableTaxes('<%=rfqItemPos%>')">
							<option value=''>--Select Tax Type--</option>
							<option value='SCGST'>SGST & CGST</option>
							<option value='IGST'>IGST</option>
							<option value='UGST'>UGST</option>
						</Select>
					</Td>
				</Tr>				
				<Tr>
					<Td width="35%">&nbsp;UOM </Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"UOMPURCHASE")%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Quantity </B></Td>
					<Td width="65%">&nbsp;<%=dtlXML.getFieldValueString(i,"ORDEREDQUANTITY")%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Currency </Td>
					<Td width="65%">&nbsp;<%=currency%></Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Coromandel HSN/SAC Code </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="hsnCode<%=rfqItemPos%>" value="" size="10" maxlength="10" readonly>
						<input  class=InputBox type="text" disabled name="testHSN<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
						<input type='checkbox' name='hsnIncorrect' value='X' onClick="allowVndrHSNEntry(this,'<%=rfqItemPos%>')">
						<Font color='RED' size=2><B>Incorrect</B></Font>
					</Td>
				</Tr> 

				<Tr>
					<Td width="35%">&nbsp;Your(Vendor) HSN/SAC Code </Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" disabled name="vndrHSNCode<%=rfqItemPos%>" value="<%=checkNull((String)materialHSNCodeHT.get(rfqMatCode))%>" size="10" maxlength="10">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;<B>Price per Unit </B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" name="itemPrice<%=rfqItemPos%>" value="0" size="6" maxlength="8"  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;<%=currSymbol%><input  <%=inpBoxColor%>  type="text" name="itemPriceTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Discount </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeDISC<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemDISCCode<%=rfqItemPos%>"  value="DISC"> 
						<input  class=InputBox type="text" name="itemDISCVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemDISCTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>
				<Tr>     
					<Td width="35%">&nbsp;<B>Price After Discount </B></Td> 
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemPriceAftrDISC<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotValAftrDISC<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>        
				
				<Tr>   
					<Td width="35%">&nbsp;Packing & Fowarding </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypePKFW<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemPKFWCode<%=rfqItemPos%>"  value="PKFW"> 
						<input  class=InputBox type="text" name="itemPKFWVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemPKFWTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>  

				<Tr>  
					<Td width="35%">&nbsp;<B>Total Price</B></Td>
					<Td width="65%">&nbsp;
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFinalPrice<%=rfqItemPos%>" value="0" <%=taxFieldsSize%> readonly>
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFinalTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
					</Td>
				</Tr>


				<Tr>
					<Td width="35%">&nbsp;Central GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemCGSTCode<%=rfqItemPos%>"  value="CGST"> 
						<input  type="hidden" name="valTypeCGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemCGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemCGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrCGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;State GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemSGSTCode<%=rfqItemPos%>"  value="SGST"> 
						<input  type="hidden" name="valTypeSGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemSGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemSGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrSGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Integrated GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemIGSTCode<%=rfqItemPos%>"  value="IGST"> 
						<input  type="hidden" name="valTypeIGST<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemIGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemIGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrIGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;Union Trty GST </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="itemUGSTCode<%=rfqItemPos%>"  value="UGST"> 
						<input  type="hidden" name="valType<%=rfqItemPos%>"  value="P"> 
						<input  class=InputBox type="text" name="itemUGSTVal<%=rfqItemPos%>"  value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')" disabled>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemUGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrUGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
							 	   					 
				<Tr> 
					<Td width="35%">&nbsp;Freight & Transit (Est) </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRT<%=rfqItemPos%>"  value="V"> 
						<input  type="hidden" name="itemFRTCode<%=rfqItemPos%>"  value="FRT"> 
						<input  class=InputBox type="text" name="itemFRTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>  onBlur="checkNum(this,'<%=rfqItemPos%>')">
						&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRT<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				<Tr>
					<Td width="35%">&nbsp;GST on Freight </Td>
					<Td width="65%">&nbsp;
						<input  type="hidden" name="valTypeFRTGST<%=rfqItemPos%>"  value="P"> 
						<input  type="hidden" name="itemFRTGSTCode<%=rfqItemPos%>"  value="FRT_GST"> 
						<input  class=InputBox type="text" <%=inpBoxColor%> name="itemFRTGSTVal<%=rfqItemPos%>" value="0" <%=taxFieldsSize%>>%
						&nbsp;<%=currSymbol%>&nbsp;<input  <%=inpBoxColor%> class=InputBox type="text" name="itemFRTGSTTotVal<%=rfqItemPos%>" value="0" size="7" readonly>
						<input type="hidden" name="itemTotValAftrFRTGST<%=rfqItemPos%>"  value="0">
					</Td>
				</Tr>
				
				<Tr>
					<Td width="35%">&nbsp;<B>Item Total Value </B></Td>
					<Td width="30%"2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=currSymbol%>&nbsp;
					<input  <%=inpBoxColor%> class=InputBox type="text" name="itemTotalValue<%=rfqItemPos%>" value="0" size="7" readonly></Td>
				</Tr>

				</table>
			</Td>
<%
		}
      		if((i+1)==Count)
      		{
%>
			</Tr>
			</Table>
<%
		}
	}
%>
<br>
<%
if(docCommentsRet.getRowCount()>0)
	{
%>
		<Div>            
			 <Table class="table" style="width:100%" border=1>
			<thead>
				<th style="text-align:center;color: white;background-color: #59584C !important">Name</th>
				<th style="text-align:center;color: white;background-color: #59584C !important">Comments Date</th>
				<th style="text-align:center;color: white;background-color: #59584C !important">Comments</th>
							        
			</thead>
	        	<tbody>
<%
			//out.println("countcountcount"+docCommentsRet.getRowCount());
			for(int s=0;s<docCommentsRet.getRowCount();s++)
			{
				String userid = checkNull(docCommentsRet.getFieldValueString(s,"EDC_USER_ID"));
				String commentedOn = checkNull(docCommentsRet.getFieldValueString(s,"EDC_DATE"));
				String comments = checkNull(docCommentsRet.getFieldValueString(s,"EDC_COMMENTS"));

				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = formatter.parse(commentedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				String commentedOnDate = formatter.format(date);
				try
				{
				userid=Integer.parseInt(userid)+"";
				}
				catch(Exception e){userid = docCommentsRet.getFieldValueString(s,"EDC_USER_ID");}
%>
				
				<tr>
<%
					int index=-1;
					if(UserNamesRetObj!=null)
					{

						index=UserNamesRetObj.getRowId("EU_ID",userid);
						userName=checkNull(UserNamesRetObj.getFieldValueString(index,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(index,"EU_LAST_NAME"));

					}
%>
						
						<td align="center"><%=userName%></td>
						<td align="center"><%=commentedOnDate%></td>
						<td align="center"><%=comments%></td>
				</tr>

<%
			}
%>
			
			</tbody>
  			</table>

               </Div>
<%
	}
	%>
<Div class="box" >            
	       			<Div class="box-header" style="background-color: #59584C;color:white;">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>COMMENTS</B></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>	<br>
	
	<center>
		<button type="button" class="btn btn-primary" onclick="goBack()">Back</button>  &nbsp;	
		<button type="button" class="btn btn-primary" onclick="SubmitQuote()">Submit</button>  &nbsp;	
		<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload()">Upload Docs</button>
		<button type="button" class="btn btn-primary" onclick="funReset()">Clear</button>  &nbsp;	
	</center>
	
	<%@ include file="../Misc/AddMessage.jsp" %>
<input type="hidden" name="allconditions" value="">
</form>
<Div id="MenuSol"></Div>
</body>
</html>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script>
function funUpload()
{

	var Url="../Shipment/ezAttachFileNew.jsp";
		$.fancybox.open({
		href : Url,
		type : 'iframe',
		padding : 5,
		width:'50%',
		height:'450px',
		autoSize : false,
		closeBtn : true,
		helpers     : {  
				overlay : {closeClick: false}
		 }
	});
}
</script>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
$(document).ready(function() {
		
       $("#priceValidUpto").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
              	changeMonth: true,
          	changeYear: true
       });
       
 });
  
</script>