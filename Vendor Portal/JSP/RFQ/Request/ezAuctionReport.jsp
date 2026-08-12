<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*" %>

<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%//@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@include file="../../../Includes/JSPs/Request/iCurrentAuctionDetails.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%
	session.putValue("AUCTION_WF_UPDATE","");
	status=auctionHeader.getFieldValueString(0,"EAH_AUCTION_STATUS");
	String wfStatus="",wfTemplate="",wfNextPart="";
	int wfCurStep=0;
	boolean showApprove=false;
	boolean showSubmit=false;
	boolean showReject=false;
	boolean showCreate=false;
	boolean showCondEdit=false;
	BigDecimal docVal=new BigDecimal(0.00);
	ReturnObjFromRetrieve retWFDocDetails= ezMiscSelect(Session,"SELECT * FROM EZC_WF_DOC_HISTORY_HEADER WHERE EWDHH_DOC_ID='"+auctionId+"'");
	String gv_VendCat = "DOM";
	
	Hashtable<String,BigDecimal> htRecQty=new Hashtable<String,BigDecimal>();
	ReturnObjFromRetrieve retAucRecItems= ezMiscSelect(Session,"SELECT * FROM EZC_AUCTION_RECOMMENDED_ITEMS WHERE EARI_AUCTION_ID='"+auctionId+"'");
	for(int i=0;i<retAucRecItems.getRowCount();i++)
	{
		htRecQty.put(retAucRecItems.getFieldValueString(i,"EARI_ITEM_ID")+"_"+retAucRecItems.getFieldValueString(i,"EARI_SUPPLIER_ID"),new BigDecimal(retAucRecItems.getFieldValueString(i,"EARI_PO_QTY")));
	}
	
	boolean isRecEdit=false;
	if(retWFDocDetails == null || retWFDocDetails.getRowCount() == 0)
		isRecEdit = true;
	
%>
<%@ include file="ezGetAuctionConditons.jsp"%>
<html>
<head>
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

<script src="../../Library/JavaScript/ezTrim.js"></script>
<script src="../../../../EzCommon/Library/plugins/jspdf/jspdf.debug.js"></script>
<script src="../../../../EzCommon/Library/plugins/jspdf/html2canvas.js"></script>
<script>
	function funDowload()
	{		
		document.myForm.action="ezDownloadAuctionReport.jsp"
		document.myForm.submit()
	}
	function funCreateWF()
	{	
		var lineItemId=document.myForm.lineItemId;
		var lineSupId=document.myForm.lineSupId;
		if(isNaN(lineItemId.length))
		{
			var itemPOS=lineItemId.value+"_"+lineSupId.value;
			if(eval("document.myForm.itemQty"+itemPOS).value != eval("document.myForm.rfqItemQty"+itemPOS).value)
			{
				alert("Recommended quantity does not match with total quantity");
				return ;
			}
		}
		else
		{
			for(i=0;i<lineItemId.length;i++)
			{
				var itemRecQty = 0.0;
				var itemTotQty = 0.0;
				var tempMatDesc = "";
				var tempArr = [];
				for(j=0;j<lineSupId.length;j++)
				{
						
					if(tempArr.includes(lineSupId[j].value))
						continue;
					else
						tempArr.push(lineSupId[j].value);
					var itemPOS=lineItemId[i].value+"_"+lineSupId[j].value;
					var tempItemQty = eval("document.myForm.itemQty"+itemPOS).value;
					var tempItemRecQty = eval("document.myForm.rfqItemQty"+itemPOS).value;
					if(tempItemQty == "" || parseFloat(tempItemQty) <= 0)
						continue;
					if(itemRecQty == 0.0)
					{
						itemRecQty = parseFloat(tempItemQty);
						tempMatDesc = eval("document.myForm.itemMatNum"+itemPOS).value;
					}
					itemTotQty += parseFloat(tempItemRecQty);
				}
				if(itemRecQty != itemTotQty)
				{
					alert("Recommended quantity does not match with total quantity for item :"+tempMatDesc);
					return ;
				}
				
			}
		}
		document.myForm.action="ezSaveAuctionWF.jsp"
		document.myForm.submit()
	}
	function funSubmit(submitType)
	{	
		document.myForm.submitType.value=submitType;
		document.myForm.action="ezUpdateAuctionWF.jsp"
		document.myForm.submit()
	}
	
	function showItems(obj)
	{
	
		openImg = new Image();
		openImg.src = "../../Images/Others/tree-select.gif";
		
		closeImg = new Image();
		closeImg.src = "../../Images/Others/tree-closed.gif";
		
		var spanObj = document.getElementById("span"+obj)
		imgobj	=document.getElementById("IMG"+obj);
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

	function hideAll()
	{
		var elements1 = document.getElementsByTagName("span")
		for(var i=0;i<elements1.length;i++)
		{
			elements1[i].style.visibility="hidden"
			elements1[i].style.display="none"
		}
	}

	
	
	function ezBackCall()
		{
					window.history.go(-1);
					return false;
	}
	
	function funPrint()
	{
		//var url="ezViewCompletedAuctionPrint.jsp?auctionId=<%=auctionId%>&auctionName=<%=auctionName%>&status=<%=status%>"
		//window.open(url,"newwin11","width=850,height=500,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		window.print();
	}
	
	
function funSummary()
{
	var url="ezViewSummary.jsp?auctionId=<%=auctionId%>";
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}	
function closeIframe()
{
	   $('#woModal').modal('toggle');
}
function funShowApprovalHirearchy(compCode,plant,category,docValue)
{
	var url="../Misc/ezShowApprovalHirearchy.jsp?compCode="+compCode+"&plant="+plant+"&category="+category+"&docValue="+docValue;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
function funAuditTrail(docId,docType)
{
	var url="../Misc/ezShowAuditTrail.jsp?docId="+docId+"&docType="+docType;
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}
</script>
<script>


function funPDFDownload() {
/*
            html2canvas(document.getElementById('headTable'), {
                onrendered: function (canvasObj) {
                    var pdf = new jsPDF('P', 'pt', 'a4'),
                        pdfConf = {
                            pagesplit: false,
                            backgroundColor: '#FFF'
                        };
                    document.body.appendChild(canvasObj); //appendChild is required for html to add page in pdf
                    pdf.addHTML(canvasObj, 0, 0, pdfConf, function () {
                        document.body.removeChild(canvasObj);
                        //pdf.addPage();
                        pdf.save('Test.pdf');
                    });
                }
            });
            */
            $(".hideprint").show();
            html2canvas(document.getElementById('headTable'), {
	                    onrendered: function (canvas) {
	                       $(".hideprint").hide();
	                        var pdf = new jsPDF('P', 'pt', 'a4'),
	                            pdfConf = {
	                                pagesplit: false,
	                                backgroundColor: '#FFF'
	                            };
	                        document.body.appendChild(canvas); //appendChild is required for html to add page in pdf
	                        var imgData = canvas.toDataURL('image/png');
					    var imgWidth = 210; 
					    var pageHeight = 295;  
					    var imgHeight = canvas.height * imgWidth / canvas.width;
					    var heightLeft = imgHeight;
					    var doc = new jsPDF('p', 'mm');
					    //var img=new Image();
					    //img.src="http://10.165.16.5/JUBL/EzcLogin/header-logo.png";
					    //doc.addImage(img,'JPEG',10,10,50,50);
					   // doc.addImage('data:image/jpeg;base64,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','JPEG',10,10,40,20);
					    var position = 0;
					    
					    doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
					    heightLeft -= pageHeight;
					    
					    while (heightLeft >= 0) {
					      position = heightLeft - imgHeight;
					      doc.addPage();
					      doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
					      heightLeft -= pageHeight;
					    }
				
				doc.save( 'AUCTION-<%=auctionId%>.pdf');
				
	                    }
            });
            
            
        }
</script>
	<Script>
		var tabHeadWidth=95
		var tabHeight="25%"
	</Script>
	<script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
</head>
<body onResize="scrollInit(1)"  scroll=no <%=onLoadString%>>
<%@ include file="../Misc/ezSubHeader.jsp"%>		
<div class="box" style="padding: 13px;" id="headTable">
<div class="row">
<div class="col-xs-12 table-responsive">
<span class="logo-lg hideprint" style="display:none"><img src="../../../../../EzcLogin/header-logo.png" width="auto" height="55px" style="margin:5px;background-color: #ffffff"></span>
<form name="myForm" method="post">
<%
	String compCode = "5000";
	for(int i=0;i<itemCount;i++)
	{
		out.println("<input type='hidden' name='material' value='"+auctionItems.getFieldValueString(i,"EAI_MATERIAL")+"'>");
		out.println("<input type='hidden' name='itemDesc' value='"+auctionItems.getFieldValueString(i,"EAI_ITEM_CODE")+"'>");
		out.println("<input type='hidden' name='reservePrice' value='"+auctionItems.getFieldValueString(i,"EAI_TARGET_PRICE")+"'>");
	}
%>



<table class="table table-bordered">
<tr>
	<th align = "center">Auction Id</th>
	<td><%=auctionId%></td>
	<th align = "center">Start Date</th>
	<td><%=startDate%></td>
	<th align = "center">End Date</th>
	<td><%=endDate%>
	</td>
</tr>
<Tr>
	<th align = "center">Mode Of Transport</th>
	<td><%=auctionHeader.getFieldValueString(0,"EAH_EXT2")%>
	<input type="hidden" name="headerVarianceVal" value='<%=varianceValue%>'>	
	<input type="hidden" name="plant" value='<%=auctionHeader.getFieldValueString(0,"EAH_PLANT")%>'>	
	<input type="hidden" name="compCode" value='<%=compCode%>'>	
	<input type="hidden" name="category" value='<%=auctionHeader.getFieldValueString(0,"EAH_CATEGORY")%>'>	
	</td>
	<th align = "center">Auction Type</th>
		<td><%=isForwardAuction?"Forward":"Reverse"%>
	</td>
	<th align = "center">QCF NO</th>
		<td><%=auctionHeader.getFieldValueString(0,"EAH_EXT3")%>
	</td>
</tr>
</table>


<%
	String supplierName = "",supplierdata = "",lowSupplier="";
	if(retAuctionHistory.getRowCount()>0 && auctionItems.getRowCount()>0)
	{
%>	

		
		<table class="table table-bordered">
		<tr>
			<th  width = "10%">&nbsp;</th>
			<!--<th  width = "10%">PR No.</th>
			<th  width = "10%">PR Item</th>-->
			<th  width = "60%">Material</th>
			<th  width = "10%">UOM</th>
		</tr>
		
<%
		//out.println("supplierCodesupplierCode	"+supplierCode);
		//out.println("auctionItems>>	"+auctionItems.toEzcString());
		//out.println("retAuctionHistory		"+retAuctionHistory.toEzcString());
		int supCount = 0;
		String totvalueLines="0";
		for(int j=0;j<auctionItems.getRowCount();j++)
		{
			String drlPRNumAu = "",drlPRItemAu="";
			
			if(auctionItems.getFieldValueString(j,"EAI_EXT1")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT1").trim()))
				drlPRNumAu = auctionItems.getFieldValueString(j,"EAI_EXT1");
								
			if(auctionItems.getFieldValueString(j,"EAI_EXT2")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT2").trim()))
				drlPRItemAu = auctionItems.getFieldValueString(j,"EAI_EXT2");
			String matNum = auctionItems.getFieldValueString(j,"EAI_ITEM_CODE").trim();
			String itemId = auctionItems.getFieldValueString(j,"EAI_ITEM_ID").trim();
%>
			<table class="table table-bordered">
			<tr>
				<td width="10%" align=center><a href="javascript:showItems('<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>')"><img border=0 id="IMG<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>"  src="../../Images/Others/tree-select.gif"></a></td>
				<!--<td width="10%" align='center'>&nbsp;<b><%=drlPRNumAu%></b></td>				
				<td width="10%" align='center'>&nbsp;<b><%=drlPRItemAu%></b></td>-->
				<td width="60%"><b><%=matNum%>&nbsp;</b></td>
				<td width="10%"><b><%=matUOMTable.get(matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID"))%>&nbsp;</b></td>
			</tr>
			</table>
			<span id="span<%=matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID")%>" >
			<table class="table table-bordered">

			<tr>
				<th  width = "25%">Supplier Name</th>
				<!--<th  width = "20%">Bid Time</th>-->
				<th  width = "5%">Quantity</th>
				<th  width = "5%">Price(<%=currency%>)</th>
				<th  width = "10%">Value(<%=currency%>)</th>
				<th  width = "5%">Rank</th>
				<th  width = "15%">Rec. Qty</th>
				<th  width = "15%">Conditons</th>
				<th  width = "15%">Gross Val.</th>
			</tr>

<%							
			supplierName = "";supplierdata = "";lowSupplier="";
			//java.math.BigDecimal matPrice = null;
			Enumeration suppIds  = bidSummary.keys();
			int i = 0;
			String suId  ="",timeStamp ="",bidValue = "",sid = "";
			String[] supKey = new String[4];
			String[] matKeys = new String[2];
			while(suppIds.hasMoreElements())
			{
				
				String tempVal = "",matStr="",matPrice="",matRank="";
				double matValue=0.0;
				double matRecValue=0.0;
				

				suId 		 = (String)suppIds.nextElement();
				supplierdata 	 = (String)bidSummary.get(suId);
				
				try
				{
					supKey = supplierdata.split("##");
					supplierName   =  supKey[0];
					timeStamp      =  supKey[1];
					bidValue       =  supKey[2];
					sid            =  supKey[3];
					lowSupplier= suId;
	

					if(supplierName==null || "null".equals(supplierName.trim()))
						supplierName = suId;
						
					matStr 	 = (String)finalMatValueTable.get(sid+matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID"));					
						
					if(matStr!=null)
					{	
						try
						{
							matKeys = matStr.split("#");
							matValue = Double.parseDouble(matKeys[0]);//new java.math.BigDecimal(matKeys[0]).setScale(2,RoundingMode.HALF_UP)+"";
							matRank  = matKeys[1];
							matPrice = ((new java.math.BigDecimal(matKeys[0])).divide(new java.math.BigDecimal(auctionItems.getFieldValueString(j,"EAI_QUANTITY")),java.math.BigDecimal.ROUND_HALF_UP)).setScale(2, java.math.BigDecimal.ROUND_HALF_UP)+"";
							
							if("1".equals(matRank))
								docVal=docVal.add(new java.math.BigDecimal(matKeys[0]));
						}catch(Exception e){}
					}
					
				
				}
				catch(Exception e2)
				{
					//out.println(e2);
					ezc.ezcommon.EzLog4j.log("Exception Ocuured Getting Lowest Bid","I");
				}	
				
				//condition start
				String rfqItemPos = itemId+"_"+sid;
				String myQty=htRecQty.get(rfqItemPos)+"";
				try
				{
					matRecValue = Double.parseDouble(matPrice)*Double.parseDouble(myQty);
				}catch(Exception e){}
				double discValDB=0.0;
				String discTypeLine= "0";
				String condDiscLine= "0";
				String totItemVal="";
				int condIndex = retAucCondDetRet.getRowId("KEY",rfqItemPos);
				try{
					discTypeLine = checkNull(retAucCondDetRet.getFieldValueString(condIndex,"DISCTYPE")); 
					condDiscLine=retAucCondDetRet.getFieldValueString(condIndex,"DISCVAL");

				if("P".equals(discTypeLine))
					discValDB= matRecValue* Double.parseDouble(condDiscLine)/100;
				else if("Q".equals(discTypeLine))
					discValDB= (Double.parseDouble(myQty)* Double.parseDouble(condDiscLine));
				else if("V".equals(discTypeLine))
					discValDB= Double.parseDouble(condDiscLine);

				totItemVal=new java.math.BigDecimal(matRecValue-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(matRecValue-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){//out.println("exceptionin cal"+e);
				}
				//LINE PKFW
				String PKFWTypeLine= "0";
				String condPKFWLine= "0";
				double PKFWValDB=0.0;		
				try{
					PKFWTypeLine = checkNull(retAucCondDetRet.getFieldValueString(condIndex,"PKFWTYPE")); 
					condPKFWLine = checkNull_Num(retAucCondDetRet.getFieldValueString(condIndex,"PKFWVAL"));

						if("P".equals(PKFWTypeLine))
							PKFWValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condPKFWLine)/100;
						else if("Q".equals(PKFWTypeLine))
							PKFWValDB= (Double.parseDouble(myQty)* Double.parseDouble(condPKFWLine));
						else if("V".equals(PKFWTypeLine))
							PKFWValDB= Double.parseDouble(condPKFWLine);

				//totItemVal=new java.math.BigDecimal(matRecValue-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(matRecValue-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){//out.println("exceptionin cal"+e);
				}	
				//LINE FRT
				String FRTTypeLine= "0";
				String condFRTLine= "0";
				double FRTValDB=0.0;		
				try{
					FRTTypeLine = checkNull(retAucCondDetRet.getFieldValueString(condIndex,"FRTTYPE")); 
					condFRTLine = checkNull_Num(retAucCondDetRet.getFieldValueString(condIndex,"FRTVAL"));

						if("P".equals(FRTTypeLine))
							FRTValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condFRTLine)/100;
						else if("Q".equals(FRTTypeLine))
							FRTValDB= (Double.parseDouble(myQty)* Double.parseDouble(condFRTLine));
						else if("V".equals(FRTTypeLine))
							FRTValDB= Double.parseDouble(condFRTLine);

				//totItemVal=new java.math.BigDecimal(matRecValue-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(matRecValue-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){
				//out.println("exceptionin cal"+e);
				}			
				//LINE BFRT
				String BFRTTypeLine= "0";
				String condBFRTLine= "0";
				double BFRTValDB=0.00;		
				try{
					BFRTTypeLine = checkNull(retAucCondDetRet.getFieldValueString(condIndex,"BFRTTYPE")); 
					condBFRTLine = checkNull_Num(retAucCondDetRet.getFieldValueString(condIndex,"BFRTVAL"));

						if("P".equals(BFRTTypeLine))
							BFRTValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condBFRTLine)/100;
						else if("Q".equals(BFRTTypeLine))
							BFRTValDB= (Double.parseDouble(myQty)* Double.parseDouble(condBFRTLine));
						else if("V".equals(BFRTTypeLine))
							BFRTValDB= Double.parseDouble(condBFRTLine);



				//totItemVal=new java.math.BigDecimal(matRecValue-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(matRecValue-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){//out.println("exceptionin cal"+e);
				}			
				//LINE INS
				String INSTypeLine= "0";
				String condINSLine= "0";
				double INSValDB=0.00;		
				try{
					INSTypeLine = checkNull(retAucCondDetRet.getFieldValueString(condIndex,"INSTYPE")); 
					condINSLine = checkNull_Num(retAucCondDetRet.getFieldValueString(condIndex,"INSVAL"));

						if("P".equals(INSTypeLine))
							INSValDB= Double.parseDouble(totItemVal)* Double.parseDouble(condINSLine)/100;
						else if("Q".equals(INSTypeLine))
							INSValDB= (Double.parseDouble(myQty)* Double.parseDouble(condINSLine));
						else if("V".equals(INSTypeLine))
							INSValDB= Double.parseDouble(condINSLine);

				//totItemVal=new java.math.BigDecimal(matRecValue-discValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				//totvalueLines=new java.math.BigDecimal(Double.parseDouble(totvalueLines)+(matRecValue-discValDB)).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
				}
				catch(Exception e){
				//out.println("exceptionin cal"+e);
				}		


				double sPriceLine = 0.0;

				sPriceLine = matRecValue-discValDB+PKFWValDB+FRTValDB+BFRTValDB+INSValDB;

				//LINE TAX
				String TAXTypeLine= "";
				String condTAXLine= "0";
				double TAXValDB=0.0;		
				try{
					TAXTypeLine = retAucCondDetRet.getFieldValueString(condIndex,"GSTTYPE"); 
					//out.println("TAXTypeLine>>>"+TAXTypeLine);
					condTAXLine=retAucCondDetRet.getFieldValueString(condIndex,"GSTVAL");
					//out.println("condTAXLine>>>"+condTAXLine);

					TAXValDB= sPriceLine * Double.parseDouble(condTAXLine)/100;
					TAXValDB  = new java.math.BigDecimal(TAXValDB).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).doubleValue();
				}
				catch(Exception e){
				//out.println("exceptionin TAX"+e);
				}	

				double grossValLine=0.0;
				String grossValLineStr ="0.00";
				try{
					grossValLine = sPriceLine + TAXValDB;
					grossValLineStr = new java.math.BigDecimal(grossValLine).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();			

				}
				catch(Exception e){
				//out.println("exceptionin cal"+e);
				}			
				//conditions end
				
				
				
%>	
				<tr>

					<td width="25%">&nbsp;<%=supplierName%></td>
					<!--<td width="20%">&nbsp;<%=timeStamp%></td>-->
					<td width="5%">&nbsp;<%=auctionItems.getFieldValueString(j,"EAI_QUANTITY")%></td>			
					<td width="5%" align=right>&nbsp;<%=matPrice%></td>
					<td width="10%" align=right>&nbsp;<%=matValue%></td>
					<td width="5%" align=right>&nbsp;<%=matRank%></td>
					<td width="15%" align=right>
						<input type="hidden" name="lineItemId" value="<%=itemId%>">
						<input type="hidden" name="lineSupId" value="<%=sid%>">
						<input type="hidden" name="itemMatNum<%=rfqItemPos%>" value="<%=matNum%>">
						<input type=hidden name="itemQty<%=rfqItemPos%>"  style="width:100px;" size=9  class="form-control" value='<%=auctionItems.getFieldValueString(j,"EAI_QUANTITY")%>'>
						<input type="hidden" name="itemVal<%=rfqItemPos%>" value="0">  
						<input type="hidden" name="itemTotalVal<%=rfqItemPos%>" value="0.00"> 
						<input type="hidden" name="itemPrice<%=rfqItemPos%>" value="<%=matPrice%>"> 
						<input type="hidden" name="rfqItemCurr<%=rfqItemPos%>" value="INR"> 
						
						<input type="hidden" name="valTypeDISC<%=rfqItemPos%>" value="<%=discTypeLine%>">
						<input type="hidden" name="itemDISC<%=rfqItemPos%>" value="<%=condDiscLine%>">
						<input type="hidden" name="itemDISCCode<%=rfqItemPos%>" value="DISC">
						<input type="hidden" name="itemDISCVal<%=rfqItemPos%>" value="<%=discValDB%>"> 

						<input type="hidden" name="valTypePKFW<%=rfqItemPos%>" value="<%=PKFWTypeLine%>">
						<input type="hidden" name="itemPKFW<%=rfqItemPos%>" value="<%=condPKFWLine%>">
						<input type="hidden" name="itemPKFWCode<%=rfqItemPos%>" value="PKFW">
						<input type="hidden" name="itemPKFWVal<%=rfqItemPos%>" value="<%=PKFWValDB%>">  

						<input type="hidden" name="valTypeFRT<%=rfqItemPos%>" value="<%=FRTTypeLine%>">
						<input type="hidden" name="itemFRT<%=rfqItemPos%>" value="<%=condFRTLine%>">
						<input type="hidden" name="itemFRTCode<%=rfqItemPos%>" value="FRT">
						<input type="hidden" name="itemFRTVal<%=rfqItemPos%>" value="<%=FRTValDB%>">  

						<input type="hidden" name="valTypeBFRT<%=rfqItemPos%>" value="<%=BFRTTypeLine%>">
						<input type="hidden" name="itemBFRT<%=rfqItemPos%>" value="<%=condBFRTLine%>">
						<input type="hidden" name="itemBFRTCode<%=rfqItemPos%>" value="BFRT">
						<input type="hidden" name="itemBFRTVal<%=rfqItemPos%>" value="<%=BFRTValDB%>"> 

						<input type="hidden" name="valTypeINS<%=rfqItemPos%>" value="<%=INSTypeLine%>">
						<input type="hidden" name="itemINS<%=rfqItemPos%>" value="<%=condINSLine%>">
						<input type="hidden" name="itemINSCode<%=rfqItemPos%>" value="INS">
						<input type="hidden" name="itemINSVal<%=rfqItemPos%>" value="<%=INSValDB%>">    						

						<input type="hidden" name="itemSupplyPrice<%=rfqItemPos%>" value="<%=sPriceLine%>"> 

						<input type="hidden" name="valTypeTAX<%=rfqItemPos%>" value=<%=TAXTypeLine%>>
						<input type="hidden" name="itemTAX<%=rfqItemPos%>" value="<%=condTAXLine%>">
						<input type="hidden" name="itemTAXCode<%=rfqItemPos%>" value="TAX">
						<input type="hidden" name="itemTAXVal<%=rfqItemPos%>" value="<%=TAXValDB%>">  

						<input type="hidden" name="itemGrossVal<%=rfqItemPos%>" value="<%=grossValLineStr%>">    		

						<input type="hidden" name="itemSupplyPrice<%=rfqItemPos%>" value="0.00"> 
						<input type="hidden" name="itemGrossVal<%=rfqItemPos%>" value="0.00"> 
						&nbsp;<input type=text class='form-control' name='rfqItemQty<%=rfqItemPos%>' <%=(!isRecEdit?"readonly":"")%> onchange="javascript:saveConditions('<%=auctionId%>','<%=itemId%>','<%=rfqItemPos%>','','<%=isRecEdit%>');" value='<%=checkBigDecNull(htRecQty.get(rfqItemPos))%>' style="text-align:right">
					</td>
					<td align="center"><a href="javascript:saveConditions('<%=auctionId%>','<%=itemId%>','<%=rfqItemPos%>','','<%=isRecEdit%>');"><img src="../RFQ/cond.PNG" alt="Conditions"></a></td>     		
     				<td  align="center" nowrap><input type=number name="itemValue<%=rfqItemPos%>"  style="width:120px;" size=10  class="form-control" value='<%=grossValLineStr%>' readonly>
				</tr>
					
<%
			supCount++;
			i++;
			
		}

		if(supCount == 0)
		{
%>	
			<script>
				document.getElementById("IMG<%=matNum%>").style.visibility='hidden'
			</script>
<%
		}
%>
		</table>
		</span>
<%
	}
	docVal=docVal.setScale(2,RoundingMode.HALF_UP);
	if(retWFDocDetails != null && retWFDocDetails.getRowCount() > 0)
	{
		//docVal = auctionHeader.getFieldValueString(0,"EAH_CATEGORY");
		wfStatus=retWFDocDetails.getFieldValueString(0,"EWDHH_WF_STATUS");
		wfCurStep = Integer.parseInt(retWFDocDetails.getFieldValueString(0,"EWDHH_CURRENT_STEP"));
		wfTemplate = retWFDocDetails.getFieldValueString(0,"EWDHH_TEMPLATE_CODE");
		wfNextPart = retWFDocDetails.getFieldValueString(0,"EWDHH_NEXT_PARTICIPANT");

		if("SUBMITTED".equals(wfStatus) || "REJECTED".equals(wfStatus))
		{
			if(workGrpVect != null && workGrpVect.contains(wfNextPart))
			{
				ReturnObjFromRetrieve retWFDetails = getWFDetails(Session,wfTemplate,wfCurStep,wfNextPart);
				BigDecimal cmpVal=BigDecimal.valueOf((Long)retWFDetails.getFieldValue(0,"EWPC_QCF_RELEASE"));
				String cmpOp = retWFDetails.getFieldValueString(0,"EWPC_QCF_FLAG");
				if("LE".equals(cmpOp))
				{	
					if(cmpVal.compareTo(BigDecimal.ZERO) == 0 || cmpVal.compareTo(docVal) <= 0)
					{
						showSubmit=true;
						showReject=true;
					}
					else
					{
						showApprove=true;
						showReject=true;
					}
				}
				if("GE".equals(cmpOp))
				{	
					if(docVal.compareTo(cmpVal) >= 0)
					{
						showApprove=true;
						showReject=true;
					}
					else
					{
						showSubmit=true;
						showReject=true;
					}	
				}				
			}
		}
	}
	else
	{
		showCreate=true;
	}
	
%>
	</TD></TR>
	</Table>
<%
	//for(int l=0;l<10;l++)
	{
%>
	<table class="table table-bordered">
		<tr>
			<Th>Material</Th>
			<Th>Start Price(<%=currency%>)</Th>
			<Th>Budget Price(<%=currency%>)</Th>
			<Th>Reserve Rate(<%=currency%>)</Th>
			<Th><%=isForwardAuction?"Highest":"Lowest"%> Last Bid</Th>
			<Th>Saving Amount(<%=currency%>)</Th>
			<Th>Saving %</Th>
			<Th>Budget Saving Amount(<%=currency%>)</Th>
			<Th>Budget Saving %</Th>
			<Th>Reserve Saving Amount(<%=currency%>)</Th>
			<Th>Reserve Saving %</Th>
		</Tr>
<%
	BigDecimal totStartPrice = new BigDecimal(0.0);
	BigDecimal totBasePrice = new BigDecimal(0.0);
	BigDecimal totReservePrice = new BigDecimal(0.0);
	BigDecimal totLowestBidVal = new BigDecimal(0.0);
	BigDecimal totStartPriceSavings = new BigDecimal(0.0);
	BigDecimal totStartPricePer = new BigDecimal(0.0);
	BigDecimal totBaseLineSavings = new BigDecimal(0.0);
	BigDecimal totBaseLinePer =  new BigDecimal(0.0);
	BigDecimal totResPriceSavings = new BigDecimal(0.0);
	BigDecimal totResPricePer =  new BigDecimal(0.0);
	
	for(int j=0;j<auctionItems.getRowCount();j++)
	{
		String matNum = auctionItems.getFieldValueString(j,"EAI_ITEM_CODE").trim();
		String tempMatKey = auctionItems.getFieldValueString(j,"EAI_ITEM_CODE")+auctionItems.getFieldValueString(j,"EAI_ITEM_ID");
		ArrayList tempMatValues = (ArrayList)matArrayTable.get(tempMatKey);
		//Collections.sort(tempMatValues);
		if(isForwardAuction)
			Collections.sort(tempMatValues,Collections.reverseOrder());
		else
			Collections.sort(tempMatValues);
		
		BigDecimal startPrice = checkBigDecNull(auctionItems.getFieldValue(j,"EAI_INITIAL_PRICE"));
		BigDecimal basePrice = checkBigDecNull(auctionItems.getFieldValue(j,"EAI_BUDGET_PRICE"));
		BigDecimal reservePrice = checkBigDecNull(auctionItems.getFieldValue(j,"EAI_TARGET_PRICE"));
		BigDecimal bidQty = checkBigDecNull(auctionItems.getFieldValue(j,"EAI_QUANTITY"));
		BigDecimal lowestBidVal = new BigDecimal(0.0);
		BigDecimal startPriceSavings = new BigDecimal(0.0);
		BigDecimal startPricePer =  new BigDecimal(0.0);
		BigDecimal baseLineSavings = new BigDecimal(0.0);
		BigDecimal baseLinePer =  new BigDecimal(0.0);
		BigDecimal resPriceSavings = new BigDecimal(0.0);
		BigDecimal resPricePer =  new BigDecimal(0.0);
		
		
		
		try{
			lowestBidVal = new BigDecimal(tempMatValues.get(0)+"");
			if(lowestBidVal.compareTo(BigDecimal.ZERO) > 0)
			{
				lowestBidVal=lowestBidVal.divide(bidQty,2,RoundingMode.HALF_UP);
				startPriceSavings = startPrice.subtract(lowestBidVal);
				startPricePer =  startPriceSavings.multiply(new BigDecimal(100));
				startPricePer = startPricePer.divide(lowestBidVal,2,RoundingMode.HALF_UP);
				baseLineSavings = basePrice.subtract(lowestBidVal);
				if(baseLineSavings.compareTo(BigDecimal.ZERO) != 0)
				{
					baseLinePer =  baseLineSavings.multiply(new BigDecimal(100));
					baseLinePer = baseLinePer.divide(lowestBidVal,2,RoundingMode.HALF_UP);
				}
				resPriceSavings = reservePrice.subtract(lowestBidVal);
				if(resPriceSavings.compareTo(BigDecimal.ZERO) != 0)
				{
					resPricePer =  resPriceSavings.multiply(new BigDecimal(100));
					resPricePer = resPricePer.divide(lowestBidVal,2,RoundingMode.HALF_UP);
				}
				
			}
			totStartPrice=totStartPrice.add(startPrice);
			totBasePrice=totBasePrice.add(basePrice);
			totReservePrice=totReservePrice.add(reservePrice);
			totLowestBidVal=totLowestBidVal.add(lowestBidVal);
			totStartPriceSavings=totStartPriceSavings.add(startPriceSavings);
		}catch(Exception e){
			out.print(e);
		}
		
%>
	<tr>
		<td><%=matNum%></td>
		<td><%=startPrice%></td>
		<td><%=basePrice%></td>
		<td><%=reservePrice%></td>
		<td><%=lowestBidVal%></td>
		<td><%=startPriceSavings%></td>
		<td><%=startPricePer%></td>
		<td><%=baseLineSavings%></td>
		<td><%=baseLinePer%></td>
		<td><%=resPriceSavings%></td>
		<td><%=resPricePer%></td>
		
	</tr>
<%
	}
		totStartPricePer =  totStartPriceSavings.multiply(new BigDecimal(100));
		totStartPricePer = totStartPricePer.divide(totLowestBidVal,2,RoundingMode.HALF_UP);
		totBaseLineSavings = totBasePrice.subtract(totLowestBidVal);
		if(totBaseLineSavings.compareTo(BigDecimal.ZERO) != 0)
		{
			totBaseLinePer =  totBaseLineSavings.multiply(new BigDecimal(100));
			totBaseLinePer = totBaseLinePer.divide(totLowestBidVal,2,RoundingMode.HALF_UP);
		}
		totResPriceSavings = totReservePrice.subtract(totLowestBidVal);
		if(totResPriceSavings.compareTo(BigDecimal.ZERO) != 0)
		{
			totResPricePer =  totResPriceSavings.multiply(new BigDecimal(100));
			totResPricePer = totResPricePer.divide(totLowestBidVal,2,RoundingMode.HALF_UP);
		}

%>
	<tr>
		<th>Total</th>
		<td><%=totStartPrice%></td>
		<td><%=totBasePrice%></td>
		<td><%=totReservePrice%></td>
		<td><%=totLowestBidVal%></td>
		<td><%=totStartPriceSavings%></td>
		<td><%=totStartPricePer%></td>
		<td><%=totBaseLineSavings%></td>
		<td><%=totBaseLinePer%></td>
		<td><%=totResPriceSavings%></td>
		<td><%=totResPricePer%></td>
		
	</tr>	
<%
	}
	
%>
	</table>
	<table class="table table-bordered">
		<Tr>
			<Th>Auction Value</Th>
			<Td><%=docVal%></Td>
		</Tr>
	</Table>
<%			
	}	
%>
		<Br>	
<%
	int commentsCount = 0;
	ezc.vendortransactions.client.EzVendorTransactionsManager ezVendTransactions = new ezc.vendortransactions.client.EzVendorTransactionsManager();
	ezc.ezparam.EzcParams v_MainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();

	v_KeyParams.setKey("GET_DOC_COMMENTS");
	vendParams.setType("AUCTION");
	vendParams.setDocNo(auctionId);

	v_MainParams.setLocalStore("Y");
	v_MainParams.setObject(v_KeyParams);
	v_MainParams.setObject(vendParams);
	Session.prepareParams(v_MainParams);

	ezc.ezparam.ReturnObjFromRetrieve commentsRet = (ezc.ezparam.ReturnObjFromRetrieve)ezVendTransactions.ezGetVendorTransactions(v_MainParams);
	//out.print("commentsRet:::"+commentsRet.toEzcString());
	if(commentsRet != null)
		commentsCount = commentsRet.getRowCount();
	if(commentsCount>0)
	{
		SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
%>
	<table class="table table-bordered">
<%
		String displayStr ="";
		for(int i=0;i<commentsCount;i++)
		{
			if(i == 0)
			{
%>	
				<Tr <%=trBGColor%>><Th>User</Th><Th>Date</Th><Th>Comments</Th></Tr>
<%
			}
					displayStr = commentsRet.getFieldValueString(i,"EDC_COMMENTS");
%>				
				<Tr>
					<Td>&nbsp;<%=commentsRet.getFieldValueString(i,"EDC_USER_ID")+"["+checkNull(commentsRet.getFieldValueString(i,"EU_FIRST_NAME"))+"]"%></Td>
					<Td>&nbsp;<%=sdf.format((Date)commentsRet.getFieldValue(i,"EDC_DATE"))%></Td>					
					<Td title='<%=displayStr%>'>&nbsp;<%=displayStr%></TD>
				</Tr>
			
<%
		}	
%>
	</Table>
	<Br>
<%
	}
	
	ReturnObjFromRetrieve retUploadList = getUploadList(Session,auctionId,"AUCTWF"); 
	int retUploadListCnt = 0; 
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();
%>
		<h5>
			<b>Attachment(s)</b>
		</h5>
		<div class="row">
		  <div class="col-md-12 col-xs-12">
			<!-- general form elements -->
			<div class="box box-default">
				<div class="box-body table-responsive no-padding">
					<div class="box-body">
					       <table id="uploadTable<%=itemId%>" class="table  table-bordered dt-responsive nowrap" >
							<tr <%=trBGColor%>>
								<th width="95%" align='left'>File Name</th>
								<th width="5%"></th>
							</tr>
<%
		if(retUploadListCnt == 0)
		{
%>
			<tr id="noDataStatUpload">
				<td>No files attached</td>
			</tr>
<%
		}
		for(int r=0;r<retUploadListCnt;r++)
		{
%>
			<tr>
				<td align="left" width="95%"><input type="hidden" name="fileItem" value="<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>"><a href="javascript:downloadFile('<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%></a></td>
				<!--<td width="5%"><span onclick="javascript:deleteFile(this,'<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td>-->
				<td width="5%">&nbsp;</td>
				
			</tr>
<%
		}
%>
		</table>
	
			</div>
		      </div>
		     </div>
		    <!-- Your Page Content Here -->
		  </div>
		</div><!--row-->

<%
	if(showSubmit || showApprove || showCreate)
	{
%>
	
	<Table align="center" data-html2canvas-ignore="true" width="96%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
	<Tr <%=trBGColor%>>
		<Th align=left ><B>Enter your comments here</B></Th>
	</Tr>
	<Tr>	
		<Td class='blankcell' width='100%'>
			<textarea name = 'comments' style='width:1073px' rows=3 cols=73 onKeyPress='return maxLength(this,"2000");' onpaste='return maxLengthPaste(this,"2000");'></textarea>
		</Td>
	</Tr> 
	</Table>	

<%
	}
%>
	<br>
	<center data-html2canvas-ignore="true">
	
	
	
<%
		if(isvendIpAdd)
		{
%>
		<br>
			<div class="row">
			<div class="col-xs-12" align="center"><p><b><font color=red >**Different Vendors bidded from same IP adresses**</font></b></p></div>
			</div>
<%
		}
		if(detailCount > 0)
		{
			if(showCreate)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funCreateWF()" style="margin-right: 5px;"><i class="fa fa-check"></i> Submit</button>
<%
			}
			if(showSubmit)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('SUBMITTED')" style="margin-right: 5px;"><i class="fa fa-check"></i> Submit</button>
<%
			}
			if(showApprove || (showSubmit && "RRKLDBUY".equals(Session.getUserId())))	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('APPROVED')" style="margin-right: 5px;"><i class="fa fa-check"></i> Approve</button>
<%
			}
			if(showReject)	
			{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('REJECTED')" style="margin-right: 5px;"><i class="fa fa-remove"></i> Reject</button>
<%
			}
			if(showSubmit || showApprove || showCreate)
			{
%>
			<button type="button"  value="H" class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload Attachments</button>
<%
			}
			
%>				
				<button type="button" class="btn btn-primary" onclick="funSummary()" style="margin-right: 5px;"><i class="fa fa-history"></i> History</button>
				<button type="button" class="btn btn-primary" onclick="funPDFDownload()" style="margin-right: 5px;"><i class="fa fa-print"></i> Print</button>
				<button  type="button" class="btn btn-primary" onclick="fnExcelReport()"> <i class="fa fa-check"></i>&nbsp;Download Excel </button>
				
				<button type="button" class="btn btn-primary" onclick="funShowApprovalHirearchy('<%=compCode%>','<%=auctionHeader.getFieldValueString(0,"EAH_PLANT")%>','<%=auctionHeader.getFieldValueString(0,"EAH_CATEGORY")%>','<%=docVal%>')" style="margin-right: 5px;"><i class="fa fa-users"></i> Show Approval Hirearchy</button>
				<button type="button" class="btn btn-primary" onclick="funAuditTrail('<%=auctionId%>','AUCTION')" style="margin-right: 5px;"><i class="fa fa-list"></i> Audit Trail</button>
				<button type="button" class="btn btn-primary" onclick="ezBackCall()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Back</button>
<%		
		}
%>
	</center>
	
	


<%
	if(detailCount == 0)
	{
		String noDataStatement = "No bidding received for this Auction yet."; 
		if("3".equals(userType))
			noDataStatement += "<BR>If you like to place your bid <a href='javascript:participate()'><b>click here</b></a>";
		else 
		{
			if(!"C".equals(status))
				noDataStatement += "<BR>";
		}	
%>
		<div id=messageDiv >
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
		</div>
<%
	}


			for(int i=0;i<supplierCount;i++)
			{
%>			
			<input type="hidden" name="chk1" value="<%=auctionSupplier.getFieldValueString(i,"EAS_SUPPLIER_CODE")%>">
<%				
			}
%>			
<input type="hidden" name="auctiondate" value="<%=startDate%>">
<input type="hidden" name="status" 	value="<%=status%>">
<input type="hidden" name="auctionId" 	value="<%=auctionId%>">
<input type="hidden" name="auctionName" value="<%=auctionName%>">
<input type="hidden" name="supplierId" 	value="<%//=supplierId%>">
<input type="hidden" name="endDate" 	value="<%=endDateFormat%>">
<input type="hidden" name="actualEndDate" value="<%=auctionHeader.getFieldValueString(0,"EAH_END_DATE")%>">
<input type="hidden" name="timeLag" 	  value="<%=auctionHeader.getFieldValueString(0,"EAH_TIME_LAG")%>">
<input type="hidden" name="extensions" 	  value="<%=auctionHeader.getFieldValueString(0,"EAH_EXTENSIONS")%>">
<input type="hidden" name="extensionTime" value="<%=auctionHeader.getFieldValueString(0,"EAH_EXTENSION_TIME")%>">
<input type="hidden" name="evalFactor" 	  value="<%=evalFactor%>">
<input type="hidden" name="counter" 	  value="<%=counter%>">
<input type="hidden" name="submitToSelf" value="Y">
<input type="hidden" name="submitType" value="">
<input type="hidden" name="wfTemplate" value="<%=wfTemplate%>">
<input type="hidden" name="wfCurStep" value="<%=wfCurStep%>">
<input type="hidden" name="wfNextPart" value="<%=wfNextPart%>">
<input type="hidden" name="docVal" value="<%=docVal%>">
</form>
</div>
</div>
</div>
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal2" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content" style="width: 88%;">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="500" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="AUCTWF">
			<input type="hidden" id="upDocId" name="upDocId" value="<%=auctionId%>">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<input type="file" id="file" name="file"/>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div> 
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<script>
function saveConditions(auctionId,lineNO,itemPos,itemCat,editFlag)
{
	var itemQty = eval("document.myForm.rfqItemQty"+itemPos).value;
	var itemPrice = eval("document.myForm.itemPrice"+itemPos).value; 
	var currency = eval("document.myForm.rfqItemCurr"+itemPos).value;
	//if(itemPrice=="" || itemPrice=="0")
	if(itemQty=="" || itemQty == "0")
	{
		alert("Please Enter Recommended Quantity of the Material at line item:"+lineNO);
		return false;
	}
	var vendCat = "<%=gv_VendCat%>"; 
	//alert("vendCat>>"+vendCat);

	var url="ezSaveAuctionConditions.jsp?auctionId="+auctionId+"&lineNO="+lineNO+"&itemPos="+itemPos+"&itemQty="+itemQty+"&itemPrice="+itemPrice+"&vendCat="+vendCat+"&currency="+currency+"&editFlag="+editFlag;

	$('iframe').attr("src",url);
	$('#woModal2').modal({show:true});
	$('.modal-dialog').draggable({
			    handle: ".modal-body"
	});		

}
function fnExcelReport()
{
    var tempTabTxt = "";
    var tables = document.getElementsByTagName('table');
    debugger;
    for(z=0;z<tables.length;z++)
    {
	    var tab_text="<table border='2px'><tr bgcolor='#87AFC6'>";
	    var textRange; 
	    var j=0;
	    var k=0;


	    //tab_text=tab_text+"<b><p align='left'><h4>Auction History Details:<%=auctionId%></p></b></h4></tr>";  


	    //tab = document.getElementById('example1'); // id of table
	    tab=tables[z];


	    for(j = 0 ; j < tab.rows.length ; j++) 
	    {     
		tab_text=tab_text+tab.rows[j].innerHTML+"</tr>";
		//tab_text=tab_text+"</tr>";
	    }


	    tab_text=tab_text+"</table>";
	    tab_text= tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
	    tab_text= tab_text.replace(/<img[^>]*>/gi,""); // remove if u want images in your table
	    tab_text= tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params
	    tempTabTxt += tab_text;
	}

    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE "); 

    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
    {
        txtArea1.document.open("txt/html","replace");
        txtArea1.document.write(tempTabTxt);
        txtArea1.document.close();
        txtArea1.focus(); 
        sa=txtArea1.document.execCommand("SaveAs",true,"Auction.xls");
    }  
    else     
    {
    	 let a = $("<a />", {
             href: 'data:application/vnd.ms-excel,' + encodeURIComponent(tempTabTxt),
             download: "AUCTION_<%=auctionId%>.xls"
         })
         .appendTo("body")
         .get(0)
         .click();
         e.preventDefault();
   }   

    return (sa);
}
	function downloadFile(upItemNo,fileName)
	{
		//alert("fileName>>"+fileName);
	  	var upDocId 	= $('#upDocId').val();
	  	var upDocType 	= $('#upDocType').val();
	  	window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	}
	function valUploadForm()
	{ 
	    	var upItemNo = $('#upItemNo').val();
	    	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');

	    	
	    	//alert("fileName11>>>"+fileName);
	    	var fileExt  = fileName.substr((fileName.lastIndexOf('.') +1)).toUpperCase();
	    	var isValid = true;
	    	if(fileName == "")
	   	{
	   		alert("Please upload file");
	   		isValid = false;
	   		return false;
	   	}
	   	if(allowedFileExt.indexOf(fileExt) <= -1)
	   	{ 
	   		alert("Only file extension's "+allowedFileStr+" are allowed.");
	   		isValid = false;
	   		return false;
	   	}
	   	if(($("#file")[0].files[0].size/1024)/1024 > allowedFileSize)
	   	{ 
	   		alert("Please upload file less than "+allowedFileSize+"MB");
	   		isValid = false;
	   		return false;
	   	}
	    	$('input[name="fileItem'+upItemNo+'"]').each(function(){
	   	  if($(this).val() == fileName)
	   	  {
	   	  	alert("File already uploaded");
	   	  	isValid = false;
	   		return false;
	   	  }	  
	   	});
	   	if(isValid)
	   	{
	   		$('#uploadbutton').hide(); 	
	          		$('#loadingInd').show();
	   	}
	   	return isValid;
	 }
	 function deleteFile(thisObj,upItemNo,fileName)
	 {
	 	var upDocId 	= $('#upDocId').val();
	 	var upDocType 	= $('#upDocType').val();
	 	if(confirm("Are you sure you want to delete this file?"))
	 	{
			$.ajax({
			    url: '../Inbox/ezDeleteFile.jsp',
			    data: { upDocId: upDocId, upDocType : upDocType,upItemNo:upItemNo,fileName:fileName},
			    dataType: "json",
			    type: 'POST',
			    success: function(result) {
			      result=$.trim(result);  
			      if(result === 'true')
			      {
				$(thisObj).closest("tr").remove();	
			      }
			    }
			});
		}
	 }
	 $(function() {
	      $( ".uploadDialogBtn" ).button().on( "click", function() {
	         $("#upItemNo").val($(this).val());
	         $("#file").val("");
	        $('#uploadMod').modal('show');
	        	return false;
	      });
	      $('#uploadForm').ajaxForm({
	      	  beforeSubmit: valUploadForm,	
	 	  success: function(msg) {
	 	      $('#uploadbutton').show(); 	
	        	      $('#loadingInd').hide();
	 	      msg=$.trim(msg);
	 	      //alert(msg);
	 	      if(msg.split("##")[0] === 'true')
	 	      {
	 	      		
	 	      	$('#noDataStatUpload').hide();
	 	      	  var upItemNo = $('#upItemNo').val();
	 	      	  var fileNameTemp = msg.split("##")[1];
			   if(fileNameTemp.indexOf("^^") >= 0)
			   {
			   	var fileNameTempArr = fileNameTemp.split("^^");
			   	for(z=0;z<fileNameTempArr.length;z++)
			   	{
			   		$('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTempArr[z]+'"><a href="javascript:downloadFile(\''+upItemNo+'\',\''+fileNameTempArr[z]+'\')">'+fileNameTempArr[z]+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTempArr[z]+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
			   	}
			   }
			   else
			   {
	 	      	   	$('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
	 	      	   }
	 	      }
	 	      //alert("File has been uploaded successfully");
	 	      $('#uploadMod').modal('hide');
	 	  },
	 	  error: function(msg) {
	 	     $('#uploadbutton').show(); 	
	        	     $('#loadingInd').hide();	
	 	     alert("Couldn't upload file");
	 	  }
	      });
	 
	 
	   } );
</script>
</html>
