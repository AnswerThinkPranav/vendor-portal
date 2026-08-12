<%@ page import="java.util.*,java.text.*" %> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>    
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*,java.text.*" %>
<%@include file="../Misc/ezGetJGLVendorsList.jsp"%>   
<%!  
	public String checkNull(String value)   
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
	public ezc.ezparam.ReturnObjFromRetrieve ezMiscSelect(ezc.session.EzSession Session,String qryStr)
	{
		ezc.ezparam.ReturnObjFromRetrieve dtlXML	  =	null;
		try
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery(qryStr);
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			dtlXML=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

		}
		catch(Exception e)
		{

		}
		return dtlXML;
	} 	
%>
<%

	String type = request.getParameter("type"); 
	String selPlant = request.getParameter("selPlant");  
	String selVendorCode = request.getParameter("selVendorCode");
	
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	int plantLen   = 0 ;
	try
	{
		plantObj=ezMiscSelect(Session,"SELECT * FROM EZC_PLANTS");
		plantLen   = plantObj.getRowCount();
	}catch(Exception e){}
	
	ezc.ezparam.ReturnObjFromRetrieve vendObj	  =	null;
	int vendLen   = 0 ;
	try
	{
		vendObj=ezMiscSelect(Session,"SELECT * FROM EZC_USERS WHERE EU_TYPE='3'");
		vendLen   = vendObj.getRowCount();
	}catch(Exception e){}
	
	String qryStr="",qryRFQ="";
	ReturnObjFromRetrieve hdrXML=null;
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 
		
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	//if(!"ALL".equals(selPlant))
		//qryStr+=" AND a.EAH_PLANT IN ('"+selPlant+"') ";		
	if(!"ALL".equals(selVendorCode)&&!"".equals(selVendorCode)&&selVendorCode != null && !"null".equals(selVendorCode))
		qryStr+=" AND C.EAS_SUPPLIER_CODE IN ('"+selVendorCode+"') ";		
	
	//if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		//qryStr += " AND A.EAH_CREATION_DATE BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	
	//qryRFQ="SELECT * FROM EZC_AUCTION_HEADER A,EZC_AUCTION_SUPPLIER B,EZC_RFQ_POS C WHERE A.EAH_AUCTION_ID=B.EAS_AUCTION_ID AND A.EAH_AUCTION_ID=C.ERP_RFQ_NO AND B.EAS_AUCTION_ID=C.ERP_RFQ_NO AND B.EAS_SUPPLIER_ID=C.ERP_SUP_ID AND C.ERP_TYPE='A'    AND concat(A.EAH_PLANT,'#',A.EAH_CATEGORY) IN ('"+gv_CategoriesForQry+"') "+qryStr;	
	qryRFQ="SELECT  A.*,B.*,C.*,DATE_FORMAT(EAH_TIME_STAMP,'%d/%m/%Y %h:%i:%s %p') TIME_STAMP,(EAH_AUCTION_VALUE/EAI_QUANTITY) ITEM_PRICE FROM EZC_AUCTION_HISTORY A, EZC_AUCTION_ITEM B, EZC_AUCTION_SUPPLIER C WHERE  A.EAH_AUCTION_ID = B.EAI_AUCTION_ID AND A.EAH_ITEM_ID = B.EAI_ITEM_ID AND A.EAH_AUCTION_ID = C.EAS_AUCTION_ID AND A.EAH_SUPPLIER_ID = C.EAS_SUPPLIER_ID "+qryStr+"ORDER BY B.EAI_ITEM_CODE,A.EAH_TIME_STAMP asc";
	ezc.ezcommon.EzLog4j.log("** qryRFQ"+qryRFQ,"I");
	out.println("** qryRFQ"+qryRFQ);
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
	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

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
			<Th>Vendor</Th>
			<Td >
				<div class="input-group-addon">
					<%=vendorsSelBox%> 
				 </div>
			</Td>				

					
			<Th>Plant</Th>
			<Td >
				<select name="selPlant" id="selPlant" class="form-control select2" style="width:100% !important"> 
				<option value="ALL" selected>All</option>

<%
				for(int j=0;j<plantLen;j++)
				{
						if(gv_PlantVect.contains(plantObj.getFieldValueString(j,"EP_PLANT").trim()))
						{	
							out.println("<option value='"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"'>"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"->"+plantObj.getFieldValueString(j,"EP_NAME1")+"</option>");
						}

				}
%>
				</select>
			</Td>				

			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>

               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                  <thead>
                     <tr>
                        <th>Auction Id</th> 
                        <th>Vendor</th>
                        <th>IP ADDRESS</th>
                        <th>History</th>
                     </tr>
                  </thead>
                  <tbody>
<%

			for(int i=0;i<Count;i++)   
                        {
                        		String auctionId	= hdrXML.getFieldValueString(i,"EAH_AUCTION_ID");
                        		
                        		String plant	= hdrXML.getFieldValueString(i,"EAH_PLANT");
					String soldList=  hdrXML.getFieldValueString(i,"EAS_SUPPLIER_CODE");
					String dispSoldTo="";
					try{
						soldList = Long.parseLong(soldList)+""; 
						dispSoldTo=soldList;
						soldList = "0000000000"+soldList;
						soldList = soldList.substring(soldList.length()-10,soldList.length());
					}catch(Exception e){
						dispSoldTo=soldList;	
						}  

					                        
                        
                        		
%>	 	
                     <tr>
               		<!--<td align="center"><%=auctionId%></td>-->
               		<td align="center"><a href='ezAuctionReport.jsp?auctionId=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%>&auctionName=<%=hdrXML.getFieldValueString(i,"EAH_AUCTION_NAME")%>'><%=hdrXML.getFieldValueString(i,"EAH_AUCTION_ID")%></a></td>
                     	<td><%=checkNull((String)gv_VendorsHT.get(soldList))+" ["+dispSoldTo+"]"%></td>
                     	<td align="center"><%=checkNull(hdrXML.getFieldValueString(i,"EAH_IP_ADDR"))%></td>
                     	
                     	<!--<td align="center"><a href='#'  onclick="funSummary('<%=auctionId%>')"><i class="fa fa-history"></i></a></td>-->
                     	<td align="center"><a href="javascript:funSummary('<%=auctionId%>');"><i class="fa fa-history"></i></a></td>     		
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
       $("#selPlant").val("<%=selPlant%>");
       $('[data-toggle=tooltip]').tooltip();
       
      	table.fnSort([[2,"desc"],[0,"desc"]])
      	
   } );
   

	function funSummary(auctionId)
	{
		var url="ezViewSummary.jsp?auctionId="+auctionId;
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
	}
   
   	function ezSubmit()
   	{
		document.myForm.action = "ezAuctionVendIPReport.jsp";
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

