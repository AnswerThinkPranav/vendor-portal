<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iEzAuctionLabels.jsp"%>
           
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

	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	String qryRFQ="";
	String qryStr="";
	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	
	qryStr+="AND B.EWDHH_WF_STATUS IN ('APPROVED')";
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	
	qryRFQ="SELECT DISTINCT A.EAH_AUCTION_ID,A.EAH_AUCTION_NAME,A.EAH_START_DATE,A.EAH_END_DATE,B.EWDHH_CREATED_ON,B.EWDHH_MODIFIED_ON,B.EWDHH_CREATED_BY,D.EAS_SUPPLIER_CODE,D.EAS_EXT1,D.EAS_SUPPLIER_ID FROM EZC_AUCTION_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.EAH_AUCTION_ID=B.EWDHH_DOC_ID INNER JOIN  EZC_AUCTION_RECOMMENDED_ITEMS C ON A.EAH_AUCTION_ID=C.EARI_AUCTION_ID INNER JOIN  EZC_AUCTION_SUPPLIER D ON A.EAH_AUCTION_ID=D.EAS_AUCTION_ID AND C.EARI_SUPPLIER_ID=D.EAS_SUPPLIER_ID  WHERE concat(A.EAH_PLANT,'#',A.EAH_CATEGORY) IN ('"+gv_CategoriesForQry+"') AND C.EARI_PO_QTY > 0 AND (C.EARI_PO_CR_QTY IS NULL OR C.EARI_PO_QTY-C.EARI_PO_CR_QTY > 0) "+qryStr;
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
   
  
	String display_header ="";
	if("2".equals(userType))
	{
		display_header	= "Pending For PO Creation"; 
		
	}


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
			<Th><%=from_Date_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th><%=To_Date_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="toDate" id="toDate" value="<%=toDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("toDate")%> 
					  </div>
				  </div>
			</Td>
	

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;"><%=Go_L%><i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                     	<th></th>
                        <th><%=Auc_Id_L%></th> 
                        <th><%=Auc_Name_L%></th> 
                        <th><%=supplier_L%></th> 
                        <th><%=start_Date_L%></th>
                        <th><%=End_Date_L%></th>
                        <th><%=Ini_On_L%></th>
                        <th><%=Last_Mod_On_L%></th>
                        <th><%=Buyer_L%></th>
			
                     </tr>
                  </thead>
                  <tbody>
<%
			SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy hh:mm aaa");
			for(int i=0;i<Count;i++)   
                        {
%>	 	
                     <tr>
                     	<td><input type="radio" name="auctChkVal" value="<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")+"#"+hdrXML.getFieldValueString(i,"EAS_SUPPLIER_ID")%>"></td>
                     	<td align="center"><a href='ezAuctionReport.jsp?auctionId=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%>&auctionName=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_NAME")%>'><%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%></a></td>
                     	<td><%=hdrXML.getFieldValueString(i,"EAH_AUCTION_NAME")%></td>
                     	<td><%=hdrXML.getFieldValueString(i,"EAS_SUPPLIER_CODE")+"["+hdrXML.getFieldValueString(i,"EAS_EXT1")+"]"%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EAH_START_DATE"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EAH_END_DATE"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_CREATED_ON"))%></td>
                     	<td><%=sdf.format((Date)hdrXML.getFieldValue(i,"EWDHH_MODIFIED_ON"))%></td>
                     	<td><%=hdrXML.getFieldValueString(i,"EWDHH_CREATED_BY")%></td>
		     </tr>	
<%
                        }
%>
                  </tbody>
               </table>                              
            </div>
         </div>
         <div class="row">
	 	 <div class="col-xs-12" align="center">
	 	 	<button type="button" class="btn btn-primary" onclick="history.go(-1)" ><i class="fa fa-backward"></i>&nbsp;<%=back_L%></button>
	 	 	<button type="button" class="btn btn-primary" onclick="ezSubmit()" ><i class="fa fa-check"></i>&nbsp;<%=continue_L%></button>
	 	 	
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
       
      
   } );

   
   	function ezSubmit()
   	{
		document.myForm.action = "ezAuctionConfirmPO.jsp";
		document.myForm.submit();
	}
		
</script>

