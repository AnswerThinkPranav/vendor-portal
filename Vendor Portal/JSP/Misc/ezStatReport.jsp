<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="ezHeader.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="ezVendorCompanyCodes.jsp" %>
<%@ page import = "java.util.*"%>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ page import = "java.text.*"%> 
<%@ include file="../../../Includes/Lib/PurchaseBean.jsp"%>
<%//@ include file="../../../Includes/Lib/DateFunctions.jsp"%>
<%//@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />

<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	int dateRange = 90;
	String fromDate		= request.getParameter("FromDate");
	String toDate		= request.getParameter("ToDate");
	String SelVendor		=request.getParameter("buyerSelVendor");
	String SelVendorname		=(String)session.getValue("SEL_VEND_NAME");
	out.println(fromDate+toDate+SelVendor+"::::::::::::::"+SelVendorname);
%>
<%@ include file="ezGetDefaultFromToDates.jsp"%>
<%@ include file="ezGetVendorCodesAndNames.jsp"%> 
<%

	String searchField = request.getParameter("searchField");
	String base = request.getParameter("base");
	String invoiceFlag = request.getParameter("InvStat");
	String vendor=(String) session.getValue("SOLDTO");
	
	String vendorNme= "";
	if ("3".equals(v_UserType)){
		vendorNme=(String)vendorsHT.get(vendor);
	}
	//out.println(vendorNme+"::::::vendor:::::::"+vendor+":::::::::"+v_UserType);
	String purnum = "";
	boolean isShowDates = false;
	if(searchField==null || "null".equals(searchField) || "".equals(searchField) )
	{
			isShowDates = true;
	}
%>
<%	

	ReturnObjFromRetrieve retCurrency	=  null;
	int    CurrCnt	=  0;
	ezc.ezparam.EzcParams mainParams1	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams1		= new EziMiscParams();
	if ("3".equals(v_UserType)){
		miscParams1.setQuery("select * from ezc_vend_general_data where EVGD_VENDOR='"+vendor+"' and  EVGD_STATUS='OPEN'");
	}
	else
	{
		miscParams1.setQuery("select * from ezc_vend_general_data");
	}	
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscParams1);
	Session.prepareParams(mainParams1);
	try
	{		
		retCurrency=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams1);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retCurrency!=null)
		CurrCnt=retCurrency.getRowCount();     	
		String  documentID="";		
		
			//documentID=retCurrency.getFieldValueString(0,"EVGD_DOC_ID");
			//out.println(":::::documentID:::"+documentID);
			
		//out.println(":::::documentID:::"+documentID);
if ("3".equals(v_UserType)){		
	if(vendor.length()==10)
	{
		vendor=vendor.substring(4,10);
	}
}	
	
ReturnObjFromRetrieve retCountry	=  null;
	int    CountryCnt	=  0;
	String docList = "";
	ezc.ezparam.EzcParams mainParams_c	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_c		= new EziMiscParams();
	if ("3".equals(v_UserType)){
	if(documentID!=null || !"null".equals(documentID) || !"".equals(documentID) )
	{	for (int i=0;i<CurrCnt;i++) 
		{
			documentID=retCurrency.getFieldValueString(i,"EVGD_DOC_ID");
			if("".equals(docList))
			{
				docList = documentID;
			}
			else
			{
				docList = docList+"','"+documentID;
			}
		}
	}
	miscParams_c.setQuery("select * from ezc_wf_doc_history_header where EWDHH_SOLD_TO in('"+vendor+"') and EWDHH_DOC_ID in ('"+docList+"') ");
	}
	else{
		for (int i=0;i<CurrCnt;i++) 
		{
				documentID=retCurrency.getFieldValueString(i,"EVGD_DOC_ID");
				
				if(documentID!=null || !"null".equals(documentID) || !"".equals(documentID) )
				{	
					if("".equals(docList))
					{
						docList = documentID;
					}
					else
					{
						docList = docList+"','"+documentID;
					}
				}
				//out.println(":::::documentID:::"+documentID);		
			
		}	
		Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fromDate);
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); 
		String fromDatee = formatter.format(date1);
		Date date2=new SimpleDateFormat("dd/MM/yyyy").parse(toDate);	
		String toDatee = formatter.format(date2);
		if(SelVendor!=null && !"null".equals(SelVendor) && !"".equals(SelVendor) )
		{
			if(SelVendor.length()==10)
			{
				SelVendor=SelVendor.substring(4,10);
			}
			miscParams_c.setQuery("select * from ezc_wf_doc_history_header where  EWDHH_SOLD_TO in('"+SelVendor+"') and EWDHH_DOC_ID in ('"+docList+"') and EWDHH_CREATED_ON between '"+fromDatee+" 00:00:01'and '"+toDatee+" 23:59:59'");
		}
		else
		{
			miscParams_c.setQuery("select * from ezc_wf_doc_history_header a,ezc_vend_general_data b where a.EWDHH_DOC_ID=b.EVGD_DOC_ID and  a.EWDHH_DOC_ID in ('"+docList+"') and a.EWDHH_CREATED_ON between '"+fromDatee+" 00:00:01'and '"+toDatee+" 23:59:59'");
		}
		
		
	}
	mainParams_c.setLocalStore("Y");
	mainParams_c.setObject(miscParams_c);
	Session.prepareParams(mainParams_c);
	try
	{		
		retCountry=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_c);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retCountry!=null)
		CountryCnt=retCountry.getRowCount();
		//EWDHH_SOLD_TO
		for (int i=0;i<CountryCnt;i++){
		String  vend=retCountry.getFieldValueString(i,"EWDHH_SOLD_TO");
		String  docID=retCountry.getFieldValueString(i,"EWDHH_DOC_ID");
		String  nextParti=retCountry.getFieldValueString(i,"EWDHH_NEXT_PARTICIPANT");
		String  currParti=retCountry.getFieldValueString(i,"EWDHH_MODIFIED_BY");
		String  status=retCountry.getFieldValueString(i,"EWDHH_WF_STATUS");
     		//out.println("::::::::"+currParti);		
     		}
%>



<html>
<head>
<Script>
function ezSubmit()
	{
		if(document.myForm.showGrid!=null)
			document.myForm.showGrid.value = "Y";
		
		$('#pleaseWaitDialog').modal('show'); 
		document.myForm.action = "ezStatReport.jsp";
		document.myForm.submit();
	}
	function getDefaultsFromTo(){
<%
		if(isShowDates){
		if(fromDate!= null && toDate != null){
%>
			document.myForm.ToDate.value = "<%=toDate%>";
			document.myForm.FromDate.value = "<%=fromDate%>";
<%
		}
		else{
%>
			toDate = new Date();
			today = toDate.getDate();
			thismonth = toDate.getMonth()+1;
			thisyear = toDate.getYear();

			fromDate =  new Date();
			fromDate.setDate((toDate.getDate()-30));
			prevdate =  fromDate.getDate();
			prevmonth = fromDate.getMonth()+1;
			prevyear =  fromDate.getYear();

			if(!document.all){
				thisyear = thisyear+1900;
				prevyear = prevyear+1900;
			}
			if(today < 10)
				today = "0"+today;
			if(prevdate < 10)
				prevdate = "0"+prevdate;	

			if(thismonth < 10)
				thismonth = "0" + thismonth;
			if(prevmonth < 10)
				prevmonth = "0" + prevmonth;	

			document.myForm.ToDate.value = ConvertDateFormat(today+'.'+thismonth+'.'+thisyear,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
			document.myForm.FromDate.value = ConvertDateFormat(prevdate+'.'+prevmonth+'.'+prevyear,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
<%

		}
		}	
%>
	}
</Script>
<style>
.pane {
  background: #fff;
}
.pane-hScroll {
  overflow: auto;
  width: 100%;
  
}
</style>
</head>

<Body scroll=yes>
<Form name='myForm' method='POST'>
<input type="hidden" name="menuItem" value="STR">
<input type="hidden" name="showGrid" value="Y"  >

<%	
	String clickString = "onclick='ezSubmit()'";
	String display_header = "";
	if ("2".equals(v_UserType))
	{
		 display_header = "Vendor Profile Requests > Status Report"; 
	}
	else
	{
		 display_header = "Self Service > Status Report"; 
	}
%>
<%@ include file="ezSubHeader.jsp"%> 	
<%if ("2".equals(v_UserType)){
%>
	<%//@ include file="ezSelectDate.jsp"%>
	<Table border="1" align="center" valign=middle width="60%" cellpadding=0 cellspacing=0 class=welcomecell>
	 	<Tr>
	 		<Th style="width:20%" <%=trBGColorH%>>
	 			From Date&nbsp;&nbsp;
	 		</Th>
	 		<Td>	 			
	 			 <input class="form-control input-sm" type="text"  name="FromDate" id="FromDate" value="<%=fromDate%>" >
			 </Td>
			 <Td>	 			
	 			 <label for="FromDate" class="input-group-addon btn" > <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
	 		</Td>
	 		 
	 		<Th  style="width:20%" <%=trBGColorH%>>
	 			&nbsp;&nbsp;&nbsp;&nbsp;To Date&nbsp;&nbsp;
	 		</Th>
	 		<Td>	 			
	 			<input class="form-control input-sm" type="text"  name="ToDate" id="ToDate" value="<%=toDate%>">
	 		</Td>	
	 		<Td>			  	
			  	<label for="ToDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label> 
	 		</Td>	 		 	
	 		<Td onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
				<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
			</Td>
	 	</Tr>
	 
	</Table>  
<%}%>


<div class="pane pane--table1" style="margin-right: 10px;">
			<div class="pane-hScroll">
	
	<table id="example" class="table table-striped table-bordered  nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%> > 
			<th align="center" width="20%">Request Number</th>
			<th align="center" width="20%">Pur. Org</th>
			<th align="center" width="20%">Request Date</th>
			<th align="center" width="20%">Vendor</th>

			<th align="center" width="20%">Vendor Name</th>
		
			<th align="center" width="20%">Approver 1</th>
			<th align="center" width="20%">Status</th>
			<th align="center" width="20%">Modified Date</th>
			<th align="center" width="20%">Approver 2</th>
			
			
			
		</tr>
	</thead>
	</Thead>
	<TBody>		
		
<%
			for (int i=0;i<CountryCnt;i++) 
			{	String docDateOn=retCountry.getFieldValueString(i,"EWDHH_DOC_DATE");
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat formatter3 = new SimpleDateFormat("yyyyMMdd");
				Date date = formatter.parse(docDateOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy");
				String docDate = formatter.format(date);
				String mainDocDate = formatter3.format(date);
				
				String modifiedOn=retCountry.getFieldValueString(i,"EWDHH_MODIFIED_ON");
				SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date dateMod = formatter1.parse(modifiedOn);
				formatter1 = new SimpleDateFormat("dd/MM/yyyy");
				String modifiedOnDate = formatter1.format(dateMod);
				String mainModifiedOnDate = formatter3.format(dateMod);
%>
					<Tr>
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EWDHH_DOC_ID")%>&nbsp;</td>
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EVGD_ADDR_NR")%>&nbsp;</td>
						<td align="center" width="20%"><span style="display:none"><%=mainDocDate%></span><%=docDate%>&nbsp;</td>
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EWDHH_SOLD_TO")%>&nbsp;</td>
<%		if ("3".equals(v_UserType)){
%>
						<td align="center" width="20%"><%=vendorNme%>&nbsp;</td>	
<%}else{%>						
						
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EVGD_NAME1")%>&nbsp;</td>
<%}%>						
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EWDHH_MODIFIED_BY")%>&nbsp;</td>
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EWDHH_WF_STATUS")%>&nbsp;</td>
						<td align="center" width="20%"><span style="display:none"><%=mainModifiedOnDate%></span><%=modifiedOnDate%>&nbsp;</td>
						<%
							if("VENDOR".equals(retCountry.getFieldValueString(i,"EWDHH_NEXT_PARTICIPANT"))){
						%>
						<td align="center" width="20%">None&nbsp;</td>
						<%
						}else{
						%>
						<td align="center" width="20%"><%=retCountry.getFieldValueString(i,"EWDHH_NEXT_PARTICIPANT")%>&nbsp;</td>
						<%}%>
						
						
					</Tr>					
<%
			}
%>		
 
	</Tbody>
	</Table></div></div>
	
</Form>
<%@ include file="ezSubFooter.jsp"%>
<%@ include file="ezFooter.jsp"%>
<%@ include file="ezDataTableScript.jsp"%>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
 function funGo()
 {
	var FromDate=document.myForm.FromDate.value;
	if(FromDate.lastIndexOf("-")!=-1)
	FromDate=FromDate.substring(8,10)+"/"+FromDate.substring(5,7)+"/"+FromDate.substring(0,4);
	var ToDate=document.myForm.ToDate.value; 
	if(ToDate.lastIndexOf("-")!=-1)
	ToDate=ToDate.substring(8,10)+"/"+ToDate.substring(5,7)+"/"+ToDate.substring(0,4);	
	//alert(FromDate+":::"+ToDate+"<>");
	document.myForm.action="ezStatReport.jsp?ToDate="+ToDate+"&FromDate="+FromDate;
	document.myForm.submit();
}
</script>
<script>
$(document).ready(function() {
		
        $("#FromDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                    	changeMonth: true,
                 	changeYear: true
              });
               $("#ToDate").datepicker({ 
			dateFormat: 'dd/mm/yy', 
			changeMonth: true,
			changeYear: true
       });
 });
  
</script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>