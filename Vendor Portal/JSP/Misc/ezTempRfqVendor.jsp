<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import="ezc.valuemap.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>		
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ include file="ezHeader.jsp"%> 
<%
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	int plantLen   = 0 ;
	try
	{
		plantObj=ezMiscSelect(Session,"SELECT * FROM EZC_PLANTS");
		plantLen   = plantObj.getRowCount();
	}catch(Exception e){}
	ezc.ezparam.ReturnObjFromRetrieve catObj	  =	null;
	int catObjLen   = 0 ;
	try
	{
		catObj=ezMiscSelect(Session,"select * from ezc_value_mapping where MAP_TYPE='CATEGORY'");
		catObjLen   = catObj.getRowCount();
	}catch(Exception e){}
%>
<%
	String tempUserId = "";
	ReturnObjFromRetrieve	valMapRetObj = null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.valuemap.client.EzValueMapManager valMapMgr = new ezc.valuemap.client.EzValueMapManager();
	EziValueMappingParams valueParams =  new EziValueMappingParams();
	
	valueParams.setMapType("TEMP_USER_NR_RANGE");
	
	mainParams.setObject(valueParams);	
	Session.prepareParams(mainParams); 
	
	try{
		ezc.ezcommon.EzLog4j.log("::::::::::::TEMP_USER_NR_RANGE::::::::::","I");
		valMapRetObj = (ReturnObjFromRetrieve)valMapMgr.ezGetValueMapping(mainParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("::::::::::::EXCEPTION IN GETTTING TEMP_USER_NR_RANGE::::::::::"+e,"E");
	}	
	
	if(valMapRetObj!=null && valMapRetObj.getRowCount()>0)
	{
		tempUserId = valMapRetObj.getFieldValueString(0,"VALUE1");
		
		String nextNr = "";
		
		
		try{
			
			nextNr = (Long.parseLong(tempUserId)+1)+"";
			
			mainParams = new ezc.ezparam.EzcParams(true);
			valueParams =  new EziValueMappingParams();
			
			valueParams.setValue1(nextNr);
			valueParams.setMapType(" MAP_TYPE = 'TEMP_USER_NR_RANGE'");

			mainParams.setObject(valueParams);	
			Session.prepareParams(mainParams);

			valMapMgr.ezUpdateValueMapping(mainParams);	
			
		}catch(Exception e){}	
	}	
	
	String purOrgOptStr = "";
	String compCodeOptStr = "";
	String venGrpOptStr = "";
	String deptOptStr = "";
	
	ReturnObjFromRetrieve retQuery	=  null;
	int    QueryCnt	=  0;

	mainParams = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams		= new EziMiscParams();

	//miscParams.setQuery("SELECT * FROM EZC_VALUE_MAPPING WHERE MAP_TYPE IN ('DEPT','COMP_CODE','VEN_GRP','PUR_ORG')");
	miscParams.setQuery("SELECT * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE IN('PUR_ORG','COMP_CODE','VEN_GRP')");

	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{		
	retQuery=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retQuery!=null)
	QueryCnt=retQuery.getRowCount(); 
	for(int i=0;i<QueryCnt;i++)
	{
		String tempMapType = retQuery.getFieldValueString(i,"EMKV_MASTER_TYPE");
		String value1 = retQuery.getFieldValueString(i,"EMKV_KEY");
		String value2 = retQuery.getFieldValueString(i,"EMKV_VALUE");
		//if("DEPT".equals(tempMapType))
			//deptOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'>"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		if("COMP_CODE".equals(tempMapType))
			compCodeOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'>"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		else if("VEN_GRP".equals(tempMapType))
			venGrpOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'>"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		else if("PUR_ORG".equals(tempMapType))
			purOrgOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'>"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
	}
%>
<%
	String loc=request.getParameter("loc");
	String docId=request.getParameter("docId");
	String mob=checkNull(request.getParameter("mob"));
	String name1=checkNull(request.getParameter("name1"));
	String email=checkNull(request.getParameter("email"));
	String state=checkNull(request.getParameter("state"));
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
input[type="text"],select_join option
{
	font-size:14;
	font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
}



</style>
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    

<form method="post"  name="myForm">
<%	
	String display_header = "Vendor Registration > Invite Vendor"; 
	String clickString = "onclick='ezSubmit()'";
%>
<%@ include file="../Misc/ezSubHeader.jsp"%> 	    
<Br>
	<table align='center' class="table table-bordered" style="width:90%"> 			
	<tr>
		<th align="right"  <%=trBGColor%>>User Id<font color="red">*</font></th>
		<Td>
			<%=tempUserId%><Input  type="hidden"   name="userId" value="<%=tempUserId%>">
		</Td>

		<th align="right"  <%=trBGColor%>>Vendor Name <font color="red">*</font></th>
		<Td>
		<Input  type="text"  class="form-control"  name="userName" id="userName" value="<%=name1%>"  style="width:100%"  maxlength="35">
		</Td>
	</tr>
	<tr>	
		<th align="right"  <%=trBGColor%>>Vendor Email <font color="red">*</font></th>
		<Td>
		<input  type="text"   class="form-control" name="eMail" id="eMail" value="<%=email%>"  style="width:100%"  maxlength="240">
		</Td>

		<th align="right"  <%=trBGColor%>>Contact No <font color="red">*</font></th>
		<Td>
		<Input  type="text"  class="form-control"  name="contactNo" id="contactNo" value="<%=mob%>"  style="width:100%"  maxlength="16">
		</Td>
	</tr>
	<!--<tr>	
		<th align="right"  <%=trBGColor%>>Purchase Org <font color="red">*</font></th>
		<Td>
		 <select class="form-control select2" name="purOrg" style="width:100% !important">
		   <option value="" selected>Select Purchase Org</option>
		   <%=purOrgOptStr%>
		 </select>
		</Td>
		<th align="right"  <%=trBGColor%>>Company Code <font color="red">*</font></th>
		<Td>
		<select class="form-control select2" name="compCode" style="width:100% !important">
		  <option value="" selected>Select Company Code</option>
		  <%=compCodeOptStr%>
		</select>
		</Td>		
	 </tr>
	     <tr>	
			<th align="right" <%=trBGColor%>>Account Group <font color="red">*</font></th>
			<Td>
			<select class="form-control select2" name="venGrp" style="width:100% !important">
			  <option value="" selected>Select Account Group </option>
				<%=venGrpOptStr%>
			</select>
			</Td>
			<th align="right"  <%=trBGColor%>>Schema Group <font color="red">*</font></th>
			<Td>
				<select class="form-control select2" name="venType" style="width:100% !important">
				<option value="" >Select Schema </option>
				<option value="IN" selected>Domestic </option>
				<option value="IM" >International </option>
			
			</Td>
	</tr>
	<tr>
		<Th align="right" <%=trBGColor%>>Plant <font color="red">*</font></Th>
		<Td >
			<select name="selPlant" id="selPlant" class="form-control select2" style="width:100% !important"> 
			<option value="" selected>Select Plant </option>
	
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
		<Th align="right" <%=trBGColor%>>Category <font color="red">*</font></Th>
		<Td >
			<select name="selCategory" id="selCategory" class="form-control select2" style="width:100% !important"> 
			<option value="" selected>Select Category </option>
	<%
			for(int j=0;j<catObjLen;j++)
			{
					/*
					if(gv_PlantVect.contains(catObj.getFieldValueString(j,"EP_PLANT").trim()))
					{
					*/
						out.println("<option value='"+catObj.getFieldValueString(j,"VALUE1").trim()+"'>"+catObj.getFieldValueString(j,"VALUE2")+"</option>");
					//}
	
			}
	%>
			</select>
	</Td>
</tr> -->
	
	     <!--<tr>	
		<th align="right"  <%=trBGColor%>>Department</th>
		<Td>
		<select class="form-control" name="dept" style="width:100% !important">
		  <option selected>Select Department </option>
			<%=deptOptStr%>
		</select>
		</Td>
		<th align="right"  <%=trBGColor%>>Vendor PAN</th>
			<Td>
				<Input  type="text"   name="panNo" id="panNo" value=""  style="width:250px"  maxlength="10">
			</Td>		
		</tr> -->
	
</table>


	<!--<table align='center' class="table table-bordered" style="width:70%"> 			
	<tr>	
		<th align="center"  colspan=2 <%=trBGColor%>>Authorizations</th>
	</Tr>
	
	<tr>	
		<td align="center" ><input type='checkbox' name='RFQ' id='RFQ' value=''>&nbsp;&nbsp;RFQ</td>
		<td align="center" ><input type='checkbox' name='VENREG' id='VENREG' value='' checked>&nbsp;&nbsp;Vendor Registration Form</td>
	</Tr>
	
	</table> -->

	<br><br>
	<center>
		<button type="button" class="btn btn-primary" onclick="funSave()">Create Vendor</button>  &nbsp;
	</center>
<input type="hidden" name="loc" id="loc" value="<%=loc%>">
<input type="hidden" name="docId" id="docId" value="<%=docId%>">
<input type="hidden" name="tempUserId" id="tempUserId" value="<%=tempUserId%>">
<input type="hidden" name="state" id="state" value="<%=state%>">
</Form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<!-- jQuery 2.1.4 -->
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../../../EzCommon/Library/jquery.form.js"></script> 
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
<!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
	<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>


<script>
		$( function() {
		        
		         $('.select2').select2()
		          }); 

	function funSave()
	{
		if(document.myForm.userName.value == "")
		{
			alert("Please enter user name");
			return ;
		}
		if(document.myForm.eMail.value == "")
		{
			alert("Please enter email");
			return ;
		}
		if(document.myForm.contactNo.value == "")
		{
			alert("Please enter contact number");
			return ;
		}		

		document.myForm.action = "ezAddTempVendor.jsp";
		document.myForm.submit();
	}
</script>

</Body>
