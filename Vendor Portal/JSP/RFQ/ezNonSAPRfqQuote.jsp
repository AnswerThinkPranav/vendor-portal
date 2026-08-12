 <%@ include file="../../Library/Globals/errorPagePath.jsp"%>
 <%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
 <%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
 <%@include file="../../../Includes/JSPs/Rfq/iViewQuoteDetails.jsp"%>
 <%@ include file="ezVendorPayTerms.jsp"%>
 <%@ include file="ezRFQTaxCodes.jsp"%>   
 <%@ include file="../Misc/ezHeader.jsp"%> 
 <%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
 <%@page import="ezc.ezutil.*,java.util.*,java.math.*"%>
 
 <%! 
 	public String checkNull(Object inputStr) 
 	{ 
 		String str = (String)inputStr;
 		String retStr = "";
 		
 		if(str == null || "null".equals(str) || "".equals(str))
 			retStr = "";
 		else
 			retStr = str;
 			
 		return retStr;	
 	} 
 %>
 <%
 try{
 session.removeValue("ATTACHEDFILES");
 }catch(Exception e){}
%>
 <html>
 <head>
 <%
 	String submitPageName = "ezReQuotationSave.jsp"; 
 	String fromPage       = "NON_SAP_QUOTE";
 %>
	<%@ include file="ezRFQ_JS.jsp" %>
 <Script>  
 	function goBack(){
 		document.forms[0].action = "ezListRFQs.jsp"
 		document.forms[0].submit();
 	} 
 	
	document.onkeydown = function (evt) 
	{
		var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
		if (keyCode == 13) 
		{
<%
			for(int j=0;j<rfqDetailsRetCnt;j++)
			{
%>
				checkNum(eval("document.myForm.itemPrice<%=rfqDetailsRet.getFieldValueString(j,"ERD_LINE_NO")%>"),'<%=rfqDetailsRet.getFieldValueString(j,"ERD_LINE_NO")%>');
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

 </Script>
 </Head>   
 <body>
 <form name="myForm" method="post"> 
 <input type="hidden" name="rfqNumber" value="<%=rfqNumber%>" >	
 <input type="hidden" name="rfqVendor" value="<%=rfqVendor%>">	
<input type="hidden" name="rfqSysKey" value="<%=rfqSysKey%>">	

 <input type="hidden" name="type" value="<%=request.getParameter("type")%>">	
 
<input type="hidden" name="saveRequestFrom" value="NON_SAP_VENDOR">
 
<input type="hidden" name="attachFlag" value ="N" >
<input type="hidden" name="attachDocDesc" value ="" >	
<input type="hidden" name="attachFileTime" value ="" >	
<input type="hidden" name="attachDocFiles" value ="" >
 
 <input type="hidden" value="<%=request.getParameter("FromDate")%>" name="FromDate">
 <input type="hidden" value="<%=request.getParameter("ToDate")%>" name="ToDate">
 
 <%	      
 	String SAPRFQNo = checkNull(rfqHeaderRet.getFieldValueString(0,"ERH_EXT1"));
 	try{
 	SAPRFQNo= Integer.parseInt(SAPRFQNo)+"";
 	}catch(Exception e){}
 	java.util.Date dateObj 	= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_RFQ_DATE");
 	String rfqDate	 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 		
 	dateObj 		= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_QUOTE_DATE");
 	String rfqQuoteDate 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 
 	dateObj 		= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_QUOTE_VALIDITY");
 	String rfqValidDate 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 		
   
 	String display_header	= "RFQ > RFQ's To Be Responded > RFQ Details";
 %>  
 	<%@ include file="../Misc/ezSubHeader.jsp"%>   
 	<br>
 <%
 	String payterm="";String incoterm="";	
 %> 
	<%@ include file="ezQuoteHeader.jsp" %>	
 	<Br>
<%
	String pageType = "EDIT";
%>	 
 	<%@ include file="ezQuotedRFQItems.jsp" %>	
 	<Br> 
	<center> 
		<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)">Back</button>  &nbsp;	
<%  
		if("4".equals(userType) || "3".equals(userType))
		{
%>
			<button type="button" class="btn btn-primary" onclick="SubmitQuote()">Submit</button>  &nbsp;	
			<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload()">Upload Docs</button>
			<button type="button" class="btn btn-primary" onclick="funReset()">Clear</button>  &nbsp;	
<%
		}
%> 
	</center> 
	<%@ include file="../Misc/AddMessage.jsp" %>     
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
 <%@ include file="../Misc/ezDataTableScript.jsp"%>
