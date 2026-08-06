<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>           
<%@ page import="java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>  
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean> 

<%        
	int dateRange = 30;    
	String fromDate		= request.getParameter("FromDate");  
	String toDate		= request.getParameter("ToDate");  
%>
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%>  
<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iListRejectMatDocs.jsp"%>    
<%@ page import="ezc.ezparam.*" %>  
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<Html> 
<Head>    
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>               
	function ezBack(event)          
	{
		document.location.href = event;
	}
	function ezSubmit()  
	{
		var fromDate = document.myForm.FromDate.value;
		var toDate   = document.myForm.ToDate.value; 
		
		if(fromDate > toDate)
		{
			alert("From Date should be less than To Date!!");
			return false;
		}
		
		document.myForm.action = "ezListRejectMatDocs.jsp";
		document.myForm.submit(); 
	}
</Script>
</head>
 
<Body scroll=no>
<form method="post" name="myForm">
<input type="hidden" id="status" value="">  


<%
	String clickString = "onclick='ezSubmit()'";
	String display_header = "Self Service > Rejected Materials";
%>
	
	<%@ include file="../Misc/ezSubHeader.jsp"%> 	 
	<%@ include file="../Misc/ezSelectDate.jsp"%>   

	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>
	<Tr <%=trBGColor%>>
			<th align="center" width="10%">Vendor Ref. No.</th>	
			<th align="center" width="8%">GR No.</th>
			<th align="center" width="8%">PO No.</th>
			<th align="center" width="5%">PO Item</th>
			<th align="center" width="8%">Material</th>
			<th align="center" width="15%">Description</th>
			<th align="center" width="8%">Doc. Qty</th>
			<th align="center" width="8%">Rej. Qty</th>
	</Tr>
	</Thead>
	<TBody>		        

<%	
	SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S"); 
	DateFormat toFormat = new SimpleDateFormat("dd-MMM-yyyy"); 
  	java.util.Date  dt=new java.util.Date();  
  	int index=0;
	String postDate="",appDate="",ackStatus="",matDocNo="",poNum="",poItemNo="",materialCode="",materialDesc="",UOM="",rejQty="",docQty="",inspecLot="",status="",matPo="",vendRefNo="",docKey="",inspectLotNo="",rejDocNo="";
	
	for(int i=0;i<retRejMatDocsObjCnt;i++)     
	 { 
	 	 vendRefNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"REF_DOC"));  
		 matDocNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDOCNO"));
		 poNum		=checkNull(retRejMatDocsObj.getFieldValueString(i,"PONUM"));
		 poItemNo 	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POITEMNO"));
		 materialCode	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATCODE"));
		 materialDesc	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDESC"));
		 UOM		=checkNull(retRejMatDocsObj.getFieldValueString(i,"UOM"));
		 docQty		=checkNull(retRejMatDocsObj.getFieldValueString(i,"REC_QTY"));
		 rejQty		=checkNull(retRejMatDocsObj.getFieldValueString(i,"REJ_QTY"));
		 postDate	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POSTDATE"));
		 appDate	=checkNull(retRejMatDocsObj.getFieldValueString(i,"APPDATE"));
		 inspectLotNo   =checkNull(retRejMatDocsObj.getFieldValueString(i,"INSLOT"));
		 
		 rejDocNo   	=checkNull(retRejMatDocsObj.getFieldValueString(i,"REJ_DOC_NO"));
		 
		 
		 matPo=matDocNo+"$$"+poItemNo;
		 status="";//(String)ackStat.get(matPo);     
		 
		 docKey = matDocNo+""+poItemNo;
%>
		<Tr>
			<td align="center" width="10%"><%=vendRefNo%>&nbsp;</td>
			<td align="center" width="8%"><%=matDocNo%>&nbsp;</td>
			<td align="center" width="8%"><%=poNum%></td>
			<td align="center" width="5%"><%=poItemNo%></td>
			<td align="center" width="8%"><%=materialCode%></td>
			<td align="left" width="15%">&nbsp;<%=materialDesc%></td>
			<td align="right" width="8%"><%=docQty%>&nbsp;</td>
			<td align="right" width="8%"><%=rejQty%>&nbsp;</td>
		</Tr>
	
<%   
	index++;      
	}
	
%>	

</Tbody>
	</Table>
	
</Form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>

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

 

                            