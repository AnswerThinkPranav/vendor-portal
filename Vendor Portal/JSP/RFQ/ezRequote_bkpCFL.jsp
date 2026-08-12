  <%@ include file="../../Library/Globals/errorPagePath.jsp"%>
 <%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
 <%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
 <%@include file="../../../Includes/JSPs/Rfq/iViewQuoteDetails.jsp"%>
 <%@ include file="ezVendorPayTerms.jsp"%>
 <%@ include file="ezRFQTaxCodes.jsp"%>   
 <%@ include file="../Misc/ezHeader.jsp"%> 
 <%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
 <%@page import="ezc.ezutil.*,java.util.*,java.math.*"%>
 <%@ page import="java.text.*" %>

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
 	session.removeValue("ATTACHEDFILES");  
 	Date toDate = new Date();
 	String rfqCloseDateStr = checkNull(request.getParameter("EndDate"));
 	Date rfqCloseDate= new Date();
 	
 	if(!"".equals(rfqCloseDateStr))
 	{
 		SimpleDateFormat simpleFormat = new SimpleDateFormat("dd/MM/yyyy");
		rfqCloseDate = simpleFormat.parse(rfqCloseDateStr);
 	}
 	int compDate = rfqCloseDate.compareTo(toDate);			
	
String usersList = "";
	String userName	= "";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;

	ReturnObjFromRetrieve docCommentsRet	=  null;
	int docCommentsRetCnt = 0;
	mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams();
	
	
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
<%
	String submitPageName = "ezReQuotationSave.jsp";
	String fromPage       = "RE_QUOTE";
%>
	<%@ include file="ezRFQ_JS.jsp" %>
 <Script>
 	function goBack(){
 		document.forms[0].action = "ezListRFQs.jsp"
 		document.forms[0].submit();
 	} 

	function enableTaxes1()
	{
		//var applTaxType	= document.myForm.applTax.value;
		var rfqItemObj  = document.myForm.rfqItem;
		var rfqItemObjLen = rfqItemObj.length;
		
		var incoTerm = "<%=rfqHeaderRet.getFieldValueString(0,"ERH_INCO_TERMS1")%>";
		var rfqItemNo;
		
		if(isNaN(rfqItemObjLen))
		{
			rfqItemNo = document.myForm.rfqItem.value;
			applTaxType	= eval("document.myForm.applTax"+rfqItemNo).value;
			
			if(incoTerm=="EXW")
			eval("document.myForm.itemFRTVal"+rfqItemNo).disabled=true;
			
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
				applTaxType	= eval("document.myForm.applTax"+rfqItemNo).value;
				
				if(incoTerm=="EXW")
					eval("document.myForm.itemFRTVal"+rfqItemNo).disabled=true;
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
					
					eval("document.myForm.itemCGSTVal"+rfqItemNo).value="0";
					eval("document.myForm.itemSGSTVal"+rfqItemNo).value="0";
				}
				if( applTaxType == 'IGST')
					eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=false;
				else
				{
					eval("document.myForm.itemIGSTVal"+rfqItemNo).disabled=true;	
					eval("document.myForm.itemIGSTVal"+rfqItemNo).value="0";	
				}
				if( applTaxType == 'UGST') 
					eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=false;
				else
				{
					eval("document.myForm.itemUGSTVal"+rfqItemNo).disabled=true;	
					eval("document.myForm.itemUGSTVal"+rfqItemNo).value="0";	
				}
				checkNum(eval("document.myForm.itemUGSTVal"+rfqItemNo),rfqItemNo);
		}
		

 </Script>
 </Head>
 <body onLoad="enableTaxes1()">
 <form name="myForm" method="post">
 <input type="hidden" name="rfqNumber" value="<%=rfqNumber%>" >	
 <input type="hidden" name="rfqVendor" value="<%=rfqVendor%>">	
<input type="hidden" name="rfqSysKey" value="<%=rfqSysKey%>">	

 <input type="hidden" name="type" value="<%=request.getParameter("type")%>">	
 
 <input type="hidden" value="<%=request.getParameter("FromDate")%>" name="FromDate">
 <input type="hidden" value="<%=request.getParameter("ToDate")%>" name="ToDate">
 
 <%	
 	java.util.Date dateObj 	= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_RFQ_DATE");
 	String rfqDate	 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 		
 	dateObj 		= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_QUOTE_DATE");
 	String rfqQuoteDate 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 
 	dateObj 		= (java.util.Date)rfqHeaderRet.getFieldValue(0,"ERH_QUOTE_VALIDITY");
 	String rfqValidDate 	= FormatDate.getStringFromDate(dateObj,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
 		
 
 	String display_header	= "ReQuotation";
 	
 	if("EditQuoted".equals(editType))display_header	= "Enter Freight For Ex-Works RFQ";
 %>
 	<%@ include file="../Misc/ezSubHeader.jsp"%> 	
 	<br>
 <%
 	String payterm="";String incoterm="";	
 %>
 	<table align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="99%">
 	<Tr>
 		<Th align="left" width="15%" <%=trBGColor%>>RFQ Ref. No</Th>
       		<Td valign="middle" align="left" width="15%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_RFQ_NO")%></Td>
 		<Th align="left" width="15%"  <%=trBGColor%>>RFQ Date</Th>
         	<Td valign="middle" align="left" width="15%"><%=rfqDate%></Td>
         	<Th align="left" width="15%"  <%=trBGColor%>>Quotation Date</Th>
         	<Td valign="middle" align="left" width="15%"><%=rfqQuoteDate%></Td>
 	</Tr>
 	<Tr>
		<Th align="left" width="15%" <%=trBGColor%>>SAP RFQ No&nbsp;&nbsp;</Th>
		<Td valign="middle" align="left" width="15%">&nbsp;<%=rfqHeaderRet.getFieldValueString(0,"ERH_EXT1")%></Td>
 		<Th align="left" width="15%"  <%=trBGColor%>>Qtn. Ref. No</Th>
       		<Td valign="middle" align="left" width="15%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_QUOTE_REF")%></Td>
 		<Th align="left" width="15%" <%=trBGColor%>>Price Valid Upto</Th>
 		<Td width="15%"><%=rfqValidDate%></Td>
 		
 	</Tr>	
 	<Tr>
 		<Th align="left" width="15%" <%=trBGColor%>>Inco Terms</Th>
 		<Td width="25%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_INCO_TERMS1")%></Td>
 		<Th align="left" width="15%"  <%=trBGColor%>>Inco Terms2</Th>
 		<Td valign="middle" align="left" width="15%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_INCO_TERMS2")%></Td>
 		<Th align="left" width="15%"  <%=trBGColor%>>Delivery Period</Th>
 		<Td valign="middle" align="left" width="15%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_DELV_PERIOD")%></Td>
 	</Tr>
 	<Tr>
 		<Th align="left" width="15%" <%=trBGColor%>>Payment terms</Th>
 		<Td width="15%"><%=rfqHeaderRet.getFieldValueString(0,"ERH_PAYMENT_TERMS")%></Td>
 		<Th align="left" width="15%"  <%=trBGColor%>>Guarantee Period</Th>
 		<Td valign="middle" align="left" width="15%" colspan=3><%=rfqHeaderRet.getFieldValueString(0,"ERH_GUARANTEE_PERIOD")%></Td>
 		<!--<Th align="left" width="15%"  <%=trBGColor%>>Applicable Tax</Th>
 		<Td valign="middle" align="left" width="15%"><input type="hidden" name="applTax" value="<%=rfqHeaderRet.getFieldValueString(0,"ERH_TAX_TYPE")%>"><%=rfqHeaderRet.getFieldValueString(0,"ERH_TAX_TYPE")%></Td>
 		<Td colspan=2>&nbsp;</Td>-->
 	</Tr>
 	</table>  
 	<Br>
<% 
	String pageType = "EDIT";
%> 	
	<%@ include file="ezQuotedRFQItems.jsp" %> 
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
	if(compDate>0)
	{
	%>
	<center>
	<button type="button" class="btn btn-primary" onclick="goBack()">Back</button>
	<Br><font color='RED'><B>We regret to inform you that, your RFQ got expired</B></font>	
	</center>
	<%
	}else{
	%>
<Div class="box" >            
	       			<Div class="box-header" style="background-color: #59584C;color:white;">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>COMMENTS</B></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
	       		       </div>
               </Div>	<br>
		
 	<Br>
 	<center>
 		<button type="button" class="btn btn-primary" onclick="goBack()">Back</button>  &nbsp;	
 		<button type="button" class="btn btn-primary" onclick="funUploads()">View Uploads</button>
 		<button type="button" class="btn btn-primary" onclick="SubmitQuote()">Submit</button>
 	</center>
 	<%
 	}
 	%>
 	<input type="hidden" name="quoteHistoryMaxCount" value="<%=quoteHistoryMaxCount%>">
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
 	function funUploads()
 	{
 		var Url="../Misc/ezViewUploads.jsp?docId=<%=rfqNumber%>";
 
 
 		$.fancybox.open({
 			href : Url,
 			type : 'iframe',
 			padding : 5,
 			margin : 200,
			width:'60%',
			height:300,
 			autoSize : false,
 			closeBtn : false,
 			helpers     : { 
 					overlay : {closeClick: false}
 					 }		
 		});
 	}
 </script>
 <%@ include file="../Misc/ezDataTableScript.jsp"%>
