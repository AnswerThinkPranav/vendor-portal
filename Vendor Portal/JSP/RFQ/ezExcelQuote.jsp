<%@page import="java.io.*"%><%@page import="java.util.*"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 1);
	response.setHeader("Cache-Control", "no-cache");
%>
<jsp:useBean id="EzGlobal" class="ezc.ezbasicutil.EzGlobal" scope="session" /> 
<%@ include file="../../../Includes/Jsps/Rfq/iViewRFQDetails.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iRFQNumberXLS.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iGetCurrJCO.jsp"%>
<%@ include file="../Rfq/ezGetMatUnits.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*"%>
<%@ page import="ezc.ezupload.MultipartRequest" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%

	String reQtFlg  = "N";
	String itemSpec = "";
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
	String topWidth="63%";
	

	if("Y".equals(ReQuote) || serviceRFQ)
	topWidth="62%";
	
	String priceString[] =request.getParameterValues("priceString");
	String qtyString[] =request.getParameterValues("quantityString");
	String currencyString[] =request.getParameterValues("currencyString");
	String valType[] =request.getParameterValues("valType");
	String taxCode[] =request.getParameterValues("taxCode");
	String itemCond[] =request.getParameterValues("itemCond");
	String remarks = "";
	boolean displaySubmit=true;
	
	if("Y".equals(relIndicator))displaySubmit=false;
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
String curr="";
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
function itemSpec(mitemSpec,item,noteType)
{
	document.myForm.target = "PopUp";
	document.myForm.action= "../Rfq/ezReadItemSpec.jsp?ItemSpec="+mitemSpec+"&ItemNo="+item+"&noteType="+noteType;
	newWindow=window.open("","PopUp","width=500,height=400,left=300,top=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	document.myForm.onsubmit = newWindow;
	document.myForm.submit();
}

function funUld()
{
	document.getElementById('light').style.display='block';
	document.getElementById('fade').style.display='block'

}
function funUpload()
{
	if(document.myForm.path.value=="")
	{
		alert("Please select document path");
		return false;
	}

	var reQuote=document.myForm.reQuote.value ;
	var EndDate=document.myForm.EndDate.value ;
	var PurchaseOrder=document.myForm.PurchaseOrder.value ;
	document.getElementById('light').style.display='none';
	document.getElementById('fade').style.display='none'	
	
	document.myForm.action="ezExcelQuote.jsp?reQuote="+reQuote+"&EndDate="+EndDate+"&PurchaseOrder="+PurchaseOrder;
	document.myForm.submit();	

}
</Script>
<style>
.black_overlay
{
	display: none;
	position: absolute;
	top: 0%;
	left: 0%;
	width: 100%;
	height: 100%;
	background-color: black;
	z-index:1001;
	-moz-opacity: 0.8;
	opacity:.80;
	filter: alpha(opacity=80);
}
.white_content
{
	display: none;
	position: absolute;
	top: 25%;
	left: 25%;
	width: 50%;
	height: 50%;
	padding: 16px;
	border: 16px solid #F3F3F3;
	background-color: white;
	z-index:1002;
	overflow: auto;
}
</style>

</Head>

<body onLoad="scrollInit(<%=scrollInit%>)" onResize="scrollInit(<%=scrollInit%>)">
<form name="myForm" method="post">

	<input type="hidden" name="attachFlag" value ="N">
	<input type="hidden" name="fromPage" value ="ExcelQuote">
	<input type="hidden" name="attachDocs" value ="" >	
	<input type="hidden" name="ext3Type" value="<%=ext3Type%>">
	<input type="hidden" name="status" value="<%=quoteStatus%>">
	<input type="hidden" name="ext" value="<%=extStatus%>">
	<input type="hidden" name="rfqVendor" value="<%=rfqVend%>">
	<input type="hidden" name="ReQuote" value="<%=ReQuote%>">
	<input type="hidden" name="reQuote" value="<%=reQuote%>">
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" value="<%=poNum%>" name="PurchaseOrder">


<%	
	String quoteExRate="";
	if(poNum.equals(xlsRFQNum.trim()))
	{	

	String userType = (String)session.getValue("UserType");
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	Vector types = new Vector();
	types.addElement("date");
	String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
        	
	
%>	

	
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	
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
      			<td valign="middle" align="left" width="15%">
      			<input type="hidden" name="RfqNo" value="<%=poNum%>"><%=poNum%></td>
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
		<th width="12%">Material</th>
		<th width="22%">Description</th>
		<th width="5%">UOM</th>
		<th width="7%">Qty</th>
		<th width="10%">Price<font color=red>* </font></th>
		<th width="8%">Currency</th>
		<Th width="12%">Delivery Date</Th>
<%
		if(quotation==null || "null".equals(quotation.trim())) quotation="";
		

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
		      	<th width="7%">Buyer Note</th>
		      	<th width="7%">Vendor Note</th>
	</tr>
	</table>
 	</div>

	<DIV  style="overflow:auto;position:absolute;width:94%;top=<%=topWidth%>;height:30%;left:3%">
	<TABLE  width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="94%">
<%

	
	if(!"".equals(vndrDefCurr)) curr=vndrDefCurr;
	else curr="INR";
//******************************************

	String xlsValid="YES";

	if (upFile!= null)
	{    
		String purreq = "";
		
		Iterator rowIter = null;

		if(mySheet!=null)
		rowIter = mySheet.rowIterator();
			
			

		try
		{
			int firstRow=0;
			int i=0;

			while (rowIter.hasNext()) 
			{

				String matDetails = "";
				String mNum="";		
				String mdesc="";
				String mUOM="";
				String mQunty="";
				String mPrice="";
				String mitemSpec="",vendItemNote="";
				String dispString="";
				String dispStringQty="";
				String matValue	="";
				String valTypeStr="";
				String taxCodeStr="";


				fd = new ezc.ezutil.FormatDate();
				java.util.Date delDate = (java.util.Date)dtlXML.getFieldValue(i,"CONFIRMDELIVERYDATE");
				String delDateString = fd.getStringFromDate(delDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));						

				HSSFRow myRow = (HSSFRow) rowIter.next();
				if(firstRow==0)
				firstRow = firstRow+1;				


				else
				{
					String rfqItem = (10*firstRow)+"";

					String tempRFQItem = "00000"+rfqItem;
					try{
						tempRFQItem = tempRFQItem.substring(tempRFQItem.length()-5,tempRFQItem.length());
					}catch(Exception e){}

					if(valType!=null && valType[i] != null)
					valTypeStr=valType[i];


%>
					<tr>
					<input type=hidden name="ItemNo" value="<%=tempRFQItem%>">
					
<%
					Iterator cellIter = myRow.cellIterator();
					int cellCnt=0;
					String cValue="";
					while (cellCnt<10) 
					{
						HSSFCell myCell = null;
						String celValue="";

						if(cellIter.hasNext())
						{
							myCell = (HSSFCell) cellIter.next();
							celValue=(String)myCell.toString();
						}	


						if(cellCnt==2)
						{
							//celValue = "000000000000000000"+celValue.trim();
							//celValue = celValue.substring(celValue.length()-18);
							mNum=celValue;
%>

							<td width="12%" align="center">&nbsp;
<%
							try
							{
								out.println(Long.parseLong(mNum));
							}
							catch(Exception e)
							{
								out.println(mNum);
							}
%>
							</td>							
<%
						}
						if(cellCnt==3)
						{
							celValue = celValue.replaceAll("'", "`");
							mdesc=celValue;

%>
							<td width="22%" align="center"><%=celValue%>&nbsp;</td>
							<input type="hidden" name="hdnMatDesc" value="<%=mdesc%>">											
							<input type="hidden" name="txtMatDesc" value="<%=mdesc%>" >
<%
						}
						if(cellCnt==4)
						{

							mUOM=celValue.trim();

%>
							<td width="5%" align="center"><%=celValue%>&nbsp;</td>
<%
						}
						if(cellCnt==5)
						{

							if (celValue.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+"))
							{
								mQunty=celValue;
							}
							else
							{
								dispStringQty="<Font color=\"red\"><B>Illegal characters in Quantity</B></Font>";
								xlsValid="NO";
							}


%>
							<td width="7%" align="center"><%=celValue%>&nbsp;</td>
							<Input type="hidden" name="updtdQty" value="<%=mQunty%>">
<%
						}
						if(cellCnt==6)
						{
							if (celValue.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+"))
							{
								mPrice=celValue;
							}
							else
							{
								dispStringQty="<Font color=\"red\"><B>Illegal characters in Quantity</B></Font>";
								xlsValid="NO";
							}  

%>
							<td width="10%" align="center">&nbsp;
							<input type="text" name="Price" size=8 maxlength=10 class=InputBox value="<%=mPrice%>">
							</td>
<%
						}
						
						if(cellCnt==8)
						{
								mitemSpec=celValue.trim();
%>

							<input type="hidden" name="ItemSpec" size=8 maxlength=10  value="<%=mitemSpec%>">
							
<%
						}	
						if(cellCnt==9)
						{
								vendItemNote=celValue.trim();
%>

							<input type="hidden" name="VendItemNote" size=8 maxlength=10 value="<%=vendItemNote%>">
							
<%
						}						
						
						


						cellCnt = cellCnt+1;								

					}
					if(itemCond!=null && itemCond[i] != null)
					taxCodeStr=itemCond[i];
					else
					{
						if(!"Y".equals(ReQuote))
						{
							while (cellCnt<28)
							{
								HSSFCell myCell = null;
								String celValue="";

								if(cellIter.hasNext())
								{
									myCell = (HSSFCell) cellIter.next();
									celValue=(String)myCell.toString();
								}	

								if(cellCnt==10 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "RA01$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^RA01$$"+celValue+"$$INR$$-$$-$$P";
								}
								if(cellCnt==11 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "RB00$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^RB00$$"+celValue+"$$INR$$-$$-$$P";
								}
								if(cellCnt==12 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "RC00$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^RC00$$"+celValue+"$$INR$$-$$-$$P";
								}
								if(cellCnt==13 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZPA1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZPA1$$"+celValue+"$$INR$$-$$-$$P";
								}
								if(cellCnt==14 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZPB1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZPB1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==15 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZPC1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZPC1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==16 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "FRA1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^FRA1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==17 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "FRB1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^FRB1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==18 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "FRC1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^FRC1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==19 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZIN1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZIN1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==20 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZEX1$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZEX1$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==21 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZEX1$$"+celValue+"$$INR$$-$$-$$A";
									else
									taxCodeStr = taxCodeStr+"^^ZEX1$$"+celValue+"$$INR$$-$$-$$A";
								}if(cellCnt==22 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZVAT$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZVAT$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==23 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "WCTQ$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^WCTQ$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==24 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZCST$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZCST$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==25 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZSRT$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZSRT$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==26 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZP20$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZP20$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==27 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZP21$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZP21$$"+celValue+"$$INR$$-$$-$$P";
								}if(cellCnt==28 && !"".equals(celValue))
								{
									if("".equals(taxCodeStr))
									taxCodeStr = "ZP22$$"+celValue+"$$INR$$-$$-$$P";
									else
									taxCodeStr = taxCodeStr+"^^ZP22$$"+celValue+"$$INR$$-$$-$$P";
								}

								cellCnt = cellCnt+1;
							}
						}
					}

%>
					<td width="8%" align="center">
						<select name="Curr" class=InputBox style="width:100%" id="CalendarDiv">
<%
						if(vendorCurr.size()==0)
%>
							<option value="">Select Currency</option>
<%								
						else	
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
					<td width="12%" align="center">
						<input type="text" class=InputBox  style="width:50%;valign:top" name="delivDateCal<%=i%>"  id="delivDateCal<%=i%>" value="<%=delDateString%>" size=10 readonly onfocus=this.blur()>
						<%=getDateImageFromToday("delivDateCal"+i)%> 
					</td>
					<input type="hidden" name="itemCond" value="<%=taxCodeStr%>">
					<input type="hidden" name="taxCode" value="">
					<input type="hidden" name="valType" value="<%=valTypeStr%>">

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

				<!--<td align="center" width="9%">
				<a href="javascript:onClick=editNote('<%=(i+1)*10%>')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
				</td>-->
				<td align="center" width="7%">
				<a href="javascript:onClick=itemSpec('<%=mitemSpec%>','<%=(i+1)*10%>','B')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
				</td>
				
				<td align="center" width="7%">
				<a href="javascript:onClick=itemSpec('<%=vendItemNote%>','<%=(i+1)*10%>','V')"><img   src="../../Images/Common/edit-button.gif" border="none" valign=bottom style="cursor:hand"></a>
				</td>
				
				</tr>
<%
				i=i+1;
				firstRow = firstRow+1;
				}

			}
		}catch(Exception Ex){out.println(Ex+":::Exception:::");}
		finally{
			fs.close();
		}


	boolean success = upFile.delete();
		
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
	if("Y".equals(relIndicator))
	{
%>
	<div style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
	<Table align=center>
		<Tr><Td ><font color="red" size="4px">*RFQ got closed.</font></Td></Tr>
	</Table>
	</div>
<%
	}
	}
	else
	{
%>	
		<Div style="position:absolute;top:40%;width:100%;visibility:visible" align="center">
		<Table align=center width="50%">
		<Tr>
			<Td align=center><Font color="red" size="3px">You have uploaded wrong RFQ details.<br>Please upload details of RFQ:<B><%=poNum%></B></Font></Td>
		</Tr>
		</Table>
		</Div>
		
<%		
	
	}
%>
	<br>
	<div id="buttons" style="position:absolute;top:93%;width:100%;visibility:visible" align="center">
		<span id="EzButtonsSpan" >	
<%
	if(poNum.equals(xlsRFQNum))
	{	
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
    	}
    	else
    	{
    		buttonName.add("Upload Quote");
    		buttonMethod.add("funUld()");
    	}
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

	<div id="light" class="white_content">

		<BR>
		<Table width=100% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
			<Tr>
				<Th width ="20%" align= right><nobr>Upload File :</nobr></th>
				<Td width="80%"> <input type="file" name="path" class=inputbox  style="width:100%">
				</Td>
			</Tr>	
		</Table>

		<div id="ButtonDiv11" style="position:absolute;top:55%;width:100%;visibility:visible">
			<center>
				<Span id="EzButtonsSpan11" >
					<a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">Cancel</a>
					&nbsp;<a href = "javascript:void(0)" onclick = "funUpload()">Submit</a>
				</Span>
			</center>
		</Div>		
		
	</div>
	<div id="fade" class="black_overlay"></div>



	
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
