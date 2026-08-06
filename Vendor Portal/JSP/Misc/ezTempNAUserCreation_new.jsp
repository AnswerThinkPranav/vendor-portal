<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import="ezc.valuemap.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*" %>		
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezCountryHT.jsp"%> 
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ include file="ezHeader.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%> 
<%@ page import ="org.json.*" %>
<%!
	public org.json.JSONArray retToJsonArr(ezc.ezparam.ReturnObjFromRetrieve retInput,String objName)throws Exception
	{
		org.json.JSONArray jsonRetArray = new org.json.JSONArray();
		if(retInput != null)
		{

			org.json.JSONObject jsonRetObj = new org.json.JSONObject();
			 java.text.SimpleDateFormat sdfObj = new java.text.SimpleDateFormat("MM/dd/yyyy");

			for (int i = 0; i < retInput.getRowCount(); i++) {
				org.json.JSONObject jsonSubRetObj = new org.json.JSONObject();

				for (int j = 0; j < retInput.getColumnCount(); j++) {
					try {
						Object obj = retInput.getFieldValue(i, j);
						if(obj != null && obj instanceof java.util.Date) 
							obj = sdfObj.format((java.util.Date)obj);
						jsonSubRetObj.put(retInput.getFieldName(j),obj);
					} catch (Exception ex) {
					}
				}
				jsonRetArray.put(jsonSubRetObj);
			}
			//finalRetObj.put(objName, jsonRetArray);
		}
		return jsonRetArray;
	}

%>
<%
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve usrNameObj	  =	null;
	int plantLen   = 0 ;
	int userNameLen   = 0 ;
	
	try
	{
		plantObj=ezMiscSelect(Session,"SELECT * FROM EZC_PLANTS");
		plantLen   = plantObj.getRowCount();
	}catch(Exception e){}
	try
	{
		usrNameObj=ezMiscSelect(Session,"SELECT ECFH_CUST_NAME  from ezc_customer_form_header order by ECFH_CUST_NAME asc");
		userNameLen   = usrNameObj.getRowCount();
	}catch(Exception e){}
	
	JSONArray jsonRetArray = retToJsonArr(usrNameObj,"JsonRetObjData");
	
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
	
	ezc.ezcommon.EzLog4j.log("GETQUERY KAT"+miscParams.getQuery(),"I");

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
	String selCategory="";
	//out.println("userRole>>>"+userRole);
	
	if("BY".equals(userRole))
		selCategory="ENG_SER";
	else 
		selCategory="RM_PM";	
	
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
		<th align="right"  <%=trBGColor%>><%=vendTempId_L%> <font color="red">*</font></th>
		<Td>
			<%=tempUserId%>
			<Input  type="hidden"   name="userId" value="<%=tempUserId%>">
		</Td>

		<th align="right"  <%=trBGColor%>><%=vendName_L%> <font color="red">*</font></th>
		<Td>
		<!--<Input  type="text"  class="form-control select2 userName"  name="userName" id="userName" value="<%=name1%>" style="width:100%"  maxlength="35">-->
			<!--<select name="userName" id="userName" class="form-control select2" onchange="onUserChange(this)" style="width:100% !important"> 
				
			<option value="" selected>Enter User Name </option>

		<%
				/*for(int j=0;j<userNameLen;j++)
				{
							out.println("<option value='"+usrNameObj.getFieldValueString(j,"ECFH_CUST_NAME").trim()+"'>"+usrNameObj.getFieldValueString(j,"ECFH_CUST_NAME")+"</option>");
				}*/
		%>
			</select>-->
			<input type="text" class="form-control userName" name="userName" id="userName" autocomplete="off" maxlength="100" value="">
			
		</Td>
	</tr>
	<tr>	
		<th align="right"  <%=trBGColor%>><%=vendEmail_L%> <font color="red">*</font></th>
		<Td>
		<input  type="text"   class="form-control" name="eMail" id="eMail" value="<%=email%>"  style="width:100%"  maxlength="240">
		</Td>

		<th align="right"  <%=trBGColor%>><%=vendContact_L%></th>
		<Td>
		<Input  type="text"  class="form-control"  name="contactNo" id="contactNo" value="<%=mob%>"  style="width:100%"  maxlength="15">
		</Td>
	</tr>
	<tr>
		<Th align="right" <%=trBGColor%>><%=vendPlant_L%> <font color="red">*</font></Th>
		<Td >
			<select name="selPlant" id="selPlant" class="form-control select2" onchange="onPlantChg()" style="width:100% !important"> 
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
	<!--</Td>
		<Th align="right" <%=trBGColor%>><%=vendCategory_L%> <font color="red">*</font></Th>
		<Td >
			<select name="selCategory" id="selCategory" class="form-control select2" style="width:100% !important"> 
			<option value="" selected>Select Category </option>
	<%
			for(int j=0;j<catObjLen;j++)
			{
				if(gv_CategoryVectAll.contains(catObj.getFieldValueString(j,"VALUE1").trim()))
				{
						out.println("<option value='"+catObj.getFieldValueString(j,"VALUE1").trim()+"'>"+catObj.getFieldValueString(j,"VALUE2")+"</option>");
				}
	
			}
	%>
			</select>
	</Td> -->
		<th align="right"  <%=trBGColor%>><%=vendCompCode_L%> <font color="red">*</font></th>
		<Td>
				<select class="form-control " name="compCode" id="compCode" style="width:100% !important" readonly>
						<option value="" selected>Select Company Code</option>
						<%=compCodeOptStr%>
				</select>
		</Td>		
	</tr>	
		
	<tr>	
		<th align="right"  <%=trBGColor%>><%=vendPurOrg_L%> <font color="red">*</font></th>  
		<Td>
		 <select class="form-control " name="purOrg" id="purOrg" style="width:100% !important" readonly>
		   <option value="" selected>Select Purchase Org</option>
		   <%=purOrgOptStr%> 
		 </select>
		</Td>
		<th align="right"  <%=trBGColor%>><%=vendSchmGrp_L%> <font color="red">*</font></th>
		<Td>
			<select class="form-control select2" name="venType" style="width:100% !important">
				<option value="" >Select Schema </option>
				<option value="IN" selected>Domestic </option>
				<option value="IM" >International </option>
			</seelct>
		</Td>		

		
	 </tr>
	 <tr>	
		<th colspan='1' align="right" <%=trBGColor%>><%=vendAccGrp_L%> <font color="red">*</font></th>
		<Td colspan='3'>
		<select class="form-control select2" name="venGrp" style="width:100% !important">
		  <option value="" selected>Select Account Group </option>
			<%=venGrpOptStr%>
		</select>
		</Td>		
			
	</tr>

	
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
	     <!--<tr>	
		<th align="right">Country<font color="red">*</font></th>
			<Td>
				<select name="country" id="country" class="form-control select2" style="width:100% !important"> 
					<option value="">Select Country</option>
<%
					Set set = cuntLHM.entrySet(); 
					Iterator i = set.iterator();
					while(i.hasNext()) 
					{ 
						Map.Entry me = (Map.Entry)i.next();
%>
							<option value="<%=me.getKey()%>"><%=me.getValue()%></option>
<%

					}
%>
				</select>
			</Td>
			<th align="right"  <%=trBGColor%>>Department<font color="red">*</font></th>
			<Td>
				<select name="dept" class="form-control select2"  style="width:100% !important">
		  			<option value="">Select Department</option>
					<%=deptOptStr%>
				</select>
			</Td>
		</tr>  
		<tr>
			<th colspan='1' align="right"  <%=trBGColor%>>Reason<font color="red">*</font></th>
			<Td colspan='3'>
				<textarea name = 'reason' id='reason' style='width:100%' rows=3 cols=73 maxlength="35" ></textarea>
			</td>		
		</tr>-->
</table>


	<table align='center' class="table table-bordered" style="width:90%"> 			
	<tr>	
		<th align="center"  colspan=2 <%=trBGColor%>><%=vendAuth_L%> </th>
	</Tr>
	
	<tr>	
		<td align="center" ><input type='checkbox' name='RFQ' id='RFQ' value=''>&nbsp;&nbsp;<%=vendRFQ_L%></td>
		<td align="center" ><input type='checkbox' name='VENREG' id='VENREG' value='' checked>&nbsp;&nbsp;<%=vendRegForm_L%></td>
	</Tr>
	
	</table>

	<br><br>
	<center>
		<button type="button" class="btn btn-primary" onclick="funSave()"><%=vendCreateUser_L%></button>  &nbsp;
	</center>
<input type="hidden" name="loc" id="loc" value="<%=loc%>">
<input type="hidden" name="docId" id="docId" value="<%=docId%>">
<input type="hidden" name="tempUserId" id="tempUserId" value="<%=tempUserId%>">
<input type="hidden" name="state" id="state" value="<%=state%>">
<input type="hidden" name="selCategory" id="selCategory" value="<%=selCategory%>" >
</Form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>

<!--
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>

<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../../../EzCommon/Library/jquery.form.js"></script> 
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>

    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
	<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
-->
<script>
 var chkText = <%=jsonRetArray%>
   	$(".userName").fuzzyComplete(chkText);    
</script>
<script>
		$( function() {
		        
		         $('.select2').select2()
		          }); 

	function funSave()
	{
		if(document.myForm.userName.value == "")
		{
			alert('<%=userName_JS_L%>');
			return ;
		}
		if(document.myForm.eMail.value == "")
		{
			alert('<%=email_JS_L%>');
			return ;
		}
		if(document.myForm.compCode.value == "")
		{
			alert('<%=compCode_JS_L%>');
			return ;
		}
		if(document.myForm.purOrg.value == "")
		{
			alert('<%=purOrg_JS_L%>');
			return ;
		}

		if(document.myForm.venGrp.value == "")
		{
			alert('<%=venGrp_JS_L%>');
			return ;
		}
		if(document.myForm.venType.value == "")
		{
			alert('<%=venSchema_JS_L%>');
			return ;
		}
		if(document.myForm.selPlant.value == "")
		{
			alert('<%=Plant_JS_L%>');
			return ;
		}
		/*
		if(document.myForm.contactNo.value == "")
		{
			alert('<%=ContactNum_JS_L%>');
			return ;
		}
		if(document.myForm.reason.value == "")
		{
			alert('<%=Reason_JS_L%>');
			return ;			
		}
		if(document.myForm.selCategory.value == "")
		{
			alert('<%=Category_JS_L%>');
			return ;
		}*/
		
		if(document.getElementById('RFQ').checked)
			document.myForm.RFQ.value = 'Y';
		var rfqAuth = 	document.myForm.RFQ.value;
		if(document.getElementById('VENREG').checked)
			document.myForm.VENREG.value = 'Y';
		var regAuth = 	document.myForm.VENREG.value;		
		
		var z = 'Y';
		
		if(rfqAuth == 'Y' || regAuth == 'Y' )
		{
			$("#purOrg").removeAttr('disabled');
			$("#compCode").removeAttr('disabled');
			
			document.myForm.action = "ezAddTempUser.jsp";
			document.myForm.submit();		
		}
		else
		{ 
			alert("Please select atleast one authorization");
			return ;		
			
		}
			var selCategory = document.myForm.selCategory.value;
			//alert(":::selCategory:::"+selCategory);

		//document.myForm.action = "ezAddTempUser.jsp";
		//document.myForm.submit();
	}
	
	/*function onUserChange(this)
	{
		//alert("Test");		
		//var userName = document.getElementById("userName").value;		
		alert(this);		
	}*/
	
	function onPlantChg()
	{
		
		var Plant = document.getElementById("selPlant").value;
		//alert("plant11::::"+Plant);
		/*
		$("#purOrg").val(plant).trigger('change');
		$("#purOrg").prop("disabled",true).trigger('change');
		$("#compCode").val(plant).trigger('change');
		$("#compCode").prop("disabled",true).trigger('change');
		*/

		
		$.ajax({
				url: "ezAutoPurOrgCompCode.jsp?plant="+Plant, 
				type: "POST",    
				dataType:"text", 
				asLync: false,
				error: function (response) 
				{ 
				alert(":::::error:::::"+response);
					return false;
				},
				success: function (response) 
				{

					//$("#purOrg").val('4500');
					let responsecheck =response.trim();

					purOrg = (responsecheck).split("##")[0];
					compCode = (responsecheck).split("##")[1];
					PurDesc = (responsecheck).split("##")[2];
					//alert("purOrg:::::"+purOrg+"::compCode::::"+compCode+"::PurDesc::::::"+PurDesc);
					if(purOrg!=""){						
						//$("#purOrg").val(purOrg);
						$("#purOrg").val(purOrg).attr('disabled',true);
						//funAutoSchema(purOrg);
						//funAutoLoadSchema(purOrg);

					}
					else{
						alert("There is no Plant - Purchase Organiztion Mapping");
					}
					if(compCode!=""){						
						//$("#compCode").val(compCode);
						$("#compCode").val(compCode).attr('disabled',true);
					}
					else{
						alert("There is no Plant - Company Code Mapping");
					}



				}
			});
		
	}	
</script>

</Body>
