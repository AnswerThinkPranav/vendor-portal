<%@ page import="java.util.*,java.text.*" %> 
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>  
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iRFQCreate_Labeles.jsp"%>
<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*,java.text.*" %> 
<%@include file="../Misc/ezGetJGLVendorsList.jsp"%>   
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
	
	if("2".equals(userType) && "PP".equals(userRole)) 
		qryStr+=" AND ERH_CREATED_BY='"+Session.getUserId()+"'";	
	
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr += " AND A.ERH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 00:00','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	
	
	qryRFQ="SELECT * FROM EZC_RFQ_HEADER A,EZC_RFQ_DETAILS B WHERE A.ERH_RFQ_NO= B.ERD_RFQ_NO AND ERH_STATUS IN('P','R','Y','S') "+qryStr;	
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
			<Th><%=from_Date_L%></Th>
			<Td>
				  <div class="input-group">
					  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="<%=fromDate%>" readonly>
					  <div class="input-group-addon">
					  	<%=getDateImage("fromDate")%> 
					  </div>
				  </div>
			</Td>
			<Th><%=to_Date_L%></Th>
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
                        <th><%=RFQ_L%></th>
                        <th><%=RFQ_Item_L%></th>                     
                        <th><%=RFQ_Date_L%></th>
                        <th><%=QCF_L%></th> 
                        <th><%=PR_NO_L%></th>
                        <th><%=Vendor_L%></th>
                        <th><%=mat_L%></th>
                        <th><%=desc_L%></th>
                        <th><%=price_L%></th>
                        <th><%=plant_L%></th>
                        <th><%=pmt_Terms_L%></th>
                        <th><%=inco_Terms_L%></th>
                        <th><%=qoute_on_off_L%></th>
                        <th><%=RFQ_vldty_L%></th>
                        <th><%=RFQ_Closure_L%></th>
                        
                     </tr>
                  </thead>
                  <tbody>
<%

			for(int i=0;i<Count;i++)   
                        {
                        		String qcfNo	= hdrXML.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
                        		String rfqType	= hdrXML.getFieldValueString(i,"ERH_EXT2");
                        		String plant	= hdrXML.getFieldValueString(i,"ERH_PLANT");
					String soldList = hdrXML.getFieldValueString(i,"ERH_SOLD_TO");
					String matCode	= hdrXML.getFieldValueString(i,"ERD_MATERIAL");
					String dispMat	= "";
					
					try{
						dispMat = Long.parseLong(matCode)+""; 
						

					}catch(Exception e){
						dispMat="";	
					}  					
					
					//if("SM".equals(matCode.substring(0,2)))
						//matCode="";
					
					
					String dispSoldTo="";
					try{
						soldList = Long.parseLong(soldList)+""; 
						dispSoldTo=soldList;
						soldList = "0000000000"+soldList;
						soldList = soldList.substring(soldList.length()-10,soldList.length());
					}catch(Exception e){
						dispSoldTo=soldList;	
					}  
					String prRelDt = "";
					try
					{
						prRelDt 	= convertDateObjToString((Date)hdrXML.getFieldValue(i,"ERP_PR_REL_DATE"));	 
					}
					catch(Exception e)
					{
						prRelDt="";
					}
					String pmntStr = hdrXML.getFieldValueString(i,"ERH_PAYMENT_TERMS");
					String incoStr=  hdrXML.getFieldValueString(i,"ERH_INCO_TERMS1");
					String quoteBy="offline";
					if("3".equals(hdrXML.getFieldValueString(i,"ERH_SAVE_FLG")))
						quoteBy="Online";
					                        
                        
                        		
%>	 	
                     <tr>
                     	
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERH_RFQ_NO")%></td>
                     	<td align="center"><%=hdrXML.getFieldValueString(i,"ERD_LINE_NO")%></td>    
                     	<td align="center"><%=formatter.format((Date)hdrXML.getFieldValue(i,"ERH_CREATED_ON"))%></td>	
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
			<td align="center"><%=hdrXML.getFieldValueString(i,"ERD_EXT1")%></td>	
                     	<td><%=checkNull((String)gv_VendorsHT.get(soldList))+" ["+dispSoldTo+"]"%></td>
                     	<td align="center"><%=dispMat%></td>
                     	<td align="left"><%=hdrXML.getFieldValueString(i,"ERD_MATERIAL_DESC")%></td>
                     	<td align="right"><%=hdrXML.getFieldValueString(i,"ERD_PRICE")%></td>
                     	<td><%=plant%></td>
                     	<td align="left"><%=pmntStr+"["+checkNull((String)pmntHash.get(pmntStr))+"]"%></td>
                     	<td align="left"><%=incoStr+"["+incoHash.get(incoStr)+"]"%></td>
                     	<td align="left"><%=quoteBy%></td>
                     	<td align="center"><%=formatter.format((Date)hdrXML.getFieldValue(i,"ERH_VALID_UPTO"))%></td>	
                     	<td align="center"><%=formatter.format((Date)hdrXML.getFieldValue(i,"ERH_MODIFIED_ON"))%></td>	
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
		document.myForm.action = "ezRfqMisReport.jsp";
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

