<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import="ezc.valuemap.params.*,ezc.ezparam.*,ezc.ezmisc.params.*" %>		
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ include file="ezHeader.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%> 
<%
	String tempUserId = request.getParameter("docId");
	
	ezc.ezparam.ReturnObjFromRetrieve tmpVendObj	  =	null;
	int tmpVendObjLen   = 0 ;
	try
	{
		tmpVendObj=ezMiscSelect(Session,"SELECT ECFH_DOC_ID,ECFH_CUST_NAME,EU_EMAIL,EU_CONTACT_NO,ECFH_SALES_ORG,ECFH_EXT1,ECFH_VEN_GRP,ECFH_PLANT,ECFH_VEN_TYPE,ECFH_CATEGORY,ECFH_STATUS,ECFH_REASON FROM EZC_CUSTOMER_FORM_HEADER,EZC_USERS WHERE ECFH_DOC_ID='"+tempUserId+"' AND ECFH_DOC_ID=EU_ID");
		//tmpVendObj=ezMiscSelect(Session,"SELECT ECFH_DOC_ID,ECFH_CUST_NAME,ECFH_SALES_ORG,ECFH_EXT1,ECFH_VEN_GRP,ECFH_PLANT,ECFH_VEN_TYPE,ECFH_CATEGORY,ECFH_STATUS FROM EZC_CUSTOMER_FORM_HEADER WHERE ECFH_DOC_ID='"+tempUserId+"' ");
		tmpVendObjLen   = tmpVendObj.getRowCount();
	}catch(Exception e){}
	
	String docId=request.getParameter("docId");
	String name1=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_CUST_NAME"));
	String email=checkNull(tmpVendObj.getFieldValueString(0,"EU_EMAIL"));
	String mob=checkNull(tmpVendObj.getFieldValueString(0,"EU_CONTACT_NO"));
	String purOrg=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_SALES_ORG"));
	String compCode=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_EXT1"));
	String acctGrp=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_VEN_GRP"));
	String plant=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_PLANT"));
	String schemaGrp=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_VEN_TYPE"));
	String category=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_CATEGORY"));		//ECFH_STATUS
	String status=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_STATUS"));
	String reason=checkNull(tmpVendObj.getFieldValueString(0,"ECFH_REASON"));
	
	ezc.ezcommon.EzLog4j.log(":::::docId::::"+docId,"I");
	ezc.ezcommon.EzLog4j.log(":::::name1::::"+name1,"I");
	ezc.ezcommon.EzLog4j.log(":::::email::::"+email,"I");
	ezc.ezcommon.EzLog4j.log(":::::mob::::"+mob,"I");
	ezc.ezcommon.EzLog4j.log(":::::purOrg::::"+purOrg,"I");
	ezc.ezcommon.EzLog4j.log(":::::compCode::::"+compCode,"I");
	ezc.ezcommon.EzLog4j.log(":::::acctGrp::::"+acctGrp,"I");
	ezc.ezcommon.EzLog4j.log(":::::plant::::"+plant,"I");
	ezc.ezcommon.EzLog4j.log(":::::schemaGrp::::"+schemaGrp,"I");
	ezc.ezcommon.EzLog4j.log(":::::category::::"+category,"I");
	
	//Disable Page
	String disabledFeild="";
	
	if("HOD".equals(userRole))
	{
		disabledFeild="readonly";
	}
	
	//AUTHORIZATIONS
	
	ezc.ezparam.ReturnObjFromRetrieve vendAuthObj	  =	null;
	int authLen   = 0 ;
	String rfqAuth="",rfqAuthChk="";
	String regAuth="",regAuthChk="";
	try
	{
		vendAuthObj=ezMiscSelect(Session,"SELECT * FROM  EZC_USER_DEFAULTS WHERE EUD_USER_ID='"+tempUserId+"' AND EUD_KEY IN ('ALLOW_REG','ALLOW_RFQ')");
		authLen   = vendAuthObj.getRowCount();
	}catch(Exception e){}
	
	for(int i=0;i<authLen;i++)
	{
		String authKey = vendAuthObj.getFieldValueString(i,"EUD_KEY");	
		String authVal = vendAuthObj.getFieldValueString(i,"EUD_VALUE");	
		
		if("ALLOW_RFQ".equals(authKey))
		{
			ezc.ezcommon.EzLog4j.log("authKey>>>"+authKey,"I");
			ezc.ezcommon.EzLog4j.log("authVal>>>"+authVal,"I");
			rfqAuth = authVal;
			if("Y".equals(rfqAuth))
				rfqAuthChk="checked";
			ezc.ezcommon.EzLog4j.log("rfqAuth>>>"+rfqAuth,"I");					
			ezc.ezcommon.EzLog4j.log("rfqAuthChk>>>"+rfqAuthChk,"I");				
		}	
		if("ALLOW_REG".equals(authKey))
		{
			regAuth = authVal;
			ezc.ezcommon.EzLog4j.log("authKey>>>"+authKey,"I");
			ezc.ezcommon.EzLog4j.log("authVal>>>"+authVal,"I");
			if("Y".equals(regAuth))
				regAuthChk="checked";			
		}		
	}
	
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
		
	}catch(Exception e){}
	if(catObj!=null)
	catObjLen   = catObj.getRowCount();
	ezc.ezcommon.EzLog4j.log(":::::catObjLen::::"+catObjLen,"I");
	
	
	String purOrgOptStr = "";
	String compCodeOptStr = "";
	String venGrpOptStr = "";
	String deptOptStr = "";
	
	ReturnObjFromRetrieve retQuery	=  null;
	int    QueryCnt	=  0;

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams		= new EziMiscParams();

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
	
	String selected="";
	for(int i=0;i<QueryCnt;i++)
	{
		String tempMapType = retQuery.getFieldValueString(i,"EMKV_MASTER_TYPE");
		String value1 = retQuery.getFieldValueString(i,"EMKV_KEY");
		String value2 = retQuery.getFieldValueString(i,"EMKV_VALUE");
		selected="";
		if("COMP_CODE".equals(tempMapType))
		{
			
			if(compCode.equals(retQuery.getFieldValueString(i,"EMKV_KEY")))
				selected="selected";	
				
				compCodeOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'"+selected+">"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		}	
		else if("VEN_GRP".equals(tempMapType))
		{
			if(acctGrp.equals(retQuery.getFieldValueString(i,"EMKV_KEY")))
				selected="selected";
				
				venGrpOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'"+selected+">"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		}	
		else if("PUR_ORG".equals(tempMapType))
		{
			if(purOrg.equals(retQuery.getFieldValueString(i,"EMKV_KEY")))
				selected="selected";
		
				purOrgOptStr+= "<option value='"+retQuery.getFieldValueString(i,"EMKV_KEY")+"'"+selected+">"+retQuery.getFieldValueString(i,"EMKV_KEY")+"-"+retQuery.getFieldValueString(i,"EMKV_VALUE")+"</option>";
		}
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
		<th align="right"  <%=trBGColor%>><%=vendTempId_L%><font color="red">*</font></th>
		<Td>
			<Input  type="text" class="form-control"  name="userId" id="userId" value="<%=tempUserId%>">
		</Td>

		<th align="right"  <%=trBGColor%>><%=vendName_L%><font color="red">*</font></th>
		<Td>
		<Input  type="text"  class="form-control"  name="userName" id="userName" value="<%=name1%>"  style="width:100%"  maxlength="35">
		</Td>
	</tr>
	<tr>	
		<th align="right"  <%=trBGColor%>><%=vendEmail_L%><font color="red">*</font></th>
		<Td>
		<input  type="text"   class="form-control" name="eMail" id="eMail" value="<%=email%>"  style="width:100%"  maxlength="240" <%=disabledFeild%>>
		</Td>

		<th align="right"  <%=trBGColor%>><%=vendContact_L%><font color="red">*</font></th>
		<Td>
		<Input  type="text"  class="form-control"  name="contactNo" id="contactNo" value="<%=mob%>"  style="width:100%"  maxlength="16" <%=disabledFeild%>>
		</Td>
	</tr>
	<tr>	
		<th align="right"  <%=trBGColor%>><%=vendPurOrg_L%> <font color="red">*</font></th>
		<Td>
		 <select class="form-control select2" name="purOrg" id="purOrg" style="width:100% !important" <%=disabledFeild%>>
		   <option value="" selected>Select Purchase Org</option>
		   <%=purOrgOptStr%>
		 </select>
		</Td>
		<th align="right"  <%=trBGColor%>><%=vendCompCode_L%> <font color="red">*</font></th>
		<Td>
		<select class="form-control select2" name="compCode" id="compCode" style="width:100% !important" <%=disabledFeild%>>
		  <option value="" selected>Select Company Code</option>
		  <%=compCodeOptStr%>
		</select>
		</Td>		
	 </tr>
	     <tr>	
			<th align="right" <%=trBGColor%>><%=vendAccGrp_L%> <font color="red">*</font></th>
			<Td>
			<select class="form-control select2" name="venGrp" id="venGrp" style="width:100% !important" <%=disabledFeild%>>
			  <option value="" selected>Select Account Group </option>
				<%=venGrpOptStr%>
			</select>
			</Td>
			<th align="right"  <%=trBGColor%>><%=vendSchmGrp_L%><font color="red">*</font></th>
			<Td>
				<select class="form-control select2" name="venType"  id="venType" style="width:100% !important" <%=disabledFeild%>>
				<option value="" >Select Schema </option>
				<option value="IN" <%if("IN".equals(schemaGrp))out.println("selected");%>>Domestic </option>
				<option value="IM" <%if("IM".equals(schemaGrp))out.println("selected");%>>International </option>
			
			</Td>
	</tr>
	<tr>
		<Th align="right" <%=trBGColor%>><%=vendPlant_L%> <font color="red">*</font></Th>
		<Td >
			<select name="selPlant" id="selPlant" class="form-control select2" style="width:100% !important" <%=disabledFeild%>> 
			<option value="">Select Plant </option>
	
	<%
			
			for(int j=0;j<plantLen;j++)
			{
					selected="";
					if(gv_PlantVect.contains(plantObj.getFieldValueString(j,"EP_PLANT").trim()))
					{
						if(plant.equals(plantObj.getFieldValueString(j,"EP_PLANT").trim()))
							selected="selected";
						out.println("<option value='"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"'"+selected+">"+plantObj.getFieldValueString(j,"EP_PLANT").trim()+"->"+plantObj.getFieldValueString(j,"EP_NAME1")+"</option>");
					}
	
			}
	%>
			</select>
	</Td>
		<Th align="right" <%=trBGColor%>><%=vendCategory_L%>  <font color="red">*</font></Th>
		<Td >
			<select name="selCategory" id="selCategory" class="form-control select2" style="width:100% !important" <%=disabledFeild%>> 
			<option value="" selected>Select Category </option>
	<%
			 ezc.ezcommon.EzLog4j.log(":::::before::::"+catObjLen+gv_CategoryVect,"I");
			for(int j=0;j<catObjLen;j++)
			{
				
				selected="";
				//if(gv_CategoryVect.contains(catObj.getFieldValueString(j,"VALUE1").trim()))
				if(gv_CategoryVect.contains("7300#"+catObj.getFieldValueString(j,"VALUE1").trim()))
				{
					ezc.ezcommon.EzLog4j.log(":::::after::::"+catObjLen,"I");
					if(category.equals(catObj.getFieldValueString(j,"VALUE1").trim()))
						selected="selected";
					
					out.println("<option value='"+catObj.getFieldValueString(j,"VALUE1").trim()+"'"+selected+">"+catObj.getFieldValueString(j,"VALUE2")+"</option>");
					
				}
	
			}
	%>
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
<tr>
		<th colspan='1' align="right"  <%=trBGColor%>>Reason<font color="red">*</font></th>
		<Td colspan='3'>
			<!--<div id="divChar">5000</div>-->
			<textarea runat="server" name ='reason' id='reason' style='width:100%' rows=3 cols=73 maxlength="5000" ><%=reason%></textarea>
		</td>		
</tr>
	
</table>

	<table id="table-2" class="table table-bordered">
		
<%	
	if("2".equals(userType))
	{
	ReturnObjFromRetrieve retUploadList = getUploadList(Session,docId,"VNRH"); 
	int retUploadListCnt = 0; 
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();
%>
		<h5 style="text-align:left">
			<%=attchmnt_L%>
		</h5>
		<div class="row">
		  <div class="col-md-12 col-xs-12">
			<!-- general form elements -->
			<div class="box box-default">
				<div class="box-body table-responsive no-padding">
					<div class="box-body">
					       <table id="uploadTable<%=itemId%>" class="table  table-bordered dt-responsive nowrap" >
							<tr <%=trBGColor%>>
								<th width="95%" align='left'><%=file_Name_L%></th>
								<th width="5%"></th>
							</tr>
<%
		if(retUploadListCnt == 0)
		{
%>
			<tr id="noDataStatUpload">
				<td>No files attached</td>
			</tr>
<%
		}
		for(int r=0;r<retUploadListCnt;r++)
		{
%>
			<tr>
				<td align="left" width="95%"><input type="hidden" name="fileItemH" value="<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>"><a href="javascript:downloadFileNew('<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%></a></td>
				<!--<td width="5%"><span onclick="javascript:deleteFile(this,'<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td>-->
				<td width="5%">&nbsp;</td>
				
			</tr>
<%
		}
	}
%>
	</table>



	<table align='center' class="table table-bordered" style="width:90%"> 			
	<tr>	
		<th align="center"  colspan=2 <%=trBGColor%>><%=vendAuth_L%> </th>
	</Tr>
	
	<tr>	
		<td align="center" ><input type='checkbox' name='RFQ' id='RFQ' value='' <%=rfqAuthChk%>>&nbsp;&nbsp;<%=vendRFQ_L%></td>
		<td align="center" ><input type='checkbox' name='VENREG' id='VENREG' value='' <%=regAuthChk%>>&nbsp;&nbsp;<%=vendRegForm_L%></td>
	</Tr>
	
	</table>

	<br><br>
	<center>
		<button type="button" class="btn btn-primary" onclick="history.go(-1)"><%=back_L%></button>  &nbsp;
		<!--<button type="button" class="btn btn-primary" onclick="funUpdate()"><%//=update_L%></button>  &nbsp;-->
<%
	if("NOTINITIATED".equals(status) && "HOD".equals(userRole) )
	{

%>
		<button type="button" class="btn btn-primary" onclick="funApprove()">Approve</button>  &nbsp;
		<button type="button" class="btn btn-primary" onclick="funSendBack()">Send Back</button>  &nbsp;
<%
	}
%>
	
	</center>

<input type="hidden" name="docId" id="docId" value="<%=docId%>">
<input type="hidden" name="tempUserId" id="tempUserId" value="<%=tempUserId%>">

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

 $(document).ready(function() { 
 	var userRole='<%=userRole%>';
 	
 	if(userRole=="HOD"){
 	$('#userId').attr('disabled',true);
 	$('#userName').attr('disabled',true);
	$('#eMail').attr('disabled',true);
	$('#contactNo').attr('disabled',true);
	$('#purOrg').attr('disabled',true);
	$('#compCode').attr('disabled',true);
	$('#venGrp').attr('disabled',true);
	$('#venType').attr('disabled',true);
	$('#selPlant').attr('disabled',true);
	$('#selCategory').attr('disabled',true);
	$('#reason').attr('disabled',true);
	$('#VENREG').attr('disabled',true);
	$('#RFQ').attr('disabled',true);
	//alert("::UserRole:::"+userRole);
 }
 });
 </script>
<script>
		$( function() {
		        
		         $('.select2').select2()
		          }); 

	function funUpdate()
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
		if(document.myForm.compCode.value == "")
		{
			alert("Please select company code");
			return ;
		}
		if(document.myForm.purOrg.value == "")
		{
			alert("Please select purchase org");
			return ;
		}

		if(document.myForm.venGrp.value == "")
		{
			alert("Please select Account group");
			return ;
		}
		if(document.myForm.venType.value == "")
		{
			alert("Please select vendor schema");
			return ;
		}
		if(document.myForm.selPlant.value == "")
		{
			alert("Please select plant");
			return ;
		}
		if(document.myForm.selCategory.value == "")
		{
			alert("Please select category");
			return ;
		}
		
		if(document.getElementById('RFQ').checked)
			document.myForm.RFQ.value = 'Y';
		var rfqAuth = 	document.myForm.RFQ.value;
		//alert("rfqAuth>>>>"+rfqAuth);
		
		if(document.getElementById('VENREG').checked)
			document.myForm.VENREG.value = 'Y';
		var regAuth = 	document.myForm.VENREG.value;		
		//alert("regAuth>>>>"+regAuth);
		
		
		if(rfqAuth == 'Y' || regAuth == 'Y' )
		{
			document.myForm.action = "ezUpdateTempUser.jsp";
			document.myForm.submit();		
		}
		else
		{
			alert("Please select atleast one authorization");
			return ;		
			
		}
	}
	function funApprove()
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
		if(document.myForm.compCode.value == "")
		{
			alert("Please select company code");
			return ;
		}
		if(document.myForm.purOrg.value == "")
		{
			alert("Please select purchase org");
			return ;
		}

		if(document.myForm.venGrp.value == "")
		{
			alert("Please select Account group");
			return ;
		}
		if(document.myForm.venType.value == "")
		{
			alert("Please select vendor schema");
			return ;
		}
		if(document.myForm.selPlant.value == "")
		{
			alert("Please select plant");
			return ;
		}
		if(document.myForm.selCategory.value == "")
		{
			alert("Please select category");
			return ;
		}

		if(document.getElementById('RFQ').checked)
			document.myForm.RFQ.value = 'Y';
		var rfqAuth = 	document.myForm.RFQ.value;
		//alert("rfqAuth>>>>"+rfqAuth);

		if(document.getElementById('VENREG').checked)
			document.myForm.VENREG.value = 'Y';
		var regAuth = 	document.myForm.VENREG.value;		
		//alert("regAuth>>>>"+regAuth);


		if(rfqAuth == 'Y' || regAuth == 'Y' )
		{
			document.myForm.action = "ezVendApprove.jsp";
			document.myForm.submit();		
		}
		else
		{
			alert("Please select atleast one authorization");
			return ;		
					
		}
		
	
	}
	function funSendBack()
	{	
		document.myForm.action = "ezVendASendBack.jsp";
		document.myForm.submit();
	}
	function downloadFileNew(upItemNo,fileName)
	{
		//alert("fileName>>"+fileName);
		var upDocId 	= $('#upDocId').val();
		var upDocType 	= "VNRH";
		//alert("upDocType>>"+upDocType);
		window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
	}
</script>

</Body>
