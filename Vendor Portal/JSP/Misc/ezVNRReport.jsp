<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<%!  
	public String checkNull(String value)   
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<%
	String type = request.getParameter("type"); 
	String qryStr="",qryRFQ="";
	ReturnObjFromRetrieve hdrXML=null;
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND A.ERH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	
	qryRFQ="SELECT * FROM EZC_RFQ_HEADER A,EZC_RFQ_POS B WHERE A.ERH_RFQ_NO=B.ERP_RFQ_NO  AND A.ERH_PLANT IN ('"+gv_PlantForQry+"') AND A.ERH_CATEGORY IN ('"+gv_CategoriesForQry+"') "+qryStr;	
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");	
	rfqTableRow.setQuery(qryRFQ);
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);
	int Count=0;
	
	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		Count = hdrXML.getRowCount();
		
	}
	catch(Exception e)
	{
		out.println("Exception in getting Purchase Group List>>>>>"+e);
	}
	
%>


<%//@ include file="../Misc/ezCommonMethods.jsp"%>   
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
 	
<%


   ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
   java.util.Date today = new java.util.Date();
   //out.println("today>>"+today); 
   
  
	String display_header ="Purchase Orer List";

%>
<style>
div.tooltip
{
    word-wrap:  break-word;
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      <%=display_header%>
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->
      <form name="myForm" method="post">
         <div class="box-body table-responsive no-padding">
            <div class="box-body"> 

		<table class="table table-striped" style="margin-bottom: 1%;"> 
		<Tr>
			<Th>From Date</Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th>To Date</Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("toDate")%> 
					  </div>
				  </div>
			</Td>
		

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th>QCF</th> 
                        <th>Vendor</th>
                        <th>RFQ No</th>
                        <th>RFQ Item</th>
                        <th>PR No</th>
                        <th>PR Item</th>
                        <th>PO No</th>
                        <th>PO Item</th>
                        <th>Quantity</th>			
                     </tr>
                  </thead>
                  <tbody>
<%

			for(int i=0;i<Count;i++)   
                        {
                        		String qcfNo	= hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
                        		String rfqType	= hdrXML.getFieldValueString(i,"ERH_EXT2");
                        		String plant	= hdrXML.getFieldValueString(i,"ERH_PLANT");
%>	 	
                     <tr>
                     	<td align="center">
<%
			if("DOM".equals(rfqType)){
%>			
			<a style='text-decoration:underline' href="ezViewDOMQCF.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
<%
			}else if("IMP".equals(rfqType)){
%>			
			<a style='text-decoration:underline' href="ezViewIMPQCF.jsp?qcfNo=<%=qcfNo%>&type=<%=type%>"><b><p style="color:#3a3636"><%=qcfNo%></p></b></a>
<%
			}
%>			
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERH_SOLD_TO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_RFQ_NO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_RFQ_LINE_NO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_PR_NO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_PR_ITEM")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_PO_NO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_PO_ITEM")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERP_QUANTITY")%></td>
		     </tr>	
<%
                        }
%>
                  </tbody>
               </table>                              
            </div>
         </div>
         <!-- Your Page Content Here -->   
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
<%@ include file="../Misc/ezDataTableScript.jsp"%>  

<Div id="MenuSol"></Div>
</body>
</html>
<script type="text/javascript" class="init"> 
   $(document).ready( function () {
       $("#type").val("<%=type%>");
       $('[data-toggle=tooltip]').tooltip();
       
      	table.fnSort([[2,"desc"],[0,"desc"]])
      	
   } );

   
   	function ezSubmit()
   	{
		document.myForm.action = "ezQCFPOList.jsp";
		document.myForm.submit();
	}
	function goToPlantAddr(plant)
	{
		//window.open("ezPlantAddress.jsp?plant="+plant,"plantdet", "status=no,toolbar=no,menubar=no,location=no,width=350,height=330,left=250,top=200");
		$('iframe').attr("src","../Purorder/ezPlantAddress.jsp?plant="+plant);
		$('#woModal').modal({show:true});
	}	
	$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});
	</script>

