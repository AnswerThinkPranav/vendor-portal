<%@ page import="java.util.*,java.text.*" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="ezc.ezparam.*,ezc.ezcommon.*,java.net.*,java.io.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezDefaultDate.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%>   
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 

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
   
  
	String display_header ="TAT Report";
	
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
                        <th>PR No</th> 
                        <th>Released On</th> 
                       	<th>Plant</th> 
                        <th>QCF No</th>
                        <th>Doc Value</th> 
                        <th>Initiator</th>
                        <th>Approver</th>
                        <th>Approved On</th>
                        <th>Role</th>
                        <th>Approval Time</th>
                        <th>Approval Time(Day(s))</th>
                     </tr>
                  </thead>
                  <tbody>
<%
	String qryStr="";
	if(fromDate != null && !"null".equals(fromDate) && !"null".equals(fromDate) && toDate != null && !"null".equals(toDate) && !"null".equals(toDate))
		qryStr = " AND EWDHH_CREATED_ON BETWEEN STR_TO_DATE('"+fromDate+" 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('"+toDate+" 23:59','%d/%m/%Y %H:%i')";			
		
	ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"select distinct ERP_PR_NO,ERP_PR_REL_DATE,ERH_PLANT,EWDHH_DOC_ID,ERH_FINAL_VALUE,EWDHH_CREATED_BY,(select z.eu_first_name from ezc_users z where z.eu_id=EWDHH_CREATED_BY) AS INITIATOR,ewdhh_created_on,EWAT_DATE,EWAT_SOURCE_PARTICIPANT,d.EU_FIRST_NAME,EWW_DESCRIPTION from ezc_rfq_prs A,ezc_wf_doc_history_header B,ezc_wf_audit_trail c,ezc_users d,ezc_wf_workgroup_users e,ezc_wf_workgroups f,ezc_rfq_header g where B.ewdhh_auth_key='QCF' and B.ewdhh_wf_status='APPROVED' and B.EWDHH_DOC_ID=A.ERP_QCF_NO and b.EWDHH_DOC_ID=c.EWAT_DOC_ID and c.EWAT_SOURCE_PARTICIPANT=d.eu_id and d.eu_id=e.EWWU_USER and e.EWWU_GROUP=f.EWW_GROUP and g.erh_colletive_rfq_no=b.EWDHH_DOC_ID "+qryStr+ " and g.erh_colletive_rfq_no='3020000005' order by EWAT_DOC_ID,EWAT_DATE");
	//ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"select distinct ERP_PR_NO,ERH_PLANT,EWDHH_DOC_ID,ERH_FINAL_VALUE,EWDHH_CREATED_BY,(select z.eu_first_name from ezc_users z where z.eu_id=EWDHH_CREATED_BY) AS INITIATOR,ewdhh_created_on,EWAT_DATE,EWAT_SOURCE_PARTICIPANT,d.EU_FIRST_NAME,EWW_DESCRIPTION from ezc_rfq_prs A,ezc_wf_doc_history_header B,ezc_wf_audit_trail c,ezc_users d,ezc_wf_workgroup_users e,ezc_wf_workgroups f,ezc_rfq_header g where B.ewdhh_auth_key='QCF' and B.ewdhh_wf_status='APPROVED' and B.EWDHH_DOC_ID=A.ERP_QCF_NO and b.EWDHH_DOC_ID=c.EWAT_DOC_ID and c.EWAT_SOURCE_PARTICIPANT=d.eu_id and d.eu_id=e.EWWU_USER and e.EWWU_GROUP=f.EWW_GROUP and g.erh_colletive_rfq_no=b.EWDHH_DOC_ID and erp_pr_no  in ('0011258141') order by EWAT_DOC_ID,EWAT_DATE");
	int retQryCnt=0;
	if(retQry != null)
	retQryCnt= retQry.getRowCount();
	//out.println("retQryCnt>>>"+retQryCnt);
	Vector qcfVect = new Vector();	
	//SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
	        SimpleDateFormat sdf
	            = new SimpleDateFormat(
                "yyyy-MM-dd HH:mm:ss");
	
		for(int i=0;i<retQryCnt;i++)
		{
			String prNo = retQry.getFieldValueString(i,"ERP_PR_NO");
			String prRelDt = "";
			String plant = retQry.getFieldValueString(i,"ERH_PLANT");
			String qcfNo = retQry.getFieldValueString(i,"EWDHH_DOC_ID");
			String initiator = retQry.getFieldValueString(i,"INITIATOR");
			String approver = retQry.getFieldValueString(i,"EU_FIRST_NAME");
			String role = retQry.getFieldValueString(i,"EWW_DESCRIPTION");
			//out.println("qcfNo>>>"+qcfNo);
			String docValue="0.00";
			
			try
			{
				prRelDt 	= convertDateObjToString((Date)retQry.getFieldValue(i,"ERP_PR_REL_DATE"));	 
			}
			catch(Exception e)
			{
				prRelDt="";
			}

			
			
			try
			{
			docValue =  retQry.getFieldValueString(i,"ERH_FINAL_VALUE");  
			docValue = (Double.parseDouble(docValue))+"";
			docValue  = new java.math.BigDecimal(docValue).setScale(2,java.math.BigDecimal.ROUND_DOWN).toString();
			}
			catch(Exception e){
			docValue="0.00";
			}                     			
			String dispAprTime= "0";
			String dispAprDays= "0";
			if(qcfVect.contains(qcfNo))
			{
				Date d1= sdf.parse(retQry.getFieldValueString(i-1,"EWAT_DATE")); 
				//out.println("D1>>>"+d1);
				Date d2= sdf.parse(retQry.getFieldValueString(i,"EWAT_DATE")); 
				//out.println("D2>>>"+d2);
				long apprTime = d2.getTime()-d1.getTime();
				//out.println("apprTime>>>"+apprTime);
				//long apprDays = (apprTime/(1000*60*60*24))%365;
				//out.println("apprDays>>>"+apprDays);
				//long apprHrs = (apprTime/(1000*60*60))%24;
				//out.println("apprHrs>>>"+apprHrs);
				long apprMin = (apprTime/(1000*60))%60;
				//out.println("apprMin>>>"+apprMin);
				//dispAprTime = apprMin+"";
				
				    long difference_In_Seconds
					= TimeUnit.MILLISECONDS
					      .toSeconds(apprTime)
					  % 60;

				    long difference_In_Minutes
					= TimeUnit
					      .MILLISECONDS
					      .toMinutes(apprTime)
					  % 60;

				    long difference_In_Hours
					= TimeUnit
					      .MILLISECONDS
					      .toHours(apprTime)
					  % 24;

				    long difference_In_Days
					= TimeUnit
					      .MILLISECONDS
					      .toDays(apprTime)
					  % 365;
					  
				    String apDays= difference_In_Days+"";
				    String apHrs= difference_In_Hours+"";
				    String apMin= difference_In_Minutes+"";
				    String apSec= difference_In_Seconds+"";
					  
				     if(difference_In_Days>0)
				     	dispAprTime = apDays+"day(s)"+" "+apHrs+":"+apMin+":"+apSec;	  
				     else if(difference_In_Hours>0)
				     	dispAprTime = apHrs+":"+apMin+":"+apSec;	  
				     else if(difference_In_Minutes>0)
				     	dispAprTime = apMin+":"+apSec;	  
				     else if(difference_In_Seconds>0)
				     	dispAprTime = apSec;
				     
				     if(difference_In_Days>0)
				     	dispAprDays = apDays;
				
				     	
				     	
			}
			else
			{
				qcfVect.add(qcfNo);
				Date d2= (Date)retQry.getFieldValue(i,"EWAT_DATE"); 
			}
%>			
			<tr>
			<td align="center"><%=prNo%></td>
			<td align="center"><%=prRelDt%></td>
			<td align="center"><%=plant%></td>
			<td align="center"><%=qcfNo%></td>
			<td align="center"><%=docValue%></td>
			<td align="center"><%=initiator%></td>
			<td align="center"><%=approver%></td>
			<td align="center"><%=sdf.format((Date)retQry.getFieldValue(i,"EWAT_DATE"))%></td>
			<td align="center"><%=role%></td>
			<td align="center"><%=dispAprTime%></td>
			<td align="center"><%=dispAprDays%></td>
			
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
      <iframe id="txtArea1" style="display:none"></iframe>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">      
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>  
            <iframe src="" width="100%" height="200" frameborder="0" allowtransparency="true"></iframe> 
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


   	function ezSubmit()
   	{
		document.myForm.action = "ezTatReport.jsp";
		document.myForm.submit();
	}
	
	$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			ezSubmit();
		}
	});

	
</script>

