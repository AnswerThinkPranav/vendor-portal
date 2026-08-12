<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>    
<%@page import="ezc.ezutil.*"%>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" /> 
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>
<style>
th
{	
    color: white;
    background: #325786; 
	
}
</style>

<%
	
	ezc.ezcommon.EzLog4j.log("****=RFQ" ,"I");
	ezc.ezparam.EzcParams rfqParams  = new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams = new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezirfqheaderparams.setRFQNo(poNum);
	ezirfqheaderparams.setSysKey((String)session.getValue("SYSKEY"));
	rfqParams.setObject(ezirfqheaderparams); 
	rfqParams.setLocalStore("Y");
	Session.prepareParams(rfqParams);

	ezc.ezpreprocurement.params.EzoRFQHeaderParams ezoRFQheaderparams = (ezc.ezpreprocurement.params.EzoRFQHeaderParams)Manager.ezGetRFQDetails(rfqParams);

	ezc.ezcommon.EzLog4j.log("****==before==Closing PRS==rfqHeader===**","I");
	ezc.ezparam.ReturnObjFromRetrieve rfqHeaderStatus  = (ezc.ezparam.ReturnObjFromRetrieve)ezoRFQheaderparams.getRFQHeader();
	//rfqHeaderStatus.getFieldValueString(0,"STATUS");
	ezc.ezcommon.EzLog4j.log("****=RFQ Header==**"+rfqHeaderStatus.toEzcString(),"I");
	String rfqStatus = "";
	
	if(rfqHeaderStatus!=null && rfqHeaderStatus.getRowCount()>0) 
	{
		rfqStatus = rfqHeaderStatus.getFieldValueString(0,"STATUS"); 
	}
	ezc.ezcommon.EzLog4j.log("****=RFQ Header==**rfqStatus"+rfqStatus,"I");
%>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      <%=rfq_Details_L%>
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form  name="myForm">
<%			
		Date toDate = new Date();
		String[] rfqDatearr = new String[3];
		StringTokenizer stDate = new StringTokenizer(CDate,"/"); 
		int x=0;
		while (stDate.hasMoreTokens()) 
		{
			rfqDatearr[x] = stDate.nextToken();
			x++;
		}
		Date rfqEndDate =null;
		
		try{
		 	rfqEndDate = new Date((Integer.parseInt(rfqDatearr[2])-1900),Integer.parseInt(rfqDatearr[0])-1,Integer.parseInt(rfqDatearr[1])); 			
		}catch(Exception e){}
		int compDate = rfqEndDate.compareTo(toDate);			
		
		//out.println(rfqEndDate+":::::"+toDate+":::::"+compDate);
		
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();    
		String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		
		
		String collRFQNO= request.getParameter("collRFQNO");
		String queryStr = "";
		
		ReturnObjFromRetrieve statRetObj = null;
		int statRetObjCount = 0;
		ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();
		queryStr = "select count(*) as chk_status from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO='"+collRFQNO+"' and ERH_STATUS in('S')";
		
		miscParams.setQuery(queryStr);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		try
		{
			statRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

		}
		catch(Exception e)
		{
			out.println("Exception occured while getting iListPriceSanctionForm.jsp::"+e);
		}
		
		String statusCnt =statRetObj.getFieldValueString(0,"chk_status");
		//out.println("statusCnt>>"+statusCnt);
			

%>
	<input type="hidden" name="type" value=<%=request.getParameter("type")%>>
	<input type="hidden" name="rfqType" value=<%=request.getParameter("rfqType")%>>
	<input type="hidden" name="EndDate" value="<%=CDate%>">
	<input type="hidden" name="OrderDate" value="<%=OrderDate%>">
	<input type="hidden" name="PurchaseOrder" value="<%=poNum%>">
	<input type="hidden" name="expStat" value="<%=expStat%>"> 
	<input type="hidden" name="statusCnt" value="<%=statusCnt%>">
	

	 <!-- title row -->
      <div class="row">
	<div class="col-xs-12">
	  <h2 class="page-header">
	    <i class="fa fa-globe"></i> <%=RFQ_L%> : <%=Long.parseLong(poNum)%>
	    <small class="pull-right"><%=RFQ_Date_L%>: <%=OrderDate%></small>
	  </h2>
	</div>
	<!-- /.col -->
      </div>
	
 <!-- Table row -->
      	<div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">	    
	<table class="table table-bordered">
            <thead>
            <tr>
                <th><%=PR_Line_L%></th>
		<th><%=PR_NO_L%></th>
		<!--<th>PR Item</th>-->              
		<th><%=PR_Mat_L%></th>
		<th><%=PR_Desc_L%></th>
		<th><%=PR_UOM_L%></th>
		<th><%=PR_Qty_L%></th>
		<th><%=PR_Plant_L%></th>
		<th><%=PR_Remarks_L%></th>
            </tr>
            </thead>
            <tbody>
<%

	
	for(int i=0;i<Count;i++)
   	{
		
		String prNo="N/A";
		String prItem="N/A"; 
		
		String refPrStr= dtlXML.getFieldValueString(i,"ERD_EXT1");
		prNo=refPrStr;
		/*
		if(!"".equals(refPrStr))
	      	{
	      		 prNo=refPrStr.split("¥")[0];
	      		 try
	      		 {
	      		 	prItem=Long.parseLong(refPrStr.split("¥")[1])+"";
	      		 }
	      		 catch(Exception e)
	      		 {
	      		 	prItem=refPrStr.split("¥")[1];
	      		 }
	      	}*/			
		
		//String curr = dtlXML.getFieldValueString(i,"AMOUNT");
		//String net  = dtlXML.getFieldValueString(i,"NET_VALUE");
		String myQty = dtlXML.getFieldValueString(i,"ERD_QUANTITY");
		try
		{
			myQty = (Double.parseDouble(myQty))+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(3,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){}
		String accCat	= dtlXML.getFieldValueString(i,"ERD_ACC_CAT");
		String itemCat	= dtlXML.getFieldValueString(i,"ERD_ITEM_CAT");
		String matNo="";
	  	try
	  	{
			matNo=(Long.parseLong(dtlXML.getFieldValueString(i,"ERD_MATERIAL")))+"";
		}catch(Exception e){
			matNo=dtlXML.getFieldValueString(i,"ERD_MATERIAL");
		}		
		
		String  serBgColor ="";
		if("D".equals(itemCat))
		{
			serBgColor="background-color:#e4ff00";			
			matNo="";
		}
		String uom = dtlXML.getFieldValueString(i,"ERD_UOM");
		if("LE".equals(uom))
			uom="AU";		

%>
     		<tr style="<%=serBgColor%>">
      		<td align="center"><%=dtlXML.getFieldValueString(i, "ERD_LINE_NO")%></td>
      		<td align="center"><%=prNo%></td>
      		<!--<td align="center"><%=prItem%></td>-->
      		<td align="center"><%=matNo%></td>
      		<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC")%></td>
      		<td align="center"><%=uom%></td>
      		<!--<td align="right"><%=dtlXML.getFieldValueString(i,"ERD_QUANTITY")%></td>-->
      		<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_QUANTITY")%></td>
      		<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_PLANT")%>&nbsp;</td>
      		<td align="center"><%=dtlXML.getFieldValueString(i,"ERD_REMARKS")%>&nbsp;</td>
    		</tr>
<%
	}
%>
            </tbody>
          </table>
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
      
<%
	if(Integer.parseInt(statusCnt)>0)
	{
%>
	<div class="alert"><p style="color:red"><b>* QCF is already submitted</p></b></div>		
<%
	}
%>
     
	
<%	
	if("C".equals(rfqStatus))
	{
%>	
		<font color=red >RFQ closed as PO is created against this RFQ</font>
<%
	}
%>

<!-- this row will not appear when printing -->
<div class="row no-print">
<div class="col-xs-12">
  <!--<a href="invoice-print.html" target="_blank" class="btn btn-default"><i class="fa fa-print"></i> Print</a>-->
<button type="button" class="btn btn-primary pull-right" onclick="goBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> <%=go_Back_L%></button>
<!--<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="viewSchedules()">View Delivery Schedules</button>-->


<%
		
		
		
		/*if(("3".equals(UserType)) && compDate>=0 && !("Y".equals(rfqStatus) || "C".equals(rfqStatus)))        
		{
			buttonName.add("Quote");
			buttonMethod.add("funQuote()"); 
		}
		else if ((QuotNo!=null)&&(QuotNo.trim().length() > 0))   
		{
			buttonName.add("ViewQuotation");
			buttonMethod.add("funView()");
			
			if("Y".equals(rfqStatus) && !("3".equals(UserType)))
			{
				buttonName.add("Create&nbsp;PO");
				buttonMethod.add("funCreatePO()"); 
			}
			
		}*/
		  
		
		//if(("3".equals(UserType)) && (QuotNo.equals("0.0000")) && !"Y".equals(expStat))
		if(("3".equals(UserType) && QuotNo.equals("0.0000") && "N".equals(chkStatus) && "0".equals(statusCnt)) || ("4".equals(UserType) && QuotNo.equals("0.0000") && "N".equals(chkStatus) && "0".equals(statusCnt)) || ("2".equals(UserType) && QuotNo.equals("0.0000") && "N".equals(chkStatus) && "0".equals(statusCnt)))  
		{
			if("4500".equals(compCode) || "9000".equals(compCode) || "7300".equals(compCode) || "4101".equals(compCode) || "7501".equals(compCode))
			{
%>
				<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="funNAQuote()"><i class="fa fa-money"></i>&nbsp;<%=quote_L%></button>
<%			
			}
			else
			{			
%>
				<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="funQuote()"><i class="fa fa-money"></i>&nbsp;<%=quote_L%></button>
<%				
			}			
		}
		else if(("3".equals(UserType) && !("N".equals(chkStatus))) || ("4".equals(UserType) && !("N".equals(chkStatus)))|| ("2".equals(UserType) && !("N".equals(chkStatus))))  
		{
			if("4500".equals(compCode) || "9000".equals(compCode) || "7300".equals(compCode) || "4101".equals(compCode) || "7501".equals(compCode))
			{
%>
				<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="funNAView('<%=request.getParameter("rfqType")%>')"><i class="fa fa-money"></i>&nbsp;<%=view_Quot_L%></button>
<%			
			}
			else
			{
%>		
				<button type="button" id="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="funView('<%=request.getParameter("rfqType")%>')"><%=view_Quot_L%></button>
<%	
			}
		}
%>
			
</div>
</div>
</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%@ include file="../Misc/ezFooter.jsp"%>
<script>

	function closeIframe()
	{
		   $('#woModal').modal('toggle');
	}
	function goToPlantAddr(plant)
	{
		//window.open("../Purorder/ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,left=280,top=200,width=350,height=320");
		$('iframe').attr("src","../Purorder/ezPlantAddress.jsp?plant="+plant);
		$('#woModal').modal({show:true});
	}

	function goBack(){
		document.myForm.action ="ezListRFQs.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"; 
		document.myForm.submit();
	}
	function funQuote()
	{
		buttonhide();
		document.myForm.action = "ezPostQuote.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}
	function funNAQuote()
	{
		buttonhide();
		document.myForm.action = "ezPostNAQuote.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}	
	function funRequote()
	{
		buttonhide();
		document.myForm.action = "ezPostRequote.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}	
	function funView(rfqType)
	{
		buttonhide();   
		//alert("rfqType>>>"+rfqType);
		if(rfqType== 'DOM')
			document.myForm.action = "ezViewQuoteDetails.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>&statusCnt=<%=statusCnt%>"
		else
			document.myForm.action = "ezViewImpQuoteDetails.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}
	function funNAView(rfqType)
	{
		buttonhide();   
		//alert("rfqType>>>"+rfqType);
		if(rfqType== 'DOM')
			document.myForm.action = "ezViewNAQuoteDetails.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>&statusCnt=<%=statusCnt%>"
		else
			document.myForm.action = "ezViewNAImpQuoteDetails.jsp?type=<%=request.getParameter("type")%>&rfqtype=<%=request.getParameter("rfqType")%>"
		document.myForm.submit();
	}

	function buttonhide()
	{
		buttonsSpan	  = document.getElementById("EzButtonsSpan");
		buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan");
		if(buttonsSpan!=null)
		{
			buttonsSpan.style.display	= "none"
			buttonsMsgSpan.style.display	= "block"
		}
	}

	</script>
