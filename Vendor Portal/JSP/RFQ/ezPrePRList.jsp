<%@page import="ezc.ezutil.*,java.util.*"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>    
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iPrePRList_Labels.jsp"%> 
 <%
	 
	String Status = request.getParameter("Status"); 
	String display_header = "",purGrpFromBack="",selected="";  
	
	if("R".equals(Status))
		display_header = "Selection Criteria for Released PRs"; 
	else
		display_header = "Selection Criteria for Unreleased PRs";
	
%>

<style>
.multiselect-container>li>a>label {
  padding: 4px 20px 3px 20px;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      <%=pur_Req_List_L%> 
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">

<body onload=funLoad()>

<Form name="myForm" method="POST">
<Input type="hidden" name="Status" value="<%=Status%>">  
<!-- Table row -->
      <div class="row">
	<div class="col-xs-12 table-responsive">	    
	<table class="table table-bordered">
	<!--<Tr>
		<Th align="left">Material Number</Th>
		<Td>
			<input type="text" class="form-control"   name="matNo" maxlength="20">
		</Td>
		<Td>
			<input type="text" class="form-control"  name="matDescScrh"  value="Enter Search String Here." onFocus="setEmpty()" onKeyPress="KeySubmit()">
		</Td>	
		<Td valign=middle align=center rowspan=2>	
			<a href= "javascript:searchForMaterial()">Find</a> 
		</Td>
	</Tr> 

	 <tr>
		    <th align="left">Material Desc.</th>
		    <td>
			<input type="text" class="form-control"     name="matDesc" maxlength="20" value="" readonly>
		    </Td>
		     <th><input type="radio" name="SearchMat"  value="MatNo" checked>Material No.<input type="radio" name="SearchMat"  value="MatDesc">Material Desc.</th> 
	   </tr> -->
	<input type="hidden" class="form-control"     name="matDesc" maxlength="20" value="">
	<input type="hidden" class="form-control"   name="matNo" maxlength="20"> 
<%
	int deptLen    = reqDeptObj.getRowCount();
	int matGrpLen  = matlGrpObj.getRowCount();
	int purLength  = purGrpObj.getRowCount();
	int docTypeLen = docTypeObj.getRowCount();
	int mrpLength  = mrpCtrlObj.getRowCount();
	int itmLength  = itemCatObj.getRowCount();
	int accLength  = accCatObj.getRowCount();
	int proLength  = proStatObj.getRowCount();
	int plantLen   = plantObj.getRowCount();
	
%>
		<Tr>
		<!--<Th align="left">Purchase Requisition</Th>
		<Td>
			<input type="text" class="form-control input-sm"   name="prNum" maxlength="10">
			<i class="fa fa-plus-square-o" style="position: absolute; top: 18px; left: 555px; font-size:16px;    cursor: pointer;" onclick="funAddMulti('prNum','Purchase Requisition')";></i>

		</Td> -->
		
		<!--<Th align="left">Requisitioner</Th>
		<Td>
			
			<select name="reqSr" id="reqSr" multiple class="form-control" style="width:100% !important" >  
<%
			for(int j=0;j<deptLen;j++)
			{
				selected="";
				out.println("<option value='"+reqDeptObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+reqDeptObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+reqDeptObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>					

 	 		</select>
			
		</Td>	
		<Th align="left">Created By</Th>
		<Td>
			<input type="text" class="form-control input-sm"   name="createdBy" maxlength="10">
		</Td>		
	
	</Tr> -->
	
	<Tr>
		    <th align="left"><%=pre_Pur_Grp_L%></th>
		    <td>
		      
		 
		    	<select name="purGrp" id="purGrp" multiple class="form-control"  style="width:100% !important">
			
<%
			//out.println("::::gv_PurGrpVect::::::"+gv_PurGrpVect);
			purGrpFromBack=request.getParameter("purGrpFromBack");
			//out.println("::::purGrpFromBack::::::"+purGrpFromBack);
			if(purGrpFromBack==null || "null".equals(purGrpFromBack))purGrpFromBack="";
			for(int j=0;j<purLength;j++)
			{
				//selected="";
				//if(!"".equals(purGrpFromBack) && purGrpFromBack.equals(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))selected="selected";
				//out.println("purGrpObj>>"+purGrpObj.getFieldValueString(j,"EMKV_KEY").trim());
				/*if(gv_PurGrpVect.contains(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))
				{
					//out.println("<option value='"+purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+purGrpObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					selected="selected";
				}*/
				//else
				//	continue;
					
				out.println("<option value='"+purGrpObj.getFieldValueString(j,"VALUE1").trim()+"'"+selected+">"+purGrpObj.getFieldValueString(j,"VALUE1").trim()+"->"+purGrpObj.getFieldValueString(j,"VALUE2")+"</option>");	
			}
%>		
		
		    </select>
		   
		    </Td>	

		<Th align="left"><%=pre_Plant_L%><font color="red">*</font></Th>
		<Td >
			<select name="selplant" id="selplant" multiple class="form-control" style="width:100% !important"> 
			
<%
			for(int j=0;j<plantLen;j++)
			{
				selected="";
				if(gv_PlantVect.size()>0)
				{
					if(gv_PlantVect.contains(plantObj.getFieldValueString(j,"EP_PLANT").trim()))
					{	
						//selected="selected";
						out.println("<option value='"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"'"+selected+">"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"->"+plantObj.getFieldValueString(j,"EP_NAME1")+"</option>");
					}
				}
				else
					out.println("<option value='"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"'"+selected+">"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"->"+plantObj.getFieldValueString(j,"EP_NAME1")+"</option>");
					
				
			}
%>
			</select>
		</Td>
	</Tr> 
	<Tr>
		    <th align="left"><%=pre_Doc_Type_L%></th>
		    <td>
			<select name="docType" id="docType" multiple class="form-control" style="width:100% !important" > 
<%
			for(int j=0;j<docTypeLen;j++)
			{
			
				selected="";
				if(gv_DocVect.contains(docTypeObj.getFieldValueString(j,"EMKV_KEY").trim()))
				{
					selected="selected";
				}	
				out.println("<option value='"+docTypeObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+docTypeObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+docTypeObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>			
		    </select>				
		    </Td>		    
		     	
		<Th align="left"><%=pre_Mat_Grp_L%></Th>
		<Td >
			<select name="matGrp" id="matGrp" multiple class="form-control" style="width:100% !important" >  
			
<%
			for(int j=0;j<matGrpLen;j++)
			{
				selected="";
				out.println("<option value='"+matlGrpObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+matlGrpObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+matlGrpObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>					

 	 		</select>

		</Td>			
		    


	</Tr>	
	<Tr>
		    <th align="left"><%=pre_Acc_Ass_Cat_L%></th>
		    <td>
		    	<select name="accCat" id="accCat" multiple class="form-control" style="width:100% !important">
<%
			for(int j=0;j<accLength;j++)
			{
				selected="";
				out.println("<option value='"+accCatObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+accCatObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+accCatObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>			
		    </select>				
		    </Td>	
		    <th align="left"><%=pre_Item_Cat_L%></th>
		    <td>
		    	<select name="itemCat" id="itemCat" multiple class="form-control" style="width:100% !important">
		    	
<%
			for(int j=0;j<itmLength;j++)
			{
				out.println("<option value='"+itemCatObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+itemCatObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+itemCatObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>			
		    </select>		    		
		    </Td>	

	</Tr> 
	<!--<Tr>
		    <th align="left">MRP Controller</th>
		    <td>
		    	<select name="mrpCtl" id="mrpCtl" multiple class="form-control"  style="width:100% !important">
		    	
<%
			for(int j=0;j<mrpLength;j++)
			{
				out.println("<option value='"+mrpCtrlObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+mrpCtrlObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+mrpCtrlObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}
%>			
		    </select>		    	
			
		    </Td>
		<th align="left">Processing Staus</th>
		<td>
		<select name="proStat" id="proStat" multiple class="form-control" style="width:100% !important">
		
<%
		for(int j=0;j<proLength;j++)
		{
			out.println("<option value='"+proStatObj.getFieldValueString(j,"EMKV_KEY").trim()+"'"+selected+">"+proStatObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+proStatObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
		}
%>			
		</select>				
		</Td>		    


	</Tr> -->
	<!--<Tr>
		<Th align="left">Fixed Vendor</Th>
		<Td>
			<input type="text" class="form-control input-sm"   name="fixVen" maxlength="10">
		</Td> 
		<Th align="left">Deletion Indicator</Th>
		<Td>
			<select name="delInd" id="delInd" class="form-control input-sm select2"  style="width:100% !important">
		    	<option value="">-- Select--</option>
		    	<option value="1">Blocked by Requester</option>
		    	<option value="0">Not Blocked</option>
		    	<input class="" type="checkbox"  name="delInd" id="delInd" value="X" >
		</Td> 
		
		<Th align="left">Tracking No.</Th>
		<Td>
			<input type="text" class="form-control input-sm"   name="trackNo" maxlength="10">
		</Td>			
		
	</Tr> -->
	
	<!--<Tr>
		<Th>Delivery Date</Th>
		<Td>
			<div class="input-group">
				  <input class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="" readonly>
				  <%=getDateImage("fromDate")%> 
		  	</div>
		</Td>
	
		<Th align="left">To</Th>
		<Td>
			<div class="input-group">
				  <input class="form-control input-sm input-sm" type="text"   name="toDate" id="toDate" value="" readonly> 
				  <%=getDateImage("toDate")%> 
		  	</div>
		</Td>
	</Tr>	
 	
	<Tr>
		<Th>Release Date</Th>
		
		<Td>
			<div class="input-group">
				  <input class="form-control input-sm" type="text"  name="relFromDate" id="relFromDate" value="" readonly>
				  <%=getDateImage("relFromDate")%> 
		  	</div>
		</Td>
	
		<Th align="left">To</Th>
		<Td>
			<div class="input-group">
				  <input class="form-control input-sm" type="text"   name="relToDate" id="relToDate" value="" readonly>
				  <%=getDateImage("relToDate")%> 
		  	</div>
		</Td>
	</Tr> -->
	<Tr>
		<Th><%=pre_Pur_Req_L%></Th>
		
		<Td>
			<input type="number" class="form-control input-sm"   name="prLow" maxlength="10">
			<!--<i class="fa fa-plus-square-o" style="position: absolute; top: 18px; left: 555px; font-size:16px;    cursor: pointer;" onclick="funAddMulti('prLow','Purchase Requisition')";></i>-->

		</Td>
	
		<Th align="left"><%=To_L%></Th>
		<Td>
			<input type="number" class="form-control input-sm"   name="prHigh" maxlength="10">
			<!--<i class="fa fa-plus-square-o" style="position: absolute; top: 18px; left: 555px; font-size:16px;    cursor: pointer;" onclick="funAddMulti('prHigh','Purchase Requisition')";></i>-->

		</Td>
		<Td nowrap>
					<input type="hidden" class="form-control input-sm"   name="prMulti" maxlength="10">
					<i class="fa fa-arrow-right" style="font-size:20px;cursor: pointer;" onclick="funAddMulti('prMulti','Purchase Requisition')";></i>
		</Td>	
	</Tr>
	<Tr>
		<Th><%=pre_Mat_L%></Th>
		
		<Td>
			<input type="number" class="form-control input-sm"   name="matLow" maxlength="10">
			<!--<i class="fa fa-plus-square-o" style="position: absolute; top: 18px; left: 555px; font-size:16px;    cursor: pointer;" onclick="funAddMulti('prLow','Purchase Requisition')";></i>-->

		</Td>
	
		<Th align="left"><%=To_L%></Th>
		<Td>
			<input type="number" class="form-control input-sm"   name="matHigh" maxlength="10">
			<!--<i class="fa fa-plus-square-o" style="position: absolute; top: 18px; left: 555px; font-size:16px;    cursor: pointer;" onclick="funAddMulti('prHigh','Purchase Requisition')";></i>-->

		</Td>
		<Td nowrap>
					<input type="hidden" class="form-control input-sm"   name="matMulti" maxlength="10">
					<i class="fa fa-arrow-right" style="font-size:20px;cursor: pointer;" onclick="funAddMulti('matMulti','Material(s)')";></i>
		</Td>	
	</Tr>	
	<Tr>
		<Th align="left"><%=pre_Amm_L%></Th>
		<Td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="prVer" value="Y">&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<input type="radio"  name="prVer" value="N">&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<input type="radio"  name="prVer" value="A" checked>&nbsp;&nbsp;&nbsp;All
		</Td>	
		<Th align="left"><%=pre_RFQ_Status_L%></Th>
		<Td colspan=4>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"  name="rfqStat" value="Y">&nbsp;&nbsp;&nbsp;Floated&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<input type="radio"  name="rfqStat" value="N" checked>&nbsp;&nbsp;&nbsp;Pending&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<input type="radio"  name="rfqStat" value="A">&nbsp;&nbsp;&nbsp;All
		</Td>		
	</Tr>
	<Tr>
		<Th align="left"><%=pre_days_L%></Th>
		<Td colspan=4>
			<!--<input type="number" class="form-control input-sm"   name="days" id="days" value="60" max="60" onKeyUp="if(this.value>60){this.value='60';}else if(this.value<0){this.value='60';}">-->
			<input type="number" class="form-control input-sm"   name="days" id="days" value="60" max="1500" onKeyUp="if(this.value>1500){this.value='1500';}else if(this.value<0){this.value='1500';}">
		</Td>	
	</Tr>	
	<input type="hidden" class="form-control input-sm" type="text"  name="fromDate" id="fromDate" value="" readonly>
	<input type="hidden" class="form-control input-sm input-sm" type="text"   name="toDate" id="toDate" value="" readonly> 
	<input type="hidden" class="form-control input-sm" type="text"  name="relFromDate" id="relFromDate" value="" readonly>
	<input type="hidden" class="form-control input-sm" type="text"   name="relToDate" id="relToDate" value="" readonly>
	<input type="hidden" class="form-control input-sm" type="text"   name="reqSr" id="reqSr" value="" readonly>
	<input type="hidden" class="form-control input-sm" type="text"   name="createdBy" id="createdBy" value="" readonly>
	<input type="hidden" class="form-control input-sm" type="text"   name="mrpCtl" id="mrpCtl" value="" readonly>
	<input type="hidden" class="form-control input-sm" type="text"   name="proStat" id="proStat" value="" readonly>

</table>
	</div>
	<!-- /.col -->
      </div>
      <!-- /.row -->	
<br> 
<div class="row no-print">
	<div class="col-xs-12">
		<button type="button" class="btn btn-primary pull-right" onclick="reset()" style="margin-right: 5px;"><i class="fa fa-remove"></i> <%=Reset_L%></button>
		<button type="button" class="btn btn-primary pull-right" onclick="getPRs()" style="margin-right: 5px;"><i class="fa fa-search"></i><%=get_PRS_L%></button>		
		</div>
		</div>

</Form>
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

      <!-- Main Footer -->
      <footer class="main-footer no-print">
        <!-- To the right -->
        
        <!-- Default to the left -->
        <strong>Copyright &copy; <%=((new java.util.Date()).getYear()+1900)%> <a href="http://www.thehackettgroup.com/">The Hackett Group</a>.</strong> All rights reserved.
      </footer>

     
      <div class="control-sidebar-bg"></div>
    </div><!-- ./wrapper -->
	<div class="modal fade" id="pleaseWaitDialog">
		 <div class="modal-dialog" style="padding-top: 15%;">
   		<div class="modal-content" style="background: transparent;">
		<div class="modal-body">
		    <img src="../img/squares.gif" style="margin-left:55%;"/>
		</div>
		</div>
		</div>
	</div>
    <!-- REQUIRED JS SCRIPTS -->
    <!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/iCheck/icheck.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/fuse/dist/fuse.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/fuzzycomplete.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js?2"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js?2"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<!--<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>-->
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<!--datatables download -->
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/dataTables.buttons.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.flash.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/jszip.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/vfs_fonts.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.html5.min.js"></script>	
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.print.min.js"></script>	

	<!--end-->
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
         
<script>

 jQuery.extend( jQuery.fn.dataTableExt.oSort, {
	"date-uk-pre": function ( a ) {
		if (a == null || a == "") {
			return 0;
		}
		var ukDatea = a.split('/');
		return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
	},

	"date-uk-asc": function ( a, b ) {
		return ((a < b) ? -1 : ((a > b) ? 1 : 0));
	},

	"date-uk-desc": function ( a, b ) {
		return ((a < b) ? 1 : ((a > b) ? -1 : 0));
	}
} );

	$(function () {
		$('.select2').select2()
	 });
	
	function callFun(clickedOn)
	{
		if(clickedOn=='H')
		{
			top.display.location.href = "../Misc/ezSBUWelcomeWait.jsp";
		}	
		else if(clickedOn=='L')
		{
			top.location.href='../Misc/ezLogout.jsp'
		} 
	}
	function changePurArea1()
	{
		if(confirm("Do you want to continue with the selected Purchase Area?"))
		{
			var selcatarea=document.headerForm.CatalogArea.value;
			document.headerForm.callPreWelcomePage.value="Y";
			document.headerForm.target="banner"
			document.headerForm.changePurArea.value="Y";
			document.headerForm.action = "../Misc/ezVendWelcome.jsp?CatalogArea="+selcatarea;
			document.headerForm.submit();
		}
		else
		{
			document.headerForm.CatalogArea.options[document.headerForm.selPAIndex.value].selected=true;
		}

	}
	function changeVendor(mFlag)
	{
		document.headerForm.callPreWelcomePage.value="S";
		if(mFlag == 'Y')
		{

			document.headerForm.target="banner"
			document.headerForm.action="../Misc/ezVendWelcome.jsp";
			document.headerForm.submit();
		}
		else
		{
			if(confirm("Do you want to continue with the selected vendor?"))
			{
				var vendorDetails 	= document.headerForm.Vndr.options[document.headerForm.Vndr.options.selectedIndex].value
				var vendorData		= vendorDetails.split("#")	
				document.headerForm.VENDOR_CODE.value = vendorData[0]
				document.headerForm.VENDOR_NAME.value = vendorData[1]
				//document.headerForm.target="banner"
				document.headerForm.action="../Misc/ezVendWelcome.jsp";
				document.headerForm.submit();
			}
			else
			{
				document.headerForm.Vndr.options[document.headerForm.selVNIndex.value].selected=true;
			}
		}
	}
	/*
	window.onbeforeunload = function() { 
	    window.setTimeout(function () { 
		window.location = 'ezVendIntWelcome.jsp';
	    }, 0); 
	    window.onbeforeunload = null; // necessary to prevent infinite loop, that kills your browser 
	}*/
	// slight update to account for browsers not supporting e.which
	function disableF5(e) { if ((e.which || e.keyCode) == 116) e.preventDefault(); };
	
	/* OR jQuery >= 1.7 */
	$(document).on("keydown", disableF5);
	
	var url = window.location;
        // for sidebar menu entirely but not cover treeview
        $('ul.sidebar-menu a').filter(function() {
             return this.href == url;
        }).parent().addClass('active');

        // for treeview
        $('ul.treeview-menu a').filter(function() {
             return this.href == url;
        }).parentsUntil(".sidebar-menu > .treeview-menu").addClass('active');
	
	
	
	</script>	
  </body>
</html>
  
  <script src="../../../../../EzcLogin/Library/js/bootstrap3-typeahead.min.js"></script>  
  <link rel="stylesheet" href="../../../../../EzcLogin/Library/css/bootstrap_3.3.6.min.css" />
  <script src="../../../../../EzcLogin/Library/js/bootstrap_3.3.5.min.js"></script>
  <script src="../../../../../EzcLogin/Library/js/bootstrap-multiselect.js"></script>
  <link rel="stylesheet" href="../../../../../EzcLogin/Library/css/bootstrap-multiselect.css" />
 

<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),".",FormatDate.DDMMYYYY) %>";	 
</Script>
<!--<Script src="../../Library/JavaScript/Rfq/ezPrePRList1.js?ver=4"></Script>-->
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/ezCheckFormFields.js"></SCRIPT>
<script>
$(document).ready(function(){

 $('#matGrp').multiselect({
   nonSelectedText: 'Select',
   enableFiltering: true,
   maxHeight: 250, 
   enableCaseInsensitiveFiltering: true,
   buttonWidth:'300px',
   includeSelectAllOption:true
 });
 $('#purGrp').multiselect({
  nonSelectedText: 'Select',
  enableFiltering: true,
  maxHeight: 250, 
  enableCaseInsensitiveFiltering: true,
  buttonWidth:'300px',
  includeSelectAllOption:true
 });
 $('#docType').multiselect({
   nonSelectedText: 'Select',
   enableFiltering: true,
   maxHeight: 250, 
   enableCaseInsensitiveFiltering: true,
   buttonWidth:'300px',
   includeSelectAllOption:true
 });
  $('#accCat').multiselect({
    nonSelectedText: 'Select',
    enableFiltering: true,
    maxHeight: 250, 
    enableCaseInsensitiveFiltering: true,
    buttonWidth:'300px',
    includeSelectAllOption:true
 });
 $('#itemCat').multiselect({
   nonSelectedText: 'Select',
   enableFiltering: true,
   maxHeight: 250, 
   enableCaseInsensitiveFiltering: true,
   buttonWidth:'300px',
   includeSelectAllOption:true
 });
 $('#selplant').multiselect({
     nonSelectedText: 'Select',
     enableFiltering: true,
     maxHeight: 250, 
     enableCaseInsensitiveFiltering: true,
     buttonWidth:'300px',
     includeSelectAllOption:true
 });
 
 
  //alert("kk");
  

 
 
 
});



</script>

<script>
function funGetValue()
{
var opts = getSelectedOptions( this.elements['purGrp[]'] );
    
    alert( 'The number of options selected is: ' + opts.length ); //  number of selected options
    
    
}
function funAddMulti(nameVal,headVal)
{
	var fieldVal= eval("document.myForm."+nameVal).value;
	$('iframe').attr("src","../RFQ/ezAddMulti.jsp?nameVal="+nameVal+"&headVal="+headVal+"&fieldVal="+fieldVal);
	$('#woModal').modal({show:true});
}
window.closeModal = function(){
    $('#woModal').modal('hide');
};

$(document).keypress(function(event){
		if (event.keyCode == 13) 
		{
			getPRs();
		}
	});

function compareDates(date1,date2)
{


	compDate1 = new Date(date1);
	compDate2 = new Date(date2);

	if(compDate1 > compDate2)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function checkEmpty(chkVal)
{
	if(chkVal=="" || chkVal==null)
		return "NA";
	else
		return chkVal;

}

function KeySubmit()
{
	if (event.keyCode==13)
		searchForMaterial()
}

function searchForMaterial()
{
	if(document.myForm.SearchMat[0].checked)
		searchMatByNumber();

	if(document.myForm.SearchMat[1].checked)
		searchMatByDesc();
}

function searchMatByNumber()
{
	var matNo	= 	document.myForm.matDescScrh.value;

	if(matNo=="" || matNo=="Enter Search String Here.")
	{
		alert('<%=mat_JS_L%>');
		document.myForm.matDescScrh.focus();
		return;
	}

	var url="ezMtrlSearch.jsp?matCode="+matNo;
	//newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});

}

function searchMatByDesc()
{
	var matDesc = document.myForm.matDescScrh.value;


	if(matDesc=="" || matDesc=="Enter Search String Here.")
	{
		alert('<%=mat_Desc_JS_L%>');
		document.myForm.matDescScrh.focus();
		return;
	}

	var url="ezSearchMaterial.jsp?matDesc="+matDesc;
	//newWindow=window.open(url,"ReportWin","width=700,height=500,left=160,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	$('iframe').attr("src",url);
	$('#woModal').modal({show:true});
}


function getPRs()
{
	//alert("In prepr111...");
	var matCode = document.myForm.matNo.value;
	var fromDate = document.myForm.fromDate.value;
	var toDate = document.myForm.toDate.value;
	var relFromDate = document.myForm.relFromDate.value;
	var relToDate = document.myForm.relToDate.value;

	var requestor = document.myForm.reqSr.value;
	var createdBy = document.myForm.createdBy.value;
	var matGrp = document.myForm.matGrp.value;
	var selplant = document.myForm.selplant.value;
	var purGrp = document.myForm.purGrp.value;
	var docType = document.myForm.docType.value;
	var accCat = document.myForm.accCat.value;
	var itemCat = document.myForm.itemCat.value;
	var mrpCtl = document.myForm.mrpCtl.value;
	var proStat = document.myForm.proStat.value;
	var prLow = document.myForm.prLow.value;
	var prMulti = document.myForm.prMulti.value;
	var matLow = document.myForm.matLow.value;
	var matMulti = document.myForm.matMulti.value;	
	var days = document.myForm.days.value;
	
	if(selplant=="")
	{
			alert('<%=plant_JS_L%>');
			return false;	
	}	
	
	/*if(requestor =="" && createdBy =="" && matGrp =="" && selplant =="" && purGrp =="" && docType =="" && accCat =="" && itemCat =="" &&mrpCtl =="" &&proStat =="" &&prLow ==""&&prMulti ==""&&matLow ==""&&matMulti ==""&&fromDate ==""&&relFromDate ==""&&days =="" )
	{
			alert("Please Enter atleast one search Item");
			return false;
	}*/
	/*if(days=="")
	{
			alert("Please Enter Number of Day(s)");
			return false;	
	}*/

	if(fromDate!="" && toDate!="")
	{
		if(compareDates(fromDate,toDate))
		{
			alert('<%=del_Date_JS_L%>');
			return false;
		}
	}

	if(relFromDate!="" && relToDate!="")
	{
		if(compareDates(relFromDate,relToDate))
		{
			alert('<%=rel_Date_JS_L%>');
			return false;
		}
	}


	buttonsSpan	  = document.getElementById("EzButtonsSpan")
	buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
	if(buttonsSpan!=null)
	{
	     buttonsSpan.style.display		= "none"
	     buttonsMsgSpan.style.display	= "block"
	}

	//alert("before>>>");
	document.myForm.action = "ezListPR.jsp";
	document.myForm.submit();
}

function setEmpty()
{
	if(myForm.matDescScrh.value=="Enter Search String Here.")
		myForm.matDescScrh.value="";
}

function closeIframe()
{
	   $('#woModal').modal('toggle');
}


</script>
